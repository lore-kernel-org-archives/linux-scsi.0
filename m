Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EFBC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6229660FD7
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhJYHIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhJYHID (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 03:08:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7DDC061764;
        Mon, 25 Oct 2021 00:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VwIAXfg3Pd/+emRDddHmnlUH4lzqOjvNN9CpS0qtZKY=; b=C/7Vfaty1LCuSfdkhQm7aJHjtg
        CCMq6pRLNRBXeQaYpDOUBb2jdSo7fxiRduZfGpIL2F5/sUlOQu7Op8CD1n0KEj/AOiJvQ8jcA7cU8
        UTimfY5dUV4vhDkn3408DtGPnk4q0Y4dzqldibKqe1RcJMs76WWOgIVJf10fYCrR3TNlHtoLZpUVo
        QRz59/An/eVBjsXFP7eD/aF1Kd8/Z+u9nL3oAs6Uyplofj/2/bkd9d1kaUpGjwPTMe8m3C2ou8/D4
        H34U/CWl9vsNZuksnV+rAloY9Ebfe72A13EqLAag6bgapQn2sQUDOtmB6d9fc/mthnxebX35HliyD
        stw+MNYQ==;
Received: from [2001:4bb8:184:6dcb:6093:467a:cccc:351c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meu37-00FUUT-EG; Mon, 25 Oct 2021 07:05:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 07/12] block: move blk_rq_init to blk-mq.c
Date:   Mon, 25 Oct 2021 09:05:12 +0200
Message-Id: <20211025070517.1548584-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025070517.1548584-1-hch@lst.de>
References: <20211025070517.1548584-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_rq_init deals with a request structure, so move it to blk-mq.c

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 17 -----------------
 block/blk-mq.c   | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 8ae6ba9ec1050..1ee942266df8d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -109,23 +109,6 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_queue_flag_test_and_set);
 
-void blk_rq_init(struct request_queue *q, struct request *rq)
-{
-	memset(rq, 0, sizeof(*rq));
-
-	INIT_LIST_HEAD(&rq->queuelist);
-	rq->q = q;
-	rq->__sector = (sector_t) -1;
-	INIT_HLIST_NODE(&rq->hash);
-	RB_CLEAR_NODE(&rq->rb_node);
-	rq->tag = BLK_MQ_NO_TAG;
-	rq->internal_tag = BLK_MQ_NO_TAG;
-	rq->start_time_ns = ktime_get_ns();
-	rq->part = NULL;
-	blk_crypto_rq_set_defaults(rq);
-}
-EXPORT_SYMBOL(blk_rq_init);
-
 #define REQ_OP_NAME(name) [REQ_OP_##name] = #name
 static const char *const blk_op_name[] = {
 	REQ_OP_NAME(READ),
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 923231023fe84..a0505099b2ce2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -316,6 +316,23 @@ void blk_mq_wake_waiters(struct request_queue *q)
 			blk_mq_tag_wakeup_all(hctx->tags, true);
 }
 
+void blk_rq_init(struct request_queue *q, struct request *rq)
+{
+	memset(rq, 0, sizeof(*rq));
+
+	INIT_LIST_HEAD(&rq->queuelist);
+	rq->q = q;
+	rq->__sector = (sector_t) -1;
+	INIT_HLIST_NODE(&rq->hash);
+	RB_CLEAR_NODE(&rq->rb_node);
+	rq->tag = BLK_MQ_NO_TAG;
+	rq->internal_tag = BLK_MQ_NO_TAG;
+	rq->start_time_ns = ktime_get_ns();
+	rq->part = NULL;
+	blk_crypto_rq_set_defaults(rq);
+}
+EXPORT_SYMBOL(blk_rq_init);
+
 static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 		unsigned int tag, u64 alloc_time_ns)
 {
-- 
2.30.2

