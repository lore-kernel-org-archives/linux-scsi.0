Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25471C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B30261074
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhJGUbc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:32 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:33431 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233598AbhJGUbc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:32 -0400
Received: by mail-pl1-f172.google.com with SMTP id a11so4729393plm.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2EejsZAOhnHTGf6NPiHxuklMQ5J5EH2LY+Cz1NjHbpU=;
        b=AFWIXqlLFpeCa5IpyOzkx9oXD/X/8QG4DhtEzIzf7lEjq5zze1dQTk5XbUXQQxgk6P
         1+VtPMbXO7mTu8B2u3+kky1GAYb6J+lQd+b2u3SWFMgtohB0swGYRIILBdNAlsrxxUZT
         jHvXsV9lBSiP6sZLIbcBbvMi9TC3m0Ttx5zi3Z/ub2Y5EXnE9lgo6NCX4Mi1ck9k615W
         yDh1tQHaFaDdNr0gopPBxnBUM6B/FOcxj6HYjb1MZFjEmbj68Gs6qah+ewFhzbcbKU5B
         4Ql1gICgMWlm2TWmMWddugA02Fa9Cc98hcGoD/ifySq0jKRMv4ApUqk4Ked1i+JP6BAj
         Ming==
X-Gm-Message-State: AOAM532wXjcQIRQ6RBR25COapAVTDOGKyEtvYKsNo0SKKKmXt1ztvnOB
        bF4zOP3quPojSnW1Rglmt5g=
X-Google-Smtp-Source: ABdhPJyO9iWuimj9e0kBYZFSJ2Vqu6AK3hD7ft8xcoP2nBg2+26Gp6fKlOVVwlfQ/91jueRBUXXeWQ==
X-Received: by 2002:a17:90a:910:: with SMTP id n16mr7669205pjn.246.1633638577862;
        Thu, 07 Oct 2021 13:29:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Benjamin Block <bblock@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 02/88] scsi: core: Rename scsi_mq_done() into scsi_done() and export it
Date:   Thu,  7 Oct 2021 13:27:57 -0700
Message-Id: <20211007202923.2174984-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the removal of the legacy block layer there is only one completion
function left in the SCSI core, namely scsi_mq_done(). Rename it into
scsi_done(). Export that function to allow SCSI LLDs to call it directly.

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 5 +++--
 include/scsi/scsi_cmnd.h | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3fd24144b805..f690a2da21ea 100644
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
