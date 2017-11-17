From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V10 2/4] MIPS: Implement dma_map_ops::get_cache_alignment()
Date: Fri, 17 Nov 2017 12:28:54 +0800
Message-ID: <1510892934-32743-1-git-send-email-chenhc@lemote.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:42243 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932695AbdKQE3A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Nov 2017 23:29:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-mips@linux-mips.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Huacai Chen <chenhc@lemote.com>

Currently, MIPS is an architecture which support coherent & noncoherent
devices co-exist. So implement get_cache_alignment() function pointer
in 'struct dma_map_ops' to return different dma alignments.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/cavium-octeon/dma-octeon.c            | 3 ++-
 arch/mips/include/asm/dma-coherence.h           | 2 ++
 arch/mips/include/asm/mach-loongson64/kmalloc.h | 6 ++++++
 arch/mips/loongson64/common/dma-swiotlb.c       | 1 +
 arch/mips/mm/dma-default.c                      | 9 +++++++++
 arch/mips/netlogic/common/nlm-dma.c             | 3 ++-
 6 files changed, 22 insertions(+), 2 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-loongson64/kmalloc.h

diff --git a/arch/mips/cavium-octeon/dma-octeon.c b/arch/mips/cavium-octeon/dma-octeon.c
index c64bd87..41c29a85 100644
--- a/arch/mips/cavium-octeon/dma-octeon.c
+++ b/arch/mips/cavium-octeon/dma-octeon.c
@@ -324,7 +324,8 @@ static struct octeon_dma_map_ops _octeon_pci_dma_map_ops = {
 		.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 		.sync_sg_for_device = octeon_dma_sync_sg_for_device,
 		.mapping_error = swiotlb_dma_mapping_error,
-		.dma_supported = swiotlb_dma_supported
+		.dma_supported = swiotlb_dma_supported,
+		.get_cache_alignment = mips_dma_get_cache_alignment
 	},
 };
 
diff --git a/arch/mips/include/asm/dma-coherence.h b/arch/mips/include/asm/dma-coherence.h
index 72d0eab..5f7a9fc 100644
--- a/arch/mips/include/asm/dma-coherence.h
+++ b/arch/mips/include/asm/dma-coherence.h
@@ -29,4 +29,6 @@ extern int hw_coherentio;
 #define hw_coherentio	0
 #endif /* CONFIG_DMA_MAYBE_COHERENT */
 
+int mips_dma_get_cache_alignment(struct device *dev);
+
 #endif
diff --git a/arch/mips/include/asm/mach-loongson64/kmalloc.h b/arch/mips/include/asm/mach-loongson64/kmalloc.h
new file mode 100644
index 0000000..2731d9e
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson64/kmalloc.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_MACH_LOONGSON64_KMALLOC_H
+#define __ASM_MACH_LOONGSON64_KMALLOC_H
+
+#define ARCH_DMA_MINALIGN L1_CACHE_BYTES
+
+#endif /* __ASM_MACH_LOONGSON64_KMALLOC_H */
diff --git a/arch/mips/loongson64/common/dma-swiotlb.c b/arch/mips/loongson64/common/dma-swiotlb.c
index 17956f2..fc6a4bf 100644
--- a/arch/mips/loongson64/common/dma-swiotlb.c
+++ b/arch/mips/loongson64/common/dma-swiotlb.c
@@ -121,6 +121,7 @@ static const struct dma_map_ops loongson_dma_map_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.dma_supported = loongson_dma_supported,
 	.cache_sync = mips_dma_cache_sync,
+	.get_cache_alignment = mips_dma_get_cache_alignment
 };
 
 void __init plat_swiotlb_setup(void)
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index e86bf5d..f006cd2 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -392,6 +392,14 @@ void mips_dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 		__dma_sync_virtual(vaddr, size, direction);
 }
 
+int mips_dma_get_cache_alignment(struct device *dev)
+{
+	if (plat_device_is_coherent(dev))
+		return 1;
+	else
+		return ARCH_DMA_MINALIGN;
+}
+
 static const struct dma_map_ops mips_default_dma_map_ops = {
 	.alloc = mips_dma_alloc_coherent,
 	.free = mips_dma_free_coherent,
@@ -407,6 +415,7 @@ static const struct dma_map_ops mips_default_dma_map_ops = {
 	.mapping_error = mips_dma_mapping_error,
 	.dma_supported = mips_dma_supported,
 	.cache_sync = mips_dma_cache_sync,
+	.get_cache_alignment = mips_dma_get_cache_alignment
 };
 
 const struct dma_map_ops *mips_dma_map_ops = &mips_default_dma_map_ops;
diff --git a/arch/mips/netlogic/common/nlm-dma.c b/arch/mips/netlogic/common/nlm-dma.c
index 0ec9d9d..e9a9ddc 100644
--- a/arch/mips/netlogic/common/nlm-dma.c
+++ b/arch/mips/netlogic/common/nlm-dma.c
@@ -79,7 +79,8 @@ const struct dma_map_ops nlm_swiotlb_dma_ops = {
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 	.sync_sg_for_device = swiotlb_sync_sg_for_device,
 	.mapping_error = swiotlb_dma_mapping_error,
-	.dma_supported = swiotlb_dma_supported
+	.dma_supported = swiotlb_dma_supported,
+	.get_cache_alignment = mips_dma_get_cache_alignment
 };
 
 void __init plat_swiotlb_setup(void)
-- 
2.7.0
