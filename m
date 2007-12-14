From: akpm@linux-foundation.org
Subject: [patch 22/30] sg: nopage
Date: Thu, 13 Dec 2007 16:14:24 -0800
Message-ID: <200712140014.lBE0EOqf026242@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755520AbXLNAXY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:23:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, npiggin@suse.de, dougg@torque.net

From: Nick Piggin <npiggin@suse.de>

Convert SG from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/sg.c~sg-nopage drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~sg-nopage
+++ a/drivers/scsi/sg.c
@@ -1144,23 +1144,22 @@ sg_fasync(int fd, struct file *filp, int
 	return (retval < 0) ? retval : 0;
 }
 
-static struct page *
-sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
+static int
+sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	Sg_fd *sfp;
-	struct page *page = NOPAGE_SIGBUS;
 	unsigned long offset, len, sa;
 	Sg_scatter_hold *rsv_schp;
 	struct scatterlist *sg;
 	int k;
 
 	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
-		return page;
+		return VM_FAULT_SIGBUS;
 	rsv_schp = &sfp->reserve;
-	offset = addr - vma->vm_start;
+	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= rsv_schp->bufflen)
-		return page;
-	SCSI_LOG_TIMEOUT(3, printk("sg_vma_nopage: offset=%lu, scatg=%d\n",
+		return VM_FAULT_SIGBUS;
+	SCSI_LOG_TIMEOUT(3, printk("sg_vma_fault: offset=%lu, scatg=%d\n",
 				   offset, rsv_schp->k_use_sg));
 	sg = rsv_schp->buffer;
 	sa = vma->vm_start;
@@ -1169,21 +1168,21 @@ sg_vma_nopage(struct vm_area_struct *vma
 		len = vma->vm_end - sa;
 		len = (len < sg->length) ? len : sg->length;
 		if (offset < len) {
+			struct page *page;
 			page = virt_to_page(page_address(sg_page(sg)) + offset);
 			get_page(page);	/* increment page count */
-			break;
+			vmf->page = page;
+			return 0; /* success */
 		}
 		sa += len;
 		offset -= len;
 	}
 
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	return VM_FAULT_SIGBUS;
 }
 
 static struct vm_operations_struct sg_mmap_vm_ops = {
-	.nopage = sg_vma_nopage,
+	.fault = sg_vma_fault,
 };
 
 static int
_
