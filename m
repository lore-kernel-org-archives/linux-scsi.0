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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B688C71156
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 210AE2084C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FUqTY0Wl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389005AbgLAVbH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:31:07 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40954 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729391AbgLAVbE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:31:04 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LSvHX117414;
        Tue, 1 Dec 2020 21:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=HjkZFHCL97gQAaLadNeOxv8/FepV0n+q0a+Z+yEywL0=;
 b=FUqTY0Wl/9KHZ3TLtu43RCkJy+gPlF04qzKYbLCPEe6iUL4tljFQUPBPLiuEdSQCu3k0
 umhSSxI/3LPjOXcvXLbz1lLqCoJ9ABWoXXyURmEqSLAKDtY55uCwhy1jjTfziuGQ2GEV
 hf75EeeGVl/qGRBHCdXt5ib+Tb11BokvqSfUKECR3Xf8nOEkErNha6tO7dWoA0/XPQQT
 Sc2BVOMgYZD3aWI9i2uG2cHJRQl30NSydfAmBzg/72CMEamhD8YwzuW7+coldw62AzIr
 ULjB7XOpeWwuOewR4np+bjewfqBQ2xY/2hrFnjcFP5GVdeRovoW8GXgvYf+Q9lYJ+ZzU OQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2aw2ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:30:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LAOSB067967;
        Tue, 1 Dec 2020 21:30:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35404ndkn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:13 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1LUBHl021073;
        Tue, 1 Dec 2020 21:30:11 GMT
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
Subject: [PATCH 09/15] bnx2i: set scsi_host_template cmd_size
Date:   Tue,  1 Dec 2020 15:29:50 -0600
Message-Id: <1606858196-5421-10-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_template cmd_size so the block/scsi-ml layers allocate the
iscsi structs for the driver.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 112 +++++++++++----------------------------
 1 file changed, 30 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index fdd4467..d523382 100644
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
@@ -451,68 +449,44 @@ static int bnx2i_alloc_bdt(struct bnx2i_hba *hba, struct iscsi_session *session,
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
+static int bnx2i_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 {
-	int i;
-
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct bnx2i_cmd *cmd = task->dd_data;
+	struct bnx2i_hba *hba = iscsi_host_priv(shost);
+	struct iscsi_task *task = scsi_cmd_priv(sc);
+	struct bnx2i_cmd *cmd = task->dd_data;
 
-		if (cmd->io_tbl.bd_tbl)
-			dma_free_coherent(&hba->pcidev->dev,
-					  ISCSI_MAX_BDS_PER_CMD *
-					  sizeof(struct iscsi_bd),
-					  cmd->io_tbl.bd_tbl,
-					  cmd->io_tbl.bd_tbl_dma);
-	}
+	if (!cmd->io_tbl.bd_tbl)
+		return 0;
 
+	dma_free_coherent(&hba->pcidev->dev,
+			  ISCSI_MAX_BDS_PER_CMD * sizeof(struct iscsi_bd),
+			  cmd->io_tbl.bd_tbl, cmd->io_tbl.bd_tbl_dma);
+	return 0;
 }
 
-
-/**
- * bnx2i_setup_cmd_pool - sets up iscsi command pool for the session
- * @hba:	adapter instance pointer
- * @session:	iscsi session pointer
- */
-static int bnx2i_setup_cmd_pool(struct bnx2i_hba *hba,
-				struct iscsi_session *session)
+static int bnx2i_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 {
-	int i;
-
-	for (i = 0; i < session->cmds_max; i++) {
-		struct iscsi_task *task = session->cmds[i];
-		struct bnx2i_cmd *cmd = task->dd_data;
-
-		task->hdr = &cmd->hdr;
-		task->hdr_max = sizeof(struct iscsi_hdr);
+	struct bnx2i_hba *hba = iscsi_host_priv(shost);
+	struct iscsi_task *task;
+	struct bnx2i_cmd *cmd;
 
-		if (bnx2i_alloc_bdt(hba, session, cmd))
-			goto free_bdts;
-	}
+	iscsi_init_cmd_priv(shost, sc);
 
-	return 0;
+	task = scsi_cmd_priv(sc);
+	cmd = task->dd_data;
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
@@ -1288,7 +1262,6 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
 		     uint32_t initial_cmdsn)
 {
 	struct Scsi_Host *shost;
-	struct iscsi_cls_session *cls_session;
 	struct bnx2i_hba *hba;
 	struct bnx2i_endpoint *bnx2i_ep;
 
@@ -1312,40 +1285,11 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
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
+	return iscsi_session_setup(&bnx2i_iscsi_transport, shost,
+				   cmds_max, 0, sizeof(struct bnx2i_cmd),
+				   initial_cmdsn, ISCSI_MAX_TARGET);
 }
 
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
-}
-
-
 /**
  * bnx2i_conn_create - create iscsi connection instance
  * @cls_session:	pointer to iscsi cls session
@@ -2265,6 +2209,10 @@ static umode_t bnx2i_attr_is_visible(int param_type, int param)
 	.sg_tablesize		= ISCSI_MAX_BDS_PER_CMD,
 	.shost_attrs		= bnx2i_dev_attributes,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct bnx2i_cmd) +
+				  sizeof(struct iscsi_task),
+	.init_cmd_priv		= bnx2i_init_cmd_priv,
+	.exit_cmd_priv		= bnx2i_exit_cmd_priv,
 };
 
 struct iscsi_transport bnx2i_iscsi_transport = {
@@ -2275,7 +2223,7 @@ struct iscsi_transport bnx2i_iscsi_transport = {
 				  CAP_DATA_PATH_OFFLOAD |
 				  CAP_TEXT_NEGO,
 	.create_session		= bnx2i_session_create,
-	.destroy_session	= bnx2i_session_destroy,
+	.destroy_session	= iscsi_session_teardown,
 	.create_conn		= bnx2i_conn_create,
 	.bind_conn		= bnx2i_conn_bind,
 	.destroy_conn		= bnx2i_conn_destroy,
-- 
1.8.3.1

