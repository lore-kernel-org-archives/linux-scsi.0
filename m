From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 01/10] qla2xxx: Collapse RISC-RAM retrieval code during a firmware-dump.
Date: Thu, 24 Apr 2008 15:21:22 -0700
Message-ID: <1209075691-6539-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20337 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbYDXWVe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:21:34 -0400
In-Reply-To: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Use the more efficient read-DMA'ble-buffer mailbox commands
rather than reading a single word/dword at a time.  We also
remove a bulk of the duplicate mailbox command-handling codes in
favor of more generic read-memory() routines (qla2xxx_dump_ram()
and qla24xx_dump_ram()).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |  394 +++++++++++++++-------------------------
 1 files changed, 143 insertions(+), 251 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 9d12d9f..cbef785 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -38,78 +38,38 @@ qla2xxx_copy_queues(scsi_qla_host_t *ha, void *ptr)
 }
 
 static int
-qla24xx_dump_memory(scsi_qla_host_t *ha, uint32_t *code_ram,
-    uint32_t cram_size, uint32_t *ext_mem, void **nxt)
+qla24xx_dump_ram(scsi_qla_host_t *ha, uint32_t addr, uint32_t *ram,
+    uint32_t ram_dwords, void **nxt)
 {
 	int rval;
-	uint32_t cnt, stat, timer, risc_address, ext_mem_cnt;
-	uint16_t mb[4];
+	uint32_t cnt, stat, timer, dwords, idx;
+	uint16_t mb0;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	dma_addr_t dump_dma = ha->gid_list_dma;
+	uint32_t *dump = (uint32_t *)ha->gid_list;
 
 	rval = QLA_SUCCESS;
-	risc_address = ext_mem_cnt = 0;
-	memset(mb, 0, sizeof(mb));
+	mb0 = 0;
 
-	/* Code RAM. */
-	risc_address = 0x20000;
-	WRT_REG_WORD(&reg->mailbox0, MBC_READ_RAM_EXTENDED);
+	WRT_REG_WORD(&reg->mailbox0, MBC_DUMP_RISC_RAM_EXTENDED);
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 
-	for (cnt = 0; cnt < cram_size / 4 && rval == QLA_SUCCESS;
-	    cnt++, risc_address++) {
-		WRT_REG_WORD(&reg->mailbox1, LSW(risc_address));
-		WRT_REG_WORD(&reg->mailbox8, MSW(risc_address));
-		RD_REG_WORD(&reg->mailbox8);
-		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_HOST_INT);
-
-		for (timer = 6000000; timer; timer--) {
-			/* Check for pending interrupts. */
-			stat = RD_REG_DWORD(&reg->host_status);
-			if (stat & HSRX_RISC_INT) {
-				stat &= 0xff;
+	dwords = GID_LIST_SIZE / 4;
+	for (cnt = 0; cnt < ram_dwords && rval == QLA_SUCCESS;
+	    cnt += dwords, addr += dwords) {
+		if (cnt + dwords > ram_dwords)
+			dwords = ram_dwords - cnt;
 
-				if (stat == 0x1 || stat == 0x2 ||
-				    stat == 0x10 || stat == 0x11) {
-					set_bit(MBX_INTERRUPT,
-					    &ha->mbx_cmd_flags);
+		WRT_REG_WORD(&reg->mailbox1, LSW(addr));
+		WRT_REG_WORD(&reg->mailbox8, MSW(addr));
 
-					mb[0] = RD_REG_WORD(&reg->mailbox0);
-					mb[2] = RD_REG_WORD(&reg->mailbox2);
-					mb[3] = RD_REG_WORD(&reg->mailbox3);
+		WRT_REG_WORD(&reg->mailbox2, MSW(dump_dma));
+		WRT_REG_WORD(&reg->mailbox3, LSW(dump_dma));
+		WRT_REG_WORD(&reg->mailbox6, MSW(MSD(dump_dma)));
+		WRT_REG_WORD(&reg->mailbox7, LSW(MSD(dump_dma)));
 
-					WRT_REG_DWORD(&reg->hccr,
-					    HCCRX_CLR_RISC_INT);
-					RD_REG_DWORD(&reg->hccr);
-					break;
-				}
-
-				/* Clear this intr; it wasn't a mailbox intr */
-				WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-				RD_REG_DWORD(&reg->hccr);
-			}
-			udelay(5);
-		}
-
-		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
-			rval = mb[0] & MBS_MASK;
-			code_ram[cnt] = htonl((mb[3] << 16) | mb[2]);
-		} else {
-			rval = QLA_FUNCTION_FAILED;
-		}
-	}
-
-	if (rval == QLA_SUCCESS) {
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
+		WRT_REG_WORD(&reg->mailbox4, MSW(dwords));
+		WRT_REG_WORD(&reg->mailbox5, LSW(dwords));
 		WRT_REG_DWORD(&reg->hccr, HCCRX_SET_HOST_INT);
 
 		for (timer = 6000000; timer; timer--) {
@@ -123,9 +83,7 @@ qla24xx_dump_memory(scsi_qla_host_t *ha, uint32_t *code_ram,
 					set_bit(MBX_INTERRUPT,
 					    &ha->mbx_cmd_flags);
 
-					mb[0] = RD_REG_WORD(&reg->mailbox0);
-					mb[2] = RD_REG_WORD(&reg->mailbox2);
-					mb[3] = RD_REG_WORD(&reg->mailbox3);
+					mb0 = RD_REG_WORD(&reg->mailbox0);
 
 					WRT_REG_DWORD(&reg->hccr,
 					    HCCRX_CLR_RISC_INT);
@@ -141,17 +99,34 @@ qla24xx_dump_memory(scsi_qla_host_t *ha, uint32_t *code_ram,
 		}
 
 		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
-			rval = mb[0] & MBS_MASK;
-			ext_mem[cnt] = htonl((mb[3] << 16) | mb[2]);
+			rval = mb0 & MBS_MASK;
+			for (idx = 0; idx < dwords; idx++)
+				ram[cnt + idx] = swab32(dump[idx]);
 		} else {
 			rval = QLA_FUNCTION_FAILED;
 		}
 	}
 
-	*nxt = rval == QLA_SUCCESS ? &ext_mem[cnt]: NULL;
+	*nxt = rval == QLA_SUCCESS ? &ram[cnt]: NULL;
 	return rval;
 }
 
