Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9285C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A0A421897
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:27:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="C8vLWlMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgIHF1f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 01:27:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17246 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728474AbgIHF1d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 01:27:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0885Pi86023737;
        Mon, 7 Sep 2020 22:27:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Ped2MNEA3rEX3TVjaToI4HiAugNR0AKMDtTTs4w2mI4=;
 b=C8vLWlMZsOLMBYGe55VUP2yLefL/R9uDPJE3PqXqTyFn82E2OUegKLpe2p4Z42RUySRy
 b65SYOsBL7j/OCshs+ohmP2FXRa9vx6IMQ/4z21ULpR1kz3fAWZhwym1TRLYXrnS3ROf
 nrF8DYqo4wn+p7SuZzvNjodq2DOFIk37sLDHCTNWwkB6i2s2aUx5JOSGNX2K4KNyLQXt
 Dhno8Sv3azHq5E9tG7ZNheyrQC35keg0exp8KOJwh1TCWy5ATZkdQNX7Ncmler5btQ+1
 zYQ8/bU3JrIk0BN0FzXpwq6TZJt6JB8aiA4ePIlyvpv9OvvGydPIMpc+d2D4QpLF/2Pt aA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pt6en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 22:27:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 22:27:26 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 22:27:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 22:27:25 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 881253F703F;
        Mon,  7 Sep 2020 22:27:25 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0885RPaX022005;
        Mon, 7 Sep 2020 22:27:25 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0885RPvm022004;
        Mon, 7 Sep 2020 22:27:25 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 7/8] qedi: Add firmware error recovery invocation support.
