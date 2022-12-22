Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A57BC001B2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 04:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiLVEkO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbiLVEjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 23:39:46 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70497193DF
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:45 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BM4OKMn020309
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=/3TVZdDNho2E3+NLYvchuIBFr7ScBOzFEwswGlQvqWk=;
 b=MO3qNLoAVJMxQoFCjPpk9ozU0qqVURvFRrC3ty36uZ8DqddeOgAsqVafw+B8CXgjF0Di
 QDd79C3c+FlnUKK5l4YgDAEB2vSLVLyyMysPFv8xI7mz3IW2TLCTrJYyQ8aIDLe/sYvr
 IAcSc3B4Z+ARDfnoBnJoF63Ax1Q9Pr3azBJeikKYjkFhFmLUnPSvBFFgpJv3VPdxHe5w
 BARJ0t1MgUuHPEEM85SjHJxoy4ZyG5rKYYDFL7MSjOLghou85sI0eUrCADt5idl+B3U9
 rIJxz4v67le9lnfn28oBqhQK6G5ZSmy0u61NK/4/Zn8XwGXxxJkzgL0xh45hT5ulvDny Kw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3mhe5rsdhc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:44 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 21 Dec
 2022 20:39:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 21 Dec 2022 20:39:41 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 61B8A5B6950;
        Wed, 21 Dec 2022 20:39:41 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 07/10] qla2xxx: edif - Reduce memory usage during low IO
Date:   Wed, 21 Dec 2022 20:39:30 -0800
Message-ID: <20221222043933.2825-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221222043933.2825-1-njavali@marvell.com>
References: <20221222043933.2825-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: msX-cCaufhRldbyiKp7Ts79WLH-bsVJo
X-Proofpoint-ORIG-GUID: msX-cCaufhRldbyiKp7Ts79WLH-bsVJo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_01,2022-12-21_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For edif, each IO require a secondary buffer to carry the
fcp cmnd. During high traffic time, these buffers are cached
in the qpair. As traffic dies down, these buffers will be
trimmed as needed. If traffic is reduce to none over 2 consecutive
intervals, then these buffers will be further trimmed.

