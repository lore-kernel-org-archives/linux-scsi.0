From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI core: fix leakage of scsi_cmnd's
Date: Thu, 8 Sep 2005 10:56:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509081045230.4503-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:16321 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751380AbVIHO4v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 10:56:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

[This message is completely separate from the concurrent discussion of 
earlier patches, as542-as546; this patch fixes a different problem.]

James:

The SCSI core has a problem with leakage of scsi_cmnd structs.  It occurs
when a request is requeued; the request keeps its associated scsi_cmnd so
that the core doesn't need to assign a new one.  However, the routines
that read the device queue sometimes delete entries without bothering to
free the associated scsi_cmnd.  Among other things, this bug manifests as
error-handler processes remaining alive when a hot-pluggable device is
unplugged in the middle of executing a command.

This patch (as559) fixes the problem by calling scsi_put_command and 
scsi_release_buffers at the appropriate times.  It also reorganizes a 
couple of bits of code, adding a new subroutine to find the scsi_cmnd 
associated with a requeued request.

This addresses Bugzilla entry #5195.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: 2613mm1/drivers/scsi/scsi_lib.c
===================================================================
--- 2613mm1.orig/drivers/scsi/scsi_lib.c
+++ 2613mm1/drivers/scsi/scsi_lib.c
@@ -1103,11 +1103,30 @@ static void scsi_generic_done(struct scs
 	scsi_io_completion(cmd, cmd->result == 0 ? cmd->bufflen : 0, 0);
 }
 
+static struct scsi_cmnd *scsi_cmd_from_req(struct request *req)
+{
+	struct scsi_cmnd *cmd;
+
+	/*
+	 * If this request was requeued, it may already have an associated
+	 * scsi_cmnd.  Find out if this is so and return the cmd.
+	 */
+	cmd = req->special;
+	if ((req->flags & REQ_SPECIAL) && req->special) {
+		struct scsi_request *sreq = req->special;
+
+		if (sreq->sr_magic == SCSI_REQ_MAGIC)
+			cmd = NULL;
+	}
+	return cmd;
+}
+
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct scsi_device *sdev = q->queuedata;
-	struct scsi_cmnd *cmd;
+	struct scsi_cmnd *cmd = scsi_cmd_from_req(req);
 	int specials_only = 0;
+	struct scsi_request *sreq = NULL;
 
 	/*
 	 * Just check to see if the device is online.  If it isn't, we
@@ -1117,6 +1136,8 @@ static int scsi_prep_fn(struct request_q
 	if (unlikely(!scsi_device_online(sdev))) {
 		printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
 		       sdev->host->host_no, sdev->id, sdev->lun);
+		if (cmd)
+			scsi_put_command(cmd);
 		return BLKPREP_KILL;
 	}
 	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
@@ -1127,6 +1148,8 @@ static int scsi_prep_fn(struct request_q
 			 * at all allowed down */
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to dead device\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
+			if (cmd)
+				scsi_put_command(cmd);
 			return BLKPREP_KILL;
 		}
 		/* OK, we only allow special commands (i.e. not
@@ -1142,53 +1165,54 @@ static int scsi_prep_fn(struct request_q
 	 * the remainder of a partially fulfilled request that can 
 	 * come up when there is a medium error.  We have to treat
 	 * these two cases differently.  We differentiate by looking
-	 * at request->cmd, as this tells us the real story.
+	 * at req->special, as this tells us the real story.
 	 */
