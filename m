From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 1/7] scsi: megaraid_sas - Online Controller Reset - I:
 Change the Chips related functions and Add the Chip reset functions
Date: Wed, 26 May 2010 10:25:12 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D06ADBFC@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
List-Id: linux-scsi@vger.kernel.org

RESUBMIT: Adding the detailed description for this patch:

Add the Controller reset functions to the Driver.  This is first part of the Online Controller Reset.
The driver supports XScle and Gen2 chips.  The chip related functions need to change and driver also
need to add the new chip reset functions to write the chip register do the chip reset.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
megaraid_sas.c |  235 +++++++++++++++++++++++++++++++++++++++++++++++++++------
megaraid_sas.h |   40 ++++++++-
 2 files changed, 248 insertions(+), 27 deletions(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c    2010-04-19 09:26:47.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c    2010-04-21 05:03:14.000000000 -0400
@@ -164,7 +164,7 @@ megasas_return_cmd(struct megasas_instan
 static inline void
 megasas_enable_intr_xscale(struct megasas_register_set __iomem * regs)
 {
-       writel(1, &(regs)->outbound_intr_mask);
+       writel(0, &(regs)->outbound_intr_mask);

        /* Dummy readl to force pci flush */
        readl(&regs->outbound_intr_mask);
@@ -200,24 +200,27 @@ static int
 megasas_clear_intr_xscale(struct megasas_register_set __iomem * regs)
 {
        u32 status;
+       u32 mfiStatus = 0;
        /*
         * Check if it is our interrupt
         */
        status = readl(&regs->outbound_intr_status);

-       if (!(status & MFI_OB_INTR_STATUS_MASK)) {
-               return 1;
-       }
+       if (status & MFI_OB_INTR_STATUS_MASK)
+               mfiStatus = MFI_INTR_FLAG_REPLY_MESSAGE;
+       if (status & MFI_XSCALE_OMR0_CHANGE_INTERRUPT)
+               mfiStatus |= MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;

        /*
         * Clear the interrupt by writing back the same value
         */
-       writel(status, &regs->outbound_intr_status);
+       if (mfiStatus)
+               writel(status, &regs->outbound_intr_status);

        /* Dummy readl to force pci flush */
        readl(&regs->outbound_intr_status);

-       return 0;
+       return mfiStatus;
 }

 /**
@@ -232,8 +235,69 @@ megasas_fire_cmd_xscale(struct megasas_i
                u32 frame_count,
                struct megasas_register_set __iomem *regs)
 {
+       unsigned long flags;
+       spin_lock_irqsave(&instance->hba_lock, flags);
        writel((frame_phys_addr >> 3)|(frame_count),
               &(regs)->inbound_queue_port);
+       spin_unlock_irqrestore(&instance->hba_lock, flags);
+}
+
+/**
+ * megasas_adp_reset_xscale -  For controller reset
+ * @regs:                              MFI register set
+ */
+static int
+megasas_adp_reset_xscale(struct megasas_instance *instance,
+       struct megasas_register_set __iomem *regs)
+{
+       u32 i;
+       u32 pcidata;
+       writel(MFI_ADP_RESET, &regs->inbound_doorbell);
+
+       for (i = 0; i < 3; i++)
+               msleep(1000); /* sleep for 3 secs */
+       pcidata  = 0;
+       pci_read_config_dword(instance->pdev, MFI_1068_PCSR_OFFSET, &pcidata);
+       printk(KERN_NOTICE "pcidata = %x\n", pcidata);
+       if (pcidata & 0x2) {
+               printk(KERN_NOTICE "mfi 1068 offset read=%x\n", pcidata);
+               pcidata &= ~0x2;
+               pci_write_config_dword(instance->pdev,
+                               MFI_1068_PCSR_OFFSET, pcidata);
+
+               for (i = 0; i < 2; i++)
+                       msleep(1000); /* need to wait 2 secs again */
+
+               pcidata  = 0;
+               pci_read_config_dword(instance->pdev,
+                               MFI_1068_FW_HANDSHAKE_OFFSET, &pcidata);
+               printk(KERN_NOTICE "1068 offset handshake read=%x\n", pcidata);
+               if ((pcidata & 0xffff0000) == MFI_1068_FW_READY) {
+                       printk(KERN_NOTICE "1068 offset pcidt=%x\n", pcidata);
+                       pcidata = 0;
+                       pci_write_config_dword(instance->pdev,
+                               MFI_1068_FW_HANDSHAKE_OFFSET, pcidata);
+               }
+       }
+       return 0;
+}
+
+/**
+ * megasas_check_reset_xscale -        For controller reset check
+ * @regs:                              MFI register set
+ */
+static int
+megasas_check_reset_xscale(struct megasas_instance *instance,
+               struct megasas_register_set __iomem *regs)
+{
+       u32 consumer;
+       consumer = *instance->consumer;
+
+       if ((instance->adprecovery != MEGASAS_HBA_OPERATIONAL) &&
+               (*instance->consumer == MEGASAS_ADPRESET_INPROG_SIGN)) {
+               return 1;
+       }
+       return 0;
 }

 static struct megasas_instance_template megasas_instance_template_xscale = {
@@ -243,6 +307,8 @@ static struct megasas_instance_template
        .disable_intr = megasas_disable_intr_xscale,
        .clear_intr = megasas_clear_intr_xscale,
        .read_fw_status_reg = megasas_read_fw_status_reg_xscale,
+       .adp_reset = megasas_adp_reset_xscale,
+       .check_reset = megasas_check_reset_xscale,
 };

 /**
@@ -264,7 +330,7 @@ megasas_enable_intr_ppc(struct megasas_r
 {
        writel(0xFFFFFFFF, &(regs)->outbound_doorbell_clear);

-       writel(~0x80000004, &(regs)->outbound_intr_mask);
+       writel(~0x80000000, &(regs)->outbound_intr_mask);

        /* Dummy readl to force pci flush */
        readl(&regs->outbound_intr_mask);
@@ -307,7 +373,7 @@ megasas_clear_intr_ppc(struct megasas_re
        status = readl(&regs->outbound_intr_status);

        if (!(status & MFI_REPLY_1078_MESSAGE_INTERRUPT)) {
-               return 1;
+               return 0;
        }

        /*
@@ -318,7 +384,7 @@ megasas_clear_intr_ppc(struct megasas_re
        /* Dummy readl to force pci flush */
        readl(&regs->outbound_doorbell_clear);

-       return 0;
+       return 1;
 }
 /**
  * megasas_fire_cmd_ppc -      Sends command to the FW
@@ -332,10 +398,34 @@ megasas_fire_cmd_ppc(struct megasas_inst
                u32 frame_count,
                struct megasas_register_set __iomem *regs)
 {
+       unsigned long flags;
+       spin_lock_irqsave(&instance->hba_lock, flags);
        writel((frame_phys_addr | (frame_count<<1))|1,
                        &(regs)->inbound_queue_port);
+       spin_unlock_irqrestore(&instance->hba_lock, flags);
 }

+/**
+ * megasas_adp_reset_ppc -     For controller reset
+ * @regs:                              MFI register set
+ */
+static int
+megasas_adp_reset_ppc(struct megasas_instance *instance,
+                       struct megasas_register_set __iomem *regs)
+{
+       return 0;
+}
+
+/**
+ * megasas_check_reset_ppc -   For controller reset check
+ * @regs:                              MFI register set
+ */
+static int
+megasas_check_reset_ppc(struct megasas_instance *instance,
+                       struct megasas_register_set __iomem *regs)
+{
+       return 0;
+}
 static struct megasas_instance_template megasas_instance_template_ppc = {

        .fire_cmd = megasas_fire_cmd_ppc,
@@ -343,6 +433,8 @@ static struct megasas_instance_template
        .disable_intr = megasas_disable_intr_ppc,
        .clear_intr = megasas_clear_intr_ppc,
        .read_fw_status_reg = megasas_read_fw_status_reg_ppc,
+       .adp_reset = megasas_adp_reset_ppc,
+       .check_reset = megasas_check_reset_ppc,
 };

 /**
@@ -397,7 +489,7 @@ megasas_clear_intr_skinny(struct megasas
        status = readl(&regs->outbound_intr_status);

        if (!(status & MFI_SKINNY_ENABLE_INTERRUPT_MASK)) {
-               return 1;
+               return 0;
        }

        /*
@@ -410,7 +502,7 @@ megasas_clear_intr_skinny(struct megasas
        */
        readl(&regs->outbound_intr_status);

-       return 0;
+       return 1;
 }

 /**
@@ -426,11 +518,33 @@ megasas_fire_cmd_skinny(struct megasas_i
                        struct megasas_register_set __iomem *regs)
 {
        unsigned long flags;
-       spin_lock_irqsave(&instance->fire_lock, flags);
+       spin_lock_irqsave(&instance->hba_lock, flags);
        writel(0, &(regs)->inbound_high_queue_port);
        writel((frame_phys_addr | (frame_count<<1))|1,
                &(regs)->inbound_low_queue_port);
-       spin_unlock_irqrestore(&instance->fire_lock, flags);
+       spin_unlock_irqrestore(&instance->hba_lock, flags);
+}
+
+/**
+ * megasas_adp_reset_skinny -  For controller reset
+ * @regs:                              MFI register set
+ */
+static int
+megasas_adp_reset_skinny(struct megasas_instance *instance,
+                       struct megasas_register_set __iomem *regs)
+{
+       return 0;
+}
+
+/**
+ * megasas_check_reset_skinny -        For controller reset check
+ * @regs:                              MFI register set
+ */
+static int
+megasas_check_reset_skinny(struct megasas_instance *instance,
+                               struct megasas_register_set __iomem *regs)
+{
+       return 0;
 }

 static struct megasas_instance_template megasas_instance_template_skinny = {
@@ -440,6 +554,8 @@ static struct megasas_instance_template
        .disable_intr = megasas_disable_intr_skinny,
        .clear_intr = megasas_clear_intr_skinny,
        .read_fw_status_reg = megasas_read_fw_status_reg_skinny,
+       .adp_reset = megasas_adp_reset_skinny,
+       .check_reset = megasas_check_reset_skinny,
 };


@@ -495,23 +611,29 @@ static int
 megasas_clear_intr_gen2(struct megasas_register_set __iomem *regs)
 {
        u32 status;
+       u32 mfiStatus = 0;
        /*
         * Check if it is our interrupt
         */
        status = readl(&regs->outbound_intr_status);

-       if (!(status & MFI_GEN2_ENABLE_INTERRUPT_MASK))
-               return 1;
+       if (status & MFI_GEN2_ENABLE_INTERRUPT_MASK) {
+               mfiStatus = MFI_INTR_FLAG_REPLY_MESSAGE;
+       }
+       if (status & MFI_G2_OUTBOUND_DOORBELL_CHANGE_INTERRUPT) {
+               mfiStatus |= MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE;
+       }

        /*
         * Clear the interrupt by writing back the same value
         */
-       writel(status, &regs->outbound_doorbell_clear);
+       if (mfiStatus)
+               writel(status, &regs->outbound_doorbell_clear);

        /* Dummy readl to force pci flush */
        readl(&regs->outbound_intr_status);

-       return 0;
+       return mfiStatus;
 }
 /**
  * megasas_fire_cmd_gen2 -     Sends command to the FW
@@ -525,8 +647,74 @@ megasas_fire_cmd_gen2(struct megasas_ins
                        u32 frame_count,
                        struct megasas_register_set __iomem *regs)
 {
+       unsigned long flags;
+       spin_lock_irqsave(&instance->hba_lock, flags);
        writel((frame_phys_addr | (frame_count<<1))|1,
                        &(regs)->inbound_queue_port);
+       spin_unlock_irqrestore(&instance->hba_lock, flags);
+}
+
+/**
+ * megasas_adp_reset_gen2 -    For controller reset
+ * @regs:                              MFI register set
+ */
+static int
+megasas_adp_reset_gen2(struct megasas_instance *instance,
+                       struct megasas_register_set __iomem *reg_set)
+{
+       u32                     retry = 0 ;
+       u32                     HostDiag;
+
+       writel(0, &reg_set->seq_offset);
+       writel(4, &reg_set->seq_offset);
+       writel(0xb, &reg_set->seq_offset);
+       writel(2, &reg_set->seq_offset);
+       writel(7, &reg_set->seq_offset);
+       writel(0xd, &reg_set->seq_offset);
+       msleep(1000);
+
+       HostDiag = (u32)readl(&reg_set->host_diag);
+
+       while ( !( HostDiag & DIAG_WRITE_ENABLE) ) {
+               msleep(100);
+               HostDiag = (u32)readl(&reg_set->host_diag);
+               printk(KERN_NOTICE "RESETGEN2: retry=%x, hostdiag=%x\n",
+                                       retry, HostDiag);
+
+               if (retry++ >= 100)
+                       return 1;
+
+       }
+
+       printk(KERN_NOTICE "ADP_RESET_GEN2: HostDiag=%x\n", HostDiag);
+
+       writel((HostDiag | DIAG_RESET_ADAPTER), &reg_set->host_diag);
+
+       ssleep(10);
+
+       HostDiag = (u32)readl(&reg_set->host_diag);
+       while ( ( HostDiag & DIAG_RESET_ADAPTER) ) {
+               msleep(100);
+               HostDiag = (u32)readl(&reg_set->host_diag);
+               printk(KERN_NOTICE "RESET_GEN2: retry=%x, hostdiag=%x\n",
+                               retry, HostDiag);
+
+               if (retry++ >= 1000)
+                       return 1;
+
+       }
+       return 0;
+}
+
+/**
+ * megasas_check_reset_gen2 -  For controller reset check
+ * @regs:                              MFI register set
+ */
+static int
+megasas_check_reset_gen2(struct megasas_instance *instance,
+               struct megasas_register_set __iomem *regs)
+{
+       return 0;
 }

 static struct megasas_instance_template megasas_instance_template_gen2 = {
@@ -536,11 +724,13 @@ static struct megasas_instance_template
        .disable_intr = megasas_disable_intr_gen2,
        .clear_intr = megasas_clear_intr_gen2,
        .read_fw_status_reg = megasas_read_fw_status_reg_gen2,
+       .adp_reset = megasas_adp_reset_gen2,
+       .check_reset = megasas_check_reset_gen2,
 };

 /**
 *      This is the end of set of functions & definitions
-*      specific to ppc (deviceid : 0x60) controllers
+*       specific to gen2 (deviceid : 0x78, 0x79) controllers
 */

 /**
@@ -599,8 +789,7 @@ megasas_issue_blocked_cmd(struct megasas
        instance->instancet->fire_cmd(instance,
                        cmd->frame_phys_addr, 0, instance->reg_set);

-       wait_event_timeout(instance->int_cmd_wait_q, (cmd->cmd_status != ENODATA),
-               MEGASAS_INTERNAL_CMD_WAIT_TIME*HZ);
+       wait_event(instance->int_cmd_wait_q, cmd->cmd_status != ENODATA);

        return 0;
 }
@@ -648,8 +837,8 @@ megasas_issue_blocked_abort_cmd(struct m
        /*
         * Wait for this cmd to complete
         */
-       wait_event_timeout(instance->abort_cmd_wait_q, (cmd->cmd_status != 0xFF),
-               MEGASAS_INTERNAL_CMD_WAIT_TIME*HZ);
+       wait_event(instance->abort_cmd_wait_q, cmd->cmd_status != 0xFF);
+       cmd->sync_cmd = 0;

        megasas_return_cmd(instance, cmd);
        return 0;
@@ -3137,7 +3326,7 @@ megasas_probe_one(struct pci_dev *pdev,
        init_waitqueue_head(&instance->abort_cmd_wait_q);

        spin_lock_init(&instance->cmd_pool_lock);
-       spin_lock_init(&instance->fire_lock);
+       spin_lock_init(&instance->hba_lock);
        spin_lock_init(&instance->completion_lock);
        spin_lock_init(&poll_aen_lock);

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h    2010-04-19 09:26:47.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h    2010-04-21 05:00:03.000000000 -0400
@@ -73,6 +73,12 @@
  * HOTPLUG     : Resume from Hotplug
  * MFI_STOP_ADP        : Send signal to FW to stop processing
  */
+#define WRITE_SEQUENCE_OFFSET          (0x0000000FC) /* I20 */
+#define HOST_DIAGNOSTIC_OFFSET         (0x000000F8)  /* I20 */
+#define DIAG_WRITE_ENABLE                      (0x00000080)
+#define DIAG_RESET_ADAPTER                     (0x00000004)
+
+#define MFI_ADP_RESET                          0x00000040
 #define MFI_INIT_ABORT                         0x00000001
 #define MFI_INIT_READY                         0x00000002
 #define MFI_INIT_MFIMODE                       0x00000004
@@ -704,6 +710,12 @@ struct megasas_ctrl_info {
  */
 #define IS_DMA64                               (sizeof(dma_addr_t) == 8)

+#define MFI_XSCALE_OMR0_CHANGE_INTERRUPT               0x00000001
+
+#define MFI_INTR_FLAG_REPLY_MESSAGE                    0x00000001
+#define MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE            0x00000002
+#define MFI_G2_OUTBOUND_DOORBELL_CHANGE_INTERRUPT      0x00000004
+
 #define MFI_OB_INTR_STATUS_MASK                        0x00000002
 #define MFI_POLL_TIMEOUT_SECS                  60
 #define MEGASAS_COMPLETION_TIMER_INTERVAL      (HZ/10)
@@ -714,6 +726,9 @@ struct megasas_ctrl_info {
 #define MFI_REPLY_SKINNY_MESSAGE_INTERRUPT     0x40000000
 #define MFI_SKINNY_ENABLE_INTERRUPT_MASK       (0x00000001)

+#define MFI_1068_PCSR_OFFSET                   0x84
+#define MFI_1068_FW_HANDSHAKE_OFFSET           0x64
+#define MFI_1068_FW_READY                      0xDDDD0000
 /*
 * register set for both 1068 and 1078 controllers
 * structure extended for 1078 registers
@@ -755,8 +770,10 @@ struct megasas_register_set {
        u32     inbound_high_queue_port ;       /*00C4h*/

        u32     reserved_5;                     /*00C8h*/
-       u32     index_registers[820];           /*00CCh*/
-
+       u32     res_6[11];                      /*CCh*/
+       u32     host_diag;
+       u32     seq_offset;
+       u32     index_registers[807];           /*00CCh*/
 } __attribute__ ((packed));

 struct megasas_sge32 {
@@ -1226,11 +1243,12 @@ struct megasas_instance {

        struct megasas_cmd **cmd_list;
        struct list_head cmd_pool;
+       /* used to sync fire the cmd to fw */
        spinlock_t cmd_pool_lock;
+       /* used to sync fire the cmd to fw */
+       spinlock_t hba_lock;
        /* used to synch producer, consumer ptrs in dpc */
        spinlock_t completion_lock;
-       /* used to sync fire the cmd to fw */
-       spinlock_t fire_lock;
        struct dma_pool *frame_dma_pool;
        struct dma_pool *sense_dma_pool;

@@ -1257,11 +1275,21 @@ struct megasas_instance {
        u8 flag;
        u8 unload;
        u8 flag_ieee;
+       u8 adprecovery;
        unsigned long last_time;

        struct timer_list io_completion_timer;
 };

+enum {
+       MEGASAS_HBA_OPERATIONAL                 = 0,
+       MEGASAS_ADPRESET_SM_INFAULT             = 1,
+       MEGASAS_ADPRESET_SM_FW_RESET_SUCCESS    = 2,
+       MEGASAS_ADPRESET_SM_OPERATIONAL         = 3,
+       MEGASAS_HW_CRITICAL_ERROR               = 4,
+       MEGASAS_ADPRESET_INPROG_SIGN            = 0xDEADDEAD,
+};
+
 struct megasas_instance_template {
        void (*fire_cmd)(struct megasas_instance *, dma_addr_t, \
                u32, struct megasas_register_set __iomem *);
@@ -1272,6 +1300,10 @@ struct megasas_instance_template {
        int (*clear_intr)(struct megasas_register_set __iomem *);

        u32 (*read_fw_status_reg)(struct megasas_register_set __iomem *);
+       int (*adp_reset)(struct megasas_instance *, \
+               struct megasas_register_set __iomem *);
+       int (*check_reset)(struct megasas_instance *, \
+               struct megasas_register_set __iomem *);
 };

 #define MEGASAS_IS_LOGICAL(scp)                                                \
