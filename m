From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/17] qla2xxx: Code scrubbing.
Date: Wed,  6 Jul 2005 10:32:07 -0700 (PDT)
Message-ID: <20050706173207.10568.12945.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:54613 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262435AbVGFRcI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:32:08 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Code scrubbing.

 - Remove trailing whitespace from driver files.
 - Remove unused #defines and inlines.
 - Standardize on C comments (// -> /* */)

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_dbg.c      |  130 ++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_def.h      |   42 ++++++-----
 drivers/scsi/qla2xxx/qla_fw.h       |    3 -
 drivers/scsi/qla2xxx/qla_gs.c       |    6 +-
 drivers/scsi/qla2xxx/qla_init.c     |   56 ++++++++-------
 drivers/scsi/qla2xxx/qla_inline.h   |   86 +----------------------
 drivers/scsi/qla2xxx/qla_iocb.c     |    4 +
 drivers/scsi/qla2xxx/qla_isr.c      |   21 +++---
 drivers/scsi/qla2xxx/qla_mbx.c      |   12 ++-
 drivers/scsi/qla2xxx/qla_os.c       |   78 +++++++++++----------
 drivers/scsi/qla2xxx/qla_rscn.c     |   30 ++++----
 drivers/scsi/qla2xxx/qla_settings.h |   25 -------
 drivers/scsi/qla2xxx/qla_sup.c      |   10 +--
 drivers/scsi/qla2xxx/qla_version.h  |    2 -
 14 files changed, 199 insertions(+), 306 deletions(-)

590ae1880589da532026c35812c9931dd34996c0
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -74,7 +74,7 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 	fw->hccr = RD_REG_WORD(&reg->hccr);
 
 	/* Pause RISC. */
-	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC); 
+	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
 	if (IS_QLA2300(ha)) {
 		for (cnt = 30000;
 		    (RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) == 0 &&
@@ -91,85 +91,85 @@ qla2300_fw_dump(scsi_qla_host_t *ha, int
 
 	if (rval == QLA_SUCCESS) {
 		dmp_reg = (uint16_t __iomem *)(reg + 0);
-		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++)
 			fw->pbiu_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x10);
-		for (cnt = 0; cnt < sizeof(fw->risc_host_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_host_reg) / 2; cnt++)
 			fw->risc_host_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x40);
-		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
 			fw->mailbox_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x40);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->resp_dma_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->resp_dma_reg) / 2; cnt++)
 			fw->resp_dma_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x50);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++)
 			fw->dma_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x00);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0xA0);
-		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++)
 			fw->risc_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2000); 
+		WRT_REG_WORD(&reg->pcr, 0x2000);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp0_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp0_reg) / 2; cnt++)
 			fw->risc_gp0_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2200); 
+		WRT_REG_WORD(&reg->pcr, 0x2200);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp1_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp1_reg) / 2; cnt++)
 			fw->risc_gp1_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2400); 
+		WRT_REG_WORD(&reg->pcr, 0x2400);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp2_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp2_reg) / 2; cnt++)
 			fw->risc_gp2_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2600); 
+		WRT_REG_WORD(&reg->pcr, 0x2600);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp3_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp3_reg) / 2; cnt++)
 			fw->risc_gp3_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2800); 
+		WRT_REG_WORD(&reg->pcr, 0x2800);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp4_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp4_reg) / 2; cnt++)
 			fw->risc_gp4_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2A00); 
+		WRT_REG_WORD(&reg->pcr, 0x2A00);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp5_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp5_reg) / 2; cnt++)
 			fw->risc_gp5_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2C00); 
+		WRT_REG_WORD(&reg->pcr, 0x2C00);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp6_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp6_reg) / 2; cnt++)
 			fw->risc_gp6_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2E00); 
+		WRT_REG_WORD(&reg->pcr, 0x2E00);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp7_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp7_reg) / 2; cnt++)
 			fw->risc_gp7_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x10); 
+		WRT_REG_WORD(&reg->ctrl_status, 0x10);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->frame_buf_hdw_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->frame_buf_hdw_reg) / 2; cnt++)
 			fw->frame_buf_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x20); 
+		WRT_REG_WORD(&reg->ctrl_status, 0x20);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->fpm_b0_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->fpm_b0_reg) / 2; cnt++)
 			fw->fpm_b0_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x30); 
+		WRT_REG_WORD(&reg->ctrl_status, 0x30);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++)
 			fw->fpm_b1_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		/* Reset RISC. */
@@ -622,7 +622,7 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int
 	fw->hccr = RD_REG_WORD(&reg->hccr);
 
 	/* Pause RISC. */
-	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC); 
+	WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
 	for (cnt = 30000; (RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) == 0 &&
 	    rval == QLA_SUCCESS; cnt--) {
 		if (cnt)
@@ -632,7 +632,7 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int
 	}
 	if (rval == QLA_SUCCESS) {
 		dmp_reg = (uint16_t __iomem *)(reg + 0);
-		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++)
 			fw->pbiu_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x10);
@@ -644,67 +644,67 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int
 		}
 
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x20);
-		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++)
 			fw->dma_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x00);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0xA0);
-		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++)
 			fw->risc_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2000); 
+		WRT_REG_WORD(&reg->pcr, 0x2000);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp0_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp0_reg) / 2; cnt++)
 			fw->risc_gp0_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2100); 
+		WRT_REG_WORD(&reg->pcr, 0x2100);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp1_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp1_reg) / 2; cnt++)
 			fw->risc_gp1_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2200); 
+		WRT_REG_WORD(&reg->pcr, 0x2200);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp2_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp2_reg) / 2; cnt++)
 			fw->risc_gp2_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2300); 
+		WRT_REG_WORD(&reg->pcr, 0x2300);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp3_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp3_reg) / 2; cnt++)
 			fw->risc_gp3_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2400); 
+		WRT_REG_WORD(&reg->pcr, 0x2400);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp4_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp4_reg) / 2; cnt++)
 			fw->risc_gp4_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2500); 
+		WRT_REG_WORD(&reg->pcr, 0x2500);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp5_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp5_reg) / 2; cnt++)
 			fw->risc_gp5_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2600); 
+		WRT_REG_WORD(&reg->pcr, 0x2600);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp6_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp6_reg) / 2; cnt++)
 			fw->risc_gp6_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->pcr, 0x2700); 
+		WRT_REG_WORD(&reg->pcr, 0x2700);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->risc_gp7_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->risc_gp7_reg) / 2; cnt++)
 			fw->risc_gp7_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x10); 
+		WRT_REG_WORD(&reg->ctrl_status, 0x10);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->frame_buf_hdw_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->frame_buf_hdw_reg) / 2; cnt++)
 			fw->frame_buf_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x20); 
+		WRT_REG_WORD(&reg->ctrl_status, 0x20);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->fpm_b0_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->fpm_b0_reg) / 2; cnt++)
 			fw->fpm_b0_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		WRT_REG_WORD(&reg->ctrl_status, 0x30); 
+		WRT_REG_WORD(&reg->ctrl_status, 0x30);
 		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
-		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++) 
+		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++)
 			fw->fpm_b1_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		/* Reset the ISP. */
