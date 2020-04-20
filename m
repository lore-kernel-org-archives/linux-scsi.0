Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C594C3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 16:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C4BF20775
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 16:25:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oLc3AJ2z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgDTQZZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 12:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725958AbgDTQZY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 12:25:24 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D22C061A10
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 09:25:24 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n24so4115996plp.13
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 09:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5/HuxgmmHlqReW6h8RDiDPaUU+foeFL9gMHI9mR80zQ=;
        b=oLc3AJ2zDSkJUS41so2hjSzJWNKd+wQTQRY105W2+x1kDo67B9HBOmeWMj71MixgMx
         Or9Sk5sj3rNm2US+gKQTp3Pa4AgxhFV4SqxT7+A6HxzfaKFMFsWyQbXAeSfmPoABqpNl
         Co26ffksskFcKs3YvP8b3uw/2SKxJVLuMvcn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5/HuxgmmHlqReW6h8RDiDPaUU+foeFL9gMHI9mR80zQ=;
        b=b6Tmg2ww1j/6K+kGdIxZhFWWCmKd9Vph5vMlOlGPqo8cAlV73qrxnqDm8VnArqYXU2
         FcnafoEFWbBzuV8HvwHNxDIo/KBCmIX8aaW1Go24p9TODFBEufwSTAJQSfPTK6iHl+nb
         7l+9qFfEfzyd6U2k/31kZeSY/bL7cq1v73erCY3Lr1Dbe9HEbDRniGCWKfh0MHVL87cV
         i19n81If7TDxp+nJeSgp5dbzBjWYXVgTHqi2dxLXwhpIO9rbQT3Fv6cmApG+VEwCQFAc
         ckowRHLc4AX9Worx4qpirHvfg1lGpnWttDi4iXjZL+6f+JtLDJWhqN41JySD1kcx+RdE
         Q2+Q==
X-Gm-Message-State: AGi0PuZNVnY53dx7t767sfpfoZUDO3y49Ug7+5Nk79V/Y2zCK3jGt3Bt
        pfyMS0kZhAXVL0k07NPHYMSNiw==
X-Google-Smtp-Source: APiQypKpCrNnEeTYcINBy79o3eKcejCinyX6OW/b2TJcQxL+18Xe1Dv9nBf3MYUu730zR6e0r+X2hA==
X-Received: by 2002:a17:90a:710a:: with SMTP id h10mr213647pjk.152.1587399924208;
        Mon, 20 Apr 2020 09:25:24 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id p64sm93150pjp.7.2020.04.20.09.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:25:23 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        sqazi@google.com, groeck@chromium.org,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        paolo.valente@linaro.org, Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/4] blk-mq: In blk_mq_dispatch_rq_list() "no budget" is a reason to kick
Date:   Mon, 20 Apr 2020 09:24:51 -0700
Message-Id: <20200420092357.v5.1.I1f95c459e51962b8d2c83e869913b6befda2255c@changeid>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
In-Reply-To: <20200420162454.48679-1-dianders@chromium.org>
References: <20200420162454.48679-1-dianders@chromium.org>
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

It should be noted that even if we add a whole bunch of extra kicking
to the queue in other patches this patch is still important.
Specifically any kicking that happened before we re-spliced leftover
requests into 'hctx->dispatch' wouldn't have found any work, so we
really need to make sure we kick ourselves after we've done the
splicing.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---

Changes in v5:
- Rebase atop commit 5fe56de799ad ("...Put driver tag...when no budget")

Changes in v4: None
Changes in v3:
- Note why blk_mq_dispatch_rq_list() change is needed.

Changes in v2: None

 block/blk-mq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a7785df2c944..1c4bedf500c5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1206,6 +1206,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 	bool no_tag = false;
 	int errors, queued;
 	blk_status_t ret = BLK_STS_OK;
+	bool no_budget_avail = false;
 
 	if (list_empty(list))
 		return false;
@@ -1224,6 +1225,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		hctx = rq->mq_hctx;
 		if (!got_budget && !blk_mq_get_dispatch_budget(hctx)) {
 			blk_mq_put_driver_tag(rq);
+			no_budget_avail = true;
 			break;
 		}
 
@@ -1320,13 +1322,15 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
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
2.26.1.301.g55bc3eb7cb9-goog

