Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB09BC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 06:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B51E164E90
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 06:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCRGmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 02:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhCRGls (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 02:41:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E23EC06174A;
        Wed, 17 Mar 2021 23:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aYvjegl3ascq2CV1FDkLsEhkfB7pCJEATLWYWXl4YXA=; b=rDEeIiPDQHKfJolLOAcH9CkvYq
        lyx3BGHzPFzm/+wTEfwjXmIpAIAtat2PkKTKEM5ACsJfGn2DsBZRrmcLVpFGbyj08DDA0O+Nezi+S
        W3n4lHzQdw5Mm54nb22rb6njVi2bWa4MLd6cbCIcYyOaU+IWMjGBd6Og2YXamjuUSDvdTQmRkg5OU
        Olsyn1rjS0Zmd2lBJkk4lW0FmTD+gNPHuM/8Skul2Fhkp2wK9MK2JL+IXnOuEQt7n+aOfJpvcpq+f
        n5utJgCH3rPqK3qq2LMBOaF6n49LdPCDMsWgwwsvf/xKTCGHYk439vnH1MylR3sfPQtTAE3MHy6sr
        TcHkyOhA==;
Received: from [2001:4bb8:18c:bb3:e1cf:ad2f:7ff7:7a0b] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMmLI-002f4p-HA; Thu, 18 Mar 2021 06:41:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 7/8] block: refactor the bounce buffering code
Date:   Thu, 18 Mar 2021 07:39:22 +0100
Message-Id: <20210318063923.302738-8-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210318063923.302738-1-hch@lst.de>
References: <20210318063923.302738-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Get rid of all the PFN arithmetics and just use an enum for the two
remaining options, and use PageHighMem for the actual bounce decision.

Add a fast path to entirely avoid the call for the common case of a queue
not using the legacy bouncing code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c       |  6 ++----
 block/blk-settings.c   | 42 ++++++++----------------------------------
 block/blk.h            | 16 ++++++++++++----
 block/bounce.c         | 35 +++++------------------------------
 include/linux/blkdev.h | 29 +++++++++++------------------
 5 files changed, 38 insertions(+), 90 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fc60ff20849738..9bcdae93f6d4f7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1161,10 +1161,8 @@ static blk_status_t blk_cloned_rq_check_limits(struct request_queue *q,
 	}
 
 	/*
-	 * queue's settings related to segment counting like q->bounce_pfn
-	 * may differ from that of other stacking queues.
-	 * Recalculate it to check the request correctly on this queue's
-	 * limitation.
+	 * The queue settings related to segment counting may differ from the
+	 * original queue.
 	 */
 	rq->nr_phys_segments = blk_recalc_rq_segments(rq);
 	if (rq->nr_phys_segments > queue_max_segments(q)) {
diff --git a/block/blk-settings.c b/block/blk-settings.c
index f9937dd2810e25..c7e26d16c59c0e 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -7,7 +7,6 @@
 #include <linux/init.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
-#include <linux/memblock.h>	/* for max_pfn/max_low_pfn */
 #include <linux/gcd.h>
 #include <linux/lcm.h>
 #include <linux/jiffies.h>
@@ -17,11 +16,6 @@
 #include "blk.h"
 #include "blk-wbt.h"
 
-unsigned long blk_max_low_pfn;
-EXPORT_SYMBOL(blk_max_low_pfn);
-
-unsigned long blk_max_pfn;
-
 void blk_queue_rq_timeout(struct request_queue *q, unsigned int timeout)
 {
 	q->rq_timeout = timeout;
@@ -55,7 +49,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->discard_alignment = 0;
 	lim->discard_misaligned = 0;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
-	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
+	lim->bounce = BLK_BOUNCE_NONE;
 	lim->alignment_offset = 0;
 	lim->io_opt = 0;
 	lim->misaligned = 0;
@@ -92,28 +86,16 @@ EXPORT_SYMBOL(blk_set_stacking_limits);
 /**
  * blk_queue_bounce_limit - set bounce buffer limit for queue
  * @q: the request queue for the device
- * @max_addr: the maximum address the device can handle
+ * @bounce: bounce limit to enforce
  *
  * Description:
- *    Different hardware can have different requirements as to what pages
- *    it can do I/O directly to. A low level driver can call
- *    blk_queue_bounce_limit to have lower memory pages allocated as bounce
- *    buffers for doing I/O to pages residing above @max_addr.
+ *    Force bouncing for ISA DMA ranges or highmem.
+ *
+ *    DEPRECATED, don't use in new code.
  **/
-void blk_queue_bounce_limit(struct request_queue *q, u64 max_addr)
+void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce bounce)
 {
-	unsigned long b_pfn = max_addr >> PAGE_SHIFT;
-
-#if BITS_PER_LONG == 64
-	/*
-	 * Assume anything <= 4GB can be handled by IOMMU.  Actually
-	 * some IOMMUs can handle everything, but I don't know of a
-	 * way to test this here.
-	 */
-	q->limits.bounce_pfn = max(max_low_pfn, b_pfn);
-#else
-	q->limits.bounce_pfn = b_pfn;
-#endif
+	q->limits.bounce = bounce;
 }
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
@@ -536,7 +518,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 					b->max_write_zeroes_sectors);
 	t->max_zone_append_sectors = min(t->max_zone_append_sectors,
 					b->max_zone_append_sectors);
