From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 15/16] mac_scsi: dont enable mac_scsi irq before requesting
 it
Date: Sat, 10 Dec 2011 16:24:49 +1100 (EST)
Message-ID: <alpine.LNX.2.00.1112101606360.13274@nippy.intranet>
References: <20111023141108.856998818@telegraphics.com.au> <20111023141219.568755239@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vm4.telegraphics.com.au ([98.124.60.149]:57867 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1LJFYx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Dec 2011 00:24:53 -0500
In-Reply-To: <20111023141219.568755239@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

Don't enable the SCSI irq when initialising the chip -- the irq has no 
handler yet.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Re-sending unchanged. Still needs the right ack.


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
