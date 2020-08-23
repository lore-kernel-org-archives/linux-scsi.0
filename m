Return-Path: <SRS0=1Iot=CB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FE3C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Aug 2020 14:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B72C2078D
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Aug 2020 14:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgHWO5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Aug 2020 10:57:37 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54133 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725996AbgHWO5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Aug 2020 10:57:34 -0400
Received: (qmail 304437 invoked by uid 1000); 23 Aug 2020 10:57:33 -0400
Date:   Sun, 23 Aug 2020 10:57:33 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Jens Axboe <axboe@kernel.dk>,
        Martin Kepplinger <martin.kepplinger@puri.sm>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, kernel@puri.sm
Subject: [PATCH] block: Fix bug in runtime-resume handling
Message-ID: <20200823145733.GC303967@rowland.harvard.edu>
References: <9b80ca7c-39f8-e52d-2535-8b0baf93c7d1@puri.sm>
 <425990b3-4b0b-4dcf-24dc-4e7e60d5869d@puri.sm>
 <20200807143002.GE226516@rowland.harvard.edu>
 <b0abab28-880e-4b88-eb3c-9ffd927d1ed9@puri.sm>
 <20200808150542.GB256751@rowland.harvard.edu>
 <d3b6f7b8-5345-1ae1-4f79-5dde226e74f1@puri.sm>
 <20200809152643.GA277165@rowland.harvard.edu>
 <60150284-be13-d373-5448-651b72a7c4c9@puri.sm>
 <20200810141343.GA299045@rowland.harvard.edu>
 <6f0c530f-4309-ab1e-393b-83bf8367f59e@puri.sm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f0c530f-4309-ab1e-393b-83bf8367f59e@puri.sm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Runtime power-management support in the block layer has somehow gotten
messed up in the past few years.  This area of code has been through a
lot of churn and it's not easy to track exactly when the bug addressed
here was introduced; it was present for a while, then fixed for a
while, and then it returned.

At any rate, the problem is that the block layer code thinks that it's
okay to issue a request with the BLK_MQ_REQ_PREEMPT flag set at any
time, even when the queue and underlying device are runtime suspended.
This belief is wrong; the flag merely indicates that it's okay to
issue the request while the queue and device are in the process of
suspending or resuming.  When they are actually suspended, no requests
may be issued.

The symptom of this bug is that a runtime-suspended block device
doesn't resume as it should.  The request which should cause a runtime
resume instead gets issued directly, without resuming the device
first.  Of course the device can't handle it properly, the I/O
fails, and the device remains suspended.

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

Reported-and-tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Bart Van Assche <bvanassche@acm.org>
CC: <stable@vger.kernel.org> # 5.2

---

The bug goes back way before 5.2, but other changes will prevent the
patch from applying directly to earlier kernels, so I'm limiting the 
@stable updates to 5.2 and after.


[as1941]


 block/blk-core.c |    6 +++---
 block/blk-pm.h   |   14 +++++++++-----
 2 files changed, 12 insertions(+), 8 deletions(-)

Index: usb-devel/block/blk-core.c
===================================================================
--- usb-devel.orig/block/blk-core.c
+++ usb-devel/block/blk-core.c
@@ -423,7 +423,8 @@ int blk_queue_enter(struct request_queue
 			 * responsible for ensuring that that counter is
 			 * globally visible before the queue is unfrozen.
 			 */
-			if (pm || !blk_queue_pm_only(q)) {
+			if ((pm && q->rpm_status != RPM_SUSPENDED) ||
+			    !blk_queue_pm_only(q)) {
 				success = true;
 			} else {
 				percpu_ref_put(&q->q_usage_counter);
@@ -448,8 +449,7 @@ int blk_queue_enter(struct request_queue
 
 		wait_event(q->mq_freeze_wq,
 			   (!q->mq_freeze_depth &&
-			    (pm || (blk_pm_request_resume(q),
-				    !blk_queue_pm_only(q)))) ||
+			    blk_pm_resume_queue(pm, q)) ||
 			   blk_queue_dying(q));
 		if (blk_queue_dying(q))
 			return -ENODEV;
Index: usb-devel/block/blk-pm.h
===================================================================
--- usb-devel.orig/block/blk-pm.h
+++ usb-devel/block/blk-pm.h
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
@@ -44,8 +47,9 @@ static inline void blk_pm_put_request(st
 		--rq->q->nr_pending;
 }
 #else
-static inline void blk_pm_request_resume(struct request_queue *q)
+static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
 {
+	return 1;
 }
 
 static inline void blk_pm_mark_last_busy(struct request *rq)
