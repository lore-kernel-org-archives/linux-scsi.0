Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46388C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 13:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhKZNHE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 08:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhKZNE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 08:04:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25315C0619D3;
        Fri, 26 Nov 2021 04:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=omV7umfU0SfN4gJAlLuf/OnKHKv3dm26gHxXCXe8nS8=; b=Tbz3SoxwzD3bGr3KUBnoUGxCzp
        +rR9KYzCDEgwuD7uEdP85Ga/IuybyPHx91pU0T3SD3/CD9+1x7h3KPrSgvVvMlZMrdApiFYzl7dL+
        8B4dNXFzFd46+oaAjz9+wKaCU9wdy2zrpEfcvrBQaSi3BGMzu0B+mEqg68vYDJYyUvrXtOhmbsrp7
        yOEpYS7ZeutAb1IOJBLqUGCTAUKIdq2jLSp/nJMRr4c+0rXcKqY2k9Vep2yFlAAv8O07QHiMgSQ3K
        /EkpxdnR8WhGne1arU6FftK1JRhRTOokMtyRzynO2GpOghchK24BfuhR76L94ArhtULyA+aUY9uYU
        FbJqqziw==;
Received: from [2001:4bb8:191:f9ce:bae8:5658:102a:5491] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mqaB3-00AWGM-Gx; Fri, 26 Nov 2021 12:18:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 2/5] block: don't check ->rq_disk in merges
Date:   Fri, 26 Nov 2021 13:17:59 +0100
Message-Id: <20211126121802.2090656-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211126121802.2090656-1-hch@lst.de>
References: <20211126121802.2090656-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a 1:1 relationship between request_queues and gendisks now, so
no need for these extra checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index e07f5a1ae86e2..4de34a332c9fd 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -777,8 +777,7 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req_op(req) != req_op(next))
 		return NULL;
 
-	if (rq_data_dir(req) != rq_data_dir(next)
-	    || req->rq_disk != next->rq_disk)
+	if (rq_data_dir(req) != rq_data_dir(next))
 		return NULL;
 
 	if (req_op(req) == REQ_OP_WRITE_SAME &&
@@ -905,10 +904,6 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (bio_data_dir(bio) != rq_data_dir(rq))
 		return false;
 
-	/* must be same device */
-	if (rq->rq_disk != bio->bi_bdev->bd_disk)
-		return false;
-
 	/* only merge integrity protected bio into ditto rq */
 	if (blk_integrity_merge_bio(rq->q, rq, bio) == false)
 		return false;
-- 
2.30.2

