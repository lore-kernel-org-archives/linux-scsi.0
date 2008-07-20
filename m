From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
 about VMERGE
Date: Sat, 19 Jul 2008 21:45:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807192141500.13523@devserv.devel.redhat.com>
References: <20080717131444K.fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0807170746001.31185@devserv.devel.redhat.com>
 <20080717221908D.fujita.tomonori@lab.ntt.co.jp> <20080719.002826.73806419.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20080719.002826.73806419.davem@davemloft.net>
Sender: linux-parisc-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 19 Jul 2008, David Miller wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Thu, 17 Jul 2008 22:18:44 +0900
> 
> > BTW, as I've already said, I'm not against removing the vmerge
> > accounting from the block layer.
> 
> I am also, as stated, not against this.
> 
> Fujita-san, please proposage a patch so that we can put this
> issue behind us :-)

Few days ago I created this.

Another task would be to remove nr_hw_segments from request, bio and queue 
parameters (if this patch is accepted).

Mikulas

---
 arch/parisc/kernel/setup.c |    5 ---
 arch/x86/kernel/pci-dma.c  |    6 ---
 block/blk-merge.c          |   72 +++------------------------------------------
 drivers/parisc/ccio-dma.c  |    2 -
 drivers/parisc/sba_iommu.c |    2 -
 fs/bio.c                   |    6 +--
 include/asm-alpha/io.h     |    3 -
 include/asm-ia64/io.h      |   26 +---------------
 include/asm-parisc/io.h    |    6 ---
 include/asm-powerpc/io.h   |    7 ----
 include/asm-sparc64/io.h   |    1 
 include/asm-x86/io_64.h    |    3 -
 include/linux/bio.h        |   15 ---------
 13 files changed, 10 insertions(+), 144 deletions(-)

Index: linux-2.6.26-fast/arch/parisc/kernel/setup.c
===================================================================
--- linux-2.6.26-fast.orig/arch/parisc/kernel/setup.c	2008-07-15 16:19:53.000000000 +0200
+++ linux-2.6.26-fast/arch/parisc/kernel/setup.c	2008-07-15 16:20:15.000000000 +0200
@@ -57,11 +57,6 @@ int parisc_bus_is_phys __read_mostly = 1
 EXPORT_SYMBOL(parisc_bus_is_phys);
 #endif
 
-/* This sets the vmerge boundary and size, it's here because it has to
- * be available on all platforms (zero means no-virtual merging) */
-unsigned long parisc_vmerge_boundary = 0;
-unsigned long parisc_vmerge_max_size = 0;
-
 void __init setup_cmdline(char **cmdline_p)
 {
 	extern unsigned int boot_args[];
Index: linux-2.6.26-fast/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.26-fast.orig/arch/x86/kernel/pci-dma.c	2008-07-15 16:19:53.000000000 +0200
+++ linux-2.6.26-fast/arch/x86/kernel/pci-dma.c	2008-07-15 16:20:15.000000000 +0200
@@ -30,11 +30,6 @@ int no_iommu __read_mostly;
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly = 0;
 
-/* This tells the BIO block layer to assume merging. Default to off
-   because we cannot guarantee merging later. */
-int iommu_bio_merge __read_mostly = 0;
-EXPORT_SYMBOL(iommu_bio_merge);
-
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
 
@@ -151,7 +146,6 @@ static __init int iommu_setup(char *p)
 		}
 
 		if (!strncmp(p, "biomerge", 8)) {
-			iommu_bio_merge = 4096;
 			iommu_merge = 1;
 			force_iommu = 1;
 		}
Index: linux-2.6.26-fast/block/blk-merge.c
===================================================================
--- linux-2.6.26-fast.orig/block/blk-merge.c	2008-07-15 16:19:53.000000000 +0200
+++ linux-2.6.26-fast/block/blk-merge.c	2008-07-15 16:20:15.000000000 +0200
@@ -66,7 +66,7 @@ void blk_recalc_rq_segments(struct reque
 		 */
 		high = page_to_pfn(bv->bv_page) > q->bounce_pfn;
 		if (high || highprv)
-			goto new_hw_segment;
+			goto new_segment;
 		if (cluster) {
 			if (seg_size + bv->bv_len > q->max_segment_size)
 				goto new_segment;
@@ -74,8 +74,6 @@ void blk_recalc_rq_segments(struct reque
 				goto new_segment;
 			if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bv))
 				goto new_segment;
-			if (BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len))
-				goto new_hw_segment;
 
 			seg_size += bv->bv_len;
 			hw_seg_size += bv->bv_len;
@@ -83,17 +81,11 @@ void blk_recalc_rq_segments(struct reque
 			continue;
 		}
 new_segment:
