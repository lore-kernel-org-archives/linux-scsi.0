From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH-RESEND 01/19] [subject axed by vger spam-guards]
Date: Thu, 20 Sep 2007 14:36:11 -0700
Message-ID: <20070920213611.GF8456@plap3.qlogic.org>
References: <20070920210422.GE8456@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:17558 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbXITVgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:36:03 -0400
Content-Disposition: inline
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

It appears this patch didn't get through vger's spam-filter due to the
original subject containing 3 'X's (I'll be a bit more careful of that
next time).

IAC:  the raw-patch is below.

James B., you can find a 'git-format-patch' mbox file for the commit
here:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.02.00-k4/0001-qla2xxx-Collapse-and-simplify-ISP2XXX-firmware-dump.patch

apply with 'git-am'.  I'm not sure if the 3-Xs got passed your spam
filter.

Thanks, av

---

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index c668034..b52fa89 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -38,7 +38,7 @@ qla2xxx_copy_queues(scsi_qla_host_t *ha, void *ptr)
 }
 
 static int
-qla2xxx_dump_memory(scsi_qla_host_t *ha, uint32_t *code_ram,
+qla24xx_dump_memory(scsi_qla_host_t *ha, uint32_t *code_ram,
     uint32_t cram_size, uint32_t *ext_mem, void **nxt)
 {
 	int rval;
@@ -152,6 +152,106 @@ qla2xxx_dump_memory(scsi_qla_host_t *ha, uint32_t *code_ram,
 	return rval;
 }
 
+static uint32_t *
+qla24xx_read_window(struct device_reg_24xx __iomem *reg, uint32_t iobase,
+    uint32_t count, uint32_t *buf)
+{
+	uint32_t __iomem *dmp_reg;
+
+	WRT_REG_DWORD(&reg->iobase_addr, iobase);
+	dmp_reg = &reg->iobase_window;
+	while (count--)
+		*buf++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+	return buf;
+}
+
+static inline int
+qla24xx_pause_risc(struct device_reg_24xx __iomem *reg)
+{
+	int rval = QLA_SUCCESS;
+	uint32_t cnt;
+
+	if ((RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0) {
+		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET |
+		    HCCRX_CLR_HOST_INT);
+		RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
+		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
+		for (cnt = 30000;
+		    (RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0 &&
+		    rval == QLA_SUCCESS; cnt--) {
+			if (cnt)
+				udelay(100);
+			else
+				rval = QLA_FUNCTION_TIMEOUT;
+		}
+	}
+
+	return rval;
+}
+
+static int
+qla24xx_soft_reset(scsi_qla_host_t *ha)
+{
+	int rval = QLA_SUCCESS;
+	uint32_t cnt;
+	uint16_t mb0, wd;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	/* Reset RISC. */
+	WRT_REG_DWORD(&reg->ctrl_status, CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+	for (cnt = 0; cnt < 30000; cnt++) {
+		if ((RD_REG_DWORD(&reg->ctrl_status) & CSRX_DMA_ACTIVE) == 0)
+			break;
+
+		udelay(10);
+	}
+
+	WRT_REG_DWORD(&reg->ctrl_status,
+	    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+	pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
+
+	udelay(100);
+	/* Wait for firmware to complete NVRAM accesses. */
+	mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+	for (cnt = 10000 ; cnt && mb0; cnt--) {
+		udelay(5);
+		mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+		barrier();
+	}
+
+	/* Wait for soft-reset to complete. */
+	for (cnt = 0; cnt < 30000; cnt++) {
+		if ((RD_REG_DWORD(&reg->ctrl_status) &
+		    CSRX_ISP_SOFT_RESET) == 0)
+			break;
+
+		udelay(10);
+	}
+	WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
+	RD_REG_DWORD(&reg->hccr);             /* PCI Posting. */
+
+	for (cnt = 30000; RD_REG_WORD(&reg->mailbox0) != 0 &&
+	    rval == QLA_SUCCESS; cnt--) {
+		if (cnt)
+			udelay(100);
+		else
+			rval = QLA_FUNCTION_TIMEOUT;
+	}
+
+	return rval;
+}
+
+static inline void
+qla2xxx_read_window(struct device_reg_2xxx __iomem *reg, uint32_t count,
+    uint16_t *buf)
+{
+	uint16_t __iomem *dmp_reg = &reg->u.isp2300.fb_cmd;
+
+	while (count--)
+		*buf++ = htons(RD_REG_WORD(dmp_reg++));
+}
+
 /**
  * qla2300_fw_dump() - Dumps binary data from the 2300 firmware.
  * @ha: HA context
@@ -214,88 +314,61 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	}
 
 	if (rval == QLA_SUCCESS) {
-		dmp_reg = (uint16_t __iomem *)(reg + 0);
+		dmp_reg = &reg->flash_address;
 		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++)
 			fw->pbiu_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x10);
+		dmp_reg = &reg->u.isp2300.req_q_in;
 		for (cnt = 0; cnt < sizeof(fw->risc_host_reg) / 2; cnt++)
 			fw->risc_host_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x40);
+		dmp_reg = &reg->u.isp2300.mailbox0;
 		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
 			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x40);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->resp_dma_reg) / 2; cnt++)
-			fw->resp_dma_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 32, fw->resp_dma_reg);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x50);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++)
-			fw->dma_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 48, fw->dma_reg);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x00);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0xA0);
+		dmp_reg = &reg->risc_hw;
 		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++)
 			fw->risc_hdw_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2000);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp0_reg) / 2; cnt++)
-			fw->risc_gp0_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp0_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2200);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp1_reg) / 2; cnt++)
-			fw->risc_gp1_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp1_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2400);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp2_reg) / 2; cnt++)
-			fw->risc_gp2_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp2_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2600);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp3_reg) / 2; cnt++)
-			fw->risc_gp3_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp3_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2800);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp4_reg) / 2; cnt++)
-			fw->risc_gp4_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp4_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2A00);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp5_reg) / 2; cnt++)
-			fw->risc_gp5_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp5_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2C00);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp6_reg) / 2; cnt++)
-			fw->risc_gp6_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp6_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2E00);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp7_reg) / 2; cnt++)
-			fw->risc_gp7_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp7_reg);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x10);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->frame_buf_hdw_reg) / 2; cnt++)
-			fw->frame_buf_hdw_reg[cnt] =
-			    htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 64, fw->frame_buf_hdw_reg);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x20);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->fpm_b0_reg) / 2; cnt++)
-			fw->fpm_b0_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 64, fw->fpm_b0_reg);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x30);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++)
-			fw->fpm_b1_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 64, fw->fpm_b1_reg);
 
 		/* Reset RISC. */
 		WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
@@ -567,83 +640,59 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 			rval = QLA_FUNCTION_TIMEOUT;
 	}
 	if (rval == QLA_SUCCESS) {
-		dmp_reg = (uint16_t __iomem *)(reg + 0);
+		dmp_reg = &reg->flash_address;
 		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++)
 			fw->pbiu_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x10);
+		dmp_reg = &reg->u.isp2100.mailbox0;
 		for (cnt = 0; cnt < ha->mbx_count; cnt++) {
-			if (cnt == 8) {
-				dmp_reg = (uint16_t __iomem *)
-					((uint8_t __iomem *)reg + 0xe0);
-			}
+			if (cnt == 8)
+				dmp_reg = &reg->u_end.isp2200.mailbox8;
+
 			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 		}
 
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x20);
+		dmp_reg = &reg->u.isp2100.unused_2[0];
 		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++)
 			fw->dma_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x00);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0xA0);
