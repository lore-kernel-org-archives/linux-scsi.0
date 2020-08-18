Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9B6C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 589442065D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VlFFQ//5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgHRMfU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:35:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726653AbgHRMfT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:35:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICTuZB027575
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:35:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=0wH23Sr6xRNVQtP0bTal8DzrvWWtRMpDHTdFDyhiuiA=;
 b=VlFFQ//5mkj5QvUjLRh21y4b3oq6R//fYYhTaEKPgdWi6dxsqweMtLGLP63CKdUarlmL
 m9ZK6eI6XoCYf85MRwjoqxrvoFzTBSQdWhyU07nWaTvY0AyJDiNQkVeHXM8xe3ePVosj
 jeL9+Nv8H76H2A2UJomxEbkRZqCIsa5o+2bY/IY049Pr2UA347YrCH0k0TaqY7P24wcm
 9ZnaXaOzOTcIO2Sh9AoVmz8nET3WkMdOn8FfxRSGuMhcsqY8l3DyHCsFGEuTl1QbXTqb
 U8wkLOsA5+2EKnxTVOAQjCVNfLuLa5hcFC0dLoHXvKYmYZaJOpITfoD22HXSfrvek94o 9g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fhjepw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:35:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:35:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 05:35:16 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 489FB3F704F;
        Tue, 18 Aug 2020 05:35:16 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07ICZGEh020450;
        Tue, 18 Aug 2020 05:35:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07ICZGEd020441;
        Tue, 18 Aug 2020 05:35:16 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/12] qla2xxx: performance tweak
Date:   Tue, 18 Aug 2020 05:31:58 -0700
Message-ID: <20200818123203.20361-8-njavali@marvell.com>
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

This patch move statistic fields from vha struct to qpair
to reduce memory thrashing.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 46 ++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_def.h  | 32 +++++++++++++++++------
 drivers/scsi/qla2xxx/qla_init.c |  5 ++--
 drivers/scsi/qla2xxx/qla_iocb.c | 18 +++++++------
 drivers/scsi/qla2xxx/qla_isr.c  |  8 +++---
 drivers/scsi/qla2xxx/qla_mid.c  |  4 +--
 drivers/scsi/qla2xxx/qla_nvme.c |  8 +++---
 drivers/scsi/qla2xxx/qla_os.c   | 10 ++++---
 8 files changed, 92 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d006ae193677..1ee747ba4ecc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2726,6 +2726,9 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	struct link_statistics *stats;
 	dma_addr_t stats_dma;
 	struct fc_host_statistics *p = &vha->fc_host_stat;
+	struct qla_qpair *qpair;
+	int i;
+	u64 ib = 0, ob = 0, ir = 0, or = 0;
 
 	memset(p, -1, sizeof(*p));
 
@@ -2762,6 +2765,27 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	if (rval != QLA_SUCCESS)
 		goto done_free;
 
+	/* --- */
+	for (i = 0; i < vha->hw->max_qpairs; i++) {
+		qpair = vha->hw->queue_pair_map[i];
+		if (!qpair)
+			continue;
+		ir += qpair->counters.input_requests;
+		or += qpair->counters.output_requests;
+		ib += qpair->counters.input_bytes;
+		ob += qpair->counters.output_bytes;
+	}
+	ir += ha->base_qpair->counters.input_requests;
+	or += ha->base_qpair->counters.output_requests;
+	ib += ha->base_qpair->counters.input_bytes;
+	ob += ha->base_qpair->counters.output_bytes;
+
+	ir += vha->qla_stats.input_requests;
+	or += vha->qla_stats.output_requests;
+	ib += vha->qla_stats.input_bytes;
+	ob += vha->qla_stats.output_bytes;
+	/* --- */
+
 	p->link_failure_count = le32_to_cpu(stats->link_fail_cnt);
 	p->loss_of_sync_count = le32_to_cpu(stats->loss_sync_cnt);
 	p->loss_of_signal_count = le32_to_cpu(stats->loss_sig_cnt);
