From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] qla2xxx: remove irq_affinity_notifier
Date: Wed, 11 Jan 2017 17:55:46 +0100
Message-ID: <1484153746-19406-3-git-send-email-hch@lst.de>
References: <1484153746-19406-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35116 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755866AbdAKQz5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 11:55:57 -0500
In-Reply-To: <1484153746-19406-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: himanshu.madhani@cavium.com
Cc: linux-scsi@vger.kernel.org

Now that qla2xxx uses the IRQ layer affinity assignment affinity
won't change over the life time of a device and the notifiers are
useless.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla2xxx/qla_def.h |  1 -
 drivers/scsi/qla2xxx/qla_isr.c | 73 ------------------------------------------
 2 files changed, 74 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e5e0301..8c2e60a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2754,7 +2754,6 @@ struct qla_msix_entry {
 	uint16_t entry;
 	char name[30];
 	void *handle;
-	struct irq_affinity_notify irq_notify;
 	int cpuid;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5f389a3..ca0b7dc 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -19,10 +19,6 @@ static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, void *);
 static void qla2x00_status_cont_entry(struct rsp_que *, sts_cont_entry_t *);
 static void qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
 	sts_entry_t *);
-static void qla_irq_affinity_notify(struct irq_affinity_notify *,
-    const cpumask_t *);
-static void qla_irq_affinity_release(struct kref *);
-
 
 /**
  * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
@@ -2572,14 +2568,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	if (!vha->flags.online)
 		return;
 
-	if (rsp->msix && rsp->msix->cpuid != smp_processor_id()) {
-		/* if kernel does not notify qla of IRQ's CPU change,
-		 * then set it here.
-		 */
-		rsp->msix->cpuid = smp_processor_id();
-		ha->tgt.rspq_vector_cpuid = rsp->msix->cpuid;
-	}
-
 	while (rsp->ring_ptr->signature != RESPONSE_PROCESSED) {
 		pkt = (struct sts_entry_24xx *)rsp->ring_ptr;
 
@@ -3076,9 +3064,6 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		qentry->have_irq = 0;
 		qentry->in_use = 0;
 		qentry->handle = NULL;
-		qentry->irq_notify.notify  = qla_irq_affinity_notify;
-		qentry->irq_notify.release = qla_irq_affinity_release;
-		qentry->cpuid = -1;
 	}
 
 	/* Enable MSI-X vectors for the base queue */
@@ -3100,18 +3085,6 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 			goto msix_register_fail;
 		qentry->have_irq = 1;
 		qentry->in_use = 1;
-
-		/* Register for CPU affinity notification. */
-		irq_set_affinity_notifier(qentry->vector, &qentry->irq_notify);
-
-		/* Schedule work (ie. trigger a notification) to read cpu
-		 * mask for this specific irq.
-		 * kref_get is required because
-		* irq_affinity_notify() will do
-		* kref_put().
-		*/
-		kref_get(&qentry->irq_notify.kref);
-		schedule_work(&qentry->irq_notify.work);
 	}
 
 	/*
@@ -3308,49 +3281,3 @@ int qla25xx_request_irq(struct qla_hw_data *ha, struct qla_qpair *qpair,
 	msix->handle = qpair;
 	return ret;
 }
-
-
-/* irq_set_affinity/irqbalance will trigger notification of cpu mask update */
-static void qla_irq_affinity_notify(struct irq_affinity_notify *notify,
-	const cpumask_t *mask)
-{
-	struct qla_msix_entry *e =
-		container_of(notify, struct qla_msix_entry, irq_notify);
-	struct qla_hw_data *ha;
-	struct scsi_qla_host *base_vha;
-	struct rsp_que *rsp = e->handle;
-
-	/* user is recommended to set mask to just 1 cpu */
-	e->cpuid = cpumask_first(mask);
-
-	ha = rsp->hw;
-	base_vha = pci_get_drvdata(ha->pdev);
-
-	ql_dbg(ql_dbg_init, base_vha, 0xffff,
-	    "%s: host %ld : vector %d cpu %d \n", __func__,
-	    base_vha->host_no, e->vector, e->cpuid);
-
-	if (e->have_irq) {
-		if ((IS_QLA83XX(ha) || IS_QLA27XX(ha)) &&
-		    (e->entry == QLA83XX_RSPQ_MSIX_ENTRY_NUMBER)) {
-			ha->tgt.rspq_vector_cpuid = e->cpuid;
-			ql_dbg(ql_dbg_init, base_vha, 0xffff,
-			    "%s: host%ld: rspq vector %d cpu %d  runtime change\n",
-			    __func__, base_vha->host_no, e->vector, e->cpuid);
-		}
-	}
-}
-
-static void qla_irq_affinity_release(struct kref *ref)
-{
-	struct irq_affinity_notify *notify =
-		container_of(ref, struct irq_affinity_notify, kref);
-	struct qla_msix_entry *e =
-		container_of(notify, struct qla_msix_entry, irq_notify);
-	struct rsp_que *rsp = e->handle;
-	struct scsi_qla_host *base_vha = pci_get_drvdata(rsp->hw->pdev);
-
-	ql_dbg(ql_dbg_init, base_vha, 0xffff,
-		"%s: host%ld: vector %d cpu %d\n", __func__,
-	    base_vha->host_no, e->vector, e->cpuid);
-}
-- 
2.1.4