+		dmp_reg = &reg->risc_hw;
 		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++)
 			fw->risc_hdw_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
 
 		WRT_REG_WORD(&reg->pcr, 0x2000);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp0_reg) / 2; cnt++)
-			fw->risc_gp0_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp0_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2100);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp1_reg) / 2; cnt++)
-			fw->risc_gp1_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp1_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2200);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp2_reg) / 2; cnt++)
-			fw->risc_gp2_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp2_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2300);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp3_reg) / 2; cnt++)
-			fw->risc_gp3_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp3_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2400);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp4_reg) / 2; cnt++)
-			fw->risc_gp4_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp4_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2500);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp5_reg) / 2; cnt++)
-			fw->risc_gp5_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp5_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2600);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp6_reg) / 2; cnt++)
-			fw->risc_gp6_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp6_reg);
 
 		WRT_REG_WORD(&reg->pcr, 0x2700);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp7_reg) / 2; cnt++)
-			fw->risc_gp7_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->risc_gp7_reg);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x10);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->frame_buf_hdw_reg) / 2; cnt++)
-			fw->frame_buf_hdw_reg[cnt] =
-			    htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 16, fw->frame_buf_hdw_reg);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x20);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->fpm_b0_reg) / 2; cnt++)
-			fw->fpm_b0_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 64, fw->fpm_b0_reg);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x30);
-		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++)
-			fw->fpm_b1_reg[cnt] = htons(RD_REG_WORD(dmp_reg++));
+		qla2xxx_read_window(reg, 64, fw->fpm_b1_reg);
 
 		/* Reset the ISP. */
 		WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
