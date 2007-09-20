From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/19] qla2xxx: Query additional RISC information during a pause.
Date: Thu, 20 Sep 2007 14:07:37 -0700
Message-ID: <1190322470-15543-6-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXITVHs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:48 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h  |    4 ++-
 drivers/scsi/qla2xxx/qla_isr.c |   53 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index d5344d7..db63386 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -942,7 +942,9 @@ struct device_reg_24xx {
 	uint16_t mailbox31;
 
 	uint32_t iobase_window;
-	uint32_t unused_4[8];		/* Gap. */
+	uint32_t unused_4;		/* Gap. */
+	uint32_t iobase_c8;
+	uint32_t unused_4_1[6];		/* Gap. */
 	uint32_t iobase_q;
 	uint32_t unused_5[2];		/* Gap. */
 	uint32_t iobase_select;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index dcfb24b..f61c2fe 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -6,6 +6,7 @@
  */
 #include "qla_def.h"
 
+#include <linux/delay.h>
 #include <scsi/scsi_tcq.h>
 
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
@@ -1484,6 +1485,52 @@ qla24xx_process_response_queue(struct scsi_qla_host *ha)
 	WRT_REG_DWORD(&reg->rsp_q_out, ha->rsp_ring_index);
 }
 
+static void
+qla2xxx_check_risc_status(scsi_qla_host_t *ha)
+{
+	int rval;
+	uint32_t cnt;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	if (!IS_QLA25XX(ha))
+		return;
+
+	rval = QLA_SUCCESS;
+	WRT_REG_DWORD(&reg->iobase_addr, 0x7C00);
+	RD_REG_DWORD(&reg->iobase_addr);
+	WRT_REG_DWORD(&reg->iobase_window, 0x0001);
+	for (cnt = 10000; (RD_REG_DWORD(&reg->iobase_window) & BIT_0) == 0 &&
+	    rval == QLA_SUCCESS; cnt--) {
+		if (cnt) {
+			WRT_REG_DWORD(&reg->iobase_window, 0x0001);
+			udelay(10);
+		} else
+			rval = QLA_FUNCTION_TIMEOUT;
+	}
+	if (rval == QLA_SUCCESS)
+		goto next_test;
+
+	WRT_REG_DWORD(&reg->iobase_window, 0x0003);
+	for (cnt = 100; (RD_REG_DWORD(&reg->iobase_window) & BIT_0) == 0 &&
+	    rval == QLA_SUCCESS; cnt--) {
+		if (cnt) {
+			WRT_REG_DWORD(&reg->iobase_window, 0x0003);
+			udelay(10);
+		} else
+			rval = QLA_FUNCTION_TIMEOUT;
+	}
+	if (rval != QLA_SUCCESS)
+		goto done;
+
+next_test:
+	if (RD_REG_DWORD(&reg->iobase_c8) & BIT_3)
+		qla_printk(KERN_INFO, ha, "Additional code -- 0x55AA.\n");
+
+done:
+	WRT_REG_DWORD(&reg->iobase_window, 0x0000);
+	RD_REG_DWORD(&reg->iobase_window);
+}
+
 /**
  * qla24xx_intr_handler() - Process interrupts for the ISP23xx and ISP63xx.
  * @irq:
@@ -1526,6 +1573,9 @@ qla24xx_intr_handler(int irq, void *dev_id)
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
 			    "Dumping firmware!\n", hccr);
+
+			qla2xxx_check_risc_status(ha);
+
 			ha->isp_ops->fw_dump(ha, 1);
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			break;
@@ -1663,6 +1713,9 @@ qla24xx_msix_default(int irq, void *dev_id)
 
 			qla_printk(KERN_INFO, ha, "RISC paused -- HCCR=%x, "
 			    "Dumping firmware!\n", hccr);
+
+			qla2xxx_check_risc_status(ha);
+
 			ha->isp_ops->fw_dump(ha, 1);
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			break;
-- 
1.5.3.2.80.g077d6f

