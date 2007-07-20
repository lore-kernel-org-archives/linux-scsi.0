From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 8/9 TAKE2] qla2xxx: Add ISP25XX support.
Date: Thu, 19 Jul 2007 20:37:34 -0700
Message-ID: <20070720033734.GB17293@plap.qlogic.org>
References: <20070719220456.GK4015@plap.qlogic.org> <11848827643315-git-send-email-andrew.vasquez@qlogic.com> <1184885633.3464.114.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5941 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbXGTDhm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 23:37:42 -0400
Content-Disposition: inline
In-Reply-To: <1184885633.3464.114.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

Large code-reuse from ISP24xx, consolidate RISC memory
extraction routines during firmware-dump.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

On Thu, 19 Jul 2007, James Bottomley wrote:

> Date: Thu, 19 Jul 2007 17:53:53 -0500
> From: James Bottomley <James.Bottomley@SteelEye.com>
> To: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>,
> 	Seokmann Ju <seokmann.ju@qlogic.com>
> Subject: Re: [PATCH 8/9] qla2xxx: Add ISP25XX support.
> Message-Id: <1184885633.3464.114.camel@localhost.localdomain>
> X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
> 
> On Thu, 2007-07-19 at 15:06 -0700, Andrew Vasquez wrote:
> > +		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
> > +		WRT_REG_DWORD(dmp_reg, 0xB0100000);
> > +		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
> > +		fw->shadow_reg[1] = htonl(RD_REG_DWORD(dmp_reg));
> 
> Repeating this horrible cast over and over again is really eye watering.
> 
> If you can't simply extend the struct device_reg_24xx as device_reg_25xx
> or something which seems more logical, what about 
> 
> uint32_t __iomem *mailbox_reg_select = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
> uint32_t __iomem *mailbox_reg_value = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);

There's definitely some more room for improvement in simplying the
routines further (more collapsing, etc.).  How's this for a start --
both 24xx and 25xx dump routines now use the appropriate
device_reg_24xx registers...

--
av

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 362353d..1612f92 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -206,7 +206,7 @@ static struct bin_attribute sysfs_optrom_attr = {
 		.name = "optrom",
 		.mode = S_IRUSR | S_IWUSR,
 	},
-	.size = OPTROM_SIZE_24XX,
+	.size = 0,
 	.read = qla2x00_sysfs_read_optrom,
 	.write = qla2x00_sysfs_write_optrom,
 };
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 996c47a..563d18f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -37,6 +37,121 @@ qla2xxx_copy_queues(scsi_qla_host_t *ha, void *ptr)
 	return ptr + (ha->response_q_length * sizeof(response_t));
 }
 
+static int
+qla2xxx_dump_memory(scsi_qla_host_t *ha, uint32_t *code_ram,
+    uint32_t cram_size, uint32_t *ext_mem, void **nxt)
+{
+	int rval;
+	uint32_t cnt, stat, timer, risc_address, ext_mem_cnt;
+	uint16_t mb[4];
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	rval = QLA_SUCCESS;
+	risc_address = ext_mem_cnt = 0;
+	memset(mb, 0, sizeof(mb));
+
+	/* Code RAM. */
+	risc_address = 0x20000;
+	WRT_REG_WORD(&reg->mailbox0, MBC_READ_RAM_EXTENDED);
+	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+
+	for (cnt = 0; cnt < cram_size / 4 && rval == QLA_SUCCESS;
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
+			code_ram[cnt] = htonl((mb[3] << 16) | mb[2]);
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
+			ext_mem[cnt] = htonl((mb[3] << 16) | mb[2]);
+		} else {
+			rval = QLA_FUNCTION_FAILED;
+		}
+	}
+
+	*nxt = rval == QLA_SUCCESS ? &ext_mem[cnt]: NULL;
+	return rval;
+}
+
 /**
  * qla2300_fw_dump() - Dumps binary data from the 2300 firmware.
  * @ha: HA context
@@ -633,11 +748,10 @@ void
 qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 {
 	int		rval;
-	uint32_t	cnt, timer;
+	uint32_t	cnt;
 	uint32_t	risc_address;
-	uint16_t	mb[4], wd;
+	uint16_t	mb0, wd;
 
-	uint32_t	stat;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t __iomem *dmp_reg;
 	uint32_t	*iter_reg;
@@ -645,10 +759,9 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	unsigned long	flags;
 	struct qla24xx_fw_dump *fw;
 	uint32_t	ext_mem_cnt;
-	void		*eft;
+	void		*nxt;
 
 	risc_address = ext_mem_cnt = 0;
-	memset(mb, 0, sizeof(mb));
 	flags = 0;
 
 	if (!hardware_locked)
@@ -701,250 +814,236 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 		/* Shadow registers. */
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
 		RD_REG_DWORD(&reg->iobase_addr);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0000000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[0] = htonl(RD_REG_DWORD(dmp_reg));
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0100000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[1] = htonl(RD_REG_DWORD(dmp_reg));
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0200000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[2] = htonl(RD_REG_DWORD(dmp_reg));
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0300000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[3] = htonl(RD_REG_DWORD(dmp_reg));
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0400000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[4] = htonl(RD_REG_DWORD(dmp_reg));
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0500000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[5] = htonl(RD_REG_DWORD(dmp_reg));
-
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xF0);
-		WRT_REG_DWORD(dmp_reg, 0xB0600000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xFC);
-		fw->shadow_reg[6] = htonl(RD_REG_DWORD(dmp_reg));
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
+		fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
+		fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
+		fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
+		fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
+		fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
+		fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
+		fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
 
 		/* Mailbox registers. */
