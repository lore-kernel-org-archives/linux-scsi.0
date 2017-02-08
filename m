From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 26/39] megaraid_sas: update can_queue only if the new value is less
Date: Wed,  8 Feb 2017 01:29:20 -0800
Message-ID: <1486546173-20713-27-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33641 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933188AbdBHJbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:31:10 -0500
Received: by mail-pf0-f182.google.com with SMTP id y143so41089217pfb.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:31:10 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Minor Optimization: No need to update HBA can_queue value
if the current max FW commands is equal to earlier value.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index b8591de..02a23d9 100644
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
