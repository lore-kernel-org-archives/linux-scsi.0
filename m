From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 4/12] scsi: megaraid_sas - Add new megaraid SAS 2 controller
 support to the driver
Date: Tue, 6 Oct 2009 14:31:54 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C35C6861C3@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C511977@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C5123FF@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:38916 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932301AbZJFUch convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Oct 2009 16:32:37 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C5123FF@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Austria, Winston" <Winston.Austria@lsi.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>

RESUBMIT:

Add the new megaraid sas 2 controller to the driver.  megaraid sas2 is LSI next generation SAS products.  driver add the interface to support this product.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |  139 +++++++++++++++++++++++++++++++++--
 drivers/scsi/megaraid/megaraid_sas.h |    4 +
 2 files changed, 138 insertions(+), 5 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c	2009-09-13 10:17:15.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c	2009-09-13 10:46:48.000000000 -0400
@@ -76,6 +76,10 @@ static struct pci_device_id megasas_pci_
 	/* gen2*/
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS0079GEN2)},
 	/* gen2*/
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS0073SKINNY)},
+	/* skinny*/
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS0071SKINNY)},
+	/* skinny*/
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_VERDE_ZCR)},
 	/* xscale IOP, vega */
 	{PCI_DEVICE(PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DELL_PERC5)},
@@ -335,6 +339,99 @@ static struct megasas_instance_template 
 };
 
 /**
+ * megasas_enable_intr_skinny -	Enables interrupts
+ * @regs:			MFI register set
+ */
+static inline void
+megasas_enable_intr_skinny(struct megasas_register_set __iomem *regs)
+{
+	writel(0xFFFFFFFF, &(regs)->outbound_intr_mask);
+
+	writel(~MFI_SKINNY_ENABLE_INTERRUPT_MASK, &(regs)->outbound_intr_mask);
+
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_intr_mask);
+}
+
+/**
+ * megasas_disable_intr_skinny -	Disables interrupt
+ * @regs:			MFI register set
+ */
+static inline void
+megasas_disable_intr_skinny(struct megasas_register_set __iomem *regs)
+{
+	u32 mask = 0xFFFFFFFF;
+	writel(mask, &regs->outbound_intr_mask);
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_intr_mask);
+}
+
+/**
+ * megasas_read_fw_status_reg_skinny - returns the current FW status value
+ * @regs:			MFI register set
+ */
+static u32
+megasas_read_fw_status_reg_skinny(struct megasas_register_set __iomem *regs)
+{
+	return readl(&(regs)->outbound_scratch_pad);
+}
+
+/**
+ * megasas_clear_interrupt_skinny -	Check & clear interrupt
+ * @regs:				MFI register set
+ */
+static int
+megasas_clear_intr_skinny(struct megasas_register_set __iomem *regs)
+{
+	u32 status;
+	/*
+	 * Check if it is our interrupt
+	 */
+	status = readl(&regs->outbound_intr_status);
+
+	if (!(status & MFI_SKINNY_ENABLE_INTERRUPT_MASK)) {
+		return 1;
+	}
+
+	/*
+	 * Clear the interrupt by writing back the same value
+	 */
+	writel(status, &regs->outbound_intr_status);
+
+	/*
+	* dummy read to flush PCI
+	*/
+	readl(&regs->outbound_intr_status);
+
+	return 0;
+}
+
+/**
+ * megasas_fire_cmd_skinny -	Sends command to the FW
+ * @frame_phys_addr :		Physical address of cmd
+ * @frame_count :		Number of frames for the command
+ * @regs :			MFI register set
+ */
+static inline void
+megasas_fire_cmd_skinny(dma_addr_t frame_phys_addr, u32 frame_count,
+			struct megasas_register_set __iomem *regs)
+{
+	writel(0, &(regs)->inbound_high_queue_port);
+	writel((frame_phys_addr | (frame_count<<1))|1,
+		&(regs)->inbound_low_queue_port);
+}
+
+static struct megasas_instance_template megasas_instance_template_skinny = {
+
+	.fire_cmd = megasas_fire_cmd_skinny,
+	.enable_intr = megasas_enable_intr_skinny,
+	.disable_intr = megasas_disable_intr_skinny,
+	.clear_intr = megasas_clear_intr_skinny,
+	.read_fw_status_reg = megasas_read_fw_status_reg_skinny,
+};
+
+
+/**
 *	The following functions are defined for gen2 (deviceid : 0x78 0x79)
 *	controllers
 */
