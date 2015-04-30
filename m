From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 9/9] scsi_dh: don't allow to detach device handlers at runtime
Date: Thu, 30 Apr 2015 19:32:31 +0200
Message-ID: <1430415151-30948-10-git-send-email-hch@lst.de>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57104 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbD3Rel (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2015 13:34:41 -0400
In-Reply-To: <1430415151-30948-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

The I/O submission and completion pathes call into the device handler
without any synchronization agains detachment.  So disallow detaching
device handlers at runtime.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 0d6ab33..1e945aa 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -142,17 +142,6 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
 }
 
 /*
- * scsi_dh_handler_detach - Detach a device handler from a device
- * @sdev - SCSI device the device handler should be detached from
- */
-static void scsi_dh_handler_detach(struct scsi_device *sdev)
-{
-	sdev->handler->detach(sdev);
-	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", sdev->handler->name);
-	module_put(sdev->handler->module);
-}
-
-/*
  * Functions for sysfs attribute 'dh_state'
  */
 static ssize_t
@@ -179,8 +168,9 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 			/*
 			 * Detach from a device handler
 			 */
-			scsi_dh_handler_detach(sdev);
-			err = 0;
+			sdev_printk(KERN_WARNING, sdev,
+				"can't detach handler %s!\n", buf);
+			err = -EINVAL;
 		} else if (!strncmp(buf, "activate", 8)) {
 			/*
 			 * Activate a device handler
@@ -230,8 +220,11 @@ int scsi_dh_add_device(struct scsi_device *sdev)
 
 void scsi_dh_remove_device(struct scsi_device *sdev)
 {
-	if (sdev->handler)
-		scsi_dh_handler_detach(sdev);
+	if (sdev->handler) {
+		sdev->handler->detach(sdev);
+		module_put(sdev->handler->module);
+	}
+
 	device_remove_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
 }
 
@@ -393,15 +386,19 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 		goto out_put_device;
 	}
 
+	if (err)
+		return err;
+
 	if (sdev->handler) {
 		if (sdev->handler == scsi_dh)
 			goto out_put_device;
 
 		sdev_printk(KERN_WARNING, sdev,
-			"replacing device handler %s with %s!, "
+			"can't replace device handler %s with %s!, "
 			"please fix the device handler tables.\n",
 			sdev->handler->name, name);
-		scsi_dh_handler_detach(sdev);
+		err = -EINVAL;
+		goto out_put_device;
 	}
 
 	err = scsi_dh_handler_attach(sdev, scsi_dh);
-- 
1.9.1

