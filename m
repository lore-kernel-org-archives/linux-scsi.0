From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Patch?: Eliminate scsi_disk.driver from 2.6.0-test5
Date: Mon, 15 Sep 2003 15:47:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200309152247.h8FMlvA12498@freya.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h-69-3-93-149.SNVACAID.covad.net ([69.3.93.149]:47807 "EHLO
	freya.yggdrasil.com") by vger.kernel.org with ESMTP id S261725AbTIOXWa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2003 19:22:30 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

	The following is a completely untested patch to
linux-2.6.0-test5/drivers/sd.c to eliminate scsi_disk.driver.
I'm out of town right now, so I can't readily test it.  I would
appreciate it if someone would give this patch a try and
submit it for integration if it does work.

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Milpitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America


--- linux-2.6.0-test5/drivers/scsi/sd.c	2003-09-08 12:50:19.000000000 -0700
+++ linux/drivers/scsi/sd.c	2003-09-15 15:36:50.000000000 -0700
@@ -75,7 +75,6 @@
 #define SD_MAX_RETRIES		5
 
 struct scsi_disk {
-	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
 	struct gendisk	*disk;
 	unsigned int	openers;	/* protected by BKL for now, yuck */
@@ -130,7 +129,7 @@
 
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 {
-	return container_of(disk->private_data, struct scsi_disk, driver);
+	return disk->private_data;
 }
 
 /**
@@ -1271,7 +1270,6 @@
 	spin_unlock(&sd_index_lock);
 
 	sdkp->device = sdp;
-	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
 	sdkp->index = index;
 	sdkp->openers = 0;
@@ -1290,7 +1288,7 @@
 
 	strcpy(gd->devfs_name, sdp->devfs_name);
 
-	gd->private_data = &sdkp->driver;
+	gd->private_data = sdkp;
 
 	sd_revalidate_disk(gd);
 
