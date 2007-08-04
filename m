From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] move ULD attachment into the prep function
Date: Sat, 04 Aug 2007 10:06:25 -0500
Message-ID: <1186239985.3439.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52194 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756680AbXHDPG1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Aug 2007 11:06:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <Jens.Axboe@oracle.com>

One of the intents of the block prep function was to allow ULDs to use
it for preprocessing.  The original SCSI model was to have a single prep
function and add a pointer indirect filter to build the necessary
commands.  This patch reverses that, does away with the init_command
field of the scsi_driver structure and makes ULDs attach directly to the
prep function instead.  The value is really that it allows us to begin
to separate the ULDs from the SCSI mid layer (as long as they don't use
any core functions---which is hard at the moment---a ULD doesn't even
need SCSI to bind).

James

Index: BUILD-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_lib.c	2007-08-04 09:53:44.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_lib.c	2007-08-04 09:53:49.000000000 -0500
@@ -1032,9 +1032,6 @@ static int scsi_init_io(struct scsi_cmnd
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
-	/* release the command and kill it */
-	scsi_release_buffers(cmd);
-	scsi_put_command(cmd);
 	return BLKPREP_KILL;
 }
 
@@ -1071,9 +1068,13 @@ static void scsi_blk_pc_done(struct scsi
 	scsi_io_completion(cmd, cmd->request_bufflen);
 }
 
-static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
+int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd;
+	int ret = scsi_prep_state_check(sdev, req);
+
+	if (ret != BLKPREP_OK)
+		return ret;
 
 	cmd = scsi_get_cmd_from_req(sdev, req);
 	if (unlikely(!cmd))
@@ -1119,18 +1120,20 @@ static int scsi_setup_blk_pc_cmnd(struct
 	cmd->done = scsi_blk_pc_done;
 	return BLKPREP_OK;
 }
+EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
 
 /*
  * Setup a REQ_TYPE_FS command.  These are simple read/write request
  * from filesystems that still need to be translated to SCSI CDBs from
  * the ULD.
  */
-static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
+int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd;
-	struct scsi_driver *drv;
-	int ret;
+	int ret = scsi_prep_state_check(sdev, req);
 
+	if (ret != BLKPREP_OK)
+		return ret;
 	/*
 	 * Filesystem requests must transfer data.
 	 */
@@ -1140,26 +1143,12 @@ static int scsi_setup_fs_cmnd(struct scs
 	if (unlikely(!cmd))
 		return BLKPREP_DEFER;
 
-	ret = scsi_init_io(cmd);
-	if (unlikely(ret))
-		return ret;
-
-	/*
-	 * Initialize the actual SCSI command for this request.
-	 */
-	drv = *(struct scsi_driver **)req->rq_disk->private_data;
-	if (unlikely(!drv->init_command(cmd))) {
-		scsi_release_buffers(cmd);
-		scsi_put_command(cmd);
-		return BLKPREP_KILL;
-	}
-
-	return BLKPREP_OK;
+	return scsi_init_io(cmd);
 }
+EXPORT_SYMBOL(scsi_setup_fs_cmnd);
 
