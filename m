From: Oliver Neukum <oneukum@suse.de>
Subject: SCSI:implement PM for sr
Date: Mon, 16 Jan 2012 09:41:41 +0100
Message-ID: <201201160941.41334.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab2APIjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2012 03:39:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

>From e81a6204b9c53b1e6a2817a96f0e1b44e3c87fb4 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Mon, 16 Jan 2012 09:38:04 +0100
Subject: [PATCH] SCSI:implement PM for sr

This implements basic power management for SCSI CDs.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/sr.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..91b545b 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -508,16 +508,29 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 
 static int sr_block_open(struct block_device *bdev, fmode_t mode)
 {
+	struct scsi_device *sdev;
 	struct scsi_cd *cd;
 	int ret = -ENXIO;
+	int err;
 
 	mutex_lock(&sr_mutex);
 	cd = scsi_cd_get(bdev->bd_disk);
+	sdev = cd->device;
+
+	err = scsi_autopm_get_device(sdev);
+	if (err) {
+		ret = -EIO;
+		goto err_out;
+	}
+
 	if (cd) {
 		ret = cdrom_open(&cd->cdi, bdev, mode);
-		if (ret)
+		if (ret) {
 			scsi_cd_put(cd);
+			scsi_autopm_put_device(sdev);
+		}
 	}
+err_out:
 	mutex_unlock(&sr_mutex);
 	return ret;
 }
@@ -525,9 +538,12 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 static int sr_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
+	struct scsi_device *sdev = cd->device;
+
 	mutex_lock(&sr_mutex);
 	cdrom_release(&cd->cdi, mode);
 	scsi_cd_put(cd);
+	scsi_autopm_put_device(sdev);
 	mutex_unlock(&sr_mutex);
 	return 0;
 }
@@ -615,6 +631,11 @@ static int sr_open(struct cdrom_device_info *cdi, int purpose)
 	struct scsi_device *sdev = cd->device;
 	int retval;
 
+	retval = scsi_autopm_get_device(sdev);
+	if (retval) {
+		retval = -EIO;
+		goto pm_error_out;
+	}
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
@@ -626,16 +647,19 @@ static int sr_open(struct cdrom_device_info *cdi, int purpose)
 	return 0;
 
 error_out:
+	scsi_autopm_put_device(sdev);
+pm_error_out:
 	return retval;	
 }
 
 static void sr_release(struct cdrom_device_info *cdi)
 {
 	struct scsi_cd *cd = cdi->handle;
+	struct scsi_device *sdev = cd->device;
 
 	if (cd->device->sector_size > 2048)
 		sr_set_blocklength(cd, 2048);
-
+	scsi_autopm_put_device(sdev);
 }
 
 static int sr_probe(struct device *dev)
@@ -715,6 +739,7 @@ static int sr_probe(struct device *dev)
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
+	scsi_autopm_put_device(sdev);
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
@@ -964,7 +989,9 @@ static void sr_kref_release(struct kref *kref)
 static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
+	struct scsi_device *sdev = cd->device;
 
+	scsi_autopm_get_device(sdev);
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
-- 
1.7.1

