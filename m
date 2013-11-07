From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH] qla2xxx: Fix warning reported by smatch.
Date: Thu, 7 Nov 2013 02:54:56 -0500
Message-ID: <1383810896-1468-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:3357 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137Ab3KGI1C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 03:27:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c  |    2 +-
 drivers/scsi/qla2xxx/qla_nx2.c |    8 ++++----
 drivers/scsi/qla2xxx/qla_os.c  |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 00427e0..1f42662 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -732,7 +732,7 @@ extern inline void qla8044_set_qsnt_ready(struct scsi_qla_host *vha);
 extern inline void qla8044_need_reset_handler(struct scsi_qla_host *vha);
 extern int qla8044_device_state_handler(struct scsi_qla_host *vha);
 extern void qla8044_clear_qsnt_ready(struct scsi_qla_host *vha);
-extern void qla8044_clear_drv_active(struct scsi_qla_host *vha);
+extern void qla8044_clear_drv_active(struct qla_hw_data *);
 void qla8044_get_minidump(struct scsi_qla_host *vha);
 int qla8044_collect_md_data(struct scsi_qla_host *vha);
 extern int qla8044_md_get_template(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 1468c59..1e6ba4a 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3017,7 +3017,7 @@ qla8xxx_dev_failed_handler(scsi_qla_host_t *vha)
 		qla82xx_clear_drv_active(ha);
 		qla82xx_idc_unlock(ha);
 	} else if (IS_QLA8044(ha)) {
-		qla8044_clear_drv_active(vha);
+		qla8044_clear_drv_active(ha);
 		qla8044_idc_unlock(ha);
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index cc3522f..b45f4d7 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -1257,10 +1257,10 @@ exit_start_fw:
 }
 
 void
-qla8044_clear_drv_active(struct scsi_qla_host *vha)
+qla8044_clear_drv_active(struct qla_hw_data *ha)
 {
 	uint32_t drv_active;
-	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *vha = pci_get_drvdata(ha->pdev);
 
 	drv_active = qla8044_rd_direct(vha, QLA8044_CRB_DRV_ACTIVE_INDEX);
 	drv_active &= ~(1 << (ha->portnum));
@@ -1324,7 +1324,7 @@ qla8044_device_bootstrap(struct scsi_qla_host *vha)
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_info, vha, 0xb0b3,
 		     "%s: HW State: FAILED\n", __func__);
-		qla8044_clear_drv_active(vha);
+		qla8044_clear_drv_active(ha);
 		qla8044_wr_direct(vha, QLA8044_CRB_DEV_STATE_INDEX,
 		    QLA8XXX_DEV_FAILED);
 		return rval;
@@ -1737,7 +1737,7 @@ qla8044_update_idc_reg(struct scsi_qla_host *vha)
 
 	rval = qla8044_set_idc_ver(vha);
 	if (rval == QLA_FUNCTION_FAILED)
-		qla8044_clear_drv_active(vha);
+		qla8044_clear_drv_active(ha);
 	qla8044_idc_unlock(ha);
 
 exit_update_idc_reg:
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8042d97..f9551df 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2885,7 +2885,7 @@ probe_hw_failed:
 	}
 	if (IS_QLA8044(ha)) {
 		qla8044_idc_lock(ha);
-		qla8044_clear_drv_active(base_vha);
+		qla8044_clear_drv_active(ha);
 		qla8044_idc_unlock(ha);
 	}
 iospace_config_failed:
@@ -3049,7 +3049,7 @@ qla2x00_clear_drv_active(scsi_qla_host_t *vha)
 
 	if (IS_QLA8044(ha)) {
 		qla8044_idc_lock(ha);
-		qla8044_clear_drv_active(vha);
+		qla8044_clear_drv_active(ha);
 		qla8044_idc_unlock(ha);
 	} else if (IS_QLA82XX(ha)) {
 		qla82xx_idc_lock(ha);
-- 
1.7.7