-		if (BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
-		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len))
-			hw_seg_size += bv->bv_len;
-		else {
-new_hw_segment:
-			if (nr_hw_segs == 1 &&
-			    hw_seg_size > rq->bio->bi_hw_front_size)
-				rq->bio->bi_hw_front_size = hw_seg_size;
-			hw_seg_size = BIOVEC_VIRT_START_SIZE(bv) + bv->bv_len;
-			nr_hw_segs++;
-		}
+		if (nr_hw_segs == 1 &&
+		    hw_seg_size > rq->bio->bi_hw_front_size)
+			rq->bio->bi_hw_front_size = hw_seg_size;
+		hw_seg_size = bv->bv_len;
+		nr_hw_segs++;
 
 		nr_phys_segs++;
 		bvprv = bv;
@@ -146,22 +138,6 @@ static int blk_phys_contig_segment(struc
 	return 0;
 }
 
-static int blk_hw_contig_segment(struct request_queue *q, struct bio *bio,
-				 struct bio *nxt)
-{
-	if (!bio_flagged(bio, BIO_SEG_VALID))
-		blk_recount_segments(q, bio);
-	if (!bio_flagged(nxt, BIO_SEG_VALID))
-		blk_recount_segments(q, nxt);
-	if (!BIOVEC_VIRT_MERGEABLE(__BVEC_END(bio), __BVEC_START(nxt)) ||
-	    BIOVEC_VIRT_OVERSIZE(bio->bi_hw_back_size + nxt->bi_hw_front_size))
-		return 0;
-	if (bio->bi_hw_back_size + nxt->bi_hw_front_size > q->max_segment_size)
-		return 0;
-
-	return 1;
-}
-
 /*
  * map a request to scatterlist, return number of sg entries setup. Caller
  * must make sure sg can hold rq->nr_phys_segments entries
@@ -317,18 +293,6 @@ int ll_back_merge_fn(struct request_queu
 	if (!bio_flagged(bio, BIO_SEG_VALID))
 		blk_recount_segments(q, bio);
 	len = req->biotail->bi_hw_back_size + bio->bi_hw_front_size;
-	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail), __BVEC_START(bio))
-	    && !BIOVEC_VIRT_OVERSIZE(len)) {
-		int mergeable =  ll_new_mergeable(q, req, bio);
-
-		if (mergeable) {
-			if (req->nr_hw_segments == 1)
-				req->bio->bi_hw_front_size = len;
-			if (bio->bi_hw_segments == 1)
-				bio->bi_hw_back_size = len;
-		}
-		return mergeable;
-	}
 
 	return ll_new_hw_segment(q, req, bio);
 }
@@ -356,18 +320,6 @@ int ll_front_merge_fn(struct request_que
 		blk_recount_segments(q, bio);
 	if (!bio_flagged(req->bio, BIO_SEG_VALID))
 		blk_recount_segments(q, req->bio);
-	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(bio), __BVEC_START(req->bio)) &&
-	    !BIOVEC_VIRT_OVERSIZE(len)) {
-		int mergeable =  ll_new_mergeable(q, req, bio);
-
-		if (mergeable) {
-			if (bio->bi_hw_segments == 1)
-				bio->bi_hw_front_size = len;
-			if (req->nr_hw_segments == 1)
-				req->biotail->bi_hw_back_size = len;
-		}
-		return mergeable;
-	}
 
 	return ll_new_hw_segment(q, req, bio);
 }
@@ -399,18 +351,6 @@ static int ll_merge_requests_fn(struct r
 		return 0;
 
 	total_hw_segments = req->nr_hw_segments + next->nr_hw_segments;
-	if (blk_hw_contig_segment(q, req->biotail, next->bio)) {
-		int len = req->biotail->bi_hw_back_size +
-				next->bio->bi_hw_front_size;
-		/*
-		 * propagate the combined length to the end of the requests
-		 */
-		if (req->nr_hw_segments == 1)
-			req->bio->bi_hw_front_size = len;
-		if (next->nr_hw_segments == 1)
-			next->biotail->bi_hw_back_size = len;
-		total_hw_segments--;
-	}
 
 	if (total_hw_segments > q->max_hw_segments)
 		return 0;
Index: linux-2.6.26-fast/include/asm-alpha/io.h
===================================================================
--- linux-2.6.26-fast.orig/include/asm-alpha/io.h	2008-07-15 16:19:52.000000000 +0200
+++ linux-2.6.26-fast/include/asm-alpha/io.h	2008-07-15 16:20:15.000000000 +0200
@@ -96,9 +96,6 @@ static inline dma_addr_t __deprecated is
 	return page_to_phys(page);
 }
 
-/* This depends on working iommu.  */
-#define BIO_VMERGE_BOUNDARY	(alpha_mv.mv_pci_tbi ? PAGE_SIZE : 0)
-
 /* Maximum PIO space address supported?  */
 #define IO_SPACE_LIMIT 0xffff
 
