From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 1/1] arcmsr: Notify has sense data report
Date: Fri, 28 Nov 2014 12:20:44 +0800
Message-ID: <1417148444.16588.56.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65136 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaK1EUu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Nov 2014 23:20:50 -0500
Received: by mail-pa0-f47.google.com with SMTP id kq14so6039259pab.34
        for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2014 20:20:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

This patch is relative to http://git.infradead.org/users/hch/scsi-queue.git/tree/refs/heads/drivers-for-3.18:/drivers/scsi/arcmsr

Setting command status with 'DRIVER_SENSE' except 'CHECK_CONDITION' if we have sense data.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2014-09-19 11:04:41.845100000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2014-11-28 10:54:30.000000000 +0800
@@ -52,7 +52,7 @@ struct device_attribute;
 	#define ARCMSR_MAX_FREECCB_NUM	320
 #define ARCMSR_MAX_OUTSTANDING_CMD	255
 #endif
-#define ARCMSR_DRIVER_VERSION		"v1.30.00.04-20140919"
+#define ARCMSR_DRIVER_VERSION		"v1.30.00.05-20141128"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
 #define ARCMSR_MAX_XFER_SECTORS_B						4096
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-09-19 11:01:26.990090000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-11-28 10:55:54.000000000 +0800
@@ -989,7 +989,8 @@ static void arcmsr_report_sense_info(str
 
 	struct scsi_cmnd *pcmd = ccb->pcmd;
 	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
-	pcmd->result = DID_OK << 16;
+
+	pcmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
 	if (sensebuffer) {
 		int sense_data_length =
 			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
@@ -998,6 +999,7 @@ static void arcmsr_report_sense_info(str
 		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
 		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
 		sensebuffer->Valid = 1;
+		pcmd->result |= (DRIVER_SENSE << 24);
 	}
 }
 


