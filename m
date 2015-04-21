From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 2/3] uas: Add US_FL_MAX_SECTORS_240 flag
Date: Tue, 21 Apr 2015 11:20:31 +0200
Message-ID: <1429608032-6910-2-git-send-email-hdegoede@redhat.com>
References: <1429608032-6910-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1429608032-6910-1-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Steve Bangert <sbangert@frontier.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

The usb-storage driver sets max_sectors = 240 in its scsi-host template,
for uas we do not want to do that for all devices, but testing has shown
that some devices need it.

This commit adds a US_FL_MAX_SECTORS_240 flag for such devices, and
implements support for it in uas.c, while at it it also adds support
for US_FL_MAX_SECTORS_64 to uas.c.

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Document new 'g' flag in kernel-parameters.txt
-Add Cc stable@vger
---
 Documentation/kernel-parameters.txt |  2 ++
 drivers/usb/storage/uas.c           | 10 +++++++++-
 drivers/usb/storage/usb.c           |  6 +++++-
 include/linux/usb_usual.h           |  2 ++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 274252f..4ddf5b5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3774,6 +3774,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					READ_CAPACITY_16 command);
 				f = NO_REPORT_OPCODES (don't use report opcodes
 					command, uas only);
+				g = MAX_SECTORS_240 (don't transfer more than
+					240 sectors at a time, uas only);
 				h = CAPACITY_HEURISTICS (decrease the
 					reported device capacity by one
 					sector if the number is odd);
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index c6109c1..6d3122a 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -759,7 +759,10 @@ static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
 
 static int uas_slave_alloc(struct scsi_device *sdev)
 {
-	sdev->hostdata = (void *)sdev->host->hostdata;
+	struct uas_dev_info *devinfo =
+		(struct uas_dev_info *)sdev->host->hostdata;
+
+	sdev->hostdata = devinfo;
 
 	/* USB has unusual DMA-alignment requirements: Although the
 	 * starting address of each scatter-gather element doesn't matter,
@@ -778,6 +781,11 @@ static int uas_slave_alloc(struct scsi_device *sdev)
 	 */
 	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
 
+	if (devinfo->flags & US_FL_MAX_SECTORS_64)
+		blk_queue_max_hw_sectors(sdev->request_queue, 64);
+	else if (devinfo->flags & US_FL_MAX_SECTORS_240)
+		blk_queue_max_hw_sectors(sdev->request_queue, 240);
+
 	return 0;
 }
 
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index db6f6b5..6c10c88 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -479,7 +479,8 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 			US_FL_SINGLE_LUN | US_FL_NO_WP_DETECT |
 			US_FL_NO_READ_DISC_INFO | US_FL_NO_READ_CAPACITY_16 |
 			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
-			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES);
+			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES |
+			US_FL_MAX_SECTORS_240);
 
 	p = quirks;
 	while (*p) {
@@ -520,6 +521,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
 		case 'f':
 			f |= US_FL_NO_REPORT_OPCODES;
 			break;
+		case 'g':
+			f |= US_FL_MAX_SECTORS_240;
+			break;
 		case 'h':
 			f |= US_FL_CAPACITY_HEURISTICS;
 			break;
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index a7f2604..7f5f78b 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -77,6 +77,8 @@
 		/* Cannot handle ATA_12 or ATA_16 CDBs */	\
 	US_FLAG(NO_REPORT_OPCODES,	0x04000000)		\
 		/* Cannot handle MI_REPORT_SUPPORTED_OPERATION_CODES */	\
+	US_FLAG(MAX_SECTORS_240,	0x08000000)		\
+		/* Sets max_sectors to 240 */			\
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
2.3.5
