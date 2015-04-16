From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] uas: Add US_FL_MAX_SECTORS_240 flag
Date: Thu, 16 Apr 2015 14:17:13 +0200
Message-ID: <1429186634-6184-2-git-send-email-hdegoede@redhat.com>
References: <1429186634-6184-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429186634-6184-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Steve Bangert <sbangert-/1bC63wxbnBWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The usb-storage driver sets max_sectors = 240 in its scsi-host template, for
uas we do not want to do that for all devices, but testing has shown that
some devices need it.

This commit adds a US_FL_MAX_SECTORS_240 flag for such devices, and implements
support for it in uas.c, while at it it also adds support for
US_FL_MAX_SECTORS_64 to uas.c.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas.c | 10 +++++++++-
 drivers/usb/storage/usb.c |  6 +++++-
 include/linux/usb_usual.h |  2 ++
 3 files changed, 16 insertions(+), 2 deletions(-)

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

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
