From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4 v2] scsi: reintroduce scsi_driver.init_command
Date: Mon, 31 Mar 2014 12:00:42 -0700
Message-ID: <20140331190042.GA8444@infradead.org>
References: <1395936862-6938-1-git-send-email-hch@lst.de>
 <1395936862-6938-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaCaTAq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2014 15:00:46 -0400
Content-Disposition: inline
In-Reply-To: <1395936862-6938-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

Move control of the prep_fn back from the ULDs into the scsi layer.  Besides
cleaning up the code this also prepares for usinng blk-mq, which doesn't
have equivalent functionality to the prep_fn method and requires the driver
to provide just a single I/O submission method.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c    |   66 ++++++++++++++++++++++++++------------------
 drivers/scsi/sd.c          |   44 ++++++++++-------------------
 drivers/scsi/sr.c          |   19 ++++---------
 include/scsi/scsi_driver.h |    8 ++----
 4 files changed, 61 insertions(+), 76 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a73751b..ed81fc3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1071,15 +1071,7 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 
 int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 {
-	struct scsi_cmnd *cmd;
-	int ret = scsi_prep_state_check(sdev, req);
-
-	if (ret != BLKPREP_OK)
-		return ret;
-
-	cmd = scsi_get_cmd_from_req(sdev, req);
-	if (unlikely(!cmd))
-		return BLKPREP_DEFER;
+	struct scsi_cmnd *cmd = req->special;
 
 	/*
 	 * BLOCK_PC requests may transfer data, in which case they must
@@ -1123,15 +1115,11 @@ EXPORT_SYMBOL(scsi_setup_blk_pc_cmnd);
  */
 int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 {
-	struct scsi_cmnd *cmd;
-	int ret = scsi_prep_state_check(sdev, req);
-
-	if (ret != BLKPREP_OK)
-		return ret;
+	struct scsi_cmnd *cmd = req->special;
 
 	if (unlikely(sdev->scsi_dh_data && sdev->scsi_dh_data->scsi_dh
 			 && sdev->scsi_dh_data->scsi_dh->prep_fn)) {
-		ret = sdev->scsi_dh_data->scsi_dh->prep_fn(sdev, req);
+		int ret = sdev->scsi_dh_data->scsi_dh->prep_fn(sdev, req);
 		if (ret != BLKPREP_OK)
 			return ret;
 	}
@@ -1141,16 +1129,13 @@ int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	 */
 	BUG_ON(!req->nr_phys_segments);
 
-	cmd = scsi_get_cmd_from_req(sdev, req);
-	if (unlikely(!cmd))
-		return BLKPREP_DEFER;
-
 	memset(cmd->cmnd, 0, BLK_MAX_CDB);
 	return scsi_init_io(cmd, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(scsi_setup_fs_cmnd);
 
-int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
+static int
+scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 {
 	int ret = BLKPREP_OK;
 
@@ -1202,9 +1187,9 @@ int scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(scsi_prep_state_check);
 
-int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
+static int
+scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 {
 	struct scsi_device *sdev = q->queuedata;
 
@@ -1235,18 +1220,44 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 
 	return ret;
 }
-EXPORT_SYMBOL(scsi_prep_return);
 
-int scsi_prep_fn(struct request_queue *q, struct request *req)
+static int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct scsi_device *sdev = q->queuedata;
-	int ret = BLKPREP_KILL;
+	struct scsi_cmnd *cmd;
+	int ret;
 
-	if (req->cmd_type == REQ_TYPE_BLOCK_PC)
+	ret = scsi_prep_state_check(sdev, req);
+	if (ret != BLKPREP_OK)
+		goto out;
+
+	cmd = scsi_get_cmd_from_req(sdev, req);
+	if (unlikely(!cmd)) {
+		ret = BLKPREP_DEFER;
+		goto out;
+	}
+
+	if (req->cmd_type == REQ_TYPE_FS)
+		ret = scsi_cmd_to_driver(cmd)->init_command(cmd);
+	else if (req->cmd_type == REQ_TYPE_BLOCK_PC)
 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
+	else
+		ret = BLKPREP_KILL;
+
+out:
 	return scsi_prep_return(q, req, ret);
 }
-EXPORT_SYMBOL(scsi_prep_fn);
+
+static void scsi_unprep_fn(struct request_queue *q, struct request *req)
+{
+	if (req->cmd_type == REQ_TYPE_FS) {
+		struct scsi_cmnd *cmd = req->special;
+		struct scsi_driver *drv = scsi_cmd_to_driver(cmd);
+
+		if (drv->uninit_command)
+			drv->uninit_command(cmd);
+	}
+}
 
 /*
  * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
@@ -1667,6 +1678,7 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 		return NULL;
 
 	blk_queue_prep_rq(q, scsi_prep_fn);
+	blk_queue_unprep_rq(q, scsi_unprep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	blk_queue_rq_timed_out(q, scsi_times_out);
 	blk_queue_lld_busy(q, scsi_lld_busy);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 89e6c04..d99cb3f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -109,6 +109,8 @@ static int sd_suspend_system(struct device *);
 static int sd_suspend_runtime(struct device *);
 static int sd_resume(struct device *);
 static void sd_rescan(struct device *);
+static int sd_init_command(struct scsi_cmnd *SCpnt);
+static void sd_uninit_command(struct scsi_cmnd *SCpnt);
 static int sd_done(struct scsi_cmnd *);
 static int sd_eh_action(struct scsi_cmnd *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
@@ -503,6 +505,8 @@ static struct scsi_driver sd_template = {
 		.pm		= &sd_pm_ops,
 	},
 	.rescan			= sd_rescan,
+	.init_command		= sd_init_command,
+	.uninit_command		= sd_uninit_command,
 	.done			= sd_done,
 	.eh_action		= sd_eh_action,
 };
@@ -838,9 +842,9 @@ static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 	return scsi_setup_blk_pc_cmnd(sdp, rq);
 }
 
-static void sd_unprep_fn(struct request_queue *q, struct request *rq)
+static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
-	struct scsi_cmnd *SCpnt = rq->special;
+	struct request *rq = SCpnt->request;
 
 	if (rq->cmd_flags & REQ_DISCARD) {
 		free_page((unsigned long)rq->buffer);
@@ -853,18 +857,10 @@ static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 	}
 }
 
-/**
- *	sd_prep_fn - build a scsi (read or write) command from
- *	information in the request structure.
- *	@SCpnt: pointer to mid-level's per scsi command structure that
- *	contains request and into which the scsi command is written
- *
- *	Returns 1 if successful and 0 if error (or cannot be done now).
- **/
-static int sd_prep_fn(struct request_queue *q, struct request *rq)
+static int sd_init_command(struct scsi_cmnd *SCpnt)
 {
-	struct scsi_cmnd *SCpnt;
-	struct scsi_device *sdp = q->queuedata;
+	struct request *rq = SCpnt->request;
+	struct scsi_device *sdp = SCpnt->device;
 	struct gendisk *disk = rq->rq_disk;
 	struct scsi_disk *sdkp;
 	sector_t block = blk_rq_pos(rq);
@@ -886,12 +882,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	} else if (rq->cmd_flags & REQ_FLUSH) {
 		ret = scsi_setup_flush_cmnd(sdp, rq);
 		goto out;
-	} else if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
-		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
-		goto out;
-	} else if (rq->cmd_type != REQ_TYPE_FS) {
-		ret = BLKPREP_KILL;
-		goto out;
 	}
 	ret = scsi_setup_fs_cmnd(sdp, rq);
 	if (ret != BLKPREP_OK)
@@ -903,11 +893,10 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	 * is used for a killable error condition */
 	ret = BLKPREP_KILL;
 
-	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
-					"sd_prep_fn: block=%llu, "
-					"count=%d\n",
-					(unsigned long long)block,
-					this_count));
+	SCSI_LOG_HLQUEUE(1,
+		scmd_printk(KERN_INFO, SCpnt,
+			"%s: block=%llu, count=%d\n",
+			__func__, (unsigned long long)block, this_count));
 
 	if (!sdp || !scsi_device_online(sdp) ||
 	    block + blk_rq_sectors(rq) > get_capacity(disk)) {
@@ -1127,7 +1116,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	 */
 	ret = BLKPREP_OK;
  out:
-	return scsi_prep_return(q, rq, ret);
+	return ret;
 }
 
 /**
@@ -2878,9 +2867,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_revalidate_disk(gd);
 
-	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
-	blk_queue_unprep_rq(sdp->request_queue, sd_unprep_fn);
-
 	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_EXT_DEVT;
 	if (sdp->removable) {
@@ -3027,8 +3013,6 @@ static int sd_remove(struct device *dev)
 	scsi_autopm_get_device(sdkp->device);
 
 	async_synchronize_full_domain(&scsi_sd_probe_domain);
-	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
-	blk_queue_unprep_rq(sdkp->device->request_queue, NULL);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 40d8592..93cbd36 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -79,6 +79,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
+static int sr_init_command(struct scsi_cmnd *SCpnt);
 static int sr_done(struct scsi_cmnd *);
 static int sr_runtime_suspend(struct device *dev);
 
@@ -94,6 +95,7 @@ static struct scsi_driver sr_template = {
 		.remove		= sr_remove,
 		.pm		= &sr_pm_ops,
 	},
+	.init_command		= sr_init_command,
 	.done			= sr_done,
 };
 
@@ -378,21 +380,14 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 	return good_bytes;
 }
 
-static int sr_prep_fn(struct request_queue *q, struct request *rq)
+static int sr_init_command(struct scsi_cmnd *SCpnt)
 {
 	int block = 0, this_count, s_size;
 	struct scsi_cd *cd;
-	struct scsi_cmnd *SCpnt;
-	struct scsi_device *sdp = q->queuedata;
+	struct request *rq = SCpnt->request;
+	struct scsi_device *sdp = SCpnt->device;
 	int ret;
 
-	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
-		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
-		goto out;
-	} else if (rq->cmd_type != REQ_TYPE_FS) {
-		ret = BLKPREP_KILL;
-		goto out;
-	}
 	ret = scsi_setup_fs_cmnd(sdp, rq);
 	if (ret != BLKPREP_OK)
 		goto out;
@@ -517,7 +512,7 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	 */
 	ret = BLKPREP_OK;
  out:
