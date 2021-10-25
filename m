Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B91D2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A083961040
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 07:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhJYHH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhJYHHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 03:07:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D48DC061745;
        Mon, 25 Oct 2021 00:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oAf0cozBABJodjGjeGfj2mHJ5q1G5mTFnT8jXPv2KNo=; b=tuoyrK3hZtrEL114mS3hEazypB
        SZTpmDVBiCszkW8cu7xBLiLdtSn1x6ymFdwRi1DnkHhuXtbm3AKPhlfju7bU/sUDuO2et3l+Kz8ZZ
        T8xBNpAsNjn7EXTjj9jGWC7vlzYRkiixc0QU1pwi0g1QHhmjZh6LsPhrIR/u+ObOicAg7nlrP1IXP
        ChaBi4tHgGJh2yz84tTnySZ4qcnVFB3IjWDkXpEE3QPJbHMDNwJvWh45xkmqKXZYgflL1fGc84jHn
        QD8Ihs4Gf6CPSCxwbFYJtjNy53nM5XgEMHFC25Bmsvz6AXPx3ZV5+5GnLvCDl0f5SrVOS9FgX14GO
        9r8p6QpQ==;
Received: from [2001:4bb8:184:6dcb:6093:467a:cccc:351c] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meu2w-00FUQE-Vw; Mon, 25 Oct 2021 07:05:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 03/12] block: remove rq_flush_dcache_pages
Date:   Mon, 25 Oct 2021 09:05:08 +0200
Message-Id: <20211025070517.1548584-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211025070517.1548584-1-hch@lst.de>
References: <20211025070517.1548584-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
index 0d267cfb71484..08c6077365ac9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1324,25 +1324,6 @@ void blk_steal_bios(struct bio_list *list, struct request *rq)
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
index b8ae1ec14e178..356b5bb4db51a 100644
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
index e003b4b44ffa2..99e17ee13feb7 100644
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
index 850ecfdebe595..047ce54fca96c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1131,14 +1131,4 @@ static inline bool blk_req_can_dispatch_to_zone(struct request *rq)
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

