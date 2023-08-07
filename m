Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCA9EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Aug 2023 12:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbjHGMLq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 08:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbjHGMLn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 08:11:43 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3451BFB
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 05:11:14 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3777mefd005711
        for <linux-scsi@vger.kernel.org>; Mon, 7 Aug 2023 05:10:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=e2fOZCsuUpKqh29WBZLXVeVtAg9AzbL6DSoGHQLup3I=;
 b=AsPyEwdBck9mrDc2jMS88cjAgPdqn/YQMyEzfpc9I618RS8Wgj67BeJPA7HsXQmL8g72
 iBPB6XyKzNZbAH2q26q/uu1WU48LF4CBN5ac4srW2x25VCTXdlFfoB9oRMRp691ofJ3Y
 OA45tuYcyBbjfUla1rG1PjPWnTiKkfNEcvZzzj0ilH+9cNla8bRbguRLPtd+ZxRWPejC
 ybGIOZPvQY0/bemGdeF2ESYxVBSCBSCjksT6F8xgPak+FL285KtuiEqOCp3C9Hsk0MlU
 aRVMixquXCHH34kWEPNkbAP70E94e/0mgX8sYokAMMO4ylcCGRtQYJc+B9KMmYACSclW Ng== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3s9nxkvhur-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Aug 2023 05:10:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 7 Aug
 2023 05:10:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 7 Aug 2023 05:10:09 -0700
Received: from localhost.marvell.com (unknown [10.30.46.195])
        by maili.marvell.com (Postfix) with ESMTP id F19DC3F70A8;
        Mon,  7 Aug 2023 05:10:07 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH v2 03/10] qla2xxx: Fix fw resource tracking
Date:   Mon, 7 Aug 2023 17:39:51 +0530
Message-ID: <20230807120958.3730-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20230807120958.3730-1-njavali@marvell.com>
References: <20230807120958.3730-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 0-RkmFwgeiQfQ3lspJuOw5EIMZaiPD12
X-Proofpoint-ORIG-GUID: 0-RkmFwgeiQfQ3lspJuOw5EIMZaiPD12
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_11,2023-08-03_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

The storage was not draining io's and the work load
is not spread out across different CPU's evenly. This led to
FW resource counters getting over run on the busy CPU. This
overrun prevented error recovery from happening in a timely
manner.

By switching the counter to atomic, it allows the count to
be little more accurate to prevent the overrun.

Cc: stable@vger.kernel.org
Fixes: da7c21b72aa8 ("scsi: qla2xxx: Fix command flush during TMF")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h    | 11 ++++++
 drivers/scsi/qla2xxx/qla_dfs.c    | 10 ++++++
 drivers/scsi/qla2xxx/qla_init.c   |  8 +++++
 drivers/scsi/qla2xxx/qla_inline.h | 57 ++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c     |  5 +--
 5 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5882e61141e6..b5ec15bbce99 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3770,6 +3770,16 @@ struct qla_fw_resources {
 	u16 pad;
 };
 
+struct qla_fw_res {
+	u16      iocb_total;
+	u16      iocb_limit;
+	atomic_t iocb_used;
+
+	u16      exch_total;
+	u16      exch_limit;
+	atomic_t exch_used;
+};
+
 #define QLA_IOCB_PCT_LIMIT 95
 
 struct  qla_buf_pool {
@@ -4829,6 +4839,7 @@ struct qla_hw_data {
 	u8 edif_post_stop_cnt_down;
 	struct qla_vp_map *vp_map;
 	struct qla_nvme_fc_rjt lsrjt;
+	struct qla_fw_res fwres ____cacheline_aligned;
 };
 
 #define RX_ELS_SIZE (roundup(sizeof(struct enode) + ELS_MAX_PAYLOAD, SMP_CACHE_BYTES))
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 1925cc6897b6..f060e593685d 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -276,6 +276,16 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 
 		seq_printf(s, "estimate exchange used[%d] high water limit [%d] n",
 			   exch_used, ha->base_qpair->fwres.exch_limit);
+
+		if (ql2xenforce_iocb_limit == 2) {
+			iocbs_used = atomic_read(&ha->fwres.iocb_used);
+			exch_used  = atomic_read(&ha->fwres.exch_used);
+			seq_printf(s, "        estimate iocb2 used [%d] high water limit [%d]\n",
+					iocbs_used, ha->fwres.iocb_limit);
+
+			seq_printf(s, "        estimate exchange2 used[%d] high water limit [%d] \n",
+					exch_used, ha->fwres.exch_limit);
+		}
 	}
 
 	return 0;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ddc9b54f5703..7faf2109228e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4214,6 +4214,14 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
 			ha->queue_pair_map[i]->fwres.exch_used = 0;
 		}
 	}
