From: sumit.saxena@avagotech.com
Subject: [PATCH v3 04/10] megaraid_sas : Code cleanup-use local variable
 drv_ops inside megasas_ioc_init_fusion
Date: Mon, 31 Aug 2015 17:23:21 +0530
Message-ID: <201508311158.t7VBwoH7031399@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastion.smtp.avagotech.com ([199.3.246.86]:52694 "EHLO
	sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbbHaLyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 07:54:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Martin Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 016b245..2038aae 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -605,6 +605,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	int i;
 	struct megasas_header *frame_hdr;
 	const char *sys_info;
+	MFI_CAPABILITIES *drv_ops;
 
 	fusion = instance->ctrl_context;
 
@@ -652,20 +653,19 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	init_frame->cmd	= MFI_CMD_INIT;
 	init_frame->cmd_status = 0xFF;
 
+	drv_ops = (MFI_CAPABILITIES *) &(init_frame->driver_operations);
+
 	/* driver support Extended MSIX */
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
 		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
-		init_frame->driver_operations.
-			mfi_capabilities.support_additional_msix = 1;
+		drv_ops->mfi_capabilities.support_additional_msix = 1;
 	/* driver supports HA / Remote LUN over Fast Path interface */
-	init_frame->driver_operations.mfi_capabilities.support_fp_remote_lun
-		= 1;
-	init_frame->driver_operations.mfi_capabilities.support_max_255lds
-		= 1;
-	init_frame->driver_operations.mfi_capabilities.support_ndrive_r1_lb
-		= 1;
-	init_frame->driver_operations.mfi_capabilities.security_protocol_cmds_fw
-		= 1;
+	drv_ops->mfi_capabilities.support_fp_remote_lun = 1;
+
+	drv_ops->mfi_capabilities.support_max_255lds = 1;
+	drv_ops->mfi_capabilities.support_ndrive_r1_lb = 1;
+	drv_ops->mfi_capabilities.security_protocol_cmds_fw = 1;
+
 	/* Convert capability to LE32 */
 	cpu_to_le32s((u32 *)&init_frame->driver_operations.mfi_capabilities);
 
-- 
1.7.1

