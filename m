From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] scsi: megaraid: Remove redundant memset before memcpy
Date: Fri, 13 Jan 2017 15:58:51 +0530
Message-ID: <1484303331-28303-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34787 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdAMK3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2017 05:29:12 -0500
Received: by mail-pf0-f196.google.com with SMTP id y143so7900830pfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 02:29:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@broadcom.com
Cc: sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>

The region set by the call to memset, immediately overwritten by the
subsequent call to memcpy and thus makes the  memset redundant

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 24778ba..32102f6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1406,8 +1406,6 @@ map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
 
 		cmd->scmd->result = (DID_OK << 16) | ext_status;
 		if (ext_status == SAM_STAT_CHECK_CONDITION) {
-			memset(cmd->scmd->sense_buffer, 0,
-			       SCSI_SENSE_BUFFERSIZE);
 			memcpy(cmd->scmd->sense_buffer, cmd->sense,
 			       SCSI_SENSE_BUFFERSIZE);
 			cmd->scmd->result |= DRIVER_SENSE << 24;
-- 
2.7.4

