From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 4/18] megaraid_sas : Move controller's queue depth
 calculation in adapter specific function
Date: Mon, 20 Apr 2015 18:03:00 +0530
Message-ID: <201504201235.t3KCZCCD016481@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:51622
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755075AbbDTMsW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 08:48:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will move controller's queue depth calculation in adapter specific functions.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

---
 drivers/scsi/megaraid/megaraid_sas_base.c   |   39 ++++++++++----------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    9 ++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e6cb2bd..7f426e0 100644
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
+		sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS - 5));
+	}
+
+	/*
 	 * Create a pool of commands
 	 */
 	if (megasas_alloc_cmds(instance))
@@ -4751,30 +4766,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
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
index c5619f8..3cd1d5f 100644
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

