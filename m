From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
Date: Wed, 9 Jun 2010 20:34:43 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Enable the Online Controller reset bit in the register related functions.  This is first part of the Online Controller Reset.
The driver supports XScle and Gen2 chips.  Driver need to read the FW state register to see if there is FW state change
Happen.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   53 +++++++++++++++++++----------------
 drivers/scsi/megaraid/megaraid_sas.h |   27 +++++++++++++++--
 2 files changed, 52 insertions(+), 28 deletions(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 14:02:55.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 14:32:43.000000000 -0400
@@ -164,7 +164,7 @@ megasas_return_cmd(struct megasas_instan
 static inline void
 megasas_enable_intr_xscale(struct megasas_register_set __iomem * regs)
 {
-	writel(1, &(regs)->outbound_intr_mask);
+	writel(0, &(regs)->outbound_intr_mask);
 
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_intr_mask);
@@ -200,24 +200,27 @@ static int 
 megasas_clear_intr_xscale(struct megasas_register_set __iomem * regs)
 {
 	u32 status;
+	u32 mfiStatus = 0;
 	/*
 	 * Check if it is our interrupt
 	 */
 	status = readl(&regs->outbound_intr_status);
 
-	if (!(status & MFI_OB_INTR_STATUS_MASK)) {
-		return 1;
-	}
+	if (status & MFI_OB_INTR_STATUS_MASK)
+		mfiStatus = MFI_INTR_FLAG_REPLY_MESSAGE;
+	if (status & MFI_XSCALE_OMR0_CHANGE_INTERRUPT)
+		mfiStatus |= MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;
 
 	/*
 	 * Clear the interrupt by writing back the same value
 	 */
-	writel(status, &regs->outbound_intr_status);
+	if (mfiStatus)
+		writel(status, &regs->outbound_intr_status);
 
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_intr_status);
 
-	return 0;
+	return mfiStatus;
 }
 
 /**
@@ -264,7 +267,7 @@ megasas_enable_intr_ppc(struct megasas_r
 {
 	writel(0xFFFFFFFF, &(regs)->outbound_doorbell_clear);
     
-	writel(~0x80000004, &(regs)->outbound_intr_mask);
+	writel(~0x80000000, &(regs)->outbound_intr_mask);
 
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_intr_mask);
@@ -307,7 +310,7 @@ megasas_clear_intr_ppc(struct megasas_re
 	status = readl(&regs->outbound_intr_status);
 
 	if (!(status & MFI_REPLY_1078_MESSAGE_INTERRUPT)) {
-		return 1;
+		return 0;
 	}
 
 	/*
@@ -318,7 +321,7 @@ megasas_clear_intr_ppc(struct megasas_re
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_doorbell_clear);
 
-	return 0;
+	return 1;
 }
 /**
  * megasas_fire_cmd_ppc -	Sends command to the FW
@@ -397,7 +400,7 @@ megasas_clear_intr_skinny(struct megasas
 	status = readl(&regs->outbound_intr_status);
 
 	if (!(status & MFI_SKINNY_ENABLE_INTERRUPT_MASK)) {
-		return 1;
+		return 0;
 	}
 
 	/*
@@ -410,7 +413,7 @@ megasas_clear_intr_skinny(struct megasas
 	*/
 	readl(&regs->outbound_intr_status);
 
-	return 0;
+	return 1;
 }
 
 /**
@@ -425,12 +428,9 @@ megasas_fire_cmd_skinny(struct megasas_i
 			u32 frame_count,
 			struct megasas_register_set __iomem *regs)
 {
-	unsigned long flags;
-	spin_lock_irqsave(&instance->fire_lock, flags);
 	writel(0, &(regs)->inbound_high_queue_port);
 	writel((frame_phys_addr | (frame_count<<1))|1,
 		&(regs)->inbound_low_queue_port);
-	spin_unlock_irqrestore(&instance->fire_lock, flags);
 }
 
 static struct megasas_instance_template megasas_instance_template_skinny = {
@@ -495,23 +495,29 @@ static int
 megasas_clear_intr_gen2(struct megasas_register_set __iomem *regs)
 {
 	u32 status;
+	u32 mfiStatus = 0;
 	/*
 	 * Check if it is our interrupt
 	 */
 	status = readl(&regs->outbound_intr_status);
 
-	if (!(status & MFI_GEN2_ENABLE_INTERRUPT_MASK))
-		return 1;
+	if (status & MFI_GEN2_ENABLE_INTERRUPT_MASK) {
+		mfiStatus = MFI_INTR_FLAG_REPLY_MESSAGE;
+	}
+	if (status & MFI_G2_OUTBOUND_DOORBELL_CHANGE_INTERRUPT) {
+		mfiStatus |= MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;
+	}
 
 	/*
 	 * Clear the interrupt by writing back the same value
 	 */
-	writel(status, &regs->outbound_doorbell_clear);
+	if (mfiStatus)
+		writel(status, &regs->outbound_doorbell_clear);
 
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_intr_status);
 
