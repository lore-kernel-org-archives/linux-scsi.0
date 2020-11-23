Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393FAC83010
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 145642137B
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 03:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgKWDSS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Nov 2020 22:18:18 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37714 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbgKWDSR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2020 22:18:17 -0500
Received: by mail-pg1-f195.google.com with SMTP id m9so12949683pgb.4;
        Sun, 22 Nov 2020 19:18:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KVnaEA5kAS4cHMBBox7CEs5AP6+C4gzdSyfpNzEu5DE=;
        b=iI6VxlJ2NH1uQccJOp/o6fTUImxQSieZlkzxuEe3ZTB2cYqVBKrFFxBY+ZmfyKlZjB
         KkFpjJW4NnxDdDl/PKaZ9OYHbO9pbNqbPS2oubAV4t7QzllMG9EMQsTzQmOX6uv0NM8D
         3DVLQJGhFGyeiZ6RYccOJCYVWx36zMytANpnoYoJx1udMrnj9EIy9Hov2Yoz1QlBSvDb
         ZnDSS0nmLB+GDE+xg3F/Go22byTR1qaACtBdvMWmQcG0arKgLCCDM0aqJznnB01B2MgN
         Q5qzUxnRWz4IpQu7kBNwrgEFNkbr5Xs1I8vvjaxoBgbia1TlUPIkZ3EuuJY2r0ijZ6WP
         6BYw==
X-Gm-Message-State: AOAM5334wwmYjDsGRn7vgFC62tXjMk0aKHDiiEfJpm2qfuP+wE5w9p/j
        69Cczx1VJTinunnP0w+R8Nw=
X-Google-Smtp-Source: ABdhPJwtEsQDoaXeoMGHVReArG7ctyVQziWFqzT2Kv3APElImPctfyfOGfa0yEkC9F1gIFuwl+beTQ==
X-Received: by 2002:a63:455e:: with SMTP id u30mr3772242pgk.113.1606101496223;
        Sun, 22 Nov 2020 19:18:16 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w12sm3578751pfn.136.2020.11.22.19.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 19:18:15 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH v3 9/9] block: Do not accept any requests while suspended
Date:   Sun, 22 Nov 2020 19:17:49 -0800
Message-Id: <20201123031749.14912-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123031749.14912-1-bvanassche@acm.org>
References: <20201123031749.14912-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

blk_queue_enter() accepts BLK_MQ_REQ_PREEMPT independent of the runtime
power management state. Since SCSI domain validation no longer depends on
this behavior, modify the behavior of blk_queue_enter() as follows:
- Do not accept any requests while suspended.
- Only process power management requests while suspending or resuming.

Submitting BLK_MQ_REQ_PREEMPT requests to a device that is runtime-
suspended causes runtime-suspended block devices not to resume as they
should. The request which should cause a runtime resume instead gets
issued directly, without resuming the device first. Of course the device
can't handle it properly, the I/O fails, and the device remains suspended.

The problem is fixed by checking that the queue's runtime-PM status
isn't RPM_SUSPENDED before allowing a request to be issued, and
queuing a runtime-resume request if it is.  In particular, the inline
blk_pm_request_resume() routine is renamed blk_pm_resume_queue() and
the code is unified by merging the surrounding checks into the
routine.  If the queue isn't set up for runtime PM, or there currently
is no restriction on allowed requests, the request is allowed.
Likewise if the BLK_MQ_REQ_PREEMPT flag is set and the status isn't
RPM_SUSPENDED.  Otherwise a runtime resume is queued and the request
is blocked until conditions are more suitable.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-and-tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
[ bvanassche: modified commit message and removed Cc: stable because without
  the previous patches from this series this patch would break parallel SCSI
  domain validation ]
---
 block/blk-core.c |  6 +++---
 block/blk-pm.h   | 14 +++++++++-----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a00bce9f46d8..230880cbf8c8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -440,7 +440,8 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 			 * responsible for ensuring that that counter is
 			 * globally visible before the queue is unfrozen.
 			 */
-			if (pm || !blk_queue_pm_only(q)) {
+			if ((pm && q->rpm_status != RPM_SUSPENDED) ||
+			    !blk_queue_pm_only(q)) {
 				success = true;
 			} else {
 				percpu_ref_put(&q->q_usage_counter);
@@ -465,8 +466,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 
 		wait_event(q->mq_freeze_wq,
 			   (!q->mq_freeze_depth &&
-			    (pm || (blk_pm_request_resume(q),
-				    !blk_queue_pm_only(q)))) ||
+			    blk_pm_resume_queue(pm, q)) ||
 			   blk_queue_dying(q));
 		if (blk_queue_dying(q))
 			return -ENODEV;
diff --git a/block/blk-pm.h b/block/blk-pm.h
index ea5507d23e75..a2283cc9f716 100644
--- a/block/blk-pm.h
+++ b/block/blk-pm.h
@@ -6,11 +6,14 @@
 #include <linux/pm_runtime.h>
 
 #ifdef CONFIG_PM
-static inline void blk_pm_request_resume(struct request_queue *q)
+static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
 {
-	if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
-		       q->rpm_status == RPM_SUSPENDING))
-		pm_request_resume(q->dev);
+	if (!q->dev || !blk_queue_pm_only(q))
+		return 1;	/* Nothing to do */
+	if (pm && q->rpm_status != RPM_SUSPENDED)
+		return 1;	/* Request allowed */
+	pm_request_resume(q->dev);
+	return 0;
 }
 
 static inline void blk_pm_mark_last_busy(struct request *rq)
@@ -44,8 +47,9 @@ static inline void blk_pm_put_request(struct request *rq)
 		--rq->q->nr_pending;
 }
 #else
-static inline void blk_pm_request_resume(struct request_queue *q)
+static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
 {
+	return 1;
 }
 
 static inline void blk_pm_mark_last_busy(struct request *rq)
