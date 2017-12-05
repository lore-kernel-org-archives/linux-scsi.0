From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 18/17] scsi: arcmsr: Fix report command result error when
 CHECK_CONDITION
Date: Tue, 05 Dec 2017 11:28:37 +0800
Message-ID: <1512444517.4239.5.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35422 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdLEL2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2017 06:28:46 -0500
Received: by mail-pg0-f51.google.com with SMTP id q20so10488253pgv.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Dec 2017 03:28:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

From: Ching Huang <ching2048@areca.com.tw>

Fix report command result error when CHECK_CONDITION.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 17:04:52.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 19:17:28.000000000 +0800
@@ -1205,7 +1205,7 @@ static void arcmsr_report_sense_info(str
 
 	struct scsi_cmnd *pcmd = ccb->pcmd;
 	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
-	pcmd->result = DID_OK << 16;
+	pcmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
 	if (sensebuffer) {
 		int sense_data_length =
 			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
@@ -1214,6 +1214,7 @@ static void arcmsr_report_sense_info(str
 		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
 		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
 		sensebuffer->Valid = 1;
+		pcmd->result |= (DRIVER_SENSE << 24);
 	}
 }
 
