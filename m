From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 3/4] scsi: megaraid_sas - Add the new controllers support
Date: Fri, 1 Aug 2008 15:17:26 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C31B080A66@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C31B080962@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:37780 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762652AbYHAVS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2008 17:18:27 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C31B080962@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "poswald@novell.com" <poswald@novell.com>, "Austria, Winston" <Winston.Austria@lsi.com>

Add the new controllers (0x78 0x79) support to the driver.  Those controllers are LSI's next generation (gen2) SAS controllers.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |  111 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |    4 +
 2 files changed, 113 insertions(+), 2 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2008-07-31 12:56:07.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2008-07-31 13:32:02.000000000 -0400
@@ -10,7 +10,7 @@
  *        2 of the License, or (at your option) any later version.
  *
  * FILE                : megaraid_sas.c
- * Version     : v00.00.03.20-rc1
+ * Version     : v00.00.04.01-rc1
  *
  * Authors:
  *     (email-id : megaraidlinux@lsi.com)
@@ -71,6 +71,10 @@ static struct pci_device_id megasas_pci_
        /* ppc IOP */
        {PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1078DE)},
        /* ppc IOP */
+       {PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1078GEN2)},
+       /* gen2*/
+       {PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS0079GEN2)},
+       /* gen2*/
        {PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_VERDE_ZCR)},
        /* xscale IOP, vega */
        {PCI_DEVICE(PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DELL_PERC5)},
@@ -324,6 +328,100 @@ static struct megasas_instance_template
 };

 /**
+*      The following functions are defined for gen2 (deviceid : 0x78 0x79)
+*      controllers
+*/
+
+/**
+ * megasas_enable_intr_gen2 -  Enables interrupts
+ * @regs:                      MFI register set
+ */
+static inline void
+megasas_enable_intr_gen2(struct megasas_register_set __iomem *regs)
+{
+       writel(0xFFFFFFFF, &(regs)->outbound_doorbell_clear);
+
+       /* write ~0x00000005 (4 & 1) to the intr mask*/
+       writel(~MFI_GEN2_ENABLE_INTERRUPT_MASK, &(regs)->outbound_intr_mask);
+
+       /* Dummy readl to force pci flush */
+       readl(&regs->outbound_intr_mask);
+}
+
+/**
+ * megasas_disable_intr_gen2 - Disables interrupt
+ * @regs:                      MFI register set
+ */
+static inline void
+megasas_disable_intr_gen2(struct megasas_register_set __iomem *regs)
+{
+       u32 mask = 0xFFFFFFFF;
+       writel(mask, &regs->outbound_intr_mask);
+       /* Dummy readl to force pci flush */
+       readl(&regs->outbound_intr_mask);
+}
+
+/**
+ * megasas_read_fw_status_reg_gen2 - returns the current FW status value
+ * @regs:                      MFI register set
+ */
+static u32
+megasas_read_fw_status_reg_gen2(struct megasas_register_set __iomem *regs)
+{
+       return readl(&(regs)->outbound_scratch_pad);
+}
+
+/**
+ * megasas_clear_interrupt_gen2 -      Check & clear interrupt
+ * @regs:                              MFI register set
+ */
+static int
+megasas_clear_intr_gen2(struct megasas_register_set __iomem *regs)
+{
+       u32 status;
+       /*
+        * Check if it is our interrupt
+        */
+       status = readl(&regs->outbound_intr_status);
+
+       if (!(status & MFI_GEN2_ENABLE_INTERRUPT_MASK)) {
+               return 1;
+       }
+
+       /*
+        * Clear the interrupt by writing back the same value
+        */
+       writel(status, &regs->outbound_doorbell_clear);
+
+       /* Dummy readl to force pci flush */
+       readl(&regs->outbound_intr_status);
+
+       return 0;
+}
+/**
+ * megasas_fire_cmd_gen2 -     Sends command to the FW
+ * @frame_phys_addr :          Physical address of cmd
+ * @frame_count :              Number of frames for the command
+ * @regs :                     MFI register set
+ */
+static inline void
+megasas_fire_cmd_gen2(dma_addr_t frame_phys_addr, u32 frame_count,
+                       struct megasas_register_set __iomem *regs)
+{
+       writel((frame_phys_addr | (frame_count<<1))|1,
+                       &(regs)->inbound_queue_port);
+}
+
+static struct megasas_instance_template megasas_instance_template_gen2 = {
+
+       .fire_cmd = megasas_fire_cmd_gen2,
+       .enable_intr = megasas_enable_intr_gen2,
+       .disable_intr = megasas_disable_intr_gen2,
+       .clear_intr = megasas_clear_intr_gen2,
+       .read_fw_status_reg = megasas_read_fw_status_reg_gen2,
+};
+
+/**
 *      This is the end of set of functions & definitions
 *      specific to ppc (deviceid : 0x60) controllers
 */
@@ -1982,7 +2080,12 @@ static int megasas_init_mfi(struct megas
        /*
         * Map the message registers
         */
-       instance->base_addr = pci_resource_start(instance->pdev, 0);
+       if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1078GEN2) ||
+               (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0079GEN2)) {
+               instance->base_addr = pci_resource_start(instance->pdev, 1);
+       } else {
+               instance->base_addr = pci_resource_start(instance->pdev, 0);
+       }

        if (pci_request_regions(instance->pdev, "megasas: LSI")) {
                printk(KERN_DEBUG "megasas: IO memory region busy!\n");
@@ -2004,6 +2107,10 @@ static int megasas_init_mfi(struct megas
                case PCI_DEVICE_ID_LSI_SAS1078DE:
                        instance->instancet = &megasas_instance_template_ppc;
                        break;
+               case PCI_DEVICE_ID_LSI_SAS1078GEN2:
+               case PCI_DEVICE_ID_LSI_SAS0079GEN2:
+                       instance->instancet = &megasas_instance_template_gen2;
+                       break;
                case PCI_DEVICE_ID_LSI_SAS1064R:
                case PCI_DEVICE_ID_DELL_PERC5:
                default:
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2008-07-31 12:50:41.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2008-07-31 12:50:41.000000000 -0400
@@ -28,6 +28,8 @@
 #define        PCI_DEVICE_ID_LSI_SAS1078R              0x0060
 #define        PCI_DEVICE_ID_LSI_SAS1078DE             0x007C
 #define        PCI_DEVICE_ID_LSI_VERDE_ZCR             0x0413
+#define        PCI_DEVICE_ID_LSI_SAS1078GEN2           0x0078
+#define        PCI_DEVICE_ID_LSI_SAS0079GEN2           0x0079

 /*
  * =====================================
@@ -580,6 +582,8 @@ struct megasas_ctrl_info {
 #define MEGASAS_COMPLETION_TIMER_INTERVAL      (HZ/10)

 #define MFI_REPLY_1078_MESSAGE_INTERRUPT       0x80000000
+#define MFI_REPLY_GEN2_MESSAGE_INTERRUPT       0x00000001
+#define MFI_GEN2_ENABLE_INTERRUPT_MASK         0x00000001 | 0x00000004

 /*
 * register set for both 1068 and 1078 controllers
