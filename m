From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH]  qla2xxx: Consolidate ISP24xx chip reset logic.
Date: Fri, 8 Jul 2005 17:59:26 -0700
Message-ID: <20050709005926.GI24126@plap.qlogic.org>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com> <20050709005626.GG24126@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:60019 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S263039AbVGIA71 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2005 20:59:27 -0400
Content-Disposition: inline
In-Reply-To: <20050709005626.GG24126@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Consolidate ISP24xx chip reset logic.

Consolidate near-duplicate RISC reset logic from
qla24xx_reset_chip() and qla24xx_chip_diag().  Also, after
initiating a soft-reset, insure the firmware has completed
all NVRAM accesses before continuing.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_dbg.c  |   11 ++++++
 drivers/scsi/qla2xxx/qla_init.c |   78 ++++++++++++++++-----------------------
 2 files changed, 42 insertions(+), 47 deletions(-)

644a5b0d24ceadbc1ea50ddd494e2386eec97004
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1526,6 +1526,17 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 
 		WRT_REG_DWORD(&reg->ctrl_status,
 		    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+		RD_REG_DWORD(&reg->ctrl_status);
+
+		/* Wait for firmware to complete NVRAM accesses. */
+		udelay(5);
+		mb[0] = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+		for (cnt = 10000 ; cnt && mb[0]; cnt--) {
+			udelay(5);
+			mb[0] = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+			barrier();
+		}
+
 		udelay(20);
 		for (cnt = 0; cnt < 30000; cnt++) {
 			if ((RD_REG_DWORD(&reg->ctrl_status) &
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -564,20 +564,18 @@ qla2x00_reset_chip(scsi_qla_host_t *ha)
 }
 
 /**
- * qla24xx_reset_chip() - Reset ISP24xx chip.
+ * qla24xx_reset_risc() - Perform full reset of ISP24xx RISC.
  * @ha: HA context
  *
  * Returns 0 on success.
  */
-void
-qla24xx_reset_chip(scsi_qla_host_t *ha)
+static inline void
+qla24xx_reset_risc(scsi_qla_host_t *ha)
 {
 	unsigned long flags = 0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t cnt, d2;
 
-	ha->isp_ops.disable_intrs(ha);
-
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Reset RISC. */
@@ -591,6 +589,17 @@ qla24xx_reset_chip(scsi_qla_host_t *ha)
 
 	WRT_REG_DWORD(&reg->ctrl_status,
 	    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+	RD_REG_DWORD(&reg->ctrl_status);
+
+	/* Wait for firmware to complete NVRAM accesses. */
+	udelay(5);
+	d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+	for (cnt = 10000 ; cnt && d2; cnt--) {
+		udelay(5);
+		d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+		barrier();
+	}
+
 	udelay(20);
 	d2 = RD_REG_DWORD(&reg->ctrl_status);
 	for (cnt = 6000000 ; cnt && (d2 & CSRX_ISP_SOFT_RESET); cnt--) {
@@ -619,6 +628,21 @@ qla24xx_reset_chip(scsi_qla_host_t *ha)
 }
 
 /**
+ * qla24xx_reset_chip() - Reset ISP24xx chip.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+void
+qla24xx_reset_chip(scsi_qla_host_t *ha)
+{
+	ha->isp_ops.disable_intrs(ha);
+
+	/* Perform RISC reset. */
+	qla24xx_reset_risc(ha);
+}
+
+/**
  * qla2x00_chip_diag() - Test chip for proper operation.
  * @ha: HA context
  *
@@ -753,49 +777,9 @@ int
 qla24xx_chip_diag(scsi_qla_host_t *ha)
 {
 	int rval;
-	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
-	unsigned long flags = 0;
-	uint32_t cnt, d2;
-
-	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	/* Reset RISC. */
-	WRT_REG_DWORD(&reg->ctrl_status, CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
-	for (cnt = 0; cnt < 30000; cnt++) {
-		if ((RD_REG_DWORD(&reg->ctrl_status) &
-		    CSRX_DMA_ACTIVE) == 0)
-			break;
-
-		udelay(10);
-	}
-
-	WRT_REG_DWORD(&reg->ctrl_status,
-	    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
-	udelay(20);
-	d2 = RD_REG_DWORD(&reg->ctrl_status);
-	for (cnt = 6000000 ; cnt && (d2 & CSRX_ISP_SOFT_RESET); cnt--) {
-		udelay(5);
-		d2 = RD_REG_DWORD(&reg->ctrl_status);
-		barrier();
-	}
-
-	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
-	RD_REG_DWORD(&reg->hccr);
-
-	WRT_REG_DWORD(&reg->hccr, HCCRX_REL_RISC_PAUSE);
-	RD_REG_DWORD(&reg->hccr);
-
-	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
-	RD_REG_DWORD(&reg->hccr);
-
-	d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
-	for (cnt = 6000000 ; cnt && d2; cnt--) {
-		udelay(5);
-		d2 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
-		barrier();
-	}
-
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	/* Perform RISC reset. */
+	qla24xx_reset_risc(ha);
 
 	ha->fw_transfer_size = REQUEST_ENTRY_SIZE * 1024;
 
------------
