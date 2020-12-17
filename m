Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FCCC2BBCD
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEA6E23884
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgLQGnY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54858 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgLQGnT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6UDWp147149;
        Thu, 17 Dec 2020 06:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=7xXar9XK3/DE9jZYLQzeVfdtRYzDcgrdrtYlzNkMCic=;
 b=e8x0PqK82cUvoJ9Q2rR+WWg1t7/hs/DrZan6ElLO9limGqkFtMep68ZbdwXaP8xf3p54
 7/1FXcOZtKCrRLlexMzsrhC49B5TgmC2oJNf0t1tWzL+pbfQwvpKbElJ0l2MHCHlMVKa
 6AMeRT7bHqfsk+6SOxlvowX5Ko8TWwtZUJmxfsT+d8/tjK7UghCysfgrJixz4sALNLBz
 9vWjQqBH/dBXVIih1Xql+fHfylGVh1MhLftTyc+KJBbJyifvhz8YXuwcw3HEgXrvGi2T
 Kvq7FpiMrPArHSq3t0pT4fg1KgYfgs4Hxkccex7CeM30YAff6SVOQwqrmyjzreMZoBL2 Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35ckcbm1r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VCw0020073;
        Thu, 17 Dec 2020 06:42:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 35e6esvfsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:28 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BH6gSLG019152;
        Thu, 17 Dec 2020 06:42:28 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:28 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 09/22] qedi: implement alloc_task_priv/free_task_priv
Date:   Thu, 17 Dec 2020 00:41:59 -0600
Message-Id: <1608187332-4434-10-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Have qedi use the alloc_task_priv/free_task_priv instead of
rolling its own loops.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_iscsi.c | 106 ++++++++++++++++-------------------------
 1 file changed, 41 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08c0540..a76f595 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -160,32 +160,30 @@ static int qedi_conn_alloc_login_resources(struct qedi_ctx *qedi,
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
+static void qedi_free_task_priv(struct iscsi_session *session,
+				struct iscsi_task *task)
+{
+	struct qedi_ctx *qedi = iscsi_host_priv(session->host);
+	struct qedi_cmd *cmd = task->dd_data;
+
+	qedi_free_sget(qedi, cmd);
+
+	if (cmd->sense_buffer)
+		dma_free_coherent(&qedi->pdev->dev, SCSI_SENSE_BUFFERSIZE,
+				  cmd->sense_buffer, cmd->sense_buffer_dma);
+}
+
+static int qedi_alloc_sget(struct qedi_ctx *qedi, struct qedi_cmd *cmd)
 {
 	struct qedi_io_bdt *io = &cmd->io_tbl;
 	struct scsi_sge *sge;
@@ -195,8 +193,8 @@ static int qedi_alloc_sget(struct qedi_ctx *qedi, struct iscsi_session *session,
 					 sizeof(*sge),
 					 &io->sge_tbl_dma, GFP_KERNEL);
 	if (!io->sge_tbl) {
-		iscsi_session_printk(KERN_ERR, session,
-				     "Could not allocate BD table.\n");
+		shost_printk(KERN_ERR, qedi->shost,
+			    "Could not allocate BD table.\n");
 		return -ENOMEM;
 	}
 
@@ -204,33 +202,29 @@ static int qedi_alloc_sget(struct qedi_ctx *qedi, struct iscsi_session *session,
 	return 0;
 }
 
-static int qedi_setup_cmd_pool(struct qedi_ctx *qedi,
-			       struct iscsi_session *session)
+static int qedi_alloc_task_priv(struct iscsi_session *session,
+				struct iscsi_task *task)
 {
-	int i;
+	struct qedi_ctx *qedi = iscsi_host_priv(session->host);
+	struct qedi_cmd *cmd = task->dd_data;
 
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct qedi_cmd *cmd = task->dd_data;
+	task->hdr = &cmd->hdr;
+	task->hdr_max = sizeof(struct iscsi_hdr);
 
-		task->hdr = &cmd->hdr;
-		task->hdr_max = sizeof(struct iscsi_hdr);
+	if (qedi_alloc_sget(qedi, cmd))
+		return -ENOMEM;
 
-		if (qedi_alloc_sget(qedi, session, cmd))
-			goto free_sgets;
-
-		cmd->sense_buffer = dma_alloc_coherent(&qedi->pdev->dev,
-						       SCSI_SENSE_BUFFERSIZE,
-						       &cmd->sense_buffer_dma,
-						       GFP_KERNEL);
-		if (!cmd->sense_buffer)
-			goto free_sgets;
-	}
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
 
@@ -264,27 +258,7 @@ static int qedi_setup_cmd_pool(struct qedi_ctx *qedi,
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
@@ -1398,7 +1372,7 @@ struct iscsi_transport qedi_iscsi_transport = {
 	.caps = CAP_RECOVERY_L0 | CAP_HDRDGST | CAP_MULTI_R2T | CAP_DATADGST |
 		CAP_DATA_PATH_OFFLOAD | CAP_TEXT_NEGO,
 	.create_session = qedi_session_create,
-	.destroy_session = qedi_session_destroy,
+	.destroy_session = iscsi_session_teardown,
 	.create_conn = qedi_conn_create,
 	.bind_conn = qedi_conn_bind,
 	.start_conn = qedi_conn_start,
@@ -1410,6 +1384,8 @@ struct iscsi_transport qedi_iscsi_transport = {
 	.get_session_param = iscsi_session_get_param,
 	.get_host_param = qedi_host_get_param,
 	.send_pdu = iscsi_conn_send_pdu,
+	.alloc_task_priv = qedi_alloc_task_priv,
+	.free_task_priv = qedi_free_task_priv,
 	.get_stats = qedi_conn_get_stats,
 	.xmit_task = qedi_task_xmit,
 	.cleanup_task = qedi_cleanup_task,
@@ -1625,7 +1601,7 @@ void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
 
 	qedi_conn_destroy(qedi_conn->cls_conn);
 
-	qedi_session_destroy(cls_sess);
+	iscsi_session_teardown(cls_sess);
 }
 
 void qedi_process_tcp_error(struct qedi_endpoint *ep,
-- 
1.8.3.1

