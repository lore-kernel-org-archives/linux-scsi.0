From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sparse __iomem annotations for qla2xxx
Date: Sat, 9 Oct 2004 15:42:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041009134223.GA19954@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:10131 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266835AbUJINme (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2004 09:42:34 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

this also found a real bug, qla2xxx isn't iounmapping at host removal at
all currently - and if the right cpp macro would have been set it'd be
too late.


===== drivers/scsi/qla2xxx/qla_dbg.c 1.9 vs edited =====
--- 1.9/drivers/scsi/qla2xxx/qla_dbg.c	2004-09-16 23:36:19 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_dbg.c	2004-10-09 14:33:47 +02:00
@@ -36,13 +36,12 @@
 	uint16_t	mb0, mb2;
 
 	uint32_t	stat;
-	device_reg_t	*reg;
-	uint16_t	*dmp_reg;
+	device_reg_t __iomem *reg = ha->iobase;
+	uint16_t __iomem *dmp_reg;
 	unsigned long	flags;
 	struct qla2300_fw_dump	*fw;
 	uint32_t	dump_size, data_ram_cnt;
 
-	reg = ha->iobase;
 	risc_address = data_ram_cnt = 0;
 	mb0 = mb2 = 0;
 	flags = 0;
@@ -91,85 +90,85 @@
 	}
 
 	if (rval == QLA_SUCCESS) {
-		dmp_reg = (uint16_t *)(reg + 0);
+		dmp_reg = (uint16_t __iomem *)(reg + 0);
 		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++) 
 			fw->pbiu_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x10);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x10);
 		for (cnt = 0; cnt < sizeof(fw->risc_host_reg) / 2; cnt++) 
 			fw->risc_host_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x40);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x40);
 		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++) 
 			fw->mailbox_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x40);
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->resp_dma_reg) / 2; cnt++) 
 			fw->resp_dma_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x50);
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++) 
 			fw->dma_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x00);
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0xA0);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0xA0);
 		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++) 
 			fw->risc_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2000); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp0_reg) / 2; cnt++) 
 			fw->risc_gp0_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2200); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp1_reg) / 2; cnt++) 
 			fw->risc_gp1_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2400); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp2_reg) / 2; cnt++) 
 			fw->risc_gp2_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2600); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp3_reg) / 2; cnt++) 
 			fw->risc_gp3_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2800); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp4_reg) / 2; cnt++) 
 			fw->risc_gp4_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2A00); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp5_reg) / 2; cnt++) 
 			fw->risc_gp5_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2C00); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp6_reg) / 2; cnt++) 
 			fw->risc_gp6_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2E00); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp7_reg) / 2; cnt++) 
 			fw->risc_gp7_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x10); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->frame_buf_hdw_reg) / 2; cnt++) 
 			fw->frame_buf_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x20); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->fpm_b0_reg) / 2; cnt++) 
 			fw->fpm_b0_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x30); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++) 
 			fw->fpm_b1_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
@@ -588,13 +587,11 @@
 	uint32_t	cnt, timer;
 	uint16_t	risc_address;
 	uint16_t	mb0, mb2;
-
-	device_reg_t	*reg;
-	uint16_t	*dmp_reg;
+	device_reg_t __iomem *reg = ha->iobase;
+	uint16_t __iomem *dmp_reg;
 	unsigned long	flags;
 	struct qla2100_fw_dump	*fw;
 
-	reg = ha->iobase;
 	risc_address = 0;
 	mb0 = mb2 = 0;
 	flags = 0;
