From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 8/24][RFC] isd200, transport: Use scsi_eh_cpy_sense API
Date: Mon,  4 Feb 2008 18:32:30 +0200
Message-ID: <1202142750-4823-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:43790 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYBDQhu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 11:37:50 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  Use of new scsi_eh_cpy_sense() to set sense information into the
  command.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/isd200.c    |   14 +++++++-------
 drivers/usb/storage/transport.c |   26 +++++++++++++-------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 8a761b6..9544728 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -53,6 +53,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
 
 #include "usb.h"
 #include "transport.h"
@@ -365,8 +366,9 @@ struct sense_data {
 static void isd200_build_sense(struct us_data *us, struct scsi_cmnd *srb)
 {
 	struct isd200_info *info = (struct isd200_info *)us->extra;
-	struct sense_data *buf = (struct sense_data *) &srb->sense_buffer[0];
-	unsigned char error = info->ATARegs[ATA_REG_ERROR_OFFSET];
+	struct sense_data sense;
+	struct sense_data *buf = &sense;
+	unsigned char error = info->ATARegs[IDE_ERROR_OFFSET];
 
 	if(error & ATA_ERROR_MEDIA_CHANGE) {
 		buf->ErrorCode = 0x70 | SENSE_ERRCODE_VALID;
@@ -399,6 +401,9 @@ static void isd200_build_sense(struct us_data *us, struct scsi_cmnd *srb)
 		buf->AdditionalSenseCode = 0;
 		buf->AdditionalSenseCodeQualifier = 0;
 	}
+	scsi_eh_cpy_sense(srb, &sense, sizeof(sense));
+
+	srb->result = buf->Flags ? SAM_STAT_CHECK_CONDITION : SAM_STAT_GOOD;
 }
 
 
@@ -639,11 +644,6 @@ static void isd200_invoke_transport( struct us_data *us,
 		}
 		if (result == ISD200_GOOD) {
 			isd200_build_sense(us, srb);
-			srb->result = SAM_STAT_CHECK_CONDITION;
-
-			/* If things are really okay, then let's show that */
-			if ((srb->sense_buffer[2] & 0xf) == 0x0)
-				srb->result = SAM_STAT_GOOD;
 		} else {
 			srb->result = DID_ERROR << 16;
 			/* Need reset here */
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index d9f4912..03b5e22 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -635,15 +635,15 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		US_DEBUGP("-- Result from auto-sense is %d\n", temp_result);
 		US_DEBUGP("-- code: 0x%x, key: 0x%x, ASC: 0x%x, ASCQ: 0x%x\n",
-			  srb->sense_buffer[0],
-			  srb->sense_buffer[2] & 0xf,
-			  srb->sense_buffer[12], 
-			  srb->sense_buffer[13]);
+			  scsi_sense(srb)[0],
+			  scsi_sense(srb)[2] & 0xf,
+			  scsi_sense(srb)[12],
+			  scsi_sense(srb)[13]);
 #ifdef CONFIG_USB_STORAGE_DEBUG
 		usb_stor_show_sense(
-			  srb->sense_buffer[2] & 0xf,
-			  srb->sense_buffer[12], 
-			  srb->sense_buffer[13]);
+			  scsi_sense(srb)[2] & 0xf,
+			  scsi_sense(srb)[12],
+			  scsi_sense(srb)[13]);
 #endif
 
 		/* set the result so the higher layers expect this data */
@@ -654,12 +654,12 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		 * we did an unsolicited auto-sense. */
 		if (result == USB_STOR_TRANSPORT_GOOD &&
 			/* Filemark 0, ignore EOM, ILI 0, no sense */
-				(srb->sense_buffer[2] & 0xaf) == 0 &&
+				(scsi_sense(srb)[2] & 0xaf) == 0 &&
 			/* No ASC or ASCQ */
-				srb->sense_buffer[12] == 0 &&
-				srb->sense_buffer[13] == 0) {
+				scsi_sense(srb)[12] == 0 &&
+				scsi_sense(srb)[13] == 0) {
 			srb->result = SAM_STAT_GOOD;
-			srb->sense_buffer[0] = 0x0;
+			scsi_eh_reset_sense(srb);
 		}
 	}
 
@@ -1056,8 +1056,8 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 		case US_BULK_STAT_OK:
 			/* device babbled -- return fake sense data */
 			if (fake_sense) {
-				memcpy(srb->sense_buffer, 
-				       usb_stor_sense_invalidCDB, 
+				scsi_eh_cpy_sense(srb,
+				       usb_stor_sense_invalidCDB,
 				       sizeof(usb_stor_sense_invalidCDB));
 				return USB_STOR_TRANSPORT_NO_SENSE;
 			}
-- 
1.5.3.3

