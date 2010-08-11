From: bo yang <boyang1288@gmail.com>
Subject: [PATCH 4/5] scsi: megaraid_sas - Add three times Online controller
	reset in driver's reset routine
Date: Wed, 11 Aug 2010 17:08:37 -0400
Message-ID: <AANLkTin_jX=KcOLbsCxC3Hwqcvi-heWg+Rdk8JGZgquL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:44642 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab0HKVIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2010 17:08:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bo.yang@lsi.com, James.Bottomley@HansenPartnership.com, James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

If fw didn't raise the interrupt with the fw state change to driver
and fw goes to failure state, driver
Will check the FW state in driver's timeout routine and issue the
reset if need.  Driver will do the OCR upto three
Times until kill adapter.  Also driver will issue OCR before driver
kill adapter even if fw in operational state.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |   70 ++++++++++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c
new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-08-10 04:37:53.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-08-10 04:49:38.000000000 -0400
@@ -730,6 +730,10 @@ static int
 megasas_check_reset_gen2(struct megasas_instance *instance,
 		struct megasas_register_set __iomem *regs)
 {
+	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
+		return 1;
+	}
+
 	return 0;
 }

@@ -942,6 +946,7 @@ megasas_make_sgl_skinny(struct megasas_i
 			mfi_sgl->sge_skinny[i].length = sg_dma_len(os_sgl);
 			mfi_sgl->sge_skinny[i].phys_addr =
 						sg_dma_address(os_sgl);
+			mfi_sgl->sge_skinny[i].flag = 0;
 		}
 	}
 	return sge_count;
@@ -1569,6 +1574,28 @@ static void megasas_complete_cmd_dpc(uns
 	}
 }

+static void
+megasas_internal_reset_defer_cmds(struct megasas_instance *instance);
+
+static void
+process_fw_state_change_wq(struct work_struct *work);
+
+void megasas_do_ocr(struct megasas_instance *instance)
+{
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1064R) ||
+	(instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||
+	(instance->pdev->device == PCI_DEVICE_ID_LSI_VERDE_ZCR)) {
+		*instance->consumer     = MEGASAS_ADPRESET_INPROG_SIGN;
+	}
+	instance->instancet->disable_intr(instance->reg_set);
+	instance->adprecovery   = MEGASAS_ADPRESET_SM_INFAULT;
+	instance->issuepend_done = 0;
+
+	atomic_set(&instance->fw_outstanding, 0);
+	megasas_internal_reset_defer_cmds(instance);
+	process_fw_state_change_wq(&instance->work_init);
+}
+
 /**
  * megasas_wait_for_outstanding -	Wait for all outstanding cmds
  * @instance:				Adapter soft state
@@ -1586,6 +1613,8 @@ static int megasas_wait_for_outstanding(
 	unsigned long flags;
 	struct list_head clist_local;
 	struct megasas_cmd *reset_cmd;
+	u32 fw_state;
+	u8 kill_adapter_flag;

 	spin_lock_irqsave(&instance->hba_lock, flags);
 	adprecovery = instance->adprecovery;
@@ -1671,7 +1700,45 @@ static int megasas_wait_for_outstanding(
 		msleep(1000);
 	}

-	if (atomic_read(&instance->fw_outstanding)) {
+	i = 0;
+	kill_adapter_flag = 0;
+	do {
+		fw_state = instance->instancet->read_fw_status_reg(
+					instance->reg_set) & MFI_STATE_MASK;
+		if ((fw_state == MFI_STATE_FAULT) &&
+			(instance->disableOnlineCtrlReset == 0)) {
+			if (i == 3) {
+				kill_adapter_flag = 2;
+				break;
+			}
+			megasas_do_ocr(instance);
+			kill_adapter_flag = 1;
+
+			/* wait for 1 secs to let FW finish the pending cmds */
+			msleep(1000);
+		}
+		i++;
+	} while (i <= 3);
+
+	if (atomic_read(&instance->fw_outstanding) &&
+					!kill_adapter_flag) {
+		if (instance->disableOnlineCtrlReset == 0) {
+
+			megasas_do_ocr(instance);
+
+			/* wait for 5 secs to let FW finish the pending cmds */
+			for (i = 0; i < wait_time; i++) {
+				int outstanding =
+					atomic_read(&instance->fw_outstanding);
+				if (!outstanding)
+					return SUCCESS;
+				msleep(1000);
+			}
+		}
+	}
+
+	if (atomic_read(&instance->fw_outstanding) ||
+					(kill_adapter_flag == 2)) {
 		printk(KERN_NOTICE "megaraid_sas: pending cmds after reset\n");
 		/*
 		* Send signal to FW to stop processing any pending cmds.
@@ -2681,6 +2748,7 @@ static int megasas_create_frame_pool(str
 			return -ENOMEM;
 		}

+		memset(cmd->frame, 0, total_sz);
 		cmd->frame->io.context = cmd->index;
 		cmd->frame->io.pad_0 = 0;
 	}