@@ -1587,16 +1684,34 @@ megasas_transition_to_ready(struct megas
 			/*
 			 * Set the CLR bit in inbound doorbell
 			 */
-			writel(MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
-				&instance->reg_set->inbound_doorbell);
+			if ((instance->pdev->device == \
+				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+				(instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+
+				writel(
+				  MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
+				  &instance->reg_set->reserved_0[0]);
+			} else {
+				writel(
+				    MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
+					&instance->reg_set->inbound_doorbell);
+			}
 
 			max_wait = 2;
 			cur_state = MFI_STATE_WAIT_HANDSHAKE;
 			break;
 
 		case MFI_STATE_BOOT_MESSAGE_PENDING:
-			writel(MFI_INIT_HOTPLUG,
-				&instance->reg_set->inbound_doorbell);
+			if ((instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+			(instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+				writel(MFI_INIT_HOTPLUG,
+				&instance->reg_set->reserved_0[0]);
+			} else
+				writel(MFI_INIT_HOTPLUG,
+					&instance->reg_set->inbound_doorbell);
 
 			max_wait = 10;
 			cur_state = MFI_STATE_BOOT_MESSAGE_PENDING;
@@ -1607,7 +1722,15 @@ megasas_transition_to_ready(struct megas
 			 * Bring it to READY state; assuming max wait 10 secs
 			 */
 			instance->instancet->disable_intr(instance->reg_set);
-			writel(MFI_RESET_FLAGS, &instance->reg_set->inbound_doorbell);
+			if ((instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+				(instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+				writel(MFI_RESET_FLAGS,
+					&instance->reg_set->reserved_0[0]);
+			} else
+				writel(MFI_RESET_FLAGS,
+					&instance->reg_set->inbound_doorbell);
 
 			max_wait = 60;
 			cur_state = MFI_STATE_OPERATIONAL;
@@ -2112,6 +2235,8 @@ static int megasas_init_mfi(struct megas
 	 * Map the message registers
 	 */
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1078GEN2) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0079GEN2)) {
 		instance->base_addr = pci_resource_start(instance->pdev, 1);
 	} else {
@@ -2142,6 +2267,10 @@ static int megasas_init_mfi(struct megas
 		case PCI_DEVICE_ID_LSI_SAS0079GEN2:
 			instance->instancet = &megasas_instance_template_gen2;
 			break;
+		case PCI_DEVICE_ID_LSI_SAS0073SKINNY:
+		case PCI_DEVICE_ID_LSI_SAS0071SKINNY:
+			instance->instancet = &megasas_instance_template_skinny;
+			break;
 		case PCI_DEVICE_ID_LSI_SAS1064R:
 		case PCI_DEVICE_ID_DELL_PERC5:
 		default:
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h	2009-09-13 10:17:15.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h	2009-09-13 10:35:03.000000000 -0400
@@ -30,6 +30,8 @@
 #define	PCI_DEVICE_ID_LSI_VERDE_ZCR		0x0413
 #define	PCI_DEVICE_ID_LSI_SAS1078GEN2		0x0078
 #define	PCI_DEVICE_ID_LSI_SAS0079GEN2		0x0079
+#define	PCI_DEVICE_ID_LSI_SAS0073SKINNY		0x0073
+#define	PCI_DEVICE_ID_LSI_SAS0071SKINNY		0x0071
 
 /*
  * =====================================
@@ -584,6 +586,8 @@ struct megasas_ctrl_info {
 #define MFI_REPLY_1078_MESSAGE_INTERRUPT	0x80000000
 #define MFI_REPLY_GEN2_MESSAGE_INTERRUPT	0x00000001
 #define MFI_GEN2_ENABLE_INTERRUPT_MASK		(0x00000001 | 0x00000004)
+#define MFI_REPLY_SKINNY_MESSAGE_INTERRUPT	0x40000000
+#define MFI_SKINNY_ENABLE_INTERRUPT_MASK	(0x00000001)
 
 /*
 * register set for both 1068 and 1078 controllers
