Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCA4C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiBVOPt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiBVOPr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:15:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C03916041C;
        Tue, 22 Feb 2022 06:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+0GNP66N7FGBlpcVzvTjZW5gfaV8Pz5L3x8p/C2dQVw=; b=Gw5s4xGGNf/WwoRLYYx7RiuUer
        ycEOKVvDrxUudZ7+NHdq8YbA+8KZuZ1c5gKzDZJa4wV27+vlqKb1PLtmXg86flGDqqLeIaCqQjWK2
        ad+lSuwPZcZn0RcC8xgJAFUYyOxCnPFOfPqHWxhxUEXC6FlmM7ZCkFk2rZY093mfAIHpq+rB+4efw
        gIbBr19+WtKsFJf2jOntObSsqte3kpR1YIyh7H3oFOA2zP8qDjAPodaG0kwMnLICOycACoz/TYrYf
        BY71XNVxVUTzF94OQyEo1XFvMr+2n0BZl27kLfotaQXW5n8/7VXwV1M8nKK9Ee8AJBmhcfG57hQUQ
        KdLGethQ==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVwg-009qKq-7W; Tue, 22 Feb 2022 14:15:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 08/12] block: don't remove hctx debugfs dir from blk_mq_exit_queue
Date:   Tue, 22 Feb 2022 15:14:46 +0100
Message-Id: <20220222141450.591193-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222141450.591193-1-hch@lst.de>
References: <20220222141450.591193-1-hch@lst.de>
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

