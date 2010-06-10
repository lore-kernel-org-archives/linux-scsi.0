From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 2/12] scsi: megaraid_sas - Online Controller Reset - II: Add
 the Chip reset functions to the driver
Date: Wed, 9 Jun 2010 20:51:48 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D0804542@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add the chip reset functions to the driver.  Driver will write the chip register offset to force the controller to reset.
This patch implemented the function for Xscale 

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |  143 +++++++++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h |   13 +++
 2 files changed, 156 insertions(+)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 14:33:53.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 14:37:17.000000000 -0400
@@ -235,8 +235,69 @@ megasas_fire_cmd_xscale(struct megasas_i
 		u32 frame_count,
 		struct megasas_register_set __iomem *regs)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&instance->hba_lock, flags);
 	writel((frame_phys_addr >> 3)|(frame_count),
 	       &(regs)->inbound_queue_port);
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+}
+
+/**
+ * megasas_adp_reset_xscale -  For controller reset
+ * @regs:                              MFI register set
+ */
+static int
+megasas_adp_reset_xscale(struct megasas_instance *instance,
+	struct megasas_register_set __iomem *regs)
+{
+	u32 i;
+	u32 pcidata;
+	writel(MFI_ADP_RESET, &regs->inbound_doorbell);
+
+	for (i = 0; i < 3; i++)
+		msleep(1000); /* sleep for 3 secs */
+	pcidata  = 0;
+	pci_read_config_dword(instance->pdev, MFI_1068_PCSR_OFFSET, &pcidata);
+	printk(KERN_NOTICE "pcidata = %x\n", pcidata);
+	if (pcidata & 0x2) {
+		printk(KERN_NOTICE "mfi 1068 offset read=%x\n", pcidata);
+		pcidata &= ~0x2;
+		pci_write_config_dword(instance->pdev,
+				MFI_1068_PCSR_OFFSET, pcidata);
+
+		for (i = 0; i < 2; i++)
+			msleep(1000); /* need to wait 2 secs again */
+
+		pcidata  = 0;
+		pci_read_config_dword(instance->pdev,
+				MFI_1068_FW_HANDSHAKE_OFFSET, &pcidata);
+		printk(KERN_NOTICE "1068 offset handshake read=%x\n", pcidata);
+		if ((pcidata & 0xffff0000) == MFI_1068_FW_READY) {
+			printk(KERN_NOTICE "1068 offset pcidt=%x\n", pcidata);
+			pcidata = 0;
+			pci_write_config_dword(instance->pdev,
+				MFI_1068_FW_HANDSHAKE_OFFSET, pcidata);
+		}
+	}
+	return 0;
+}
+
+/**
+ * megasas_check_reset_xscale -	For controller reset check
+ * @regs:				MFI register set
+ */
+static int
+megasas_check_reset_xscale(struct megasas_instance *instance,
+		struct megasas_register_set __iomem *regs)
+{
+	u32 consumer;
+	consumer = *instance->consumer;
+
+	if ((instance->adprecovery != MEGASAS_HBA_OPERATIONAL) &&
+		(*instance->consumer == MEGASAS_ADPRESET_INPROG_SIGN)) {
+		return 1;
+	}
+	return 0;
 }
 
 static struct megasas_instance_template megasas_instance_template_xscale = {
@@ -246,6 +307,8 @@ static struct megasas_instance_template 
 	.disable_intr = megasas_disable_intr_xscale,
 	.clear_intr = megasas_clear_intr_xscale,
 	.read_fw_status_reg = megasas_read_fw_status_reg_xscale,
+	.adp_reset = megasas_adp_reset_xscale,
+	.check_reset = megasas_check_reset_xscale,
 };
 
 /**
@@ -335,10 +398,34 @@ megasas_fire_cmd_ppc(struct megasas_inst
 		u32 frame_count,
 		struct megasas_register_set __iomem *regs)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&instance->hba_lock, flags);
 	writel((frame_phys_addr | (frame_count<<1))|1, 
 			&(regs)->inbound_queue_port);
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+}
+
+/**
+ * megasas_adp_reset_ppc -	For controller reset
+ * @regs:				MFI register set
+ */
+static int
+megasas_adp_reset_ppc(struct megasas_instance *instance,
+			struct megasas_register_set __iomem *regs)
+{
+	return 0;
 }
 
