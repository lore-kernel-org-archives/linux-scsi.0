Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB05AC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiBVOPZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbiBVOPW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:15:22 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A689415F36A;
        Tue, 22 Feb 2022 06:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=esQS1vqvDXuhlb8zqEebCU+gcficHaNDtdsQyPyEWmQ=; b=GhgXaLkOLTCuOM7q5g/rdBYnBE
        Wgc7U5EAUx3jTkhDkS7dBadWX7nFCu2zupQ3LG+37m3clDhJWGr1VyHTOJFkhsFjU6AAH4rATUIRH
        KnFef5eDbmPXK57/IQqfXqkiETasqfCGSatgPoBJjfNJpv/rFKXXn0i4jTudfypo6RLDuVhe4AmQX
        E3TrUYamrlRkNBKSwU2rFTB3hUTDCpkYwHTR00RkJRG1UlZeWMLRkC0gOHj1ASS+Nm5pXtG1/BCBe
        An0BzxLupCdmM2WgW4DsTRvwOLZOx4fpcKV53BemWXMhoQjHooVyii+fFAKATJ3D1qErweyRkvoN/
        xMARFwPQ==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVwM-009qBr-Rt; Tue, 22 Feb 2022 14:14:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 01/12] blk-mq: do not include passthrough requests in I/O accounting
Date:   Tue, 22 Feb 2022 15:14:39 +0100
Message-Id: <20220222141450.591193-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222141450.591193-1-hch@lst.de>
References: <20220222141450.591193-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I/O accounting buckets I/O into the read/write/discard categories into
which passthrough I/O does not fit at all.  It also accounts to the
block_device, which may not even exist for passthrough I/O.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 6 +-----
 block/blk.h    | 2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a05ce77250316..ee80853473d1e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -883,11 +883,7 @@ static inline void blk_account_io_done(struct request *req, u64 now)
 
 static void __blk_account_io_start(struct request *rq)
 {
-	/* passthrough requests can hold bios that do not have ->bi_bdev set */
-	if (rq->bio && rq->bio->bi_bdev)
-		rq->part = rq->bio->bi_bdev;
-	else if (rq->q->disk)
-		rq->part = rq->q->disk->part0;
+	rq->part = rq->bio->bi_bdev;
 
 	part_stat_lock();
 	update_io_ticks(rq->part, jiffies, false);
diff --git a/block/blk.h b/block/blk.h
index ebaa59ca46ca6..6f21859c7f0ff 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -325,7 +325,7 @@ int blk_dev_init(void);
  */
 static inline bool blk_do_io_stat(struct request *rq)
 {
-	return (rq->rq_flags & RQF_IO_STAT) && rq->q->disk;
+	return (rq->rq_flags & RQF_IO_STAT) && !blk_rq_is_passthrough(rq);
 }
 
 void update_io_ticks(struct block_device *part, unsigned long now, bool end);
-- 
2.30.2