-	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
+	t->bounce = min_not_zero(t->bounce, b->bounce);
 
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
 					    b->seg_boundary_mask);
@@ -916,11 +898,3 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 	}
 }
 EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
-
-static int __init blk_settings_init(void)
-{
-	blk_max_low_pfn = max_low_pfn - 1;
-	blk_max_pfn = max_pfn - 1;
-	return 0;
-}
-subsys_initcall(blk_settings_init);
diff --git a/block/blk.h b/block/blk.h
index 895c9f4a5182a7..8f4337c5a9e66c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -6,6 +6,7 @@
 #include <linux/blk-mq.h>
 #include <linux/part_stat.h>
 #include <linux/blk-crypto.h>
+#include <linux/memblock.h>	/* for max_pfn/max_low_pfn */
 #include <xen/xen.h>
 #include "blk-crypto-internal.h"
 #include "blk-mq.h"
@@ -311,13 +312,20 @@ static inline void blk_throtl_bio_endio(struct bio *bio) { }
 static inline void blk_throtl_stat_add(struct request *rq, u64 time) { }
 #endif
 
-#ifdef CONFIG_BOUNCE
-extern void blk_queue_bounce(struct request_queue *q, struct bio **bio);
-#else
+void __blk_queue_bounce(struct request_queue *q, struct bio **bio);
+
+static inline bool blk_queue_may_bounce(struct request_queue *q)
+{
+	return IS_ENABLED(CONFIG_BOUNCE) &&
+		q->limits.bounce == BLK_BOUNCE_HIGH &&
+		max_low_pfn >= max_pfn;
+}
+
 static inline void blk_queue_bounce(struct request_queue *q, struct bio **bio)
 {
+	if (unlikely(blk_queue_may_bounce(q) && bio_has_data(*bio)))
+		__blk_queue_bounce(q, bio);	
 }
-#endif /* CONFIG_BOUNCE */
 
 #ifdef CONFIG_BLK_CGROUP_IOLATENCY
 extern int blk_iolatency_init(struct request_queue *q);
diff --git a/block/bounce.c b/block/bounce.c
index debd5b0bd31890..6bafc0d1f867a1 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/highmem.h>
-#include <linux/memblock.h>
 #include <linux/printk.h>
 #include <asm/tlbflush.h>
 
@@ -49,11 +48,11 @@ static void init_bounce_bioset(void)
 	bounce_bs_setup = true;
 }
 
-#if defined(CONFIG_HIGHMEM)
 static __init int init_emergency_pool(void)
 {
 	int ret;
-#if defined(CONFIG_HIGHMEM) && !defined(CONFIG_MEMORY_HOTPLUG)
+
+#ifndef CONFIG_MEMORY_HOTPLUG
 	if (max_pfn <= max_low_pfn)
 		return 0;
 #endif
@@ -67,9 +66,7 @@ static __init int init_emergency_pool(void)
 }
 
 __initcall(init_emergency_pool);