-static int scsi_prep_fn(struct request_queue *q, struct request *req)
+int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 {
-	struct scsi_device *sdev = q->queuedata;
 	int ret = BLKPREP_OK;
 
 	/*
@@ -1205,35 +1194,25 @@ static int scsi_prep_fn(struct request_q
 				ret = BLKPREP_KILL;
 			break;
 		}
-
-		if (ret != BLKPREP_OK)
-			goto out;
 	}
+	return ret;
+}
+EXPORT_SYMBOL(scsi_prep_state_check);
 
-	switch (req->cmd_type) {
-	case REQ_TYPE_BLOCK_PC:
-		ret = scsi_setup_blk_pc_cmnd(sdev, req);
-		break;
-	case REQ_TYPE_FS:
-		ret = scsi_setup_fs_cmnd(sdev, req);
-		break;
-	default:
-		/*
-		 * All other command types are not supported.
-		 *
-		 * Note that these days the SCSI subsystem does not use
-		 * REQ_TYPE_SPECIAL requests anymore.  These are only used
-		 * (directly or via blk_insert_request) by non-SCSI drivers.
-		 */
-		blk_dump_rq_flags(req, "SCSI bad req");
-		ret = BLKPREP_KILL;
-		break;
-	}
+int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
+{
+	struct scsi_device *sdev = q->queuedata;
 
- out:
 	switch (ret) {
 	case BLKPREP_KILL:
 		req->errors = DID_NO_CONNECT << 16;
+		/* release the command and kill it */
+		if (req->special) {
+			struct scsi_cmnd *cmd = req->special;
+			scsi_release_buffers(cmd);
+			scsi_put_command(cmd);
+			req->special = NULL;
+		}
 		break;
 	case BLKPREP_DEFER:
 		/*
@@ -1250,6 +1229,17 @@ static int scsi_prep_fn(struct request_q
 
 	return ret;
 }
+EXPORT_SYMBOL(scsi_prep_return);
+
+static int scsi_prep_fn(struct request_queue *q, struct request *req)
+{
+	struct scsi_device *sdev = q->queuedata;
+	int ret = BLKPREP_KILL;
+
+	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
+		ret = scsi_setup_blk_pc_cmnd(sdev, req);
+	return scsi_prep_return(q, req, ret);
+}
 
 /*
  * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
Index: BUILD-2.6/drivers/scsi/sd.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sd.c	2007-08-04 08:45:14.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sd.c	2007-08-04 09:53:49.000000000 -0500
@@ -240,7 +240,6 @@ static struct scsi_driver sd_template = 
 		.shutdown	= sd_shutdown,
 	},
 	.rescan			= sd_rescan,
-	.init_command		= sd_init_command,
 };
 
 /*
@@ -331,14 +330,31 @@ static void scsi_disk_put(struct scsi_di
  *
  *	Returns 1 if successful and 0 if error (or cannot be done now).
  **/
-static int sd_init_command(struct scsi_cmnd * SCpnt)
+static int sd_prep_fn(struct request_queue *q, struct request *rq)
 {
-	struct scsi_device *sdp = SCpnt->device;
-	struct request *rq = SCpnt->request;
+	struct scsi_cmnd *SCpnt;
+	struct scsi_device *sdp = q->queuedata;
 	struct gendisk *disk = rq->rq_disk;
 	sector_t block = rq->sector;
-	unsigned int this_count = SCpnt->request_bufflen >> 9;
+	unsigned int this_count = rq->nr_sectors;
 	unsigned int timeout = sdp->timeout;
+	int ret;
+
+	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
+		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
+		goto out;
+	} else if (rq->cmd_type != REQ_TYPE_FS) {
+		ret = BLKPREP_KILL;
+		goto out;
+	}
+	ret = scsi_setup_fs_cmnd(sdp, rq);
+	if (ret != BLKPREP_OK)
+		goto out;
+	SCpnt = rq->special;
+
+	/* from here on until we're complete, any goto out
+	 * is used for a killable error condition */
+	ret = BLKPREP_KILL;
 
 	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
 					"sd_init_command: block=%llu, "
@@ -353,7 +369,7 @@ static int sd_init_command(struct scsi_c
 						rq->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
 						"Retry with 0x%p\n", SCpnt));
-		return 0;
+		goto out;
 	}
 
 	if (sdp->changed) {
@@ -362,8 +378,9 @@ static int sd_init_command(struct scsi_c
 		 * the changed bit has been reset
 		 */
 		/* printk("SCSI disk has been changed. Prohibiting further I/O.\n"); */
-		return 0;
+		goto out;
 	}
+
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
 					(unsigned long long)block));
 
