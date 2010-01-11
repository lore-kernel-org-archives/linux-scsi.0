From: giridhar.malavali@qlogic.com
Subject: [PATCH 4/6] qla2xxx: Enhance EEH support and enable AER support.
Date: Mon, 11 Jan 2010 11:32:15 -0800
Message-ID: <1263238337-363-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1263238337-363-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:60665 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753932Ab0AKTcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jan 2010 14:32:18 -0500
In-Reply-To: <1263238337-363-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

qla2xxx: EEH added call to pci_restore_state.
qla2xxx: EEH added delay in slot reset routine.
qla2xxx: EEH moved call to pci_save_state(), see (1).
qla2xxx: EEH additional changes for RHEL5.5.
qla2xxx: EEH added function call, removed function call, see (2).

(1) In qla2xxx_probe_one the call to pci_save_state() has been
    moved to after the call to qla2xxx_request_irqs().

(2) Add call to pci_disable_pcie_error_reporting() in remove_one.
    Delete call to pci_cleanup_aer_uncorrect_error_status() in pci_resume.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    5 +++--
 drivers/scsi/qla2xxx/qla_os.c  |   40 ++++++++++++++++++++++++----------------
 2 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ffd0efd..5613456 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2252,10 +2252,11 @@ qla2x00_free_irqs(scsi_qla_host_t *vha)
 
 	if (ha->flags.msix_enabled)
 		qla24xx_disable_msix(ha);
-	else if (ha->flags.inta_enabled) {
+	else if (ha->flags.msi_enabled) {
 		free_irq(ha->pdev->irq, rsp);
 		pci_disable_msi(ha->pdev);
-	}
+	} else
+		free_irq(ha->pdev->irq, rsp);
 }
 
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8529eb1..fe34b7f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1818,7 +1818,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Set EEH reset type to fundamental if required by hba */
 	if ( IS_QLA24XX(ha) || IS_QLA25XX(ha) || IS_QLA81XX(ha)) {
 		pdev->needs_freset = 1;
-		pci_save_state(pdev);
 	}
 
 	/* Configure PCI I/O space */
@@ -1975,6 +1974,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
 		goto probe_init_failed;
+
+	pci_save_state(pdev);
+
 	/* Alloc arrays of request and response ring ptrs */
 que_init:
 	if (!qla2x00_alloc_queues(ha)) {
@@ -2176,6 +2178,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	kfree(ha);
 	ha = NULL;
 
+	pci_disable_pcie_error_reporting(pdev);
+
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 }
@@ -3310,6 +3314,7 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_frozen:
 		ha->flags.eeh_busy = 1;
+		qla2x00_free_irqs(vha);
 		pci_disable_device(pdev);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
@@ -3363,10 +3368,19 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	pci_ers_result_t ret = PCI_ERS_RESULT_DISCONNECT;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
 	struct qla_hw_data *ha = base_vha->hw;
-	int rc;
+	struct rsp_que *rsp;
+	int rc, retries = 10;
 
 	DEBUG17(qla_printk(KERN_WARNING, ha, "slot_reset\n"));
 
+	/* Workaround: qla2xxx driver which access hardware earlier
+	 * needs error state to be pci_channel_io_online.
+	 * Otherwise mailbox command timesout.
+	 */
+	pdev->error_state = pci_channel_io_normal;
+
+	pci_restore_state(pdev);
+
 	if (ha->mem_only)
 		rc = pci_enable_device_mem(pdev);
 	else
@@ -3378,27 +3392,23 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 		return ret;
 	}
 
+	rsp = ha->rsp_q_map[0];
+	if (qla2x00_request_irqs(ha, rsp))
+		return ret;
+
 	if (ha->isp_ops->pci_config(base_vha))
 		return ret;
 
-#ifdef QL_DEBUG_LEVEL_17
-	{
-		uint8_t b;
-		uint32_t i;
+	while (ha->flags.mbox_busy && retries--)
+		msleep(1000);
 
-		printk("slot_reset_1: ");
-		for (i = 0; i < 256; i++) {
-			pci_read_config_byte(ha->pdev, i, &b);
-			printk("%s%02x", (i%16) ? " " : "\n", b);
-		}
-		printk("\n");
-	}
-#endif
 	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 	if (qla2x00_abort_isp(base_vha) == QLA_SUCCESS)
 		ret =  PCI_ERS_RESULT_RECOVERED;
 	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
+	pci_cleanup_aer_uncorrect_error_status(pdev);
+
 	DEBUG17(qla_printk(KERN_WARNING, ha,
 	    "slot_reset-return:ret=%x\n", ret));
 
@@ -3422,8 +3432,6 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 	}
 
 	ha->flags.eeh_busy = 0;
-
-	pci_cleanup_aer_uncorrect_error_status(pdev);
 }
 
 static struct pci_error_handlers qla2xxx_err_handler = {
-- 
1.6.2.rc1.30.gd43c

