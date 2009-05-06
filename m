From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 9/10] scsi: megaraid_sas - Fixed the logic drives deleted
 and cmds pending in FW issue
Date: Tue, 5 May 2009 20:08:29 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C354F61C69@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C354F61C62@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:45719 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbZEFCJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 22:09:17 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C354F61C62@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

When we tested the SAS 2 controller, the system faced the issues of pending cmds in FW after deleted the logic drives.  This patch will fix this issue.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   72 +++++++++++++++++++++++++++++------
 drivers/scsi/megaraid/megaraid_sas.h |   24 ++++++-----
 2 files changed, 74 insertions(+), 22 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-05-04 23:02:46.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-05-04 23:03:28.000000000 -0400
@@ -225,7 +225,10 @@ megasas_clear_intr_xscale(struct megasas
  * @regs :                     MFI register set
  */
 static inline void
-megasas_fire_cmd_xscale(dma_addr_t frame_phys_addr,u32 frame_count, struct megasas_register_set __iomem *regs)
+megasas_fire_cmd_xscale(struct megasas_instance *instance,
+               dma_addr_t frame_phys_addr,
+               u32 frame_count,
+               struct megasas_register_set __iomem *regs)
 {
        writel((frame_phys_addr >> 3)|(frame_count),
               &(regs)->inbound_queue_port);
@@ -322,7 +325,10 @@ megasas_clear_intr_ppc(struct megasas_re
  * @regs :                     MFI register set
  */
 static inline void
-megasas_fire_cmd_ppc(dma_addr_t frame_phys_addr, u32 frame_count, struct megasas_register_set __iomem *regs)
+megasas_fire_cmd_ppc(struct megasas_instance *instance,
+               dma_addr_t frame_phys_addr,
+               u32 frame_count,
+               struct megasas_register_set __iomem *regs)
 {
        writel((frame_phys_addr | (frame_count<<1))|1,
                        &(regs)->inbound_queue_port);
@@ -412,12 +418,18 @@ megasas_clear_intr_skinny(struct megasas
  * @regs :                     MFI register set
  */
 static inline void
-megasas_fire_cmd_skinny(dma_addr_t frame_phys_addr, u32 frame_count,
+megasas_fire_cmd_skinny(struct megasas_instance *instance,
+                       dma_addr_t frame_phys_addr,
+                       u32 frame_count,
                        struct megasas_register_set __iomem *regs)
 {
+       unsigned long flags;
+       spin_lock_irqsave(&instance->fire_lock, flags);
+
        writel(0, &(regs)->inbound_high_queue_port);
        writel((frame_phys_addr | (frame_count<<1))|1,
                        &(regs)->inbound_low_queue_port);
+       spin_unlock_irqrestore(&instance->fire_lock, flags);
        /*msleep(5);*/
 }

@@ -507,7 +519,9 @@ megasas_clear_intr_gen2(struct megasas_r
  * @regs :                     MFI register set
  */
 static inline void
-megasas_fire_cmd_gen2(dma_addr_t frame_phys_addr, u32 frame_count,
+megasas_fire_cmd_gen2(struct megasas_instance *instance,
+                       dma_addr_t frame_phys_addr,
+                       u32 frame_count,
                        struct megasas_register_set __iomem *regs)
 {
        writel((frame_phys_addr | (frame_count<<1))|1,
@@ -549,7 +563,8 @@ megasas_issue_polled(struct megasas_inst
        /*
         * Issue the frame using inbound queue port
         */
-       instance->instancet->fire_cmd(cmd->frame_phys_addr ,0,instance->reg_set);
+       instance->instancet->fire_cmd(instance,
+                       cmd->frame_phys_addr, 0, instance->reg_set);

        /*
         * Wait for cmd_status to change
@@ -580,7 +595,8 @@ megasas_issue_blocked_cmd(struct megasas
 {
        cmd->cmd_status = ENODATA;

-       instance->instancet->fire_cmd(cmd->frame_phys_addr ,0,instance->reg_set);
+       instance->instancet->fire_cmd(instance,
+                       cmd->frame_phys_addr, 0, instance->reg_set);

        wait_event_timeout(instance->int_cmd_wait_q, (cmd->cmd_status != ENODATA),
                MEGASAS_INTERNAL_CMD_WAIT_TIME*HZ);
@@ -625,7 +641,8 @@ megasas_issue_blocked_abort_cmd(struct m
        cmd->sync_cmd = 1;
        cmd->cmd_status = 0xFF;

-       instance->instancet->fire_cmd(cmd->frame_phys_addr ,0,instance->reg_set);
+       instance->instancet->fire_cmd(instance,
+                       cmd->frame_phys_addr, 0, instance->reg_set);

        /*
         * Wait for this cmd to complete
@@ -1151,7 +1168,8 @@ megasas_queue_command(struct scsi_cmnd *
         */
        atomic_inc(&instance->fw_outstanding);

-       instance->instancet->fire_cmd(cmd->frame_phys_addr ,cmd->frame_count-1,instance->reg_set);
+       instance->instancet->fire_cmd(instance, cmd->frame_phys_addr,
+                               cmd->frame_count-1, instance->reg_set);
        /*
         * Check if we have pend cmds to be completed
         */
@@ -1313,8 +1331,16 @@ static int megasas_wait_for_outstanding(
                * Send signal to FW to stop processing any pending cmds.
                * The controller will be taken offline by the OS now.
                */
-               writel(MFI_STOP_ADP,
+               if ((instance->pdev->device ==
+                       PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+                       (instance->pdev->device ==
+                       PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+                       writel(MFI_STOP_ADP,
+                               &instance->reg_set->reserved_0[0]);
+               } else {
+                       writel(MFI_STOP_ADP,
                                &instance->reg_set->inbound_doorbell);
+               }
                megasas_dump_pending_frames(instance);
                instance->hw_crit_error = 1;
                return FAILED;
@@ -1761,7 +1787,7 @@ megasas_transition_to_ready(struct megas
                        /*
                         * Set the CLR bit in inbound doorbell
                         */
-                       if ((instance->pdev->device == \
+                       if ((instance->pdev->device ==
                                PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
                                (instance->pdev->device ==
                                PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
@@ -2760,7 +2786,8 @@ megasas_register_aen(struct megasas_inst
        /*
         * Issue the aen registration frame
         */
-       instance->instancet->fire_cmd(cmd->frame_phys_addr ,0,instance->reg_set);
+       instance->instancet->fire_cmd(instance,
+                       cmd->frame_phys_addr, 0, instance->reg_set);

        return 0;
 }
@@ -2945,6 +2972,7 @@ megasas_probe_one(struct pci_dev *pdev,
        init_waitqueue_head(&instance->abort_cmd_wait_q);

        spin_lock_init(&instance->cmd_pool_lock);
+       spin_lock_init(&instance->fire_lock);
        spin_lock_init(&instance->completion_lock);

        mutex_init(&instance->aen_mutex);
@@ -3134,6 +3162,7 @@ megasas_suspend(struct pci_dev *pdev, pm
        struct megasas_instance *instance;

        instance = pci_get_drvdata(pdev);
+       instance->unload = 1;
        host = instance->host;

        if (poll_mode_io)
@@ -3230,6 +3259,8 @@ megasas_resume(struct pci_dev *pdev)
                megasas_start_timer(instance, &instance->io_completion_timer,
                                megasas_io_completion_timer,
                                MEGASAS_COMPLETION_TIMER_INTERVAL);
+       instance->unload = 0;
+
        return 0;

 fail_irq:
@@ -3580,6 +3611,17 @@ static int megasas_mgmt_ioctl_fw(struct
                goto out_kfree_ioc;
        }

+       if (instance->hw_crit_error == 1) {
+               printk(KERN_DEBUG "Controller in Crit ERROR\n");
+               error = -ENODEV;
+               goto out_kfree_ioc;
+       }
+
+       if (instance->unload == 1) {
+               error = -ENODEV;
+               goto out_kfree_ioc;
+       }
+
        /*
         * We will allow only MEGASAS_INT_CMDS number of parallel ioctl cmds
         */
@@ -3615,6 +3657,14 @@ static int megasas_mgmt_ioctl_aen(struct
        if (!instance)
                return -ENODEV;

+       if (instance->hw_crit_error == 1) {
+               error = -ENODEV;
+       }
+
+       if (instance->unload == 1) {
+               return -ENODEV;
+       }
+
        mutex_lock(&instance->aen_mutex);
        error = megasas_register_aen(instance, aen.seq_num,
                                     aen.class_locale_word);
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-05-04 20:44:37.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-05-04 20:00:31.000000000 -0400
@@ -1167,17 +1167,6 @@ struct megasas_evt_detail {

 } __attribute__ ((packed));

- struct megasas_instance_template {
-       void (*fire_cmd)(dma_addr_t ,u32 ,struct megasas_register_set __iomem *);
-
-       void (*enable_intr)(struct megasas_register_set __iomem *) ;
-       void (*disable_intr)(struct megasas_register_set __iomem *);
-
-       int (*clear_intr)(struct megasas_register_set __iomem *);
-
-       u32 (*read_fw_status_reg)(struct megasas_register_set __iomem *);
- };
-
 struct megasas_aen_event {
        struct work_struct hotplug_work;
        struct megasas_instance *instance;
@@ -1207,6 +1196,7 @@ struct megasas_instance {
        struct list_head cmd_pool;
        spinlock_t cmd_pool_lock;
        /* used to synch producer, consumer ptrs in dpc */
+       spinlock_t fire_lock;
        spinlock_t completion_lock;
        struct dma_pool *frame_dma_pool;
        struct dma_pool *sense_dma_pool;
@@ -1240,6 +1230,18 @@ struct megasas_instance {
        struct timer_list io_completion_timer;
 };

+struct megasas_instance_template {
+       void (*fire_cmd)(struct megasas_instance *, dma_addr_t, \
+               u32, struct megasas_register_set __iomem *);
+
+       void (*enable_intr)(struct megasas_register_set __iomem *) ;
+       void (*disable_intr)(struct megasas_register_set __iomem *);
+
+       int (*clear_intr)(struct megasas_register_set __iomem *);
+
+       u32 (*read_fw_status_reg)(struct megasas_register_set __iomem *);
+};
+
 #define MEGASAS_IS_LOGICAL(scp)                                                \
        (scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1

