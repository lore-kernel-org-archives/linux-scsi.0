From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 14/39] megaraid_sas: enhance debug logs in OCR context
Date: Mon,  6 Feb 2017 01:59:47 -0800
Message-ID: <1486375212-17329-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:35248 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751675AbdBFKCD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:03 -0500
Received: by mail-pg0-f54.google.com with SMTP id 194so27431548pgd.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:03 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Add additional logging from driver in OCR context.
Add debug logs for partial completion of IOs is iodone context.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  3 +++
 drivers/scsi/megaraid/megaraid_sas_base.c   | 38 ++++++++++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 35 +++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 6e7cb0b..ac2aed3 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1405,6 +1405,9 @@ struct megasas_ctrl_info {
 
 #define VD_EXT_DEBUG 0
 
+/* Driver's internal Logging levels*/
+#define OCR_LOGS    (1 << 0)
+
 #define SCAN_PD_CHANNEL	0x1
 #define SCAN_VD_CHANNEL	0x2
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3e74f0f..d386f69 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2739,6 +2739,24 @@ blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 }
 
 /**
+ * megasas_dump_frame -	This function will dump MPT/MFI frame
+ */
+static inline void
+megasas_dump_frame(void *mpi_request, int sz)
+{
+	int i;
+	__le32 *mfp = (__le32 *)mpi_request;
+
+	printk(KERN_INFO "IO request frame:\n\t");
+	for (i = 0; i < sz; i++) {
+		if (i && ((i % 8) == 0))
+			printk("\n\t");
+		printk("%08x ", le32_to_cpu(mfp[i]));
+	}
+	printk("\n");
+}
+
+/**
  * megasas_reset_bus_host -	Bus & host reset handler entry point
  */
 static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
@@ -2748,12 +2766,26 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
+	scmd_printk(KERN_INFO, scmd,
+		"Controller reset is requested due to IO timeout\n"
+		"SCSI command pointer: (%p)\t SCSI host state: %d\t"
+		" SCSI host busy: %d\t FW outstanding: %d\n",
+		scmd, scmd->device->host->shost_state,
+		atomic_read((atomic_t *)&scmd->device->host->host_busy),
+		atomic_read(&instance->fw_outstanding));
+
 	/*
 	 * First wait for all commands to complete
 	 */
-	if (instance->ctrl_context)
-		ret = megasas_reset_fusion(scmd->device->host, 1);
-	else
+	if (instance->ctrl_context) {
+		struct megasas_cmd_fusion *cmd;
+		cmd = (struct megasas_cmd_fusion *)scmd->SCp.ptr;
+		if (cmd)
+			megasas_dump_frame(cmd->io_request,
+				sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
+		ret = megasas_reset_fusion(scmd->device->host,
+				SCSIIO_TIMEOUT_OCR);
+	} else
 		ret = megasas_generic_reset(scmd);
 
 	return ret;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 75c4ad1..8dd4944 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1442,8 +1442,10 @@ map_cmd_status(struct fusion_context *fusion,
 	struct scsi_cmnd *scmd, u8 status, u8 ext_status,
 			u32 data_length, u8 *sense)
 {
+	u8 cmd_type;
 	int resid;
 
+	cmd_type = megasas_cmd_type(scmd);
 	switch (status) {
 
 	case MFI_STAT_OK:
@@ -1474,6 +1476,13 @@ map_cmd_status(struct fusion_context *fusion,
 		 */
 		resid = (scsi_bufflen(scmd) - data_length);
 		scsi_set_resid(scmd, resid);
+
+		if (resid &&
+			((cmd_type == READ_WRITE_LDIO) ||
+			(cmd_type == READ_WRITE_SYSPDIO)))
+			scmd_printk(KERN_INFO, scmd, "BRCM Debug mfi stat 0x%x, data len"
+				" requested/completed 0x%x/0x%x\n",
+				status, scsi_bufflen(scmd), data_length);
 		break;
 
 	case MFI_STAT_LD_OFFLINE:
@@ -3473,6 +3482,14 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 			       " will reset adapter scsi%d.\n",
 				instance->host->host_no);
 			megasas_complete_cmd_dpc_fusion((unsigned long)instance);
+			if (instance->requestorId && reason) {
+				dev_warn(&instance->pdev->dev, "SR-IOV Found FW in FAULT"
+				" state while polling during"
+				" I/O timeout handling for %d\n",
+				instance->host->host_no);
+				*convert = 1;
+			}
+
 			retval = 1;
 			goto out;
 		}
@@ -3492,7 +3509,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 		}
 
 		/* If SR-IOV VF mode & I/O timeout, check for HB timeout */
-		if (instance->requestorId && reason) {
+		if (instance->requestorId && (reason == SCSIIO_TIMEOUT_OCR)) {
 			if (instance->hb_host_mem->HB.fwCounter !=
 			    instance->hb_host_mem->HB.driverCounter) {
 				instance->hb_host_mem->HB.driverCounter =
@@ -3908,6 +3925,9 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 	fusion = instance->ctrl_context;
 
+	scmd_printk(KERN_INFO, scmd, "task abort called for scmd(%p)\n", scmd);
+	scsi_print_command(scmd);
+
 	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
 		dev_err(&instance->pdev->dev, "Controller is not OPERATIONAL,"
 		"SCSI host:%d\n", instance->host->host_no);
@@ -3988,6 +4008,9 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 	fusion = instance->ctrl_context;
 
+	sdev_printk(KERN_INFO, scmd->device,
+		    "target reset called for scmd(%p)\n", scmd);
+
 	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
 		dev_err(&instance->pdev->dev, "Controller is not OPERATIONAL,"
 		"SCSI host:%d\n", instance->host->host_no);
@@ -4147,6 +4170,9 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 		if (convert)
 			reason = 0;
 
+		if (megasas_dbg_lvl & OCR_LOGS)
+			dev_info(&instance->pdev->dev, "\nPending SCSI commands:\n");
+
 		/* Now return commands back to the OS */
 		for (i = 0 ; i < instance->max_scsi_cmds; i++) {
 			cmd_fusion = fusion->cmd_list[i];
@@ -4157,6 +4183,13 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			}
 			scmd_local = cmd_fusion->scmd;
 			if (cmd_fusion->scmd) {
+				if (megasas_dbg_lvl & OCR_LOGS) {
+					sdev_printk(KERN_INFO,
+						cmd_fusion->scmd->device, "SMID: 0x%x\n",
+						cmd_fusion->index);
+					scsi_print_command(cmd_fusion->scmd);
+				}
+
 				scmd_local->result =
 					megasas_check_mpio_paths(instance,
 							scmd_local);
-- 
2.8.3
