From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/3] sd: add support for runtime PM
Date: Wed, 16 Jun 2010 14:52:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006161157330.1587-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60326 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932546Ab0FPSwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:52:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1399) adds runtime-PM support to the sd driver.  The
support is unsophisticated: If a SCSI disk device is mounted, or if
its device file is held open, then the device will not be
runtime-suspended; otherwise it will (provided userspace gives
permission by writing "auto" to the sysfs power/control attribute).

In order to make this work, a dev_set_drvdata() call had to be moved
from sd_probe_async() to sd_probe().  Also, a few lines of code were
changed to use a local variable instead of recalculating the address
of an embedded struct device.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -758,6 +758,10 @@ static int sd_open(struct block_device *
 
 	sdev = sdkp->device;
 
+	retval = scsi_autopm_get_device(sdev);
+	if (retval)
+		goto error_autopm;
+
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
@@ -802,6 +806,8 @@ static int sd_open(struct block_device *
 	return 0;
 
 error_out:
+	scsi_autopm_put_device(sdev);
+error_autopm:
 	scsi_disk_put(sdkp);
 	return retval;	
 }
@@ -833,6 +839,8 @@ static int sd_release(struct gendisk *di
 	 * XXX and what if there are packets in flight and this close()
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
+
+	scsi_autopm_put_device(sdev);
 	scsi_disk_put(sdkp);
 	return 0;
 }
@@ -2210,7 +2218,6 @@ static void sd_probe_async(void *data, a
 	if (sdp->removable)
 		gd->flags |= GENHD_FL_REMOVABLE;
 
-	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 	sd_dif_config_host(sdkp);
 
@@ -2218,6 +2225,7 @@ static void sd_probe_async(void *data, a
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
+	scsi_autopm_put_device(sdp);
 	put_device(&sdkp->dev);
 }
 
@@ -2295,14 +2303,15 @@ static int sd_probe(struct device *dev)
 	}
 
 	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = &sdp->sdev_gendev;
+	sdkp->dev.parent = dev;
 	sdkp->dev.class = &sd_disk_class;
-	dev_set_name(&sdkp->dev, dev_name(&sdp->sdev_gendev));
+	dev_set_name(&sdkp->dev, dev_name(dev));
 
 	if (device_add(&sdkp->dev))
 		goto out_free_index;
 
-	get_device(&sdp->sdev_gendev);
+	get_device(dev);
+	dev_set_drvdata(dev, sdkp);
 
 	get_device(&sdkp->dev);	/* prevent release before async_schedule */
 	async_schedule(sd_probe_async, sdkp);
@@ -2336,8 +2345,10 @@ static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp;
 
-	async_synchronize_full();
 	sdkp = dev_get_drvdata(dev);
+	scsi_autopm_get_device(sdkp->device);
+
+	async_synchronize_full();
 	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);

