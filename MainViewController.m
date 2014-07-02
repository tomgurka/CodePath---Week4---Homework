//
//  MainViewController.m
//  Week4
//
//  Created by Tom Gurka on 6/26/14.
//  Copyright (c) 2014 tom. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

//Views
@property (weak, nonatomic) IBOutlet UIView *containerView;

//Original Image
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

//New Image
@property (nonatomic, strong) UIImageView * createdImageView;

//Head Panner
- (IBAction)onHeadPan:(UIPanGestureRecognizer *)sender;

//Container Panner
- (IBAction)onViewPan:(UIPanGestureRecognizer *)sender;

//Container Center
@property (assign,nonatomic) CGPoint originalCenter;

//Pincher
@property (strong,nonatomic) UIPinchGestureRecognizer *pinchGesture;


@end

@implementation MainViewController

{
    //Container Center Y
    float centerY;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        centerY = 0;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Remember the original center mark
    self.originalCenter = CGPointMake(self.containerView.center.x, self.containerView.center.y);

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Head in container

//Head Pan from container
- (IBAction)onHeadPan:(UIPanGestureRecognizer *)sender {
    
    UIImageView * originalImageView = (UIImageView *)sender.view;
    
    //Set CG Points
    CGPoint location = [sender locationInView:self.view];
    CGPoint translation = [sender translationInView:self.view];
    
    //Track Translation
    NSLog(@"Location (%f, %f)   Translation (%f, %f)", location.x, location.y, translation.x, translation.y);
    
    //Began
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        self.createdImageView = [[UIImageView alloc] init];
        self.createdImageView.image = originalImageView.image;
        //self.createdImageView.backgroundColor = [UIColor redColor];
        self.createdImageView.frame = CGRectMake(location.x,location.y,originalImageView.frame.size.width *5, originalImageView.frame.size.height *5);
        
        //Add The pincher!
        
        [self.createdImageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(stickerScale:)]];
        
        NSLog(@"scaling Addded ..");
    
        
        [self.view addSubview:self.createdImageView];

    }
    //Changed
    else if (sender.state == UIGestureRecognizerStateChanged){
        
//        self.createdImageView.center = CGPointMake(location.x + translation.x, location.y + translation.y);
        
      self.createdImageView.center = CGPointMake(location.x, location.y);

//        sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
        //[containerHeadPan setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    //Ended
    else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Over");
    }
}


//Container

//Container Pan
- (IBAction)onViewPan:(UIPanGestureRecognizer *)viewPanner {
    
    //Set CG Points
    
    CGPoint offset = [viewPanner translationInView:self.view];
    
    //Began
    if (viewPanner.state == UIGestureRecognizerStateBegan) {
         NSLog(@"%f", self.containerView.center.y);
        centerY = self.containerView.center.y;
    }
    
    
    //Changed
    else if (viewPanner.state == UIGestureRecognizerStateChanged) {
        
        if (self.containerView.center.y == 519) {
            self.containerView.center = CGPointMake(self.containerView.center.x, 519);
        //self.containerView.center = CGPointMake(self.containerView.center.x, centerY + offset.y * .1);
        } else {
            self.containerView.center = CGPointMake(self.containerView.center.x, centerY + offset.y);
        }
        
    }
    
    //Ended
    else if (viewPanner.state == UIGestureRecognizerStateEnded) {
        
        
        [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:30 options:0 animations:^{
            
            if (self.containerView.center.y < 570) {
                self.containerView.center = CGPointMake(self.containerView.center.x, 519);
            } else {
                self.containerView.center = CGPointMake(self.containerView.center.x, self.originalCenter.y);
            }
        } completion:nil];
        
    }
}

- (void)stickerScale:(UIPinchGestureRecognizer *)pinchGesture {
    NSLog(@"pinching sticker");
    
    // use the scale of the pinchGesture
    CGFloat scale = pinchGesture.scale;
    
    
    if(pinchGesture.state == UIGestureRecognizerStateChanged) {
        
        pinchGesture.view.transform = CGAffineTransformMakeScale(scale, scale);
        
        
    } if (pinchGesture.state == UIGestureRecognizerStateEnded) {
        
    }
    
}


@end
