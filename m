From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 6/8] megaraid_sas : Reserve commands for IOCTLs and
 internal DCMDs
Date: Mon, 5 Jan 2015 20:06:23 +0530
Message-ID: <201501051440.t05EeP9Q030054@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0063.outbound.protection.outlook.com ([65.55.169.63]:63804
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753388AbbAEOuh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 09:50:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

1)For fusion adapters, limited reserved frames for non SCSI commands to 8(3 for parallel IOCTLs + 5 for driver's internal DCMDs).
Earlier reserved commands for non SCSI IO frames was set to 32, so with this implementation, increased per controller
"can_queue". Behavior of MFI controllers will remain unchanged.

2)Optimized the code related to per controller's 'can_queue' setting.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Chaitra Basappa <chaitra.basappa@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |    7 ++-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   71 ++++++++++++++-------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    8 ++-
 3 files changed, 46 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 842e6f7..e2adbf3 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1082,6 +1082,8 @@ enum MR_SCSI_CMD_TYPE {
  */
 #define MEGASAS_INT_CMDS			32
 #define MEGASAS_SKINNY_INT_CMDS			5
+#define MEGASAS_FUSION_INTERNAL_CMDS		5
+#define MEGASAS_FUSION_IOCTL_CMDS		3
 
 #define MEGASAS_MAX_MSIX_QUEUES			128
 /*
@@ -1687,9 +1689,8 @@ struct megasas_instance {
 
 	u16 max_num_sge;
 	u16 max_fw_cmds;
-	/* For Fusion its num IOCTL cmds, for others MFI based its
-	   max_fw_cmds */
 	u16 max_mfi_cmds;
+	u16 max_scsi_cmds;
 	u32 max_sectors_per_req;
 	struct megasas_aen_event *ev;
 
@@ -1765,7 +1766,7 @@ struct megasas_instance {
 	u8 requestorId;
 	char PlasmaFW111;
 	char mpio;
-	int throttlequeuedepth;
+	u16 throttlequeuedepth;
 	u8 mask_interrupts;
 	u8 is_imr;
 };
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index fbc1d4c..ac3c04a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -78,7 +78,7 @@ static int allow_vf_ioctls;
 module_param(allow_vf_ioctls, int, S_IRUGO);
 MODULE_PARM_DESC(allow_vf_ioctls, "Allow ioctls in SR-IOV VF mode. Default: 0");
 
-static int throttlequeuedepth = MEGASAS_THROTTLE_QUEUE_DEPTH;
+static unsigned int throttlequeuedepth = MEGASAS_THROTTLE_QUEUE_DEPTH;
 module_param(throttlequeuedepth, int, S_IRUGO);
 MODULE_PARM_DESC(throttlequeuedepth,
 	"Adapter queue depth when throttled due to I/O timeout. Default: 16");
@@ -1764,6 +1764,7 @@ void
 megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
 {
 	unsigned long flags;
+
 	if (instance->flag & MEGASAS_FW_BUSY
 	    && time_after(jiffies, instance->last_time + 5 * HZ)
 	    && atomic_read(&instance->fw_outstanding) <
@@ -1771,13 +1772,8 @@ megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
 
 		spin_lock_irqsave(instance->host->host_lock, flags);
 		instance->flag &= ~MEGASAS_FW_BUSY;
-		if (instance->is_imr) {
-			instance->host->can_queue =
-				instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
-		} else
-			instance->host->can_queue =
-				instance->max_fw_cmds - MEGASAS_INT_CMDS;
 
+		instance->host->can_queue = instance->max_scsi_cmds;
 		spin_unlock_irqrestore(instance->host->host_lock, flags);
 	}
 }
@@ -4685,23 +4681,38 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
 		instance->max_sectors_per_req = tmp_sectors;
 
-	/* Check for valid throttlequeuedepth module parameter */
-	if (instance->is_imr) {
-		if (throttlequeuedepth > (instance->max_fw_cmds -
-					  MEGASAS_SKINNY_INT_CMDS))
-			instance->throttlequeuedepth =
-				MEGASAS_THROTTLE_QUEUE_DEPTH;
-		else
-			instance->throttlequeuedepth = throttlequeuedepth;
+	/*
+	 * 1. For fusion adapters, 3 commands for IOCTL and 5 commands
+	 *    for driver's internal DCMDs.
+	 * 2. For MFI skinny adapters, 5 commands for IOCTL + driver's
+	 *    internal DCMDs.
+	 * 3. For rest of MFI adapters, 27 commands reserved for IOCTLs
+	 *    and 5 commands for drivers's internal DCMD.
+	 */
+	if (instance->ctrl_context) {
+		instance->max_scsi_cmds = instance->max_fw_cmds -
+					(MEGASAS_FUSION_INTERNAL_CMDS +
+					MEGASAS_FUSION_IOCTL_CMDS);
+		sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
+	} else if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+		instance->max_scsi_cmds = instance->max_fw_cmds -
+						MEGASAS_SKINNY_INT_CMDS;
+		sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
 	} else {
-		if (throttlequeuedepth > (instance->max_fw_cmds -
-					  MEGASAS_INT_CMDS))
-			instance->throttlequeuedepth =
-				MEGASAS_THROTTLE_QUEUE_DEPTH;
-		else
-			instance->throttlequeuedepth = throttlequeuedepth;
+		instance->max_scsi_cmds = instance->max_fw_cmds -
+						MEGASAS_INT_CMDS;
+		sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS - 5));
 	}
 
