From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/3] usb_storage: usb_stor_bulk_transfer_sg cleanup
Date: Thu, 3 Jan 2008 19:54:32 +1100
Message-ID: <200801031954.33083.rusty@rustcorp.com.au>
References: <200801031800.02537.rusty@rustcorp.com.au> <200801031950.12090.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:59359 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbYACIzF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2008 03:55:05 -0500
In-Reply-To: <200801031950.12090.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

usb_stor_bulk_transfer_sg() assumes buf is a scatterlist array if
use_sg is non-NULL.  Change it to an explicit sg arg, instead, to
allow the callers to change to scsi_sglist().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 09247461cfda drivers/usb/storage/freecom.c
--- a/drivers/usb/storage/freecom.c	Thu Jan 03 19:30:25 2008 +1100
+++ b/drivers/usb/storage/freecom.c	Thu Jan 03 19:51:09 2008 +1100
@@ -133,7 +133,7 @@ freecom_readdata (struct scsi_cmnd *srb,
 	/* Now transfer all of our blocks. */
 	US_DEBUGP("Start of read\n");
 	result = usb_stor_bulk_transfer_sg(us, ipipe, srb->request_buffer,
-			count, srb->use_sg, &srb->resid);
+			count, scsi_sglist(srb), scsi_sg_count(srb), &srb->resid);
 	US_DEBUGP("freecom_readdata done!\n");
 
 	if (result > USB_STOR_XFER_SHORT)
@@ -167,7 +167,7 @@ freecom_writedata (struct scsi_cmnd *srb
 	/* Now transfer all of our blocks. */
 	US_DEBUGP("Start of write\n");
 	result = usb_stor_bulk_transfer_sg(us, opipe, srb->request_buffer,
-			count, srb->use_sg, &srb->resid);
+			count, scsi_sglist(srb), scsi_sg_count(srb), &srb->resid);
 
 	US_DEBUGP("freecom_writedata done!\n");
 	if (result > USB_STOR_XFER_SHORT)
diff -r 09247461cfda drivers/usb/storage/sddr09.c
--- a/drivers/usb/storage/sddr09.c	Thu Jan 03 19:30:25 2008 +1100
+++ b/drivers/usb/storage/sddr09.c	Thu Jan 03 19:51:09 2008 +1100
@@ -355,7 +355,7 @@ static int
 static int
 sddr09_readX(struct us_data *us, int x, unsigned long fromaddress,
 	     int nr_of_pages, int bulklen, unsigned char *buf,
-	     int use_sg) {
+	     struct scatterlist *sg, int use_sg) {
 
 	unsigned char *command = us->iobuf;
 	int result;
@@ -382,7 +382,7 @@ sddr09_readX(struct us_data *us, int x, 
 	}
 
 	result = usb_stor_bulk_transfer_sg(us, us->recv_bulk_pipe,
-				       buf, bulklen, use_sg, NULL);
+					   buf, bulklen, sg, use_sg, NULL);
 
 	if (result != USB_STOR_XFER_GOOD) {
 		US_DEBUGP("Result for bulk_transfer in sddr09_read2%d %d\n",
@@ -403,12 +403,13 @@ sddr09_readX(struct us_data *us, int x, 
  */
 static int
 sddr09_read20(struct us_data *us, unsigned long fromaddress,
-	      int nr_of_pages, int pageshift, unsigned char *buf, int use_sg) {
+	      int nr_of_pages, int pageshift, unsigned char *buf,
+	      struct scatterlist *sg, int use_sg) {
 	int bulklen = nr_of_pages << pageshift;
 
 	/* The last 8 bits of fromaddress are ignored. */
 	return sddr09_readX(us, 0, fromaddress, nr_of_pages, bulklen,
-			    buf, use_sg);
+			    buf, sg, use_sg);
 }
 
 /*
@@ -426,11 +427,12 @@ sddr09_read20(struct us_data *us, unsign
  */
 static int
 sddr09_read21(struct us_data *us, unsigned long fromaddress,
-	      int count, int controlshift, unsigned char *buf, int use_sg) {
+	      int count, int controlshift, unsigned char *buf,
+	      struct scatterlist *sg, int use_sg) {
 
 	int bulklen = (count << controlshift);
 	return sddr09_readX(us, 1, fromaddress, count, bulklen,
-			    buf, use_sg);
+			    buf, sg, use_sg);
 }
 
 /*
@@ -444,13 +446,14 @@ sddr09_read21(struct us_data *us, unsign
  */
 static int
 sddr09_read22(struct us_data *us, unsigned long fromaddress,
-	      int nr_of_pages, int pageshift, unsigned char *buf, int use_sg) {
+	      int nr_of_pages, int pageshift, unsigned char *buf,
+	      struct scatterlist *sg, int use_sg) {
 
 	int bulklen = (nr_of_pages << pageshift) + (nr_of_pages << CONTROL_SHIFT);
 	US_DEBUGP("sddr09_read22: reading %d pages, %d bytes\n",
 		  nr_of_pages, bulklen);
 	return sddr09_readX(us, 2, fromaddress, nr_of_pages, bulklen,
-			    buf, use_sg);
+			    buf, sg, use_sg);
 }
 
 #if 0
