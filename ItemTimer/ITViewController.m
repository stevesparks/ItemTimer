//
//  ITViewController.m
//  ItemTimer
//
//  Created by Steve Sparks on 11/12/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "ITViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ITViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) NSTimer *countdownTimer;
@property (strong, nonatomic) NSTimer *labelUpdateTimer;
@property (strong, nonatomic) AVAudioPlayer *trombonePlayer;
@property (strong, nonatomic) AVAudioPlayer *dingPlayer;
@property (nonatomic) NSTimeInterval countdownTime;
@end

@implementation ITViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_countdownTime = 45.0;

	NSString *fileName = [[NSBundle mainBundle] pathForResource:@"sadtrombone" ofType:@"wav"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fileName];
    _trombonePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    _trombonePlayer.volume = 1;
	[_trombonePlayer prepareToPlay];

	fileName = [[NSBundle mainBundle] pathForResource:@"ding" ofType:@"wav"];
    url = [[NSURL alloc] initFileURLWithPath:fileName];
    _dingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    _dingPlayer.volume = 1;
	[_dingPlayer prepareToPlay];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	_labelUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(labelUpdateTimerFired:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[_labelUpdateTimer invalidate];
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
	[_countdownTimer invalidate];
	_countdownTimer = nil;
	_timerLabel.text = @"Ready";
	_timerLabel.textColor = [UIColor blackColor];
}

- (IBAction)bigRedButtonPressed:(id)sender {
	_timerLabel.text = @"";
	_timerLabel.textColor = [UIColor blackColor];

	[_dingPlayer play];
	if(_countdownTimer) {
		[_countdownTimer invalidate];
		_countdownTimer = nil;
	}

	_countdownTimer = [NSTimer scheduledTimerWithTimeInterval:_countdownTime target:self selector:@selector(countdownTimerFired:) userInfo:nil repeats:NO];
}


- (void)countdownTimerFired:(NSTimer *)timer {
	_timerLabel.text = @"FAIL!!";
	_timerLabel.textColor = [UIColor redColor];
	[_trombonePlayer play];
	_countdownTimer = nil;
}

- (void)labelUpdateTimerFired:(NSTimer *)timer {
	if(_countdownTimer) {
		NSTimeInterval t = [_countdownTimer.fireDate timeIntervalSinceNow];
		_timerLabel.text = [NSString stringWithFormat:@"%.1f", t];
	}
}

@end
