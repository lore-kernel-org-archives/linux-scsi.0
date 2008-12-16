From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Tue, 16 Dec 2008 10:27:48 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812161007210.2396-100000@iolanthe.rowland.org>
References: <20081204233942.GA4950@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57398 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753613AbYLPP1t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 10:27:49 -0500
In-Reply-To: <20081204233942.GA4950@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 4 Dec 2008, Mike Anderson wrote:

> Previously I had submitted some patches on scsi mid retry with a short text
> on current retry policy (this cover mid retry policy vs
> scsi_io_completion, which should be unified).
> 
> http://marc.info/?l=linux-scsi&m=122210133628085&w=2
> 
> I will try to refresh my patches with a updated policy document and also
> align that with the changes to scsi_io_completion posted prior to
> re-submit.

Your policy discussion needs to be expanded.  And it needs to apply to 
scsi_io_completion() as well as scsi_decide_disposition().

As I see it, the set of possible retry actions is as follows:

     1: Don't retry at all.  This is appropriate for certain kinds
	of errors (such as LBA out of range); you know that they will
	never succeed no matter how many times you try them.

     2: Keep on retrying until the request times out.  This is
	appropriate in only a few circumstances (like the tape arrays
	James mentioned earlier).

     3: Retry a few times, generally with a short delay between 
	attempts, and then give up.  I favor a total of 3 attempts
	but the current code tends to use 6 -- okay, fine.

What's needed is a clear classification of errors into these three 
cases; that's what your policy document tries to do.  However the 
implementation of case (3) in particular needs to be fixed, since the 
code does not limit the number of retries correctly.


By the way, there seems to be some confusion over how to handle
HARDWARE ERROR (SK = 4).  The spec says "nonrecoverable".  This does
not mean non-retryable!

"Nonrecoverable" means that the hardware was unable to recover from the 
error.  But it still might be a transient error, and it might go away 
if the command was tried again.  In fact, the spec specifically 
mentions "parity error" as a possible cause; certainly a parity error 
might go away the next time the command is issued.

So the whole idea of the retry_hwerr flag is bogus; hardware errors
should always be retried.  Or perhaps only the name is bogus, since the
flag really indicates that the command should be tried over and over
again without pause until it succeeds or the request times out (whereas
normally hardware errors should be retried only a few times).

Alan Stern

