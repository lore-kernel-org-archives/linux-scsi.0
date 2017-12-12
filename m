From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 2/4] scsi: arcmsr: waiting for iop firmware ready before
 issue get_config command to iop
Date: Tue, 12 Dec 2017 18:48:24 +0800
Message-ID: <1513075704.5249.21.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:43376 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdLLKs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2017 05:48:28 -0500
Received: by mail-pf0-f196.google.com with SMTP id e3so13888403pfi.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Dec 2017 02:48:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com

From: Ching Huang <ching2048@areca.com.tw>

waiting for iop firmware ready before issue get_config command to iop for adapter type A and D

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 9b587ca..dfaea8f 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2966,6 +2966,7 @@ static bool arcmsr_hbaA_get_config(struct AdapterControlBlock *acb)
 	char __iomem *iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);
 	char __iomem *iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);
 	int count;
+	arcmsr_wait_firmware_ready(acb);
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
 	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
@@ -3149,6 +3150,7 @@ static bool arcmsr_hbaD_get_config(struct AdapterControlBlock *acb)
 		writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,
 			acb->pmuD->outbound_doorbell);/*clear interrupt*/
 	}
+	arcmsr_wait_firmware_ready(acb);
 	/* post "get config" instruction */
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, reg->inbound_msgaddr0);
 	/* wait message ready */
