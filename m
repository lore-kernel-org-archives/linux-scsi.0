From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] untangle scsi_prep_fn
Date: Sat, 4 Nov 2006 20:10:55 +0100
Message-ID: <20061104191055.GB23477@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:51395 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1753619AbWKDTK6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Nov 2006 14:10:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

I wanted to add some BUG checks to scsi_prep_fn to make sure no one
sends us a non-sg command, but this function is a horrible mess.

So I decided to detangle the function and document what the valid
cases are.  While doing that I found that REQ_TYPE_SPECIAL commands
aren't used by the SCSI layer anymore and we can get rid of the code
handling them.

The new structure of scsi_prep_fn is:

 (1) check if we're allowed to send this command
 (2) big switch on cmd_type.  For the two valid types call into
     a function to set the command up, else error
 (3) code to handle error cases

Because FS and BLOCK_PC commands are handled entirely separate after
the patch this introduces a tiny amount of code duplication.  This
improves readabiulity though and will help to avoid the bidi command
overhead for FS commands so it's a good thing.

I've tested this on both sata and mptsas.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_lib.c	2006-10-30 17:00:23.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_lib.c	2006-11-04 20:01:06.000000000 +0100
@@ -995,25 +995,14 @@
 	int		   count;
 
 	/*
-	 * if this is a rq->data based REQ_BLOCK_PC, setup for a non-sg xfer
-	 */
-	if (blk_pc_request(req) && !req->bio) {
-		cmd->request_bufflen = req->data_len;
-		cmd->request_buffer = req->data;
-		req->buffer = req->data;
-		cmd->use_sg = 0;
-		return 0;
-	}
-
-	/*
-	 * we used to not use scatter-gather for single segment request,
+	 * We used to not use scatter-gather for single segment request,
 	 * but now we do (it makes highmem I/O easier to support without
 	 * kmapping pages)
 	 */
 	cmd->use_sg = req->nr_phys_segments;
 
 	/*
-	 * if sg table allocation fails, requeue request later.
+	 * If sg table allocation fails, requeue request later.
 	 */
 	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
 	if (unlikely(!sgpnt)) {
@@ -1021,24 +1010,21 @@
 		return BLKPREP_DEFER;
 	}
 
+	req->buffer = NULL;
 	cmd->request_buffer = (char *) sgpnt;
-	cmd->request_bufflen = req->nr_sectors << 9;
 	if (blk_pc_request(req))
 		cmd->request_bufflen = req->data_len;
-	req->buffer = NULL;
+	else
+		cmd->request_bufflen = req->nr_sectors << 9;
 
 	/* 
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
 	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
-
-	/*
-	 * mapped well, send it off
-	 */
 	if (likely(count <= cmd->use_sg)) {
 		cmd->use_sg = count;
-		return 0;
+		return BLKPREP_OK;
 	}
 
 	printk(KERN_ERR "Incorrect number of segments after building list\n");
@@ -1068,6 +1054,27 @@
 	return -EOPNOTSUPP;
 }
 
+static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
+		struct request *req)
+{
+	struct scsi_cmnd *cmd;
+
+	if (!req->special) {
+		cmd = scsi_get_command(sdev, GFP_ATOMIC);
+		if (unlikely(!cmd))
+			return NULL;
+		req->special = cmd;
+	} else {
+		cmd = req->special;
+	}
+
+	/* pull a tag out of the request if we have one */
+	cmd->tag = req->tag;
+	cmd->request = req;
+
+	return cmd;
+}
+
 static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 {
 	BUG_ON(!blk_pc_request(cmd->request));
@@ -1080,9 +1087,37 @@
 	scsi_io_completion(cmd, cmd->request_bufflen);
 }
 
-static void scsi_setup_blk_pc_cmnd(struct scsi_cmnd *cmd)
+static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
-	struct request *req = cmd->request;
+	struct scsi_cmnd *cmd;
+
+	cmd = scsi_get_cmd_from_req(sdev, req);
+	if (unlikely(!cmd))
+		return BLKPREP_DEFER;
+
+	/*
+	 * BLOCK_PC requests may transfer data, in which case they must
+	 * a bio attached to them.  Or they might contain a SCSI command
+	 * that does not transfer data, in which case they may optionally
+	 * submit a request without an attached bio.
+	 */
+	if (req->bio) {
+		int ret;
+
+		BUG_ON(!req->nr_phys_segments);
+
+		ret = scsi_init_io(cmd);
+		if (unlikely(ret))
+			return ret;
+	} else {
+		BUG_ON(req->data_len);
+		BUG_ON(req->data);
+
+		cmd->request_bufflen = 0;
+		cmd->request_buffer = NULL;
+		cmd->use_sg = 0;
+		req->buffer = NULL;
+	}
 
 	BUG_ON(sizeof(req->cmd) > sizeof(cmd->cmnd));
 	memcpy(cmd->cmnd, req->cmd, sizeof(cmd->cmnd));
