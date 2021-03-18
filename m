Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA95EC4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70DAF64F18
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhCRD3G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 23:29:06 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:33516 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhCRD2t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 23:28:49 -0400
Received: by mail-pf1-f175.google.com with SMTP id x26so2513870pfn.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 20:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eH5H5mmCXB8ydpg0W8lBnsfgg64on1T1nw+umaCctAE=;
        b=eeCP/5nFesFOLnbXMWy5exdr9tG8c24wzcYxE2B6D6u+Jni01qYjgGmQLb1D0Q5DMi
         sZSSE3zxvCegSHrAc315Xs9EkTN6xxUytIl43DxPyHWIGfLLFsI0vQnk/YVPzkcBy/Rw
         XL+nfQrkv0SH/XpfY5nptEBthR2nfll1IiU6McQjSEeJj+JKolfXgtrZwRjgAEXdN5CP
         wYC9E/DKi7j8OqfgId8S7vckKQsE5KarFK5zm0EK9SQMJ5Oz2i3NFptJMqYvY/cg+sVn
         Q0KcTxKtq0RhPoK2X8MdCxBlBCUoFMG40xyjA2ol5wn4dNnS52Utu4Od+m/K+YU4s1MD
         OMWQ==
X-Gm-Message-State: AOAM530b56FpfNjtAfpRy7D9noUjoBkp4m/FN6xoY3AKGr5pquR0wCI+
        Wl+Q+Vvh1OqSc3YOusK/4U0=
X-Google-Smtp-Source: ABdhPJyRrO5WkfIqpDB6DSi6ICve4t9lyo9YjZe9qa8ofY/GROiAlEu6hT8pXQkCBr3Fg69Ua4Nb0Q==
X-Received: by 2002:a62:aa16:0:b029:1fb:51cd:c8e3 with SMTP id e22-20020a62aa160000b02901fb51cdc8e3mr2034864pff.60.1616038128792;
        Wed, 17 Mar 2021 20:28:48 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7fb2:1f41:ab33:bae6])
        by smtp.gmail.com with ESMTPSA id y68sm473687pgy.5.2021.03.17.20.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 20:28:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 1/6] Revert "qla2xxx: Make sure that aborted commands are freed"
Date:   Wed, 17 Mar 2021 20:28:35 -0700
Message-Id: <20210318032840.7611-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210318032840.7611-1-bvanassche@acm.org>
References: <20210318032840.7611-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calling vha->hw->tgt.tgt_ops->free_cmd() from qlt_xmit_response() is wrong
since the command for which a response is sent must remain valid until the
SCSI target core calls .release_cmd(). It has been observed that the
following scenario triggers a kernel crash:
- qlt_xmit_response() calls qlt_check_reserve_free_req().
- qlt_check_reserve_free_req() returns -EAGAIN.
- qlt_xmit_response() calls vha->hw->tgt.tgt_ops->free_cmd(cmd).
- transport_handle_queue_full() tries to retransmit the response.

Fix this crash by reverting the patch that introduced it.

Fixes: 0dcec41acb85 ("scsi: qla2xxx: Make sure that aborted commands are freed")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c  | 13 +++++--------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  4 ----
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d6366a46283e..5e8b2653e134 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3222,8 +3222,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	if (!qpair->fw_started || (cmd->reset_count != qpair->chip_reset) ||
 	    (cmd->sess && cmd->sess->deleted)) {
 		cmd->state = QLA_TGT_STATE_PROCESSED;
-		res = 0;
-		goto free;
+		return 0;
 	}
 
 	ql_dbg_qp(ql_dbg_tgt, qpair, 0xe018,
@@ -3234,8 +3233,9 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 
 	res = qlt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status,
 	    &full_req_cnt);
-	if (unlikely(res != 0))
-		goto free;
+	if (unlikely(res != 0)) {
+		return res;
+	}
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 
@@ -3255,8 +3255,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
 		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		res = 0;
-		goto free;
+		return 0;
 	}
 
 	/* Does F/W have an IOCBs for this request */
@@ -3359,8 +3358,6 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	qlt_unmap_sg(vha, cmd);
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-free:
-	vha->hw->tgt.tgt_ops->free_cmd(cmd);
 	return res;
 }
 EXPORT_SYMBOL(qlt_xmit_response);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 30959f8da065..15650a0bde09 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -653,7 +653,6 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
-	struct scsi_qla_host *vha = cmd->vha;
 
 	if (cmd->aborted) {
 		/* Cmd can loop during Q-full.  tcm_qla2xxx_aborted_task
@@ -666,7 +665,6 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 			cmd->se_cmd.transport_state,
 			cmd->se_cmd.t_state,
 			cmd->se_cmd.se_cmd_flags);
-		vha->hw->tgt.tgt_ops->free_cmd(cmd);
 		return 0;
 	}
 
@@ -694,7 +692,6 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
-	struct scsi_qla_host *vha = cmd->vha;
 	int xmit_type = QLA_TGT_XMIT_STATUS;
 
 	if (cmd->aborted) {
@@ -708,7 +705,6 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 		    cmd, kref_read(&cmd->se_cmd.cmd_kref),
 		    cmd->se_cmd.transport_state, cmd->se_cmd.t_state,
 		    cmd->se_cmd.se_cmd_flags);
-		vha->hw->tgt.tgt_ops->free_cmd(cmd);
 		return 0;
 	}
 	cmd->bufflen = se_cmd->data_length;
