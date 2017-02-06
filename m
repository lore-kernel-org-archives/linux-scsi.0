From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 25/39] megaraid_sas: update can_queue only if the new value is less
Date: Mon,  6 Feb 2017 01:59:58 -0800
Message-ID: <1486375212-17329-26-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35027 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbdBFKCf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:35 -0500
Received: by mail-pf0-f169.google.com with SMTP id f144so23080103pfa.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:35 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Minor Optimization: No need to update HBA can_queue value
if the current max FW commands is equal to earlier value.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 22965b6..2bfdf6b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -259,7 +259,7 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
 
 	if (fw_boot_context == OCR_CONTEXT) {
 		cur_max_fw_cmds = cur_max_fw_cmds - 1;
-		if (cur_max_fw_cmds <= instance->max_fw_cmds) {
+		if (cur_max_fw_cmds < instance->max_fw_cmds) {
 			instance->cur_can_queue =
 				cur_max_fw_cmds - (MEGASAS_FUSION_INTERNAL_CMDS +
 						MEGASAS_FUSION_IOCTL_CMDS);
-- 
2.8.3
