Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 857CEC43217
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70B1163231
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhKQGRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbhKQGRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C97BC0613B9;
        Tue, 16 Nov 2021 22:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=LjB+PW6droKOhO2mj2A/+eYS7xjIK3FEJ790igEy5r8=; b=AlqY5MsRheu/bSJmGs+30xVC25
        rAvzNtaIjwPTM0j5hsCxtXTsvzL7kjEIhKYivvjaMQp9uoaIrnnIrHMQDexNSkT0dSCIDpBd4Hr9M
        QoCvg8p6I7DuCpMq1rSiORlguB+rzdeS6OMMctRCr0TnOgNldxStgv/tRyJzeMLTcJDusBV7/sslb
        5c7/N2I/3d3Bh6kP3fpsWRa4AqtGIAwSIigY0qY9IXVO/BvBK3keqUhkCW2eIX9X4m60pvNVlwI9O
        3J1SHAdmh8xaF7LWVLe3cYMsLXMCD13WLSEANEb2tTqk9iry7rUQPTHhWFBpzU8qJkN00kKAq1A9X
        xzlgs5Gg==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnECu-007MER-Q0; Wed, 17 Nov 2021 06:14:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 02/11] block: remove rq_flush_dcache_pages
Date:   Wed, 17 Nov 2021 07:13:55 +0100
Message-Id: <20211117061404.331732-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This function is trivial, and flush_dcache_page is always defined, so
just open code it in the 2.5 callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c          | 19 -------------------
 drivers/mtd/mtd_blkdevs.c | 10 ++++++++--
 drivers/mtd/ubi/block.c   |  6 +++++-
 include/linux/blk-mq.h    | 10 ----------
 4 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e27a659973965..f1ca31a89493a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1297,25 +1297,6 @@ void blk_steal_bios(struct bio_list *list, struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_steal_bios);
 
-#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
-/**
- * rq_flush_dcache_pages - Helper function to flush all pages in a request
- * @rq: the request to be flushed
- *
- * Description:
- *     Flush all pages in @rq.
- */
-void rq_flush_dcache_pages(struct request *rq)
-{
-	struct req_iterator iter;
-	struct bio_vec bvec;
-
-	rq_for_each_segment(bvec, rq, iter)
-		flush_dcache_page(bvec.bv_page);
-}
-EXPORT_SYMBOL_GPL(rq_flush_dcache_pages);
-#endif
-
 /**
  * blk_lld_busy - Check if underlying low-level drivers of a device are busy
  * @q : the queue of the device being checked
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 4eaba6f4ec680..66f81d42fe778 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -46,6 +46,8 @@ static blk_status_t do_blktrans_request(struct mtd_blktrans_ops *tr,
 			       struct mtd_blktrans_dev *dev,
 			       struct request *req)
 {
+	struct req_iterator iter;
+	struct bio_vec bvec;
 	unsigned long block, nsect;
 	char *buf;
 
@@ -76,13 +78,17 @@ static blk_status_t do_blktrans_request(struct mtd_blktrans_ops *tr,
 			}
 		}
 		kunmap(bio_page(req->bio));
-		rq_flush_dcache_pages(req);
+
+		rq_for_each_segment(bvec, req, iter)
+			flush_dcache_page(bvec.bv_page);
 		return BLK_STS_OK;
 	case REQ_OP_WRITE:
 		if (!tr->writesect)
 			return BLK_STS_IOERR;
 
-		rq_flush_dcache_pages(req);
+		rq_for_each_segment(bvec, req, iter)
+			flush_dcache_page(bvec.bv_page);
+
 		buf = kmap(bio_page(req->bio)) + bio_offset(req->bio);
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize) {
 			if (tr->writesect(dev, block, buf)) {
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 062e6c2c45f5f..302426ab30f8d 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -294,6 +294,8 @@ static void ubiblock_do_work(struct work_struct *work)
 	int ret;
 	struct ubiblock_pdu *pdu = container_of(work, struct ubiblock_pdu, work);
 	struct request *req = blk_mq_rq_from_pdu(pdu);
+	struct req_iterator iter;
+	struct bio_vec bvec;
 
 	blk_mq_start_request(req);
 
@@ -305,7 +307,9 @@ static void ubiblock_do_work(struct work_struct *work)
 	blk_rq_map_sg(req->q, req, pdu->usgl.sg);
 
 	ret = ubiblock_read(pdu);
-	rq_flush_dcache_pages(req);
+
+	rq_for_each_segment(bvec, req, iter)
+		flush_dcache_page(bvec.bv_page);
 
 	blk_mq_end_request(req, errno_to_blk_status(ret));
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a78d9a0f2a1be..308edc2a4925b 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1132,14 +1132,4 @@ static inline bool blk_req_can_dispatch_to_zone(struct request *rq)
 }
 #endif /* CONFIG_BLK_DEV_ZONED */
 
-#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
-# error	"You should define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform"
-#endif
-#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
-void rq_flush_dcache_pages(struct request *rq);
-#else
-static inline void rq_flush_dcache_pages(struct request *rq)
-{
-}
-#endif /* ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE */
 #endif /* BLK_MQ_H */
-- 
2.30.2

