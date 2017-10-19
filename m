From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 04/19] megaraid_sas: Remove redundant checks for ctrl_context
Date: Thu, 19 Oct 2017 02:48:51 -0700
Message-ID: <1508406546-25944-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:56134 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752445AbdJSJuJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:09 -0400
Received: by mail-pf0-f195.google.com with SMTP id 17so6188785pfn.12
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:09 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index cd997ccf5ebf..340079d0bff0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -991,7 +991,7 @@ megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
 
 	/* Below code is only for non pended DCMD */
-	if (instance->ctrl_context && !instance->mask_interrupts)
+	if (!instance->mask_interrupts)
 		ret = megasas_issue_blocked_cmd(instance, cmd,
 			MFI_IO_TIMEOUT_SECS);
 	else
@@ -1004,7 +1004,7 @@ megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
 		ret = -EINVAL;
 	}
 
-	if (ret == DCMD_TIMEOUT && instance->ctrl_context)
+	if (ret == DCMD_TIMEOUT)
 		megaraid_sas_kill_hba(instance);
 
 	if (ret == DCMD_SUCCESS)
@@ -1080,13 +1080,13 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(ci_h);
 	dcmd->sgl.sge32[0].length = cpu_to_le32(size_map_info);
 
-	if (instance->ctrl_context && !instance->mask_interrupts)
+	if (!instance->mask_interrupts)
 		ret = megasas_issue_blocked_cmd(instance, cmd,
 			MFI_IO_TIMEOUT_SECS);
 	else
 		ret = megasas_issue_polled(instance, cmd);
 
-	if (ret == DCMD_TIMEOUT && instance->ctrl_context)
+	if (ret == DCMD_TIMEOUT)
 		megaraid_sas_kill_hba(instance);
 
 	megasas_return_cmd(instance, cmd);
-- 
2.14.1.dirty
