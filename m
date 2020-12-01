Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A16AC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C72272085B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e34+j3qS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389227AbgLAVbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:31:11 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40968 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729472AbgLAVbF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:31:05 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LT9tg117612;
        Tue, 1 Dec 2020 21:30:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=TyqXj4g0FspgEeOkJE0RW16vFjueHMTTmBOgj4GRMCA=;
 b=e34+j3qSoE3eKapDMPWzoNJ0C+o6GXe9qGxFmRE+x8sUYDiQB1Izz8R81X0HbHz4Fro3
 8SKKGNNnCOToGPSFUcNPfFbkRIhuJ2i0X9VULY7Nalu60d9y9oAfUekuFVxveSWmur+S
 Bfkx6ZPwCAMvbwPxhtP3FMRoianpzLCm0DedWBdGvLYH2BH/yCGC2Y8E8/t2Sco7W4v3
 uuw9d6dvrOMU2Ua2wFLsMNF3oIwT+HR63AKBYrrPKWsblc2cqZGfZhHfvCvcuEXKt4dh
 QvT2LXkvnpU2APa8Oic10aJgbKaDO/OUXh+sx5bHQhJDBj1e+GCgVI7dUDFHsDr4FSjA 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2aw2uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:30:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LU88v105833;
        Tue, 1 Dec 2020 21:30:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3540eyh8xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:13 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1LUCJx021080;
        Tue, 1 Dec 2020 21:30:12 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:30:11 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 10/15] qedi: set scsi_host_template cmd_size
Date:   Tue,  1 Dec 2020 15:29:51 -0600
Message-Id: <1606858196-5421-11-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=2 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_template cmd_size so the block/scsi-ml layers allocate
the iscsi structs for the driver.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 113 ++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08c0540..979b875 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -14,6 +14,9 @@
 #include "qedi_iscsi.h"
 #include "qedi_gbl.h"
 
+static int qedi_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc);
+static int qedi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc);
+
 int qedi_recover_all_conns(struct qedi_ctx *qedi)
 {
 	struct qedi_conn *qedi_conn;
@@ -59,6 +62,9 @@ struct scsi_host_template qedi_host_template = {
 	.dma_boundary = QEDI_HW_DMA_BOUNDARY,
 	.cmd_per_lun = 128,
 	.shost_attrs = qedi_shost_attrs,
+	.cmd_size = sizeof(struct qedi_cmd) + sizeof(struct iscsi_task),
+	.init_cmd_priv = qedi_init_cmd_priv,
+	.exit_cmd_priv = qedi_exit_cmd_priv,
 };
 
 static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
@@ -160,32 +166,17 @@ static int qedi_conn_alloc_login_resources(struct qedi_ctx *qedi,
 	return -ENOMEM;
 }
 
-static void qedi_destroy_cmd_pool(struct qedi_ctx *qedi,
-				  struct iscsi_session *session)
+static void qedi_free_sget(struct qedi_ctx *qedi, struct qedi_cmd *cmd)
 {
-	int i;
+	if (!cmd->io_tbl.sge_tbl)
+		return;
 
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct qedi_cmd *cmd = task->dd_data;
-
-		if (cmd->io_tbl.sge_tbl)
-			dma_free_coherent(&qedi->pdev->dev,
-					  QEDI_ISCSI_MAX_BDS_PER_CMD *
-					  sizeof(struct scsi_sge),
-					  cmd->io_tbl.sge_tbl,
-					  cmd->io_tbl.sge_tbl_dma);
-
-		if (cmd->sense_buffer)
-			dma_free_coherent(&qedi->pdev->dev,
-					  SCSI_SENSE_BUFFERSIZE,
-					  cmd->sense_buffer,
-					  cmd->sense_buffer_dma);
-	}
+	dma_free_coherent(&qedi->pdev->dev,
+			  QEDI_ISCSI_MAX_BDS_PER_CMD * sizeof(struct scsi_sge),
+			  cmd->io_tbl.sge_tbl, cmd->io_tbl.sge_tbl_dma);
 }
 