-		mbx_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
+		mbx_reg = &reg->mailbox0;
 		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
 			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg++));
 
 		/* Transfer sequence registers. */
 		iter_reg = fw->xseq_gp_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF00);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF10);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF20);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF30);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF40);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF50);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF60);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBF70);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBFE0);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < sizeof(fw->xseq_0_reg) / 4; cnt++)
 			fw->xseq_0_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xBFF0);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < sizeof(fw->xseq_1_reg) / 4; cnt++)
 			fw->xseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Receive sequence registers. */
 		iter_reg = fw->rseq_gp_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF00);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF10);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF20);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF30);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF40);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF50);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF60);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFF70);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFFD0);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < sizeof(fw->rseq_0_reg) / 4; cnt++)
 			fw->rseq_0_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFFE0);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < sizeof(fw->rseq_1_reg) / 4; cnt++)
 			fw->rseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0xFFF0);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < sizeof(fw->rseq_2_reg) / 4; cnt++)
 			fw->rseq_2_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Command DMA registers. */
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7100);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < sizeof(fw->cmd_dma_reg) / 4; cnt++)
 			fw->cmd_dma_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Queues. */
 		iter_reg = fw->req0_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7200);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 8; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xE4);
+		dmp_reg = &reg->iobase_q;
 		for (cnt = 0; cnt < 7; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->resp0_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7300);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 8; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xE4);
+		dmp_reg = &reg->iobase_q;
 		for (cnt = 0; cnt < 7; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->req1_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7400);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 8; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xE4);
+		dmp_reg = &reg->iobase_q;
 		for (cnt = 0; cnt < 7; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Transmit DMA registers. */
 		iter_reg = fw->xmt0_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7600);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7610);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->xmt1_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7620);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7630);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->xmt2_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7640);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7650);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->xmt3_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7660);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7670);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->xmt4_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7680);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7690);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x76A0);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < sizeof(fw->xmt_data_dma_reg) / 4; cnt++)
 			fw->xmt_data_dma_reg[cnt] =
 			    htonl(RD_REG_DWORD(dmp_reg++));
@@ -952,221 +1051,221 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 		/* Receive DMA registers. */
 		iter_reg = fw->rcvt0_data_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7700);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7710);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		iter_reg = fw->rcvt1_data_dma_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7720);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x7730);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* RISC registers. */
 		iter_reg = fw->risc_gp_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F00);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F10);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F20);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F30);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F40);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F50);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F60);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Local memory controller registers. */
 		iter_reg = fw->lmc_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3010);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3020);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3030);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3040);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3050);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x3060);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Fibre Protocol Module registers. */
 		iter_reg = fw->fpm_hdw_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4010);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4020);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4030);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4040);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4050);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4060);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4070);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4080);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x4090);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x40A0);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x40B0);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		/* Frame Buffer registers. */
 		iter_reg = fw->fb_hdw_reg;
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6000);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6010);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6020);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6030);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6040);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6100);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6130);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6150);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6170);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x6190);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
 		WRT_REG_DWORD(&reg->iobase_addr, 0x61B0);
-		dmp_reg = (uint32_t __iomem *)((uint8_t __iomem *)reg + 0xC0);
+		dmp_reg = &reg->iobase_window;
 		for (cnt = 0; cnt < 16; cnt++)
 			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
 
@@ -1187,10 +1286,10 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 
 		udelay(100);
 		/* Wait for firmware to complete NVRAM accesses. */
-		mb[0] = (uint32_t) RD_REG_WORD(&reg->mailbox0);
-		for (cnt = 10000 ; cnt && mb[0]; cnt--) {
+		mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+		for (cnt = 10000 ; cnt && mb0; cnt--) {
 			udelay(5);
-			mb[0] = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+			mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
 			barrier();
 		}
 
@@ -1214,110 +1313,717 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 			rval = QLA_FUNCTION_TIMEOUT;
 	}
 
-	/* Memory. */
+	if (rval == QLA_SUCCESS)
+		rval = qla2xxx_dump_memory(ha, fw->code_ram,
+		    sizeof(fw->code_ram), fw->ext_mem, &nxt);
+
 	if (rval == QLA_SUCCESS) {
-		/* Code RAM. */
-		risc_address = 0x20000;
-		WRT_REG_WORD(&reg->mailbox0, MBC_READ_RAM_EXTENDED);
-		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+		nxt = qla2xxx_copy_queues(ha, nxt);
+		if (ha->eft)
+			memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
 	}
-	for (cnt = 0; cnt < sizeof(fw->code_ram) / 4 && rval == QLA_SUCCESS;
-	    cnt++, risc_address++) {
-		WRT_REG_WORD(&reg->mailbox1, LSW(risc_address));
-		WRT_REG_WORD(&reg->mailbox8, MSW(risc_address));
-		RD_REG_WORD(&reg->mailbox8);
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_HOST_INT);
 
-		for (timer = 6000000; timer; timer--) {
-			/* Check for pending interrupts. */
-			stat = RD_REG_DWORD(&reg->host_status);
-			if (stat & HSRX_RISC_INT) {
-				stat &= 0xff;
+	if (rval != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "Failed to dump firmware (%x)!!!\n", rval);
+		ha->fw_dumped = 0;
 
-				if (stat == 0x1 || stat == 0x2 ||
-				    stat == 0x10 || stat == 0x11) {
-					set_bit(MBX_INTERRUPT,
-					    &ha->mbx_cmd_flags);
+	} else {
+		qla_printk(KERN_INFO, ha,
+		    "Firmware dump saved to temp buffer (%ld/%p).\n",
+		    ha->host_no, ha->fw_dump);
+		ha->fw_dumped = 1;
+	}
 
-					mb[0] = RD_REG_WORD(&reg->mailbox0);
-					mb[2] = RD_REG_WORD(&reg->mailbox2);
-					mb[3] = RD_REG_WORD(&reg->mailbox3);
+qla24xx_fw_dump_failed:
+	if (!hardware_locked)
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
 
-					WRT_REG_DWORD(&reg->hccr,
-					    HCCRX_CLR_RISC_INT);
-					RD_REG_DWORD(&reg->hccr);
-					break;
-				}
+void
+qla25xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
+{
+	int		rval;
+	uint32_t	cnt;
+	uint32_t	risc_address;
+	uint16_t	mb0, wd;
 
-				/* Clear this intr; it wasn't a mailbox intr */
-				WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-				RD_REG_DWORD(&reg->hccr);
-			}
-			udelay(5);
-		}
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	uint32_t __iomem *dmp_reg;
+	uint32_t	*iter_reg;
+	uint16_t __iomem *mbx_reg;
+	unsigned long	flags;
+	struct qla25xx_fw_dump *fw;
+	uint32_t	ext_mem_cnt;
+	void		*nxt;
 
