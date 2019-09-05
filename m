Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B878BC3A5A5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9208C2082E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Q5tg4z5j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbfIEE3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:29:08 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62199 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731095AbfIEE3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 00:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567657745; x=1599193745;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=4es099Tzn+1lybmV19FyhcM0o6YKAGlTweyIXLI8G2M=;
  b=Q5tg4z5jfpwQcwbO5s0Tpg7LsZ5Y0dQOW3yElhxBazGRNlSr3Onl7aeP
   OvLcMR4s9nlvoM+3SjLC/UBpN1kH7sMEZxUbL9GxG45o2pPTknAnslAJP
   76EZ5ssKD7DYY7hiYdSTc12IPDNLgxTP5asoNbsH/94Ng8CX2/XnmamDB
   TaLrtcogkSnziqLwLyxZomnp4EaJHl5Gsl4TsB/E3CUqGiX9kh0Bf+Wmd
   PnXOccr60hVd0LmDnPRMKy4v9JFxNH7YWOL8CUKv6qTryYVOpAwtSp1le
   6m8oLbt7I47WAsB7v0klwDhmkimj31WfZogg3rjzQE7hSnLD3YgsrNivd
   g==;
IronPort-SDR: mDlEBW6ucd9Nvjb9I8HynlO4pizPfyaGNvTxTEWc1DRahFp5wcQD9JBsjQJMm7jvvupApnVkox
 BeFqXpSb50af0CbIhTdNBEO2PHpz9hJjQ72uHL+o7JDwiGy1et3yOSo/02aqHfjT/iMW7uC7aa
 NXbbDBR5gvzjrHFbI/vz7sRR91LxEHGS6KCWpeQig+/Qlfjt/W9c29QVhpZ4JbmINzocEohqAv
 QwqY1qG1Hyj4oMFdCP9h3FeEu4DzoC9kKL1r3x8++FOaa22bj90mxQ0ze3mNndAb5P4Hkx9i9M
 t/o=
X-IronPort-AV: E=Sophos;i="5.64,469,1559491200"; 
   d="scan'208";a="224233073"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 12:29:04 +0800
IronPort-SDR: gnDPaI8zDUxDx/4zFnOgRWWF/i+XWPB0YNn1UNQDJ20c5NFJaKtxe0mIwBbqULFpphT7RTPYO4
 p/PscSviE5qmHNzJvxQPIXF1998ThCcad84HcoWz6+R8bomJ2exDTSSjiaV69a5zBQwRzItWJp
 wfwZA0MCYHUB5raj8enk3hC+NTv/rbtM63GtJDdfkWbG0QmA7j3IP/QeT9Ccd7rFicGRa/h114
 VTXIV9Fzl5OUGj8su686kqT78eIEqMrhxEXFU5hkBuqYmJ6FSwtfmnHFLlQuBdTusMw3CS6GIh
 rLo19urMWC7gqollPT4ZtY+G
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 21:26:01 -0700
IronPort-SDR: swWbFTikVbWqQ4x8Nafg6Dfmxd/Jl7AFEMMKNSU6536CyJS2tqFks9byp/SS90QypqA3a80V48
 0VGP1FaTGC1qZuD4MWfvgtMsnZtYh7+t2L5GmRSuB8DKffVtQcpvQpk6q++uk8fq1cWy4U+Uss
 DqeUiiJQODiWaKo8aFbnzAhDOL0pRSpJD2O3/CE5B60n/6OzpTmmbsujZ23rOz3Zo5rYjWBADg
 qxeIPt8HUL88A2R5NcDTUvlHBFZVWpmxg+YjWpTu93agR4/xR7XbBl+oaHVuZf/UNH4hj+wfvY
 J3c=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 04 Sep 2019 21:29:04 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 2/7] block: Change elevator_init_mq() to always succeed
Date:   Thu,  5 Sep 2019 13:28:56 +0900
Message-Id: <20190905042901.5830-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905042901.5830-1-damien.lemoal@wdc.com>
References: <20190905042901.5830-1-damien.lemoal@wdc.com>
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