+
+	ha->fwres.iocb_total = ha->orig_fw_iocb_count;
+	ha->fwres.iocb_limit = (ha->orig_fw_iocb_count * QLA_IOCB_PCT_LIMIT) / 100;
+	ha->fwres.exch_total = ha->orig_fw_xcb_count;
+	ha->fwres.exch_limit = (ha->orig_fw_xcb_count * QLA_IOCB_PCT_LIMIT) / 100;
+
+	atomic_set(&ha->fwres.iocb_used, 0);
+	atomic_set(&ha->fwres.exch_used, 0);
 }
 
 void qla_adjust_iocb_limit(scsi_qla_host_t *vha)
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 0167e85ba058..0556969f6dc1 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -386,6 +386,7 @@ enum {
 	RESOURCE_IOCB = BIT_0,
 	RESOURCE_EXCH = BIT_1,  /* exchange */
 	RESOURCE_FORCE = BIT_2,
+	RESOURCE_HA = BIT_3,
 };
 
 static inline int
@@ -393,7 +394,7 @@ qla_get_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 {
 	u16 iocbs_used, i;
 	u16 exch_used;
-	struct qla_hw_data *ha = qp->vha->hw;
+	struct qla_hw_data *ha = qp->hw;
 
 	if (!ql2xenforce_iocb_limit) {
 		iores->res_type = RESOURCE_NONE;
@@ -428,15 +429,69 @@ qla_get_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 			return -ENOSPC;
 		}
 	}
+
+	if (ql2xenforce_iocb_limit == 2) {
+		if ((iores->iocb_cnt + atomic_read(&ha->fwres.iocb_used)) >=
+		    ha->fwres.iocb_limit) {
+			iores->res_type = RESOURCE_NONE;
+			return -ENOSPC;
+		}
+
+		if (iores->res_type & RESOURCE_EXCH) {
+			if ((iores->exch_cnt + atomic_read(&ha->fwres.exch_used)) >=
+			    ha->fwres.exch_limit) {
+				iores->res_type = RESOURCE_NONE;
+				return -ENOSPC;
+			}
+		}
+	}
+
 force:
 	qp->fwres.iocbs_used += iores->iocb_cnt;
 	qp->fwres.exch_used += iores->exch_cnt;
+	if (ql2xenforce_iocb_limit == 2) {
+		atomic_add(iores->iocb_cnt, &ha->fwres.iocb_used);
+		atomic_add(iores->exch_cnt, &ha->fwres.exch_used);
+		iores->res_type |= RESOURCE_HA;
+	}
 	return 0;
 }
 
+/*
+ * decrement to zero.  This routine will not decrement below zero
+ * @v:  pointer of type atomic_t
+ * @amount: amount to decrement from v
+ */
+static void qla_atomic_dtz(atomic_t *v, int amount)
+{
+	int c, old, dec;
+
+	c = atomic_read(v);
+	for (;;) {
+		dec = c - amount;
+		if (unlikely(dec < 0))
+			dec = 0;
+
+		old = atomic_cmpxchg((v), c, dec);
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+}
+
 static inline void
 qla_put_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 {
+	struct qla_hw_data *ha = qp->hw;
+
+	if (iores->res_type & RESOURCE_HA) {
+		if (iores->res_type & RESOURCE_IOCB)
+			qla_atomic_dtz(&ha->fwres.iocb_used, iores->iocb_cnt);
+
+		if (iores->res_type & RESOURCE_EXCH)
+			qla_atomic_dtz(&ha->fwres.exch_used, iores->exch_cnt);
+	}
+
 	if (iores->res_type & RESOURCE_IOCB) {
 		if (qp->fwres.iocbs_used >= iores->iocb_cnt) {
 			qp->fwres.iocbs_used -= iores->iocb_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a18bcc86a21a..7da13607e239 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -44,10 +44,11 @@ module_param(ql2xfulldump_on_mpifail, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql2xfulldump_on_mpifail,
 		 "Set this to take full dump on MPI hang.");
 
-int ql2xenforce_iocb_limit = 1;
+int ql2xenforce_iocb_limit = 2;
 module_param(ql2xenforce_iocb_limit, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql2xenforce_iocb_limit,
-		 "Enforce IOCB throttling, to avoid FW congestion. (default: 1)");
+		 "Enforce IOCB throttling, to avoid FW congestion. (default: 2) "
+		 "1: track usage per queue, 2: track usage per adapter");
 
 /*
  * CT6 CTX allocation cache
-- 
2.23.1

