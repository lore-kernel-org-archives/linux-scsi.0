From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v2 1/3] arcmsr: fixed getting wrong configuration data
Date: Wed, 25 Nov 2015 11:21:21 +0800
Message-ID: <1448421681.4698.18.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32979 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbbKYDV3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2015 22:21:29 -0500
Received: by pabfh17 with SMTP id fh17so43763653pab.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2015 19:21:29 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
Cc: hch@lst.de

From: Ching Huang <ching2048@areca.com.tw>

Fixed getting wrong configuration data of adapter type B and type D.

Signed-of-by: Ching Huang <ching2048@areca.com.tw>

---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-23 16:25:22.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-24 11:35:26.000000000 +0800
@@ -2694,15 +2694,15 @@ static bool arcmsr_hbaB_get_config(struc
 		acb->firm_model,
 		acb->firm_version);
 
-	acb->signature = readl(&reg->message_rwbuffer[1]);
+	acb->signature = readl(&reg->message_rwbuffer[0]);
 	/*firm_signature,1,00-03*/
-	acb->firm_request_len = readl(&reg->message_rwbuffer[2]);
+	acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
 	/*firm_request_len,1,04-07*/
-	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[3]);
+	acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
 	/*firm_numbers_queue,2,08-11*/
-	acb->firm_sdram_size = readl(&reg->message_rwbuffer[4]);
+	acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
 	/*firm_sdram_size,3,12-15*/
-	acb->firm_hd_channels = readl(&reg->message_rwbuffer[5]);
+	acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
 	/*firm_ide_channels,4,16-19*/
 	acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);  /*firm_cfg_version,25,100-103*/
 	/*firm_ide_channels,4,16-19*/
@@ -2880,15 +2880,15 @@ static bool arcmsr_hbaD_get_config(struc
 		iop_device_map++;
 		count--;
 	}
-	acb->signature = readl(&reg->msgcode_rwbuffer[1]);
+	acb->signature = readl(&reg->msgcode_rwbuffer[0]);
 	/*firm_signature,1,00-03*/
-	acb->firm_request_len = readl(&reg->msgcode_rwbuffer[2]);
+	acb->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);
 	/*firm_request_len,1,04-07*/
-	acb->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[3]);
+	acb->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]);
 	/*firm_numbers_queue,2,08-11*/
-	acb->firm_sdram_size = readl(&reg->msgcode_rwbuffer[4]);
+	acb->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);
 	/*firm_sdram_size,3,12-15*/
-	acb->firm_hd_channels = readl(&reg->msgcode_rwbuffer[5]);
+	acb->firm_hd_channels = readl(&reg->msgcode_rwbuffer[4]);
 	/*firm_hd_channels,4,16-19*/
 	acb->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);
 	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",


