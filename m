From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 02/24] usb: protocol.c - convert to accessors and !use_sg
 code path removal
Date: Wed, 12 Sep 2007 02:50:12 +0300
Message-ID: <46E729B4.10904@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27746 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761151AbXIKXuu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 19:50:50 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


 - Use scsi data accessors and remove of !use_sg code path

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/usb/storage/protocol.c |  120 ++++++++++++++++-----------------------
 1 files changed, 49 insertions(+), 71 deletions(-)

diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index 9ad3042..e9fc873 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -149,10 +149,6 @@ void usb_stor_transparent_scsi_command(struct scsi_cmnd *srb,
  ***********************************************************************/
 
 /* Copy a buffer of length buflen to/from the srb's transfer buffer.
- * (Note: for scatter-gather transfers (srb->use_sg > 0), srb->request_buffer
- * points to a list of s-g entries and we ignore srb->request_bufflen.
- * For non-scatter-gather transfers, srb->request_buffer points to the
- * transfer buffer itself and srb->request_bufflen is the buffer's length.)
  * Update the *index and *offset variables so that the next copy will
  * pick up from where this one left off. */
 
@@ -162,77 +158,59 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
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
-		struct scatterlist *sg =
-				(struct scatterlist *) srb->request_buffer
-				+ *index;
-
-		/* This loop handles a single s-g list entry, which may
-		 * include multiple pages.  Find the initial page structure
-		 * and the starting offset within the page, and update
-		 * the *offset and *index values for the next loop. */
-		cnt = 0;
-		while (cnt < buflen && *index < srb->use_sg) {
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
-				++*index;
-				++sg;
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
+	struct scatterlist *sg = scsi_sglist(srb) + *index;
+
+	/* This loop handles a single s-g list entry, which may
+	 * include multiple pages.  Find the initial page structure
+	 * and the starting offset within the page, and update
+	 * the *offset and *index values for the next loop. */
+	cnt = 0;
+	while (cnt < buflen && *index < scsi_sg_count(srb)) {
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
+			++*index;
+			++sg;
+		}
+
+		/* Transfer the data for all the pages in this
+		 * s-g entry.  For each page: call kmap(), do the
+		 * transfer, and call kunmap() immediately after. */
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
 	}
 
@@ -249,6 +227,6 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
 
 	usb_stor_access_xfer_buf(buffer, buflen, srb, &index, &offset,
 			TO_XFER_BUF);
-	if (buflen < srb->request_bufflen)
-		srb->resid = srb->request_bufflen - buflen;
+	if (buflen < scsi_bufflen(srb))
+		scsi_set_resid(srb, scsi_bufflen(srb) - buflen);
 }
-- 
1.5.3.1