@@ -750,7 +799,6 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	int		rval;
 	uint32_t	cnt;
 	uint32_t	risc_address;
-	uint16_t	mb0, wd;
 
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
@@ -782,547 +830,198 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	fw = &ha->fw_dump->isp.isp24;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
 
-	rval = QLA_SUCCESS;
 	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
 
 	/* Pause RISC. */
-	if ((RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0) {
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET |
-		    HCCRX_CLR_HOST_INT);
-		RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
-		for (cnt = 30000;
-		    (RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0 &&
-		    rval == QLA_SUCCESS; cnt--) {
-			if (cnt)
-				udelay(100);
-			else
-				rval = QLA_FUNCTION_TIMEOUT;
-		}
-	}
-
-	if (rval == QLA_SUCCESS) {
-		/* Host interface registers. */
-		dmp_reg = (uint32_t __iomem *)(reg + 0);
-		for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
-			fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Disable interrupts. */
-		WRT_REG_DWORD(&reg->ictrl, 0);
-		RD_REG_DWORD(&reg->ictrl);
-
-		/* Shadow registers. */
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-		RD_REG_DWORD(&reg->iobase_addr);
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
-		fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
-		fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
-		fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
-		fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
-		fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
-		fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
-		fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		/* Mailbox registers. */
-		mbx_reg = &reg->mailbox0;
-		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
-			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg++));
-
-		/* Transfer sequence registers. */
-		iter_reg = fw->xseq_gp_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF00);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF10);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF20);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF30);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF40);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF50);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF60);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF70);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBFE0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->xseq_0_reg) / 4; cnt++)
-			fw->xseq_0_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBFF0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->xseq_1_reg) / 4; cnt++)
-			fw->xseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Receive sequence registers. */
-		iter_reg = fw->rseq_gp_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF00);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF10);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF20);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF30);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF40);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF50);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF60);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF70);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFFD0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->rseq_0_reg) / 4; cnt++)
-			fw->rseq_0_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFFE0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->rseq_1_reg) / 4; cnt++)
-			fw->rseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFFF0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->rseq_2_reg) / 4; cnt++)
-			fw->rseq_2_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Command DMA registers. */
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7100);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->cmd_dma_reg) / 4; cnt++)
-			fw->cmd_dma_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Queues. */
-		iter_reg = fw->req0_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7200);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 8; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		dmp_reg = &reg->iobase_q;
-		for (cnt = 0; cnt < 7; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->resp0_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7300);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 8; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		dmp_reg = &reg->iobase_q;
-		for (cnt = 0; cnt < 7; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->req1_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7400);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 8; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		dmp_reg = &reg->iobase_q;
-		for (cnt = 0; cnt < 7; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Transmit DMA registers. */
-		iter_reg = fw->xmt0_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7600);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7610);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->xmt1_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7620);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7630);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->xmt2_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7640);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7650);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->xmt3_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7660);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7670);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->xmt4_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7680);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7690);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x76A0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->xmt_data_dma_reg) / 4; cnt++)
-			fw->xmt_data_dma_reg[cnt] =
-			    htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Receive DMA registers. */
-		iter_reg = fw->rcvt0_data_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7700);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7710);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->rcvt1_data_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7720);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7730);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* RISC registers. */
-		iter_reg = fw->risc_gp_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F00);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F10);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F20);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F30);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F40);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F50);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F60);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Local memory controller registers. */
-		iter_reg = fw->lmc_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3000);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3010);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3020);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3030);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3040);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3050);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3060);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Fibre Protocol Module registers. */
-		iter_reg = fw->fpm_hdw_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4000);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4010);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4020);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4030);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4040);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4050);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4060);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4070);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4080);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4090);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x40A0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x40B0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Frame Buffer registers. */
-		iter_reg = fw->fb_hdw_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6000);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6010);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6020);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6030);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6040);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6100);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6130);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6150);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6170);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6190);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x61B0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Reset RISC. */
-		WRT_REG_DWORD(&reg->ctrl_status,
-		    CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
-		for (cnt = 0; cnt < 30000; cnt++) {
-			if ((RD_REG_DWORD(&reg->ctrl_status) &
-			    CSRX_DMA_ACTIVE) == 0)
-				break;
-
-			udelay(10);
-		}
-
-		WRT_REG_DWORD(&reg->ctrl_status,
-		    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
-		pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
-
-		udelay(100);
-		/* Wait for firmware to complete NVRAM accesses. */
-		mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
-		for (cnt = 10000 ; cnt && mb0; cnt--) {
-			udelay(5);
-			mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
-			barrier();
-		}
-
-		/* Wait for soft-reset to complete. */
-		for (cnt = 0; cnt < 30000; cnt++) {
-			if ((RD_REG_DWORD(&reg->ctrl_status) &
-			    CSRX_ISP_SOFT_RESET) == 0)
-				break;
-
-			udelay(10);
-		}
-		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
-		RD_REG_DWORD(&reg->hccr);             /* PCI Posting. */
-	}
-
-	for (cnt = 30000; RD_REG_WORD(&reg->mailbox0) != 0 &&
-	    rval == QLA_SUCCESS; cnt--) {
-		if (cnt)
-			udelay(100);
-		else
-			rval = QLA_FUNCTION_TIMEOUT;
-	}
-
-	if (rval == QLA_SUCCESS)
-		rval = qla2xxx_dump_memory(ha, fw->code_ram,
-		    sizeof(fw->code_ram), fw->ext_mem, &nxt);
-
-	if (rval == QLA_SUCCESS) {
-		nxt = qla2xxx_copy_queues(ha, nxt);
-		if (ha->eft)
-			memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
-	}
-
+	rval = qla24xx_pause_risc(reg);
+	if (rval != QLA_SUCCESS)
+		goto qla24xx_fw_dump_failed_0;
+
+	/* Host interface registers. */
+	dmp_reg = &reg->flash_addr;
+	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
+		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
+
+	/* Disable interrupts. */
+	WRT_REG_DWORD(&reg->ictrl, 0);
+	RD_REG_DWORD(&reg->ictrl);
+
+	/* Shadow registers. */
+	WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
+	RD_REG_DWORD(&reg->iobase_addr);
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
+	fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
+	fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
+	fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
+	fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
+	fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
+	fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
+	fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	/* Mailbox registers. */
+	mbx_reg = &reg->mailbox0;
+	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
+		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg++));
+
+	/* Transfer sequence registers. */
+	iter_reg = fw->xseq_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0xBF00, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF10, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF20, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF30, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF40, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF50, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF60, 16, iter_reg);
+	qla24xx_read_window(reg, 0xBF70, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0xBFE0, 16, fw->xseq_0_reg);
+	qla24xx_read_window(reg, 0xBFF0, 16, fw->xseq_1_reg);
+
+	/* Receive sequence registers. */
+	iter_reg = fw->rseq_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0xFF00, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF10, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF20, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF30, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF40, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF50, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF60, 16, iter_reg);
+	qla24xx_read_window(reg, 0xFF70, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0xFFD0, 16, fw->rseq_0_reg);
+	qla24xx_read_window(reg, 0xFFE0, 16, fw->rseq_1_reg);
+	qla24xx_read_window(reg, 0xFFF0, 16, fw->rseq_2_reg);
+
+	/* Command DMA registers. */
+	qla24xx_read_window(reg, 0x7100, 16, fw->cmd_dma_reg);
+
+	/* Queues. */
+	iter_reg = fw->req0_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7200, 8, iter_reg);
+	dmp_reg = &reg->iobase_q;
+	for (cnt = 0; cnt < 7; cnt++)
+		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+	iter_reg = fw->resp0_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7300, 8, iter_reg);
+	dmp_reg = &reg->iobase_q;
+	for (cnt = 0; cnt < 7; cnt++)
+		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+	iter_reg = fw->req1_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7400, 8, iter_reg);
+	dmp_reg = &reg->iobase_q;
+	for (cnt = 0; cnt < 7; cnt++)
+		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+	/* Transmit DMA registers. */
+	iter_reg = fw->xmt0_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7600, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7610, 16, iter_reg);
+
+	iter_reg = fw->xmt1_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7620, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7630, 16, iter_reg);
+
+	iter_reg = fw->xmt2_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7640, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7650, 16, iter_reg);
+
+	iter_reg = fw->xmt3_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7660, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7670, 16, iter_reg);
+
+	iter_reg = fw->xmt4_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7680, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7690, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0x76A0, 16, fw->xmt_data_dma_reg);
+
+	/* Receive DMA registers. */
+	iter_reg = fw->rcvt0_data_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7700, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7710, 16, iter_reg);
+
+	iter_reg = fw->rcvt1_data_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7720, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7730, 16, iter_reg);
+
+	/* RISC registers. */
+	iter_reg = fw->risc_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0x0F00, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F10, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F20, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F30, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F40, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F50, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F60, 16, iter_reg);
+	qla24xx_read_window(reg, 0x0F70, 16, iter_reg);
+
+	/* Local memory controller registers. */
+	iter_reg = fw->lmc_reg;
+	iter_reg = qla24xx_read_window(reg, 0x3000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3050, 16, iter_reg);
+	qla24xx_read_window(reg, 0x3060, 16, iter_reg);
+
+	/* Fibre Protocol Module registers. */
+	iter_reg = fw->fpm_hdw_reg;
+	iter_reg = qla24xx_read_window(reg, 0x4000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4050, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4060, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4070, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4080, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4090, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x40A0, 16, iter_reg);
+	qla24xx_read_window(reg, 0x40B0, 16, iter_reg);
+
+	/* Frame Buffer registers. */
+	iter_reg = fw->fb_hdw_reg;
+	iter_reg = qla24xx_read_window(reg, 0x6000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6100, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6130, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6150, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6170, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6190, 16, iter_reg);
+	qla24xx_read_window(reg, 0x61B0, 16, iter_reg);
+
+	rval = qla24xx_soft_reset(ha);
+	if (rval != QLA_SUCCESS)
+		goto qla24xx_fw_dump_failed_0;
+
+	rval = qla24xx_dump_memory(ha, fw->code_ram, sizeof(fw->code_ram),
+	    fw->ext_mem, &nxt);
+	if (rval != QLA_SUCCESS)
+		goto qla24xx_fw_dump_failed_0;
+
+	nxt = qla2xxx_copy_queues(ha, nxt);
+	if (ha->eft)
+		memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
+
+qla24xx_fw_dump_failed_0:
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to dump firmware (%x)!!!\n", rval);
@@ -1346,7 +1045,6 @@ qla25xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	int		rval;
 	uint32_t	cnt;
 	uint32_t	risc_address;
