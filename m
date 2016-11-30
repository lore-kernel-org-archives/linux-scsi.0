From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 4/5] qla2xxx: Add Block Multi Queue functionality.
Date: Wed, 30 Nov 2016 12:24:56 -0800
Message-ID: <1480537497-16429-5-git-send-email-himanshu.madhani@cavium.com>
References: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:50533
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757162AbcK3Ulj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Nov 2016 15:41:39 -0500
In-Reply-To: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Sawan Chandak <sawan.chandak@cavium.com>

Tell the SCSI layer how many hardware queues we have based on the number
of max queue pairs created. The number of max queue pairs created will
depend on number of MSI X vector count or number of CPU's in a system.

This feature can be turned on via CONFIG_SCSI_MQ_DEFAULT or passing
scsi_mod.use_blk_mq=Y as a parameter to the kernel

Queue pair creation depend on module parameter "ql2xmqsupport", which
need to be enabled to create queue pair.

Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 39 +++++++++++++--------------------------
 drivers/scsi/qla2xxx/qla_os.c  | 41 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 49 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 0c4910b..d0802af 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3005,7 +3005,7 @@ struct qla_init_msix_entry {
 			free_irq(qentry->vector, qentry->handle);
 		}
 	}
-	pci_disable_msix(ha->pdev);
+	pci_free_irq_vectors(ha->pdev);
 	kfree(ha->msix_entries);
 	ha->msix_entries = NULL;
 	ha->flags.msix_enabled = 0;
