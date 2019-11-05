Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16519C5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFA44206BA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="btrCo6FP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbfKEPHG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:07:06 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42092 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730939AbfKEPHG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:07:06 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5ExqwS009704;
        Tue, 5 Nov 2019 07:07:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=aMXd0BHyPFU1wmygVVQHyTuafDcmyHLZVNaqMzwxvRM=;
 b=btrCo6FPt3OVhsIwTGxGD6uvxlrMp1Rs8O0PTNelFkcE7OMnBb9bh7ymFW3Pnw7wEXo/
 aRqv1q+HVFXH35KnvAFM/ldVSsxBhY8/tR3fCq3/0f7qK6jOzMmdLo1xB1PuONmQPXSc
 Rr/yQ9cyWDA79Ce/AnSH5sJkAac4DLvtZ9t+mOreaC12nW5KrIPRmR2Sfq6b0qKRfOgQ
 o7zxCXhYVB3Ee4gu2pgfw+zwm6UHWVBCMg3atkv1dKZ9AIXi7ssYhev4/lI8PVAI0MQ3
 8guc2TzqudIeRExBJtvQMba4sTQRZB72ZVvn4uA017oDoQ0MJ1TDVcjwUrggSHB+k66I Eg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w17n93cks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 07:07:04 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 07:07:03 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 5 Nov 2019 07:07:03 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B05873F7040;
        Tue,  5 Nov 2019 07:07:03 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA5F73Ys008143;
        Tue, 5 Nov 2019 07:07:03 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA5F73tj008134;
        Tue, 5 Nov 2019 07:07:03 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/8] qla2xxx: Do command completion on abort timeout
Date:   Tue, 5 Nov 2019 07:06:51 -0800
Message-ID: <20191105150657.8092-3-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191105150657.8092-1-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_05:2019-11-05,2019-11-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On switch, fabric and mgt command timeout, driver
send Abort to tell FW to return the original command.
If abort is timeout, then return both Abort and
original command for cleanup.

Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
Cc: stable@vger.kernel.org # 5.2
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 721ee7f09b39..ef9bb3c7ad6f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -604,6 +604,7 @@ typedef struct srb {
 	const char *name;
 	int iocbs;
 	struct qla_qpair *qpair;
+	struct srb *cmd_sp;
 	struct list_head elem;
 	u32 gen1;	/* scratch */
 	u32 gen2;	/* scratch */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5db8ad832893..7fdbe041cc19 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -101,8 +101,22 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	u32 handle;
 	unsigned long flags;
 
+	if (sp->cmd_sp)
+		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
+		    "Abort timeout - cmd hdl=%x, cmd type=%x hdl=%x, type=%x\n",
+		    sp->cmd_sp->handle, sp->cmd_sp->type,
+		    sp->handle, sp->type);
+	else
+		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
+		    "Abort timeout 2 - hdl=%x, type=%x\n",
+		    sp->handle, sp->type);
+
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	for (handle = 1; handle < qpair->req->num_outstanding_cmds; handle++) {
+		if (sp->cmd_sp && (qpair->req->outstanding_cmds[handle] ==
+		    sp->cmd_sp))
+			qpair->req->outstanding_cmds[handle] = NULL;
+
 		/* removing the abort */
 		if (qpair->req->outstanding_cmds[handle] == sp) {
 			qpair->req->outstanding_cmds[handle] = NULL;
@@ -111,6 +125,9 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
+	if (sp->cmd_sp)
+		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
+
 	abt->u.abt.comp_status = CS_TIMEOUT;
 	sp->done(sp, QLA_OS_TIMER_EXPIRED);
 }
@@ -142,6 +159,7 @@ static int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
 	sp->qpair = cmd_sp->qpair;
+	sp->cmd_sp = cmd_sp;
 	if (wait)
 		sp->flags = SRB_WAKEUP_ON_COMP;
 
-- 
2.12.0

