From: James.Smart@Emulex.Com
Subject: [PATCH] add  starget_for_each_device() helper function
Date: Fri, 10 Dec 2004 17:09:14 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12E899@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44247 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261840AbULJWJT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Dec 2004 17:09:19 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id iBAM9Fni023533
	for <linux-scsi@vger.kernel.org>; Fri, 10 Dec 2004 14:09:15 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


   This patch deprecates the use of device_for_each_child() with stargets.
   The reasoning behind this is due to issues regarding:
      Semaphores that device_for_each_child() takes.
      Implicit assumptions that each child is an sdev device.

   The patch adds a new helper function, starget_for_each_device(), and
   replaces all previous uses of device_for_each_child().

-- James S



diff -upNr linux-2.6.10-rc3/drivers/scsi/scsi.c linux-2.6.10-rc3.patch/drivers/scsi/scsi.c
--- linux-2.6.10-rc3/drivers/scsi/scsi.c	2004-12-10 15:45:15.118916176 -0500
+++ linux-2.6.10-rc3.patch/drivers/scsi/scsi.c	2004-12-10 15:45:15.136913440 -0500
@@ -1075,6 +1075,28 @@ struct scsi_device *__scsi_iterate_devic
 EXPORT_SYMBOL(__scsi_iterate_devices);
 
 /**
+ * starget_for_each_device  -  helper to walk all devices of a target
+ * @starget:	target whose devices we want to iterate over.
+ *
+ * This traverses over each devices of @shost.  The devices have
+ * a reference that must be released by scsi_host_put when breaking
+ * out of the loop.
+ */
+void starget_for_each_device(struct scsi_target *starget, void * data,
+		     void (*fn)(struct scsi_device *, void *))
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost) {
+		if ((sdev->channel == starget->channel) &&
+		    (sdev->id == starget->id))
+			fn(sdev, data);
+	}
+}
+EXPORT_SYMBOL(starget_for_each_device);
+
+/**
  * scsi_device_lookup - find a device given the host (UNLOCKED)
  * @shost:	SCSI host pointer
  * @channel:	SCSI channel (zero if only one channel)
diff -upNr linux-2.6.10-rc3/drivers/scsi/scsi_lib.c linux-2.6.10-rc3.patch/drivers/scsi/scsi_lib.c
--- linux-2.6.10-rc3/drivers/scsi/scsi_lib.c	2004-12-10 15:45:15.227899608 -0500
+++ linux-2.6.10-rc3.patch/drivers/scsi/scsi_lib.c	2004-12-10 15:45:15.229899304 -0500
@@ -1768,31 +1768,29 @@ scsi_device_resume(struct scsi_device *s
 }
 EXPORT_SYMBOL(scsi_device_resume);
 
-static int
-device_quiesce_fn(struct device *dev, void *data)
+static void
+device_quiesce_fn(struct scsi_device *sdev, void *data)
 {
-	scsi_device_quiesce(to_scsi_device(dev));
-	return 0;
+	scsi_device_quiesce(sdev);
 }
 
 void
 scsi_target_quiesce(struct scsi_target *starget)
 {
-	device_for_each_child(&starget->dev, NULL, device_quiesce_fn);
+	starget_for_each_device(starget, NULL, device_quiesce_fn);
 }
 EXPORT_SYMBOL(scsi_target_quiesce);
 
-static int
-device_resume_fn(struct device *dev, void *data)
+static void
+device_resume_fn(struct scsi_device *sdev, void *data)
 {
-	scsi_device_resume(to_scsi_device(dev));
-	return 0;
+	scsi_device_resume(sdev);
 }
 
 void
 scsi_target_resume(struct scsi_target *starget)
 {
-	device_for_each_child(&starget->dev, NULL, device_resume_fn);
+	starget_for_each_device(starget, NULL, device_resume_fn);
 }
 EXPORT_SYMBOL(scsi_target_resume);
 
diff -upNr linux-2.6.10-rc3/drivers/scsi/scsi_transport_fc.c linux-2.6.10-rc3.patch/drivers/scsi/scsi_transport_fc.c
--- linux-2.6.10-rc3/drivers/scsi/scsi_transport_fc.c	2004-12-10 15:45:15.269893224 -0500
+++ linux-2.6.10-rc3.patch/drivers/scsi/scsi_transport_fc.c	2004-12-10 15:45:15.271892920 -0500
@@ -331,10 +331,9 @@ EXPORT_SYMBOL(fc_release_transport);
  * @dev:	scsi device
  * @data:	unused
  **/
-static int fc_device_block(struct device *dev, void *data)
+static void fc_device_block(struct scsi_device *sdev, void *data)
 {
-	scsi_internal_device_block(to_scsi_device(dev));
-	return 0;
+	scsi_internal_device_block(sdev);
 }
 
 /**
@@ -342,10 +341,9 @@ static int fc_device_block(struct device
  * @dev:	scsi device
  * @data:	unused
  **/
-static int fc_device_unblock(struct device *dev, void *data)
+static void fc_device_unblock(struct scsi_device *sdev, void *data)
 {
-	scsi_internal_device_unblock(to_scsi_device(dev));
-	return 0;
+	scsi_internal_device_unblock(sdev);
 }
 
 /**
@@ -365,7 +363,7 @@ static void fc_timeout_blocked_tgt(unsig
 	 * unblock this device, then IO errors will probably
 	 * result if the host still isn't ready.
 	 */
-	device_for_each_child(&starget->dev, NULL, fc_device_unblock);
+	starget_for_each_device(starget, NULL, fc_device_unblock);
 }
 
 /**
@@ -393,7 +391,7 @@ fc_target_block(struct scsi_target *star
 	if (timeout < 0 || timeout > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
 		return -EINVAL;
 
-	device_for_each_child(&starget->dev, NULL, fc_device_block);
+	starget_for_each_device(starget, NULL, fc_device_block);
 
 	/* The scsi lld blocks this target for the timeout period only. */
 	timer->data = (unsigned long)starget;
@@ -426,7 +424,7 @@ fc_target_unblock(struct scsi_target *st
 	 */
 	del_timer_sync(&fc_starget_dev_loss_timer(starget));
 
-	device_for_each_child(&starget->dev, NULL, fc_device_unblock);
+	starget_for_each_device(starget, NULL, fc_device_unblock);
 }
 EXPORT_SYMBOL(fc_target_unblock);
 
diff -upNr linux-2.6.10-rc3/include/scsi/scsi_device.h linux-2.6.10-rc3.patch/include/scsi/scsi_device.h
--- linux-2.6.10-rc3/include/scsi/scsi_device.h	2004-12-10 15:45:15.180906752 -0500
+++ linux-2.6.10-rc3.patch/include/scsi/scsi_device.h	2004-12-10 15:45:15.203903256 -0500
@@ -172,6 +172,8 @@ extern struct scsi_device *scsi_device_l
 					      uint, uint, uint);
 extern struct scsi_device *__scsi_device_lookup(struct Scsi_Host *,
 						uint, uint, uint);
+extern void starget_for_each_device(struct scsi_target *, void *,
+		     void (*fn)(struct scsi_device *, void *));
 
 /* only exposed to implement shost_for_each_device */
 extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
