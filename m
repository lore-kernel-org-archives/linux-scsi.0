Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598A0C001B2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 04:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiLVEk1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbiLVEjr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 23:39:47 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1A619C20
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:46 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BM4OKMp020309
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=OPbuv0of2DcnU0Qr67s8xFrc4+PzqxAILZG/D+WnBjY=;
 b=UjsZWRp73UEJZE4R1m2/suEe827nO/dstwJeVYWndloZwqzJYDMDPH2EvQiW2r1OYabp
 ggYUPjuDG71WkntFkfRDdwf4qi7pF/eUAvgZ5DuKbclYGGVj7CYjWO7oVNaEtjiPCZwz
 1KuprSNoAlrO4udjTVHvRY/fvsGkdBH7Z6JwomkORXdNM4ZjwyPWguc4u5+T/YM4K1a5
 FN1b61Y5Zcigzq6XFc+kuo5KVTXOj4uMhVk56kxQOQsQHu8Qtr9Dr7Pr9x5zwNRFFbH7
 F9PY4A9dnEf1ZKm90pK6Vc/6L9DILVjpOa/+ZmsbUIgMF03CxkGSme8BZtA56E02hM2r Lg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3mhe5rsdhc-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:45 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 21 Dec
 2022 20:39:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 21 Dec 2022 20:39:41 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AFD9B3F7068;
        Wed, 21 Dec 2022 20:39:41 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 09/10] qla2xxx: Select qpair depending on which CPU post_cmd() gets called
Date:   Wed, 21 Dec 2022 20:39:32 -0800
Message-ID: <20221222043933.2825-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221222043933.2825-1-njavali@marvell.com>
References: <20221222043933.2825-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: kK6t2KD-s49PXmgSrST_L08WeK0D5UKZ
X-Proofpoint-ORIG-GUID: kK6t2KD-s49PXmgSrST_L08WeK0D5UKZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_01,2022-12-21_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shreyas Deodhar <sdeodhar@marvell.com>

In current IO path, Tx and Rx may not be processed on same CPU. This
may lead to thrashing and optimum performance may not be achieved.

