From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Mon, 22 Jun 2015 10:55:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1506221050590.1799-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34012 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753449AbbFVOzv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 10:55:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, James Bottomley <JBottomley@Parallels.com>
Cc: Jun Itou <itou_jun@infoseek.jp>, Markus Rathgeb <maggu2810@gmail.com>, Matt <vickm78@hotmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>

Some USB mass-storage devices claim to have a write-back cache but
don't support the SYNCHRONIZE CACHE command, which means there is no
way to tell these devices to flush their caches out to permanent
storage.  Unfortunately, there is nothing we can do about this.

Until recently this deficiency did not cause any noticeable problems.
But following commit 89fb4cd1f717 ("scsi: handle flush errors
properly"), the errors are propagated to userspace where they get
reported as failures.

As a workaround, this patch adds a quirks flag for these devices to
the usb-storage driver, and a corresponding SCSI device flag, to
indicate the device can't handle SYNCHRONIZE CACHE.  If the flag is
set, the sd driver will override the cache settings reported by the
device, so that the device appears to be write-through.  This will
prevent the unsupported command from being sent.

This addresses Bugzilla #89511.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Jun Itou <itou_jun@infoseek.jp>
Reported-by: Markus Rathgeb <maggu2810@gmail.com>
Reported-by: Matt <vickm78@hotmail.com>
Tested-by: Markus Rathgeb <maggu2810@gmail.com>
Tested-by: Matt <vickm78@hotmail.com>
Fixes: 89fb4cd1f717a871ef79fa7debbe840e3225cd54
CC: James Bottomley <JBottomley@Parallels.com>
CC: <stable@vger.kernel.org>

---

As far as I'm concerned, this can be merged by either Greg or James 
(once the current merge window is over, of course).

Alan Stern


[as1779]


 drivers/scsi/sd.c                  |    7 +++++++
 drivers/usb/storage/scsiglue.c     |    4 ++++
 drivers/usb/storage/unusual_devs.h |   21 +++++++++++++++++++++
 include/linux/usb_usual.h          |    2 ++
 include/scsi/scsi_device.h         |    1 +
 5 files changed, 35 insertions(+)

Index: usb-4.0/include/scsi/scsi_device.h
===================================================================
--- usb-4.0.orig/include/scsi/scsi_device.h
+++ usb-4.0/include/scsi/scsi_device.h
@@ -174,6 +174,7 @@ struct scsi_device {
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 	unsigned broken_fua:1;		/* Don't set FUA bit */
 	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
+	unsigned broken_synch_cache:1;	/* SYNCHRONIZE_CACHE is broken */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
Index: usb-4.0/drivers/scsi/sd.c
===================================================================
--- usb-4.0.orig/drivers/scsi/sd.c
+++ usb-4.0/drivers/scsi/sd.c
@@ -2929,6 +2929,13 @@ static void sd_probe_async(void *data, a
 	sdkp->first_scan = 1;
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
+	/*
+	 * Some buggy USB bridges don't implement SYNCHRONIZE_CACHE
+	 * but still claim to be write-back.  Override them.
+	 */
+	if (sdp->broken_synch_cache)
+		sdkp->cache_override = 1;
+
 	sd_revalidate_disk(gd);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
Index: usb-4.0/include/linux/usb_usual.h
===================================================================
--- usb-4.0.orig/include/linux/usb_usual.h
+++ usb-4.0/include/linux/usb_usual.h
@@ -79,6 +79,8 @@
 		/* Cannot handle MI_REPORT_SUPPORTED_OPERATION_CODES */	\
 	US_FLAG(MAX_SECTORS_240,	0x08000000)		\
 		/* Sets max_sectors to 240 */			\
+	US_FLAG(NO_SYNCHRONIZE_CACHE,	0x10000000)		\
+		/* Cannot handle SYNCHRONIZE CACHE */		\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
Index: usb-4.0/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-4.0.orig/drivers/usb/storage/scsiglue.c
+++ usb-4.0/drivers/usb/storage/scsiglue.c
@@ -260,6 +260,10 @@ static int slave_configure(struct scsi_d
 		if (us->fflags & US_FL_BROKEN_FUA)
 			sdev->broken_fua = 1;
 
+		/* Likewise for SYNCHRONIZE CACHE */
+		if (us->fflags & US_FL_NO_SYNCHRONIZE_CACHE)
+			sdev->broken_synch_cache = 1;
+
 	} else {
 
 		/* Non-disk-type devices don't need to blacklist any pages
Index: usb-4.0/drivers/usb/storage/unusual_devs.h
===================================================================
--- usb-4.0.orig/drivers/usb/storage/unusual_devs.h
+++ usb-4.0/drivers/usb/storage/unusual_devs.h
@@ -392,6 +392,13 @@ UNUSUAL_DEV(  0x04b8, 0x0602, 0x0110, 0x
 		"785EPX Storage",
 		USB_SC_SCSI, USB_PR_BULK, NULL, US_FL_SINGLE_LUN),
 
+/* Reported by Jun Itou <itou_jun@infoseek.jp> */
+UNUSUAL_DEV(  0x04bb, 0x0109, 0x0100, 0x0100,
+		"I-O DATA DEVICE INC.",
+		"I-O DATA HDZ-UES",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_SYNCHRONIZE_CACHE),
+
 /* Not sure who reported this originally but
  * Pavel Machek <pavel@ucw.cz> reported that the extra US_FL_SINGLE_LUN
  * flag be added */
@@ -409,6 +416,13 @@ UNUSUAL_DEV(  0x04ce, 0x0002, 0x026c, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY),
 
+/* Reported by Markus Rathgeb <maggu2810@gmail.com> */
+UNUSUAL_DEV(  0x04cf, 0x8818, 0xb007, 0xb007,
+		"Myson Century, Inc.",
+		"USB Mass Storage Device",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_SYNCHRONIZE_CACHE),
+
 /* Reported by Kriston Fincher <kriston@airmail.net>
  * Patch submitted by Sean Millichamp <sean@bruenor.org>
  * This is to support the Panasonic PalmCam PV-SD4090
@@ -1372,6 +1386,13 @@ UNUSUAL_DEV( 0x0bc2, 0x3010, 0x0000, 0x0
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_SANE_SENSE ),
 
+/* Reported by matt <vickm78@hotmail.com> */
+UNUSUAL_DEV(  0x0bc2, 0x3332, 0x0012, 0x0012,
+		"Seagate",
+		"External",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_SYNCHRONIZE_CACHE),
+
 UNUSUAL_DEV(  0x0d49, 0x7310, 0x0000, 0x9999,
 		"Maxtor",
 		"USB to SATA",

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
