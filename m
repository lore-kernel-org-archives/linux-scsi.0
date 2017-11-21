From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] dma-mapping: always provide dma_get_cache_alignment
Date: Tue, 21 Nov 2017 14:23:37 +0100
Message-ID: <20171121132339.1702-2-hch@lst.de>
References: <20171121132339.1702-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51753 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdKUNXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Nov 2017 08:23:47 -0500
In-Reply-To: <20171121132339.1702-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Huacai Chen <chenhc@lemote.com>, linux-scsi@vger.kernel.org, iommu@lists.linux-foundation.org, stable@vger.kernel.org

Provide the dummy version of dma_get_cache_alignment that always returns 1
even if CONFIG_HAS_DMA is not set, so that drivers and subsystems can
use it without ifdefs.

Cc: stable@vger.kernel.org
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/dma-mapping.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index e8f8e8fb244d..81ed9b2d84dc 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -704,7 +704,6 @@ static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
 	return ret;
 }
 
-#ifdef CONFIG_HAS_DMA
 static inline int dma_get_cache_alignment(void)
 {
 #ifdef ARCH_DMA_MINALIGN
@@ -712,7 +711,6 @@ static inline int dma_get_cache_alignment(void)
 #endif
 	return 1;
 }
-#endif
 
 /* flags for the coherent memory api */
 #define DMA_MEMORY_EXCLUSIVE		0x01
-- 
2.14.2
