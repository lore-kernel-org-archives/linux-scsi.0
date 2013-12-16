From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 04/24] qla4xxx: Use IDC_CTRL bit1 directly instead of AF_83XX_NO_FWDUMP flag.
Date: Mon, 16 Dec 2013 06:49:34 -0500
Message-ID: <1387194594-29817-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:2737 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049Ab3LPMXZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:25 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Removed AF_83XX_NO_FWDUMP flag and directly checking IDC_CTRL bit1
while taking minidump, to check for graceful reset.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_83xx.c | 16 ++++++++++++++--
 drivers/scsi/qla4xxx/ql4_def.h  |  1 -
 drivers/scsi/qla4xxx/ql4_nx.c   | 15 +--------------
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index 43c1688..e80e82f 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -1304,12 +1304,24 @@ static void qla4_83xx_process_init_seq(struct scsi_qla_host *ha)
 static int qla4_83xx_restart(struct scsi_qla_host *ha)
 {
 	int ret_val = QLA_SUCCESS;
+	uint32_t idc_ctrl;
 
 	qla4_83xx_process_stop_seq(ha);
 
-	/* Collect minidump*/
-	if (!test_and_clear_bit(AF_83XX_NO_FW_DUMP, &ha->flags))
+	/*
+	 * Collect minidump.
+	 * If IDC_CTRL BIT1 is set, clear it on going to INIT state and
+	 * don't collect minidump
+	 */
+	idc_ctrl = qla4_83xx_rd_reg(ha, QLA83XX_IDC_DRV_CTRL);
+	if (idc_ctrl & GRACEFUL_RESET_BIT1) {
+		qla4_83xx_wr_reg(ha, QLA83XX_IDC_DRV_CTRL,
+				 (idc_ctrl & ~GRACEFUL_RESET_BIT1));
+		ql4_printk(KERN_INFO, ha, "%s: Graceful RESET: Not collecting minidump\n",
+			   __func__);
+	} else {
 		qla4_8xxx_get_minidump(ha);
+	}
 
 	qla4_83xx_process_init_seq(ha);
 
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index e9df4ad..5236337 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -580,7 +580,6 @@ struct scsi_qla_host {
 #define AF_82XX_FW_DUMPED		24 /* 0x01000000 */
 #define AF_8XXX_RST_OWNER		25 /* 0x02000000 */
 #define AF_82XX_DUMP_READING		26 /* 0x04000000 */
-#define AF_83XX_NO_FW_DUMP		27 /* 0x08000000 */
 #define AF_83XX_IOCB_INTR_ON		28 /* 0x10000000 */
 #define AF_83XX_MBOX_INTR_ON		29 /* 0x20000000 */
 
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index bbe8361..0ec07ec 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2821,7 +2821,7 @@ int qla4_8xxx_device_bootstrap(struct scsi_qla_host *ha)
 {
 	int rval = QLA_ERROR;
 	int i, timeout;
-	uint32_t old_count, count, idc_ctrl;
+	uint32_t old_count, count;
 	int need_reset = 0, peg_stuck = 1;
 
 	need_reset = ha->isp_ops->need_reset(ha);
@@ -2864,19 +2864,6 @@ dev_initialize:
 	qla4_8xxx_wr_direct(ha, QLA8XXX_CRB_DEV_STATE,
 			    QLA8XXX_DEV_INITIALIZING);
 
-	/*
-	 * For ISP8324 and ISP8042, if IDC_CTRL GRACEFUL_RESET_BIT1 is set,
-	 * reset it after device goes to INIT state.
-	 */
-	if (is_qla8032(ha) || is_qla8042(ha)) {
-		idc_ctrl = qla4_83xx_rd_reg(ha, QLA83XX_IDC_DRV_CTRL);
-		if (idc_ctrl & GRACEFUL_RESET_BIT1) {
-			qla4_83xx_wr_reg(ha, QLA83XX_IDC_DRV_CTRL,
-					 (idc_ctrl & ~GRACEFUL_RESET_BIT1));
-			set_bit(AF_83XX_NO_FW_DUMP, &ha->flags);
-		}
-	}
-
 	ha->isp_ops->idc_unlock(ha);
 
 	if (is_qla8022(ha))
-- 
1.8.2.GIT