@@ -382,7 +399,7 @@ static int sd_init_command(struct scsi_c
 		if ((block & 1) || (rq->nr_sectors & 1)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
-			return 0;
+			goto out;
 		} else {
 			block = block >> 1;
 			this_count = this_count >> 1;
@@ -392,7 +409,7 @@ static int sd_init_command(struct scsi_c
 		if ((block & 3) || (rq->nr_sectors & 3)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
-			return 0;
+			goto out;
 		} else {
 			block = block >> 2;
 			this_count = this_count >> 2;
@@ -402,7 +419,7 @@ static int sd_init_command(struct scsi_c
 		if ((block & 7) || (rq->nr_sectors & 7)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
-			return 0;
+			goto out;
 		} else {
 			block = block >> 3;
 			this_count = this_count >> 3;
@@ -410,7 +427,7 @@ static int sd_init_command(struct scsi_c
 	}
 	if (rq_data_dir(rq) == WRITE) {
 		if (!sdp->writeable) {
-			return 0;
+			goto out;
 		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
@@ -419,7 +436,7 @@ static int sd_init_command(struct scsi_c
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
 		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
-		return 0;
+		goto out;
 	}
 
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
@@ -470,7 +487,7 @@ static int sd_init_command(struct scsi_c
 			 */
 			scmd_printk(KERN_ERR, SCpnt,
 				    "FUA write on READ/WRITE(6) drive\n");
-			return 0;
+			goto out;
 		}
 
 		SCpnt->cmnd[1] |= (unsigned char) ((block >> 16) & 0x1f);
@@ -501,7 +518,9 @@ static int sd_init_command(struct scsi_c
 	 * This indicates that the command is ready from our end to be
 	 * queued.
 	 */
-	return 1;
+	ret = BLKPREP_OK;
+ out:
+	return scsi_prep_return(q, rq, ret);
 }
 
 /**
@@ -1669,6 +1688,7 @@ static int sd_probe(struct device *dev)
 
 	sd_revalidate_disk(gd);
 
+	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
 	blk_queue_issue_flush_fn(sdp->request_queue, sd_issue_flush);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
Index: BUILD-2.6/include/scsi/scsi_driver.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_driver.h	2007-08-04 08:45:14.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_driver.h	2007-08-04 09:53:49.000000000 -0500
@@ -5,13 +5,15 @@
 
 struct module;
 struct scsi_cmnd;
+struct scsi_device;
+struct request;
+struct request_queue;
 
 
 struct scsi_driver {
 	struct module		*owner;
 	struct device_driver	gendrv;
 
-	int (*init_command)(struct scsi_cmnd *);
 	void (*rescan)(struct device *);
 };
 #define to_scsi_driver(drv) \
@@ -25,4 +27,9 @@ extern int scsi_register_interface(struc
 #define scsi_unregister_interface(intf) \
 	class_interface_unregister(intf)
 
+int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req);
+int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req);
+int scsi_prep_state_check(struct scsi_device *sdev, struct request *req);
+int scsi_prep_return(struct request_queue *q, struct request *req, int ret);
+
 #endif /* _SCSI_SCSI_DRIVER_H */
Index: BUILD-2.6/include/scsi/sd.h
===================================================================
--- BUILD-2.6.orig/include/scsi/sd.h	2007-08-04 08:45:14.000000000 -0500
+++ BUILD-2.6/include/scsi/sd.h	2007-08-04 09:53:49.000000000 -0500
@@ -55,7 +55,6 @@ static void sd_shutdown(struct device *d
 static int sd_suspend(struct device *dev, pm_message_t state);
 static int sd_resume(struct device *dev);
 static void sd_rescan(struct device *);
-static int  sd_init_command(struct scsi_cmnd *);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct class_device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
Index: BUILD-2.6/drivers/scsi/sr.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sr.c	2007-08-04 08:42:10.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sr.c	2007-08-04 09:53:49.000000000 -0500
@@ -78,7 +78,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
-static int sr_init_command(struct scsi_cmnd *);
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -87,7 +86,6 @@ static struct scsi_driver sr_template = 
 		.probe		= sr_probe,
 		.remove		= sr_remove,
 	},
-	.init_command		= sr_init_command,
 };
 
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
@@ -296,19 +294,39 @@ static void rw_intr(struct scsi_cmnd * S
 	scsi_io_completion(SCpnt, good_bytes);
 }
 
-static int sr_init_command(struct scsi_cmnd * SCpnt)
+static int sr_prep_fn(struct request_queue *q, struct request *rq)
 {
 	int block=0, this_count, s_size, timeout = SR_TIMEOUT;
-	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
+	struct scsi_cd *cd;
+	struct scsi_cmnd *SCpnt;
+	struct scsi_device *sdp = q->queuedata;
+	int ret;
+
+	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
+		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
+		goto out;
+	} else if (rq->cmd_type != REQ_TYPE_FS) {
+		ret = BLKPREP_KILL;
+		goto out;
+	}
+	ret = scsi_setup_fs_cmnd(sdp, rq);
+	if (ret != BLKPREP_OK)
+		goto out;
+	SCpnt = rq->special;
+	cd = scsi_cd(rq->rq_disk);
+
+	/* from here on until we're complete, any goto out
+	 * is used for a killable error condition */
+	ret = BLKPREP_KILL;
 
 	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %s, block = %d\n",
 				cd->disk->disk_name, block));
 
 	if (!cd->device || !scsi_device_online(cd->device)) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n",
-					SCpnt->request->nr_sectors));
+					rq->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
-		return 0;
+		goto out;
 	}
 
 	if (cd->device->changed) {
@@ -316,7 +334,7 @@ static int sr_init_command(struct scsi_c
 		 * quietly refuse to do anything to a changed disc until the
 		 * changed bit has been reset
 		 */
-		return 0;
+		goto out;
 	}
 
 	/*
@@ -333,21 +351,21 @@ static int sr_init_command(struct scsi_c
 
 	if (s_size != 512 && s_size != 1024 && s_size != 2048) {
 		scmd_printk(KERN_ERR, SCpnt, "bad sector size %d\n", s_size);
-		return 0;
+		goto out;
 	}
 
-	if (rq_data_dir(SCpnt->request) == WRITE) {
+	if (rq_data_dir(rq) == WRITE) {
 		if (!cd->device->writeable)
-			return 0;
+			goto out;
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
  	 	cd->cdi.media_written = 1;
-	} else if (rq_data_dir(SCpnt->request) == READ) {
+	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_10;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
-		blk_dump_rq_flags(SCpnt->request, "Unknown sr command");
-		return 0;
+		blk_dump_rq_flags(rq, "Unknown sr command");
+		goto out;
 	}
 
 	{
@@ -368,10 +386,10 @@ static int sr_init_command(struct scsi_c
 	/*
 	 * request doesn't start on hw block boundary, add scatter pads
 	 */
-	if (((unsigned int)SCpnt->request->sector % (s_size >> 9)) ||
+	if (((unsigned int)rq->sector % (s_size >> 9)) ||
 	    (SCpnt->request_bufflen % s_size)) {
 		scmd_printk(KERN_NOTICE, SCpnt, "unaligned transfer\n");
-		return 0;
+		goto out;
 	}
 
 	this_count = (SCpnt->request_bufflen >> 9) / (s_size >> 9);
@@ -379,12 +397,12 @@ static int sr_init_command(struct scsi_c
 
 	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n",
 				cd->cdi.name,
-				(rq_data_dir(SCpnt->request) == WRITE) ?
+				(rq_data_dir(rq) == WRITE) ?
 					"writing" : "reading",
-				this_count, SCpnt->request->nr_sectors));
+				this_count, rq->nr_sectors));
 
 	SCpnt->cmnd[1] = 0;
-	block = (unsigned int)SCpnt->request->sector / (s_size >> 9);
+	block = (unsigned int)rq->sector / (s_size >> 9);
 
 	if (this_count > 0xffff) {
 		this_count = 0xffff;
@@ -419,7 +437,9 @@ static int sr_init_command(struct scsi_c
 	 * This indicates that the command is ready from our end to be
 	 * queued.
 	 */
-	return 1;
+	ret = BLKPREP_OK;
+ out:
+	return scsi_prep_return(q, rq, ret);
 }
 
 static int sr_block_open(struct inode *inode, struct file *file)
@@ -590,6 +610,7 @@ static int sr_probe(struct device *dev)
 
 	/* FIXME: need to handle a get_capabilities failure properly ?? */
 	get_capabilities(cd);
+	blk_queue_prep_rq(sdev->request_queue, sr_prep_fn);
 	sr_vendor_init(cd);
 
 	disk->driverfs_dev = &sdev->sdev_gendev;


