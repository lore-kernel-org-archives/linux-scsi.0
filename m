From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 4/18] megaraid_sas : Move controller's queue depth
 calculation in adapter specific function
Date: Thu, 23 Apr 2015 16:30:54 +0530
Message-ID: <201504231103.t3NB3Ajm029643@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:39156
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964794AbbDWLBA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:01:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will move internal commands and SCSI commands reservation in adapter's sepcific functions.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---
 drivers/scsi/megaraid/megaraid_sas.h        |    1 +
 drivers/scsi/megaraid/megaraid_sas_base.c   |   39 ++++++++++----------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    9 ++++++
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index bdcf2b6..762de8a 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1084,6 +1084,7 @@ enum MR_SCSI_CMD_TYPE {
 #define MEGASAS_SKINNY_INT_CMDS			5
 #define MEGASAS_FUSION_INTERNAL_CMDS		5
 #define MEGASAS_FUSION_IOCTL_CMDS		3
+#define MEGASAS_MFI_IOCTL_CMDS			27
 
 #define MEGASAS_MAX_MSIX_QUEUES			128
 /*
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 1bd3272..dee61e8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4354,6 +4354,21 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 	instance->max_num_sge = (instance->instancet->read_fw_status_reg(reg_set) & 0xFF0000) >>
 					0x10;
 	/*
+	 * For MFI skinny adapters, MEGASAS_SKINNY_INT_CMDS commands
+	 * are reserved for IOCTL + driver's internal DCMDs.
+	 */
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+		instance->max_scsi_cmds = (instance->max_fw_cmds -
+			MEGASAS_SKINNY_INT_CMDS);
+		sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
+	} else {
+		instance->max_scsi_cmds = (instance->max_fw_cmds -
+			MEGASAS_INT_CMDS);
+		sema_init(&instance->ioctl_sem, (MEGASAS_MFI_IOCTL_CMDS));
+	}
+
+	/*
 	 * Create a pool of commands
 	 */
 	if (megasas_alloc_cmds(instance))
@@ -4788,30 +4803,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
 		instance->max_sectors_per_req = tmp_sectors;
 
-	/*
-	 * 1. For fusion adapters, 3 commands for IOCTL and 5 commands
-	 *    for driver's internal DCMDs.
-	 * 2. For MFI skinny adapters, 5 commands for IOCTL + driver's
-	 *    internal DCMDs.
-	 * 3. For rest of MFI adapters, 27 commands reserved for IOCTLs
-	 *    and 5 commands for drivers's internal DCMD.
-	 */
-	if (instance->ctrl_context) {
-		instance->max_scsi_cmds = instance->max_fw_cmds -
-					(MEGASAS_FUSION_INTERNAL_CMDS +
-					MEGASAS_FUSION_IOCTL_CMDS);
-		sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
-	} else if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
-		instance->max_scsi_cmds = instance->max_fw_cmds -
-						MEGASAS_SKINNY_INT_CMDS;
-		sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
-	} else {
-		instance->max_scsi_cmds = instance->max_fw_cmds -
-						MEGASAS_INT_CMDS;
-		sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS - 5));
-	}
-
 	/* Check for valid throttlequeuedepth module parameter */
 	if (throttlequeuedepth &&
 			throttlequeuedepth <= instance->max_scsi_cmds)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index d38f85e..3e9dd6a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1061,6 +1061,15 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 		fusion->last_reply_idx[i] = 0;
 
 	/*
+	 * For fusion adapters, 3 commands for IOCTL and 5 commands
+	 * for driver's internal DCMDs.
+	 */
+	instance->max_scsi_cmds = instance->max_fw_cmds -
+				(MEGASAS_FUSION_INTERNAL_CMDS +
+				MEGASAS_FUSION_IOCTL_CMDS);
+	sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
+
+	/*
 	 * Allocate memory for descriptors
 	 * Create a pool of commands
 	 */
-- 
1.7.1

