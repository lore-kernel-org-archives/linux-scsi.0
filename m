Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4DC267AED;
	Fri,  2 May 2025 06:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746168591; cv=none; b=HXcdI7k3CiKwTSA2dhaqaOXiBy9ga67vlDyAta+vZHC9dyJipBy9r/hK1uv5UJxKOZG633epw/oO3eHMpe8NB8+QMSrNZm6jyjVRHCvEo3yd83fhYBEUBjnynVtroO/2e9ITV3eiySXH2DlijmW/qnz+Vg8SQfKxV9QLrcMtNPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746168591; c=relaxed/simple;
	bh=slyyotA22NhdkHBNZlO9tsm+DD7sCorvraA7JdOV1Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJD4wOqxeqOcIaUv+XTodcxdwOrWwG2ghIYfVZdhVXwROAKdC4htdhD6BQk+8cPg6Bw5VT9stz8EXg/cVg+jERW6M8IVAq5D3rHKvomcHsHSc7EGKklPcR06IsrYnP+VLQb8CAnONRFDiVdvtQBfVahDLtuypnX+6m5uCeGmkew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gOLzpXAs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gOLzpXAs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lnoEImdQYuJ6Bxz2Pqiv3fuac79e18hKKtzQRDifFHI=; b=gOLzpXAsc+QwRjpnegvv9j+eBq
	IG4Mfv0RQ75RqCAZ0SikjGpZKGCpGqdkBt0b2fO0aYlGy/0j2/TK77k/dYZEZFw2Y41d70+XjxWPK
	fyqZVXpFy6g/juZr2WKElty9uceXq1WPq0R8s2twtM+0gNdTMd/SzwFHaphveAwoUtZ8UTaTvRAQH
	8jekZs+L/pXFoScLxAyM/NW4FUZTa4VPMorevZSLt8Tj5FmGwWhnmCw9ssGaZ+UnYtoiCb6Z4qS3g
	jPf4DqoUhOEjpnam6oenNk6EZ9Ye+HqMrj5s2zcsXEDlIXdBDs41CO1Oa5U/69OFjiArifev7qLig
	Q7SJIG2w==;
Received: from [185.143.37.16] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAkDT-0000000115u-2UmM;
	Fri, 02 May 2025 06:49:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-mm@kvack.org
Subject: [PATCH 6/7] block: remove bounce buffering support
Date: Fri,  2 May 2025 07:49:23 +0100
Message-ID: <20250502064930.2981820-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502064930.2981820-1-hch@lst.de>
References: <20250502064930.2981820-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The block layer bounce buffering support is unused now, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/mips/configs/gcw0_defconfig  |   1 -
 block/Makefile                    |   1 -
 block/blk-map.c                   |   5 +-
 block/blk-mq.c                    |   2 -
 block/blk-settings.c              |   5 -
 block/blk.h                       |  17 --
 block/bounce.c                    | 267 ------------------------------
 include/linux/blk_types.h         |   1 -
 include/linux/blkdev.h            |   5 +-
 include/trace/events/block.h      |  15 --
 include/uapi/linux/blktrace_api.h |   2 +-
 kernel/trace/blktrace.c           |   9 -
 12 files changed, 3 insertions(+), 327 deletions(-)
 delete mode 100644 block/bounce.c

diff --git a/arch/mips/configs/gcw0_defconfig b/arch/mips/configs/gcw0_defconfig
index bc1ef66e3999..8b7ad877e07a 100644
--- a/arch/mips/configs/gcw0_defconfig
+++ b/arch/mips/configs/gcw0_defconfig
@@ -13,7 +13,6 @@ CONFIG_MIPS_CMDLINE_DTB_EXTEND=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
-# CONFIG_BOUNCE is not set
 CONFIG_NET=y
 CONFIG_PACKET=y
 CONFIG_UNIX=y
diff --git a/block/Makefile b/block/Makefile
index 3a941dc0d27f..36033c0f07bc 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -11,7 +11,6 @@ obj-y		:= bdev.o fops.o bio.o elevator.o blk-core.o blk-sysfs.o \
 			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \
 			disk-events.o blk-ia-ranges.o early-lookup.o
 
-obj-$(CONFIG_BOUNCE)		+= bounce.o
 obj-$(CONFIG_BLK_DEV_BSG_COMMON) += bsg.o
 obj-$(CONFIG_BLK_DEV_BSGLIB)	+= bsg-lib.o
 obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
diff --git a/block/blk-map.c b/block/blk-map.c
index d2f22744b3d1..cadbf11b50a3 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -556,8 +556,6 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 
 	if (map_data)
 		copy = true;
