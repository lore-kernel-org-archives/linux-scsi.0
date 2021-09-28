Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12658C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFE5560F4F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhI1FZT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 01:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhI1FZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 01:25:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1639BC061575;
        Mon, 27 Sep 2021 22:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=lmHEDTWGofeDOwHsn0RpYTE0PMMmj0L5m+XiC3VnX2w=; b=mld55F53YIGAnwfDfJb1dpucQE
        DQeivNpnLZgobDKZWtBQGX2JzkHqC2GFdR/7SofbBXFoRfBIGVlqBxjh1dOIOjLEfx25zcMmvLige
        +ygr040OwDq3n7tJ+uWWssNbsEJhWjehCfcP7JqE5++m5jXgNAtsGyIwXxqwTbdyxb8DqmpCHUs1h
        AVzb/F5l7OwQNzHh8e3dp7T0uuNQ6bPPODq9jNBCwZm8fv7fAFouxF80P8o0Zd2jiJgRnD8ZpsVJw
        vsleMY54A0LlhHhoo1rVUbLziYmmA9Q502Xl23vY+f9zi/i9/VByppiDdENanm0yDaqAEI4ScpWaS
        WxzNk15g==;
Received: from p4fdb05cb.dip0.t-ipconnect.de ([79.219.5.203] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mV5Zg-00AW6x-4a; Tue, 28 Sep 2021 05:22:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 1/5] mtd_blkdevs: remove the sector out of range check in do_blktrans_request
Date:   Tue, 28 Sep 2021 07:22:07 +0200
Message-Id: <20210928052211.112801-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928052211.112801-1-hch@lst.de>
References: <20210928052211.112801-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The block layer already performs this check, no need to duplicate it in
the driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mtd/mtd_blkdevs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index b8ae1ec14e178..5ce5da705ac00 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -52,17 +52,11 @@ static blk_status_t do_blktrans_request(struct mtd_blktrans_ops *tr,
 	block = blk_rq_pos(req) << 9 >> tr->blkshift;
 	nsect = blk_rq_cur_bytes(req) >> tr->blkshift;
 
-	if (req_op(req) == REQ_OP_FLUSH) {
+	switch (req_op(req)) {
+	case REQ_OP_FLUSH:
 		if (tr->flush(dev))
 			return BLK_STS_IOERR;
 		return BLK_STS_OK;
-	}
-
-	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
-	    get_capacity(req->rq_disk))
-		return BLK_STS_IOERR;
-
-	switch (req_op(req)) {
 	case REQ_OP_DISCARD:
 		if (tr->discard(dev, block, nsect))
 			return BLK_STS_IOERR;
-- 
2.30.2

