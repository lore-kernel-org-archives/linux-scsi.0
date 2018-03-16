From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 4/5] mm: Add NO_DMA dummies for DMA pool API
Date: Fri, 16 Mar 2018 14:25:43 +0100
Message-ID: <1521206744-1504-5-git-send-email-geert@linux-m68k.org>
References: <1521206744-1504-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521206744-1504-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: iommu@lists.linux-foundation.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Add dummies for dma{,m}_pool_{create,destroy,alloc,free}(), to allow
compile-testing if NO_DMA=y.

This prevents the following from showing up later:

    ERROR: "dma_pool_destroy" [drivers/usb/mtu3/mtu3.ko] undefined!
    ERROR: "dma_pool_free" [drivers/usb/mtu3/mtu3.ko] undefined!
    ERROR: "dma_pool_alloc" [drivers/usb/mtu3/mtu3.ko] undefined!
    ERROR: "dma_pool_create" [drivers/usb/mtu3/mtu3.ko] undefined!
    ERROR: "dma_pool_destroy" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
    ERROR: "dma_pool_free" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
    ERROR: "dma_pool_alloc" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
    ERROR: "dma_pool_create" [drivers/scsi/hisi_sas/hisi_sas_main.ko] undefined!
    ERROR: "dma_pool_alloc" [drivers/mailbox/bcm-pdc-mailbox.ko] undefined!
    ERROR: "dma_pool_free" [drivers/mailbox/bcm-pdc-mailbox.ko] undefined!
    ERROR: "dma_pool_create" [drivers/mailbox/bcm-pdc-mailbox.ko] undefined!
    ERROR: "dma_pool_destroy" [drivers/mailbox/bcm-pdc-mailbox.ko] undefined!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Robin Murphy <robin.murphy@arm.com>
---
v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state,
  - Group NO_DMA-stubs under a single #ifdef,
  - Move dma_pool_zalloc() definition down.
---
 include/linux/dmapool.h | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/linux/dmapool.h b/include/linux/dmapool.h
index 53ba737505df31c7..f632ecfb4238404e 100644
--- a/include/linux/dmapool.h
+++ b/include/linux/dmapool.h
@@ -16,6 +16,8 @@
 
 struct device;
 
+#ifdef CONFIG_HAS_DMA
+
 struct dma_pool *dma_pool_create(const char *name, struct device *dev, 
 			size_t size, size_t align, size_t allocation);
 
@@ -23,13 +25,6 @@ void dma_pool_destroy(struct dma_pool *pool);
 
 void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 		     dma_addr_t *handle);
-
-static inline void *dma_pool_zalloc(struct dma_pool *pool, gfp_t mem_flags,
-				    dma_addr_t *handle)
-{
-	return dma_pool_alloc(pool, mem_flags | __GFP_ZERO, handle);
-}
-
 void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t addr);
 
 /*
@@ -39,5 +34,26 @@ struct dma_pool *dmam_pool_create(const char *name, struct device *dev,
 				  size_t size, size_t align, size_t allocation);
 void dmam_pool_destroy(struct dma_pool *pool);
 
+#else /* !CONFIG_HAS_DMA */
+static inline struct dma_pool *dma_pool_create(const char *name,
+	struct device *dev, size_t size, size_t align, size_t allocation)
+{ return NULL; }
+static inline void dma_pool_destroy(struct dma_pool *pool) { }
+static inline void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
+				   dma_addr_t *handle) { return NULL; }
+static inline void dma_pool_free(struct dma_pool *pool, void *vaddr,
+				 dma_addr_t addr) { }
+static inline struct dma_pool *dmam_pool_create(const char *name,
+	struct device *dev, size_t size, size_t align, size_t allocation)
+{ return NULL; }
+static inline void dmam_pool_destroy(struct dma_pool *pool) { }
+#endif /* !CONFIG_HAS_DMA */
+
+static inline void *dma_pool_zalloc(struct dma_pool *pool, gfp_t mem_flags,
+				    dma_addr_t *handle)
+{
+	return dma_pool_alloc(pool, mem_flags | __GFP_ZERO, handle);
+}
+
 #endif
 
-- 
2.7.4