@@ -723,7 +723,7 @@ qla2100_fw_dump(scsi_qla_host_t *ha, int
 	if (rval == QLA_SUCCESS && (IS_QLA2200(ha) || (IS_QLA2100(ha) &&
 	    (RD_REG_WORD(&reg->mctr) & (BIT_1 | BIT_0)) != 0))) {
 
-		WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC); 
+		WRT_REG_WORD(&reg->hccr, HCCR_PAUSE_RISC);
 		for (cnt = 30000;
 		    (RD_REG_WORD(&reg->hccr) & HCCR_RISC_PAUSE) == 0 &&
 		    rval == QLA_SUCCESS; cnt--) {
@@ -964,7 +964,7 @@ qla_uprintf(char **uiter, char *fmt, ...
 	int	iter, len;
 	char	buf[128];
 	va_list	args;
- 
+
 	va_start(args, fmt);
 	len = vsprintf(buf, fmt, args);
 	va_end(args);
@@ -1913,8 +1913,8 @@ qla24xx_ascii_fw_dump(scsi_qla_host_t *h
 /*                         Driver Debug Functions.                          */
 /****************************************************************************/
 
-void 
-qla2x00_dump_regs(scsi_qla_host_t *ha) 
+void
+qla2x00_dump_regs(scsi_qla_host_t *ha)
 {
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
@@ -1935,7 +1935,7 @@ qla2x00_dump_regs(scsi_qla_host_t *ha) 
 
 
 void
-qla2x00_dump_buffer(uint8_t * b, uint32_t size) 
+qla2x00_dump_buffer(uint8_t * b, uint32_t size)
 {
 	uint32_t cnt;
 	uint8_t c;
@@ -1961,11 +1961,11 @@ qla2x00_dump_buffer(uint8_t * b, uint32_
 /**************************************************************************
  *   qla2x00_print_scsi_cmd
  *	 Dumps out info about the scsi cmd and srb.
- *   Input	 
+ *   Input
  *	 cmd : struct scsi_cmnd
  **************************************************************************/
 void
-qla2x00_print_scsi_cmd(struct scsi_cmnd * cmd) 
+qla2x00_print_scsi_cmd(struct scsi_cmnd * cmd)
 {
 	int i;
 	struct scsi_qla_host *ha;
@@ -1988,7 +1988,7 @@ qla2x00_print_scsi_cmd(struct scsi_cmnd 
 	    cmd->request_buffer, cmd->request_bufflen);
 	printk("  tag=%d, transfersize=0x%x\n",
 	    cmd->tag, cmd->transfersize);
-	printk("  serial_number=%lx, SP=%p\n", cmd->serial_number, sp); 
+	printk("  serial_number=%lx, SP=%p\n", cmd->serial_number, sp);
 	printk("  data direction=%d\n", cmd->sc_data_direction);
 
 	if (!sp)
@@ -2025,8 +2025,8 @@ qla2x00_dump_pkt(void *pkt)
  *       count   = number of words.
  */
 void
-qla2x00_formatted_dump_buffer(char *string, uint8_t * buffer, 
-				uint8_t wd_size, uint32_t count) 
+qla2x00_formatted_dump_buffer(char *string, uint8_t * buffer,
+				uint8_t wd_size, uint32_t count)
 {
 	uint32_t cnt;
 	uint16_t *buf16;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -116,7 +116,7 @@
 
 #include "qla_settings.h"
 
-/* 
+/*
  * Data bit definitions
  */
 #define BIT_0	0x1
@@ -194,8 +194,8 @@
 #define MAX_TARGETS		MAX_FIBRE_DEVICES
 #define MIN_LUNS		8
 #define MAX_LUNS		MAX_FIBRE_LUNS
-#define MAX_CMDS_PER_LUN	255 
-                                    
+#define MAX_CMDS_PER_LUN	255
+
 /*
  * Fibre Channel device definitions.
  */
@@ -243,7 +243,7 @@
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 
 /*
- * SCSI Request Block 
+ * SCSI Request Block
  */
 typedef struct srb {
 	struct list_head list;
@@ -254,7 +254,7 @@ typedef struct srb {
 	struct scsi_cmnd *cmd;		/* Linux SCSI command pkt */
 
 	struct timer_list timer;	/* Command timer */
-	atomic_t ref_count;	/* Reference count for this structure */			
+	atomic_t ref_count;	/* Reference count for this structure */
 	uint16_t flags;
 
 	/* Request state */
@@ -312,7 +312,7 @@ struct device_reg_2xxx {
 	uint16_t flash_data;		/* Flash BIOS data */
 	uint16_t unused_1[1];		/* Gap */
 	uint16_t ctrl_status;		/* Control/Status */
-#define CSR_FLASH_64K_BANK	BIT_3	/* Flash upper 64K bank select */ 
+#define CSR_FLASH_64K_BANK	BIT_3	/* Flash upper 64K bank select */
 #define CSR_FLASH_ENABLE	BIT_1	/* Flash BIOS Read/Write enable */
 #define CSR_ISP_SOFT_RESET	BIT_0	/* ISP soft reset */
 
@@ -355,12 +355,12 @@ struct device_reg_2xxx {
 			uint16_t rsp_q_out;	/*  Out-Pointer */
 
 						/* RISC to Host Status */
-			uint32_t host_status;	
+			uint32_t host_status;
 #define HSR_RISC_INT		BIT_15	/* RISC interrupt */
 #define HSR_RISC_PAUSED		BIT_8	/* RISC Paused */
 
 					/* Host to Host Semaphore */
-			uint16_t host_semaphore; 
+			uint16_t host_semaphore;
 			uint16_t unused_3[17];	/* Gap */
 			uint16_t mailbox0;
 			uint16_t mailbox1;
@@ -1057,7 +1057,7 @@ typedef struct {
 	 * LSB BIT 5 = Rx Sensitivity 1G bit 1
 	 * LSB BIT 6 = Rx Sensitivity 1G bit 2
 	 * LSB BIT 7 = Rx Sensitivity 1G bit 3
-	 *            
+	 *
 	 * MSB BIT 0 = Tx Sensitivity 2G bit 0
 	 * MSB BIT 1 = Tx Sensitivity 2G bit 1
 	 * MSB BIT 2 = Tx Sensitivity 2G bit 2
@@ -1075,7 +1075,7 @@ typedef struct {
 	 * LSB BIT 5 = Output Swing 2G bit 0
 	 * LSB BIT 6 = Output Swing 2G bit 1
 	 * LSB BIT 7 = Output Swing 2G bit 2
-	 *            
+	 *
 	 * MSB BIT 0 = Output Emphasis 2G bit 0
 	 * MSB BIT 1 = Output Emphasis 2G bit 1
 	 * MSB BIT 2 = Output Enable
@@ -1997,7 +1997,7 @@ struct qla_board_info {
 struct gid_list_info {
 	uint8_t	al_pa;
 	uint8_t	area;
-	uint8_t	domain;		
+	uint8_t	domain;
 	uint8_t	loop_id_2100;	/* ISP2100/ISP2200 -- 4 bytes. */
 	uint16_t loop_id;	/* ISP23XX         -- 6 bytes. */
 	uint16_t reserved_1;	/* ISP24XX         -- 8 bytes. */
@@ -2111,7 +2111,7 @@ typedef struct scsi_qla_host {
 #define ISP_ABORT_RETRY         20      /* ISP aborted. */
 #define FCPORT_RESCAN_NEEDED	21      /* IO descriptor processing needed */
 #define IODESC_PROCESS_NEEDED	22      /* IO descriptor processing needed */
-#define IOCTL_ERROR_RECOVERY	23      
+#define IOCTL_ERROR_RECOVERY	23
 #define LOOP_RESET_NEEDED	24
 #define BEACON_BLINK_NEEDED	25
 
@@ -2126,7 +2126,7 @@ typedef struct scsi_qla_host {
 #define SRB_MIN_REQ	128
 	mempool_t	*srb_mempool;
 
-	/* This spinlock is used to protect "io transactions", you must	
+	/* This spinlock is used to protect "io transactions", you must
 	 * aquire it before doing any IO to the card, eg with RD_REG*() and
 	 * WRT_REG*() for the duration of your entire commandtransaction.
 	 *
@@ -2153,12 +2153,12 @@ typedef struct scsi_qla_host {
 	response_t      *response_ring_ptr; /* Current address. */
 	uint16_t        rsp_ring_index;     /* Current index. */
 	uint16_t	response_q_length;
-    
+
 	struct isp_operations isp_ops;
 
 	/* Outstandings ISP commands. */
 	srb_t		*outstanding_cmds[MAX_OUTSTANDING_COMMANDS];
-	uint32_t	current_outstanding_cmd; 
+	uint32_t	current_outstanding_cmd;
 	srb_t		*status_srb;	/* Status continuation entry. */
 
 	uint16_t           revision;
@@ -2187,7 +2187,7 @@ typedef struct scsi_qla_host {
 #define LOOP_P2P  2
 #define P2P_LOOP  3
 
-        uint8_t		marker_needed; 
+        uint8_t		marker_needed;
 
 	uint8_t		interrupts_on;
 
@@ -2208,7 +2208,7 @@ typedef struct scsi_qla_host {
 	uint8_t		mbx_count;
 	uint16_t	last_loop_id;
 
-        uint32_t	login_retry_count; 
+        uint32_t	login_retry_count;
 
 	/* Fibre Channel Device List. */
 	struct list_head	fcports;
@@ -2253,7 +2253,7 @@ typedef struct scsi_qla_host {
 	dma_addr_t	rlc_rsp_dma;
 	rpt_lun_cmd_rsp_t *rlc_rsp;
 
-	/* Small DMA pool allocations -- maximum 256 bytes in length. */ 
+	/* Small DMA pool allocations -- maximum 256 bytes in length. */
 #define DMA_POOL_SIZE	256
 	struct dma_pool *s_dma_pool;
 
@@ -2281,10 +2281,10 @@ typedef struct scsi_qla_host {
 	uint32_t	mbx_flags;
 #define  MBX_IN_PROGRESS	BIT_0
 #define  MBX_BUSY		BIT_1	/* Got the Access */
-#define  MBX_SLEEPING_ON_SEM	BIT_2 
+#define  MBX_SLEEPING_ON_SEM	BIT_2
 #define  MBX_POLLING_FOR_COMP	BIT_3
 #define  MBX_COMPLETED		BIT_4
-#define  MBX_TIMEDOUT		BIT_5 
+#define  MBX_TIMEDOUT		BIT_5
 #define  MBX_ACCESS_TIMEDOUT	BIT_6
 
 	mbx_cmd_t 	mc;
@@ -2345,7 +2345,7 @@ typedef struct scsi_qla_host {
 	  test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) || \
 	  test_bit(LOOP_RESYNC_ACTIVE, &ha->dpc_flags)) || \
 	 atomic_read(&ha->loop_state) == LOOP_DOWN)
-				 
+
 #define LOOP_RDY(ha)	(!LOOP_NOT_READY(ha))
 
 #define TGT_Q(ha, t) (ha->otgt[t])
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -21,8 +21,6 @@
 #ifndef __QLA_FW_H
 #define __QLA_FW_H
 
-// ISP24xx
-
 #define RISC_SADDRESS		0x100000
 #define MBS_CHECKSUM_ERROR	0x4010
 
@@ -60,7 +58,6 @@ struct port_database_24xx {
 #define PDS_PORT_UNAVAILABLE	0x07
 #define PDS_PRLO_PENDING	0x09
 #define PDS_LOGO_PENDING	0x11
-//FIXME
 #define PDS_PRLI2_PENDING	0x12
 
 	uint8_t hard_address[3];
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -317,7 +317,7 @@ qla2x00_gid_pt(scsi_qla_host_t *ha, sw_i
 		 * single call.  Return a failed status, and let GA_NXT handle
 		 * the overload.
 		 */
-		if (i == MAX_FIBRE_DEVICES) 
+		if (i == MAX_FIBRE_DEVICES)
 			rval = QLA_FUNCTION_FAILED;
 	}
 
@@ -658,7 +658,7 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 
 	/* Prepare CT arguments -- node_name, symbolic node_name, size */
 	memcpy(ct_req->req.rsnn_nn.node_name, ha->node_name, WWN_SIZE);
-	
+
 	/* Prepare the Symbolic Node Name */
 	/* Board type */
 	snn = ct_req->req.rsnn_nn.sym_node_name;
@@ -863,7 +863,7 @@ qla2x00_sns_gid_pt(scsi_qla_host_t *ha, 
 		 * single call.  Return a failed status, and let GA_NXT handle
 		 * the overload.
 		 */
-		if (i == MAX_FIBRE_DEVICES) 
+		if (i == MAX_FIBRE_DEVICES)
 			rval = QLA_FUNCTION_FAILED;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -123,10 +123,10 @@ qla2x00_initialize_adapter(scsi_qla_host
 		    (rval = qla2x00_init_rings(ha)) == QLA_SUCCESS) {
 check_fw_ready_again:
 			/*
-			 * Wait for a successful LIP up to a maximum 
+			 * Wait for a successful LIP up to a maximum
 			 * of (in seconds): RISC login timeout value,
 			 * RISC retry count value, and port down retry
-			 * value OR a minimum of 4 seconds OR If no 
+			 * value OR a minimum of 4 seconds OR If no
 			 * cable, only 5 seconds.
 			 */
 			rval = qla2x00_fw_ready(ha);
@@ -389,7 +389,7 @@ qla2x00_isp_firmware(scsi_qla_host_t *ha
 	int  rval;
 
 	/* Assume loading risc code */
-	rval = QLA_FUNCTION_FAILED; 
+	rval = QLA_FUNCTION_FAILED;
 
 	if (ha->flags.disable_risc_code_load) {
 		DEBUG2(printk("scsi(%ld): RISC CODE NOT loaded\n",
@@ -417,7 +417,7 @@ qla2x00_isp_firmware(scsi_qla_host_t *ha
  * Returns 0 on success.
  */
 void
-qla2x00_reset_chip(scsi_qla_host_t *ha) 
+qla2x00_reset_chip(scsi_qla_host_t *ha)
 {
 	unsigned long   flags = 0;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
@@ -673,7 +673,7 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 		for (cnt = 6000000; cnt && (data == MBS_BUSY); cnt--) {
 			udelay(5);
 			data = RD_MAILBOX_REG(ha, reg, 0);
-			barrier(); 
+			barrier();
 		}
 	} else
 		udelay(10);
@@ -988,7 +988,7 @@ qla2x00_update_fw_options(scsi_qla_host_
 		emphasis = (ha->fw_seriallink_options[2] &
 		    (BIT_4 | BIT_3)) >> 3;
 		tx_sens = ha->fw_seriallink_options[0] &
-		    (BIT_3 | BIT_2 | BIT_1 | BIT_0); 
+		    (BIT_3 | BIT_2 | BIT_1 | BIT_0);
 		rx_sens = (ha->fw_seriallink_options[0] &
 		    (BIT_7 | BIT_6 | BIT_5 | BIT_4)) >> 4;
 		ha->fw_options[10] = (emphasis << 14) | (swing << 8);
@@ -1006,7 +1006,7 @@ qla2x00_update_fw_options(scsi_qla_host_
 		    (BIT_7 | BIT_6 | BIT_5)) >> 5;
 		emphasis = ha->fw_seriallink_options[3] & (BIT_1 | BIT_0);
 		tx_sens = ha->fw_seriallink_options[1] &
-		    (BIT_3 | BIT_2 | BIT_1 | BIT_0); 
+		    (BIT_3 | BIT_2 | BIT_1 | BIT_0);
 		rx_sens = (ha->fw_seriallink_options[1] &
 		    (BIT_7 | BIT_6 | BIT_5 | BIT_4)) >> 4;
 		ha->fw_options[11] = (emphasis << 14) | (swing << 8);
@@ -1171,7 +1171,7 @@ qla2x00_fw_ready(scsi_qla_host_t *ha)
 	rval = QLA_SUCCESS;
 
 	/* 20 seconds for loop down. */
-	min_wait = 20;		
+	min_wait = 20;
 
 	/*
 	 * Firmware should take at most one RATOV to login, plus 5 seconds for
@@ -1217,8 +1217,8 @@ qla2x00_fw_ready(scsi_qla_host_t *ha)
 			    (fw_state >= FSTATE_LOSS_OF_SYNC ||
 				fw_state == FSTATE_WAIT_AL_PA)) {
 				/* Loop down. Timeout on min_wait for states
-				 * other than Wait for Login. 
-				 */	
+				 * other than Wait for Login.
+				 */
 				if (time_after_eq(jiffies, mtime)) {
 					qla_printk(KERN_INFO, ha,
 					    "Cable is unplugged...\n");
@@ -1620,7 +1620,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	 *
 	 *	 The driver waits for the link to come up after link down
 	 *	 before returning I/Os to OS with "DID_NO_CONNECT".
-	 */						
+	 */
 	if (nv->link_down_timeout == 0) {
 		ha->loop_down_abort_time =
 		    (LOOP_DOWN_TIME - LOOP_DOWN_TIMEOUT);
@@ -1628,7 +1628,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 		ha->link_down_timeout =	 nv->link_down_timeout;
 		ha->loop_down_abort_time =
 		    (LOOP_DOWN_TIME - ha->link_down_timeout);
-	} 
+	}
 
 	/*
 	 * Need enough time to try and get the port back.
@@ -1730,7 +1730,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
  *      2 = database was full and device was not configured.
  */
 static int
-qla2x00_configure_loop(scsi_qla_host_t *ha) 
+qla2x00_configure_loop(scsi_qla_host_t *ha)
 {
 	int  rval;
 	unsigned long flags, save_flags;
@@ -1838,7 +1838,7 @@ qla2x00_configure_loop(scsi_qla_host_t *
  *	0 = success.
  */
 static int
-qla2x00_configure_local_loop(scsi_qla_host_t *ha) 
+qla2x00_configure_local_loop(scsi_qla_host_t *ha)
 {
 	int		rval, rval2;
 	int		found_devs;
@@ -1993,16 +1993,16 @@ cleanup_allocation:
 }
 
 static void
-qla2x00_probe_for_all_luns(scsi_qla_host_t *ha) 
+qla2x00_probe_for_all_luns(scsi_qla_host_t *ha)
 {
 	fc_port_t	*fcport;
 
-	qla2x00_mark_all_devices_lost(ha); 
+	qla2x00_mark_all_devices_lost(ha);
  	list_for_each_entry(fcport, &ha->fcports, list) {
 		if (fcport->port_type != FCT_TARGET)
 			continue;
 
-		qla2x00_update_fcport(ha, fcport); 
+		qla2x00_update_fcport(ha, fcport);
 	}
 }
 
@@ -2573,7 +2573,7 @@ qla2x00_find_new_loop_id(scsi_qla_host_t
  *	Kernel context.
  */
 static int
-qla2x00_device_resync(scsi_qla_host_t *ha) 
+qla2x00_device_resync(scsi_qla_host_t *ha)
 {
 	int	rval;
 	int	rval2;
@@ -2837,8 +2837,8 @@ qla2x00_fabric_login(scsi_qla_host_t *ha
 			 * unrecoverable / not handled error
 			 */
 			DEBUG2(printk("%s(%ld): failed=%x port_id=%02x%02x%02x "
- 			    "loop_id=%x jiffies=%lx.\n", 
- 			    __func__, ha->host_no, mb[0], 
+ 			    "loop_id=%x jiffies=%lx.\n",
+ 			    __func__, ha->host_no, mb[0],
 			    fcport->d_id.b.domain, fcport->d_id.b.area,
 			    fcport->d_id.b.al_pa, fcport->loop_id, jiffies));
 
@@ -2901,7 +2901,7 @@ qla2x00_local_device_login(scsi_qla_host
  *      0 = success
  */
 int
-qla2x00_loop_resync(scsi_qla_host_t *ha) 
+qla2x00_loop_resync(scsi_qla_host_t *ha)
 {
 	int   rval;
 	uint32_t wait_time;
@@ -2960,7 +2960,7 @@ qla2x00_rescan_fcports(scsi_qla_host_t *
 
 		rescan_done = 1;
 	}
-	qla2x00_probe_for_all_luns(ha); 
+	qla2x00_probe_for_all_luns(ha);
 }
 
 /*
@@ -3030,7 +3030,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 
 			ha->isp_ops.enable_intrs(ha);
 
-			ha->isp_abort_cnt = 0; 
+			ha->isp_abort_cnt = 0;
 			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 		} else {	/* failed the ISP abort */
 			ha->flags.online = 1;
@@ -3039,7 +3039,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
  					qla_printk(KERN_WARNING, ha,
 					    "ISP error recovery failed - "
 					    "board disabled\n");
-					/* 
+					/*
 					 * The next call disables the board
 					 * completely.
 					 */
@@ -3064,7 +3064,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 				status = 1;
 			}
 		}
-		       
+
 	}
 
 	if (status) {
@@ -3119,11 +3119,11 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 			}
 
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	
+
 			status = qla2x00_setup_chip(ha);
 
 			spin_lock_irqsave(&ha->hardware_lock, flags);
- 
+
 			if (!IS_QLA24XX(ha) && !IS_QLA25XX(ha)) {
 				/* Enable proper parity */
 				if (IS_QLA2300(ha))
@@ -3168,7 +3168,7 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 		}
 
 		/* if no cable then assume it's good */
-		if ((ha->device_flags & DFLG_NO_CABLE)) 
+		if ((ha->device_flags & DFLG_NO_CABLE))
 			status = 0;
 
 		DEBUG(printk("%s(): Configure loop done, status = 0x%x\n",
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -30,7 +30,7 @@ static __inline__ uint16_t qla2x00_debou
  *      register value.
  */
 static __inline__ uint16_t
-qla2x00_debounce_register(volatile uint16_t __iomem *addr) 
+qla2x00_debounce_register(volatile uint16_t __iomem *addr)
 {
 	volatile uint16_t first;
 	volatile uint16_t second;
@@ -78,7 +78,7 @@ static __inline__ int qla2x00_normalize_
  *	ffffabc1ffffeeee	(0x100000000 + e_addr)
  *	ffffabc100000000	(0x100000000 + e_addr) & ~(0xffffffff)
  *	ffffabc100000000	(ne_addr)
- *	
+ *
  * Compute length of second DMA segment:
  *
  *	00000000ffffeeee	(e_addr & 0xffffffff)
@@ -114,48 +114,18 @@ qla2x00_normalize_dma_addr(
 }
 
 static __inline__ void qla2x00_poll(scsi_qla_host_t *);
-static inline void 
+static inline void
 qla2x00_poll(scsi_qla_host_t *ha)
 {
 	ha->isp_ops.intr_handler(0, ha, NULL);
 }
 
-static __inline__ int qla2x00_is_wwn_zero(uint8_t *);
-
-/*
- * qla2x00_is_wwn_zero - Check for zero node name
- *
- * Input:
- *      wwn = Pointer to WW name to check
- *
- * Returns:
- *      1 if name is 0x00 else 0
- *
- * Context:
- *      Kernel context.
- */
-static __inline__ int
-qla2x00_is_wwn_zero(uint8_t *wwn)
-{
-	int cnt;
-
-	for (cnt = 0; cnt < WWN_SIZE ; cnt++, wwn++) {
-		if (*wwn != 0)
-			break;
-	}
-	/* if zero return 1 */
-	if (cnt == WWN_SIZE)
-		return (1);
-	else
-		return (0);
-}
-
 static __inline__ void qla2x00_check_fabric_devices(scsi_qla_host_t *);
 /*
  * This routine will wait for fabric devices for
  * the reset delay.
  */
-static __inline__ void qla2x00_check_fabric_devices(scsi_qla_host_t *ha) 
+static __inline__ void qla2x00_check_fabric_devices(scsi_qla_host_t *ha)
 {
 	uint16_t	fw_state;
 
@@ -188,54 +158,6 @@ qla2x00_issue_marker(scsi_qla_host_t *ha
 	return (QLA_SUCCESS);
 }
 
-static __inline__ void qla2x00_add_timer_to_cmd(srb_t *, int);
-static __inline__ void qla2x00_delete_timer_from_cmd(srb_t *);
-
-/**************************************************************************
-*   qla2x00_add_timer_to_cmd
-*
-* Description:
-*       Creates a timer for the specified command. The timeout is usually
-*       the command time from kernel minus 2 secs.
-*
-* Input:
-*     sp - pointer to validate
-*
-* Returns:
-*     None.
-**************************************************************************/
-static inline void
-qla2x00_add_timer_to_cmd(srb_t *sp, int timeout)
-{
-	init_timer(&sp->timer);
-	sp->timer.expires = jiffies + timeout * HZ;
-	sp->timer.data = (unsigned long) sp;
-	sp->timer.function = (void (*) (unsigned long))qla2x00_cmd_timeout;
-	add_timer(&sp->timer);
-}
-
-/**************************************************************************
-*   qla2x00_delete_timer_from_cmd
-*
-* Description:
-*       Delete the timer for the specified command.
-*
-* Input:
-*     sp - pointer to validate
-*
-* Returns:
-*     None.
-**************************************************************************/
-static inline void 
-qla2x00_delete_timer_from_cmd(srb_t *sp)
-{
-	if (sp->timer.function != NULL) {
-		del_timer(&sp->timer);
-		sp->timer.function =  NULL;
-		sp->timer.data = (unsigned long) NULL;
-	}
-}
-
 static inline uint8_t *host_to_fcp_swap(uint8_t *, uint32_t);
 static inline uint8_t *
 host_to_fcp_swap(uint8_t *fcp, uint32_t bsize)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -468,7 +468,7 @@ queuing_error:
  *
  * Returns non-zero if a failure occured, else zero.
  */
-int 
+int
 __qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
     uint8_t type)
 {
@@ -504,7 +504,7 @@ __qla2x00_marker(scsi_qla_host_t *ha, ui
 	return (QLA_SUCCESS);
 }
 
-int 
+int
 qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
     uint8_t type)
 {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -240,13 +240,13 @@ qla2x00_mbx_completion(scsi_qla_host_t *
 	wptr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 1);
 
 	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
-		if (IS_QLA2200(ha) && cnt == 8) 
+		if (IS_QLA2200(ha) && cnt == 8)
 			wptr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 8);
 		if (cnt == 4 || cnt == 5)
 			ha->mailbox_out[cnt] = qla2x00_debounce_register(wptr);
 		else
 			ha->mailbox_out[cnt] = RD_REG_WORD(wptr);
-	
+
 		wptr++;
 	}
 
@@ -514,7 +514,7 @@ qla2x00_async_event(scsi_qla_host_t *ha,
 		    "Configuration change detected: value=%x.\n", mb[1]);
 
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
-			atomic_set(&ha->loop_state, LOOP_DOWN);  
+			atomic_set(&ha->loop_state, LOOP_DOWN);
 			if (!atomic_read(&ha->loop_down_timer))
 				atomic_set(&ha->loop_down_timer,
 				    LOOP_DOWN_TIME);
@@ -846,7 +846,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		qla_printk(KERN_WARNING, ha, "Status Entry invalid handle.\n");
 
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-		if (ha->dpc_wait && !ha->dpc_active) 
+		if (ha->dpc_wait && !ha->dpc_active)
 			up(ha->dpc_wait);
 
 		return;
@@ -969,7 +969,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		}
 
 		/*
-		 * Check to see if SCSI Status is non zero. If so report SCSI 
+		 * Check to see if SCSI Status is non zero. If so report SCSI
 		 * Status.
 		 */
 		if (lscsi_status != 0) {
@@ -991,7 +991,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			sp->request_sense_length = sense_len;
 			sp->request_sense_ptr = cp->sense_buffer;
 
-			if (sp->request_sense_length > 32) 
+			if (sp->request_sense_length > 32)
 				sense_len = 32;
 
 			memcpy(cp->sense_buffer, sense_data, sense_len);
@@ -1096,7 +1096,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		break;
 
 	case CS_ABORTED:
-		/* 
+		/*
 		 * hv2.19.12 - DID_ABORT does not retry the request if we
 		 * aborted this request then abort otherwise it must be a
 		 * reset.
@@ -1137,7 +1137,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 
 		/* SCSI Mid-Layer handles device queue full */
 
-		cp->result = DID_OK << 16 | lscsi_status; 
+		cp->result = DID_OK << 16 | lscsi_status;
 
 		break;
 
@@ -1178,7 +1178,7 @@ qla2x00_status_cont_entry(scsi_qla_host_
 			    "sp=%p sp->state:%d\n", __func__, sp, sp->state));
 			qla_printk(KERN_INFO, ha,
 			    "cmd is NULL: already returned to OS (sp=%p)\n",
-			    sp); 
+			    sp);
 
 			ha->status_srb = NULL;
 			return;
@@ -1223,7 +1223,7 @@ qla2x00_error_entry(scsi_qla_host_t *ha,
 	else if (pkt->entry_status & RF_INV_E_COUNT)
 		qla_printk(KERN_ERR, ha, "%s: Invalid Entry Count\n", __func__);
 	else if (pkt->entry_status & RF_INV_E_PARAM)
-		qla_printk(KERN_ERR, ha, 
+		qla_printk(KERN_ERR, ha,
 		    "%s: Invalid Entry Parameter\n", __func__);
 	else if (pkt->entry_status & RF_INV_E_TYPE)
 		qla_printk(KERN_ERR, ha, "%s: Invalid Entry Type\n", __func__);
@@ -1365,7 +1365,6 @@ qla24xx_process_response_queue(struct sc
 			DEBUG3(printk(KERN_INFO
 			    "scsi(%ld): Process error entry.\n", ha->host_no));
 
-			//FIXME
 			qla2x00_error_entry(ha, (sts_entry_t *) pkt);
 			((response_t *)pkt)->signature = RESPONSE_PROCESSED;
 			wmb();
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -294,7 +294,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 			    "Mailbox command timeout occured. Scheduling ISP "
 			    "abort.\n");
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
-			if (ha->dpc_wait && !ha->dpc_active) 
+			if (ha->dpc_wait && !ha->dpc_active)
 				up(ha->dpc_wait);
 
 		} else if (!abort_active) {
@@ -1753,18 +1753,18 @@ qla2x00_login_fabric(scsi_qla_host_t *ha
 /*
  * qla2x00_login_local_device
  *           Issue login loop port mailbox command.
- *    
+ *
  * Input:
  *           ha = adapter block pointer.
  *           loop_id = device loop ID.
  *           opt = command options.
- *          
+ *
  * Returns:
  *            Return status code.
- *             
+ *
  * Context:
  *            Kernel context.
- *             
+ *
  */
 int
 qla2x00_login_local_device(scsi_qla_host_t *ha, uint16_t loop_id,
@@ -2070,7 +2070,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_
 	} else {
 		DEBUG11(printk("%s(%ld): done. mb1=%x mb2=%x mb3=%x mb6=%x "
 		    "mb7=%x mb10=%x.\n", __func__, ha->host_no,
-		    mcp->mb[1], mcp->mb[2], mcp->mb[3], mcp->mb[6], mcp->mb[7], 
+		    mcp->mb[1], mcp->mb[2], mcp->mb[3], mcp->mb[6], mcp->mb[7],
 		    mcp->mb[10]));
 
 		if (cur_xchg_cnt)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -64,7 +64,7 @@ MODULE_PARM_DESC(ql2xplogiabsentdevice,
 int ql2xenablezio = 0;
 module_param(ql2xenablezio, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xenablezio,
-		"Option to enable ZIO:If 1 then enable it otherwise" 
+		"Option to enable ZIO:If 1 then enable it otherwise"
 		" use the default set in the NVRAM."
 		" Default is 0 : disabled");
 
@@ -89,7 +89,7 @@ static void qla2x00_free_device(scsi_qla
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
 
 /*
- * SCSI host template entry points 
+ * SCSI host template entry points
  */
 static int qla2xxx_slave_configure(struct scsi_device * device);
 static int qla2xxx_slave_alloc(struct scsi_device *);
@@ -280,7 +280,7 @@ char *
 qla2x00_fw_version_str(struct scsi_qla_host *ha, char *str)
 {
 	char un_str[10];
-	
+
 	sprintf(str, "%d.%02d.%02d ", ha->fw_major_version,
 	    ha->fw_minor_version,
 	    ha->fw_subminor_version);
@@ -504,14 +504,14 @@ qla2x00_eh_wait_on_command(scsi_qla_host
 
 /*
  * qla2x00_wait_for_hba_online
- *    Wait till the HBA is online after going through 
+ *    Wait till the HBA is online after going through
  *    <= MAX_RETRIES_OF_ISP_ABORT  or
  *    finally HBA is disabled ie marked offline
  *
  * Input:
  *     ha - pointer to host adapter structure
- * 
- * Note:    
+ *
+ * Note:
  *    Does context switching-Release SPIN_LOCK
  *    (if any) before calling this routine.
  *
@@ -519,13 +519,13 @@ qla2x00_eh_wait_on_command(scsi_qla_host
  *    Success (Adapter is online) : 0
  *    Failed  (Adapter is offline/disabled) : 1
  */
-static int 
+static int
 qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
 {
 	int		return_status;
 	unsigned long	wait_online;
 
-	wait_online = jiffies + (MAX_LOOP_TIMEOUT * HZ); 
+	wait_online = jiffies + (MAX_LOOP_TIMEOUT * HZ);
 	while (((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) ||
 	    test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) ||
 	    test_bit(ISP_ABORT_RETRY, &ha->dpc_flags) ||
@@ -533,8 +533,8 @@ qla2x00_wait_for_hba_online(scsi_qla_hos
 
 		msleep(1000);
 	}
-	if (ha->flags.online) 
-		return_status = QLA_SUCCESS; 
+	if (ha->flags.online)
+		return_status = QLA_SUCCESS;
 	else
 		return_status = QLA_FUNCTION_FAILED;
 
@@ -546,27 +546,27 @@ qla2x00_wait_for_hba_online(scsi_qla_hos
 /*
  * qla2x00_wait_for_loop_ready
  *    Wait for MAX_LOOP_TIMEOUT(5 min) value for loop
- *    to be in LOOP_READY state.	 
+ *    to be in LOOP_READY state.
  * Input:
  *     ha - pointer to host adapter structure
- * 
- * Note:    
+ *
+ * Note:
  *    Does context switching-Release SPIN_LOCK
  *    (if any) before calling this routine.
- *    
+ *
  *
  * Return:
  *    Success (LOOP_READY) : 0
  *    Failed  (LOOP_NOT_READY) : 1
  */
-static inline int 
+static inline int
 qla2x00_wait_for_loop_ready(scsi_qla_host_t *ha)
 {
 	int 	 return_status = QLA_SUCCESS;
 	unsigned long loop_timeout ;
 
 	/* wait for 5 min at the max for loop to be ready */
-	loop_timeout = jiffies + (MAX_LOOP_TIMEOUT * HZ); 
+	loop_timeout = jiffies + (MAX_LOOP_TIMEOUT * HZ);
 
 	while ((!atomic_read(&ha->loop_down_timer) &&
 	    atomic_read(&ha->loop_state) == LOOP_DOWN) ||
@@ -577,7 +577,7 @@ qla2x00_wait_for_loop_ready(scsi_qla_hos
 			break;
 		}
 	}
-	return (return_status);	
+	return (return_status);
 }
 
 /**************************************************************************
@@ -647,13 +647,13 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	/* Wait for the command to be returned. */
 	if (ret == SUCCESS) {
 		if (qla2x00_eh_wait_on_command(ha, cmd) != QLA_SUCCESS) {
-			qla_printk(KERN_ERR, ha, 
+			qla_printk(KERN_ERR, ha,
 			    "scsi(%ld:%d:%d): Abort handler timed out -- %lx "
 			    "%x.\n", ha->host_no, id, lun, serial, ret);
 		}
 	}
 
-	qla_printk(KERN_INFO, ha, 
+	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): Abort command issued -- %lx %x.\n", ha->host_no,
 	    id, lun, serial, ret);
 
@@ -668,7 +668,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 *
 * Input:
 *    ha - pointer to scsi_qla_host structure.
-*    t  - target 	
+*    t  - target
 * Returns:
 *    Either SUCCESS or FAILED.
 *
@@ -717,7 +717,7 @@ qla2x00_eh_wait_for_pending_target_comma
 *    executing commands.
 *
 *    NOTE: The use of SP is undefined within this context.  Do *NOT*
-*          attempt to use this value, even if you determine it is 
+*          attempt to use this value, even if you determine it is
 *          non-null.
 *
 * Input:
@@ -793,7 +793,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 			    "commands\n", __func__, ha->host_no));
 			qla_printk(KERN_INFO, ha,
 			    "%s: failed while waiting for commands\n",
-			    __func__); 
+			    __func__);
 
 			goto eh_dev_reset_done;
 		}
@@ -959,7 +959,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 
 	/*
 	 * Fixme-may be dpc thread is active and processing
-	 * loop_resync,so wait a while for it to 
+	 * loop_resync,so wait a while for it to
 	 * be completed and then issue big hammer.Otherwise
 	 * it may cause I/O failure as big hammer marks the
 	 * devices as lost kicking of the port_down_timer
@@ -974,7 +974,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 
 		if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
 			goto eh_host_reset_lock;
-	} 
+	}
 	clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 
 	/* Waiting for our command in done_queue to be returned to OS.*/
@@ -1020,7 +1020,7 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 	}
 
 	if (status == QLA_SUCCESS &&
-		((!ha->flags.enable_target_reset && 
+		((!ha->flags.enable_target_reset &&
 		  !ha->flags.enable_lip_reset) ||
 		ha->flags.enable_lip_full_login)) {
 
@@ -1139,7 +1139,7 @@ qla2x00_config_dma_addressing(scsi_qla_h
 
 			if (pci_set_consistent_dma_mask(ha->pdev,
 			    DMA_64BIT_MASK)) {
-				qla_printk(KERN_DEBUG, ha, 
+				qla_printk(KERN_DEBUG, ha,
 				    "Failed to set 64 bit PCI consistent mask; "
 				    "using 32 bit.\n");
 				pci_set_consistent_dma_mask(ha->pdev,
@@ -1666,7 +1666,7 @@ void qla2x00_mark_device_lost(scsi_qla_h
 {
 	if (atomic_read(&fcport->state) == FCS_ONLINE && fcport->rport)
 		fc_remote_port_block(fcport->rport);
-	/* 
+	/*
 	 * We may need to retry the login, so don't change the state of the
 	 * port but do the retries.
 	 */
@@ -1711,7 +1711,7 @@ void qla2x00_mark_device_lost(scsi_qla_h
  * Context:
  */
 void
-qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha) 
+qla2x00_mark_all_devices_lost(scsi_qla_host_t *ha)
 {
 	fc_port_t *fcport;
 
@@ -2061,11 +2061,11 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
  *
  * Context:
  *      Kernel context.
- * 
+ *
  * Note: Sets the ref_count for non Null sp to one.
  */
 static int
-qla2x00_allocate_sp_pool(scsi_qla_host_t *ha) 
+qla2x00_allocate_sp_pool(scsi_qla_host_t *ha)
 {
 	int      rval;
 
@@ -2081,10 +2081,10 @@ qla2x00_allocate_sp_pool(scsi_qla_host_t
 
 /*
  *  This routine frees all adapter allocated memory.
- *  
+ *
  */
 static void
-qla2x00_free_sp_pool( scsi_qla_host_t *ha) 
+qla2x00_free_sp_pool( scsi_qla_host_t *ha)
 {
 	if (ha->srb_mempool) {
 		mempool_destroy(ha->srb_mempool);
@@ -2223,7 +2223,7 @@ qla2x00_do_dpc(void *data)
 
 						DEBUG(printk("scsi(%ld): port login OK: logged in ID 0x%x\n",
 						    ha->host_no, fcport->loop_id));
-						
+
 						fcport->port_login_retry_count =
 						    ha->port_down_retry_count * PORT_RETRY_TIME;
 						atomic_set(&fcport->state, FCS_ONLINE);
@@ -2254,7 +2254,7 @@ qla2x00_do_dpc(void *data)
 			clear_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags);
 			DEBUG(printk("scsi(%ld): qla2x00_login_retry()\n",
 			    ha->host_no));
-				
+
 			set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 
 			DEBUG(printk("scsi(%ld): qla2x00_login_retry - end\n",
@@ -2315,7 +2315,7 @@ qla2x00_do_dpc(void *data)
 *      ha  = adapter block pointer.
 */
 static void
-qla2x00_rst_aen(scsi_qla_host_t *ha) 
+qla2x00_rst_aen(scsi_qla_host_t *ha)
 {
 	if (ha->flags.online && !ha->flags.reset_active &&
 	    !atomic_read(&ha->loop_down_timer) &&
@@ -2386,7 +2386,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 	 *
 	 * Whenever, a port is in the LOST state we start decrementing its port
 	 * down timer every second until it reaches zero. Once  it reaches zero
-	 * the port it marked DEAD. 
+	 * the port it marked DEAD.
 	 */
 	t = 0;
 	list_for_each_entry(fcport, &ha->fcports, list) {
@@ -2398,9 +2398,9 @@ qla2x00_timer(scsi_qla_host_t *ha)
 			if (atomic_read(&fcport->port_down_timer) == 0)
 				continue;
 
-			if (atomic_dec_and_test(&fcport->port_down_timer) != 0) 
+			if (atomic_dec_and_test(&fcport->port_down_timer) != 0)
 				atomic_set(&fcport->state, FCS_DEVICE_DEAD);
-			
+
 			DEBUG(printk("scsi(%ld): fcport-%d - port retry count: "
 			    "%d remaining\n",
 			    ha->host_no,
@@ -2422,7 +2422,7 @@ qla2x00_timer(scsi_qla_host_t *ha)
 			    ha->host_no));
 
 			if (!IS_QLA2100(ha) && ha->link_down_timeout)
-				atomic_set(&ha->loop_state, LOOP_DEAD); 
+				atomic_set(&ha->loop_state, LOOP_DEAD);
 
 			/* Schedule an ISP abort to return any tape commands. */
 			spin_lock_irqsave(&ha->hardware_lock, cpu_flags);
diff --git a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
--- a/drivers/scsi/qla2xxx/qla_rscn.c
+++ b/drivers/scsi/qla2xxx/qla_rscn.c
@@ -82,7 +82,7 @@ static int qla2x00_send_login_iocb(scsi_
 static int qla2x00_send_login_iocb_cb(scsi_qla_host_t *, struct io_descriptor *,
     struct mbx_entry *);
 
-/** 
+/**
  * Mailbox IOCB callback array.
  **/
 static int (*iocb_function_cb_list[LAST_IOCB_CB])
@@ -95,7 +95,7 @@ static int (*iocb_function_cb_list[LAST_
 };
 
 
-/** 
+/**
  * Generic IO descriptor handle routines.
  **/
 
@@ -169,7 +169,7 @@ qla2x00_handle_to_iodesc(scsi_qla_host_t
 }
 
 
-/** 
+/**
  * IO descriptor allocation routines.
  **/
 
@@ -248,7 +248,7 @@ qla2x00_init_io_descriptors(scsi_qla_hos
 }
 
 
-/** 
+/**
  * IO descriptor timer routines.
  **/
 
@@ -299,7 +299,7 @@ qla2x00_add_iodesc_timer(struct io_descr
 	add_timer(&iodesc->timer);
 }
 
-/** 
+/**
  * IO descriptor support routines.
  **/
 
@@ -333,7 +333,7 @@ qla2x00_update_login_fcport(scsi_qla_hos
 }
 
 
-/** 
+/**
  * Mailbox IOCB commands.
  **/
 
@@ -383,7 +383,7 @@ qla2x00_get_mbx_iocb_entry(scsi_qla_host
  * Returns QLA_SUCCESS if the IOCB was issued.
  */
 static int
-qla2x00_send_abort_iocb(scsi_qla_host_t *ha, struct io_descriptor *iodesc, 
+qla2x00_send_abort_iocb(scsi_qla_host_t *ha, struct io_descriptor *iodesc,
     uint32_t handle_to_abort, int ha_locked)
 {
 	unsigned long flags = 0;
@@ -720,7 +720,7 @@ qla2x00_send_login_iocb_cb(scsi_qla_host
 	/* Only process the last command. */
 	if (remote_fcport->iodesc_idx_sent != iodesc->idx) {
 		DEBUG14(printk("scsi(%ld): Login IOCB -- ignoring, sent to "
-		    "[%02x%02x%02x], expected %x, received %x.\n", 
+		    "[%02x%02x%02x], expected %x, received %x.\n",
 		    ha->host_no, iodesc->d_id.b.domain, iodesc->d_id.b.area,
 		    iodesc->d_id.b.al_pa, remote_fcport->iodesc_idx_sent,
 		    iodesc->idx));
@@ -754,9 +754,9 @@ qla2x00_send_login_iocb_cb(scsi_qla_host
 
 		DEBUG14(printk("scsi(%ld): Login IOCB -- status=%x mb1=%x pn="
 		    "%02x%02x%02x%02x%02x%02x%02x%02x.\n", ha->host_no, status,
-		    mb[1], mbxstat->port_name[0], mbxstat->port_name[1], 
-		    mbxstat->port_name[2], mbxstat->port_name[3], 
-		    mbxstat->port_name[4], mbxstat->port_name[5], 
+		    mb[1], mbxstat->port_name[0], mbxstat->port_name[1],
+		    mbxstat->port_name[2], mbxstat->port_name[3],
+		    mbxstat->port_name[4], mbxstat->port_name[5],
 		    mbxstat->port_name[6], mbxstat->port_name[7]));
 
 		memcpy(remote_fcport->node_name, mbxstat->node_name, WWN_SIZE);
@@ -1052,7 +1052,7 @@ qla2x00_send_login_iocb_cb(scsi_qla_host
 }
 
 
-/** 
+/**
  * IO descriptor processing routines.
  **/
 
@@ -1136,7 +1136,7 @@ qla2x00_handle_port_rscn(scsi_qla_host_t
 		    remote_fcport = rscn_fcport;
 	}
 
-	/* 
+	/*
 	 * If the port is already in our fcport list and online, send an ADISC
 	 * to see if it's still alive.  Issue login if a new fcport or the known
 	 * fcport is currently offline.
@@ -1191,7 +1191,7 @@ qla2x00_handle_port_rscn(scsi_qla_host_t
 			}
 			return (QLA_SUCCESS);
 		}
-		
+
 		/* Send ADISC if the fcport is online */
 		if (atomic_read(&remote_fcport->state) == FCS_ONLINE ||
 		    remote_fcport->iodesc_idx_sent == IODESC_ADISC_NEEDED) {
@@ -1229,7 +1229,7 @@ qla2x00_handle_port_rscn(scsi_qla_host_t
 			 * abort.
 			 */
 			uint32_t handle_to_abort;
-			
+
 			iodesc = &ha->io_descriptors[
 				remote_fcport->iodesc_idx_sent];
 			qla2x00_remove_iodesc_timer(iodesc);
diff --git a/drivers/scsi/qla2xxx/qla_settings.h b/drivers/scsi/qla2xxx/qla_settings.h
--- a/drivers/scsi/qla2xxx/qla_settings.h
+++ b/drivers/scsi/qla2xxx/qla_settings.h
@@ -22,33 +22,8 @@
  */
 #define DEBUG_QLA2100		0	/* For Debug of qla2x00 */
 
-#define STOP_ON_RESET		0
 #define USE_ABORT_TGT		1	/* Use Abort Target mbx cmd */
 
-#define VSA			0	/* Volume Set Addressing */
-
-/* Failover options */
-#define MAX_RECOVERYTIME	10	/*
-					 * Max suspend time for a lun recovery
-					 * time
-					 */
-#define MAX_FAILBACKTIME	5	/* Max suspend time before fail back */
-
-#define QLA_CMD_TIMER_DELTA	3
-
-/* 
- * When a lun is suspended for the "Not Ready" condition then it will suspend
- * the lun for increments of 6 sec delays.  SUSPEND_COUNT is that count.
- */
-#define SUSPEND_COUNT		10	/* 6 secs * 10 retries = 60 secs */
-
-/*
- * Defines the time in seconds that the driver extends the command timeout to
- * get around the problem where the mid-layer only allows 5 retries for
- * commands that return BUS_BUSY
- */
-#define EXTEND_CMD_TIMEOUT	60
-
 #define MAX_RETRIES_OF_ISP_ABORT	5
 
 /* Max time to wait for the loop to be in LOOP_READY state */
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -31,7 +31,7 @@ static void qla2x00_nv_write(scsi_qla_ho
  */
 
 /**
- * qla2x00_lock_nvram_access() - 
+ * qla2x00_lock_nvram_access() -
  * @ha: HA context
  */
 void
@@ -64,7 +64,7 @@ qla2x00_lock_nvram_access(scsi_qla_host_
 }
 
 /**
- * qla2x00_unlock_nvram_access() - 
+ * qla2x00_unlock_nvram_access() -
  * @ha: HA context
  */
 void
@@ -542,18 +542,18 @@ qla24xx_write_flash_data(scsi_qla_host_t
 
 	conf_addr = flash_conf_to_access_addr(0x03d8);
 	switch (man_id) {
-	case 0xbf: // STT flash
+	case 0xbf: /* STT flash. */
 		rest_addr = 0x1fff;
 		sec_mask = 0x3e000;
 		if (flash_id == 0x80)
 			conf_addr = flash_conf_to_access_addr(0x0352);
 		break;
-	case 0x13: // ST M25P80
+	case 0x13: /* ST M25P80. */
 		rest_addr = 0x3fff;
 		sec_mask = 0x3c000;
 		break;
 	default:
-		// Default to 64 kb sector size
+		/* Default to 64 kb sector size. */
 		rest_addr = 0x3fff;
 		sec_mask = 0x3c000;
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -17,7 +17,7 @@
  *
  ******************************************************************************/
 /*
- * Driver version 
+ * Driver version
  */
 #define QLA2XXX_VERSION      "8.00.02b5-k"
 

-- 
Andrew Vasquez
