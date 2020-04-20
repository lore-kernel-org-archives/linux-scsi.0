Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0AFC3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 16:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EC3F20857
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 16:25:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KUBJDxas"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgDTQZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 12:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728433AbgDTQZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 12:25:25 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD9CC061A0C
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 09:25:25 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ng8so74377pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 09:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sJb/FZkBYSseiSKNzzWagXNE/s2TMt80AisrI4SdHXg=;
        b=KUBJDxasRKeNRfT7LjBcYw8jIuMRS8knhr1jWgdF5aQN6fN8PPTIUhvHLDOfDDuwbn
         VFfvRCq+JaHti7X9smTvMSfDYe2LfpA+OE0FyosSdWFCSMXr0uox0foWB1qm0Gz69CmX
         9X3o+uDxr0q3mMra9qG4Jm+7h5x3WC2SPvu5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sJb/FZkBYSseiSKNzzWagXNE/s2TMt80AisrI4SdHXg=;
        b=H9xsj4UphMCF9EcUzLbtdKrF50m31nT4iVvhdIZLMPyBiMIz8ZI9l4eBcIHCvicL17
         bvQug2uzKskw5nCXXs8Xc8FcpkR6asyCbPe/nGZbPc4TXKViEkcigpRRdGTTuIGIAfSZ
         D+ckBzaCOidMVsruQJptjb95fOSPkCrHo1E/Cfk+ZMd1IXsYbiEszXt+f9Wt55VYlDmY
         W+5HWF5sMY4U2G2dt3KoOMdzv24AA2qNwsjkT5eZNkRdm1pQsaGYXQZ4l9tjvyu2E5D8
         opu4A5LIoEa5zelljyqfDSy80ZEtMMqf0fx1O0xDS2KZt7y5SZLkrbB75pUW5OovSlcM
         61LQ==
X-Gm-Message-State: AGi0PubiMNvOaohlqmcdW/fAXRQNyfFG2swkhH595J5KpMZB0fnEkQXz
        1YllTi44pPbKvwF12L4JceuXXg==
X-Google-Smtp-Source: APiQypJs4GaJ6rb7KxgKEfa+hDVAZ8kHOtrz2+nvnHERM7J1Y9Bab5AsRC8ri3uoYqw+0duAqDbWnQ==
X-Received: by 2002:a17:90a:270d:: with SMTP id o13mr247209pje.34.1587399925403;
        Mon, 20 Apr 2020 09:25:25 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id p64sm93150pjp.7.2020.04.20.09.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 09:25:24 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        sqazi@google.com, groeck@chromium.org,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        paolo.valente@linaro.org, Douglas Anderson <dianders@chromium.org>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/4] blk-mq: Add blk_mq_delay_run_hw_queues() API call
Date:   Mon, 20 Apr 2020 09:24:52 -0700
Message-Id: <20200420092357.v5.2.I4c665d70212a5b33e103fec4d5019a59b4c05577@changeid>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
In-Reply-To: <20200420162454.48679-1-dianders@chromium.org>
References: <20200420162454.48679-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have:
* blk_mq_run_hw_queue()
* blk_mq_delay_run_hw_queue()
* blk_mq_run_hw_queues()

...but not blk_mq_delay_run_hw_queues(), presumably because nobody
needed it before now.  Since we need it for a later patch in this
series, add it.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---

Changes in v5: None
Changes in v4: None
Changes in v3:
- ("blk-mq: Add blk_mq_delay_run_hw_queues() API call") new for v3

Changes in v2: None

 block/blk-mq.c         | 19 +++++++++++++++++++
 include/linux/blk-mq.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1c4bedf500c5..cf95e8e0881a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1545,6 +1545,25 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
 }
 EXPORT_SYMBOL(blk_mq_run_hw_queues);
 
+/**
+ * blk_mq_delay_run_hw_queues - Run all hardware queues asynchronously.
+ * @q: Pointer to the request queue to run.
+ * @msecs: Microseconds of delay to wait before running the queues.
+ */
+void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long msecs)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		if (blk_mq_hctx_stopped(hctx))
+			continue;
+
+		blk_mq_delay_run_hw_queue(hctx, msecs);
+	}
+}
+EXPORT_SYMBOL(blk_mq_delay_run_hw_queues);
+
 /**
  * blk_mq_queue_stopped() - check whether one or more hctxs have been stopped
  * @q: request queue.
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index f389d7c724bd..3bbc730eca72 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -508,6 +508,7 @@ void blk_mq_unquiesce_queue(struct request_queue *q);
 void blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_run_hw_queues(struct request_queue *q, bool async);
+void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long msecs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
 void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset);
-- 
2.26.1.301.g55bc3eb7cb9-goog

