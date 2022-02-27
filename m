Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211F8C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 17:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiB0RWc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 12:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiB0RWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 12:22:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D766C958;
        Sun, 27 Feb 2022 09:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=esQS1vqvDXuhlb8zqEebCU+gcficHaNDtdsQyPyEWmQ=; b=VhFN9Dd3QO1rXDct2ahT+bxqSn
        RILoHKysosaiOJFHFlnfSpinkiz/+96icBl7Ah9OoNOVuetCrbqA84fpX75Ze0bssgY2yzKjwqAEN
        ECIWsvPQcJ+3QVgWPlfxSL4tfDM2i+tGq2sv6QLL+YwnmQQ2K0s2j67gZ597nIuQ03jh/VWspHzER
        uWZISAFdeoAlTe9GCXjLvQVKP3vQMoTt58ZXKLb/FwN5Z2QG4IHhwrHwQ96CRNI37uQCAmcJ121X2
        kvIEVDqCzbcYLrBB0jV209NlJV9OxuiyEoa07H6p7LTX8+D50VOV1i5tL6gaPYSmhPiEWQMkGvJTS
        l+0HhfrQ==;
Received: from 91-118-163-82.static.upcbusiness.at ([91.118.163.82] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nONF1-009rxx-K6; Sun, 27 Feb 2022 17:21:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 01/14] blk-mq: do not include passthrough requests in I/O accounting
Date:   Sun, 27 Feb 2022 18:21:31 +0100
Message-Id: <20220227172144.508118-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220227172144.508118-1-hch@lst.de>
References: <20220227172144.508118-1-hch@lst.de>
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

