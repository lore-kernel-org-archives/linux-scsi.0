Return-Path: <SRS0=rQSi=EH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D522C2D0A3
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 18:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A14122253
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 18:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xv7YSmjM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgKAS7v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Nov 2020 13:59:51 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60564 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgKAS7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2020 13:59:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1Itwel016835;
        Sun, 1 Nov 2020 18:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=RK+0MOmbi7xiqi3AKyEYCqmAHmtWFiz8zi19mqNaU2k=;
 b=Xv7YSmjM3iHkRThttZP3q2l286xYoUk45DTP1f3HWNDkxQeOPc80ByaTVwNDJrVF6Nft
 bwL37Xotp76lME/bCkDtKgGudxkrXPtgCEAFexLyPtiBKQiCedaLNPKyP8JA63TkgeSz
 7I6/GKzv4PoAlvUN09JbuRNNf4y7HmEcdv9c6RDZXUac7ViwYlrUeKAFBxEucOIkhSPp
 64lLPPlMZaCOUGneJX0w73viavVnIMhQ2y97GfnWFRggnNUEP/O80Jx9spEL2aWX2oc4
 J3cKVcXWFSNMWEsDzpYzRcfVO+iiLj23tR9UUOYBuB5gvPGqnz4uhkWrUL8psGy4cXKN bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34hhb1sbay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 01 Nov 2020 18:59:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1IxbRG168752;
        Sun, 1 Nov 2020 18:59:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34hvrsxyfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Nov 2020 18:59:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A1Ixi72009060;
        Sun, 1 Nov 2020 18:59:45 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Nov 2020 10:59:43 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, njavali@marvell.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 3/8] qla2xxx: drop TARGET_SCF_LOOKUP_LUN_FROM_TAG
Date:   Sun,  1 Nov 2020 12:59:29 -0600
Message-Id: <1604257174-4524-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011010155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011010154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It looks like only the __qlt_24xx_handle_abts code path does not know
the lun for an abort and it uses the TARGET_SCF_LOOKUP_LUN_FROM_TAG
flag to have lio core look it up. LIO uses target_lookup_lun_from_tag
to go from cmd tag to lun for the driver. However, qla2xxx has a
tcm_qla2xxx_find_cmd_by_tag which does almost the same thing as the
LIO helper (it finds the cmd but does not return the lun). This patch
has qla2xxx use its internal helper.

This is more of a transition patch and that is why I'm having qla2xxx
use its internal function instead of killing it. The tcm qla2xxx driver
is the only that needs the sess_cmd_list, so the first couple of patches
move that list from LIO core to the driver. The final patches then
remove the sess_cmd_lock from the main IO path.

Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 21 +++++++++++----------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  4 +---
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index a27a625..f88548b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2083,6 +2083,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_mgmt_cmd *mcmd;
 	struct qla_qpair_hint *h = &vha->vha_tgt.qla_tgt->qphints[0];
+	struct qla_tgt_cmd *abort_cmd;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
 	    "qla_target(%d): task abort (tag=%d)\n",
@@ -2110,17 +2111,17 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	 */
 	mcmd->se_cmd.cpuid = h->cpuid;
 
-	if (ha->tgt.tgt_ops->find_cmd_by_tag) {
-		struct qla_tgt_cmd *abort_cmd;
-
-		abort_cmd = ha->tgt.tgt_ops->find_cmd_by_tag(sess,
+	abort_cmd = ha->tgt.tgt_ops->find_cmd_by_tag(sess,
 				le32_to_cpu(abts->exchange_addr_to_abort));
-		if (abort_cmd && abort_cmd->qpair) {
-			mcmd->qpair = abort_cmd->qpair;
-			mcmd->se_cmd.cpuid = abort_cmd->se_cmd.cpuid;
-			mcmd->abort_io_attr = abort_cmd->atio.u.isp24.attr;
-			mcmd->flags = QLA24XX_MGMT_ABORT_IO_ATTR_VALID;
-		}
+	if (!abort_cmd)
+		return -EIO;
+	mcmd->unpacked_lun = abort_cmd->se_cmd.orig_fe_lun;
+
+	if (abort_cmd->qpair) {
+		mcmd->qpair = abort_cmd->qpair;
+		mcmd->se_cmd.cpuid = abort_cmd->se_cmd.cpuid;
+		mcmd->abort_io_attr = abort_cmd->atio.u.isp24.attr;
+		mcmd->flags = QLA24XX_MGMT_ABORT_IO_ATTR_VALID;
 	}
 
 	INIT_WORK(&mcmd->work, qlt_do_tmr_work);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 61017ac..f5a91bf 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -574,13 +574,11 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
 	struct fc_port *sess = mcmd->sess;
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
 	int transl_tmr_func = 0;
-	int flags = TARGET_SCF_ACK_KREF;
 
 	switch (tmr_func) {
 	case QLA_TGT_ABTS:
 		pr_debug("%ld: ABTS received\n", sess->vha->host_no);
 		transl_tmr_func = TMR_ABORT_TASK;
-		flags |= TARGET_SCF_LOOKUP_LUN_FROM_TAG;
 		break;
 	case QLA_TGT_2G_ABORT_TASK:
 		pr_debug("%ld: 2G Abort Task received\n", sess->vha->host_no);
@@ -613,7 +611,7 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
 	}
 
 	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
-	    transl_tmr_func, GFP_ATOMIC, tag, flags);
+	    transl_tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
 }
 
 static struct qla_tgt_cmd *tcm_qla2xxx_find_cmd_by_tag(struct fc_port *sess,
-- 
1.8.3.1

