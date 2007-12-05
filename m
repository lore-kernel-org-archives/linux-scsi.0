From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [PATCH] esp_scsi: Fix reset cleanup spinlock recursion
Date: Wed, 5 Dec 2007 16:10:54 +0000 (GMT)
Message-ID: <Pine.LNX.4.64N.0712051529470.5943@blysk.ds.pg.gda.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:52267 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbXLEQLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 11:11:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, "David S. Miller" <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 The esp_reset_cleanup() function is called with the host lock held and 
invokes starget_for_each_device() which wants to take it too.  Here is a 
fix along the lines of shost_for_each_device()/__shost_for_each_device() 
adding a __starget_for_each_device() counterpart which assumes the lock 
has already been taken.

 Eventually, I think the driver should get modified so that more work is 
done as a softirq rather than in the interrupt context, but for now it 
fixes a bug that causes the spinlock debugger to fire.

 While at it, it fixes a small number of cosmetic problems with 
starget_for_each_device() too.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Checked with checkpatch.pl and at the run time.  Please apply.

  Maciej

patch-mips-2.6.23-rc5-20070904-esp_scsi-reset-3
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/scsi/esp_scsi.c linux-mips-2.6.23-rc5-20070904/drivers/scsi/esp_scsi.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/scsi/esp_scsi.c	2007-10-23 14:07:38.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/scsi/esp_scsi.c	2007-11-26 01:01:10.000000000 +0000
@@ -2028,8 +2028,8 @@ static void esp_reset_cleanup(struct esp
 		tp->flags |= ESP_TGT_CHECK_NEGO;
 
 		if (tp->starget)
-			starget_for_each_device(tp->starget, NULL,
-						esp_clear_hold);
+			__starget_for_each_device(tp->starget, NULL,
+						  esp_clear_hold);
 	}
 	esp->flags &= ~ESP_FLAG_RESETTING;
 }
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/scsi/scsi.c linux-mips-2.6.23-rc5-20070904/drivers/scsi/scsi.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/scsi/scsi.c	2007-09-04 04:55:44.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/scsi/scsi.c	2007-12-05 16:00:40.000000000 +0000
@@ -886,11 +886,11 @@ EXPORT_SYMBOL(__scsi_iterate_devices);
  * starget_for_each_device  -  helper to walk all devices of a target
  * @starget:	target whose devices we want to iterate over.
  *
- * This traverses over each devices of @shost.  The devices have
+ * This traverses over each device of @starget.  The devices have
  * a reference that must be released by scsi_host_put when breaking
  * out of the loop.
  */
-void starget_for_each_device(struct scsi_target *starget, void * data,
+void starget_for_each_device(struct scsi_target *starget, void *data,
 		     void (*fn)(struct scsi_device *, void *))
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -905,6 +905,33 @@ void starget_for_each_device(struct scsi
 EXPORT_SYMBOL(starget_for_each_device);
 
 /**
+ * __starget_for_each_device  -  helper to walk all devices of a target
+ *				 (UNLOCKED)
+ * @starget:	target whose devices we want to iterate over.
+ *
+ * This traverses over each device of @starget.  It does _not_
+ * take a reference on the scsi_device, so the whole loop must be
+ * protected by shost->host_lock.
+ *
+ * Note:  The only reason why drivers would want to use this is because
+ * they need to access the device list in irq context.  Otherwise you
+ * really want to use starget_for_each_device instead.
+ **/
+void __starget_for_each_device(struct scsi_target *starget, void *data,
+			       void (*fn)(struct scsi_device *, void *))
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_device *sdev;
+
+	__shost_for_each_device(sdev, shost) {
+		if ((sdev->channel == starget->channel) &&
+		    (sdev->id == starget->id))
+			fn(sdev, data);
+	}
+}
+EXPORT_SYMBOL(__starget_for_each_device);
+
+/**
  * __scsi_device_lookup_by_target - find a device given the target (UNLOCKED)
  * @starget:	SCSI target pointer
  * @lun:	SCSI Logical Unit Number
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/include/scsi/scsi_device.h linux-mips-2.6.23-rc5-20070904/include/scsi/scsi_device.h
--- linux-mips-2.6.23-rc5-20070904.macro/include/scsi/scsi_device.h	2007-09-04 04:56:21.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/include/scsi/scsi_device.h	2007-11-26 01:00:57.000000000 +0000
@@ -222,6 +222,9 @@ extern struct scsi_device *__scsi_device
 							  uint);
 extern void starget_for_each_device(struct scsi_target *, void *,
 		     void (*fn)(struct scsi_device *, void *));
+extern void __starget_for_each_device(struct scsi_target *, void *,
+				      void (*fn)(struct scsi_device *,
+						 void *));
 
 /* only exposed to implement shost_for_each_device */
 extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
