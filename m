From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] Illustration of warning explosion silliness
Date: Wed, 27 Sep 2006 20:58:30 -0400
Message-ID: <20060928005830.GA25694@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:20434 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1031314AbWI1A6b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Sep 2006 20:58:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>

The following patch (DO NOT APPLY) illustrates why
device_for_each_child() should not be marked with __must_check.

The function returns the return value of the actor function, and ceases
iteration upon error.

However, _every_ case in drivers/scsi has a hardcoded return value,
illustrating how it is quite valid to not check the return value of this
function.

Not-signed-off-by: Jeff Garzik <jeff@garzik.org>


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d6743b9..4816c42 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2166,11 +2166,13 @@ target_block(struct device *dev, void *d
 void
 scsi_target_block(struct device *dev)
 {
+	int dummy;
+
 	if (scsi_is_target_device(dev))
 		starget_for_each_device(to_scsi_target(dev), NULL,
 					device_block);
 	else
-		device_for_each_child(dev, NULL, target_block);
+		dummy = device_for_each_child(dev, NULL, target_block);
 }
 EXPORT_SYMBOL_GPL(scsi_target_block);
 
@@ -2192,11 +2194,13 @@ target_unblock(struct device *dev, void 
 void
 scsi_target_unblock(struct device *dev)
 {
+	int dummy;
+
 	if (scsi_is_target_device(dev))
 		starget_for_each_device(to_scsi_target(dev), NULL,
 					device_unblock);
 	else
-		device_for_each_child(dev, NULL, target_unblock);
+		dummy = device_for_each_child(dev, NULL, target_unblock);
 }
 EXPORT_SYMBOL_GPL(scsi_target_unblock);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e7fe565..520ec13 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -803,6 +803,7 @@ static int __remove_child (struct device
 void scsi_remove_target(struct device *dev)
 {
 	struct device *rdev;
+	int dummy;
 
 	if (scsi_is_target_device(dev)) {
 		__scsi_remove_target(to_scsi_target(dev));
@@ -810,7 +811,7 @@ void scsi_remove_target(struct device *d
 	}
 
 	rdev = get_device(dev);
-	device_for_each_child(dev, NULL, __remove_child);
+	dummy = device_for_each_child(dev, NULL, __remove_child);
 	put_device(rdev);
 }
 EXPORT_SYMBOL(scsi_remove_target);
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index b5b0c2c..4370244 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -211,8 +211,10 @@ static int do_sas_phy_delete(struct devi
  */
 void sas_remove_children(struct device *dev)
 {
-	device_for_each_child(dev, (void *)0, do_sas_phy_delete);
-	device_for_each_child(dev, (void *)1, do_sas_phy_delete);
+	int dummy;
+
+	dummy = device_for_each_child(dev, (void *)0, do_sas_phy_delete);
+	dummy = device_for_each_child(dev, (void *)1, do_sas_phy_delete);
 }
 EXPORT_SYMBOL(sas_remove_children);
 
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 9f070f0..6cc79e5 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -372,8 +372,9 @@ static ssize_t
 store_spi_revalidate(struct class_device *cdev, const char *buf, size_t count)
 {
 	struct scsi_target *starget = transport_class_to_starget(cdev);
+	int dummy;
 
-	device_for_each_child(&starget->dev, NULL, child_iter);
+	dummy = device_for_each_child(&starget->dev, NULL, child_iter);
 	return count;
 }
 static CLASS_DEVICE_ATTR(revalidate, S_IWUSR, NULL, store_spi_revalidate);
