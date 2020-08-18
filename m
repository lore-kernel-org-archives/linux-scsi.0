Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB150C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A35B0206DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="j1dYfmI+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHRMg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:36:58 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53650 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726435AbgHRMg4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:36:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICTPrq027424
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:36:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=3ldWZyi3ILiSUJMh/Lehskvqv2vs5HUljgQ9TRRm6wA=;
 b=j1dYfmI+mEjUeAr7lxv2T3K6PuiHpNKGJHnZZOwdVamygFhZo5X3s452sJJ43RbEjOPa
 puMeXZLZrQOIe1KvvjwT4aPUK0QKqmg3fDeql+HIldgGRCXJhwYrGiO0RIoXBDHPPDAU
 N3Td9jaR4mxbonnowHEnJYLH61dmBrlaFftvoGeR9A0WHCH0EOgyuTF6FmUQFNuTLHsh
 aPVBbGR7UiV7hhXEGURugyHc3TDLdiZnv+VuCl8kER/1hKhq/6zs4R9qRc+56sgAS3Xt
 p17KMfj5FFYNmPeXyhxiMhtswB8lGZaxvXV9yVnFSWd/vbMILYtXQVyBr5/DXVCOqgsC /w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fhjexk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:36:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:36:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:36:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 05:36:52 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D381A3F703F;
        Tue, 18 Aug 2020 05:36:52 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07ICaqij020474;
        Tue, 18 Aug 2020 05:36:52 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07ICaqp9020473;
        Tue, 18 Aug 2020 05:36:52 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 11/12] qla2xxx: Add IOCB resource tracking
Date:   Tue, 18 Aug 2020 05:32:02 -0700
Message-ID: <20200818123203.20361-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200818123203.20361-1-njavali@marvell.com>
References: <20200818123203.20361-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

This patch tracks number of IOCB resources used in the IO
fast path. If the number of used IOCBs reach a high water
limit, driver would return the IO as busy and let upper layer
retry. This prevents over subscription of IOCB resources where
any future error recovery command is unable to cut through.
Enable IOCB throttling by default.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h    | 17 ++++++++++
 drivers/scsi/qla2xxx/qla_dfs.c    | 14 ++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |  3 ++
 drivers/scsi/qla2xxx/qla_init.c   | 26 +++++++++++++++
 drivers/scsi/qla2xxx/qla_inline.h | 55 +++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_iocb.c   | 28 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    |  2 ++
 drivers/scsi/qla2xxx/qla_os.c     |  6 ++++
 8 files changed, 151 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3ca8665638c4..863b9c7766e1 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -624,6 +624,12 @@ enum {
 	TYPE_TGT_TMCMD,		/* task management */
 };
 
