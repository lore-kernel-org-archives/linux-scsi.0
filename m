Return-Path: <SRS0=Qc7/=5E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11AEC4332D
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 08:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A0F720724
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Mar 2020 08:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="K2I/HtzA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgCSIiZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 04:38:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32580 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725601AbgCSIiZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Mar 2020 04:38:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02J8V4bV008482;
        Thu, 19 Mar 2020 01:38:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=0ICKFoMKe8BCdolMWqr5gcBFn5r6HFU5u4Qos2tlV8A=;
 b=K2I/HtzAzqZmWEt7lAhKHKSeZrSUQ7qLOrE3DTa1mjYoesopWjwBhAeCHKWNptMXf3Tn
 c1Rt0k3TLBM1/RVUvpEUzrTE//G6ZFSBoDrM7rWqavzMYERCP7PY85uYBS42AjqoOUKk
 locUai904CtVmIIqCyg9v9oAtb8W34Mx79FaQeLF7swNUCsLn37zwssuGaES9e4MDUSi
 k7bFaP+x2TozOLhaCsmqeV5/cJwpBXSaZSKUbTqxSHeE4dQsOPLfMXHOg1poG4/tDRmY
 ukbmfVSFmV8fvPeRaJlstwhwokIuFmClOz4x7vLter0ObvSvUVw+gkDvCceMW6mmSWqV bw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2yu8pqpxyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Mar 2020 01:38:19 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Mar
 2020 01:38:18 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 19 Mar 2020 01:38:18 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6F63E3F703F;
        Thu, 19 Mar 2020 01:38:18 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02J8cIjY019542;
        Thu, 19 Mar 2020 01:38:18 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02J8cISc019541;
        Thu, 19 Mar 2020 01:38:18 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 2/2] qedi: Add PCI shutdown handler support.
Date:   Thu, 19 Mar 2020 01:38:11 -0700
Message-ID: <20200319083811.19499-3-mrangankar@marvell.com>
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

Add PCI shutdown handler support for supporting
wake-on-lan feature.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedi/qedi.h       |  2 ++
 drivers/scsi/qedi/qedi_gbl.h   |  1 +
 drivers/scsi/qedi/qedi_iscsi.c | 18 ++++++++++++++++++
 drivers/scsi/qedi/qedi_iscsi.h |  1 +
 drivers/scsi/qedi/qedi_main.c  | 19 +++++++++++++++++--
 5 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index 812e368..9498279 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -36,6 +36,7 @@
  */
 #define QEDI_MODE_NORMAL	0
 #define QEDI_MODE_RECOVERY	1
+#define QEDI_MODE_SHUTDOWN	2
 
 #define ISCSI_WQE_SET_PTU_INVALIDATE	1
 #define QEDI_MAX_ISCSI_TASK		4096
@@ -278,6 +279,7 @@ struct qedi_ctx {
 #define QEDI_IOTHREAD_WAKE	2
 #define QEDI_IN_RECOVERY	5
 #define QEDI_IN_OFFLINE		6
+#define QEDI_IN_SHUTDOWN	7
 
 	u8 mac[ETH_ALEN];
 	u32 src_ip[4];
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 8ba7c77..116645c 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -73,5 +73,6 @@ void qedi_trace_io(struct qedi_ctx *qedi, struct iscsi_task *task,
 void qedi_clearsq(struct qedi_ctx *qedi,
 		  struct qedi_conn *qedi_conn,
 		  struct iscsi_task *task);
+void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess);
 
 #endif
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 8829880..1f4a5fb 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -392,6 +392,7 @@ static int qedi_conn_bind(struct iscsi_cls_session *cls_session,
 
 	qedi_ep->conn = qedi_conn;
 	qedi_conn->ep = qedi_ep;
+	qedi_conn->iscsi_ep = ep;
 	qedi_conn->iscsi_conn_id = qedi_ep->iscsi_cid;
 	qedi_conn->fw_cid = qedi_ep->fw_cid;
 	qedi_conn->cmd_cleanup_req = 0;
@@ -782,6 +783,9 @@ static int qedi_task_xmit(struct iscsi_task *task)
 	struct qedi_cmd *cmd = task->dd_data;
 	struct scsi_cmnd *sc = task->sc;
 
+	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
+		return -ENODEV;
+
 	cmd->state = 0;
 	cmd->task = NULL;
 	cmd->use_slowpath = false;
@@ -1596,6 +1600,20 @@ void qedi_process_iscsi_error(struct qedi_endpoint *ep,
 		qedi_start_conn_recovery(qedi_conn->qedi, qedi_conn);
 }
 
+void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
+{
+	struct iscsi_session *session = cls_sess->dd_data;
+	struct iscsi_conn *conn = session->leadconn;
+	struct qedi_conn *qedi_conn = conn->dd_data;
+
+	if (iscsi_is_session_online(cls_sess))
+		qedi_ep_disconnect(qedi_conn->iscsi_ep);
+
+	qedi_conn_destroy(qedi_conn->cls_conn);
+
+	qedi_session_destroy(cls_sess);
+}
+
 void qedi_process_tcp_error(struct qedi_endpoint *ep,
 			    struct iscsi_eqe_data *data)
 {
diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscsi.h
index 67c3b73..39dc27c 100644
--- a/drivers/scsi/qedi/qedi_iscsi.h
+++ b/drivers/scsi/qedi/qedi_iscsi.h
@@ -149,6 +149,7 @@ struct qedi_conn {
 	struct iscsi_cls_conn *cls_conn;
 	struct qedi_ctx *qedi;
 	struct qedi_endpoint *ep;
+	struct iscsi_endpoint *iscsi_ep;
 	struct list_head active_cmd_list;
 	spinlock_t list_lock;		/* internal conn lock */
 	u32 active_cmd_count;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index cfa705a..b995b19 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2344,7 +2344,11 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	struct qedi_ctx *qedi = pci_get_drvdata(pdev);
 	int rval;
 
-	if (mode == QEDI_MODE_NORMAL) {
+	if (mode == QEDI_MODE_SHUTDOWN)
+		iscsi_host_for_each_session(qedi->shost,
+					    qedi_clear_session_ctx);
+
+	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
 		if (qedi->tmf_thread) {
 			flush_workqueue(qedi->tmf_thread);
 			destroy_workqueue(qedi->tmf_thread);
@@ -2384,7 +2388,7 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 
 	qedi_destroy_fp(qedi);
 
-	if (mode == QEDI_MODE_NORMAL) {
+	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
 		qedi_release_cid_que(qedi);
 		qedi_cm_free_mem(qedi);
 		qedi_free_uio(qedi->udev);
@@ -2404,6 +2408,16 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
 	}
 }
 
+static void qedi_shutdown(struct pci_dev *pdev)
+{
+	struct qedi_ctx *qedi = pci_get_drvdata(pdev);
+
+	QEDI_ERR(&qedi->dbg_ctx, "%s: Shutdown qedi\n", __func__);
+	if (test_and_set_bit(QEDI_IN_SHUTDOWN, &qedi->flags))
+		return;
+	__qedi_remove(pdev, QEDI_MODE_SHUTDOWN);
+}
+
 static int __qedi_probe(struct pci_dev *pdev, int mode)
 {
 	struct qedi_ctx *qedi;
@@ -2740,6 +2754,7 @@ static void qedi_remove(struct pci_dev *pdev)
 	.id_table = qedi_pci_tbl,
 	.probe = qedi_probe,
 	.remove = qedi_remove,
+	.shutdown = qedi_shutdown,
 };
 
 static int __init qedi_init(void)
-- 
1.8.3.1

