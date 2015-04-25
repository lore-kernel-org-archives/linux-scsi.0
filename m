From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] scatterlist: enable sg chaining for all architectures
Date: Sat, 25 Apr 2015 23:56:16 +0900
Message-ID: <1429973776-7499-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Some architectures enable sg chaining option while others do not.

The requirement to enable sg chaining is that pages must be aligned
at a 32-bit boundary in order to overload the LSB of the pointer.
Regardless of whether ARCH_HAS_SG_CHAIN is defined or not, the above
requirement is always chacked by BUG_ON() in sg_assign_page.  So
all architectures can enable sg chaining.

As you can see from the changes in drivers/target/target_core_rd.c,
enabling SG chaining for all architectures allows us to allocate
discontiguous scatterlist tables which can be traversed throughout
by sg_next() without a special handling for some architectures.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org
Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org
---
 arch/arm/Kconfig                |  6 ------
 arch/arm64/Kconfig              |  1 -
 arch/ia64/Kconfig               |  1 -
 arch/powerpc/Kconfig            |  1 -
 arch/s390/Kconfig               |  1 -
 arch/sparc/Kconfig              |  1 -
 arch/x86/Kconfig                |  1 -
 drivers/target/target_core_rd.c | 45 -----------------------------------------
 include/linux/scatterlist.h     |  4 ----
 include/scsi/scsi.h             |  8 ++------
 lib/Kconfig                     |  7 -------
 lib/scatterlist.c               |  8 --------
 12 files changed, 2 insertions(+), 82 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 45df48b..4436000 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -89,16 +89,11 @@ config ARM
 	  Europe.  There is an ARM Linux project with a web page at
 	  <http://www.arm.linux.org.uk/>.
 
-config ARM_HAS_SG_CHAIN
-	select ARCH_HAS_SG_CHAIN
-	bool
-
 config NEED_SG_DMA_LENGTH
 	bool
 
 config ARM_DMA_USE_IOMMU
 	bool
-	select ARM_HAS_SG_CHAIN
 	select NEED_SG_DMA_LENGTH
 
 if ARM_DMA_USE_IOMMU
@@ -318,7 +313,6 @@ config ARCH_MULTIPLATFORM
 	bool "Allow multiple platforms to be selected"
 	depends on MMU
 	select ARCH_WANT_OPTIONAL_GPIOLIB
-	select ARM_HAS_SG_CHAIN
 	select ARM_PATCH_PHYS_VIRT
 	select AUTO_ZRELADDR
 	select CLKSRC_OF
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 4269dba..582462a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -5,7 +5,6 @@ config ARM64
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_SUPPORTS_ATOMIC_RMW
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 76d25b2..a9f896e 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -32,7 +32,6 @@ config IA64
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select ARCH_HAS_SG_CHAIN
 	select VIRT_TO_BUS
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 190cc48..6f3b6768 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -112,7 +112,6 @@ config PPC
 	select HAVE_DMA_API_DEBUG
 	select HAVE_OPROFILE
 	select HAVE_DEBUG_KMEMLEAK
-	select ARCH_HAS_SG_CHAIN
 	select GENERIC_ATOMIC64 if PPC32
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select HAVE_PERF_EVENTS
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 8e58c61..2854e52 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -67,7 +67,6 @@ config S390
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_INLINE_READ_LOCK
 	select ARCH_INLINE_READ_LOCK_BH
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index e49502a..d0512f5 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -42,7 +42,6 @@ config SPARC
 	select MODULES_USE_ELF_RELA
 	select ODD_RT_SIGACTION
 	select OLD_SIGSUSPEND
-	select ARCH_HAS_SG_CHAIN
 
 config SPARC32
 	def_bool !64BIT
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 226d569..eeb52b8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -101,7 +101,6 @@ config X86
 	select HAVE_BPF_JIT if X86_64
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_HUGE_VMAP if X86_64 || (X86_32 && X86_PAE)
-	select ARCH_HAS_SG_CHAIN
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index fa20d67..ce6a0ac 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -144,16 +144,12 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 		sg_per_table = (total_sg_needed > max_sg_per_table) ?
 			max_sg_per_table : total_sg_needed;
 
-#ifdef CONFIG_ARCH_HAS_SG_CHAIN
-
 		/*
 		 * Reserve extra element for chain entry
 		 */
 		if (sg_per_table < total_sg_needed)
 			chain_entry = 1;
 