+struct iocb_resource {
+	u8 res_type;
+	u8 pad;
+	u16 iocb_cnt;
+};
+
 typedef struct srb {
 	/*
 	 * Do not move cmd_type field, it needs to
@@ -631,6 +637,7 @@ typedef struct srb {
 	 */
 	uint8_t cmd_type;
 	uint8_t pad[3];
+	struct iocb_resource iores;
 	struct kref cmd_kref;	/* need to migrate ref_count over to this */
 	void *priv;
 	wait_queue_head_t nvme_ls_waitq;
@@ -3577,6 +3584,15 @@ struct req_que {
 	uint8_t req_pkt[REQUEST_ENTRY_SIZE];
 };
 
+struct qla_fw_resources {
+	u16 iocbs_total;
+	u16 iocbs_limit;
+	u16 iocbs_qp_limit;
+	u16 iocbs_used;
+};
+
+#define QLA_IOCB_PCT_LIMIT 95
+
 /*Queue pair data structure */
 struct qla_qpair {
 	spinlock_t qp_lock;
@@ -3629,6 +3645,7 @@ struct qla_qpair {
 	uint64_t retry_term_jiff;
 	struct qla_tgt_counters tgt_counters;
 	uint16_t cpuid;
+	struct qla_fw_resources fwres ____cacheline_aligned;
 };
 
 /* Place holder for FW buffer parameters */
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index b9b3a3dd93db..4a86dca4a445 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -257,6 +257,8 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 	struct scsi_qla_host *vha = s->private;
 	uint16_t mb[MAX_IOCB_MB_REG];
 	int rc;
+	struct qla_hw_data *ha = vha->hw;
+	u16 iocbs_used, i;
 
 	rc = qla24xx_res_count_wait(vha, mb, SIZEOF_IOCB_MB_REG);
 	if (rc != QLA_SUCCESS) {
@@ -281,6 +283,18 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 		    mb[23]);
 	}
 
+	if (ql2xenforce_iocb_limit) {
+		/* lock is not require. It's an estimate. */
+		iocbs_used = ha->base_qpair->fwres.iocbs_used;
+		for (i = 0; i < ha->max_qpairs; i++) {
+			if (ha->queue_pair_map[i])
+				iocbs_used += ha->queue_pair_map[i]->fwres.iocbs_used;
+		}
+
+		seq_printf(s, "Driver: estimate iocb used [%d] high water limit [%d]\n",
+			   iocbs_used, ha->base_qpair->fwres.iocbs_limit);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3360857c4405..9c4d077edf9e 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -129,6 +129,8 @@ int qla2x00_reserve_mgmt_server_loop_id(scsi_qla_host_t *);
 void qla_rscn_replay(fc_port_t *fcport);
 void qla24xx_free_purex_item(struct purex_item *item);
 extern bool qla24xx_risc_firmware_invalid(uint32_t *);
+void qla_init_iocb_limit(scsi_qla_host_t *);
+
 
 /*
  * Global Data in qla_os.c source file.
@@ -175,6 +177,7 @@ extern int qla2xuseresexchforels;
 extern int ql2xexlogins;
 extern int ql2xdifbundlinginternalbuffers;
 extern int ql2xfulldump_on_mpifail;
+extern int ql2xenforce_iocb_limit;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 99f322fb74ab..a1603bad3ee6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3622,6 +3622,31 @@ qla24xx_detect_sfp(scsi_qla_host_t *vha)
 	return ha->flags.lr_detected;
 }
 
+void qla_init_iocb_limit(scsi_qla_host_t *vha)
+{
+	u16 i, num_qps;
+	u32 limit;
+	struct qla_hw_data *ha = vha->hw;
+
+	num_qps = ha->num_qpairs + 1;
+	limit = (ha->orig_fw_iocb_count * QLA_IOCB_PCT_LIMIT) / 100;
+
+	ha->base_qpair->fwres.iocbs_total = ha->orig_fw_iocb_count;
+	ha->base_qpair->fwres.iocbs_limit = limit;
+	ha->base_qpair->fwres.iocbs_qp_limit = limit / num_qps;
+	ha->base_qpair->fwres.iocbs_used = 0;
+	for (i = 0; i < ha->max_qpairs; i++) {
+		if (ha->queue_pair_map[i])  {
+			ha->queue_pair_map[i]->fwres.iocbs_total =
+				ha->orig_fw_iocb_count;
+			ha->queue_pair_map[i]->fwres.iocbs_limit = limit;
+			ha->queue_pair_map[i]->fwres.iocbs_qp_limit =
+				limit / num_qps;
+			ha->queue_pair_map[i]->fwres.iocbs_used = 0;
+		}
+	}
+}
+
 /**
  * qla2x00_setup_chip() - Load and start RISC firmware.
  * @vha: HA context
@@ -3722,6 +3747,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 						    MIN_MULTI_ID_FABRIC - 1;
 				}
 				qla2x00_get_resource_cnts(vha);
+				qla_init_iocb_limit(vha);
 
 				/*
 				 * Allocate the array of outstanding commands
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 5501b4c581ec..9e9a5d3fb802 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -373,3 +373,58 @@ qla2xxx_get_fc4_priority(struct scsi_qla_host *vha)
 
 	return (data >> 6) & BIT_0 ? FC4_PRIORITY_FCP : FC4_PRIORITY_NVME;
 }
+
+enum {
+	RESOURCE_NONE,
+	RESOURCE_INI,
+};
+
+static inline int
+qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
+{
+	u16 iocbs_used, i;
+	struct qla_hw_data *ha = qp->vha->hw;
+
+	if (!ql2xenforce_iocb_limit) {
+		iores->res_type = RESOURCE_NONE;
+		return 0;
+	}
+
+	if ((iores->iocb_cnt + qp->fwres.iocbs_used) < qp->fwres.iocbs_qp_limit) {
+		qp->fwres.iocbs_used += iores->iocb_cnt;
+		return 0;
+	} else {
+		/* no need to acquire qpair lock. It's just rough calculation */
+		iocbs_used = ha->base_qpair->fwres.iocbs_used;
+		for (i = 0; i < ha->max_qpairs; i++) {
+			if (ha->queue_pair_map[i])
+				iocbs_used += ha->queue_pair_map[i]->fwres.iocbs_used;
+		}
+
+		if ((iores->iocb_cnt + iocbs_used) < qp->fwres.iocbs_limit) {
+			qp->fwres.iocbs_used += iores->iocb_cnt;
+			return 0;
+		} else {
+			iores->res_type = RESOURCE_NONE;
+			return -ENOSPC;
+		}
+	}
+}
+
+static inline void
+qla_put_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
+{
+	switch (iores->res_type) {
+	case RESOURCE_NONE:
+		break;
+	default:
+		if (qp->fwres.iocbs_used >= iores->iocb_cnt) {
+			qp->fwres.iocbs_used -= iores->iocb_cnt;
+		} else {
+			// should not happen
+			qp->fwres.iocbs_used = 0;
+		}
+		break;
+	}
+	iores->res_type = RESOURCE_NONE;
+}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d69e16e844aa..b60a332e5846 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1637,6 +1637,12 @@ qla24xx_start_scsi(srb_t *sp)
 
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+
+	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.iocb_cnt = req_cnt;
+	if (qla_get_iocbs(sp->qpair, &sp->iores))
+		goto queuing_error;
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    rd_reg_dword_relaxed(req->req_q_out);
@@ -1709,6 +1715,7 @@ qla24xx_start_scsi(srb_t *sp)
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
+	qla_put_iocbs(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -1822,6 +1829,12 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	/* Total Data and protection sg segment(s) */
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
+
+	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	if (qla_get_iocbs(sp->qpair, &sp->iores))
+		goto queuing_error;
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    rd_reg_dword_relaxed(req->req_q_out);
@@ -1896,6 +1909,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	}
 	/* Cleanup will be performed by the caller (queuecommand) */
 
