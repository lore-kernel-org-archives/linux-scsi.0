Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E6DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 248B861BFA
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 06:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbhKQGR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 01:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbhKQGRY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 01:17:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4609EC061764;
        Tue, 16 Nov 2021 22:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=5Y57JG7VXaoFWW1akQPI6hTMWlsbyIej2L4X3VlG1LE=; b=EWByrGMG+/If75tDNJKhTRfVCs
        8wmJEu33W62TXmRsyr2sJE7UB0/H6rgMJq6/naMYCMVc0hGTlAAJURaRmiSnC/bnOYrp79rbGutil
        nleJTeHxJYdm/VaoVyRkuuNYS4q8ydLUz0PiNxIOfrBCfpdzrB+jbHREtOfi5zNzKGbzSnKEMiIJO
        dsGrwD/ME6GTH7RhEHRkCmPsLS55YGh3enE4+7FSRwIOpsdHUXtCW7dHq6dQkgKck1zVCasr23MFV
        4IxjnmFzX9Scqr2yT/29aRFUO3dP8K9T3zeLLBgSBDCF0Dwticqzv19aotFn6izACPL6CMoCRRDZ/
        EKBaTgiQ==;
Received: from 213-225-5-109.nat.highway.a1.net ([213.225.5.109] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnED6-007MGe-9r; Wed, 17 Nov 2021 06:14:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH 09/11] block: move blk_dump_rq_flags to blk-mq.c
Date:   Wed, 17 Nov 2021 07:14:02 +0100
Message-Id: <20211117061404.331732-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_dump_rq_flags deals with a request, so move it to blk-mq.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c | 14 --------------
 block/blk-mq.c   | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 60cc44418ce79..89971630f092f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -217,20 +217,6 @@ void blk_print_req_error(struct request *req, blk_status_t status)
 		IOPRIO_PRIO_CLASS(req->ioprio));
 }
 
-void blk_dump_rq_flags(struct request *rq, char *msg)
-{
-	printk(KERN_INFO "%s: dev %s: flags=%llx\n", msg,
-		rq->rq_disk ? rq->rq_disk->disk_name : "?",
-		(unsigned long long) rq->cmd_flags);
-
-	printk(KERN_INFO "  sector %llu, nr/cnr %u/%u\n",
-	       (unsigned long long)blk_rq_pos(rq),
-	       blk_rq_sectors(rq), blk_rq_cur_sectors(rq));
-	printk(KERN_INFO "  bio %p, biotail %p, len %u\n",
-	       rq->bio, rq->biotail, blk_rq_bytes(rq));
-}
-EXPORT_SYMBOL(blk_dump_rq_flags);
-
 /**
  * blk_sync_queue - cancel any pending callbacks on a queue
  * @q: the queue
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8b7edfc9623dd..f8a39f4fce01e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -667,6 +667,20 @@ void blk_mq_free_plug_rqs(struct blk_plug *plug)
 		blk_mq_free_request(rq);
 }
 
+void blk_dump_rq_flags(struct request *rq, char *msg)
+{
+	printk(KERN_INFO "%s: dev %s: flags=%llx\n", msg,
+		rq->rq_disk ? rq->rq_disk->disk_name : "?",
+		(unsigned long long) rq->cmd_flags);
+
+	printk(KERN_INFO "  sector %llu, nr/cnr %u/%u\n",
+	       (unsigned long long)blk_rq_pos(rq),
+	       blk_rq_sectors(rq), blk_rq_cur_sectors(rq));
+	printk(KERN_INFO "  bio %p, biotail %p, len %u\n",
+	       rq->bio, rq->biotail, blk_rq_bytes(rq));
+}
+EXPORT_SYMBOL(blk_dump_rq_flags);
+
 static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, blk_status_t error)
 {
-- 
2.30.2

