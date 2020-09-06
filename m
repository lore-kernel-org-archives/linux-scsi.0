Return-Path: <SRS0=a8U3=CP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16C1C43461
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB7020797
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgIFBWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 21:22:51 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44875 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728887AbgIFBWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 21:22:42 -0400
Received: by mail-pg1-f196.google.com with SMTP id 7so6267833pgm.11;
        Sat, 05 Sep 2020 18:22:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vzqwbvuEI0MUhU8xoJagSYikuR6h4EfX4KZRl8Z2nRE=;
        b=be2d8BktjGVZhGonAXyd9a2BOitu+sTzFq3hUzzRBapiboSZHoN8PiQuU1zh82oYzg
         Bw0IRcNykhzE5n5b0qCpbqfx4f6V5VAvRiGKqjy8DRILccDbPxWyC0TAmw4+Z5WMb7BI
         HGvq+9teKv5iaiUxrmWaMXnLciclad7IJRi7VVc2lpqjELHusYzh3IcFNYJuOIvxlZ8h
         g1mOQB1g/yQldHZ+wEaLjidwEIXrm5PAA6PpAkgC5rwUFks+sVdz6x+oYjE0oChsx7/H
         yLE4GH1Ney27LbLeols7jopjd8JQrlgnPW+oHvUNJ5JCd+PXk87fcbrQUaoiEwikPi57
         hjZQ==
X-Gm-Message-State: AOAM531aOa3TkA+R093Cy7mugz7l9qQeHCSGTNsJRWJ42L8ZvE6fDRM/
        riCxksP3knLt+EQAsaBiqINMCX/n3WA=
X-Google-Smtp-Source: ABdhPJwBbiTvZMj3ugSNOtOgzrsTYXIkmvVKxjy29lc9pPmPonlkUE5TKQJwkZ8J+U/xPgtVpK4TQg==
X-Received: by 2002:a63:a08:: with SMTP id 8mr11182601pgk.300.1599355360874;
        Sat, 05 Sep 2020 18:22:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:cd46:435a:ac98:84de])
        by smtp.gmail.com with ESMTPSA id 25sm3585165pjh.57.2020.09.05.18.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 18:22:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH 9/9] block: Do not accept any requests while suspended
Date:   Sat,  5 Sep 2020 18:22:19 -0700
Message-Id: <20200906012219.17893-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200906012219.17893-1-bvanassche@acm.org>
References: <20200906012219.17893-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
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

Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
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
index c5a2f8173b1f..22c1c6e6c0e1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -436,7 +436,8 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 			 * responsible for ensuring that that counter is
 			 * globally visible before the queue is unfrozen.
 			 */
-			if (pm || !blk_queue_pm_only(q)) {
+			if ((pm && q->rpm_status != RPM_SUSPENDED) ||
+			    !blk_queue_pm_only(q)) {
 				success = true;
 			} else {
 				percpu_ref_put(&q->q_usage_counter);
@@ -461,8 +462,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 
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
