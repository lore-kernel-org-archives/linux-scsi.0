Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF215C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 05:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E07023B4B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 05:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgLIFas (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 00:30:48 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45179 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbgLIFap (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 00:30:45 -0500
Received: by mail-pg1-f195.google.com with SMTP id v29so453695pgk.12;
        Tue, 08 Dec 2020 21:30:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kpaABBaTm2eEnOhP2FWFHi2c3i6BhMnLZ0O2VqeGX/g=;
        b=CktDdddCDo+Plpg6tAk4m615JUuY42JPRcanMVZcnd/jA0Vu7UrmcMljLO/uY4PJ3q
         EW6mv37hwZJbTmQeuvXblbUqoV/K+36EsHqwslCHUmDjmEiKZCwR5x1GhEwt5QR/g7Om
         SJgCziMsfRiratZrfogFzXk3AYC2G6ynAZd7Ue+6RsgQLSuJFZ+knqf7FmeZfnM1R8L7
         qy3e7eZQfRQYG+OHSg7mVWgt8FmURVBzhKP6apRhRSWlKcYGgTsdrarkN+mJVuffH72H
         Q8AZgwpBG1kVom0Yw9FvUIppy5doNeK9gVmoqAGt5gc49PQl54Op8mfmf2dXhnX6wvSx
         v5jA==
X-Gm-Message-State: AOAM531jEYk67DEKOLIrHRPvrhrR8AaA79tNx3lYak6X/xTRmLpQWgc0
        3nZk71AVfczIAU8Zxh61PS8=
X-Google-Smtp-Source: ABdhPJycZlGY1AHx6RrCm9ftrvm5cSb0hC0HgyExFOgJQVRMzZ0cV+22sQUFwyXgFcFCfsof+C4TwQ==
X-Received: by 2002:a63:6d49:: with SMTP id i70mr503148pgc.216.1607491804634;
        Tue, 08 Dec 2020 21:30:04 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 77sm753097pfv.16.2020.12.08.21.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 21:30:03 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Can Guo <cang@codeaurora.org>
Subject: [PATCH v5 2/8] block: Introduce BLK_MQ_REQ_PM
Date:   Tue,  8 Dec 2020 21:29:45 -0800
Message-Id: <20201209052951.16136-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209052951.16136-1-bvanassche@acm.org>
References: <20201209052951.16136-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the BLK_MQ_REQ_PM flag. This flag makes the request allocation
functions set RQF_PM. This is the first step towards removing
BLK_MQ_REQ_PREEMPT.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c       | 7 ++++---
 block/blk-mq.c         | 2 ++
 include/linux/blk-mq.h | 2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2db8bda43b6e..10696f9fb6ac 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -424,11 +424,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
 /**
  * blk_queue_enter() - try to increase q->q_usage_counter
  * @q: request queue pointer
- * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
+ * @flags: BLK_MQ_REQ_NOWAIT, BLK_MQ_REQ_PM and/or BLK_MQ_REQ_PREEMPT
  */
 int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 {
-	const bool pm = flags & BLK_MQ_REQ_PREEMPT;
+	const bool pm = flags & (BLK_MQ_REQ_PM | BLK_MQ_REQ_PREEMPT);
 
 	while (true) {
 		bool success = false;
@@ -630,7 +630,8 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
 	struct request *req;
 
 	WARN_ON_ONCE(op & REQ_NOWAIT);
-	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT));
+	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM |
+			       BLK_MQ_REQ_PREEMPT));
 
 	req = blk_mq_alloc_request(q, op, flags);
 	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1b25ec2fe9be..b5880a1fb38d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -292,6 +292,8 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->mq_hctx = data->hctx;
 	rq->rq_flags = 0;
 	rq->cmd_flags = data->cmd_flags;
+	if (data->flags & BLK_MQ_REQ_PM)
+		rq->rq_flags |= RQF_PM;
 	if (data->flags & BLK_MQ_REQ_PREEMPT)
 		rq->rq_flags |= RQF_PREEMPT;
 	if (blk_queue_io_stat(data->q))
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b23eeca4d677..c00e856c6fb1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -444,6 +444,8 @@ enum {
 	BLK_MQ_REQ_NOWAIT	= (__force blk_mq_req_flags_t)(1 << 0),
 	/* allocate from reserved pool */
 	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
+	/* set RQF_PM */
+	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 2),
 	/* set RQF_PREEMPT */
 	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
 };
