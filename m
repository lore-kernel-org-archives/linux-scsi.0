From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 01/24] qla4xxx: ISP8xxx: Correct retry of adapter initialization
Date: Mon, 16 Dec 2013 06:49:31 -0500
Message-ID: <1387194594-29817-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:3657 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302Ab3LPMX0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:26 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Issue:
For ISP8xxx, adapter initialization is not retried if qla4xxx_initialize_adapter
fails.

Fix:
If qla4xxx_initialize_adapter fails, first check if failure is due to IRQs not
attached in order to skip retrial, then free the IRQs and then retry initializing
the adapter.

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_glbl.h |  1 +
 drivers/scsi/qla4xxx/ql4_init.c |  7 +------
 drivers/scsi/qla4xxx/ql4_nx.c   | 21 +++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_os.c   | 27 ++++++++++++++++++++++-----
 4 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index d67c50e..6d72e1d 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -279,6 +279,7 @@ int qla4_83xx_ms_mem_write_128b(struct scsi_qla_host *ha,
 uint8_t qla4xxx_set_ipaddr_state(uint8_t fw_ipaddr_state);
 int qla4_83xx_get_port_config(struct scsi_qla_host *ha, uint32_t *config);
 int qla4_83xx_set_port_config(struct scsi_qla_host *ha, uint32_t *config);
+int qla4_8xxx_check_init_adapter_retry(struct scsi_qla_host *ha);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 7456eeb..28fbece 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -959,13 +959,8 @@ int qla4xxx_initialize_adapter(struct scsi_qla_host *ha, int is_reset)
 		qla4xxx_build_ddb_list(ha, is_reset);
 
 	set_bit(AF_ONLINE, &ha->flags);
-exit_init_hba:
-	if (is_qla80XX(ha) && (status == QLA_ERROR)) {
-		/* Since interrupts are registered in start_firmware for
-		 * 80XX, release them here if initialize_adapter fails */
-		qla4xxx_free_irqs(ha);
-	}
 
+exit_init_hba:
 	DEBUG2(printk("scsi%ld: initialize adapter: %s\n", ha->host_no,
 	    status == QLA_ERROR ? "FAILED" : "SUCCEEDED"));
 	return status;
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index d001202..bbe8361 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3836,3 +3836,24 @@ qla4_8xxx_enable_msix(struct scsi_qla_host *ha)
 msix_out:
 	return ret;
 }
+
+int qla4_8xxx_check_init_adapter_retry(struct scsi_qla_host *ha)
+{
+	int status = QLA_SUCCESS;
+
+	/* Dont retry adapter initialization if IRQ allocation failed */
+	if (!test_bit(AF_IRQ_ATTACHED, &ha->flags)) {
+		ql4_printk(KERN_WARNING, ha, "%s: Skipping retry of adapter initialization as IRQs are not attached\n",
+			   __func__);
+		status = QLA_ERROR;
+		goto exit_init_adapter_failure;
+	}
+
+	/* Since interrupts are registered in start_firmware for
+	 * 8xxx, release them here if initialize_adapter fails
+	 * and retry adapter initialization */
+	qla4xxx_free_irqs(ha);
+
+exit_init_adapter_failure:
+	return status;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c21adc3..9803c9e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4881,8 +4881,21 @@ recover_ha_init_adapter:
 			ssleep(6);
 
 		/* NOTE: AF_ONLINE flag set upon successful completion of
-		 *       qla4xxx_initialize_adapter */
+		 * qla4xxx_initialize_adapter */
 		status = qla4xxx_initialize_adapter(ha, RESET_ADAPTER);
+		if (is_qla80XX(ha) && (status == QLA_ERROR)) {
+			status = qla4_8xxx_check_init_adapter_retry(ha);
+			if (status == QLA_ERROR) {
+				ql4_printk(KERN_INFO, ha, "scsi%ld: %s: Don't retry recover adapter\n",
+					   ha->host_no, __func__);
+				qla4xxx_dead_adapter_cleanup(ha);
+				clear_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags);
+				clear_bit(DPC_RESET_HA, &ha->dpc_flags);
+				clear_bit(DPC_RESET_HA_FW_CONTEXT,
+					  &ha->dpc_flags);
+				goto exit_recover;
+			}
+		}
 	}
 
 	/* Retry failed adapter initialization, if necessary
@@ -8681,11 +8694,8 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	status = qla4xxx_initialize_adapter(ha, INIT_ADAPTER);
 
 	/* Dont retry adapter initialization if IRQ allocation failed */
-	if (is_qla80XX(ha) && !test_bit(AF_IRQ_ATTACHED, &ha->flags)) {
-		ql4_printk(KERN_WARNING, ha, "%s: Skipping retry of adapter initialization\n",
-			   __func__);
+	if (is_qla80XX(ha) && (status == QLA_ERROR))
 		goto skip_retry_init;
-	}
 
 	while ((!test_bit(AF_ONLINE, &ha->flags)) &&
 	    init_retry_count++ < MAX_INIT_RETRIES) {
@@ -8709,6 +8719,10 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 			continue;
 
 		status = qla4xxx_initialize_adapter(ha, INIT_ADAPTER);
+		if (is_qla80XX(ha) && (status == QLA_ERROR)) {
+			if (qla4_8xxx_check_init_adapter_retry(ha) == QLA_ERROR)
+				goto skip_retry_init;
+		}
 	}
 
 skip_retry_init:
@@ -9615,6 +9629,7 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 		if (rval != QLA_SUCCESS) {
 			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: HW State: "
 			    "FAILED\n", ha->host_no, __func__);
+			qla4xxx_free_irqs(ha);
 			ha->isp_ops->idc_lock(ha);
 			qla4_8xxx_clear_drv_active(ha);
 			qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DEV_STATE,
@@ -9642,6 +9657,8 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 			rval = qla4xxx_initialize_adapter(ha, RESET_ADAPTER);
 			if (rval == QLA_SUCCESS)
 				ha->isp_ops->enable_intrs(ha);
+			else
+				qla4xxx_free_irqs(ha);
 
 			ha->isp_ops->idc_lock(ha);
 			qla4_8xxx_set_drv_active(ha);
-- 
1.8.2.GIT

