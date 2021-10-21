Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C2CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 07:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECBFB610C8
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 07:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhJUHeq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 03:34:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6330 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231143AbhJUHeo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 03:34:44 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L67tfZ010474
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 00:32:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=FvrHThkiEngrditDUEhMKJJhq84TGbWbEJRFpYR8HlE=;
 b=NNx+j2Mat2jVXsZqjqW2koEzQPvnXp7Vwi+uYt4rzcwbHx52EIm0A4otoffAvnZNO47H
 RklXYERP8hzKMHLlkq+ktjrnxe2SX77y54im5tjvX7cSbcQF1QjbFE9ulazUsEAW/f6r
 j2j8X/+Mb0mu8VLVFDyFw8HYkcXjKIpAp3O/NlvXI4kuX+n+M7WuJ0/f7uav5ml/1G2O
 yKe0G6yXgyH1FD+9I5a6RWHLdjpHB39770kH6A0u1YwfZTh/Kukk2Uc553zrYTgXwfSw
 GfMVgZOmY0P5VwOLHBnzl5WQn2VzCVctZcWyYxAbJCa9ELtUK2+G3wXMeo58VhVg3FP/ ow== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bu2nrgbhe-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 00:32:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 21 Oct
 2021 00:32:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 21 Oct 2021 00:32:26 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C4AA73F708E;
        Thu, 21 Oct 2021 00:32:26 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 19L7WQTG027629;
        Thu, 21 Oct 2021 00:32:26 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 19L7WQ7u027628;
        Thu, 21 Oct 2021 00:32:26 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 03/13] qla2xxx: turn off target reset during issue_lip
Date:   Thu, 21 Oct 2021 00:31:58 -0700
Message-ID: <20211021073208.27582-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211021073208.27582-1-njavali@marvell.com>
References: <20211021073208.27582-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Nos9DDApHQSsvGAYpjVXWL9hE7KOQqip
X-Proofpoint-GUID: Nos9DDApHQSsvGAYpjVXWL9hE7KOQqip
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_02,2021-10-20_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

When user use issue_lip to do link bounce, driver sends
additional target reset to remote device before resetting
the link. The target reset would affect other paths with
active IOs. This patch will remove the unnecessary
target reset.

Fixes: 5854771e314e ("[SCSI] qla2xxx: Add ISPFX00 specific bus reset routine")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |  2 --
 drivers/scsi/qla2xxx/qla_mr.c  | 23 -----------------------
 drivers/scsi/qla2xxx/qla_os.c  | 27 ++-------------------------
 3 files changed, 2 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 8aadcdeca6cb..8faaa0ec595d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -171,7 +171,6 @@ extern int ql2xasynctmfenable;
 extern int ql2xgffidenable;
 extern int ql2xenabledif;
 extern int ql2xenablehba_err_chk;
-extern int ql2xtargetreset;
 extern int ql2xdontresethba;
 extern uint64_t ql2xmaxlun;
 extern int ql2xmdcapmask;
@@ -820,7 +819,6 @@ extern void qlafx00_abort_iocb(srb_t *, struct abort_iocb_entry_fx00 *);
 extern void qlafx00_fxdisc_iocb(srb_t *, struct fxdisc_entry_fx00 *);
 extern void qlafx00_timer_routine(scsi_qla_host_t *);
 extern int qlafx00_rescan_isp(scsi_qla_host_t *);
-extern int qlafx00_loop_reset(scsi_qla_host_t *vha);
 
 /* qla82xx related functions */
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 6e920da64863..350b0c4346fb 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -738,29 +738,6 @@ qlafx00_lun_reset(fc_port_t *fcport, uint64_t l, int tag)
 	return qla2x00_async_tm_cmd(fcport, TCF_LUN_RESET, l, tag);
 }
 
-int
-qlafx00_loop_reset(scsi_qla_host_t *vha)
-{
-	int ret;
-	struct fc_port *fcport;
-	struct qla_hw_data *ha = vha->hw;
-
-	if (ql2xtargetreset) {
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->port_type != FCT_TARGET)
-				continue;
-
-			ret = ha->isp_ops->target_reset(fcport, 0, 0);
-			if (ret != QLA_SUCCESS) {
-				ql_dbg(ql_dbg_taskm, vha, 0x803d,
-				    "Bus Reset failed: Reset=%d "
-				    "d_id=%x.\n", ret, fcport->d_id.b24);
-			}
-		}
-	}
-	return QLA_SUCCESS;
-}
-
 int
 qlafx00_iospace_config(struct qla_hw_data *ha)
 {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 03ff2596715b..3fca6b8bb23f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -202,12 +202,6 @@ MODULE_PARM_DESC(ql2xdbwr,
 		" 0 -- Regular doorbell.\n"
 		" 1 -- CAMRAM doorbell (faster).\n");
 
-int ql2xtargetreset = 1;
-module_param(ql2xtargetreset, int, S_IRUGO);
-MODULE_PARM_DESC(ql2xtargetreset,
-		 "Enable target reset."
-		 "Default is 1 - use hw defaults.");
-
 int ql2xgffidenable;
 module_param(ql2xgffidenable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xgffidenable,
@@ -1695,27 +1689,10 @@ int
 qla2x00_loop_reset(scsi_qla_host_t *vha)
 {
 	int ret;
-	struct fc_port *fcport;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (IS_QLAFX00(ha)) {
-		return qlafx00_loop_reset(vha);
-	}
-
-	if (ql2xtargetreset == 1 && ha->flags.enable_target_reset) {
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport->port_type != FCT_TARGET)
-				continue;
-
-			ret = ha->isp_ops->target_reset(fcport, 0, 0);
-			if (ret != QLA_SUCCESS) {
-				ql_dbg(ql_dbg_taskm, vha, 0x802c,
-				    "Bus Reset failed: Reset=%d "
-				    "d_id=%x.\n", ret, fcport->d_id.b24);
-			}
-		}
-	}
-
+	if (IS_QLAFX00(ha))
+		return QLA_SUCCESS;
 
 	if (ha->flags.enable_lip_full_login && !IS_CNA_CAPABLE(ha)) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
-- 
2.19.0.rc0

