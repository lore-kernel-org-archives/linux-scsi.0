Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E4DC2BB48
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 05:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4565423B79
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 05:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgLIFbN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 00:31:13 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36920 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbgLIFa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 00:30:59 -0500
Received: by mail-pf1-f195.google.com with SMTP id 11so278228pfu.4;
        Tue, 08 Dec 2020 21:30:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QERdTwjPZ+r8U563wLHeA0G6+1BAJ6muqEYRyeBxvOU=;
        b=NIflJkJYmeJjWZHRFIZwjgl2iJsh8RCeAxpZO88X5CQF1Yg5hhsxDnLQuP2XMNbLYm
         S6Exx5PaxFM440NJiRMOh2RjsxSi+8N87Mp+rHX9V9mlyKtUlxuPyJOLpTd95ePyraQh
         u7VHz+uhsDJZ/XcAogSYBWg3qdEkIoTOTdt+9eOIINby8hAFNrNHDyYwH0k9ZS2ZDZem
         qU9UhQ7xnby4IGERX6Qdi1z9rFi6bJ6FA6lTxqCkAezTsDQ/DaWN+CIpCi5AlDEZuYUD
         EqD0YRoqvo3QUc46iJ8ninBpjw1vSxW8mIFAUDYjji3oL34BuNFv+ff7hbYUx7IWj/2R
         BcAw==
X-Gm-Message-State: AOAM533KGrpT6551+fOjyEZh17V0ryvVSr1WLA4FtcX2lIbRpz9/6Trt
        aO10VKHtRuSDGfzG2fq8oLY=
X-Google-Smtp-Source: ABdhPJzdKLdHse0zbZFzgJSfw/TcX1bQsoXL2I8C2Yq1TQDhKKEMX2GTdfewFDpXKqBXnWkGX5HnLg==
X-Received: by 2002:a63:d618:: with SMTP id q24mr486419pgg.171.1607491817740;
        Tue, 08 Dec 2020 21:30:17 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id 77sm753097pfv.16.2020.12.08.21.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 21:30:16 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Subject: [PATCH v5 8/8] block: Do not accept any requests while suspended
Date:   Tue,  8 Dec 2020 21:29:51 -0800
Message-Id: <20201209052951.16136-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209052951.16136-1-bvanassche@acm.org>
References: <20201209052951.16136-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

blk_queue_enter() accepts BLK_MQ_REQ_PM requests independent of the runtime
power management state. Now that SCSI domain validation no longer depends
on this behavior, modify the behavior of blk_queue_enter() as follows:
- Do not accept any requests while suspended.
- Only process power management requests while suspending or resuming.

Submitting BLK_MQ_REQ_PM requests to a device that is runtime suspended
causes runtime-suspended devices not to resume as they should. The request
which should cause a runtime resume instead gets issued directly, without
resuming the device first. Of course the device can't handle it properly,
the I/O fails, and the device remains suspended.

The problem is fixed by checking that the queue's runtime-PM status
isn't RPM_SUSPENDED before allowing a request to be issued, and
queuing a runtime-resume request if it is.  In particular, the inline
blk_pm_request_resume() routine is renamed blk_pm_resume_queue() and
the code is unified by merging the surrounding checks into the
routine.  If the queue isn't set up for runtime PM, or there currently
is no restriction on allowed requests, the request is allowed.
Likewise if the BLK_MQ_REQ_PM flag is set and the status isn't
RPM_SUSPENDED.  Otherwise a runtime resume is queued and the request
is blocked until conditions are more suitable.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-and-tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
[ bvanassche: modified commit message and removed Cc: stable because without
  the previous patches from this series this patch would break parallel SCSI
  domain validation + introduced queue_rpm_status() ]
---
 block/blk-core.c       |  7 ++++---
 block/blk-pm.h         | 14 +++++++++-----
 include/linux/blkdev.h | 12 ++++++++++++
 3 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a00bce9f46d8..2d53e2ff48ff 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -18,6 +18,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
+#include <linux/blk-pm.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -440,7 +441,8 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 			 * responsible for ensuring that that counter is
 			 * globally visible before the queue is unfrozen.
 			 */
-			if (pm || !blk_queue_pm_only(q)) {
+			if ((pm && queue_rpm_status(q) != RPM_SUSPENDED) ||
+			    !blk_queue_pm_only(q)) {
 				success = true;
 			} else {
 				percpu_ref_put(&q->q_usage_counter);
@@ -465,8 +467,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 
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
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7d4b746f7e6a..2b6fc3fb3a99 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -692,6 +692,18 @@ static inline bool queue_is_mq(struct request_queue *q)
 	return q->mq_ops;
 }
 
+#ifdef CONFIG_PM
+static inline enum rpm_status queue_rpm_status(struct request_queue *q)
+{
+	return q->rpm_status;
+}
+#else
+static inline enum rpm_status queue_rpm_status(struct request_queue *q)
+{
+	return RPM_ACTIVE;
+}
+#endif
+
 static inline enum blk_zoned_model
 blk_queue_zoned_model(struct request_queue *q)
 {
