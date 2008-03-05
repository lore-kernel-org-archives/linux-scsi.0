From: <gregkh-l3A5Bk7waGM@public.gmane.org>
Subject: patch scsi-add-a-field-to-scsi_device-to-count-open-file-references.patch added to gregkh-2.6 tree
Date: Wed, 05 Mar 2008 12:13:35 -0800
Message-ID: <1204748015695@kroah.org>
References: <Pine.LNX.4.44L0.0803031508490.7094-100000@iolanthe.rowland.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0803031508490.7094-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, gregkh-l3A5Bk7waGM@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: SCSI: add a field to scsi_device to count open file references

to my gregkh-2.6 tree.  Its filename is

     scsi-add-a-field-to-scsi_device-to-count-open-file-references.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org  Wed Mar  5 12:05:47 2008
From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Date: Mon, 3 Mar 2008 15:16:16 -0500 (EST)
Subject: SCSI: add a field to scsi_device to count open file references
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,  SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <Pine.LNX.4.44L0.0803031508490.7094-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>


This patch (as1050) adds a new field to struct scsi_device, to keep a
count of the number of block-device open file references.  This count
will be used by usb-storage to determine whether USB-PERSIST should be
forced on during a suspend.

Signed-off-by: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>

---
 drivers/scsi/sd.c          |    3 +++
 drivers/scsi/sr.c          |    5 ++++-
 include/scsi/scsi_device.h |    1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -610,6 +610,7 @@ static int sd_open(struct inode *inode, 
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	}
 
+	atomic_inc(&sdev->blockdev_open_cnt);
 	return 0;
 
 error_out:
@@ -636,6 +637,8 @@ static int sd_release(struct inode *inod
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
 
+	atomic_dec(&sdev->blockdev_open_cnt);
+
 	if (!--sdkp->openers && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
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
-
 }
 
 static int sr_probe(struct device *dev)
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -153,6 +153,7 @@ struct scsi_device {
 	atomic_t iorequest_cnt;
 	atomic_t iodone_cnt;
 	atomic_t ioerr_cnt;
+	atomic_t blockdev_open_cnt;
 
 	int timeout;
 


Patches currently in gregkh-2.6 which might be from stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org are

usb/usb-convert-usb.h-struct-usb_device-to-kernel-doc.patch
usb/usb-make-usb_storage_onetouch-available-with-pm.patch
usb/usb-usb-ohci-sm501-driver-use-the-conventional-convention-for-suspend-and-resume.patch
usb/usb-reorganize-code-in-hub.c.patch
usb/usb-ehci-carry-out-port-handover-during-each-root-hub-resume.patch
usb/scsi-add-a-field-to-scsi_device-to-count-open-file-references.patch
usb/usb-allow-drivers-to-force-usb-persist.patch
usb/usb-remove-config_usb_persist-setting.patch
usb/usb-check-serial-number-string-after-device-reset.patch
usb/usb-make-usb-persist-work-after-every-system-sleep.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
