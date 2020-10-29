Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B2CC55178
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 09:46:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F91820790
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 09:46:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nNopl6JC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgJ2Jq0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:46:26 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36434 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgJ2JqZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 05:46:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T6k6Cp080103;
        Thu, 29 Oct 2020 06:49:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=XYB8sv16Kgw1VI1ldMEcRUA60vmVdLXN8/gW9c3/x2A=;
 b=nNopl6JCi2ihjNlghvl2GUf8B+L3TY+5m4M/W1BAV9SZ4e5qlI0mSyauawyqm/up1L2K
 g99UtneChxYZVSX8zdolPhRAWlsHtGzqSBriyKMzF/TGYCPgXpjH/AQkSONLO8wc3yqS
 tYiyPQw0+FaCfZByB0MLzStlyW86LFtIYOP9W7qOvohfwW7asOwQhRxtcfz+CWhcoMNP
 rdma7nNiyvPoC2+zYGqjxRvU4h+cuMwCwsEHBrkmQwfF7+VSKEcoWOPOqU01U0VnNFVF
 26ZV/VB29ITp+rp8FvaKnBW1QhvIqw2u2xJswAKpbGWb1CXZhA2Bod6gK3VsyuP2S+ic RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sb37dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 06:49:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T6kNrY178585;
        Thu, 29 Oct 2020 06:49:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1svd50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 06:49:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09T6nglB008162;
        Thu, 29 Oct 2020 06:49:42 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 23:49:41 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, njavali@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 3/8] tcm qla2xxx: drop TARGET_SCF_LOOKUP_LUN_FROM_TAG
Date:   Thu, 29 Oct 2020 01:49:26 -0500
Message-Id: <1603954171-11621-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290047
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
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
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

