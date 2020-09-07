Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B12EC2D0E4
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 12:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 005AF215A4
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 12:17:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SIjt1g8i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgIGMRk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 08:17:40 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49866 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729297AbgIGMRg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 08:17:36 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087C4oXj017242
        for <linux-scsi@vger.kernel.org>; Mon, 7 Sep 2020 05:17:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=yWqhTubkQisJFnXCFWxvOjrvJ1SA+LfkQnMq7DzNrho=;
 b=SIjt1g8iqeNcdF0f5EN6KeFiSo/1RUw+EFiPbr6p26t8Z6zitWhUyIVzzjwZWhs+qDwJ
 /PIJguIm3p92ixsh9hN7u4E+K62Amu36ystQOvhUKARnTcvTyQ66/PVqgCxDfPavZ7W1
 +cf8+adoZqECL6fWJjAXlAToaOududMWvglTV25Fu9lAmgh8tNImamvufUISHlxxjtlF
 797fT3oiYC5o5iwwVcjkcICFQEta+XdZMr/6ZfndUSecS/VAGBytoasGE5D/Hrt9ct4C
 MEvB5RO3ZBfD6U004Qu7OD2WB8PlZMVOwUTdqZhzRQ8aZ1JlhbkXKFMJGYPwwp0K28vH sg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvqxnfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2020 05:17:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 05:17:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 05:17:32 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AEFCD3F703F;
        Mon,  7 Sep 2020 05:17:32 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 087CHWPm005234;
        Mon, 7 Sep 2020 05:17:32 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 087CHWeq005233;
        Mon, 7 Sep 2020 05:17:32 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 6/8] qedf: Add schedule_hw_err_handler callback for fan failure
Date:   Mon, 7 Sep 2020 05:14:41 -0700
Message-ID: <20200907121443.5150-7-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200907121443.5150-1-jhasan@marvell.com>
References: <20200907121443.5150-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_06:2020-09-07,2020-09-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

 On fan failure, disable the PCI function and initiate recovery for ramrod
 failure.


Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf.h      |  4 ++++
 drivers/scsi/qedf/qedf_main.c | 45 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 15d6cbe..0e2cbb1 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -389,6 +389,7 @@ struct qedf_ctx {
 	mempool_t *io_mempool;
 	struct workqueue_struct *dpc_wq;
 	struct delayed_work recovery_work;
+	struct delayed_work board_disable_work;
 	struct delayed_work grcdump_work;
 	struct delayed_work stag_work;
 
@@ -541,6 +542,9 @@ extern void qedf_process_seq_cleanup_compl(struct qedf_ctx *qedf,
 extern void qedf_wq_grcdump(struct work_struct *work);
 void qedf_stag_change_work(struct work_struct *work);
 void qedf_ctx_soft_reset(struct fc_lport *lport);
+extern void qedf_board_disable_work(struct work_struct *work);
+extern void qedf_schedule_hw_err_handler(void *dev,
+		enum qed_hw_err_type err_type);
 
 #define FCOE_WORD_TO_BYTE  4
 #define QEDF_MAX_TASK_NUM	0xFFFF
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 50af70a..3a45ca7 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -104,6 +104,12 @@
 MODULE_PARM_DESC(dp_level, " printk verbosity control passed to qed module  "
 	"during probe (0-3: 0 more verbose).");
 
+static bool qedf_enable_recovery = true;
+module_param_named(enable_recovery, qedf_enable_recovery,
+		bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(enable_recovery, "Enable/disable recovery on driver/firmware "
+		"interface level errors 0 = Disabled, 1 = Enabled (Default: 1).");
+
 struct workqueue_struct *qedf_io_wq;
 
 static struct fcoe_percpu_s qedf_global;
@@ -668,6 +674,7 @@ static u32 qedf_get_login_failures(void *cookie)
 		.dcbx_aen = qedf_dcbx_handler,
 		.get_generic_tlv_data = qedf_get_generic_tlv_data,
 		.get_protocol_tlv_data = qedf_get_protocol_tlv_data,
+		.schedule_hw_err_handler = qedf_schedule_hw_err_handler,
 	}
 };
 
@@ -3777,6 +3784,44 @@ void qedf_wq_grcdump(struct work_struct *work)
 	qedf_capture_grc_dump(qedf);
 }
 
+void qedf_schedule_hw_err_handler(void *dev, enum qed_hw_err_type err_type)
+{
+	struct qedf_ctx *qedf = dev;
+
+	QEDF_ERR(&(qedf->dbg_ctx),
+			"Hardware error handler scheduled, event=%d.\n",
+			err_type);
+
+	if (test_bit(QEDF_IN_RECOVERY, &qedf->flags)) {
+		QEDF_ERR(&(qedf->dbg_ctx),
+				"Already in recovery, not scheduling board disable work.\n");
+		return;
+	}
+
+	switch (err_type) {
+	case QED_HW_ERR_FAN_FAIL:
+		schedule_delayed_work(&qedf->board_disable_work, 0);
+		break;
+	case QED_HW_ERR_MFW_RESP_FAIL:
+	case QED_HW_ERR_HW_ATTN:
+	case QED_HW_ERR_DMAE_FAIL:
+	case QED_HW_ERR_FW_ASSERT:
+		/* Prevent HW attentions from being reasserted */
+		qed_ops->common->attn_clr_enable(qedf->cdev, true);
+		break;
+	case QED_HW_ERR_RAMROD_FAIL:
+		/* Prevent HW attentions from being reasserted */
+		qed_ops->common->attn_clr_enable(qedf->cdev, true);
+
+		if (qedf_enable_recovery)
+			qed_ops->common->recovery_process(qedf->cdev);
+
+		break;
+	default:
+		break;
+	}
+}
+
 /*
  * Protocol TLV handler
  */
-- 
1.8.3.1