-		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
-			rval = mb[0] & MBS_MASK;
-			fw->code_ram[cnt] = htonl((mb[3] << 16) | mb[2]);
-		} else {
-			rval = QLA_FUNCTION_FAILED;
+	risc_address = ext_mem_cnt = 0;
+	flags = 0;
+
+	if (!hardware_locked)
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	if (!ha->fw_dump) {
+		qla_printk(KERN_WARNING, ha,
+		    "No buffer available for dump!!!\n");
+		goto qla25xx_fw_dump_failed;
+	}
+
+	if (ha->fw_dumped) {
+		qla_printk(KERN_WARNING, ha,
+		    "Firmware has been previously dumped (%p) -- ignoring "
+		    "request...\n", ha->fw_dump);
+		goto qla25xx_fw_dump_failed;
+	}
+	fw = &ha->fw_dump->isp.isp25;
+	qla2xxx_prep_dump(ha, ha->fw_dump);
+
+	rval = QLA_SUCCESS;
+	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
+
+	/* Pause RISC. */
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
 		}
 	}
 
 	if (rval == QLA_SUCCESS) {
-		/* External Memory. */
-		risc_address = 0x100000;
-		ext_mem_cnt = ha->fw_memory_size - 0x100000 + 1;
-		WRT_REG_WORD(&reg->mailbox0, MBC_READ_RAM_EXTENDED);
-		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-	}
-	for (cnt = 0; cnt < ext_mem_cnt && rval == QLA_SUCCESS;
-	    cnt++, risc_address++) {
-		WRT_REG_WORD(&reg->mailbox1, LSW(risc_address));
-		WRT_REG_WORD(&reg->mailbox8, MSW(risc_address));
-		RD_REG_WORD(&reg->mailbox8);
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_HOST_INT);
+		/* Host interface registers. */
+		dmp_reg = (uint32_t __iomem *)(reg + 0);
+		for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
+			fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
 
-		for (timer = 6000000; timer; timer--) {
-			/* Check for pending interrupts. */
-			stat = RD_REG_DWORD(&reg->host_status);
-			if (stat & HSRX_RISC_INT) {
-				stat &= 0xff;
+		/* Disable interrupts. */
+		WRT_REG_DWORD(&reg->ictrl, 0);
+		RD_REG_DWORD(&reg->ictrl);
 
-				if (stat == 0x1 || stat == 0x2 ||
-				    stat == 0x10 || stat == 0x11) {
-					set_bit(MBX_INTERRUPT,
-					    &ha->mbx_cmd_flags);
+		/* Shadow registers. */
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
+		RD_REG_DWORD(&reg->iobase_addr);
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
+		fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
 
-					mb[0] = RD_REG_WORD(&reg->mailbox0);
-					mb[2] = RD_REG_WORD(&reg->mailbox2);
-					mb[3] = RD_REG_WORD(&reg->mailbox3);
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
+		fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
 
-					WRT_REG_DWORD(&reg->hccr,
-					    HCCRX_CLR_RISC_INT);
-					RD_REG_DWORD(&reg->hccr);
-					break;
-				}
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
+		fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
 
-				/* Clear this intr; it wasn't a mailbox intr */
-				WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-				RD_REG_DWORD(&reg->hccr);
-			}
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
+		fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
+		fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
+		fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
+		fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0700000);
+		fw->shadow_reg[7] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0800000);
+		fw->shadow_reg[8] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0900000);
+		fw->shadow_reg[9] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		WRT_REG_DWORD(&reg->iobase_select, 0xB0A00000);
+		fw->shadow_reg[10] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+		/* RISC I/O register. */
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0010);
+		RD_REG_DWORD(&reg->iobase_addr);
+		fw->risc_io_reg = htonl(RD_REG_DWORD(&reg->iobase_window));
+
+		/* Mailbox registers. */
+		mbx_reg = &reg->mailbox0;
+		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
+			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg++));
+
+		/* Transfer sequence registers. */
+		iter_reg = fw->xseq_gp_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF00);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF10);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF20);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF30);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF40);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF50);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF60);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBF70);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		iter_reg = fw->xseq_0_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBFC0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBFD0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBFE0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xBFF0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < sizeof(fw->xseq_1_reg) / 4; cnt++)
+			fw->xseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
+
+		/* Receive sequence registers. */
+		iter_reg = fw->rseq_gp_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF00);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF10);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF20);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF30);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF40);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF50);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF60);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFF70);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		iter_reg = fw->rseq_0_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFFC0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFFD0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFFE0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < sizeof(fw->rseq_1_reg) / 4; cnt++)
+			fw->rseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xFFF0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < sizeof(fw->rseq_2_reg) / 4; cnt++)
+			fw->rseq_2_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
+
+		/* Auxiliary sequence registers. */
+		iter_reg = fw->aseq_gp_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB000);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB010);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB020);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB030);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB040);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB050);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB060);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB070);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		iter_reg = fw->aseq_0_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB0C0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB0D0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB0E0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < sizeof(fw->aseq_1_reg) / 4; cnt++)
+			fw->aseq_1_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0xB0F0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < sizeof(fw->aseq_2_reg) / 4; cnt++)
+			fw->aseq_2_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
+
+		/* Command DMA registers. */
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7100);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < sizeof(fw->cmd_dma_reg) / 4; cnt++)
+			fw->cmd_dma_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
+
+		/* Queues. */
+		iter_reg = fw->req0_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7200);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 8; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		dmp_reg = &reg->iobase_q;
+		for (cnt = 0; cnt < 7; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		iter_reg = fw->resp0_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7300);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 8; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		dmp_reg = &reg->iobase_q;
+		for (cnt = 0; cnt < 7; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		iter_reg = fw->req1_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7400);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 8; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		dmp_reg = &reg->iobase_q;
+		for (cnt = 0; cnt < 7; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		/* Transmit DMA registers. */
+		iter_reg = fw->xmt0_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7600);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7610);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		iter_reg = fw->xmt1_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7620);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7630);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		iter_reg = fw->xmt2_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7640);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7650);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		iter_reg = fw->xmt3_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7660);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7670);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		iter_reg = fw->xmt4_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7680);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7690);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x76A0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < sizeof(fw->xmt_data_dma_reg) / 4; cnt++)
+			fw->xmt_data_dma_reg[cnt] =
+			    htonl(RD_REG_DWORD(dmp_reg++));
+
+		/* Receive DMA registers. */
+		iter_reg = fw->rcvt0_data_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7700);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7710);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		iter_reg = fw->rcvt1_data_dma_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7720);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x7730);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		/* RISC registers. */
+		iter_reg = fw->risc_gp_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F00);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F10);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F20);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F30);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F40);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F50);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F60);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		/* Local memory controller registers. */
+		iter_reg = fw->lmc_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3000);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3010);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3020);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3030);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3040);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3050);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3060);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x3070);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		/* Fibre Protocol Module registers. */
+		iter_reg = fw->fpm_hdw_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4000);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4010);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4020);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4030);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4040);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4050);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4060);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4070);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4080);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x4090);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x40A0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x40B0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		/* Frame Buffer registers. */
+		iter_reg = fw->fb_hdw_reg;
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6000);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6010);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6020);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6030);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6040);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6100);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6130);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6150);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6170);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6190);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x61B0);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+		WRT_REG_DWORD(&reg->iobase_addr, 0x6F00);
+		dmp_reg = &reg->iobase_window;
+		for (cnt = 0; cnt < 16; cnt++)
+			*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
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
+		pci_read_config_word(ha->pdev, PCI_COMMAND, &wd);
+
+		udelay(100);
+		/* Wait for firmware to complete NVRAM accesses. */
+		mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+		for (cnt = 10000 ; cnt && mb0; cnt--) {
 			udelay(5);
+			mb0 = (uint32_t) RD_REG_WORD(&reg->mailbox0);
+			barrier();
 		}
 
