Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321E8C10F1B
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Dec 2022 11:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiLSLIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Dec 2022 06:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiLSLIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2022 06:08:00 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC8725ED
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:07:59 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJ9Q1pg010480
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:07:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=9Q/1wZjP32FbHRFizfzL8KHDldfpIL/elHfQsYrazYo=;
 b=cTomGC+R2nwzmZVC1+8Zn3y2TVIcl+mmrBZCK8aBMzN16EWSNyoXKCC8S3FXWb0yuJ62
 ShNW1HFpuF5xiX9vV92faty7SNurjaoUEmMKAY9i8+rbHmZBERfP6XkJ+DbaGgGz80zO
 ZzXVMhiyQDxIJjk0T7R7X2xFuf6ZVyQAXl4q+1jHBUc+6hQUv4Kl0LngHylCCQywwTCN
 UsYwqgbiSFbHcZBg9GGn7/EHbj3/O1sxGfZklMHoKBepN9MBID791RRxi2dO0ZPheZDM
 bMjBvBT6Qu0jtY7boEHxbkbrH/T/YIRhHVXrGILryiC+m58bUjpq6HzWvkX/uJMx0i4y 2Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mjnanrb8v-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2022 03:07:59 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 19 Dec
 2022 03:07:57 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 19 Dec 2022 03:07:57 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 81B323F7063;
        Mon, 19 Dec 2022 03:07:57 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 05/11] qla2xxx: Fix exchange over subscription for mgt cmd
Date:   Mon, 19 Dec 2022 03:07:42 -0800
Message-ID: <20221219110748.7039-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221219110748.7039-1-njavali@marvell.com>
References: <20221219110748.7039-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: LD3JbH9Igy6LcDdFU4SxyIPpbndZHqtO
X-Proofpoint-ORIG-GUID: LD3JbH9Igy6LcDdFU4SxyIPpbndZHqtO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Add resource checking for management (non-IO) commands.

Fixes: 89c72f4245a8 ("scsi: qla2xxx: Add IOCB resource tracking")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c    | 10 ++++-
 drivers/scsi/qla2xxx/qla_inline.h |  5 ++-
 drivers/scsi/qla2xxx/qla_iocb.c   | 67 +++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    |  1 +
 4 files changed, 80 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 777808af5634..1925cc6897b6 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -235,7 +235,7 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 	uint16_t mb[MAX_IOCB_MB_REG];
 	int rc;
 	struct qla_hw_data *ha = vha->hw;
-	u16 iocbs_used, i;
+	u16 iocbs_used, i, exch_used;
 
 	rc = qla24xx_res_count_wait(vha, mb, SIZEOF_IOCB_MB_REG);
 	if (rc != QLA_SUCCESS) {
@@ -263,13 +263,19 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 	if (ql2xenforce_iocb_limit) {
 		/* lock is not require. It's an estimate. */
 		iocbs_used = ha->base_qpair->fwres.iocbs_used;
+		exch_used = ha->base_qpair->fwres.exch_used;
 		for (i = 0; i < ha->max_qpairs; i++) {
-			if (ha->queue_pair_map[i])
+			if (ha->queue_pair_map[i]) {
 				iocbs_used += ha->queue_pair_map[i]->fwres.iocbs_used;
+				exch_used += ha->queue_pair_map[i]->fwres.exch_used;
+			}
 		}
 
 		seq_printf(s, "Driver: estimate iocb used [%d] high water limit [%d]\n",
 			   iocbs_used, ha->base_qpair->fwres.iocbs_limit);
+
+		seq_printf(s, "estimate exchange used[%d] high water limit [%d] n",
+			   exch_used, ha->base_qpair->fwres.exch_limit);
 	}
 
 	return 0;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 2d5a275d8b00..b0ee307b5d4b 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -380,7 +380,7 @@ qla2xxx_get_fc4_priority(struct scsi_qla_host *vha)
 
 enum {
 	RESOURCE_NONE,
-	RESOURCE_IOCB  = BIT_0,
+	RESOURCE_IOCB = BIT_0,
 	RESOURCE_EXCH = BIT_1,  /* exchange */
 	RESOURCE_FORCE = BIT_2,
 };
@@ -396,6 +396,8 @@ qla_get_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 		iores->res_type = RESOURCE_NONE;
 		return 0;
 	}
