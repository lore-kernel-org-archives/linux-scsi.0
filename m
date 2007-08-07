From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] move ULD attachment into the prep function
Date: Tue, 07 Aug 2007 18:01:18 +0300
Message-ID: <46B8893E.9030005@panasas.com>
References: <1186239985.3439.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:24109 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756782AbXHGPB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 11:01:56 -0400
In-Reply-To: <1186239985.3439.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

James Bottomley wrote:
> One of the intents of the block prep function was to allow ULDs to use
> it for preprocessing.  The original SCSI model was to have a single prep
> function and add a pointer indirect filter to build the necessary
> commands.  This patch reverses that, does away with the init_command
> field of the scsi_driver structure and makes ULDs attach directly to the
> prep function instead.  The value is really that it allows us to begin
> to separate the ULDs from the SCSI mid layer (as long as they don't use
> any core functions---which is hard at the moment---a ULD doesn't even
> need SCSI to bind).
> 
> James
> 
> Index: BUILD-2.6/drivers/scsi/scsi_lib.c

It turns out this patch is dependent on previous
sd: disentangle barriers in SCSI (02)

and that one is dependent on the previous-previous one: 
block: add protocol discriminators to requests and queues. (01)

but the middle one (02) does not apply it looks like there is a missing
hunk for scsi_lib.c in the first (01)

<sd: disentangle barriers in SCSI (02)>
@@ -1596,7 +1580,6 @@ struct request_queue *scsi_alloc_queue(s
 		return NULL;
 
 	blk_queue_prep_rq(q, scsi_prep_fn);
-	blk_queue_issue_flush_fn(q, scsi_issue_flush_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	blk_queue_protocol(q, BLK_PROTOCOL_SCSI);
 	return q;
</sd: disentangle barriers in SCSI (02)>

The before last sync line: 
 	blk_queue_protocol(q, BLK_PROTOCOL_SCSI);
is missing from (01). Any thing else I need?

So I guess my first complain is that these should have been
a series to denote dependency. Also I think an email with 
deeper explanation of where you are going with these, and 
what is the motivation could be nice.

Apart from that:

Ouch! ;) That patch hurts.

What is the time frame for these changes are they for immediate
inclusion into scsi-misc and into 2.6.24 merge window? Before
scsi_data_buff, sglist, bidi, Mike's execute_async_cleanup ... ?

I do not like this patch. I think that if your motivation was
to make sd/sr and other ULD's more independent of scsi-ml than
you achieved the opposite. 5 exported functions and intimate
knowledge of scsi_lib internals. Lots of same cut and past code 
in ULD's. Interdependence of scsi_lib.c with it's ULD's. Will 
make it hard for scsi_lib to change without touching ULD's.
(And there are lots of scheduled changes :-))

What about below approach? 
What I tried to do is keep scsi_lib private, export a more
simple API for ULD's. And keep common code common.
The code was compiled and booted but I did not do any error 
injection and/or low memory condition testing.

[PATCH 3/3] move ULD attachment into the prep function


  - scsi_lib.c prep_fn will only support blk_pc_commands.
  - Let ULD's that support blk_fs_request() overload prep_fn.
    sd.c and sr.c will do so.
  - scsi_lib exports a scsi_prep_cmnd() helper that will take
    a request and allocate and return a struct scsi_cmnd.
  - If ULD decides it wants to fail the command allocated above
    It must call a new export scsi_prep_return() to cancel the
    request and return the command to free store.

