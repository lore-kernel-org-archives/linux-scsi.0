From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] remove generic symlink from sg
Date: Sat, 18 Mar 2006 15:06:18 -0600
Message-ID: <1142715978.3773.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38341 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750993AbWCRVGV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 16:06:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This has been redundant ever since James Smart added the class back
links since every scsi_device now gets one of these of the form
scsi_generic:sg<n>.

I'm open to going through the deprecated features business for this,
since this would represent a user visible change of the scsi sysfs
interface if you wish.

James

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1471,11 +1471,6 @@ sg_add(struct class_device *cl_dev, stru
 			printk(KERN_WARNING "sg_add: "
 				"class_device_create failed\n");
 		class_set_devdata(sg_class_member, sdp);
-		error = sysfs_create_link(&scsidp->sdev_gendev.kobj, 
-					  &sg_class_member->kobj, "generic");
-		if (error)
-			printk(KERN_ERR "sg_add: unable to make symlink "
-					"'generic' back to sg%d\n", k);
 	} else
 		printk(KERN_WARNING "sg_add: sg_sys INvalid\n");
 
@@ -1544,7 +1539,6 @@ sg_remove(struct class_device *cl_dev, s
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 
 	if (sdp) {
-		sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
 		class_device_destroy(sg_sysfs_class, MKDEV(SCSI_GENERIC_MAJOR, k));
 		cdev_del(sdp->cdev);
 		sdp->cdev = NULL;