+	qla_put_iocbs(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	return QLA_FUNCTION_FAILED;
 }
@@ -1957,6 +1971,12 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+
+	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.iocb_cnt = req_cnt;
+	if (qla_get_iocbs(sp->qpair, &sp->iores))
+		goto queuing_error;
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    rd_reg_dword_relaxed(req->req_q_out);
@@ -2029,6 +2049,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
+	qla_put_iocbs(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -2157,6 +2178,12 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	/* Total Data and protection sg segment(s) */
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
+
+	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	if (qla_get_iocbs(sp->qpair, &sp->iores))
+		goto queuing_error;
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    rd_reg_dword_relaxed(req->req_q_out);
@@ -2234,6 +2261,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	}
 	/* Cleanup will be performed by the caller (queuecommand) */
 
+	qla_put_iocbs(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 	return QLA_FUNCTION_FAILED;
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a63f2000fadf..bb3beaa77d39 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2901,6 +2901,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		}
 		return;
 	}
+	qla_put_iocbs(sp->qpair, &sp->iores);
 
 	if (sp->cmd_type != TYPE_SRB) {
 		req->outstanding_cmds[handle] = NULL;
@@ -3313,6 +3314,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	default:
 		sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 		if (sp) {
+			qla_put_iocbs(sp->qpair, &sp->iores);
 			sp->done(sp, res);
 			return 0;
 		}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 077f50ca4ef1..b9373a2dcbc1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -40,6 +40,11 @@ module_param(ql2xfulldump_on_mpifail, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql2xfulldump_on_mpifail,
 		 "Set this to take full dump on MPI hang.");
 
+int ql2xenforce_iocb_limit = 1;
+module_param(ql2xenforce_iocb_limit, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ql2xenforce_iocb_limit,
+		 "Enforce IOCB throttling, to avoid FW congestion. (default: 0)");
+
 /*
  * CT6 CTX allocation cache
  */
@@ -3316,6 +3321,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		for (i = 0; i < ha->max_qpairs; i++)
 			qla2xxx_create_qpair(base_vha, 5, 0, startit);
 	}
+	qla_init_iocb_limit(base_vha);
 
 	if (ha->flags.running_gold_fw)
 		goto skip_dpc;
-- 
2.19.0.rc0

