From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] arcmsr: fix misuse of | instead of &
Date: Sat, 9 Jun 2012 12:10:19 +0300
Message-ID: <20120609091018.GC877@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: David Howells <dhowells@redhat.com>, Nick Cheng <nick.cheng@areca.com.tw>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ARCMSR_ARC1880_DiagWrite_ENABLE is 0x00000080 so (x | 0x00000080) is
never zero.  The intent here was to test that loop until
ARCMSR_ARC1880_DiagWrite_ENABLE was turned on, but because the test was
wrong, we would do five loops regardless of whether it succeed or not.

Also I simplified the condition a little by removing the unused
assignement.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.  I do not own this hardware.

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index cbde1dc..def24a1 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2821,7 +2821,7 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 	int i, count = 0;
 	struct MessageUnit_A __iomem *pmuA = acb->pmuA;
 	struct MessageUnit_C __iomem *pmuC = acb->pmuC;
-	u32 temp = 0;
+
 	/* backup pci config data */
 	printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n", acb->host->host_no);
 	for (i = 0; i < 64; i++) {
@@ -2839,7 +2839,7 @@ static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 			writel(0x2, &pmuC->write_sequence);
 			writel(0x7, &pmuC->write_sequence);
 			writel(0xD, &pmuC->write_sequence);
-		} while ((((temp = readl(&pmuC->host_diagnostic)) | ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
+		} while (((readl(&pmuC->host_diagnostic) & ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
 		writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
 	} else {
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);
