From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Tue, 16 Dec 2008 13:14:36 -0600
Message-ID: <1229454876.3193.19.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0812161007210.2396-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47671 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbYLPTOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 14:14:42 -0500
In-Reply-To: <Pine.LNX.4.44L0.0812161007210.2396-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2008-12-16 at 10:27 -0500, Alan Stern wrote:
> Your policy discussion needs to be expanded.  And it needs to apply
> to 
> scsi_io_completion() as well as scsi_decide_disposition().
> 
> As I see it, the set of possible retry actions is as follows:
> 
>      1: Don't retry at all.  This is appropriate for certain kinds
>         of errors (such as LBA out of range); you know that they will
>         never succeed no matter how many times you try them.
> 
>      2: Keep on retrying until the request times out.  This is
>         appropriate in only a few circumstances (like the tape arrays
>         James mentioned earlier).
> 
>      3: Retry a few times, generally with a short delay between 
>         attempts, and then give up.  I favor a total of 3 attempts
>         but the current code tends to use 6 -- okay, fine.
> 
> What's needed is a clear classification of errors into these three 
> cases; that's what your policy document tries to do.  However the 
> implementation of case (3) in particular needs to be fixed, since the 
> code does not limit the number of retries correctly.

It would be nice ... unfortunately, errors tend to migrate around the
categories because of empirical results, so such a document could never
be definitive.

As a rule of thumb:  errors which produced an action in the device which
errors but is retryable count down the retries (things like parity/crc
errors on the bus).  Things which would produce no benefit retrying
(like Medium errors) get failed immediately and things which indicate
transient resource issues either in the device (QUEUE_FULL) or the host
(DID_REQUEUE) get retried upto the timeout limit with a suitable backoff
(mostly we refuse to issue more commands until one returns).

> By the way, there seems to be some confusion over how to handle
> HARDWARE ERROR (SK = 4).  The spec says "nonrecoverable".  This does
> not mean non-retryable!

> "Nonrecoverable" means that the hardware was unable to recover from
> the 
> error.  But it still might be a transient error, and it might go away 
> if the command was tried again.  In fact, the spec specifically 
> mentions "parity error" as a possible cause; certainly a parity error 
> might go away the next time the command is issued.

Really, no ... most array and disk vendors have specifically requested
that we not retry either medium or hardware errors (with the exception
of those we have the flag for).  The reason is that by the time the
sense is returned, the device has been retrying on its own for quite a
while.  If we also retry, we trigger a delay in reporting the error to
the user.

> So the whole idea of the retry_hwerr flag is bogus; hardware errors
> should always be retried.  Or perhaps only the name is bogus, since
> the
> flag really indicates that the command should be tried over and over
> again without pause until it succeeds or the request times out
> (whereas
> normally hardware errors should be retried only a few times).

It doesn't actually; the MLQUEUE return blocks the device from further
issue until a command returns (or, if empty issue queue, until I/O
pressure causes a block unplug 3 times).

James


