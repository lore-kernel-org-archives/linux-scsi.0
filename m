From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 14/39] megaraid_sas: set residual bytes count during IO completion
Date: Wed,  8 Feb 2017 01:29:08 -0800
Message-ID: <1486546173-20713-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33923 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754111AbdBHJao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:30:44 -0500
Received: by mail-pf0-f177.google.com with SMTP id e4so40972400pfg.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:30:36 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Fixing issue of not setting residual bytes correctly.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index edbecc5..4628671 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1445,6 +1445,7 @@ map_cmd_status(struct fusion_context *fusion,
 	struct scsi_cmnd *scmd, u8 status, u8 ext_status,
 			u32 data_length, u8 *sense)
 {
+	int resid;
 
 	switch (status) {
 
@@ -1467,6 +1468,15 @@ map_cmd_status(struct fusion_context *fusion,
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
