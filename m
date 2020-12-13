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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2569DC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1A7123108
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391086AbgLMDLS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:11:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60550 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387661AbgLMDKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:10:01 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD340cK175925;
        Sun, 13 Dec 2020 03:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=mBr3Z51/nH0BuCET5CQcEJgEGyQBX5Ejowovar5nR4U=;
 b=k55SZ4m9PCSXL1y01qX1voEfzet9v+dai++EAgY8oKL1fBtLtgg91DJtccu4d+lUle1G
 M16PWcih4m8W+iUmlwsmRaNWNKtW5C7kEplTUZ6A46BKVEg6tgWX4hH3TTisKNfuA5ce
 RFMqqFfTnMsBBvN2AG6E07ziv439ySFXZSEwufqDPOaAit+ngQE0LaDnDgxT0CMybt7H
 YKcNUASOPN7RFr9n7PGUcYUIDlnTH0zaNWd45ozO8M92tcanZJLtNaM3wVySl3odgW0R
 qOo/vMrJ9SJVOx3ixinphvCDg/1dJMauQ3uAdB3WNw3WYExl3D2UUXFoBRzbiFwWQBVZ jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcb1ph3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:09:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD3512l107843;
        Sun, 13 Dec 2020 03:09:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35d7ejakhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:09:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BD395to010255;
        Sun, 13 Dec 2020 03:09:05 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:09:04 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 09/18] bnx2i: implement alloc_task_priv/free_task_priv
Date:   Sat, 12 Dec 2020 21:08:37 -0600
Message-Id: <1607828926-3658-10-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
References: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Have bnx2i use the alloc_task_priv/free_task_priv instead of rolling
its own loops.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 107 +++++++++------------------------------
 1 file changed, 24 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index fdd4467..c49e7aa 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -438,11 +438,9 @@ static void bnx2i_free_ep(struct iscsi_endpoint *ep)
 /**
  * bnx2i_alloc_bdt - allocates buffer descriptor (BD) table for the command
  * @hba:	adapter instance pointer
- * @session:	iscsi session pointer
  * @cmd:	iscsi command structure
  */
-static int bnx2i_alloc_bdt(struct bnx2i_hba *hba, struct iscsi_session *session,
-			   struct bnx2i_cmd *cmd)
+static int bnx2i_alloc_bdt(struct bnx2i_hba *hba, struct bnx2i_cmd *cmd)
 {
 	struct io_bdt *io = &cmd->io_tbl;
 	struct iscsi_bd *bd;
@@ -451,68 +449,39 @@ static int bnx2i_alloc_bdt(struct bnx2i_hba *hba, struct iscsi_session *session,
 					ISCSI_MAX_BDS_PER_CMD * sizeof(*bd),
 					&io->bd_tbl_dma, GFP_KERNEL);
 	if (!io->bd_tbl) {
-		iscsi_session_printk(KERN_ERR, session, "Could not "
-				     "allocate bdt.\n");
+		shost_printk(KERN_ERR, hba->shost, "Could not allocate bdt.\n");
 		return -ENOMEM;
 	}
 	io->bd_valid = 0;
 	return 0;
 }
 
-/**
- * bnx2i_destroy_cmd_pool - destroys iscsi command pool and release BD table
- * @hba:	adapter instance pointer
- * @session:	iscsi session pointer
- */
-static void bnx2i_destroy_cmd_pool(struct bnx2i_hba *hba,
-				   struct iscsi_session *session)
+static void bnx2i_free_task_priv(struct iscsi_session *session,
+				 struct iscsi_task *task)
 {
-	int i;
-
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct bnx2i_cmd *cmd = task->dd_data;
+	struct bnx2i_hba *hba = iscsi_host_priv(session->host);
+	struct bnx2i_cmd *cmd = task->dd_data;
 
-		if (cmd->io_tbl.bd_tbl)
-			dma_free_coherent(&hba->pcidev->dev,
-					  ISCSI_MAX_BDS_PER_CMD *
-					  sizeof(struct iscsi_bd),
-					  cmd->io_tbl.bd_tbl,
-					  cmd->io_tbl.bd_tbl_dma);
-	}
+	if (!cmd->io_tbl.bd_tbl)
+		return;
 
+	dma_free_coherent(&hba->pcidev->dev,
+			  ISCSI_MAX_BDS_PER_CMD * sizeof(struct iscsi_bd),
+			  cmd->io_tbl.bd_tbl, cmd->io_tbl.bd_tbl_dma);
 }
 
