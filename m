Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F4BC2BA2B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DC7B20820
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RVJkQ7hr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgDHPEl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:04:41 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33255 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728620AbgDHPEk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 11:04:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id c138so3174073pfc.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2020 08:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V7jm6LpOOba6AShtQDS9c6sItWuCS66vjofoe5YuiE4=;
        b=RVJkQ7hrtx/hJqp9SyS8a/6H90Yi26GUw3MAk2MsBz2Po5NpDAosNRaETNYCYW5o0w
         ykePsQQP91ugsXr2roLsaXUNJ0W2CuDK3R8H+PuKPcxuI0oVH3csLak7G3gnyrb24oIE
         BAaIhmv6eZuom8joh7i06yEvMXG2iAlXlcDbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V7jm6LpOOba6AShtQDS9c6sItWuCS66vjofoe5YuiE4=;
        b=Jv3g5z2K65TqxR9/IkZu+ZcCGKgHtj3u2nN9/wGPzmh8o6u4jY8fe/9OsN1J0sQ9qH
         3uKBg5bEHJ3uB5BZqsvGkKXwps+I4Y3qSVF/kleixImg8jvv3jZLRbRMH8jwZiw4eA3r
         aSfRud9HA43xQe0aj4hx0R4+suXUi/pNfFDTweDYAIL+pOqvp5fwhMzVqzKUFggJpCza
         xqGIArld3ZNG/hi4xuzOGH4m5PUTivHGNYC6XxkjGVNHpjcconXHG+uq+ZBH3bda2N2l
         iEJ/mPyDmqQjdUeay+qdpYK0R2U1FVbPPsWgPc/aLr2CCfqFUMlOuPSejREhHvpD2dlY
         Cgow==
X-Gm-Message-State: AGi0PuZqfhMM21WtAZq9CDmrWAq75fUh2Yqn49Ara1xmzGPYnco05jBp
        M3R3apeXGYWvrwDyARxd75zaKg==
X-Google-Smtp-Source: APiQypIz1G9cPCJpf4iXpx7RsV38wvJ0SkqcWHSSgCLSAaQfpBIOel67MdUS8T7gg/yBEMN2Opta/w==
X-Received: by 2002:a63:e10f:: with SMTP id z15mr7474924pgh.88.1586358277236;
        Wed, 08 Apr 2020 08:04:37 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id d85sm1468083pfd.157.2020.04.08.08.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 08:04:36 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     paolo.valente@linaro.org, groeck@chromium.org,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, sqazi@google.com,
        Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/4] Revert "scsi: core: run queue if SCSI device queue isn't ready and queue is idle"
Date:   Wed,  8 Apr 2020 08:04:02 -0700
Message-Id: <20200408080255.v4.4.I630e6ca4cdcf9ab13ea899274745f9e3174eb12b@changeid>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
In-Reply-To: <20200408150402.21208-1-dianders@chromium.org>
References: <20200408150402.21208-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This reverts commit 7e70aa789d4a0c89dbfbd2c8a974a4df717475ec.

Now that we have the patches ("blk-mq: In blk_mq_dispatch_rq_list()
"no budget" is a reason to kick") and ("blk-mq: Rerun dispatching in
the case of budget contention") we should no longer need the fix in
the SCSI code.  Revert it, resolving conflicts with other patches that
have touched this code.

With this revert (and the two new patches) I can run the script that
was in commit 7e70aa789d4a ("scsi: core: run queue if SCSI device
queue isn't ready and queue is idle") in a loop with no failure.  If I
do this revert without the two new patches I can easily get a failure.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
I don't know for sure that we can revert this patch, but in the very
least the original test case now passes.  If there is any question
about this, we can just drop this patch.

Changes in v4: None
Changes in v3:
- ("Revert "scsi: core: run queue...") new for v3.

Changes in v2: None

 drivers/scsi/scsi_lib.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 610ee41fa54c..b9e28ea76cc0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1632,12 +1632,7 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 	struct request_queue *q = hctx->queue;
 	struct scsi_device *sdev = q->queuedata;
 
-	if (scsi_dev_queue_ready(q, sdev))
-		return true;
-
-	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
-		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
-	return false;
+	return scsi_dev_queue_ready(q, sdev);
 }
 
 static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
-- 
2.26.0.292.g33ef6b2f38-goog

