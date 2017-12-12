From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 3/4] scsi: arcmsr: simplify arcmsr_hbaE_get_config function
Date: Tue, 12 Dec 2017 18:50:51 +0800
Message-ID: <1513075851.5249.24.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, hch@infradead.org, colin.king@canonical.com
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

simplify arcmsr_hbaE_get_config function

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index dfaea8f..b7a56e8 100755
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -3205,16 +3205,14 @@ static bool arcmsr_hbaE_get_config(struct AdapterControlBlock *pACB)
 	struct MessageUnit_E __iomem *reg = pACB->pmuE;
 	char __iomem *iop_firm_model = (char __iomem *)(&reg->msgcode_rwbuffer[15]);
 	char __iomem *iop_firm_version = (char __iomem *)(&reg->msgcode_rwbuffer[17]);
-	uint32_t intmask_org, Index, firmware_state = 0, read_doorbell;
+	uint32_t intmask_org;
 	int count;
 
 	/* disable all outbound interrupt */
 	intmask_org = readl(&reg->host_int_mask); /* disable outbound message0 int */
 	writel(intmask_org | ARCMSR_HBEMU_ALL_INTMASKENABLE, &reg->host_int_mask);
 	/* wait firmware ready */
-	do {
-		firmware_state = readl(&reg->outbound_msgaddr1);
-	} while ((firmware_state & ARCMSR_HBEMU_MESSAGE_FIRMWARE_OK) == 0);
+	arcmsr_wait_firmware_ready(pACB);
 	mdelay(20);
 	/* post "get config" instruction */
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
@@ -3222,17 +3220,7 @@ static bool arcmsr_hbaE_get_config(struct AdapterControlBlock *pACB)
 	pACB->out_doorbell ^= ARCMSR_HBEMU_DRV2IOP_MESSAGE_CMD_DONE;
 	writel(pACB->out_doorbell, &reg->iobound_doorbell);
 	/* wait message ready */
-	for (Index = 0; Index < 2000; Index++) {
-		read_doorbell = readl(&reg->iobound_doorbell);
-		if ((read_doorbell ^ pACB->in_doorbell) & ARCMSR_HBEMU_IOP2DRV_MESSAGE_CMD_DONE) {
-			writel(0, &reg->host_int_status);
-			pACB->in_doorbell = read_doorbell;
-			break;
-		}
-		mdelay(1);
-	} /*max 1 seconds*/
-
-	if (Index >= 2000) {
+	if (!arcmsr_hbaE_wait_msgint_ready(pACB)) {
 		pr_notice("arcmsr%d: wait get adapter firmware "
 			"miscellaneous data timeout\n", pACB->host->host_no);
 		return false;