Pick qpair such that Tx and Rx are processed on same CPU.

Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  2 ++
 drivers/scsi/qla2xxx/qla_init.c   |  2 --
 drivers/scsi/qla2xxx/qla_inline.h | 55 +++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    |  3 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |  4 +++
 drivers/scsi/qla2xxx/qla_os.c     |  6 ++++
 6 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 972f1144b9d3..ec0e987b71fa 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3469,6 +3469,7 @@ struct qla_msix_entry {
 	int have_irq;
 	int in_use;
 	uint32_t vector;
+	uint32_t vector_base0;
 	uint16_t entry;
 	char name[30];
 	void *handle;
@@ -4125,6 +4126,7 @@ struct qla_hw_data {
 	struct req_que **req_q_map;
 	struct rsp_que **rsp_q_map;
 	struct qla_qpair **queue_pair_map;
+	struct qla_qpair **qp_cpu_map;
 	unsigned long req_qid_map[(QLA_MAX_QUEUES / 8) / sizeof(unsigned long)];
 	unsigned long rsp_qid_map[(QLA_MAX_QUEUES / 8) / sizeof(unsigned long)];
 	unsigned long qpair_qid_map[(QLA_MAX_QUEUES / 8)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ce9e28b4d339..c5e73d5a26b1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9426,8 +9426,6 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 		qpair->req = ha->req_q_map[req_id];
 		qpair->rsp->req = qpair->req;
 		qpair->rsp->qpair = qpair;
-		/* init qpair to this cpu. Will adjust at run time. */
-		qla_cpu_update(qpair, raw_smp_processor_id());
 
 		if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
 			if (ha->fw_attributes & BIT_4)
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index b0ee307b5d4b..cce6e425c121 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -515,3 +515,58 @@ fcport_is_bigger(fc_port_t *fcport)
 {
 	return !fcport_is_smaller(fcport);
 }
+
+static inline struct qla_qpair *
+qla_mapq_nvme_select_qpair(struct qla_hw_data *ha, struct qla_qpair *qpair)
+{
+	int cpuid = smp_processor_id();
+
+	if (qpair->cpuid != cpuid &&
+	    ha->qp_cpu_map[cpuid]) {
+		qpair = ha->qp_cpu_map[cpuid];
+	}
+	return qpair;
+}
+
+static inline void
+qla_mapq_init_qp_cpu_map(struct qla_hw_data *ha,
+			 struct qla_msix_entry *msix,
+			 struct qla_qpair *qpair)
+{
+	const struct cpumask *mask;
+	unsigned int cpu;
+
+	if (!ha->qp_cpu_map)
+		return;
+	mask = pci_irq_get_affinity(ha->pdev, msix->vector_base0);
+	qpair->cpuid = cpumask_first(mask);
+	for_each_cpu(cpu, mask) {
+		ha->qp_cpu_map[cpu] = qpair;
+	}
+	msix->cpuid = qpair->cpuid;
+}
+
+static inline void
+qla_mapq_free_qp_cpu_map(struct qla_hw_data *ha)
+{
+	if (ha->qp_cpu_map) {
+		kfree(ha->qp_cpu_map);
+		ha->qp_cpu_map = NULL;
+	}
+}
+
+static inline int qla_mapq_alloc_qp_cpu_map(struct qla_hw_data *ha)
+{
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+
+	if (!ha->qp_cpu_map) {
+		ha->qp_cpu_map = kcalloc(NR_CPUS, sizeof(struct qla_qpair *),
+					 GFP_KERNEL);
+		if (!ha->qp_cpu_map) {
+			ql_log(ql_log_fatal, vha, 0x0180,
+			       "Unable to allocate memory for qp_cpu_map ptrs.\n");
+			return -1;
+		}
+	}
+	return 0;
+}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index cbbd7014da93..46e8b38603f0 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3769,7 +3769,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 
 	if (rsp->qpair->cpuid != smp_processor_id() || !rsp->qpair->rcv_intr) {
 		rsp->qpair->rcv_intr = 1;
-		qla_cpu_update(rsp->qpair, smp_processor_id());
 	}
 
 #define __update_rsp_in(_is_shadow_hba, _rsp, _rsp_in)			\
@@ -4377,6 +4376,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	for (i = 0; i < ha->msix_count; i++) {
 		qentry = &ha->msix_entries[i];
 		qentry->vector = pci_irq_vector(ha->pdev, i);
+		qentry->vector_base0 = i;
 		qentry->entry = i;
 		qentry->have_irq = 0;
 		qentry->in_use = 0;
@@ -4604,5 +4604,6 @@ int qla25xx_request_irq(struct qla_hw_data *ha, struct qla_qpair *qpair,
 	}
 	msix->have_irq = 1;
 	msix->handle = qpair;
+	qla_mapq_init_qp_cpu_map(ha, msix, qpair);
 	return ret;
 }
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index c57e02a35521..648e8f798606 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -609,6 +609,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	fc_port_t *fcport;
 	struct srb_iocb *nvme;
 	struct scsi_qla_host *vha;
+	struct qla_hw_data *ha;
 	int rval;
 	srb_t *sp;
 	struct qla_qpair *qpair = hw_queue_handle;
@@ -629,6 +630,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 		return -ENODEV;
 
 	vha = fcport->vha;
+	ha = vha->hw;
 
 	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
 		return -EBUSY;
@@ -643,6 +645,8 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	if (fcport->nvme_flag & NVME_FLAG_RESETTING)
 		return -EBUSY;
 
+	qpair = qla_mapq_nvme_select_qpair(ha, qpair);
+
 	/* Alloc SRB structure */
 	sp = qla2xxx_get_qpair_sp(vha, qpair, fcport, GFP_ATOMIC);
 	if (!sp)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d07a914559d3..545167627e48 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -472,6 +472,11 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 			    "Unable to allocate memory for queue pair ptrs.\n");
 			goto fail_qpair_map;
 		}
+		if (qla_mapq_alloc_qp_cpu_map(ha) != 0) {
+			kfree(ha->queue_pair_map);
+			ha->queue_pair_map = NULL;
+			goto fail_qpair_map;
+		}
 	}
 
 	/*
@@ -546,6 +551,7 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 		ha->base_qpair = NULL;
 	}
 
+	qla_mapq_free_qp_cpu_map(ha);
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 0; cnt < ha->max_req_queues; cnt++) {
 		if (!test_bit(cnt, ha->req_qid_map))
-- 
2.19.0.rc0

