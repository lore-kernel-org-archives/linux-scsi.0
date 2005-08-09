From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Tue, 9 Aug 2005 10:40:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0508091023090.4643-100000@iolanthe.rowland.org>
References: <42F7F1CD.3080600@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:27549 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964796AbVHIOkZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 10:40:25 -0400
In-Reply-To: <42F7F1CD.3080600@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>

On Tue, 9 Aug 2005, Stefan Richter wrote:

> Alan Stern wrote:
> > The current code does use
> > down_*_trylock, and it does check the device state for
> > disconnect-in-progress.  If things don't work out, it sleeps
> > for a short while and then tries again.
> 
> I think the error handler should rather give SUCCESS back to
> scsi if it knows the device was or is being disconnected.
> 
> After that, commands would be enqueued again, and these
> commands would be immediately done() with an appropriate
> result code.
> 
> IMO the error handler should return SUCCESS rather than
> FAILED because, if the device is diconnected, there is
> simply nothing left to do that could advance recovery
> from error.

Your premise is correct: Nothing can advance error recovery once the 
device is gone.  It doesn't follow that the error handler should return 
SUCCESS.  In fact it doesn't matter what the handler returns, since no 
further action will succeed.  When the handler returns FAILED, the device 
is set off-line and no further commands are issued at all.

>  Retries (in the error handler) will not help
> with error recovery either. Or do you retry in hope that
> the device might be reconnected and then a device reset
> should happen?

Are you referring to the "try again" part I wrote above?  That has nothing
to do with disconnects.  If the handler realizes a disconnect has
occurred, it immediately returns FAILED.  But if there hasn't been a
disconnect and the handler was still unable to acquire the semaphore, then
it waits a short while, checks for disconnect, and does the down_*_trylock 
again.


> A more general thought: It appears from the example you
> explained that maybe the USB highlevel carries too much of a
> burden to watch out for concurrency. Tasks like to mutually
> exclude port resets and disconnects --- which seems to me to
> be a task unspecific to highlevel protocols, correct me if
> I'm wrong --- might be better moved into the USB core. Then
> the highlevel would have to worry less about how exactly to
> avoid races and deadlocks, only about _what_ to do if there
> is a conflict. (The kind of conflict should be indicated by
> the core by means of return values or status flags or the
> like.)
> 
> But I am of course speaking without any knowledge about USB
> and Linux' USB stack.

I'm not sure I understand your comment.  Are you saying that the job I 
outlined above -- trying to acquire the device semaphore while checking 
for possible disconnects -- should be part of the USB core instead of 
the high-level USB device driver?

It already is in the core.  If you're interested, read 
drivers/usb/core/usb.c:usb_lock_device_for_reset().

Alan Stern