-	uint16_t	mb0, wd;
 
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
@@ -1378,654 +1076,241 @@ qla25xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	fw = &ha->fw_dump->isp.isp25;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
 
-	rval = QLA_SUCCESS;
 	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
 
 	/* Pause RISC. */
-	if ((RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0) {
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET |
-		    HCCRX_CLR_HOST_INT);
-		RD_REG_DWORD(&reg->hccr);		/* PCI Posting. */
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_PAUSE);
-		for (cnt = 30000;
-		    (RD_REG_DWORD(&reg->hccr) & HCCRX_RISC_PAUSE) == 0 &&
-		    rval == QLA_SUCCESS; cnt--) {
-			if (cnt)
-				udelay(100);
-			else
-				rval = QLA_FUNCTION_TIMEOUT;
-		}
-	}
-
-	if (rval == QLA_SUCCESS) {
-		/* Host interface registers. */
-		dmp_reg = (uint32_t __iomem *)(reg + 0);
-		for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
-			fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Disable interrupts. */
-		WRT_REG_DWORD(&reg->ictrl, 0);
-		RD_REG_DWORD(&reg->ictrl);
-
-		/* Shadow registers. */
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-		RD_REG_DWORD(&reg->iobase_addr);
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
-		fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
-		fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
-		fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
-		fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
-		fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
-		fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
-		fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0700000);
-		fw->shadow_reg[7] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0800000);
-		fw->shadow_reg[8] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0900000);
-		fw->shadow_reg[9] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		WRT_REG_DWORD(&reg->iobase_select, 0xB0A00000);
-		fw->shadow_reg[10] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
-
-		/* RISC I/O register. */
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0010);
-		RD_REG_DWORD(&reg->iobase_addr);
-		fw->risc_io_reg = htonl(RD_REG_DWORD(&reg->iobase_window));
-
-		/* Mailbox registers. */
-		mbx_reg = &reg->mailbox0;
-		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
-			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg++));
-
-		/* Transfer sequence registers. */
-		iter_reg = fw->xseq_gp_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF00);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF10);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF20);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF30);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF40);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF50);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF60);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBF70);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->xseq_0_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBFC0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBFD0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBFE0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xBFF0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->xseq_1_reg) / 4; cnt++)
-			fw->xseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Receive sequence registers. */
-		iter_reg = fw->rseq_gp_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF00);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF10);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF20);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF30);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF40);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF50);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF60);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFF70);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->rseq_0_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFFC0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFFD0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFFE0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->rseq_1_reg) / 4; cnt++)
-			fw->rseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xFFF0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->rseq_2_reg) / 4; cnt++)
-			fw->rseq_2_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Auxiliary sequence registers. */
-		iter_reg = fw->aseq_gp_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB000);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB010);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB020);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB030);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB040);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB050);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB060);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB070);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->aseq_0_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB0C0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB0D0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB0E0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->aseq_1_reg) / 4; cnt++)
-			fw->aseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0xB0F0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->aseq_2_reg) / 4; cnt++)
-			fw->aseq_2_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Command DMA registers. */
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7100);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->cmd_dma_reg) / 4; cnt++)
-			fw->cmd_dma_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Queues. */
-		iter_reg = fw->req0_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7200);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 8; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		dmp_reg = &reg->iobase_q;
-		for (cnt = 0; cnt < 7; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->resp0_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7300);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 8; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		dmp_reg = &reg->iobase_q;
-		for (cnt = 0; cnt < 7; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->req1_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7400);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 8; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		dmp_reg = &reg->iobase_q;
-		for (cnt = 0; cnt < 7; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Transmit DMA registers. */
-		iter_reg = fw->xmt0_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7600);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7610);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->xmt1_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7620);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7630);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->xmt2_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7640);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7650);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->xmt3_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7660);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7670);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->xmt4_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7680);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7690);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x76A0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < sizeof(fw->xmt_data_dma_reg) / 4; cnt++)
-			fw->xmt_data_dma_reg[cnt] =
-			    htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Receive DMA registers. */
-		iter_reg = fw->rcvt0_data_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7700);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7710);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		iter_reg = fw->rcvt1_data_dma_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7720);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x7730);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* RISC registers. */
-		iter_reg = fw->risc_gp_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F00);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F10);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F20);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F30);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F40);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F50);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F60);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Local memory controller registers. */
-		iter_reg = fw->lmc_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3000);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3010);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3020);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3030);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3040);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3050);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3060);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x3070);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Fibre Protocol Module registers. */
-		iter_reg = fw->fpm_hdw_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4000);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4010);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4020);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4030);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4040);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4050);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4060);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4070);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4080);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x4090);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x40A0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x40B0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Frame Buffer registers. */
-		iter_reg = fw->fb_hdw_reg;
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6000);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6010);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6020);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6030);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6040);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6100);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6130);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6150);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6170);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6190);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x61B0);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		WRT_REG_DWORD(&reg->iobase_addr, 0x6F00);
-		dmp_reg = &reg->iobase_window;
-		for (cnt = 0; cnt < 16; cnt++)
-			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
-
-		/* Reset RISC. */
-		WRT_REG_DWORD(&reg->ctrl_status,
-		    CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
-		for (cnt = 0; cnt < 30000; cnt++) {
-			if ((RD_REG_DWORD(&reg->ctrl_status) &
-			    CSRX_DMA_ACTIVE) == 0)
-				break;
-
-			udelay(10);
-		}
-
-		WRT_REG_DWORD(&reg->ctrl_status,
-		    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
-		pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
-
-		udelay(100);
-		/* Wait for firmware to complete NVRAM accesses. */
-		mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
-		for (cnt = 10000 ; cnt && mb0; cnt--) {
-			udelay(5);
-			mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
-			barrier();
-		}
-
-		/* Wait for soft-reset to complete. */
-		for (cnt = 0; cnt < 30000; cnt++) {
-			if ((RD_REG_DWORD(&reg->ctrl_status) &
-			    CSRX_ISP_SOFT_RESET) == 0)
-				break;
-
-			udelay(10);
-		}
-		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
-		RD_REG_DWORD(&reg->hccr);             /* PCI Posting. */
-	}
-
-	for (cnt = 30000; RD_REG_WORD(&reg->mailbox0) != 0 &&
-	    rval == QLA_SUCCESS; cnt--) {
-		if (cnt)
-			udelay(100);
-		else
-			rval = QLA_FUNCTION_TIMEOUT;
-	}
-
-	if (rval == QLA_SUCCESS)
-		rval = qla2xxx_dump_memory(ha, fw->code_ram,
-		    sizeof(fw->code_ram), fw->ext_mem, &nxt);
-
-	if (rval == QLA_SUCCESS) {
-		nxt = qla2xxx_copy_queues(ha, nxt);
-		if (ha->eft)
-			memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
-	}
-
+	rval = qla24xx_pause_risc(reg);
+	if (rval != QLA_SUCCESS)
+		goto qla25xx_fw_dump_failed_0;
+
+	/* Host interface registers. */
+	dmp_reg = &reg->flash_addr;
+	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
+		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
+
+	/* Disable interrupts. */
+	WRT_REG_DWORD(&reg->ictrl, 0);
+	RD_REG_DWORD(&reg->ictrl);
+
+	/* Shadow registers. */
+	WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
+	RD_REG_DWORD(&reg->iobase_addr);
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
+	fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
+	fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
+	fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
+	fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
+	fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
+	fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
+	fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0700000);
+	fw->shadow_reg[7] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0800000);
+	fw->shadow_reg[8] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0900000);
+	fw->shadow_reg[9] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0A00000);
+	fw->shadow_reg[10] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	/* RISC I/O register. */
+	WRT_REG_DWORD(&reg->iobase_addr, 0x0010);
+	fw->risc_io_reg = htonl(RD_REG_DWORD(&reg->iobase_window));
+
+	/* Mailbox registers. */
+	mbx_reg = &reg->mailbox0;
+	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
+		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg++));
+
+	/* Transfer sequence registers. */
+	iter_reg = fw->xseq_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0xBF00, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF10, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF20, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF30, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF40, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF50, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF60, 16, iter_reg);
+	qla24xx_read_window(reg, 0xBF70, 16, iter_reg);
+
+	iter_reg = fw->xseq_0_reg;
+	iter_reg = qla24xx_read_window(reg, 0xBFC0, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBFD0, 16, iter_reg);
+	qla24xx_read_window(reg, 0xBFE0, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0xBFF0, 16, fw->xseq_1_reg);
+
+	/* Receive sequence registers. */
+	iter_reg = fw->rseq_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0xFF00, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF10, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF20, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF30, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF40, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF50, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF60, 16, iter_reg);
+	qla24xx_read_window(reg, 0xFF70, 16, iter_reg);
+
+	iter_reg = fw->rseq_0_reg;
+	iter_reg = qla24xx_read_window(reg, 0xFFC0, 16, iter_reg);
+	qla24xx_read_window(reg, 0xFFD0, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0xFFE0, 16, fw->rseq_1_reg);
+	qla24xx_read_window(reg, 0xFFF0, 16, fw->rseq_2_reg);
+
+	/* Auxiliary sequence registers. */
+	iter_reg = fw->aseq_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0xB000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB050, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB060, 16, iter_reg);
+	qla24xx_read_window(reg, 0xB070, 16, iter_reg);
+
+	iter_reg = fw->aseq_0_reg;
+	iter_reg = qla24xx_read_window(reg, 0xB0C0, 16, iter_reg);
+	qla24xx_read_window(reg, 0xB0D0, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0xB0E0, 16, fw->aseq_1_reg);
+	qla24xx_read_window(reg, 0xB0F0, 16, fw->aseq_2_reg);
+
+	/* Command DMA registers. */
+	qla24xx_read_window(reg, 0x7100, 16, fw->cmd_dma_reg);
+
+	/* Queues. */
+	iter_reg = fw->req0_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7200, 8, iter_reg);
+	dmp_reg = &reg->iobase_q;
+	for (cnt = 0; cnt < 7; cnt++)
+		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+	iter_reg = fw->resp0_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7300, 8, iter_reg);
+	dmp_reg = &reg->iobase_q;
+	for (cnt = 0; cnt < 7; cnt++)
+		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+	iter_reg = fw->req1_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7400, 8, iter_reg);
+	dmp_reg = &reg->iobase_q;
+	for (cnt = 0; cnt < 7; cnt++)
+		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+	/* Transmit DMA registers. */
+	iter_reg = fw->xmt0_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7600, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7610, 16, iter_reg);
+
+	iter_reg = fw->xmt1_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7620, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7630, 16, iter_reg);
+
+	iter_reg = fw->xmt2_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7640, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7650, 16, iter_reg);
+
+	iter_reg = fw->xmt3_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7660, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7670, 16, iter_reg);
+
+	iter_reg = fw->xmt4_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7680, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7690, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0x76A0, 16, fw->xmt_data_dma_reg);
+
+	/* Receive DMA registers. */
+	iter_reg = fw->rcvt0_data_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7700, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7710, 16, iter_reg);
+
+	iter_reg = fw->rcvt1_data_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7720, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7730, 16, iter_reg);
+
+	/* RISC registers. */
+	iter_reg = fw->risc_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0x0F00, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F10, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F20, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F30, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F40, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F50, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F60, 16, iter_reg);
+	qla24xx_read_window(reg, 0x0F70, 16, iter_reg);
+
+	/* Local memory controller registers. */
+	iter_reg = fw->lmc_reg;
+	iter_reg = qla24xx_read_window(reg, 0x3000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3050, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3060, 16, iter_reg);
+	qla24xx_read_window(reg, 0x3070, 16, iter_reg);
+
+	/* Fibre Protocol Module registers. */
+	iter_reg = fw->fpm_hdw_reg;
+	iter_reg = qla24xx_read_window(reg, 0x4000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4050, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4060, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4070, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4080, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4090, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x40A0, 16, iter_reg);
+	qla24xx_read_window(reg, 0x40B0, 16, iter_reg);
+
+	/* Frame Buffer registers. */
+	iter_reg = fw->fb_hdw_reg;
+	iter_reg = qla24xx_read_window(reg, 0x6000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6100, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6130, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6150, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6170, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6190, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x61B0, 16, iter_reg);
+	qla24xx_read_window(reg, 0x6F00, 16, iter_reg);
+
+	rval = qla24xx_soft_reset(ha);
+	if (rval != QLA_SUCCESS)
+		goto qla25xx_fw_dump_failed_0;
+
+	rval = qla24xx_dump_memory(ha, fw->code_ram, sizeof(fw->code_ram),
+	    fw->ext_mem, &nxt);
+	if (rval != QLA_SUCCESS)
+		goto qla25xx_fw_dump_failed_0;
+
+	nxt = qla2xxx_copy_queues(ha, nxt);
+	if (ha->eft)
+		memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
+
+qla25xx_fw_dump_failed_0:
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to dump firmware (%x)!!!\n", rval);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c196486..4af0856 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -316,7 +316,9 @@ struct device_reg_2xxx {
 	} u;
 
 	uint16_t fpm_diag_config;
-	uint16_t unused_5[0x6];		/* Gap */
+	uint16_t unused_5[0x4];		/* Gap */
+	uint16_t risc_hw;
+	uint16_t unused_5_1;		/* Gap */
 	uint16_t pcr;			/* Processor Control Register. */
 	uint16_t unused_6[0x5];		/* Gap */
 	uint16_t mctr;			/* Memory Configuration and Timing. */
-- 
1.5.3.2.80.g077d6f
