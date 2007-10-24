From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 08/11] parisc: make iommu respect the segment size
 limits
Date: Wed, 24 Oct 2007 19:48:27 +0900
Message-ID: <20071024172113Y.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756568AbXJXKuF@vger.kernel.org>
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kyle@parisc-linux.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org


This patch makes iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/parisc/ccio-dma.c      |    2 +-
 drivers/parisc/iommu-helpers.h |    7 ++++++-
 drivers/parisc/sba_iommu.c     |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 7c60cbd..2ec7db1 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -941,7 +941,7 @@ ccio_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	** w/o this association, we wouldn't have coherent DMA!
 	** Access to the virtual address is what forces a two pass algorithm.
 	*/
-	coalesced = iommu_coalesce_chunks(ioc, sglist, nents, ccio_alloc_range);
+	coalesced = iommu_coalesce_chunks(ioc, dev, sglist, nents, ccio_alloc_range);
 
 	/*
 	** Program the I/O Pdir
diff --git a/drivers/parisc/iommu-helpers.h b/drivers/parisc/iommu-helpers.h
index 0a1f99a..97ba828 100644
--- a/drivers/parisc/iommu-helpers.h
+++ b/drivers/parisc/iommu-helpers.h
@@ -95,12 +95,14 @@ iommu_fill_pdir(struct ioc *ioc, struct scatterlist *startsg, int nents,
 */
 
 static inline unsigned int
-iommu_coalesce_chunks(struct ioc *ioc, struct scatterlist *startsg, int nents,
+iommu_coalesce_chunks(struct ioc *ioc, struct device *dev,
+		      struct scatterlist *startsg, int nents,
 		      int (*iommu_alloc_range)(struct ioc *, size_t))
 {
 	struct scatterlist *contig_sg;	   /* contig chunk head */
 	unsigned long dma_offset, dma_len; /* start/len of DMA stream */
 	unsigned int n_mappings = 0;
+	unsigned int max_seg_size = dma_get_max_seg_size(dev);
 
 	while (nents > 0) {
 
@@ -142,6 +144,9 @@ iommu_coalesce_chunks(struct ioc *ioc, struct scatterlist *startsg, int nents,
 					    IOVP_SIZE) > DMA_CHUNK_SIZE))
 				break;
 
+			if (startsg->length + dma_len > max_seg_size)
+				break;
+
 			/*
 			** Next see if we can append the next chunk (i.e.
 			** it must end on one page and begin on another
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index e527a0e..d06627c 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -946,7 +946,7 @@ sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	** w/o this association, we wouldn't have coherent DMA!
 	** Access to the virtual address is what forces a two pass algorithm.
 	*/
-	coalesced = iommu_coalesce_chunks(ioc, sglist, nents, sba_alloc_range);
+	coalesced = iommu_coalesce_chunks(ioc, dev, sglist, nents, sba_alloc_range);
 
 	/*
 	** Program the I/O Pdir
-- 
1.5.2.4