Date:   Mon, 7 Sep 2020 22:24:11 -0700
Message-ID: <20200908052412.21917-8-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200908052412.21917-1-mrangankar@marvell.com>
References: <20200908052412.21917-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_02:2020-09-07,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add support to initiate MFW process recovery for all
the devices if storage function receive the event first.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi.h       |  4 +++
 drivers/scsi/qedi/qedi_fw.c    |  7 ++--
 drivers/scsi/qedi/qedi_iscsi.c |  3 +-
 drivers/scsi/qedi/qedi_main.c  | 61 +++++++++++++++++++++++++++++++++-
 4 files changed, 71 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index 9c19ec9dc682..7e59d50f2fab 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -274,6 +274,10 @@ struct qedi_ctx {
 	spinlock_t ll2_lock;	/* Light L2 lock */
 	spinlock_t hba_lock;	/* per port lock */
 	struct task_struct *ll2_recv_thread;
+	unsigned long qedi_err_flags;
+#define QEDI_ERR_ATTN_CLR_EN	0
+#define QEDI_ERR_IS_RECOVERABLE	2
+#define QEDI_ERR_OVERRIDE_EN	31
 	unsigned long flags;
 #define UIO_DEV_OPENED		1
 #define QEDI_IOTHREAD_WAKE	2
diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index f158fde0a43c..440ddd2309f1 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1267,7 +1267,8 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
 	rval  = wait_event_interruptible_timeout(qedi_conn->wait_queue,
 						 ((qedi_conn->cmd_cleanup_req ==
 						 qedi_conn->cmd_cleanup_cmpl) ||
-						 qedi_conn->ep),
+						 test_bit(QEDI_IN_RECOVERY,
+							  &qedi->flags)),
 						 5 * HZ);
 	if (rval) {
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
@@ -1292,7 +1293,9 @@ int qedi_cleanup_all_io(struct qedi_ctx *qedi, struct qedi_conn *qedi_conn,
 	/* Enable IOs for all other sessions except current.*/
 	if (!wait_event_interruptible_timeout(qedi_conn->wait_queue,
 					      (qedi_conn->cmd_cleanup_req ==
-					       qedi_conn->cmd_cleanup_cmpl),
+					       qedi_conn->cmd_cleanup_cmpl) ||
+					       test_bit(QEDI_IN_RECOVERY,
+							&qedi->flags),
 					      5 * HZ)) {
 		iscsi_host_for_each_session(qedi->shost,
 					    qedi_mark_device_available);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index ae86a40ca040..08c05403cd72 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1072,7 +1072,8 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	qedi_ep->state = EP_STATE_DISCONN_START;
 
-	if (test_bit(QEDI_IN_SHUTDOWN, &qedi->flags))
+	if (test_bit(QEDI_IN_SHUTDOWN, &qedi->flags) ||
+	    test_bit(QEDI_IN_RECOVERY, &qedi->flags))
 		goto ep_release_conn;
 
 	ret = qedi_ops->destroy_conn(qedi->cdev, qedi_ep->handle, abrt_conn);
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 4f43e2a24b50..28b5d6670580 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -50,6 +50,10 @@ module_param(qedi_ll2_buf_size, uint, 0644);
 MODULE_PARM_DESC(qedi_ll2_buf_size,
 		 "parameter to set ping packet size, default - 0x400, Jumbo packets - 0x2400.");
 
+static uint qedi_flags_override;
+module_param(qedi_flags_override, uint, 0644);
+MODULE_PARM_DESC(qedi_flags_override, "Disable/Enable MFW error flags bits action.");
+
 const struct qed_iscsi_ops *qedi_ops;
 static struct scsi_transport_template *qedi_scsi_transport;
 static struct pci_driver qedi_pci_driver;
@@ -1113,6 +1117,39 @@ static void qedi_get_protocol_tlv_data(void *dev, void *data)
 	return;
 }
 
+void qedi_schedule_hw_err_handler(void *dev,
+				  enum qed_hw_err_type err_type)
+{
+	struct qedi_ctx *qedi = (struct qedi_ctx *)dev;
+	unsigned long override_flags = qedi_flags_override;
+
+	if (override_flags && test_bit(QEDI_ERR_OVERRIDE_EN, &override_flags))
+		qedi->qedi_err_flags = qedi_flags_override;
+
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+		  "HW error handler scheduled, err=%d err_flags=0x%x\n",
+		  err_type, qedi->qedi_err_flags);
+
+	switch (err_type) {
+	case QED_HW_ERR_MFW_RESP_FAIL:
+	case QED_HW_ERR_HW_ATTN:
+	case QED_HW_ERR_DMAE_FAIL:
+	case QED_HW_ERR_RAMROD_FAIL:
+	case QED_HW_ERR_FW_ASSERT:
+		/* Prevent HW attentions from being reasserted */
+		if (test_bit(QEDI_ERR_ATTN_CLR_EN, &qedi->qedi_err_flags))
+			qedi_ops->common->attn_clr_enable(qedi->cdev, true);
+
+		if (err_type == QED_HW_ERR_RAMROD_FAIL &&
+		    test_bit(QEDI_ERR_IS_RECOVERABLE, &qedi->qedi_err_flags))
+			qedi_ops->common->recovery_process(qedi->cdev);
+
+		break;
+	default:
+		break;
+	}
+}
+
 static void qedi_schedule_recovery_handler(void *dev)
 {
 	struct qedi_ctx *qedi = dev;
@@ -1155,6 +1192,7 @@ static struct qed_iscsi_cb_ops qedi_cb_ops = {
 	{
 		.link_update =		qedi_link_update,
 		.schedule_recovery_handler = qedi_schedule_recovery_handler,
+		.schedule_hw_err_handler = qedi_schedule_hw_err_handler,
 		.get_protocol_tlv_data = qedi_get_protocol_tlv_data,
 		.get_generic_tlv_data = qedi_get_generic_tlv_data,
 	}
@@ -2355,6 +2393,7 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 {
 	struct qedi_ctx *qedi = pci_get_drvdata(pdev);
 	int rval;
+	u16 retry = 10;
 
 	if (mode == QEDI_MODE_SHUTDOWN)
 		iscsi_host_for_each_session(qedi->shost,
@@ -2383,7 +2422,13 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	qedi_sync_free_irqs(qedi);
 
 	if (!test_bit(QEDI_IN_OFFLINE, &qedi->flags)) {
-		qedi_ops->stop(qedi->cdev);
+		while (retry--) {
+			rval = qedi_ops->stop(qedi->cdev);
+			if (rval < 0)
+				msleep(1000);
+			else
+				break;
+		}
 		qedi_ops->ll2->stop(qedi->cdev);
 	}
 
@@ -2442,6 +2487,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	struct qed_probe_params qed_params;
 	void *task_start, *task_end;
 	int rc;
+	u16 retry = 10;
 
 	if (mode != QEDI_MODE_RECOVERY) {
 		qedi = qedi_host_alloc(pdev);
@@ -2453,6 +2499,10 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 		qedi = pci_get_drvdata(pdev);
 	}
 
+retry_probe:
+	if (mode == QEDI_MODE_RECOVERY)
+		msleep(2000);
+
 	memset(&qed_params, 0, sizeof(qed_params));
 	qed_params.protocol = QED_PROTOCOL_ISCSI;
 	qed_params.dp_module = qedi_qed_debug;
@@ -2460,11 +2510,20 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	qed_params.is_vf = is_vf;
 	qedi->cdev = qedi_ops->common->probe(pdev, &qed_params);
 	if (!qedi->cdev) {
+		if (mode == QEDI_MODE_RECOVERY && retry) {
+			QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+				  "Retry %d initialize hardware\n", retry);
+			retry--;
+			goto retry_probe;
+		}
+
 		rc = -ENODEV;
 		QEDI_ERR(&qedi->dbg_ctx, "Cannot initialize hardware\n");
 		goto free_host;
 	}
 
+	set_bit(QEDI_ERR_ATTN_CLR_EN, &qedi->qedi_err_flags);
+	set_bit(QEDI_ERR_IS_RECOVERABLE, &qedi->qedi_err_flags);
 	atomic_set(&qedi->link_state, QEDI_LINK_DOWN);
 
 	rc = qedi_ops->fill_dev_info(qedi->cdev, &qedi->dev_info);
-- 
2.25.0