@@ -538,7 +541,8 @@ static int
 static int
 sddr09_writeX(struct us_data *us,
 	      unsigned long Waddress, unsigned long Eaddress,
-	      int nr_of_pages, int bulklen, unsigned char *buf, int use_sg) {
+	      int nr_of_pages, int bulklen, unsigned char *buf,
+	      struct scatterlist *sg, int use_sg) {
 
 	unsigned char *command = us->iobuf;
 	int result;
@@ -568,7 +572,7 @@ sddr09_writeX(struct us_data *us,
 	}
 
 	result = usb_stor_bulk_transfer_sg(us, us->send_bulk_pipe,
-				       buf, bulklen, use_sg, NULL);
+				       buf, bulklen, sg, use_sg, NULL);
 
 	if (result != USB_STOR_XFER_GOOD) {
 		US_DEBUGP("Result for bulk_transfer in sddr09_writeX %d\n",
@@ -582,10 +586,10 @@ static int
 static int
 sddr09_write_inplace(struct us_data *us, unsigned long address,
 		     int nr_of_pages, int pageshift, unsigned char *buf,
-		     int use_sg) {
+		     struct scatterlist *sg, int use_sg) {
 	int bulklen = (nr_of_pages << pageshift) + (nr_of_pages << CONTROL_SHIFT);
 	return sddr09_writeX(us, address, address, nr_of_pages, bulklen,
-			     buf, use_sg);
+			     buf, sg, use_sg);
 }
 
 #if 0
@@ -772,7 +776,7 @@ sddr09_read_data(struct us_data *us,
 				info->pageshift;
 
 			result = sddr09_read20(us, address>>1,
-					pages, info->pageshift, buffer, 0);
+					pages, info->pageshift, buffer, NULL, 0);
 			if (result)
 				break;
 		}
@@ -858,7 +862,7 @@ sddr09_write_lba(struct us_data *us, uns
 	/* read old contents */
 	address = (pba << (info->pageshift + info->blockshift));
 	result = sddr09_read22(us, address>>1, info->blocksize,
-			       info->pageshift, blockbuffer, 0);
+			       info->pageshift, blockbuffer, NULL, 0);
 	if (result)
 		return result;
 
@@ -898,7 +902,7 @@ sddr09_write_lba(struct us_data *us, uns
 	US_DEBUGP("Rewrite PBA %d (LBA %d)\n", pba, lba);
 
 	result = sddr09_write_inplace(us, address>>1, info->blocksize,
-				      info->pageshift, blockbuffer, 0);
+				      info->pageshift, blockbuffer, NULL, 0);
 
 	US_DEBUGP("sddr09_write_inplace returns %d\n", result);
 
