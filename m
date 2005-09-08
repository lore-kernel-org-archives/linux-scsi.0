From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI core: fix leakage of scsi_cmnd's
Date: Thu, 08 Sep 2005 10:56:29 -0500
Message-ID: <1126194989.4845.24.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509081045230.4503-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:20892 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964807AbVIHP4c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 11:56:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509081045230.4503-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

> The SCSI core has a problem with leakage of scsi_cmnd structs.  It occurs
> when a request is requeued; the request keeps its associated scsi_cmnd so
> that the core doesn't need to assign a new one.  However, the routines
> that read the device queue sometimes delete entries without bothering to
> free the associated scsi_cmnd.  Among other things, this bug manifests as
> error-handler processes remaining alive when a hot-pluggable device is
> unplugged in the middle of executing a command.
> 
> This patch (as559) fixes the problem by calling scsi_put_command and 
> scsi_release_buffers at the appropriate times.  It also reorganizes a 
> couple of bits of code, adding a new subroutine to find the scsi_cmnd 
> associated with a requeued request.

Nate Dailey also had a patch for this, a reply to which is incomplete
still in my drafts folder.

The bottom line is that I don't think any modifications to the prep_fn()
are necessary.  It's guarded by REQ_DONTPREP, so is never called again
if we actually manage to prepare a command fully.  The returns from it
are:

BLKPREP_DEFER:  Requeue the command for re-preparation (no resources
should be allocated)

BLKPREP_KILL: destroy the command (no resources should be allocated)

BLKPREP_OK: Command is prepared, resources are allocated, REQ_DONTPREP
is set to prevent any additional prep_fn() call.

So in the DEFER or KILL case, all you need to worry about is resources
you may have allocated in the current prep_fn() invocation.  It seems to
me that we do release these correctly, unless I'm missing something?

The second problem is a bug (also spotted by Nate).  However, what I
think we should be doing in this case is calling __scsi_done with
DID_NO_CONNECT which should clean up correctly and also send the error
indications back up the stack to the correct sources (that's what we do
in scsi_dispatch_cmd() for this problem).

James