+/**
+ * megasas_check_reset_ppc -	For controller reset check
+ * @regs:				MFI register set
+ */
+static int
+megasas_check_reset_ppc(struct megasas_instance *instance,
+			struct megasas_register_set __iomem *regs)
+{
+	return 0;
+}
 static struct megasas_instance_template megasas_instance_template_ppc = {
 	
 	.fire_cmd = megasas_fire_cmd_ppc,
@@ -346,6 +433,8 @@ static struct megasas_instance_template 
 	.disable_intr = megasas_disable_intr_ppc,
 	.clear_intr = megasas_clear_intr_ppc,
 	.read_fw_status_reg = megasas_read_fw_status_reg_ppc,
+	.adp_reset = megasas_adp_reset_ppc,
+	.check_reset = megasas_check_reset_ppc,
 };
 
 /**
@@ -428,9 +517,34 @@ megasas_fire_cmd_skinny(struct megasas_i
 			u32 frame_count,
 			struct megasas_register_set __iomem *regs)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&instance->hba_lock, flags);
 	writel(0, &(regs)->inbound_high_queue_port);
 	writel((frame_phys_addr | (frame_count<<1))|1,
 		&(regs)->inbound_low_queue_port);
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+}
+
+/**
+ * megasas_adp_reset_skinny -	For controller reset
+ * @regs:				MFI register set
+ */
+static int
+megasas_adp_reset_skinny(struct megasas_instance *instance,
+			struct megasas_register_set __iomem *regs)
+{
+	return 0;
+}
+
+/**
+ * megasas_check_reset_skinny -	For controller reset check
+ * @regs:				MFI register set
+ */
+static int
+megasas_check_reset_skinny(struct megasas_instance *instance,
+				struct megasas_register_set __iomem *regs)
+{
+	return 0;
 }
 
 static struct megasas_instance_template megasas_instance_template_skinny = {
@@ -440,6 +554,8 @@ static struct megasas_instance_template 
 	.disable_intr = megasas_disable_intr_skinny,
 	.clear_intr = megasas_clear_intr_skinny,
 	.read_fw_status_reg = megasas_read_fw_status_reg_skinny,
+	.adp_reset = megasas_adp_reset_skinny,
+	.check_reset = megasas_check_reset_skinny,
 };
 
 
@@ -531,8 +647,33 @@ megasas_fire_cmd_gen2(struct megasas_ins
 			u32 frame_count,
 			struct megasas_register_set __iomem *regs)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&instance->hba_lock, flags);
 	writel((frame_phys_addr | (frame_count<<1))|1,
 			&(regs)->inbound_queue_port);
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+}
+
+/**
+ * megasas_adp_reset_gen2 -	For controller reset
+ * @regs:				MFI register set
+ */
+static int
+megasas_adp_reset_gen2(struct megasas_instance *instance,
+			struct megasas_register_set __iomem *reg_set)
+{
+	return 0;
+}
+
+/**
+ * megasas_check_reset_gen2 -	For controller reset check
+ * @regs:				MFI register set
+ */
+static int
+megasas_check_reset_gen2(struct megasas_instance *instance,
+		struct megasas_register_set __iomem *regs)
+{
+	return 0;
 }
 
 static struct megasas_instance_template megasas_instance_template_gen2 = {
@@ -542,6 +683,8 @@ static struct megasas_instance_template 
 	.disable_intr = megasas_disable_intr_gen2,
 	.clear_intr = megasas_clear_intr_gen2,
 	.read_fw_status_reg = megasas_read_fw_status_reg_gen2,
+	.adp_reset = megasas_adp_reset_gen2,
+	.check_reset = megasas_check_reset_gen2,
 };
 
 /**
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-06-08 14:33:53.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-06-08 14:34:19.000000000 -0400
@@ -1281,6 +1281,15 @@ struct megasas_instance {
 	struct timer_list io_completion_timer;
 };
 
+enum {
+	MEGASAS_HBA_OPERATIONAL			= 0,
+	MEGASAS_ADPRESET_SM_INFAULT		= 1,
+	MEGASAS_ADPRESET_SM_FW_RESET_SUCCESS	= 2,
+	MEGASAS_ADPRESET_SM_OPERATIONAL		= 3,
+	MEGASAS_HW_CRITICAL_ERROR		= 4,
+	MEGASAS_ADPRESET_INPROG_SIGN		= 0xDEADDEAD,
+};
+
 struct megasas_instance_template {
 	void (*fire_cmd)(struct megasas_instance *, dma_addr_t, \
 		u32, struct megasas_register_set __iomem *);
@@ -1291,6 +1300,10 @@ struct megasas_instance_template {
 	int (*clear_intr)(struct megasas_register_set __iomem *);
 
 	u32 (*read_fw_status_reg)(struct megasas_register_set __iomem *);
+	int (*adp_reset)(struct megasas_instance *, \
+		struct megasas_register_set __iomem *);
+	int (*check_reset)(struct megasas_instance *, \
+		struct megasas_register_set __iomem *);
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\