-	else if (blk_queue_may_bounce(q))
-		copy = true;
 	else if (iov_iter_alignment(iter) & align)
 		copy = true;
 	else if (iov_iter_is_bvec(iter))
@@ -713,8 +711,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (!len || !kbuf)
 		return -EINVAL;
 
-	if (!blk_rq_aligned(q, addr, len) || object_is_on_stack(kbuf) ||
-	    blk_queue_may_bounce(q))
+	if (!blk_rq_aligned(q, addr, len) || object_is_on_stack(kbuf))
 		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
 	else
 		bio = bio_map_kern(q, kbuf, len, gfp_mask);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 554380bfd002..714ab6062e94 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3098,8 +3098,6 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto new_request;
 	}
 
-	bio = blk_queue_bounce(bio, q);
-
 	/*
 	 * The cached request already holds a q_usage_counter reference and we
 	 * don't have to acquire a new one if we use it.
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 4817e7ca03f8..a000daafbfb4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -124,11 +124,6 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
 		return 0;
 	}
 
-	if (lim->features & BLK_FEAT_BOUNCE_HIGH) {
-		pr_warn("no bounce buffer support for integrity metadata\n");
-		return -EINVAL;
-	}
-
 	if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY)) {
 		pr_warn("integrity support disabled.\n");
 		return -EINVAL;
diff --git a/block/blk.h b/block/blk.h
index 328075787814..ff21f234b62f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -443,23 +443,6 @@ static inline void ioc_clear_queue(struct request_queue *q)
 }
 #endif /* CONFIG_BLK_ICQ */
 
-struct bio *__blk_queue_bounce(struct bio *bio, struct request_queue *q);
-
-static inline bool blk_queue_may_bounce(struct request_queue *q)
-{
-	return IS_ENABLED(CONFIG_BOUNCE) &&
-		(q->limits.features & BLK_FEAT_BOUNCE_HIGH) &&
-		max_low_pfn >= max_pfn;
-}
-
-static inline struct bio *blk_queue_bounce(struct bio *bio,
-		struct request_queue *q)
-{
-	if (unlikely(blk_queue_may_bounce(q) && bio_has_data(bio)))
-		return __blk_queue_bounce(bio, q);
-	return bio;
-}
-
 #ifdef CONFIG_BLK_DEV_ZONED
 void disk_init_zone_resources(struct gendisk *disk);
 void disk_free_zone_resources(struct gendisk *disk);
