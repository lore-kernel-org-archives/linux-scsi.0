Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A0EC2D0F3
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 15:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2568220737
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 15:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oXd2fQ64"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389544AbgDBPwQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 11:52:16 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:38359 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389464AbgDBPwH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 11:52:07 -0400
Received: by mail-pf1-f172.google.com with SMTP id c21so1942588pfo.5
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2020 08:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Q3jBwdmyUkdTL07RQ4evpZO2DzG9gMebwuAt0SZP0k=;
        b=oXd2fQ64qrNWa66OlP7Ra3x06XYTxk19Ian0YyjvHZj5/xAdfi6Rn+rhULcFiJJkFA
         xrhIx+PkuvI+401s9kuz3pEQfYye0k4XFNSTEoyu5ksbpOWYrAuxoYBh5NHO6bQjYIPH
         MVgOr6xCzmp/PtPuWeAYDTYLg0N6T5ue/nISU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Q3jBwdmyUkdTL07RQ4evpZO2DzG9gMebwuAt0SZP0k=;
        b=rdJNb8FihE/5u2CZQ1L+OF254o2RlGHdKO9ksom8D6NC4cbNr7lo8UApbutjjTASl0
         layG5es2uv0B4o1paOYapFZSDvsO5hi1q7SsxT4Vr2Pj0+z39d7yXTXigVvq0iM6n9Ae
         grtBWErjZFanu0Iig4uQaHZHAAdN80tzd1lJfqCTuHLuXJuB2duTw6LISQBTAYULT/jO
         OzG96Iu+JQydqi//j09Maz+gZQJzg70vh3bGKjUiUmqiVl5NkKW614U5lIVfU5tMjtmU
         l/QEeCYxgH7vcXPnd2xMAZsleauZUBsoKw9fs+BkirzDmRDYuPwyI2hK5ltQthCIbLyc
         qBSA==
X-Gm-Message-State: AGi0PuapqtPif+YargcWENnzGACpqObrqWBMjJvC+8F3vQDyR34FTz4i
        xs/2snE7KEz2lTIOf0siMBtgnw==
X-Google-Smtp-Source: APiQypLIOJvFZ3n8tsGjP8rKreVP3/DZYTDGeAQSmvs04KJAkllBKQ3g3zeXbEbSSbGmDvAMgnIiOw==
X-Received: by 2002:aa7:9dc1:: with SMTP id g1mr3832763pfq.308.1585842726489;
        Thu, 02 Apr 2020 08:52:06 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id x68sm2578815pfb.5.2020.04.02.08.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 08:52:05 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     paolo.valente@linaro.org, sqazi@google.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, groeck@chromium.org,
        Douglas Anderson <dianders@chromium.org>,
        Ajay Joshi <ajay.joshi@wdc.com>, Arnd Bergmann <arnd@arndb.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hou Tao <houtao1@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] blk-mq: Rerun dispatching in the case of budget contention
Date:   Thu,  2 Apr 2020 08:51:30 -0700
Message-Id: <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
In-Reply-To: <20200402155130.8264-1-dianders@chromium.org>
References: <20200402155130.8264-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is possible for two threads to be running
blk_mq_do_dispatch_sched() at the same time with the same "hctx".
This is because there can be more than one caller to
__blk_mq_run_hw_queue() with the same "hctx" and hctx_lock() doesn't
prevent more than one thread from entering.

If more than one thread is running blk_mq_do_dispatch_sched() at the
same time with the same "hctx", they may have contention acquiring
budget.  The blk_mq_get_dispatch_budget() can eventually translate
into scsi_mq_get_budget().  If the device's "queue_depth" is 1 (not
uncommon) then only one of the two threads will be the one to
increment "device_busy" to 1 and get the budget.

The losing thread will break out of blk_mq_do_dispatch_sched() and
will stop dispatching requests.  The assumption is that when more
budget is available later (when existing transactions finish) the
queue will be kicked again, perhaps in scsi_end_request().

The winning thread now has budget and can go on to call
dispatch_request().  If dispatch_request() returns NULL here then we
have a potential problem.  Specifically we'll now call
blk_mq_put_dispatch_budget() which translates into
scsi_mq_put_budget().  That will mark the device as no longer busy but
doesn't do anything to kick the queue.  This violates the assumption
that the queue would be kicked when more budget was available.

Pictorially:

