From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/7] sg_ring: dma_map_sg_ring() helper
Date: Wed, 19 Dec 2007 18:34:42 +1100
Message-ID: <200712191834.42457.rusty@rustcorp.com.au>
References: <200712191731.26512.rusty@rustcorp.com.au> <200712191831.07804.rusty@rustcorp.com.au> <200712191833.46615.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200712191833.46615.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
