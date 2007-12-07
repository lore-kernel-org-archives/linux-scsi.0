From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 3/6] powerpc: remove DMA 4GB boundary protection
Date: Fri, 7 Dec 2007 23:56:41 +0900
Message-ID: <20071207235712O.tomof@acm.org>
References: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53596 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbXLGO45 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 09:56:57 -0500
In-Reply-To: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, paulus@samba.org, olof@lixom.net, anton@samba.org, fujita.tomonori@lab.ntt.co.jp

Previously, during initialization of the IOMMU tables, the last entry
at each 4GB boundary is marked as used since there are many adapters
which cannot handle DMAing across any 4GB boundary.

The IOMMU doesn't allocate a memory area spanning LLD's segment
boundary anymore. The segment boundary of devices are set to 4GB by
default. So we can remove 4GB boundary protection now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/kernel/iommu.c |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 6abf4c3..bdb194c 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -448,9 +448,6 @@ void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 {
 	unsigned long sz;
-	unsigned long start_index, end_index;
-	unsigned long entries_per_4g;
-	unsigned long index;
 	static int welcomed = 0;
 	struct page *page;
 
@@ -472,6 +469,7 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 
 #ifdef CONFIG_CRASH_DUMP
 	if (ppc_md.tce_get) {
+		unsigned long index;
 		unsigned long tceval;
 		unsigned long tcecount = 0;
 
@@ -502,23 +500,6 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 	ppc_md.tce_free(tbl, tbl->it_offset, tbl->it_size);
 #endif
 
-	/*
-	 * DMA cannot cross 4 GB boundary.  Mark last entry of each 4
-	 * GB chunk as reserved.
-	 */
-	if (protect4gb) {
-		entries_per_4g = 0x100000000l >> IOMMU_PAGE_SHIFT;
-
-		/* Mark the last bit before a 4GB boundary as used */
-		start_index = tbl->it_offset | (entries_per_4g - 1);
-		start_index -= tbl->it_offset;
-
-		end_index = tbl->it_size;
-
-		for (index = start_index; index < end_index - 1; index += entries_per_4g)
-			__set_bit(index, tbl->it_map);
-	}
-
 	if (!welcomed) {
 		printk(KERN_INFO "IOMMU table initialized, virtual merging %s\n",
 		       novmerge ? "disabled" : "enabled");
-- 
1.5.3.4

