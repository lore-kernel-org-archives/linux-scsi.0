From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 26/39] megaraid_sas: max_fw_cmds are decremented twice, remove duplicate
Date: Mon,  6 Feb 2017 01:59:59 -0800
Message-ID: <1486375212-17329-27-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33892 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdBFKCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:38 -0500
Received: by mail-pf0-f180.google.com with SMTP id e4so23035626pfg.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:37 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fix to account for the reply_q_sz not exceeding
the maximum commands that the firmware can support,
instance->max_fw_cmds is already decremented in
megasas_fusion_update_can_queue().
Remove the extra decrement logic in code.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2bfdf6b..e74cbe6d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1282,13 +1282,6 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 	megasas_fusion_update_can_queue(instance, PROBE_CONTEXT);
 
 	/*
-	 * Reduce the max supported cmds by 1. This is to ensure that the
-	 * reply_q_sz (1 more than the max cmd that driver may send)
-	 * does not exceed max cmds that the FW can support
-	 */
-	instance->max_fw_cmds = instance->max_fw_cmds-1;
-
-	/*
 	 * Only Driver's internal DCMDs and IOCTL DCMDs needs to have MFI frames
 	 */
 	instance->max_mfi_cmds =
-- 
2.8.3
