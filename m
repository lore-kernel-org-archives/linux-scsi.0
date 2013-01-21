From: vikas.chaudhary@qlogic.com
Subject: [PATCH 06/10] qla4xxx: Re-register IRQ handler while retrying initialize of adapter
Date: Sun, 20 Jan 2013 23:51:01 -0500
Message-ID: <1358743865-435-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:12578 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750855Ab3AUFLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jan 2013 00:11:39 -0500
In-Reply-To: <1358743865-435-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Poornima Vonti <poornima.vonti@qlogic.com>

From: Poornima Vonti <poornima.vonti@qlogic.com>

Problem:
If initialization of adapter fails for some reason, then the interrupt handlers
are released. The interrupt handlers are not registered again when initialization
of adapter is retried.

Solution:
Re-register the interrupt handler when adapter initialization is retried.

Signed-off-by: Poornima Vonti <poornima.vonti@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c |   27 ++++-----------------------
 2 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index b3d6dab..71d3d23 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2986,7 +2986,7 @@ int qla4_8xxx_load_risc(struct scsi_qla_host *ha)
 
 	retval = qla4_8xxx_device_state_handler(ha);
 
-	if (retval == QLA_SUCCESS && !test_bit(AF_INIT_DONE, &ha->flags))
+	if (retval == QLA_SUCCESS && !test_bit(AF_IRQ_ATTACHED, &ha->flags))
 		retval = qla4xxx_request_irqs(ha);
 
 	return retval;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 1df1387..2ccbb3b 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6110,7 +6110,6 @@ qla4xxx_pci_mmio_enabled(struct pci_dev *pdev)
 static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 {
 	uint32_t rval = QLA_ERROR;
-	uint32_t ret = 0;
 	int fn;
 	struct pci_dev *other_pdev = NULL;
 
@@ -6196,16 +6195,7 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 			qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DRV_STATE, 0);
 			qla4_8xxx_set_drv_active(ha);
 			ha->isp_ops->idc_unlock(ha);
-			ret = qla4xxx_request_irqs(ha);
-			if (ret) {
-				ql4_printk(KERN_WARNING, ha, "Failed to "
-				    "reserve interrupt %d already in use.\n",
-				    ha->pdev->irq);
-				rval = QLA_ERROR;
-			} else {
-				ha->isp_ops->enable_intrs(ha);
-				rval = QLA_SUCCESS;
-			}
+			ha->isp_ops->enable_intrs(ha);
 		}
 	} else {
 		ql4_printk(KERN_INFO, ha, "scsi%ld: %s: devfn 0x%x is not "
@@ -6215,18 +6205,9 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 		     QLA8XXX_DEV_READY)) {
 			clear_bit(AF_FW_RECOVERY, &ha->flags);
 			rval = qla4xxx_initialize_adapter(ha, RESET_ADAPTER);
-			if (rval == QLA_SUCCESS) {
-				ret = qla4xxx_request_irqs(ha);
-				if (ret) {
-					ql4_printk(KERN_WARNING, ha, "Failed to"
-					    " reserve interrupt %d already in"
-					    " use.\n", ha->pdev->irq);
-					rval = QLA_ERROR;
-				} else {
-					ha->isp_ops->enable_intrs(ha);
-					rval = QLA_SUCCESS;
-				}
-			}
+			if (rval == QLA_SUCCESS)
+				ha->isp_ops->enable_intrs(ha);
+
 			ha->isp_ops->idc_lock(ha);
 			qla4_8xxx_set_drv_active(ha);
 			ha->isp_ops->idc_unlock(ha);
-- 
1.7.8.GIT

