From: Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V8 2/5] MIPS: Implement dma_map_ops::get_cache_alignment()
Date: Tue, 17 Oct 2017 16:05:39 +0800
Message-ID: <1508227542-13165-2-git-send-email-chenhc@lemote.com>
References: <1508227542-13165-1-git-send-email-chenhc@lemote.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1508227542-13165-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently, MIPS is an architecture which support coherent & noncoherent
devices co-exist. So implement get_cache_alignment() function pointer
in 'struct dma_map_ops' to return different dma alignments.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/cavium-octeon/dma-octeon.c      |  3 ++-
 arch/mips/include/asm/dma-coherence.h     |  2 ++
 arch/mips/loongson64/common/dma-swiotlb.c |  1 +
 arch/mips/mm/dma-default.c                | 11 ++++++++++-
 arch/mips/netlogic/common/nlm-dma.c       |  3 ++-
 5 files changed, 17 insertions(+), 3 deletions(-)

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
diff --git a/arch/mips/loongson64/common/dma-swiotlb.c b/arch/mips/loongson64/common/dma-swiotlb.c
index 34486c1..17b9897 100644
--- a/arch/mips/loongson64/common/dma-swiotlb.c
+++ b/arch/mips/loongson64/common/dma-swiotlb.c
@@ -119,6 +119,7 @@ static const struct dma_map_ops loongson_dma_map_ops = {
 	.sync_sg_for_device = loongson_dma_sync_sg_for_device,
 	.mapping_error = swiotlb_dma_mapping_error,
 	.dma_supported = loongson_dma_supported,
+	.get_cache_alignment = mips_dma_get_cache_alignment
 };
 
 void __init plat_swiotlb_setup(void)
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index c01bd20..e8f0659 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -394,6 +394,14 @@ void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 
 EXPORT_SYMBOL(dma_cache_sync);
 
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
@@ -407,7 +415,8 @@ static const struct dma_map_ops mips_default_dma_map_ops = {
 	.sync_sg_for_cpu = mips_dma_sync_sg_for_cpu,
 	.sync_sg_for_device = mips_dma_sync_sg_for_device,
 	.mapping_error = mips_dma_mapping_error,
-	.dma_supported = mips_dma_supported
+	.dma_supported = mips_dma_supported,
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
