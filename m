From: vikas.chaudhary@qlogic.com
Subject: [PATCH 05/13] qla4xxx: Update idc reg in case of PCI AER
Date: Thu, 20 Sep 2012 07:35:05 -0400
Message-ID: <1348140913-11828-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:62499 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754177Ab2ITLxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 07:53:05 -0400
In-Reply-To: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Camram is reset by FW to default values after reboot/cold boot/pci reset.
In case of AER, PCI may need to reset so we need to set correct idc reg value
after PCIE error.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_glbl.h |    1 +
 drivers/scsi/qla4xxx/ql4_nx.c   |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c   |   15 +++++++++++++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index eea04e0..0580f80 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -256,6 +256,7 @@ void qla4_8xxx_get_minidump(struct scsi_qla_host *ha);
 int qla4_8xxx_mbx_intr_disable(struct scsi_qla_host *ha);
 int qla4_8xxx_mbx_intr_enable(struct scsi_qla_host *ha);
 int qla4_8xxx_set_param(struct scsi_qla_host *ha, int param);
+int qla4_8xxx_update_idc_reg(struct scsi_qla_host *ha);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 9b67aad..66f52d2 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2833,7 +2833,7 @@ exit_set_idc_ver:
 	return rval;
 }
 
-static int qla4_8xxx_update_idc_reg(struct scsi_qla_host *ha)
+int qla4_8xxx_update_idc_reg(struct scsi_qla_host *ha)
 {
 	uint32_t drv_active;
 	int rval = QLA_SUCCESS;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index afaba52..81b3038 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6135,9 +6135,19 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 		ha->isp_ops->idc_lock(ha);
 		qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DEV_STATE,
 				    QLA8XXX_DEV_COLD);
-		qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DRV_IDC_VERSION,
-				    QLA82XX_IDC_VERSION);
 		ha->isp_ops->idc_unlock(ha);
+
+		rval = qla4_8xxx_update_idc_reg(ha);
+		if (rval == QLA_ERROR) {
+			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: HW State: FAILED\n",
+				   ha->host_no, __func__);
+			ha->isp_ops->idc_lock(ha);
+			qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DEV_STATE,
+					    QLA8XXX_DEV_FAILED);
+			ha->isp_ops->idc_unlock(ha);
+			goto exit_error_recovery;
+		}
+
 		clear_bit(AF_FW_RECOVERY, &ha->flags);
 		rval = qla4xxx_initialize_adapter(ha, RESET_ADAPTER);
 
@@ -6195,6 +6205,7 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 			ha->isp_ops->idc_unlock(ha);
 		}
 	}
+exit_error_recovery:
 	clear_bit(DPC_RESET_ACTIVE, &ha->dpc_flags);
 	return rval;
 }
-- 
1.7.1

