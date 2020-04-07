Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BBD4C2BB86
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 22:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BD9320747
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 22:00:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DoMYYcsn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgDGWAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 18:00:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35434 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgDGWAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2020 18:00:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id k5so2380088pga.2
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2020 15:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Me9YjeaVzWgazxTUthRuKJI46sDGdqwI3du7HWGuOE8=;
        b=DoMYYcsntVvHTK2oXwnp3vDDbf3nT3otp0Pm+CFLtccf3kJadBX/hZRhcI+IUM7OHu
         9GtnDCkyi0neXGAopex9ODL02nb2SkLNI9F9jFhOpGDWQH8JSCPaQyp2PFwBCyKzwP31
         RESBufGdSgg25ZKaFUfV1vNerMXA6d58coYtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Me9YjeaVzWgazxTUthRuKJI46sDGdqwI3du7HWGuOE8=;
        b=YYesFV9yFX70LpjC4TsUi76m1vkddN5m/+/qtmndLSvjW4AW6IhT6pyQv9gTAznrzy
         rCUUd+YatXcsabaIu+9vN1wCj1mgJjPDzpbCmf9D/IE8hRlSs3DdB2NPA1x2VQ+U1c5T
         MptdJCFa9syQ6qyqSWeLWrgT8SwflBDSTpVLb9MluvX6hvXGpZGkCQI64U8RVMurFLSZ
         c8iiWot9eb6DceNRzQScSdY2g/4DGgeCnlWcPZrblAtBP1557fMfIVcqyvCk0rP8LAKu
         kPHJRa3syZtOMedBmyPGuijEjnU2tttzSM9BnVR87y/5n+CmLdQopR2LlofNpeRWmKBr
         LXgw==
X-Gm-Message-State: AGi0PuZdw4hKe7DviDgG9VHIWr9vn5kGMJZCWd6k+36yWBsmivD5ix4G
        F8Fg+pY+skGE7Wzs8eUiomjZbA==
X-Google-Smtp-Source: APiQypIc2emGqDVPItIPl9ujfmle5KLS4GyLNUOKdjuBUMmxWIOMYhRxDK6Fup63PD2P+ZhrpVonLQ==
X-Received: by 2002:a63:c06:: with SMTP id b6mr4046203pgl.218.1586296841645;
        Tue, 07 Apr 2020 15:00:41 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id g3sm880112pgd.64.2020.04.07.15.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 15:00:41 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        sqazi@google.com, Gwendal Grignou <gwendal@chromium.org>,
        groeck@chromium.org, linux-block@vger.kernel.org,
        paolo.valente@linaro.org, Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] blk-mq: Rerun dispatching in the case of budget contention
Date:   Tue,  7 Apr 2020 15:00:04 -0700
Message-Id: <20200407145906.v3.3.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
In-Reply-To: <20200407220005.119540-1-dianders@chromium.org>
References: <20200407220005.119540-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If ever a thread running blk-mq code tries to get budget and fails it
immediately stops doing work and assumes that whenever budget is freed
up that queues will be kicked and whatever work the thread was trying
to do will be tried again.

One path where budget is freed and queues are kicked in the normal
case can be seen in scsi_finish_command().  Specifically:
- scsi_finish_command()
  - scsi_device_unbusy()
    - # Decrement "device_busy", AKA release budget
  - scsi_io_completion()
    - scsi_end_request()
      - blk_mq_run_hw_queues()

The above is all well and good.  The problem comes up when a thread
claims the budget but then releases it without actually dispatching
any work.  Since we didn't schedule any work we'll never run the path
of finishing work / kicking the queues.

This isn't often actually a problem which is why this issue has
existed for a while and nobody noticed.  Specifically we only get into
this situation when we unexpectedly found that we weren't going to do
any work.  Code that later receives new work kicks the queues.  All
good, right?

The problem shows up, however, if timing is just wrong and we hit a
race.  To see this race let's think about the case where we only have
a budget of 1 (only one thread can hold budget).  Now imagine that a
thread got budget and then decided not to dispatch work.  It's about
to call put_budget() but then the thread gets context switched out for
a long, long time.  While in this state, any and all kicks of the
queue (like the when we received new work) will be no-ops because
nobody can get budget.  Finally the thread holding budget gets to run
again and returns.  All the normal kicks will have been no-ops and we
have an I/O stall.

