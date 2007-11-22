From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 3/4] swiotlb: respect the segment boundary limits
Date: Thu, 22 Nov 2007 11:43:30 +0900
Message-ID: <20071122114107L.tomof@acm.org>
References: <522edb7703e4a70374b0c689cd7bae659fb0908b.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47202 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbXKVCoV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 21:44:21 -0500
In-Reply-To: <522edb7703e4a70374b0c689cd7bae659fb0908b.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, tony.luck@intel.com, airlied@linux.ie, tglx@linutronix.de, mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp

This patch makes swiotlb not allocate a memory area spanning LLD's
segment boundary.

is_span_boundary() judges whether a memory area spans LLD's segment
boundary. If map_single finds such a area, map_single tries to find
the next available memory area.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |   41 +++++++++++++++++++++++++++++++++++------
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 1a8050a..4bb5a11 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -282,6 +282,15 @@ address_needs_mapping(struct device *hwdev, dma_addr_t addr)
 	return (addr & ~mask) != 0;
 }
 
+static inline unsigned int is_span_boundary(unsigned int index,
+					    unsigned int nslots,
+					    unsigned long offset_slots,
+					    unsigned long max_slots)
+{
+	unsigned long offset = (offset_slots + index) & (max_slots - 1);
+	return offset + nslots > max_slots;
+}
+
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
@@ -292,6 +301,16 @@ map_single(struct device *hwdev, char *buffer, size_t size, int dir)
 	char *dma_addr;
 	unsigned int nslots, stride, index, wrap;
 	int i;
+	unsigned long start_dma_addr;
+	unsigned long mask;
+	unsigned long offset_slots;
+	unsigned long max_slots;
+
+	mask = dma_get_seg_boundary(hwdev);
+	start_dma_addr = virt_to_bus(io_tlb_start) & mask;
+
+	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	max_slots = ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
 	/*
 	 * For mappings greater than a page, we limit the stride (and
@@ -311,10 +330,17 @@ map_single(struct device *hwdev, char *buffer, size_t size, int dir)
 	 */
 	spin_lock_irqsave(&io_tlb_lock, flags);
 	{
-		wrap = index = ALIGN(io_tlb_index, stride);
-
+		index = ALIGN(io_tlb_index, stride);
 		if (index >= io_tlb_nslabs)
-			wrap = index = 0;
+			index = 0;
+
+		while (is_span_boundary(index, nslots, offset_slots,
+					max_slots)) {
+			index += stride;
+			if (index >= io_tlb_nslabs)
+				index = 0;
+		}
+		wrap = index;
 
 		do {
 			/*
@@ -341,9 +367,12 @@ map_single(struct device *hwdev, char *buffer, size_t size, int dir)
 
 				goto found;
 			}
-			index += stride;
-			if (index >= io_tlb_nslabs)
-				index = 0;
+			do {
+				index += stride;
+				if (index >= io_tlb_nslabs)
+					index = 0;
+			} while (is_span_boundary(index, nslots, offset_slots,
+						  max_slots));
 		} while (index != wrap);
 
 		spin_unlock_irqrestore(&io_tlb_lock, flags);
-- 
1.5.3.4

