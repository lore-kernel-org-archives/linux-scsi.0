Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8B1C3A5AD
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E89CF21743
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kKUHWvTO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387578AbfIEJvw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 05:51:52 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25315 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730769AbfIEJvv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 05:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567677112; x=1599213112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4es099Tzn+1lybmV19FyhcM0o6YKAGlTweyIXLI8G2M=;
  b=kKUHWvTOqf4keCOLA/R4zVJv6YvIVtv24qqMYzOgVnOdwAWwhuZSvRU9
   nKzzsLgrvrZHdw+teHW9T4a/o/6wGxto5/5fvlRuBVrHQv0GAbkNuqQGp
   cTpykmkbwf0S0n4vip7KozqCmgaulIt8kMrWjQdtlizAzYgjpgULVWJB6
   Q0OQyJkOMQMG/+2yvziMOZiK/R9/zqoCH2o+72l3/oRfKm/PBYLcBi43j
   HS4QofJD+7bxELH+OC5RAHgs1tvUrj6ohAMI+Ox6Kko0m2zEIgVy7JBqY
   aVK4MgEQtizf6ETtr5i74P1MfIgGh15gXjYcaJKDrz6fumuPsUNaxbxuL
   w==;
IronPort-SDR: 7B0/A2pSyixCBNOWNMQ1ipoKXh1ftqtmDI6QKZmOFA6EfUvviWv9P8caZQGCcFBvldI6sgETj9
 GGHnh6PCZ5quHqAYqfDCQqltk5SnF3nI5FhB1YP3p/WhFTdCc6Refzn6tHw8UXrJf0NJkzECNo
 grCYSt069biPM97pe922wSUbL54HIz/FM4YhvAwpruo+ov5nZPZWF9RGmr/fKEcQH1PKAMaYNc
 rACT7dkQo/YudRm2ZLaN6YE4R1z8PCp0ksffa/mxyeACgN0DwE9vNfKJuj/zqOtZpWtOzEM4oK
 rzg=
X-IronPort-AV: E=Sophos;i="5.64,470,1559491200"; 
   d="scan'208";a="119106254"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 17:51:40 +0800
IronPort-SDR: EPMWaudBJ+KmFjaumjnBOBdTYZ0Z+J2xH8hGlBCVtisnKVuglTxosOGcRK+PMKBsSAu8kX5+WS
 QPkqnrziAmfFus29o6NdIJTIshZgSJKNoqt6c4hrYoy+fi/MSJHFV7YPSpmypbP4LWlsOGH1o6
 3gHJ6FyQbae7dMoDc7rcdmZaAVfU6Wb1gvdoKwFJ1uFXwaxzTINjinoOXud8QezA/pUEKJSR46
 itoJzgpARWb8bmH/iOzW6KkjejgyWfKFEq3ackyHdUPv0+qUGgdIc5udAqa+OulzN6QOb8RON0
 m9wrMpHwp5YHmRz/qiWwr55y
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 02:48:35 -0700
IronPort-SDR: zZEakMvskMlFNIDvSV9wxiBRD4mLO9VxhlarUpSqpeHQc9cpzF2ItrDi6grb6pXxAIrLz/PrNY
 5p7ZXCUwzzVNAVxwN84zKR6rqp/zYsNwjf6HN/LBJ49MZMNz08COVy3+JvOIZEJ8dZfT/Syw7r
 1NPIdlgd3F1/uQvRYUPXMKrK1KjY9vjx9MvChzyj0wr+iQmVU2eZUwuny/og6DaOVr3ZOxl92l
 T24+RRZEAoLIvHPf+vWIY41WW2e6gd9onB59X/s7rOwvWy/KJnE7XzOfZRSWQtdfs7qe4n1C7J
 50U=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Sep 2019 02:51:39 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v5 2/7] block: Change elevator_init_mq() to always succeed
Date:   Thu,  5 Sep 2019 18:51:30 +0900
Message-Id: <20190905095135.26026-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the default elevator chosen is mq-deadline, elevator_init_mq() may
return an error if mq-deadline initialization fails, leading to
blk_mq_init_allocated_queue() returning an error, which in turn will
cause the block device initialization to fail and the device not being
exposed.

Instead of taking such extreme measure, handle mq-deadline
initialization failures in the same manner as when mq-deadline is not
available (no module to load), that is, default to the "none" scheduler.
With this change, elevator_init_mq() return type can be changed to void.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c   |  8 +-------
 block/blk.h      |  2 +-
 block/elevator.c | 23 ++++++++++++-----------
 3 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 13923630e00a..ee4caf0c0807 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2842,8 +2842,6 @@ static unsigned int nr_hw_queues(struct blk_mq_tag_set *set)
 struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 						  struct request_queue *q)
 {
-	int ret = -ENOMEM;
-
 	/* mark the queue as mq asap */
 	q->mq_ops = set->ops;
 
@@ -2904,14 +2902,10 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
 
-	ret = elevator_init_mq(q);
-	if (ret)
-		goto err_tag_set;
+	elevator_init_mq(q);
 
 	return q;
 
-err_tag_set:
-	blk_mq_del_queue_tag_set(q);
 err_hctxs:
 	kfree(q->queue_hw_ctx);
 	q->nr_hw_queues = 0;
diff --git a/block/blk.h b/block/blk.h
index e4619fc5c99a..ed347f7a97b1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -184,7 +184,7 @@ void blk_account_io_done(struct request *req, u64 now);
 
 void blk_insert_flush(struct request *rq);
 
-int elevator_init_mq(struct request_queue *q);
+void elevator_init_mq(struct request_queue *q);
 int elevator_switch_mq(struct request_queue *q,
 			      struct elevator_type *new_e);
 void __elevator_exit(struct request_queue *, struct elevator_queue *);
diff --git a/block/elevator.c b/block/elevator.c
index 4721834815bb..2944c129760c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -628,34 +628,35 @@ static inline bool elv_support_iosched(struct request_queue *q)
 
 /*
  * For blk-mq devices supporting IO scheduling, we default to using mq-deadline,
- * if available, for single queue devices. If deadline isn't available OR we
- * have multiple queues, default to "none".
+ * if available, for single queue devices. If deadline isn't available OR
+ * deadline initialization fails OR we have multiple queues, default to "none".
  */
-int elevator_init_mq(struct request_queue *q)
+void elevator_init_mq(struct request_queue *q)
 {
 	struct elevator_type *e;
-	int err = 0;
+	int err;
 
 	if (!elv_support_iosched(q))
-		return 0;
+		return;
 
 	if (q->nr_hw_queues != 1)
-		return 0;
+		return;
 
 	WARN_ON_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags));
 
 	if (unlikely(q->elevator))
-		goto out;
+		return;
 
 	e = elevator_get(q, "mq-deadline", false);
 	if (!e)
-		goto out;
+		return;
 
 	err = blk_mq_init_sched(q, e);
-	if (err)
+	if (err) {
+		pr_warn("\"%s\" elevator initialization failed, "
+			"falling back to \"none\"\n", e->elevator_name);
 		elevator_put(e);
-out:
-	return err;
+	}
 }
 
 
-- 
2.21.0

