From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: arcmsr: clean up clang warning on extraneous parentheses
Date: Mon,  1 Oct 2018 00:03:07 +0100
Message-ID: <20180930230307.18664-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are extraneous parantheses that are causing clang to produce a
warning so remove these.

Clean up 3 clang warnings:
equality comparison with extraneous parentheses [-Wparentheses-equality]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index cc0be4651128..22cf697adab0 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -4135,9 +4135,9 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 		pci_read_config_byte(acb->pdev, i, &value[i]);
 	}
 	/* hardware reset signal */
-	if ((acb->dev_id == 0x1680)) {
+	if (acb->dev_id == 0x1680) {
 		writel(ARCMSR_ARC1680_BUS_RESET, &pmuA->reserved1[0]);
-	} else if ((acb->dev_id == 0x1880)) {
+	} else if (acb->dev_id == 0x1880) {
 		do {
 			count++;
 			writel(0xF, &pmuC->write_sequence);
@@ -4161,7 +4161,7 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 		} while (((readl(&pmuE->host_diagnostic_3xxx) &
 			ARCMSR_ARC1884_DiagWrite_ENABLE) == 0) && (count < 5));
 		writel(ARCMSR_ARC188X_RESET_ADAPTER, &pmuE->host_diagnostic_3xxx);
-	} else if ((acb->dev_id == 0x1214)) {
+	} else if (acb->dev_id == 0x1214) {
 		writel(0x20, pmuD->reset_request);
 	} else {
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);
-- 
2.17.1
