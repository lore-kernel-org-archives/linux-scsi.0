From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 6/12] scsi: megaraid_sas - Online Controller Reset (OCR) :
 IOCTL cmds need to wait for OCR finish
Date: Wed, 9 Jun 2010 22:02:18 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D0804555@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:36756 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab0FJECk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2010 00:02:40 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

During the Online Controller Reset (OCR), all applications cmds need to wait for the OCR to finish, then can issue new cmds to FW.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |  163 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |   35 +++++++
 2 files changed, 195 insertions(+), 3 deletions(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 16:09:25.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-06-08 16:12:27.000000000 -0400
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
@@ -2075,6 +2081,38 @@ megasas_complete_cmd(struct megasas_inst
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
+static void
+megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
+{
+	return;
+}
+
+
+static void
+process_fw_state_change_wq(struct work_struct *work)
+(
+	return;
+)
+/**
  * megasas_deplete_reply_queue -	Processes all completed commands
  * @instance:				Adapter soft state
  * @alt_status:				Alternate status to be returned to
@@ -2100,6 +2138,52 @@ megasas_deplete_reply_queue(struct megas
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
+			schedule_work(&instance->work_init);
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
@@ -2108,8 +2192,21 @@ megasas_deplete_reply_queue(struct megas
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
@@ -4109,6 +4206,9 @@ static int megasas_mgmt_ioctl_fw(struct 
 	struct megasas_iocpacket *ioc;
 	struct megasas_instance *instance;
 	int error;
+	int i;
+	unsigned long flags;
+	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
 	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
 	if (!ioc)
@@ -4144,6 +4244,34 @@ static int megasas_mgmt_ioctl_fw(struct 
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
 
@@ -4157,6 +4285,9 @@ static int megasas_mgmt_ioctl_aen(struct
 	struct megasas_instance *instance;
 	struct megasas_aen aen;
 	int error;
+	int i;
+	unsigned long flags;
+	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
 	if (file->private_data != file) {
 		printk(KERN_DEBUG "megasas: fasync_helper was not "
@@ -4180,6 +4311,34 @@ static int megasas_mgmt_ioctl_aen(struct
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
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-06-08 16:09:25.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-06-08 16:09:43.000000000 -0400
@@ -409,7 +409,40 @@ struct megasas_ctrl_prop {
 	u16 ecc_bucket_leak_rate;
 	u8 restore_hotspare_on_insertion;
 	u8 expose_encl_devices;
-	u8 reserved[38];
+	u8 maintainPdFailHistory;
+	u8 disallowHostRequestReordering;
+	u8 abortCCOnError;
+	u8 loadBalanceMode;
+	u8 disableAutoDetectBackplane;
+
+	u8 snapVDSpace;
+
+	/*
+	* Add properties that can be controlled by
+	* a bit in the following structure.
+	*/
+
+	struct {
+		u32     copyBackDisabled            : 1;
+		u32     SMARTerEnabled              : 1;
+		u32     prCorrectUnconfiguredAreas  : 1;
+		u32     useFdeOnly                  : 1;
+		u32     disableNCQ                  : 1;
+		u32     SSDSMARTerEnabled           : 1;
+		u32     SSDPatrolReadEnabled        : 1;
+		u32     enableSpinDownUnconfigured  : 1;
+		u32     autoEnhancedImport          : 1;
+		u32     enableSecretKeyControl      : 1;
+		u32     disableOnlineCtrlReset      : 1;
+		u32     allowBootWithPinnedCache    : 1;
+		u32     disableSpinDownHS           : 1;
+		u32     enableJBOD                  : 1;
+		u32     reserved                    :18;
+	} OnOffProperties;
+	u8 autoSnapVDSpace;
+	u8 viewSpace;
+	u16 spinDownTime;
+	u8  reserved[24];
 } __packed;
 
 /*
