From: Brian Kysela <brian.kysela@gmail.com>
Subject: Re: [BUG] usb-storage: Error in queuecommand: us->srb = ffff88006a338480
Date: Thu, 6 Nov 2008 19:54:38 -0500
Message-ID: <20081107005438.GA26198@ezra.hsd1.tn.comcast.net>
References: <20081106095757.2c2fcdc3.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0811061435070.23473-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:34261 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYKGAyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 19:54:44 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811061435070.23473-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On 2008-11-06 at 14:36 -0500, Alan Stern wrote: 
> On Thu, 6 Nov 2008, Andrew Morton wrote:
> 
> > > The error message:
> > > 
> > > > [  152.701070] usb-storage: Error in queuecommand: us->srb = ffff88007dfd0680
> > > 
> > > means that the SCSI layer has told usb-storage to start a new command 
> > > before the old one completed.  This could happen, for example, if the 
> > > SCSI layer had gotten confused and tried to cancel a command that 
> > > wasn't running -- then it would think usb-storage was idle when in fact 
> > > it was still busy.  (This was the failure mechanism resulting from the 
> > > timeout changes.)
> > > 
> > 
> > OK, thanks.  I'll cc linux-scsi, but I have this-wont-be-getting-fixed
> > feelings on this one :(
> > 
> > I wonder what's special about Brian's setup.
> 
> Brian, if you can use usbmon to monitor what happens during the file 
> copy and subsequent error, it might provide a clue.  Instructions are 
> in the kernel source file Documentation/usb/usbmon.txt.

Since it's a large file, I have posted the content of usbmon here:

http://www.kysela.org/pub/1.mon.out

I also got another kernel bug and system freeze on that copy, after the
copy process hung, when I pulled the drive out:

[ Linux version 2.6.28-rc2-00385-g721d5df ]

[  698.265008] Code: a8 00 00 00 00 00 00 00 48 c7 86 b0 00 00 00 00 00 00 00 4c 89 c6 48 89 38 e8 a7 0c 01 00 31 c0 41 5b c3 48 8b 16 48 39 f2 75 04 <0f> 0b eb fe 48 83 be 98 00 00 00 00 74 04 0f 0b eb fe 48 8b 46 
[  698.264858] ------------[ cut here ]------------
[  698.264865] kernel BUG at /home/brian/projects/linux-2.6/block/elevator.c:841!
[  698.264870] invalid opcode: 0000 [#1] PREEMPT SMP 
[  698.264879] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-7/1-7:1.0/host2/target2:0:0/2:0:0:0/block/sdb/size
[  698.264885] CPU 0 
[  698.264965] Process scsi_eh_2 (pid: 1537, threadinfo ffff880066830000, task ffff880069b26580)
[  698.264969] Stack:
[  698.264972]  ffffffff80441fb5 ffff880069afe368 ffff880069afe178 ffff88007e3623b0
[  698.264981]  ffff88007e362040 ffff88007e362040 0000000000000286 ffff880069a33148
[  698.264992]  ffff880066831ed0 ffff880066831ee0 ffffffff80373aa9 ffff88007e362040
[  698.265004] Call Trace:
[  698.265007]  [<ffffffff80441fb5>] ? scsi_request_fn+0x141/0x3ec
[  698.265008]  [<ffffffff80373aa9>] ? blk_invoke_request_fn+0x33/0x60
[  698.265008]  [<ffffffff80373f6b>] ? blk_run_queue+0x21/0x34
[  698.265008]  [<ffffffff80440e73>] ? scsi_queue_insert+0x97/0x9e
[  698.265008]  [<ffffffff8043ec8d>] ? scsi_eh_flush_done_q+0x5d/0x93
[  698.265008]  [<ffffffff8043f9df>] ? scsi_error_handler+0x18c/0x2e7
[  698.265008]  [<ffffffff8043f853>] ? scsi_error_handler+0x0/0x2e7
[  698.265008]  [<ffffffff8024a6b6>] ? kthread+0x47/0x75
[  698.265008]  [<ffffffff805835df>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  698.265008]  [<ffffffff8020c5c9>] ? child_rip+0xa/0x11
[  698.265008]  [<ffffffff8020bab8>] ? restore_args+0x0/0x30
[  698.265008]  [<ffffffff8024a64a>] ? kthreadd+0x16e/0x193
[  698.265008]  [<ffffffff8024a66f>] ? kthread+0x0/0x75
[  698.265008]  [<ffffffff8020c5bf>] ? child_rip+0x0/0x11
[  698.265008] Code: a8 00 00 00 00 00 00 00 48 c7 86 b0 00 00 00 00 00 00 00 4c 89 c6 48 89 38 e8 a7 0c 01 00 31 c0 41 5b c3 48 8b 16 48 39 f2 75 04 <0f> 0b eb fe 48 83 be 98 00 00 00 00 74 04 0f 0b eb fe 48 8b 46 
[  698.265008] RIP  [<ffffffff8037236c>] elv_dequeue_request+0x8/0x45
[  698.265008]  RSP <ffff880066831dc8>
[  698.265008] ---[ end trace 60e1b9808d5b9649 ]---


Brian
