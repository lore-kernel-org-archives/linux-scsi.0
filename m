From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 30/33] USB storage: sg chaining support
Date: Mon, 16 Jul 2007 11:47:44 +0200
Message-ID: <11845792692184-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760967AbXGPJsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:39 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, greg@kroah.com

[PATCH] USB storage: sg chaining support

Modify usb_stor_access_xfer_buf() to take a pointer to an sg
entry pointer, so we can keep track of that instead of passing
around an integer index (which we can't use when dealing with
multiple scatterlist arrays).

Cc: greg@kroah.com
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/usb/storage/alauda.c        |   16 ++++++++++------
 drivers/usb/storage/datafab.c       |   10 ++++++----
 drivers/usb/storage/jumpshot.c      |   10 ++++++----
 drivers/usb/storage/protocol.c      |   20 +++++++++++---------
 drivers/usb/storage/protocol.h      |    2 +-
 drivers/usb/storage/sddr09.c        |   16 ++++++++++------
 drivers/usb/storage/sddr55.c        |   16 ++++++++++------
 drivers/usb/storage/shuttle_usbat.c |   17 ++++++++---------
 8 files changed, 62 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 4d3cbb1..8d3711a 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -798,12 +798,13 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 {
 	unsigned char *buffer;
 	u16 lba, max_lba;
-	unsigned int page, len, index, offset;
+	unsigned int page, len, offset;
 	unsigned int blockshift = MEDIA_INFO(us).blockshift;
 	unsigned int pageshift = MEDIA_INFO(us).pageshift;
 	unsigned int blocksize = MEDIA_INFO(us).blocksize;
 	unsigned int pagesize = MEDIA_INFO(us).pagesize;
 	unsigned int uzonesize = MEDIA_INFO(us).uzonesize;
+	struct scatterlist *sg;
 	int result;
 
 	/*
@@ -827,7 +828,8 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 	max_lba = MEDIA_INFO(us).capacity >> (blockshift + pageshift);
 
 	result = USB_STOR_TRANSPORT_GOOD;
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors > 0) {
 		unsigned int zone = lba / uzonesize; /* integer division */
@@ -873,7 +875,7 @@ static int alauda_read_data(struct us_data *us, unsigned long address,
 
 		/* Store the data in the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, TO_XFER_BUF);
+				&sg, &offset, TO_XFER_BUF);
 
 		page = 0;
 		lba++;
@@ -891,11 +893,12 @@ static int alauda_write_data(struct us_data *us, unsigned long address,
 		unsigned int sectors)
 {
 	unsigned char *buffer, *blockbuffer;
-	unsigned int page, len, index, offset;
+	unsigned int page, len, offset;
 	unsigned int blockshift = MEDIA_INFO(us).blockshift;
 	unsigned int pageshift = MEDIA_INFO(us).pageshift;
 	unsigned int blocksize = MEDIA_INFO(us).blocksize;
 	unsigned int pagesize = MEDIA_INFO(us).pagesize;
+	struct scatterlist *sg;
 	u16 lba, max_lba;
 	int result;
 
@@ -929,7 +932,8 @@ static int alauda_write_data(struct us_data *us, unsigned long address,
 	max_lba = MEDIA_INFO(us).capacity >> (pageshift + blockshift);
 
 	result = USB_STOR_TRANSPORT_GOOD;
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors > 0) {
 		/* Write as many sectors as possible in this block */
@@ -946,7 +950,7 @@ static int alauda_write_data(struct us_data *us, unsigned long address,
 
 		/* Get the data from the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, FROM_XFER_BUF);
+				&sg, &offset, FROM_XFER_BUF);
 
 		result = alauda_write_lba(us, lba, page, pages, buffer,
 			blockbuffer);
diff --git a/drivers/usb/storage/datafab.c b/drivers/usb/storage/datafab.c
index c87ad1b..579e9f5 100644
--- a/drivers/usb/storage/datafab.c
+++ b/drivers/usb/storage/datafab.c
@@ -98,7 +98,8 @@ static int datafab_read_data(struct us_data *us,
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Datafab
@@ -155,7 +156,7 @@ static int datafab_read_data(struct us_data *us,
 
 		// Store the data in the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				 &sg_idx, &sg_offset, TO_XFER_BUF);
+				 &sg, &sg_offset, TO_XFER_BUF);
 
 		sector += thistime;
 		totallen -= len;
@@ -181,7 +182,8 @@ static int datafab_write_data(struct us_data *us,
 	unsigned char thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Datafab
@@ -217,7 +219,7 @@ static int datafab_write_data(struct us_data *us,
 
 		// Get the data from the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg_idx, &sg_offset, FROM_XFER_BUF);
+				&sg, &sg_offset, FROM_XFER_BUF);
 
 		command[0] = 0;
 		command[1] = thistime;
diff --git a/drivers/usb/storage/jumpshot.c b/drivers/usb/storage/jumpshot.c
index 003fcf5..61097cb 100644
--- a/drivers/usb/storage/jumpshot.c
+++ b/drivers/usb/storage/jumpshot.c
@@ -119,7 +119,8 @@ static int jumpshot_read_data(struct us_data *us,
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Jumpshot
@@ -170,7 +171,7 @@ static int jumpshot_read_data(struct us_data *us,
 
 		// Store the data in the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				 &sg_idx, &sg_offset, TO_XFER_BUF);
+				 &sg, &sg_offset, TO_XFER_BUF);
 
 		sector += thistime;
 		totallen -= len;
@@ -195,7 +196,8 @@ static int jumpshot_write_data(struct us_data *us,
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result, waitcount;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Jumpshot
@@ -225,7 +227,7 @@ static int jumpshot_write_data(struct us_data *us,
 
 		// Get the data from the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg_idx, &sg_offset, FROM_XFER_BUF);
+				&sg, &sg_offset, FROM_XFER_BUF);
 
 		command[0] = 0;
 		command[1] = thistime;
diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index 9ad3042..cc8f7c5 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -157,7 +157,7 @@ void usb_stor_transparent_scsi_command(struct scsi_cmnd *srb,
  * pick up from where this one left off. */
 
 unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
-	unsigned int buflen, struct scsi_cmnd *srb, unsigned int *index,
+	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **sgptr,
 	unsigned int *offset, enum xfer_buf_dir dir)
 {
 	unsigned int cnt;
@@ -184,16 +184,17 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 	 * located in high memory -- then kmap() will map it to a temporary
 	 * position in the kernel's virtual address space. */
 	} else {
-		struct scatterlist *sg =
-				(struct scatterlist *) srb->request_buffer
-				+ *index;
+		struct scatterlist *sg = *sgptr;
+
+		if (!sg)
+			sg = (struct scatterlist *) srb->request_buffer;
 
 		/* This loop handles a single s-g list entry, which may
 		 * include multiple pages.  Find the initial page structure
 		 * and the starting offset within the page, and update
 		 * the *offset and *index values for the next loop. */
 		cnt = 0;
-		while (cnt < buflen && *index < srb->use_sg) {
+		while (cnt < buflen) {
 			struct page *page = sg->page +
 					((sg->offset + *offset) >> PAGE_SHIFT);
 			unsigned int poff =
@@ -209,8 +210,7 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 
 				/* Transfer continues to next s-g entry */
 				*offset = 0;
-				++*index;
-				++sg;
+				sg = sg_next(sg);
 			}
 
 			/* Transfer the data for all the pages in this
@@ -234,6 +234,7 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 				sglen -= plen;
 			}
 		}
+		*sgptr = sg;
 	}
 
 	/* Return the amount actually transferred */
@@ -245,9 +246,10 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 void usb_stor_set_xfer_buf(unsigned char *buffer,
 	unsigned int buflen, struct scsi_cmnd *srb)
 {
-	unsigned int index = 0, offset = 0;
+	unsigned int offset = 0;
+	struct scatterlist *sg = NULL;
 
-	usb_stor_access_xfer_buf(buffer, buflen, srb, &index, &offset,
+	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
 			TO_XFER_BUF);
 	if (buflen < srb->request_bufflen)
 		srb->resid = srb->request_bufflen - buflen;
diff --git a/drivers/usb/storage/protocol.h b/drivers/usb/storage/protocol.h
index 845bed4..8737a36 100644
--- a/drivers/usb/storage/protocol.h
+++ b/drivers/usb/storage/protocol.h
@@ -52,7 +52,7 @@ extern void usb_stor_transparent_scsi_command(struct scsi_cmnd*,
 enum xfer_buf_dir	{TO_XFER_BUF, FROM_XFER_BUF};
 
 extern unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
-	unsigned int buflen, struct scsi_cmnd *srb, unsigned int *index,
+	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **,
 	unsigned int *offset, enum xfer_buf_dir dir);
 
 extern void usb_stor_set_xfer_buf(unsigned char *buffer,
diff --git a/drivers/usb/storage/sddr09.c b/drivers/usb/storage/sddr09.c
index b2ed2a3..b12202c 100644
--- a/drivers/usb/storage/sddr09.c
+++ b/drivers/usb/storage/sddr09.c
@@ -705,7 +705,8 @@ sddr09_read_data(struct us_data *us,
 	unsigned char *buffer;
 	unsigned int lba, maxlba, pba;
 	unsigned int page, pages;
-	unsigned int len, index, offset;
+	unsigned int len, offset;
+	struct scatterlist *sg;
 	int result;
 
 	// Figure out the initial LBA and page
@@ -730,7 +731,8 @@ sddr09_read_data(struct us_data *us,
 	// contiguous LBA's. Another exercise left to the student.
 
 	result = 0;
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors > 0) {
 
@@ -777,7 +779,7 @@ sddr09_read_data(struct us_data *us,
 
 		// Store the data in the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, TO_XFER_BUF);
+				&sg, &offset, TO_XFER_BUF);
 
 		page = 0;
 		lba++;
@@ -931,7 +933,8 @@ sddr09_write_data(struct us_data *us,
 	unsigned int pagelen, blocklen;
 	unsigned char *blockbuffer;
 	unsigned char *buffer;
-	unsigned int len, index, offset;
+	unsigned int len, offset;
+	struct scatterlist *sg;
 	int result;
 
 	// Figure out the initial LBA and page
@@ -968,7 +971,8 @@ sddr09_write_data(struct us_data *us,
 	}
 
 	result = 0;
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors > 0) {
 
@@ -987,7 +991,7 @@ sddr09_write_data(struct us_data *us,
 
 		// Get the data from the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, FROM_XFER_BUF);
+				&sg, &offset, FROM_XFER_BUF);
 
 		result = sddr09_write_lba(us, lba, page, pages,
 				buffer, blockbuffer);
diff --git a/drivers/usb/storage/sddr55.c b/drivers/usb/storage/sddr55.c
index 0b1b5b5..d43a341 100644
--- a/drivers/usb/storage/sddr55.c
+++ b/drivers/usb/storage/sddr55.c
@@ -167,7 +167,8 @@ static int sddr55_read_data(struct us_data *us,
 	unsigned long address;
 
 	unsigned short pages;
-	unsigned int len, index, offset;
+	unsigned int len, offset;
+	struct scatterlist *sg;
 
 	// Since we only read in one block at a time, we have to create
 	// a bounce buffer and move the data a piece at a time between the
@@ -178,7 +179,8 @@ static int sddr55_read_data(struct us_data *us,
 	buffer = kmalloc(len, GFP_NOIO);
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR; /* out of memory */
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors>0) {
 
@@ -255,7 +257,7 @@ static int sddr55_read_data(struct us_data *us,
 
 		// Store the data in the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, TO_XFER_BUF);
+				&sg, &offset, TO_XFER_BUF);
 
 		page = 0;
 		lba++;
@@ -287,7 +289,8 @@ static int sddr55_write_data(struct us_data *us,
 
 	unsigned short pages;
 	int i;
-	unsigned int len, index, offset;
+	unsigned int len, offset;
+	struct scatterlist *sg;
 
 	/* check if we are allowed to write */
 	if (info->read_only || info->force_read_only) {
@@ -304,7 +307,8 @@ static int sddr55_write_data(struct us_data *us,
 	buffer = kmalloc(len, GFP_NOIO);
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
-	index = offset = 0;
+	offset = 0;
+	sg = NULL;
 
 	while (sectors > 0) {
 
@@ -322,7 +326,7 @@ static int sddr55_write_data(struct us_data *us,
 
 		// Get the data from the transfer buffer
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&index, &offset, FROM_XFER_BUF);
+				&sg, &offset, FROM_XFER_BUF);
 
 		US_DEBUGP("Write %02X pages, to PBA %04X"
 			" (LBA %04X) page %02X\n",
diff --git a/drivers/usb/storage/shuttle_usbat.c b/drivers/usb/storage/shuttle_usbat.c
index 5e27297..a0ff394 100644
--- a/drivers/usb/storage/shuttle_usbat.c
+++ b/drivers/usb/storage/shuttle_usbat.c
@@ -996,7 +996,8 @@ static int usbat_flash_read_data(struct us_data *us,
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	result = usbat_flash_check_media(us, info);
 	if (result != USB_STOR_TRANSPORT_GOOD)
@@ -1050,7 +1051,7 @@ static int usbat_flash_read_data(struct us_data *us,
 	
 		/* Store the data in the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-					 &sg_idx, &sg_offset, TO_XFER_BUF);
+					 &sg, &sg_offset, TO_XFER_BUF);
 
 		sector += thistime;
 		totallen -= len;
@@ -1086,7 +1087,8 @@ static int usbat_flash_write_data(struct us_data *us,
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_idx = 0, sg_offset = 0;
+	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	result = usbat_flash_check_media(us, info);
 	if (result != USB_STOR_TRANSPORT_GOOD)
@@ -1125,7 +1127,7 @@ static int usbat_flash_write_data(struct us_data *us,
 
 		/* Get the data from the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, us->srb,
-					 &sg_idx, &sg_offset, FROM_XFER_BUF);
+					 &sg, &sg_offset, FROM_XFER_BUF);
 
 		/* ATA command 0x30 (WRITE SECTORS) */
 		usbat_pack_ata_sector_cmd(command, thistime, sector, 0x30);
@@ -1165,8 +1167,8 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	unsigned char *buffer;
 	unsigned int len;
 	unsigned int sector;
-	unsigned int sg_segment = 0;
 	unsigned int sg_offset = 0;
+	struct scatterlist *sg = NULL;
 
 	US_DEBUGP("handle_read10: transfersize %d\n",
 		srb->transfersize);
@@ -1223,9 +1225,6 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 	sector |= short_pack(data[7+5], data[7+4]);
 	transferred = 0;
 
-	sg_segment = 0; /* for keeping track of where we are in */
-	sg_offset = 0;  /* the scatter/gather list */
-
 	while (transferred != srb->request_bufflen) {
 
 		if (len > srb->request_bufflen - transferred)
@@ -1258,7 +1257,7 @@ static int usbat_hp8200e_handle_read10(struct us_data *us,
 
 		/* Store the data in the transfer buffer */
 		usb_stor_access_xfer_buf(buffer, len, srb,
-				 &sg_segment, &sg_offset, TO_XFER_BUF);
+				 &sg, &sg_offset, TO_XFER_BUF);
 
 		/* Update the amount transferred and the sector number */
 
-- 
1.5.3.rc0.90.gbaa79

