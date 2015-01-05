From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 4/8] megaraid_sas : Disable interrupt_mask before enabling hardware interrupts
Date: Mon, 5 Jan 2015 20:06:13 +0530
Message-ID: <201501051440.t05EeF85030030@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com
List-Id: linux-scsi@vger.kernel.org

Update driver "mask_interrupts" before enable/disable hardware interrupt in order to avoid missing interrupts because of "mask_interrupts" still set to 1 and hardware interrupts are
enabled.

Cc: <stable@vger.kernel.org>

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Chaitra Basappa <chaitra.basappa@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index fe60743..a703c86 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -102,6 +102,8 @@ megasas_enable_intr_fusion(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
 	regs = instance->reg_set;
+
+	instance->mask_interrupts = 0;
 	/* For Thunderbolt/Invader also clear intr on enable */
 	writel(~0, &regs->outbound_intr_status);
 	readl(&regs->outbound_intr_status);
@@ -110,7 +112,6 @@ megasas_enable_intr_fusion(struct megasas_instance *instance)
 
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_intr_mask);
-	instance->mask_interrupts = 0;
 }
 
 /**
-- 
1.7.3
