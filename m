Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015E2C2BA19
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC855206B6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 07:42:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nD1jFWNX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406819AbgDNHmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 03:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406809AbgDNHmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2020 03:42:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BD2C008748;
        Tue, 14 Apr 2020 00:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Ual/dMzALNy8sA75wgtQ+6CUGk8C9/Ruhu//u9rXiYs=; b=nD1jFWNXBCPAHbKCVLUh/4zZP6
        aMmoAa2p2OsI8xgMcnB2Cn2pKZLtc9sWDwBKzIOUkA23FTslj2T/Be9JdJ4HQVKaEyXHHQMuW+sfu
        jn6zfc5VOaCWrYlqGOs25hrYbadm7LCeLtoppuaGtok7dBPU2ONjPtVyzQQ9wf4TGJHdhA/9vW2UH
        3mLC9RoxUAmaa7Wl/cGJ3jRcIBTrEgaioW3BYA3yXv+djI+7ET76a/vdqROV+H0pVYi8BtA03QTja
        t8b2rWol0S9WjASVxYfn4Xp9JPF6Qg6Lmv60JIRaPq3EqVTeORW/hap4olwjWqc3pzDjOmLNF2ghk
        oy8BDYBA==;
Received: from [2001:4bb8:180:384b:4c21:af7:dd95:e552] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jOGDJ-00078L-FJ; Tue, 14 Apr 2020 07:42:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/5] block: provide a blk_rq_map_sg variant that returns the last element
Date:   Tue, 14 Apr 2020 09:42:22 +0200
Message-Id: <20200414074225.332324-3-hch@lst.de>
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

To be able to move some of the special purpose hacks in blk_rq_map_sg
into the callers we need a variant that returns the last mapped
S/G list element to the caller.  Add that variant as __blk_rq_map_sg
and make blk_rq_map_sg a trivial inline wrapper around it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c      | 25 ++++++++++++-------------
 include/linux/blkdev.h | 10 +++++++++-
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 99c9759f3a8a..ee618cdb141e 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -519,24 +519,23 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
  * map a request to scatterlist, return number of sg entries setup. Caller
  * must make sure sg can hold rq->nr_phys_segments entries
  */
-int blk_rq_map_sg(struct request_queue *q, struct request *rq,
-		  struct scatterlist *sglist)
+int __blk_rq_map_sg(struct request_queue *q, struct request *rq,
+		struct scatterlist *sglist, struct scatterlist **last_sg)
 {
-	struct scatterlist *sg = NULL;
 	int nsegs = 0;
 
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
-		nsegs = __blk_bvec_map_sg(rq->special_vec, sglist, &sg);
+		nsegs = __blk_bvec_map_sg(rq->special_vec, sglist, last_sg);
 	else if (rq->bio && bio_op(rq->bio) == REQ_OP_WRITE_SAME)
-		nsegs = __blk_bvec_map_sg(bio_iovec(rq->bio), sglist, &sg);
+		nsegs = __blk_bvec_map_sg(bio_iovec(rq->bio), sglist, last_sg);
 	else if (rq->bio)
-		nsegs = __blk_bios_map_sg(q, rq->bio, sglist, &sg);
+		nsegs = __blk_bios_map_sg(q, rq->bio, sglist, last_sg);
 
 	if (blk_rq_bytes(rq) && (blk_rq_bytes(rq) & q->dma_pad_mask)) {
 		unsigned int pad_len =
 			(q->dma_pad_mask & ~blk_rq_bytes(rq)) + 1;
 
-		sg->length += pad_len;
+		(*last_sg)->length += pad_len;
 		rq->extra_len += pad_len;
 	}
 
@@ -544,9 +543,9 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		if (op_is_write(req_op(rq)))
 			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
 
-		sg_unmark_end(sg);
-		sg = sg_next(sg);
-		sg_set_page(sg, virt_to_page(q->dma_drain_buffer),
+		sg_unmark_end(*last_sg);
+		*last_sg = sg_next(*last_sg);
+		sg_set_page(*last_sg, virt_to_page(q->dma_drain_buffer),
 			    q->dma_drain_size,
 			    ((unsigned long)q->dma_drain_buffer) &
 			    (PAGE_SIZE - 1));
@@ -554,8 +553,8 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		rq->extra_len += q->dma_drain_size;
 	}
 
-	if (sg)
-		sg_mark_end(sg);
+	if (*last_sg)
+		sg_mark_end(*last_sg);
 
 	/*
 	 * Something must have been wrong if the figured number of
@@ -565,7 +564,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 
 	return nsegs;
 }
-EXPORT_SYMBOL(blk_rq_map_sg);
+EXPORT_SYMBOL(__blk_rq_map_sg);
 
 static inline int ll_new_hw_segment(struct request *req, struct bio *bio,
 		unsigned int nr_phys_segs)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 76da162b6ae9..496dc9491026 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1136,7 +1136,15 @@ static inline unsigned short blk_rq_nr_discard_segments(struct request *rq)
 	return max_t(unsigned short, rq->nr_phys_segments, 1);
 }
 
-extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+int __blk_rq_map_sg(struct request_queue *q, struct request *rq,
+		struct scatterlist *sglist, struct scatterlist **last_sg);
+static inline int blk_rq_map_sg(struct request_queue *q, struct request *rq,
+		struct scatterlist *sglist)
+{
+	struct scatterlist *last_sg = NULL;
+
+	return __blk_rq_map_sg(q, rq, sglist, &last_sg);
+}
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
-- 
2.25.1

