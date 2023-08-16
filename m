Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2363C25B5E
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345926AbjHPTzW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345910AbjHPTzE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:04 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446041BEE;
        Wed, 16 Aug 2023 12:55:03 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6887b3613e4so1179377b3a.3;
        Wed, 16 Aug 2023 12:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215703; x=1692820503;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3+wK2b/T5ahLT/169wPA2eew56bTI2jrIsHOq12bMQA=;
        b=EhLzdUnZ5CDX0wooop5A0Qy2LNwf48H63clRs5608awpNCv2M87DxxLJIcbsw9Abbh
         2n6PM2J7ZTPLIHA99mdCFkezIQuRUmVrccH9S44X5TW05J+p2WplKxiWfABDMsZKGCL9
         0YMWRa4CZygiDG+TJbd7e86Lyek8NOOvUqgCtoqQpuY/BHyWqJEh9vJ5LpzQYjEGoEQG
         9aWkglbqpaifVgYYnjZD8gbGoapV4Y8Ut4b0gKGRH7TkV7lomOPWAHvoMjybC4F7Y930
         TXLy9UGm7AogVMiWYnfN3zEsl32ruZ/ArqnxNkgoz6ub3hCuZvxfy7PYBE+RHq1p7wTW
         ThBg==
X-Gm-Message-State: AOJu0YwxrOUhQ2zjQqs14E7cWt7VFgPAWh/howTIqCAA394bL/ECBKlG
        dV8CBZsGhHJxT0BPyqPGCwA=
X-Google-Smtp-Source: AGHT+IEuPF57GoiVHy80p8JN6Kr+gPanM9h0ZyGHzuX3I8WzdqLR9CvUVl4AOtI95bYJNiaGxHdubQ==
X-Received: by 2002:a05:6a00:3490:b0:687:9909:3c75 with SMTP id cp16-20020a056a00349000b0068799093c75mr3170690pfb.4.1692215702559;
        Wed, 16 Aug 2023 12:55:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v9 02/17] block: Only use write locking if necessary
Date:   Wed, 16 Aug 2023 12:53:14 -0700
Message-ID: <20230816195447.3703954-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make blk_req_needs_zone_write_lock() return false if
q->limits.use_zone_write_lock is false. Inline this function because it
is short and because it is called from the hot path of the mq-deadline
I/O scheduler.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 112620985bff..d8a80cce832f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -53,11 +53,16 @@ const char *blk_zone_cond_str(enum blk_zone_cond zone_cond)
 EXPORT_SYMBOL_GPL(blk_zone_cond_str);
 
 /*
- * Return true if a request is a write requests that needs zone write locking.
+ * Return true if a request is a write request that needs zone write locking.
  */
 bool blk_req_needs_zone_write_lock(struct request *rq)
 {
-	if (!rq->q->disk->seq_zones_wlock)
+	struct request_queue *q = rq->q;
+
+	if (!q->limits.use_zone_write_lock)
+		return false;
+
+	if (!q->disk->seq_zones_wlock)
 		return false;
 
 	return blk_rq_is_seq_zoned_write(rq);
