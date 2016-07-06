From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] qla2xxx: setup data needed in ISR before setting up the ISR
Date: Wed,  6 Jul 2016 09:51:50 +0200
Message-ID: <1467791510-5307-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

qla2xxx first calls request_irq() and then does the setup of the queue
entry data needed in the interrupt handlers in when using MSI-X. This
could lead to a NULL pointer dereference when an IRQ fires between the
request_irq() call and the assignment of the qentry data structure to the
rsp->msix field. A possible case for such a race would be in the kdump
case when the HBA's IRQs are still enabled but the driver is undergoing
a new initialisation and thus is not aware of already activated IRQs in
the HBA.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/qla2xxx/qla_isr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5649c20..20743a3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3086,6 +3086,8 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	/* Enable MSI-X vectors for the base queue */
 	for (i = 0; i < 2; i++) {
 		qentry = &ha->msix_entries[i];
+		qentry->rsp = rsp;
+		rsp->msix = qentry;
 		if (IS_P3P_TYPE(ha))
 			ret = request_irq(qentry->vector,
 				qla82xx_msix_entries[i].handler,
@@ -3097,8 +3099,6 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		if (ret)
 			goto msix_register_fail;
 		qentry->have_irq = 1;
-		qentry->rsp = rsp;
-		rsp->msix = qentry;
 
 		/* Register for CPU affinity notification. */
 		irq_set_affinity_notifier(qentry->vector, &qentry->irq_notify);
@@ -3119,12 +3119,12 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	 */
 	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
 		qentry = &ha->msix_entries[ATIO_VECTOR];
+		qentry->rsp = rsp;
+		rsp->msix = qentry;
 		ret = request_irq(qentry->vector,
 			qla83xx_msix_entries[ATIO_VECTOR].handler,
 			0, qla83xx_msix_entries[ATIO_VECTOR].name, rsp);
 		qentry->have_irq = 1;
-		qentry->rsp = rsp;
-		rsp->msix = qentry;
 	}
 
 msix_register_fail:
-- 
1.8.5.6
