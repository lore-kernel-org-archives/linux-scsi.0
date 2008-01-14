From: Michael Reed <mdr@sgi.com>
Subject: panic in sg_add when class_device_create() fails
Date: Mon, 14 Jan 2008 14:11:36 -0800
Message-ID: <478BDE18.2010600@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.171.30]:37040 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750739AbYANWLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 17:11:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
Cc: Jeremy Higdon <jeremy@sgi.com>

We're seeing an occasional panic in sg_add() when class_device_create()
fails.  It's obvious in the code that it uses the pointer to sg_class_member
even though it's invalid.  We do see the "class_device_create failed" message.

        class_set_devdata(cl_dev, sdp);
        error = cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, sdp->index), 1);
        if (error)
                goto cdev_add_err;

        if (sg_sysfs_valid) {
                struct class_device * sg_class_member;

                sg_class_member = class_device_create(sg_sysfs_class, NULL,
                                MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
                                cl_dev->dev, "%s",
                                disk->disk_name);
                if (IS_ERR(sg_class_member))
                        printk(KERN_WARNING "sg_add: "
                                "class_device_create failed\n");
                class_set_devdata(sg_class_member, sdp);
                                  ^^^^^^^^^^^^^^^^
                error = sysfs_create_link(&scsidp->sdev_gendev.kobj,
                                          &sg_class_member->kobj, "generic");
                if (error)
                        printk(KERN_ERR "sg_add: unable to make symlink "
                                        "'generic' back to sg%d\n", sdp->index);
        } else
                printk(KERN_WARNING "sg_add: sg_sys Invalid\n");

I'm uncertain of the correct fix.  Perhaps it involves a call to cdev_unmap()? 
I don't have a good way to test a fix as this problem is not easily reproduced.

Mike