-#endif /* CONFIG_ARCH_HAS_SG_CHAIN */
-
 		sg = kcalloc(sg_per_table + chain_entry, sizeof(*sg),
 				GFP_KERNEL);
 		if (!sg) {
@@ -164,15 +160,11 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 
 		sg_init_table(sg, sg_per_table + chain_entry);
 
-#ifdef CONFIG_ARCH_HAS_SG_CHAIN
-
 		if (i > 0) {
 			sg_chain(sg_table[i - 1].sg_table,
 				 max_sg_per_table + 1, sg);
 		}
 
-#endif /* CONFIG_ARCH_HAS_SG_CHAIN */
-
 		sg_table[i].sg_table = sg;
 		sg_table[i].rd_sg_count = sg_per_table;
 		sg_table[i].page_start_offset = page_offset;
@@ -420,7 +412,6 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
 	struct scatterlist *prot_sg;
 	u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
 	u32 prot_offset, prot_page;
-	u32 prot_npages __maybe_unused;
 	u64 tmp;
 	sense_reason_t rc = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
@@ -435,42 +426,6 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, dif_verify dif_verify)
 	prot_sg = &prot_table->sg_table[prot_page -
 					prot_table->page_start_offset];
 
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-
-	prot_npages = DIV_ROUND_UP(prot_offset + sectors * se_dev->prot_length,
-				   PAGE_SIZE);
-
-	/*
-	 * Allocate temporaly contiguous scatterlist entries if prot pages
-	 * straddles multiple scatterlist tables.
-	 */
-	if (prot_table->page_end_offset < prot_page + prot_npages - 1) {
-		int i;
-
-		prot_sg = kcalloc(prot_npages, sizeof(*prot_sg), GFP_KERNEL);
-		if (!prot_sg)
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-
-		need_to_release = true;
-		sg_init_table(prot_sg, prot_npages);
-
-		for (i = 0; i < prot_npages; i++) {
-			if (prot_page + i > prot_table->page_end_offset) {
-				prot_table = rd_get_prot_table(dev,
-								prot_page + i);
-				if (!prot_table) {
-					kfree(prot_sg);
-					return rc;
-				}
-				sg_unmark_end(&prot_sg[i - 1]);
-			}
-			prot_sg[i] = prot_table->sg_table[prot_page + i -
-						prot_table->page_start_offset];
-		}
-	}
-
-#endif /* !CONFIG_ARCH_HAS_SG_CHAIN */
-
 	rc = dif_verify(cmd, cmd->t_task_lba, sectors, 0, prot_sg, prot_offset);
 	if (need_to_release)
 		kfree(prot_sg);
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index ed8f9e7..bee59ea 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -136,10 +136,6 @@ static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 			    struct scatterlist *sgl)
 {
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-	BUG();
-#endif
-
 	/*
 	 * offset and length are unused for chain entry.  Clear them.
 	 */
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index d0a66aa..f01c5bb 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -28,14 +28,10 @@ enum scsi_timeouts {
 #define SCSI_MAX_SG_SEGMENTS	128
 
 /*
- * Like SCSI_MAX_SG_SEGMENTS, but for archs that have sg chaining. This limit
- * is totally arbitrary, a setting of 2048 will get you at least 8mb ios.
+ * This limit is totally arbitrary, a setting of 2048 will get you at least
+ * 8mb ios.
  */
-#ifdef CONFIG_ARCH_HAS_SG_CHAIN
 #define SCSI_MAX_SG_CHAIN_SEGMENTS	2048
-#else
-#define SCSI_MAX_SG_CHAIN_SEGMENTS	SCSI_MAX_SG_SEGMENTS
-#endif
 
 /*
  * DIX-capable adapters effectively support infinite chaining for the
diff --git a/lib/Kconfig b/lib/Kconfig
index 601965a..0b938d2 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -515,11 +515,4 @@ config UCS2_STRING
 
 source "lib/fonts/Kconfig"
 
-#
-# sg chaining option
-#
-
-config ARCH_HAS_SG_CHAIN
-	def_bool n
-
 endmenu
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index c9f2e8c..6d9d477 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -73,16 +73,12 @@ EXPORT_SYMBOL(sg_nents);
  **/
 struct scatterlist *sg_last(struct scatterlist *sgl, unsigned int nents)
 {
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-	struct scatterlist *ret = &sgl[nents - 1];
-#else
 	struct scatterlist *sg, *ret = NULL;
 	unsigned int i;
 
 	for_each_sg(sgl, sg, nents, i)
 		ret = sg;
 
-#endif
 #ifdef CONFIG_DEBUG_SG
 	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
 	BUG_ON(!sg_is_last(ret));
@@ -255,10 +251,6 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 
 	if (nents == 0)
 		return -EINVAL;
-#ifndef CONFIG_ARCH_HAS_SG_CHAIN
-	if (WARN_ON_ONCE(nents > max_ents))
-		return -EINVAL;
-#endif
 
 	left = nents;
 	prv = NULL;
-- 
1.9.1
