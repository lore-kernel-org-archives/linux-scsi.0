Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B17C4167B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 04:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237338AbiLNEus (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 23:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiLNEu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 23:50:28 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DCBDF82
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:27 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE3gC9G020064
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=CUhE3g/pgH37qV3/k1K0DWPGTPtcXQK1wPC6qxBphNs=;
 b=Y4F5DVSCGjkDrQU0jHb+T3zypqQVydCIVbMLx8tv3614fslL8t0v5UxHXGb6ZIPUPZkT
 xs3qt8PLDux+W8hZlOo1SIwYiqU/EtEJEz/6RZX0wcb+PBEOrEKlgYkmWFrR8v2lfZpe
 V3v2nlg7Medw0Fu3bPfh2lZJEuhvwcZImjnNn1ydiQldSWWw8AEOLaOpymGKlqCqgcfd
 vkk1W7xoLD8rCaCyNmgNZVQf9dz39ZeACf8j0vWqDXNEc60WigXRWlvzkTBmh4ibYzMB
 mNhym2XmqTA0+VOyB0s7Rz+q89Aslrkesd8cgnOOmONY1/qhq4nfzpWZZXx7W3cr34Wu Ow== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mf6tj078c-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 20:50:27 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 13 Dec
 2022 20:50:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Tue, 13 Dec 2022 20:50:24 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6BB243F7073;
        Tue, 13 Dec 2022 20:50:24 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>
Subject: [PATCH 04/10] qla2xxx: Fix exchange over subscription
Date:   Tue, 13 Dec 2022 20:50:08 -0800
Message-ID: <20221214045014.19362-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221214045014.19362-1-njavali@marvell.com>
References: <20221214045014.19362-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gayLsKbFngJgW1Y9-cf0g9wxP26idMk1
X-Proofpoint-GUID: gayLsKbFngJgW1Y9-cf0g9wxP26idMk1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_02,2022-12-13_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

In large environment, user can experience command timeout and
escalation of path recovery. Currently driver does not track
the number of exchanges/commands sent to FW. If there are
delay for commands at the head of the queue, then this will
create back pressure for commands at the back of the queue.

This patch would check for exchange availability before command submission.

Fixes: 89c72f4245a8 ("scsi: qla2xxx: Add IOCB resource tracking")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  6 +++-
 drivers/scsi/qla2xxx/qla_edif.c   |  7 +++--
 drivers/scsi/qla2xxx/qla_init.c   | 13 ++++++++
 drivers/scsi/qla2xxx/qla_inline.h | 52 +++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_iocb.c   | 28 ++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c    |  3 +-
 drivers/scsi/qla2xxx/qla_nvme.c   | 15 ++++++++-
 7 files changed, 88 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a26a373be9da..cd4eb11b0707 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -660,7 +660,7 @@ enum {
 
 struct iocb_resource {
 	u8 res_type;
-	u8 pad;
+	u8  exch_cnt;
 	u16 iocb_cnt;
 };
 
@@ -3721,6 +3721,10 @@ struct qla_fw_resources {
 	u16 iocbs_limit;
 	u16 iocbs_qp_limit;
 	u16 iocbs_used;
+	u16 exch_total;
+	u16 exch_limit;
+	u16 exch_used;
+	u16 pad;
 };
 
 #define QLA_IOCB_PCT_LIMIT 95
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 00ccc41cef14..d17ba6275b68 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2989,9 +2989,10 @@ qla28xx_start_scsi_edif(srb_t *sp)
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = req_cnt;
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -3185,7 +3186,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
 		mempool_free(sp->u.scmd.ct6_ctx, ha->ctx_mempool);
 		sp->u.scmd.ct6_ctx = NULL;
 	}
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(lock, flags);
 
 	return QLA_FUNCTION_FAILED;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8d9ecabb1aac..fd27fb511479 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -128,12 +128,14 @@ static void qla24xx_abort_iocb_timeout(void *data)
 		    sp->cmd_sp)) {
 			qpair->req->outstanding_cmds[handle] = NULL;
 			cmdsp_found = 1;
+			qla_put_fw_resources(qpair, &sp->cmd_sp->iores);
 		}
 
 		/* removing the abort */
 		if (qpair->req->outstanding_cmds[handle] == sp) {
 			qpair->req->outstanding_cmds[handle] = NULL;
 			sp_found = 1;
+			qla_put_fw_resources(qpair, &sp->iores);
 			break;
 		}
 	}
