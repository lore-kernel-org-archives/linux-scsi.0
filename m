From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 3/7] scsi: megaraid_sas - Online COntroller Reset (OCR)
 PART-III
Date: Thu, 6 May 2010 09:52:47 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3CDB80BE9@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:48898 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754957Ab0EFPxE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2010 11:53:04 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>

This is third part of the Online Controller Reset. In ISR routine, if driver receive the FW state change interrupt
And the online controller reset support enabled in FW, driver will read the controller register.  Driver will issue
Controller reset if the FW register state failure.  Also driver will back up the pending cmds for the re-fire after
the reset finished.

Also Driver added the CTIO support to this patch.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
megaraid_sas.c |  412 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
megaraid_sas.h |   46 +++++-
 2 files changed, 433 insertions(+), 25 deletions(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c    2010-05-02 02:39:12.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c    2010-05-03 03:46:39.000000000 -0400
@@ -107,6 +107,12 @@ static void
 megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
                     u8 alt_status);

+static int megasas_transition_to_ready(struct megasas_instance *instance);
+static int megasas_get_pd_list(struct megasas_instance *instance);
+static int megasas_issue_init_mfi(struct megasas_instance *instance);
+static int megasas_register_aen(struct megasas_instance *instance,
+                               u32 seq_num, u32 class_locale_word);
+
 /**
  * megasas_get_cmd -   Get a command from the free pool
  * @instance:          Adapter soft state
@@ -1856,7 +1862,8 @@ megasas_service_aen(struct megasas_insta
        instance->aen_cmd = NULL;
        megasas_return_cmd(instance, cmd);

-       if (instance->unload == 0) {
+       if ((instance->unload == 0) &&
+               ((instance->issuepend_done == 1))) {
                struct megasas_aen_event *ev;
                ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
                if (!ev) {
@@ -1951,6 +1958,9 @@ megasas_complete_cmd(struct megasas_inst
        struct megasas_header *hdr = &cmd->frame->hdr;
        unsigned long flags;

+       /* flag for the retry reset */
+       cmd->retry_for_fw_reset = 0;
+
        if (cmd->scmd)
                cmd->scmd->SCp.ptr = NULL;

