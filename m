From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 10/13] scsi: arcmsr: fix clear doorbell queue on
 ACB_ADAPTER_TYPE_B controller
Date: Thu, 09 Nov 2017 08:24:53 +0800
Message-ID: <1510187093.4523.91.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:49842 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753275AbdKIIY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 03:24:56 -0500
Received: by mail-io0-f177.google.com with SMTP id n137so8943728iod.6
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 00:24:56 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org

From: Ching Huang <ching2048@areca.com.tw>

fix clear doorbell queue on ACB_ADAPTER_TYPE_B controller

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:54:18.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:54:58.000000000 +0800
@@ -4202,10 +4202,19 @@ static void arcmsr_clear_doorbell_queue_
 
 	case ACB_ADAPTER_TYPE_B: {
 		struct MessageUnit_B *reg = acb->pmuB;
-		/*clear interrupt and message state*/
-		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
+		uint32_t outbound_doorbell, i;
+		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
 		/* let IOP know data has been read */
+		for(i=0; i < 200; i++) {
+			msleep(20);
+			outbound_doorbell = readl(reg->iop2drv_doorbell);
+			if( outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {
+				writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
+				writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
+			} else
+				break;
+		}
 		}
 		break;
 	case ACB_ADAPTER_TYPE_C: {