@@ -1098,154 +1133,138 @@
 	cmd->allowed = req->retries;
 	cmd->timeout_per_command = req->timeout;
 	cmd->done = scsi_blk_pc_done;
+	return BLKPREP_OK;
 }
 
-static int scsi_prep_fn(struct request_queue *q, struct request *req)
+/*
+ * Setup a REQ_TYPE_FS command.  These are simple read/write request
+ * from filesystems that still need to be translated to SCSI CDBs from
+ * the ULD.
+ */
+static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 {
-	struct scsi_device *sdev = q->queuedata;
 	struct scsi_cmnd *cmd;
-	int specials_only = 0;
+	struct scsi_driver *drv;
+	int ret;
 
 	/*
-	 * Just check to see if the device is online.  If it isn't, we
-	 * refuse to process any commands.  The device must be brought
-	 * online before trying any recovery commands
+	 * Filesystem requests must transfer data.
 	 */
-	if (unlikely(!scsi_device_online(sdev))) {
-		sdev_printk(KERN_ERR, sdev,
-			    "rejecting I/O to offline device\n");
-		goto kill;
-	}
-	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
-		/* OK, we're not in a running state don't prep
-		 * user commands */
-		if (sdev->sdev_state == SDEV_DEL) {
-			/* Device is fully deleted, no commands
-			 * at all allowed down */
-			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to dead device\n");
-			goto kill;
-		}
-		/* OK, we only allow special commands (i.e. not
-		 * user initiated ones */
-		specials_only = sdev->sdev_state;
+	BUG_ON(!req->nr_phys_segments);
+
+	cmd = scsi_get_cmd_from_req(sdev, req);
+	if (unlikely(!cmd))
+		return BLKPREP_DEFER;
+
+	ret = scsi_init_io(cmd);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * Initialize the actual SCSI command for this request.
+	 */
+	drv = *(struct scsi_driver **)req->rq_disk->private_data;
+	if (unlikely(!drv->init_command(cmd))) {
+		scsi_release_buffers(cmd);
+		scsi_put_command(cmd);
+		return BLKPREP_KILL;
 	}
 
+	return BLKPREP_OK;
+}
+
+static int scsi_prep_fn(struct request_queue *q, struct request *req)
+{
+	struct scsi_device *sdev = q->queuedata;
+	int ret = BLKPREP_OK;
+
 	/*
-	 * Find the actual device driver associated with this command.
-	 * The SPECIAL requests are things like character device or
-	 * ioctls, which did not originate from ll_rw_blk.  Note that
-	 * the special field is also used to indicate the cmd for
-	 * the remainder of a partially fulfilled request that can 
-	 * come up when there is a medium error.  We have to treat
-	 * these two cases differently.  We differentiate by looking
-	 * at request->cmd, as this tells us the real story.
+	 * If the device is not in running state we will reject some
+	 * or all commands.
 	 */
-	if (blk_special_request(req) && req->special)
-		cmd = req->special;
-	else if (blk_pc_request(req) || blk_fs_request(req)) {
-		if (unlikely(specials_only) && !(req->cmd_flags & REQ_PREEMPT)){
-			if (specials_only == SDEV_QUIESCE ||
-			    specials_only == SDEV_BLOCK)
-				goto defer;
-			
+	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
+		switch (sdev->sdev_state) {
+		case SDEV_OFFLINE:
+			/*
+			 * If the device is offline we refuse to process any
+			 * commands.  The device must be brought online
+			 * before trying any recovery commands.
+			 */
+			sdev_printk(KERN_ERR, sdev,
+				    "rejecting I/O to offline device\n");
+			ret = BLKPREP_KILL;
+			break;
+		case SDEV_DEL:
+			/*
+			 * If the device is fully deleted, we refuse to
+			 * process any commands as well.
+			 */
 			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to device being removed\n");
-			goto kill;
+				    "rejecting I/O to dead device\n");
+			ret = BLKPREP_KILL;
+			break;
+		case SDEV_QUIESCE:
+		case SDEV_BLOCK:
+			/*
+			 * If the devices is blocked we defer normal commands.
+			 */
+			if (!(req->cmd_flags & REQ_PREEMPT))
+				ret = BLKPREP_DEFER;
+			break;
+		default:
+			/*
+			 * For any other not fully online state we only allow
+			 * special commands.  In particular any user initiated
+			 * command is not allowed.
+			 */
+			if (!(req->cmd_flags & REQ_PREEMPT))
+				ret = BLKPREP_KILL;
+			break;
 		}
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
-	} else {
-		blk_dump_rq_flags(req, "SCSI bad req");
-		goto kill;
+
+		if (ret != BLKPREP_OK)
+			goto out;
 	}
-	
-	/* note the overloading of req->special.  When the tag
-	 * is active it always means cmd.  If the tag goes
-	 * back for re-queueing, it may be reset */
-	req->special = cmd;
-	cmd->request = req;
-	
-	/*
-	 * FIXME: drop the lock here because the functions below
-	 * expect to be called without the queue lock held.  Also,
-	 * previously, we dequeued the request before dropping the
-	 * lock.  We hope REQ_STARTED prevents anything untoward from
-	 * happening now.
-	 */
-	if (blk_fs_request(req) || blk_pc_request(req)) {
-		int ret;
 
+	switch (req->cmd_type) {
+	case REQ_TYPE_BLOCK_PC:
+		ret = scsi_setup_blk_pc_cmnd(sdev, req);
+		break;
+	case REQ_TYPE_FS:
+		ret = scsi_setup_fs_cmnd(sdev, req);
+		break;
+	default:
 		/*
-		 * This will do a couple of things:
-		 *  1) Fill in the actual SCSI command.
-		 *  2) Fill in any other upper-level specific fields
-		 * (timeout).
+		 * All other command types are not supported.
 		 *
-		 * If this returns 0, it means that the request failed
-		 * (reading past end of disk, reading offline device,
-		 * etc).   This won't actually talk to the device, but
-		 * some kinds of consistency checking may cause the	
-		 * request to be rejected immediately.
+		 * Note that these days the SCSI subsystem does not use
+		 * REQ_TYPE_SPECIAL requests anymore.  These are only used
+		 * (directly or via blk_insert_request) by non-SCSI drivers.
 		 */
+		blk_dump_rq_flags(req, "SCSI bad req");
+		ret = BLKPREP_KILL;
+		break;
+	}
 
-		/* 
-		 * This sets up the scatter-gather table (allocating if
-		 * required).
-		 */
-		ret = scsi_init_io(cmd);
-		switch(ret) {
-			/* For BLKPREP_KILL/DEFER the cmd was released */
-		case BLKPREP_KILL:
-			goto kill;
-		case BLKPREP_DEFER:
-			goto defer;
-		}
-		
+ out:
+	switch (ret) {
+	case BLKPREP_KILL:
+		req->errors = DID_NO_CONNECT << 16;
+		break;
+	case BLKPREP_DEFER:
 		/*
-		 * Initialize the actual SCSI command for this request.
+		 * If we defer, the elv_next_request() returns NULL, but the
+		 * queue must be restarted, so we plug here if no returning
+		 * command will automatically do that.
 		 */
-		if (blk_pc_request(req)) {
-			scsi_setup_blk_pc_cmnd(cmd);
-		} else if (req->rq_disk) {
-			struct scsi_driver *drv;
-
-			drv = *(struct scsi_driver **)req->rq_disk->private_data;
-			if (unlikely(!drv->init_command(cmd))) {
-				scsi_release_buffers(cmd);
-				scsi_put_command(cmd);
-				goto kill;
-			}
-		}
+		if (sdev->device_busy == 0)
+			blk_plug_device(q);
+		break;
+	default:
+		req->cmd_flags |= REQ_DONTPREP;
 	}
 
-	/*
-	 * The request is now prepped, no need to come back here
-	 */
-	req->cmd_flags |= REQ_DONTPREP;
-	return BLKPREP_OK;
-
- defer:
-	/* If we defer, the elv_next_request() returns NULL, but the
-	 * queue must be restarted, so we plug here if no returning
-	 * command will automatically do that. */
-	if (sdev->device_busy == 0)
-		blk_plug_device(q);
-	return BLKPREP_DEFER;
- kill:
-	req->errors = DID_NO_CONNECT << 16;
-	return BLKPREP_KILL;
+	return ret;
 }
 
 /*
