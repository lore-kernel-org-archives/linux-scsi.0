From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Problems with the block-layer timeouts
Date: Mon, 3 Nov 2008 09:52:48 +0100
Message-ID: <20081103085247.GO31673@kernel.dk>
References: <Pine.LNX.4.44L0.0811011214470.21703-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:40234 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbYKCIyI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2008 03:54:08 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811011214470.21703-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Sat, Nov 01 2008, Alan Stern wrote:
> James and Jens:
> 
> I spent most of the day yesterday debugging some tricky problems in the
> new block-layer timeout scheme.  Clearly it is in need of more work.

It is.

> A major reason for these problems was that there doesn't seem to be a 
> clear a idea of when the timeout period should begin.  In 
> blk_add_timer() a comment says:
> 
>  *    Each request has its own timer, and as it is added to the queue, we
>  *    set up the timer.
> 
> On the other hand, elv_next_request() says:
> 
> 			 * We are now handing the request to the hardware,
> 			 * add the timeout handler
> 
> (Note that this comment is wrong for an additional reason.  
> elv_next_request() doesn't hand the request to the hardware; it hands 
> the request to a driver.  What the driver chooses to do with the 
> request is its own affair.)
> 
> So when should the timeout begin?  The most logical time is when the 
> driver does send the request to the hardware.  Of course, the block 
> core has no way to know when that happens, so a suitable proxy might be 
> when the request is removed from the block queue.  (On the other hand, 
> are there drivers which don't bother to dequeue a request until it has 
> completed?)  Either way, both the comments above and the actual code 
> should be changed.
> 
> 
> The real source of the problems I encountered is in the SCSI midlayer.  
> scsi_request_fn() can call elv_next_request() long before it is ready
> to begin executing the request.  In particular, it does so before 
> checking scsi_dev_queue_ready().  So if the lower-level driver can 
> handle up to N simultaneous requests, the midlayer will call 
> elv_next_request() N+1 times.  The last request has to wait until one 
> of the first N completes.  Surely this waiting period doesn't deserve 
> to be counted as part of the last request's timeout.
> 
> In my case N was 1, and request #1 ended up being requeued.  Requeuing
> restarts the timer; as a result, the timer for request #2 expired
> before request #1's second incarnation timed out.  And this was before
> request #2 had even begun!
> 
> That's not so terribly bad in itself.  However the scsi_times_out()  
> routine is completely unprepared to handle timeouts for requests that
> haven't yet been dispatched to the LLD.  Or, for that matter, requests
> which have been returned by the LLD but were requeued and have not yet
> been sent back down.
> 
> So what happened was that the midlayer tried to abort a request which
> hadn't started yet.  Or, depending on the exact timing, it found itself
> being asked to abort two requests when only one was running, so it gave
> up and did nothing.  One way leads to processes hanging, the other way
> leads to a system crash.
> 
> How should this be fixed?  It would help to call scsi_dev_queue_ready()  
> before elv_next_request(), but that's not sufficient.  
> scsi_times_out() needs to recognize that a timeout for a non-running
> request can be handled by directly returning BLK_EH_HANDLED.  Right?

We already discussed this issue with Tejun. There's a hack in my tree
now that just moves the activate call to dequeue time, which works ok
for SCSI (but wont work for eg IDE). The real fix is to have a peek and
fetch interface for retrieving requests. We've actually wanted that for
some time, since the current 'peek and mark active' approach doesn't
even work well now since it'll both force pushing of requests to the
dispatch list and mark it unmergeable, since the block layer does not
whether the driver has started handling the request or not.

So, in summary, a short term fix will be merged soon and a longer term
fix will be right after.

> While I'm on the subject, there are a few related items that could be 
> improved.  In my tests, I was generating I/O requests simply by doing
> 
> 	dd if=/dev/sda ...
> 
> I don't know where the timeouts for these requests are determined, but
> they were set to 60 seconds.  That seems much too long.

Fully agreed, as Mike mentioned this actually looks like a dumb udev
rule that didn't have any effect until this generic timeout work. For
normal IO, something in the 10 second range is a lot more appropriate.

> In blk_del_timer(), there's no reason to test q->rq_timed_out_fn.  If 
> the method pointer is NULL then req->deadline would be 0 anyway.  In 
> addition, req->deadline should be set to 0 and the end of the routine, 
> just in case req gets requeued.
> 
> In blk_add_timer(), the line
> 
> 	expiry = round_jiffies(req->deadline);
> 
> is not optimal.  round_jiffies() will sometimes round a value _down_ to
> the nearest second.  But blk_rq_timed_out_timer() tests whether
> req->deadline is in the past -- and if the deadline was rounded down
> then this won't be true the first time through.  You wind up getting an
> unnecessary timer interrupt.  Instead there should be a
> round_jiffies_up() utility routine, and it should be used in both
> blk_add_timer() and blk_rq_timed_out_timer().

Very good point, we do indeed want a round_jiffies_up() for this!

-- 
Jens Axboe

