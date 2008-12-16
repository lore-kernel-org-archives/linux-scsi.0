From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Tue, 16 Dec 2008 15:49:43 -0600
Message-ID: <1229464183.3193.44.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0812161429270.6238-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49053 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbYLPXU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 18:20:29 -0500
In-Reply-To: <Pine.LNX.4.44L0.0812161429270.6238-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2008-12-16 at 14:56 -0500, Alan Stern wrote:
> On Tue, 16 Dec 2008, James Bottomley wrote:
> 
> > It would be nice ... unfortunately, errors tend to migrate around the
> > categories because of empirical results, so such a document could never
> > be definitive.
> > 
> > As a rule of thumb:  errors which produced an action in the device which
> > errors but is retryable count down the retries (things like parity/crc
> > errors on the bus).  Things which would produce no benefit retrying
> > (like Medium errors) get failed immediately and things which indicate
> > transient resource issues either in the device (QUEUE_FULL) or the host
> > (DID_REQUEUE) get retried upto the timeout limit with a suitable backoff
> > (mostly we refuse to issue more commands until one returns).
> 
> It would be wonderful if Mike or someone else would implement this
> scheme.  The necessary changes shouldn't be very extensive.
> 
> (And I still think the wait_for logic in scsi_softirq_done() is wrong; 
> rq->timeout shouldn't be multiplied by cmd->allowed.)

It's the logical retry timeout ... if a command fails and times out it
gets retried, if it continues to time out, retries*timeout is the max
before it fails.

> > > So the whole idea of the retry_hwerr flag is bogus; hardware errors
> > > should always be retried.  Or perhaps only the name is bogus, since
> > > the
> > > flag really indicates that the command should be tried over and over
> > > again without pause until it succeeds or the request times out
> > > (whereas
> > > normally hardware errors should be retried only a few times).
> > 
> > It doesn't actually; the MLQUEUE return blocks the device from further
> > issue until a command returns (or, if empty issue queue, until I/O
> > pressure causes a block unplug 3 times).
> 
> Okay, I misunderstood how that works.  Still, the code bypasses the 
> normal retry pathways, leaving it vulnerable to these sorts of 
> problems. 

It does?  How?  decide_disposition() goes straigh into the expiry check.

>  So why put the retry_hwerr test in check_sense()?  Why not 
> put it in scsi_io_completion() instead, so that retries can be limited 
> appropriately?

because check_sense goes into decide disposition which gets the timeout
test applied on MLQUEUE return.

> BTW, what happens if the issue queue is empty and there is no I/O
> pressure?  Then the command wouldn't be retried at all, it would just
> time out.  That doesn't seem like what you want.

I/O pressure is proportional to the size of the request queue.  By
definition, a requeue means at least 1 outstnading request and thus some
pressure.

James


