Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0261C2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DF88206F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NrKiFeVe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgDHPEi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:04:38 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39452 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbgDHPEi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 11:04:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id g32so3430409pgb.6
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2020 08:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rDHN9ShJvPz0UC+OvvEBSbpZQdwfsROoxRdOsJpjLv0=;
        b=NrKiFeVelll9pTVVnyYFbqtfExMtVh9jG1XxNcax63V2iOlogbNMp3Tei7cfflKCek
         GYDuk5PEV9I8dDqHAY9YG1Vp9pBlhF5q6Qxx+PZ25NwD32oV7ly/smcvVwYqzoKzFJ8K
         T7M04Zq7jhH203yIWAec05bIeAoT78enlp82E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rDHN9ShJvPz0UC+OvvEBSbpZQdwfsROoxRdOsJpjLv0=;
        b=NbdMj9LYaWSr9tR7TfMfqtUgAMlcfs5YJ5bBqZ/2FmiVW0RO0QLCZoOXZEM0UJhHAv
         YavJSs9wLr9cxJc68ajD5xZ4qSQ+ZMGmDNG/tKkBKjNaZQIAzqj3wFCIdd3f3DYRhhh7
         beoaIhQpkNfQMfpImRDdgOr2sHFMFdr8LsFZMGrbWjMlWeGzklWaYdruMrnz84Y2tL1d
         9RzXqz//V3SmkZUfi87dcec5rCRT10drSil0NR7S8CnRPSz5XzQEbTcuTVUcEZzRMlV1
         64P5/IrVQ80BcC0yMYy6klXX+MgEVsILMLE+irlsd2MgVs+Ks3KKUAgYjFnBTgJiOLun
         gdZA==
X-Gm-Message-State: AGi0PuZ8d27PwiZJfD4l4ivsRhJ19NUvRk960gwDxHIzbiQ/xsMCxWhe
        4S9dCse5sRnmI+Hu63/LdwTETw==
X-Google-Smtp-Source: APiQypKN4PhmLudiD/Afa/12hEX5RZJfGx8y/CDaW//mijPLTlSOZHQWy/kAxIiXMEPac8OZx+b8wA==
X-Received: by 2002:a63:54e:: with SMTP id 75mr6795145pgf.398.1586358275351;
        Wed, 08 Apr 2020 08:04:35 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id d85sm1468083pfd.157.2020.04.08.08.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 08:04:34 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     paolo.valente@linaro.org, groeck@chromium.org,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, sqazi@google.com,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/4] blk-mq: Rerun dispatching in the case of budget contention
Date:   Wed,  8 Apr 2020 08:04:01 -0700
Message-Id: <20200408080255.v4.3.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
In-Reply-To: <20200408150402.21208-1-dianders@chromium.org>
References: <20200408150402.21208-1-dianders@chromium.org>
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
we hit a race similar to the one described above.

Note that we only need to fix blk_mq_do_dispatch_sched() and
blk_mq_do_dispatch_ctx() and not the other places that put budget.  In
other cases we know that we have work to do on at least one "hctx" and
code already exists to kick that "hctx"'s queue.  When that work
finally finishes all the queues will be kicked using the normal flow.

One last note is that (at least in the SCSI case) budget is shared by
all "hctx"s that have the same queue.  Thus we need to make sure to
kick the whole queue, not just re-run dispatching on a single "hctx".

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

Changes in v4:
- Only kick in blk_mq_do_dispatch_ctx() / blk_mq_do_dispatch_sched().

Changes in v3:
- Always kick when putting the budget.
- Delay blk_mq_do_dispatch_sched() kick by 3 ms for inexact has_work().
- Totally rewrote commit message.

Changes in v2:
- Replace ("scsi: core: Fix stall...") w/ ("blk-mq: Rerun dispatch...")

 block/blk-mq-sched.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 74cedea56034..eca81bd4010c 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -80,6 +80,8 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
 	blk_mq_run_hw_queue(hctx, true);
 }
 
+#define BLK_MQ_BUDGET_DELAY	3		/* ms units */
+
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
@@ -103,6 +105,14 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
 		rq = e->type->ops.dispatch_request(hctx);
 		if (!rq) {
 			blk_mq_put_dispatch_budget(hctx);
+			/*
+			 * We're releasing without dispatching. Holding the
+			 * budget could have blocked any "hctx"s with the
+			 * same queue and if we didn't dispatch then there's
+			 * no guarantee anyone will kick the queue.  Kick it
+			 * ourselves.
+			 */
+			blk_mq_delay_run_hw_queues(q, BLK_MQ_BUDGET_DELAY);
 			break;
 		}
 
@@ -149,6 +159,14 @@ static void blk_mq_do_dispatch_ctx(struct blk_mq_hw_ctx *hctx)
 		rq = blk_mq_dequeue_from_ctx(hctx, ctx);
 		if (!rq) {
 			blk_mq_put_dispatch_budget(hctx);
+			/*
+			 * We're releasing without dispatching. Holding the
+			 * budget could have blocked any "hctx"s with the
+			 * same queue and if we didn't dispatch then there's
+			 * no guarantee anyone will kick the queue.  Kick it
+			 * ourselves.
+			 */
+			blk_mq_delay_run_hw_queues(q, BLK_MQ_BUDGET_DELAY);
 			break;
 		}
 
-- 
2.26.0.292.g33ef6b2f38-goog

