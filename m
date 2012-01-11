From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/7] qla4xxx: Temperature monitoring for ISP82XX core.
Date: Wed, 11 Jan 2012 02:44:15 -0800
Message-ID: <1326278661-16368-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:6687 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939Ab2AKK7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2012 05:59:21 -0500
In-Reply-To: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Mike Hernandez <michael.hernandez@qlogic.com>

From: Mike Hernandez <michael.hernandez@qlogic.com>

During watchdog, need to monitor temperature of ISP82XX core
and set device state to FAILED when temperature reaches
"Panic" level.

Signed-off-by: Mike Hernandez <michael.hernandez@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |    1 +
 drivers/scsi/qla4xxx/ql4_nx.h  |   19 +++++++++++++++--
 drivers/scsi/qla4xxx/ql4_os.c  |   42 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 22a3ff0..ec48dc3 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -671,6 +671,7 @@ struct scsi_qla_host {
 	uint16_t pri_ddb_idx;
 	uint16_t sec_ddb_idx;
 	int is_reset;
+	uint16_t temperature;
 };
 
 struct ql4_task_data {
diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index 35376a1..cfb2f2e 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -19,12 +19,25 @@
 #define PHAN_PEG_RCV_INITIALIZED	0xff01
 
 /*CRB_RELATED*/
-#define QLA82XX_CRB_BASE	QLA82XX_CAM_RAM(0x200)
-#define QLA82XX_REG(X)		(QLA82XX_CRB_BASE+(X))
-
+#define QLA82XX_CRB_BASE		(QLA82XX_CAM_RAM(0x200))
+#define QLA82XX_REG(X)			(QLA82XX_CRB_BASE+(X))
 #define CRB_CMDPEG_STATE		QLA82XX_REG(0x50)
 #define CRB_RCVPEG_STATE		QLA82XX_REG(0x13c)
 #define CRB_DMA_SHIFT			QLA82XX_REG(0xcc)
+#define CRB_TEMP_STATE			QLA82XX_REG(0x1b4)
+
+#define qla82xx_get_temp_val(x)		((x) >> 16)
+#define qla82xx_get_temp_state(x)	((x) & 0xffff)
+#define qla82xx_encode_temp(val, state)	(((val) << 16) | (state))
+
+/*
+ * Temperature control.
+ */
+enum {
+	QLA82XX_TEMP_NORMAL = 0x1,	/* Normal operating range */
+	QLA82XX_TEMP_WARN,	/* Sound alert, temperature getting high */
+	QLA82XX_TEMP_PANIC	/* Fatal error, hardware has shut down. */
+};
 
 #define QLA82XX_HW_H0_CH_HUB_ADR	0x05
 #define QLA82XX_HW_H1_CH_HUB_ADR	0x0E
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6f9b84d..d816229 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1972,6 +1972,42 @@ mem_alloc_error_exit:
 }
 
 /**
+ * qla4_8xxx_check_temp - Check the ISP82XX temperature.
+ * @ha: adapter block pointer.
+ *
+ * Note: The caller should not hold the idc lock.
+ **/
+static int qla4_8xxx_check_temp(struct scsi_qla_host *ha)
+{
+	uint32_t temp, temp_state, temp_val;
+	int status = QLA_SUCCESS;
+
+	temp = qla4_8xxx_rd_32(ha, CRB_TEMP_STATE);
+
+	temp_state = qla82xx_get_temp_state(temp);
+	temp_val = qla82xx_get_temp_val(temp);
+
+	if (temp_state == QLA82XX_TEMP_PANIC) {
+		ql4_printk(KERN_WARNING, ha, "Device temperature %d degrees C"
+			   " exceeds maximum allowed. Hardware has been shut"
+			   " down.\n", temp_val);
+		status = QLA_ERROR;
+	} else if (temp_state == QLA82XX_TEMP_WARN) {
+		if (ha->temperature == QLA82XX_TEMP_NORMAL)
+			ql4_printk(KERN_WARNING, ha, "Device temperature %d"
+				   " degrees C exceeds operating range."
+				   " Immediate action needed.\n", temp_val);
+	} else {
+		if (ha->temperature == QLA82XX_TEMP_WARN)
+			ql4_printk(KERN_INFO, ha, "Device temperature is"
+				   " now %d degrees C in normal range.\n",
+				   temp_val);
+	}
+	ha->temperature = temp_state;
+	return status;
+}
+
+/**
  * qla4_8xxx_check_fw_alive  - Check firmware health
  * @ha: Pointer to host adapter structure.
  *
@@ -2042,7 +2078,11 @@ void qla4_8xxx_watchdog(struct scsi_qla_host *ha)
 	    test_bit(DPC_RESET_HA, &ha->dpc_flags) ||
 	    test_bit(DPC_RETRY_RESET_HA, &ha->dpc_flags))) {
 		dev_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
-		if (dev_state == QLA82XX_DEV_NEED_RESET &&
+
+		if (qla4_8xxx_check_temp(ha)) {
+			set_bit(DPC_HA_UNRECOVERABLE, &ha->dpc_flags);
+			qla4xxx_wake_dpc(ha);
+		} else if (dev_state == QLA82XX_DEV_NEED_RESET &&
 		    !test_bit(DPC_RESET_HA, &ha->dpc_flags)) {
 			if (!ql4xdontresethba) {
 				ql4_printk(KERN_INFO, ha, "%s: HW State: "
-- 
1.7.8.rc2.3.g0911


