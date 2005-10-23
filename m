From: Jeff Garzik <jgarzik@pobox.com>
Subject: [patch 6/6] SCSI HCIL: misc cleanups
Date: Sat, 22 Oct 2005 21:41:24 -0400
Message-ID: <20051023014124.GF18279@havoc.gtf.org>
References: <20051023013618.GA18201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:35038 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751379AbVJWBlZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 21:41:25 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id F16F31C09610
	for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2005 21:41:24 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N1fO8b018468
	for linux-scsi@vger.kernel.org; Sat, 22 Oct 2005 21:41:24 -0400
Content-Disposition: inline
In-Reply-To: <20051023013618.GA18201@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- eliminate use of 'channel' and 'id' in starget_for_each_device()
- unexport __scsi_device_lookup_by_target()
- add some whitespace after '==', on one line

Signed-off-by: Jeff Garzik <jgarzik@pobox.com>


65036fc5edddd0ddf25f99a6e83c2d8fb7ebd46f
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1f0ebab..88aea32 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1108,13 +1108,10 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
 void starget_for_each_device(struct scsi_target *starget, void * data,
 		     void (*fn)(struct scsi_device *, void *))
 {
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, shost) {
-		if ((sdev->channel == starget->channel) &&
-		    (sdev->id == starget->id))
-			fn(sdev, data);
+	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
+		fn(sdev, data);
 	}
 }
 EXPORT_SYMBOL(starget_for_each_device);
@@ -1133,19 +1130,18 @@ EXPORT_SYMBOL(starget_for_each_device);
  * they're need to access the device list in irq context.  Otherwise you
  * really want to use scsi_device_lookup_by_target instead.
  **/
-struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
+static struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *starget,
 						   uint lun)
 {
 	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
-		if (sdev->lun ==lun)
+		if (sdev->lun == lun)
 			return sdev;
 	}
 
 	return NULL;
 }
-EXPORT_SYMBOL(__scsi_device_lookup_by_target);
 
 /**
  * scsi_device_lookup_by_target - find a device given the target
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 83cc223..5b492f6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -192,8 +192,6 @@ extern struct scsi_device *__scsi_device
 						uint, uint, uint);
 extern struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *,
 							uint);
-extern struct scsi_device *__scsi_device_lookup_by_target(struct scsi_target *,
-							  uint);
 extern void starget_for_each_device(struct scsi_target *, void *,
 		     void (*fn)(struct scsi_device *, void *));
 
