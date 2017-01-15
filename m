From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 2/6] ncr5380: Clean up dead code and redundant macro usage
Date: Sun, 15 Jan 2017 18:50:57 -0500 (EST)
Message-ID: <14c65a94ea13beec917ba81100d6167af41cbbd9.1484523085.git.fthain@telegraphics.com.au>
References: <cover.1484523085.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1484523085.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove dead code inside #if 0 conditionals.

Remove the #ifdef __KERNEL__ test, since NCR5380.h has no definitions
that relate to userspace code.

Remove two redundant macro definitions which were overlooked in
commit e9db3198e08b ("sun3_scsi: Adopt NCR5380.c core driver").

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.h    |  7 -------
 drivers/scsi/atari_scsi.c | 31 -------------------------------
 drivers/scsi/sun3_scsi.c  |  3 ---
 3 files changed, 41 deletions(-)

diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index e61d9f9..d78f0957 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -166,11 +166,7 @@
 #define CSR_SCSI_BUF_RDY       0x02	/* ro  SCSI buffer read */
 #define CSR_GATED_53C80_IRQ    0x01	/* ro  Last block xferred */
 
-#if 0
-#define CSR_BASE CSR_SCSI_BUFF_INTR | CSR_53C80_INTR
-#else
 #define CSR_BASE CSR_53C80_INTR
-#endif
 
 /* Note : PHASE_* macros are based on the values of the STATUS register */
 #define PHASE_MASK 	(SR_MSG | SR_CD | SR_IO)
@@ -229,8 +225,6 @@ struct NCR5380_hostdata {
 	char info[168];				/* Host banner message */
 };
 
-#ifdef __KERNEL__
-
 struct NCR5380_cmd {
 	struct list_head list;
 };
@@ -323,5 +317,4 @@ static inline int NCR5380_dma_residual_none(struct NCR5380_hostdata *hostdata)
 	return 0;
 }
 
-#endif				/* __KERNEL__ */
 #endif				/* NCR5380_H */
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 105b353..2b6eb7c 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -178,37 +178,6 @@ static int scsi_dma_is_ignored_buserr(unsigned char dma_stat)
 }
 
 
-#if 0
-/* Dead code... wasn't called anyway :-) and causes some trouble, because at
- * end-of-DMA, both SCSI ints are triggered simultaneously, so the NCR int has
- * to clear the DMA int pending bit before it allows other level 6 interrupts.
- */
-static void scsi_dma_buserr(int irq, void *dummy)
-{
-	unsigned char dma_stat = tt_scsi_dma.dma_ctrl;
-
-	/* Don't do anything if a NCR interrupt is pending. Probably it's just
-	 * masked... */
-	if (atari_irq_pending(IRQ_TT_MFP_SCSI))
-		return;
-
-	printk("Bad SCSI DMA interrupt! dma_addr=0x%08lx dma_stat=%02x dma_cnt=%08lx\n",
-	       SCSI_DMA_READ_P(dma_addr), dma_stat, SCSI_DMA_READ_P(dma_cnt));
-	if (dma_stat & 0x80) {
-		if (!scsi_dma_is_ignored_buserr(dma_stat))
-			printk("SCSI DMA bus error -- bad DMA programming!\n");
-	} else {
-		/* Under normal circumstances we never should get to this point,
-		 * since both interrupts are triggered simultaneously and the 5380
-		 * int has higher priority. When this irq is handled, that DMA
-		 * interrupt is cleared. So a warning message is printed here.
-		 */
-		printk("SCSI DMA intr ?? -- this shouldn't happen!\n");
-	}
-}
-#endif
-
-
 static irqreturn_t scsi_tt_intr(int irq, void *dev)
 {
 	struct Scsi_Host *instance = dev;
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 88db699..166f466 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -56,9 +56,6 @@
 #define NCR5380_dma_send_setup          sun3scsi_dma_count
 #define NCR5380_dma_residual            sun3scsi_dma_residual
 
-#define NCR5380_acquire_dma_irq(instance)    (1)
-#define NCR5380_release_dma_irq(instance)
-
 #include "NCR5380.h"
 
 
-- 
2.10.2
