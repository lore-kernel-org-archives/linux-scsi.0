From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 1.1 1/1]  arcmsr: Notify has sense data report
Date: Fri, 28 Nov 2014 18:07:32 +0800
Message-ID: <1417169252.25477.11.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35377 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaK1KHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 05:07:38 -0500
Received: by mail-pd0-f178.google.com with SMTP id g10so6438575pdj.37
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2014 02:07:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: hare@suse.de

From: Ching Huang <ching2048@areca.com.tw>

Setting command status with 'DRIVER_SENSE' except 'CHECK_CONDITION' if we have sense data.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

This patch is relative to http://git.infradead.org/users/hch/scsi-queue.git/tree/refs/heads/drivers-for-3.18:/drivers/scsi/arcmsr


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
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-11-28 17:51:04.000000000 +0800
@@ -989,16 +989,15 @@ static void arcmsr_report_sense_info(str
 
 	struct scsi_cmnd *pcmd = ccb->pcmd;
 	struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
-	pcmd->result = DID_OK << 16;
-	if (sensebuffer) {
-		int sense_data_length =
+
+	pcmd->result = (DRIVER_SENSE << 24) | (DID_OK << 16) | (CHECK_CONDITION << 1);
+	int sense_data_length =
 			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
 			? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;
-		memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
-		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
-		sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
-		sensebuffer->Valid = 1;
-	}
+	memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
+	memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
+	sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
+	sensebuffer->Valid = 1;
 }
 
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)