@@ -634,79 +631,79 @@
 			rval = QLA_FUNCTION_TIMEOUT;
 	}
 	if (rval == QLA_SUCCESS) {
-		dmp_reg = (uint16_t *)(reg + 0);
+		dmp_reg = (uint16_t __iomem *)(reg + 0);
 		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++) 
 			fw->pbiu_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x10);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x10);
 		for (cnt = 0; cnt < ha->mbx_count; cnt++) {
 			if (cnt == 8) {
-				dmp_reg = (uint16_t *)((uint8_t *)reg + 0xe0);
+				dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0xe0);
 			}
 			fw->mailbox_reg[cnt] = RD_REG_WORD(dmp_reg++);
 		}
 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x20);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x20);
 		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++) 
 			fw->dma_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x00);
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0xA0);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0xA0);
 		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++) 
 			fw->risc_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2000); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp0_reg) / 2; cnt++) 
 			fw->risc_gp0_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2100); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp1_reg) / 2; cnt++) 
 			fw->risc_gp1_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2200); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp2_reg) / 2; cnt++) 
 			fw->risc_gp2_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2300); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp3_reg) / 2; cnt++) 
 			fw->risc_gp3_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2400); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp4_reg) / 2; cnt++) 
 			fw->risc_gp4_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2500); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp5_reg) / 2; cnt++) 
 			fw->risc_gp5_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2600); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp6_reg) / 2; cnt++) 
 			fw->risc_gp6_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->pcr, 0x2700); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->risc_gp7_reg) / 2; cnt++) 
 			fw->risc_gp7_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x10); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->frame_buf_hdw_reg) / 2; cnt++) 
 			fw->frame_buf_hdw_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x20); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->fpm_b0_reg) / 2; cnt++) 
 			fw->fpm_b0_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
 		WRT_REG_WORD(&reg->ctrl_status, 0x30); 
-		dmp_reg = (uint16_t *)((uint8_t *)reg + 0x80);
+		dmp_reg = (uint16_t __iomem *)((uint8_t __iomem *)reg + 0x80);
 		for (cnt = 0; cnt < sizeof(fw->fpm_b1_reg) / 2; cnt++) 
 			fw->fpm_b1_reg[cnt] = RD_REG_WORD(dmp_reg++);
 
