From: vikas.chaudhary@qlogic.com
Subject: [PATCH 08/12] qla4xxx: Set IDC version in correct way
Date: Wed, 22 Aug 2012 07:55:06 -0400
Message-ID: <1345636510-23131-9-git-send-email-vikas.chaudhary@qlogic.com>
References: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:28168 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755963Ab2HVML4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 08:11:56 -0400
In-Reply-To: <1345636510-23131-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Issue:
   Device can go to READY state from COLD and skip INITIALIZATION,
   In this case driver will never set IDC version from function
   qla4_8xxx_device_bootstrap().

Fix:
1. Set IDC version at start of function qla4_82xx_need_reset_handler().
2. Set IDC version only if we are 1st driver to load.
3. Added new function qla4_8xxx_update_idc_reg() to set all idc reg at one place.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |   42 ++++++++++++++++++++++++++++++++--------
 1 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 13d8e48..70793bf 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2337,10 +2337,6 @@ dev_initialize:
 	qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DEV_STATE,
 			    QLA8XXX_DEV_INITIALIZING);
 
-	/* Driver that sets device state to initializating sets IDC version */
-	qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DRV_IDC_VERSION,
-			    QLA82XX_IDC_VERSION);
-
 	ha->isp_ops->idc_unlock(ha);
 	if (ql4xenablemd && test_bit(AF_FW_RECOVERY, &ha->flags) &&
 	    !test_and_set_bit(AF_82XX_FW_DUMPED, &ha->flags)) {
@@ -2463,6 +2459,38 @@ qla4_8xxx_need_qsnt_handler(struct scsi_qla_host *ha)
 	ha->isp_ops->idc_unlock(ha);
 }
 
+static void qla4_82xx_set_idc_ver(struct scsi_qla_host *ha)
+{
+	int idc_ver;
+	uint32_t drv_active;
+
+	drv_active = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_ACTIVE);
+	if (drv_active == (1 << (ha->func_num * 4))) {
+		qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DRV_IDC_VERSION,
+				    QLA82XX_IDC_VERSION);
+		ql4_printk(KERN_INFO, ha,
+			   "%s: IDC version updated to %d\n", __func__,
+			   QLA82XX_IDC_VERSION);
+	} else {
+		idc_ver = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_IDC_VERSION);
+		if (QLA82XX_IDC_VERSION != idc_ver) {
+			ql4_printk(KERN_INFO, ha,
+				   "%s: qla4xxx driver IDC version %d is not compatible with IDC version %d of other drivers!\n",
+				   __func__, QLA82XX_IDC_VERSION, idc_ver);
+		}
+	}
+}
+
+static void qla4_8xxx_update_idc_reg(struct scsi_qla_host *ha)
+{
+	if (!test_bit(AF_INIT_DONE, &ha->flags)) {
+		ha->isp_ops->idc_lock(ha);
+		qla4_8xxx_set_drv_active(ha);
+		qla4_82xx_set_idc_ver(ha);
+		ha->isp_ops->idc_unlock(ha);
+	}
+}
+
 /**
  * qla4_8xxx_device_state_handler - Adapter state machine
  * @ha: pointer to host adapter structure.
@@ -2475,11 +2503,7 @@ int qla4_8xxx_device_state_handler(struct scsi_qla_host *ha)
 	int rval = QLA_SUCCESS;
 	unsigned long dev_init_timeout;
 
-	if (!test_bit(AF_INIT_DONE, &ha->flags)) {
-		ha->isp_ops->idc_lock(ha);
-		qla4_8xxx_set_drv_active(ha);
-		ha->isp_ops->idc_unlock(ha);
-	}
+	qla4_8xxx_update_idc_reg(ha);
 
 	dev_state = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DEV_STATE);
 	DEBUG2(ql4_printk(KERN_INFO, ha, "Device state is 0x%x = %s\n",
-- 
1.7.8.GIT

