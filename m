From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 06/33] i386 dma_map_sg: convert to using sg helpers
Date: Mon, 16 Jul 2007 11:47:20 +0200
Message-ID: <1184579268960-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9292 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758778AbXGPJse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:34 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, ak@suse.de

The dma mapping helpers need to be converted to using
sg helpers as well, so they will work with a chained
sglist setup.

Cc: ak@suse.de
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/asm-i386/dma-mapping.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/asm-i386/dma-mapping.h b/include/asm-i386/dma-mapping.h
index f1d72d1..6a2d26c 100644
--- a/include/asm-i386/dma-mapping.h
+++ b/include/asm-i386/dma-mapping.h
@@ -2,10 +2,10 @@
 #define _ASM_I386_DMA_MAPPING_H
 
 #include <linux/mm.h>
+#include <linux/scatterlist.h>
 
 #include <asm/cache.h>
 #include <asm/io.h>
-#include <asm/scatterlist.h>
 #include <asm/bug.h>
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
@@ -35,18 +35,19 @@ dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 }
 
 static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	   enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(nents == 0 || sg[0].length == 0);
+	WARN_ON(nents == 0 || sglist[0].length == 0);
 
-	for (i = 0; i < nents; i++ ) {
-		BUG_ON(!sg[i].page);
+	for_each_sg(sglist, sg, nents, i) {
+		BUG_ON(!sg->page);
 
-		sg[i].dma_address = page_to_phys(sg[i].page) + sg[i].offset;
+		sg->dma_address = page_to_phys(sg->page) + sg->offset;
 	}
 
 	flush_write_buffers();
-- 
1.5.3.rc0.90.gbaa79

