Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CE6C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62BDF61A49
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhCZF7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 01:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhCZF6y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 01:58:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BB3C0613B2;
        Thu, 25 Mar 2021 22:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=NDqQp4Ftyr52dj9n4LUT/2BI4UdUYiCwlr8CIqOc3AU=; b=dVzFtYGR3PFE+uysVOCSoAhTpO
        DkDJREruF+EAXoiq3iLSeM/vEGvejyvUT2c+4ogFeDTZwz0BjZllVigZeFv7e00ToIDi3vvkt3xPP
        +THEBDQ8r4MzG/QbqWy/Rc0LUI3H0r8KfrRnvU2AVwHW0QDJKxX+Xvjh/ETHeS7CEeyjWEZxu6Meo
        EKB9h2/9AVR2Vd2oLcMQa/W4dXwABvoSmrLEY6hyXRdbnJ4o1Mjp+s0YZSZ45WEwfybmWgz8jBTiJ
        VjfUQXwcgnQQlMkS6FLqJ35l3LgldG/PUqkzrqGpYl2SS+hOmHqkgDqZYqRsbDUyJvTVvtgT8kai3
        CCKY04Yg==;
Received: from [2001:4bb8:191:f692:97ff:1e47:aee2:c7e5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfUV-005AOr-Fe; Fri, 26 Mar 2021 05:58:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 6/8] block: remove BLK_BOUNCE_ISA support
Date:   Fri, 26 Mar 2021 06:58:20 +0100
Message-Id: <20210326055822.1437471-7-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210326055822.1437471-1-hch@lst.de>
References: <20210326055822.1437471-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the BLK_BOUNCE_ISA support now that all users are gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c     |   3 +-
 block/blk-map.c           |   4 +-
 block/blk-settings.c      |  11 ----
 block/blk.h               |   5 --
 block/bounce.c            | 124 ++++++++------------------------------
 block/scsi_ioctl.c        |   2 +-
 drivers/ata/libata-scsi.c |   3 +-
 include/linux/blkdev.h    |   7 ---
 mm/Kconfig                |   9 ++-
 9 files changed, 35 insertions(+), 133 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index dfa652122a2dc8..4b4eb8964a6f98 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -204,7 +204,6 @@ bool bio_integrity_prep(struct bio *bio)
 {
 	struct bio_integrity_payload *bip;
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
-	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
 	void *buf;
 	unsigned long start, end;
 	unsigned int len, nr_pages;
@@ -238,7 +237,7 @@ bool bio_integrity_prep(struct bio *bio)
 
 	/* Allocate kernel buffer for protection data */
 	len = intervals * bi->tuple_size;
-	buf = kmalloc(len, GFP_NOIO | q->bounce_gfp);
+	buf = kmalloc(len, GFP_NOIO);
 	status = BLK_STS_RESOURCE;
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");
diff --git a/block/blk-map.c b/block/blk-map.c
index 1ffef782fcf2dd..b62b52dcb61d97 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -181,7 +181,7 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 
 			i++;
 		} else {
-			page = alloc_page(rq->q->bounce_gfp | gfp_mask);
+			page = alloc_page(GFP_NOIO | gfp_mask);
 			if (!page) {
 				ret = -ENOMEM;
 				goto cleanup;
@@ -486,7 +486,7 @@ static struct bio *bio_copy_kern(struct request_queue *q, void *data,
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | gfp_mask);
+		page = alloc_page(GFP_NOIO | gfp_mask);
 		if (!page)
 			goto cleanup;
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index b4aa2f37fab6f5..f9937dd2810e25 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -103,28 +103,17 @@ EXPORT_SYMBOL(blk_set_stacking_limits);
 void blk_queue_bounce_limit(struct request_queue *q, u64 max_addr)
 {
 	unsigned long b_pfn = max_addr >> PAGE_SHIFT;
-	int dma = 0;
 
-	q->bounce_gfp = GFP_NOIO;
 #if BITS_PER_LONG == 64
 	/*
 	 * Assume anything <= 4GB can be handled by IOMMU.  Actually
 	 * some IOMMUs can handle everything, but I don't know of a
 	 * way to test this here.
 	 */
-	if (b_pfn < (min_t(u64, 0xffffffffUL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
-		dma = 1;
 	q->limits.bounce_pfn = max(max_low_pfn, b_pfn);
 #else
-	if (b_pfn < blk_max_low_pfn)
-		dma = 1;
 	q->limits.bounce_pfn = b_pfn;
 #endif
-	if (dma) {
-		init_emergency_isa_pool();
-		q->bounce_gfp = GFP_NOIO | GFP_DMA;
-		q->limits.bounce_pfn = b_pfn;
-	}
 }
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
diff --git a/block/blk.h b/block/blk.h
index 3b53e44b967e4e..895c9f4a5182a7 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -312,13 +312,8 @@ static inline void blk_throtl_stat_add(struct request *rq, u64 time) { }
 #endif
 
 #ifdef CONFIG_BOUNCE
-extern int init_emergency_isa_pool(void);
 extern void blk_queue_bounce(struct request_queue *q, struct bio **bio);
 #else
-static inline int init_emergency_isa_pool(void)
-{
-	return 0;
-}
 static inline void blk_queue_bounce(struct request_queue *q, struct bio **bio)
 {
 }
diff --git a/block/bounce.c b/block/bounce.c
index 6c441f4f1cd4aa..debd5b0bd31890 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -29,7 +29,7 @@
 #define ISA_POOL_SIZE	16
 
 static struct bio_set bounce_bio_set, bounce_bio_split;
-static mempool_t page_pool, isa_page_pool;
+static mempool_t page_pool;
 
 static void init_bounce_bioset(void)
 {
@@ -89,41 +89,6 @@ static void bounce_copy_vec(struct bio_vec *to, unsigned char *vfrom)
 
 #endif /* CONFIG_HIGHMEM */
 
-/*
- * allocate pages in the DMA region for the ISA pool
- */
-static void *mempool_alloc_pages_isa(gfp_t gfp_mask, void *data)
-{
-	return mempool_alloc_pages(gfp_mask | GFP_DMA, data);
-}
-
-static DEFINE_MUTEX(isa_mutex);
-
-/*
- * gets called "every" time someone init's a queue with BLK_BOUNCE_ISA
- * as the max address, so check if the pool has already been created.
- */
-int init_emergency_isa_pool(void)
-{
-	int ret;
-
-	mutex_lock(&isa_mutex);
-
-	if (mempool_initialized(&isa_page_pool)) {
-		mutex_unlock(&isa_mutex);
-		return 0;
-	}
-
-	ret = mempool_init(&isa_page_pool, ISA_POOL_SIZE, mempool_alloc_pages_isa,
-			   mempool_free_pages, (void *) 0);
-	BUG_ON(ret);
-
-	pr_info("isa pool size: %d pages\n", ISA_POOL_SIZE);
-	init_bounce_bioset();
-	mutex_unlock(&isa_mutex);
-	return 0;
-}
-
 /*
  * Simple bounce buffer support for highmem pages. Depending on the
  * queue gfp mask set, *to may or may not be a highmem page. kmap it
@@ -159,7 +124,7 @@ static void copy_to_high_bio_irq(struct bio *to, struct bio *from)
 	}
 }
 
-static void bounce_end_io(struct bio *bio, mempool_t *pool)
+static void bounce_end_io(struct bio *bio)
 {
 	struct bio *bio_orig = bio->bi_private;
 	struct bio_vec *bvec, orig_vec;
@@ -173,7 +138,7 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool)
 		orig_vec = bio_iter_iovec(bio_orig, orig_iter);
 		if (bvec->bv_page != orig_vec.bv_page) {
 			dec_zone_page_state(bvec->bv_page, NR_BOUNCE);
-			mempool_free(bvec->bv_page, pool);
+			mempool_free(bvec->bv_page, &page_pool);
 		}
 		bio_advance_iter(bio_orig, &orig_iter, orig_vec.bv_len);
 	}
@@ -185,33 +150,17 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool)
 
 static void bounce_end_io_write(struct bio *bio)
 {
-	bounce_end_io(bio, &page_pool);
-}
-
-static void bounce_end_io_write_isa(struct bio *bio)
-{
-
-	bounce_end_io(bio, &isa_page_pool);
+	bounce_end_io(bio);
 }
 
-static void __bounce_end_io_read(struct bio *bio, mempool_t *pool)
+static void bounce_end_io_read(struct bio *bio)
 {
 	struct bio *bio_orig = bio->bi_private;
 
 	if (!bio->bi_status)
 		copy_to_high_bio_irq(bio_orig, bio);
 
-	bounce_end_io(bio, pool);
-}
-
-static void bounce_end_io_read(struct bio *bio)
-{
-	__bounce_end_io_read(bio, &page_pool);
-}
-
-static void bounce_end_io_read_isa(struct bio *bio)
-{
-	__bounce_end_io_read(bio, &isa_page_pool);
+	bounce_end_io(bio);
 }
 
 static struct bio *bounce_clone_bio(struct bio *bio_src)
@@ -287,8 +236,8 @@ static struct bio *bounce_clone_bio(struct bio *bio_src)
 	return NULL;
 }
 
-static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
-			       mempool_t *pool)
+
+void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 {
 	struct bio *bio;
 	int rw = bio_data_dir(*bio_orig);
@@ -298,6 +247,20 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 	bool bounce = false;
 	int sectors = 0;
 
+	/*
+	 * Data-less bio, nothing to bounce
+	 */
+	if (!bio_has_data(*bio_orig))
+		return;
+
+	/*
+	 * Just check if the bounce pfn is equal to or bigger than the highest
+	 * pfn in the system -- in that case, don't waste time iterating over
+	 * bio segments
+	 */
+	if (q->limits.bounce_pfn >= blk_max_pfn)
+		return;
+
 	bio_for_each_segment(from, *bio_orig, iter) {
 		if (i++ < BIO_MAX_VECS)
 			sectors += from.bv_len >> 9;
@@ -327,7 +290,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 		if (page_to_pfn(page) <= q->limits.bounce_pfn)
 			continue;
 
-		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
+		to->bv_page = mempool_alloc(&page_pool, GFP_NOIO);
 		inc_zone_page_state(to->bv_page, NR_BOUNCE);
 
 		if (rw == WRITE) {
@@ -346,46 +309,11 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 
 	bio->bi_flags |= (1 << BIO_BOUNCED);
 
-	if (pool == &page_pool) {
+	if (rw == READ)
+		bio->bi_end_io = bounce_end_io_read;
+	else
 		bio->bi_end_io = bounce_end_io_write;
-		if (rw == READ)
-			bio->bi_end_io = bounce_end_io_read;
-	} else {
-		bio->bi_end_io = bounce_end_io_write_isa;
-		if (rw == READ)
-			bio->bi_end_io = bounce_end_io_read_isa;
-	}
 
 	bio->bi_private = *bio_orig;
 	*bio_orig = bio;
 }
-
-void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
-{
-	mempool_t *pool;
-
-	/*
-	 * Data-less bio, nothing to bounce
-	 */
-	if (!bio_has_data(*bio_orig))
-		return;
-
-	/*
-	 * for non-isa bounce case, just check if the bounce pfn is equal
-	 * to or bigger than the highest pfn in the system -- in that case,
-	 * don't waste time iterating over bio segments
-	 */
-	if (!(q->bounce_gfp & GFP_DMA)) {
-		if (q->limits.bounce_pfn >= blk_max_pfn)
-			return;
-		pool = &page_pool;
-	} else {
-		BUG_ON(!mempool_initialized(&isa_page_pool));
-		pool = &isa_page_pool;
-	}
-
-	/*
-	 * slow path
-	 */
-	__blk_queue_bounce(q, bio_orig, pool);
-}
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 6599bac0a78cb0..1048b09255678c 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -431,7 +431,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 
 	bytes = max(in_len, out_len);
 	if (bytes) {
-		buffer = kzalloc(bytes, q->bounce_gfp | GFP_USER| __GFP_NOWARN);
+		buffer = kzalloc(bytes, GFP_NOIO | GFP_USER | __GFP_NOWARN);
 		if (!buffer)
 			return -ENOMEM;
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 48b8934970f36a..fd8b6febbf70c4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1043,8 +1043,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 		blk_queue_max_segments(q, queue_max_segments(q) - 1);
 
 		sdev->dma_drain_len = ATAPI_MAX_DRAIN;
-		sdev->dma_drain_buf = kmalloc(sdev->dma_drain_len,
-				q->bounce_gfp | GFP_KERNEL);
+		sdev->dma_drain_buf = kmalloc(sdev->dma_drain_len, GFP_NOIO);
 		if (!sdev->dma_drain_buf) {
 			ata_dev_err(dev, "drain buffer allocation failed\n");
 			return -ENOMEM;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bc6bc8383b434e..0dbb72ea373529 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -436,11 +436,6 @@ struct request_queue {
 	 */
 	int			id;
 
-	/*
-	 * queue needs bounce pages for pages above this limit
-	 */
-	gfp_t			bounce_gfp;
-
 	spinlock_t		queue_lock;
 
 	/*
@@ -847,7 +842,6 @@ extern unsigned long blk_max_low_pfn, blk_max_pfn;
  *
  * BLK_BOUNCE_HIGH	: bounce all highmem pages
  * BLK_BOUNCE_ANY	: don't bounce anything
- * BLK_BOUNCE_ISA	: bounce pages above ISA DMA boundary
  */
 
 #if BITS_PER_LONG == 32
@@ -856,7 +850,6 @@ extern unsigned long blk_max_low_pfn, blk_max_pfn;
 #define BLK_BOUNCE_HIGH		-1ULL
 #endif
 #define BLK_BOUNCE_ANY		(-1ULL)
-#define BLK_BOUNCE_ISA		(DMA_BIT_MASK(24))
 
 /*
  * default timeout for SG_IO if none specified
diff --git a/mm/Kconfig b/mm/Kconfig
index 24c045b24b9506..d0808a23e54bc8 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -283,12 +283,11 @@ config PHYS_ADDR_T_64BIT
 config BOUNCE
 	bool "Enable bounce buffers"
 	default y
-	depends on BLOCK && MMU && (ZONE_DMA || HIGHMEM)
+	depends on BLOCK && MMU && HIGHMEM
 	help
-	  Enable bounce buffers for devices that cannot access
-	  the full range of memory available to the CPU. Enabled
-	  by default when ZONE_DMA or HIGHMEM is selected, but you
-	  may say n to override this.
+	  Enable bounce buffers for devices that cannot access the full range of
+	  memory available to the CPU. Enabled by default when HIGHMEM is
+	  selected, but you may say n to override this.
 
 config VIRT_TO_BUS
 	bool
-- 
2.30.1

