Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42ACFC2BA19
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 229CD2072D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:43:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aah8AlFD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406866AbgDNHnP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 03:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406802AbgDNHmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 03:42:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42536C0A3BE2;
        Tue, 14 Apr 2020 00:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=NAIt5oTU1BTGIn6G50o3gY9uHzLMJtJBa12r7DtM3UI=; b=aah8AlFDeQ2I5GtgiyQIPyzdbJ
        F2daZihSc+Z6UypPCUCwGv1BUh3YPZFsZl3CkxPd9zaDUGgAf51462yRBtlXgL6indxaCCuTYvmV7
        sDSjk3GptQv0AEn645tLZd/iOEErRckzWdwTWKEJP0ZclyaqJtagrXcf0p0h7NZvNOX7pChgQV74v
        /QlCBEgfVAhBDXYWkUrtqPjEm21FBA+6NFAx7Y1MrWOtA21m37v3Es/6IixeeY3w/hnJh4Ndz0xJZ
        rLcVXrAb/S1AxbNjhOX8kliok3PKQl4e50IwgmcPEKaAeHe3N4LHcpQZw9YvazvAJGVqIM8CzF2dA
        jdPXoSbg==;
Received: from [2001:4bb8:180:384b:4c21:af7:dd95:e552] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jOGDG-00076C-Mo; Tue, 14 Apr 2020 07:42:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/5] block: remove RQF_COPY_USER
Date:   Tue, 14 Apr 2020 09:42:21 +0200
Message-Id: <20200414074225.332324-2-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414074225.332324-1-hch@lst.de>
References: <20200414074225.332324-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The RQF_COPY_USER is set for bio where the passthrough request mapping
helpers decided that bounce buffering is required.  It is then used to
pad scatterlist for drivers that required it.  But given that
non-passthrough requests are per definition aligned, and directly mapped
pass-through request must be aligned it is not actually required at all.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-map.c        | 9 +--------
 block/blk-merge.c      | 3 +--
 block/blk-mq-debugfs.c | 1 -
 include/linux/blkdev.h | 2 --
 4 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index b72c361911a4..b6fa343fea9f 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -654,8 +654,6 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			bio = rq->bio;
 	} while (iov_iter_count(&i));
 
-	if (!bio_flagged(bio, BIO_USER_MAPPED))
-		rq->rq_flags |= RQF_COPY_USER;
 	return 0;
 
 unmap_rq:
@@ -731,7 +729,6 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 {
 	int reading = rq_data_dir(rq) == READ;
 	unsigned long addr = (unsigned long) kbuf;
-	int do_copy = 0;
 	struct bio *bio, *orig_bio;
 	int ret;
 
@@ -740,8 +737,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	if (!len || !kbuf)
 		return -EINVAL;
 
-	do_copy = !blk_rq_aligned(q, addr, len) || object_is_on_stack(kbuf);
-	if (do_copy)
+	if (!blk_rq_aligned(q, addr, len) || object_is_on_stack(kbuf))
 		bio = bio_copy_kern(q, kbuf, len, gfp_mask, reading);
 	else
 		bio = bio_map_kern(q, kbuf, len, gfp_mask);
@@ -752,9 +748,6 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	bio->bi_opf &= ~REQ_OP_MASK;
 	bio->bi_opf |= req_op(rq);
 
-	if (do_copy)
-		rq->rq_flags |= RQF_COPY_USER;
-
 	orig_bio = bio;
 	ret = blk_rq_append_bio(rq, &bio);
 	if (unlikely(ret)) {
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 1534ed736363..99c9759f3a8a 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -532,8 +532,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	else if (rq->bio)
 		nsegs = __blk_bios_map_sg(q, rq->bio, sglist, &sg);
 
-	if (unlikely(rq->rq_flags & RQF_COPY_USER) &&
-	    (blk_rq_bytes(rq) & q->dma_pad_mask)) {
+	if (blk_rq_bytes(rq) && (blk_rq_bytes(rq) & q->dma_pad_mask)) {
 		unsigned int pad_len =
 			(q->dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
 
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index b3f2ba483992..96b7a35c898a 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -292,7 +292,6 @@ static const char *const rqf_name[] = {
 	RQF_NAME(MQ_INFLIGHT),
 	RQF_NAME(DONTPREP),
 	RQF_NAME(PREEMPT),
-	RQF_NAME(COPY_USER),
 	RQF_NAME(FAILED),
 	RQF_NAME(QUIET),
 	RQF_NAME(ELVPRIV),
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 32868fbedc9e..76da162b6ae9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -82,8 +82,6 @@ typedef __u32 __bitwise req_flags_t;
 /* set for "ide_preempt" requests and also for requests for which the SCSI
    "quiesce" state must be ignored. */
 #define RQF_PREEMPT		((__force req_flags_t)(1 << 8))
-/* contains copies of user pages */
-#define RQF_COPY_USER		((__force req_flags_t)(1 << 9))
 /* vaguely specified driver internal error.  Ignored by the block layer */
 #define RQF_FAILED		((__force req_flags_t)(1 << 10))
 /* don't warn about errors */
-- 
2.25.1

