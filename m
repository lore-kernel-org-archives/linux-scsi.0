Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E905C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 06:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 296A864F04
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 06:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhCRGmL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 02:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhCRGl7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 02:41:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CB1C06174A;
        Wed, 17 Mar 2021 23:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=H4Dtrbj4H6gmQ0NyhNB1Ua+zBbZw+6zj61B3DLC3WTA=; b=kZyAMMB3tMgUnjJ8FejxWgD3UG
        g+/gA9pEaeb/qNleC7F3ezHtVq0z/tV2zh1OUJEBk+UUz2TpaDkrF/pOWnr4ol31TiBkJa74kWZbj
        AD6Xzg8hV9GvYE7cUgLfzl9eTfY0Kkhm4z9CqB3y776/nT5kLrGMPjFxEMP/CdOfToIB58t5Zi5Bi
        NObULf5PzjwmhOEC016BqgKFkLJS444vmVM8oJt2nj4d00WVE/NsaNnMZfB91dTeCRdVckfCLgReW
        o5KS9Tta2PsiBK8Z+IghGs1/2eUwiHVC5exZ7vcwZd3I0I0HeMLdWiwZ+JG3plzAafLf8IK6wSEUO
        zeEhLtVg==;
Received: from [2001:4bb8:18c:bb3:e1cf:ad2f:7ff7:7a0b] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMmLO-002f5H-Hf; Thu, 18 Mar 2021 06:41:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 8/8] block: stop calling blk_queue_bounce for passthrough requests
Date:   Thu, 18 Mar 2021 07:39:23 +0100
Message-Id: <20210318063923.302738-9-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210318063923.302738-1-hch@lst.de>
References: <20210318063923.302738-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of overloading the passthrough fast path with the deprecated
block layer bounce buffering let the users that combine an old
undermaintained driver with a highmem system pay the price by always
falling back to copies in that case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c                    | 116 ++++++++---------------------
 block/bounce.c                     |  11 +--
 drivers/nvme/host/lightnvm.c       |   2 +-
 drivers/target/target_core_pscsi.c |   4 +-
 include/linux/blkdev.h             |   2 +-
 5 files changed, 36 insertions(+), 99 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index b62b52dcb61d97..dac78376acc899 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -123,7 +123,6 @@ static int bio_uncopy_user(struct bio *bio)
 			bio_free_pages(bio);
 	}
 	kfree(bmd);
-	bio_put(bio);
 	return ret;
 }
 
@@ -132,7 +131,7 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 {
 	struct bio_map_data *bmd;
 	struct page *page;
-	struct bio *bio, *bounce_bio;
+	struct bio *bio;
 	int i = 0, ret;
 	int nr_pages;
 	unsigned int len = iter->count;
@@ -218,16 +217,9 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 
 	bio->bi_private = bmd;
 
-	bounce_bio = bio;
-	ret = blk_rq_append_bio(rq, &bounce_bio);
+	ret = blk_rq_append_bio(rq, bio);
 	if (ret)
 		goto cleanup;
-
-	/*
-	 * We link the bounce buffer in and could have to traverse it later, so
-	 * we have to get a ref to prevent it from being freed
-	 */
-	bio_get(bounce_bio);
 	return 0;
 cleanup:
 	if (!map_data)
@@ -242,7 +234,7 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 		gfp_t gfp_mask)
 {
 	unsigned int max_sectors = queue_max_hw_sectors(rq->q);
-	struct bio *bio, *bounce_bio;
+	struct bio *bio;
 	int ret;
 	int j;
 
@@ -304,49 +296,17 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 			break;
 	}
 
-	/*
-	 * Subtle: if we end up needing to bounce a bio, it would normally
-	 * disappear when its bi_end_io is run.  However, we need the original
-	 * bio for the unmap, so grab an extra reference to it
-	 */
-	bio_get(bio);
-
-	bounce_bio = bio;
-	ret = blk_rq_append_bio(rq, &bounce_bio);
+	ret = blk_rq_append_bio(rq, bio);
 	if (ret)
-		goto out_put_orig;
-
-	/*
-	 * We link the bounce buffer in and could have to traverse it
-	 * later, so we have to get a ref to prevent it from being freed
-	 */
-	bio_get(bounce_bio);
+		goto out_unmap;
 	return 0;
 
