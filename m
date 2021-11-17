Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1991AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A1B61C4F
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhKQGR1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbhKQGRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DA5C061570;
        Tue, 16 Nov 2021 22:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aN/HpC6wz8bll47+40mhrwWrH9ninZ18GAqRjH5cT1o=; b=azjkoGewnH7jnFCJwphvLSW1FO
        ngIJHBJG7GgBqo4ELYXpGO9Ym4Q+hXt33dE9kw+Rkz/WzOJ3NiZt4XWiH0QHNQrCALaa8eT6+AQ4B
        7xNPb4rU2GWPCYY2WwCtZUVfjlreUEgkDc2D9ZPxyNQGsXZD13+9BeHd0FtECT9bcBQB4q7hUxh0t
        oy54ffqzGvUWHrascqh9FxpVg3+wQRuxmuHMcb0/DSIFOWvMLV063uq7gOiSpjmQGqeV4vtjOmcoB
        lX/MvzWaswPcHI7i1YJJODMAtIxtpNKbr9uayMFSkmpIgO7l99teFTl6zc0fwHey9gWEoCQnJ4kc3
        muOoL59Q==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnED3-007MG1-0p; Wed, 17 Nov 2021 06:14:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 07/11] block: move blk_steal_bios to blk-mq.c
Date:   Wed, 17 Nov 2021 07:14:00 +0100
Message-Id: <20211117061404.331732-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Keep all the request based code together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 21 ---------------------
 block/blk-mq.c   | 21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a3384c85074e3..723a8c84aef12 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1164,27 +1164,6 @@ void disk_end_io_acct(struct gendisk *disk, unsigned int op,
 }
 EXPORT_SYMBOL(disk_end_io_acct);
 
-/*
- * Steal bios from a request and add them to a bio list.
- * The request must not have been partially completed before.
- */
-void blk_steal_bios(struct bio_list *list, struct request *rq)
-{
-	if (rq->bio) {
-		if (list->tail)
-			list->tail->bi_next = rq->bio;
-		else
-			list->head = rq->bio;
-		list->tail = rq->biotail;
-
-		rq->bio = NULL;
-		rq->biotail = NULL;
-	}
-
-	rq->__data_len = 0;
-}
-EXPORT_SYMBOL_GPL(blk_steal_bios);
-
 /**
  * blk_lld_busy - Check if underlying low-level drivers of a device are busy
  * @q : the queue of the device being checked
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8d0d18ef07d09..300fa393e6445 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3011,6 +3011,27 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 }
 EXPORT_SYMBOL_GPL(blk_rq_prep_clone);
 
+/*
+ * Steal bios from a request and add them to a bio list.
+ * The request must not have been partially completed before.
+ */
+void blk_steal_bios(struct bio_list *list, struct request *rq)
+{
+	if (rq->bio) {
+		if (list->tail)
+			list->tail->bi_next = rq->bio;
+		else
+			list->head = rq->bio;
+		list->tail = rq->biotail;
+
+		rq->bio = NULL;
+		rq->biotail = NULL;
+	}
+
+	rq->__data_len = 0;
+}
+EXPORT_SYMBOL_GPL(blk_steal_bios);
+
 static size_t order_to_size(unsigned int order)
 {
 	return (size_t)PAGE_SIZE << order;
-- 
2.30.2

