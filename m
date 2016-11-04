From: <himanshu.madhani@cavium.com>
Subject: [PATCH 4/4] qla2xxx: Fix Target stack handling with Multi-queue changes
Date: Fri, 4 Nov 2016 09:33:33 -0700
Message-ID: <1478277213-3848-5-git-send-email-himanshu.madhani@cavium.com>
References: <1478277213-3848-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0041.outbound.protection.outlook.com ([104.47.38.41]:65334
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935119AbcKDTHB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Nov 2016 15:07:01 -0400
In-Reply-To: <1478277213-3848-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

From: Quinn Tran <quinn.tran@cavium.com>

- Fix race condition betweeen dpc_thread accessing MQ resources
  and qla2x00_remove_one thread trying to free resource.
- Fix MQ resources out of order free.  MQ interrupts needs a workqueue.
  Interrupt needed to stop before the wq can be destroy.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  3 ++-
 drivers/scsi/qla2xxx/qla_isr.c | 20 +++++++----------
 drivers/scsi/qla2xxx/qla_mq.c  |  2 +-
 drivers/scsi/qla2xxx/qla_os.c  | 51 +++++++++++++++++++++++++++++++-----------
 4 files changed, 49 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 573b95d..1621059 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2734,7 +2734,8 @@ struct isp_operations {
 
 #define QLA_MSIX_DEFAULT		0x00
 #define QLA_MSIX_RSP_Q			0x01
-#define QLA_MSIX_QPAIR_MULTIQ_RSP_Q	0x02
+#define QLA_ATIO_VECTOR		0x02
+#define QLA_MSIX_QPAIR_MULTIQ_RSP_Q	0x03
 
 #define QLA_MIDX_DEFAULT	0
 #define QLA_MIDX_RSP_Q		1
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a185b5f9..3fe9501 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2968,6 +2968,7 @@ struct qla_init_msix_entry {
 static struct qla_init_msix_entry msix_entries[] = {
 	{ "qla2xxx (default)", qla24xx_msix_default },
 	{ "qla2xxx (rsp_q)", qla24xx_msix_rsp_q },
+	{ "qla2xxx (atio_q)", qla83xx_msix_atio_q },
 	{ "qla2xxx (qpair_multiq)", qla2xxx_msix_rsp_q },
 };
 
@@ -2976,12 +2977,6 @@ struct qla_init_msix_entry {
 	{ "qla2xxx (rsp_q)", qla82xx_msix_rsp_q },
 };
 
-static struct qla_init_msix_entry qla83xx_msix_entries[] = {
-	{ "qla2xxx (default)", qla24xx_msix_default },
-	{ "qla2xxx (rsp_q)", qla24xx_msix_rsp_q },
-	{ "qla2xxx (atio_q)", qla83xx_msix_atio_q },
-};
-
 static void
 qla24xx_disable_msix(struct qla_hw_data *ha)
 {
@@ -3009,7 +3004,6 @@ struct qla_init_msix_entry {
 qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
 #define MIN_MSIX_COUNT	2
-#define ATIO_VECTOR	2
 	int i, ret;
 	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
@@ -3065,7 +3059,7 @@ struct qla_init_msix_entry {
 	}
 
 	/* Enable MSI-X vectors for the base queue */
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < (QLA_MSIX_RSP_Q + 1); i++) {
 		qentry = &ha->msix_entries[i];
 		qentry->handle = rsp;
 		rsp->msix = qentry;
@@ -3082,6 +3076,7 @@ struct qla_init_msix_entry {
 		if (ret)
 			goto msix_register_fail;
 		qentry->have_irq = 1;
+		qentry->in_use = 1;
 
 		/* Register for CPU affinity notification. */
 		irq_set_affinity_notifier(qentry->vector, &qentry->irq_notify);
@@ -3101,14 +3096,15 @@ struct qla_init_msix_entry {
 	 * queue.
 	 */
 	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
-		qentry = &ha->msix_entries[ATIO_VECTOR];
+		qentry = &ha->msix_entries[QLA_ATIO_VECTOR];
 		rsp->msix = qentry;
 		qentry->handle = rsp;
 		scnprintf(qentry->name, sizeof(qentry->name),
-		    qla83xx_msix_entries[ATIO_VECTOR].name);
+		    msix_entries[QLA_ATIO_VECTOR].name);
+		qentry->in_use = 1;
 		ret = request_irq(qentry->vector,
-			qla83xx_msix_entries[ATIO_VECTOR].handler,
-			0, qla83xx_msix_entries[ATIO_VECTOR].name, rsp);
+			msix_entries[QLA_ATIO_VECTOR].handler,
+			0, msix_entries[QLA_ATIO_VECTOR].name, rsp);
 		qentry->have_irq = 1;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_mq.c b/drivers/scsi/qla2xxx/qla_mq.c
index 8eb8ae1..3799853 100644
--- a/drivers/scsi/qla2xxx/qla_mq.c
+++ b/drivers/scsi/qla2xxx/qla_mq.c
@@ -131,7 +131,7 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, cpumask_var_t
 		qpair->vp_idx = vp_idx;
 
 		for (i = 0; i < ha->msix_count; i++) {
-			msix = &ha->msix_entries[i + 2];
+			msix = &ha->msix_entries[i];
 			if (msix->in_use)
 				continue;
 			qpair->msix = msix;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1cb0a59..fa9e99a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -434,24 +434,41 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	struct req_que *req;
 	struct rsp_que *rsp;
 	int cnt;
+	unsigned long flags;
 
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 0; cnt < ha->max_req_queues; cnt++) {
 		if (!test_bit(cnt, ha->req_qid_map))
 			continue;
 
 		req = ha->req_q_map[cnt];
+		clear_bit(cnt, ha->req_qid_map);
+		ha->req_q_map[cnt] = NULL;
+
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		qla2x00_free_req_que(ha, req);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	kfree(ha->req_q_map);
 	ha->req_q_map = NULL;
 
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 0; cnt < ha->max_rsp_queues; cnt++) {
 		if (!test_bit(cnt, ha->rsp_qid_map))
 			continue;
 
 		rsp = ha->rsp_q_map[cnt];
+		clear_bit(cnt, ha->req_qid_map);
+		ha->rsp_q_map[cnt] =  NULL;
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		qla2x00_free_rsp_que(ha, rsp);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	kfree(ha->rsp_q_map);
 	ha->rsp_q_map = NULL;
 }
@@ -1715,19 +1732,24 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		pci_read_config_word(ha->pdev,
 		    QLA_83XX_PCI_MSIX_CONTROL, &msix);
 		ha->msix_count = msix + 1;
-		/* Max queues are bounded by available msix vectors */
-		/* queue 0 uses two msix vectors */
+		/*
+		 * By default, driver uses at least two msix vectors
+		 * (default & rspq)
+		 */
 		if (ql2xmqsupport) {
 			cpus = num_online_cpus();
 			/* MB interrupt uses 1 vector */
 			ha->max_req_queues = (ha->msix_count - 1 > cpus) ?
 				(cpus + 1) : (ha->msix_count - 1);
 			ha->max_rsp_queues = ha->max_req_queues;
+
+			/* ATIOQ needs 1 vector. That's 1 less QPair */
+			if (QLA_TGT_MODE_ENABLED())
+				ha->max_req_queues--;
+
 			/* Queue pairs is the max value minus
 			 * the base queue pair */
 			ha->max_qpairs = ha->max_req_queues - 1;
-			ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc010,
-			    "Max no of queues pairs:%d.\n", ha->max_qpairs);
 			ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0190,
 			    "Max no of queues pairs:%d.\n", ha->max_qpairs);
 		}
@@ -1739,6 +1761,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 
 mqiobase_exit:
 	ha->msix_count = ha->max_rsp_queues + 1;
+	if (QLA_TGT_MODE_ENABLED())
+		ha->msix_count++;
 
 	qlt_83xx_iospace_config(ha);
 
@@ -3116,13 +3140,6 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 static void
 qla2x00_destroy_deferred_work(struct qla_hw_data *ha)
 {
-	/* Flush the work queue and remove it */
-	if (ha->wq) {
-		flush_workqueue(ha->wq);
-		destroy_workqueue(ha->wq);
-		ha->wq = NULL;
-	}
-
 	/* Cancel all work and destroy DPC workqueues */
 	if (ha->dpc_lp_wq) {
 		cancel_work_sync(&ha->idc_aen);
@@ -3318,9 +3335,17 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 		ha->isp_ops->disable_intrs(ha);
 	}
 
+	qla2x00_free_fcports(vha);
+
 	qla2x00_free_irqs(vha);
 
-	qla2x00_free_fcports(vha);
+	/* Flush the work queue and remove it */
+	if (ha->wq) {
+		flush_workqueue(ha->wq);
+		destroy_workqueue(ha->wq);
+		ha->wq = NULL;
+	}
+
 
 	qla2x00_mem_free(ha);
 
@@ -5042,8 +5067,8 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 
 	base_vha->flags.init_done = 0;
 	qla25xx_delete_queues(base_vha);
-	qla2x00_free_irqs(base_vha);
 	qla2x00_free_fcports(base_vha);
+	qla2x00_free_irqs(base_vha);
 	qla2x00_mem_free(ha);
 	qla82xx_md_free(base_vha);
 	qla2x00_free_queues(ha);
-- 
1.8.3.1

