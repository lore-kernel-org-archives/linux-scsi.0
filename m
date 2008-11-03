From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problems with the block-layer timeouts
Date: Mon, 3 Nov 2008 10:59:08 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811031051210.2454-100000@iolanthe.rowland.org>
References: <20081103085247.GO31673@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51392 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755228AbYKCP7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2008 10:59:10 -0500
In-Reply-To: <20081103085247.GO31673@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

Hi, Tejun!  I ran across the same bug as you, but about a day later.

On Mon, 3 Nov 2008, Jens Axboe wrote:

> > So when should the timeout begin?  The most logical time is when the 
> > driver does send the request to the hardware.  Of course, the block 
> > core has no way to know when that happens, so a suitable proxy might be 
> > when the request is removed from the block queue.  (On the other hand, 
> > are there drivers which don't bother to dequeue a request until it has 
> > completed?)  Either way, both the comments above and the actual code 
> > should be changed.

> We already discussed this issue with Tejun. There's a hack in my tree
> now that just moves the activate call to dequeue time, which works ok
> for SCSI (but wont work for eg IDE). The real fix is to have a peek and
> fetch interface for retrieving requests. We've actually wanted that for
> some time, since the current 'peek and mark active' approach doesn't
> even work well now since it'll both force pushing of requests to the
> dispatch list and mark it unmergeable, since the block layer does not
> whether the driver has started handling the request or not.
> 
> So, in summary, a short term fix will be merged soon and a longer term
> fix will be right after.

Even a "peek and fetch" interface might not be best, at least as far as
timer issues are concerned.  Ideally, the timer shouldn't be started
until the SCSI midlayer knows that the request has successfully been
sent to the lower-level driver.

Therefore the best approach would be to EXPORT blk_add_timer().  It 
should be called at the end of scsi_dispatch_cmd(), when the return 
value from the queuecommand method is known to be 0.

With something like this, Mike's fix to end_that_request_last() 
wouldn't be needed, since blkdev_dequeue_request() wouldn't 
automatically start the timer.  It seems silly to start the timer when 
you know you're just going to stop it immediately afterwards.

Alan Stern

