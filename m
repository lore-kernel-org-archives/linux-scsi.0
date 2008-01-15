From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: panic in sg_add when class_device_create() fails
Date: Tue, 15 Jan 2008 13:36:42 +0900
Message-ID: <20080115133642F.fujita.tomonori@lab.ntt.co.jp>
References: <478BDE18.2010600@sgi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:50845 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYAOEgr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 23:36:47 -0500
In-Reply-To: <478BDE18.2010600@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mdr@sgi.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, jeremy@sgi.com

On Mon, 14 Jan 2008 14:11:36 -0800
Michael Reed <mdr@sgi.com> wrote:

> We're seeing an occasional panic in sg_add() when class_device_create()
> fails.  It's obvious in the code that it uses the pointer to sg_class_member
> even though it's invalid.  We do see the "class_device_create failed" message.
> 
>         class_set_devdata(cl_dev, sdp);
>         error = cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, sdp->index), 1);
>         if (error)
>                 goto cdev_add_err;
> 
>         if (sg_sysfs_valid) {
>                 struct class_device * sg_class_member;
> 
>                 sg_class_member = class_device_create(sg_sysfs_class, NULL,
>                                 MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
>                                 cl_dev->dev, "%s",
>                                 disk->disk_name);
>                 if (IS_ERR(sg_class_member))
>                         printk(KERN_WARNING "sg_add: "
>                                 "class_device_create failed\n");
>                 class_set_devdata(sg_class_member, sdp);
>                                   ^^^^^^^^^^^^^^^^
>                 error = sysfs_create_link(&scsidp->sdev_gendev.kobj,
>                                           &sg_class_member->kobj, "generic");
>                 if (error)
>                         printk(KERN_ERR "sg_add: unable to make symlink "
>                                         "'generic' back to sg%d\n", sdp->index);
>         } else
>                 printk(KERN_WARNING "sg_add: sg_sys Invalid\n");
> 
> I'm uncertain of the correct fix.  Perhaps it involves a call to cdev_unmap()? 

The following patches work for me:

http://marc.info/?l=linux-scsi&m=120037070303939&w=2
http://marc.info/?l=linux-scsi&m=120037070303941&w=2


> I don't have a good way to test a fix as this problem is not easily
> reproduced.

I used the attached patch (though the fault injection feature can do
something better, I guess).


diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 527e2eb..4cdd213 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1424,12 +1424,16 @@ sg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
 
 	sdp->cdev = cdev;
 	if (sg_sysfs_valid) {
+		static int count = 0;
 		struct class_device * sg_class_member;
 
-		sg_class_member = class_device_create(sg_sysfs_class, NULL,
-				MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
-				cl_dev->dev, "%s",
-				disk->disk_name);
+		if (++count % 2)
+			sg_class_member = class_device_create(sg_sysfs_class, NULL,
+							      MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
+							      cl_dev->dev, "%s",
+							      disk->disk_name);
+		else
+			sg_class_member = ERR_PTR(-ENOMEM);
 		if (IS_ERR(sg_class_member)) {
 			printk(KERN_ERR "sg_add: "
 			       "class_device_create failed\n");