@@ -2071,39 +2081,301 @@ megasas_complete_cmd(struct megasas_inst
 }

 /**
+ * megasas_issue_pending_cmds_again -  issue all pending cmds
+ *                                     in FW again because of the fw reset
+ * @instance:                          Adapter soft state
+ */
+static inline void
+megasas_issue_pending_cmds_again(struct megasas_instance *instance)
+{
+       struct megasas_cmd *cmd;
+       struct list_head clist_local;
+       union megasas_evt_class_locale class_locale;
+       unsigned long flags;
+       u32 seq_num;
+
+       INIT_LIST_HEAD(&clist_local);
+       spin_lock_irqsave(&instance->hba_lock, flags);
+       list_splice_init(&instance->internal_reset_pending_q, &clist_local);
+       spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+       while (!list_empty(&clist_local)) {
+               cmd     = list_entry((&clist_local)->next,
+                                       struct megasas_cmd, list);
+               list_del_init(&cmd->list);
+
+               if (cmd->sync_cmd || cmd->scmd) {
+                       printk(KERN_NOTICE "megaraid_sas: command %p, %p:%d"
+                               "detected to be pending while HBA reset.\n",
+                                       cmd, cmd->scmd, cmd->sync_cmd);
+
+                       cmd->retry_for_fw_reset++;
+
+                       if (cmd->retry_for_fw_reset == 3) {
+                               printk(KERN_NOTICE "megaraid_sas: cmd %p, %p:%d"
+                                       "was tried multiple times during reset."
+                                       "Shutting down the HBA\n",
+                                       cmd, cmd->scmd, cmd->sync_cmd);
+                               megaraid_sas_kill_hba(instance);
+
+                               instance->adprecovery =
+                                               MEGASAS_HW_CRITICAL_ERROR;
+                               return;
+                       }
+               }
+
+               if (cmd->sync_cmd == 1) {
+                       if (cmd->scmd) {
+                               printk(KERN_NOTICE "megaraid_sas: unexpected"
+                                       "cmd attached to internal command!\n");
+                       }
+                       printk(KERN_NOTICE "megasas: %p synchronous cmd"
+                                               "on the internal reset queue,"
+                                               "issue it again.\n", cmd);
+                       cmd->cmd_status = ENODATA;
+                       instance->instancet->fire_cmd(instance,
+                                                       cmd->frame_phys_addr ,
+                                                       0, instance->reg_set);
+               } else if (cmd->scmd) {
+                       printk(KERN_NOTICE "megasas: %p scsi cmd [%02x],%#lx"
+                       "detected on the internal queue, issue again.\n",
+                       cmd, cmd->scmd->cmnd[0], cmd->scmd->serial_number);
+
+                       atomic_inc(&instance->fw_outstanding);
+                       instance->instancet->fire_cmd(instance,
+                                       cmd->frame_phys_addr,
+                                       cmd->frame_count-1, instance->reg_set);
+               } else {
+                       printk(KERN_NOTICE "megasas: %p unexpected cmd on the"
+                               "internal reset defer list while re-issue!!\n",
+                               cmd);
+               }
+       }
+
+       if (instance->aen_cmd) {
+               printk(KERN_NOTICE "megaraid_sas: aen_cmd in def process\n");
+               megasas_return_cmd(instance, instance->aen_cmd);
+
+               instance->aen_cmd       = NULL;
+       }
+
+       /*
+       * Initiate AEN (Asynchronous Event Notification)
+       */
+       seq_num = instance->last_seq_num;
+       class_locale.members.reserved = 0;
+       class_locale.members.locale = MR_EVT_LOCALE_ALL;
+       class_locale.members.class = MR_EVT_CLASS_DEBUG;
+
+       megasas_register_aen(instance, seq_num, class_locale.word);
+}
+
+/**
+ * Move the internal reset pending commands to a deferred queue.
+ *
+ * We move the commands pending at internal reset time to a
+ * pending queue. This queue would be flushed after successful
+ * completion of the internal reset sequence. if the internal reset
+ * did not complete in time, the kernel reset handler would flush
+ * these commands.
+ **/
+static void
+megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
+{
+       struct megasas_cmd *cmd;
+       int i;
+       u32 max_cmd = instance->max_fw_cmds;
+       u32 defer_index;
+       unsigned long flags;
+
+       defer_index     = 0;
+       spin_lock_irqsave(&instance->cmd_pool_lock, flags);
+       for (i = 0; i < max_cmd; i++) {
+               cmd = instance->cmd_list[i];
+               if (cmd->sync_cmd == 1 || cmd->scmd) {
+                       printk(KERN_NOTICE "megasas: moving cmd[%d]:%p:%d:%p"
+                                       "on the defer queue as internal\n",
+                               defer_index, cmd, cmd->sync_cmd, cmd->scmd);
+
+                       if (!list_empty(&cmd->list)) {
+                               printk(KERN_NOTICE "megaraid_sas: ERROR while"
+                                       " moving this cmd:%p, %d %p, it was"
+                                       "discovered on some list?\n",
+                                       cmd, cmd->sync_cmd, cmd->scmd);
+
+                               list_del_init(&cmd->list);
+                       }
+                       defer_index++;
+                       list_add_tail(&cmd->list,
+                               &instance->internal_reset_pending_q);
+               }
+       }
+       spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
+}
+
+
+static void
+process_fw_state_change_wq(struct work_struct *work)
+{
+       struct megasas_instance *instance =
+               container_of(work, struct megasas_instance, work_init);
+       u32 wait;
+       unsigned long flags;
+
+       if (instance->adprecovery != MEGASAS_ADPRESET_SM_INFAULT) {
+               printk(KERN_NOTICE "megaraid_sas: error, recovery st %x \n",
+                               instance->adprecovery);
+               return ;
+       }
+
+       if (instance->adprecovery == MEGASAS_ADPRESET_SM_INFAULT) {
+               printk(KERN_NOTICE "megaraid_sas: FW detected to be in fault"
+                                       "state, restarting it...\n");
+
+               instance->instancet->disable_intr(instance->reg_set);
+               atomic_set(&instance->fw_outstanding, 0);
+
+               atomic_set(&instance->fw_reset_no_pci_access, 1);
+               instance->instancet->adp_reset(instance, instance->reg_set);
+               atomic_set(&instance->fw_reset_no_pci_access, 0 );
+
+               printk(KERN_NOTICE "megaraid_sas: FW restarted successfully,"
+                                       "initiating next stage...\n");
+
+               printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine,"
+                                       "state 2 starting...\n");
+
+               /*waitting for about 20 second before start the second init*/
+               for (wait = 0; wait < 30; wait++) {
+                       msleep(1000);
+               }
+
+               if (megasas_transition_to_ready(instance)) {
+                       printk(KERN_NOTICE "megaraid_sas:adapter not ready\n");
+
+                       megaraid_sas_kill_hba(instance);
+                       instance->adprecovery   = MEGASAS_HW_CRITICAL_ERROR;
+                       return ;
+               }
+
+               if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1064R) ||
+                       (instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||
+                       (instance->pdev->device == PCI_DEVICE_ID_LSI_VERDE_ZCR)
+                       ) {
+                       *instance->consumer = *instance->producer;
+               } else {
+                       *instance->consumer = 0;
+                       *instance->producer = 0;
+               }
+
+               megasas_issue_init_mfi(instance);
+
+               spin_lock_irqsave(&instance->hba_lock, flags);
+               instance->adprecovery   = MEGASAS_HBA_OPERATIONAL;
+               spin_unlock_irqrestore(&instance->hba_lock, flags);
+               instance->instancet->enable_intr(instance->reg_set);
+
+               megasas_issue_pending_cmds_again(instance);
+               instance->issuepend_done = 1;
+       }
+       return ;
+}
+
+/**
  * megasas_deplete_reply_queue -       Processes all completed commands
  * @instance:                          Adapter soft state
  * @alt_status:                                Alternate status to be returned to
  *                                     SCSI mid-layer instead of the status
  *                                     returned by the FW
+ * Note: this must be called with hba lock held
  */
 static int