-#endif
 
-#ifdef CONFIG_HIGHMEM
 /*
  * highmem version, map in to vec
  */
@@ -82,13 +79,6 @@ static void bounce_copy_vec(struct bio_vec *to, unsigned char *vfrom)
 	kunmap_atomic(vto);
 }
 
-#else /* CONFIG_HIGHMEM */
-
-#define bounce_copy_vec(to, vfrom)	\
-	memcpy(page_address((to)->bv_page) + (to)->bv_offset, vfrom, (to)->bv_len)
-
-#endif /* CONFIG_HIGHMEM */
-
 /*
  * Simple bounce buffer support for highmem pages. Depending on the
  * queue gfp mask set, *to may or may not be a highmem page. kmap it
@@ -236,8 +226,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_src)
 	return NULL;
 }
 
-
-void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
+void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 {
 	struct bio *bio;
 	int rw = bio_data_dir(*bio_orig);
@@ -247,24 +236,10 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	bool bounce = false;
 	int sectors = 0;
 
-	/*
-	 * Data-less bio, nothing to bounce
-	 */
-	if (!bio_has_data(*bio_orig))
-		return;
-
-	/*
-	 * Just check if the bounce pfn is equal to or bigger than the highest
-	 * pfn in the system -- in that case, don't waste time iterating over
-	 * bio segments
-	 */
-	if (q->limits.bounce_pfn >= blk_max_pfn)
-		return;
-
 	bio_for_each_segment(from, *bio_orig, iter) {
 		if (i++ < BIO_MAX_VECS)
 			sectors += from.bv_len >> 9;
-		if (page_to_pfn(from.bv_page) > q->limits.bounce_pfn)
+		if (PageHighMem(from.bv_page))
 			bounce = true;
 	}
 	if (!bounce)
@@ -287,7 +262,7 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	for (i = 0, to = bio->bi_io_vec; i < bio->bi_vcnt; to++, i++) {
 		struct page *page = to->bv_page;
 
-		if (page_to_pfn(page) <= q->limits.bounce_pfn)
+		if (!PageHighMem(page))
 			continue;
 
 		to->bv_page = mempool_alloc(&page_pool, GFP_NOIO);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0dbb72ea373529..55cc8b96c84427 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -313,8 +313,17 @@ enum blk_zoned_model {
 	BLK_ZONED_HM,		/* Host-managed zoned block device */
 };
 
+/*
+ * BLK_BOUNCE_NONE:	never bounce (default)
+ * BLK_BOUNCE_HIGH:	bounce all highmem pages
+ */
+enum blk_bounce {
+	BLK_BOUNCE_NONE,
+	BLK_BOUNCE_HIGH,
+};
+
 struct queue_limits {
-	unsigned long		bounce_pfn;
+	enum blk_bounce		bounce;
 	unsigned long		seg_boundary_mask;
 	unsigned long		virt_boundary_mask;
 
@@ -835,22 +844,6 @@ static inline unsigned int blk_queue_depth(struct request_queue *q)
 	return q->nr_requests;
 }
 
-extern unsigned long blk_max_low_pfn, blk_max_pfn;
-
-/*
- * standard bounce addresses:
- *
- * BLK_BOUNCE_HIGH	: bounce all highmem pages
- * BLK_BOUNCE_ANY	: don't bounce anything
- */
-
-#if BITS_PER_LONG == 32
-#define BLK_BOUNCE_HIGH		((u64)blk_max_low_pfn << PAGE_SHIFT)
-#else
-#define BLK_BOUNCE_HIGH		-1ULL
-#endif
-#define BLK_BOUNCE_ANY		(-1ULL)
-
 /*
  * default timeout for SG_IO if none specified
  */
@@ -1134,7 +1127,7 @@ extern void blk_abort_request(struct request *);
  * Access functions for manipulating queue properties
  */
 extern void blk_cleanup_queue(struct request_queue *);
-extern void blk_queue_bounce_limit(struct request_queue *, u64);
+void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce limit);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_segments(struct request_queue *, unsigned short);
-- 
2.30.1