-	return 0;
+	return mfiStatus;
 }
 /**
  * megasas_fire_cmd_gen2 -     Sends command to the FW
@@ -540,7 +546,7 @@ static struct megasas_instance_template 
 
 /**
 *	This is the end of set of functions & definitions
-* 	specific to ppc (deviceid : 0x60) controllers
+*       specific to gen2 (deviceid : 0x78, 0x79) controllers
 */
 
 /**
@@ -599,8 +605,7 @@ megasas_issue_blocked_cmd(struct megasas
 	instance->instancet->fire_cmd(instance,
 			cmd->frame_phys_addr, 0, instance->reg_set);
 
-	wait_event_timeout(instance->int_cmd_wait_q, (cmd->cmd_status != ENODATA),
-		MEGASAS_INTERNAL_CMD_WAIT_TIME*HZ);
+	wait_event(instance->int_cmd_wait_q, cmd->cmd_status != ENODATA);
 
 	return 0;
 }
@@ -648,8 +653,8 @@ megasas_issue_blocked_abort_cmd(struct m
 	/*
 	 * Wait for this cmd to complete
 	 */
-	wait_event_timeout(instance->abort_cmd_wait_q, (cmd->cmd_status != 0xFF),
-		MEGASAS_INTERNAL_CMD_WAIT_TIME*HZ);
+	wait_event(instance->abort_cmd_wait_q, cmd->cmd_status != 0xFF);
+	cmd->sync_cmd = 0;
 
 	megasas_return_cmd(instance, cmd);
 	return 0;
@@ -3137,7 +3142,7 @@ megasas_probe_one(struct pci_dev *pdev, 
 	init_waitqueue_head(&instance->abort_cmd_wait_q);
 
 	spin_lock_init(&instance->cmd_pool_lock);
-	spin_lock_init(&instance->fire_lock);
+	spin_lock_init(&instance->hba_lock);
 	spin_lock_init(&instance->completion_lock);
 	spin_lock_init(&poll_aen_lock);
 
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-06-08 14:02:55.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-06-08 14:24:50.000000000 -0400
@@ -73,6 +73,12 @@
  * HOTPLUG	: Resume from Hotplug
  * MFI_STOP_ADP	: Send signal to FW to stop processing
  */
+#define WRITE_SEQUENCE_OFFSET		(0x0000000FC) /* I20 */
+#define HOST_DIAGNOSTIC_OFFSET		(0x000000F8)  /* I20 */
+#define DIAG_WRITE_ENABLE			(0x00000080)
+#define DIAG_RESET_ADAPTER			(0x00000004)
+
+#define MFI_ADP_RESET				0x00000040
 #define MFI_INIT_ABORT				0x00000001
 #define MFI_INIT_READY				0x00000002
 #define MFI_INIT_MFIMODE			0x00000004
@@ -704,6 +710,12 @@ struct megasas_ctrl_info {
  */
 #define IS_DMA64				(sizeof(dma_addr_t) == 8)
 
+#define MFI_XSCALE_OMR0_CHANGE_INTERRUPT		0x00000001
+
+#define MFI_INTR_FLAG_REPLY_MESSAGE			0x00000001
+#define MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE		0x00000002
+#define MFI_G2_OUTBOUND_DOORBELL_CHANGE_INTERRUPT	0x00000004
+
 #define MFI_OB_INTR_STATUS_MASK			0x00000002
 #define MFI_POLL_TIMEOUT_SECS			60
 #define MEGASAS_COMPLETION_TIMER_INTERVAL      (HZ/10)
@@ -714,6 +726,9 @@ struct megasas_ctrl_info {
 #define MFI_REPLY_SKINNY_MESSAGE_INTERRUPT	0x40000000
 #define MFI_SKINNY_ENABLE_INTERRUPT_MASK	(0x00000001)
 
+#define MFI_1068_PCSR_OFFSET			0x84
+#define MFI_1068_FW_HANDSHAKE_OFFSET		0x64
+#define MFI_1068_FW_READY			0xDDDD0000
 /*
 * register set for both 1068 and 1078 controllers
 * structure extended for 1078 registers
@@ -755,8 +770,10 @@ struct megasas_register_set {
 	u32 	inbound_high_queue_port ;	/*00C4h*/
 
 	u32 	reserved_5;			/*00C8h*/
-	u32 	index_registers[820];		/*00CCh*/
-
+	u32	res_6[11];			/*CCh*/
+	u32	host_diag;
+	u32	seq_offset;
+	u32 	index_registers[807];		/*00CCh*/
 } __attribute__ ((packed));
 
 struct megasas_sge32 {
@@ -1226,11 +1243,12 @@ struct megasas_instance {
 
 	struct megasas_cmd **cmd_list;
 	struct list_head cmd_pool;
+	/* used to sync fire the cmd to fw */
 	spinlock_t cmd_pool_lock;
+	/* used to sync fire the cmd to fw */
+	spinlock_t hba_lock;
 	/* used to synch producer, consumer ptrs in dpc */
 	spinlock_t completion_lock;
-	/* used to sync fire the cmd to fw */
-	spinlock_t fire_lock;
 	struct dma_pool *frame_dma_pool;
 	struct dma_pool *sense_dma_pool;
 
@@ -1257,6 +1275,7 @@ struct megasas_instance {
 	u8 flag;
 	u8 unload;
 	u8 flag_ieee;
+	u8 adprecovery;
 	unsigned long last_time;
 
 	struct timer_list io_completion_timer; 
