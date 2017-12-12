From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 1/4] scsi: arcmsr: simplify arcmsr_hbaC_get_config function
Date: Tue, 12 Dec 2017 18:42:29 +0800
Message-ID: <1513075349.5249.17.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:44145 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdLLKme (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2017 05:42:34 -0500
Received: by mail-pf0-f195.google.com with SMTP id m26so13888054pfj.11
        for <linux-scsi@vger.kernel.org>; Tue, 12 Dec 2017 02:42:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com

From: Ching Huang <ching2048@areca.com.tw>

simplify arcmsr_hbaC_get_config function

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index e4258b6..9b587ca 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -3082,7 +3082,7 @@ static bool arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)
 
 static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
 {
-	uint32_t intmask_org, Index, firmware_state = 0;
+	uint32_t intmask_org;
 	struct MessageUnit_C __iomem *reg = pACB->pmuC;
 	char *acb_firm_model = pACB->firm_model;
 	char *acb_firm_version = pACB->firm_version;
@@ -3093,21 +3093,12 @@ static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
 	intmask_org = readl(&reg->host_int_mask); /* disable outbound message0 int */
 	writel(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);
 	/* wait firmware ready */
-	do {
-		firmware_state = readl(&reg->outbound_msgaddr1);
-	} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
+	arcmsr_wait_firmware_ready(pACB);
 	/* post "get config" instruction */
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
 	/* wait message ready */
-	for (Index = 0; Index < 2000; Index++) {
-		if (readl(&reg->outbound_doorbell) & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, &reg->outbound_doorbell_clear);/*clear interrupt*/
-			break;
-		}
-		udelay(10);
-	} /*max 1 seconds*/
-	if (Index >= 2000) {
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", pACB->host->host_no);
 		return false;
