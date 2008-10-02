From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [1/21] SCSI-ISA-DMA: Add the alloc/get_pages_mask calls
Date: Thu,  2 Oct 2008 09:58:39 +0200 (CEST)
Message-ID: <20081002075839.1887F3E6A09@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57075 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYJBH6l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:41 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


[Merge note: this patch will be in a SCSI patchkit and in the core
mask allocator patchkit. They are equivalent. If one of them 
is merged first simply drop it in the other]

Add the compat version of the *_pages_* calls. These just check
if the mask is inside the DMA range and if yes set __GFP_DMA.

This is needed so that some code can start using the _mask calls
early.

Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/gfp.h |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

Index: linux/include/linux/gfp.h
===================================================================
--- linux.orig/include/linux/gfp.h
+++ linux/include/linux/gfp.h
@@ -4,6 +4,7 @@
 #include <linux/mmzone.h>
 #include <linux/stddef.h>
 #include <linux/linkage.h>
+#include <asm/dma.h>  /* For TRAD_DMA_MASK/MAX_DMA_ADDRESS */
 
 struct vm_area_struct;
 
@@ -234,14 +235,29 @@ void free_pages_exact(void *virt, size_t
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask),0)
 
-#define __get_dma_pages(gfp_mask, order) \
-		__get_free_pages((gfp_mask) | GFP_DMA,(order))
-
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
 extern void free_hot_page(struct page *page);
 extern void free_cold_page(struct page *page);
 
+#define gfp_mask(m) ((__pa(MAX_DMA_ADDRESS - 1) & (m)) ? 0 : __GFP_DMA)
+
+#define alloc_pages_mask(gfp, size, mask) \
+	alloc_pages((gfp) | gfp_mask(mask), get_order(size))
+#define get_pages_mask(gfp, size, mask) \
+	((void *)__get_free_pages((gfp) | gfp_mask(mask), get_order(size)))
+#define __free_pages_mask(p, s) __free_pages((p), get_order(s))
+#define free_pages_mask(addr, s) free_pages((unsigned long)(addr), get_order(s))
+
+#define __get_dma_pages(gfp_mask, order) \
+		__get_free_pages((gfp_mask) | GFP_DMA, (order))
+
+#define get_page_mask(gfp, mask) get_pages_mask((gfp), PAGE_SIZE, mask)
+#define alloc_page_mask(gfp, mask) alloc_pages_mask((gfp), PAGE_SIZE, mask)
+
+#define __free_page_mask(page) __free_pages_mask(page, PAGE_SIZE)
+#define free_page_mask(addr) free_pages_mask((addr), PAGE_SIZE)
+
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr),0)
 
