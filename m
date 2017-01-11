From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] qla2xxx: fix MSI-X vector affinity
Date: Wed, 11 Jan 2017 17:55:45 +0100
Message-ID: <1484153746-19406-2-git-send-email-hch@lst.de>
References: <1484153746-19406-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35112 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755866AbdAKQzx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 11:55:53 -0500
In-Reply-To: <1484153746-19406-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: himanshu.madhani@cavium.com
Cc: linux-scsi@vger.kernel.org

The first two or three vectors in qla2xxx adapter are global and
not associated with a specific queue.  They should not have IRQ
affinity assigned.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qla2xxx/qla_def.h |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c | 15 +++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ef699b6..e5e0301 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2732,7 +2732,7 @@ struct isp_operations {
 #define QLA_MSIX_FW_MODE(m)	(((m) & (BIT_7|BIT_8|BIT_9)) >> 7)
 #define QLA_MSIX_FW_MODE_1(m)	(QLA_MSIX_FW_MODE(m) == 1)
 
-#define QLA_MSIX_DEFAULT		0x00
+#define QLA_BASE_VECTORS	2 /* default + RSP */
 #define QLA_MSIX_RSP_Q			0x01
 #define QLA_ATIO_VECTOR		0x02
 #define QLA_MSIX_QPAIR_MULTIQ_RSP_Q	0x03
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b9c113e..5f389a3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3018,13 +3018,20 @@ static const struct qla_init_msix_entry qla82xx_msix_entries[] = {
 static int
 qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
-#define MIN_MSIX_COUNT	2
 	int i, ret;
 	struct qla_msix_entry *qentry;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+	struct irq_affinity desc = {
+		.pre_vectors = QLA_BASE_VECTORS,
+	};
+
+	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha))
+		desc.pre_vectors++;
+
+	ret = pci_alloc_irq_vectors_affinity(ha->pdev, QLA_BASE_VECTORS,
+			ha->msix_count, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
+			&desc);
 
-	ret = pci_alloc_irq_vectors(ha->pdev, MIN_MSIX_COUNT, ha->msix_count,
-				    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
 	if (ret < 0) {
 		ql_log(ql_log_fatal, vha, 0x00c7,
 		    "MSI-X: Failed to enable support, "
@@ -3075,7 +3082,7 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	}
 
 	/* Enable MSI-X vectors for the base queue */
-	for (i = 0; i < (QLA_MSIX_RSP_Q + 1); i++) {
+	for (i = 0; i < QLA_BASE_VECTORS; i++) {
 		qentry = &ha->msix_entries[i];
 		qentry->handle = rsp;
 		rsp->msix = qentry;
-- 
2.1.4

