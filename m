From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Fri, 5 Dec 2008 16:41:02 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0812051631520.6358@kai.makisara.local>
References: <Pine.LNX.4.44L0.0812041546260.2180-100000@iolanthe.rowland.org> <1228424573.3363.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:45020 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYLEOlJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:41:09 -0500
In-Reply-To: <1228424573.3363.54.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

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
So, a tape command returning (non-recoverable) HARDWARE_ERROR is retried 
until the timeout (default 3.8 hours if the command happens to use the 
long timout)? And is the result returned to the upper level timeout 
instead of sense data? Does not sound good.

And another thing is that retrying an error that is not clearly retryable 
"outside" retry counting does not sound good.

> What bug would this patch fix?  Because I can see it causing problems
> with the arrays that originally reported this problem.
> 
Is a quirk needed?

Kai
