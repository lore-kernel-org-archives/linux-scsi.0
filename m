Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70285C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D3F5216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405295AbfHIDDi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:38 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40484 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so45100029pgj.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eKOgVohH0ob6Iam0C7/vR+LC2ndL+wiqkOxeb1gOIvs=;
        b=Kpm3pqwwAoWG6itrx+tS6Nm7cXTVypdoCa/2bfECYgtaiPzNSLY/6Acac+XcaU5B3x
         yQXA8uephrds6/pgR4pFqwqfjALIbU6dZGiJlWwGeTfJ1VmMjZpUZfyhU9vQaqSPdhLw
         Y0OGr7T+93ldHfzpAfytJSXjrJBJvzXHA9XDHwgx8Qzyt560hb3rXpuwlSTAylcORCXg
         bOGHmquGycNMlnE2EaxQ6iPK3qAlT3pqDepIUyNX4gi3kV/UGFNUe0M0BaA8Z7nrqKr2
         J6Te6yqq5Xpd7sCYlp1WgFiHgKnlNGXwa7xJ8A8iamXGVQUK+7h+uiPhI1cNUx7Fsk3e
         q/Zg==
X-Gm-Message-State: APjAAAVH1a8ZI3NeZ8U8QPO7bc88LXt1vdLPQoJiLgeNfDS7op4QwFLU
        0GPgdkrIxWKb/pcoVs/9DeM=
X-Google-Smtp-Source: APXvYqwVKDIpMh25A6twMVcHD9fs+icj03k+6RPdVqzbjLjQYWWr+wftibiTPjxR+cgJ97krvKwdhA==
X-Received: by 2002:a63:3387:: with SMTP id z129mr15381096pgz.177.1565319816640;
        Thu, 08 Aug 2019 20:03:36 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 45/58] qla2xxx: Fix a race condition between aborting and completing a SCSI command
Date:   Thu,  8 Aug 2019 20:02:06 -0700
Message-Id: <20190809030219.11296-46-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of allocating a struct srb dynamically from inside .queuecommand(),
set qla2xxx_driver_template.cmd_size such that struct scsi_cmnd and struct
srb are contiguous. Do not call QLA_QPAIR_MARK_BUSY() /
QLA_QPAIR_MARK_NOT_BUSY() for SRBs associated with SCSI commands. That is
safe because scsi_remove_host() is called before queue pairs are deleted
and scsi_remove_host() waits for all outstanding SCSI commands to finish.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 -
 drivers/scsi/qla2xxx/qla_os.c  | 45 ++++++----------------------------
 2 files changed, 8 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 65d79bcb7ccf..3ffe7661a25b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -630,7 +630,6 @@ typedef struct srb {
 } srb_t;
 
 #define GET_CMD_SP(sp) (sp->u.scmd.cmd)
-#define SET_CMD_SP(sp, cmd) (sp->u.scmd.cmd = cmd)
 #define GET_CMD_CTX_SP(sp) (sp->u.scmd.ctx)
 
 #define GET_CMD_SENSE_LEN(sp) \
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9ef59995f5d6..5ca7f7913258 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -713,7 +713,6 @@ void qla2x00_sp_compl(srb_t *sp, int res)
 	cmd->scsi_done(cmd);
 	if (comp)
 		complete(comp);
-	qla2x00_rel_sp(sp);
 }
 
 void qla2xxx_qpair_sp_free_dma(srb_t *sp)
@@ -814,7 +813,6 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 	cmd->scsi_done(cmd);
 	if (comp)
 		complete(comp);
-	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
 
 static int
@@ -908,9 +906,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	else
 		goto qc24_target_busy;
 
-	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
-	if (!sp)
-		goto qc24_host_busy;
+	sp = scsi_cmd_priv(cmd);
+	qla2xxx_init_sp(sp, vha, vha->hw->base_qpair, fcport);
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
@@ -931,9 +928,6 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 qc24_host_busy_free_sp:
 	sp->free(sp);
 
-qc24_host_busy:
-	return SCSI_MLQUEUE_HOST_BUSY;
-
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
@@ -994,9 +988,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	else
 		goto qc24_target_busy;
 
-	sp = qla2xxx_get_qpair_sp(vha, qpair, fcport, GFP_ATOMIC);
-	if (!sp)
-		goto qc24_host_busy;
+	sp = scsi_cmd_priv(cmd);
+	qla2xxx_init_sp(sp, vha, qpair, fcport);
 
 	sp->u.scmd.cmd = cmd;
 	sp->type = SRB_SCSI_CMD;
@@ -1020,9 +1013,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 qc24_host_busy_free_sp:
 	sp->free(sp);
 
-qc24_host_busy:
-	return SCSI_MLQUEUE_HOST_BUSY;
-
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
@@ -1257,10 +1247,8 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	int ret;
 	unsigned int id;
 	uint64_t lun;
-	unsigned long flags;
 	int rval;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_qpair *qpair;
 
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x8042,
@@ -1272,32 +1260,14 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	if (ret != 0)
 		return ret;
 
-	sp = (srb_t *) CMD_SP(cmd);
-	if (!sp)
-		return SUCCESS;
-
-	qpair = sp->qpair;
-	if (!qpair)
-		return SUCCESS;
+	sp = scsi_cmd_priv(cmd);
 
 	if (sp->fcport && sp->fcport->deleted)
 		return SUCCESS;
 
-	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
-	if (sp->type != SRB_SCSI_CMD || GET_CMD_SP(sp) != cmd) {
-		/* there's a chance an interrupt could clear
-		   the ptr as part of done & free */
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		return SUCCESS;
-	}
-
-	/* Get a reference to the sp and drop the lock. */
-	if (sp_get(sp)){
-		/* ref_count is already 0 */
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
+	/* Return if the command has already finished. */
+	if (sp_get(sp))
 		return SUCCESS;
-	}
-	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
 	id = cmd->device->id;
 	lun = cmd->device->lun;
@@ -7159,6 +7129,7 @@ struct scsi_host_template qla2xxx_driver_template = {
 
 	.supported_mode		= MODE_INITIATOR,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(srb_t),
 };
 
 static const struct pci_error_handlers qla2xxx_err_handler = {
-- 
2.22.0

