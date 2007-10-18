From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/4] shuttle_usbat: Eliminate use of transfersize
Date: Thu, 18 Oct 2007 12:27:54 -0400
Message-ID: <1192724876703-git-send-email-matthew@wil.cx>
References: <11927248762034-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:39387 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbXJRQ1i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 12:27:38 -0400
In-Reply-To: <11927248762034-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Daniel Drake <dsd@gentoo.org>, Matthew Wilcox <willy@linux.intel.com>

It's more intuitive to go straight to the struct device for the
sector_size, when that's what we want, rather than using transfersize
as a replacement.

Also fix a bug in handling of GPCMD_READ_CD where we were pulling the
wrong bytes out of the packet to calculate the length.  I checked this
against MMC5r04.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/usb/storage/shuttle_usbat.c |   46 +++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index 570c125..a172e98 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -49,6 +49,7 @@
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 
 #include "usb.h"
 #include "transport.h"
@@ -1164,12 +1165,10 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	unsigned char *buffer;
 	unsigned int len;
 	unsigned int sector;
+	unsigned int sector_size;
 	unsigned int sg_offset = 0;
 	struct scatterlist *sg = NULL;
 
-	US_DEBUGP("handle_read10: transfersize %d\n",
-		srb->transfersize);
-
 	if (scsi_bufflen(srb) < 0x10000) {
 
 		result = usbat_hp8200e_rw_block_test(us, USBAT_ATA, 
@@ -1184,25 +1183,32 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	}
 
 	/*
-	 * Since we're requesting more data than we can handle in
-	 * a single read command (max is 64k-1), we will perform
-	 * multiple reads, but each read must be in multiples of
-	 * a sector.  Luckily the sector size is in srb->transfersize
-	 * (see linux/drivers/scsi/sr.c).
+	 * Since we're requesting more data than we can handle in a
+	 * single read command (max is 64k-1), we will perform multiple
+	 * reads, but each read must be in multiples of a sector.
+	 *
+	 * For ordinary READ_10 commands, we're reading at the current
+	 * sector size, so use the device's sector size.  If the command
+	 * is a READ_CD, we might be reading different sector sizes.
+	 * Fortunately, we can calculate the sector size from the
+	 * contents of the command.
 	 */
 
 	if (data[7+0] == GPCMD_READ_CD) {
-		len = short_pack(data[7+9], data[7+8]);
-		len <<= 16;
-		len |= data[7+7];
+		len = data[7+8] | ((u32)data[7+7] << 8) |
+							((u32)data[7+6] << 16);
 		US_DEBUGP("handle_read10: GPCMD_READ_CD: len %d\n", len);
-		srb->transfersize = scsi_bufflen(srb)/len;
+		sector_size = scsi_bufflen(srb) / len;
+	} else {
+		sector_size = srb->device->sector_size;
 	}
 
-	if (!srb->transfersize)  {
-		srb->transfersize = 2048; /* A guess */
-		US_DEBUGP("handle_read10: transfersize 0, forcing %d\n",
-			srb->transfersize);
+	US_DEBUGP("handle_read10: sector_size %d\n", sector_size);
+
+	if (!sector_size)  {
+		sector_size = 2048; /* A guess */
+		US_DEBUGP("handle_read10: sector_size 0, forcing %d\n",
+			sector_size);
 	}
 
 	/*
@@ -1211,7 +1217,7 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	 * bounce buffer and the actual transfer buffer.
 	 */
 
-	len = (65535/srb->transfersize) * srb->transfersize;
+	len = (65535/sector_size) * sector_size;
 	US_DEBUGP("Max read is %d bytes\n", len);
 	len = min(len, scsi_bufflen(srb));
 	buffer = kmalloc(len, GFP_NOIO);
@@ -1238,8 +1244,8 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 		data[7+5] = LSB_of(sector&0xFFFF);
 		if (data[7+0] == GPCMD_READ_CD)
 			data[7+6] = 0;
-		data[7+7] = MSB_of(len / srb->transfersize); /* SCSI command */
-		data[7+8] = LSB_of(len / srb->transfersize); /* num sectors */
+		data[7+7] = MSB_of(len / sector_size); /* SCSI command */
+		data[7+8] = LSB_of(len / sector_size); /* num sectors */
 
 		result = usbat_hp8200e_rw_block_test(us, USBAT_ATA, 
 			registers, data, 19,
@@ -1259,7 +1265,7 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 		/* Update the amount transferred and the sector number */
 
 		transferred += len;
-		sector += len / srb->transfersize;
+		sector += len / sector_size;
 
 	} /* while transferred != scsi_bufflen(srb) */
 
-- 
1.4.4.2

