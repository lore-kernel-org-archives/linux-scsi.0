From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 6/12] scsi: megaraid_sas - Online Controller Reset (OCR) :
 IOCTL cmds need to wait for OCR finish
Date: Fri, 18 Jun 2010 14:55:10 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D0927495@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804555@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D0804555@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

RESUBMIT: 

During the Online Controller Reset (OCR), all applications cmds need to wait for the OCR to finish, then can issue new cmds to FW.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |  169 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |    6 +
 2 files changed, 173 insertions(+), 2 deletions(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-06-17 08:10:50.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-06-17 08:42:32.000000000 -0400
@@ -107,6 +107,12 @@ static void
 megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		     u8 alt_status);
 
+static int megasas_transition_to_ready(struct megasas_instance *instance);
+static int megasas_get_pd_list(struct megasas_instance *instance);
+static int megasas_issue_init_mfi(struct megasas_instance *instance);
+static int megasas_register_aen(struct megasas_instance *instance,
+				u32 seq_num, u32 class_locale_word);
+
 /**
  * megasas_get_cmd -	Get a command from the free pool
  * @instance:		Adapter soft state
@@ -1471,6 +1477,18 @@ static int megasas_slave_alloc(struct sc
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
@@ -2063,6 +2081,32 @@ megasas_complete_cmd(struct megasas_inst
 }
 
 /**
+ * megasas_issue_pending_cmds_again -	issue all pending cmds
+ *                              	in FW again because of the fw reset
+ * @instance:				Adapter soft state
+ */
+static inline void
+megasas_issue_pending_cmds_again(struct megasas_instance *instance)
+{
+	return;
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
+
+static void
+megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
+{
+}
+
+/**
  * megasas_deplete_reply_queue -	Processes all completed commands
  * @instance:				Adapter soft state
  * @alt_status:				Alternate status to be returned to
@@ -2075,6 +2119,7 @@ megasas_deplete_reply_queue(struct megas
 					u8 alt_status)
 {
 	u32 mfiStatus;
+	u32 fw_state;
 
 	if ((mfiStatus = instance->instancet->check_reset(instance,
 					instance->reg_set)) == 1) {
@@ -2087,6 +2132,51 @@ megasas_deplete_reply_queue(struct megas
 		return IRQ_NONE;
 	}
 
+	instance->mfiStatus = mfiStatus;
+
+	if ((mfiStatus & MFI_INTR_FLAG_FIRMWARE_STATE_CHANGE)) {
+		fw_state = instance->instancet->read_fw_status_reg(
+				instance->reg_set) & MFI_STATE_MASK;
+
+		if (fw_state != MFI_STATE_FAULT) {
+			printk(KERN_NOTICE "megaraid_sas: fw state:%x\n",
+						fw_state);
+		}
+
+		if ((fw_state == MFI_STATE_FAULT) &&
+				(instance->disableOnlineCtrlReset == 0)) {
+			printk(KERN_NOTICE "megaraid_sas: wait adp restart\n");
+
+			if ((instance->pdev->device ==
+					PCI_DEVICE_ID_LSI_SAS1064R) ||
+				(instance->pdev->device ==
+					PCI_DEVICE_ID_DELL_PERC5) ||
+				(instance->pdev->device ==
+					PCI_DEVICE_ID_LSI_VERDE_ZCR)) {
+
+				*instance->consumer =
+					MEGASAS_ADPRESET_INPROG_SIGN;
+			}
+
+
+			instance->instancet->disable_intr(instance->reg_set);
+			instance->adprecovery	= MEGASAS_ADPRESET_SM_INFAULT;
+			instance->issuepend_done = 0;
+
+			atomic_set(&instance->fw_outstanding, 0);
+			megasas_internal_reset_defer_cmds(instance);
+
+			printk(KERN_NOTICE "megasas: fwState=%x, stage:%d\n",
+					fw_state, instance->adprecovery);
+
+			return IRQ_HANDLED;
+
+		} else {
+			printk(KERN_NOTICE "megasas: fwstate:%x, dis_OCR=%x\n",
+				fw_state, instance->disableOnlineCtrlReset);
+		}
+	}
+
 	tasklet_schedule(&instance->isr_tasklet);
 	return IRQ_HANDLED;
 }
@@ -2095,8 +2185,21 @@ megasas_deplete_reply_queue(struct megas
  */
 static irqreturn_t megasas_isr(int irq, void *devp)
 {
-	return megasas_deplete_reply_queue((struct megasas_instance *)devp,
-					   DID_OK);
+	struct megasas_instance *instance;
+	unsigned long flags;
+	irqreturn_t	rc;
+
+	if (atomic_read(
+		&(((struct megasas_instance *)devp)->fw_reset_no_pci_access)))
+		return IRQ_HANDLED;
+
+	instance = (struct megasas_instance *)devp;
+
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	rc =  megasas_deplete_reply_queue(instance, DID_OK);
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+	return rc;
 }
 
 /**
@@ -4094,6 +4197,9 @@ static int megasas_mgmt_ioctl_fw(struct 
 	struct megasas_iocpacket *ioc;
 	struct megasas_instance *instance;
 	int error;
+	int i;
+	unsigned long flags;
+	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
 	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
 	if (!ioc)
@@ -4129,6 +4235,34 @@ static int megasas_mgmt_ioctl_fw(struct 
 		goto out_kfree_ioc;
 	}
 
+	for (i = 0; i < wait_time; i++) {
+
+		spin_lock_irqsave(&instance->hba_lock, flags);
+		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL) {
+			spin_unlock_irqrestore(&instance->hba_lock, flags);
+			break;
+		}
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
+			printk(KERN_NOTICE "megasas: waiting"
+				"for controller reset to finish\n");
+		}
+
+		msleep(1000);
+	}
+
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+		printk(KERN_ERR "megaraid_sas: timed out while"
+			"waiting for HBA to recover\n");
+		error = -ENODEV;
+		goto out_kfree_ioc;
+	}
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+
 	error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
 	up(&instance->ioctl_sem);
 
@@ -4142,6 +4276,9 @@ static int megasas_mgmt_ioctl_aen(struct
 	struct megasas_instance *instance;
 	struct megasas_aen aen;
 	int error;
+	int i;
+	unsigned long flags;
+	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
 	if (file->private_data != file) {
 		printk(KERN_DEBUG "megasas: fasync_helper was not "
@@ -4165,6 +4302,34 @@ static int megasas_mgmt_ioctl_aen(struct
 		return -ENODEV;
 	}
 
+	for (i = 0; i < wait_time; i++) {
+
+		spin_lock_irqsave(&instance->hba_lock, flags);
+		if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL) {
+			spin_unlock_irqrestore(&instance->hba_lock,
+						flags);
+			break;
+		}
+
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
+			printk(KERN_NOTICE "megasas: waiting for"
+				"controller reset to finish\n");
+		}
+
+		msleep(1000);
+	}
+
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+		printk(KERN_ERR "megaraid_sas: timed out while waiting"
+				"for HBA to recover.\n");
+		return -ENODEV;
+	}
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+
 	mutex_lock(&instance->aen_mutex);
 	error = megasas_register_aen(instance, aen.seq_num,
 				     aen.class_locale_word);
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-06-17 08:10:50.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-06-17 08:25:39.000000000 -0400
@@ -414,8 +414,14 @@ struct megasas_ctrl_prop {
 	u8 abortCCOnError;
 	u8 loadBalanceMode;
 	u8 disableAutoDetectBackplane;
+
 	u8 snapVDSpace;
 
+	/*
+	* Add properties that can be controlled by
+	* a bit in the following structure.
+	*/
+
 	struct {
 		u32     copyBackDisabled            : 1;
 		u32     SMARTerEnabled              : 1;
