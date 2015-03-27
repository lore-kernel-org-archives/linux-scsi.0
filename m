From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 6/7] scsi: storvsc: Don't assume that the scatterlist is
 not chained
Date: Fri, 27 Mar 2015 00:27:19 -0700
Message-ID: <1427441240-29314-6-git-send-email-kys@microsoft.com>
References: <1427441219-29275-1-git-send-email-kys@microsoft.com>
 <1427441240-29314-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1427441240-29314-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

The current code assumes that the scatterlists presented are not chained.
Fix the code to not make this assumption.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
	V2: Got rid of double assignment. Olaf Hering <olaf@aepfle.de>
 drivers/scsi/storvsc_drv.c |   99 +++++++++++++++++++++++++------------------
 1 files changed, 57 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index f8e4dd9..4156e29 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -626,19 +626,6 @@ cleanup:
 	return NULL;
 }
 
-/* Disgusting wrapper functions */
-static inline unsigned long sg_kmap_atomic(struct scatterlist *sgl, int idx)
-{
-	void *addr = kmap_atomic(sg_page(sgl + idx));
-	return (unsigned long)addr;
-}
-
-static inline void sg_kunmap_atomic(unsigned long addr)
-{
-	kunmap_atomic((void *)addr);
-}
-
-
 /* Assume the original sgl has enough room */
 static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 					    struct scatterlist *bounce_sgl,
@@ -653,32 +640,38 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 	unsigned long bounce_addr = 0;
 	unsigned long dest_addr = 0;
 	unsigned long flags;
+	struct scatterlist *cur_dest_sgl;
+	struct scatterlist *cur_src_sgl;
 
 	local_irq_save(flags);
-
+	cur_dest_sgl = orig_sgl;
+	cur_src_sgl = bounce_sgl;
 	for (i = 0; i < orig_sgl_count; i++) {
-		dest_addr = sg_kmap_atomic(orig_sgl,i) + orig_sgl[i].offset;
+		dest_addr = (unsigned long)
+				kmap_atomic(sg_page(cur_dest_sgl)) +
+				cur_dest_sgl->offset;
 		dest = dest_addr;
-		destlen = orig_sgl[i].length;
+		destlen = cur_dest_sgl->length;
 
 		if (bounce_addr == 0)
-			bounce_addr = sg_kmap_atomic(bounce_sgl,j);
+			bounce_addr = (unsigned long)kmap_atomic(
+							sg_page(cur_src_sgl));
 
 		while (destlen) {
-			src = bounce_addr + bounce_sgl[j].offset;
-			srclen = bounce_sgl[j].length - bounce_sgl[j].offset;
+			src = bounce_addr + cur_src_sgl->offset;
+			srclen = cur_src_sgl->length - cur_src_sgl->offset;
 
 			copylen = min(srclen, destlen);
 			memcpy((void *)dest, (void *)src, copylen);
 
 			total_copied += copylen;
-			bounce_sgl[j].offset += copylen;
+			cur_src_sgl->offset += copylen;
 			destlen -= copylen;
 			dest += copylen;
 
-			if (bounce_sgl[j].offset == bounce_sgl[j].length) {
+			if (cur_src_sgl->offset == cur_src_sgl->length) {
 				/* full */
-				sg_kunmap_atomic(bounce_addr);
+				kunmap_atomic((void *)bounce_addr);
 				j++;
 
 				/*
@@ -692,21 +685,27 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 					/*
 					 * We are done; cleanup and return.
 					 */
-					sg_kunmap_atomic(dest_addr - orig_sgl[i].offset);
+					kunmap_atomic((void *)(dest_addr -
+						cur_dest_sgl->offset));
 					local_irq_restore(flags);
 					return total_copied;
 				}
 
 				/* if we need to use another bounce buffer */
-				if (destlen || i != orig_sgl_count - 1)
-					bounce_addr = sg_kmap_atomic(bounce_sgl,j);
+				if (destlen || i != orig_sgl_count - 1) {
+					cur_src_sgl = sg_next(cur_src_sgl);
+					bounce_addr = (unsigned long)
+							kmap_atomic(
+							sg_page(cur_src_sgl));
+				}
 			} else if (destlen == 0 && i == orig_sgl_count - 1) {
 				/* unmap the last bounce that is < PAGE_SIZE */
-				sg_kunmap_atomic(bounce_addr);
+				kunmap_atomic((void *)bounce_addr);
 			}
 		}
 
-		sg_kunmap_atomic(dest_addr - orig_sgl[i].offset);
+		kunmap_atomic((void *)(dest_addr - cur_dest_sgl->offset));
+		cur_dest_sgl = sg_next(cur_dest_sgl);
 	}
 
 	local_irq_restore(flags);
