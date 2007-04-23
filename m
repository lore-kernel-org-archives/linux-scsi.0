From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 3/7] scsi: expose AN to user space
Date: Mon, 23 Apr 2007 16:59:57 -0700
Message-ID: <20070423165957.e0d6a589.kristen.c.accardi@intel.com>
References: <20070424074856.005152262@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030858AbXDXACa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Apr 2007 20:02:30 -0400
In-Reply-To: <20070424074856.005152262@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com, Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Get media change notification capability from disk and pass this information
to genhd by setting appropriate flag.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/scsi/sr.c
===================================================================
--- 2.6-git.orig/drivers/scsi/sr.c
+++ 2.6-git/drivers/scsi/sr.c
@@ -601,6 +601,8 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
+	if (sdev->media_change_notify)
+		disk->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
 	add_disk(disk);
 
 	sdev_printk(KERN_DEBUG, sdev,
Index: 2.6-git/include/scsi/scsi_device.h
===================================================================
--- 2.6-git.orig/include/scsi/scsi_device.h
+++ 2.6-git/include/scsi/scsi_device.h
@@ -124,7 +124,7 @@ struct scsi_device {
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
-
+	unsigned media_change_notify:1; /* dev supports async media notify */
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
Index: 2.6-git/drivers/scsi/sd.c
===================================================================
--- 2.6-git.orig/drivers/scsi/sd.c
+++ 2.6-git/drivers/scsi/sd.c
@@ -1706,6 +1706,9 @@ static int sd_probe(struct device *dev)
 	if (sdp->removable)
 		gd->flags |= GENHD_FL_REMOVABLE;
 
+	if (sdp->media_change_notify)
+		gd->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
+
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 

-- 
