From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 13/16] mac_scsi: fix mac_scsi on some powerbooks
Date: Mon, 24 Oct 2011 01:11:21 +1100
Message-ID: <20111023141210.668233681@telegraphics.com.au>
References: <20111023141108.856998818@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vm4.telegraphics.com.au ([98.124.60.149]:46073 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab1JWOMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2011 10:12:15 -0400
Content-Disposition: inline; filename=fix-scsi-interrupt
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Fix the mac_scsi interrupt edge trigger on non-RBV PowerBooks. This doesn't appear to help my PowerBook 520 but the NetBSD source reveals that the PowerBook 500 series is different than the others.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Index: linux-m68k/arch/m68k/mac/via.c
===================================================================
--- linux-m68k.orig/arch/m68k/mac/via.c	2011-10-22 23:02:39.000000000 +1100
+++ linux-m68k/arch/m68k/mac/via.c	2011-10-23 00:51:01.000000000 +1100
@@ -252,22 +252,28 @@ void __init via_init(void)
 		via2[vACR] &= ~0x03; /* disable port A & B latches */
 	}
 
+	/* Everything below this point is VIA2 only... */
+
+	if (rbv_present)
+		return;
+
 	/*
-	 * Set vPCR for control line interrupts (but not on RBV)
+	 * Set vPCR for control line interrupts.
+	 *
+	 * CA1 (SLOTS IRQ), CB1 (ASC IRQ): negative edge trigger.
+	 *
+	 * Macs with ESP SCSI have a negative edge triggered SCSI interrupt.
+	 * Testing reveals that PowerBooks do too. However, the SE/30
+	 * schematic diagram shows an active high NCR5380 IRQ line.
 	 */
-	if (!rbv_present) {
-		/* For all VIA types, CA1 (SLOTS IRQ) and CB1 (ASC IRQ)
-		 * are made negative edge triggered here.
-		 */
-		if (macintosh_config->scsi_type == MAC_SCSI_OLD) {
-			/* CB2 (IRQ) indep. input, positive edge */
-			/* CA2 (DRQ) indep. input, positive edge */
-			via2[vPCR] = 0x66;
-		} else {
-			/* CB2 (IRQ) indep. input, negative edge */
-			/* CA2 (DRQ) indep. input, negative edge */
-			via2[vPCR] = 0x22;
-		}
+
+	pr_debug("VIA2 vPCR is 0x%02X\n", via2[vPCR]);
+	if (macintosh_config->via_type == MAC_VIA_II) {
+		/* CA2 (SCSI DRQ), CB2 (SCSI IRQ): indep. input, pos. edge */
+		via2[vPCR] = 0x66;
+	} else {
+		/* CA2 (SCSI DRQ), CB2 (SCSI IRQ): indep. input, neg. edge */
+		via2[vPCR] = 0x22;
 	}
 }
 

