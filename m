From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Fri, 05 Dec 2008 09:45:50 -0600
Message-ID: <1228491950.3488.2.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0812041546260.2180-100000@iolanthe.rowland.org>
	 <1228424573.3363.54.camel@localhost.localdomain>
	 <alpine.LNX.2.00.0812051631520.6358@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37967 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754917AbYLEPpr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 10:45:47 -0500
In-Reply-To: <alpine.LNX.2.00.0812051631520.6358@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2008-12-05 at 16:41 +0200, Kai Makisara wrote:
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
> So, a tape command returning (non-recoverable) HARDWARE_ERROR is retried 
> until the timeout (default 3.8 hours if the command happens to use the 
> long timout)? And is the result returned to the upper level timeout 
> instead of sense data? Does not sound good.

No.  This is abnormal behaviour and it's conditioned on a flag in device
info.  The standards say that HARDWARE_ERROR is an immediate failure ...
we just have some stupid arrays (won't name names) that violate the
standard and the option was either to give the user spurious I/O errors
or allow retry.

> And another thing is that retrying an error that is not clearly retryable 
> "outside" retry counting does not sound good.

It's not by standard HARDWARE_ERROR is never retryable, so we don't in
the usual case.

> > What bug would this patch fix?  Because I can see it causing problems
> > with the arrays that originally reported this problem.
> > 
> Is a quirk needed?

BLIST_RETRY_HWERROR

James


