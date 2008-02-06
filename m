From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Wed, 6 Feb 2008 15:23:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802061516110.5359-100000@iolanthe.rowland.org>
References: <20080205175403.GA31714@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080205175403.GA31714-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Cc: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 5 Feb 2008, Matthew Dharm wrote:

> Six of one and a half-dozen of the other.  All we're arguing over is the
> definition of "correct behavior" here.  You want to change the API so that
> overrun is acceptable and handled; I prefer calling it a Bad Thing(tm).
> 
> We both agree that the code shouldn't run off the end of the s-g list.
> 
> Since you've already committed to updating the patch, then we can do it
> your way.  Just make sure it's very very clear in the comments.

Okay, here's my version.  It makes some significant changes to the 
interface for usb_stor_access_xfer_buf() -- in particular, the context 
information is now stored in an opaque structure rather than in ad-hoc 
local variables.  All the callers are updated to use the new interface.

Functionally it's almost the same as before.  It's more careful about
not letting callers overrun the transfer buffer, and it can now set the
SCSI residue when a copy is finished.

This patch applies to 2.6.24.  If it's acceptable I'll send a patch for 
2.6.25-rc1 (once it has been released), complete with Changelog and 
a Signed-off-by: line.

Note that this has been compile-tested only!  Verification that it 
works okay would be appreciated.

Alan Stern


Index: 2.6.24/drivers/usb/storage/protocol.h
===================================================================
--- 2.6.24.orig/drivers/usb/storage/protocol.h
+++ 2.6.24/drivers/usb/storage/protocol.h
@@ -48,13 +48,23 @@ extern void usb_stor_ufi_command(struct 
 extern void usb_stor_transparent_scsi_command(struct scsi_cmnd*,
 		struct us_data*);
 
-/* struct scsi_cmnd transfer buffer access utilities */
+/* Utility routines for accessing data in scsi_cmnd transfer buffers */
 enum xfer_buf_dir	{TO_XFER_BUF, FROM_XFER_BUF};
 
+struct xfer_buf_params {
+	struct scsi_cmnd	*srb;
+	struct scatterlist	*sg;
+	enum xfer_buf_dir	dir;
+	unsigned int		offset;
+	unsigned int		count;
+};
+
+extern void usb_stor_init_xfer_buf(struct xfer_buf_params *xbp,
+		struct us_data *us, enum xfer_buf_dir dir);
 extern unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
-	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **,
-	unsigned int *offset, enum xfer_buf_dir dir);
+		unsigned int buflen, struct xfer_buf_params *xbp);
+extern void usb_stor_finish_xfer_buf(struct xfer_buf_params *xbp);
 
 extern void usb_stor_set_xfer_buf(unsigned char *buffer,
-	unsigned int buflen, struct scsi_cmnd *srb);
+	unsigned int buflen, struct us_data *us);
 #endif
