From: andrew.vasquez@qlogic.com
Subject: [PATCH 07/15] qla2xxx: Update firmware-dump procedure for ISP24xx.
Date: Fri, 13 Jan 2006 17:05:21 -0800
Message-ID: <11372007161698-git-send-email-andrew.vasquez@qlogic.com>
References: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:33060 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1945931AbWANBFV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 20:05:21 -0500
In-Reply-To: <11372006833162-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Small changes to register retrieval and order as per latest
firmware specification.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_dbg.c |  105 ++++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_dbg.h |    4 +-
 2 files changed, 55 insertions(+), 54 deletions(-)

df6e05fa3f6c026a83c3cb6e9a7365bba5fa7ac6
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 5c5d231..2d9b12f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1003,10 +1003,10 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 	fw = (struct qla24xx_fw_dump *) ha->fw_dump24;
 
 	rval = QLA_SUCCESS;
-	fw->hccr = RD_REG_DWORD(&reg->hccr);
+	fw->host_status = RD_REG_DWORD(&reg->host_status);
 
 	/* Pause RISC. */
-	if ((fw->hccr & HCCRX_RISC_PAUSE) == 0) {
+	if ((RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0) {
 		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET |
 		    HCCRX_CLR_HOST_INT);
 		RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
@@ -1021,16 +1021,54 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 		}
 	}
 
-	/* Disable interrupts. */
-	WRT_REG_DWORD(&reg->ictrl, 0);
-	RD_REG_DWORD(&reg->ictrl);
-
 	if (rval == QLA_SUCCESS) {
 		/* Host interface registers. */
 		dmp_reg = (uint32_t __iomem *)(reg + 0);
 		for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
 			fw->host_reg[cnt] = RD_REG_DWORD(dmp_reg++);
 
+		/* Disable interrupts. */
+		WRT_REG_DWORD(&reg->ictrl, 0);
+		RD_REG_DWORD(&reg->ictrl);
+
+		/* Shadow registers. */
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
+		RD_REG_DWORD(&reg->iobase_addr);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
+		WRT_REG_DWORD(dmp_reg, 0xB0000000);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
+		fw->shadow_reg[0] = RD_REG_DWORD(dmp_reg);
+
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
+		WRT_REG_DWORD(dmp_reg, 0xB0100000);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
+		fw->shadow_reg[1] = RD_REG_DWORD(dmp_reg);
+
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
+		WRT_REG_DWORD(dmp_reg, 0xB0200000);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
+		fw->shadow_reg[2] = RD_REG_DWORD(dmp_reg);
+
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
+		WRT_REG_DWORD(dmp_reg, 0xB0300000);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
+		fw->shadow_reg[3] = RD_REG_DWORD(dmp_reg);
+
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
+		WRT_REG_DWORD(dmp_reg, 0xB0400000);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
+		fw->shadow_reg[4] = RD_REG_DWORD(dmp_reg);
+
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
+		WRT_REG_DWORD(dmp_reg, 0xB0500000);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
+		fw->shadow_reg[5] = RD_REG_DWORD(dmp_reg);
+
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
+		WRT_REG_DWORD(dmp_reg, 0xB0600000);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
+		fw->shadow_reg[6] = RD_REG_DWORD(dmp_reg);
+
 		/* Mailbox registers. */
 		mbx_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
@@ -1308,43 +1346,6 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
 
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-		RD_REG_DWORD(&reg->iobase_addr);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0000000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[0] = RD_REG_DWORD(dmp_reg);
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0100000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[1] = RD_REG_DWORD(dmp_reg);
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0200000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[2] = RD_REG_DWORD(dmp_reg);
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0300000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[3] = RD_REG_DWORD(dmp_reg);
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0400000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[4] = RD_REG_DWORD(dmp_reg);
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0500000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[5] = RD_REG_DWORD(dmp_reg);
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0600000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[6] = RD_REG_DWORD(dmp_reg);
-
 		/* Local memory controller registers. */
 		iter_reg = fw->lmc_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3000);
@@ -1677,7 +1678,7 @@ qla24xx_ascii_fw_dump(scsi_qla_host_t *h
 	    ha->fw_major_version, ha->fw_minor_version,
 	    ha->fw_subminor_version, ha->fw_attributes);
 
-	qla_uprintf(&uiter, "\nHCCR Register\n%04x\n", fw->hccr);
+	qla_uprintf(&uiter, "\nR2H Status Register\n%04x\n", fw->host_status);
 
 	qla_uprintf(&uiter, "\nHost Interface Registers");
 	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++) {
@@ -1687,6 +1688,14 @@ qla24xx_ascii_fw_dump(scsi_qla_host_t *h
 		qla_uprintf(&uiter, "%08x ", fw->host_reg[cnt]);
 	}
 
+	qla_uprintf(&uiter, "\n\nShadow Registers");
+	for (cnt = 0; cnt < sizeof(fw->shadow_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->shadow_reg[cnt]);
+	}
+
 	qla_uprintf(&uiter, "\n\nMailbox Registers");
 	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++) {
 		if (cnt % 8 == 0)
@@ -1855,14 +1864,6 @@ qla24xx_ascii_fw_dump(scsi_qla_host_t *h
 		qla_uprintf(&uiter, "%08x ", fw->risc_gp_reg[cnt]);
 	}
 
-	qla_uprintf(&uiter, "\n\nShadow Registers");
-	for (cnt = 0; cnt < sizeof(fw->shadow_reg) / 4; cnt++) {
-		if (cnt % 8 == 0)
-			qla_uprintf(&uiter, "\n");
-
-		qla_uprintf(&uiter, "%08x ", fw->shadow_reg[cnt]);
-	}
-
 	qla_uprintf(&uiter, "\n\nLMC Registers");
 	for (cnt = 0; cnt < sizeof(fw->lmc_reg) / 4; cnt++) {
 		if (cnt % 8 == 0)
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 935a59a..ab6afea 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -227,8 +227,9 @@ struct qla2100_fw_dump {
 #define FW_DUMP_SIZE_24XX	0x2B0000
 
 struct qla24xx_fw_dump {
-	uint32_t hccr;
+	uint32_t host_status;
 	uint32_t host_reg[32];
+	uint32_t shadow_reg[7];
 	uint16_t mailbox_reg[32];
 	uint32_t xseq_gp_reg[128];
 	uint32_t xseq_0_reg[16];
@@ -250,7 +251,6 @@ struct qla24xx_fw_dump {
 	uint32_t rcvt0_data_dma_reg[32];
 	uint32_t rcvt1_data_dma_reg[32];
 	uint32_t risc_gp_reg[128];
-	uint32_t shadow_reg[7];
 	uint32_t lmc_reg[112];
 	uint32_t fpm_hdw_reg[192];
 	uint32_t fb_hdw_reg[176];
-- 
1.1.1-g4c34