git-diff
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 60cbe37..c8ed932 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1128,8 +1128,6 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd;
-	struct scsi_driver *drv;
-	int ret;
 
 	/*
 	 * Filesystem requests must transfer data.
@@ -1140,24 +1138,11 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
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
 
-static int scsi_prep_fn(struct request_queue *q, struct request *req)
+struct scsi_cmnd *scsi_prep_cmnd(struct request_queue *q, struct request *req,
+                                 int *pRet)
 {
 	struct scsi_device *sdev = q->queuedata;
 	int ret = BLKPREP_OK;
@@ -1231,6 +1216,16 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 	}
 
  out:
+	*pRet = ret;
+	return req->special;
+}
+EXPORT_SYMBOL(scsi_prep_cmnd);
+
+int scsi_prep_return(struct request_queue *q, struct request *req,
+                     struct scsi_cmnd *cmd, int ret)
+{
+	struct scsi_device *sdev = q->queuedata;
+
 	switch (ret) {
 	case BLKPREP_KILL:
 		req->errors = DID_NO_CONNECT << 16;
@@ -1248,8 +1243,25 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 		req->cmd_flags |= REQ_DONTPREP;
 	}
 
+	if (cmd) {
+		scsi_release_buffers(cmd);
+		scsi_put_command(cmd);
+	}
 	return ret;
 }
+EXPORT_SYMBOL(scsi_prep_return);
+
+static int scsi_prep_fn(struct request_queue *q, struct request *req)
+{
+	int ret = BLKPREP_KILL;
+	struct scsi_cmnd *cmd = NULL;
+	if (blk_pc_request(req))
+		cmd = scsi_prep_cmnd(q, req, &ret);
+	if (!cmd || ret) {
+		return scsi_prep_return(q, req, cmd, ret);
+	}
+	return BLKPREP_OK;
+}
 
 /*
  * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c6116f..a2381c8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -240,7 +240,6 @@ static struct scsi_driver sd_template = {
 		.shutdown	= sd_shutdown,
 	},
 	.rescan			= sd_rescan,
-	.init_command		= sd_init_command,
 };
 
 /*
@@ -331,14 +330,22 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
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
+	int ret = BLKPREP_KILL;
+
+	SCpnt = scsi_prep_cmnd(q, rq, &ret);
+	if (!SCpnt || ret) {
+		goto error;
+	}
+	if (blk_pc_request(rq))
+		return BLKPREP_OK;
 
 	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
 					"sd_init_command: block=%llu, "
@@ -353,7 +360,7 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 						rq->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
 						"Retry with 0x%p\n", SCpnt));
-		return 0;
+		goto error;
 	}
 
 	if (sdp->changed) {
@@ -362,8 +369,9 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 		 * the changed bit has been reset
 		 */
 		/* printk("SCSI disk has been changed. Prohibiting further I/O.\n"); */
-		return 0;
+		goto error;
 	}
+
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
 					(unsigned long long)block));
 
@@ -382,7 +390,7 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 		if ((block & 1) || (rq->nr_sectors & 1)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
-			return 0;
+			goto error;
 		} else {
 			block = block >> 1;
 			this_count = this_count >> 1;
@@ -392,7 +400,7 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 		if ((block & 3) || (rq->nr_sectors & 3)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
-			return 0;
+			goto error;
 		} else {
 			block = block >> 2;
 			this_count = this_count >> 2;
@@ -402,7 +410,7 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 		if ((block & 7) || (rq->nr_sectors & 7)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
-			return 0;
+			goto error;
 		} else {
 			block = block >> 3;
 			this_count = this_count >> 3;
@@ -410,7 +418,7 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 	}
 	if (rq_data_dir(rq) == WRITE) {
 		if (!sdp->writeable) {
-			return 0;
+			goto error;
 		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
@@ -419,7 +427,7 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
 		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
-		return 0;
+		goto error;
 	}
 
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
@@ -470,7 +478,7 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 			 */
 			scmd_printk(KERN_ERR, SCpnt,
 				    "FUA write on READ/WRITE(6) drive\n");
-			return 0;
+			goto error;
 		}
 
 		SCpnt->cmnd[1] |= (unsigned char) ((block >> 16) & 0x1f);
@@ -501,7 +509,9 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
 	 * This indicates that the command is ready from our end to be
 	 * queued.
 	 */
-	return 1;
+	return BLKPREP_OK;
+ error:
+	return scsi_prep_return(q, rq, SCpnt, ret);
 }
 
 /**
@@ -1669,6 +1679,7 @@ static int sd_probe(struct device *dev)
 
 	sd_revalidate_disk(gd);
 
+	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
 	blk_queue_issue_flush_fn(sdp->request_queue, sd_issue_flush);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 902eb11..2b727d6 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -78,7 +78,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
-static int sr_init_command(struct scsi_cmnd *);
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -87,7 +86,6 @@ static struct scsi_driver sr_template = {
 		.probe		= sr_probe,
 		.remove		= sr_remove,
 	},
-	.init_command		= sr_init_command,
 };
 
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
@@ -296,19 +294,30 @@ static void rw_intr(struct scsi_cmnd * SCpnt)
 	scsi_io_completion(SCpnt, good_bytes);
 }
 
-static int sr_init_command(struct scsi_cmnd * SCpnt)
+static int sr_prep_fn(struct request_queue *q, struct request *rq)
 {
 	int block=0, this_count, s_size, timeout = SR_TIMEOUT;
-	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
+	struct scsi_cd *cd;
+	struct scsi_cmnd *SCpnt;
+	int ret = BLKPREP_KILL;
+
+	SCpnt = scsi_prep_cmnd(q, rq, &ret);
+	if (!SCpnt || ret) {
+		goto error;
+	}
+	if (blk_pc_request(rq))
+		return BLKPREP_OK;
+
+	cd = scsi_cd(rq->rq_disk);
 
 	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %s, block = %d\n",
 				cd->disk->disk_name, block));
 
 	if (!cd->device || !scsi_device_online(cd->device)) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n",
-					SCpnt->request->nr_sectors));
+					rq->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
-		return 0;
+		goto error;
 	}
 
 	if (cd->device->changed) {
@@ -316,7 +325,7 @@ static int sr_init_command(struct scsi_cmnd * SCpnt)
 		 * quietly refuse to do anything to a changed disc until the
 		 * changed bit has been reset
 		 */
-		return 0;
+		goto error;
 	}
 
 	/*
@@ -333,21 +342,21 @@ static int sr_init_command(struct scsi_cmnd * SCpnt)
 
 	if (s_size != 512 && s_size != 1024 && s_size != 2048) {
 		scmd_printk(KERN_ERR, SCpnt, "bad sector size %d\n", s_size);
-		return 0;
+		goto error;
 	}
 
-	if (rq_data_dir(SCpnt->request) == WRITE) {
+	if (rq_data_dir(rq) == WRITE) {
 		if (!cd->device->writeable)
-			return 0;
+			goto error;
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
+		goto error;
 	}
 
 	{
@@ -368,10 +377,10 @@ static int sr_init_command(struct scsi_cmnd * SCpnt)
 	/*
 	 * request doesn't start on hw block boundary, add scatter pads
 	 */
