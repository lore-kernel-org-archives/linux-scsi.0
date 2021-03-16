Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDF1C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A60065039
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhCPD5U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:57:20 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:39309 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbhCPD5D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:57:03 -0400
Received: by mail-pf1-f174.google.com with SMTP id 18so7926231pfo.6
        for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2021 20:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QMQlvBfwxf5ebBmPCGV5LSTvfi+WVBoe9VdUPym0BDA=;
        b=Cjoy3Dih4JAuAjtNk+FfswnL+VfeSc5px8HwXTbWMAResBgJ4M5le2XIU117aZQgie
         uMWXhquePUHByk5wd+Q1H71zJG4EBJagMPc4bdr7AMS8IsOFsu+Kp/syhccEShgi8coU
         ym+AefLi3JHfzv8D2nV7CK/yYHBNNW8dfAQLNY/WsA14wudsCipUAEk7WL03ov5NI15U
         DUZpnJooZlCPyqF4vQ2Yg61PvJAcr86VM3xlvMw6Jman03NTk1CSrDpyNAQQIYKvZtUR
         U6U6ZrTvJPVLG9MrHYLVzSIn4QXhSq6EL9g1CRxVayUpuNdM4HVOB/7Uxzz2/UgJ/Bg3
         ZVog==
X-Gm-Message-State: AOAM5318RD7dL0mx057+vcwpZEhPesYYIz2zY5epcAHHtV1KFJCjBsOj
        eFGrihxW/7ZHIdm6vqpTeSw=
X-Google-Smtp-Source: ABdhPJzhECc2Mcg0VV40FME1HzygybiLQv6nq0eO6ohXPs6udNpM2fPpBxWCHcF2cAisM6UqYMXLkQ==
X-Received: by 2002:a62:76c5:0:b029:1f2:e6af:e2ab with SMTP id r188-20020a6276c50000b02901f2e6afe2abmr13427541pfc.10.1615867022924;
        Mon, 15 Mar 2021 20:57:02 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:8641:766a:ce30:8278])
        by smtp.gmail.com with ESMTPSA id fs9sm1031673pjb.40.2021.03.15.20.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 20:57:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 1/7] Revert "qla2xxx: Make sure that aborted commands are freed"
Date:   Mon, 15 Mar 2021 20:56:49 -0700
Message-Id: <20210316035655.2835-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316035655.2835-1-bvanassche@acm.org>
References: <20210316035655.2835-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calling vha->hw->tgt.tgt_ops->free_cmd() from qlt_xmit_response() is wrong
since the command for which a response is sent must remain valid until the
SCSI target core calls .release_cmd().

Fixes: 0dcec41acb85 ("scsi: qla2xxx: Make sure that aborted commands are freed")
Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
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
