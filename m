From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 3/6] qla2xxx: Utilize pci_alloc_irq_vectors/pci_free_irq_vectors calls.
Date: Fri, 2 Dec 2016 13:44:54 -0800
Message-ID: <1480715097-13611-4-git-send-email-himanshu.madhani@cavium.com>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0085.outbound.protection.outlook.com ([104.47.36.85]:51184
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751033AbcLCAVq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 19:21:46 -0500
In-Reply-To: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Michael Hernandez <michael.hernandez@cavium.com>

Replaces the old pci_enable_msi[x]* and pci_disable_msi[x] calls.

Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 +
 drivers/scsi/qla2xxx/qla_isr.c | 81 +++++++++++++++---------------------------
 2 files changed, 30 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9a6ddcb..53021b5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2748,6 +2748,7 @@ struct qla_msix_entry {
 	uint32_t vector;
 	uint16_t entry;
 	struct rsp_que *rsp;
+	void *handle;
 	struct irq_affinity_notify irq_notify;
 	int cpuid;
 };
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 19f1848..16e7601 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3025,52 +3025,17 @@ struct qla_init_msix_entry {
 	{ "qla2xxx (atio_q)", qla83xx_msix_atio_q },
 };
 
-static void
-qla24xx_disable_msix(struct qla_hw_data *ha)
-{
-	int i;
-	struct qla_msix_entry *qentry;
-	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
-
-	for (i = 0; i < ha->msix_count; i++) {
-		qentry = &ha->msix_entries[i];
-		if (qentry->have_irq) {
-			/* un-register irq cpu affinity notification */
-			irq_set_affinity_notifier(qentry->vector, NULL);
-			free_irq(qentry->vector, qentry->rsp);
-		}
-	}
-	pci_disable_msix(ha->pdev);
-	kfree(ha->msix_entries);
-	ha->msix_entries = NULL;
-	ha->flags.msix_enabled = 0;
-	ql_dbg(ql_dbg_init, vha, 0x0042,
-	    "Disabled the MSI.\n");
-}
-
 static int
 qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
 #define MIN_MSIX_COUNT	2
 #define ATIO_VECTOR	2
 	int i, ret;
-	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
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
+	    MIN_MSIX_COUNT, ha->msix_count, PCI_IRQ_MSIX|PCI_IRQ_AFFINITY);
 	if (ret < 0) {
 		ql_log(ql_log_fatal, vha, 0x00c7,
 		    "MSI-X: Failed to enable support, "
@@ -3097,10 +3062,10 @@ struct qla_init_msix_entry {
 
 	for (i = 0; i < ha->msix_count; i++) {
 		qentry = &ha->msix_entries[i];
-		qentry->vector = entries[i].vector;
-		qentry->entry = entries[i].entry;
+		qentry->vector = pci_irq_vector(ha->pdev, i);
+		qentry->entry = i;
 		qentry->have_irq = 0;
-		qentry->rsp = NULL;
+		qentry->handle = NULL;
 		qentry->irq_notify.notify  = qla_irq_affinity_notify;
 		qentry->irq_notify.release = qla_irq_affinity_release;
 		qentry->cpuid = -1;
@@ -3109,7 +3074,7 @@ struct qla_init_msix_entry {
 	/* Enable MSI-X vectors for the base queue */
 	for (i = 0; i < 2; i++) {
 		qentry = &ha->msix_entries[i];
-		qentry->rsp = rsp;
+		qentry->handle = rsp;
 		rsp->msix = qentry;
 		if (IS_P3P_TYPE(ha))
 			ret = request_irq(qentry->vector,
@@ -3142,7 +3107,7 @@ struct qla_init_msix_entry {
 	 */
 	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
 		qentry = &ha->msix_entries[ATIO_VECTOR];
-		qentry->rsp = rsp;
+		qentry->handle = rsp;
 		rsp->msix = qentry;
 		ret = request_irq(qentry->vector,
 			qla83xx_msix_entries[ATIO_VECTOR].handler,
@@ -3155,7 +3120,7 @@ struct qla_init_msix_entry {
 		ql_log(ql_log_fatal, vha, 0x00cb,
 		    "MSI-X: unable to register handler -- %x/%d.\n",
 		    qentry->vector, ret);
-		qla24xx_disable_msix(ha);
+		qla2x00_free_irqs(vha);
 		ha->mqenable = 0;
 		goto msix_out;
 	}
@@ -3177,7 +3142,6 @@ struct qla_init_msix_entry {
 	    ha->mqiobase, ha->max_rsp_queues, ha->max_req_queues);
 
 msix_out:
-	kfree(entries);
 	return ret;
 }
 
@@ -3230,7 +3194,7 @@ struct qla_init_msix_entry {
 	    !IS_QLA27XX(ha))
 		goto skip_msi;
 
-	ret = pci_enable_msi(ha->pdev);
+	ret = pci_alloc_irq_vectors(ha->pdev, 1, 1, PCI_IRQ_MSI);
 	if (!ret) {
 		ql_dbg(ql_dbg_init, vha, 0x0038,
 		    "MSI: Enabled.\n");
@@ -3275,6 +3239,8 @@ struct qla_init_msix_entry {
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct rsp_que *rsp;
+	struct qla_msix_entry *qentry;
+	int i;
 
 	/*
 	 * We need to check that ha->rsp_q_map is valid in case we are called
@@ -3284,13 +3250,24 @@ struct qla_init_msix_entry {
 		return;
 	rsp = ha->rsp_q_map[0];
 
-	if (ha->flags.msix_enabled)
-		qla24xx_disable_msix(ha);
-	else if (ha->flags.msi_enabled) {
-		free_irq(ha->pdev->irq, rsp);
-		pci_disable_msi(ha->pdev);
-	} else
-		free_irq(ha->pdev->irq, rsp);
+	if (ha->flags.msix_enabled) {
+		for (i = 0; i < ha->msix_count; i++) {
+			qentry = &ha->msix_entries[i];
+			if (qentry->have_irq) {
+				irq_set_affinity_notifier(qentry->vector, NULL);
+				free_irq(pci_irq_vector(ha->pdev, i), qentry->handle);
+			}
+		}
+		kfree(ha->msix_entries);
+		ha->msix_entries = NULL;
+		ha->flags.msix_enabled = 0;
+		ql_dbg(ql_dbg_init, vha, 0x0042,
+			"Disabled MSI-X.\n");
+	} else {
+		free_irq(pci_irq_vector(ha->pdev, 0), rsp);
+	}
+
+	pci_free_irq_vectors(ha->pdev);
 }
 
 
-- 
1.8.3.1

