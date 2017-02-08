From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 27/39] megaraid_sas: max_fw_cmds are decremented twice, remove duplicate
Date: Wed,  8 Feb 2017 01:29:21 -0800
Message-ID: <1486546173-20713-28-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36258 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933188AbdBHJbS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:31:18 -0500
Received: by mail-pf0-f172.google.com with SMTP id 189so41037576pfu.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:31:18 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 02a23d9..9e2a289 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1285,13 +1285,6 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
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
