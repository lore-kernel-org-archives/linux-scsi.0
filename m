From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 15/42] qla2xxx: Remove unnecessary delays from fw dump code path.
Date: Fri, 11 Apr 2014 16:54:20 -0400
Message-ID: <1397249687-32666-16-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:32093 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720AbaDKVb7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:31:59 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Hiral Patel <hiral.patel@qlogic.com>

Signed-off-by: Hiral Patel <hiral.patel@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |   71 +++++++++++++++++----------------------
 drivers/scsi/qla2xxx/qla_dbg.h |    2 +-
 2 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index ba72e16..16939a9 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -296,23 +296,13 @@ qla24xx_read_window(struct device_reg_24xx __iomem *reg, uint32_t iobase,
 	return buf;
 }
 
-int
+void
 qla24xx_pause_risc(struct device_reg_24xx __iomem *reg)
 {
-	int rval = QLA_SUCCESS;
-	uint32_t cnt;
-
 	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
-	for (cnt = 30000;
-	    ((RD_REG_DWORD(&reg->host_status) & HSRX_RISC_PAUSED) == 0) &&
-	    rval == QLA_SUCCESS; cnt--) {
-		if (cnt)
-			udelay(100);
-		else
-			rval = QLA_FUNCTION_TIMEOUT;
-	}
 
-	return rval;
+	/* 100 usec delay is sufficient enough for hardware to pause RISC */
+	udelay(100);
 }
 
 int
@@ -320,10 +310,14 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
 {
 	int rval = QLA_SUCCESS;
 	uint32_t cnt;
-	uint16_t mb0, wd;
+	uint16_t wd;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
-	/* Reset RISC. */
+	/*
+	 * Reset RISC. The delay is dependent on system architecture.
+	 * Driver can proceed with the reset sequence after waiting
+	 * for a timeout period.
+	 */
 	WRT_REG_DWORD(&reg->ctrl_status, CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
 	for (cnt = 0; cnt < 30000; cnt++) {
 		if ((RD_REG_DWORD(&reg->ctrl_status) & CSRX_DMA_ACTIVE) == 0)
@@ -337,13 +331,6 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
 
 	udelay(100);
-	/* Wait for firmware to complete NVRAM accesses. */
-	mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
-	for (cnt = 10000 ; cnt && mb0; cnt--) {
-		udelay(5);
-		mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
-		barrier();
-	}
 
 	/* Wait for soft-reset to complete. */
 	for (cnt = 0; cnt < 30000; cnt++) {
@@ -356,10 +343,10 @@ qla24xx_soft_reset(struct qla_hw_data *ha)
 	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
 	RD_REG_DWORD(&reg->hccr);             /* PCI Posting. */
 
-	for (cnt = 30000; RD_REG_WORD(&reg->mailbox0) != 0 &&
+	for (cnt = 10000; RD_REG_WORD(&reg->mailbox0) != 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
 		if (cnt)
-			udelay(100);
+			udelay(10);
 		else
 			rval = QLA_FUNCTION_TIMEOUT;
 	}
@@ -1075,10 +1062,11 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
 
-	/* Pause RISC. */
-	rval = qla24xx_pause_risc(reg);
-	if (rval != QLA_SUCCESS)
-		goto qla24xx_fw_dump_failed_0;
+	/*
+	 * Pause RISC. No need to track timeout, as resetting the chip
+	 * is the right approach incase of pause timeout
+	 */
+	qla24xx_pause_risc(reg);
 
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
@@ -1325,10 +1313,11 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
 
-	/* Pause RISC. */
-	rval = qla24xx_pause_risc(reg);
-	if (rval != QLA_SUCCESS)
-		goto qla25xx_fw_dump_failed_0;
+	/*
+	 * Pause RISC. No need to track timeout, as resetting the chip
+	 * is the right approach incase of pause timeout
+	 */
+	qla24xx_pause_risc(reg);
 
 	/* Host/Risc registers. */
 	iter_reg = fw->host_risc_reg;
@@ -1641,10 +1630,11 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
 
-	/* Pause RISC. */
-	rval = qla24xx_pause_risc(reg);
-	if (rval != QLA_SUCCESS)
-		goto qla81xx_fw_dump_failed_0;
+	/*
+	 * Pause RISC. No need to track timeout, as resetting the chip
+	 * is the right approach incase of pause timeout
+	 */
+	qla24xx_pause_risc(reg);
 
 	/* Host/Risc registers. */
 	iter_reg = fw->host_risc_reg;
@@ -1959,10 +1949,11 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
 
-	/* Pause RISC. */
-	rval = qla24xx_pause_risc(reg);
-	if (rval != QLA_SUCCESS)
-		goto qla83xx_fw_dump_failed_0;
+	/*
+	 * Pause RISC. No need to track timeout, as resetting the chip
+	 * is the right approach incase of pause timeout
+	 */
+	qla24xx_pause_risc(reg);
 
 	WRT_REG_DWORD(&reg->iobase_addr, 0x6000);
 	dmp_reg = &reg->iobase_window;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index cc96104..3679b73 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -353,5 +353,5 @@ extern int qla27xx_dump_mpi_ram(struct qla_hw_data *, uint32_t, uint32_t *,
 	uint32_t, void **);
 extern int qla24xx_dump_ram(struct qla_hw_data *, uint32_t, uint32_t *,
 	uint32_t, void **);
-extern int qla24xx_pause_risc(struct device_reg_24xx __iomem *);
+extern void qla24xx_pause_risc(struct device_reg_24xx __iomem *);
 extern int qla24xx_soft_reset(struct qla_hw_data *);
-- 
1.7.7

