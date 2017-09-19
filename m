From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V6 1/3] dma-mapping: Introduce device_is_coherent() as a helper
Date: Tue, 19 Sep 2017 16:52:39 +0800
Message-ID: <1505811161-25246-1-git-send-email-chenhc@lemote.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpproxy19.qq.com ([184.105.206.84]:60587 "EHLO
        smtpproxy19.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdISIvt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2017 04:51:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org

We will use device_is_coherent() as a helper function, which will be
used in the next patch.

There is a MIPS-specific plat_device_is_coherent(), but we need a more
generic solution, so add and use a new function pointer in dma_map_ops.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/cavium-octeon/dma-octeon.c               |  3 ++-
 arch/mips/include/asm/mach-generic/dma-coherence.h |  6 +++---
 arch/mips/loongson64/common/dma-swiotlb.c          |  1 +
 arch/mips/mm/dma-default.c                         |  3 ++-
 arch/mips/netlogic/common/nlm-dma.c                |  3 ++-
 include/linux/dma-mapping.h                        | 10 ++++++++++
 6 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/mips/cavium-octeon/dma-octeon.c b/arch/mips/cavium-octeon/dma-octeon.c
index c64bd87..cd1a133 100644
--- a/arch/mips/cavium-octeon/dma-octeon.c
+++ b/arch/mips/cavium-octeon/dma-octeon.c
@@ -324,7 +324,8 @@ static struct octeon_dma_map_ops _octeon_pci_dma_map_ops = {
 		.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 		.sync_sg_for_device = octeon_dma_sync_sg_for_device,
 		.mapping_error = swiotlb_dma_mapping_error,
-		.dma_supported = swiotlb_dma_supported
+		.dma_supported = swiotlb_dma_supported,
+		.device_is_coherent = plat_device_is_coherent
 	},
 };
 
diff --git a/arch/mips/loongson64/common/dma-swiotlb.c b/arch/mips/loongson64/common/dma-swiotlb.c
index 34486c1..c758d9b 100644
--- a/arch/mips/loongson64/common/dma-swiotlb.c
+++ b/arch/mips/loongson64/common/dma-swiotlb.c
@@ -119,6 +119,7 @@ static const struct dma_map_ops loongson_dma_map_ops = {
 	.sync_sg_for_device = loongson_dma_sync_sg_for_device,
 	.mapping_error = swiotlb_dma_mapping_error,
 	.dma_supported = loongson_dma_supported,
+	.device_is_coherent = plat_device_is_coherent
 };
 
 void __init plat_swiotlb_setup(void)
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index c01bd20..6e18301 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -407,7 +407,8 @@ static const struct dma_map_ops mips_default_dma_map_ops = {
 	.sync_sg_for_cpu = mips_dma_sync_sg_for_cpu,
 	.sync_sg_for_device = mips_dma_sync_sg_for_device,
 	.mapping_error = mips_dma_mapping_error,
-	.dma_supported = mips_dma_supported
+	.dma_supported = mips_dma_supported,
+	.device_is_coherent = plat_device_is_coherent
 };
 
 const struct dma_map_ops *mips_dma_map_ops = &mips_default_dma_map_ops;
diff --git a/arch/mips/netlogic/common/nlm-dma.c b/arch/mips/netlogic/common/nlm-dma.c
index 0ec9d9d..aa11b27 100644
--- a/arch/mips/netlogic/common/nlm-dma.c
+++ b/arch/mips/netlogic/common/nlm-dma.c
@@ -79,7 +79,8 @@ const struct dma_map_ops nlm_swiotlb_dma_ops = {
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 	.sync_sg_for_device = swiotlb_sync_sg_for_device,
 	.mapping_error = swiotlb_dma_mapping_error,
-	.dma_supported = swiotlb_dma_supported
+	.dma_supported = swiotlb_dma_supported,
+	.device_is_coherent = plat_device_is_coherent
 };
 
 void __init plat_swiotlb_setup(void)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 29ce981..08da227 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -131,6 +131,7 @@ struct dma_map_ops {
 #ifdef ARCH_HAS_DMA_GET_REQUIRED_MASK
 	u64 (*get_required_mask)(struct device *dev);
 #endif
+	int (*device_is_coherent)(struct device *dev);
 	int is_phys;
 };
 
@@ -697,6 +698,15 @@ static inline void *dma_zalloc_coherent(struct device *dev, size_t size,
 }
 
 #ifdef CONFIG_HAS_DMA
+static inline int device_is_coherent(struct device *dev)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+	if (ops && ops->device_is_coherent)
+		return ops->device_is_coherent(dev);
+	else
+		return 1;    /* compatible behavior */
+}
+
 static inline int dma_get_cache_alignment(void)
 {
 #ifdef ARCH_DMA_MINALIGN
-- 
2.7.0
