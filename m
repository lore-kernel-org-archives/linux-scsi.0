From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI core: fix leakage of scsi_cmnd's
Date: Thu, 08 Sep 2005 12:13:01 -0500
Message-ID: <1126199581.4845.49.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509081210160.4607-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:6557 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964948AbVIHRNF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 13:13:05 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509081210160.4607-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Dailey, Nate" <Nate.Dailey@stratus.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2005-09-08 at 12:44 -0400, Alan Stern wrote:
> You _are_ missing something: scsi_requeue_command turns off the
> REQ_DONTPREP flag before calling blk_requeue_request.  So requeued
> requests do indeed get re-prepped.  This is needed for allocating
> scatter-gather lists and so on; the original ones get deallocated the
> first time the command finishes, so new ones are needed when the command
> is requeued.

Sigh, I might have guessed we'd have a leak somewhere ...

Is not a better way to fix this actually to have the
scsi_requeue_command put the command and reset req->special to NULL?
That way the command gets reprepared as well and the prep fn assumptions
should be fully valid.  This would also correct what looks like a bug in
the command transformation routines (The ones that convert ten byte
commands to six byte ones if we get an illegal request response) ...
they look to be assuming that scsi_requeue_command() will actually
reissue the correct command instead of simply reusing the existing one.

> > The second problem is a bug (also spotted by Nate).  However, what I
> > think we should be doing in this case is calling __scsi_done with
> > DID_NO_CONNECT which should clean up correctly and also send the error
> > indications back up the stack to the correct sources (that's what we do
> > in scsi_dispatch_cmd() for this problem).
> 
> Is there some reason for not doing this same sort of thing from within
> scsi_prep_fn when rejecting a request?  Obviously most of the cleanup
> won't be needed, but you still want to send the error indications back to
> the correct sources.  It seems that prep_fn and request_fn should be
> consistent in the way they handle problems.

No real reason except that in the prep_fn() you often don't have a
command to call __scsi_done() on.  Both methods are fully valid and
(with the all commands go via bios merger) supply the indications at all
the correct stack levels.

James


