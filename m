Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A01AC636D3
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 21:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjA3V1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 16:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjA3V1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 16:27:07 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F62C30E9D;
        Mon, 30 Jan 2023 13:27:06 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id cl23-20020a17090af69700b0022c745bfdc3so5839535pjb.3;
        Mon, 30 Jan 2023 13:27:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Skju3H/RsWPZRhCsRg0OOLUt7scOZ3q1EB0H4HbGA64=;
        b=UaL/7BmboqyzylgXqsuPC5PmIIBq5rRBW3RTZe1ZWYLFVqLZxcvaa/wYGtTyPBUOia
         lOVTq/rJyBt3BTFQlcmfDtq/Wi51obJji/pKHs20SusADTnkWprPRwIataI9301YChSa
         yACkpGraZuJXwFB6OhdDUiVd4BtpEqrCL7ri8yP7Bco9yxzj2d5aCyOkqn9FOqV26AwR
         lLzNo73FCsEEezgE1MEvPStwkWfW63UeP/eBP/BK3hiWRp6tqEMMAIljAwU8/gBAYay7
         jrlWdos+hruJUP250zFZgfdLsC8I0phKNipqebDPEcJAz75kwMG4K0C9Sw/T1gfKOtjo
         MSug==
X-Gm-Message-State: AO0yUKX6r0jy2EUyJVGEYIXZZrdJLm8Gjj1DcwmVUT1JwSYvNhmdpUGK
        U8BxPYcW+Yhht/iacZBCtB8=
X-Google-Smtp-Source: AK7set86MoqEQQ1eZYkC2Ju4X5pyp/se66X59m99iCtPC9JQVSbakaKa4QCsy5TwrHzlSY85WXfnOg==
X-Received: by 2002:a17:903:1d1:b0:196:2ade:6e21 with SMTP id e17-20020a17090301d100b001962ade6e21mr25931713plh.14.1675114026065;
        Mon, 30 Jan 2023 13:27:06 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b00196087a3d7csm7425613plf.77.2023.01.30.13.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:27:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH v4 1/7] block: Introduce blk_mq_debugfs_init()
Date:   Mon, 30 Jan 2023 13:26:50 -0800
Message-Id: <20230130212656.876311-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230130212656.876311-1-bvanassche@acm.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the code for creating the block layer debugfs root directory into
blk-mq-debugfs.c. This patch prepares for adding more debugfs
initialization code by introducing the function blk_mq_debugfs_init().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c       | 3 ++-
 block/blk-mq-debugfs.c | 5 +++++
 block/blk-mq-debugfs.h | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ccf9a7683a3c..0dacc2df9588 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -45,6 +45,7 @@
 #include <trace/events/block.h>
 
 #include "blk.h"
+#include "blk-mq-debugfs.h"
 #include "blk-mq-sched.h"
 #include "blk-pm.h"
 #include "blk-cgroup.h"
@@ -1202,7 +1203,7 @@ int __init blk_dev_init(void)
 	blk_requestq_cachep = kmem_cache_create("request_queue",
 			sizeof(struct request_queue), 0, SLAB_PANIC, NULL);
 
-	blk_debugfs_root = debugfs_create_dir("block", NULL);
+	blk_mq_debugfs_init();
 
 	return 0;
 }
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index bd942341b638..60d1de0ce624 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -874,3 +874,8 @@ void blk_mq_debugfs_unregister_sched_hctx(struct blk_mq_hw_ctx *hctx)
 	debugfs_remove_recursive(hctx->sched_debugfs_dir);
 	hctx->sched_debugfs_dir = NULL;
 }
+
+void blk_mq_debugfs_init(void)
+{
+	blk_debugfs_root = debugfs_create_dir("block", NULL);
+}
diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
index 9c7d4b6117d4..7942119051f5 100644
--- a/block/blk-mq-debugfs.h
+++ b/block/blk-mq-debugfs.h
@@ -17,6 +17,8 @@ struct blk_mq_debugfs_attr {
 	const struct seq_operations *seq_ops;
 };
 
+void blk_mq_debugfs_init(void);
+
 int __blk_mq_debugfs_rq_show(struct seq_file *m, struct request *rq);
 int blk_mq_debugfs_rq_show(struct seq_file *m, void *v);
 
@@ -36,6 +38,10 @@ void blk_mq_debugfs_unregister_sched_hctx(struct blk_mq_hw_ctx *hctx);
 void blk_mq_debugfs_register_rqos(struct rq_qos *rqos);
 void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos);
 #else
+static inline void blk_mq_debugfs_init(void)
+{
+}
+
 static inline void blk_mq_debugfs_register(struct request_queue *q)
 {
 }