- out_put_orig:
-	bio_put(bio);
  out_unmap:
 	bio_release_pages(bio, false);
 	bio_put(bio);
 	return ret;
 }
 
-/**
- *	bio_unmap_user	-	unmap a bio
- *	@bio:		the bio being unmapped
- *
- *	Unmap a bio previously mapped by bio_map_user_iov(). Must be called from
- *	process context.
- *
- *	bio_unmap_user() may sleep.
- */
-static void bio_unmap_user(struct bio *bio)
-{
-	bio_release_pages(bio, bio_data_dir(bio) == READ);
-	bio_put(bio);
-	bio_put(bio);
-}
-
 static void bio_invalidate_vmalloc_pages(struct bio *bio)
 {
 #ifdef ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
@@ -519,33 +479,27 @@ static struct bio *bio_copy_kern(struct request_queue *q, void *data,
  * Append a bio to a passthrough request.  Only works if the bio can be merged
  * into the request based on the driver constraints.
  */
-int blk_rq_append_bio(struct request *rq, struct bio **bio)
+int blk_rq_append_bio(struct request *rq, struct bio *bio)
 {
-	struct bio *orig_bio = *bio;
 	struct bvec_iter iter;
 	struct bio_vec bv;
 	unsigned int nr_segs = 0;
 
-	blk_queue_bounce(rq->q, bio);
+	if (WARN_ON_ONCE(rq->q->limits.bounce != BLK_BOUNCE_NONE))
+		return -EINVAL;
 
-	bio_for_each_bvec(bv, *bio, iter)
+	bio_for_each_bvec(bv, bio, iter)
 		nr_segs++;
 
 	if (!rq->bio) {
-		blk_rq_bio_prep(rq, *bio, nr_segs);
+		blk_rq_bio_prep(rq, bio, nr_segs);
 	} else {
-		if (!ll_back_merge_fn(rq, *bio, nr_segs)) {
-			if (orig_bio != *bio) {
-				bio_put(*bio);
-				*bio = orig_bio;
-			}
+		if (!ll_back_merge_fn(rq, bio, nr_segs))
 			return -EINVAL;
-		}
-
-		rq->biotail->bi_next = *bio;
-		rq->biotail = *bio;
-		rq->__data_len += (*bio)->bi_iter.bi_size;
-		bio_crypt_free_ctx(*bio);
+		rq->biotail->bi_next = bio;
+		rq->biotail = bio;
+		rq->__data_len += (bio)->bi_iter.bi_size;
+		bio_crypt_free_ctx(bio);
 	}
 
 	return 0;
@@ -566,12 +520,6 @@ EXPORT_SYMBOL(blk_rq_append_bio);
  *
  *    A matching blk_rq_unmap_user() must be issued at the end of I/O, while
  *    still in process context.
- *
- *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
- *    before being submitted to the device, as pages mapped may be out of
- *    reach. It's the callers responsibility to make sure this happens. The
- *    original bio must be passed back in to blk_rq_unmap_user() for proper
- *    unmapping.
  */
 int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			struct rq_map_data *map_data,
@@ -588,6 +536,8 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 
 	if (map_data)
 		copy = true;
+	else if (blk_queue_may_bounce(q))
+		copy = true;
 	else if (iov_iter_alignment(iter) & align)
 		copy = true;
 	else if (queue_virt_boundary(q))
@@ -641,25 +591,21 @@ EXPORT_SYMBOL(blk_rq_map_user);
  */
 int blk_rq_unmap_user(struct bio *bio)
 {
-	struct bio *mapped_bio;
+	struct bio *next_bio;
 	int ret = 0, ret2;
 
 	while (bio) {
-		mapped_bio = bio;
-		if (unlikely(bio_flagged(bio, BIO_BOUNCED)))
-			mapped_bio = bio->bi_private;
-
 		if (bio->bi_private) {
-			ret2 = bio_uncopy_user(mapped_bio);
+			ret2 = bio_uncopy_user(bio);
 			if (ret2 && !ret)
 				ret = ret2;
 		} else {
-			bio_unmap_user(mapped_bio);
+			bio_release_pages(bio, bio_data_dir(bio) == READ);
 		}
 
-		mapped_bio = bio;
+		next_bio = bio;
 		bio = bio->bi_next;
-		bio_put(mapped_bio);
+		bio_put(next_bio);
 	}
 
 	return ret;
@@ -684,7 +630,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 {
 	int reading = rq_data_dir(rq) == READ;
 	unsigned long addr = (unsigned long) kbuf;
-	struct bio *bio, *orig_bio;
+	struct bio *bio;
 	int ret;
 
 	if (len > (queue_max_hw_sectors(q) << 9))
@@ -692,7 +638,8 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (!len || !kbuf)
 		return -EINVAL;
 
-	if (!blk_rq_aligned(q, addr, len) || object_is_on_stack(kbuf))
+	if (!blk_rq_aligned(q, addr, len) || object_is_on_stack(kbuf) ||
+	    blk_queue_may_bounce(q))
 		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
 	else
 		bio = bio_map_kern(q, kbuf, len, gfp_mask);
@@ -703,14 +650,9 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	bio->bi_opf &= ~REQ_OP_MASK;
 	bio->bi_opf |= req_op(rq);
 
-	orig_bio = bio;
-	ret = blk_rq_append_bio(rq, &bio);
-	if (unlikely(ret)) {
-		/* request is too big */
-		bio_put(orig_bio);
-		return ret;
-	}
-
-	return 0;
+	ret = blk_rq_append_bio(rq, bio);
+	if (unlikely(ret))
+		bio_put(bio);
+	return ret;
 }
 EXPORT_SYMBOL(blk_rq_map_kern);
diff --git a/block/bounce.c b/block/bounce.c
index 6bafc0d1f867a1..94081e013c58cc 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -180,12 +180,8 @@ static struct bio *bounce_clone_bio(struct bio *bio_src)
 	 *    asking for trouble and would force extra work on
 	 *    __bio_clone_fast() anyways.
 	 */
-	if (bio_is_passthrough(bio_src))
-		bio = bio_kmalloc(GFP_NOIO | __GFP_NOFAIL,
-				  bio_segments(bio_src));
-	else
-		bio = bio_alloc_bioset(GFP_NOIO, bio_segments(bio_src),
-				       &bounce_bio_set);
+	bio = bio_alloc_bioset(GFP_NOIO, bio_segments(bio_src),
+			       &bounce_bio_set);
 	bio->bi_bdev		= bio_src->bi_bdev;
 	if (bio_flagged(bio_src, BIO_REMAPPED))
 		bio_set_flag(bio, BIO_REMAPPED);
@@ -245,8 +241,7 @@ void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	if (!bounce)
 		return;
 
-	if (!bio_is_passthrough(*bio_orig) &&
-	    sectors < bio_sectors(*bio_orig)) {
+	if (sectors < bio_sectors(*bio_orig)) {
 		bio = bio_split(*bio_orig, sectors, GFP_NOIO, &bounce_bio_split);
 		bio_chain(bio, *bio_orig);
 		submit_bio_noacct(*bio_orig);
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index b705988629f224..f6ca2fbb711e98 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -660,7 +660,7 @@ static struct request *nvme_nvm_alloc_request(struct request_queue *q,
 	rq->cmd_flags &= ~REQ_FAILFAST_DRIVER;
 
 	if (rqd->bio)
-		blk_rq_append_bio(rq, &rqd->bio);
+		blk_rq_append_bio(rq, rqd->bio);
 	else
 		rq->ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_NORM);
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 3cbc074992bc86..7df4a9c9c7ffaa 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -911,7 +911,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					" %d i: %d bio: %p, allocating another"
 					" bio\n", bio->bi_vcnt, i, bio);
 
-				rc = blk_rq_append_bio(req, &bio);
+				rc = blk_rq_append_bio(req, bio);
 				if (rc) {
 					pr_err("pSCSI: failed to append bio\n");
 					goto fail;
@@ -930,7 +930,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 
 	if (bio) {
-		rc = blk_rq_append_bio(req, &bio);
+		rc = blk_rq_append_bio(req, bio);
 		if (rc) {
 			pr_err("pSCSI: failed to append bio\n");
 			goto fail;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 55cc8b96c84427..d5d320da51f8bf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -909,7 +909,7 @@ extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 extern void blk_rq_unprep_clone(struct request *rq);
 extern blk_status_t blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
-extern int blk_rq_append_bio(struct request *rq, struct bio **bio);
+int blk_rq_append_bio(struct request *rq, struct bio *bio);
 extern void blk_queue_split(struct bio **);
 extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
-- 
2.30.1