@@ -2781,15 +2805,16 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 			p->rx_words = le64_to_cpu(stats->fpm_recv_word_cnt);
 			p->tx_words = le64_to_cpu(stats->fpm_xmit_word_cnt);
 		} else {
-			p->rx_words = vha->qla_stats.input_bytes;
-			p->tx_words = vha->qla_stats.output_bytes;
+			p->rx_words = ib >> 2;
+			p->tx_words = ob >> 2;
 		}
 	}
+
 	p->fcp_control_requests = vha->qla_stats.control_requests;
-	p->fcp_input_requests = vha->qla_stats.input_requests;
-	p->fcp_output_requests = vha->qla_stats.output_requests;
-	p->fcp_input_megabytes = vha->qla_stats.input_bytes >> 20;
-	p->fcp_output_megabytes = vha->qla_stats.output_bytes >> 20;
+	p->fcp_input_requests = ir;
+	p->fcp_output_requests = or;
+	p->fcp_input_megabytes  = ib >> 20;
+	p->fcp_output_megabytes = ob >> 20;
 	p->seconds_since_last_reset =
 	    get_jiffies_64() - vha->qla_stats.jiffies_at_last_reset;
 	do_div(p->seconds_since_last_reset, HZ);
@@ -2809,9 +2834,18 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	struct link_statistics *stats;
 	dma_addr_t stats_dma;
+	int i;
+	struct qla_qpair *qpair;
 
 	memset(&vha->qla_stats, 0, sizeof(vha->qla_stats));
 	memset(&vha->fc_host_stat, 0, sizeof(vha->fc_host_stat));
