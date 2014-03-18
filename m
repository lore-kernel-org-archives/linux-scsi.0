From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 10/12] scsi/NCR5380: remove unused macro definitions
Date: Tue, 18 Mar 2014 11:42:22 +1100
Message-ID: <20140318004215.582469999@telegraphics.com.au>
References: <20140318004212.612472697@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:53942 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaCRAoG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2014 20:44:06 -0400
Content-Disposition: inline; filename=ncr5380-debug-macros-remove-X_PRINTK-NCRPRINT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org

Remove the unused (and divergent) debugging macro definitions from
the sun3_NCR5380 and atari_NCR5380 drivers. These drivers have been
converted to use the common macros in NCR5380.h.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_scsi.h |   93 -----------------------
 drivers/scsi/sun3_scsi.h  |  181 ----------------------------------------------
 2 files changed, 274 deletions(-)

Index: linux-m68k/drivers/scsi/atari_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/atari_scsi.h	2014-03-17 23:49:22.000000000 +1100
+++ linux-m68k/drivers/scsi/atari_scsi.h	2014-03-18 00:18:37.000000000 +1100
@@ -80,99 +80,6 @@
 #define SCSI_RESET_HOST_RESET 0x200
 #define SCSI_RESET_ACTION   0xff
 
-/* Debugging printk definitions:
- *
- *  ARB  -> arbitration
- *  ASEN -> auto-sense
- *  DMA  -> DMA
- *  HSH  -> PIO handshake
- *  INF  -> information transfer
- *  INI  -> initialization
- *  INT  -> interrupt
- *  LNK  -> linked commands
- *  MAIN -> NCR5380_main() control flow
- *  NDAT -> no data-out phase
- *  NWR  -> no write commands
- *  PIO  -> PIO transfers
- *  PDMA -> pseudo DMA (unused on Atari)
- *  QU   -> queues
- *  RSL  -> reselections
- *  SEL  -> selections
- *  USL  -> usleep cpde (unused on Atari)
- *  LBS  -> last byte sent (unused on Atari)
- *  RSS  -> restarting of selections
- *  EXT  -> extended messages
- *  ABRT -> aborting and resetting
- *  TAG  -> queue tag handling
- *  MER  -> merging of consec. buffers
- *
- */
-
-#define dprint(flg, format...)			\
-({						\
-	if (NDEBUG & (flg))			\
-		printk(KERN_DEBUG format);	\
-})
-
-#define ARB_PRINTK(format, args...) \
-	dprint(NDEBUG_ARBITRATION, format , ## args)
-#define ASEN_PRINTK(format, args...) \
-	dprint(NDEBUG_AUTOSENSE, format , ## args)
-#define DMA_PRINTK(format, args...) \
-	dprint(NDEBUG_DMA, format , ## args)
-#define HSH_PRINTK(format, args...) \
-	dprint(NDEBUG_HANDSHAKE, format , ## args)
-#define INF_PRINTK(format, args...) \
-	dprint(NDEBUG_INFORMATION, format , ## args)
-#define INI_PRINTK(format, args...) \
-	dprint(NDEBUG_INIT, format , ## args)
-#define INT_PRINTK(format, args...) \
-	dprint(NDEBUG_INTR, format , ## args)
-#define LNK_PRINTK(format, args...) \
-	dprint(NDEBUG_LINKED, format , ## args)
-#define MAIN_PRINTK(format, args...) \
-	dprint(NDEBUG_MAIN, format , ## args)
-#define NDAT_PRINTK(format, args...) \
-	dprint(NDEBUG_NO_DATAOUT, format , ## args)
-#define NWR_PRINTK(format, args...) \
-	dprint(NDEBUG_NO_WRITE, format , ## args)
-#define PIO_PRINTK(format, args...) \
-	dprint(NDEBUG_PIO, format , ## args)
-#define PDMA_PRINTK(format, args...) \
-	dprint(NDEBUG_PSEUDO_DMA, format , ## args)
-#define QU_PRINTK(format, args...) \
-	dprint(NDEBUG_QUEUES, format , ## args)
-#define RSL_PRINTK(format, args...) \
-	dprint(NDEBUG_RESELECTION, format , ## args)
-#define SEL_PRINTK(format, args...) \
-	dprint(NDEBUG_SELECTION, format , ## args)
-#define USL_PRINTK(format, args...) \
-	dprint(NDEBUG_USLEEP, format , ## args)
-#define LBS_PRINTK(format, args...) \
-	dprint(NDEBUG_LAST_BYTE_SENT, format , ## args)
-#define RSS_PRINTK(format, args...) \
-	dprint(NDEBUG_RESTART_SELECT, format , ## args)
-#define EXT_PRINTK(format, args...) \
-	dprint(NDEBUG_EXTENDED, format , ## args)
-#define ABRT_PRINTK(format, args...) \
-	dprint(NDEBUG_ABORT, format , ## args)
-#define TAG_PRINTK(format, args...) \
-	dprint(NDEBUG_TAGS, format , ## args)
-#define MER_PRINTK(format, args...) \
-	dprint(NDEBUG_MERGING, format , ## args)
-
-/* conditional macros for NCR5380_print_{,phase,status} */
-
-#define NCR_PRINT(mask)	\
-	((NDEBUG & (mask)) ? NCR5380_print(instance) : (void)0)
-
-#define NCR_PRINT_PHASE(mask) \
-	((NDEBUG & (mask)) ? NCR5380_print_phase(instance) : (void)0)
-
-#define NCR_PRINT_STATUS(mask) \
-	((NDEBUG & (mask)) ? NCR5380_print_status(instance) : (void)0)
-
-
 #endif /* ndef ASM */
 #endif /* ATARI_SCSI_H */
 
Index: linux-m68k/drivers/scsi/sun3_scsi.h
===================================================================
--- linux-m68k.orig/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:32.000000000 +1100
+++ linux-m68k/drivers/scsi/sun3_scsi.h	2014-03-18 00:18:37.000000000 +1100
@@ -182,188 +182,7 @@ struct sun3_udc_regs {
 
 #define VME_DATA24 0x3d00
 
-// debugging printk's, taken from atari_scsi.h 
-/* Debugging printk definitions:
- *
- *  ARB  -> arbitration
- *  ASEN -> auto-sense
- *  DMA  -> DMA
- *  HSH  -> PIO handshake
- *  INF  -> information transfer
- *  INI  -> initialization
- *  INT  -> interrupt
- *  LNK  -> linked commands
- *  MAIN -> NCR5380_main() control flow
- *  NDAT -> no data-out phase
- *  NWR  -> no write commands
- *  PIO  -> PIO transfers
- *  PDMA -> pseudo DMA (unused on Atari)
- *  QU   -> queues
- *  RSL  -> reselections
- *  SEL  -> selections
- *  USL  -> usleep cpde (unused on Atari)
- *  LBS  -> last byte sent (unused on Atari)
- *  RSS  -> restarting of selections
- *  EXT  -> extended messages
- *  ABRT -> aborting and resetting
- *  TAG  -> queue tag handling
- *  MER  -> merging of consec. buffers
- *
- */
-
 #include "NCR5380.h"
 
-#if NDEBUG & NDEBUG_ARBITRATION
-#define ARB_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define ARB_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_AUTOSENSE
-#define ASEN_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define ASEN_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_DMA
-#define DMA_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define DMA_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_HANDSHAKE
-#define HSH_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define HSH_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_INFORMATION
-#define INF_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define INF_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_INIT
-#define INI_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define INI_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_INTR
-#define INT_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define INT_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_LINKED
-#define LNK_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define LNK_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_MAIN
-#define MAIN_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define MAIN_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_NO_DATAOUT
-#define NDAT_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define NDAT_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_NO_WRITE
-#define NWR_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define NWR_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_PIO
-#define PIO_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define PIO_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_PSEUDO_DMA
-#define PDMA_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define PDMA_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_QUEUES
-#define QU_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define QU_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_RESELECTION
-#define RSL_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define RSL_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_SELECTION
-#define SEL_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define SEL_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_USLEEP
-#define USL_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define USL_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_LAST_BYTE_SENT
-#define LBS_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define LBS_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_RESTART_SELECT
-#define RSS_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define RSS_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_EXTENDED
-#define EXT_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define EXT_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_ABORT
-#define ABRT_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define ABRT_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_TAGS
-#define TAG_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define TAG_PRINTK(format, args...)
-#endif
-#if NDEBUG & NDEBUG_MERGING
-#define MER_PRINTK(format, args...) \
-	printk(KERN_DEBUG format , ## args)
-#else
-#define MER_PRINTK(format, args...)
-#endif
-
-/* conditional macros for NCR5380_print_{,phase,status} */
-
-#define NCR_PRINT(mask)	\
-	((NDEBUG & (mask)) ? NCR5380_print(instance) : (void)0)
-
-#define NCR_PRINT_PHASE(mask) \
-	((NDEBUG & (mask)) ? NCR5380_print_phase(instance) : (void)0)
-
-#define NCR_PRINT_STATUS(mask) \
-	((NDEBUG & (mask)) ? NCR5380_print_status(instance) : (void)0)
-
-
-
 #endif /* SUN3_NCR5380_H */
 

