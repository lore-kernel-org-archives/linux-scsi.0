From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 06/16] m68k/mac: cleanup mac_irq_pending
Date: Mon, 24 Oct 2011 01:11:14 +1100
Message-ID: <20111023141138.478727775@telegraphics.com.au>
References: <20111023141108.856998818@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=replace-mac_irq_pending
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

mac_irq_pending() has only one caller (mac_esp.c). Nothing tests for Baboon, PSC or OSS pending interrupts. Until that need arises, let's keep it simple and remove all the unused abstraction. Replace it with a routine to check for SCSI DRQ.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Index: linux-m68k/arch/m68k/include/asm/macintosh.h
===================================================================
--- linux-m68k.orig/arch/m68k/include/asm/macintosh.h	2011-10-22 23:02:38.000000000 +1100
+++ linux-m68k/arch/m68k/include/asm/macintosh.h	2011-10-23 00:51:07.000000000 +1100
@@ -11,7 +11,7 @@
 extern void mac_reset(void);
 extern void mac_poweroff(void);
 extern void mac_init_IRQ(void);
-extern int mac_irq_pending(unsigned int);
+
 extern void mac_irq_enable(struct irq_data *data);
 extern void mac_irq_disable(struct irq_data *data);
 
Index: linux-m68k/arch/m68k/mac/baboon.c
===================================================================
--- linux-m68k.orig/arch/m68k/mac/baboon.c	2011-10-22 23:02:38.000000000 +1100
+++ linux-m68k/arch/m68k/mac/baboon.c	2011-10-23 00:51:07.000000000 +1100
@@ -123,10 +123,3 @@ void baboon_irq_disable(int irq)
 	if (baboon_disabled)
 		mac_irq_disable(irq_get_irq_data(IRQ_NUBUS_C));
 }
-
-int baboon_irq_pending(int irq)
-{
-	int irq_idx = IRQ_IDX(irq);
-
-	return baboon->mb_ifr & (1 << irq_idx);
-}
Index: linux-m68k/arch/m68k/mac/macints.c
===================================================================
--- linux-m68k.orig/arch/m68k/mac/macints.c	2011-10-22 23:02:38.000000000 +1100
+++ linux-m68k/arch/m68k/mac/macints.c	2011-10-23 00:51:07.000000000 +1100
@@ -142,7 +142,6 @@ extern void via_register_interrupts(void
 extern void via_irq_enable(int);
 extern void via_irq_disable(int);
 extern void via_irq_clear(int);
-extern int  via_irq_pending(int);
 
 /*
  * OSS hooks
@@ -152,7 +151,6 @@ extern void oss_register_interrupts(void
 extern void oss_irq_enable(int);
 extern void oss_irq_disable(int);
 extern void oss_irq_clear(int);
-extern int  oss_irq_pending(int);
 
 /*
  * PSC hooks
@@ -162,7 +160,6 @@ extern void psc_register_interrupts(void
 extern void psc_irq_enable(int);
 extern void psc_irq_disable(int);
 extern void psc_irq_clear(int);
-extern int  psc_irq_pending(int);
 
 /*
  * IOP hooks
@@ -239,7 +236,6 @@ void __init mac_init_IRQ(void)
 /*
  *  mac_irq_enable - enable an interrupt source
  * mac_irq_disable - disable an interrupt source
- * mac_irq_pending - returns the pending status of an IRQ (nonzero = pending)
  *
  * These routines are just dispatchers to the VIA/OSS/PSC routines.
  */
@@ -314,34 +310,6 @@ void mac_irq_disable(struct irq_data *da
 	}
 }
 
-int mac_irq_pending(unsigned int irq)
-{
-	switch(IRQ_SRC(irq)) {
-	case 1:
-		return via_irq_pending(irq);
-	case 2:
-	case 7:
-		if (oss_present)
-			return oss_irq_pending(irq);
-		else
-			return via_irq_pending(irq);
-	case 3:
-	case 5:
-	case 6:
-		if (psc_present)
-			return psc_irq_pending(irq);
-		else if (oss_present)
-			return oss_irq_pending(irq);
-		break;
-	case 4:
-		if (psc_present)
-			return psc_irq_pending(irq);
-		break;
-	}
-	return 0;
-}
-EXPORT_SYMBOL(mac_irq_pending);
-
 static int num_debug[8];
 
 irqreturn_t mac_debug_handler(int irq, void *dev_id)
Index: linux-m68k/arch/m68k/mac/oss.c
===================================================================
--- linux-m68k.orig/arch/m68k/mac/oss.c	2011-10-22 23:02:38.000000000 +1100
+++ linux-m68k/arch/m68k/mac/oss.c	2011-10-23 00:51:07.000000000 +1100
@@ -219,32 +219,3 @@ void oss_irq_disable(int irq) {
 #endif
 	}
 }