+	for (i = 0; i < vha->hw->max_qpairs; i++) {
+		qpair = vha->hw->queue_pair_map[i];
+		if (!qpair)
+			continue;
+		memset(&qpair->counters, 0, sizeof(qpair->counters));
+	}
+	memset(&ha->base_qpair->counters, 0, sizeof(qpair->counters));
 
 	vha->qla_stats.jiffies_at_last_reset = get_jiffies_64();
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ad4a0ba7203c..3ca8665638c4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2443,12 +2443,6 @@ typedef struct fc_port {
 	struct list_head list;
 	struct scsi_qla_host *vha;
 
-	uint8_t node_name[WWN_SIZE];
-	uint8_t port_name[WWN_SIZE];
-	port_id_t d_id;
-	uint16_t loop_id;
-	uint16_t old_loop_id;
-
 	unsigned int conf_compl_supported:1;
 	unsigned int deleted:2;
 	unsigned int free_pending:1;
@@ -2465,6 +2459,13 @@ typedef struct fc_port {
 	unsigned int n2n_flag:1;
 	unsigned int explicit_logout:1;
 	unsigned int prli_pend_timer:1;
+	uint8_t nvme_flag;
+
+	uint8_t node_name[WWN_SIZE];
+	uint8_t port_name[WWN_SIZE];
+	port_id_t d_id;
+	uint16_t loop_id;
+	uint16_t old_loop_id;
 
 	struct completion nvme_del_done;
 	uint32_t nvme_prli_service_param;
@@ -2473,7 +2474,7 @@ typedef struct fc_port {
 #define NVME_PRLI_SP_TARGET     BIT_4
 #define NVME_PRLI_SP_DISCOVERY  BIT_3
 #define NVME_PRLI_SP_FIRST_BURST	BIT_0
-	uint8_t nvme_flag;
+
 	uint32_t nvme_first_burst_size;
 #define NVME_FLAG_REGISTERED 4
 #define NVME_FLAG_DELETING 2
@@ -3510,6 +3511,14 @@ struct qla_tgt_counters {
 	uint64_t num_term_xchg_sent;
 };
 
+struct qla_counters {
+	uint64_t input_bytes;
+	uint64_t input_requests;
+	uint64_t output_bytes;
+	uint64_t output_requests;
+
+};
+
 struct qla_qpair;
 
 /* Response queue data structure */
@@ -3594,6 +3603,7 @@ struct qla_qpair {
 	uint32_t enable_class_2:1;
 	uint32_t enable_explicit_conf:1;
 	uint32_t use_shadow_reg:1;
+	uint32_t rcv_intr:1;
 
 	uint16_t id;			/* qp number used with FW */
 	uint16_t vp_idx;		/* vport ID */
@@ -3609,13 +3619,16 @@ struct qla_qpair {
 	struct qla_msix_entry *msix; /* point to &ha->msix_entries[x] */
 	struct qla_hw_data *hw;
 	struct work_struct q_work;
+	struct qla_counters counters;
+
 	struct list_head qp_list_elem; /* vha->qp_list */
 	struct list_head hints_list;
-	uint16_t cpuid;
+
 	uint16_t retry_term_cnt;
 	__le32	retry_term_exchg_addr;
 	uint64_t retry_term_jiff;
 	struct qla_tgt_counters tgt_counters;
+	uint16_t cpuid;
 };
 
 /* Place holder for FW buffer parameters */
@@ -4129,6 +4142,9 @@ struct qla_hw_data {
 #define USE_ASYNC_SCAN(ha) (IS_QLA25XX(ha) || IS_QLA81XX(ha) ||\
 	IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
 
+#define IS_ZIO_THRESHOLD_CAPABLE(ha) \
+	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+
 	/* HBA serial number */
 	uint8_t		serial0;
 	uint8_t		serial1;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b4d53eb4e53e..99f322fb74ab 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3690,9 +3690,8 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 					goto execute_fw_with_lr;
 				}
 
-				if ((IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-				    IS_QLA28XX(ha)) &&
-				    (ha->zio_mode == QLA_ZIO_MODE_6))
+				if (IS_ZIO_THRESHOLD_CAPABLE(ha) &&
+				    ha->zio_mode == QLA_ZIO_MODE_6)
 					qla27xx_set_zio_threshold(vha,
 					    ha->last_zio_threshold);
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index e3d2dea0b057..d69e16e844aa 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -594,6 +594,7 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 	uint32_t dsd_list_len;
 	struct dsd_dma *dsd_ptr;
 	struct ct6_dsd *ctx;
+	struct qla_qpair *qpair = sp->qpair;
 
 	cmd = GET_CMD_SP(sp);
 
@@ -612,12 +613,12 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		cmd_pkt->control_flags = cpu_to_le16(CF_WRITE_DATA);
-		vha->qla_stats.output_bytes += scsi_bufflen(cmd);
-		vha->qla_stats.output_requests++;
+		qpair->counters.output_bytes += scsi_bufflen(cmd);
+		qpair->counters.output_requests++;
 	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		cmd_pkt->control_flags = cpu_to_le16(CF_READ_DATA);
-		vha->qla_stats.input_bytes += scsi_bufflen(cmd);
-		vha->qla_stats.input_requests++;
+		qpair->counters.input_bytes += scsi_bufflen(cmd);
+		qpair->counters.input_requests++;
 	}
 
 	cur_seg = scsi_sglist(cmd);
@@ -704,6 +705,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
+	struct qla_qpair *qpair = sp->qpair;
 
 	cmd = GET_CMD_SP(sp);
 
@@ -721,12 +723,12 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		cmd_pkt->task_mgmt_flags = cpu_to_le16(TMF_WRITE_DATA);
-		vha->qla_stats.output_bytes += scsi_bufflen(cmd);
-		vha->qla_stats.output_requests++;
+		qpair->counters.output_bytes += scsi_bufflen(cmd);
+		qpair->counters.output_requests++;
 	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
 		cmd_pkt->task_mgmt_flags = cpu_to_le16(TMF_READ_DATA);
-		vha->qla_stats.input_bytes += scsi_bufflen(cmd);
-		vha->qla_stats.input_requests++;
+		qpair->counters.input_bytes += scsi_bufflen(cmd);
+		qpair->counters.input_requests++;
 	}
 
 	/* One DSD is available in the Command Type 3 IOCB */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d38dd6520b53..a63f2000fadf 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3414,8 +3414,10 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	if (!ha->flags.fw_started)
 		return;
 
-	if (rsp->qpair->cpuid != smp_processor_id())
+	if (rsp->qpair->cpuid != smp_processor_id() || !rsp->qpair->rcv_intr) {
+		rsp->qpair->rcv_intr = 1;
 		qla_cpu_update(rsp->qpair, smp_processor_id());
+	}
 
 	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
@@ -3865,7 +3867,7 @@ qla2xxx_msix_rsp_q(int irq, void *dev_id)
 	}
 	ha = qpair->hw;
 
-	queue_work(ha->wq, &qpair->q_work);
+	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
 
 	return IRQ_HANDLED;
 }
