Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD45C43219
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB96B61B2B
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhKQGRU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhKQGRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB0BC061766;
        Tue, 16 Nov 2021 22:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=sj4m7qIW4XnTc8yJ1sHaocTSvUI4MlzH3MUnD0CWBjQ=; b=oAcoHClEmyaFmZ64D1tZFg74Ug
        CGkqUPJk7YrjmFkgBcKkNTWXzuiNAGEIXaf5FQo65kLfXAeDZxVkbI7OQYxvb9fLrcNpfq1lbACOX
        xV/b+QdnQH7Bjyn3bqFD++QoqauB9/tD33xRPD2YlINHtRDnY6IkWE1V0ouA1OkxijsogSZ+a87BA
        s9GQqSW6kvGiH9odK5Bji4wfwB/R2pJqq9NeNUE2qNorMoroXfgjByPLXdh93cwphbF+rH9lAvVs6
        aMIgC9bjYKVW18RefONMvFAK83nbg8Rox4AV+FzUI8JVPSxZml50tJboIGkIUcwR4SkPvMV3rtKHW
        VYmFdqrw==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnED1-007MFn-7c; Wed, 17 Nov 2021 06:14:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 06/11] block: move blk_rq_init to blk-mq.c
Date:   Wed, 17 Nov 2021 07:13:59 +0100
Message-Id: <20211117061404.331732-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
index e1c928ec92946..a3384c85074e3 100644
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
index 0362ec9ad4d14..8d0d18ef07d09 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -328,6 +328,23 @@ void blk_mq_wake_waiters(struct request_queue *q)
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
 		struct blk_mq_tags *tags, unsigned int tag, u64 alloc_time_ns)
 {
-- 
2.30.2