Thread A                          Thread B
================================= ==================================
blk_mq_get_dispatch_budget() => 1
dispatch_request() => NULL
                                  blk_mq_get_dispatch_budget() => 0
                                  // because Thread A marked
                                  // "device_busy" in scsi_device
blk_mq_put_dispatch_budget()

The above case was observed in reboot tests and caused a task to hang
forever waiting for IO to complete.  Traces showed that in fact two
tasks were running blk_mq_do_dispatch_sched() at the same time with
the same "hctx".  The task that got the budget did in fact see
dispatch_request() return NULL.  Both tasks returned and the system
went on for several minutes (until the hung task delay kicked in)
without the given "hctx" showing up again in traces.

Let's attempt to fix this problem by detecting if there was contention
for the budget in the case where we put the budget without dispatching
anything.  If we saw contention we kick all hctx's associated with the
queue where there was contention.  We do this without any locking by
adding a double-check for budget and accepting a small amount of faux
contention if the 2nd check gives us budget but then we don't dispatch
anything (we'll look like we contended with ourselves).

A few extra notes:

- This whole thing is only a problem due to the inexact nature of
  has_work().  Specifically if has_work() always guaranteed that a
  "true" return meant that dispatch_request() would return non-NULL
  then we wouldn't have this problem.  That's because we only grab the
  budget if has_work() returned true.  If we had the non-NULL
  guarantee then at least one of the threads would actually dispatch
  work and when the work was done then queues would be kicked
  normally.

- One specific I/O scheduler that trips this problem quite a bit is
  BFQ which definitely returns "true" for has_work() in cases where it
  wouldn't dispatch.  Making BFQ's has_work() more exact requires that
  has_work() becomes a much heavier function, including figuring out
  how to acquire spinlocks in has_work() without tripping circular
  lock dependencies.  This is prototyped but it's unclear if it's
  really the way to go when the problem can be solved with a
  relatively lightweight contention detection mechanism.

- Because this problem only trips with inexact has_work() it's
  believed that blk_mq_do_dispatch_ctx() does not need a similar
  change.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

Changes in v2:
- Replace ("scsi: core: Fix stall...") w/ ("blk-mq: Rerun dispatch...")

 block/blk-mq-sched.c   | 26 ++++++++++++++++++++++++--
 block/blk-mq.c         |  3 +++
 include/linux/blkdev.h |  2 ++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 74cedea56034..0195d75f5f96 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -97,12 +97,34 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
 		if (e->type->ops.has_work && !e->type->ops.has_work(hctx))
 			break;
 
-		if (!blk_mq_get_dispatch_budget(hctx))
-			break;
+
+		if (!blk_mq_get_dispatch_budget(hctx)) {
+			/*
+			 * We didn't get budget so set contention.  If
+			 * someone else had the budget but didn't dispatch
+			 * they'll kick everything.  NOTE: we check one
+			 * extra time _after_ setting contention to fully
+			 * close the race.  If we don't actually dispatch
+			 * we'll detext faux contention (with ourselves)
+			 * but that should be rare.
+			 */
+			atomic_set(&q->budget_contention, 1);
+
+			if (!blk_mq_get_dispatch_budget(hctx))
+				break;
+		}
 
 		rq = e->type->ops.dispatch_request(hctx);
 		if (!rq) {
 			blk_mq_put_dispatch_budget(hctx);
+
+			/*
+			 * We've released the budget but us holding it might
+			 * have prevented someone else from dispatching.
+			 * Detect that case and run all queues again.
+			 */
+			if (atomic_read(&q->budget_contention))
+				blk_mq_run_hw_queues(q, true);
 			break;
 		}
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2cd8d2b49ff4..6163c43ceca5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1528,6 +1528,9 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
 	struct blk_mq_hw_ctx *hctx;
 	int i;
 
+	/* We're running the queues, so clear the contention detector */
+	atomic_set(&q->budget_contention, 0);
+
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (blk_mq_hctx_stopped(hctx))
 			continue;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f629d40c645c..07f21e45d993 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -583,6 +583,8 @@ struct request_queue {
 
 #define BLK_MAX_WRITE_HINTS	5
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
+
+	atomic_t		budget_contention;
 };
 
 #define QUEUE_FLAG_STOPPED	0	/* queue is stopped */
-- 
2.26.0.rc2.310.g2932bb562d-goog

