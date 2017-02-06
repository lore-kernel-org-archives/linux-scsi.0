From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 13/39] megaraid_sas : set residual bytes count during IO compeltion
Date: Mon,  6 Feb 2017 01:59:46 -0800
Message-ID: <1486375212-17329-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:36114 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbdBFKCA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:02:00 -0500
Received: by mail-pg0-f52.google.com with SMTP id v184so27411905pgv.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:02:00 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fixing issue of not setting residual bytes correctly.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 83b8482..75c4ad1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1442,6 +1442,7 @@ map_cmd_status(struct fusion_context *fusion,
 	struct scsi_cmnd *scmd, u8 status, u8 ext_status,
 			u32 data_length, u8 *sense)
 {
+	int resid;
 
 	switch (status) {
 
@@ -1464,6 +1465,15 @@ map_cmd_status(struct fusion_context *fusion,
 			       SCSI_SENSE_BUFFERSIZE);
 			scmd->result |= DRIVER_SENSE << 24;
 		}
+
+		/*
+		 * If the  IO request is partially completed, then MR FW will
+		 * update "io_request->DataLength" field with actual number of
+		 * bytes transferred.Driver will set residual bytes count in
+		 * SCSI command structure.
+		 */
+		resid = (scsi_bufflen(scmd) - data_length);
+		scsi_set_resid(scmd, resid);
 		break;
 
 	case MFI_STAT_LD_OFFLINE:
-- 
2.8.3
