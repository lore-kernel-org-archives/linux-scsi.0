From: Mathieu Chouquet-Stringer <mchouque@free.fr>
Subject: class_device_add error in SCSI with 2.6.17-rc2-g52824b6b
Date: Wed, 19 Apr 2006 23:31:29 +0200
Message-ID: <20060419213129.GA9148@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp13.wanadoo.fr ([193.252.22.54]:218 "EHLO smtp13.wanadoo.fr")
	by vger.kernel.org with ESMTP id S1751164AbWDSVci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 17:32:38 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf1309.wanadoo.fr (SMTP Server) with ESMTP id D664C700009D
	for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2006 23:32:31 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

	Hello James,

While booting 2.6.17-rc2-g52824b6b on an alpha (a 164LX clone), I get
the following error messages for every sd devices that get registered:

sd 0:0:0:0: Attached scsi disk sda
kobject_add failed for 0:0: with -EEXIST, don't try to register things with the same name in the same directory.
fffffc0000e4bc88 0000000000100100 fffffc000045c398 fffffc0000ec9910 
       fffffc0000ec9910 0000000000000000 fffffc0000688080 0000000000100100 
       fffffc0000488b84 fffffc0000ec9910 fffffc0000ec9500 fffffc0000ec9900 
       fffffc0000ec1800 0000000000000000 fffffc0000ec18e8 fffffc0000ec1a18 
       0000000000000000 ffffffffffffffea fffffc000045ac8c fffffc0000ec18e8 
       0000000000000000 fffffc0000687f50 fffffc0000683d48 0000000000000000 
Trace:
[<fffffc000045c398>] class_device_add+0xb4/0x388
[<fffffc0000488b84>] sd_probe+0x154/0x4cc
[<fffffc000045ac8c>] driver_probe_device+0x6c/0xf0
[<fffffc000045ae90>] __driver_attach+0x9c/0x11c
[<fffffc0000459bac>] bus_for_each_dev+0x5c/0xb0
[<fffffc000045adf4>] __driver_attach+0x0/0x11c
[<fffffc000045af3c>] driver_attach+0x2c/0x40
[<fffffc000045a390>] bus_add_driver+0xa8/0x1d4
[<fffffc000045b644>] driver_register+0xa8/0xc0
[<fffffc0000476018>] scsi_register_driver+0x24/0x38
[<fffffc0000310200>] init+0x11c/0x360
[<fffffc0000311598>] kernel_thread+0x28/0x90
[<fffffc0000311580>] kernel_thread+0x10/0x90


Looking at 'git whatchanged' for drivers/scsi/sd.c, I guess (just a wild
guess, I'll bisect tomorrow if needed) this patch probably broke the
whole thing:

diff-tree 6bdaa1f17dd32ec62345c7b57842f53e6278a2fa (from
5baba830e93732e802dc7e0a362eb730e1917f58)
Author: James Bottomley <James.Bottomley@steeleye.com>
Date:   Sat Mar 18 14:14:21 2006 -0600

    [SCSI] allow displaying and setting of cache type via sysfs

    I think I promised to do this two years ago

    This patch adds a scsi_disk class with the cache type and FUA
    parameters, so user land application can easily obtain them without
    having to parse dmesg.  It also allows setting the cache type (use with
    care...)

    This patch is a bit dangerous because I've replaced the disk kref with a
    class device reference ...

    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>


Looking at the backtrace, this portion of the patch appears to be
failing:

@@ -1566,7 +1642,16 @@ static int sd_probe(struct device *dev)
        if (error)
                goto out_put;

+       class_device_initialize(&sdkp->cdev);
+       sdkp->cdev.dev = &sdp->sdev_gendev;
+       sdkp->cdev.class = &sd_disk_class;
+       strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
+
+       if (class_device_add(&sdkp->cdev))
+               goto out_put;
+
        get_device(&sdp->sdev_gendev);
+
        sdkp->device = sdp;
        sdkp->driver = &sd_template;
        sdkp->disk = gd;


I'll look some more at the whole thing tomorrow as I'm not familiar at
all with kobject/sysfs...

Cheers,

-- 
Mathieu Chouquet-Stringer                         mchouque@free.fr