diff --git a/block/bounce.c b/block/bounce.c
deleted file mode 100644
index 09a9616cf209..000000000000
--- a/block/bounce.c
+++ /dev/null
@@ -1,267 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* bounce buffer handling for block devices
- *
- * - Split from highmem.c
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/mm.h>
-#include <linux/export.h>
-#include <linux/swap.h>
-#include <linux/gfp.h>
-#include <linux/bio-integrity.h>
-#include <linux/pagemap.h>
-#include <linux/mempool.h>
-#include <linux/blkdev.h>
-#include <linux/backing-dev.h>
-#include <linux/init.h>
-#include <linux/hash.h>
-#include <linux/highmem.h>
-#include <linux/printk.h>
-#include <asm/tlbflush.h>
-
-#include <trace/events/block.h>
-#include "blk.h"
-#include "blk-cgroup.h"
-
-#define POOL_SIZE	64
-#define ISA_POOL_SIZE	16
-
-static struct bio_set bounce_bio_set, bounce_bio_split;
-static mempool_t page_pool;
-
-static void init_bounce_bioset(void)
-{
-	static bool bounce_bs_setup;
-	int ret;
-
-	if (bounce_bs_setup)
-		return;
-
-	ret = bioset_init(&bounce_bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
-	BUG_ON(ret);
-
-	ret = bioset_init(&bounce_bio_split, BIO_POOL_SIZE, 0, 0);
-	BUG_ON(ret);
-	bounce_bs_setup = true;
-}
-
-static __init int init_emergency_pool(void)
-{
-	int ret;
-
-#ifndef CONFIG_MEMORY_HOTPLUG
-	if (max_pfn <= max_low_pfn)
-		return 0;
-#endif
-
-	ret = mempool_init_page_pool(&page_pool, POOL_SIZE, 0);
-	BUG_ON(ret);
-	pr_info("pool size: %d pages\n", POOL_SIZE);
-
-	init_bounce_bioset();
-	return 0;
-}
-
-__initcall(init_emergency_pool);
-
-/*
- * Simple bounce buffer support for highmem pages. Depending on the
- * queue gfp mask set, *to may or may not be a highmem page. kmap it
- * always, it will do the Right Thing
- */
-static void copy_to_high_bio_irq(struct bio *to, struct bio *from)
-{
-	struct bio_vec tovec, fromvec;
-	struct bvec_iter iter;
-	/*
-	 * The bio of @from is created by bounce, so we can iterate
-	 * its bvec from start to end, but the @from->bi_iter can't be
-	 * trusted because it might be changed by splitting.
-	 */
-	struct bvec_iter from_iter = BVEC_ITER_ALL_INIT;
-
-	bio_for_each_segment(tovec, to, iter) {
-		fromvec = bio_iter_iovec(from, from_iter);
-		if (tovec.bv_page != fromvec.bv_page) {
-			/*
-			 * fromvec->bv_offset and fromvec->bv_len might have
-			 * been modified by the block layer, so use the original
-			 * copy, bounce_copy_vec already uses tovec->bv_len
-			 */
-			memcpy_to_bvec(&tovec, page_address(fromvec.bv_page) +
-				       tovec.bv_offset);
-		}
-		bio_advance_iter(from, &from_iter, tovec.bv_len);
-	}
-}
-
-static void bounce_end_io(struct bio *bio)
-{
-	struct bio *bio_orig = bio->bi_private;
-	struct bio_vec *bvec, orig_vec;
-	struct bvec_iter orig_iter = bio_orig->bi_iter;
-	struct bvec_iter_all iter_all;
-
-	/*
-	 * free up bounce indirect pages used
-	 */
-	bio_for_each_segment_all(bvec, bio, iter_all) {
-		orig_vec = bio_iter_iovec(bio_orig, orig_iter);
-		if (bvec->bv_page != orig_vec.bv_page) {
-			dec_zone_page_state(bvec->bv_page, NR_BOUNCE);
-			mempool_free(bvec->bv_page, &page_pool);
-		}
-		bio_advance_iter(bio_orig, &orig_iter, orig_vec.bv_len);
-	}
-
-	bio_orig->bi_status = bio->bi_status;
-	bio_endio(bio_orig);
-	bio_put(bio);
-}
-
-static void bounce_end_io_write(struct bio *bio)
-{
-	bounce_end_io(bio);
-}
-
-static void bounce_end_io_read(struct bio *bio)
-{
-	struct bio *bio_orig = bio->bi_private;
-
-	if (!bio->bi_status)
-		copy_to_high_bio_irq(bio_orig, bio);
-
-	bounce_end_io(bio);
-}
-
-static struct bio *bounce_clone_bio(struct bio *bio_src)
-{
-	struct bvec_iter iter;
-	struct bio_vec bv;
-	struct bio *bio;
-
-	/*
-	 * Pre immutable biovecs, __bio_clone() used to just do a memcpy from
-	 * bio_src->bi_io_vec to bio->bi_io_vec.
-	 *
-	 * We can't do that anymore, because:
-	 *
-	 *  - The point of cloning the biovec is to produce a bio with a biovec
-	 *    the caller can modify: bi_idx and bi_bvec_done should be 0.
-	 *
-	 *  - The original bio could've had more than BIO_MAX_VECS biovecs; if
-	 *    we tried to clone the whole thing bio_alloc_bioset() would fail.
-	 *    But the clone should succeed as long as the number of biovecs we
-	 *    actually need to allocate is fewer than BIO_MAX_VECS.
-	 *
-	 *  - Lastly, bi_vcnt should not be looked at or relied upon by code
-	 *    that does not own the bio - reason being drivers don't use it for
-	 *    iterating over the biovec anymore, so expecting it to be kept up
-	 *    to date (i.e. for clones that share the parent biovec) is just
-	 *    asking for trouble and would force extra work.
-	 */
-	bio = bio_alloc_bioset(bio_src->bi_bdev, bio_segments(bio_src),
-			       bio_src->bi_opf, GFP_NOIO, &bounce_bio_set);
-	if (bio_flagged(bio_src, BIO_REMAPPED))
-		bio_set_flag(bio, BIO_REMAPPED);
-	bio->bi_ioprio		= bio_src->bi_ioprio;
-	bio->bi_write_hint	= bio_src->bi_write_hint;
-	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
-	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
-
-	switch (bio_op(bio)) {
-	case REQ_OP_DISCARD:
-	case REQ_OP_SECURE_ERASE:
-	case REQ_OP_WRITE_ZEROES:
-		break;
-	default:
-		bio_for_each_segment(bv, bio_src, iter)
-			bio->bi_io_vec[bio->bi_vcnt++] = bv;
-		break;
-	}
-
-	if (bio_crypt_clone(bio, bio_src, GFP_NOIO) < 0)
-		goto err_put;
-
-	if (bio_integrity(bio_src) &&
-	    bio_integrity_clone(bio, bio_src, GFP_NOIO) < 0)
-		goto err_put;
-
-	bio_clone_blkg_association(bio, bio_src);
-
-	return bio;
-
-err_put:
-	bio_put(bio);
-	return NULL;
-}
-
-struct bio *__blk_queue_bounce(struct bio *bio_orig, struct request_queue *q)
-{
-	struct bio *bio;
-	int rw = bio_data_dir(bio_orig);
-	struct bio_vec *to, from;
-	struct bvec_iter iter;
-	unsigned i = 0, bytes = 0;
-	bool bounce = false;
-	int sectors;
-
-	bio_for_each_segment(from, bio_orig, iter) {
-		if (i++ < BIO_MAX_VECS)
-			bytes += from.bv_len;
-		if (PageHighMem(from.bv_page))
-			bounce = true;
-	}
-	if (!bounce)
-		return bio_orig;
-
-	/*
-	 * Individual bvecs might not be logical block aligned. Round down
-	 * the split size so that each bio is properly block size aligned,
-	 * even if we do not use the full hardware limits.
-	 */
-	sectors = ALIGN_DOWN(bytes, queue_logical_block_size(q)) >>
-			SECTOR_SHIFT;
-	if (sectors < bio_sectors(bio_orig)) {
-		bio = bio_split(bio_orig, sectors, GFP_NOIO, &bounce_bio_split);
-		bio_chain(bio, bio_orig);
-		submit_bio_noacct(bio_orig);
-		bio_orig = bio;
-	}
-	bio = bounce_clone_bio(bio_orig);
-
-	/*
-	 * Bvec table can't be updated by bio_for_each_segment_all(),
-	 * so retrieve bvec from the table directly. This way is safe
-	 * because the 'bio' is single-page bvec.
-	 */
-	for (i = 0, to = bio->bi_io_vec; i < bio->bi_vcnt; to++, i++) {
-		struct page *bounce_page;
-
-		if (!PageHighMem(to->bv_page))
-			continue;
-
-		bounce_page = mempool_alloc(&page_pool, GFP_NOIO);
-		inc_zone_page_state(bounce_page, NR_BOUNCE);
-
-		if (rw == WRITE) {
-			flush_dcache_page(to->bv_page);
-			memcpy_from_bvec(page_address(bounce_page), to);
-		}
-		to->bv_page = bounce_page;
-	}
-
-	trace_block_bio_bounce(bio_orig);
-
-	bio->bi_flags |= (1 << BIO_BOUNCED);
-
-	if (rw == READ)
-		bio->bi_end_io = bounce_end_io_read;
-	else
-		bio->bi_end_io = bounce_end_io_write;
-
-	bio->bi_private = bio_orig;
-	return bio;
-}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index dce7615c35e7..5a46067e85b1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -286,7 +286,6 @@ struct bio {
 enum {
 	BIO_PAGE_PINNED,	/* Unpin pages in bio_release_pages() */
 	BIO_CLONED,		/* doesn't own data */
-	BIO_BOUNCED,		/* bio is a bounce bio */
 	BIO_QUIET,		/* Make BIO Quiet */
 	BIO_CHAIN,		/* chained bio, ->bi_remaining in effect */
 	BIO_REFFED,		/* bio has elevated ->bi_cnt */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f3d74f9dae8e..5ccb961ee2ae 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -331,9 +331,6 @@ typedef unsigned int __bitwise blk_features_t;
 /* skip this queue in blk_mq_(un)quiesce_tagset */
 #define BLK_FEAT_SKIP_TAGSET_QUIESCE	((__force blk_features_t)(1u << 13))
 
-/* bounce all highmem pages */
-#define BLK_FEAT_BOUNCE_HIGH		((__force blk_features_t)(1u << 14))
-
 /* undocumented magic for bcache */
 #define BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE \
 	((__force blk_features_t)(1u << 15))
@@ -347,7 +344,7 @@ typedef unsigned int __bitwise blk_features_t;
  */
 #define BLK_FEAT_INHERIT_MASK \
 	(BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA | BLK_FEAT_ROTATIONAL | \
-	 BLK_FEAT_STABLE_WRITES | BLK_FEAT_ZONED | BLK_FEAT_BOUNCE_HIGH | \
+	 BLK_FEAT_STABLE_WRITES | BLK_FEAT_ZONED | \
 	 BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE)
 
 /* internal flags in queue_limits.flags */
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index bd0ea07338eb..ad36e73b8579 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -360,21 +360,6 @@ DECLARE_EVENT_CLASS(block_bio,
 		  __entry->nr_sector, __entry->comm)
 );
 
-/**
- * block_bio_bounce - used bounce buffer when processing block operation
- * @bio: block operation
- *
- * A bounce buffer was used to handle the block operation @bio in @q.
- * This occurs when hardware limitations prevent a direct transfer of
- * data between the @bio data memory area and the IO device.  Use of a
- * bounce buffer requires extra copying of data and decreases
- * performance.
- */
-DEFINE_EVENT(block_bio, block_bio_bounce,
-	TP_PROTO(struct bio *bio),
-	TP_ARGS(bio)
-);
-
 /**
  * block_bio_backmerge - merging block operation to the end of an existing operation
  * @bio: new block operation to merge
diff --git a/include/uapi/linux/blktrace_api.h b/include/uapi/linux/blktrace_api.h
index 690621b610e5..1bfb635e309b 100644
--- a/include/uapi/linux/blktrace_api.h
+++ b/include/uapi/linux/blktrace_api.h
@@ -49,7 +49,7 @@ enum blktrace_act {
 	__BLK_TA_UNPLUG_TIMER,		/* queue was unplugged by timer */
 	__BLK_TA_INSERT,		/* insert request */
 	__BLK_TA_SPLIT,			/* bio was split */
-	__BLK_TA_BOUNCE,		/* bio was bounced */
+	__BLK_TA_BOUNCE,		/* unused, was: bio was bounced */
 	__BLK_TA_REMAP,			/* bio was remapped */
 	__BLK_TA_ABORT,			/* request aborted */
 	__BLK_TA_DRV_DATA,		/* driver-specific binary data */
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 3679a6d18934..d5f36f415d9d 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -893,11 +893,6 @@ static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 	rcu_read_unlock();
 }
 
-static void blk_add_trace_bio_bounce(void *ignore, struct bio *bio)
-{
-	blk_add_trace_bio(bio->bi_bdev->bd_disk->queue, bio, BLK_TA_BOUNCE, 0);
-}
-
 static void blk_add_trace_bio_complete(void *ignore,
 				       struct request_queue *q, struct bio *bio)
 {
@@ -1089,8 +1084,6 @@ static void blk_register_tracepoints(void)
 	WARN_ON(ret);
 	ret = register_trace_block_rq_complete(blk_add_trace_rq_complete, NULL);
 	WARN_ON(ret);
-	ret = register_trace_block_bio_bounce(blk_add_trace_bio_bounce, NULL);
-	WARN_ON(ret);
 	ret = register_trace_block_bio_complete(blk_add_trace_bio_complete, NULL);
 	WARN_ON(ret);
 	ret = register_trace_block_bio_backmerge(blk_add_trace_bio_backmerge, NULL);
@@ -1125,7 +1118,6 @@ static void blk_unregister_tracepoints(void)
 	unregister_trace_block_bio_frontmerge(blk_add_trace_bio_frontmerge, NULL);
 	unregister_trace_block_bio_backmerge(blk_add_trace_bio_backmerge, NULL);
 	unregister_trace_block_bio_complete(blk_add_trace_bio_complete, NULL);
-	unregister_trace_block_bio_bounce(blk_add_trace_bio_bounce, NULL);
 	unregister_trace_block_rq_complete(blk_add_trace_rq_complete, NULL);
 	unregister_trace_block_rq_requeue(blk_add_trace_rq_requeue, NULL);
 	unregister_trace_block_rq_merge(blk_add_trace_rq_merge, NULL);
@@ -1462,7 +1454,6 @@ static const struct {
 	[__BLK_TA_UNPLUG_TIMER]	= {{ "UT", "unplug_timer" }, blk_log_unplug },
 	[__BLK_TA_INSERT]	= {{  "I", "insert" },	   blk_log_generic },
 	[__BLK_TA_SPLIT]	= {{  "X", "split" },	   blk_log_split },
-	[__BLK_TA_BOUNCE]	= {{  "B", "bounce" },	   blk_log_generic },
 	[__BLK_TA_REMAP]	= {{  "A", "remap" },	   blk_log_remap },
 };
 
-- 
2.47.2