@@ -727,48 +726,61 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 	unsigned long bounce_addr = 0;
 	unsigned long src_addr = 0;
 	unsigned long flags;
+	struct scatterlist *cur_src_sgl;
+	struct scatterlist *cur_dest_sgl;
 
 	local_irq_save(flags);
 
+	cur_src_sgl = orig_sgl;
+	cur_dest_sgl = bounce_sgl;
+
 	for (i = 0; i < orig_sgl_count; i++) {
-		src_addr = sg_kmap_atomic(orig_sgl,i) + orig_sgl[i].offset;
+		src_addr = (unsigned long)
+				kmap_atomic(sg_page(cur_src_sgl)) +
+				cur_src_sgl->offset;
 		src = src_addr;
-		srclen = orig_sgl[i].length;
+		srclen = cur_src_sgl->length;
 
 		if (bounce_addr == 0)
-			bounce_addr = sg_kmap_atomic(bounce_sgl,j);
+			bounce_addr = (unsigned long)
+					kmap_atomic(sg_page(cur_dest_sgl));
 
 		while (srclen) {
 			/* assume bounce offset always == 0 */
-			dest = bounce_addr + bounce_sgl[j].length;
-			destlen = PAGE_SIZE - bounce_sgl[j].length;
+			dest = bounce_addr + cur_dest_sgl->length;
+			destlen = PAGE_SIZE - cur_dest_sgl->length;
 
 			copylen = min(srclen, destlen);
 			memcpy((void *)dest, (void *)src, copylen);
 
 			total_copied += copylen;
-			bounce_sgl[j].length += copylen;
+			cur_dest_sgl->length += copylen;
 			srclen -= copylen;
 			src += copylen;
 
-			if (bounce_sgl[j].length == PAGE_SIZE) {
+			if (cur_dest_sgl->length == PAGE_SIZE) {
 				/* full..move to next entry */
-				sg_kunmap_atomic(bounce_addr);
+				kunmap_atomic((void *)bounce_addr);
 				bounce_addr = 0;
 				j++;
 			}
 
 			/* if we need to use another bounce buffer */
-			if (srclen && bounce_addr == 0)
-				bounce_addr = sg_kmap_atomic(bounce_sgl, j);
+			if (srclen && bounce_addr == 0) {
+				cur_dest_sgl = sg_next(cur_dest_sgl);
+				bounce_addr = (unsigned long)
+						kmap_atomic(
+						sg_page(cur_dest_sgl));
+			}
 
 		}
 
-		sg_kunmap_atomic(src_addr - orig_sgl[i].offset);
+		kunmap_atomic((void *)(src_addr - cur_src_sgl->offset));
+		cur_src_sgl = sg_next(cur_src_sgl);
 	}
 
 	if (bounce_addr)
-		sg_kunmap_atomic(bounce_addr);
+		kunmap_atomic((void *)bounce_addr);
 
 	local_irq_restore(flags);
 
@@ -1536,6 +1548,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct scatterlist *sgl;
 	unsigned int sg_count = 0;
 	struct vmscsi_request *vm_srb;
+	struct scatterlist *cur_sgl;
 
 	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
 		/*
@@ -1617,10 +1630,12 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		}
 
 		cmd_request->data_buffer.offset = sgl[0].offset;
-
-		for (i = 0; i < sg_count; i++)
+		cur_sgl = sgl;
+		for (i = 0; i < sg_count; i++) {
 			cmd_request->data_buffer.pfn_array[i] =
-				page_to_pfn(sg_page((&sgl[i])));
+				page_to_pfn(sg_page((cur_sgl)));
+			cur_sgl = sg_next(cur_sgl);
+		}
 
 	} else if (scsi_sglist(scmnd)) {
 		cmd_request->data_buffer.offset =
-- 
1.7.4.1
