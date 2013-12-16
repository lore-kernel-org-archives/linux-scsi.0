From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 02/24] qla4xxx: Print WARN_ONCE() if iSCSI function presence bit removed
Date: Mon, 16 Dec 2013 06:49:32 -0500
Message-ID: <1387194594-29817-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:50698 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381Ab3LPMYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:24:03 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_83xx.c | 20 ++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_glbl.h |  1 +
 drivers/scsi/qla4xxx/ql4_os.c   |  5 +++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index 8196c2f..43c1688 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -1664,3 +1664,23 @@ void qla4_83xx_disable_pause(struct scsi_qla_host *ha)
 	__qla4_83xx_disable_pause(ha);
 	ha->isp_ops->idc_unlock(ha);
 }
+
+/**
+ * qla4_83xx_is_detached - Check if we are marked invisible.
+ * @ha: Pointer to host adapter structure.
+ **/
+int qla4_83xx_is_detached(struct scsi_qla_host *ha)
+{
+	uint32_t drv_active;
+
+	drv_active = qla4_8xxx_rd_direct(ha, QLA8XXX_CRB_DRV_ACTIVE);
+
+	if (test_bit(AF_INIT_DONE, &ha->flags) &&
+	    !(drv_active & (1 << ha->func_num))) {
+		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: drv_active = 0x%X\n",
+				  __func__, drv_active));
+		return QLA_SUCCESS;
+	}
+
+	return QLA_ERROR;
+}
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 6d72e1d..b1a19cd 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -280,6 +280,7 @@ uint8_t qla4xxx_set_ipaddr_state(uint8_t fw_ipaddr_state);
 int qla4_83xx_get_port_config(struct scsi_qla_host *ha, uint32_t *config);
 int qla4_83xx_set_port_config(struct scsi_qla_host *ha, uint32_t *config);
 int qla4_8xxx_check_init_adapter_retry(struct scsi_qla_host *ha);
+int qla4_83xx_is_detached(struct scsi_qla_host *ha);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdontresethba;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9803c9e..e6fa19c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4372,6 +4372,11 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 	uint32_t dev_state;
 	uint32_t idc_ctrl;
 
+	if (is_qla8032(ha) &&
+	    (qla4_83xx_is_detached(ha) == QLA_SUCCESS))
+		WARN_ONCE(1, "%s: iSCSI function %d marked invisible\n",
+			  __func__, ha->func_num);
+
 	/* don't poll if reset is going on */
 	if (!(test_bit(DPC_RESET_ACTIVE, &ha->dpc_flags) ||
 	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
-- 
1.8.2.GIT

