From: vikas.chaudhary@qlogic.com
Subject: [PATCH 1/8] qla4xxx: Take E-port out of reset before disabling pause frames
Date: Thu,  7 Mar 2013 05:43:07 -0500
Message-ID: <1362652994-7593-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:18173 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752800Ab3CGLFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 06:05:22 -0500
In-Reply-To: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Dusane <manish.dusane@qlogic.com>

From: Manish Dusane <manish.dusane@qlogic.com>

Problem Description:
Disabling pause frames might cause hardware wedging needing a power cycle.
This might happen if the Eport is not initialized and is in reset.

Solution:
Before disabling pause frames ensure that eport is out of reset.

Signed-off-by: Manish Dusane <manish.dusane@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_83xx.c | 28 ++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_83xx.h | 10 ++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index 5d8fe4f..d607eb8 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -1629,9 +1629,37 @@ static void __qla4_83xx_disable_pause(struct scsi_qla_host *ha)
 	ql4_printk(KERN_INFO, ha, "Disabled pause frames successfully.\n");
 }
 
+/**
+ * qla4_83xx_eport_init - Initialize EPort.
+ * @ha: Pointer to host adapter structure.
+ *
+ * If EPort hardware is in reset state before disabling pause, there would be
+ * serious hardware wedging issues. To prevent this perform eport init everytime
+ * before disabling pause frames.
+ **/
+static void qla4_83xx_eport_init(struct scsi_qla_host *ha)
+{
+	/* Clear the 8 registers */
+	qla4_83xx_wr_reg_indirect(ha, QLA83XX_RESET_REG, 0x0);
+	qla4_83xx_wr_reg_indirect(ha, QLA83XX_RESET_PORT0, 0x0);
+	qla4_83xx_wr_reg_indirect(ha, QLA83XX_RESET_PORT1, 0x0);
+	qla4_83xx_wr_reg_indirect(ha, QLA83XX_RESET_PORT2, 0x0);
+	qla4_83xx_wr_reg_indirect(ha, QLA83XX_RESET_PORT3, 0x0);
+	qla4_83xx_wr_reg_indirect(ha, QLA83XX_RESET_SRE_SHIM, 0x0);
+	qla4_83xx_wr_reg_indirect(ha, QLA83XX_RESET_EPG_SHIM, 0x0);
+	qla4_83xx_wr_reg_indirect(ha, QLA83XX_RESET_ETHER_PCS, 0x0);
+
+	/* Write any value to Reset Control register */
+	qla4_83xx_wr_reg_indirect(ha, QLA83XX_RESET_CONTROL, 0xFF);
+
+	ql4_printk(KERN_INFO, ha, "EPORT is out of reset.\n");
+}
+
 void qla4_83xx_disable_pause(struct scsi_qla_host *ha)
 {
 	ha->isp_ops->idc_lock(ha);
+	/* Before disabling pause frames, ensure that eport is not in reset */
+	qla4_83xx_eport_init(ha);
 	qla4_83xx_dump_pause_control_regs(ha);
 	__qla4_83xx_disable_pause(ha);
 	ha->isp_ops->idc_unlock(ha);
diff --git a/drivers/scsi/qla4xxx/ql4_83xx.h b/drivers/scsi/qla4xxx/ql4_83xx.h
index 6a00f90..fab237f 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.h
+++ b/drivers/scsi/qla4xxx/ql4_83xx.h
@@ -55,6 +55,16 @@
 #define QLA83XX_SET_PAUSE_VAL		0x0
 #define QLA83XX_SET_TC_MAX_CELL_VAL	0x03FF03FF
 
+#define QLA83XX_RESET_CONTROL		0x28084E50
+#define QLA83XX_RESET_REG		0x28084E60
+#define QLA83XX_RESET_PORT0		0x28084E70
+#define QLA83XX_RESET_PORT1		0x28084E80
+#define QLA83XX_RESET_PORT2		0x28084E90
+#define QLA83XX_RESET_PORT3		0x28084EA0
+#define QLA83XX_RESET_SRE_SHIM		0x28084EB0
+#define QLA83XX_RESET_EPG_SHIM		0x28084EC0
+#define QLA83XX_RESET_ETHER_PCS		0x28084ED0
+
 /* qla_83xx_reg_tbl registers */
 #define QLA83XX_PEG_HALT_STATUS1	0x34A8
 #define QLA83XX_PEG_HALT_STATUS2	0x34AC
-- 
1.8.0