-	return scsi_prep_return(q, rq, ret);
+	return ret;
 }
 
 static int sr_block_open(struct block_device *bdev, fmode_t mode)
@@ -718,7 +713,6 @@ static int sr_probe(struct device *dev)
 
 	/* FIXME: need to handle a get_capabilities failure properly ?? */
 	get_capabilities(cd);
-	blk_queue_prep_rq(sdev->request_queue, sr_prep_fn);
 	sr_vendor_init(cd);
 
 	disk->driverfs_dev = &sdev->sdev_gendev;
@@ -993,7 +987,6 @@ static int sr_remove(struct device *dev)
 
 	scsi_autopm_get_device(cd->device);
 
-	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
 	mutex_lock(&sr_ref_mutex);
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 20fdfc2..b507729 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -6,15 +6,14 @@
 struct module;
 struct scsi_cmnd;
 struct scsi_device;
-struct request;
-struct request_queue;
-
 
 struct scsi_driver {
 	struct module		*owner;
 	struct device_driver	gendrv;
 
 	void (*rescan)(struct device *);
+	int (*init_command)(struct scsi_cmnd *);
+	void (*uninit_command)(struct scsi_cmnd *);
 	int (*done)(struct scsi_cmnd *);
 	int (*eh_action)(struct scsi_cmnd *, int);
 };
@@ -31,8 +30,5 @@ extern int scsi_register_interface(struct class_interface *);
 
 int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req);
 int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req);
-int scsi_prep_state_check(struct scsi_device *sdev, struct request *req);
-int scsi_prep_return(struct request_queue *q, struct request *req, int ret);
-int scsi_prep_fn(struct request_queue *, struct request *);
 
 #endif /* _SCSI_SCSI_DRIVER_H */
-- 
1.7.10.4

