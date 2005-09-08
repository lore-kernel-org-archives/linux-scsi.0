From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI core: fix leakage of scsi_cmnd's
Date: Thu, 8 Sep 2005 12:44:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509081210160.4607-100000@iolanthe.rowland.org>
References: <1126194989.4845.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:5519 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964898AbVIHQo2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 12:44:28 -0400
In-Reply-To: <1126194989.4845.24.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Dailey, Nate" <Nate.Dailey@stratus.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 8 Sep 2005, James Bottomley wrote:

> > The SCSI core has a problem with leakage of scsi_cmnd structs.  It occurs
> > when a request is requeued; the request keeps its associated scsi_cmnd so
> > that the core doesn't need to assign a new one.  However, the routines
> > that read the device queue sometimes delete entries without bothering to
> > free the associated scsi_cmnd.  Among other things, this bug manifests as
> > error-handler processes remaining alive when a hot-pluggable device is
> > unplugged in the middle of executing a command.
> > 
> > This patch (as559) fixes the problem by calling scsi_put_command and 
> > scsi_release_buffers at the appropriate times.  It also reorganizes a 
> > couple of bits of code, adding a new subroutine to find the scsi_cmnd 
> > associated with a requeued request.
> 
> Nate Dailey also had a patch for this, a reply to which is incomplete
> still in my drafts folder.

CC'ed to Nate.  Thanks for pointing out his patch.  Mine does much the 
same thing as his, with a few additions: call scsi_release_buffers when 
deleting a request from scsi_request_fn, and centralize the code to 
find the scsi_cmnd instead of repeating it several times.

> The bottom line is that I don't think any modifications to the prep_fn()
> are necessary.  It's guarded by REQ_DONTPREP, so is never called again
> if we actually manage to prepare a command fully.  The returns from it
> are:
> 
> BLKPREP_DEFER:  Requeue the command for re-preparation (no resources
> should be allocated)
> 
> BLKPREP_KILL: destroy the command (no resources should be allocated)
> 
> BLKPREP_OK: Command is prepared, resources are allocated, REQ_DONTPREP
> is set to prevent any additional prep_fn() call.
> 
> So in the DEFER or KILL case, all you need to worry about is resources
> you may have allocated in the current prep_fn() invocation.  It seems to
> me that we do release these correctly, unless I'm missing something?

You _are_ missing something: scsi_requeue_command turns off the
REQ_DONTPREP flag before calling blk_requeue_request.  So requeued
requests do indeed get re-prepped.  This is needed for allocating
scatter-gather lists and so on; the original ones get deallocated the
first time the command finishes, so new ones are needed when the command
is requeued.

> The second problem is a bug (also spotted by Nate).  However, what I
> think we should be doing in this case is calling __scsi_done with
> DID_NO_CONNECT which should clean up correctly and also send the error
> indications back up the stack to the correct sources (that's what we do
> in scsi_dispatch_cmd() for this problem).

Is there some reason for not doing this same sort of thing from within
scsi_prep_fn when rejecting a request?  Obviously most of the cleanup
won't be needed, but you still want to send the error indications back to
the correct sources.  It seems that prep_fn and request_fn should be
consistent in the way they handle problems.

Alan Stern

