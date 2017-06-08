From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: ipr: remove unnecessary variable assignments and the
 variable itself
Date: Thu, 8 Jun 2017 15:47:13 -0500
Message-ID: <20170608204713.GA7765@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Remove unnecessary variable assignments, the variable itself and
refactor the code.

Addresses-Coverity-ID: 1227034
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/ipr.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b0c68d2..633db65 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8414,7 +8414,6 @@ static int ipr_reset_next_stage(struct ipr_cmnd *ipr_cmd)
 static int ipr_reset_enable_ioa(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
-	volatile u32 int_reg;
 	volatile u64 maskval;
 	int i;
 
@@ -8431,15 +8430,14 @@ static int ipr_reset_enable_ioa(struct ipr_cmnd *ipr_cmd)
 	if (ioa_cfg->sis64) {
 		/* Set the adapter to the correct endian mode. */
 		writel(IPR_ENDIAN_SWAP_KEY, ioa_cfg->regs.endian_swap_reg);
-		int_reg = readl(ioa_cfg->regs.endian_swap_reg);
+		readl(ioa_cfg->regs.endian_swap_reg);
 	}
 
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_reg32);
-
-	if (int_reg & IPR_PCII_IOA_TRANS_TO_OPER) {
+	if (readl(ioa_cfg->regs.sense_interrupt_reg32) &
+	    IPR_PCII_IOA_TRANS_TO_OPER) {
 		writel((IPR_PCII_ERROR_INTERRUPTS | IPR_PCII_HRRQ_UPDATED),
 		       ioa_cfg->regs.clr_interrupt_mask_reg32);
-		int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
+		readl(ioa_cfg->regs.sense_interrupt_mask_reg);
 		return IPR_RC_JOB_CONTINUE;
 	}
 
@@ -8453,7 +8451,7 @@ static int ipr_reset_enable_ioa(struct ipr_cmnd *ipr_cmd)
 	} else
 		writel(IPR_PCII_OPER_INTERRUPTS, ioa_cfg->regs.clr_interrupt_mask_reg32);
 
-	int_reg = readl(ioa_cfg->regs.sense_interrupt_mask_reg);
+	readl(ioa_cfg->regs.sense_interrupt_mask_reg);
 
 	dev_info(&ioa_cfg->pdev->dev, "Initializing IOA.\n");
 
-- 
2.5.0
