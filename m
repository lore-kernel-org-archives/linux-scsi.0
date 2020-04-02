Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C961EC2BA12
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 15:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D21D20737
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 15:52:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ErbvY8r5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389528AbgDBPwG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 11:52:06 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36426 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389464AbgDBPwG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 11:52:06 -0400
Received: by mail-pg1-f193.google.com with SMTP id c23so2039104pgj.3
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2020 08:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=91TGSK7f3sZaNHrNjwv3lknFeXeezpxf66N2To7Vp6E=;
        b=ErbvY8r5SSroUWCgQcdORhlfrOOLrwx14vPvHlg/HqOvXU3jY+UWBJbMt0u3NpWhkg
         ZrrfQ+rYXIpGE2A8SN1byjVo3YEHplZeah09GFCUfFEOGiSR8cp+Xwzkq7CgbLE7VQet
         cYOnWvck9Qo2PnxG8bHN18C87gB0ojosODpbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=91TGSK7f3sZaNHrNjwv3lknFeXeezpxf66N2To7Vp6E=;
        b=Zzj16IRgOM0E/ou1CSKcgx4ygYWP5Xaqu06wsWnXnHQpfriCS8M+RB5fFyR5dp3UJq
         6LmLnrgA3UzxBuKSZZzuUEoK+LJF6tmCslIcOXPsTSSxOTMw+h+yiTWlHgUTTeRVy+Dd
         VEUamXzFP8iHOsWBt16+aTIYh2Jz8UCc0nyu+qwE8BjDaPQscUpdp5eFcrEREmQJYd2M
         9pckzqPXhzSurrJzUEH+Ci2dkxRUTcpMsYGpPbnvxKeuncnqmUPRK+zuXdHk5jXtXfuP
         0LdNxnwfrss0qgAcoCCHjXotl+kjcKpaNFj6G/ONUCbdL4cZ0q6LQy3pl4H9luQv3sMm
         79Jg==
X-Gm-Message-State: AGi0PuYX/d4mm6lOQKl7BEh4Q6TIMriwyfr4/TjwOOXe+YZUFpi+6Mfy
        p2ZDVYqYxVD+o2ygAlcIpFUBgg==
X-Google-Smtp-Source: APiQypImzOCBUNtsbiPzjiDW9PuoxYILaMINgF1fKvv0r+xRLgvzitqDl42wjh7kUfwQMvp2cwkd2w==
X-Received: by 2002:a63:134e:: with SMTP id 14mr3943484pgt.380.1585842725090;
        Thu, 02 Apr 2020 08:52:05 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id x68sm2578815pfb.5.2020.04.02.08.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 08:52:04 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     paolo.valente@linaro.org, sqazi@google.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, groeck@chromium.org,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] blk-mq: In blk_mq_dispatch_rq_list() "no budget" is a reason to kick
Date:   Thu,  2 Apr 2020 08:51:29 -0700
Message-Id: <20200402085050.v2.1.I1f95c459e51962b8d2c83e869913b6befda2255c@changeid>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
In-Reply-To: <20200402155130.8264-1-dianders@chromium.org>
References: <20200402155130.8264-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In blk_mq_dispatch_rq_list(), if blk_mq_sched_needs_restart() returns
true and the driver returns BLK_STS_RESOURCE then we'll kick the
queue.  However, there's another case where we might need to kick it.
If we were unable to get budget we can be in much the same state as
when the driver returns BLK_STS_RESOURCE, so we should treat it the
same.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

Changes in v2: None

 block/blk-mq.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d92088dec6c3..2cd8d2b49ff4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1189,6 +1189,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 	bool no_tag = false;
 	int errors, queued;
 	blk_status_t ret = BLK_STS_OK;
+	bool no_budget_avail = false;
 
 	if (list_empty(list))
 		return false;
@@ -1205,8 +1206,10 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		rq = list_first_entry(list, struct request, queuelist);
 
 		hctx = rq->mq_hctx;
-		if (!got_budget && !blk_mq_get_dispatch_budget(hctx))
+		if (!got_budget && !blk_mq_get_dispatch_budget(hctx)) {
+			no_budget_avail = true;
 			break;
+		}
 
 		if (!blk_mq_get_driver_tag(rq)) {
 			/*
@@ -1311,13 +1314,15 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		 *
 		 * If driver returns BLK_STS_RESOURCE and SCHED_RESTART
 		 * bit is set, run queue after a delay to avoid IO stalls
-		 * that could otherwise occur if the queue is idle.
+		 * that could otherwise occur if the queue is idle.  We'll do
+		 * similar if we couldn't get budget and SCHED_RESTART is set.
 		 */
 		needs_restart = blk_mq_sched_needs_restart(hctx);
 		if (!needs_restart ||
 		    (no_tag && list_empty_careful(&hctx->dispatch_wait.entry)))
 			blk_mq_run_hw_queue(hctx, true);
-		else if (needs_restart && (ret == BLK_STS_RESOURCE))
+		else if (needs_restart && (ret == BLK_STS_RESOURCE ||
+					   no_budget_avail))
 			blk_mq_delay_run_hw_queue(hctx, BLK_MQ_RESOURCE_DELAY);
 
 		blk_mq_update_dispatch_busy(hctx, true);
-- 
2.26.0.rc2.310.g2932bb562d-goog

