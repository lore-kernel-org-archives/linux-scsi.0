From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Tue, 16 Dec 2008 14:56:59 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812161429270.6238-100000@iolanthe.rowland.org>
References: <1229454876.3193.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34931 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754622AbYLPT5C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 14:57:02 -0500
In-Reply-To: <1229454876.3193.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 16 Dec 2008, James Bottomley wrote:

> It would be nice ... unfortunately, errors tend to migrate around the
> categories because of empirical results, so such a document could never
> be definitive.
> 
> As a rule of thumb:  errors which produced an action in the device which
> errors but is retryable count down the retries (things like parity/crc
> errors on the bus).  Things which would produce no benefit retrying
> (like Medium errors) get failed immediately and things which indicate
> transient resource issues either in the device (QUEUE_FULL) or the host
> (DID_REQUEUE) get retried upto the timeout limit with a suitable backoff
> (mostly we refuse to issue more commands until one returns).

It would be wonderful if Mike or someone else would implement this
scheme.  The necessary changes shouldn't be very extensive.

(And I still think the wait_for logic in scsi_softirq_done() is wrong; 
rq->timeout shouldn't be multiplied by cmd->allowed.)


> > So the whole idea of the retry_hwerr flag is bogus; hardware errors
> > should always be retried.  Or perhaps only the name is bogus, since
> > the
> > flag really indicates that the command should be tried over and over
> > again without pause until it succeeds or the request times out
> > (whereas
> > normally hardware errors should be retried only a few times).
> 
> It doesn't actually; the MLQUEUE return blocks the device from further
> issue until a command returns (or, if empty issue queue, until I/O
> pressure causes a block unplug 3 times).

Okay, I misunderstood how that works.  Still, the code bypasses the 
normal retry pathways, leaving it vulnerable to these sorts of 
problems.  So why put the retry_hwerr test in check_sense()?  Why not 
put it in scsi_io_completion() instead, so that retries can be limited 
appropriately?

BTW, what happens if the issue queue is empty and there is no I/O
pressure?  Then the command wouldn't be retried at all, it would just
time out.  That doesn't seem like what you want.

Alan Stern

