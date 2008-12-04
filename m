From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Thu, 4 Dec 2008 16:45:41 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812041629320.2577-100000@iolanthe.rowland.org>
References: <1228424573.3363.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35873 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755404AbYLDVpn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 16:45:43 -0500
In-Reply-To: <1228424573.3363.54.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 4 Dec 2008, James Bottomley wrote:

> On Thu, 2008-12-04 at 15:49 -0500, Alan Stern wrote:
> > This patch (as1183) fixes a bug in scsi_check_sense().  The routine is
> > documented as returning one of SUCCESS, FAILED, or NEEDS_RETRY.  But
> > in the HARDWARE_ERROR case it can return ADD_TO_MLQUEUE.  And since it
> > does this without bothering to increment the retry count, it can lead
> > to an infinite retry loop.
> > 
> > The fix is to return NEEDS_RETRY instead.  Then the caller,
> > scsi_decide_disposition(), will do the right thing.
> 
> OK, but why?
> 
> The current behaviour is to retry the error until the command timeout
> expires, which, I think is what was needed by the annoying arrays that
> have retryable hardware errors.
> 
> What bug would this patch fix?  Because I can see it causing problems
> with the arrays that originally reported this problem.

You're right and I was wrong.  It only _appeared_ to be an infinite
retry loop because there were 6 iterations allowed and each iteration
had a 60-second timeout.  So I retract the patch submission.

Waiting six minutes for a command to complete is a bit ridiculous,
though -- especially when the user program generating that command
decides to reissue it a few times.  Can we do anything to expedite the
failure?  For example, does it really make sense for scsi_softirq_done
to multiply cmd->allowed by rq->timeout?  After all, if a command
aborts with a timeout instead of failing outright, what point is there
in retrying it?  The proper approach would have been to use a longer 
timeout initially.

By the way, is there any reason to keep scmd->retries now?  If commands
are going to be retried until they timeout, why bother to count the
retries?

Alan Stern