+	/* Check for valid throttlequeuedepth module parameter */
+	if (throttlequeuedepth &&
+			throttlequeuedepth <= instance->max_scsi_cmds)
+		instance->throttlequeuedepth = throttlequeuedepth;
+	else
+		instance->throttlequeuedepth =
+				MEGASAS_THROTTLE_QUEUE_DEPTH;
+
         /*
 	* Setup tasklet for cmd completion
 	*/
@@ -4996,12 +5007,7 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	 */
 	host->irq = instance->pdev->irq;
 	host->unique_id = instance->unique_id;
-	if (instance->is_imr) {
-		host->can_queue =
-			instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
-	} else
-		host->can_queue =
-			instance->max_fw_cmds - MEGASAS_INT_CMDS;
+	host->can_queue = instance->max_scsi_cmds;
 	host->this_id = instance->init_id;
 	host->sg_tablesize = instance->max_num_sge;
 
@@ -5264,13 +5270,11 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
 	instance->ctrl_info = NULL;
 
+
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY))
 		instance->flag_ieee = 1;
-		sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
-	} else
-		sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS - 5));
-
+
 	megasas_dbg_lvl = 0;
 	instance->flag = 0;
 	instance->unload = 1;
@@ -6264,9 +6268,6 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 		goto out_kfree_ioc;
 	}
 
-	/*
-	 * We will allow only MEGASAS_INT_CMDS number of parallel ioctl cmds
-	 */
 	if (down_interruptible(&instance->ioctl_sem)) {
 		error = -ERESTARTSYS;
 		goto out_kfree_ioc;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 8232930..5eefd0c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1019,8 +1019,12 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 	 * does not exceed max cmds that the FW can support
 	 */
 	instance->max_fw_cmds = instance->max_fw_cmds-1;
-	/* Only internal cmds (DCMD) need to have MFI frames */
-	instance->max_mfi_cmds = MEGASAS_INT_CMDS;
+
+	/*
+	 * Only Driver's internal DCMDs and IOCTL DCMDs needs to have MFI frames
+	 */
+	instance->max_mfi_cmds =
+		MEGASAS_FUSION_INTERNAL_CMDS + MEGASAS_FUSION_IOCTL_CMDS;
 
 	max_cmd = instance->max_fw_cmds;
 
-- 
1.7.3

