From: Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Tue, 19 Jul 2016 15:20:34 +0200
Message-ID: <1468934434-29263-1-git-send-email-oneukum@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbcGSNZB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 09:25:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, martin.petersen@oracle.com, ames.Bottomley@HansenPartnership.com, jthumshirn@suse.com, eich@suse.com
Cc: Oliver Neukum <oneukum@suse.com>

Some SATA to USB bridges fail to cooperate with some
drives resulting in no cache being present being reported
to the host. That causes the host to skip sending
a command to synchronize caches. That causes data loss
when the drive is powered down.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 Documentation/kernel-parameters.txt | 2 ++
 drivers/scsi/sd.c                   | 6 +++---
 drivers/usb/storage/scsiglue.c      | 4 ++++
 drivers/usb/storage/unusual_devs.h  | 7 +++++++
 drivers/usb/storage/usb.c           | 6 +++++-
 include/linux/usb_usual.h           | 2 ++
 include/scsi/scsi_device.h          | 1 +
 7 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 82b42c9..c8c682e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -4182,6 +4182,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				u = IGNORE_UAS (don't bind to the uas driver);
 				w = NO_WP_DETECT (don't test whether the
 					medium is write-protected).
+				y = ALWAYS_SYNC (issue a SYNCHRONIZE_CACHE
+					even if the device claims no cache)
 			Example: quirks=0419:aaf5:rl,0421:0433:rc
 
 	user_debug=	[KNL,ARM]
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 60bff78..3e8a6f1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -139,7 +139,7 @@ static void sd_set_flush_flag(struct scsi_disk *sdkp)
 {
 	bool wc = false, fua = false;
 
-	if (sdkp->WCE) {
+	if (sdkp->WCE || sdkp->device->always_sync) {
 		wc = true;
 		if (sdkp->DPOFUA)
 			fua = true;
@@ -3228,7 +3228,7 @@ static void sd_shutdown(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return;
 
-	if (sdkp->WCE && sdkp->media_present) {
+	if ((sdkp->WCE || sdkp->device->always_sync) && sdkp->media_present)  {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp);
 	}
@@ -3247,7 +3247,7 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
 		return 0;
 
-	if (sdkp->WCE && sdkp->media_present) {
+	if ((sdkp->WCE || sdkp->device->always_sync) && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp);
 		if (ret) {
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 33eb923..43e76ae 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -296,6 +296,10 @@ static int slave_configure(struct scsi_device *sdev)
 		if (us->fflags & US_FL_BROKEN_FUA)
 			sdev->broken_fua = 1;
 
+		/* Some even totally fail to indicate a cache */
+		if (us->fflags & US_FL_ALWAYS_SYNC)
+			sdev->always_sync = 1;
+
 	} else {
 
 		/*
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index aa35392..af3c7ee 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -338,6 +338,13 @@ UNUSUAL_DEV(  0x046b, 0xff40, 0x0100, 0x0100,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_WP_DETECT),
 
+/* Reported by Egbert Eich <eich@suse.com> */
+UNUSUAL_DEV(  0x0480, 0xd010, 0x0100, 0x9999,
+		"Toshiba",
+		"External USB 3.0",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_ALWAYS_SYNC),
+
 /* Patch submitted by Philipp Friedrich <philipp@void.at> */
 UNUSUAL_DEV(  0x0482, 0x0100, 0x0100, 0x0100,
 		"Kyocera",
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index ef2d8cd..19255f1 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -498,7 +498,8 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 			US_FL_NO_READ_DISC_INFO | US_FL_NO_READ_CAPACITY_16 |
 			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
 			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES |
-			US_FL_MAX_SECTORS_240 | US_FL_NO_REPORT_LUNS);
+			US_FL_MAX_SECTORS_240 | US_FL_NO_REPORT_LUNS |
+			US_FL_ALWAYS_SYNC);
 
 	p = quirks;
 	while (*p) {
@@ -581,6 +582,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 		case 'w':
 			f |= US_FL_NO_WP_DETECT;
 			break;
+		case 'y':
+			f |= US_FL_ALWAYS_SYNC;
+			break;
 		/* Ignore unrecognized flag characters */
 		}
 	}
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 245f57d..0aae1b2 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -81,6 +81,8 @@
 		/* Sets max_sectors to 240 */			\
 	US_FLAG(NO_REPORT_LUNS,	0x10000000)			\
 		/* Cannot handle REPORT_LUNS */			\
+	US_FLAG(ALWAYS_SYNC, 0x20000000)			\
+		/* lies about caching, so always sync */	\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a6c346d..392d166 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -179,6 +179,7 @@ struct scsi_device {
 	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
+	unsigned always_sync:1;		/* synchronize cache in every case*/
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 	unsigned broken_fua:1;		/* Don't set FUA bit */
 	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
-- 
2.1.4

