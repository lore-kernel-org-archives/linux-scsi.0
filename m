From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: handle HARDWARE_ERROR sense correctly
Date: Thu, 04 Dec 2008 15:02:53 -0600
Message-ID: <1228424573.3363.54.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0812041546260.2180-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58830 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbYLDVCw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 16:02:52 -0500
In-Reply-To: <Pine.LNX.4.44L0.0812041546260.2180-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2008-12-04 at 15:49 -0500, Alan Stern wrote:
> This patch (as1183) fixes a bug in scsi_check_sense().  The routine is
> documented as returning one of SUCCESS, FAILED, or NEEDS_RETRY.  But
> in the HARDWARE_ERROR case it can return ADD_TO_MLQUEUE.  And since it
> does this without bothering to increment the retry count, it can lead
> to an infinite retry loop.
> 
> The fix is to return NEEDS_RETRY instead.  Then the caller,
> scsi_decide_disposition(), will do the right thing.

OK, but why?

The current behaviour is to retry the error until the command timeout
expires, which, I think is what was needed by the annoying arrays that
have retryable hardware errors.

What bug would this patch fix?  Because I can see it causing problems
with the arrays that originally reported this problem.

James