@@ -2000,6 +2002,7 @@ qla2x00_tmf_iocb_timeout(void *data)
 		for (h = 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
 			if (sp->qpair->req->outstanding_cmds[h] == sp) {
 				sp->qpair->req->outstanding_cmds[h] = NULL;
+				qla_put_fw_resources(sp->qpair, &sp->iores);
 				break;
 			}
 		}
@@ -3943,6 +3946,12 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
 	ha->base_qpair->fwres.iocbs_limit = limit;
 	ha->base_qpair->fwres.iocbs_qp_limit = limit / num_qps;
 	ha->base_qpair->fwres.iocbs_used = 0;
+
+	ha->base_qpair->fwres.exch_total = ha->orig_fw_xcb_count;
+	ha->base_qpair->fwres.exch_limit = (ha->orig_fw_xcb_count *
+					    QLA_IOCB_PCT_LIMIT) / 100;
+	ha->base_qpair->fwres.exch_used  = 0;
+
 	for (i = 0; i < ha->max_qpairs; i++) {
 		if (ha->queue_pair_map[i])  {
 			ha->queue_pair_map[i]->fwres.iocbs_total =
@@ -3951,6 +3960,10 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
 			ha->queue_pair_map[i]->fwres.iocbs_qp_limit =
 				limit / num_qps;
 			ha->queue_pair_map[i]->fwres.iocbs_used = 0;
+			ha->queue_pair_map[i]->fwres.exch_total = ha->orig_fw_xcb_count;
+			ha->queue_pair_map[i]->fwres.exch_limit =
+				(ha->orig_fw_xcb_count * QLA_IOCB_PCT_LIMIT) / 100;
+			ha->queue_pair_map[i]->fwres.exch_used = 0;
 		}
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 5185dc5daf80..2d5a275d8b00 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -380,13 +380,16 @@ qla2xxx_get_fc4_priority(struct scsi_qla_host *vha)
 
 enum {
 	RESOURCE_NONE,
-	RESOURCE_INI,
+	RESOURCE_IOCB  = BIT_0,
+	RESOURCE_EXCH = BIT_1,  /* exchange */
+	RESOURCE_FORCE = BIT_2,
 };
 
 static inline int
-qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
+qla_get_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 {
 	u16 iocbs_used, i;
+	u16 exch_used;
 	struct qla_hw_data *ha = qp->vha->hw;
 
 	if (!ql2xenforce_iocb_limit) {
@@ -394,10 +397,7 @@ qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
 		return 0;
 	}
 
-	if ((iores->iocb_cnt + qp->fwres.iocbs_used) < qp->fwres.iocbs_qp_limit) {
-		qp->fwres.iocbs_used += iores->iocb_cnt;
-		return 0;
-	} else {
+	if ((iores->iocb_cnt + qp->fwres.iocbs_used) >= qp->fwres.iocbs_qp_limit) {
 		/* no need to acquire qpair lock. It's just rough calculation */
 		iocbs_used = ha->base_qpair->fwres.iocbs_used;
 		for (i = 0; i < ha->max_qpairs; i++) {
@@ -405,30 +405,48 @@ qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
 				iocbs_used += ha->queue_pair_map[i]->fwres.iocbs_used;
 		}
 
-		if ((iores->iocb_cnt + iocbs_used) < qp->fwres.iocbs_limit) {
-			qp->fwres.iocbs_used += iores->iocb_cnt;
-			return 0;
-		} else {
+		if ((iores->iocb_cnt + iocbs_used) >= qp->fwres.iocbs_limit) {
+			iores->res_type = RESOURCE_NONE;
+			return -ENOSPC;
+		}
+	}
+
+	if (iores->res_type & RESOURCE_EXCH) {
+		exch_used = ha->base_qpair->fwres.exch_used;
+		for (i = 0; i < ha->max_qpairs; i++) {
+			if (ha->queue_pair_map[i])
+				exch_used += ha->queue_pair_map[i]->fwres.exch_used;
+		}
+
+		if ((exch_used + iores->exch_cnt) >= qp->fwres.exch_limit) {
 			iores->res_type = RESOURCE_NONE;
 			return -ENOSPC;
 		}
 	}
+	qp->fwres.iocbs_used += iores->iocb_cnt;
+	qp->fwres.exch_used += iores->exch_cnt;
+	return 0;
 }
 
 static inline void
-qla_put_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
+qla_put_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 {
-	switch (iores->res_type) {
-	case RESOURCE_NONE:
-		break;
-	default:
+	if (iores->res_type & RESOURCE_IOCB) {
 		if (qp->fwres.iocbs_used >= iores->iocb_cnt) {
 			qp->fwres.iocbs_used -= iores->iocb_cnt;
 		} else {
-			// should not happen
+			/* should not happen */
 			qp->fwres.iocbs_used = 0;
 		}
-		break;
+	}
+
+	if (iores->res_type & RESOURCE_EXCH) {
+		if (qp->fwres.exch_used >= iores->exch_cnt) {
+			qp->fwres.exch_used -= iores->exch_cnt;
+		} else {
+			/* should not happen */
+			qp->fwres.exch_used = 0;
+		}
 	}
 	iores->res_type = RESOURCE_NONE;
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 42ce4e1fe744..399ec8da2d73 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1589,9 +1589,10 @@ qla24xx_start_scsi(srb_t *sp)
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = req_cnt;
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -1678,7 +1679,7 @@ qla24xx_start_scsi(srb_t *sp)
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -1793,9 +1794,10 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -1883,7 +1885,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	}
 	/* Cleanup will be performed by the caller (queuecommand) */
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -1952,9 +1954,10 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = req_cnt;
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -2041,7 +2044,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -2171,9 +2174,10 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -2260,7 +2264,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	}
 	/* Cleanup will be performed by the caller (queuecommand) */
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e19fde304e5c..42d3d2de3d31 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3197,7 +3197,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		}
 		return;
 	}
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 
 	if (sp->cmd_type != TYPE_SRB) {
 		req->outstanding_cmds[handle] = NULL;
@@ -3618,7 +3618,6 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	default:
 		sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 		if (sp) {
-			qla_put_iocbs(sp->qpair, &sp->iores);
 			sp->done(sp, res);
 			return 0;
 		}
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 8927ddc5e69c..c57e02a35521 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -428,13 +428,24 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 		goto queuing_error;
 	}
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
+	sp->iores.iocb_cnt = req_cnt;
+	if (qla_get_fw_resources(sp->qpair, &sp->iores)) {
+		rval = -EBUSY;
+		goto queuing_error;
+	}
+
 	if (req->cnt < (req_cnt + 2)) {
 		if (IS_SHADOW_REG_CAPABLE(ha)) {
 			cnt = *req->out_ptr;
 		} else {
 			cnt = rd_reg_dword_relaxed(req->req_q_out);
-			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
+			if (qla2x00_check_reg16_for_disconnect(vha, cnt)) {
+				rval = -EBUSY;
 				goto queuing_error;
+			}
 		}
 
 		if (req->ring_index < cnt)
@@ -583,6 +594,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 		qla24xx_process_response_queue(vha, rsp);
 
 queuing_error:
+	if (rval)
+		qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return rval;
-- 
2.19.0.rc0

