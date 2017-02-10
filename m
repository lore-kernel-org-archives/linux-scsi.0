From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 32/39] megaraid_sas: Change build_mpt_mfi_pass_thru to return void
Date: Fri, 10 Feb 2017 00:59:32 -0800
Message-ID: <1486717179-23320-33-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:36592 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbdBJMXS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 07:23:18 -0500
Received: by mail-pg0-f49.google.com with SMTP id v184so10311932pgv.3
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 04:22:46 -0800 (PST)
In-Reply-To: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Code refactoring to build_mpt_mfi_pass_thru to return void.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index c0a58dc..bafaf03 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3229,7 +3229,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
  * mfi_cmd:			megasas_cmd pointer
  *
  */
-u8
+void
 build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 			struct megasas_cmd *mfi_cmd)
 {
@@ -3279,8 +3279,6 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 		MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR;
 
 	mpi25_ieee_chain->Length = cpu_to_le32(instance->max_chain_frame_sz);
-
-	return 0;
 }
 
 /**
@@ -3295,11 +3293,7 @@ build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc = NULL;
 	u16 index;
 
-	if (build_mpt_mfi_pass_thru(instance, cmd)) {
-		dev_err(&instance->pdev->dev, "Couldn't build MFI pass thru cmd\n");
-		return NULL;
-	}
-
+	build_mpt_mfi_pass_thru(instance, cmd);
 	index = cmd->context.smid;
 
 	req_desc = megasas_get_request_descriptor(instance, index - 1);
-- 
2.8.3
