From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/32] usb: protocol.c - convert to accessors and !use_sg code
 path removal
Date: Wed, 17 Oct 2007 19:29:24 +0200
Message-ID: <47164674.9040500@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:26202 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764978AbXJQRap (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 13:30:45 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Jeff Garzik <jeff@garzik.org>, Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


 - Use scsi data accessors and remove of !use_sg code path

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/protocol.c |  126 +++++++++++++++++-----------------------
 1 files changed, 53 insertions(+), 73 deletions(-)

diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index cc8f7c5..6a11caf 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -149,11 +149,7 @@ void usb_stor_transparent_scsi_command(struct scsi_cmnd *srb,
  ***********************************************************************/
 
 /* Copy a buffer of length buflen to/from the srb's transfer buffer.
- * (Note: for scatter-gather transfers (srb->use_sg > 0), srb->request_buffer
- * points to a list of s-g entries and we ignore srb->request_bufflen.
- * For non-scatter-gather transfers, srb->request_buffer points to the
- * transfer buffer itself and srb->request_bufflen is the buffer's length.)
- * Update the *index and *offset variables so that the next copy will
+ * Update the **sgptr and *offset variables so that the next copy will
  * pick up from where this one left off. */
 
 unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
@@ -162,80 +158,64 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
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
-					buffer, cnt);
-		else
-			memcpy(buffer, (unsigned char *) srb->request_buffer +
-					*offset, cnt);
-		*offset += cnt;
-
-	/* Using scatter-gather.  We have to go through the list one entry
+	/* We have to go through the list one entry
 	 * at a time.  Each s-g entry contains some number of pages, and
 	 * each page has to be kmap()'ed separately.  If the page is already
 	 * in kernel-addressable memory then kmap() will return its address.
 	 * If the page is not directly accessible -- such as a user buffer
 	 * located in high memory -- then kmap() will map it to a temporary
 	 * position in the kernel's virtual address space. */
-	} else {
-		struct scatterlist *sg = *sgptr;
-
-		if (!sg)
-			sg = (struct scatterlist *) srb->request_buffer;
-
-		/* This loop handles a single s-g list entry, which may
-		 * include multiple pages.  Find the initial page structure
-		 * and the starting offset within the page, and update
-		 * the *offset and *index values for the next loop. */
-		cnt = 0;
-		while (cnt < buflen) {
-			struct page *page = sg->page +
-					((sg->offset + *offset) >> PAGE_SHIFT);
-			unsigned int poff =
-					(sg->offset + *offset) & (PAGE_SIZE-1);
-			unsigned int sglen = sg->length - *offset;
-
-			if (sglen > buflen - cnt) {
-
-				/* Transfer ends within this s-g entry */
-				sglen = buflen - cnt;
-				*offset += sglen;
-			} else {
-
-				/* Transfer continues to next s-g entry */
-				*offset = 0;
-				sg = sg_next(sg);
-			}
-
-			/* Transfer the data for all the pages in this
-			 * s-g entry.  For each page: call kmap(), do the
-			 * transfer, and call kunmap() immediately after. */
-			while (sglen > 0) {
-				unsigned int plen = min(sglen, (unsigned int)
-						PAGE_SIZE - poff);
-				unsigned char *ptr = kmap(page);
-
-				if (dir == TO_XFER_BUF)
-					memcpy(ptr + poff, buffer + cnt, plen);
-				else
-					memcpy(buffer + cnt, ptr + poff, plen);
-				kunmap(page);
-
-				/* Start at the beginning of the next page */
-				poff = 0;
-				++page;
-				cnt += plen;
-				sglen -= plen;
-			}
+	struct scatterlist *sg = *sgptr;
+
+	if (!sg)
+		sg = scsi_sglist(srb);
+
+	/* This loop handles a single s-g list entry, which may
+		* include multiple pages.  Find the initial page structure
+		* and the starting offset within the page, and update
+		* the *offset and **sgptr values for the next loop. */
+	cnt = 0;
+	while (cnt < buflen) {
+		struct page *page = sg->page +
+				((sg->offset + *offset) >> PAGE_SHIFT);
+		unsigned int poff =
+				(sg->offset + *offset) & (PAGE_SIZE-1);
+		unsigned int sglen = sg->length - *offset;
+
+		if (sglen > buflen - cnt) {
+
+			/* Transfer ends within this s-g entry */
+			sglen = buflen - cnt;
+			*offset += sglen;
+		} else {
+
+			/* Transfer continues to next s-g entry */
+			*offset = 0;
+			sg = sg_next(sg);
+		}
+
+		/* Transfer the data for all the pages in this
+			* s-g entry.  For each page: call kmap(), do the
+			* transfer, and call kunmap() immediately after. */
+		while (sglen > 0) {
+			unsigned int plen = min(sglen, (unsigned int)
+					PAGE_SIZE - poff);
+			unsigned char *ptr = kmap(page);
+
+			if (dir == TO_XFER_BUF)
+				memcpy(ptr + poff, buffer + cnt, plen);
+			else
+				memcpy(buffer + cnt, ptr + poff, plen);
+			kunmap(page);
+
+			/* Start at the beginning of the next page */
+			poff = 0;
+			++page;
+			cnt += plen;
+			sglen -= plen;
 		}
-		*sgptr = sg;
 	}
+	*sgptr = sg;
 
 	/* Return the amount actually transferred */
 	return cnt;
@@ -251,6 +231,6 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
 
 	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
 			TO_XFER_BUF);
-	if (buflen < srb->request_bufflen)
-		srb->resid = srb->request_bufflen - buflen;
+	if (buflen < scsi_bufflen(srb))
+		scsi_set_resid(srb, scsi_bufflen(srb) - buflen);
 }
-- 
1.5.3.1


