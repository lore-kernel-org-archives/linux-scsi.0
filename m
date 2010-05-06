From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 6/7] scsi: megaraid_sas - Add three times Online controller
 reset
Date: Thu, 6 May 2010 10:34:05 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3CDB80C32@cosmail02.lsi.com>
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

If fw didn't raise the interrupt with the fw state change to driver and fw goes to failure state, driver
Will check the FW state in driver's timeout routine and issue the reset if need.  Driver will do the OCR upto three
Times until kill adapter.  Also driver will issue OCR before driver kill adapter even if fw in operational state.   

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
megaraid_sas.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-05-04 14:32:49.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-05-04 15:07:26.000000000 -0400
@@ -1569,6 +1569,28 @@ static void megasas_complete_cmd_dpc(uns
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
@@ -1586,6 +1608,8 @@ static int megasas_wait_for_outstanding(
 	unsigned long flags;
 	struct list_head clist_local;
 	struct megasas_cmd *reset_cmd;
+	u32 fw_state;
+	u8 kill_adapter_flag;
 
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	adprecovery = instance->adprecovery;
@@ -1671,7 +1695,45 @@ static int megasas_wait_for_outstanding(
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
