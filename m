Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F897C4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 08:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 008E02072C
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 08:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="M79tHUyw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgCSIiW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 04:38:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26314 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725601AbgCSIiW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Mar 2020 04:38:22 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02J8V4SX008475;
        Thu, 19 Mar 2020 01:38:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=p0gv7ic0VhK3kivEsIXMeT6WmN16eSW61+y+6kuOc5Y=;
 b=M79tHUywJX77I3Gtc9rTsEL30n0oYMzY+Jz+9Ny39IUgjZhZhx7D2FfO4G+q67VqbLez
 w9AU2Ac2Rn4mvxyseoPeVQ0rfeWQ5VHAX3iG0ereCnETwEfbYnVGGSgFuvJ3fpCZp/F2
 wqsZ5b1eX/qCTHsrKo1YRgCcI/BDb72yE/2kJ+Xi+dsjh0i57Gll38bgJuEGIvpU+a2i
 Tbsn4yRp+pulgNS9IlX+5K77nucsPvzcOJTbbiY7DHTDKhsSHDbmm1RUHiazmAggbxSI
 X84XJa+sB68SIGerWVPCo4ONZtCcSEb8hltC3CJEesNNd7OD7sduGPyOpRh2O/7orENU MQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2yu8pqpxyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 01:38:16 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Mar
 2020 01:38:15 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 19 Mar 2020 01:38:15 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 38BDF3F704A;
        Thu, 19 Mar 2020 01:38:15 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02J8cFRb019538;
        Thu, 19 Mar 2020 01:38:15 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02J8cFMB019537;
        Thu, 19 Mar 2020 01:38:15 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 1/2] qedi: Add MFW error recovery process.