-
-/**
- * bnx2i_setup_cmd_pool - sets up iscsi command pool for the session
- * @hba:	adapter instance pointer
- * @session:	iscsi session pointer
- */
-static int bnx2i_setup_cmd_pool(struct bnx2i_hba *hba,
-				struct iscsi_session *session)
+static int bnx2i_alloc_task_priv(struct iscsi_session *session,
+				 struct iscsi_task *task)
 {
-	int i;
-
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct bnx2i_cmd *cmd = task->dd_data;
-
-		task->hdr = &cmd->hdr;
-		task->hdr_max = sizeof(struct iscsi_hdr);
-
-		if (bnx2i_alloc_bdt(hba, session, cmd))
-			goto free_bdts;
-	}
+	struct bnx2i_hba *hba = iscsi_host_priv(session->host);
+	struct bnx2i_cmd *cmd = task->dd_data;
 
-	return 0;
+	task->hdr = &cmd->hdr;
+	task->hdr_max = sizeof(struct iscsi_hdr);
 
-free_bdts:
-	bnx2i_destroy_cmd_pool(hba, session);
-	return -ENOMEM;
+	return bnx2i_alloc_bdt(hba, cmd);
 }
 
-
 /**
  * bnx2i_setup_mp_bdt - allocate BD table resources
  * @hba:	pointer to adapter structure
@@ -1288,7 +1257,6 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
 		     uint32_t initial_cmdsn)
 {
 	struct Scsi_Host *shost;
-	struct iscsi_cls_session *cls_session;
 	struct bnx2i_hba *hba;
 	struct bnx2i_endpoint *bnx2i_ep;
 
@@ -1312,40 +1280,11 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
 	else if (cmds_max < BNX2I_SQ_WQES_MIN)
 		cmds_max = BNX2I_SQ_WQES_MIN;
 
-	cls_session = iscsi_session_setup(&bnx2i_iscsi_transport, shost,
-					  cmds_max, 0, sizeof(struct bnx2i_cmd),
-					  initial_cmdsn, ISCSI_MAX_TARGET);
-	if (!cls_session)
-		return NULL;
-
-	if (bnx2i_setup_cmd_pool(hba, cls_session->dd_data))
-		goto session_teardown;
-	return cls_session;
-
-session_teardown:
-	iscsi_session_teardown(cls_session);
-	return NULL;
-}
-
-
-/**
- * bnx2i_session_destroy - destroys iscsi session
- * @cls_session:	pointer to iscsi cls session
- *
- * Destroys previously created iSCSI session instance and releases
- *	all resources held by it
- */
-static void bnx2i_session_destroy(struct iscsi_cls_session *cls_session)
-{
-	struct iscsi_session *session = cls_session->dd_data;
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct bnx2i_hba *hba = iscsi_host_priv(shost);
-
-	bnx2i_destroy_cmd_pool(hba, session);
-	iscsi_session_teardown(cls_session);
+	return iscsi_session_setup(&bnx2i_iscsi_transport, shost,
+				   cmds_max, 0, sizeof(struct bnx2i_cmd),
+				   initial_cmdsn, ISCSI_MAX_TARGET);
 }
 
-
 /**
  * bnx2i_conn_create - create iscsi connection instance
  * @cls_session:	pointer to iscsi cls session
@@ -2275,7 +2214,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 				  CAP_DATA_PATH_OFFLOAD |
 				  CAP_TEXT_NEGO,
 	.create_session		= bnx2i_session_create,
-	.destroy_session	= bnx2i_session_destroy,
+	.destroy_session	= iscsi_session_teardown,
 	.create_conn		= bnx2i_conn_create,
 	.bind_conn		= bnx2i_conn_bind,
 	.destroy_conn		= bnx2i_conn_destroy,
@@ -2287,6 +2226,8 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 	.start_conn		= bnx2i_conn_start,
 	.stop_conn		= iscsi_conn_stop,
 	.send_pdu		= iscsi_conn_send_pdu,
+	.alloc_task_priv	= bnx2i_alloc_task_priv,
+	.free_task_priv		= bnx2i_free_task_priv,
 	.xmit_task		= bnx2i_task_xmit,
 	.get_stats		= bnx2i_conn_get_stats,
 	/* TCP connect - disconnect - option-2 interface calls */
-- 
1.8.3.1

