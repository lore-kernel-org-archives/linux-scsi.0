From: Ondrej Zary <linux@zary.sk>
Subject: [PATCH] fdomain: Add register definitions
Date: Sat, 18 May 2019 21:47:24 +0200
Message-ID: <20190518194724.30711-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add register bit definitions from documentation to header file and use
them instead of magic constants. No changes to generated binary.

Signed-off-by: Ondrej Zary <linux@zary.sk>
---
 drivers/scsi/fdomain.c     | 144 ++++++++++++++++++++++++---------------------
 drivers/scsi/fdomain.h     | 117 +++++++++++++++++++++++++++---------
 drivers/scsi/fdomain_isa.c |   4 +-
 3 files changed, 167 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 19af1ae608df..297ccc799436 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -99,7 +99,7 @@
  * up the machine.
  */
 #define FIFO_COUNT	2	/* Number of 512 byte blocks before INTR */
-#define PARITY_MASK	0x08	/* Parity enabled, 0x00 = disabled */
+#define PARITY_MASK	ACTL_PAREN	/* Parity enabled, 0 = disabled */
 
 enum chip_type {
 	unknown		= 0x00,
@@ -117,18 +117,19 @@ struct fdomain {
 
 static inline void fdomain_make_bus_idle(struct fdomain *fd)
 {
-	outb(0, fd->base + SCSI_Cntl);
-	outb(0, fd->base + SCSI_Mode_Cntl);
+	outb(0, fd->base + REG_BCTL);
+	outb(0, fd->base + REG_MCTL);
 	if (fd->chip == tmc18c50 || fd->chip == tmc18c30)
 		/* Clear forced intr. */
-		outb(0x21 | PARITY_MASK, fd->base + TMC_Cntl);
+		outb(ACTL_RESET | ACTL_CLRFIRQ | PARITY_MASK,
+		     fd->base + REG_ACTL);
 	else
-		outb(0x01 | PARITY_MASK, fd->base + TMC_Cntl);
+		outb(ACTL_RESET | PARITY_MASK, fd->base + REG_ACTL);
 }
 
 static enum chip_type fdomain_identify(int port)
 {
-	u16 id = inb(port + LSB_ID_Code) | inb(port + MSB_ID_Code) << 8;
+	u16 id = inb(port + REG_ID_LSB) | inb(port + REG_ID_MSB) << 8;
 
 	switch (id) {
 	case 0x6127:
@@ -140,10 +141,10 @@ static enum chip_type fdomain_identify(int port)
 	}
 
 	/* Try to toggle 32-bit mode. This only works on an 18c30 chip. */
-	outb(0x80, port + IO_Control);
-	if ((inb(port + Configuration2) & 0x80) == 0x80) {
-		outb(0x00, port + IO_Control);
-		if ((inb(port + Configuration2) & 0x80) == 0x00)
+	outb(CFG2_32BIT, port + REG_CFG2);
+	if ((inb(port + REG_CFG2) & CFG2_32BIT)) {
+		outb(0, port + REG_CFG2);
+		if ((inb(port + REG_CFG2) & CFG2_32BIT) == 0)
 			return tmc18c30;
 	}
 	/* If that failed, we are an 18c50. */
@@ -155,8 +156,8 @@ static int fdomain_test_loopback(int base)
 	int i;
 
 	for (i = 0; i < 255; i++) {
-		outb(i, base + Write_Loopback);
-		if (inb(base + Read_Loopback) != i)
+		outb(i, base + REG_LOOPBACK);
+		if (inb(base + REG_LOOPBACK) != i)
 			return 1;
 	}
 
@@ -165,12 +166,12 @@ static int fdomain_test_loopback(int base)
 
 static void fdomain_reset(int base)
 {
-	outb(1, base + SCSI_Cntl);
+	outb(1, base + REG_BCTL);
 	mdelay(20);
-	outb(0, base + SCSI_Cntl);
+	outb(0, base + REG_BCTL);
 	mdelay(1150);
-	outb(0, base + SCSI_Mode_Cntl);
-	outb(PARITY_MASK, base + TMC_Cntl);
+	outb(0, base + REG_MCTL);
+	outb(PARITY_MASK, base + REG_ACTL);
 }
 
 static int fdomain_select(struct Scsi_Host *sh, int target)
@@ -179,20 +180,20 @@ static int fdomain_select(struct Scsi_Host *sh, int target)
 	unsigned long timeout;
 	struct fdomain *fd = shost_priv(sh);
 
-	outb(0x82, fd->base + SCSI_Cntl); /* Bus Enable + Select */
-	outb(BIT(sh->this_id) | BIT(target), fd->base + SCSI_Data_NoACK);
+	outb(BCTL_BUSEN | BCTL_SEL, fd->base + REG_BCTL);
+	outb(BIT(sh->this_id) | BIT(target), fd->base + REG_SCSI_DATA_NOACK);
 
 	/* Stop arbitration and enable parity */
-	outb(PARITY_MASK, fd->base + TMC_Cntl);
+	outb(PARITY_MASK, fd->base + REG_ACTL);
 
 	timeout = 350;	/* 350 msec */
 
 	do {
-		status = inb(fd->base + SCSI_Status); /* Read adapter status */
-		if (status & 1) {	/* Busy asserted */
+		status = inb(fd->base + REG_BSTAT);
+		if (status & BSTAT_BSY) {
 			/* Enable SCSI Bus */
 			/* (on error, should make bus idle with 0) */
-			outb(0x80, fd->base + SCSI_Cntl);
+			outb(BCTL_BUSEN, fd->base + REG_BCTL);
 			return 0;
 		}
 		mdelay(1);
@@ -203,7 +204,7 @@ static int fdomain_select(struct Scsi_Host *sh, int target)
 
 static void fdomain_finish_cmd(struct fdomain *fd, int result)
 {
-	outb(0x00, fd->base + Interrupt_Cntl);
+	outb(0, fd->base + REG_ICTL);
 	fdomain_make_bus_idle(fd);
 	fd->cur_cmd->result = result;
 	fd->cur_cmd->scsi_done(fd->cur_cmd);
@@ -216,15 +217,15 @@ static void fdomain_read_data(struct scsi_cmnd *cmd)
 	unsigned char *virt, *ptr;
 	size_t offset, len;
 
-	while ((len = inw(fd->base + FIFO_Data_Count)) > 0) {
+	while ((len = inw(fd->base + REG_FIFO_COUNT)) > 0) {
 		offset = scsi_bufflen(cmd) - scsi_get_resid(cmd);
 		virt = scsi_kmap_atomic_sg(scsi_sglist(cmd), scsi_sg_count(cmd),
 					   &offset, &len);
 		ptr = virt + offset;
 		if (len & 1)
-			*ptr++ = inb(fd->base + Read_FIFO);
+			*ptr++ = inb(fd->base + REG_FIFO);
 		if (len > 1)
-			insw(fd->base + Read_FIFO, ptr, len >> 1);
+			insw(fd->base + REG_FIFO, ptr, len >> 1);
 		scsi_set_resid(cmd, scsi_get_resid(cmd) - len);
 		scsi_kunmap_atomic_sg(virt);
 	}
@@ -238,7 +239,7 @@ static void fdomain_write_data(struct scsi_cmnd *cmd)
 	unsigned char *virt, *ptr;
 	size_t offset, len;
 
-	while ((len = FIFO_Size - inw(fd->base + FIFO_Data_Count)) > 512) {
+	while ((len = FIFO_Size - inw(fd->base + REG_FIFO_COUNT)) > 512) {
 		offset = scsi_bufflen(cmd) - scsi_get_resid(cmd);
 		if (len + offset > scsi_bufflen(cmd)) {
 			len = scsi_bufflen(cmd) - offset;
@@ -249,9 +250,9 @@ static void fdomain_write_data(struct scsi_cmnd *cmd)
 					   &offset, &len);
 		ptr = virt + offset;
 		if (len & 1)
-			outb(*ptr++, fd->base + Write_FIFO);
+			outb(*ptr++, fd->base + REG_FIFO);
 		if (len > 1)
-			outsw(fd->base + Write_FIFO, ptr, len >> 1);
+			outsw(fd->base + REG_FIFO, ptr, len >> 1);
 		scsi_set_resid(cmd, scsi_get_resid(cmd) - len);
 		scsi_kunmap_atomic_sg(virt);
 	}
@@ -270,66 +271,68 @@ static void fdomain_work(struct work_struct *work)
 	spin_lock_irqsave(sh->host_lock, flags);
 
 	if (cmd->SCp.phase & in_arbitration) {
-		status = inb(fd->base + TMC_Status);
-		if (!(status & 0x02)) {
+		status = inb(fd->base + REG_ASTAT);
+		if (!(status & ASTAT_ARB)) {
 			fdomain_finish_cmd(fd, DID_BUS_BUSY << 16);
 			goto out;
 		}
 		cmd->SCp.phase = in_selection;
 
-		outb(0x40 | FIFO_COUNT, fd->base + Interrupt_Cntl);
-		outb(0x82, fd->base + SCSI_Cntl); /* Bus Enable + Select */
-		outb(BIT(cmd->device->host->this_id) |
-		     BIT(scmd_id(cmd)), fd->base + SCSI_Data_NoACK);
+		outb(ICTL_SEL | FIFO_COUNT, fd->base + REG_ICTL);
+		outb(BCTL_BUSEN | BCTL_SEL, fd->base + REG_BCTL);
+		outb(BIT(cmd->device->host->this_id) | BIT(scmd_id(cmd)),
+		     fd->base + REG_SCSI_DATA_NOACK);
 		/* Stop arbitration and enable parity */
-		outb(0x10 | PARITY_MASK, fd->base + TMC_Cntl);
+		outb(ACTL_IRQEN | PARITY_MASK, fd->base + REG_ACTL);
 		goto out;
 	} else if (cmd->SCp.phase & in_selection) {
-		status = inb(fd->base + SCSI_Status);
-		if (!(status & 0x01)) {
+		status = inb(fd->base + REG_BSTAT);
+		if (!(status & BSTAT_BSY)) {
 			/* Try again, for slow devices */
 			if (fdomain_select(cmd->device->host, scmd_id(cmd))) {
 				fdomain_finish_cmd(fd, DID_NO_CONNECT << 16);
 				goto out;
 			}
 			/* Stop arbitration and enable parity */
-			outb(0x10 | PARITY_MASK, fd->base + TMC_Cntl);
+			outb(ACTL_IRQEN | PARITY_MASK, fd->base + REG_ACTL);
 		}
 		cmd->SCp.phase = in_other;
-		outb(0x90 | FIFO_COUNT, fd->base + Interrupt_Cntl);
-		outb(0x80, fd->base + SCSI_Cntl);
+		outb(ICTL_FIFO | ICTL_REQ | FIFO_COUNT, fd->base + REG_ICTL);
+		outb(BCTL_BUSEN, fd->base + REG_BCTL);
 		goto out;
 	}
 
 	/* cur_cmd->SCp.phase == in_other: this is the body of the routine */
-	status = inb(fd->base + SCSI_Status);
+	status = inb(fd->base + REG_BSTAT);
 
-	if (status & 0x10) {	/* REQ */
+	if (status & BSTAT_REQ) {
 		switch (status & 0x0e) {
-		case 0x08:	/* COMMAND OUT */
+		case BSTAT_CMD:	/* COMMAND OUT */
 			outb(cmd->cmnd[cmd->SCp.sent_command++],
-			     fd->base + Write_SCSI_Data);
+			     fd->base + REG_SCSI_DATA);
 			break;
-		case 0x00:	/* DATA OUT -- tmc18c50/tmc18c30 only */
+		case 0:	/* DATA OUT -- tmc18c50/tmc18c30 only */
 			if (fd->chip != tmc1800 && !cmd->SCp.have_data_in) {
 				cmd->SCp.have_data_in = -1;
-				outb(0xd0 | PARITY_MASK, fd->base + TMC_Cntl);
+				outb(ACTL_IRQEN | ACTL_FIFOWR | ACTL_FIFOEN |
+				     PARITY_MASK, fd->base + REG_ACTL);
 			}
 			break;
-		case 0x04:	/* DATA IN -- tmc18c50/tmc18c30 only */
+		case BSTAT_IO:	/* DATA IN -- tmc18c50/tmc18c30 only */
 			if (fd->chip != tmc1800 && !cmd->SCp.have_data_in) {
 				cmd->SCp.have_data_in = 1;
-				outb(0x90 | PARITY_MASK, fd->base + TMC_Cntl);
+				outb(ACTL_IRQEN | ACTL_FIFOEN | PARITY_MASK,
+				     fd->base + REG_ACTL);
 			}
 			break;
-		case 0x0c:	/* STATUS IN */
-			cmd->SCp.Status = inb(fd->base + Read_SCSI_Data);
+		case BSTAT_CMD | BSTAT_IO:	/* STATUS IN */
+			cmd->SCp.Status = inb(fd->base + REG_SCSI_DATA);
 			break;
-		case 0x0a:	/* MESSAGE OUT */
-			outb(MESSAGE_REJECT, fd->base + Write_SCSI_Data);
+		case BSTAT_MSG | BSTAT_CMD:	/* MESSAGE OUT */
+			outb(MESSAGE_REJECT, fd->base + REG_SCSI_DATA);
 			break;
-		case 0x0e:	/* MESSAGE IN */
-			cmd->SCp.Message = inb(fd->base + Read_SCSI_Data);
+		case BSTAT_MSG | BSTAT_IO | BSTAT_CMD:	/* MESSAGE IN */
+			cmd->SCp.Message = inb(fd->base + REG_SCSI_DATA);
 			if (!cmd->SCp.Message)
 				++done;
 			break;
@@ -340,10 +343,12 @@ static void fdomain_work(struct work_struct *work)
 	    cmd->SCp.sent_command >= cmd->cmd_len) {
 		if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 			cmd->SCp.have_data_in = -1;
-			outb(0xd0 | PARITY_MASK, fd->base + TMC_Cntl);
+			outb(ACTL_IRQEN | ACTL_FIFOWR | ACTL_FIFOEN |
+			     PARITY_MASK, fd->base + REG_ACTL);
 		} else {
 			cmd->SCp.have_data_in = 1;
-			outb(0x90 | PARITY_MASK, fd->base + TMC_Cntl);
+			outb(ACTL_IRQEN | ACTL_FIFOEN | PARITY_MASK,
+			     fd->base + REG_ACTL);
 		}
 	}
 
@@ -359,10 +364,12 @@ static void fdomain_work(struct work_struct *work)
 				   (DID_OK << 16));
 	} else {
 		if (cmd->SCp.phase & disconnect) {
-			outb(0xd0 | FIFO_COUNT, fd->base + Interrupt_Cntl);
-			outb(0x00, fd->base + SCSI_Cntl);
+			outb(ICTL_FIFO | ICTL_SEL | ICTL_REQ | FIFO_COUNT,
+			     fd->base + REG_ICTL);
+			outb(0, fd->base + REG_BCTL);
 		} else
-			outb(0x90 | FIFO_COUNT, fd->base + Interrupt_Cntl);
+			outb(ICTL_FIFO | ICTL_REQ | FIFO_COUNT,
+			     fd->base + REG_ICTL);
 	}
 out:
 	spin_unlock_irqrestore(sh->host_lock, flags);
@@ -373,10 +380,10 @@ static irqreturn_t fdomain_irq(int irq, void *dev_id)
 	struct fdomain *fd = dev_id;
 
 	/* Is it our IRQ? */
-	if ((inb(fd->base + TMC_Status) & 0x01) == 0)
+	if ((inb(fd->base + REG_ASTAT) & ASTAT_IRQ) == 0)
 		return IRQ_NONE;
 
-	outb(0x00, fd->base + Interrupt_Cntl);
+	outb(0, fd->base + REG_ICTL);
 
 	/* We usually have one spurious interrupt after each command. */
 	if (!fd->cur_cmd)	/* Spurious interrupt */
@@ -406,12 +413,13 @@ static int fdomain_queue(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	fdomain_make_bus_idle(fd);
 
 	/* Start arbitration */
-	outb(0x00, fd->base + Interrupt_Cntl);
-	outb(0x00, fd->base + SCSI_Cntl);	/* Disable data drivers */
-	outb(BIT(cmd->device->host->this_id),
-	     fd->base + SCSI_Data_NoACK);	/* Set our id bit */
-	outb(0x20, fd->base + Interrupt_Cntl);
-	outb(0x14 | PARITY_MASK, fd->base + TMC_Cntl);	/* Start arbitration */
+	outb(0, fd->base + REG_ICTL);
+	outb(0, fd->base + REG_BCTL);	/* Disable data drivers */
+	/* Set our id bit */
+	outb(BIT(cmd->device->host->this_id), fd->base + REG_SCSI_DATA_NOACK);
+	outb(ICTL_ARB, fd->base + REG_ICTL);
+	/* Start arbitration */
+	outb(ACTL_ARB | ACTL_IRQEN | PARITY_MASK, fd->base + REG_ACTL);
 
 	spin_unlock_irqrestore(sh->host_lock, flags);
 
diff --git a/drivers/scsi/fdomain.h b/drivers/scsi/fdomain.h
index fabb2e49461f..6f63fc6b0d12 100644
--- a/drivers/scsi/fdomain.h
+++ b/drivers/scsi/fdomain.h
@@ -12,34 +12,95 @@ enum {
 	sent_ident	= 0x40,
 };
 
-enum in_port_type {
-	Read_SCSI_Data	 =  0,
-	SCSI_Status	 =  1,
-	TMC_Status	 =  2,
-	FIFO_Status	 =  3,	/* tmc18c50/tmc18c30 only */
-	Interrupt_Cond	 =  4,	/* tmc18c50/tmc18c30 only */
-	LSB_ID_Code	 =  5,
-	MSB_ID_Code	 =  6,
-	Read_Loopback	 =  7,
-	SCSI_Data_NoACK	 =  8,
-	Interrupt_Status =  9,
-	Configuration1	 = 10,
-	Configuration2	 = 11,	/* tmc18c50/tmc18c30 only */
-	Read_FIFO	 = 12,
-	FIFO_Data_Count	 = 14
-};
-
-enum out_port_type {
-	Write_SCSI_Data	=  0,
-	SCSI_Cntl	=  1,
-	Interrupt_Cntl	=  2,
-	SCSI_Mode_Cntl	=  3,
-	TMC_Cntl	=  4,
-	Memory_Cntl	=  5,	/* tmc18c50/tmc18c30 only */
-	Write_Loopback	=  7,
-	IO_Control	= 11,	/* tmc18c30 only */
-	Write_FIFO	= 12
-};
+/* (@) = not present on TMC1800, (#) = not present on TMC1800 and TMC18C50 */
+#define REG_SCSI_DATA		0	/* R/W: SCSI Data (with ACK) */
+#define REG_BSTAT		1	/* R: SCSI Bus Status */
+#define		BSTAT_BSY	BIT(0)	 /* Busy */
+#define		BSTAT_MSG	BIT(1)	 /* Message */
+#define		BSTAT_IO	BIT(2)	 /* Input/Output */
+#define		BSTAT_CMD	BIT(3)	 /* Command/Data */
+#define		BSTAT_REQ	BIT(4)	 /* Request and Not Ack */
+#define		BSTAT_SEL	BIT(5)	 /* Select */
+#define		BSTAT_ACK	BIT(6)	 /* Acknowledge and Request */
+#define		BSTAT_ATN	BIT(7)	 /* Attention */
+#define REG_BCTL		1	/* W: SCSI Bus Control */
+#define		BCTL_RST	BIT(0)	 /* Bus Reset */
+#define		BCTL_SEL	BIT(1)	 /* Select */
+#define		BCTL_BSY	BIT(2)	 /* Busy */
+#define		BCTL_ATN	BIT(3)	 /* Attention */
+#define		BCTL_IO		BIT(4)	 /* Input/Output */
+#define		BCTL_CMD	BIT(5)	 /* Command/Data */
+#define		BCTL_MSG	BIT(6)	 /* Message */
+#define		BCTL_BUSEN	BIT(7)	 /* Enable bus drivers */
+#define REG_ASTAT		2	/* R: Adapter Status 1 */
+#define		ASTAT_IRQ	BIT(0)	 /* Interrupt active */
+#define		ASTAT_ARB	BIT(1)	 /* Arbitration complete */
+#define		ASTAT_PARERR	BIT(2)	 /* Parity error */
+#define		ASTAT_RST	BIT(3)	 /* SCSI reset occurred */
+#define		ASTAT_FIFODIR	BIT(4)	 /* FIFO direction */
+#define		ASTAT_FIFOEN	BIT(5)	 /* FIFO enabled */
+#define		ASTAT_PAREN	BIT(6)	 /* Parity enabled */
+#define		ASTAT_BUSEN	BIT(7)	 /* Bus drivers enabled */
+#define REG_ICTL		2	/* W: Interrupt Control */
+#define		ICTL_FIFO_MASK	0x0f	 /* FIFO threshold, 1/16 FIFO size */
+#define		ICTL_FIFO	BIT(4)	 /* Int. on FIFO count */
+#define		ICTL_ARB	BIT(5)	 /* Int. on Arbitration complete */
+#define		ICTL_SEL	BIT(6)	 /* Int. on SCSI Select */
+#define		ICTL_REQ	BIT(7)	 /* Int. on SCSI Request */
+#define REG_FSTAT		3	/* R: Adapter Status 2 (FIFO) - (@) */
+#define		FSTAT_ONOTEMPTY	BIT(0)	 /* Output FIFO not empty */
+#define		FSTAT_INOTEMPTY	BIT(1)	 /* Input FIFO not empty */
+#define		FSTAT_NOTEMPTY	BIT(2)	 /* Main FIFO not empty */
+#define		FSTAT_NOTFULL	BIT(3)	 /* Main FIFO not full */
+#define REG_MCTL		3	/* W: SCSI Data Mode Control */
+#define		MCTL_ACK_MASK	0x0f	 /* Acknowledge period */
+#define		MCTL_ACTDEASS	BIT(4)	 /* Active deassert of REQ and ACK */
+#define		MCTL_TARGET	BIT(5)	 /* Enable target mode */
+#define		MCTL_FASTSYNC	BIT(6)	 /* Enable Fast Synchronous */
+#define		MCTL_SYNC	BIT(7)	 /* Enable Synchronous */
+#define REG_INTCOND		4	/* R: Interrupt Condition - (@) */
+#define		IRQ_FIFO	BIT(1)	 /* FIFO interrupt */
+#define		IRQ_REQ		BIT(2)	 /* SCSI Request interrupt */
+#define		IRQ_SEL		BIT(3)	 /* SCSI Select interrupt */
+#define		IRQ_ARB		BIT(4)	 /* SCSI Arbitration interrupt */
+#define		IRQ_RST		BIT(5)	 /* SCSI Reset interrupt */
+#define		IRQ_FORCED	BIT(6)	 /* Forced interrupt */
+#define		IRQ_TIMEOUT	BIT(7)	 /* Bus timeout */
+#define REG_ACTL		4	/* W: Adapter Control 1 */
+#define		ACTL_RESET	BIT(0)	 /* Reset FIFO, parity, reset int. */
+#define		ACTL_FIRQ	BIT(1)	 /* Set Forced interrupt */
+#define		ACTL_ARB	BIT(2)	 /* Initiate Bus Arbitration */
+#define		ACTL_PAREN	BIT(3)	 /* Enable SCSI Parity */
+#define		ACTL_IRQEN	BIT(4)	 /* Enable interrupts */
+#define		ACTL_CLRFIRQ	BIT(5)	 /* Clear Forced interrupt */
+#define		ACTL_FIFOWR	BIT(6)	 /* FIFO Direction (1=write) */
+#define		ACTL_FIFOEN	BIT(7)	 /* Enable FIFO */
+#define REG_ID_LSB		5	/* R: ID Code (LSB) */
+#define REG_ACTL2		5	/* Adapter Control 2 - (@) */
+#define		ACTL2_RAMOVRLY	BIT(0)	 /* Enable RAM overlay */
+#define		ACTL2_SLEEP	BIT(7)	 /* Sleep mode */
+#define REG_ID_MSB		6	/* R: ID Code (MSB) */
+#define REG_LOOPBACK		7	/* R/W: Loopback */
+#define REG_SCSI_DATA_NOACK	8	/* R/W: SCSI Data (no ACK) */
+#define REG_ASTAT3		9	/* R: Adapter Status 3 */
+#define		ASTAT3_ACTDEASS	BIT(0)	 /* Active deassert enabled */
+#define		ASTAT3_RAMOVRLY	BIT(1)	 /* RAM overlay enabled */
+#define		ASTAT3_TARGERR	BIT(2)	 /* Target error */
+#define		ASTAT3_IRQEN	BIT(3)	 /* Interrupts enabled */
+#define		ASTAT3_IRQMASK	0xf0	 /* Enabled interrupts mask */
+#define REG_CFG1		10	/* R: Configuration Register 1 */
+#define		CFG1_BUS	BIT(0)	 /* 0 = ISA */
+#define		CFG1_IRQ_MASK	0x0e	 /* IRQ jumpers */
+#define		CFG1_IO_MASK	0x30	 /* I/O base jumpers */
+#define		CFG1_BIOS_MASK	0xc0	 /* BIOS base jumpers */
+#define REG_CFG2		11	/* R/W: Configuration Register 2 (@) */
+#define		CFG2_ROMDIS	BIT(0)	 /* ROM disabled */
+#define		CFG2_RAMDIS	BIT(1)	 /* RAM disabled */
+#define		CFG2_IRQEDGE	BIT(2)	 /* Edge-triggered interrupts */
+#define		CFG2_NOWS	BIT(3)	 /* No wait states */
+#define		CFG2_32BIT	BIT(7)	 /* 32-bit mode */
+#define REG_FIFO		12	/* R/W: FIFO */
+#define REG_FIFO_COUNT		14	/* R: FIFO Data Count */
 
 #ifdef CONFIG_PM_SLEEP
 static const struct dev_pm_ops fdomain_pm_ops;
diff --git a/drivers/scsi/fdomain_isa.c b/drivers/scsi/fdomain_isa.c
index bca5d56f12aa..28639adf8219 100644
--- a/drivers/scsi/fdomain_isa.c
+++ b/drivers/scsi/fdomain_isa.c
@@ -131,7 +131,7 @@ static int fdomain_isa_match(struct device *dev, unsigned int ndev)
 	if (!request_region(base, FDOMAIN_REGION_SIZE, "fdomain_isa"))
 		return 0;
 
-	irq = irqs[(inb(base + Configuration1) & 0x0e) >> 1];
+	irq = irqs[(inb(base + REG_CFG1) & 0x0e) >> 1];
 
 
 	if (sig)
@@ -164,7 +164,7 @@ static int fdomain_isa_param_match(struct device *dev, unsigned int ndev)
 	}
 
 	if (irq_ <= 0)
-		irq_ = irqs[(inb(io[ndev] + Configuration1) & 0x0e) >> 1];
+		irq_ = irqs[(inb(io[ndev] + REG_CFG1) & 0x0e) >> 1];
 
 	sh = fdomain_create(io[ndev], irq_, scsi_id[ndev], dev);
 	if (!sh) {
-- 
Ondrej Zary