-		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
-			rval = mb[0] & MBS_MASK;
-			fw->ext_mem[cnt] = htonl((mb[3] << 16) | mb[2]);
-		} else {
-			rval = QLA_FUNCTION_FAILED;
+		/* Wait for soft-reset to complete. */
+		for (cnt = 0; cnt < 30000; cnt++) {
+			if ((RD_REG_DWORD(&reg->ctrl_status) &
+			    CSRX_ISP_SOFT_RESET) == 0)
+				break;
+
+			udelay(10);
 		}
+		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_RESET);
+		RD_REG_DWORD(&reg->hccr);             /* PCI Posting. */
 	}
 
+	for (cnt = 30000; RD_REG_WORD(&reg->mailbox0) != 0 &&
+	    rval == QLA_SUCCESS; cnt--) {
+		if (cnt)
+			udelay(100);
+		else
+			rval = QLA_FUNCTION_TIMEOUT;
+	}
+
+	if (rval == QLA_SUCCESS)
+		rval = qla2xxx_dump_memory(ha, fw->code_ram,
+		    sizeof(fw->code_ram), fw->ext_mem, &nxt);
+
 	if (rval == QLA_SUCCESS) {
-		eft = qla2xxx_copy_queues(ha, &fw->ext_mem[cnt]);
+		nxt = qla2xxx_copy_queues(ha, nxt);
 		if (ha->eft)
-			memcpy(eft, ha->eft, ntohl(ha->fw_dump->eft_size));
+			memcpy(nxt, ha->eft, ntohl(ha->fw_dump->eft_size));
 	}
 
 	if (rval != QLA_SUCCESS) {
@@ -1332,7 +2038,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 		ha->fw_dumped = 1;
 	}
 
-qla24xx_fw_dump_failed:
+qla25xx_fw_dump_failed:
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 49dffeb..cca4b0d 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -213,6 +213,43 @@ struct qla24xx_fw_dump {
 	uint32_t ext_mem[1];
 };
 
+struct qla25xx_fw_dump {
+	uint32_t host_status;
+	uint32_t host_reg[32];
+	uint32_t shadow_reg[11];
+	uint32_t risc_io_reg;
+	uint16_t mailbox_reg[32];
+	uint32_t xseq_gp_reg[128];
+	uint32_t xseq_0_reg[48];
+	uint32_t xseq_1_reg[16];
+	uint32_t rseq_gp_reg[128];
+	uint32_t rseq_0_reg[32];
+	uint32_t rseq_1_reg[16];
+	uint32_t rseq_2_reg[16];
+	uint32_t aseq_gp_reg[128];
+	uint32_t aseq_0_reg[32];
+	uint32_t aseq_1_reg[16];
+	uint32_t aseq_2_reg[16];
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
+	uint32_t lmc_reg[128];
+	uint32_t fpm_hdw_reg[192];
+	uint32_t fb_hdw_reg[192];
+	uint32_t code_ram[0x2000];
+	uint32_t ext_mem[1];
+};
+
 #define EFT_NUM_BUFFERS		4
 #define EFT_BYTES_PER_BUFFER	0x4000
 #define EFT_SIZE		((EFT_BYTES_PER_BUFFER) * (EFT_NUM_BUFFERS))
