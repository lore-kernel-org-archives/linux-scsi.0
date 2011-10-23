From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 15/16] mac_scsi: dont enable mac_scsi irq before requesting it
Date: Mon, 24 Oct 2011 01:11:23 +1100
Message-ID: <20111023141219.568755239@telegraphics.com.au>
References: <20111023141108.856998818@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=mac-scsi-dont-enable-irq
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Don't enable the SCSI irq when initialising the chip -- the irq has no handler yet.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Index: linux-m68k/drivers/scsi/mac_scsi.c
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_scsi.c	2011-10-22 23:02:38.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_scsi.c	2011-10-22 23:44:51.000000000 +1100
@@ -339,9 +339,6 @@ static void mac_scsi_reset_boot(struct S
 
 	printk(KERN_INFO "Macintosh SCSI: resetting the SCSI bus..." );
 
-	/* switch off SCSI IRQ - catch an interrupt without IRQ bit set else */
-	disable_irq(IRQ_MAC_SCSI);
-
 	/* get in phase */
 	NCR5380_write( TARGET_COMMAND_REG,
 		      PHASE_SR_TO_TCR( NCR5380_read(STATUS_REG) ));
@@ -357,9 +354,6 @@ static void mac_scsi_reset_boot(struct S
 	for( end = jiffies + AFTER_RESET_DELAY; time_before(jiffies, end); )
 		barrier();
 
-	/* switch on SCSI IRQ again */
-	enable_irq(IRQ_MAC_SCSI);
-
 	printk(KERN_INFO " done\n" );
 }
 #endif
