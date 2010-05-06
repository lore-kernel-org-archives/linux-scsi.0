From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 2/7] scsi: megaraid_sas - Online controller Reset Support
 (OCR) PART-II
Date: Thu, 6 May 2010 09:41:26 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3CDB80BCE@cosmail02.lsi.com>
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

This is second part of the Online Controller Reset (OCR).  When driver doesn't finish to issue the pending
Cmds, driver will return BUSY to OS.  Also in driver's timeout routine, if online controller reset is going
On, driver will return RESET to OS. 

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
megaraid_sas.c |  110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
megaraid_sas.h |    2 +
 2 files changed, 107 insertions(+), 5 deletions(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-04-21 05:16:37.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-04-28 08:52:56.000000000 -0400
@@ -1320,14 +1320,22 @@ megasas_queue_command(struct scsi_cmnd *
 	u32 frame_count;
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance;
+	unsigned long flags;
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
 
-	/* Don't process if we have already declared adapter dead */
-	if (instance->hw_crit_error)
+	if (instance->issuepend_done == 0)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+
 	scmd->scsi_done = done;
 	scmd->result = 0;
 
@@ -1463,6 +1471,18 @@ static int megasas_slave_alloc(struct sc
 	return 0;
 }
 
+static void megaraid_sas_kill_hba(struct megasas_instance *instance)
+{
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+		writel(MFI_STOP_ADP,
+			&instance->reg_set->reserved_0[0]);
+	} else {
+		writel(MFI_STOP_ADP,
+			&instance->reg_set->inbound_doorbell);
+	}
+}
+
 /**
  * megasas_complete_cmd_dpc	 -	Returns FW's controller structure
  * @instance_addr:			Address of adapter soft state
@@ -1480,7 +1500,7 @@ static void megasas_complete_cmd_dpc(uns
 	unsigned long flags;
 
 	/* If we have already declared adapter dead, donot complete cmds */
-	if (instance->hw_crit_error)
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR )
 		return;
 
 	spin_lock_irqsave(&instance->completion_lock, flags);
@@ -1490,6 +1510,11 @@ static void megasas_complete_cmd_dpc(uns
 
 	while (consumer != producer) {
 		context = instance->reply_queue[consumer];
+		if (context >= instance->max_fw_cmds) {
+			printk(KERN_ERR "Unexpected context value %x\n",
+				context);
+			BUG();
+		}
 
 		cmd = instance->cmd_list[context];
 
@@ -1539,7 +1564,76 @@ static void megasas_complete_cmd_dpc(uns
 static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 {
 	int i;
+	u32 reset_index;
 	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
+	u8 adprecovery;
+	unsigned long flags;
+	struct list_head clist_local;
+	struct megasas_cmd *reset_cmd;
+
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	adprecovery = instance->adprecovery;
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+	if (adprecovery != MEGASAS_HBA_OPERATIONAL) {
+
+		INIT_LIST_HEAD(&clist_local);
+		spin_lock_irqsave(&instance->hba_lock, flags);
+		list_splice_init(&instance->internal_reset_pending_q,
+				&clist_local);
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+		printk(KERN_NOTICE "megasas: HBA reset wait ...\n");
+		for (i = 0; i < wait_time; i++) {
+			msleep(1000);
+			spin_lock_irqsave(&instance->hba_lock, flags);
+			adprecovery = instance->adprecovery;
+			spin_unlock_irqrestore(&instance->hba_lock, flags);
+			if (adprecovery == MEGASAS_HBA_OPERATIONAL)
+				break;
+		}
+
+		if (adprecovery != MEGASAS_HBA_OPERATIONAL) {
+			printk(KERN_NOTICE "megasas: reset: Stopping HBA.\n");
+			spin_lock_irqsave(&instance->hba_lock, flags);
+			instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
+			spin_unlock_irqrestore(&instance->hba_lock, flags);
+			return FAILED;
+		}
+
+		reset_index	= 0;
+		while (!list_empty(&clist_local)) {
+			reset_cmd	= list_entry((&clist_local)->next,
+						struct megasas_cmd, list);
+			list_del_init(&reset_cmd->list);
+			if (reset_cmd->scmd) {
+				reset_cmd->scmd->result = DID_RESET << 16;
+				printk(KERN_NOTICE "%d:%p reset [%02x], %#lx\n",
+					reset_index, reset_cmd,
+					reset_cmd->scmd->cmnd[0],
+					reset_cmd->scmd->serial_number);
+
+				reset_cmd->scmd->scsi_done(reset_cmd->scmd);
+				megasas_return_cmd(instance, reset_cmd);
+			} else if (reset_cmd->sync_cmd) {
+				printk(KERN_NOTICE "megasas:%p synch cmds"
+						"reset queue\n",
+						reset_cmd);
+
+				reset_cmd->cmd_status = ENODATA;
+				instance->instancet->fire_cmd(instance,
+						reset_cmd->frame_phys_addr,
+						0, instance->reg_set);
+			} else {
+				printk(KERN_NOTICE "megasas: %p unexpected"
+					"cmds lst\n",
+					reset_cmd);
+			}
+			reset_index++;
+		}
+
+		return SUCCESS;
+	}
 
 	for (i = 0; i < wait_time; i++) {
 
@@ -1562,6 +1656,7 @@ static int megasas_wait_for_outstanding(
 	}
 
 	if (atomic_read(&instance->fw_outstanding)) {
+		printk(KERN_NOTICE "megaraid_sas: pending cmds after reset\n");
 		/*
 		* Send signal to FW to stop processing any pending cmds.
 		* The controller will be taken offline by the OS now.
@@ -1577,10 +1672,14 @@ static int megasas_wait_for_outstanding(
 				&instance->reg_set->inbound_doorbell);
 		}
 		megasas_dump_pending_frames(instance);
-		instance->hw_crit_error = 1;
+		spin_lock_irqsave(&instance->hba_lock, flags);
+		instance->adprecovery	= MEGASAS_HW_CRITICAL_ERROR;
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
 		return FAILED;
 	}
 
+	printk(KERN_NOTICE "megaraid_sas: no pending cmds after reset\n");
+
 	return SUCCESS;
 }
 
@@ -1602,7 +1701,7 @@ static int megasas_generic_reset(struct 
 	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET -%ld cmd=%x retries=%x\n",
 		 scmd->serial_number, scmd->cmnd[0], scmd->retries);
 
-	if (instance->hw_crit_error) {
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
 		printk(KERN_ERR "megasas: cannot recover from previous reset "
 		       "failures\n");
 		return FAILED;
@@ -3319,6 +3418,7 @@ megasas_probe_one(struct pci_dev *pdev, 
 	 * Initialize locks and queues
 	 */
 	INIT_LIST_HEAD(&instance->cmd_pool);
+	INIT_LIST_HEAD(&instance->internal_reset_pending_q);
 
 	atomic_set(&instance->fw_outstanding,0);
 
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-04-21 05:16:37.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-04-28 08:01:45.000000000 -0400
@@ -1275,10 +1275,12 @@ struct megasas_instance {
 	u8 flag;
 	u8 unload;
 	u8 flag_ieee;
+	u8 issuepend_done;
 	u8 adprecovery;
 	unsigned long last_time;
 
 	struct timer_list io_completion_timer;
+	struct list_head internal_reset_pending_q;
 };
 
 enum {