+static int
+qla24xx_dump_memory(scsi_qla_host_t *ha, uint32_t *code_ram,
+    uint32_t cram_size, void **nxt)
+{
+	int rval;
+
+	/* Code RAM. */
+	rval = qla24xx_dump_ram(ha, 0x20000, code_ram, cram_size / 4, nxt);
+	if (rval != QLA_SUCCESS)
+		return rval;
+
+	/* External Memory. */
+	return qla24xx_dump_ram(ha, 0x100000, *nxt,
+	    ha->fw_memory_size - 0x100000 + 1, nxt);
+}
+
 static uint32_t *
 qla24xx_read_window(struct device_reg_24xx __iomem *reg, uint32_t iobase,
     uint32_t count, uint32_t *buf)
@@ -239,6 +214,90 @@ qla24xx_soft_reset(scsi_qla_host_t *ha)
 	return rval;
 }
 
+static int
+qla2xxx_dump_ram(scsi_qla_host_t *ha, uint32_t addr, uint16_t *ram,
+    uint16_t ram_words, void **nxt)
+{
+	int rval;
+	uint32_t cnt, stat, timer, words, idx;
+	uint16_t mb0;
+	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	dma_addr_t dump_dma = ha->gid_list_dma;
+	uint16_t *dump = (uint16_t *)ha->gid_list;
+
+	rval = QLA_SUCCESS;
+	mb0 = 0;
+
+	WRT_MAILBOX_REG(ha, reg, 0, MBC_DUMP_RISC_RAM_EXTENDED);
+	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+
+	words = GID_LIST_SIZE / 2;
+	for (cnt = 0; cnt < ram_words && rval == QLA_SUCCESS;
+	    cnt += words, addr += words) {
+		if (cnt + words > ram_words)
+			words = ram_words - cnt;
+
+		WRT_MAILBOX_REG(ha, reg, 1, LSW(addr));
+		WRT_MAILBOX_REG(ha, reg, 8, MSW(addr));
+
+		WRT_MAILBOX_REG(ha, reg, 2, MSW(dump_dma));
+		WRT_MAILBOX_REG(ha, reg, 3, LSW(dump_dma));
+		WRT_MAILBOX_REG(ha, reg, 6, MSW(MSD(dump_dma)));
+		WRT_MAILBOX_REG(ha, reg, 7, LSW(MSD(dump_dma)));
+
+		WRT_MAILBOX_REG(ha, reg, 4, words);
+		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
+
+		for (timer = 6000000; timer; timer--) {
+			/* Check for pending interrupts. */
+			stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
+			if (stat & HSR_RISC_INT) {
+				stat &= 0xff;
+
+				if (stat == 0x1 || stat == 0x2) {
+					set_bit(MBX_INTERRUPT,
+					    &ha->mbx_cmd_flags);
+
+					mb0 = RD_MAILBOX_REG(ha, reg, 0);
+
+					/* Release mailbox registers. */
+					WRT_REG_WORD(&reg->semaphore, 0);
+					WRT_REG_WORD(&reg->hccr,
+					    HCCR_CLR_RISC_INT);
+					RD_REG_WORD(&reg->hccr);
+					break;
+				} else if (stat == 0x10 || stat == 0x11) {
+					set_bit(MBX_INTERRUPT,
+					    &ha->mbx_cmd_flags);
+
+					mb0 = RD_MAILBOX_REG(ha, reg, 0);
+
+					WRT_REG_WORD(&reg->hccr,
+					    HCCR_CLR_RISC_INT);
+					RD_REG_WORD(&reg->hccr);
+					break;
+				}
+
+				/* clear this intr; it wasn't a mailbox intr */
+				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
+				RD_REG_WORD(&reg->hccr);
+			}
+			udelay(5);
+		}
+
+		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
+			rval = mb0 & MBS_MASK;
+			for (idx = 0; idx < words; idx++)
+				ram[cnt + idx] = swab16(dump[idx]);
+		} else {
+			rval = QLA_FUNCTION_FAILED;
+		}
+	}
+
+	*nxt = rval == QLA_SUCCESS ? &ram[cnt]: NULL;
+	return rval;
+}
+
 static inline void
 qla2xxx_read_window(struct device_reg_2xxx __iomem *reg, uint32_t count,
     uint16_t *buf)
