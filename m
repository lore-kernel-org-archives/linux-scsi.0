From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 05/11] IA64: make sba_iommu respect the segment size
 limits
Date: Wed, 24 Oct 2007 19:48:17 +0900
Message-ID: <20071024171750S.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:37672 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbXJXKs3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 06:48:29 -0400
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tony.luck@intel.com, fujita.tomonori@lab.ntt.co.jp


This patch makes sba iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/hp/common/sba_iommu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index bc859a3..82bf7fa 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -1265,7 +1265,7 @@ sba_fill_pdir(
  * the sglist do both.
  */
 static SBA_INLINE int
-sba_coalesce_chunks( struct ioc *ioc,
+sba_coalesce_chunks(struct ioc *ioc, struct device *dev,
 	struct scatterlist *startsg,
 	int nents)
 {
@@ -1275,6 +1275,7 @@ sba_coalesce_chunks( struct ioc *ioc,
 	struct scatterlist *dma_sg;        /* next DMA stream head */
 	unsigned long dma_offset, dma_len; /* start/len of DMA stream */
 	int n_mappings = 0;
+	unsigned int max_seg_size = dma_get_max_seg_size(dev);
 
 	while (nents > 0) {
 		unsigned long vaddr = (unsigned long) sba_sg_address(startsg);
@@ -1314,6 +1315,9 @@ sba_coalesce_chunks( struct ioc *ioc,
 			    > DMA_CHUNK_SIZE)
 				break;
 
+			if (dma_len + startsg->length > max_seg_size)
+				break;
+
 			/*
 			** Then look for virtually contiguous blocks.
 			**
@@ -1441,7 +1445,7 @@ int sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents, int di
 	** w/o this association, we wouldn't have coherent DMA!
 	** Access to the virtual address is what forces a two pass algorithm.
 	*/
-	coalesced = sba_coalesce_chunks(ioc, sglist, nents);
+	coalesced = sba_coalesce_chunks(ioc, dev, sglist, nents);
 
 	/*
 	** Program the I/O Pdir
-- 
1.5.2.4

