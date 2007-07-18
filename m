From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 09:20:09 +0900
Message-ID: <20070718092130V.tomof@acm.org>
References: <20070717190705T.fujita.tomonori@lab.ntt.co.jp>
	<20070717101928.GK5195@kernel.dk>
	<1184698434.3378.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:40604 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757732AbXGRAU1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 20:20:27 -0400
In-Reply-To: <1184698434.3378.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 13:53:54 -0500

> On Tue, 2007-07-17 at 12:19 +0200, Jens Axboe wrote:
> > > > Since Linus is happily snoring by now, could you test and see if the
> > > > tree works for you?
> > > 
> > > It works for me. I'll submit some minor patches against your bsg
> > > branch to scsi-ml. Can you push them together?
> > 
> > Certainly, I'll pull them into the bsg branch.
> 
> While you're at it, here's a patch to separate BSG and SCSI again (so
> SCSI can be built modular).  The way I did it was simply to move the
> SCSI specific logic into SCSI.  When you come up with a generic way to
> register the bsg requiring drivers, then we can move it out again.

Thanks, looks nice.


> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -714,6 +714,7 @@ static int attr_add(struct device *dev, struct device_attribute *attr)
>  int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  {
>  	int error, i;
> +	struct request_queue *rq = sdev->request_queue;
>  
>  	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
>  		return error;
> @@ -733,6 +734,16 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	/* take a reference for the sdev_classdev; this is
>  	 * released by the sdev_class .release */
>  	get_device(&sdev->sdev_gendev);
> +
> +	if (rq->kobj.parent)
> +		error = bsg_register_queue(rq, kobject_name(rq->kobj.parent));
> +	else
> +		error = bsg_register_queue(rq, kobject_name(&sdev->sdev_gendev.kobj));
> +	if (error) {
> +		sdev_printk(KERN_INFO, sdev, "Failed to register bsg queue\n");
> +		goto out;

Needs more cleanup here?

We might just ignore the error here since it's not fatal not to create
a bsg device, I guess.

I updated the patch against the latest code (which has just be merged
to Linus's tree).


diff --git a/block/Kconfig b/block/Kconfig
index 0768741..93adf61 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -53,7 +53,7 @@ endif # BLOCK
 
 config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
-	depends on (SCSI=y) && EXPERIMENTAL
+ 	depends on EXPERIMENTAL
 	---help---
 	Saying Y here will enable generic SG (SCSI generic) v4 support
 	for any block device.
diff --git a/block/bsg.c b/block/bsg.c
index baa04e7..4e0be1b 100644
--- a/block/bsg.c
+++ b/block/bsg.c
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
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ed72086..9ebd215 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -714,6 +714,7 @@ static int attr_add(struct device *dev,
 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
 	int error, i;
+	struct request_queue *rq = sdev->request_queue;
 
 	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
 		return error;
@@ -733,6 +734,15 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	/* take a reference for the sdev_classdev; this is
 	 * released by the sdev_class .release */
 	get_device(&sdev->sdev_gendev);
+
+	if (rq->kobj.parent)
+		error = bsg_register_queue(rq, kobject_name(rq->kobj.parent));
+	else
+		error = bsg_register_queue(rq, kobject_name(&sdev->sdev_gendev.kobj));
+
+	if (error)
+		sdev_printk(KERN_INFO, sdev, "Failed to register bsg queue\n");
+
 	if (sdev->host->hostt->sdev_attrs) {
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = attr_add(&sdev->sdev_gendev,
@@ -779,6 +789,7 @@ void __scsi_remove_device(struct scsi_de
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
+	bsg_unregister_queue(sdev->request_queue);
 	class_device_unregister(&sdev->sdev_classdev);
 	transport_remove_device(dev);
 	device_del(dev);
