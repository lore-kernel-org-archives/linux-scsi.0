Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE117C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 13:03:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhKZNGc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 08:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhKZNEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 08:04:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7828EC0613FE;
        Fri, 26 Nov 2021 04:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HaxtvZRNx4zf6RCep8t0FSuXHJUOaGajJ5JwpULYqBo=; b=djG5ee3I2MMTIVE6esArj2PeQf
        OOFPk5gxp9RdJ7WonNr22W5hahpcz9EV0hehMn4ZcUnOtmIQaRJ3kJ5fRY3ogg8OHGkv3DE8rSnsr
        r5f/bo0Ed7AJls8Iz/SdapWdceUtZMaRZ8c/apIhP7n6ZbhODNEfvLKtF+IhELCI9cFEQWntSthD4
        MvAxcIDqccMhfxmCTU6snjmkxzn0wOgGTuiihEXWGk0Hd/yyQm/CgvWat0xZzVmBNqtAWCbn34CYU
        AkYQyygfZDnfCpuCQC17U9iSNgHEN68vkHXec77X/1qvd81FRQJgtRERhZtXywxI7A+EnORp+1K+M
        F6B8Sqdw==;
Received: from [2001:4bb8:191:f9ce:bae8:5658:102a:5491] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mqaB2-00AWG5-6p; Fri, 26 Nov 2021 12:18:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 1/5] mtd_blkdevs: remove the sector out of range check in do_blktrans_request
Date:   Fri, 26 Nov 2021 13:17:58 +0100
Message-Id: <20211126121802.2090656-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211126121802.2090656-1-hch@lst.de>
References: <20211126121802.2090656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The block layer already performs this check, no need to duplicate it in
the driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/mtd/mtd_blkdevs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 66f81d42fe778..113f86df76038 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -54,17 +54,11 @@ static blk_status_t do_blktrans_request(struct mtd_blktrans_ops *tr,
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

