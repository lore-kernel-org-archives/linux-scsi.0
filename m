From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/11]  qla2xxx: Add ISP24xx diagnostic routines.
Date: Mon, 13 Jun 2005 22:31:46 -0700 (PDT)
Message-ID: <20050614053146.12127.57434.sendpatchset@plap.qlogic.com>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:43414 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261189AbVFNFbs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 01:31:48 -0400
In-Reply-To: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add ISP24xx diagnostic routines.

Add function and structure definitions for the ISP24xx
diagnostic firmware dump routines.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_dbg.c | 1194 ++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_dbg.h |   32 +
 drivers/scsi/qla2xxx/qla_gbl.h |    3 
 3 files changed, 1229 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -975,6 +975,1185 @@ qla_uprintf(char **uiter, char *fmt, ...
 	return (len);
 }
 
+
+void
+qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
+{
+	int		rval;
+	uint32_t	cnt, timer;
+	uint32_t	risc_address;
+	uint16_t	mb[4];
+
+	uint32_t	stat;
+	struct device_reg_24xx __iomem *reg;
+	uint32_t __iomem *dmp_reg;
+	uint32_t	*iter_reg;
+	uint16_t __iomem *mbx_reg;
+	unsigned long	flags;
+	struct qla24xx_fw_dump *fw;
+	uint32_t	ext_mem_cnt;
+
+	reg = (struct device_reg_24xx __iomem *)ha->iobase;
+	risc_address = ext_mem_cnt = 0;
+	memset(mb, 0, sizeof(mb));
+	flags = 0;
+
+	if (!hardware_locked)
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	if (!ha->fw_dump24) {
+		qla_printk(KERN_WARNING, ha,
+		    "No buffer available for dump!!!\n");
+		goto qla24xx_fw_dump_failed;
+	}
+
+	if (ha->fw_dumped) {
+		qla_printk(KERN_WARNING, ha,
+		    "Firmware has been previously dumped (%p) -- ignoring "
+		    "request...\n", ha->fw_dump24);
+		goto qla24xx_fw_dump_failed;
+	}
+	fw = (struct qla24xx_fw_dump *) ha->fw_dump24;
+
+	rval = QLA_SUCCESS;
+	fw->hccr = RD_REG_DWORD(&reg->hccr);
+
+	/* Pause RISC. */
+	if ((fw->hccr & HCCRX_RISC_PAUSE) == 0) {
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
+	/* Disable interrupts. */
+	WRT_REG_DWORD(&reg->ictrl, 0);
+	RD_REG_DWORD(&reg->ictrl);
+
+	if (rval == QLA_SUCCESS) {
+		/* Host interface registers. */
+		dmp_reg = (uint32_t __iomem *)(reg + 0);
+		for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
+			fw->host_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+
+		/* Mailbox registers. */
+		mbx_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
+		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
+			fw->mailbox_reg[cnt] = RD_REG_WORD(mbx_reg++);
+
+		/* Transfer sequence registers. */
+		iter_reg = fw->xseq_gp_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF00);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF10);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF20);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF30);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF40);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF50);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF60);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF70);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBFE0);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < sizeof(fw->xseq_0_reg) / 4; cnt++)
+			fw->xseq_0_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBFF0);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < sizeof(fw->xseq_1_reg) / 4; cnt++)
+			fw->xseq_1_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+
+		/* Receive sequence registers. */
+		iter_reg = fw->rseq_gp_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF00);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF10);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF20);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF30);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF40);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF50);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF60);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF70);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFFD0);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < sizeof(fw->rseq_0_reg) / 4; cnt++)
+			fw->rseq_0_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFFE0);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < sizeof(fw->rseq_1_reg) / 4; cnt++)
+			fw->rseq_1_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFFF0);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < sizeof(fw->rseq_2_reg) / 4; cnt++)
+			fw->rseq_2_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+
+		/* Command DMA registers. */
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7100);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < sizeof(fw->cmd_dma_reg) / 4; cnt++)
+			fw->cmd_dma_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+
+		/* Queues. */
+		iter_reg = fw->req0_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7200);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 8; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xE4);
+		for (cnt = 0; cnt < 7; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		iter_reg = fw->resp0_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7300);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 8; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xE4);
+		for (cnt = 0; cnt < 7; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		iter_reg = fw->req1_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7400);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 8; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xE4);
+		for (cnt = 0; cnt < 7; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		/* Transmit DMA registers. */
+		iter_reg = fw->xmt0_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7600);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7610);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		iter_reg = fw->xmt1_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7620);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7630);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		iter_reg = fw->xmt2_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7640);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7650);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		iter_reg = fw->xmt3_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7660);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7670);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		iter_reg = fw->xmt4_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7680);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7690);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x76A0);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < sizeof(fw->xmt_data_dma_reg) / 4; cnt++)
+			fw->xmt_data_dma_reg[cnt] = RD_REG_DWORD(dmp_reg++);
+
+		/* Receive DMA registers. */
+		iter_reg = fw->rcvt0_data_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7700);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7710);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		iter_reg = fw->rcvt1_data_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7720);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7730);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		/* RISC registers. */
+		iter_reg = fw->risc_gp_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F00);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F10);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F20);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F30);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F40);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F50);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F60);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
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
+		dmp_reg = (uint32_t *)((uint8_t *)reg + 0xFC);
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
+		/* Local memory controller registers. */
+		iter_reg = fw->lmc_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3000);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3010);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3020);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3030);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3040);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3050);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3060);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		/* Fibre Protocol Module registers. */
+		iter_reg = fw->fpm_hdw_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4000);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4010);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4020);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4030);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4040);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4050);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4060);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4070);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4080);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4090);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x40A0);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x40B0);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		/* Frame Buffer registers. */
+		iter_reg = fw->fb_hdw_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6000);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6010);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6020);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6030);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6040);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6100);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6130);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6150);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6170);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6190);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x61B0);
+		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = RD_REG_DWORD(dmp_reg++);
+
+		/* Reset RISC. */
+		WRT_REG_DWORD(&reg->ctrl_status,
+		    CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+		for (cnt = 0; cnt < 30000; cnt++) {
+			if ((RD_REG_DWORD(&reg->ctrl_status) &
+			    CSRX_DMA_ACTIVE) == 0)
+				break;
+
+			udelay(10);
+		}
+
+		WRT_REG_DWORD(&reg->ctrl_status,
+		    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
+		udelay(20);
+		for (cnt = 0; cnt < 30000; cnt++) {
+			if ((RD_REG_DWORD(&reg->ctrl_status) &
+			    CSRX_ISP_SOFT_RESET) == 0)
+				break;
+
+			udelay(10);
+		}
+		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
+		RD_REG_DWORD(&reg->hccr);             /* PCI Posting. */
+	}
+
+	for (cnt = 30000; RD_REG_WORD(&reg->mailbox0) != 0 &&
+	    rval == QLA_SUCCESS; cnt--) {
+		if (cnt)
+			udelay(100);
+		else
+			rval = QLA_FUNCTION_TIMEOUT;
+	}
+
+	/* Memory. */
+	if (rval == QLA_SUCCESS) {
+		/* Code RAM. */
+		risc_address = 0x20000;
+		WRT_REG_WORD(&reg->mailbox0, MBC_READ_RAM_EXTENDED);
+		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+	}
+	for (cnt = 0; cnt < sizeof(fw->code_ram) / 4 && rval == QLA_SUCCESS;
+	    cnt++, risc_address++) {
+		WRT_REG_WORD(&reg->mailbox1, LSW(risc_address));
+		WRT_REG_WORD(&reg->mailbox8, MSW(risc_address));
+		RD_REG_WORD(&reg->mailbox8);
+		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_HOST_INT);
+
+		for (timer = 6000000; timer; timer--) {
+			/* Check for pending interrupts. */
+			stat = RD_REG_DWORD(&reg->host_status);
+			if (stat & HSRX_RISC_INT) {
+				stat &= 0xff;
+
+				if (stat == 0x1 || stat == 0x2 ||
+				    stat == 0x10 || stat == 0x11) {
+					set_bit(MBX_INTERRUPT,
+					    &ha->mbx_cmd_flags);
+
+					mb[0] = RD_REG_WORD(&reg->mailbox0);
+					mb[2] = RD_REG_WORD(&reg->mailbox2);
+					mb[3] = RD_REG_WORD(&reg->mailbox3);
+
+					WRT_REG_DWORD(&reg->hccr,
+					    HCCRX_CLR_RISC_INT);
+					RD_REG_DWORD(&reg->hccr);
+					break;
+				}
+
+				/* Clear this intr; it wasn't a mailbox intr */
+				WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+				RD_REG_DWORD(&reg->hccr);
+			}
+			udelay(5);
+		}
+
+		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
+			rval = mb[0] & MBS_MASK;
+			fw->code_ram[cnt] = (mb[3] << 16) | mb[2];
+		} else {
+			rval = QLA_FUNCTION_FAILED;
+		}
+	}
+
+	if (rval == QLA_SUCCESS) {
+		/* External Memory. */
+		risc_address = 0x100000;
+		ext_mem_cnt = ha->fw_memory_size - 0x100000 + 1;
+		WRT_REG_WORD(&reg->mailbox0, MBC_READ_RAM_EXTENDED);
+		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+	}
+	for (cnt = 0; cnt < ext_mem_cnt && rval == QLA_SUCCESS;
+	    cnt++, risc_address++) {
+		WRT_REG_WORD(&reg->mailbox1, LSW(risc_address));
+		WRT_REG_WORD(&reg->mailbox8, MSW(risc_address));
+		RD_REG_WORD(&reg->mailbox8);
+		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_HOST_INT);
+
+		for (timer = 6000000; timer; timer--) {
+			/* Check for pending interrupts. */
+			stat = RD_REG_DWORD(&reg->host_status);
+			if (stat & HSRX_RISC_INT) {
+				stat &= 0xff;
+
+				if (stat == 0x1 || stat == 0x2 ||
+				    stat == 0x10 || stat == 0x11) {
+					set_bit(MBX_INTERRUPT,
+					    &ha->mbx_cmd_flags);
+
+					mb[0] = RD_REG_WORD(&reg->mailbox0);
+					mb[2] = RD_REG_WORD(&reg->mailbox2);
+					mb[3] = RD_REG_WORD(&reg->mailbox3);
+
+					WRT_REG_DWORD(&reg->hccr,
+					    HCCRX_CLR_RISC_INT);
+					RD_REG_DWORD(&reg->hccr);
+					break;
+				}
+
+				/* Clear this intr; it wasn't a mailbox intr */
+				WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+				RD_REG_DWORD(&reg->hccr);
+			}
+			udelay(5);
+		}
+
+		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
+			rval = mb[0] & MBS_MASK;
+			fw->ext_mem[cnt] = (mb[3] << 16) | mb[2];
+		} else {
+			rval = QLA_FUNCTION_FAILED;
+		}
+	}
+
+	if (rval != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "Failed to dump firmware (%x)!!!\n", rval);
+		ha->fw_dumped = 0;
+
+	} else {
+		qla_printk(KERN_INFO, ha,
+		    "Firmware dump saved to temp buffer (%ld/%p).\n",
+		    ha->host_no, ha->fw_dump24);
+		ha->fw_dumped = 1;
+	}
+
+qla24xx_fw_dump_failed:
+	if (!hardware_locked)
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+void
+qla24xx_ascii_fw_dump(scsi_qla_host_t *ha)
+{
+	uint32_t cnt;
+	char *uiter;
+	struct qla24xx_fw_dump *fw;
+	uint32_t ext_mem_cnt;
+
+	uiter = ha->fw_dump_buffer;
+	fw = ha->fw_dump24;
+
+	qla_uprintf(&uiter, "ISP FW Version %d.%02d.%02d Attributes %04x\n",
+	    ha->fw_major_version, ha->fw_minor_version,
+	    ha->fw_subminor_version, ha->fw_attributes);
+
+	qla_uprintf(&uiter, "\nHCCR Register\n%04x\n", fw->hccr);
+
+	qla_uprintf(&uiter, "\nHost Interface Registers");
+	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->host_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nMailbox Registers");
+	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->mailbox_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nXSEQ GP Registers");
+	for (cnt = 0; cnt < sizeof(fw->xseq_gp_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->xseq_gp_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nXSEQ-0 Registers");
+	for (cnt = 0; cnt < sizeof(fw->xseq_0_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->xseq_0_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nXSEQ-1 Registers");
+	for (cnt = 0; cnt < sizeof(fw->xseq_1_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->xseq_1_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nRSEQ GP Registers");
+	for (cnt = 0; cnt < sizeof(fw->rseq_gp_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->rseq_gp_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nRSEQ-0 Registers");
+	for (cnt = 0; cnt < sizeof(fw->rseq_0_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->rseq_0_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nRSEQ-1 Registers");
+	for (cnt = 0; cnt < sizeof(fw->rseq_1_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->rseq_1_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nRSEQ-2 Registers");
+	for (cnt = 0; cnt < sizeof(fw->rseq_2_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->rseq_2_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nCommand DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->cmd_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->cmd_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nRequest0 Queue DMA Channel Registers");
+	for (cnt = 0; cnt < sizeof(fw->req0_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->req0_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nResponse0 Queue DMA Channel Registers");
+	for (cnt = 0; cnt < sizeof(fw->resp0_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->resp0_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nRequest1 Queue DMA Channel Registers");
+	for (cnt = 0; cnt < sizeof(fw->req1_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->req1_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nXMT0 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt0_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->xmt0_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nXMT1 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt1_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->xmt1_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nXMT2 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt2_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->xmt2_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nXMT3 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt3_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->xmt3_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nXMT4 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt4_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->xmt4_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nXMT Data DMA Common Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt_data_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->xmt_data_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nRCV Thread 0 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->rcvt0_data_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->rcvt0_data_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nRCV Thread 1 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->rcvt1_data_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->rcvt1_data_dma_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nRISC GP Registers");
+	for (cnt = 0; cnt < sizeof(fw->risc_gp_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->risc_gp_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nShadow Registers");
+	for (cnt = 0; cnt < sizeof(fw->shadow_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->shadow_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nLMC Registers");
+	for (cnt = 0; cnt < sizeof(fw->lmc_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->lmc_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nFPM Hardware Registers");
+	for (cnt = 0; cnt < sizeof(fw->fpm_hdw_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->fpm_hdw_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nFB Hardware Registers");
+	for (cnt = 0; cnt < sizeof(fw->fb_hdw_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			qla_uprintf(&uiter, "\n");
+
+		qla_uprintf(&uiter, "%08x ", fw->fb_hdw_reg[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nCode RAM");
+	for (cnt = 0; cnt < sizeof (fw->code_ram) / 4; cnt++) {
+		if (cnt % 8 == 0) {
+			qla_uprintf(&uiter, "\n%08x: ", cnt + 0x20000);
+		}
+		qla_uprintf(&uiter, "%08x ", fw->code_ram[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n\nExternal Memory");
+	ext_mem_cnt = ha->fw_memory_size - 0x100000 + 1;
+	for (cnt = 0; cnt < ext_mem_cnt; cnt++) {
+		if (cnt % 8 == 0) {
+			qla_uprintf(&uiter, "\n%08x: ", cnt + 0x100000);
+		}
+		qla_uprintf(&uiter, "%08x ", fw->ext_mem[cnt]);
+	}
+
+	qla_uprintf(&uiter, "\n[<==END] ISP Debug Dump");
+}
+
+void
+qla24xx_console_fw_dump(scsi_qla_host_t *ha)
+{
+	uint32_t cnt;
+	char *uiter;
+	struct qla24xx_fw_dump *fw;
+	uint32_t ext_mem_cnt;
+
+	uiter = ha->fw_dump_buffer;
+	fw = ha->fw_dump24;
+
+	printk("ISP FW Version %d.%02d.%02d Attributes %04x\n",
+	    ha->fw_major_version, ha->fw_minor_version,
+	    ha->fw_subminor_version, ha->fw_attributes);
+
+	printk("\nHCCR Register\n%04x\n", fw->hccr);
+
+	printk("\nHost Interface Registers");
+	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->host_reg[cnt]);
+	}
+
+	printk("\n\nMailbox Registers");
+	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->mailbox_reg[cnt]);
+	}
+
+	printk("\n\nXSEQ GP Registers");
+	for (cnt = 0; cnt < sizeof(fw->xseq_gp_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->xseq_gp_reg[cnt]);
+	}
+
+	printk("\n\nXSEQ-0 Registers");
+	for (cnt = 0; cnt < sizeof(fw->xseq_0_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->xseq_0_reg[cnt]);
+	}
+
+	printk("\n\nXSEQ-1 Registers");
+	for (cnt = 0; cnt < sizeof(fw->xseq_1_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->xseq_1_reg[cnt]);
+	}
+
+	printk("\n\nRSEQ GP Registers");
+	for (cnt = 0; cnt < sizeof(fw->rseq_gp_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->rseq_gp_reg[cnt]);
+	}
+
+	printk("\n\nRSEQ-0 Registers");
+	for (cnt = 0; cnt < sizeof(fw->rseq_0_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->rseq_0_reg[cnt]);
+	}
+
+	printk("\n\nRSEQ-1 Registers");
+	for (cnt = 0; cnt < sizeof(fw->rseq_1_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->rseq_1_reg[cnt]);
+	}
+
+	printk("\n\nRSEQ-2 Registers");
+	for (cnt = 0; cnt < sizeof(fw->rseq_2_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->rseq_2_reg[cnt]);
+	}
+
+	printk("\n\nCommand DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->cmd_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->cmd_dma_reg[cnt]);
+	}
+
+	printk("\n\nRequest0 Queue DMA Channel Registers");
+	for (cnt = 0; cnt < sizeof(fw->req0_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->req0_dma_reg[cnt]);
+	}
+
+	printk("\n\nResponse0 Queue DMA Channel Registers");
+	for (cnt = 0; cnt < sizeof(fw->resp0_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->resp0_dma_reg[cnt]);
+	}
+
+	printk("\n\nRequest1 Queue DMA Channel Registers");
+	for (cnt = 0; cnt < sizeof(fw->req1_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->req1_dma_reg[cnt]);
+	}
+
+	printk("\n\nXMT0 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt0_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->xmt0_dma_reg[cnt]);
+	}
+
+	printk("\n\nXMT1 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt1_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->xmt1_dma_reg[cnt]);
+	}
+
+	printk("\n\nXMT2 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt2_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->xmt2_dma_reg[cnt]);
+	}
+
+	printk("\n\nXMT3 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt3_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->xmt3_dma_reg[cnt]);
+	}
+
+	printk("\n\nXMT4 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt4_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->xmt4_dma_reg[cnt]);
+	}
+
+	printk("\n\nXMT Data DMA Common Registers");
+	for (cnt = 0; cnt < sizeof(fw->xmt_data_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->xmt_data_dma_reg[cnt]);
+	}
+
+	printk("\n\nRCV Thread 0 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->rcvt0_data_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->rcvt0_data_dma_reg[cnt]);
+	}
+
+	printk("\n\nRCV Thread 1 Data DMA Registers");
+	for (cnt = 0; cnt < sizeof(fw->rcvt1_data_dma_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->rcvt1_data_dma_reg[cnt]);
+	}
+
+	printk("\n\nRISC GP Registers");
+	for (cnt = 0; cnt < sizeof(fw->risc_gp_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->risc_gp_reg[cnt]);
+	}
+
+	printk("\n\nShadow Registers");
+	for (cnt = 0; cnt < sizeof(fw->shadow_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->shadow_reg[cnt]);
+	}
+
+	printk("\n\nLMC Registers");
+	for (cnt = 0; cnt < sizeof(fw->lmc_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->lmc_reg[cnt]);
+	}
+
+	printk("\n\nFPM Hardware Registers");
+	for (cnt = 0; cnt < sizeof(fw->fpm_hdw_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->fpm_hdw_reg[cnt]);
+	}
+
+	printk("\n\nFB Hardware Registers");
+	for (cnt = 0; cnt < sizeof(fw->fb_hdw_reg) / 4; cnt++) {
+		if (cnt % 8 == 0)
+			printk("\n");
+
+		printk("%08x ", fw->fb_hdw_reg[cnt]);
+	}
+
+	printk("\n\nCode RAM");
+	for (cnt = 0; cnt < sizeof (fw->code_ram) / 4; cnt++) {
+		if (cnt % 8 == 0) {
+			printk("\n%08x: ", cnt + 0x20000);
+		}
+		printk("%08x ", fw->code_ram[cnt]);
+	}
+
+	printk("\n\nExternal Memory");
+	ext_mem_cnt = ha->fw_memory_size - 0x100000 + 1;
+	for (cnt = 0; cnt < ext_mem_cnt; cnt++) {
+		if (cnt % 8 == 0) {
+			printk("\n%08x: ", cnt + 0x100000);
+		}
+		printk("%08x ", fw->ext_mem[cnt]);
+	}
+
+	printk("\n[<==END] ISP Debug Dump");
+}
+
 //FIXME
 
 /****************************************************************************/
@@ -1066,6 +2245,21 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd 
 	printk("  state=%d\n", sp->state);
 }
 
+void
+qla2x00_dump_pkt(void *pkt)
+{
+	uint32_t i;
+	uint8_t *data = (uint8_t *) pkt;
+
+	for (i = 0; i < 64; i++) {
+		if (!(i % 4))
+			printk("\n%02x: ", i);
+
+		printk("%02x ", data[i]);
+	}
+	printk("\n");
+}
+
 #if defined(QL_DEBUG_ROUTINES)
 /*
  * qla2x00_formatted_dump_buffer
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -230,4 +230,36 @@ struct qla2100_fw_dump {
 	uint16_t risc_ram[0xf000];
 };
 
+#define FW_DUMP_SIZE_24XX	0x2B0000
 
+struct qla24xx_fw_dump {
+	uint32_t hccr;
+	uint32_t host_reg[32];
+	uint16_t mailbox_reg[32];
+	uint32_t xseq_gp_reg[128];
+	uint32_t xseq_0_reg[16];
+	uint32_t xseq_1_reg[16];
+	uint32_t rseq_gp_reg[128];
+	uint32_t rseq_0_reg[16];
+	uint32_t rseq_1_reg[16];
+	uint32_t rseq_2_reg[16];
+	uint32_t cmd_dma_reg[16];
+	uint32_t req0_dma_reg[15];
+	uint32_t resp0_dma_reg[15];
+	uint32_t req1_dma_reg[15];
+	uint32_t xmt0_dma_reg[32];
+	uint32_t xmt1_dma_reg[32];
+	uint32_t xmt2_dma_reg[32];
+	uint32_t xmt3_dma_reg[32];
+	uint32_t xmt4_dma_reg[32];
+	uint32_t xmt_data_dma_reg[16];
+	uint32_t rcvt0_data_dma_reg[32];
+	uint32_t rcvt1_data_dma_reg[32];
+	uint32_t risc_gp_reg[128];
+	uint32_t shadow_reg[7];
+	uint32_t lmc_reg[112];
+	uint32_t fpm_hdw_reg[192];
+	uint32_t fb_hdw_reg[176];
+	uint32_t code_ram[0x2000];
+	uint32_t ext_mem[1];
+};
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -198,11 +198,14 @@ extern void qla2x00_write_nvram_word(scs
  */
 extern void qla2100_fw_dump(scsi_qla_host_t *, int);
 extern void qla2300_fw_dump(scsi_qla_host_t *, int);
+extern void qla24xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla2100_ascii_fw_dump(scsi_qla_host_t *);
 extern void qla2300_ascii_fw_dump(scsi_qla_host_t *);
+extern void qla24xx_ascii_fw_dump(scsi_qla_host_t *);
 extern void qla2x00_dump_regs(scsi_qla_host_t *);
 extern void qla2x00_dump_buffer(uint8_t *, uint32_t);
 extern void qla2x00_print_scsi_cmd(struct scsi_cmnd *);
+extern void qla2x00_dump_pkt(void *);
 
 /*
  * Global Function Prototypes in qla_gs.c source file.
------------

-- 
Andrew Vasquez
