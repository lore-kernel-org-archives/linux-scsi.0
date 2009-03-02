From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] Set manage_start_stop for some USB storage devices by
	default
Date: Mon, 2 Mar 2009 14:43:19 -0300
Message-ID: <20090302174240.GA22206@vespa.holoscopio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.18.203]:49574 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbZCBRnJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 12:43:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Hello,

Some time ago, I've worked with a Sandisk storage device, which could
not resume properly. I've found out that it was timing out when
receiving requests. I could mount it right after resuming, but using a
mounted device was not possible. Since this device is the only storage
present in some mobile, it is used as the root device and cannot be
unmounted.

I've thought this was a bug in the device itself and not a problem in
the bus or host controller, since other devices worked pretty well.
After doing some tests, I've realized that doing a rescan in the device
before accessing it worked. And setting manage_start_stop as true does
this automatically when resuming for us.

Thus, the patch below. I would like some comments about this particular
issue and, if the solution is acceptable, I will send a proper commit
log.

Best regards,
Cascardo.

---
 drivers/usb/storage/scsiglue.c     |    6 ++++++
 drivers/usb/storage/unusual_devs.h |    5 +++++
 include/linux/usb_usual.h          |    5 ++++-
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 8daaace..b7ed288 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -123,6 +123,12 @@ static int slave_configure(struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
 
+	/* Some devices require that manage_start_stop be set up so they
+	 * can resume properly
+	 */
+	if (us->fflags & US_FL_MANAGE_START_STOP)
+		sdev->manage_start_stop = 1;
+
 	/* Many devices have trouble transfering more than 32KB at a time,
 	 * while others have trouble with more than 64K. At this time we
 	 * are limiting both to 32K (64 sectores).
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 729a256..7332c4d 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1015,6 +1015,11 @@ UNUSUAL_DEV(  0x0781, 0x0200, 0x0000, 0x9999,
 		0),
 #endif
 
+UNUSUAL_DEV(  0x0781, 0x6500, 0x0000, 0xffff,
+		"Sandisk",
+		"uSSD 5000",
+		US_SC_DEVICE, US_PR_DEVICE, NULL, US_FL_MANAGE_START_STOP),
+
 #ifdef CONFIG_USB_STORAGE_FREECOM
 UNUSUAL_DEV(  0x07ab, 0xfc01, 0x0000, 0x9999,
 		"Freecom",
diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
index bd414ec..8c56127 100644
--- a/include/linux/usb_usual.h
+++ b/include/linux/usb_usual.h
@@ -54,7 +54,10 @@
 	US_FLAG(BULK_IGNORE_TAG,0x00004000)			\
 		/* Ignore tag mismatch in bulk operations */	\
 	US_FLAG(CAPACITY_OK,	0x00010000)			\
-		/* READ CAPACITY response is correct */
+		/* READ CAPACITY response is correct */		\
+	US_FLAG(MANAGE_START_STOP,	0x00020000)		\
+		/* manage_start_stop for the SCSI device */
+
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
-- 
1.6.2.rc0
