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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D540C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B79B23108
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390477AbgLMDLC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:11:02 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60634 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388193AbgLMDKC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:10:02 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD33bM5156190;
        Sun, 13 Dec 2020 03:09:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=z6I6fHREh7MFbCUuv3108y5Mdw0oOU21FY0obr3/55U=;
 b=rwtZfkECT26mNqdQsLQC2Bvk5+buMG3qUlr8gJ3z+glJcQrRVRFkwno/kCO420IY3W2o
 INcr5WOG/KFxJ0dMIJVrwWYVfttYNwN7HcK7ZxeCqREt0zmnBCOgH4fcQDiTAC4F3TmW
 mVny04T2C+IaYbtbS5LQ+xCEeB/Zh8/VeyYpDQZxisLT5AvX1Tm4ZHWM/QTH76osmC7T
 VHVzs5yTJMIfbsV8BFPRcxPwFJrdcTEb/tHflpr0fcHO04AzVkJg6D/joGvMM8wuM7qm
 r2G8hDGgQ1Mo24wgwbtz3es1tKomWMPxhK541EyE83a+Rm2/gbqw8EBUmkmfVJh/aCzo zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcb1ph6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:09:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD351wR107812;
        Sun, 13 Dec 2020 03:09:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35d7ejakjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:09:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BD398WD013837;
        Sun, 13 Dec 2020 03:09:08 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:09:08 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 12/18] bnx2i: set scsi_host_template cmd_size
Date:   Sat, 12 Dec 2020 21:08:40 -0600
Message-Id: <1607828926-3658-13-git-send-email-michael.christie@oracle.com>
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

Use scsi_host_template cmd_size so the block/scsi-ml layers allocate the
iscsi structs for the driver.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 55 ++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index c49e7aa..975fb48 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -434,6 +434,31 @@ static void bnx2i_free_ep(struct iscsi_endpoint *ep)
 	iscsi_destroy_endpoint(ep);
 }
 
+static void __bnx2i_free_task_priv(struct Scsi_Host *shost,
+				   struct iscsi_task *task)
+{
+	struct bnx2i_hba *hba = iscsi_host_priv(shost);
+	struct bnx2i_cmd *cmd = task->dd_data;
+
+	if (!cmd->io_tbl.bd_tbl)
+		return;
+
+	dma_free_coherent(&hba->pcidev->dev,
+			  ISCSI_MAX_BDS_PER_CMD * sizeof(struct iscsi_bd),
+			  cmd->io_tbl.bd_tbl, cmd->io_tbl.bd_tbl_dma);
+}
+
+static void bnx2i_free_task_priv(struct iscsi_session *session,
+				 struct iscsi_task *task)
+{
+	__bnx2i_free_task_priv(session->host, task);
+}
+
+static int bnx2i_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	__bnx2i_free_task_priv(shost, scsi_cmd_priv(sc));
+	return 0;
+}
 
 /**
  * bnx2i_alloc_bdt - allocates buffer descriptor (BD) table for the command
@@ -456,30 +481,28 @@ static int bnx2i_alloc_bdt(struct bnx2i_hba *hba, struct bnx2i_cmd *cmd)
 	return 0;
 }
 
-static void bnx2i_free_task_priv(struct iscsi_session *session,
-				 struct iscsi_task *task)
+static int __bnx2i_alloc_task_priv(struct Scsi_Host *shost,
+				   struct iscsi_task *task)
 {
-	struct bnx2i_hba *hba = iscsi_host_priv(session->host);
+	struct bnx2i_hba *hba = iscsi_host_priv(shost);
 	struct bnx2i_cmd *cmd = task->dd_data;
 
-	if (!cmd->io_tbl.bd_tbl)
-		return;
+	task->hdr = &cmd->hdr;
+	task->hdr_max = sizeof(struct iscsi_hdr);
 
-	dma_free_coherent(&hba->pcidev->dev,
-			  ISCSI_MAX_BDS_PER_CMD * sizeof(struct iscsi_bd),
-			  cmd->io_tbl.bd_tbl, cmd->io_tbl.bd_tbl_dma);
+	return bnx2i_alloc_bdt(hba, cmd);
 }
 
 static int bnx2i_alloc_task_priv(struct iscsi_session *session,
 				 struct iscsi_task *task)
 {
-	struct bnx2i_hba *hba = iscsi_host_priv(session->host);
-	struct bnx2i_cmd *cmd = task->dd_data;
-
-	task->hdr = &cmd->hdr;
-	task->hdr_max = sizeof(struct iscsi_hdr);
+	return __bnx2i_alloc_task_priv(session->host, task);
+}
 
-	return bnx2i_alloc_bdt(hba, cmd);
+static int bnx2i_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	iscsi_init_cmd_priv(shost, sc);
+	return __bnx2i_alloc_task_priv(shost, scsi_cmd_priv(sc));
 }
 
 /**
@@ -2204,6 +2227,10 @@ static umode_t bnx2i_attr_is_visible(int param_type, int param)
 	.sg_tablesize		= ISCSI_MAX_BDS_PER_CMD,
 	.shost_attrs		= bnx2i_dev_attributes,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct bnx2i_cmd) +
+				  sizeof(struct iscsi_task),
+	.init_cmd_priv		= bnx2i_init_cmd_priv,
+	.exit_cmd_priv		= bnx2i_exit_cmd_priv,
 };
 
 struct iscsi_transport bnx2i_iscsi_transport = {
-- 
1.8.3.1

