From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
 about VMERGE
Date: Tue, 15 Jul 2008 09:37:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
References: <1216118676-13625-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbYGONhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 09:37:51 -0400
In-Reply-To: <1216118676-13625-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>

On Tue, 15 Jul 2008, FUJITA Tomonori wrote:

> blk_recalc_rq_segments assumes that any segments can be merged in the
> case of BIOVEC_VIRT_MERGEABLE && !BIOVEC_VIRT_OVERSIZE. However, an
> IOMMU can't merge segments if the total length of the segments is
> larger than max_segment_size (the LLD restriction).
>
> Due to this bug, a LLD may get the larger number of segments than
> nr_hw_segments because the block layer puts more segments in a request
> than it should do.
>
> This bug could happen on alpha, parisc, and sparc, which use VMERGE.

Parisc doesn't use virtual merge accounting (there is variable for it but 
it's always 0). On sparc64 it is broken anyway with or without your patch. 
And alpha alone doesn't justify substantial code bloat in generic block 
layer. So I propose this patch to drop it at all.

A further patch could be made to drop bi_hw_segments, nr_hw_segments and 
similar --- they have no use for anything except alpha and because there 
are few alpha computers and alpha is discontinued platform, the logic for 
attempting to predict number of hardware segments can't be well tested and 
maintained.

> Like blk_hw_contig_segment() does, this patch uses hw_seg_size for
> simplicity, which is a bit larger than an exact value (we don't need
> BIOVEC_VIRT_START_SIZE here).
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: David Miller <davem@davemloft.net>
> ---
> block/blk-merge.c |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 5efc9e7..39a22f8 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -83,7 +83,8 @@ void blk_recalc_rq_segments(struct request *rq)
> 			continue;
> 		}
> new_segment:
> -		if (BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
> +		if (hw_seg_size + bv->bv_len <= q->max_segment_size &&
> +		    BIOVEC_VIRT_MERGEABLE(bvprv, bv) &&
> 		    !BIOVEC_VIRT_OVERSIZE(hw_seg_size + bv->bv_len))
> 			hw_seg_size += bv->bv_len;
> 		else {
>

Drop virtual merge accounting in bio layer (not the virtual merging 
itself). It is used only on Sparc64 (where it is broken and needs to be 
disabled) and on Alpha. This logic is very hard to maintain (the generic 
code in block/blk-merge.c tries to attempt to predict how 
architecture-specific IOMMU will merge the segments) and Alpha 
architecture alone doesn't justify the maintenance and code-bloat cost.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
  arch/parisc/kernel/setup.c |    5 ---
  arch/x86/kernel/pci-dma.c  |    6 ---
  block/blk-merge.c          |   72 +++------------------------------------------
  fs/bio.c                   |    6 +--
  include/asm-alpha/io.h     |    3 -
  include/asm-ia64/io.h      |   26 +---------------
  include/asm-parisc/io.h    |    6 ---
  include/asm-powerpc/io.h   |    7 ----
  include/asm-sparc64/io.h   |    1
  include/asm-x86/io_64.h    |    3 -
  include/linux/bio.h        |   15 ---------
  11 files changed, 10 insertions(+), 140 deletions(-)

Index: linux-2.6.26-fast/arch/parisc/kernel/setup.c
===================================================================
--- linux-2.6.26-fast.orig/arch/parisc/kernel/setup.c	2008-07-15 14:19:01.000000000 +0200
+++ linux-2.6.26-fast/arch/parisc/kernel/setup.c	2008-07-15 14:19:18.000000000 +0200
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
--- linux-2.6.26-fast.orig/arch/x86/kernel/pci-dma.c	2008-07-15 14:20:15.000000000 +0200
+++ linux-2.6.26-fast/arch/x86/kernel/pci-dma.c	2008-07-15 14:20:37.000000000 +0200
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
--- linux-2.6.26-fast.orig/block/blk-merge.c	2008-07-15 14:22:25.000000000 +0200
+++ linux-2.6.26-fast/block/blk-merge.c	2008-07-15 14:36:06.000000000 +0200
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
--- linux-2.6.26-fast.orig/include/asm-alpha/io.h	2008-07-15 14:14:39.000000000 +0200
+++ linux-2.6.26-fast/include/asm-alpha/io.h	2008-07-15 14:16:15.000000000 +0200
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
--- linux-2.6.26-fast.orig/include/asm-ia64/io.h	2008-07-15 14:14:45.000000000 +0200
+++ linux-2.6.26-fast/include/asm-ia64/io.h	2008-07-15 14:18:24.000000000 +0200
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
--- linux-2.6.26-fast.orig/include/asm-parisc/io.h	2008-07-15 14:14:52.000000000 +0200
+++ linux-2.6.26-fast/include/asm-parisc/io.h	2008-07-15 14:18:58.000000000 +0200
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
--- linux-2.6.26-fast.orig/include/asm-powerpc/io.h	2008-07-15 14:14:56.000000000 +0200
+++ linux-2.6.26-fast/include/asm-powerpc/io.h	2008-07-15 14:19:37.000000000 +0200
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
--- linux-2.6.26-fast.orig/include/asm-sparc64/io.h	2008-07-15 14:15:04.000000000 +0200
+++ linux-2.6.26-fast/include/asm-sparc64/io.h	2008-07-15 14:19:52.000000000 +0200
@@ -16,7 +16,6 @@
  /* BIO layer definitions. */
  extern unsigned long kern_base, kern_size;
  #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
-#define BIO_VMERGE_BOUNDARY	8192

  static inline u8 _inb(unsigned long addr)
  {
Index: linux-2.6.26-fast/include/asm-x86/io_64.h
===================================================================
--- linux-2.6.26-fast.orig/include/asm-x86/io_64.h	2008-07-15 14:15:08.000000000 +0200
+++ linux-2.6.26-fast/include/asm-x86/io_64.h	2008-07-15 14:20:11.000000000 +0200
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
--- linux-2.6.26-fast.orig/include/linux/bio.h	2008-07-15 14:15:13.000000000 +0200
+++ linux-2.6.26-fast/include/linux/bio.h	2008-07-15 14:44:58.000000000 +0200
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
--- linux-2.6.26-fast.orig/fs/bio.c	2008-07-15 14:43:03.000000000 +0200
+++ linux-2.6.26-fast/fs/bio.c	2008-07-15 14:43:58.000000000 +0200
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