@@ -246,5 +283,6 @@ struct qla2xxx_fw_dump {
 		struct qla2100_fw_dump isp21;
 		struct qla2300_fw_dump isp23;
 		struct qla24xx_fw_dump isp24;
+		struct qla25xx_fw_dump isp25;
 	} isp;
 };
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 27a2396..0c9f36c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2209,6 +2209,7 @@ typedef struct scsi_qla_host {
 #define	SWITCH_FOUND			BIT_3
 #define	DFLG_NO_CABLE			BIT_4
 
+#define PCI_DEVICE_ID_QLOGIC_ISP2532	0x2532
 	uint32_t	device_type;
 #define DT_ISP2100			BIT_0
 #define DT_ISP2200			BIT_1
@@ -2221,7 +2222,8 @@ typedef struct scsi_qla_host {
 #define DT_ISP2432			BIT_8
 #define DT_ISP5422			BIT_9
 #define DT_ISP5432			BIT_10
-#define DT_ISP_LAST			(DT_ISP5432 << 1)
+#define DT_ISP2532			BIT_11
+#define DT_ISP_LAST			(DT_ISP2532 << 1)
 
 #define DT_IIDMA			BIT_26
 #define DT_FWI2				BIT_27
@@ -2242,11 +2244,13 @@ typedef struct scsi_qla_host {
 #define IS_QLA2432(ha)	(DT_MASK(ha) & DT_ISP2432)
 #define IS_QLA5422(ha)	(DT_MASK(ha) & DT_ISP5422)
 #define IS_QLA5432(ha)	(DT_MASK(ha) & DT_ISP5432)
+#define IS_QLA2532(ha)	(DT_MASK(ha) & DT_ISP2532)
 
 #define IS_QLA23XX(ha)	(IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
     			 IS_QLA6312(ha) || IS_QLA6322(ha))
 #define IS_QLA24XX(ha)	(IS_QLA2422(ha) || IS_QLA2432(ha))
 #define IS_QLA54XX(ha)	(IS_QLA5422(ha) || IS_QLA5432(ha))
+#define IS_QLA25XX(ha)	(IS_QLA2532(ha))
 
 #define IS_IIDMA_CAPABLE(ha)	((ha)->device_type & DT_IIDMA)
 #define IS_FWI2_CAPABLE(ha)	((ha)->device_type & DT_FWI2)
@@ -2310,6 +2314,7 @@ typedef struct scsi_qla_host {
 #define PORT_SPEED_1GB	0x00
 #define PORT_SPEED_2GB	0x01
 #define PORT_SPEED_4GB	0x03
+#define PORT_SPEED_8GB	0x04
 	uint16_t	link_data_rate;		/* F/W operating speed */
 
 	uint8_t		current_topology;
@@ -2576,6 +2581,7 @@ typedef struct scsi_qla_host {
 #define OPTROM_SIZE_2300	0x20000
 #define OPTROM_SIZE_2322	0x100000
 #define OPTROM_SIZE_24XX	0x100000
+#define OPTROM_SIZE_25XX	0x200000
 
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 63a11fe..99fe496 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -8,14 +8,17 @@
 #define __QLA_FW_H
 
 #define MBS_CHECKSUM_ERROR	0x4010
+#define MBS_INVALID_PRODUCT_KEY	0x4020
 
 /*
  * Firmware Options.
  */
 #define FO1_ENABLE_PUREX	BIT_10
 #define FO1_DISABLE_LED_CTRL	BIT_6
+#define FO1_ENABLE_8016		BIT_0
 #define FO2_ENABLE_SEL_CLASS2	BIT_5
 #define FO3_NO_ABTS_ON_LINKDOWN	BIT_14
+#define FO3_HOLD_STS_IOCB	BIT_12
 
 /*
  * Port Database structure definition for ISP 24xx.
@@ -341,7 +344,9 @@ struct init_cb_24xx {
 	 * BIT 10 = Reserved
 	 * BIT 11 = Enable FC-SP Security
 	 * BIT 12 = FC Tape Enable
-	 * BIT 13-31 = Reserved
+	 * BIT 13 = Reserved
+	 * BIT 14 = Enable Target PRLI Control
+	 * BIT 15-31 = Reserved
 	 */
 	uint32_t firmware_options_2;
 
@@ -363,7 +368,8 @@ struct init_cb_24xx {
 	 * BIT 13 = Data Rate bit 0
 	 * BIT 14 = Data Rate bit 1
 	 * BIT 15 = Data Rate bit 2
-	 * BIT 16-31 = Reserved
+	 * BIT 16 = Enable 75 ohm Termination Select
+	 * BIT 17-31 = Reserved
 	 */
 	uint32_t firmware_options_3;
 
@@ -435,6 +441,7 @@ struct cmd_type_7 {
 #define TMF_LUN_RESET		BIT_12
 #define TMF_CLEAR_TASK_SET	BIT_10
 #define TMF_ABORT_TASK_SET	BIT_9
+#define TMF_DSD_LIST_ENABLE	BIT_2
 #define TMF_READ_DATA		BIT_1
 #define TMF_WRITE_DATA		BIT_0
 
@@ -589,7 +596,7 @@ struct els_entry_24xx {
 #define EST_SOFI3		(1 << 4)
 #define EST_SOFI2		(3 << 4)
 
-	uint32_t rx_xchg_address[2];	/* Receive exchange address. */
+	uint32_t rx_xchg_address;	/* Receive exchange address. */
 	uint16_t rx_dsd_count;
 
 	uint8_t opcode;
@@ -650,6 +657,7 @@ struct logio_entry_24xx {
 
 	uint16_t control_flags;		/* Control flags. */
 					/* Modifiers. */
+#define LCF_INCLUDE_SNS		BIT_10	/* Include SNS (FFFFFC) during LOGO. */
 #define LCF_FCP2_OVERRIDE	BIT_9	/* Set/Reset word 3 of PRLI. */
 #define LCF_CLASS_2		BIT_8	/* Enable class 2 during PLOGI. */
 #define LCF_FREE_NPORT		BIT_7	/* Release NPORT handle after LOGO. */
@@ -779,6 +787,15 @@ struct device_reg_24xx {
 #define FA_RISC_CODE_ADDR	0x20000
 #define FA_RISC_CODE_SEGMENTS	2
 
+#define FA_FW_AREA_ADDR		0x40000
+#define FA_VPD_NVRAM_ADDR	0x48000
+#define FA_FEATURE_ADDR		0x4C000
+#define FA_FLASH_DESCR_ADDR	0x50000
+#define FA_HW_EVENT_ADDR	0x54000
+#define FA_BOOT_LOG_ADDR	0x58000
+#define FA_FW_DUMP0_ADDR	0x60000
+#define FA_FW_DUMP1_ADDR	0x70000
+
 	uint32_t flash_data;		/* Flash/NVRAM BIOS data. */
 
 	uint32_t ctrl_status;		/* Control/Status. */
@@ -859,10 +876,13 @@ struct device_reg_24xx {
 #define HCCRX_CLR_RISC_INT	0xA0000000
 
 	uint32_t gpiod;			/* GPIO Data register. */
+
 					/* LED update mask. */
 #define GPDX_LED_UPDATE_MASK	(BIT_20|BIT_19|BIT_18)
 					/* Data update mask. */
 #define GPDX_DATA_UPDATE_MASK	(BIT_17|BIT_16)
+					/* Data update mask. */
+#define GPDX_DATA_UPDATE_2_MASK	(BIT_28|BIT_27|BIT_26|BIT_17|BIT_16)
 					/* LED control mask. */
 #define GPDX_LED_COLOR_MASK	(BIT_4|BIT_3|BIT_2)
 					/* LED bit values. Color names as
@@ -877,6 +897,8 @@ struct device_reg_24xx {
 	uint32_t gpioe;			/* GPIO Enable register. */
 					/* Enable update mask. */
 #define GPEX_ENABLE_UPDATE_MASK	(BIT_17|BIT_16)
+					/* Enable update mask. */
+#define GPEX_ENABLE_UPDATE_2_MASK (BIT_28|BIT_27|BIT_26|BIT_17|BIT_16)
 					/* Enable. */
 #define GPEX_ENABLE		(BIT_1|BIT_0)
 
@@ -916,6 +938,14 @@ struct device_reg_24xx {
 	uint16_t mailbox29;
 	uint16_t mailbox30;
 	uint16_t mailbox31;
+
+	uint32_t iobase_window;
+	uint32_t unused_4[8];		/* Gap. */
+	uint32_t iobase_q;
+	uint32_t unused_5[2];		/* Gap. */
+	uint32_t iobase_select;
+	uint32_t unused_6[2];		/* Gap. */
+	uint32_t iobase_sdata;
 };
 
 /* MID Support ***************************************************************/
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index b44eff2..aa1e411 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -17,6 +17,7 @@ extern int qla2x00_initialize_adapter(scsi_qla_host_t *);
 extern int qla2100_pci_config(struct scsi_qla_host *);
 extern int qla2300_pci_config(struct scsi_qla_host *);
 extern int qla24xx_pci_config(scsi_qla_host_t *);
+extern int qla25xx_pci_config(scsi_qla_host_t *);
 extern void qla2x00_reset_chip(struct scsi_qla_host *);
 extern void qla24xx_reset_chip(struct scsi_qla_host *);
 extern int qla2x00_chip_diag(struct scsi_qla_host *);
@@ -281,6 +282,10 @@ extern int qla2x00_write_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
     uint32_t);
 extern int qla24xx_write_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
     uint32_t);
+extern uint8_t *qla25xx_read_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
+    uint32_t);
+extern int qla25xx_write_nvram_data(scsi_qla_host_t *, uint8_t *, uint32_t,
+    uint32_t);
 
 extern int qla2x00_beacon_on(struct scsi_qla_host *);
 extern int qla2x00_beacon_off(struct scsi_qla_host *);
@@ -307,6 +312,7 @@ extern int qla24xx_get_flash_version(scsi_qla_host_t *, void *);
 extern void qla2100_fw_dump(scsi_qla_host_t *, int);
 extern void qla2300_fw_dump(scsi_qla_host_t *, int);
 extern void qla24xx_fw_dump(scsi_qla_host_t *, int);
+extern void qla25xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla2x00_dump_regs(scsi_qla_host_t *);
 extern void qla2x00_dump_buffer(uint8_t *, uint32_t);
 extern void qla2x00_print_scsi_cmd(struct scsi_cmnd *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index e393c84..b06cbb8 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1532,7 +1532,11 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
 	eiter->len = __constant_cpu_to_be16(4 + 4);
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+	if (IS_QLA25XX(ha))
+		eiter->a.sup_speed = __constant_cpu_to_be32(
+		    FDMI_PORT_SPEED_1GB|FDMI_PORT_SPEED_2GB|
+		    FDMI_PORT_SPEED_4GB|FDMI_PORT_SPEED_8GB);
+	else if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 		eiter->a.sup_speed = __constant_cpu_to_be32(
 		    FDMI_PORT_SPEED_1GB|FDMI_PORT_SPEED_2GB|
 		    FDMI_PORT_SPEED_4GB);
@@ -1564,6 +1568,10 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 		eiter->a.cur_speed =
 		    __constant_cpu_to_be32(FDMI_PORT_SPEED_4GB);
 		break;
+	case PORT_SPEED_8GB:
+		eiter->a.cur_speed =
+		    __constant_cpu_to_be32(FDMI_PORT_SPEED_8GB);
+		break;
 	default:
 		eiter->a.cur_speed =
 		    __constant_cpu_to_be32(FDMI_PORT_SPEED_UNKNOWN);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3c5fcf8..5ec798c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -287,6 +287,40 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 }
 
 /**
+ * qla25xx_pci_config() - Setup ISP25xx PCI configuration registers.
+ * @ha: HA context
+ *
+ * Returns 0 on success.
+ */
+int
+qla25xx_pci_config(scsi_qla_host_t *ha)
+{
+	uint16_t w;
+	uint32_t d;
+
+	pci_set_master(ha->pdev);
+	pci_try_set_mwi(ha->pdev);
+
+	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
+	w |= (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w &= ~PCI_COMMAND_INTX_DISABLE;
+	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
+
+	/* PCIe -- adjust Maximum Read Request Size (2048). */
+	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
+		pcie_set_readrq(ha->pdev, 2048);
+
+	/* Reset expansion ROM address decode enable */
+	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);
+	d &= ~PCI_ROM_ADDRESS_ENABLE;
+	pci_write_config_dword(ha->pdev, PCI_ROM_ADDRESS, d);
+
+	ha->chip_revision = ha->pdev->revision;
+
+	return QLA_SUCCESS;
+}
+
+/**
  * qla2x00_isp_firmware() - Choose firmware image.
  * @ha: HA context
  *
@@ -717,7 +751,9 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 		mem_size = (ha->fw_memory_size - 0x11000 + 1) *
 		    sizeof(uint16_t);
 	} else if (IS_FWI2_CAPABLE(ha)) {
-		fixed_size = offsetof(struct qla24xx_fw_dump, ext_mem);
+		fixed_size = IS_QLA25XX(ha) ?
+		    offsetof(struct qla25xx_fw_dump, ext_mem):
+		    offsetof(struct qla24xx_fw_dump, ext_mem);
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 259710b..b8f226a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -247,7 +247,7 @@ void
 qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 {
 #define LS_UNKNOWN	2
-	static char	*link_speeds[5] = { "1", "2", "?", "4", "10" };
+	static char	*link_speeds[5] = { "1", "2", "?", "4", "8" };
 	char		*link_speed;
 	uint16_t	handle_cnt;
 	uint16_t	cnt;
@@ -1758,11 +1758,11 @@ qla2x00_request_irqs(scsi_qla_host_t *ha)
 	int ret;
 
 	/* If possible, enable MSI-X. */
-	if (!IS_QLA2432(ha))
+	if (!IS_QLA2432(ha) && !IS_QLA2532(ha))
 		goto skip_msix;
 
-        if (ha->chip_revision < QLA_MSIX_CHIP_REV_24XX ||
-	    !QLA_MSIX_FW_MODE_1(ha->fw_attributes)) {
+        if (IS_QLA2432(ha) && (ha->chip_revision < QLA_MSIX_CHIP_REV_24XX ||
+	    !QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
 		DEBUG2(qla_printk(KERN_WARNING, ha,
 		    "MSI-X: Unsupported ISP2432 (0x%X, 0x%X).\n",
 		    ha->chip_revision, ha->fw_attributes));
@@ -1781,7 +1781,7 @@ qla2x00_request_irqs(scsi_qla_host_t *ha)
 	    "MSI-X: Falling back-to INTa mode -- %d.\n", ret);
 skip_msix:
 
-	if (!IS_QLA24XX(ha))
+	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha))
 		goto skip_msi;
 
 	ret = pci_enable_msi(ha->pdev);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e870e7c..8bdc5a2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -265,6 +265,8 @@ qla24xx_pci_info_str(struct scsi_qla_host *ha, char *str)
 		strcpy(str, "PCIe (");
 		if (lspeed == 1)
 			strcat(str, "2.5Gb/s ");
+		else if (lspeed == 2)
+			strcat(str, "5.0Gb/s ");
 		else
 			strcat(str, "<unknown> ");
 		snprintf(lwstr, sizeof(lwstr), "x%d)", lwidth);
@@ -343,6 +345,12 @@ qla24xx_fw_version_str(struct scsi_qla_host *ha, char *str)
 		strcat(str, "[IP] ");
 	if (ha->fw_attributes & BIT_2)
 		strcat(str, "[Multi-ID] ");
+	if (ha->fw_attributes & BIT_3)
+		strcat(str, "[SB-2] ");
+	if (ha->fw_attributes & BIT_4)
+		strcat(str, "[T10 CRC] ");
+	if (ha->fw_attributes & BIT_5)
+		strcat(str, "[VI] ");
 	if (ha->fw_attributes & BIT_13)
 		strcat(str, "[Experimental]");
 	return str;
@@ -1348,6 +1356,39 @@ static struct isp_operations qla24xx_isp_ops = {
 	.get_flash_version	= qla24xx_get_flash_version,
 };
 
+static struct isp_operations qla25xx_isp_ops = {
+	.pci_config		= qla25xx_pci_config,
+	.reset_chip		= qla24xx_reset_chip,
+	.chip_diag		= qla24xx_chip_diag,
+	.config_rings		= qla24xx_config_rings,
+	.reset_adapter		= qla24xx_reset_adapter,
+	.nvram_config		= qla24xx_nvram_config,
+	.update_fw_options	= qla24xx_update_fw_options,
+	.load_risc		= qla24xx_load_risc,
+	.pci_info_str		= qla24xx_pci_info_str,
+	.fw_version_str		= qla24xx_fw_version_str,
+	.intr_handler		= qla24xx_intr_handler,
+	.enable_intrs		= qla24xx_enable_intrs,
+	.disable_intrs		= qla24xx_disable_intrs,
+	.abort_command		= qla24xx_abort_command,
+	.abort_target		= qla24xx_abort_target,
+	.fabric_login		= qla24xx_login_fabric,
+	.fabric_logout		= qla24xx_fabric_logout,
+	.calc_req_entries	= NULL,
+	.build_iocbs		= NULL,
+	.prep_ms_iocb		= qla24xx_prep_ms_iocb,
+	.prep_ms_fdmi_iocb	= qla24xx_prep_ms_fdmi_iocb,
+	.read_nvram		= qla25xx_read_nvram_data,
+	.write_nvram		= qla25xx_write_nvram_data,
+	.fw_dump		= qla25xx_fw_dump,
+	.beacon_on		= qla24xx_beacon_on,
+	.beacon_off		= qla24xx_beacon_off,
+	.beacon_blink		= qla24xx_beacon_blink,
+	.read_optrom		= qla24xx_read_optrom_data,
+	.write_optrom		= qla24xx_write_optrom_data,
+	.get_flash_version	= qla24xx_get_flash_version,
+};
+
 static inline void
 qla2x00_set_isp_flags(scsi_qla_host_t *ha)
 {
@@ -1413,6 +1454,13 @@ qla2x00_set_isp_flags(scsi_qla_host_t *ha)
 		ha->device_type |= DT_FWI2;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP2532:
+		ha->device_type |= DT_ISP2532;
+		ha->device_type |= DT_ZIO_SUPPORTED;
+		ha->device_type |= DT_FWI2;
+		ha->device_type |= DT_IIDMA;
+		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
+		break;
 	}
 }
 
@@ -1527,7 +1575,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5422 ||
-	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5432)
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5432 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2532)
 		sht = &qla24xx_driver_template;
 	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
 	if (host == NULL) {
@@ -1609,6 +1658,17 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_24XX;
 		ha->isp_ops = &qla24xx_isp_ops;
+	} else if (IS_QLA25XX(ha)) {
+		host->max_id = MAX_TARGETS_2200;
+		ha->mbx_count = MAILBOX_REGISTER_COUNT;
+		ha->request_q_length = REQUEST_ENTRY_CNT_24XX;
+		ha->response_q_length = RESPONSE_ENTRY_CNT_2300;
+		ha->last_loop_id = SNS_LAST_LOOP_ID_2300;
+		ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
+		ha->mgmt_svr_loop_id = 10 + ha->vp_idx;
+		ha->gid_list_info_size = 8;
+		ha->optrom_size = OPTROM_SIZE_25XX;
+		ha->isp_ops = &qla25xx_isp_ops;
 	}
 	host->can_queue = ha->request_q_length + 128;
 
@@ -2665,18 +2725,20 @@ qla2x00_down_timeout(struct semaphore *sema, unsigned long timeout)
 
 /* Firmware interface routines. */
 
-#define FW_BLOBS	5
+#define FW_BLOBS	6
 #define FW_ISP21XX	0
 #define FW_ISP22XX	1
 #define FW_ISP2300	2
 #define FW_ISP2322	3
 #define FW_ISP24XX	4
+#define FW_ISP25XX	5
 
 #define FW_FILE_ISP21XX	"ql2100_fw.bin"
 #define FW_FILE_ISP22XX	"ql2200_fw.bin"
 #define FW_FILE_ISP2300	"ql2300_fw.bin"
 #define FW_FILE_ISP2322	"ql2322_fw.bin"
 #define FW_FILE_ISP24XX	"ql2400_fw.bin"
+#define FW_FILE_ISP25XX	"ql2500_fw.bin"
 
 static DECLARE_MUTEX(qla_fw_lock);
 
@@ -2686,6 +2748,7 @@ static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
 	{ .name = FW_FILE_ISP2300, .segs = { 0x800, 0 }, },
 	{ .name = FW_FILE_ISP2322, .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
 	{ .name = FW_FILE_ISP24XX, },
+	{ .name = FW_FILE_ISP25XX, },
 };
 
 struct fw_blob *
@@ -2704,6 +2767,8 @@ qla2x00_request_firmware(scsi_qla_host_t *ha)
 		blob = &qla_fw_blobs[FW_ISP2322];
 	} else if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		blob = &qla_fw_blobs[FW_ISP24XX];
+	} else if (IS_QLA25XX(ha)) {
+		blob = &qla_fw_blobs[FW_ISP25XX];
 	}
 
 	down(&qla_fw_lock);
@@ -2747,6 +2812,7 @@ static struct pci_device_id qla2xxx_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2432) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5422) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5432) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2532) },
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index aafd604..a925a3f 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -766,6 +766,29 @@ qla24xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
 	return ret;
 }
 
+uint8_t *
+qla25xx_read_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+    uint32_t bytes)
+{
+	uint32_t i;
+	uint32_t *dwptr;
+
+	/* Dword reads to flash. */
+	dwptr = (uint32_t *)buf;
+	for (i = 0; i < bytes >> 2; i++, naddr++)
+		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
+		    flash_data_to_access_addr(FA_VPD_NVRAM_ADDR | naddr)));
+
+	return buf;
+}
+
+int
+qla25xx_write_nvram_data(scsi_qla_host_t *ha, uint8_t *buf, uint32_t naddr,
+    uint32_t bytes)
+{
+	return qla24xx_write_flash_data(ha, (uint32_t *)buf,
+	    FA_VPD_NVRAM_ADDR | naddr, bytes >> 2);
+}
 
 static inline void
 qla2x00_flip_colors(scsi_qla_host_t *ha, uint16_t *pflags)
-- 
1.5.3.rc2.4.g726f9


