Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6409DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B1B360F4F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 05:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhI1FZl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 01:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhI1FZk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 01:25:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4193C061575;
        Mon, 27 Sep 2021 22:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=qyVVyX6iwsSVfVlLizJ/p3RKDKLEZPsrZosyweOO2yw=; b=dE2g5H4jLJm9J1v7Q2ve3YhEX7
        gtXxx7bSIKRbTqli5RP19ydQk12CiXOyPhaYaDpISOIHB+/qjkK5LTSxG/60vS9PlR6mwJO59Mxfg
        /zP2kkX7dn4M0HCOG0+ZM4HZVbErR1HgSWJrCNQdreDPCByL395wrPxWFX9g2tsH1Q4PYjRrAJ80m
        cyWBPeCzVFTyRLYHKULCXo8e7K5qk6KNcFmWvUSTdCCznjHLU0CWyl32Be+fIeRi/6j4oM0vjYrf6
        VAp1+16iSGPxvhyfBUIgf/PEFAhgDzetNGBshk91xbvcikY4rpqYx+Cc8+t00f8RI9zZZXyWzUWCp
        JbHuRIcw==;
Received: from p4fdb05cb.dip0.t-ipconnect.de ([79.219.5.203] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mV5a1-00AW8S-Ej; Tue, 28 Sep 2021 05:23:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 2/5] block: don't check ->rq_disk in merges
Date:   Tue, 28 Sep 2021 07:22:08 +0200
Message-Id: <20210928052211.112801-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928052211.112801-1-hch@lst.de>
References: <20210928052211.112801-1-hch@lst.de>
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
index 5b4f23014df8a..6b62415452f82 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -756,8 +756,7 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (req_op(req) != req_op(next))
 		return NULL;
 
-	if (rq_data_dir(req) != rq_data_dir(next)
-	    || req->rq_disk != next->rq_disk)
+	if (rq_data_dir(req) != rq_data_dir(next))
 		return NULL;
 
 	if (req_op(req) == REQ_OP_WRITE_SAME &&
@@ -884,10 +883,6 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
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

