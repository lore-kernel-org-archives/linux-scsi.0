From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: panic in sg_add when class_device_create() fails
Date: Mon, 14 Jan 2008 16:28:51 -0600
Message-ID: <1200349731.3159.76.camel@localhost.localdomain>
References: <478BDE18.2010600@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46867 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756789AbYANW24 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 17:28:56 -0500
In-Reply-To: <478BDE18.2010600@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net, Jeremy Higdon <jeremy@sgi.com>


On Mon, 2008-01-14 at 14:11 -0800, Michael Reed wrote:
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
> I don't have a good way to test a fix as this problem is not easily reproduced.

I think just

error = ERR_PTR(sg_class_member);
goto cdev_add_err;

Will do it, won't it?

James


