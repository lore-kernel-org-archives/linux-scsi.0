From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] scsi: reintroduce scsi_driver.init_command
Date: Mon, 31 Mar 2014 12:45:15 +0200
Message-ID: <20140331104515.GA17822@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:32892 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbaCaKpS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Mar 2014 06:45:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

> The above call would free the cmnd->cmnd and set it to null. If then
> scsi_io_completion was going to do some error processing it looks like
> it could try to access the scsi_cmnd->cmnd field.
> 
> With the current code that would not be a problem because the blk unprep
> callback is not called until the block layer does its request cleanup in
> blk_finish_request which as you know is after
> scsi_io_completion/scsi_end_request is done with the cmnd.

This incremental patches fixes the issue, and makes sure the uninit calls are
nicely paired like the rest of the I/O completion routines after patch 2:


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 48c5c77..8e79612 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -490,8 +490,6 @@ static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 	struct request *req = cmd->request;
 	unsigned long flags;
 
-	scsi_uninit_command(cmd);
-
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_unprep_request(req);
 	req->special = NULL;
@@ -941,6 +939,7 @@ requeue:
 		/* Unprep the request and put it back at the head of the queue.
 		 * A new command will be prepared and issued.
 		 */
+		scsi_uninit_command(cmd);
 		scsi_release_buffers(cmd);
 		scsi_requeue_command(q, cmd);
 		break;
@@ -956,6 +955,7 @@ requeue:
 	return;
 
 next_command:
+	scsi_uninit_command(cmd);
 	scsi_release_buffers(cmd);
 	scsi_next_command(cmd);
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d95c4fd..d99cb3f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1652,8 +1652,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	unsigned char op = SCpnt->cmnd[0];
 	unsigned char unmap = SCpnt->cmnd[1] & 8;
 
-	sd_uninit_command(SCpnt);
-
 	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME) {
 		if (!result) {
 			good_bytes = blk_rq_bytes(req);