Index: 2.6.24/drivers/usb/storage/protocol.c
===================================================================
--- 2.6.24.orig/drivers/usb/storage/protocol.c
+++ 2.6.24/drivers/usb/storage/protocol.c
@@ -148,33 +148,66 @@ void usb_stor_transparent_scsi_command(s
  * Scatter-gather transfer buffer access routines
  ***********************************************************************/
 
-/* Copy a buffer of length buflen to/from the srb's transfer buffer.
- * (Note: for scatter-gather transfers (srb->use_sg > 0), srb->request_buffer
- * points to a list of s-g entries and we ignore srb->request_bufflen.
- * For non-scatter-gather transfers, srb->request_buffer points to the
- * transfer buffer itself and srb->request_bufflen is the buffer's length.)
- * Update the *index and *offset variables so that the next copy will
- * pick up from where this one left off. */
+/* usb_stor_init_xfer_buf - initialize an xfer_buf_params structure
+ *
+ * Store in @xbp the values needed for accessing a transfer buffer
+ * through several calls to usb_stor_access_xfer_buf().  The sg
+ * and offset members are initialized to point to the start of the
+ * transfer buffer for @us->srb.
+ */
+void usb_stor_init_xfer_buf(struct xfer_buf_params *xbp,
+		struct us_data *us, enum xfer_buf_dir dir)
+{
+	xbp->srb = us->srb;
+	xbp->sg = (struct scatterlist *) xbp->srb->request_buffer;
+	xbp->dir = dir;
+	xbp->offset = 0;
+	xbp->count = 0;
+}
 
+/* usb_stor_access_xfer_buf - copy data to/from a scsi_cmnd's transfer buffer
+ *
+ * Copy data between @buffer and @xbp->srb's transfer buffer.  Data
+ * can be copied incrementally through successive calls to this routine;
+ * each copy will pick up from the location in the transfer buffer where
+ * the previous call left off.
+ *
+ * The direction of the copy is as specified in usb_stor_init_xfer_buf(),
+ * which must have been called earlier.
+ *
+ * The amount of data to copy is given by @buflen, but it is limited
+ * by @xbp->srb->request_bufflen as well as by the total length of
+ * the scatter-gather buffers (if @xbp->srb uses scatter-gather).
+ * It's not an error for the caller to try copying too much data;
+ * when that happens only the data that fits will be copied.
+ *
+ * The sg and offset members of @xbp are updated to point to the next
+ * location in the transfer buffer.  The count member is updated to
+ * keep track of the total number of bytes copied across multiple
+ * calls.
+ *
+ * Returns the number of bytes transferred in this call.
+ */
 unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
-	unsigned int buflen, struct scsi_cmnd *srb, struct scatterlist **sgptr,
-	unsigned int *offset, enum xfer_buf_dir dir)
+	unsigned int buflen, struct xfer_buf_params *xbp)
 {
 	unsigned int cnt;
 
-	/* If not using scatter-gather, just transfer the data directly.
-	 * Make certain it will fit in the available buffer space. */
-	if (srb->use_sg == 0) {
-		if (*offset >= srb->request_bufflen)
-			return 0;
-		cnt = min(buflen, srb->request_bufflen - *offset);
-		if (dir == TO_XFER_BUF)
-			memcpy((unsigned char *) srb->request_buffer + *offset,
+	/* Make sure we don't try to copy too much data */
+	buflen = min(buflen, xbp->srb->request_bufflen - xbp->count);
+
+	/* If not using scatter-gather, just transfer the data directly */
+	if (xbp->srb->use_sg == 0) {
+		cnt = buflen;
+		if (xbp->dir == TO_XFER_BUF)
+			memcpy(xbp->offset + (unsigned char *)
+					xbp->srb->request_buffer,
 					buffer, cnt);
 		else
-			memcpy(buffer, (unsigned char *) srb->request_buffer +
-					*offset, cnt);
-		*offset += cnt;
+			memcpy(buffer, xbp->offset + (unsigned char *)
+					xbp->srb->request_buffer, cnt);
+		xbp->offset += cnt;
+	}
 
 	/* Using scatter-gather.  We have to go through the list one entry
 	 * at a time.  Each s-g entry contains some number of pages, and
@@ -183,34 +216,32 @@ unsigned int usb_stor_access_xfer_buf(un
 	 * If the page is not directly accessible -- such as a user buffer
 	 * located in high memory -- then kmap() will map it to a temporary
 	 * position in the kernel's virtual address space. */
-	} else {
-		struct scatterlist *sg = *sgptr;
-
-		if (!sg)
-			sg = (struct scatterlist *) srb->request_buffer;
+	else {
 
 		/* This loop handles a single s-g list entry, which may
 		 * include multiple pages.  Find the initial page structure
 		 * and the starting offset within the page, and update
 		 * the *offset and *index values for the next loop. */
 		cnt = 0;
-		while (cnt < buflen) {
-			struct page *page = sg_page(sg) +
-					((sg->offset + *offset) >> PAGE_SHIFT);
+		while (cnt < buflen && xbp->sg) {
+			struct page *page = sg_page(xbp->sg) +
+					((xbp->sg->offset + xbp->offset) >>
+						PAGE_SHIFT);
 			unsigned int poff =
-					(sg->offset + *offset) & (PAGE_SIZE-1);
-			unsigned int sglen = sg->length - *offset;
+					(xbp->sg->offset + xbp->offset) &
+						(PAGE_SIZE-1);
+			unsigned int sglen = xbp->sg->length - xbp->offset;
 
 			if (sglen > buflen - cnt) {
 
 				/* Transfer ends within this s-g entry */
 				sglen = buflen - cnt;
-				*offset += sglen;
+				xbp->offset += sglen;
 			} else {
 
 				/* Transfer continues to next s-g entry */
-				*offset = 0;
-				sg = sg_next(sg);
+				xbp->offset = 0;
+				xbp->sg = sg_next(xbp->sg);
 			}
 
 			/* Transfer the data for all the pages in this
@@ -221,7 +252,7 @@ unsigned int usb_stor_access_xfer_buf(un
 						PAGE_SIZE - poff);
 				unsigned char *ptr = kmap(page);
 
-				if (dir == TO_XFER_BUF)
+				if (xbp->dir == TO_XFER_BUF)
 					memcpy(ptr + poff, buffer + cnt, plen);
 				else
 					memcpy(buffer + cnt, ptr + poff, plen);
@@ -234,23 +265,31 @@ unsigned int usb_stor_access_xfer_buf(un
 				sglen -= plen;
 			}
 		}
-		*sgptr = sg;
 	}
 
 	/* Return the amount actually transferred */
+	xbp->count += cnt;
 	return cnt;
 }
 
+/* usb_stor_finish_xfer_buf - end a transfer buffer data copy
+ *
+ * Sets @xbp->srb->resid based on the total amount of data copied.
+ */
+void usb_stor_finish_xfer_buf(struct xfer_buf_params *xbp)
+{
+	if (xbp->count < xbp->srb->request_bufflen)
+		xbp->srb->resid = xbp->srb->request_bufflen - xbp->count;
+}
+
 /* Store the contents of buffer into srb's transfer buffer and set the
  * SCSI residue. */
 void usb_stor_set_xfer_buf(unsigned char *buffer,
-	unsigned int buflen, struct scsi_cmnd *srb)
+	unsigned int buflen, struct us_data *us)
 {
-	unsigned int offset = 0;
-	struct scatterlist *sg = NULL;
+	struct xfer_buf_params xbp;
 
-	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
-			TO_XFER_BUF);
-	if (buflen < srb->request_bufflen)
-		srb->resid = srb->request_bufflen - buflen;
+	usb_stor_init_xfer_buf(&xbp, us, TO_XFER_BUF);
+	usb_stor_access_xfer_buf(buffer, buflen, &xbp);
+	usb_stor_finish_xfer_buf(&xbp);
 }
Index: 2.6.24/drivers/usb/storage/alauda.c
===================================================================
--- 2.6.24.orig/drivers/usb/storage/alauda.c
+++ 2.6.24/drivers/usb/storage/alauda.c
@@ -798,14 +798,14 @@ static int alauda_read_data(struct us_da
 {
 	unsigned char *buffer;
 	u16 lba, max_lba;
-	unsigned int page, len, offset;
+	unsigned int page, len;
 	unsigned int blockshift = MEDIA_INFO(us).blockshift;
 	unsigned int pageshift = MEDIA_INFO(us).pageshift;
 	unsigned int blocksize = MEDIA_INFO(us).blocksize;
 	unsigned int pagesize = MEDIA_INFO(us).pagesize;
 	unsigned int uzonesize = MEDIA_INFO(us).uzonesize;
-	struct scatterlist *sg;
 	int result;
+	struct xfer_buf_params xbp;
 
 	/*
 	 * Since we only read in one block at a time, we have to create
@@ -828,8 +828,7 @@ static int alauda_read_data(struct us_da
 	max_lba = MEDIA_INFO(us).capacity >> (blockshift + pageshift);
 
 	result = USB_STOR_TRANSPORT_GOOD;
-	offset = 0;
-	sg = NULL;
+	usb_stor_init_xfer_buf(&xbp, us, TO_XFER_BUF);
 
 	while (sectors > 0) {
 		unsigned int zone = lba / uzonesize; /* integer division */
@@ -874,13 +873,13 @@ static int alauda_read_data(struct us_da
 		}
 
 		/* Store the data in the transfer buffer */
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg, &offset, TO_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		page = 0;
 		lba++;
 		sectors -= pages;
 	}
+	usb_stor_finish_xfer_buf(&xbp);
 
 	kfree(buffer);
 	return result;
@@ -893,14 +892,14 @@ static int alauda_write_data(struct us_d
 		unsigned int sectors)
 {
 	unsigned char *buffer, *blockbuffer;
-	unsigned int page, len, offset;
+	unsigned int page, len;
 	unsigned int blockshift = MEDIA_INFO(us).blockshift;
 	unsigned int pageshift = MEDIA_INFO(us).pageshift;
 	unsigned int blocksize = MEDIA_INFO(us).blocksize;
 	unsigned int pagesize = MEDIA_INFO(us).pagesize;
-	struct scatterlist *sg;
 	u16 lba, max_lba;
 	int result;
+	struct xfer_buf_params xbp;
 
 	/*
 	 * Since we don't write the user data directly to the device,
@@ -932,8 +931,7 @@ static int alauda_write_data(struct us_d
 	max_lba = MEDIA_INFO(us).capacity >> (pageshift + blockshift);
 
 	result = USB_STOR_TRANSPORT_GOOD;
-	offset = 0;
-	sg = NULL;
+	usb_stor_init_xfer_buf(&xbp, us, FROM_XFER_BUF);
 
 	while (sectors > 0) {
 		/* Write as many sectors as possible in this block */
@@ -949,8 +947,7 @@ static int alauda_write_data(struct us_d
 		}
 
 		/* Get the data from the transfer buffer */
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg, &offset, FROM_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		result = alauda_write_lba(us, lba, page, pages, buffer,
 			blockbuffer);
@@ -961,6 +958,7 @@ static int alauda_write_data(struct us_d
 		lba++;
 		sectors -= pages;
 	}
+	usb_stor_finish_xfer_buf(&xbp);
 
 	kfree(buffer);
 	kfree(blockbuffer);
@@ -1053,7 +1051,7 @@ int alauda_transport(struct scsi_cmnd *s
 		((__be32 *) ptr)[0] = cpu_to_be32(capacity - 1);
 		((__be32 *) ptr)[1] = cpu_to_be32(512);
 
-		usb_stor_set_xfer_buf(ptr, 8, srb);
+		usb_stor_set_xfer_buf(ptr, 8, us);
 		return USB_STOR_TRANSPORT_GOOD;
 	}
 
@@ -1102,7 +1100,7 @@ int alauda_transport(struct scsi_cmnd *s
 		ptr[7] = 11;
 		ptr[12] = info->sense_asc;
 		ptr[13] = info->sense_ascq;
-		usb_stor_set_xfer_buf(ptr, 18, srb);
+		usb_stor_set_xfer_buf(ptr, 18, us);
 
 		return USB_STOR_TRANSPORT_GOOD;
 	}
Index: 2.6.24/drivers/usb/storage/datafab.c
===================================================================
--- 2.6.24.orig/drivers/usb/storage/datafab.c
+++ 2.6.24/drivers/usb/storage/datafab.c
@@ -98,8 +98,7 @@ static int datafab_read_data(struct us_d
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_offset = 0;
-	struct scatterlist *sg = NULL;
+	struct xfer_buf_params xbp;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Datafab
@@ -126,6 +125,7 @@ static int datafab_read_data(struct us_d
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
 
+	usb_stor_init_xfer_buf(&xbp, us, TO_XFER_BUF);
 	do {
 		// loop, never allocate or transfer more than 64k at once
 		// (min(128k, 255*info->ssize) is the real limit)
@@ -155,13 +155,13 @@ static int datafab_read_data(struct us_d
 			goto leave;
 
 		// Store the data in the transfer buffer
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				 &sg, &sg_offset, TO_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		sector += thistime;
 		totallen -= len;
 	} while (totallen > 0);
 
+	usb_stor_finish_xfer_buf(&xbp);
 	kfree(buffer);
 	return USB_STOR_TRANSPORT_GOOD;
 
@@ -182,8 +182,7 @@ static int datafab_write_data(struct us_
 	unsigned char thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_offset = 0;
-	struct scatterlist *sg = NULL;
+	struct xfer_buf_params xbp;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Datafab
@@ -210,6 +209,7 @@ static int datafab_write_data(struct us_
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
 
+	usb_stor_init_xfer_buf(&xbp, us, FROM_XFER_BUF);
 	do {
 		// loop, never allocate or transfer more than 64k at once
 		// (min(128k, 255*info->ssize) is the real limit)
@@ -218,8 +218,7 @@ static int datafab_write_data(struct us_
 		thistime = (len / info->ssize) & 0xff;
 
 		// Get the data from the transfer buffer
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg, &sg_offset, FROM_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		command[0] = 0;
 		command[1] = thistime;
@@ -259,6 +258,7 @@ static int datafab_write_data(struct us_
 		totallen -= len;
 	} while (totallen > 0);
 
+	usb_stor_finish_xfer_buf(&xbp);
 	kfree(buffer);
 	return USB_STOR_TRANSPORT_GOOD;
 
@@ -488,7 +488,7 @@ static int datafab_handle_mode_sense(str
 		ptr[0] = i - 1;
 	else
 		((__be16 *) ptr)[0] = cpu_to_be16(i - 2);
-	usb_stor_set_xfer_buf(ptr, i, srb);
+	usb_stor_set_xfer_buf(ptr, i, us);
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
@@ -545,7 +545,7 @@ int datafab_transport(struct scsi_cmnd *
 		// we need the last sector, not the number of sectors
 		((__be32 *) ptr)[0] = cpu_to_be32(info->sectors - 1);
 		((__be32 *) ptr)[1] = cpu_to_be32(info->ssize);
-		usb_stor_set_xfer_buf(ptr, 8, srb);
+		usb_stor_set_xfer_buf(ptr, 8, us);
 
 		return USB_STOR_TRANSPORT_GOOD;
 	}
@@ -621,7 +621,7 @@ int datafab_transport(struct scsi_cmnd *
 		ptr[7] = 11;
 		ptr[12] = info->sense_asc;
 		ptr[13] = info->sense_ascq;
-		usb_stor_set_xfer_buf(ptr, 18, srb);
+		usb_stor_set_xfer_buf(ptr, 18, us);
 
 		return USB_STOR_TRANSPORT_GOOD;
 	}
Index: 2.6.24/drivers/usb/storage/isd200.c
===================================================================
--- 2.6.24.orig/drivers/usb/storage/isd200.c
+++ 2.6.24/drivers/usb/storage/isd200.c
@@ -1248,7 +1248,7 @@ static int isd200_scsi_to_ata(struct scs
 
 		/* copy InquiryData */
 		usb_stor_set_xfer_buf((unsigned char *) &info->InquiryData,
-				sizeof(info->InquiryData), srb);
+				sizeof(info->InquiryData), us);
 		srb->result = SAM_STAT_GOOD;
 		sendToTransport = 0;
 		break;
@@ -1257,7 +1257,7 @@ static int isd200_scsi_to_ata(struct scs
 		US_DEBUGP("   ATA OUT - SCSIOP_MODE_SENSE\n");
 
 		/* Initialize the return buffer */
-		usb_stor_set_xfer_buf(senseData, sizeof(senseData), srb);
+		usb_stor_set_xfer_buf(senseData, sizeof(senseData), us);
 
 		if (info->DeviceFlags & DF_MEDIA_STATUS_ENABLED)
 		{
@@ -1310,7 +1310,7 @@ static int isd200_scsi_to_ata(struct scs
 		readCapacityData.BytesPerBlock = cpu_to_be32(0x200);
 
 		usb_stor_set_xfer_buf((unsigned char *) &readCapacityData,
-				sizeof(readCapacityData), srb);
+				sizeof(readCapacityData), us);
 		srb->result = SAM_STAT_GOOD;
 		sendToTransport = 0;
 	}
Index: 2.6.24/drivers/usb/storage/jumpshot.c
===================================================================
--- 2.6.24.orig/drivers/usb/storage/jumpshot.c
+++ 2.6.24/drivers/usb/storage/jumpshot.c
@@ -119,8 +119,7 @@ static int jumpshot_read_data(struct us_
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_offset = 0;
-	struct scatterlist *sg = NULL;
+	struct xfer_buf_params xbp;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Jumpshot
@@ -141,6 +140,7 @@ static int jumpshot_read_data(struct us_
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
 
+	usb_stor_init_xfer_buf(&xbp, us, TO_XFER_BUF);
 	do {
 		// loop, never allocate or transfer more than 64k at once
 		// (min(128k, 255*info->ssize) is the real limit)
@@ -170,13 +170,13 @@ static int jumpshot_read_data(struct us_
 		US_DEBUGP("jumpshot_read_data:  %d bytes\n", len);
 
 		// Store the data in the transfer buffer
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				 &sg, &sg_offset, TO_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		sector += thistime;
 		totallen -= len;
 	} while (totallen > 0);
 
+	usb_stor_finish_xfer_buf(&xbp);
 	kfree(buffer);
 	return USB_STOR_TRANSPORT_GOOD;
 
@@ -196,8 +196,7 @@ static int jumpshot_write_data(struct us
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result, waitcount;
-	unsigned int sg_offset = 0;
-	struct scatterlist *sg = NULL;
+	struct xfer_buf_params xbp;
 
 	// we're working in LBA mode.  according to the ATA spec, 
 	// we can support up to 28-bit addressing.  I don't know if Jumpshot
@@ -218,6 +217,7 @@ static int jumpshot_write_data(struct us
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
 
+	usb_stor_init_xfer_buf(&xbp, us, FROM_XFER_BUF);
 	do {
 		// loop, never allocate or transfer more than 64k at once
 		// (min(128k, 255*info->ssize) is the real limit)
@@ -226,8 +226,7 @@ static int jumpshot_write_data(struct us
 		thistime = (len / info->ssize) & 0xff;
 
 		// Get the data from the transfer buffer
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg, &sg_offset, FROM_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		command[0] = 0;
 		command[1] = thistime;
@@ -269,6 +268,7 @@ static int jumpshot_write_data(struct us
 		totallen -= len;
 	} while (totallen > 0);
 
+	usb_stor_finish_xfer_buf(&xbp);
 	kfree(buffer);
 	return result;
 
@@ -415,7 +415,7 @@ static int jumpshot_handle_mode_sense(st
 		ptr[0] = i - 1;
 	else
 		((__be16 *) ptr)[0] = cpu_to_be16(i - 2);
-	usb_stor_set_xfer_buf(ptr, i, srb);
+	usb_stor_set_xfer_buf(ptr, i, us);
 
 	return USB_STOR_TRANSPORT_GOOD;
 }
@@ -477,7 +477,7 @@ int jumpshot_transport(struct scsi_cmnd 
 		//
 		((__be32 *) ptr)[0] = cpu_to_be32(info->sectors - 1);
 		((__be32 *) ptr)[1] = cpu_to_be32(info->ssize);
-		usb_stor_set_xfer_buf(ptr, 8, srb);
+		usb_stor_set_xfer_buf(ptr, 8, us);
 
 		return USB_STOR_TRANSPORT_GOOD;
 	}
@@ -548,7 +548,7 @@ int jumpshot_transport(struct scsi_cmnd 
 		ptr[7] = 11;
 		ptr[12] = info->sense_asc;
 		ptr[13] = info->sense_ascq;
-		usb_stor_set_xfer_buf(ptr, 18, srb);
+		usb_stor_set_xfer_buf(ptr, 18, us);
 
 		return USB_STOR_TRANSPORT_GOOD;
 	}
Index: 2.6.24/drivers/usb/storage/sddr09.c
===================================================================
--- 2.6.24.orig/drivers/usb/storage/sddr09.c
+++ 2.6.24/drivers/usb/storage/sddr09.c
@@ -705,9 +705,9 @@ sddr09_read_data(struct us_data *us,
 	unsigned char *buffer;
 	unsigned int lba, maxlba, pba;
 	unsigned int page, pages;
-	unsigned int len, offset;
-	struct scatterlist *sg;
+	unsigned int len;
 	int result;
+	struct xfer_buf_params xbp;
 
 	// Figure out the initial LBA and page
 	lba = address >> info->blockshift;
@@ -731,8 +731,7 @@ sddr09_read_data(struct us_data *us,
 	// contiguous LBA's. Another exercise left to the student.
 
 	result = 0;
-	offset = 0;
-	sg = NULL;
+	usb_stor_init_xfer_buf(&xbp, us, TO_XFER_BUF);
 
 	while (sectors > 0) {
 
@@ -778,14 +777,14 @@ sddr09_read_data(struct us_data *us,
 		}
 
 		// Store the data in the transfer buffer
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg, &offset, TO_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		page = 0;
 		lba++;
 		sectors -= pages;
 	}
 
+	usb_stor_finish_xfer_buf(&xbp);
 	kfree(buffer);
 	return result;
 }
@@ -933,9 +932,9 @@ sddr09_write_data(struct us_data *us,
 	unsigned int pagelen, blocklen;
 	unsigned char *blockbuffer;
 	unsigned char *buffer;
-	unsigned int len, offset;
-	struct scatterlist *sg;
+	unsigned int len;
 	int result;
+	struct xfer_buf_params xbp;
 
 	// Figure out the initial LBA and page
 	lba = address >> info->blockshift;
@@ -971,8 +970,7 @@ sddr09_write_data(struct us_data *us,
 	}
 
 	result = 0;
-	offset = 0;
-	sg = NULL;
+	usb_stor_init_xfer_buf(&xbp, us, FROM_XFER_BUF);
 
 	while (sectors > 0) {
 
@@ -990,8 +988,7 @@ sddr09_write_data(struct us_data *us,
 		}
 
 		// Get the data from the transfer buffer
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg, &offset, FROM_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		result = sddr09_write_lba(us, lba, page, pages,
 				buffer, blockbuffer);
@@ -1003,6 +1000,7 @@ sddr09_write_data(struct us_data *us,
 		sectors -= pages;
 	}
 
+	usb_stor_finish_xfer_buf(&xbp);
 	kfree(buffer);
 	kfree(blockbuffer);
 
@@ -1480,7 +1478,7 @@ int sddr09_transport(struct scsi_cmnd *s
 		ptr[2] = sensekey;
 		ptr[7] = 11;
 		ptr[12] = sensecode;
-		usb_stor_set_xfer_buf(ptr, 18, srb);
+		usb_stor_set_xfer_buf(ptr, 18, us);
 		sensekey = sensecode = havefakesense = 0;
 		return USB_STOR_TRANSPORT_GOOD;
 	}
@@ -1532,7 +1530,7 @@ int sddr09_transport(struct scsi_cmnd *s
 		// Report page size
 
 		((__be32 *) ptr)[1] = cpu_to_be32(info->pagesize);
-		usb_stor_set_xfer_buf(ptr, 8, srb);
+		usb_stor_set_xfer_buf(ptr, 8, us);
 
 		return USB_STOR_TRANSPORT_GOOD;
 	}
@@ -1550,7 +1548,7 @@ int sddr09_transport(struct scsi_cmnd *s
 			memcpy(ptr, mode_page_01, sizeof(mode_page_01));
 			((__be16*)ptr)[0] = cpu_to_be16(sizeof(mode_page_01) - 2);
 			ptr[3] = (info->flags & SDDR09_WP) ? 0x80 : 0;
-			usb_stor_set_xfer_buf(ptr, sizeof(mode_page_01), srb);
+			usb_stor_set_xfer_buf(ptr, sizeof(mode_page_01), us);
 			return USB_STOR_TRANSPORT_GOOD;
 		}
 
Index: 2.6.24/drivers/usb/storage/sddr55.c
===================================================================
--- 2.6.24.orig/drivers/usb/storage/sddr55.c
+++ 2.6.24/drivers/usb/storage/sddr55.c
@@ -167,8 +167,8 @@ static int sddr55_read_data(struct us_da
 	unsigned long address;
 
 	unsigned short pages;
-	unsigned int len, offset;
-	struct scatterlist *sg;
+	unsigned int len;
+	struct xfer_buf_params xbp;
 
 	// Since we only read in one block at a time, we have to create
 	// a bounce buffer and move the data a piece at a time between the
@@ -179,8 +179,7 @@ static int sddr55_read_data(struct us_da
 	buffer = kmalloc(len, GFP_NOIO);
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR; /* out of memory */
-	offset = 0;
-	sg = NULL;
+	usb_stor_init_xfer_buf(&xbp, us, TO_XFER_BUF);
 
 	while (sectors>0) {
 
@@ -256,14 +255,14 @@ static int sddr55_read_data(struct us_da
 		}
 
 		// Store the data in the transfer buffer
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg, &offset, TO_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		page = 0;
 		lba++;
 		sectors -= pages >> info->smallpageshift;
 	}
 
+	usb_stor_finish_xfer_buf(&xbp);
 	result = USB_STOR_TRANSPORT_GOOD;
 
 leave:
@@ -289,8 +288,8 @@ static int sddr55_write_data(struct us_d
 
 	unsigned short pages;
 	int i;
-	unsigned int len, offset;
-	struct scatterlist *sg;
+	unsigned int len;
+	struct xfer_buf_params xbp;
 
 	/* check if we are allowed to write */
 	if (info->read_only || info->force_read_only) {
@@ -307,8 +306,7 @@ static int sddr55_write_data(struct us_d
 	buffer = kmalloc(len, GFP_NOIO);
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
-	offset = 0;
-	sg = NULL;
+	usb_stor_init_xfer_buf(&xbp, us, FROM_XFER_BUF);
 
 	while (sectors > 0) {
 
@@ -325,8 +323,7 @@ static int sddr55_write_data(struct us_d
 		len = pages << info->pageshift;
 
 		// Get the data from the transfer buffer
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-				&sg, &offset, FROM_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		US_DEBUGP("Write %02X pages, to PBA %04X"
 			" (LBA %04X) page %02X\n",
@@ -472,6 +469,7 @@ static int sddr55_write_data(struct us_d
 		sectors -= pages >> info->smallpageshift;
 	}
 	result = USB_STOR_TRANSPORT_GOOD;
+	usb_stor_finish_xfer_buf(&xbp);
 
  leave:
 	kfree(buffer);
@@ -770,7 +768,7 @@ int sddr55_transport(struct scsi_cmnd *s
 		memcpy (ptr, info->sense_data, sizeof info->sense_data);
 		ptr[0] = 0x70;
 		ptr[7] = 11;
-		usb_stor_set_xfer_buf (ptr, sizeof info->sense_data, srb);
+		usb_stor_set_xfer_buf(ptr, sizeof info->sense_data, us);
 		memset (info->sense_data, 0, sizeof info->sense_data);
 
 		return USB_STOR_TRANSPORT_GOOD;
@@ -835,7 +833,7 @@ int sddr55_transport(struct scsi_cmnd *s
 
 		((__be32 *) ptr)[0] = cpu_to_be32(capacity);
 		((__be32 *) ptr)[1] = cpu_to_be32(PAGESIZE);
-		usb_stor_set_xfer_buf(ptr, 8, srb);
+		usb_stor_set_xfer_buf(ptr, 8, us);
 
 		sddr55_read_map(us);
 
@@ -846,7 +844,7 @@ int sddr55_transport(struct scsi_cmnd *s
 
 		memcpy(ptr, mode_page_01, sizeof mode_page_01);
 		ptr[3] = (info->read_only || info->force_read_only) ? 0x80 : 0;
-		usb_stor_set_xfer_buf(ptr, sizeof(mode_page_01), srb);
+		usb_stor_set_xfer_buf(ptr, sizeof(mode_page_01), us);
 
 		if ( (srb->cmnd[2] & 0x3F) == 0x01 ) {
 			US_DEBUGP(
Index: 2.6.24/drivers/usb/storage/shuttle_usbat.c
===================================================================
--- 2.6.24.orig/drivers/usb/storage/shuttle_usbat.c
+++ 2.6.24/drivers/usb/storage/shuttle_usbat.c
@@ -993,8 +993,7 @@ static int usbat_flash_read_data(struct 
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_offset = 0;
-	struct scatterlist *sg = NULL;
+	struct xfer_buf_params xbp;
 
 	result = usbat_flash_check_media(us, info);
 	if (result != USB_STOR_TRANSPORT_GOOD)
@@ -1023,6 +1022,7 @@ static int usbat_flash_read_data(struct 
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
 
+	usb_stor_init_xfer_buf(&xbp, us, TO_XFER_BUF);
 	do {
 		/*
 		 * loop, never allocate or transfer more than 64k at once
@@ -1047,13 +1047,13 @@ static int usbat_flash_read_data(struct 
 		US_DEBUGP("usbat_flash_read_data:  %d bytes\n", len);
 	
 		/* Store the data in the transfer buffer */
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-					 &sg, &sg_offset, TO_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		sector += thistime;
 		totallen -= len;
 	} while (totallen > 0);
 
+	usb_stor_finish_xfer_buf(&xbp);
 	kfree(buffer);
 	return USB_STOR_TRANSPORT_GOOD;
 
@@ -1084,8 +1084,7 @@ static int usbat_flash_write_data(struct
 	unsigned char  thistime;
 	unsigned int totallen, alloclen;
 	int len, result;
-	unsigned int sg_offset = 0;
-	struct scatterlist *sg = NULL;
+	struct xfer_buf_params xbp;
 
 	result = usbat_flash_check_media(us, info);
 	if (result != USB_STOR_TRANSPORT_GOOD)
@@ -1114,6 +1113,7 @@ static int usbat_flash_write_data(struct
 	if (buffer == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
 
+	usb_stor_init_xfer_buf(&xbp, us, FROM_XFER_BUF);
 	do {
 		/*
 		 * loop, never allocate or transfer more than 64k at once
@@ -1123,8 +1123,7 @@ static int usbat_flash_write_data(struct
 		thistime = (len / info->ssize) & 0xff;
 
 		/* Get the data from the transfer buffer */
-		usb_stor_access_xfer_buf(buffer, len, us->srb,
-					 &sg, &sg_offset, FROM_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		/* ATA command 0x30 (WRITE SECTORS) */
 		usbat_pack_ata_sector_cmd(command, thistime, sector, 0x30);
@@ -1143,6 +1142,7 @@ static int usbat_flash_write_data(struct
 		totallen -= len;
 	} while (totallen > 0);
 
+	usb_stor_finish_xfer_buf(&xbp);
 	kfree(buffer);
 	return result;
 
@@ -1164,8 +1164,7 @@ static int usbat_hp8200e_handle_read10(s
 	unsigned char *buffer;
 	unsigned int len;
 	unsigned int sector;
-	unsigned int sg_offset = 0;
-	struct scatterlist *sg = NULL;
+	struct xfer_buf_params xbp;
 
 	US_DEBUGP("handle_read10: transfersize %d\n",
 		srb->transfersize);
@@ -1222,6 +1221,7 @@ static int usbat_hp8200e_handle_read10(s
 	sector |= short_pack(data[7+5], data[7+4]);
 	transferred = 0;
 
+	usb_stor_init_xfer_buf(&xbp, us, TO_XFER_BUF);
 	while (transferred != srb->request_bufflen) {
 
 		if (len > srb->request_bufflen - transferred)
@@ -1253,8 +1253,7 @@ static int usbat_hp8200e_handle_read10(s
 			break;
 
 		/* Store the data in the transfer buffer */
-		usb_stor_access_xfer_buf(buffer, len, srb,
-				 &sg, &sg_offset, TO_XFER_BUF);
+		usb_stor_access_xfer_buf(buffer, len, &xbp);
 
 		/* Update the amount transferred and the sector number */
 
@@ -1263,6 +1262,7 @@ static int usbat_hp8200e_handle_read10(s
 
 	} /* while transferred != srb->request_bufflen */
 
+	usb_stor_finish_xfer_buf(&xbp);
 	kfree(buffer);
 	return result;
 }
@@ -1603,7 +1603,7 @@ static int usbat_flash_transport(struct 
 		 */
 		((__be32 *) ptr)[0] = cpu_to_be32(info->sectors - 1);
 		((__be32 *) ptr)[1] = cpu_to_be32(info->ssize);
-		usb_stor_set_xfer_buf(ptr, 8, srb);
+		usb_stor_set_xfer_buf(ptr, 8, us);
 
 		return USB_STOR_TRANSPORT_GOOD;
 	}
@@ -1681,7 +1681,7 @@ static int usbat_flash_transport(struct 
 		ptr[7] = 11;
 		ptr[12] = info->sense_asc;
 		ptr[13] = info->sense_ascq;
-		usb_stor_set_xfer_buf(ptr, 18, srb);
+		usb_stor_set_xfer_buf(ptr, 18, us);
 
 		return USB_STOR_TRANSPORT_GOOD;
 	}
Index: 2.6.24/drivers/usb/storage/usb.c
===================================================================
--- 2.6.24.orig/drivers/usb/storage/usb.c
+++ 2.6.24/drivers/usb/storage/usb.c
@@ -299,7 +299,7 @@ void fill_inquiry_response(struct us_dat
 		data[35] = 0x30 + ((bcdDevice) & 0x0F);
 	}
 
-	usb_stor_set_xfer_buf(data, data_len, us->srb);
+	usb_stor_set_xfer_buf(data, data_len, us);
 }
 
 static int usb_stor_control_thread(void * __us)
