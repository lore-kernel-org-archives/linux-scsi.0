From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 04/24] usb: freecom.c & sddr09.c - convert to accessors and
 !use_sg cleanup
Date: Wed, 12 Sep 2007 02:51:51 +0300
Message-ID: <46E72A17.4080108@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6966 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761452AbXIKXwY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 19:52:24 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - Use scsi data accessors and remove of !use_sg code path
 - This patch is dependent on cleanup patch to usb transport.c/h

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/freecom.c |   14 ++++++--------
 drivers/usb/storage/sddr09.c  |    9 +++------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index 88aa59a..f5a4e8d 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -132,8 +132,7 @@ freecom_readdata (struct scsi_cmnd *srb, struct us_data *us,
 
 	/* Now transfer all of our blocks. */
 	US_DEBUGP("Start of read\n");
-	result = usb_stor_bulk_transfer_sg(us, ipipe, srb->request_buffer,
-			count, srb->use_sg, &srb->resid);
+	result = usb_stor_bulk_srb(us, ipipe, srb);
 	US_DEBUGP("freecom_readdata done!\n");
 
 	if (result > USB_STOR_XFER_SHORT)
@@ -166,8 +165,7 @@ freecom_writedata (struct scsi_cmnd *srb, struct us_data *us,
 
 	/* Now transfer all of our blocks. */
 	US_DEBUGP("Start of write\n");
-	result = usb_stor_bulk_transfer_sg(us, opipe, srb->request_buffer,
-			count, srb->use_sg, &srb->resid);
+	result = usb_stor_bulk_srb(us, opipe, srb);
 
 	US_DEBUGP("freecom_writedata done!\n");
 	if (result > USB_STOR_XFER_SHORT)
@@ -281,7 +279,7 @@ int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * and such will hang. */
 	US_DEBUGP("Device indicates that it has %d bytes available\n",
 			le16_to_cpu (fst->Count));
-	US_DEBUGP("SCSI requested %d\n", srb->request_bufflen);
+	US_DEBUGP("SCSI requested %d\n", scsi_bufflen(srb));
 
 	/* Find the length we desire to read. */
 	switch (srb->cmnd[0]) {
@@ -292,12 +290,12 @@ int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 			length = le16_to_cpu(fst->Count);
 			break;
 		default:
- 			length = srb->request_bufflen;
+			length = scsi_bufflen(srb);
 	}
 
 	/* verify that this amount is legal */
-	if (length > srb->request_bufflen) {
-		length = srb->request_bufflen;
+	if (length > scsi_bufflen(srb)) {
+		length = scsi_bufflen(srb);
 		US_DEBUGP("Truncating request to match buffer length: %d\n", length);
 	}
 
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index b2ed2a3..bd69b75 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -1619,7 +1619,7 @@ int sddr09_transport(struct scsi_cmnd *srb, struct us_data *us)
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	if (srb->request_bufflen == 0)
+	if (scsi_bufflen(srb) == 0)
 		return USB_STOR_TRANSPORT_GOOD;
 
 	if (srb->sc_data_direction == DMA_TO_DEVICE ||
@@ -1630,12 +1630,9 @@ int sddr09_transport(struct scsi_cmnd *srb, struct us_data *us)
 		US_DEBUGP("SDDR09: %s %d bytes\n",
 			  (srb->sc_data_direction == DMA_TO_DEVICE) ?
 			  "sending" : "receiving",
-			  srb->request_bufflen);
+			  scsi_bufflen(srb));
 
-		result = usb_stor_bulk_transfer_sg(us, pipe,
-					srb->request_buffer,
-					srb->request_bufflen,
-					srb->use_sg, &srb->resid);
+		result = usb_stor_bulk_srb(us, pipe, srb);
 
 		return (result == USB_STOR_XFER_GOOD ?
 			USB_STOR_TRANSPORT_GOOD : USB_STOR_TRANSPORT_ERROR);
-- 
1.5.3.1