As you can see from the above, you need just the right timing to see
the race.  To start with, the only case it happens if we thought we
had work, actually managed to get the budget, but then actually didn't
have work.  That's pretty rare to start with.  Even then, there's
usually a very small amount of time between realizing that there's no
work and putting the budget.  During this small amount of time new
work has to come in and the queue kick has to make it all the way to
trying to get the budget and fail.  It's pretty unlikely.

One case where this could have failed is illustrated by an example of
threads running blk_mq_do_dispatch_sched():

* Threads A and B both run has_work() at the same time with the same
  "hctx".  Imagine has_work() is exact.  There's no lock, so it's OK
  if Thread A and B both get back true.
* Thread B gets interrupted for a long time right after it decides
  that there is work.  Maybe its CPU gets an interrupt and the
  interrupt handler is slow.
* Thread A runs, get budget, dispatches work.
* Thread A's work finishes and budget is released.
* Thread B finally runs again and gets budget.
* Since Thread A already took care of the work and no new work has
  come in, Thread B will get NULL from dispatch_request().  I believe
  this is specifically why dispatch_request() is allowed to return
  NULL in the first place if has_work() must be exact.
* Thread B will now be holding the budget and is about to call
  put_budget(), but hasn't called it yet.
* Thread B gets interrupted for a long time (again).  Dang interrupts.
* Now Thread C (maybe with a different "hctx" but the same queue)
  comes along and runs blk_mq_do_dispatch_sched().
* Thread C won't do anything because it can't get budget.
* Finally Thread B will run again and put the budget without kicking
  any queues.

Even though the example above is with blk_mq_do_dispatch_sched() I
believe the race is possible any time someone is holding budget but
doesn't do work.

Unfortunately, the unlikely has become more likely if you happen to be
using the BFQ I/O scheduler.  BFQ, by design, sometimes returns "true"
for has_work() but then NULL for dispatch_request() and stays in this
state for a while (currently up to 9 ms).  Suddenly you only need one
race to hit, not two races in a row.  With my current setup this is
easy to reproduce in reboot tests and traces have actually shown that
we hit a race similar to the one describe above.

In theory we could choose to just fix blk_mq_do_dispatch_sched() to
kick the queues when it puts budget.  That would fix the BFQ case and
one could argue that all the other cases are just theoretical.  While
that is true, for all the other cases it should be very uncommon to
run into the case where we need put_budget().  Having an extra queue
kick for safety there shouldn't affect much and keeps the race at bay.

One last note is that (at least in the SCSI case) budget is shared by
all "hctx"s that have the same queue.  Thus we need to make sure to
kick the whole queue, not just re-run dispatching on a single "hctx".

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

Changes in v3:
- Always kick when putting the budget.
- Delay blk_mq_do_dispatch_sched() kick by 3 ms for inexact has_work().
- Totally rewrote commit message.

Changes in v2:
- Replace ("scsi: core: Fix stall...") w/ ("blk-mq: Rerun dispatch...")

 block/blk-mq.h | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.h b/block/blk-mq.h
index 10bfdfb494fa..1270505367ab 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -180,12 +180,24 @@ unsigned int blk_mq_in_flight(struct request_queue *q, struct hd_struct *part);
 void blk_mq_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 			 unsigned int inflight[2]);
 
+#define BLK_MQ_BUDGET_DELAY	3		/* ms units */
+
 static inline void blk_mq_put_dispatch_budget(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 
-	if (q->mq_ops->put_budget)
+	if (q->mq_ops->put_budget) {
 		q->mq_ops->put_budget(hctx);
+
+		/*
+		 * The only time we call blk_mq_put_dispatch_budget() is if
+		 * we released the budget without dispatching.  Holding the
+		 * budget could have blocked any "hctx"s with the same queue
+		 * and if we didn't dispatch then there's no guarantee anyone
+		 * will kick the queue.  Kick it ourselves.
+		 */
+		blk_mq_delay_run_hw_queues(q, BLK_MQ_BUDGET_DELAY);
+	}
 }
 
 static inline bool blk_mq_get_dispatch_budget(struct blk_mq_hw_ctx *hctx)
-- 
2.26.0.292.g33ef6b2f38-goog