@@ -1014,13 +1018,14 @@ sddr09_read_control(struct us_data *us,
 		unsigned long address,
 		unsigned int blocks,
 		unsigned char *content,
+		struct scatterlist *sg,
 		int use_sg) {
 
 	US_DEBUGP("Read control address %lu, blocks %d\n",
 		address, blocks);
 
 	return sddr09_read21(us, address, blocks,
-			     CONTROL_SHIFT, content, use_sg);
+			     CONTROL_SHIFT, content, sg, use_sg);
 }
 
 /*
@@ -1220,7 +1225,7 @@ sddr09_read_map(struct us_data *us) {
 			result = sddr09_read_control(
 				us, address>>1,
 				min(alloc_blocks, numblocks - i),
-				buffer, 0);
+				buffer, NULL, 0);
 			if (result) {
 				result = -1;
 				goto done;
@@ -1639,7 +1644,8 @@ int sddr09_transport(struct scsi_cmnd *s
 		result = usb_stor_bulk_transfer_sg(us, pipe,
 					srb->request_buffer,
 					srb->request_bufflen,
-					srb->use_sg, &srb->resid);
+					scsi_sglist(srb), scsi_sg_count(srb),
+					&srb->resid);
 
 		return (result == USB_STOR_XFER_GOOD ?
 			USB_STOR_TRANSPORT_GOOD : USB_STOR_TRANSPORT_ERROR);
diff -r 09247461cfda drivers/usb/storage/shuttle_usbat.c
--- a/drivers/usb/storage/shuttle_usbat.c	Thu Jan 03 19:30:25 2008 +1100
+++ b/drivers/usb/storage/shuttle_usbat.c	Thu Jan 03 19:51:09 2008 +1100
@@ -132,13 +132,14 @@ static int usbat_bulk_read(struct us_dat
 static int usbat_bulk_read(struct us_data *us,
 			   unsigned char *data,
 			   unsigned int len,
+			   struct scatterlist *sg,
 			   int use_sg)
 {
 	if (len == 0)
 		return USB_STOR_XFER_GOOD;
 
 	US_DEBUGP("usbat_bulk_read: len = %d\n", len);
-	return usb_stor_bulk_transfer_sg(us, us->recv_bulk_pipe, data, len, use_sg, NULL);
+	return usb_stor_bulk_transfer_sg(us, us->recv_bulk_pipe, data, len, sg, use_sg, NULL);
 }
 
 /*
@@ -147,13 +148,14 @@ static int usbat_bulk_write(struct us_da
 static int usbat_bulk_write(struct us_data *us,
 			    unsigned char *data,
 			    unsigned int len,
+			    struct scatterlist *sg,
 			    int use_sg)
 {
 	if (len == 0)
 		return USB_STOR_XFER_GOOD;
 
 	US_DEBUGP("usbat_bulk_write:  len = %d\n", len);
-	return usb_stor_bulk_transfer_sg(us, us->send_bulk_pipe, data, len, use_sg, NULL);
+	return usb_stor_bulk_transfer_sg(us, us->send_bulk_pipe, data, len, sg, use_sg, NULL);
 }
 
 /*
@@ -316,6 +318,7 @@ static int usbat_read_block(struct us_da
 static int usbat_read_block(struct us_data *us,
 			    unsigned char *content,
 			    unsigned short len,
+			    struct scatterlist *sg,
 			    int use_sg)
 {
 	int result;
@@ -337,7 +340,7 @@ static int usbat_read_block(struct us_da
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	result = usbat_bulk_read(us, content, len, use_sg);
+	result = usbat_bulk_read(us, content, len, sg, use_sg);
 	return (result == USB_STOR_XFER_GOOD ?
 			USB_STOR_TRANSPORT_GOOD : USB_STOR_TRANSPORT_ERROR);
 }
@@ -350,6 +353,7 @@ static int usbat_write_block(struct us_d
 			     unsigned char *content,
 			     unsigned short len,
 			     int minutes,
+			     struct scatterlist *sg,
 			     int use_sg)
 {
 	int result;
@@ -372,7 +376,7 @@ static int usbat_write_block(struct us_d
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
-	result = usbat_bulk_write(us, content, len, use_sg);
+	result = usbat_bulk_write(us, content, len, sg, use_sg);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -394,6 +398,7 @@ static int usbat_hp8200e_rw_block_test(s
 				       int direction,
 				       unsigned char *content,
 				       unsigned short len,
+				       struct scatterlist *sg,
 				       int use_sg,
 				       int minutes)
 {
@@ -465,14 +470,15 @@ static int usbat_hp8200e_rw_block_test(s
 				data[1+(j<<1)] = data_out[j];
 			}
 
-			result = usbat_bulk_write(us, data, num_registers*2, 0);
+			result = usbat_bulk_write(us, data, num_registers*2,
+						  NULL, 0);
 			if (result != USB_STOR_XFER_GOOD)
 				return USB_STOR_TRANSPORT_ERROR;
 
 		}
 
 		result = usb_stor_bulk_transfer_sg(us,
-			pipe, content, len, use_sg, NULL);
+			pipe, content, len, sg, use_sg, NULL);
 
 		/*
 		 * If we get a stall on the bulk download, we'll retry
@@ -583,7 +589,7 @@ static int usbat_multiple_write(struct u
 	}
 
 	/* Send the data */