@@ -3019,24 +3019,12 @@ struct qla_init_msix_entry {
 #define MIN_MSIX_COUNT	2
 #define ATIO_VECTOR	2
 	int i, ret;
-	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	int cpus;
 
-	entries = kzalloc(sizeof(struct msix_entry) * ha->msix_count,
-			GFP_KERNEL);
-	if (!entries) {
-		ql_log(ql_log_warn, vha, 0x00bc,
-		    "Failed to allocate memory for msix_entry.\n");
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < ha->msix_count; i++)
-		entries[i].entry = i;
-
-	ret = pci_enable_msix_range(ha->pdev,
-				    entries, MIN_MSIX_COUNT, ha->msix_count);
+	ret = pci_alloc_irq_vectors(ha->pdev,
+		MIN_MSIX_COUNT, ha->msix_count, PCI_IRQ_MSIX);
 	if (ret < 0) {
 		ql_log(ql_log_fatal, vha, 0x00c7,
 		    "MSI-X: Failed to enable support, "
@@ -3050,16 +3038,17 @@ struct qla_init_msix_entry {
 		    ha->msix_count, ret);
 		ha->msix_count = ret;
 		/* Recalculate queue values */
-		if (ql2xmqsupport) {
+		if (ha->mqiobase && ql2xmqsupport) {
 			cpus = num_online_cpus();
 			ha->max_req_queues = (ha->msix_count - 1 > cpus) ?
 				(cpus + 1) : (ha->msix_count - 1);
-			ha->max_rsp_queues = ha->max_req_queues;
 
 			/* ATIOQ needs 1 vector. That's 1 less QPair */
 			if (QLA_TGT_MODE_ENABLED())
 				ha->max_req_queues--;
 
+			ha->max_rsp_queues = ha->max_req_queues;
+
 			ha->max_qpairs = ha->max_req_queues - 1;
 			ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0190,
 			    "Adjusted Max no of queues pairs: %d.\n", ha->max_qpairs);
@@ -3077,8 +3066,8 @@ struct qla_init_msix_entry {
 
 	for (i = 0; i < ha->msix_count; i++) {
 		qentry = &ha->msix_entries[i];
-		qentry->vector = entries[i].vector;
-		qentry->entry = entries[i].entry;
+		qentry->vector = pci_irq_vector(ha->pdev, i);
+		qentry->entry = i;
 		qentry->have_irq = 0;
 		qentry->in_use = 0;
 		qentry->handle = NULL;
@@ -3164,7 +3153,6 @@ struct qla_init_msix_entry {
 	    ha->mqiobase, ha->max_rsp_queues, ha->max_req_queues);
 
 msix_out:
-	kfree(entries);
 	return ret;
 }
 
@@ -3217,7 +3205,7 @@ struct qla_init_msix_entry {
 	    !IS_QLA27XX(ha))
 		goto skip_msi;
 
-	ret = pci_enable_msi(ha->pdev);
+	ret = pci_alloc_irq_vectors(ha->pdev, 1, 1, PCI_IRQ_MSI);
 	if (!ret) {
 		ql_dbg(ql_dbg_init, vha, 0x0038,
 		    "MSI: Enabled.\n");
@@ -3273,11 +3261,10 @@ struct qla_init_msix_entry {
 
 	if (ha->flags.msix_enabled)
 		qla24xx_disable_msix(ha);
-	else if (ha->flags.msi_enabled) {
-		free_irq(ha->pdev->irq, rsp);
-		pci_disable_msi(ha->pdev);
-	} else
-		free_irq(ha->pdev->irq, rsp);
+	else {
+		free_irq(pci_irq_vector(ha->pdev, 0), rsp);
+		pci_free_irq_vectors(ha->pdev);
+	}
 }
 
 int qla25xx_request_irq(struct qla_hw_data *ha, struct qla_qpair *qpair,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fc578d3..d0cd360 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -354,7 +354,7 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 		goto fail_rsp_map;
 	}
 
-	if (ql2xmqsupport) {
+	if (ql2xmqsupport && ha->max_qpairs) {
 		ha->queue_pair_map = kzalloc(sizeof(struct qla_qpair *)
 			* ha->max_qpairs, GFP_KERNEL);
 		if (!ha->queue_pair_map) {
@@ -667,16 +667,26 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	srb_t *sp;
 	int rval;
-	struct qla_qpair *qpair;
+	struct qla_qpair *qpair = NULL;
+	uint32_t tag;
+	uint16_t hwq;
 
 	if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags))) {
 		cmd->result = DID_NO_CONNECT << 16;
 		goto qc24_fail_command;
 	}
 
-	if (vha->vp_idx && vha->qpair) {
-		qpair = vha->qpair;
-		return qla2xxx_mqueuecommand(host, cmd, qpair);
+	if (ha->mqenable) {
+		if (shost_use_blk_mq(vha->host)) {
+			tag = blk_mq_unique_tag(cmd->request);
+			hwq = blk_mq_unique_tag_to_hwq(tag);
+			qpair = ha->queue_pair_map[hwq];
+		} else if (vha->vp_idx && vha->qpair) {
+			qpair = vha->qpair;
+		}
+
+		if (qpair)
+			return qla2xxx_mqueuecommand(host, cmd, qpair);
 	}
 
 	if (ha->flags.eeh_busy) {
@@ -2368,6 +2378,8 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 	uint16_t req_length = 0, rsp_length = 0;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
+	int cpu_id;
+	cpumask_t cpu_mask;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
 	sht = &qla2xxx_driver_template;
@@ -2733,6 +2745,16 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 		goto probe_init_failed;
 	}
 
+	if (ha->mqenable && shost_use_blk_mq(host)) {
+		/* number of hardware queues supported by blk/scsi-mq*/
+		host->nr_hw_queues = ha->max_qpairs;
+
+		ql_dbg(ql_dbg_init, base_vha, 0x0192,
+			"blk/scsi-mq enabled,HW Queue = %d.\n", host->nr_hw_queues);
+	} else
+		ql_dbg(ql_dbg_init, base_vha, 0x0193,
+			"blk/scsi-mq disabled.\n");
+
 	qlt_probe_one_stage1(base_vha, ha);
 
 	pci_save_state(pdev);
@@ -2836,6 +2858,15 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 	if (ha->mqenable) {
 		base_vha->qps_hint = alloc_percpu(struct qla_percpu_qp_hint);
 		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
+		/* Create start of day qpairs for Block MQ */
+		if (shost_use_blk_mq(host)) {
+			cpumask_clear(&cpu_mask);
+			for (cpu_id = 0; cpu_id < ha->max_qpairs; cpu_id++) {
+				cpumask_set_cpu(cpu_id, &cpu_mask);
+				qla2xxx_create_qpair(base_vha, &cpu_mask, 5, 0);
+				cpumask_clear_cpu(cpu_id, &cpu_mask);
+			}
+		}
 	}
 
 	if (ha->flags.running_gold_fw)
-- 
1.8.3.1