-	if (req->flags & REQ_SPECIAL && req->special) {
-		struct scsi_request *sreq = req->special;
+	if ((req->flags & REQ_SPECIAL) && req->special) {
+		sreq = req->special;
+		if (sreq->sr_magic != SCSI_REQ_MAGIC)
+			sreq = NULL;
 
-		if (sreq->sr_magic == SCSI_REQ_MAGIC) {
-			cmd = scsi_get_command(sreq->sr_device, GFP_ATOMIC);
-			if (unlikely(!cmd))
-				goto defer;
-			scsi_init_cmd_from_req(cmd, sreq);
-		} else
-			cmd = req->special;
 	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
-
-		if(unlikely(specials_only) && !(req->flags & REQ_SPECIAL)) {
-			if(specials_only == SDEV_QUIESCE ||
+		if (unlikely(specials_only) && !(req->flags & REQ_SPECIAL)) {
+			if (specials_only == SDEV_QUIESCE ||
 					specials_only == SDEV_BLOCK)
 				return BLKPREP_DEFER;
 			
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to device being removed\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
+			if (cmd)
+				scsi_put_command(cmd);
 			return BLKPREP_KILL;
 		}
-			
-			
-		/*
-		 * Now try and find a command block that we can use.
-		 */
-		if (!req->special) {
-			cmd = scsi_get_command(sdev, GFP_ATOMIC);
-			if (unlikely(!cmd))
-				goto defer;
-		} else
-			cmd = req->special;
-		
-		/* pull a tag out of the request if we have one */
-		cmd->tag = req->tag;
+
 	} else {
 		blk_dump_rq_flags(req, "SCSI bad req");
+		if (cmd)		/* Paranoia */
+			scsi_put_command(cmd);
 		return BLKPREP_KILL;
 	}
+			
+	/*
+	 * Now try and find a command block that we can use.
+	 */
+	if (!cmd) {
+		cmd = scsi_get_command(sdev, GFP_ATOMIC);
+		if (unlikely(!cmd))
+			goto defer;
+
+		if (sreq)
+			scsi_init_cmd_from_req(cmd, sreq);
+		else {
+			/* pull a tag out of the request if we have one */
+			cmd->tag = req->tag;
+		}
 	
-	/* note the overloading of req->special.  When the tag
-	 * is active it always means cmd.  If the tag goes
-	 * back for re-queueing, it may be reset */
-	req->special = cmd;
-	cmd->request = req;
+		/* note the overloading of req->special.  When the tag
+		 * is active it always means cmd.  If the tag goes
+		 * back for re-queueing, it may be reset */
+		req->special = cmd;
+		cmd->request = req;
+	}
 	
 	/*
 	 * FIXME: drop the lock here because the functions below
@@ -1337,16 +1361,21 @@ static inline int scsi_host_queue_ready(
 /*
  * Kill requests for a dead device
  */
-static void scsi_kill_requests(request_queue_t *q)
+static void scsi_kill_request(struct request *req, struct request_queue *q)
 {
-	struct request *req;
+	struct scsi_cmnd *cmd = scsi_cmd_from_req(req);
+
+	blkdev_dequeue_request(req);
+	req->flags |= REQ_QUIET;
+	while (end_that_request_first(req, 0, req->nr_sectors))
+		;
+	end_that_request_last(req);
 
-	while ((req = elv_next_request(q)) != NULL) {
-		blkdev_dequeue_request(req);
-		req->flags |= REQ_QUIET;
-		while (end_that_request_first(req, 0, req->nr_sectors))
-			;
-		end_that_request_last(req);
+	if (cmd) {
+		spin_unlock(q->queue_lock);
+		scsi_release_buffers(cmd);
+		scsi_put_command(cmd);
+		spin_lock(q->queue_lock);
 	}
 }
 
@@ -1370,7 +1399,8 @@ static void scsi_request_fn(struct reque
 
 	if (!sdev) {
 		printk("scsi: killing requests for dead queue\n");
-		scsi_kill_requests(q);
+		while ((req = elv_next_request(q)) != NULL)
+			scsi_kill_request(req, q);
 		return;
 	}
 
@@ -1397,11 +1427,7 @@ static void scsi_request_fn(struct reque
 		if (unlikely(!scsi_device_online(sdev))) {
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
-			blkdev_dequeue_request(req);
-			req->flags |= REQ_QUIET;
-			while (end_that_request_first(req, 0, req->nr_sectors))
-				;
-			end_that_request_last(req);
+			scsi_kill_request(req, q);
 			continue;
 		}
 

