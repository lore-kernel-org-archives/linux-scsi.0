Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5B7C8300D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4AF42076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgD3NUf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:60868 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbgD3NUI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 81212AF4C;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 22/41] block: implement persistent commands
Date:   Thu, 30 Apr 2020 15:18:45 +0200
Message-Id: <20200430131904.5847-23-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some LLDDs implement event handling by sending a command to the
firmware, which then will be completed once the firmware wants
to register an event.
So worst case a command is being sent to the firmware then the
driver initializes, and will be returned once the driver unloads.
To avoid these commands to block the queues during freezing or
quiescing this patch implements support for 'persistent' commands,
which will be excluded from blk_queue_enter() and blk_queue_exit()
calls.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq.c            | 12 +++++++++---
 include/linux/blk-mq.h    |  2 ++
 include/linux/blk_types.h |  4 ++++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 44482aaed11e..402cf104d183 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -402,9 +402,14 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 {
 	struct blk_mq_alloc_data alloc_data = { .flags = flags, .cmd_flags = op };
 	struct request *rq;
-	int ret;
+	int ret = 0;
 
-	ret = blk_queue_enter(q, flags);
+	if (flags & BLK_MQ_REQ_PERSISTENT) {
+		if (blk_queue_dying(q))
+			ret = -ENODEV;
+		alloc_data.cmd_flags |= REQ_PERSISTENT;
+	} else
+		ret = blk_queue_enter(q, flags);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -481,7 +486,8 @@ static void __blk_mq_free_request(struct request *rq)
 	if (sched_tag != -1)
 		blk_mq_put_tag(hctx->sched_tags, ctx, sched_tag);
 	blk_mq_sched_restart(hctx);
-	blk_queue_exit(q);
+	if (!(rq->cmd_flags & REQ_PERSISTENT))
+		blk_queue_exit(q);
 }
 
 void blk_mq_free_request(struct request *rq)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c186dc25fc1c..a4b02196810c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -441,6 +441,8 @@ enum {
 	BLK_MQ_REQ_INTERNAL	= (__force blk_mq_req_flags_t)(1 << 2),
 	/* set RQF_PREEMPT */
 	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
+	/* mark request as persistent */
+	BLK_MQ_REQ_PERSISTENT	= (__force blk_mq_req_flags_t)(1 << 4),
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 70254ae11769..898e75e2e8b0 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -336,6 +336,9 @@ enum req_flag_bits {
 	/* command specific flags for REQ_OP_WRITE_ZEROES: */
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
 
+	/* Persistent firmware command, ignore for q_usage_counter */
+	__REQ_PERSISTENT,
+
 	__REQ_HIPRI,
 
 	/* for driver use */
@@ -362,6 +365,7 @@ enum req_flag_bits {
 #define REQ_CGROUP_PUNT		(1ULL << __REQ_CGROUP_PUNT)
 
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
+#define REQ_PERSISTENT		(1ULL << __REQ_PERSISTENT)
 #define REQ_HIPRI		(1ULL << __REQ_HIPRI)
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
-- 
2.16.4

