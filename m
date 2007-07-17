From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 13:53:54 -0500
Message-ID: <1184698434.3378.15.camel@localhost.localdomain>
References: <20070717065940.GZ5195@kernel.dk>
	 <20070717160816K.fujita.tomonori@lab.ntt.co.jp>
	 <20070717071045.GD5195@kernel.dk>
	 <20070717190705T.fujita.tomonori@lab.ntt.co.jp>
	 <20070717101928.GK5195@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59623 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756013AbXGQSx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 14:53:57 -0400
In-Reply-To: <20070717101928.GK5195@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2007-07-17 at 12:19 +0200, Jens Axboe wrote:
> > > Since Linus is happily snoring by now, could you test and see if the
> > > tree works for you?
> > 
> > It works for me. I'll submit some minor patches against your bsg
> > branch to scsi-ml. Can you push them together?
> 
> Certainly, I'll pull them into the bsg branch.

While you're at it, here's a patch to separate BSG and SCSI again (so
SCSI can be built modular).  The way I did it was simply to move the
SCSI specific logic into SCSI.  When you come up with a generic way to
register the bsg requiring drivers, then we can move it out again.

James

diff --git a/block/Kconfig b/block/Kconfig
index 6597b60..3468d75 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -53,7 +53,7 @@ endif # BLOCK
 
 config BLK_DEV_BSG
 	bool "Block layer SG support"
-	depends on (SCSI=y) && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	default y
 	---help---
 	Saying Y here will enable generic SG (SCSI generic) v4
diff --git a/block/bsg.c b/block/bsg.c
index 576933f..1d9e6f7 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1030,29 +1030,6 @@ err:
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
@@ -1094,15 +1071,6 @@ static int __init bsg_init(void)
 		return ret;
 	}
 
-	ret = scsi_register_interface(&bsg_intf);
-	if (ret) {
-		printk(KERN_ERR "bsg: failed register scsi interface %d\n", ret);
-		kmem_cache_destroy(bsg_cmd_cachep);
-		class_destroy(bsg_class);
-		unregister_chrdev(BSG_MAJOR, "bsg");
-		return ret;
-	}
-
 	printk(KERN_INFO "%s loaded\n", bsg_version);
 	return 0;
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ed72086..fcbe94c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -714,6 +714,7 @@ static int attr_add(struct device *dev, struct device_attribute *attr)
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
 	int error, i;
+	struct request_queue *rq = sdev->request_queue;
 
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
 		return error;
@@ -733,6 +734,16 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	/* take a reference for the sdev_classdev; this is
 	 * released by the sdev_class .release */
 	get_device(&sdev->sdev_gendev);
+
+	if (rq->kobj.parent)
+		error = bsg_register_queue(rq, kobject_name(rq->kobj.parent));
+	else
+		error = bsg_register_queue(rq, kobject_name(&sdev->sdev_gendev.kobj));
+	if (error) {
+		sdev_printk(KERN_INFO, sdev, "Failed to register bsg queue\n");
+		goto out;
+	}
+
 	if (sdev->host->hostt->sdev_attrs) {
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = attr_add(&sdev->sdev_gendev,
@@ -779,6 +790,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
+	bsg_unregister_queue(sdev->request_queue);
 	class_device_unregister(&sdev->sdev_classdev);
 	transport_remove_device(dev);
 	device_del(dev);


