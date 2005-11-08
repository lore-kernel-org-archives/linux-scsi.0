From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 10/10] make all scsi REQ_PC use the same setup and
	completion paths.
Date: Tue, 08 Nov 2005 04:06:57 -0600
Message-ID: <1131444417.23111.71.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:12447 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932504AbVKHKIK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 05:08:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org

This is more of RFC and so I made it the last patch incase
it is not correct.

scsi_prep_fn's REQ_PC code does the same setup and completion as
sd and st's init_command. sr's does almost the same thing except
the init_command tests cd->device->changed and fails the commands if
changed is set. And sr's intr command clears the scsi_cmnd->result for
RECOVERED_ERROR. If not for those two cases, sr, sd and st could
all use the same setup and completion code paths for REQ_PC commands.
I was not sure if sr's code was mistake or maybe not needed since
the caller can check these things (but maybe userspace apps
rely on this behavior now). If that sr code can go for REQ_PC commands
this patch brings all those paths together.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c06e1e4..99cb09f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1377,7 +1377,7 @@ static int scsi_prep_fn(struct request_q
 		/*
 		 * Initialize the actual SCSI command for this request.
 		 */
-		if (req->rq_disk) {
+		if (!blk_pc_request(req) && req->rq_disk) {
 			drv = *(struct scsi_driver **)req->rq_disk->private_data;
 			if (unlikely(!drv->init_command(cmd))) {
 				scsi_release_buffers(cmd);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4b43d73..4062d92 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -232,41 +232,14 @@ static void scsi_disk_put(struct scsi_di
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
-		SCpnt->allowed = rq->retries;
-		goto queue;
-	}
-
-	/*
-	 * we only do REQ_CMD and REQ_BLOCK_PC
+	 * we only do REQ_CMD
 	 */
 	if (!blk_fs_request(rq))
 		return 0;
@@ -403,9 +376,7 @@ static int sd_init_command(struct scsi_c
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = SD_MAX_RETRIES;
-
-queue:
-	SCpnt->timeout_per_command = timeout;
+	SCpnt->timeout_per_command = sdp->timeout;
 
 	/*
 	 * This is the completion routine we use.  This is matched in terms
@@ -882,16 +853,7 @@ static void sd_rw_intr(struct scsi_cmnd 
 	   relatively rare error condition, no care is taken to avoid
 	   unnecessary additional work such as memcpy's that could be avoided.
 	 */
-
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
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index bbcf428..f741c0d 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -295,7 +295,7 @@ static void rw_intr(struct scsi_cmnd * S
 
 static int sr_init_command(struct scsi_cmnd * SCpnt)
 {
-	int block=0, this_count, s_size, timeout = SR_TIMEOUT;
+	int block=0, this_count, s_size;
 	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
 
 	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %s, block = %d\n",
@@ -316,33 +316,6 @@ static int sr_init_command(struct scsi_c
 		return 0;
 	}
 
-	/*
-	 * these are already setup, just copy cdb basically
-	 */
-	if (SCpnt->request->flags & REQ_BLOCK_PC) {
-		struct request *rq = SCpnt->request;
-
-		if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
-			return 0;
-
-		memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
-		SCpnt->cmd_len = rq->cmd_len;
-		if (!rq->data_len)
-			SCpnt->sc_data_direction = DMA_NONE;
-		else if (rq_data_dir(rq) == WRITE)
-			SCpnt->sc_data_direction = DMA_TO_DEVICE;
-		else
-			SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-
-		this_count = rq->data_len;
-		if (rq->timeout)
-			timeout = rq->timeout;
-
-		SCpnt->allowed = rq->retries;
-		SCpnt->transfersize = rq->data_len;
-		goto queue;
-	}
-
 	if (!(SCpnt->request->flags & REQ_CMD)) {
 		blk_dump_rq_flags(SCpnt->request, "sr unsup command");
 		return 0;
@@ -437,8 +410,7 @@ static int sr_init_command(struct scsi_c
 	SCpnt->transfersize = cd->device->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = MAX_RETRIES;
-queue:
-	SCpnt->timeout_per_command = timeout;
+	SCpnt->timeout_per_command = SR_TIMEOUT;
 
 	/*
 	 * This is the completion routine we use.  This is matched in terms
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 5e61e48..2149137 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -193,7 +193,6 @@ static int sgl_unmap_user_pages(struct s
 
 static int st_probe(struct device *);
 static int st_remove(struct device *);
-static int st_init_command(struct scsi_cmnd *);
 
 static void do_create_driverfs_files(void);
 static void do_remove_driverfs_files(void);
@@ -206,7 +205,6 @@ static struct scsi_driver st_template = 
 		.probe		= st_probe,
 		.remove		= st_remove,
 	},
-	.init_command		= st_init_command,
 };
 
 static int st_compression(struct scsi_tape *, int);
@@ -4177,47 +4175,6 @@ static void scsi_tape_release(struct kre
 	return;
 }
 
-static void st_intr(struct scsi_cmnd *SCpnt)
-{
-	/*
-	 * The caller should be checking the request's errors
-	 * value.
-	 */
-	scsi_io_completion(SCpnt, SCpnt->bufflen, 0);
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
-	SCpnt->allowed = rq->retries;
-	SCpnt->timeout_per_command = rq->timeout;
-	SCpnt->transfersize = rq->data_len;
-	SCpnt->done = st_intr;
-	return 1;
-}
-
 static int __init init_st(void)
 {
 	validate_options();