-	result = usbat_bulk_write(us, data, num_registers*2, 0);
+	result = usbat_bulk_write(us, data, num_registers*2, NULL,0);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
@@ -608,6 +614,7 @@ static int usbat_read_blocks(struct us_d
 static int usbat_read_blocks(struct us_data *us,
 			     unsigned char *buffer,
 			     int len,
+			     struct scatterlist *sg,
 			     int use_sg)
 {
 	int result;
@@ -628,7 +635,7 @@ static int usbat_read_blocks(struct us_d
 		return USB_STOR_TRANSPORT_FAILED;
 	
 	/* Read the blocks we just asked for */
-	result = usbat_bulk_read(us, buffer, len, use_sg);
+	result = usbat_bulk_read(us, buffer, len, sg, use_sg);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_FAILED;
 
@@ -650,6 +657,7 @@ static int usbat_write_blocks(struct us_
 static int usbat_write_blocks(struct us_data *us,
 							  unsigned char *buffer,
 			      int len,
+			      struct scatterlist *sg,
 			      int use_sg)
 {
 	int result;
@@ -670,7 +678,7 @@ static int usbat_write_blocks(struct us_
 		return USB_STOR_TRANSPORT_FAILED;
 	
 	/* Write the data */
-	result = usbat_bulk_write(us, buffer, len, use_sg);
+	result = usbat_bulk_write(us, buffer, len, sg, use_sg);
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_FAILED;
 
@@ -955,7 +963,7 @@ static int usbat_flash_get_sector_count(
 	msleep(100);
 
 	/* Read the device identification data */
-	rc = usbat_read_block(us, reply, 512, 0);
+	rc = usbat_read_block(us, reply, 512, NULL, 0);
 	if (rc != USB_STOR_TRANSPORT_GOOD)
 		goto leave;
 
@@ -1040,7 +1048,7 @@ static int usbat_flash_read_data(struct 
 			goto leave;
 
 		/* Read the data we just requested */
-		result = usbat_read_blocks(us, buffer, len, 0);
+		result = usbat_read_blocks(us, buffer, len, NULL, 0);
 		if (result != USB_STOR_TRANSPORT_GOOD)
 			goto leave;
   	 
@@ -1135,7 +1143,7 @@ static int usbat_flash_write_data(struct
 			goto leave;
 
 		/* Write the data */
-		result = usbat_write_blocks(us, buffer, len, 0);
+		result = usbat_write_blocks(us, buffer, len, NULL, 0);
 		if (result != USB_STOR_TRANSPORT_GOOD)
 			goto leave;
 
@@ -1178,7 +1186,8 @@ static int usbat_hp8200e_handle_read10(s
 			(USBAT_QUAL_FCQ | USBAT_QUAL_ALQ),
 			DMA_FROM_DEVICE,
 			srb->request_buffer, 
-			srb->request_bufflen, srb->use_sg, 1);
+		        srb->request_bufflen,
+			scsi_sglist(srb), scsi_sg_count(srb), 1);
 
 		return result;
 	}
@@ -1247,7 +1256,7 @@ static int usbat_hp8200e_handle_read10(s
 			(USBAT_QUAL_FCQ | USBAT_QUAL_ALQ),
 			DMA_FROM_DEVICE,
 			buffer,
-			len, 0, 1);
+			len, NULL, 0, 1);
 
 		if (result != USB_STOR_TRANSPORT_GOOD)
 			break;
@@ -1473,7 +1482,7 @@ static int usbat_hp8200e_transport(struc
 			(USBAT_QUAL_FCQ | USBAT_QUAL_ALQ),
 			DMA_TO_DEVICE,
 			srb->request_buffer, 
-			len, srb->use_sg, 10);
+			len, scsi_sglist(srb), scsi_sg_count(srb), 10);
 
 		if (result == USB_STOR_TRANSPORT_GOOD) {
 			transferred += len;
@@ -1512,7 +1521,7 @@ static int usbat_hp8200e_transport(struc
 
 	if ((result = usbat_write_block(us,
 			USBAT_ATA, srb->cmnd, 12,
-				(srb->cmnd[0]==GPCMD_BLANK ? 75 : 10), 0) !=
+				(srb->cmnd[0]==GPCMD_BLANK ? 75 : 10), NULL, 0) !=
 			     USB_STOR_TRANSPORT_GOOD)) {
 		return result;
 	}
@@ -1540,11 +1549,12 @@ static int usbat_hp8200e_transport(struc
 			len = *status;
 
 
-		result = usbat_read_block(us, srb->request_buffer, len, srb->use_sg);
+		result = usbat_read_block(us, srb->request_buffer, len,
+		       	 		  scsi_sglist(srb), scsi_sg_count(srb));
 
 		/* Debug-print the first 32 bytes of the transfer */
 
-		if (!srb->use_sg) {
+		if (!scsi_sg_count(srb)) {
 			string[0] = 0;
 			for (i=0; i<len && i<32; i++) {
 				sprintf(string+strlen(string), "%02X ",
diff -r 09247461cfda drivers/usb/storage/transport.c
--- a/drivers/usb/storage/transport.c	Thu Jan 03 19:30:25 2008 +1100
+++ b/drivers/usb/storage/transport.c	Thu Jan 03 19:51:09 2008 +1100
@@ -468,7 +468,8 @@ static int usb_stor_bulk_transfer_sglist
  * scatter-gather or not, and acts appropriately.
  */
 int usb_stor_bulk_transfer_sg(struct us_data* us, unsigned int pipe,
-		void *buf, unsigned int length_left, int use_sg, int *residual)
+			      void *buf, unsigned int length_left,
+			      struct scatterlist *sg, int use_sg, int *residual)
 {
 	int result;
 	unsigned int partial;
@@ -477,7 +478,7 @@ int usb_stor_bulk_transfer_sg(struct us_
 	if (use_sg) {
 		/* use the usb core scatter-gather primitives */
 		result = usb_stor_bulk_transfer_sglist(us, pipe,
-				(struct scatterlist *) buf, use_sg,
+				sg, use_sg,
 				length_left, &partial);
 		length_left -= partial;
 	} else {
@@ -739,7 +740,8 @@ int usb_stor_CBI_transport(struct scsi_c
 				us->recv_bulk_pipe : us->send_bulk_pipe;
 		result = usb_stor_bulk_transfer_sg(us, pipe,
 					srb->request_buffer, transfer_length,
-					srb->use_sg, &srb->resid);
+					scsi_sglist(srb), scsi_sg_count(srb),
+					&srb->resid);
 		US_DEBUGP("CBI data stage result is 0x%x\n", result);
 
 		/* if we stalled the data transfer it means command failed */
@@ -838,7 +840,8 @@ int usb_stor_CB_transport(struct scsi_cm
 				us->recv_bulk_pipe : us->send_bulk_pipe;
 		result = usb_stor_bulk_transfer_sg(us, pipe,
 					srb->request_buffer, transfer_length,
-					srb->use_sg, &srb->resid);
+					scsi_sglist(srb), scsi_sg_count(srb),
+					&srb->resid);
 		US_DEBUGP("CB data stage result is 0x%x\n", result);
 
 		/* if we stalled the data transfer it means command failed */
@@ -957,7 +960,8 @@ int usb_stor_Bulk_transport(struct scsi_
 				us->recv_bulk_pipe : us->send_bulk_pipe;
 		result = usb_stor_bulk_transfer_sg(us, pipe,
 					srb->request_buffer, transfer_length,
-					srb->use_sg, &srb->resid);
+					scsi_sglist(srb), scsi_sg_count(srb),
+					&srb->resid);
 		US_DEBUGP("Bulk data transfer result 0x%x\n", result);
 		if (result == USB_STOR_XFER_ERROR)
 			return USB_STOR_TRANSPORT_ERROR;
diff -r 09247461cfda drivers/usb/storage/transport.h
--- a/drivers/usb/storage/transport.h	Thu Jan 03 19:30:25 2008 +1100
+++ b/drivers/usb/storage/transport.h	Thu Jan 03 19:51:09 2008 +1100
@@ -138,7 +138,8 @@ extern int usb_stor_bulk_transfer_buf(st
 extern int usb_stor_bulk_transfer_buf(struct us_data *us, unsigned int pipe,
 		void *buf, unsigned int length, unsigned int *act_len);
 extern int usb_stor_bulk_transfer_sg(struct us_data *us, unsigned int pipe,
-		void *buf, unsigned int length, int use_sg, int *residual);
+		void *buf, unsigned int length, struct scatterlist *sg,
+		int use_sg, int *residual);
 
 extern int usb_stor_port_reset(struct us_data *us);
 #endif
