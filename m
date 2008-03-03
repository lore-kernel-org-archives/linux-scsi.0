From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Mon, 3 Mar 2008 15:16:16 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803031508490.7094-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch (as1050) adds a new field to struct scsi_device, to keep a
count of the number of block-device open file references.  This count
will be used by usb-storage to determine whether USB-PERSIST should be
forced on during a suspend.

Signed-off-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>

---

This patch is being submitted through the USB tree rather than the SCSI 
tree because it is part of a series of USB patches.


Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -611,6 +611,7 @@ static int sd_open(struct inode *inode, 
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	}
 
+	atomic_inc(&sdev->blockdev_open_cnt);
 	return 0;
 
 error_out:
@@ -637,6 +638,8 @@ static int sd_release(struct inode *inod
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
 
+	atomic_dec(&sdev->blockdev_open_cnt);
+
 	if (!--sdkp->openers && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
Index: usb-2.6/drivers/scsi/sr.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sr.c
+++ usb-2.6/drivers/scsi/sr.c
@@ -564,6 +564,7 @@ static int sr_open(struct cdrom_device_i
 	if (!scsi_block_when_processing_errors(sdev))
 		goto error_out;
 
+	atomic_inc(&sdev->blockdev_open_cnt);
 	return 0;
 
 error_out:
@@ -573,10 +574,12 @@ error_out:
 static void sr_release(struct cdrom_device_info *cdi)
 {
 	struct scsi_cd *cd = cdi->handle;
+	struct scsi_device *sdev = cd->device;
+
+	atomic_dec(&sdev->blockdev_open_cnt);
 
 	if (cd->device->sector_size > 2048)
 		sr_set_blocklength(cd, 2048);
