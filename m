From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] fix all REQ_BLOCK_PC retries and requeues (take2)
Date: Sun, 18 Sep 2005 16:04:52 -0500
Message-ID: <1127077492.2728.2.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:25555 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932224AbVIRXE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 19:04:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@suse.de

sd and st handle REQ_BLOCK_PC command setup the same, and
except for a bug in st_intr they would handle completion
exactly the same. And it seems we want scsi_execute*
to handle setup and completion in the same way as
the ULDs so the patch below moves everyone to use
scsi_generic_done for REQ_BLOCK_PC commands.

This patch also adds a reties count onto the request
so that we handle command retries like we used to.

This patch was made against scsi-rc-fixes.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/block/scsi_ioctl.c b/drivers/block/scsi_ioctl.c
--- a/drivers/block/scsi_ioctl.c
+++ b/drivers/block/scsi_ioctl.c
@@ -302,6 +302,7 @@ static int sg_io(struct file *file, requ
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
 		rq->timeout = BLK_DEFAULT_TIMEOUT;
+	rq->retries = 1;
 
 	start_time = jiffies;
 
@@ -412,6 +413,7 @@ static int sg_scsi_ioctl(struct file *fi
 			rq->timeout = BLK_DEFAULT_TIMEOUT;
 			break;
 	}
+	rq->retries = 1;
 
 	memset(sense, 0, sizeof(sense));
 	rq->sense = sense;
@@ -570,6 +572,7 @@ int scsi_cmd_ioctl(struct file *file, st
 			rq->data = NULL;
 			rq->data_len = 0;
 			rq->timeout = BLK_DEFAULT_TIMEOUT;
+			rq->retries = 1;
 			memset(rq->cmd, 0, sizeof(rq->cmd));
 			rq->cmd[0] = GPCMD_START_STOP_UNIT;
 			rq->cmd[4] = 0x02 + (close != 0);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -337,6 +337,7 @@ int scsi_execute(struct scsi_device *sde
 	memcpy(req->cmd, cmd, req->cmd_len);
 	req->sense = sense;
 	req->sense_len = 0;
+	req->retries = retries;
 	req->timeout = timeout;
 	req->flags |= flags | REQ_BLOCK_PC | REQ_SPECIAL | REQ_QUIET;
 
@@ -1125,7 +1126,13 @@ static int scsi_issue_flush_fn(request_q
 static void scsi_generic_done(struct scsi_cmnd *cmd)
 {
 	BUG_ON(!blk_pc_request(cmd->request));
-	scsi_io_completion(cmd, cmd->result == 0 ? cmd->bufflen : 0, 0);
+	/*
+	 * This will complete the whole command with uptodate=1 so
+	 * as far as the block layer is concerned the command completed
+	 * successfully. Since this is REQ_BLOCK_PC command though the
+	 * caller should check the errors value to check for errors
+	 */
+	scsi_io_completion(cmd, cmd->bufflen, 0);
 }
 
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
@@ -1255,7 +1262,7 @@ static int scsi_prep_fn(struct request_q
 		/*
 		 * Initialize the actual SCSI command for this request.
 		 */
-		if (req->rq_disk) {
+		if (!blk_pc_request(req)) {
 			drv = *(struct scsi_driver **)req->rq_disk->private_data;
 			if (unlikely(!drv->init_command(cmd))) {
 				scsi_release_buffers(cmd);
@@ -1273,7 +1280,7 @@ static int scsi_prep_fn(struct request_q
 				cmd->sc_data_direction = DMA_NONE;
 			
 			cmd->transfersize = req->data_len;
-			cmd->allowed = 3;
+			cmd->allowed = req->retries;
 			cmd->timeout_per_command = req->timeout;
 			cmd->done = scsi_generic_done;
 		}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -86,7 +86,6 @@
  * Number of allowed retries
  */
 #define SD_MAX_RETRIES		5
-#define SD_PASSTHROUGH_RETRIES	1
 
 static void scsi_disk_release(struct kref *kref);
 
@@ -219,41 +218,14 @@ static void scsi_disk_put(struct scsi_di
  **/
 static int sd_init_command(struct scsi_cmnd * SCpnt)
 {
-	unsigned int this_count, timeout;
+	unsigned int this_count;
 	struct gendisk *disk;
 	sector_t block;
 	struct scsi_device *sdp = SCpnt->device;
 	struct request *rq = SCpnt->request;
 
-	timeout = sdp->timeout;
-
 	/*
-	 * SG_IO from block layer already setup, just copy cdb basically
-	 */
-	if (blk_pc_request(rq)) {
-		if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
-			return 0;
-
-		memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
-		SCpnt->cmd_len = rq->cmd_len;
-		if (rq_data_dir(rq) == WRITE)
-			SCpnt->sc_data_direction = DMA_TO_DEVICE;
-		else if (rq->data_len)
-			SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-		else
-			SCpnt->sc_data_direction = DMA_NONE;
-
-		this_count = rq->data_len;
-		if (rq->timeout)
-			timeout = rq->timeout;
-
-		SCpnt->transfersize = rq->data_len;
-		SCpnt->allowed = SD_PASSTHROUGH_RETRIES;
-		goto queue;
-	}
-
-	/*
-	 * we only do REQ_CMD and REQ_BLOCK_PC
+	 * we only do REQ_CMD
 	 */
 	if (!blk_fs_request(rq))
 		return 0;
@@ -390,10 +362,7 @@ static int sd_init_command(struct scsi_c
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = SD_MAX_RETRIES;
-
-queue:
-	SCpnt->timeout_per_command = timeout;
-
+	SCpnt->timeout_per_command = sdp->timeout;
 	/*
 	 * This is the completion routine we use.  This is matched in terms
 	 * of capability to this function.
@@ -862,15 +831,7 @@ static void sd_rw_intr(struct scsi_cmnd 
 	   unnecessary additional work such as memcpy's that could be avoided.
 	 */
 
-	/* 
-	 * If SG_IO from block layer then set good_bytes to stop retries;
-	 * else if errors, check them, and if necessary prepare for
-	 * (partial) retries.
-	 */
-	if (blk_pc_request(SCpnt->request))
-		good_bytes = this_count;
-	else if (driver_byte(result) != 0 &&
-		 sense_valid && !sense_deferred) {
+	if (driver_byte(result) != 0 && sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case MEDIUM_ERROR:
 			if (!blk_fs_request(SCpnt->request))
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -196,7 +196,6 @@ static int sgl_unmap_user_pages(struct s
 
 static int st_probe(struct device *);
 static int st_remove(struct device *);
-static int st_init_command(struct scsi_cmnd *);
 
 static void do_create_driverfs_files(void);
 static void do_remove_driverfs_files(void);
@@ -209,7 +208,6 @@ static struct scsi_driver st_template = 
 		.probe		= st_probe,
 		.remove		= st_remove,
 	},
-	.init_command		= st_init_command,
 };
 
 static int st_compression(struct scsi_tape *, int);
@@ -4185,42 +4183,6 @@ static void scsi_tape_release(struct kre
 	return;
 }
 
-static void st_intr(struct scsi_cmnd *SCpnt)
-{
-	scsi_io_completion(SCpnt, (SCpnt->result ? 0: SCpnt->bufflen), 1);
-}
-
-/*
- * st_init_command: only called via the scsi_cmd_ioctl (block SG_IO)
- * interface for REQ_BLOCK_PC commands.
- */
-static int st_init_command(struct scsi_cmnd *SCpnt)
-{
-	struct request *rq;
-
-	if (!(SCpnt->request->flags & REQ_BLOCK_PC))
-		return 0;
-
-	rq = SCpnt->request;
-	if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
-		return 0;
-
-	memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
-	SCpnt->cmd_len = rq->cmd_len;
-
-	if (rq_data_dir(rq) == WRITE)
-		SCpnt->sc_data_direction = DMA_TO_DEVICE;
-	else if (rq->data_len)
-		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	else
-		SCpnt->sc_data_direction = DMA_NONE;
-
-	SCpnt->timeout_per_command = rq->timeout;
-	SCpnt->transfersize = rq->data_len;
-	SCpnt->done = st_intr;
-	return 1;
-}
-
 static int __init init_st(void)
 {
 	validate_options();
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -184,6 +184,7 @@ struct request {
 	void *sense;
 
 	unsigned int timeout;
+	int retries;
 
 	/*
 	 * For Power Management requests