@@ -258,19 +317,14 @@ void
 qla2300_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 {
 	int		rval;
-	uint32_t	cnt, timer;
-	uint32_t	risc_address;
-	uint16_t	mb0, mb2;
+	uint32_t	cnt;
 
-	uint32_t	stat;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	uint16_t __iomem *dmp_reg;
 	unsigned long	flags;
 	struct qla2300_fw_dump	*fw;
-	uint32_t	data_ram_cnt;
+	void		*nxt;
 
-	risc_address = data_ram_cnt = 0;
-	mb0 = mb2 = 0;
 	flags = 0;
 
 	if (!hardware_locked)
@@ -388,185 +442,23 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 		}
 	}
 
-	if (rval == QLA_SUCCESS) {
-		/* Get RISC SRAM. */
-		risc_address = 0x800;
- 		WRT_MAILBOX_REG(ha, reg, 0, MBC_READ_RAM_WORD);
-		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-	}
-	for (cnt = 0; cnt < sizeof(fw->risc_ram) / 2 && rval == QLA_SUCCESS;
-	    cnt++, risc_address++) {
- 		WRT_MAILBOX_REG(ha, reg, 1, (uint16_t)risc_address);
-		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
-
-		for (timer = 6000000; timer; timer--) {
-			/* Check for pending interrupts. */
- 			stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
-			if (stat & HSR_RISC_INT) {
-				stat &= 0xff;
-
-				if (stat == 0x1 || stat == 0x2) {
-					set_bit(MBX_INTERRUPT,
-					    &ha->mbx_cmd_flags);
-
-					mb0 = RD_MAILBOX_REG(ha, reg, 0);
-					mb2 = RD_MAILBOX_REG(ha, reg, 2);
-
-					/* Release mailbox registers. */
-					WRT_REG_WORD(&reg->semaphore, 0);
-					WRT_REG_WORD(&reg->hccr,
-					    HCCR_CLR_RISC_INT);
-					RD_REG_WORD(&reg->hccr);
-					break;
-				} else if (stat == 0x10 || stat == 0x11) {
-					set_bit(MBX_INTERRUPT,
-					    &ha->mbx_cmd_flags);
-
-					mb0 = RD_MAILBOX_REG(ha, reg, 0);
-					mb2 = RD_MAILBOX_REG(ha, reg, 2);
-
-					WRT_REG_WORD(&reg->hccr,
-					    HCCR_CLR_RISC_INT);
-					RD_REG_WORD(&reg->hccr);
-					break;
-				}
-
-				/* clear this intr; it wasn't a mailbox intr */
-				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-				RD_REG_WORD(&reg->hccr);
-			}
-			udelay(5);
-		}
-
-		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
-			rval = mb0 & MBS_MASK;
-			fw->risc_ram[cnt] = htons(mb2);
-		} else {
-			rval = QLA_FUNCTION_FAILED;
-		}
-	}
-
-	if (rval == QLA_SUCCESS) {
-		/* Get stack SRAM. */
-		risc_address = 0x10000;
- 		WRT_MAILBOX_REG(ha, reg, 0, MBC_READ_RAM_EXTENDED);
-		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-	}
-	for (cnt = 0; cnt < sizeof(fw->stack_ram) / 2 && rval == QLA_SUCCESS;
-	    cnt++, risc_address++) {
- 		WRT_MAILBOX_REG(ha, reg, 1, LSW(risc_address));
- 		WRT_MAILBOX_REG(ha, reg, 8, MSW(risc_address));
-		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
-
-		for (timer = 6000000; timer; timer--) {
-			/* Check for pending interrupts. */
- 			stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
-			if (stat & HSR_RISC_INT) {
-				stat &= 0xff;
-
-				if (stat == 0x1 || stat == 0x2) {
-					set_bit(MBX_INTERRUPT,
-					    &ha->mbx_cmd_flags);
-
-					mb0 = RD_MAILBOX_REG(ha, reg, 0);
-					mb2 = RD_MAILBOX_REG(ha, reg, 2);
-
-					/* Release mailbox registers. */
-					WRT_REG_WORD(&reg->semaphore, 0);
-					WRT_REG_WORD(&reg->hccr,
-					    HCCR_CLR_RISC_INT);
-					RD_REG_WORD(&reg->hccr);
-					break;
-				} else if (stat == 0x10 || stat == 0x11) {
-					set_bit(MBX_INTERRUPT,
-					    &ha->mbx_cmd_flags);
-
-					mb0 = RD_MAILBOX_REG(ha, reg, 0);
-					mb2 = RD_MAILBOX_REG(ha, reg, 2);
-
-					WRT_REG_WORD(&reg->hccr,
-					    HCCR_CLR_RISC_INT);
-					RD_REG_WORD(&reg->hccr);
-					break;
-				}
-
-				/* clear this intr; it wasn't a mailbox intr */
-				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-				RD_REG_WORD(&reg->hccr);
-			}
-			udelay(5);
-		}
-
-		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
-			rval = mb0 & MBS_MASK;
-			fw->stack_ram[cnt] = htons(mb2);
-		} else {
-			rval = QLA_FUNCTION_FAILED;
-		}
-	}
-
-	if (rval == QLA_SUCCESS) {
-		/* Get data SRAM. */
-		risc_address = 0x11000;
-		data_ram_cnt = ha->fw_memory_size - risc_address + 1;
- 		WRT_MAILBOX_REG(ha, reg, 0, MBC_READ_RAM_EXTENDED);
-		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
-	}
-	for (cnt = 0; cnt < data_ram_cnt && rval == QLA_SUCCESS;
-	    cnt++, risc_address++) {
- 		WRT_MAILBOX_REG(ha, reg, 1, LSW(risc_address));
- 		WRT_MAILBOX_REG(ha, reg, 8, MSW(risc_address));
-		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
-
-		for (timer = 6000000; timer; timer--) {
-			/* Check for pending interrupts. */
- 			stat = RD_REG_DWORD(&reg->u.isp2300.host_status);
-			if (stat & HSR_RISC_INT) {
-				stat &= 0xff;
-
-				if (stat == 0x1 || stat == 0x2) {
-					set_bit(MBX_INTERRUPT,
-					    &ha->mbx_cmd_flags);
-
-					mb0 = RD_MAILBOX_REG(ha, reg, 0);
-					mb2 = RD_MAILBOX_REG(ha, reg, 2);
-
-					/* Release mailbox registers. */
-					WRT_REG_WORD(&reg->semaphore, 0);
-					WRT_REG_WORD(&reg->hccr,
-					    HCCR_CLR_RISC_INT);
-					RD_REG_WORD(&reg->hccr);
-					break;
-				} else if (stat == 0x10 || stat == 0x11) {
-					set_bit(MBX_INTERRUPT,
-					    &ha->mbx_cmd_flags);
-
-					mb0 = RD_MAILBOX_REG(ha, reg, 0);
-					mb2 = RD_MAILBOX_REG(ha, reg, 2);
-
-					WRT_REG_WORD(&reg->hccr,
-					    HCCR_CLR_RISC_INT);
-					RD_REG_WORD(&reg->hccr);
-					break;
-				}
+	/* Get RISC SRAM. */
+	if (rval == QLA_SUCCESS)
+		rval = qla2xxx_dump_ram(ha, 0x800, fw->risc_ram,
+		    sizeof(fw->risc_ram) / 2, &nxt);
 
-				/* clear this intr; it wasn't a mailbox intr */
-				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-				RD_REG_WORD(&reg->hccr);
-			}
-			udelay(5);
-		}
+	/* Get stack SRAM. */
+	if (rval == QLA_SUCCESS)
+		rval = qla2xxx_dump_ram(ha, 0x10000, fw->stack_ram,
+		    sizeof(fw->stack_ram) / 2, &nxt);
 
-		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
-			rval = mb0 & MBS_MASK;
-			fw->data_ram[cnt] = htons(mb2);
-		} else {
-			rval = QLA_FUNCTION_FAILED;
-		}
-	}
+	/* Get data SRAM. */
+	if (rval == QLA_SUCCESS)
+		rval = qla2xxx_dump_ram(ha, 0x11000, fw->data_ram,
+		    ha->fw_memory_size - 0x11000 + 1, &nxt);
 
 	if (rval == QLA_SUCCESS)
-		qla2xxx_copy_queues(ha, &fw->data_ram[cnt]);
+		qla2xxx_copy_queues(ha, nxt);
 
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
@@ -1010,7 +902,7 @@ qla24xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 		goto qla24xx_fw_dump_failed_0;
 
 	rval = qla24xx_dump_memory(ha, fw->code_ram, sizeof(fw->code_ram),
-	    fw->ext_mem, &nxt);
+	    &nxt);
 	if (rval != QLA_SUCCESS)
 		goto qla24xx_fw_dump_failed_0;
 
@@ -1318,7 +1210,7 @@ qla25xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 		goto qla25xx_fw_dump_failed_0;
 
 	rval = qla24xx_dump_memory(ha, fw->code_ram, sizeof(fw->code_ram),
-	    fw->ext_mem, &nxt);
+	    &nxt);
 	if (rval != QLA_SUCCESS)
 		goto qla25xx_fw_dump_failed_0;
 
-- 
1.5.5.1.67.gbdb8

