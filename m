From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH -mm 06/11] alpha: make pci_iommu respect the segment size
 limits
Date: Wed, 24 Oct 2007 19:48:20 +0900
Message-ID: <20071024171938Q.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757656AbXJXKx1@vger.kernel.org>
In-Reply-To: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

This patch makes pci_iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/alpha/kernel/pci_iommu.c |   24 ++++++++++++++++++------
 include/asm-alpha/pci.h       |    1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 2d00a08..26d3789 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -9,6 +9,7 @@
 #include <linux/bootmem.h>
 #include <linux/scatterlist.h>
 #include <linux/log2.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/io.h>
 #include <asm/hwrpb.h>
@@ -470,22 +471,29 @@ EXPORT_SYMBOL(pci_free_consistent);
 #define SG_ENT_PHYS_ADDRESS(SG) __pa(SG_ENT_VIRT_ADDRESS(SG))
 
 static void
-sg_classify(struct scatterlist *sg, struct scatterlist *end, int virt_ok)
+sg_classify(struct device *dev, struct scatterlist *sg, struct scatterlist *end,
+	    int virt_ok)
 {
 	unsigned long next_paddr;
 	struct scatterlist *leader;
 	long leader_flag, leader_length;
+	unsigned int max_seg_size;
 
 	leader = sg;
 	leader_flag = 0;
 	leader_length = leader->length;
 	next_paddr = SG_ENT_PHYS_ADDRESS(leader) + leader_length;
 
+	/* we will not marge sg without device. */
+	max_seg_size = dev ? dma_get_max_seg_size(dev) : 0;
 	for (++sg; sg < end; ++sg) {
 		unsigned long addr, len;
 		addr = SG_ENT_PHYS_ADDRESS(sg);
 		len = sg->length;
 
+		if (leader_length + len > max_seg_size)
+			goto new_segment;
+
 		if (next_paddr == addr) {
 			sg->dma_address = -1;
 			leader_length += len;
@@ -494,6 +502,7 @@ sg_classify(struct scatterlist *sg, struct scatterlist *end, int virt_ok)
 			leader_flag = 1;
 			leader_length += len;
 		} else {
+new_segment:
 			leader->dma_address = leader_flag;
 			leader->dma_length = leader_length;
 			leader = sg;
@@ -512,7 +521,7 @@ sg_classify(struct scatterlist *sg, struct scatterlist *end, int virt_ok)
    in the blanks.  */
 
 static int
-sg_fill(struct scatterlist *leader, struct scatterlist *end,
+sg_fill(struct device *dev, struct scatterlist *leader, struct scatterlist *end,
 	struct scatterlist *out, struct pci_iommu_arena *arena,
 	dma_addr_t max_dma, int dac_allowed)
 {
@@ -562,8 +571,8 @@ sg_fill(struct scatterlist *leader, struct scatterlist *end,
 
 		/* Otherwise, break up the remaining virtually contiguous
 		   hunks into individual direct maps and retry.  */
-		sg_classify(leader, end, 0);
-		return sg_fill(leader, end, out, arena, max_dma, dac_allowed);
+		sg_classify(dev, leader, end, 0);
+		return sg_fill(dev, leader, end, out, arena, max_dma, dac_allowed);
 	}
 
 	out->dma_address = arena->dma_base + dma_ofs*PAGE_SIZE + paddr;
@@ -619,12 +628,15 @@ pci_map_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
 	struct pci_iommu_arena *arena;
 	dma_addr_t max_dma;
 	int dac_allowed;
+	struct device *dev;
 
 	if (direction == PCI_DMA_NONE)
 		BUG();
 
 	dac_allowed = pdev ? pci_dac_dma_supported(pdev, pdev->dma_mask) : 0;
 
+	dev = pdev ? &pdev->dev : NULL;
+
 	/* Fast path single entry scatterlists.  */
 	if (nents == 1) {
 		sg->dma_length = sg->length;
@@ -638,7 +650,7 @@ pci_map_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
 	end = sg + nents;
 
 	/* First, prepare information about the entries.  */
-	sg_classify(sg, end, alpha_mv.mv_pci_tbi != 0);
+	sg_classify(dev, sg, end, alpha_mv.mv_pci_tbi != 0);
 
 	/* Second, figure out where we're going to map things.  */
 	if (alpha_mv.mv_pci_tbi) {
@@ -658,7 +670,7 @@ pci_map_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
 	for (out = sg; sg < end; ++sg) {
 		if ((int) sg->dma_address < 0)
 			continue;
-		if (sg_fill(sg, end, out, arena, max_dma, dac_allowed) < 0)
+		if (sg_fill(dev, sg, end, out, arena, max_dma, dac_allowed) < 0)
 			goto error;
 		out++;
 	}
diff --git a/include/asm-alpha/pci.h b/include/asm-alpha/pci.h
index 30ee766..d5b10ef 100644
--- a/include/asm-alpha/pci.h
+++ b/include/asm-alpha/pci.h
@@ -4,6 +4,7 @@
 #ifdef __KERNEL__
 
 #include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
 #include <asm/scatterlist.h>
 #include <asm/machvec.h>
 
-- 
1.5.2.4
