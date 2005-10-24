From: Jeff Garzik <jgarzik@pobox.com>
Subject: [scsi hcil 3/9] misc cleanups
Date: Mon, 24 Oct 2005 18:02:05 -0400
Message-ID: <20051024220205.GC10567@havoc.gtf.org>
References: <20051024220013.GA10070@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:49039 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751332AbVJXWCG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 18:02:06 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 067B31C0A7BA
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 18:02:06 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OM25Xv010650
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 18:02:05 -0400
Content-Disposition: inline
In-Reply-To: <20051024220013.GA10070@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


commit 4e7dd2d43e3b5aa5868de81bd62a4f1dc5ff51c4
Author: Jeff Garzik <jgarzik@pobox.com>
Date:   Mon Oct 24 15:07:05 2005 -0400

    [SCSI] misc cleanups
    
    - eliminate use of 'channel' and 'id' in starget_for_each_device()
    - unexport __scsi_device_lookup_by_target()
    - add some whitespace after '==', on one line

 drivers/scsi/scsi.c        |   12 ++++--------
 include/scsi/scsi_device.h |    2 --
 2 files changed, 4 insertions(+), 10 deletions(-)

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
index 7ece056..233b053 100644
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
 
