From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 05/15] megaraid_sas: Do not re-fire shutdown DCMD after OCR
Date: Wed,  5 Jul 2017 05:00:19 -0700
Message-ID: <1499256029-16319-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34685 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752093AbdGEMB0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 08:01:26 -0400
Received: by mail-pf0-f169.google.com with SMTP id q85so15261414pfq.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 05:01:26 -0700 (PDT)
In-Reply-To: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 0f13c58..a308e14 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3618,6 +3618,15 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 
 		if (!smid)
 			continue;
+
+		/* Do not refire shutdown command */
+		if (le32_to_cpu(cmd_mfi->frame->dcmd.opcode) ==
+			MR_DCMD_CTRL_SHUTDOWN) {
+			cmd_mfi->frame->dcmd.cmd_status = MFI_STAT_OK;
+			megasas_complete_cmd(instance, cmd_mfi, DID_OK);
+			continue;
+		}
+
 		req_desc = megasas_get_request_descriptor
 					(instance, smid - 1);
 		refire_cmd = req_desc && ((cmd_mfi->frame->dcmd.opcode !=
-- 
1.8.3.1
