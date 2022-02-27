Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D3AC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 17:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiB0RXF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 12:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiB0RXA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 12:23:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EBB6D4E0;
        Sun, 27 Feb 2022 09:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+0GNP66N7FGBlpcVzvTjZW5gfaV8Pz5L3x8p/C2dQVw=; b=wZ0pjNB5rEJwdaLIliUjZAgaHk
        vydNFMli/WVLhJnndHz5HnyZ2tiJOZFoxqerODW3+k7sMgflIo2VtPrKAM+x36EEKttD87pD2tCPg
        5/vuw/IN8ic469wUkUJKtoMArFCx/OayKHQVM6oarFaRi0VOi1CoGEVEBTmfJwO7XFPAdVNoFrY1y
        /w5X+OD6jeuvYKnRVgAqZX9fmd4IUs0kiWJ3uJuZPDgRoxjkvzuT7nT4Kkml3qGKg8UGTQHfDB0Xc
        4dsShaX9XIt0maspxY6FHdkkBB5vrXNSubeGQ831xA6RSvWlEpUULC4XrusZWeg90d9WDosfD8pmX
        cszgArBw==;
Received: from 91-118-163-82.static.upcbusiness.at ([91.118.163.82] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nONFP-009s3y-Mv; Sun, 27 Feb 2022 17:22:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 10/14] block: don't remove hctx debugfs dir from blk_mq_exit_queue
Date:   Sun, 27 Feb 2022 18:21:40 +0100
Message-Id: <20220227172144.508118-11-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220227172144.508118-1-hch@lst.de>
References: <20220227172144.508118-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

The queue's top debugfs dir is removed from blk_release_queue(), so all
hctx's debugfs dirs are removed from there. Given blk_mq_exit_queue()
is only called from blk_cleanup_queue(), it isn't necessary to remove
hctx debugfs from blk_mq_exit_queue().

So remove it from blk_mq_exit_queue().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 63e2d3fd60946..540c8da30da72 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3425,7 +3425,6 @@ static void blk_mq_exit_hw_queues(struct request_queue *q,
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (i == nr_queue)
 			break;
-		blk_mq_debugfs_unregister_hctx(hctx);
 		blk_mq_exit_hctx(q, set, hctx, i);
 	}
 }
-- 
2.30.2

