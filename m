From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/5] dma_map_sg_ring() helper
Date: Thu, 20 Dec 2007 16:49:30 +1100
Message-ID: <200712201649.31254.rusty@rustcorp.com.au>
References: <200712201645.19035.rusty@rustcorp.com.au> <200712201648.58480.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:52149 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbXLTFtr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Dec 2007 00:49:47 -0500
In-Reply-To: <200712201648.58480.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

Obvious counterpart to dma_map_sg.  Note that this is arch-independent
code; sg_rings are backwards compatible with simple sg arrays.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/base/dma-mapping.c  |   13 +++++++++++++
 include/linux/dma-mapping.h |    4 ++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dma-mapping.c b/drivers/base/dma-mapping.c
--- a/drivers/base/dma-mapping.c
+++ b/drivers/base/dma-mapping.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <linux/sg_ring.h>
 
 /*
  * Managed DMA API
@@ -162,6 +163,59 @@ void dmam_free_noncoherent(struct device
 }
 EXPORT_SYMBOL(dmam_free_noncoherent);
 
+/**
+ * dma_map_sg_ring - Map an entire sg ring
+ * @dev: Device to free noncoherent memory for
+ * @sg: The sg_ring
+ * @direction: DMA_TO_DEVICE, DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
+ *
+ * This returns -ENOMEM if mapping fails.  It's not clear that telling you
+ * it failed is useful though.
+ */
+int dma_map_sg_ring(struct device *dev, struct sg_ring *sg,
+		     enum dma_data_direction direction)
+{
+	struct sg_ring *i;
+	unsigned int num;
+
+	for (i = sg; i; i = sg_ring_next(i, sg)) {
+		BUG_ON(i->num > i->max);
+		num = dma_map_sg(dev, i->sg, i->num, direction);
+		if (num == 0 && i->num != 0)
+			goto unmap;
+	}
+	return 0;
+
+unmap:
+	while (sg) {
+		dma_unmap_sg(dev, sg->sg, sg->num, direction);
+		sg = sg_ring_next(sg, i);
+	}
+	return -ENOMEM;
+
+}
+EXPORT_SYMBOL(dma_map_sg_ring);
+
+/**
+ * dma_unmap_sg_ring - Unmap an entire sg ring
+ * @dev: Device to free noncoherent memory for
+ * @sg: The sg_ring
+ * @direction: DMA_TO_DEVICE, DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
+ *
+ * Call after dma_map_sg_ring() succeeds.
+ */
+void dma_unmap_sg_ring(struct device *dev, struct sg_ring *sg,
+		       enum dma_data_direction direction)
+{
+	struct sg_ring *i;
+
+	for (i = sg; i; i = sg_ring_next(i, sg)) {
+		BUG_ON(i->num > i->max);
+		dma_unmap_sg(dev, i->sg, i->num, direction);
+	}
+}
+EXPORT_SYMBOL(dma_unmap_sg_ring);
+
 #ifdef ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
 
 static void dmam_coherent_decl_release(struct device *dev, void *res)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -87,6 +87,12 @@ dma_mark_declared_memory_occupied(struct
 }
 #endif
 
+struct sg_ring;
+extern int dma_map_sg_ring(struct device *dev, struct sg_ring *sg,
+			   enum dma_data_direction direction);
+extern void dma_unmap_sg_ring(struct device *dev, struct sg_ring *sg,
+			      enum dma_data_direction direction);
+
 /*
  * Managed DMA API
  */
