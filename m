From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] fix LLD module refcounting in sr.c
Date: 10 May 2004 16:20:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084224040.2659.400.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:44977 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261918AbUEJVUq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2004 17:20:46 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

The patch to close all the open/close/hotplug races in sr left the
module refcounting broken so that the ULD housing the CD device now
can't be removed until the device itself is removed.

This patch (structurally identical to the one for sd.c to perform the
same function) fixes the module refcounting.

James

===== drivers/scsi/sr.c 1.105 vs edited =====
--- 1.105/drivers/scsi/sr.c	Mon Apr 12 20:27:08 2004
+++ edited/drivers/scsi/sr.c	Mon May 10 16:12:15 2004
@@ -138,7 +138,15 @@
 		goto out;
 	cd = scsi_cd(disk);
 	if (!kref_get(&cd->kref))
-		cd = NULL;
+		goto out_null;
+	if (scsi_device_get(cd->device))
+		goto out_put;
+	goto out;
+
+ out_put:
+	kref_put(&cd->kref);
+ out_null:
+	cd = NULL;
  out:
 	up(&sr_ref_sem);
 	return cd;
@@ -147,6 +155,7 @@
 static inline void scsi_cd_put(struct scsi_cd *cd)
 {
 	down(&sr_ref_sem);
+	scsi_device_put(cd->device);
 	kref_put(&cd->kref);
 	up(&sr_ref_sem);
 }
@@ -558,13 +567,10 @@
 	if (sdev->type != TYPE_ROM && sdev->type != TYPE_WORM)
 		goto fail;
 
-	if ((error = scsi_device_get(sdev)) != 0)
-		goto fail;
-
 	error = -ENOMEM;
 	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
 	if (!cd)
-		goto fail_put_sdev;
+		goto fail;
 	memset(cd, 0, sizeof(*cd));
 
 	kref_init(&cd->kref, sr_kref_release);
@@ -637,8 +643,6 @@
 	put_disk(disk);
 fail_free:
 	kfree(cd);
-fail_put_sdev:
-	scsi_device_put(sdev);
 fail:
 	return error;
 }
@@ -926,7 +930,6 @@
 static void sr_kref_release(struct kref *kref)
 {
 	struct scsi_cd *cd = container_of(kref, struct scsi_cd, kref);
-	struct scsi_device *sdev = cd->device;
 	struct gendisk *disk = cd->disk;
 
 	spin_lock(&sr_index_lock);
@@ -940,8 +943,6 @@
 	put_disk(disk);
 
 	kfree(cd);
-
-	scsi_device_put(sdev);
 }
 
 static int sr_remove(struct device *dev)
@@ -950,7 +951,9 @@
 
 	del_gendisk(cd->disk);
 
-	scsi_cd_put(cd);
+	down(&sr_ref_sem);
+	kref_put(&cd->kref);
+	up(&sr_ref_sem);
 
 	return 0;
 }

