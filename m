From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 12/15] qla4xxx: update AER support for ISP82XX
Date: Wed, 6 Oct 2010 22:50:56 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8712940678F@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:39119 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0JGFu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:50:59 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

* Cleanup qla4xxx_pci_mmio_enabled():
  don't want to return PCI_ERS_NEED_RESET if firmware hung.
  IDC will take care of it.
* Request irq after initialize_adapter() in qla82xx_error_recovery().
* Return all active commands from qla4xxx_pci_error_detected().
* Cleanup ql4_def.h

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |   19 +----------------
 drivers/scsi/qla4xxx/ql4_os.c  |   45 ++++++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index f595ab1..0f3bfc3 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
+#include <linux/aer.h>
 
 #include <net/tcp.h>
 #include <scsi/scsi.h>
@@ -36,24 +37,6 @@
 #include "ql4_dbg.h"
 #include "ql4_nx.h"
 
-#if defined(CONFIG_PCIEAER)
-#include <linux/aer.h>
-#else
-/* AER releated */
-static inline int pci_enable_pcie_error_reporting(struct pci_dev *dev)
-{
-	return -EINVAL;
-}
-static inline int pci_disable_pcie_error_reporting(struct pci_dev *dev)
-{
-	return -EINVAL;
-}
-static inline int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
-{
-	return -EINVAL;
-}
-#endif
-
 #ifndef PCI_DEVICE_ID_QLOGIC_ISP4010
 #define PCI_DEVICE_ID_QLOGIC_ISP4010	0x4010
 #endif
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 779745f..4b6cdb6 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2252,6 +2252,8 @@ qla4xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		qla4xxx_mailbox_premature_completion(ha);
 		qla4xxx_free_irqs(ha);
 		pci_disable_device(pdev);
+		/* Return back all IOs */
+		qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		set_bit(AF_EEH_BUSY, &ha->flags);
@@ -2275,17 +2277,13 @@ qla4xxx_pci_mmio_enabled(struct pci_dev *pdev)
 	if (!is_aer_supported(ha))
 		return PCI_ERS_RESULT_NONE;
 
-	if (test_bit(AF_FW_RECOVERY, &ha->flags)) {
-		ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: firmware hang  -- "
-		    "mmio_enabled\n", ha->host_no, __func__);
-		return PCI_ERS_RESULT_NEED_RESET;
-	} else
-		return PCI_ERS_RESULT_RECOVERED;
+	return PCI_ERS_RESULT_RECOVERED;
 }
 
-uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
+static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 {
 	uint32_t rval = QLA_ERROR;
+	uint32_t ret = 0;
 	int fn;
 	struct pci_dev *other_pdev = NULL;
 
@@ -2297,7 +2295,6 @@ uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 		clear_bit(AF_ONLINE, &ha->flags);
 		qla4xxx_mark_all_devices_missing(ha);
 		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
-		qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
 	}
 
 	fn = PCI_FUNC(ha->pdev->devfn);
@@ -2360,7 +2357,16 @@ uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 			/* Clear driver state register */
 			qla4_8xxx_wr_32(ha, QLA82XX_CRB_DRV_STATE, 0);
 			qla4_8xxx_set_drv_active(ha);
-			ha->isp_ops->enable_intrs(ha);
+			ret = qla4xxx_request_irqs(ha);
+			if (ret) {
+				ql4_printk(KERN_WARNING, ha, "Failed to "
+				    "reserve interrupt %d already in use.\n",
+				    ha->pdev->irq);
+				rval = QLA_ERROR;
+			} else {
+				ha->isp_ops->enable_intrs(ha);
+				rval = QLA_SUCCESS;
+			}
 		}
 		qla4_8xxx_idc_unlock(ha);
 	} else {
@@ -2372,8 +2378,18 @@ uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 			clear_bit(AF_FW_RECOVERY, &ha->flags);
 			rval = qla4xxx_initialize_adapter(ha,
 			    PRESERVE_DDB_LIST);
-			if (rval == QLA_SUCCESS)
-				ha->isp_ops->enable_intrs(ha);
+			if (rval == QLA_SUCCESS) {
+				ret = qla4xxx_request_irqs(ha);
+				if (ret) {
+					ql4_printk(KERN_WARNING, ha, "Failed to"
+					    " reserve interrupt %d already in"
+					    " use.\n", ha->pdev->irq);
+					rval = QLA_ERROR;
+				} else {
+					ha->isp_ops->enable_intrs(ha);
+					rval = QLA_SUCCESS;
+				}
+			}
 			qla4_8xxx_idc_lock(ha);
 			qla4_8xxx_set_drv_active(ha);
 			qla4_8xxx_idc_unlock(ha);
@@ -2415,12 +2431,7 @@ qla4xxx_pci_slot_reset(struct pci_dev *pdev)
 		goto exit_slot_reset;
 	}
 
-	ret = qla4xxx_request_irqs(ha);
-	if (ret) {
-		ql4_printk(KERN_WARNING, ha, "Failed to reserve interrupt %d"
-		    " already in use.\n", pdev->irq);
-		goto exit_slot_reset;
-	}
+	ha->isp_ops->disable_intrs(ha);
 
 	if (is_qla8022(ha)) {
 		if (qla4_8xxx_error_recovery(ha) == QLA_SUCCESS) {
-- 
1.6.6

