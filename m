From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH]indistinguishable devices with broken and unbroken firmware #2
Date: Thu, 8 Feb 2007 09:04:48 +0100
Message-ID: <200702080904.48806.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161540AbXBHIEl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Feb 2007 03:04:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org, gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>

Hi,

there's a USB mass storage device which exists in two version. One
reports the correct size and the other does not. Apart from that they
are identical and cannot be told apart. Here's a heuristic based on the
empirical finding that drives have even sizes.

The requested changes have been made.
Greg, can this go through your tree?

	Regards
		Oliver

Signed-off-by: Oliver Neukum <oneukum@suse.de>
------

--- linux-2.6.20/drivers/usb/storage/unusual_devs.h	2007-02-06 14:14:49.000000000 +0100
+++ linux-2.6.20-autosusp/drivers/usb/storage/unusual_devs.h	2007-02-07 15:14:01.000000000 +0100
@@ -1430,7 +1430,7 @@
 		"DataStor",
 		"USB4500 FW1.04",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY),
+		US_FL_CAPACITY_HEURISTICS),
 
 /* Control/Bulk transport for all SubClass values */
 USUAL_DEV(US_SC_RBC, US_PR_CB, USB_US_TYPE_STOR),
--- linux-2.6.20/drivers/usb/storage/scsiglue.c	2007-02-06 14:13:49.000000000 +0100
+++ linux-2.6.20-autosusp/drivers/usb/storage/scsiglue.c	2007-02-07 15:14:01.000000000 +0100
@@ -170,6 +170,12 @@
 		if (us->flags & US_FL_FIX_CAPACITY)
 			sdev->fix_capacity = 1;
 
+		/* A few disks have two indistinguishable version, one of
+		 * which reports the correct capacity and the other does not.
+		 * The sd driver has to guess which is the case. */
+		if (us->flags & US_FL_CAPACITY_HEURISTICS)
+			sdev->guess_capacity = 1;
+
 		/* Some devices report a SCSI revision level above 2 but are
 		 * unable to handle the REPORT LUNS command (for which
 		 * support is mandatory at level 3).  Since we already have
--- linux-2.6.20/drivers/scsi/sd.c	2007-02-06 14:14:48.000000000 +0100
+++ linux-2.6.20-autosusp/drivers/scsi/sd.c	2007-02-08 08:49:22.000000000 +0100
@@ -1270,9 +1270,18 @@
 
 	/* Some devices return the total number of sectors, not the
 	 * highest sector number.  Make the necessary adjustment. */
-	if (sdp->fix_capacity)
+	if (sdp->fix_capacity) {
 		--sdkp->capacity;
 
+	/* Some devices have version which report the correct sizes
+	 * and others which do not. We guess size according to a heuristic
+	 * and err on the side of lowering the capacity. */
+	} else {
+		if (sdp->guess_capacity)
+			if (sdkp->capacity & 0x01) /* odd sizes are odd */
+				--sdkp->capacity;
+	}
+
 got_data:
 	if (sector_size == 0) {
 		sector_size = 512;
--- linux-2.6.20/include/linux/usb_usual.h	2007-02-06 14:14:07.000000000 +0100
+++ linux-2.6.20-autosusp/include/linux/usb_usual.h	2007-02-07 15:14:01.000000000 +0100
@@ -46,7 +46,9 @@
 	US_FLAG(MAX_SECTORS_64,	0x00000400)			\
 		/* Sets max_sectors to 64    */			\
 	US_FLAG(IGNORE_DEVICE,	0x00000800)			\
-		/* Don't claim device */
+		/* Don't claim device */			\
+	US_FLAG(CAPACITY_HEURISTICS,	0x00001000)		\
+		/* sometimes sizes is too big */
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
--- linux-2.6.20/include/scsi/scsi_device.h	2007-02-06 14:14:57.000000000 +0100
+++ linux-2.6.20-autosusp/include/scsi/scsi_device.h	2007-02-07 15:14:01.000000000 +0100
@@ -122,6 +122,7 @@
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
+	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
