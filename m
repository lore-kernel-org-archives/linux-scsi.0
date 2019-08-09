Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAEFC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59774216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405315AbfHIDDn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34627 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:42 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so45223013pfo.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PJrw8cMVO88kOFJwYruXSzVX89ZnvaxLf5VkuBdqF3Y=;
        b=imHEZjOUixJznfqFueTmSCMWVSsz73QaEh7QVyI7rgAeSyGEIAW1SZR7VD5YMMSH+J
         wBbruEIT/0y42QpSbAMiQTI0nfIsmiv+u9Z0oBOqXnaDTe9NXw4OfUkgRpn0PIicjFW5
         TEhIpdbKZUjKJbFeFUlN4/wBt9eE8h76ywub4dKZeNmWiEzRrM3LBBVCwbPOrFvA4A6C
         XwDTESe1bTdTKeCkRHj/KNLHzdFSSHl0TqPtI6v8jzgmJNXZB6yQYJ0IjMxtJuQubZqL
         36o2tGjitvUKUm0VYZXNH6Pv0TDOksTt6hV0mkm4Nwy9VKkPoeExuEVXuy3X+3c27hU8
         oUvg==
X-Gm-Message-State: APjAAAWKPbae+l0KS2IYLM8Uyd43IBq0F9jIEEHLoYCWSFQz13BjQ3G2
        ZHNRGOz7Tn6lW0Xoe/DIxjA=
X-Google-Smtp-Source: APXvYqzVUbatpDNAyyp0FUAkq41xRWGQaHFKRF5DfboTmxtUTwL94K6Mu/fi1X3jV0FbVdPZPpxNZA==
X-Received: by 2002:a17:90a:b947:: with SMTP id f7mr174256pjw.63.1565319821879;
        Thu, 08 Aug 2019 20:03:41 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 49/58] qla2xxx: Make sure that aborted commands are freed
Date:   Thu,  8 Aug 2019 20:02:10 -0700
Message-Id: <20190809030219.11296-50-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The LIO core requires that the target driver callback functions
.queue_data_in() and .queue_status() call target_put_sess_cmd() or
transport_generic_free_cmd(). These calls may happen synchronously or
asynchronously. Make sure that one of these LIO functions is called
in case a command has been aborted. This patch avoids that the code
for removing a session hangs due to commands that do not make progress.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: 694833ee00c4 ("scsi: tcm_qla2xxx: Do not allow aborted cmd to advance.") # v4.13.
Fixes: a07100e00ac4 ("qla2xxx: Fix TMR ABORT interaction issue between qla2xxx and TCM") # v4.5.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c  | 13 ++++++++-----
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  4 ++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cc0c99b5f3fb..0ffda6171614 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3206,7 +3206,8 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	if (!qpair->fw_started || (cmd->reset_count != qpair->chip_reset) ||
 	    (cmd->sess && cmd->sess->deleted)) {
 		cmd->state = QLA_TGT_STATE_PROCESSED;
-		return 0;
+		res = 0;
+		goto free;
 	}
 
 	ql_dbg_qp(ql_dbg_tgt, qpair, 0xe018,
@@ -3217,9 +3218,8 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 
 	res = qlt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status,
 	    &full_req_cnt);
-	if (unlikely(res != 0)) {
-		return res;
-	}
+	if (unlikely(res != 0))
+		goto free;
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 
@@ -3239,7 +3239,8 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
 		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		return 0;
+		res = 0;
+		goto free;
 	}
 
 	/* Does F/W have an IOCBs for this request */
@@ -3342,6 +3343,8 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	qlt_unmap_sg(vha, cmd);
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
+free:
+	vha->hw->tgt.tgt_ops->free_cmd(cmd);
 	return res;
 }
 EXPORT_SYMBOL(qlt_xmit_response);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 963c220f8ba8..042a24314edc 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -620,6 +620,7 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
+	struct scsi_qla_host *vha = cmd->vha;
 
 	if (cmd->aborted) {
 		/* Cmd can loop during Q-full.  tcm_qla2xxx_aborted_task
@@ -632,6 +633,7 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 			cmd->se_cmd.transport_state,
 			cmd->se_cmd.t_state,
 			cmd->se_cmd.se_cmd_flags);
+		vha->hw->tgt.tgt_ops->free_cmd(cmd);
 		return 0;
 	}
 
@@ -659,6 +661,7 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
+	struct scsi_qla_host *vha = cmd->vha;
 	int xmit_type = QLA_TGT_XMIT_STATUS;
 
 	if (cmd->aborted) {
@@ -672,6 +675,7 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 		    cmd, kref_read(&cmd->se_cmd.cmd_kref),
 		    cmd->se_cmd.transport_state, cmd->se_cmd.t_state,
 		    cmd->se_cmd.se_cmd_flags);
+		vha->hw->tgt.tgt_ops->free_cmd(cmd);
 		return 0;
 	}
 	cmd->bufflen = se_cmd->data_length;
-- 
2.22.0

