Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05DAC25B45
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 20:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjJWUg5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 16:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjJWUgw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 16:36:52 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83031D78;
        Mon, 23 Oct 2023 13:36:50 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-68fb85afef4so3086453b3a.1;
        Mon, 23 Oct 2023 13:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698093410; x=1698698210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s/5xet03ew9Pw9gn1HDVrR9Wequ2bFLVgw3o3jyYqZc=;
        b=HiKIE6YoYCVEi0uAyHezkJf67zIHaZR3BUEMOqURrAAUN/OcelwBElKStiF6iGz2Dz
         ot6g+6aIVNaecCcH372B27wKcYSLf03Y4o7iBTo5jFMqa7vaKRd3G+iK49qltrmRpfae
         2WnTJguJIKh5CCzuKwcTgSKnuMpav7aoPbUXqCwWk5AnzK4ufUJQ8Q5b07neXmoLOWhZ
         OsAvnjkKqRB+vpmIAk4tCZmo0GgNB2xJ75DIe+L0jbDjyvGJ4KLuQByD7wzjbd3NDVgu
         7Ob3BEZ6T/8Czq/7GxiF5yQHDY7Xjqg2eCYh0tUUJI/mpKPnekVUzxmuEdX0Py121G/L
         O/uw==
X-Gm-Message-State: AOJu0YyPtPHGkajkGucpvJCV4jTLB0+YTNLdXMGkUwIFq9krbZRQbs5X
        4g8Qn+JRGw4xx7pvLijwk4A=
X-Google-Smtp-Source: AGHT+IGfTywYz4f7hTgPSzcr9zr9xBTXBy9oK25vNgKXe7U+OYCUZ1DoMhbIDX4X8u7Lep3r509uxA==
X-Received: by 2002:a05:6a20:158b:b0:154:a1e3:f967 with SMTP id h11-20020a056a20158b00b00154a1e3f967mr674807pzj.47.1698093409835;
        Mon, 23 Oct 2023 13:36:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id g29-20020aa79ddd000000b0068be4ce33easm5776025pfq.96.2023.10.23.13.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 13:36:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Yu Kuai <yukuai1@huaweicloud.com>,
        Ed Tsai <ed.tsai@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH v4 1/3] block: Introduce flag BLK_MQ_F_DISABLE_FAIR_TAG_SHARING
Date:   Mon, 23 Oct 2023 13:36:33 -0700
Message-ID: <20231023203643.3209592-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023203643.3209592-1-bvanassche@acm.org>
References: <20231023203643.3209592-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The fair sharing algorithm has a negative performance impact for storage
devices for which the full queue depth is required to reach peak
performance, e.g. UFS devices. This is because it takes long after a
request queue became inactive until tags are reassigned to the active
request queue(s). Since making tag sharing fair is not needed if the
request processing latency is similar for all request queues, introduce
the hctx / tag set flag BLK_MQ_F_DISABLE_FAIR_TAG_SHARING.

Cc: Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ed Tsai <ed.tsai@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq-debugfs.c | 1 +
 block/blk-mq.h         | 3 ++-
 include/linux/blk-mq.h | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 5cbeb9344f2f..f41408103106 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -198,6 +198,7 @@ static const char *const hctx_flag_name[] = {
 	HCTX_FLAG_NAME(NO_SCHED),
 	HCTX_FLAG_NAME(STACKING),
 	HCTX_FLAG_NAME(TAG_HCTX_SHARED),
+	HCTX_FLAG_NAME(DISABLE_FAIR_TAG_SHARING),
 };
 #undef HCTX_FLAG_NAME
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index f75a9ecfebde..eda6bd0611ea 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -416,7 +416,8 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 {
 	unsigned int depth, users;
 
-	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED))
+	if (!hctx || !(hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED) ||
+	    (hctx->flags & BLK_MQ_F_DISABLE_FAIR_TAG_SHARING))
 		return true;
 
 	/*
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1ab3081c82ed..b12a0be839aa 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -662,6 +662,7 @@ enum {
 	 * or shared hwqs instead of 'mq-deadline'.
 	 */
 	BLK_MQ_F_NO_SCHED_BY_DEFAULT	= 1 << 7,
+	BLK_MQ_F_DISABLE_FAIR_TAG_SHARING = 1 << 8,
 	BLK_MQ_F_ALLOC_POLICY_START_BIT = 8,
 	BLK_MQ_F_ALLOC_POLICY_BITS = 1,
 
