From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 7/12] scsi: megaraid_sas - Online Controller Reset (OCR):
 Pending cmds will be stored in diffeent queue
Date: Fri, 18 Jun 2010 14:59:36 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D092749C@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804558@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D0804558@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

RESUBMIT:

When driver is doing the OCR, driver will store the pending cmds (in FW not return) to different queue.  Those cmds will
Be re-issued to FW after OCR finished.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |  101 ++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-06-17 08:43:34.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-06-17 07:51:23.000000000 -0400
@@ -2100,10 +2100,106 @@ megasas_issue_pending_cmds_again(struct 
  * did not complete in time, the kernel reset handler would flush
  * these commands.
  **/
-
 static void
 megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
 {
+	struct megasas_cmd *cmd;
+	int i;
+	u32 max_cmd = instance->max_fw_cmds;
+	u32 defer_index;
+	unsigned long flags;
+
+	defer_index     = 0;
+	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
+	for (i = 0; i < max_cmd; i++) {
+		cmd = instance->cmd_list[i];
+		if (cmd->sync_cmd == 1 || cmd->scmd) {
+			printk(KERN_NOTICE "megasas: moving cmd[%d]:%p:%d:%p"
+					"on the defer queue as internal\n",
+				defer_index, cmd, cmd->sync_cmd, cmd->scmd);
+
+			if (!list_empty(&cmd->list)) {
+				printk(KERN_NOTICE "megaraid_sas: ERROR while"
+					" moving this cmd:%p, %d %p, it was"
+					"discovered on some list?\n",
+					cmd, cmd->sync_cmd, cmd->scmd);
+
+				list_del_init(&cmd->list);
+			}
+			defer_index++;
+			list_add_tail(&cmd->list,
+				&instance->internal_reset_pending_q);
+		}
+	}
+	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
+}
+
+
+static void
+process_fw_state_change_wq(struct work_struct *work)
+{
+	struct megasas_instance *instance =
+		container_of(work, struct megasas_instance, work_init);
+	u32 wait;
+	unsigned long flags;
+
+	if (instance->adprecovery != MEGASAS_ADPRESET_SM_INFAULT) {
+		printk(KERN_NOTICE "megaraid_sas: error, recovery st %x \n",
+				instance->adprecovery);
+		return ;
+	}
+
+	if (instance->adprecovery == MEGASAS_ADPRESET_SM_INFAULT) {
+		printk(KERN_NOTICE "megaraid_sas: FW detected to be in fault"
+					"state, restarting it...\n");
+
+		instance->instancet->disable_intr(instance->reg_set);
+		atomic_set(&instance->fw_outstanding, 0);
+
+		atomic_set(&instance->fw_reset_no_pci_access, 1);
+		instance->instancet->adp_reset(instance, instance->reg_set);
+		atomic_set(&instance->fw_reset_no_pci_access, 0 );
+
+		printk(KERN_NOTICE "megaraid_sas: FW restarted successfully,"
+					"initiating next stage...\n");
+
+		printk(KERN_NOTICE "megaraid_sas: HBA recovery state machine,"
+					"state 2 starting...\n");
+
+		/*waitting for about 20 second before start the second init*/
+		for (wait = 0; wait < 30; wait++) {
+			msleep(1000);
+		}
+
+		if (megasas_transition_to_ready(instance)) {
+			printk(KERN_NOTICE "megaraid_sas:adapter not ready\n");
+
+			megaraid_sas_kill_hba(instance);
+			instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
+			return ;
+		}
+
+		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1064R) ||
+			(instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||
+			(instance->pdev->device == PCI_DEVICE_ID_LSI_VERDE_ZCR)
+			) {
+			*instance->consumer = *instance->producer;
+		} else {
+			*instance->consumer = 0;
+			*instance->producer = 0;
+		}
+
+		megasas_issue_init_mfi(instance);
+
+		spin_lock_irqsave(&instance->hba_lock, flags);
+		instance->adprecovery	= MEGASAS_HBA_OPERATIONAL;
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+		instance->instancet->enable_intr(instance->reg_set);
+
+		megasas_issue_pending_cmds_again(instance);
+		instance->issuepend_done = 1;
+	}
+	return ;
 }
 
 /**
@@ -2169,6 +2265,7 @@ megasas_deplete_reply_queue(struct megas
 			printk(KERN_NOTICE "megasas: fwState=%x, stage:%d\n",
 					fw_state, instance->adprecovery);
 
+			schedule_work(&instance->work_init);
 			return IRQ_HANDLED;
 
 		} else {
@@ -3573,6 +3670,8 @@ megasas_probe_one(struct pci_dev *pdev, 
 	instance->last_time = 0;
 	instance->disableOnlineCtrlReset = 1;
 
+	INIT_WORK(&instance->work_init, process_fw_state_change_wq);
+
 	/*
 	 * Initialize MFI Firmware
 	 */