-	if (((unsigned int)SCpnt->request->sector % (s_size >> 9)) ||
+	if (((unsigned int)rq->sector % (s_size >> 9)) ||
 	    (SCpnt->request_bufflen % s_size)) {
 		scmd_printk(KERN_NOTICE, SCpnt, "unaligned transfer\n");
-		return 0;
+		goto error;
 	}
 
 	this_count = (SCpnt->request_bufflen >> 9) / (s_size >> 9);
@@ -379,12 +388,12 @@ static int sr_init_command(struct scsi_cmnd * SCpnt)
 
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
@@ -419,7 +428,9 @@ static int sr_init_command(struct scsi_cmnd * SCpnt)
 	 * This indicates that the command is ready from our end to be
 	 * queued.
 	 */
-	return 1;
+	return BLKPREP_OK;
+ error:
+	return scsi_prep_return(q, rq, SCpnt, ret);
 }
 
 static int sr_block_open(struct inode *inode, struct file *file)
@@ -590,6 +601,7 @@ static int sr_probe(struct device *dev)
 
 	/* FIXME: need to handle a get_capabilities failure properly ?? */
 	get_capabilities(cd);
+	blk_queue_prep_rq(sdev->request_queue, sr_prep_fn);
 	sr_vendor_init(cd);
 
 	disk->driverfs_dev = &sdev->sdev_gendev;
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 3465f31..56df2ed 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -11,7 +11,6 @@ struct scsi_driver {
 	struct module		*owner;
 	struct device_driver	gendrv;
 
-	int (*init_command)(struct scsi_cmnd *);
 	void (*rescan)(struct device *);
 };
 #define to_scsi_driver(drv) \
@@ -25,4 +24,9 @@ extern int scsi_register_interface(struct class_interface *);
 #define scsi_unregister_interface(intf) \
 	class_interface_unregister(intf)
 
+extern struct scsi_cmnd *scsi_prep_cmnd(struct request_queue *, 
+                                        struct request *req, int *pRet);
+extern int scsi_prep_return(struct request_queue *, struct request *req,
+                            struct scsi_cmnd *cmd, int ret);
+
 #endif /* _SCSI_SCSI_DRIVER_H */
diff --git a/include/scsi/sd.h b/include/scsi/sd.h
index ce02ad1..aa1e716 100644
--- a/include/scsi/sd.h
+++ b/include/scsi/sd.h
@@ -55,7 +55,6 @@ static void sd_shutdown(struct device *dev);
 static int sd_suspend(struct device *dev, pm_message_t state);
 static int sd_resume(struct device *dev);
 static void sd_rescan(struct device *);
-static int  sd_init_command(struct scsi_cmnd *);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct class_device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);

