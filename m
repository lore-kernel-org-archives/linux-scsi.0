Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9CEC43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 592C12080D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfLISCe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 13:02:34 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34267 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfLISCe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 13:02:34 -0500
Received: by mail-pl1-f193.google.com with SMTP id x17so856127pln.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2019 10:02:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qAmJFetc8aEZEawXUw+zzsF9jEj+i6q3XO7QXtmC4sk=;
        b=IkS4Hk3hqoIbpx0aQ4HvDkXphfa7epQrAKh1VVdeNdq+2+Qaz6e48bDbTRquuZDCld
         86j3Xi1DdLPmAQzzjEV6vpwQ0iPYdAWxS3KMuko0RY5gg5ZfIrbz5YiiHmRijdZfzy2q
         emZ09L8WhU1sW9m4B4Ap2N3II1ZHGzG2Pj4CM/vFPjVhegULb8o1mQJPYE/fFoRAdOuX
         wNK5In9+WveJa4QxWe3wVw8tKd+Bz8M8LSIsb7ULOPRJaZdSnA3i03E6qkWExZsz40L8
         risCVKNnswwbolFe5yZ6CE93YTpNHBeHbSf3q1/6cy1l5L4wS//eVYqFqCfWgGXuMe0H
         H+Vg==
X-Gm-Message-State: APjAAAX20/ZtnRLuwgOCJOWBMuR96o5i00hHzeN2gYbHd3TV/y7uPJEJ
        dLJovqfby8mjwTyuHp90exw=
X-Google-Smtp-Source: APXvYqy1mdtjEMSAbDg8GcIwt1DQaY2rCUQ9ojO0lwikt9edPh519MzlbWaqdtbthsZ02IEScvd73A==
X-Received: by 2002:a17:90a:2188:: with SMTP id q8mr270905pjc.47.1575914553111;
        Mon, 09 Dec 2019 10:02:33 -0800 (PST)
Received: from bvanassche-glaptop.roam.corp.google.com ([216.9.110.7])
        by smtp.gmail.com with ESMTPSA id f13sm132393pfa.57.2019.12.09.10.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 10:02:32 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH 2/4] qla2xxx: Simplify the code for aborting SCSI commands
Date:   Mon,  9 Dec 2019 10:02:21 -0800
Message-Id: <20191209180223.194959-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191209180223.194959-1-bvanassche@acm.org>
References: <20191209180223.194959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the SCSI core does not reuse the tag of the SCSI command that is
being aborted by .eh_abort() before .eh_abort() has finished it is not
necessary to check from inside that callback whether or not the SCSI command
has already completed. Instead, rely on the firmware to return an error code
when attempting to abort a command that has already completed. Additionally,
rely on the firmware to return an error code when attempting to abort an
already aborted command.

In qla2x00_abort_srb(), use blk_mq_request_started() instead of
sp->completed and sp->aborted.

This patch eliminates several race conditions triggered by the removed member
variables.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  3 ---
 drivers/scsi/qla2xxx/qla_isr.c |  5 -----
 drivers/scsi/qla2xxx/qla_os.c  | 15 ++-------------
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 460f443f6471..ab7424318ee8 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -597,9 +597,6 @@ typedef struct srb {
 	struct fc_port *fcport;
 	struct scsi_qla_host *vha;
 	unsigned int start_timer:1;
-	unsigned int abort:1;
-	unsigned int aborted:1;
-	unsigned int completed:1;
 
 	uint32_t handle;
 	uint16_t flags;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 2601d7673c37..721a8d83e350 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2487,11 +2487,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		return;
 	}
 
-	if (sp->abort)
-		sp->aborted = 1;
-	else
-		sp->completed = 1;
-
 	if (sp->cmd_type != TYPE_SRB) {
 		req->outstanding_cmds[handle] = NULL;
 		ql_dbg(ql_dbg_io, vha, 0x3015,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 145ea93206f0..2231d99d311b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1253,17 +1253,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		return SUCCESS;
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
-	if (sp->completed) {
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		return SUCCESS;
-	}
-
-	if (sp->abort || sp->aborted) {
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		return FAILED;
-	}
-
-	sp->abort = 1;
 	sp->comp = &comp;
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
@@ -1696,6 +1685,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 	DECLARE_COMPLETION_ONSTACK(comp);
 	scsi_qla_host_t *vha = qp->vha;
 	struct qla_hw_data *ha = vha->hw;
+	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	int rval;
 	bool ret_cmd;
 	uint32_t ratov_j;
@@ -1717,7 +1707,6 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		sp->comp = &comp;
-		sp->abort =  1;
 		spin_unlock_irqrestore(qp->qp_lock_ptr, *flags);
 
 		rval = ha->isp_ops->abort_command(sp);
@@ -1741,7 +1730,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && (!sp->completed || !sp->aborted))
+		if (ret_cmd && blk_mq_request_started(cmd->request))
 			sp->done(sp, res);
 	} else {
 		sp->done(sp, res);
