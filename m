From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] bsg: separate bsg and SCSI (so SCSI can be modular)
Date: Thu, 19 Jul 2007 10:15:10 -0500
Message-ID: <1184858110.3464.92.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39649 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756800AbXGSPPL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 11:15:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patch moves the bsg registration into SCSI so that bsg no longer
has a dependency on the scsi_interface_register API.

This can be viewed as a temporary expedient until we can get universal
bsg binding sorted out properly.

James
---

Index: BUILD-2.6/block/Kconfig
===================================================================
--- BUILD-2.6.orig/block/Kconfig	2007-07-18 11:34:20.000000000 -0500
+++ BUILD-2.6/block/Kconfig	2007-07-18 11:36:24.000000000 -0500
@@ -53,7 +53,7 @@ endif # BLOCK
 
 config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
-	depends on (SCSI=y) && EXPERIMENTAL
+ 	depends on EXPERIMENTAL
 	---help---
 	Saying Y here will enable generic SG (SCSI generic) v4 support
 	for any block device.
Index: BUILD-2.6/block/bsg.c
===================================================================
--- BUILD-2.6.orig/block/bsg.c	2007-07-18 11:34:20.000000000 -0500
+++ BUILD-2.6/block/bsg.c	2007-07-18 11:36:24.000000000 -0500
@@ -1009,29 +1009,6 @@ err:
 }
 EXPORT_SYMBOL_GPL(bsg_register_queue);
 
-static int bsg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
-{
-	int ret;
-	struct scsi_device *sdp = to_scsi_device(cl_dev->dev);
-	struct request_queue *rq = sdp->request_queue;
-
-	if (rq->kobj.parent)
-		ret = bsg_register_queue(rq, kobject_name(rq->kobj.parent));
-	else
-		ret = bsg_register_queue(rq, kobject_name(&sdp->sdev_gendev.kobj));
-	return ret;
-}
-
-static void bsg_remove(struct class_device *cl_dev, struct class_interface *cl_intf)
-{
-	bsg_unregister_queue(to_scsi_device(cl_dev->dev)->request_queue);
-}
-
-static struct class_interface bsg_intf = {
-	.add	= bsg_add,
-	.remove	= bsg_remove,
-};
-
 static struct cdev bsg_cdev = {
 	.kobj   = {.name = "bsg", },
 	.owner  = THIS_MODULE,
@@ -1069,16 +1046,9 @@ static int __init bsg_init(void)
 	if (ret)
 		goto unregister_chrdev;
 
-	ret = scsi_register_interface(&bsg_intf);
-	if (ret)
-		goto remove_cdev;
-
 	printk(KERN_INFO BSG_DESCRIPTION " version " BSG_VERSION
 	       " loaded (major %d)\n", bsg_major);
 	return 0;
-remove_cdev:
-	printk(KERN_ERR "bsg: failed register scsi interface %d\n", ret);
-	cdev_del(&bsg_cdev);
 unregister_chrdev:
 	unregister_chrdev_region(MKDEV(bsg_major, 0), BSG_MAX_DEVS);
 destroy_bsg_class:
Index: BUILD-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_sysfs.c	2007-07-18 11:36:02.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_sysfs.c	2007-07-19 10:10:50.000000000 -0500
@@ -715,6 +715,7 @@ static int attr_add(struct device *dev, 
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
 	int error, i;
+	struct request_queue *rq = sdev->request_queue;
 
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
 		return error;
@@ -734,6 +735,17 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	/* take a reference for the sdev_classdev; this is
 	 * released by the sdev_class .release */
 	get_device(&sdev->sdev_gendev);
+
+	error = bsg_register_queue(rq, sdev->sdev_gendev.bus_id);
+
+	if (error)
+		sdev_printk(KERN_INFO, sdev,
+			    "Failed to register bsg queue, errno=%d\n", error);
+
+	/* we're treating error on bsg register as non-fatal, so pretend
+	 * nothing went wrong */
+	error = 0;
+
 	if (sdev->host->hostt->sdev_attrs) {
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = attr_add(&sdev->sdev_gendev,
@@ -780,6 +792,7 @@ void __scsi_remove_device(struct scsi_de
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
+	bsg_unregister_queue(sdev->request_queue);
 	class_device_unregister(&sdev->sdev_classdev);
 	transport_remove_device(dev);
 	device_del(dev);


