From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Thu, 4 Dec 2008 15:39:42 -0800
Message-ID: <20081204233942.GA4950@linux.vnet.ibm.com>
References: <1228424573.3363.54.camel@localhost.localdomain> <Pine.LNX.4.44L0.0812041629320.2577-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:52494 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYLDXjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 18:39:44 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mB4Ncx0q008883
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2008 16:38:59 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB4NdhYU208454
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2008 16:39:43 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB4Ndgfn000402
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2008 16:39:43 -0700
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0812041629320.2577-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 4 Dec 2008, James Bottomley wrote:
> 
> > On Thu, 2008-12-04 at 15:49 -0500, Alan Stern wrote:
> > > This patch (as1183) fixes a bug in scsi_check_sense().  The routine is
> > > documented as returning one of SUCCESS, FAILED, or NEEDS_RETRY.  But
> > > in the HARDWARE_ERROR case it can return ADD_TO_MLQUEUE.  And since it
> > > does this without bothering to increment the retry count, it can lead
> > > to an infinite retry loop.
> > > 
> > > The fix is to return NEEDS_RETRY instead.  Then the caller,
> > > scsi_decide_disposition(), will do the right thing.
> > 
> > OK, but why?
> > 
> > The current behaviour is to retry the error until the command timeout
> > expires, which, I think is what was needed by the annoying arrays that
> > have retryable hardware errors.
> > 

Yes there are some arrays that need this behavior. The two users: 
usb disks and the devinfo entries with BLIST_RETRY_HWERROR appear to have
two different expected behaviors.

> > What bug would this patch fix?  Because I can see it causing problems
> > with the arrays that originally reported this problem.
> 
> You're right and I was wrong.  It only _appeared_ to be an infinite
> retry loop because there were 6 iterations allowed and each iteration
> had a 60-second timeout.  So I retract the patch submission.
> 
> Waiting six minutes for a command to complete is a bit ridiculous,
> though -- especially when the user program generating that command
> decides to reissue it a few times.  Can we do anything to expedite the
> failure?

A short term hack until retry policy is aligned and updated would be to
use the sdev_bflags to differentiate the usb case from use of the
BLIST_RETRY_HWERROR bflag.

> For example, does it really make sense for scsi_softirq_done
> to multiply cmd->allowed by rq->timeout?  After all, if a command
> aborts with a timeout instead of failing outright, what point is there
> in retrying it?  The proper approach would have been to use a longer 
> timeout initially.
> 

The wait_for is used for more than retries of timeouts.

I had thought it might be a good idea to expose the wait_for value and
then users could control the wait_for behavior if needed by using a udev
rule to set it near the IO timeout value if so required.

> By the way, is there any reason to keep scmd->retries now?  If commands
> are going to be retried until they timeout, why bother to count the
> retries? 

Previously I had submitted some patches on scsi mid retry with a short text
on current retry policy (this cover mid retry policy vs
scsi_io_completion, which should be unified).

http://marc.info/?l=linux-scsi&m=122210133628085&w=2

I will try to refresh my patches with a updated policy document and also
align that with the changes to scsi_io_completion posted prior to
re-submit.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
