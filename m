From: James.Smart@Emulex.Com
Subject: [Patch] Fix Suspend I/O block/unblock patch
Date: Thu, 14 Oct 2004 10:31:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F20B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:10173 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S265477AbUJNObN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 10:31:13 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i9EEVBgI029768
	for <linux-scsi@vger.kernel.org>; Thu, 14 Oct 2004 07:31:12 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In further testing of the fc block/unblock patch, the recommendation to use device_for_each_child() instead of shost_for_each_device() in the target functions was not a good one. The calling sequences on the unblock path, which may eventually block, are not good for device_for_each_child(), which takes and holds a semaphore.

This patch reverts to using shost_for_each_device(), which takes the proper locks and performs ref counting. Although the block portion doesn't encounter the problem, it too was converted for the sake of consistency.  The patch also makes one other minor change - allowing an offline state change to occur if blocked.

-- James


This patch is specific to the scsi-target-2.6 bitkeeper tree.

diff -uNr scsi-target-2.6/drivers/scsi/scsi_lib.c scsi-target-2.6.patch/drivers/scsi/scsi_lib.c
--- scsi-target-2.6/drivers/scsi/scsi_lib.c	2004-10-14 08:26:13.776167096 -0400
+++ scsi-target-2.6.patch/drivers/scsi/scsi_lib.c	2004-10-14 08:26:13.778166792 -0400
@@ -1664,6 +1664,7 @@
 		case SDEV_CREATED:
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
+		case SDEV_BLOCK:
 			break;
 		default:
 			goto illegal;
diff -uNr scsi-target-2.6/drivers/scsi/scsi_transport_fc.c scsi-target-2.6.patch/drivers/scsi/scsi_transport_fc.c
--- scsi-target-2.6/drivers/scsi/scsi_transport_fc.c	2004-10-14 08:26:13.783166032 -0400
+++ scsi-target-2.6.patch/drivers/scsi/scsi_transport_fc.c	2004-10-14 08:26:13.785165728 -0400
@@ -325,29 +325,6 @@
 EXPORT_SYMBOL(fc_release_transport);
 
 
-
-/**
- * fc_device_block - called by target functions to block a scsi device
- * @dev:	scsi device
- * @data:	unused
- **/
-static int fc_device_block(struct device *dev, void *data)
-{
-	scsi_internal_device_block(to_scsi_device(dev));
-	return 0;
-}
-
-/**
- * fc_device_unblock - called by target functions to unblock a scsi device
- * @dev:	scsi device
- * @data:	unused
- **/
-static int fc_device_unblock(struct device *dev, void *data)
-{
-	scsi_internal_device_unblock(to_scsi_device(dev));
-	return 0;
-}
-
 /**
  * fc_timeout_blocked_tgt - Timeout handler for blocked scsi targets
  *			 that fail to recover in the alloted time.
@@ -356,6 +333,8 @@
 static void fc_timeout_blocked_tgt(unsigned long data)
 {
 	struct scsi_target *starget = (struct scsi_target *)data;
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_device *sdev;
 
 	dev_printk(KERN_ERR, &starget->dev, 
 		"blocked target time out: target resuming\n");
@@ -365,7 +344,10 @@
 	 * unblock this device, then IO errors will probably
 	 * result if the host still isn't ready.
 	 */
-	device_for_each_child(&starget->dev, NULL, fc_device_unblock);
+	shost_for_each_device(sdev, shost) {
+		if (sdev->id == starget->id)
+			scsi_internal_device_unblock(sdev);
+	}
 }
 
 /**
@@ -387,13 +369,18 @@
 int
 fc_target_block(struct scsi_target *starget)
 {
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_device *sdev;
 	int timeout = fc_starget_dev_loss_tmo(starget);
 	struct timer_list *timer = &fc_starget_dev_loss_timer(starget);
 
 	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
 		return -EINVAL;
 
-	device_for_each_child(&starget->dev, NULL, fc_device_block);
+	shost_for_each_device(sdev, shost) {
+		if (sdev->id == starget->id)
+			scsi_internal_device_block(sdev);
+	}
 
 	/* The scsi lld blocks this target for the timeout period only. */
 	timer->data = (unsigned long)starget;
@@ -419,6 +406,9 @@
 void
 fc_target_unblock(struct scsi_target *starget)
 {
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_device *sdev;
+
 	/* 
 	 * Stop the target timer first. Take no action on the del_timer
 	 * failure as the state machine state change will validate the
@@ -426,7 +416,10 @@
 	 */
 	del_timer_sync(&fc_starget_dev_loss_timer(starget));
 
-	device_for_each_child(&starget->dev, NULL, fc_device_unblock);
+	shost_for_each_device(sdev, shost) {
+		if (sdev->id == starget->id)
+			scsi_internal_device_unblock(sdev);
+	}
 }
 EXPORT_SYMBOL(fc_target_unblock);
 
