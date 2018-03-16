From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: [PATCH v2 2/5] dma-coherent: Add NO_DMA dummies for managed DMA API
Date: Fri, 16 Mar 2018 14:25:41 +0100
Message-ID: <1521206744-1504-3-git-send-email-geert@linux-m68k.org>
References: <1521206744-1504-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1521206744-1504-1-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "James E . J . Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Add dummies for dmam_{alloc,free}_coherent(), to allow compile-testing
if NO_DMA=y.

This prevents the following from showing up later:

    ERROR: "dmam_alloc_coherent" [drivers/net/ethernet/arc/arc_emac.ko] undefined!
    ERROR: "dmam_free_coherent" [drivers/net/ethernet/apm/xgene/xgene-enet.ko] undefined!
    ERROR: "dmam_alloc_coherent" [drivers/net/ethernet/apm/xgene/xgene-enet.ko] undefined!
    ERROR: "dmam_alloc_coherent" [drivers/mtd/nand/hisi504_nand.ko] undefined!
    ERROR: "dmam_alloc_coherent" [drivers/mmc/host/dw_mmc.ko] undefined!

Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Reviewed-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
---
v2:
  - Add Reviewed-by, Acked-by,
  - Drop RFC state.
---
 include/linux/dma-mapping.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 5ea7eec83c0fbb82..94f41846b933fca7 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -776,10 +776,19 @@ static inline void dma_deconfigure(struct device *dev) {}
 /*
  * Managed DMA API
  */
+#ifdef CONFIG_HAS_DMA
 extern void *dmam_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_handle, gfp_t gfp);
 extern void dmam_free_coherent(struct device *dev, size_t size, void *vaddr,
 			       dma_addr_t dma_handle);
+#else /* !CONFIG_HAS_DMA */
+static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_handle, gfp_t gfp)
+{ return NULL; }
+static inline void dmam_free_coherent(struct device *dev, size_t size,
+				      void *vaddr, dma_addr_t dma_handle) { }
+#endif /* !CONFIG_HAS_DMA */
+
 extern void *dmam_alloc_attrs(struct device *dev, size_t size,
 			      dma_addr_t *dma_handle, gfp_t gfp,
 			      unsigned long attrs);
-- 
2.7.4
