From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Someone ( bsg merge ? ) broke {sd,hd}parm on current git
Date: Thu, 19 Jul 2007 10:19:16 -0500
Message-ID: <1184858356.3464.96.camel@localhost.localdomain>
References: <469C10F6.3050008@googlemail.com>
	 <20070717100921W.fujita.tomonori@lab.ntt.co.jp>
	 <469C1E2A.8010508@googlemail.com>
	 <20070719082516W.fujita.tomonori@lab.ntt.co.jp>
	 <1184853770.3464.85.camel@localhost.localdomain>
	 <469F75A4.8050301@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57793 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S939053AbXGSPTS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 11:19:18 -0400
In-Reply-To: <469F75A4.8050301@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel C <nix.or.die@googlemail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org

On Thu, 2007-07-19 at 16:31 +0200, Gabriel C wrote:
> No is not an SATA controller.
> 
> sda and sdb are SCSI disks connected to an Adaptec AIC-7892P U160/m
> controller using the aic7xxx driver.

OK, this definitely works for me, that's what my root disk is on.  I
think this isn't a kernel problem ... I think it's a udev name clash
problem.  Try the attached patch, which corrects the names:

> sdc is an ATA-7 disk connected to an IDE controller ( 82801BA IDE U100
> )  using libata and the ata_piix driver.


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



