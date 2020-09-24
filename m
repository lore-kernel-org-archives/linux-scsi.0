Return-Path: <SRS0=Lz4Y=DB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B22C2D0E2
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 07:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 476C62395B
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Sep 2020 07:05:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ffI/pVo8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgIXHFH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Sep 2020 03:05:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28148 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727001AbgIXHFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Sep 2020 03:05:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08O71lIK027063;
        Thu, 24 Sep 2020 00:05:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=EOQ/zwNbTW4g389GNF116KR4PV8d4TVGoYxGRUZ7mv8=;
 b=ffI/pVo8pWtTuVH7zNZpjGSni+mliB/o7nR/MmHu3BHv1LOHaisLBInoVuCKLQaOBUKX
 sYJSJq79BNEIr5sToquR9LeGqSpBn1FHrHAV8K0msT/bk0yk9dpJfSgI3UKbLyPtNDDn
 K5W1mOB9bGsWTmqj48Ok1MLF0SLG9EvmL+ddWYr7PCmZ4HLs77txGDcjQu57KiWX9sAr
 aoGA5sYB6yhlkVZPulgWsuqQOZ7sQnQPtjAirmLO3KimG5VvfYYs8zdB/HDDV2hNznNS
 gpdpZXh1syDPtp7WfT6QbXPaDPZnyBany8p3+3azbNqE/tETmhW6lsjKGLrddsb9znYe gQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33nhgnjjyy-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 24 Sep 2020 00:05:00 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 24 Sep
 2020 00:04:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Sep 2020 00:04:03 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EB6A33F704A;
        Thu, 24 Sep 2020 00:04:02 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08O742Oq008313;
        Thu, 24 Sep 2020 00:04:02 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08O742Dh008304;
        Thu, 24 Sep 2020 00:04:02 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH] qedi: Add schedule_hw_err_handler callback for fan failure
Date:   Thu, 24 Sep 2020 00:03:38 -0700
Message-ID: <20200924070338.8270-1-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_02:2020-09-24,2020-09-24 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On fan failure event from MFW, bring down active connections,
and unload the firmware context.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi.h      |  1 +
 drivers/scsi/qedi/qedi_main.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index 7e59d50f2fab..c342defc3f52 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -339,6 +339,7 @@ struct qedi_ctx {
 
 	struct workqueue_struct *dpc_wq;
 	struct delayed_work recovery_work;
+	struct delayed_work board_disable_work;
 
 	spinlock_t task_idx_lock;	/* To protect gbl context */
 	s32 last_tidx_alloc;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 10a7ee055552..ff71ea2589a8 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1133,6 +1133,9 @@ void qedi_schedule_hw_err_handler(void *dev,
 		  err_type, qedi->qedi_err_flags);
 
 	switch (err_type) {
+	case QED_HW_ERR_FAN_FAIL:
+		schedule_delayed_work(&qedi->board_disable_work, 0);
+		break;
 	case QED_HW_ERR_MFW_RESP_FAIL:
 	case QED_HW_ERR_HW_ATTN:
 	case QED_HW_ERR_DMAE_FAIL:
@@ -2486,6 +2489,21 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	}
 }
 
+static void qedi_board_disable_work(struct work_struct *work)
+{
+	struct qedi_ctx *qedi =
+			container_of(work, struct qedi_ctx,
+				     board_disable_work.work);
+
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+		  "Fan failure, Unloading firmware context.\n");
+
+	if (test_and_set_bit(QEDI_IN_SHUTDOWN, &qedi->flags))
+		return;
+
+	__qedi_remove(qedi->pdev, QEDI_MODE_SHUTDOWN);
+}
+
 static void qedi_shutdown(struct pci_dev *pdev)
 {
 	struct qedi_ctx *qedi = pci_get_drvdata(pdev);
@@ -2753,6 +2771,8 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 		}
 
 		INIT_DELAYED_WORK(&qedi->recovery_work, qedi_recovery_handler);
+		INIT_DELAYED_WORK(&qedi->board_disable_work,
+				  qedi_board_disable_work);
 
 		/* F/w needs 1st task context memory entry for performance */
 		set_bit(QEDI_RESERVE_TASK_ID, qedi->task_idx_map);
-- 
2.25.0

