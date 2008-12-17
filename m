From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Wed, 17 Dec 2008 10:09:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812170946030.2510-100000@iolanthe.rowland.org>
References: <1229464183.3193.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60788 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751325AbYLQPJQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2008 10:09:16 -0500
In-Reply-To: <1229464183.3193.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 16 Dec 2008, James Bottomley wrote:

> > It would be wonderful if Mike or someone else would implement this
> > scheme.  The necessary changes shouldn't be very extensive.
> > 
> > (And I still think the wait_for logic in scsi_softirq_done() is wrong; 
> > rq->timeout shouldn't be multiplied by cmd->allowed.)
> 
> It's the logical retry timeout ... if a command fails and times out it
> gets retried, if it continues to time out, retries*timeout is the max
> before it fails.

Yes, certainly -- that's what the current code does.  And it's wrong.

rq->timeout should be the overall timeout for the request.  No matter
how many commands get prepped and issued, no matter how many times the 
request gets pushed back on the queue, if the request isn't finished
by then it should expire.

If I submit a request with a timeout of 60 seconds, then I want it to
be aborted if it hasn't finished within 60 seconds after the time it
starts.  I don't want to wait 360 seconds just because the SCSI
midlayer decides that it has to issue 6 separate commands to carry out
my request.


> > > It doesn't actually; the MLQUEUE return blocks the device from further
> > > issue until a command returns (or, if empty issue queue, until I/O
> > > pressure causes a block unplug 3 times).
> > 
> > Okay, I misunderstood how that works.  Still, the code bypasses the 
> > normal retry pathways, leaving it vulnerable to these sorts of 
> > problems. 
> 
> It does?  How?  decide_disposition() goes straigh into the expiry check.

Consider the various pathways there are for retries:

	scsi_softirq_done -> scsi_decide_disposition which returns
	NEEDS_RETRY -> scsi_queue_insert

	scsi_softirq_done -> scsi_decide_disposition which returns
	ADD_TO_MLQUEUE -> scsi_queue_insert

	scsi_io_completion -> scsi_end_request -> scsi_requeue_command
	-> blk_requeue_request

	scsi_io_completion decides on ACTION_REPREP ->
	scsi_requeue_command -> blk_requeue_request

	scsi_io_completion decides on ACTION_RETRY -> scsi_queue_insert

	scsi_io_completion decides on ACTION_DELAYED_RETRY ->
	scsi_queue_insert

6 different pathways for retries!  And exactly how consistent are they 
about deciding when there have been too many retries or the request 
should expire?  Not very.

> >  So why put the retry_hwerr test in check_sense()?  Why not 
> > put it in scsi_io_completion() instead, so that retries can be limited 
> > appropriately?
> 
> because check_sense goes into decide disposition which gets the timeout
> test applied on MLQUEUE return.

This merely reinforces my point that there are too many different ways 
to retry commands, with inconsistent timeout checks.


> > BTW, what happens if the issue queue is empty and there is no I/O
> > pressure?  Then the command wouldn't be retried at all, it would just
> > time out.  That doesn't seem like what you want.
> 
> I/O pressure is proportional to the size of the request queue.  By
> definition, a requeue means at least 1 outstnading request and thus some
> pressure.

But you mentioned above that it takes 3 unplug events before the
command is retried.  If that command is the single outstanding request,
will it ever be retried?  How many block unplug events do you get from
a single request?

Alan Stern

