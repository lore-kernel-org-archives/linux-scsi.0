Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9311FC83013
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DD7120771
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 02:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgK3CrN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:47:13 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39705 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgK3CrN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2020 21:47:13 -0500
Received: by mail-pg1-f195.google.com with SMTP id f17so9195671pge.6;
        Sun, 29 Nov 2020 18:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ek/NBMowVicklCRXVtMA4IKHziAJguvbGxIIObE1pyI=;
        b=aPhmzYjEV0HFm0FYhdENZ9Br/A/liFzsWaWNas7S8dZKmqWsOvzhTV73XsCJ9pu+zn
         2IbMJpUmTo3+qv5Ffs21ybHh9TizAJOk/IA4PiiiPRfD+R4SaVIJ7XFTRhDl/0dGQuHU
         VNEEN/nPCOZRPkAVvI5hE1JK7X8hzcAAiEZcFEbQ7IT8mRQWQ5vfIr37TtGgiulQKCI7
         wskxd5194PbVk5Auz9bpulVvKJePPAPlDaSvgI73b2Xpap0UMaKy8JDveea+EsYnTIqp
         m43hgrbxprspigqXA3xSliOMEEzCTLFThkkosyOB/TvLL2XBGFQ89ydwI+2II1qI5Pv+
         aEOg==
X-Gm-Message-State: AOAM533NZ0M4lPUF9tscug4SHjazxq+KdftdXQinKpVix3zzQF5eGdES
        TN9bHtXGwNaPQQ9ERPaWbD5uVJ004DE=
X-Google-Smtp-Source: ABdhPJzS03gqauwE4QVphlrDXH3dcEVGnM0Bu+xstROCnJYuLDZAlvhftznD8uhaOcIYkIJ0lmps1g==
X-Received: by 2002:aa7:8c12:0:b029:18b:9939:9798 with SMTP id c18-20020aa78c120000b029018b99399798mr16668116pfd.44.1606704386704;
        Sun, 29 Nov 2020 18:46:26 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n127sm14734659pfd.143.2020.11.29.18.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 18:46:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Hannes Reinecke <hare@suse.de>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Can Guo <cang@codeaurora.org>
Subject: [PATCH v4 2/9] block: Introduce BLK_MQ_REQ_PM
Date:   Sun, 29 Nov 2020 18:46:08 -0800
Message-Id: <20201130024615.29171-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130024615.29171-1-bvanassche@acm.org>
References: <20201130024615.29171-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the BLK_MQ_REQ_PM flag. This flag makes the request allocation
functions set RQF_PM. This is the first step towards removing
BLK_MQ_REQ_PREEMPT.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
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
