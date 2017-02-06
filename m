From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 22/39] megaraid_sas: latest controller OCR capability from FW before sending shutdown DCMD
Date: Mon,  6 Feb 2017 01:59:55 -0800
Message-ID: <1486375212-17329-23-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35007 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbdBFKCb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:31 -0500
Received: by mail-pf0-f175.google.com with SMTP id f144so23078987pfa.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:31 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fetch the latest controller OCR capability from FW before
sending MR_DCMD_CTRL_SHUTDOWN
When application sends a shutdown DCMD (MR_DCMD_CTRL_SHUTDOWN),
driver will fetch latest controller information from firmware.
This is to ensure that driver always has latest OCR capability
of controller before sending the DCMD.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 907b2bf..ac88ad6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6895,6 +6895,13 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 					       MFI_FRAME_SGL64 |
 					       MFI_FRAME_SENSE64));
 
+	if (cmd->frame->dcmd.opcode == MR_DCMD_CTRL_SHUTDOWN) {
+		if (megasas_get_ctrl_info(instance) != DCMD_SUCCESS) {
+			megasas_return_cmd(instance, cmd);
+			return -1;
+		}
+	}
+
 	if (cmd->frame->dcmd.opcode == MR_DRIVER_SET_APP_CRASHDUMP_MODE) {
 		error = megasas_set_crash_dump_params_ioctl(cmd);
 		megasas_return_cmd(instance, cmd);
-- 
2.8.3
