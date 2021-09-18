Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468CAC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27A47611C3
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbhIRAHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:07:45 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:38630 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242560AbhIRAHk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:07:40 -0400
Received: by mail-pg1-f171.google.com with SMTP id w8so11114077pgf.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a2tBUYszQtfP0BTUcwuGA2EUy83xRZufxN/pIPHL0F0=;
        b=fF/PDCQ0RQcOECoDW3RE0ke8xljOP8CnTO80VqjsHL9OF6wY6L6rPgbyEId0AiSpbH
         WMkrtG21ivJhhbh9UwPoHVj2CxvkhyuRni3l7myBwWUji7HKuxmIHh2OG9ef88EGViu9
         6ImNurIAfg2GleuNLkYp8F2AjFCyEKD51x1mz/bLgb00nvPt1QDXI5hOHLIsZnN4eerf
         8UVeCkqi3S9qZlWTBFSXqy5vEjntoMgS5qLvFxIPRISnu/ip9yHP4W6all2S0g/+CwmF
         HumHQf2IsUnf2EWUtgrE/oW6pwMnFKboPOcjx5WcLsXy+gPe43cDLuY6+nIpr4FDG7os
         YfRw==
X-Gm-Message-State: AOAM5315OvTrmiFY7/AruxtoLTXVfEnPFr3Ad74ffsi9EcHPrdwZ1Ju1
        sf4QaOs1DFZ7OjM8OPuVqAY=
X-Google-Smtp-Source: ABdhPJzwSq1W4Zk+4E5kvaMA9PMptnq/vBvpyS0vcSFVYe9aXUkO3x3TVpgTCdIL8jOLeCLkONIatA==
X-Received: by 2002:a62:6493:0:b0:43c:e252:3dfc with SMTP id y141-20020a626493000000b0043ce2523dfcmr13126131pfb.60.1631923577211;
        Fri, 17 Sep 2021 17:06:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 02/84] scsi: core: Rename scsi_mq_done() into scsi_done() and export it
Date:   Fri, 17 Sep 2021 17:04:45 -0700
Message-Id: <20210918000607.450448-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the removal of the legacy block layer there is only one completion
function left in the SCSI core, namely scsi_mq_done(). Rename it into
scsi_done(). Export that function to allow SCSI LLDs to call it directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 5 +++--
 include/scsi/scsi_cmnd.h | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba6d748a0246..c3a0283dbff0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1575,7 +1575,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
-static void scsi_mq_done(struct scsi_cmnd *cmd)
+void scsi_done(struct scsi_cmnd *cmd)
 {
 	switch (cmd->submitter) {
 	case BLOCK_LAYER:
@@ -1593,6 +1593,7 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
 	trace_scsi_dispatch_cmd_done(cmd);
 	blk_mq_complete_request(scsi_cmd_to_rq(cmd));
 }
+EXPORT_SYMBOL(scsi_done);
 
 static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
 {
@@ -1692,7 +1693,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-	cmd->scsi_done = scsi_mq_done;
+	cmd->scsi_done = scsi_done;
 
 	blk_mq_start_request(req);
 	reason = scsi_dispatch_cmd(cmd);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 365d47a66c18..5b230d06527f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -172,6 +172,8 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 	return *(struct scsi_driver **)rq->rq_disk->private_data;
 }
 
+void scsi_done(struct scsi_cmnd *cmd);
+
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
