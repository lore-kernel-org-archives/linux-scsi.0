From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] target code updates to support scanned targets
Date: Thu, 17 Feb 2005 11:32:46 -0800
Message-ID: <20050217193246.GB14116@plap.qlogic.org>
References: <7526e305050215152950f5a69e@mail.gmail.com> <1108513997.5539.76.camel@mulgrave> <20050216005325.GC6859@plap.qlogic.org> <1108518411.5539.83.camel@mulgrave> <20050216175433.GC7203@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch01.qlogic.com ([198.70.193.200]:27277 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S262396AbVBQTcV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 14:32:21 -0500
Content-Disposition: inline
In-Reply-To: <20050216175433.GC7203@plap.san.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Joe Scsi <joe.scsi@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 16 Feb 2005, Andrew Vasquez wrote:
> On Tue, 15 Feb 2005, James Bottomley wrote:
> > Well, how about a different format for this, so there's a
> > scsi_remove_target that takes a generic device (analogous to the
> > scsi_scan_target) except that this time if the device isn't a target, we
> > remove all the children of the device that are targets?
> > 
> 
> along the same vein, we'll also need generic-device accessors to block
> and unblock all scsi_device children of an scsi_target.  currently,
> scsi_internal_devive_[block|unblock]() is issued across all sdevs for
> a given starget:
> 
> 	void scsi_block_target(struct device *)
> 	void scsi_unblock_target(struct device *)
> 
> one caveat with these parent-accessors is that we also lose
> 'per-starget' (un)blocking/removal granualarity -- not sure if that's
> going to be a problem for other interfaces in the future.
> 

Does the following seem reasonable?

* add scsi_target_block() and scsi_target_unblock() routines which
  take a generic-device.  Side note:  there are mixture of 
  scsi_<object>_<action>() and scsi_<action>_<noun>() functions defined
  in the scsi APIs -- going forward are there any 'guides' or
  suggestions on which to choose?
* modify scsi_remove_target() to take a generic-device.

-- 
Andrew Vasquez


===== drivers/scsi/scsi_lib.c 1.149 vs edited =====
--- 1.149/drivers/scsi/scsi_lib.c	2005-02-15 23:48:33 -08:00
+++ edited/drivers/scsi/scsi_lib.c	2005-02-17 11:17:22 -08:00
@@ -1889,3 +1889,55 @@ scsi_internal_device_unblock(struct scsi
 	return 0;
 }
 EXPORT_SYMBOL_GPL(scsi_internal_device_unblock);
+
+static void
+device_block(struct scsi_device *sdev, void *data)
+{
+	scsi_internal_device_block(sdev);
+}
+
+static int
+target_block(struct device *dev, void *data)
+{
+	if (scsi_is_target_device(dev))
+		starget_for_each_device(to_scsi_target(dev), NULL,
+					device_block);
+	return 0;
+}
+
+void
+scsi_target_block(struct device *dev)
+{
+	if (scsi_is_target_device(dev))
+		starget_for_each_device(to_scsi_target(dev), NULL,
+					device_block);
+	else
+		device_for_each_child(dev, NULL, target_block);
+}
+EXPORT_SYMBOL_GPL(scsi_target_block);
+
+static void
+device_unblock(struct scsi_device *sdev, void *data)
+{
+	scsi_internal_device_unblock(sdev);
+}
+
+static int
+target_unblock(struct device *dev, void *data)
+{
+	if (scsi_is_target_device(dev))
+		starget_for_each_device(to_scsi_target(dev), NULL,
+					device_unblock);
+	return 0;
+}
+
+void
+scsi_target_unblock(struct device *dev)
+{
+	if (scsi_is_target_device(dev))
+		starget_for_each_device(to_scsi_target(dev), NULL,
+					device_unblock);
+	else
+		device_for_each_child(dev, NULL, target_unblock);
+}
+EXPORT_SYMBOL_GPL(scsi_target_unblock);
===== drivers/scsi/scsi_scan.c 1.141 vs edited =====
--- 1.141/drivers/scsi/scsi_scan.c	2005-02-15 23:48:33 -08:00
+++ edited/drivers/scsi/scsi_scan.c	2005-02-16 10:21:35 -08:00
@@ -1385,7 +1385,7 @@ void scsi_forget_host(struct Scsi_Host *
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
-		scsi_remove_target(starget);
+		scsi_remove_target(&starget->dev);
 		spin_lock_irqsave(shost->host_lock, flags);
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
===== drivers/scsi/scsi_sysfs.c 1.65 vs edited =====
--- 1.65/drivers/scsi/scsi_sysfs.c	2005-02-15 23:48:33 -08:00
+++ edited/drivers/scsi/scsi_sysfs.c	2005-02-16 17:05:37 -08:00
@@ -634,15 +634,7 @@ void scsi_remove_device(struct scsi_devi
 }
 EXPORT_SYMBOL(scsi_remove_device);
 
-/**
- * scsi_remove_target - try to remove a target and all its devices
- * @starget: the target to remove
- *
- * Note: This is slightly racy.  It is possible that if the user
- * requests the addition of another device then the target won't be
- * removed.
- */
-void scsi_remove_target(struct scsi_target *starget)
+void __scsi_remove_target(struct scsi_target *starget)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	unsigned long flags;
@@ -660,6 +652,31 @@ void scsi_remove_target(struct scsi_targ
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	scsi_target_reap(starget);
+}
+
+/**
+ * scsi_remove_target - try to remove a target and all its devices
+ * @dev: generic starget or parent of generic stargets to be removed
+ *
+ * Note: This is slightly racy.  It is possible that if the user
+ * requests the addition of another device then the target won't be
+ * removed.
+ */
+void scsi_remove_target(struct device *dev)
+{
+	struct device *rdev, *idev, *next;
+
+	if (scsi_is_target_device(dev)) {
+		__scsi_remove_target(to_scsi_target(dev));
+		return;
+	}
+
+	rdev = get_device(dev);
+	list_for_each_entry_safe(idev, next, &dev->children, node) {
+		if (scsi_is_target_device(idev))
+			__scsi_remove_target(to_scsi_target(idev));
+	}
+	put_device(rdev);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
===== include/scsi/scsi_device.h 1.30 vs edited =====
--- 1.30/include/scsi/scsi_device.h	2005-02-15 23:48:33 -08:00
+++ edited/include/scsi/scsi_device.h	2005-02-17 11:15:51 -08:00
@@ -227,7 +227,9 @@ extern void scsi_device_resume(struct sc
 extern void scsi_target_quiesce(struct scsi_target *);
 extern void scsi_target_resume(struct scsi_target *);
 extern void scsi_target_reap(struct scsi_target *);
-extern void scsi_remove_target(struct scsi_target *);
+extern void scsi_target_block(struct device *);
+extern void scsi_target_unblock(struct device *);
+extern void scsi_remove_target(struct device *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
