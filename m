From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] always handle REQ_BLOCK_PC requests in common code
Date: Fri, 6 Jan 2006 18:34:07 +0100
Message-ID: <20060106173407.GA23658@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:13522 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932515AbWAFReT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2006 12:34:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

LLDDs should never see REQ_BLOCK_PC requests, we can handle them just
fine in the core code.  There is a small behaviour change in that some
check in sr's rw_intr are bypassed, but I consider the old behaviour
a bug.

Mike found this cleanup ooportunity and provdided early patches, so all
the credit goes to him, even if I redid the patches from scratch beause
that was easier than forward-porting the old patches.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_lib.c	2005-12-16 16:14:35.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_lib.c	2006-01-06 18:11:16.000000000 +0100
@@ -1247,7 +1247,7 @@
 	return -EOPNOTSUPP;
 }
 
-static void scsi_generic_done(struct scsi_cmnd *cmd)
+static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 {
 	BUG_ON(!blk_pc_request(cmd->request));
 	/*
@@ -1259,7 +1259,7 @@
 	scsi_io_completion(cmd, cmd->bufflen, 0);
 }
 
-void scsi_setup_blk_pc_cmnd(struct scsi_cmnd *cmd)
+static void scsi_setup_blk_pc_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *req = cmd->request;
 
@@ -1276,8 +1276,8 @@
 	cmd->transfersize = req->data_len;
 	cmd->allowed = req->retries;
 	cmd->timeout_per_command = req->timeout;
+	cmd->done = scsi_blk_pc_done;
 }
-EXPORT_SYMBOL_GPL(scsi_setup_blk_pc_cmnd);
 
 static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
@@ -1374,7 +1374,6 @@
 	 * happening now.
 	 */
 	if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
-		struct scsi_driver *drv;
 		int ret;
 
 		/*
@@ -1406,16 +1405,17 @@
 		/*
 		 * Initialize the actual SCSI command for this request.
 		 */
-		if (req->rq_disk) {
+		if (req->flags & REQ_BLOCK_PC) {
+			scsi_setup_blk_pc_cmnd(cmd);
+		} else if (req->rq_disk) {
+			struct scsi_driver *drv;
+
 			drv = *(struct scsi_driver **)req->rq_disk->private_data;
 			if (unlikely(!drv->init_command(cmd))) {
 				scsi_release_buffers(cmd);
 				scsi_put_command(cmd);
 				goto kill;
 			}
-		} else {
-			scsi_setup_blk_pc_cmnd(cmd);
-			cmd->done = scsi_generic_done;
 		}
 	}
 
Index: scsi-misc-2.6/drivers/scsi/sd.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sd.c	2006-01-06 17:52:58.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/sd.c	2006-01-06 18:18:49.000000000 +0100
@@ -233,34 +233,12 @@
  **/
 static int sd_init_command(struct scsi_cmnd * SCpnt)
 {
-	unsigned int this_count, timeout;
-	struct gendisk *disk;
-	sector_t block;
 	struct scsi_device *sdp = SCpnt->device;
 	struct request *rq = SCpnt->request;
-
-	timeout = sdp->timeout;
-
-	/*
-	 * SG_IO from block layer already setup, just copy cdb basically
-	 */
-	if (blk_pc_request(rq)) {
-		scsi_setup_blk_pc_cmnd(SCpnt);
-		if (rq->timeout)
-			timeout = rq->timeout;
-
-		goto queue;
-	}
-
-	/*
-	 * we only do REQ_CMD and REQ_BLOCK_PC
-	 */
-	if (!blk_fs_request(rq))
-		return 0;
-
-	disk = rq->rq_disk;
-	block = rq->sector;
-	this_count = SCpnt->request_bufflen >> 9;
+	struct gendisk *disk = rq->rq_disk;
+	sector_t block = rq->sector;
+	unsigned int this_count = SCpnt->request_bufflen >> 9;
+	unsigned int timeout = sdp->timeout;
 
 	SCSI_LOG_HLQUEUE(1, printk("sd_init_command: disk=%s, block=%llu, "
 			    "count=%d\n", disk->disk_name,
@@ -394,8 +372,6 @@
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = SD_MAX_RETRIES;
-
-queue:
 	SCpnt->timeout_per_command = timeout;
 
 	/*
@@ -870,15 +846,7 @@
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
+	if (driver_byte(result) != 0 &&
 		 sense_valid && !sense_deferred) {
 		switch (sshdr.sense_key) {
 		case MEDIUM_ERROR:
Index: scsi-misc-2.6/drivers/scsi/sr.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sr.c	2005-12-16 16:14:35.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/sr.c	2006-01-06 18:16:05.000000000 +0100
@@ -237,8 +237,6 @@
 		case ILLEGAL_REQUEST:
 			if (!(SCpnt->sense_buffer[0] & 0x90))
 				break;
-			if (!blk_fs_request(SCpnt->request))
-				break;
 			error_sector = (SCpnt->sense_buffer[3] << 24) |
 				(SCpnt->sense_buffer[4] << 16) |
 				(SCpnt->sense_buffer[5] << 8) |
@@ -317,23 +315,6 @@
 	}
 
 	/*
-	 * these are already setup, just copy cdb basically
-	 */
-	if (SCpnt->request->flags & REQ_BLOCK_PC) {
-		scsi_setup_blk_pc_cmnd(SCpnt);
-
-		if (SCpnt->timeout_per_command)
-			timeout = SCpnt->timeout_per_command;
-
-		goto queue;
-	}
-
-	if (!(SCpnt->request->flags & REQ_CMD)) {
-		blk_dump_rq_flags(SCpnt->request, "sr unsup command");
-		return 0;
-	}
-
-	/*
 	 * we do lazy blocksize switching (when reading XA sectors,
 	 * see CDROMREADMODE2 ioctl) 
 	 */
@@ -421,8 +402,6 @@
 	 */
 	SCpnt->transfersize = cd->device->sector_size;
 	SCpnt->underflow = this_count << 9;
-
-queue:
 	SCpnt->allowed = MAX_RETRIES;
 	SCpnt->timeout_per_command = timeout;
 
Index: scsi-misc-2.6/drivers/scsi/st.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/st.c	2006-01-04 12:11:46.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/st.c	2006-01-06 18:12:35.000000000 +0100
@@ -193,7 +193,6 @@
 
 static int st_probe(struct device *);
 static int st_remove(struct device *);
-static int st_init_command(struct scsi_cmnd *);
 
 static void do_create_driverfs_files(void);
 static void do_remove_driverfs_files(void);
@@ -206,7 +205,6 @@
 		.probe		= st_probe,
 		.remove		= st_remove,
 	},
-	.init_command		= st_init_command,
 };
 
 static int st_compression(struct scsi_tape *, int);
@@ -4180,29 +4178,6 @@
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
-	if (!(SCpnt->request->flags & REQ_BLOCK_PC))
-		return 0;
-
-	scsi_setup_blk_pc_cmnd(SCpnt);
-	SCpnt->done = st_intr;
-	return 1;
-}
-
 static int __init init_st(void)
 {
 	validate_options();
Index: scsi-misc-2.6/include/scsi/scsi_cmnd.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_cmnd.h	2005-12-16 16:14:35.000000000 +0100
+++ scsi-misc-2.6/include/scsi/scsi_cmnd.h	2006-01-06 18:11:45.000000000 +0100
@@ -151,6 +151,5 @@
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
-extern void scsi_setup_blk_pc_cmnd(struct scsi_cmnd *cmd);
 
 #endif /* _SCSI_SCSI_CMND_H */
