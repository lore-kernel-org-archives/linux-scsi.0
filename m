From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 03/24] usb: shuttle_usbat.c - convert to accessors and !use_sg
 code path removal
Date: Wed, 12 Sep 2007 02:51:03 +0300
Message-ID: <46E729E7.9030504@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:1633 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761259AbXIKXvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 19:51:38 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - functions that received char* but where passed scatterlist* mostly
   were changed to receive void*
 - Use scsi data accessors and remove of !use_sg code path

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/shuttle_usbat.c |   68 +++++++++++++---------------------
 1 files changed, 26 insertions(+), 42 deletions(-)

diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index 5e27297..1cc1fcf 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -130,7 +130,7 @@ static int usbat_write(struct us_data *us,
  * Convenience function to perform a bulk read
  */
 static int usbat_bulk_read(struct us_data *us,
-			   unsigned char *data,
+			   void* buf,
 			   unsigned int len,
 			   int use_sg)
 {
@@ -138,14 +138,14 @@ static int usbat_bulk_read(struct us_data *us,
 		return USB_STOR_XFER_GOOD;
 
 	US_DEBUGP("usbat_bulk_read: len = %d\n", len);
-	return usb_stor_bulk_transfer_sg(us, us->recv_bulk_pipe, data, len, use_sg, NULL);
+	return usb_stor_bulk_transfer_sg(us, us->recv_bulk_pipe, buf, len, use_sg, NULL);
 }
 
 /*
  * Convenience function to perform a bulk write
  */
 static int usbat_bulk_write(struct us_data *us,
-			    unsigned char *data,
+			    void* buf,
 			    unsigned int len,
 			    int use_sg)
 {
@@ -153,7 +153,7 @@ static int usbat_bulk_write(struct us_data *us,
 		return USB_STOR_XFER_GOOD;
 
 	US_DEBUGP("usbat_bulk_write:  len = %d\n", len);
-	return usb_stor_bulk_transfer_sg(us, us->send_bulk_pipe, data, len, use_sg, NULL);
+	return usb_stor_bulk_transfer_sg(us, us->send_bulk_pipe, buf, len, use_sg, NULL);
 }
 
 /*
@@ -317,7 +317,7 @@ static int usbat_wait_not_busy(struct us_data *us, int minutes)
  * Read block data from the data register
  */
 static int usbat_read_block(struct us_data *us,
-			    unsigned char *content,
+			    void* buf,
 			    unsigned short len,
 			    int use_sg)
 {
@@ -340,7 +340,7 @@ static int usbat_read_block(struct us_data *us,
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	result = usbat_bulk_read(us, content, len, use_sg);
+	result = usbat_bulk_read(us, buf, len, use_sg);
 	return (result == USB_STOR_XFER_GOOD ?
 			USB_STOR_TRANSPORT_GOOD : USB_STOR_TRANSPORT_ERROR);
 }
@@ -350,7 +350,7 @@ static int usbat_read_block(struct us_data *us,
  */
 static int usbat_write_block(struct us_data *us,
 			     unsigned char access,
-			     unsigned char *content,
+			     void* buf,
 			     unsigned short len,
 			     int minutes,
 			     int use_sg)
@@ -375,7 +375,7 @@ static int usbat_write_block(struct us_data *us,
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	result = usbat_bulk_write(us, content, len, use_sg);
+	result = usbat_bulk_write(us, buf, len, use_sg);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -395,7 +395,7 @@ static int usbat_hp8200e_rw_block_test(struct us_data *us,
 				       unsigned char timeout,
 				       unsigned char qualifier,
 				       int direction,
-				       unsigned char *content,
+				       void *buf,
 				       unsigned short len,
 				       int use_sg,
 				       int minutes)
@@ -475,7 +475,7 @@ static int usbat_hp8200e_rw_block_test(struct us_data *us,
 		}
 
 		result = usb_stor_bulk_transfer_sg(us,
-			pipe, content, len, use_sg, NULL);
+			pipe, buf, len, use_sg, NULL);
 
 		/*
 		 * If we get a stall on the bulk download, we'll retry
@@ -609,7 +609,7 @@ static int usbat_multiple_write(struct us_data *us,
  * other related details) are defined beforehand with _set_shuttle_features().
  */
 static int usbat_read_blocks(struct us_data *us,
-			     unsigned char *buffer,
+			     void* buffer,
 			     int len,
 			     int use_sg)
 {
@@ -651,7 +651,7 @@ static int usbat_read_blocks(struct us_data *us,
  * other related details) are defined beforehand with _set_shuttle_features().
  */
 static int usbat_write_blocks(struct us_data *us,
-							  unsigned char *buffer,
+			      void* buffer,
 			      int len,
 			      int use_sg)
 {
@@ -1171,15 +1171,15 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	US_DEBUGP("handle_read10: transfersize %d\n",
 		srb->transfersize);
 
-	if (srb->request_bufflen < 0x10000) {
+	if (scsi_bufflen(srb) < 0x10000) {
 
 		result = usbat_hp8200e_rw_block_test(us, USBAT_ATA, 
 			registers, data, 19,
 			USBAT_ATA_DATA, USBAT_ATA_STATUS, 0xFD,
 			(USBAT_QUAL_FCQ | USBAT_QUAL_ALQ),
 			DMA_FROM_DEVICE,
-			srb->request_buffer, 
-			srb->request_bufflen, srb->use_sg, 1);
+			scsi_sglist(srb),
+			scsi_bufflen(srb), scsi_sg_count(srb), 1);
 
 		return result;
 	}
@@ -1197,7 +1197,7 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 		len <<= 16;
 		len |= data[7+7];
 		US_DEBUGP("handle_read10: GPCMD_READ_CD: len %d\n", len);
-		srb->transfersize = srb->request_bufflen/len;
+		srb->transfersize = scsi_bufflen(srb)/len;
 	}
 
 	if (!srb->transfersize)  {
@@ -1214,7 +1214,7 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 
 	len = (65535/srb->transfersize) * srb->transfersize;
 	US_DEBUGP("Max read is %d bytes\n", len);
-	len = min(len, srb->request_bufflen);
+	len = min(len, scsi_bufflen(srb));
 	buffer = kmalloc(len, GFP_NOIO);
 	if (buffer == NULL) /* bloody hell! */
 		return USB_STOR_TRANSPORT_FAILED;
@@ -1226,10 +1226,10 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	sg_segment = 0; /* for keeping track of where we are in */
 	sg_offset = 0;  /* the scatter/gather list */
 
-	while (transferred != srb->request_bufflen) {
+	while (transferred != scsi_bufflen(srb)) {
 
-		if (len > srb->request_bufflen - transferred)
-			len = srb->request_bufflen - transferred;
+		if (len > scsi_bufflen(srb) - transferred)
+			len = scsi_bufflen(srb) - transferred;
 
 		data[3] = len&0xFF; 	  /* (cylL) = expected length (L) */
 		data[4] = (len>>8)&0xFF;  /* (cylH) = expected length (H) */
@@ -1265,7 +1265,7 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 		transferred += len;
 		sector += len / srb->transfersize;
 
-	} /* while transferred != srb->request_bufflen */
+	} /* while transferred != scsi_bufflen(srb) */
 
 	kfree(buffer);
 	return result;
@@ -1433,9 +1433,8 @@ static int usbat_hp8200e_transport(struct scsi_cmnd *srb, struct us_data *us)
 	unsigned char data[32];
 	unsigned int len;
 	int i;
-	char string[64];
 
-	len = srb->request_bufflen;
+	len = scsi_bufflen(srb);
 
 	/* Send A0 (ATA PACKET COMMAND).
 	   Note: I guess we're never going to get any of the ATA
@@ -1476,8 +1475,8 @@ static int usbat_hp8200e_transport(struct scsi_cmnd *srb, struct us_data *us)
 			USBAT_ATA_DATA, USBAT_ATA_STATUS, 0xFD,
 			(USBAT_QUAL_FCQ | USBAT_QUAL_ALQ),
 			DMA_TO_DEVICE,
-			srb->request_buffer, 
-			len, srb->use_sg, 10);
+			scsi_sglist(srb),
+			len, scsi_sg_count(srb), 10);
 
 		if (result == USB_STOR_TRANSPORT_GOOD) {
 			transferred += len;
@@ -1544,23 +1543,8 @@ static int usbat_hp8200e_transport(struct scsi_cmnd *srb, struct us_data *us)
 			len = *status;
 
 
-		result = usbat_read_block(us, srb->request_buffer, len, srb->use_sg);
-
-		/* Debug-print the first 32 bytes of the transfer */
-
-		if (!srb->use_sg) {
-			string[0] = 0;
-			for (i=0; i<len && i<32; i++) {
-				sprintf(string+strlen(string), "%02X ",
-				  ((unsigned char *)srb->request_buffer)[i]);
-				if ((i%16)==15) {
-					US_DEBUGP("%s\n", string);
-					string[0] = 0;
-				}
-			}
-			if (string[0]!=0)
-				US_DEBUGP("%s\n", string);
-		}
+		result = usbat_read_block(us, scsi_sglist(srb), len,
+			                                   scsi_sg_count(srb));
 	}
 
 	return result;
-- 
1.5.3.1