-megasas_deplete_reply_queue(struct megasas_instance *instance, u8 alt_status)
+megasas_deplete_reply_queue(struct megasas_instance *instance,
+                                       u8 alt_status)
 {
-       /*
-        * Check if it is our interrupt
-        * Clear the interrupt
-        */
-       if(instance->instancet->clear_intr(instance->reg_set))
+       u32 mfiStatus;
+       u32 fw_state;
+
+       if ((mfiStatus = instance->instancet->check_reset(instance,
+                                       instance->reg_set)) == 1) {
+               return IRQ_HANDLED;
+       }
+
+       if ((mfiStatus = instance->instancet->clear_intr(
+                                               instance->reg_set)
+                                               ) == 0) {
                return IRQ_NONE;
+       }
+
+       instance->mfiStatus = mfiStatus;
+
+       if ((mfiStatus & MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE)) {
+               fw_state = instance->instancet->read_fw_status_reg(
+                               instance->reg_set) & MFI_STATE_MASK;
+
+               if (fw_state != MFI_STATE_FAULT) {
+                       printk(KERN_NOTICE "megaraid_sas: fw state:%x\n",
+                                               fw_state);
+               }
+
+               if ((fw_state == MFI_STATE_FAULT) &&
+                               (instance->disableOnlineCtrlReset == 0)) {
+                       printk(KERN_NOTICE "megaraid_sas: wait adp restart\n");
+
+                       if ((instance->pdev->device ==
+                                       PCI_DEVICE_ID_LSI_SAS1064R) ||
+                               (instance->pdev->device ==
+                                       PCI_DEVICE_ID_DELL_PERC5) ||
+                               (instance->pdev->device ==
+                                       PCI_DEVICE_ID_LSI_VERDE_ZCR)) {
+
+                               *instance->consumer =
+                                       MEGASAS_ADPRESET_INPROG_SIGN;
+                       }
+
+
+                       instance->instancet->disable_intr(instance->reg_set);
+                       instance->adprecovery   = MEGASAS_ADPRESET_SM_INFAULT;
+                       instance->issuepend_done = 0;
+
+                       atomic_set(&instance->fw_outstanding, 0);
+                       megasas_internal_reset_defer_cmds(instance);
+
+                       printk(KERN_NOTICE "megasas: fwState=%x, stage:%d\n",
+                                       fw_state, instance->adprecovery);
+
+                       schedule_work(&instance->work_init);
+                       return IRQ_HANDLED;
+
+               } else {
+                       printk(KERN_NOTICE "megasas: fwstate:%x, dis_OCR=%x\n",
+                               fw_state, instance->disableOnlineCtrlReset);
+               }
+       }

-       if (instance->hw_crit_error)
-               goto out_done;
-        /*
-        * Schedule the tasklet for cmd completion
-        */
        tasklet_schedule(&instance->isr_tasklet);
-out_done:
        return IRQ_HANDLED;
 }
