From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC 2/6] dma-coherent: Add NO_DMA dummies for managed DMA API
Date: Tue,  6 Feb 2018 11:14:48 +0100
Message-ID: <1517912092-15470-3-git-send-email-geert@linux-m68k.org>
References: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:37476 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752647AbeBFKPE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 05:15:04 -0500
In-Reply-To: <1517912092-15470-1-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>, Richard Weinberger <richard@nod.at>
Cc: Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, iommu@lists.linux-foundation.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

Add dummies for dmam_{alloc,free}_coherent(), to allow compile-testing
if NO_DMA=y.

This prevents the following from showing up later:

    ERROR: "dmam_alloc_coherent" [drivers/net/ethernet/arc/arc_emac.ko] undefined!
    ERROR: "dmam_free_coherent" [drivers/net/ethernet/apm/xgene/xgene-enet.ko] undefined!
    ERROR: "dmam_alloc_coherent" [drivers/net/ethernet/apm/xgene/xgene-enet.ko] undefined!
    ERROR: "dmam_alloc_coherent" [drivers/mtd/nand/hisi504_nand.ko] undefined!
    ERROR: "dmam_alloc_coherent" [drivers/mmc/host/dw_mmc.ko] undefined!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/dma-mapping.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index d78d7541f784875b..4d92956a4ddb8a5c 100644
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