Free fcp cmnd buffers to reduce memory usage
during slow IO time.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  6 ++-
 drivers/scsi/qla2xxx/qla_gbl.h |  1 +
 drivers/scsi/qla2xxx/qla_mid.c | 94 ++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c  |  1 +
 4 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6f6190404939..972f1144b9d3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3735,7 +3735,10 @@ struct  qla_buf_pool {
 	u16 num_bufs;
 	u16 num_active;
 	u16 max_used;
-	u16 reserved;
+	u16 num_alloc;
+	u16 prev_max;
+	u16 pad;
+	uint32_t take_snapshot:1;
 	unsigned long *buf_map;
 	void **buf_array;
 	dma_addr_t *dma_array;
@@ -4874,6 +4877,7 @@ typedef struct scsi_qla_host {
 #define LOOP_READY	5
 #define LOOP_DEAD	6
 
+	unsigned long   buf_expired;
 	unsigned long   relogin_jif;
 	unsigned long   dpc_flags;
 #define RESET_MARKER_NEEDED	0	/* Send marker to ISP. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index d802d37fe739..9142df876c73 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -293,6 +293,7 @@ extern void qla2x00_alert_all_vps(struct rsp_que *, uint16_t *);
 extern void qla2x00_async_event(scsi_qla_host_t *, struct rsp_que *,
 	uint16_t *);
 extern int  qla2x00_vp_abort_isp(scsi_qla_host_t *);
+void qla_adjust_buf(struct scsi_qla_host *);
 
 /*
  * Global Function Prototypes in qla_iocb.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 5976a2f036e6..c6ca39b8e23d 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -1170,6 +1170,7 @@ int qla_get_buf(struct scsi_qla_host *vha, struct qla_qpair *qp, struct qla_buf_
 
 		dsc->buf = qp->buf_pool.buf_array[tag] = buf;
 		dsc->buf_dma = qp->buf_pool.dma_array[tag] = buf_dma;
+		qp->buf_pool.num_alloc++;
 	} else {
 		dsc->buf = qp->buf_pool.buf_array[tag];
 		dsc->buf_dma = qp->buf_pool.dma_array[tag];
@@ -1185,14 +1186,107 @@ int qla_get_buf(struct scsi_qla_host *vha, struct qla_qpair *qp, struct qla_buf_
 	return 0;
 }
 
+void qla_trim_buf(struct qla_qpair *qp, u16 trim)
+{
+	int i, j;
+	struct qla_hw_data *ha = qp->vha->hw;
+
+	if (!trim)
+		return;
+
+	for (i = 0; i < trim; i++) {
+		j = qp->buf_pool.num_alloc - 1;
+		if (test_bit(j, qp->buf_pool.buf_map)) {
+			ql_dbg(ql_dbg_io + ql_dbg_verbose, qp->vha, 0x300b,
+			       "QP id(%d): trim active buf[%d]. Remain %d bufs\n",
+			       qp->id, j, qp->buf_pool.num_alloc);
+			return;
+		}
+
+		if (qp->buf_pool.buf_array[j]) {
+			dma_pool_free(ha->fcp_cmnd_dma_pool, qp->buf_pool.buf_array[j],
+				      qp->buf_pool.dma_array[j]);
+			qp->buf_pool.buf_array[j] = NULL;
+			qp->buf_pool.dma_array[j] = 0;
+		}
+		qp->buf_pool.num_alloc--;
+		if (!qp->buf_pool.num_alloc)
+			break;
+	}
+	ql_dbg(ql_dbg_io + ql_dbg_verbose, qp->vha, 0x3010,
+	       "QP id(%d): trimmed %d bufs. Remain %d bufs\n",
+	       qp->id, trim, qp->buf_pool.num_alloc);
+}
+
+void __qla_adjust_buf(struct qla_qpair *qp)
+{
+	u32 trim;
+
+	qp->buf_pool.take_snapshot = 0;
+	qp->buf_pool.prev_max = qp->buf_pool.max_used;
+	qp->buf_pool.max_used = qp->buf_pool.num_active;
+
+	if (qp->buf_pool.prev_max > qp->buf_pool.max_used &&
+	    qp->buf_pool.num_alloc > qp->buf_pool.max_used) {
+		/* down trend */
+		trim = qp->buf_pool.num_alloc - qp->buf_pool.max_used;
+		trim  = (trim * 10) / 100;
+		trim = trim ? trim : 1;
+		qla_trim_buf(qp, trim);
+	} else if (!qp->buf_pool.prev_max  && !qp->buf_pool.max_used) {
+		/* 2 periods of no io */
+		qla_trim_buf(qp, qp->buf_pool.num_alloc);
+	}
+}
 
 /* it is assume qp->qp_lock is held at this point */
 void qla_put_buf(struct qla_qpair *qp, struct qla_buf_dsc *dsc)
 {
 	if (dsc->tag == TAG_FREED)
 		return;
+	lockdep_assert_held(qp->qp_lock_ptr);
 
 	clear_bit(dsc->tag, qp->buf_pool.buf_map);
 	qp->buf_pool.num_active--;
 	dsc->tag = TAG_FREED;
+
+	if (qp->buf_pool.take_snapshot)
+		__qla_adjust_buf(qp);
+}
+
+#define EXPIRE (60 * HZ)
+void qla_adjust_buf(struct scsi_qla_host *vha)
+{
+	unsigned long flags;
+	int i;
+	struct qla_qpair *qp;
+
+	if (vha->vp_idx)
+		return;
+
+	if (!vha->buf_expired) {
+		vha->buf_expired = jiffies + EXPIRE;
+		return;
+	}
+	if (time_before(jiffies, vha->buf_expired))
+		return;
+
+	vha->buf_expired = jiffies + EXPIRE;
+
+	for (i = 0; i < vha->hw->num_qpairs; i++) {
+		qp = vha->hw->queue_pair_map[i];
+		if (!qp)
+			continue;
+		if (!qp->buf_pool.num_alloc)
+			continue;
+
+		if (qp->buf_pool.take_snapshot) {
+			/* no io has gone through in the last EXPIRE period */
+			spin_lock_irqsave(qp->qp_lock_ptr, flags);
+			__qla_adjust_buf(qp);
+			spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
+		} else {
+			qp->buf_pool.take_snapshot = 1;
+		}
+	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f8758cea11d6..d07a914559d3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7522,6 +7522,7 @@ qla2x00_timer(struct timer_list *t)
 		set_bit(SET_ZIO_THRESHOLD_NEEDED, &vha->dpc_flags);
 		start_dpc++;
 	}
+	qla_adjust_buf(vha);
 
 	/* borrowing w to signify dpc will run */
 	w = 0;
-- 
2.19.0.rc0