-
 /**
  * megasas_isr - isr entry point
  */
 static irqreturn_t megasas_isr(int irq, void *devp)
 {
-       return megasas_deplete_reply_queue((struct megasas_instance *)devp,
-                                          DID_OK);
+       struct megasas_instance *instance;
+       unsigned long flags;
+       irqreturn_t     rc;
+
+       if (atomic_read(
+               &(((struct megasas_instance *)devp)->fw_reset_no_pci_access)))
+               return IRQ_HANDLED;
+
+       instance = (struct megasas_instance *)devp;
+
+       spin_lock_irqsave(&instance->hba_lock, flags);
+       rc =  megasas_deplete_reply_queue(instance, DID_OK);
+       spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+       return rc;
 }

 /**
@@ -2260,7 +2532,7 @@ megasas_transition_to_ready(struct megas
                               "in %d secs\n", fw_state, max_wait);
                        return -ENODEV;
                }
-       };
+       }
        printk(KERN_INFO "megasas: FW now in Ready state\n");

        return 0;
@@ -2342,6 +2614,7 @@ static int megasas_create_frame_pool(str
         */
        sgl_sz = sge_sz * instance->max_num_sge;
        frame_count = (sgl_sz + MEGAMFI_FRAME_SIZE - 1) / MEGAMFI_FRAME_SIZE;
+       frame_count = 15;

        /*
         * We need one extra frame for the MFI command
@@ -2489,6 +2762,7 @@ static int megasas_alloc_cmds(struct meg
                cmd = instance->cmd_list[i];
                memset(cmd, 0, sizeof(struct megasas_cmd));
                cmd->index = i;
+               cmd->scmd = NULL;
                cmd->instance = instance;

                list_add_tail(&cmd->list, &instance->cmd_pool);
@@ -2656,7 +2930,7 @@ megasas_get_ld_list(struct megasas_insta

        /* the following function will get the instance PD LIST */

