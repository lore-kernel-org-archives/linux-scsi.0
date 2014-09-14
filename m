From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH fix for 3.17 v3] uas: Add a quirk for rejecting ATA_12 and ATA_16 commands
Date: Sun, 14 Sep 2014 11:44:12 +0200
Message-ID: <1410687852-6338-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

And set this quirk for the Seagate Expansion Desk (0bc2:2312), as that one
seems to hang upon receiving an ATA_12 or ATA_16 command.

https://bugzilla.kernel.org/show_bug.cgi?id=79511

While at it also add missing documentation for the u value for usb-storage
quirks.

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>

--
Changes in v2: Add documentation for new t and u usb-storage.quirks flags
Changes in v3: Fix typo in documentation
---
 Documentation/kernel-parameters.txt |  3 +++
 drivers/usb/storage/uas.c           | 13 +++++++++++++
 drivers/usb/storage/unusual_uas.h   | 16 ++++++----------
 drivers/usb/storage/usb.c           |  6 +++++-
 include/linux/usb_usual.h           |  2 ++
 5 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 5ae8608..ec6b25a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3541,6 +3541,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					bogus residue values);
 				s = SINGLE_LUN (the device has only one
 					Logical Unit);
+				t = NO_ATA_1X (don't allow ATA(12) and ATA(16)
+					commands, uas only);
+				u = IGNORE_UAS (do not try to use uas);
 				w = NO_WP_DETECT (don't test whether the
 					medium is write-protected).
 			Example: quirks=0419:aaf5:rl,0421:0433:rc
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 3f42785..75d2ccd 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -28,6 +28,7 @@
 #include <scsi/scsi_tcq.h>
 
 #include "uas-detect.h"
+#include "scsiglue.h"
 
 /*
  * The r00-r01c specs define this version of the SENSE IU data structure.
@@ -49,6 +50,7 @@ struct uas_dev_info {
 	struct usb_anchor cmd_urbs;
 	struct usb_anchor sense_urbs;
 	struct usb_anchor data_urbs;
+	unsigned long flags;
 	int qdepth, resetting;
 	struct response_iu response;
 	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
@@ -714,6 +716,15 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
 
+	if ((devinfo->flags & US_FL_NO_ATA_1X) &&
+			(cmnd->cmnd[0] == ATA_12 || cmnd->cmnd[0] == ATA_16)) {
+		memcpy(cmnd->sense_buffer, usb_stor_sense_invalidCDB,
+		       sizeof(usb_stor_sense_invalidCDB));
+		cmnd->result = SAM_STAT_CHECK_CONDITION;
+		cmnd->scsi_done(cmnd);
+		return 0;
+	}
+
 	spin_lock_irqsave(&devinfo->lock, flags);
 
 	if (devinfo->resetting) {
@@ -1080,6 +1091,8 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	devinfo->resetting = 0;
 	devinfo->running_task = 0;
 	devinfo->shutdown = 0;
+	devinfo->flags = id->driver_info;
+	usb_stor_adjust_quirks(udev, &devinfo->flags);
 	init_usb_anchor(&devinfo->cmd_urbs);
 	init_usb_anchor(&devinfo->sense_urbs);
 	init_usb_anchor(&devinfo->data_urbs);
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 7244444..52f7012 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -40,13 +40,9 @@
  * and don't forget to CC: the USB development list <linux-usb@vger.kernel.org>
  */
 
-/*
- * This is an example entry for the US_FL_IGNORE_UAS flag. Once we have an
- * actual entry using US_FL_IGNORE_UAS this entry should be removed.
- *
- * UNUSUAL_DEV(  0xabcd, 0x1234, 0x0100, 0x0100,
- *		"Example",
- *		"Storage with broken UAS",
- *		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
- *		US_FL_IGNORE_UAS),
- */
+/* https://bugzilla.kernel.org/show_bug.cgi?id=79511 */
+UNUSUAL_DEV(0x0bc2, 0x2312, 0x0000, 0x9999,
+		"Seagate",
+		"Expansion Desk",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index cedb292..b9d1b93 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -478,7 +478,8 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 			US_FL_CAPACITY_OK | US_FL_IGNORE_RESIDUE |
 			US_FL_SINGLE_LUN | US_FL_NO_WP_DETECT |
 			US_FL_NO_READ_DISC_INFO | US_FL_NO_READ_CAPACITY_16 |
-			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE);
+			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
+			US_FL_NO_ATA_1X);
 
 	p = quirks;
 	while (*p) {
@@ -543,6 +544,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 		case 's':
 			f |= US_FL_SINGLE_LUN;
 			break;
+		case 't':
+			f |= US_FL_NO_ATA_1X;
+			break;
 		case 'u':
 			f |= US_FL_IGNORE_UAS;
 			break;
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index 9b7de1b..d271f88 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -73,6 +73,8 @@
 		/* Device advertises UAS but it is broken */	\
 	US_FLAG(BROKEN_FUA,	0x01000000)			\
 		/* Cannot handle FUA in WRITE or READ CDBs */	\
+	US_FLAG(NO_ATA_1X,	0x02000000)			\
+		/* Cannot handle ATA_12 or ATA_16 CDBs */	\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
2.1.0