@@ -3891,7 +3893,7 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
 	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	queue_work(ha->wq, &qpair->q_work);
+	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 15efe2f04b86..08cfe043ac66 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -808,11 +808,9 @@ static void qla_do_work(struct work_struct *work)
 {
 	unsigned long flags;
 	struct qla_qpair *qpair = container_of(work, struct qla_qpair, q_work);
-	struct scsi_qla_host *vha;
-	struct qla_hw_data *ha = qpair->hw;
+	struct scsi_qla_host *vha = qpair->vha;
 
 	spin_lock_irqsave(&qpair->qp_lock, flags);
-	vha = pci_get_drvdata(ha->pdev);
 	qla24xx_process_response_queue(vha, qpair->rsp);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 435f17f87301..1c742875817f 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -428,8 +428,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	/* No data transfer how do we check buffer len == 0?? */
 	if (fd->io_dir == NVMEFC_FCP_READ) {
 		cmd_pkt->control_flags = cpu_to_le16(CF_READ_DATA);
-		vha->qla_stats.input_bytes += fd->payload_length;
-		vha->qla_stats.input_requests++;
+		qpair->counters.input_bytes += fd->payload_length;
+		qpair->counters.input_requests++;
 	} else if (fd->io_dir == NVMEFC_FCP_WRITE) {
 		cmd_pkt->control_flags = cpu_to_le16(CF_WRITE_DATA);
 		if ((vha->flags.nvme_first_burst) &&
@@ -441,8 +441,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 				cmd_pkt->control_flags |=
 					cpu_to_le16(CF_NVME_FIRST_BURST_ENABLE);
 		}
-		vha->qla_stats.output_bytes += fd->payload_length;
-		vha->qla_stats.output_requests++;
+		qpair->counters.output_bytes += fd->payload_length;
+		qpair->counters.output_requests++;
 	} else if (fd->io_dir == 0) {
 		cmd_pkt->control_flags = 0;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 858549e21aea..077f50ca4ef1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7198,8 +7198,10 @@ qla2x00_timer(struct timer_list *t)
 	 * FC-NVME
 	 * see if the active AEN count has changed from what was last reported.
 	 */
+	index = atomic_read(&ha->nvme_active_aen_cnt);
 	if (!vha->vp_idx &&
-	    (atomic_read(&ha->nvme_active_aen_cnt) != ha->nvme_last_rptd_aen) &&
+	    (index != ha->nvme_last_rptd_aen) &&
+	    (index >= DEFAULT_ZIO_THRESHOLD) &&
 	    ha->zio_mode == QLA_ZIO_MODE_6 &&
 	    !ha->flags.host_shutting_down) {
 		ql_log(ql_log_info, vha, 0x3002,
@@ -7211,9 +7213,9 @@ qla2x00_timer(struct timer_list *t)
 	}
 
 	if (!vha->vp_idx &&
-	    (atomic_read(&ha->zio_threshold) != ha->last_zio_threshold) &&
-	    (ha->zio_mode == QLA_ZIO_MODE_6) &&
-	    (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))) {
+	    atomic_read(&ha->zio_threshold) != ha->last_zio_threshold &&
+	    ha->zio_mode == QLA_ZIO_MODE_6 &&
+	    IS_ZIO_THRESHOLD_CAPABLE(ha)) {
 		ql_log(ql_log_info, vha, 0x3002,
 		    "Sched: Set ZIO exchange threshold to %d.\n",
 		    ha->last_zio_threshold);
-- 
2.19.0.rc0

