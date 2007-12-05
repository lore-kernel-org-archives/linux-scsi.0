From: npiggin@suse.de
Subject: [patch 10/18] sg: nopage
Date: Wed, 05 Dec 2007 18:15:57 +1100
Message-ID: <20071205071627.793811000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbXLEHzL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:11 -0500
Content-Disposition: inline; filename=sg-nopage.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Convert SG from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/sg.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/scsi/sg.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sg.c
+++ linux-2.6/drivers/scsi/sg.c
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

-- 

