From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] sd: disentangle barriers in SCSI
Date: Fri, 03 Aug 2007 16:41:11 -0500
Message-ID: <1186177271.5493.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58765 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761891AbXHCVlO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 17:41:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Tejun Heo <htejun@gmail.com>

Our current implementation has a generic set of barrier functions that
go through the SCSI driver model.  Realistically, this is unnecessary,
because the only device that can use barriers (sd) can set the flush
functions up at probe or revalidate time.  This patch pulls the barrier
functions out of the mid layer and scsi driver model and relocates them
directly in sd.

James

Index: BUILD-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_lib.c	2007-08-03 16:00:43.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_lib.c	2007-08-03 16:01:08.000000000 -0500
@@ -1038,22 +1038,6 @@ static int scsi_init_io(struct scsi_cmnd
 	return BLKPREP_KILL;
 }
 
-static int scsi_issue_flush_fn(struct request_queue *q, struct gendisk *disk,
-			       sector_t *error_sector)
-{
-	struct scsi_device *sdev = q->queuedata;
-	struct scsi_driver *drv;
-
-	if (sdev->sdev_state != SDEV_RUNNING)
-		return -ENXIO;
-
-	drv = *(struct scsi_driver **) disk->private_data;
-	if (drv->issue_flush)
-		return drv->issue_flush(&sdev->sdev_gendev, error_sector);
-
-	return -EOPNOTSUPP;
-}
-
 static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 		struct request *req)
 {
@@ -1596,7 +1580,6 @@ struct request_queue *scsi_alloc_queue(s
 		return NULL;
 
 	blk_queue_prep_rq(q, scsi_prep_fn);
-	blk_queue_issue_flush_fn(q, scsi_issue_flush_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	blk_queue_protocol(q, BLK_PROTOCOL_SCSI);
 	return q;
Index: BUILD-2.6/drivers/scsi/sd.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/sd.c	2007-08-03 16:00:37.000000000 -0500
+++ BUILD-2.6/drivers/scsi/sd.c	2007-08-03 16:39:13.000000000 -0500
@@ -241,7 +241,6 @@ static struct scsi_driver sd_template = 
 	},
 	.rescan			= sd_rescan,
 	.init_command		= sd_init_command,
-	.issue_flush		= sd_issue_flush,
 };
 
 /*
@@ -800,10 +799,17 @@ static int sd_sync_cache(struct scsi_dis
 	return 0;
 }
 
-static int sd_issue_flush(struct device *dev, sector_t *error_sector)
+static int sd_issue_flush(struct request_queue *q, struct gendisk *disk,
+			  sector_t *error_sector)
 {
 	int ret = 0;
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_device *sdp = q->queuedata;
+	struct scsi_disk *sdkp;
+
+	if (sdp->sdev_state != SDEV_RUNNING)
+		return -ENXIO;
+
+	sdkp = scsi_disk_get_from_dev(&sdp->sdev_gendev);
 
 	if (!sdkp)
                return -ENODEV;
@@ -1663,6 +1669,8 @@ static int sd_probe(struct device *dev)
 
 	sd_revalidate_disk(gd);
 
+	blk_queue_issue_flush_fn(sdp->request_queue, sd_issue_flush);
+
 	gd->driverfs_dev = &sdp->sdev_gendev;
 	gd->flags = GENHD_FL_DRIVERFS;
 	if (sdp->removable)
Index: BUILD-2.6/include/scsi/scsi_driver.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_driver.h	2007-08-03 16:00:30.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_driver.h	2007-08-03 16:00:50.000000000 -0500
@@ -13,8 +13,6 @@ struct scsi_driver {
 
 	int (*init_command)(struct scsi_cmnd *);
 	void (*rescan)(struct device *);
-	int (*issue_flush)(struct device *, sector_t *);
-	int (*prepare_flush)(struct request_queue *, struct request *);
 };
 #define to_scsi_driver(drv) \
 	container_of((drv), struct scsi_driver, gendrv)
Index: BUILD-2.6/include/scsi/sd.h
===================================================================
--- BUILD-2.6.orig/include/scsi/sd.h	2007-08-03 16:06:29.000000000 -0500
+++ BUILD-2.6/include/scsi/sd.h	2007-08-03 16:06:44.000000000 -0500
@@ -56,8 +56,6 @@ static int sd_suspend(struct device *dev
 static int sd_resume(struct device *dev);
 static void sd_rescan(struct device *);
 static int  sd_init_command(struct scsi_cmnd *);
-static int  sd_issue_flush(struct device *, sector_t *);
-static void sd_prepare_flush(struct request_queue *, struct request *);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct class_device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);