-
-/*
- * Check to see if a specific OSS interrupt is pending
- */
-
-int oss_irq_pending(int irq)
-{
-	switch(irq) {
-		case IRQ_MAC_SCC:
-			return oss->irq_pending & OSS_IP_IOPSCC;
-			break;
-		case IRQ_MAC_ADB:
-			return oss->irq_pending & OSS_IP_IOPISM;
-			break;
-		case IRQ_MAC_SCSI:
-			return oss->irq_pending & OSS_IP_SCSI;
-			break;
-		case IRQ_NUBUS_9:
-		case IRQ_NUBUS_A:
-		case IRQ_NUBUS_B:
-		case IRQ_NUBUS_C:
-		case IRQ_NUBUS_D:
-		case IRQ_NUBUS_E:
-			irq -= NUBUS_SOURCE_BASE;
-			return oss->irq_pending & (1 << irq);
-			break;
-	}
-	return 0;
-}
Index: linux-m68k/arch/m68k/mac/psc.c
===================================================================
--- linux-m68k.orig/arch/m68k/mac/psc.c	2011-10-22 23:02:38.000000000 +1100
+++ linux-m68k/arch/m68k/mac/psc.c	2011-10-22 23:02:38.000000000 +1100
@@ -180,12 +180,3 @@ void psc_irq_disable(int irq) {
 #endif
 	psc_write_byte(pIER, 1 << irq_idx);
 }
-
-int psc_irq_pending(int irq)
-{
-	int irq_src	= IRQ_SRC(irq);
-	int irq_idx	= IRQ_IDX(irq);
-	int pIFR	= pIERbase + (irq_src << 4);
-
-	return psc_read_byte(pIFR) & (1 << irq_idx);
-}
Index: linux-m68k/arch/m68k/mac/via.c
===================================================================
--- linux-m68k.orig/arch/m68k/mac/via.c	2011-10-22 23:02:38.000000000 +1100
+++ linux-m68k/arch/m68k/mac/via.c	2011-10-23 00:51:07.000000000 +1100
@@ -584,28 +584,6 @@ void via_irq_disable(int irq) {
 	}
 }
 
-/*
- * Returns nonzero if an interrupt is pending on the given
- * VIA/IRQ combination.
- */
-
-int via_irq_pending(int irq)
-{
-	int irq_src	= IRQ_SRC(irq);
-	int irq_idx	= IRQ_IDX(irq);
-	int irq_bit	= 1 << irq_idx;
-
-	if (irq_src == 1) {
-		return via1[vIFR] & irq_bit;
-	} else if (irq_src == 2) {
-		return via2[gIFR] & irq_bit;
-	} else if (irq_src == 7) {
-		/* Always 0 for MAC_VIA_QUADRA if the slot irq is disabled. */
-		return ~via2[gBufA] & irq_bit;
-	}
-	return 0;
-}
-
 void via1_set_head(int head)
 {
 	if (head == 0)
@@ -614,3 +592,9 @@ void via1_set_head(int head)
 		via1[vBufA] |= VIA1A_vHeadSel;
 }
 EXPORT_SYMBOL(via1_set_head);
+
+int via2_scsi_drq_pending(void)
+{
+	return via2[gIFR] & (1 << IRQ_IDX(IRQ_MAC_SCSIDRQ));
+}
+EXPORT_SYMBOL(via2_scsi_drq_pending);
Index: linux-m68k/drivers/scsi/mac_esp.c
===================================================================
--- linux-m68k.orig/drivers/scsi/mac_esp.c	2011-10-22 23:02:38.000000000 +1100
+++ linux-m68k/drivers/scsi/mac_esp.c	2011-10-22 23:02:38.000000000 +1100
@@ -25,6 +25,7 @@
 #include <asm/dma.h>
 #include <asm/macints.h>
 #include <asm/macintosh.h>
+#include <asm/mac_via.h>
 
 #include <scsi/scsi_host.h>
 
@@ -149,7 +150,7 @@ static inline int mac_esp_wait_for_dreq(
 
 	do {
 		if (mep->pdma_regs == NULL) {
-			if (mac_irq_pending(IRQ_MAC_SCSIDRQ))
+			if (via2_scsi_drq_pending())
 				return 0;
 		} else {
 			if (nubus_readl(mep->pdma_regs) & 0x200)
Index: linux-m68k/arch/m68k/include/asm/mac_via.h
===================================================================
--- linux-m68k.orig/arch/m68k/include/asm/mac_via.h	2011-10-22 23:02:22.000000000 +1100
+++ linux-m68k/arch/m68k/include/asm/mac_via.h	2011-10-23 00:51:07.000000000 +1100
@@ -254,6 +254,8 @@
 extern volatile __u8 *via1,*via2;
 extern int rbv_present,via_alt_mapping;
 
+extern int via2_scsi_drq_pending(void);
+
 static inline int rbv_set_video_bpp(int bpp)
 {
 	char val = (bpp==1)?0:(bpp==2)?1:(bpp==4)?2:(bpp==8)?3:-1;