-static int qedi_alloc_sget(struct qedi_ctx *qedi, struct iscsi_session *session,
-			   struct qedi_cmd *cmd)
+static int qedi_alloc_sget(struct qedi_ctx *qedi, struct qedi_cmd *cmd)
 {
 	struct qedi_io_bdt *io = &cmd->io_tbl;
 	struct scsi_sge *sge;
@@ -195,8 +186,8 @@ static int qedi_alloc_sget(struct qedi_ctx *qedi, struct iscsi_session *session,
 					 sizeof(*sge),
 					 &io->sge_tbl_dma, GFP_KERNEL);
 	if (!io->sge_tbl) {
-		iscsi_session_printk(KERN_ERR, session,
-				     "Could not allocate BD table.\n");
+		shost_printk(KERN_ERR, qedi->shost,
+			     "Could not allocate BD table.\n");
 		return -ENOMEM;
 	}
 
@@ -204,33 +195,47 @@ static int qedi_alloc_sget(struct qedi_ctx *qedi, struct iscsi_session *session,
 	return 0;
 }
 
-static int qedi_setup_cmd_pool(struct qedi_ctx *qedi,
-			       struct iscsi_session *session)
+static int qedi_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 {
-	int i;
+	struct qedi_ctx *qedi = iscsi_host_priv(shost);
+	struct iscsi_task *task = scsi_cmd_priv(sc);
+	struct qedi_cmd *cmd = task->dd_data;
 
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct qedi_cmd *cmd = task->dd_data;
+	qedi_free_sget(qedi, cmd);
 
-		task->hdr = &cmd->hdr;
-		task->hdr_max = sizeof(struct iscsi_hdr);
+	if (cmd->sense_buffer)
+		dma_free_coherent(&qedi->pdev->dev, SCSI_SENSE_BUFFERSIZE,
+				  cmd->sense_buffer, cmd->sense_buffer_dma);
+	return 0;
+}
+
+static int qedi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	struct qedi_ctx *qedi = iscsi_host_priv(shost);
+	struct iscsi_task *task;
+	struct qedi_cmd *cmd;
 
-		if (qedi_alloc_sget(qedi, session, cmd))
-			goto free_sgets;
+	iscsi_init_cmd_priv(shost, sc);
 
-		cmd->sense_buffer = dma_alloc_coherent(&qedi->pdev->dev,
-						       SCSI_SENSE_BUFFERSIZE,
-						       &cmd->sense_buffer_dma,
-						       GFP_KERNEL);
-		if (!cmd->sense_buffer)
-			goto free_sgets;
-	}
+	task = scsi_cmd_priv(sc);
+	cmd = task->dd_data;
+	task->hdr = &cmd->hdr;
+	task->hdr_max = sizeof(struct iscsi_hdr);
+
+	if (qedi_alloc_sget(qedi, cmd))
+		goto free_sgets;
+
+	cmd->sense_buffer = dma_alloc_coherent(&qedi->pdev->dev,
+					       SCSI_SENSE_BUFFERSIZE,
+					       &cmd->sense_buffer_dma,
+					       GFP_KERNEL);
+	if (!cmd->sense_buffer)
+		goto free_sgets;
 
 	return 0;
 
 free_sgets:
-	qedi_destroy_cmd_pool(qedi, session);
+	qedi_free_sget(qedi, cmd);
 	return -ENOMEM;
 }
 
@@ -264,27 +269,7 @@ static int qedi_setup_cmd_pool(struct qedi_ctx *qedi,
 		return NULL;
 	}
 
-	if (qedi_setup_cmd_pool(qedi, cls_session->dd_data)) {
-		QEDI_ERR(&qedi->dbg_ctx,
-			 "Failed to setup cmd pool for ep=%p\n", qedi_ep);
-		goto session_teardown;
-	}
-
 	return cls_session;
-
-session_teardown:
-	iscsi_session_teardown(cls_session);
-	return NULL;
-}
-
-static void qedi_session_destroy(struct iscsi_cls_session *cls_session)
-{
-	struct iscsi_session *session = cls_session->dd_data;
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct qedi_ctx *qedi = iscsi_host_priv(shost);
-
-	qedi_destroy_cmd_pool(qedi, session);
-	iscsi_session_teardown(cls_session);
 }
 
 static struct iscsi_cls_conn *
@@ -1398,7 +1383,7 @@ struct iscsi_transport qedi_iscsi_transport = {
 	.caps = CAP_RECOVERY_L0 | CAP_HDRDGST | CAP_MULTI_R2T | CAP_DATADGST |
 		CAP_DATA_PATH_OFFLOAD | CAP_TEXT_NEGO,
 	.create_session = qedi_session_create,
-	.destroy_session = qedi_session_destroy,
+	.destroy_session = iscsi_session_teardown,
 	.create_conn = qedi_conn_create,
 	.bind_conn = qedi_conn_bind,
 	.start_conn = qedi_conn_start,
@@ -1625,7 +1610,7 @@ void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
 
 	qedi_conn_destroy(qedi_conn->cls_conn);
 
-	qedi_session_destroy(cls_sess);
+	iscsi_session_teardown(cls_sess);
 }
 
 void qedi_process_tcp_error(struct qedi_endpoint *ep,
-- 
1.8.3.1

