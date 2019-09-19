Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A7EC49ED7
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 09:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C06E6208C0
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 09:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388898AbfISJpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:45:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:59256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388742AbfISJpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 05:45:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D5DABB6C8;
        Thu, 19 Sep 2019 09:45:49 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        Hans Holmberg <hans.holmberg@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 2/2] blk-mq: always call into the scheduler in blk_mq_make_request()
Date:   Thu, 19 Sep 2019 11:45:47 +0200
Message-Id: <20190919094547.67194-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190919094547.67194-1-hare@suse.de>
References: <20190919094547.67194-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

A scheduler might be attached even for devices exposing more than
one hardware queue, so the check for the number of hardware queue
is pointless and should be removed.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 44ff3c1442a4..faab542e4836 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1931,7 +1931,6 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 
 static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
-	const int is_sync = op_is_sync(bio->bi_opf);
 	const int is_flush_fua = op_is_flush(bio->bi_opf);
 	struct blk_mq_alloc_data data = { .flags = 0};
 	struct request *rq;
@@ -1977,7 +1976,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		/* bypass scheduler for flush rq */
 		blk_insert_flush(rq);
 		blk_mq_run_hw_queue(data.hctx, true);
-	} else if (plug && (q->nr_hw_queues == 1 || q->mq_ops->commit_rqs)) {
+	} else if (plug && q->mq_ops->commit_rqs) {
 		/*
 		 * Use plugging if we have a ->commit_rqs() hook as well, as
 		 * we know the driver uses bd->last in a smart fashion.
@@ -2020,9 +2019,6 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 			blk_mq_try_issue_directly(data.hctx, same_queue_rq,
 					&cookie);
 		}
-	} else if ((q->nr_hw_queues > 1 && is_sync) || (!q->elevator &&
-			!data.hctx->dispatch_busy)) {
-		blk_mq_try_issue_directly(data.hctx, rq, &cookie);
 	} else {
 		blk_mq_sched_insert_request(rq, false, true, true);
 	}
-- 
2.16.4

