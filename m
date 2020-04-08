Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4398FC2BA1A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AAD220820
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aL8VsGju"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgDHPEg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:04:36 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34097 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbgDHPEg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 11:04:36 -0400
Received: by mail-pl1-f195.google.com with SMTP id a23so2608663plm.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2020 08:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=99bGb9kPLJIKPGAYnWeUQM+upQBOmhTKAuXfLDA02as=;
        b=aL8VsGjuULtKfOLQ4xJAOYPOZmY0Fm4LmPDtmN2EaK+l6PCc9odZkH+cahGM56TX7V
         RRRVicea4VeZOdbhSkDKFRCH58KpGUJ7CNOXzRWeuJNXr7aH2Mg1BkRpLSkVcDhAuWap
         3QS1w5M7oxl5CLQ+/jYNLGia4XietUIz9CYHU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=99bGb9kPLJIKPGAYnWeUQM+upQBOmhTKAuXfLDA02as=;
        b=MwgQxqBq7deci+MpWpQQS0oiIqPnH4+mmzMWkMcLBi1c4esQ70U4NpiGUyhAwLjou7
         tWcJod/nxDWeCmYcNzbs/lwfgubi8hnbVnWi4UZpWb4hg/0TZsO46Gq+YXgau5ywNkWP
         hoZ0olBnENoqUbvl34FMN3v6ZEOGu9/xFUarvvTsm3O2j8jqcMzyLgXIpu2cF5n7RANU
         FmnV9c3KJnXEJxz8Br1zNqVwaiwBvPJ/CKNjWS3AtqZ/BXBs8JHBFKpgdCZ//qgQMjJ1
         HiB707Z7hDI3w8jTwyD5iKVXW48MXOyQdL8KNgkfP/UKTMQXil+kUkfiz/N0nMgH8zqk
         foyA==
X-Gm-Message-State: AGi0PubIadf6jHcEujrjkKfzfioxaUyb3nSmKBedBHmnJieni3ZCEkpF
        DIJIpZtcjxrMCZwLh0pLaaUeJA==
X-Google-Smtp-Source: APiQypLwTROlMgk5kYCTxCFF56//DDLXDI3u7/I38vnrWOWWHtwiZKkjylcUiWynghi29M6bg7W1mQ==
X-Received: by 2002:a17:90a:178e:: with SMTP id q14mr208304pja.132.1586358273435;
        Wed, 08 Apr 2020 08:04:33 -0700 (PDT)
Received: from tictac2.mtv.corp.google.com ([2620:15c:202:1:24fa:e766:52c9:e3b2])
        by smtp.gmail.com with ESMTPSA id d85sm1468083pfd.157.2020.04.08.08.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 08:04:32 -0700 (PDT)
From:   Douglas Anderson <dianders@chromium.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     paolo.valente@linaro.org, groeck@chromium.org,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, sqazi@google.com,
        Douglas Anderson <dianders@chromium.org>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/4] blk-mq: Add blk_mq_delay_run_hw_queues() API call
Date:   Wed,  8 Apr 2020 08:04:00 -0700
Message-Id: <20200408080255.v4.2.I4c665d70212a5b33e103fec4d5019a59b4c05577@changeid>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
In-Reply-To: <20200408150402.21208-1-dianders@chromium.org>
References: <20200408150402.21208-1-dianders@chromium.org>
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
---

Changes in v4: None
Changes in v3:
- ("blk-mq: Add blk_mq_delay_run_hw_queues() API call") new for v3

Changes in v2: None

 block/blk-mq.c         | 19 +++++++++++++++++++
 include/linux/blk-mq.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 2cd8d2b49ff4..ea0cd970a3ff 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1537,6 +1537,25 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
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
index 11cfd6470b1a..405f8c196517 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -503,6 +503,7 @@ void blk_mq_unquiesce_queue(struct request_queue *q);
 void blk_mq_delay_run_hw_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
 void blk_mq_run_hw_queues(struct request_queue *q, bool async);
+void blk_mq_delay_run_hw_queues(struct request_queue *q, unsigned long msecs);
 void blk_mq_tagset_busy_iter(struct blk_mq_tag_set *tagset,
 		busy_tag_iter_fn *fn, void *priv);
 void blk_mq_tagset_wait_completed_request(struct blk_mq_tag_set *tagset);
-- 
2.26.0.292.g33ef6b2f38-goog