Index: linux-2.6.26-fast/include/asm-ia64/io.h
===================================================================
--- linux-2.6.26-fast.orig/include/asm-ia64/io.h	2008-07-15 16:19:52.000000000 +0200
+++ linux-2.6.26-fast/include/asm-ia64/io.h	2008-07-15 16:20:15.000000000 +0200
@@ -430,30 +430,8 @@ extern void memcpy_fromio(void *dst, con
 extern void memcpy_toio(volatile void __iomem *dst, const void *src, long n);
 extern void memset_io(volatile void __iomem *s, int c, long n);
 
-# endif /* __KERNEL__ */
-
-/*
- * Enabling BIO_VMERGE_BOUNDARY forces us to turn off I/O MMU bypassing.  It is said that
- * BIO-level virtual merging can give up to 4% performance boost (not verified for ia64).
- * On the other hand, we know that I/O MMU bypassing gives ~8% performance improvement on
- * SPECweb-like workloads on zx1-based machines.  Thus, for now we favor I/O MMU bypassing
- * over BIO-level virtual merging.
- */
 extern unsigned long ia64_max_iommu_merge_mask;
-#if 1
-#define BIO_VMERGE_BOUNDARY	0
-#else
-/*
- * It makes no sense at all to have this BIO_VMERGE_BOUNDARY macro here.  Should be
- * replaced by dma_merge_mask() or something of that sort.  Note: the only way
- * BIO_VMERGE_BOUNDARY is used is to mask off bits.  Effectively, our definition gets
- * expanded into:
- *
- *	addr & ((ia64_max_iommu_merge_mask + 1) - 1) == (addr & ia64_max_iommu_vmerge_mask)
- *
- * which is precisely what we want.
- */
-#define BIO_VMERGE_BOUNDARY	(ia64_max_iommu_merge_mask + 1)
-#endif
+
+# endif /* __KERNEL__ */
 
 #endif /* _ASM_IA64_IO_H */
Index: linux-2.6.26-fast/include/asm-parisc/io.h
===================================================================
--- linux-2.6.26-fast.orig/include/asm-parisc/io.h	2008-07-15 16:19:53.000000000 +0200
+++ linux-2.6.26-fast/include/asm-parisc/io.h	2008-07-15 16:20:15.000000000 +0200
@@ -4,12 +4,6 @@
 #include <linux/types.h>
 #include <asm/pgtable.h>
 
-extern unsigned long parisc_vmerge_boundary;
-extern unsigned long parisc_vmerge_max_size;
-
-#define BIO_VMERGE_BOUNDARY	parisc_vmerge_boundary
-#define BIO_VMERGE_MAX_SIZE	parisc_vmerge_max_size
-
 #define virt_to_phys(a) ((unsigned long)__pa(a))
 #define phys_to_virt(a) __va(a)
 #define virt_to_bus virt_to_phys
Index: linux-2.6.26-fast/include/asm-powerpc/io.h
===================================================================
--- linux-2.6.26-fast.orig/include/asm-powerpc/io.h	2008-07-15 16:19:53.000000000 +0200
+++ linux-2.6.26-fast/include/asm-powerpc/io.h	2008-07-15 16:20:15.000000000 +0200
@@ -683,13 +683,6 @@ static inline void * phys_to_virt(unsign
  */
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 
-/* We do NOT want virtual merging, it would put too much pressure on
- * our iommu allocator. Instead, we want drivers to be smart enough
- * to coalesce sglists that happen to have been mapped in a contiguous
- * way by the iommu
- */
-#define BIO_VMERGE_BOUNDARY	0
-
 /*
  * 32 bits still uses virt_to_bus() for it's implementation of DMA
  * mappings se we have to keep it defined here. We also have some old
Index: linux-2.6.26-fast/include/asm-sparc64/io.h
===================================================================
--- linux-2.6.26-fast.orig/include/asm-sparc64/io.h	2008-07-15 16:19:53.000000000 +0200
+++ linux-2.6.26-fast/include/asm-sparc64/io.h	2008-07-15 16:20:15.000000000 +0200
@@ -16,7 +16,6 @@
 /* BIO layer definitions. */
 extern unsigned long kern_base, kern_size;
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
-#define BIO_VMERGE_BOUNDARY	8192
 
 static inline u8 _inb(unsigned long addr)
 {
Index: linux-2.6.26-fast/include/asm-x86/io_64.h
===================================================================
--- linux-2.6.26-fast.orig/include/asm-x86/io_64.h	2008-07-15 16:19:53.000000000 +0200
+++ linux-2.6.26-fast/include/asm-x86/io_64.h	2008-07-15 16:20:15.000000000 +0200
@@ -304,9 +304,6 @@ void memset_io(volatile void __iomem *a,
 
 #define flush_write_buffers()
 
-extern int iommu_bio_merge;
-#define BIO_VMERGE_BOUNDARY iommu_bio_merge
-
 /*
  * Convert a virtual cached pointer to an uncached pointer
  */
Index: linux-2.6.26-fast/include/linux/bio.h
===================================================================
--- linux-2.6.26-fast.orig/include/linux/bio.h	2008-07-15 16:19:53.000000000 +0200
+++ linux-2.6.26-fast/include/linux/bio.h	2008-07-15 16:20:15.000000000 +0200
@@ -26,21 +26,8 @@
 
 #ifdef CONFIG_BLOCK
 
-/* Platforms may set this to teach the BIO layer about IOMMU hardware. */
 #include <asm/io.h>
 
-#if defined(BIO_VMERGE_MAX_SIZE) && defined(BIO_VMERGE_BOUNDARY)
-#define BIOVEC_VIRT_START_SIZE(x) (bvec_to_phys(x) & (BIO_VMERGE_BOUNDARY - 1))
-#define BIOVEC_VIRT_OVERSIZE(x)	((x) > BIO_VMERGE_MAX_SIZE)
-#else
-#define BIOVEC_VIRT_START_SIZE(x)	0
-#define BIOVEC_VIRT_OVERSIZE(x)		0
-#endif
-
-#ifndef BIO_VMERGE_BOUNDARY
-#define BIO_VMERGE_BOUNDARY	0
-#endif
-
 #define BIO_DEBUG
 
 #ifdef BIO_DEBUG
@@ -235,8 +222,6 @@ static inline void *bio_data(struct bio 
 	((bvec_to_phys((vec1)) + (vec1)->bv_len) == bvec_to_phys((vec2)))
 #endif
 
-#define BIOVEC_VIRT_MERGEABLE(vec1, vec2)	\
-	((((bvec_to_phys((vec1)) + (vec1)->bv_len) | bvec_to_phys((vec2))) & (BIO_VMERGE_BOUNDARY - 1)) == 0)
 #define __BIO_SEG_BOUNDARY(addr1, addr2, mask) \
 	(((addr1) | (mask)) == (((addr2) - 1) | (mask)))
 #define BIOVEC_SEG_BOUNDARY(q, b1, b2) \
Index: linux-2.6.26-fast/fs/bio.c
===================================================================
--- linux-2.6.26-fast.orig/fs/bio.c	2008-07-15 16:19:53.000000000 +0200
+++ linux-2.6.26-fast/fs/bio.c	2008-07-15 16:20:15.000000000 +0200
@@ -352,8 +352,7 @@ static int __bio_add_page(struct request
 	 */
 
 	while (bio->bi_phys_segments >= q->max_phys_segments
-	       || bio->bi_hw_segments >= q->max_hw_segments
-	       || BIOVEC_VIRT_OVERSIZE(bio->bi_size)) {
+	       || bio->bi_hw_segments >= q->max_hw_segments) {
 
 		if (retried_segments)
 			return 0;
@@ -390,8 +389,7 @@ static int __bio_add_page(struct request
 	}
 
 	/* If we may be able to merge these biovecs, force a recount */
-	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec) ||
-	    BIOVEC_VIRT_MERGEABLE(bvec-1, bvec)))
+	if (bio->bi_vcnt && (BIOVEC_PHYS_MERGEABLE(bvec-1, bvec)))
 		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 
 	bio->bi_vcnt++;
Index: linux-2.6.26-fast/drivers/parisc/ccio-dma.c
===================================================================
--- linux-2.6.26-fast.orig/drivers/parisc/ccio-dma.c	2008-07-15 16:29:31.000000000 +0200
+++ linux-2.6.26-fast/drivers/parisc/ccio-dma.c	2008-07-15 16:34:23.000000000 +0200
@@ -1587,8 +1587,6 @@ static int __init ccio_probe(struct pari
 
 	ioc_count++;
 
-	parisc_vmerge_boundary = IOVP_SIZE;
-	parisc_vmerge_max_size = BITS_PER_LONG * IOVP_SIZE;
 	parisc_has_iommu();
 	return 0;
 }
Index: linux-2.6.26-fast/drivers/parisc/sba_iommu.c
===================================================================
--- linux-2.6.26-fast.orig/drivers/parisc/sba_iommu.c	2008-07-15 16:29:31.000000000 +0200
+++ linux-2.6.26-fast/drivers/parisc/sba_iommu.c	2008-07-15 16:34:32.000000000 +0200
@@ -1979,8 +1979,6 @@ sba_driver_callback(struct parisc_device
 	proc_create("sba_iommu-bitmap", 0, root, &sba_proc_bitmap_fops);
 #endif
 
-	parisc_vmerge_boundary = IOVP_SIZE;
-	parisc_vmerge_max_size = IOVP_SIZE * BITS_PER_LONG;
 	parisc_has_iommu();
 	return 0;
 }
