Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FE2C3404C
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C87B724670
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgBTEew (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:34:52 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53104 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgBTEew (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 23:34:52 -0500
Received: by mail-pj1-f66.google.com with SMTP id ep11so333078pjb.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 20:34:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d+OMZN1nf2SoER6CxOMCRAYjygornAleHITm2IYaiKY=;
        b=QZgs9DR0M5IrLSL9rdgKBIt+FsdEPQYqWCzgwjIY6wVQfvH2CRcwfqxv7GNxeKtwlC
         NLimYsAnNJapkWmL3onA3OMUEq3qnDYyxxkDAse6SV8pK5tCE6dyg1ph/Ve7UVD/o6N6
         JNx9k8QZWcxvolaUBvUQSRGxrGtqmNkTo+CYzQDsTpLYhfaH/bkDws7lNmusddKAag+K
         F8ac/8sU2C5IxhsRg29tErxue2KCNuEC5qxeL2/UXht48itlYbbMt5qQhiJPb0Qe/NHm
         DwnjE8xwgSy6oPj88hziS904EtskqOHxLq0jrH2eIMxdwnJ0dEoc6wIcV4Y21XYo3uEk
         cj8Q==
X-Gm-Message-State: APjAAAWRgA5w8O0wSVLcayoZxqHtx47x9LbnX/6VFXHQseqAGrxL/EZR
        0sgoDi1jc9PcG2dwtRw/id4=
X-Google-Smtp-Source: APXvYqxp5qBw0X0mIkRpjkDWZhLO7CwebMpZyxx/KImde4a6J/Ni+oVNdg6E6vQRNgkRrm2GsJSd+A==
X-Received: by 2002:a17:902:82c9:: with SMTP id u9mr29085282plz.264.1582173289838;
        Wed, 19 Feb 2020 20:34:49 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:29a7:b1bb:5b40:3d61])
        by smtp.gmail.com with ESMTPSA id b5sm1236263pfb.179.2020.02.19.20.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 20:34:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 1/5] qla2xxx: Simplify the code for aborting SCSI commands
Date:   Wed, 19 Feb 2020 20:34:37 -0800
Message-Id: <20200220043441.20504-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220043441.20504-1-bvanassche@acm.org>
References: <20200220043441.20504-1-bvanassche@acm.org>
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

Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  3 ---
 drivers/scsi/qla2xxx/qla_isr.c |  5 -----
 drivers/scsi/qla2xxx/qla_os.c  | 27 ++++++++++++++-------------
 3 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ed32e9715794..c5a067f45005 100644
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
index e40705d38cea..c7c86a432b55 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2516,11 +2516,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
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
index 79387ac8936f..a34f27b2d602 100644
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
 
@@ -1688,6 +1677,10 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	return QLA_SUCCESS;
 }
 
+/*
+ * The caller must ensure that no completion interrupts will happen
+ * while this function is in progress.
+ */
 static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 			      unsigned long *flags)
 	__releases(qp->qp_lock_ptr)
@@ -1696,6 +1689,7 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 	DECLARE_COMPLETION_ONSTACK(comp);
 	scsi_qla_host_t *vha = qp->vha;
 	struct qla_hw_data *ha = vha->hw;
+	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	int rval;
 	bool ret_cmd;
 	uint32_t ratov_j;
@@ -1717,7 +1711,6 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		sp->comp = &comp;
-		sp->abort =  1;
 		spin_unlock_irqrestore(qp->qp_lock_ptr, *flags);
 
 		rval = ha->isp_ops->abort_command(sp);
@@ -1741,13 +1734,17 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 		}
 
 		spin_lock_irqsave(qp->qp_lock_ptr, *flags);
-		if (ret_cmd && (!sp->completed || !sp->aborted))
+		if (ret_cmd && blk_mq_request_started(cmd->request))
 			sp->done(sp, res);
 	} else {
 		sp->done(sp, res);
 	}
 }
 
+/*
+ * The caller must ensure that no completion interrupts will happen
+ * while this function is in progress.
+ */
 static void
 __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 {
@@ -1794,6 +1791,10 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 	spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
 }
 
+/*
+ * The caller must ensure that no completion interrupts will happen
+ * while this function is in progress.
+ */
 void
 qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 {
