From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: ipr: fix build on 32-bit architectures
Date: Fri,  8 Jun 2018 16:46:00 +0200
Message-ID: <20180608144617.2900894-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.com>, Souptick Joarder <jrdr.linux@gmail.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Sinan Kaya <okaya@codeaurora.org>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Replacing writeq() with writeq_relaxed() doesn't work on many architectures,
as that variant is not available in general:

net/Makefile:24: CC cannot link executables. Skipping bpfilter.
drivers/scsi/ipr.c: In function 'ipr_mask_and_clear_interrupts':
drivers/scsi/ipr.c:767:3: error: implicit declaration of function 'writeq_relaxed'; did you mean 'writew_relaxed'? [-Werror=implicit-function-declaration]
   writeq_relaxed(~0, ioa_cfg->regs.set_interrupt_mask_reg);
   ^~~~~~~~~~~~~~
   writew_relaxed

The other issue here is that the patch eliminated the wrong barrier.
As per a long discussion that followed Sinan's original patch submission,
the conclusion was that drivers should generally assume that the barrier
implied by writel() is sufficient for ordering DMA, so this reverts his
change and instead removes the extraneous wmb() before it, which is no
longer needed on any architecture now.

Fixes: 0109a4f2e02d ("scsi: ipr: Eliminate duplicate barriers on weakly-ordered archs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/ipr.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 865c07dc11ea..d2f67a41fcdd 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -760,13 +760,12 @@ static void ipr_mask_and_clear_interrupts(struct ipr_ioa_cfg *ioa_cfg,
 		ioa_cfg->hrrq[i].allow_interrupts = 0;
 		spin_unlock(&ioa_cfg->hrrq[i]._lock);
 	}
-	wmb();
 
 	/* Set interrupt mask to stop all new interrupts */
 	if (ioa_cfg->sis64)
-		writeq_relaxed(~0, ioa_cfg->regs.set_interrupt_mask_reg);
+		writeq(~0, ioa_cfg->regs.set_interrupt_mask_reg);
 	else
-		writel_relaxed(~0, ioa_cfg->regs.set_interrupt_mask_reg);
+		writel(~0, ioa_cfg->regs.set_interrupt_mask_reg);
 
 	/* Clear any pending interrupts */
 	if (ioa_cfg->sis64)
@@ -8401,10 +8400,9 @@ static int ipr_reset_enable_ioa(struct ipr_cmnd *ipr_cmd)
 		ioa_cfg->hrrq[i].allow_interrupts = 1;
 		spin_unlock(&ioa_cfg->hrrq[i]._lock);
 	}
-	wmb();
 	if (ioa_cfg->sis64) {
 		/* Set the adapter to the correct endian mode. */
-		writel_relaxed(IPR_ENDIAN_SWAP_KEY,
+		writel(IPR_ENDIAN_SWAP_KEY,
 			       ioa_cfg->regs.endian_swap_reg);
 		int_reg = readl(ioa_cfg->regs.endian_swap_reg);
 	}
-- 
2.9.0