Date:   Thu, 19 Mar 2020 01:38:10 -0700
Message-ID: <20200319083811.19499-2-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200319083811.19499-1-mrangankar@marvell.com>
References: <20200319083811.19499-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_01:2020-03-18,2020-03-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds the mfw error recovery process in the qedi driver.
The process includes a partial/customized driver unload and load
to reset context by preserving active iSCSI session kernel state.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi.h      |  1 +
 drivers/scsi/qedi/qedi_main.c | 87 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 66 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index 9513fd3..812e368 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -331,6 +331,7 @@ struct qedi_ctx {
 	u16 ll2_mtu;
 
 	struct workqueue_struct *dpc_wq;
+	struct delayed_work recovery_work;
 
 	spinlock_t task_idx_lock;	/* To protect gbl context */
 	s32 last_tidx_alloc;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index acb930b..cfa705a 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -58,6 +58,7 @@
 static void qedi_reset_uio_rings(struct qedi_uio_dev *udev);
 static void qedi_ll2_free_skbs(struct qedi_ctx *qedi);
 static struct nvm_iscsi_block *qedi_get_nvram_block(struct qedi_ctx *qedi);
+static void qedi_recovery_handler(struct work_struct *work);
 
 static int qedi_iscsi_event_cb(void *context, u8 fw_event_code, void *fw_handle)
 {
@@ -1113,6 +1114,20 @@ static void qedi_get_protocol_tlv_data(void *dev, void *data)
 	return;
 }
 
+static void qedi_schedule_recovery_handler(void *dev)
+{
+	struct qedi_ctx *qedi = dev;
+
+	QEDI_ERR(&qedi->dbg_ctx, "Recovery handler scheduled.\n");
+
+	if (test_and_set_bit(QEDI_IN_RECOVERY, &qedi->flags))
+		return;
+
+	atomic_set(&qedi->link_state, QEDI_LINK_DOWN);
+
+	schedule_delayed_work(&qedi->recovery_work, 0);
+}
+
 static void qedi_link_update(void *dev, struct qed_link_output *link)
 {
 	struct qedi_ctx *qedi = (struct qedi_ctx *)dev;
@@ -1130,6 +1145,7 @@ static void qedi_link_update(void *dev, struct qed_link_output *link)
 static struct qed_iscsi_cb_ops qedi_cb_ops = {
 	{
 		.link_update =		qedi_link_update,
+		.schedule_recovery_handler = qedi_schedule_recovery_handler,
 		.get_protocol_tlv_data = qedi_get_protocol_tlv_data,
 		.get_generic_tlv_data = qedi_get_generic_tlv_data,
 	}
@@ -2328,16 +2344,18 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	struct qedi_ctx *qedi = pci_get_drvdata(pdev);
 	int rval;
 
-	if (qedi->tmf_thread) {
-		flush_workqueue(qedi->tmf_thread);
-		destroy_workqueue(qedi->tmf_thread);
-		qedi->tmf_thread = NULL;
-	}
+	if (mode == QEDI_MODE_NORMAL) {
+		if (qedi->tmf_thread) {
+			flush_workqueue(qedi->tmf_thread);
+			destroy_workqueue(qedi->tmf_thread);
+			qedi->tmf_thread = NULL;
+		}
 
-	if (qedi->offload_thread) {
-		flush_workqueue(qedi->offload_thread);
-		destroy_workqueue(qedi->offload_thread);
-		qedi->offload_thread = NULL;
+		if (qedi->offload_thread) {
+			flush_workqueue(qedi->offload_thread);
+			destroy_workqueue(qedi->offload_thread);
+			qedi->offload_thread = NULL;
+		}
 	}
 
 #ifdef CONFIG_DEBUG_FS
@@ -2353,8 +2371,7 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 		qedi_ops->ll2->stop(qedi->cdev);
 	}
 
-	if (mode == QEDI_MODE_NORMAL)
-		qedi_free_iscsi_pf_param(qedi);
+	qedi_free_iscsi_pf_param(qedi);
 
 	rval = qedi_ops->common->update_drv_state(qedi->cdev, false);
 	if (rval)
@@ -2373,9 +2390,6 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 		qedi_free_uio(qedi->udev);
 		qedi_free_itt(qedi);
 
-		iscsi_host_remove(qedi->shost);
-		iscsi_host_free(qedi->shost);
-
 		if (qedi->ll2_recv_thread) {
 			kthread_stop(qedi->ll2_recv_thread);
 			qedi->ll2_recv_thread = NULL;
@@ -2384,6 +2398,9 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 
 		if (qedi->boot_kset)
 			iscsi_boot_destroy_kset(qedi->boot_kset);
+
+		iscsi_host_remove(qedi->shost);
+		iscsi_host_free(qedi->shost);
 	}
 }
 
@@ -2435,14 +2452,12 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 		  qedi->dev_info.common.num_hwfns,
 		  qedi_ops->common->get_affin_hwfn_idx(qedi->cdev));
 
-	if (mode != QEDI_MODE_RECOVERY) {
-		rc = qedi_set_iscsi_pf_param(qedi);
-		if (rc) {
-			rc = -ENOMEM;
-			QEDI_ERR(&qedi->dbg_ctx,
-				 "Set iSCSI pf param fail\n");
-			goto free_host;
-		}
+	rc = qedi_set_iscsi_pf_param(qedi);
+	if (rc) {
+		rc = -ENOMEM;
+		QEDI_ERR(&qedi->dbg_ctx,
+			 "Set iSCSI pf param fail\n");
+		goto free_host;
 	}
 
 	qedi_ops->common->update_pf_params(qedi->cdev, &qedi->pf_params);
@@ -2633,6 +2648,8 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 			goto free_cid_que;
 		}
 
+		INIT_DELAYED_WORK(&qedi->recovery_work, qedi_recovery_handler);
+
 		/* F/w needs 1st task context memory entry for performance */
 		set_bit(QEDI_RESERVE_TASK_ID, qedi->task_idx_map);
 		atomic_set(&qedi->num_offloads, 0);
@@ -2673,6 +2690,32 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	return rc;
 }
 
+static void qedi_mark_conn_recovery(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *session = cls_session->dd_data;
+	struct iscsi_conn *conn = session->leadconn;
+	struct qedi_conn *qedi_conn = conn->dd_data;
+
+	iscsi_conn_failure(qedi_conn->cls_conn->dd_data, ISCSI_ERR_CONN_FAILED);
+}
+
+static void qedi_recovery_handler(struct work_struct *work)
+{
+	struct qedi_ctx *qedi =
+			container_of(work, struct qedi_ctx, recovery_work.work);
+
+	iscsi_host_for_each_session(qedi->shost, qedi_mark_conn_recovery);
+
+	/* Call common_ops->recovery_prolog to allow the MFW to quiesce
+	 * any PCI transactions.
+	 */
+	qedi_ops->common->recovery_prolog(qedi->cdev);
+
+	__qedi_remove(qedi->pdev, QEDI_MODE_RECOVERY);
+	__qedi_probe(qedi->pdev, QEDI_MODE_RECOVERY);
+	clear_bit(QEDI_IN_RECOVERY, &qedi->flags);
+}
+
 static int qedi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	return __qedi_probe(pdev, QEDI_MODE_NORMAL);
-- 
1.8.3.1