@@ -987,9 +984,7 @@
 void 
 qla2x00_dump_regs(scsi_qla_host_t *ha) 
 {
-	device_reg_t	*reg;
-
-	reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	printk("Mailbox registers:\n");
 	printk("scsi(%ld): mbox 0 0x%04x \n",
===== drivers/scsi/qla2xxx/qla_def.h 1.22 vs edited =====
--- 1.22/drivers/scsi/qla2xxx/qla_def.h	2004-09-10 20:49:34 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_def.h	2004-10-09 15:43:40 +02:00
@@ -2126,11 +2126,9 @@
 
 	spinlock_t		hardware_lock ____cacheline_aligned;
 
-	device_reg_t	*iobase;		/* Base I/O address */
+	device_reg_t __iomem *iobase;		/* Base I/O address */
 	unsigned long	pio_address;
 	unsigned long	pio_length;
-	void *		mmio_address;
-	unsigned long	mmio_length;
 #define MIN_IOBASE_LEN		0x100
 
 	/* ISP ring lock, rings, and indexes */
===== drivers/scsi/qla2xxx/qla_init.c 1.36 vs edited =====
--- 1.36/drivers/scsi/qla2xxx/qla_init.c	2004-10-07 05:05:03 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_init.c	2004-10-09 14:34:56 +02:00
@@ -385,7 +385,7 @@
 qla2x00_reset_chip(scsi_qla_host_t *ha) 
 {
 	unsigned long   flags = 0;
-	device_reg_t	*reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 	uint32_t	cnt;
 	unsigned long	mbx_flags = 0;
 	uint16_t	cmd;
@@ -539,7 +539,7 @@
 qla2x00_chip_diag(scsi_qla_host_t *ha)
 {
 	int		rval;
-	device_reg_t	*reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 	unsigned long	flags = 0;
 	uint16_t	data;
 	uint32_t	cnt;
@@ -905,7 +905,7 @@
 	int	rval;
 	unsigned long flags = 0;
 	int cnt;
-	device_reg_t *reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -1192,7 +1192,7 @@
 	init_cb_t *icb   = ha->init_cb;
 	nvram_t *nv    = (nvram_t *)ha->request_ring;
 	uint16_t  *wptr  = (uint16_t *)ha->request_ring;
-	device_reg_t *reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 	uint8_t  timer_mode;
 
 	rval = QLA_SUCCESS;
@@ -4271,7 +4271,7 @@
 qla2x00_restart_isp(scsi_qla_host_t *ha)
 {
 	uint8_t		status = 0;
-	device_reg_t	*reg;
+	device_reg_t __iomem *reg = ha->iobase;
 	unsigned long	flags = 0;
 	uint32_t wait_time;
 
@@ -4356,7 +4356,7 @@
 qla2x00_reset_adapter(scsi_qla_host_t *ha)
 {
 	unsigned long flags = 0;
-	device_reg_t *reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	ha->flags.online = 0;
 	qla2x00_disable_intrs(ha);
===== drivers/scsi/qla2xxx/qla_inline.h 1.5 vs edited =====
--- 1.5/drivers/scsi/qla2xxx/qla_inline.h	2004-09-06 21:07:52 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_inline.h	2004-10-09 14:33:48 +02:00
@@ -18,7 +18,7 @@
  */
 
 
-static __inline__ uint16_t qla2x00_debounce_register(volatile uint16_t *);
+static __inline__ uint16_t qla2x00_debounce_register(volatile uint16_t __iomem *);
 /*
  * qla2x00_debounce_register
  *      Debounce register.
@@ -30,7 +30,7 @@
  *      register value.
  */
 static __inline__ uint16_t
-qla2x00_debounce_register(volatile uint16_t *addr) 
+qla2x00_debounce_register(volatile uint16_t __iomem *addr) 
 {
 	volatile uint16_t first;
 	volatile uint16_t second;
@@ -131,10 +131,9 @@
 qla2x00_enable_intrs(scsi_qla_host_t *ha)
 {
 	unsigned long flags = 0;
-	device_reg_t *reg;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	reg = ha->iobase;
 	ha->interrupts_on = 1;
 	/* enable risc and host interrupts */
 	WRT_REG_WORD(&reg->ictrl, ICR_EN_INT | ICR_EN_RISC);
@@ -147,10 +146,9 @@
 qla2x00_disable_intrs(scsi_qla_host_t *ha)
 {
 	unsigned long flags = 0;
-	device_reg_t *reg;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	reg = ha->iobase;
 	ha->interrupts_on = 0;
 	/* disable risc and host interrupts */
 	WRT_REG_WORD(&reg->ictrl, 0);
===== drivers/scsi/qla2xxx/qla_iocb.c 1.13 vs edited =====
--- 1.13/drivers/scsi/qla2xxx/qla_iocb.c	2004-09-06 21:07:36 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_iocb.c	2004-10-09 14:33:48 +02:00
@@ -338,15 +338,15 @@
 	uint16_t	cnt;
 	uint16_t	req_cnt;
 	uint16_t	tot_dsds;
-	device_reg_t	*reg;
+	device_reg_t __iomem *reg;
 	char		tag[2];
 
 	/* Setup device pointers. */
 	ret = 0;
 	fclun = sp->lun_queue->fclun;
 	ha = fclun->fcport->ha;
-	cmd = sp->cmd;
 	reg = ha->iobase;
+	cmd = sp->cmd;
 
 	/* Send marker if required */
 	if (ha->marker_needed != 0) {
@@ -547,7 +547,7 @@
 request_t *
 qla2x00_req_pkt(scsi_qla_host_t *ha)
 {
-	device_reg_t	*reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 	request_t	*pkt = NULL;
 	uint16_t	cnt;
 	uint32_t	*dword_ptr;
@@ -616,7 +616,7 @@
 request_t *
 qla2x00_ms_req_pkt(scsi_qla_host_t *ha, srb_t  *sp)
 {
-	device_reg_t	*reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 	request_t	*pkt = NULL;
 	uint16_t	cnt, i, index;
 	uint32_t	*dword_ptr;
@@ -706,7 +706,7 @@
 void
 qla2x00_isp_cmd(scsi_qla_host_t *ha)
 {
-	device_reg_t *reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	DEBUG5(printk("%s(): IOCB data:\n", __func__));
 	DEBUG5(qla2x00_dump_buffer(
===== drivers/scsi/qla2xxx/qla_isr.c 1.17 vs edited =====
--- 1.17/drivers/scsi/qla2xxx/qla_isr.c	2004-09-06 21:07:52 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_isr.c	2004-10-09 14:36:44 +02:00
@@ -43,7 +43,7 @@
 qla2100_intr_handler(int irq, void *dev_id, struct pt_regs *regs)
 {
 	scsi_qla_host_t	*ha;
-	device_reg_t	*reg;
+	device_reg_t __iomem *reg;
 	int		status;
 	unsigned long	flags;
 	unsigned long	iter;
@@ -127,7 +127,7 @@
 qla2300_intr_handler(int irq, void *dev_id, struct pt_regs *regs)
 {
 	scsi_qla_host_t	*ha;
-	device_reg_t	*reg;
+	device_reg_t __iomem *reg;
 	int		status;
 	unsigned long	flags;
 	unsigned long	iter;
@@ -235,17 +235,17 @@
 qla2x00_mbx_completion(scsi_qla_host_t *ha, uint16_t mb0)
 {
 	uint16_t	cnt;
-	uint16_t	*wptr;
-	device_reg_t	*reg = ha->iobase;
+	uint16_t __iomem *wptr;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	/* Load return mailbox registers. */
 	ha->flags.mbox_int = 1;
 	ha->mailbox_out[0] = mb0;
-	wptr = (uint16_t *)MAILBOX_REG(ha, reg, 1);
+	wptr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 1);
 
 	for (cnt = 1; cnt < ha->mbx_count; cnt++) {
 		if (IS_QLA2200(ha) && cnt == 8) 
-			wptr = (uint16_t *)MAILBOX_REG(ha, reg, 8);
+			wptr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 8);
 		if (cnt == 4 || cnt == 5)
 			ha->mailbox_out[cnt] = qla2x00_debounce_register(wptr);
 		else
@@ -277,7 +277,7 @@
 	uint16_t	handle_cnt;
 	uint16_t	cnt;
 	uint32_t	handles[5];
-	device_reg_t	*reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 	uint32_t	rscn_entry, host_pid;
 	uint8_t		rscn_queue_index;
 
@@ -724,7 +724,7 @@
 void
 qla2x00_process_response_queue(struct scsi_qla_host *ha)
 {
-	device_reg_t	*reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 	sts_entry_t	*pkt;
 	uint16_t        handle_cnt;
 	uint16_t        cnt;
===== drivers/scsi/qla2xxx/qla_mbx.c 1.14 vs edited =====
--- 1.14/drivers/scsi/qla2xxx/qla_mbx.c	2004-09-10 20:49:34 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_mbx.c	2004-10-09 14:33:48 +02:00
@@ -58,12 +58,13 @@
 {
 	int		rval;
 	unsigned long    flags = 0;
-	device_reg_t     *reg       = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 	struct timer_list	tmp_intr_timer;
 	uint8_t		abort_active = test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 	uint8_t		io_lock_on = ha->flags.init_done;
 	uint16_t	command;
-	uint16_t	*iptr, *optr;
+	uint16_t	*iptr;
+	uint16_t __iomem *optr;
 	uint32_t	cnt;
 	uint32_t	mboxes;
 	unsigned long	mbx_flags = 0;
@@ -101,7 +102,7 @@
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Load mailbox registers. */
-	optr = (uint16_t *)MAILBOX_REG(ha, reg, 0);
+	optr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 0);
 
 	iptr = mcp->mb;
 	command = mcp->mb[0];
@@ -109,7 +110,7 @@
 
 	for (cnt = 0; cnt < ha->mbx_count; cnt++) {
 		if (IS_QLA2200(ha) && cnt == 8)
-			optr = (uint16_t *)MAILBOX_REG(ha, reg, 8);
+			optr = (uint16_t __iomem *)MAILBOX_REG(ha, reg, 8);
 		if (mboxes & BIT_0)
 			WRT_REG_WORD(optr, *iptr);
 
@@ -209,6 +210,7 @@
 
 	/* Check whether we timed out */
 	if (ha->flags.mbox_int) {
+		uint16_t *iptr2;
 
 		DEBUG3_11(printk("qla2x00_mailbox_cmd: cmd %x completed.\n",
 		    command);)
@@ -223,15 +225,15 @@
 		}
 
 		/* Load return mailbox registers. */
-		optr = mcp->mb;
+		iptr2 = mcp->mb;
 		iptr = (uint16_t *)&ha->mailbox_out[0];
 		mboxes = mcp->in_mb;
 		for (cnt = 0; cnt < ha->mbx_count; cnt++) {
 			if (mboxes & BIT_0)
-				*optr = *iptr;
+				*iptr2 = *iptr;
 
 			mboxes >>= 1;
-			optr++;
+			iptr2++;
 			iptr++;
 		}
 	} else {
===== drivers/scsi/qla2xxx/qla_os.c 1.47 vs edited =====
--- 1.47/drivers/scsi/qla2xxx/qla_os.c	2004-09-14 05:28:52 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2004-10-09 15:43:30 +02:00
@@ -845,11 +845,9 @@
 		was_empty = add_to_pending_queue(ha, sp);
 
 	if ((IS_QLA2100(ha) || IS_QLA2200(ha)) && ha->flags.online) {
-		unsigned long flags;
-		device_reg_t *reg;
-		reg = ha->iobase;
-		
 		if (ha->response_ring_ptr->signature != RESPONSE_PROCESSED) {
+			unsigned long flags;
+
 			spin_lock_irqsave(&ha->hardware_lock, flags);	
 			qla2x00_process_response_queue(ha);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -1890,15 +1888,13 @@
 
 	ha->pio_address = pio;
 	ha->pio_length = pio_len;
-	ha->mmio_address = ioremap(mmio, MIN_IOBASE_LEN);
-	if (!ha->mmio_address) {
+	ha->iobase = ioremap(mmio, MIN_IOBASE_LEN);
+	if (!ha->iobase) {
 		qla_printk(KERN_ERR, ha,
 		    "cannot remap MMIO (%s), aborting\n", ha->pdev->slot_name);
 
 		goto iospace_error_exit;
 	}
-	ha->mmio_length = mmio_len;
-	ha->iobase = (device_reg_t *) ha->mmio_address;
 
 	return (0);
 
@@ -1912,7 +1908,7 @@
 int qla2x00_probe_one(struct pci_dev *pdev, struct qla_board_info *brd_info)
 {
 	int	ret;
-	device_reg_t *reg;
+	device_reg_t __iomem *reg;
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
 	unsigned long	flags = 0;
@@ -2225,14 +2221,11 @@
 		free_irq(ha->pdev->irq, ha);
 
 	/* release io space registers  */
+	if (ha->iobase)
+		iounmap(ha->iobase);
 	pci_release_regions(ha->pdev);
 
 	pci_disable_device(ha->pdev);
-
-#if MEMORY_MAPPED_IO
-	if (ha->mmio_address)
-		iounmap(ha->mmio_address);
-#endif
 }
 
 
===== drivers/scsi/qla2xxx/qla_rscn.c 1.8 vs edited =====
--- 1.8/drivers/scsi/qla2xxx/qla_rscn.c	2004-07-29 16:58:59 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_rscn.c	2004-10-09 14:33:48 +02:00
@@ -374,10 +374,9 @@
 qla2x00_get_mbx_iocb_entry(scsi_qla_host_t *ha, uint32_t handle)
 {
 	uint16_t cnt;
-	device_reg_t *reg;
+	device_reg_t __iomem *reg = ha->iobase;
 	struct mbx_entry *mbxentry;
 
-	reg = ha->iobase;
 	mbxentry = NULL;
 
 	if (ha->req_q_cnt < 3) {
===== drivers/scsi/qla2xxx/qla_sup.c 1.6 vs edited =====
--- 1.6/drivers/scsi/qla2xxx/qla_sup.c	2004-09-06 21:06:47 +02:00
+++ edited/drivers/scsi/qla2xxx/qla_sup.c	2004-10-09 14:33:49 +02:00
@@ -39,9 +39,7 @@
 qla2x00_lock_nvram_access(scsi_qla_host_t *ha)
 {
 	uint16_t data;
-	device_reg_t *reg;
-
-	reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA2300(ha)) {
 		data = RD_REG_WORD(&reg->nvram);
@@ -73,9 +71,7 @@
 void
 qla2x00_unlock_nvram_access(scsi_qla_host_t *ha)
 {
-	device_reg_t *reg;
-
-	reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA2300(ha)) {
 		WRT_REG_WORD(&reg->u.isp2300.host_semaphore, 0);
@@ -116,7 +112,7 @@
 	int count;
 	uint16_t word;
 	uint32_t nv_cmd;
-	device_reg_t *reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	qla2x00_nv_write(ha, NVR_DATA_OUT);
 	qla2x00_nv_write(ha, 0);
@@ -201,7 +197,7 @@
 qla2x00_nvram_request(scsi_qla_host_t *ha, uint32_t nv_cmd)
 {
 	uint8_t		cnt;
-	device_reg_t	*reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 	uint16_t	data = 0;
 	uint16_t	reg_data;
 
@@ -243,7 +239,7 @@
 void
 qla2x00_nv_deselect(scsi_qla_host_t *ha)
 {
-	device_reg_t *reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	WRT_REG_WORD(&reg->nvram, NVR_DESELECT);
 	NVRAM_DELAY();
@@ -258,7 +254,7 @@
 void
 qla2x00_nv_write(scsi_qla_host_t *ha, uint16_t data)
 {
-	device_reg_t *reg = ha->iobase;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	WRT_REG_WORD(&reg->nvram, data | NVR_SELECT);
 	NVRAM_DELAY();
