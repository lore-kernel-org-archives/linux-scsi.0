From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 09/13] scsi: in scsi_prep_fn(), remove bogus comments & clean up
Date: Thu, 31 Mar 2005 18:08:35 +0900 (KST)
Message-ID: <20050331090647.B562915C@htj.dyndns.org>
References: <20050331090647.FEDC3964@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.200]:26932 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261257AbVCaJIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 04:08:41 -0500
Received: by wproxy.gmail.com with SMTP id 68so491813wra
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 01:08:40 -0800 (PST)
In-Reply-To: <20050331090647.FEDC3964@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

09_scsi_prep_fn_comment_update.patch

	Remove bogus comments from scsi_prep_fn() and clean up a bit.
	While at it, remove leading and tailing empty comment lines
	for one or two liners to make the code more concise.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 scsi_lib.c |   35 ++++++++---------------------------
 1 files changed, 8 insertions(+), 27 deletions(-)

Index: scsi-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi_lib.c	2005-03-31 18:06:22.000000000 +0900
+++ scsi-export/drivers/scsi/scsi_lib.c	2005-03-31 18:06:22.000000000 +0900
@@ -1051,14 +1051,11 @@ static int scsi_prep_fn(struct request_q
 	}
 
 	/*
-	 * Find the actual device driver associated with this command.
 	 * The SPECIAL requests are things like character device or
 	 * ioctls, which did not originate from ll_rw_blk.  Note that
 	 * the special field is also used to indicate the cmd for
 	 * the remainder of a partially fulfilled request that can 
-	 * come up when there is a medium error.  We have to treat
-	 * these two cases differently.  We differentiate by looking
-	 * at request->cmd, as this tells us the real story.
+	 * come up when there is a medium error.
 	 */
 	if (req->flags & REQ_SPECIAL) {
 		struct scsi_request *sreq = req->special;
@@ -1099,26 +1096,16 @@ static int scsi_prep_fn(struct request_q
 		blk_dump_rq_flags(req, "SCSI bad req");
 		return BLKPREP_KILL;
 	}
-	
-	/* note the overloading of req->special.  When the tag
-	 * is active it always means cmd.  If the tag goes
-	 * back for re-queueing, it may be reset */
+
 	req->special = cmd;
 	cmd->request = req;
-	
-	/*
-	 * FIXME: drop the lock here because the functions below
-	 * expect to be called without the queue lock held.  Also,
-	 * previously, we dequeued the request before dropping the
-	 * lock.  We hope REQ_STARTED prevents anything untoward from
-	 * happening now.
-	 */
+
 	if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
 		struct scsi_driver *drv;
 		int ret;
 
 		/*
-		 * This will do a couple of things:
+		 * drv->init_command will do a couple of things:
 		 *  1) Fill in the actual SCSI command.
 		 *  2) Fill in any other upper-level specific fields
 		 * (timeout).
@@ -1130,19 +1117,15 @@ static int scsi_prep_fn(struct request_q
 		 * request to be rejected immediately.
 		 */
 
-		/* 
-		 * This sets up the scatter-gather table (allocating if
-		 * required).
-		 */
+		/* This sets up the scatter-gather table (allocating if
+		 * required). */
 		ret = scsi_init_io(cmd);
 		if (ret == BLKPREP_DEFER)
 			goto defer;
 		else if (ret == BLKPREP_KILL)
 			goto kill;
 
-		/*
-		 * Initialize the actual SCSI command for this request.
-		 */
+		/* Initialize the actual SCSI command for this request. */
 		drv = *(struct scsi_driver **)req->rq_disk->private_data;
 		if (unlikely(!drv->init_command(cmd)))
 			goto kill;
@@ -1159,9 +1142,7 @@ static int scsi_prep_fn(struct request_q
 		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
 			(cmd->device->lun << 5 & 0xe0);
 
-	/*
-	 * The request is now prepped, no need to come back here
-	 */
+	/* The request is now prepped, no need to come back here. */
 	req->flags |= REQ_DONTPREP;
 	return BLKPREP_OK;
 

