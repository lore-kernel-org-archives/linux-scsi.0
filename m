From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problems with the block-layer timeouts
Date: Mon, 3 Nov 2008 12:07:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811031204490.2194-100000@iolanthe.rowland.org>
References: <490F2953.30709@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56090 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755345AbYKCRHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2008 12:07:41 -0500
In-Reply-To: <490F2953.30709@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Tue, 4 Nov 2008, Tejun Heo wrote:

> Hello, Alan Stern!  :-)
> 
> Alan Stern wrote:
> > Even a "peek and fetch" interface might not be best, at least as far as
> > timer issues are concerned.  Ideally, the timer shouldn't be started
> > until the SCSI midlayer knows that the request has successfully been
> > sent to the lower-level driver.
> > 
> > Therefore the best approach would be to EXPORT blk_add_timer().  It 
> > should be called at the end of scsi_dispatch_cmd(), when the return 
> > value from the queuecommand method is known to be 0.
> > 
> > With something like this, Mike's fix to end_that_request_last() 
> > wouldn't be needed, since blkdev_dequeue_request() wouldn't 
> > automatically start the timer.  It seems silly to start the timer when 
> > you know you're just going to stop it immediately afterwards.
> 
> Block layer currently doesn't know when a request is actually being
> issued.  For timeout, blk_add_timer() can be exported but I think that
> only aggravate the already highly fragmented block layer interface
> (different users use it differently to the point of scary chaos).  For
> minor example, block tracing considers elv_next_request() as the command
> issue point which isn't quite true for SCSI and many other drivers.  For
> that too, we can export the tracing interface but I don't think that's
> the right direction.  More stuff are scheduled to be moved to block
> layer and exporting more and more implementation details to block layer
> users will have hard time scaling.
> 
> I'm trying to convert all drivers to use the same command issue model -
> elv_next_request() -> blkdev_dequeue_request() on actual issue ->
> blk_end_request().  I have first draft of the conversion patchset but
> it's gonna take me a few more days to review and test what I can as
> several drivers (mostly legacy ones) are a bit tricky.
> 
> For the time being, SCSI layer is the only block layer timeout user and
> completion w/o dequeuing is only for error cases in SCSI, so the
> inefficiency there shouldn't matter too much.

In fact, I have changed my mind.  Starting the timer after the command
has been sent to the low-level driver would mean that the command might
finish before the timer was started!

So never mind.  I did confirm at least that your patch together with 
Mike's fixed the problem I encountered last week.

I have a couple of small fixes for the block timer routines.  They'll 
get posted separately later on.

Alan Stern

