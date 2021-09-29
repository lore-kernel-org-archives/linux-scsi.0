Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE3AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF6D7613CE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347046AbhI2WIB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:01 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:40957 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344298AbhI2WIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:01 -0400
Received: by mail-pl1-f170.google.com with SMTP id j15so2519874plh.7
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BpghTOQqRX6wAUScODjVGinMTm9xFNmc1wvmQaPCCIs=;
        b=TnB9TzOgWPvSX9YBfOiFntKe1sNAkhQ8uFtkRib9zUyWwgWqYjeNmf8VC6ySYuRdT8
         LM2N+GXPdsD1ocguu3zlBi6qsRGxQfQbcZjsi65CFKuBj+Es2EjYOyoIMk6GHtkJVR4m
         FCIZGr6MfqCSRzKLwDERYWAo/9kG1Un1R+F9nz3PclLq+daXySuGrvNCb4CNWqXj0tmt
         xI6q2Aq7Q4tS3ykDLFz+Lx3a/zi1fOfUShtpcU+oqyPggJnGKvLMbarEDKlmIa5LVI53
         aw39YSd9dYI9q71T3KPQfNsZzyIzGxivR2zjQJzlMERrsJGT91+c0+n1+ZfMQEZC0Hts
         c9kw==
X-Gm-Message-State: AOAM532llBOpv8rfq+GL0RrMTXA9BViPKx2Nq5NG+ZmDzmGoOafXA1F7
        kNa8pjiVyZyulCXzfUeIAq3Lq1BChoM=
X-Google-Smtp-Source: ABdhPJwpVFAsb5WyPgNQumNWeFT0jni/Qz1ULZSpzrM6Z/UtN2NJbmII8uMq6tcTgP2mpVlPwAqwug==
X-Received: by 2002:a17:90a:7345:: with SMTP id j5mr9162324pjs.48.1632953179437;
        Wed, 29 Sep 2021 15:06:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 02/84] scsi: core: Rename scsi_mq_done() into scsi_done() and export it
Date:   Wed, 29 Sep 2021 15:04:38 -0700
Message-Id: <20210929220600.3509089-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the removal of the legacy block layer there is only one completion
function left in the SCSI core, namely scsi_mq_done(). Rename it into
scsi_done(). Export that function to allow SCSI LLDs to call it directly.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 5 +++--
 include/scsi/scsi_cmnd.h | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c0c1f1ca0382..47bfd12abdda 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1575,7 +1575,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
-static void scsi_mq_done(struct scsi_cmnd *cmd)
+void scsi_done(struct scsi_cmnd *cmd)
 {
 	switch (cmd->submitter) {
 	case SUBMITTED_BY_BLOCK_LAYER:
@@ -1593,6 +1593,7 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
 	trace_scsi_dispatch_cmd_done(cmd);
 	blk_mq_complete_request(scsi_cmd_to_rq(cmd));
 }
+EXPORT_SYMBOL(scsi_done);
 
 static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
 {
@@ -1693,7 +1694,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
-	cmd->scsi_done = scsi_mq_done;
+	cmd->scsi_done = scsi_done;
 
 	blk_mq_start_request(req);
 	reason = scsi_dispatch_cmd(cmd);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 893c24aab8e4..4edaadc293a7 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -171,6 +171,8 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 	return *(struct scsi_driver **)rq->rq_disk->private_data;
 }
 
+void scsi_done(struct scsi_cmnd *cmd);
+
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
