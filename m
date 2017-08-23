From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 05/14] megaraid_sas: Do not re-fire shutdown DCMD after OCR
Date: Wed, 23 Aug 2017 04:46:59 -0700
Message-ID: <1503488828-2242-6-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:37504 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753887AbdHWLro (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 07:47:44 -0400
Received: by mail-pg0-f53.google.com with SMTP id y129so6243453pgy.4
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 04:47:44 -0700 (PDT)
In-Reply-To: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index d33e833..6efa72a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3624,6 +3624,15 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 
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