+	if (iores->res_type & RESOURCE_FORCE)
+		goto force;
 
 	if ((iores->iocb_cnt + qp->fwres.iocbs_used) >= qp->fwres.iocbs_qp_limit) {
 		/* no need to acquire qpair lock. It's just rough calculation */
@@ -423,6 +425,7 @@ qla_get_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 			return -ENOSPC;
 		}
 	}
+force:
 	qp->fwres.iocbs_used += iores->iocb_cnt;
 	qp->fwres.exch_used += iores->exch_cnt;
 	return 0;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 399ec8da2d73..4f48f098ea5a 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3817,6 +3817,65 @@ qla24xx_prlo_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->vp_index = sp->fcport->vha->vp_idx;
 }
 
+int qla_get_iocbs_resource(struct srb *sp)
+{
+	bool get_exch;
+	bool push_it_through = false;
+
+	if (!ql2xenforce_iocb_limit) {
+		sp->iores.res_type = RESOURCE_NONE;
+		return 0;
+	}
+	sp->iores.res_type = RESOURCE_NONE;
+
+	switch (sp->type) {
+	case SRB_TM_CMD:
+	case SRB_PRLI_CMD:
+	case SRB_ADISC_CMD:
+		push_it_through = true;
+		fallthrough;
+	case SRB_LOGIN_CMD:
+	case SRB_ELS_CMD_RPT:
+	case SRB_ELS_CMD_HST:
+	case SRB_ELS_CMD_HST_NOLOGIN:
+	case SRB_CT_CMD:
+	case SRB_NVME_LS:
+	case SRB_ELS_DCMD:
+		get_exch = true;
+		break;
+
+	case SRB_FXIOCB_DCMD:
+	case SRB_FXIOCB_BCMD:
+		sp->iores.res_type = RESOURCE_NONE;
+		return 0;
+
+	case SRB_SA_UPDATE:
+	case SRB_SA_REPLACE:
+	case SRB_MB_IOCB:
+	case SRB_ABT_CMD:
+	case SRB_NACK_PLOGI:
+	case SRB_NACK_PRLI:
+	case SRB_NACK_LOGO:
+	case SRB_LOGOUT_CMD:
+	case SRB_CTRL_VP:
+		push_it_through = true;
+		fallthrough;
+	default:
+		get_exch = false;
+	}
+
+	sp->iores.res_type |= RESOURCE_IOCB;
+	sp->iores.iocb_cnt = 1;
+	if (get_exch) {
+		sp->iores.res_type |= RESOURCE_EXCH;
+		sp->iores.exch_cnt = 1;
+	}
+	if (push_it_through)
+		sp->iores.res_type |= RESOURCE_FORCE;
+
+	return qla_get_fw_resources(sp->qpair, &sp->iores);
+}
+
 int
 qla2x00_start_sp(srb_t *sp)
 {
@@ -3831,6 +3890,12 @@ qla2x00_start_sp(srb_t *sp)
 		return -EIO;
 
 	spin_lock_irqsave(qp->qp_lock_ptr, flags);
+	rval = qla_get_iocbs_resource(sp);
+	if (rval) {
+		spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
+		return -EAGAIN;
+	}
+
 	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
 	if (!pkt) {
 		rval = EAGAIN;
@@ -3931,6 +3996,8 @@ qla2x00_start_sp(srb_t *sp)
 	wmb();
 	qla2x00_start_iocbs(vha, qp->req);
 done:
+	if (rval)
+		qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 42d3d2de3d31..759bea69de12 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3112,6 +3112,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	}
 	bsg_reply->reply_payload_rcv_len = 0;
 
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 done:
 	/* Return the vendor specific reply to API */
 	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
-- 
2.19.0.rc0

