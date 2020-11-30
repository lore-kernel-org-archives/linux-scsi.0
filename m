Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9FDC8301F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B85F208FE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgK3CrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:47:20 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38837 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgK3CrU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 21:47:20 -0500
Received: by mail-pl1-f195.google.com with SMTP id l1so5668763pld.5;
        Sun, 29 Nov 2020 18:47:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dc3KA4G0u9z3zbg3gtVIeoxia8Wwz3LorG0wWR1Dri4=;
        b=jgr95PedbI2gFRo4QAW8UCXcr7kFN0Ewkx2hqKndgmlVGX6oSOJSFAdr01NnA5NfTk
         TobEPNtQhV5M+05KiDA7esHC2jhLamen4ORUOxrPkpoALGun8hTgTJX14GXHr67I+/AI
         v68SwykJqKraCSF5e3fiMqLE305zR3cYO6Yj5JHrUFO9bRDDbVEcU9gJV7PuxX8RcRWv
         yFIWnhJg4byPzEF89F4ZHUmRzpsD9UWwJqoKHW6QiMnE4Qz8MZaUc297fD5A8rtZzxHd
         fSXAGDUURXzu+rWNaitRSHC1dflNhXT1N5ezs506IzMDQA63O3JDcrUjx0q16AbrqCO0
         pjPw==
X-Gm-Message-State: AOAM531D5inuhqVEGCTYGW9+wS4Z8Os7SolZtIKr0yv8x1+mBaEOBZBT
        JsrwtvKU67v0qzwF7AQk7Ik=
X-Google-Smtp-Source: ABdhPJyJ7ksWFc6OJ0sUpV/NchfbjUxUD3qfDaehhekN/A2eMRNW6jZTOTIoDFVSQzC1EYI1CJdLDw==
X-Received: by 2002:a17:90a:f0ce:: with SMTP id fa14mr5735301pjb.156.1606704399300;
        Sun, 29 Nov 2020 18:46:39 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n127sm14734659pfd.143.2020.11.29.18.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 18:46:38 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH v4 8/9] block: Remove RQF_PREEMPT and BLK_MQ_REQ_PREEMPT
Date:   Sun, 29 Nov 2020 18:46:14 -0800
Message-Id: <20201130024615.29171-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130024615.29171-1-bvanassche@acm.org>
References: <20201130024615.29171-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove flag RQF_PREEMPT and BLK_MQ_REQ_PREEMPT since these are no longer
used by any kernel code.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c       | 7 +++----
 block/blk-mq-debugfs.c | 1 -
 block/blk-mq.c         | 2 --
 include/linux/blk-mq.h | 2 --
 include/linux/blkdev.h | 6 +-----
 5 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 10696f9fb6ac..a00bce9f46d8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -424,11 +424,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
 /**
  * blk_queue_enter() - try to increase q->q_usage_counter
  * @q: request queue pointer
- * @flags: BLK_MQ_REQ_NOWAIT, BLK_MQ_REQ_PM and/or BLK_MQ_REQ_PREEMPT
+ * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PM
  */
 int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 {
-	const bool pm = flags & (BLK_MQ_REQ_PM | BLK_MQ_REQ_PREEMPT);
+	const bool pm = flags & BLK_MQ_REQ_PM;
 
 	while (true) {
 		bool success = false;
@@ -630,8 +630,7 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
 	struct request *req;
 
 	WARN_ON_ONCE(op & REQ_NOWAIT);
-	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM |
-			       BLK_MQ_REQ_PREEMPT));
+	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM));
 
 	req = blk_mq_alloc_request(q, op, flags);
 	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 3094542e12ae..9336a6f8d6ef 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -297,7 +297,6 @@ static const char *const rqf_name[] = {
 	RQF_NAME(MIXED_MERGE),
 	RQF_NAME(MQ_INFLIGHT),
 	RQF_NAME(DONTPREP),
-	RQF_NAME(PREEMPT),
 	RQF_NAME(FAILED),
 	RQF_NAME(QUIET),
 	RQF_NAME(ELVPRIV),
diff --git a/block/blk-mq.c b/block/blk-mq.c
index b5880a1fb38d..d50504888b68 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -294,8 +294,6 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->cmd_flags = data->cmd_flags;
 	if (data->flags & BLK_MQ_REQ_PM)
 		rq->rq_flags |= RQF_PM;
-	if (data->flags & BLK_MQ_REQ_PREEMPT)
-		rq->rq_flags |= RQF_PREEMPT;
 	if (blk_queue_io_stat(data->q))
 		rq->rq_flags |= RQF_IO_STAT;
 	INIT_LIST_HEAD(&rq->queuelist);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c00e856c6fb1..88af1df94308 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -446,8 +446,6 @@ enum {
 	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
 	/* set RQF_PM */
 	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 2),
-	/* set RQF_PREEMPT */
-	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 639cae2c158b..7d4b746f7e6a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -79,9 +79,6 @@ typedef __u32 __bitwise req_flags_t;
 #define RQF_MQ_INFLIGHT		((__force req_flags_t)(1 << 6))
 /* don't call prep for this one */
 #define RQF_DONTPREP		((__force req_flags_t)(1 << 7))
-/* set for "ide_preempt" requests and also for requests for which the SCSI
-   "quiesce" state must be ignored. */
-#define RQF_PREEMPT		((__force req_flags_t)(1 << 8))
 /* vaguely specified driver internal error.  Ignored by the block layer */
 #define RQF_FAILED		((__force req_flags_t)(1 << 10))
 /* don't warn about errors */
@@ -430,8 +427,7 @@ struct request_queue {
 	unsigned long		queue_flags;
 	/*
 	 * Number of contexts that have called blk_set_pm_only(). If this
-	 * counter is above zero then only RQF_PM and RQF_PREEMPT requests are
-	 * processed.
+	 * counter is above zero then only RQF_PM requests are processed.
 	 */
 	atomic_t		pm_only;
 
