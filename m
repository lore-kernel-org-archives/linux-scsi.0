From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 76/77] ncr5380: Fix wait for 53C80 registers registers after PDMA
Date: Tue, 22 Dec 2015 12:18:54 +1100
Message-ID: <20151222011758.695930028@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=77-71
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

The check for 53C80 registers accessibility was commented out because
it was broken (inverted). Fix and enable it.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/g_NCR5380.c |   37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2015-12-22 12:17:31.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2015-12-22 12:17:32.000000000 +1100
@@ -609,14 +609,10 @@ static inline int NCR5380_pread(struct S
 	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
 		printk("53C400r: no 53C80 gated irq after transfer");
 
-#if 0
-	/*
-	 *	DON'T DO THIS - THEY NEVER ARRIVE!
-	 */
-	printk("53C400r: Waiting for 53C80 registers\n");
-	while (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)
+	/* wait for 53C80 registers to be available */
+	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG))
 		;
-#endif
+
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
 		printk(KERN_ERR "53C400r: no end dma signal\n");
 		
@@ -638,7 +634,6 @@ static inline int NCR5380_pwrite(struct
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int blocks = len / 128;
 	int start = 0;
-	int i;
 
 	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
 	NCR5380_write(hostdata->c400_blk_cnt, blocks);
@@ -687,36 +682,16 @@ static inline int NCR5380_pwrite(struct
 		blocks--;
 	}
 
-#if 0
-	printk("53C400w: waiting for registers to be available\n");
-	THEY NEVER DO ! while (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG);
-	printk("53C400w: Got em\n");
-#endif
-
-	/* Let's wait for this instead - could be ugly */
-	/* All documentation says to check for this. Maybe my hardware is too
-	 * fast. Waiting for it seems to work fine! KLL
-	 */
-	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)) {
+	/* wait for 53C80 registers to be available */
+	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)) {
 		udelay(4); /* DTC436 chip hangs without this */
 		/* FIXME - no timeout */
 	}
 
-	/*
-	 * I know. i is certainly != 0 here but the loop is new. See previous
-	 * comment.
-	 */
-	if (i) {
-		if (!((i = NCR5380_read(BUS_AND_STATUS_REG)) & BASR_END_DMA_TRANSFER))
-			printk(KERN_ERR "53C400w: No END OF DMA bit - WHOOPS! BASR=%0x\n", i);
-	} else
-		printk(KERN_ERR "53C400w: no 53C80 gated irq after transfer (last block)\n");
-
-#if 0
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER)) {
 		printk(KERN_ERR "53C400w: no end dma signal\n");
 	}
-#endif
+
 	while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT))
 		; 	// TIMEOUT
 	return 0;