-       if ((ret == 0) && (ci->ldCount < MAX_LOGICAL_DRIVES)) {
+       if ((ret == 0) && (ci->ldCount <= MAX_LOGICAL_DRIVES)) {
                memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);

                for (ld_index = 0; ld_index < ci->ldCount; ld_index++) {
@@ -2970,6 +3244,21 @@ static int megasas_init_mfi(struct megas
        if (megasas_issue_init_mfi(instance))
                goto fail_fw_init;

+       instance->fw_support_ieee = 0;
+       instance->fw_support_ieee =
+               (instance->instancet->read_fw_status_reg(reg_set) &
+               0x04000000);
+
+       printk(KERN_NOTICE "megasas_init_mfi: fw_support_ieee=%d",
+                       instance->fw_support_ieee);
+
+       if (instance->fw_support_ieee)
+               instance->flag_ieee = 1;
+
+       /** for passthrough
+       * the following function will get the PD LIST.
+       */
+
        memset(instance->pd_list, 0 ,
                (MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
        megasas_get_pd_list(instance);
@@ -2996,6 +3285,8 @@ static int megasas_init_mfi(struct megas
                max_sectors_2 = ctrl_info->max_request_size;

                tmp_sectors = min_t(u32, max_sectors_1 , max_sectors_2);
+               instance->disableOnlineCtrlReset =
+               ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
        }

        instance->max_sectors_per_req = instance->max_num_sge *
@@ -3217,6 +3508,7 @@ megasas_register_aen(struct megasas_inst
        dcmd->flags = MFI_FRAME_DIR_READ;
        dcmd->timeout = 0;
        dcmd->pad_0 = 0;
+       instance->last_seq_num = seq_num;
        dcmd->data_xfer_len = sizeof(struct megasas_evt_detail);
        dcmd->opcode = MR_DCMD_CTRL_EVENT_WAIT;
        dcmd->mbox.w[0] = seq_num;
@@ -3385,6 +3677,7 @@ megasas_probe_one(struct pci_dev *pdev,

        instance = (struct megasas_instance *)host->hostdata;
        memset(instance, 0, sizeof(*instance));
+       atomic_set( &instance->fw_reset_no_pci_access, 0 );

        instance->producer = pci_alloc_consistent(pdev, sizeof(u32),
                                                  &instance->producer_h);
@@ -3402,6 +3695,9 @@ megasas_probe_one(struct pci_dev *pdev,
        megasas_poll_wait_aen = 0;
        instance->flag_ieee = 0;
        instance->ev = NULL;
+       instance->issuepend_done = 1;
+       instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
+       megasas_poll_wait_aen = 0;

        instance->evt_detail = pci_alloc_consistent(pdev,
                                                    sizeof(struct
@@ -3451,6 +3747,9 @@ megasas_probe_one(struct pci_dev *pdev,
        instance->flag = 0;
        instance->unload = 1;
        instance->last_time = 0;
+       instance->disableOnlineCtrlReset = 1;
+
+       INIT_WORK(&instance->work_init, process_fw_state_change_wq);

        /*
         * Initialize MFI Firmware
@@ -3542,6 +3841,9 @@ static void megasas_flush_cache(struct m
        struct megasas_cmd *cmd;
        struct megasas_dcmd_frame *dcmd;

+       if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
+               return;
+
        cmd = megasas_get_cmd(instance);

        if (!cmd)
@@ -3579,6 +3881,9 @@ static void megasas_shutdown_controller(
        struct megasas_cmd *cmd;
        struct megasas_dcmd_frame *dcmd;

+       if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
+               return;
+
        cmd = megasas_get_cmd(instance);

        if (!cmd)
@@ -4070,6 +4375,9 @@ static int megasas_mgmt_ioctl_fw(struct
        struct megasas_iocpacket *ioc;
        struct megasas_instance *instance;
        int error;
+       int i;
+       unsigned long flags;
+       u32 wait_time = MEGASAS_RESET_WAIT_TIME;

        ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
        if (!ioc)
@@ -4086,8 +4394,8 @@ static int megasas_mgmt_ioctl_fw(struct
                goto out_kfree_ioc;
        }

-       if (instance->hw_crit_error == 1) {
-               printk(KERN_DEBUG "Controller in Crit ERROR\n");
+       if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
+               printk(KERN_ERR "Controller in crit error\n");
                error = -ENODEV;
                goto out_kfree_ioc;
        }
@@ -4104,6 +4412,35 @@ static int megasas_mgmt_ioctl_fw(struct
                error = -ERESTARTSYS;
                goto out_kfree_ioc;
        }
+
+       for (i = 0; i < wait_time; i++) {
+
+               spin_lock_irqsave(&instance->hba_lock, flags);
+               if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL) {
+                       spin_unlock_irqrestore(&instance->hba_lock, flags);
+                       break;
+               }
+               spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+               if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
+                       printk(KERN_NOTICE "megasas: waiting"
+                               "for controller reset to finish\n");
+               }
+
+               msleep(1000);
+       }
+
+       spin_lock_irqsave(&instance->hba_lock, flags);
+       if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
+               spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+               printk(KERN_ERR "megaraid_sas: timed out while"
+                       "waiting for HBA to recover\n");
+               error = -ENODEV;
+               goto out_kfree_ioc;
+       }
+       spin_unlock_irqrestore(&instance->hba_lock, flags);
+
        error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
        up(&instance->ioctl_sem);

@@ -4117,6 +4454,9 @@ static int megasas_mgmt_ioctl_aen(struct
        struct megasas_instance *instance;
        struct megasas_aen aen;
        int error;
+       int i;
+       unsigned long flags;
+       u32 wait_time = MEGASAS_RESET_WAIT_TIME;

        if (file->private_data != file) {
                printk(KERN_DEBUG "megasas: fasync_helper was not "
@@ -4132,14 +4472,42 @@ static int megasas_mgmt_ioctl_aen(struct
        if (!instance)
                return -ENODEV;

-       if (instance->hw_crit_error == 1) {
-               error = -ENODEV;
+       if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
+               return -ENODEV;
        }

        if (instance->unload == 1) {
                return -ENODEV;
        }

+       for (i = 0; i < wait_time; i++) {
+
+               spin_lock_irqsave(&instance->hba_lock, flags);
+               if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL) {
+                       spin_unlock_irqrestore(&instance->hba_lock,
+                                               flags);
+                       break;
+               }
+
+               spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+               if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
+                       printk(KERN_NOTICE "megasas: waiting for"
+                               "controller reset to finish\n");
+               }
+
+               msleep(1000);
+       }
+
+       spin_lock_irqsave(&instance->hba_lock, flags);
+       if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
+               spin_unlock_irqrestore(&instance->hba_lock, flags);
+               printk(KERN_ERR "megaraid_sas: timed out while waiting"
+                               "for HBA to recover.\n");
+               return -ENODEV;
+       }
+       spin_unlock_irqrestore(&instance->hba_lock, flags);
+
        mutex_lock(&instance->aen_mutex);
        error = megasas_register_aen(instance, aen.seq_num,
                                     aen.class_locale_word);
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h    2010-05-02 02:39:12.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h    2010-05-03 03:46:45.000000000 -0400
@@ -60,6 +60,7 @@
 #define MFI_STATE_READY                                0xB0000000
 #define MFI_STATE_OPERATIONAL                  0xC0000000
 #define MFI_STATE_FAULT                                0xF0000000
+#define  MFI_RESET_REQUIRED                    0x00000001

 #define MEGAMFI_FRAME_SIZE                     64

@@ -408,8 +409,40 @@ struct megasas_ctrl_prop {
        u16 ecc_bucket_leak_rate;
        u8 restore_hotspare_on_insertion;
        u8 expose_encl_devices;
-       u8 reserved[38];
+       u8 maintainPdFailHistory;
+       u8 disallowHostRequestReordering;
+       u8 abortCCOnError;
+       u8 loadBalanceMode;
+       u8 disableAutoDetectBackplane;

+       u8 snapVDSpace;
+
+       /*
+       * Add properties that can be controlled by
+       * a bit in the following structure.
+       */
+
+       struct {
+               u32     copyBackDisabled            : 1;
+               u32     SMARTerEnabled              : 1;
+               u32     prCorrectUnconfiguredAreas  : 1;
+               u32     useFdeOnly                  : 1;
+               u32     disableNCQ                  : 1;
+               u32     SSDSMARTerEnabled           : 1;
+               u32     SSDPatrolReadEnabled        : 1;
+               u32     enableSpinDownUnconfigured  : 1;
+               u32     autoEnhancedImport          : 1;
+               u32     enableSecretKeyControl      : 1;
+               u32     disableOnlineCtrlReset      : 1;
+               u32     allowBootWithPinnedCache    : 1;
+               u32     disableSpinDownHS           : 1;
+               u32     enableJBOD                  : 1;
+               u32     reserved                    :18;
+       } OnOffProperties;
+       u8 autoSnapVDSpace;
+       u8 viewSpace;
+       u16 spinDownTime;
+       u8  reserved[24];
 } __packed;

 /*
@@ -1265,19 +1298,24 @@ struct megasas_instance {

        struct pci_dev *pdev;
        u32 unique_id;
+       u32 fw_support_ieee;

        atomic_t fw_outstanding;
-       u32 hw_crit_error;
+       atomic_t fw_reset_no_pci_access;

        struct megasas_instance_template *instancet;
        struct tasklet_struct isr_tasklet;
+       struct work_struct work_init;

        u8 flag;
        u8 unload;
        u8 flag_ieee;
        u8 issuepend_done;
+       u8 disableOnlineCtrlReset;
        u8 adprecovery;
        unsigned long last_time;
+       u32 mfiStatus;
+       u32 last_seq_num;

        struct timer_list io_completion_timer;
        struct list_head internal_reset_pending_q;
@@ -1325,7 +1363,9 @@ struct megasas_cmd {
        u32 index;
        u8 sync_cmd;
        u8 cmd_status;
-       u16 abort_aen;
+       u8 abort_aen;
+       u8 retry_for_fw_reset;
+

        struct list_head list;
        struct scsi_cmnd *scmd;

