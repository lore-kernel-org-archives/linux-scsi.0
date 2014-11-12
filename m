From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 08/37] ncr5380: Remove redundant AUTOSENSE macro
Date: Wed, 12 Nov 2014 16:11:54 +1100
Message-ID: <20141112051148.399620818@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40970 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaKLFnJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:09 -0500
Content-Disposition: inline; filename=ncr5380-remove-AUTOSENSE-macro
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org

Every NCR5380 driver sets AUTOSENSE so it need not be optional (and the
mid-layer expects it). Remove this redundant macro to improve readability.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   14 +-------------
 drivers/scsi/NCR5380.h       |    5 -----
 drivers/scsi/arm/cumana_1.c  |    1 -
 drivers/scsi/arm/oak.c       |    1 -
 drivers/scsi/atari_NCR5380.c |   15 +--------------
 drivers/scsi/atari_scsi.c    |    1 -
 drivers/scsi/dmx3191d.c      |    1 -
 drivers/scsi/dtc.c           |    4 ----
 drivers/scsi/g_NCR5380.c     |    2 --
 drivers/scsi/mac_scsi.c      |    2 --
 drivers/scsi/pas16.c         |    4 ----
 drivers/scsi/sun3_NCR5380.c  |   16 +---------------
 drivers/scsi/sun3_scsi.c     |    2 --
 drivers/scsi/t128.c          |    4 ----
 14 files changed, 3 insertions(+), 69 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2014-11-12 16:10:55.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2014-11-12 16:10:57.000000000 +1100
@@ -627,9 +627,6 @@ NCR5380_print_options(struct Scsi_Host *
 #ifdef AUTOPROBE_IRQ
 	       " AUTOPROBE_IRQ"
 #endif
-#ifdef AUTOSENSE
-	       " AUTOSENSE"
-#endif
 #ifdef DIFFERENTIAL
 	       " DIFFERENTIAL"
 #endif
@@ -857,12 +854,6 @@ static int NCR5380_init(struct Scsi_Host
 	hostdata->host = instance;
 	hostdata->time_expires = 0;
 
-#ifndef AUTOSENSE
-	if ((instance->cmd_per_lun > 1) || instance->can_queue > 1)
-		    printk(KERN_WARNING "scsi%d : WARNING : support for multiple outstanding commands enabled\n" "         without AUTOSENSE option, contingent allegiance conditions may\n"
-		    	   "         be incorrectly cleared.\n", instance->host_no);
-#endif				/* def AUTOSENSE */
-
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
@@ -2260,7 +2251,6 @@ static void NCR5380_information_transfer
 					else if (status_byte(cmd->SCp.Status) != GOOD)
 						cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
 
-#ifdef AUTOSENSE
 					if ((cmd->cmnd[0] == REQUEST_SENSE) &&
 						hostdata->ses.cmd_len) {
 						scsi_eh_restore_cmnd(cmd, &hostdata->ses);
@@ -2277,9 +2267,7 @@ static void NCR5380_information_transfer
 						    hostdata->issue_queue;
 						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
 						dprintk(NDEBUG_QUEUES, "scsi%d : REQUEST SENSE added to head of issue queue\n", instance->host_no);
-					} else
-#endif				/* def AUTOSENSE */
-					{
+					} else {
 						collect_stats(hostdata, cmd);
 						cmd->scsi_done(cmd);
 					}
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-11-12 16:10:55.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-11-12 16:10:57.000000000 +1100
@@ -25,10 +25,7 @@
 #define NCR5380_H
 
 #include <linux/interrupt.h>
-
-#ifdef AUTOSENSE
 #include <scsi/scsi_eh.h>
-#endif
 
 #define NCR5380_PUBLIC_RELEASE 7
 #define NCR53C400_PUBLIC_RELEASE 2
@@ -281,9 +278,7 @@ struct NCR5380_hostdata {
 	unsigned pendingr;
 	unsigned pendingw;
 #endif
-#ifdef AUTOSENSE
 	struct scsi_eh_save ses;
-#endif
 };
 
 #ifdef __KERNEL__
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2014-11-12 16:10:43.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2014-11-12 16:10:57.000000000 +1100
@@ -18,7 +18,6 @@
 
 #include <scsi/scsicam.h>
 
-#define AUTOSENSE
 #define PSEUDO_DMA
 
 #define CUMANASCSI_PUBLIC_RELEASE 1
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2014-11-12 16:10:49.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2014-11-12 16:10:57.000000000 +1100
@@ -17,7 +17,6 @@
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
 
-#define AUTOSENSE
 /*#define PSEUDO_DMA*/
 
 #define OAKSCSI_PUBLIC_RELEASE 1
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-11-12 16:10:55.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-11-12 16:10:57.000000000 +1100
@@ -683,9 +683,6 @@ static inline void NCR5380_all_init(void
 static void __init NCR5380_print_options(struct Scsi_Host *instance)
 {
 	printk(" generic options"
-#ifdef AUTOSENSE
-	       " AUTOSENSE"
-#endif
 #ifdef REAL_DMA
 	       " REAL DMA"
 #endif
@@ -842,13 +839,6 @@ static int __init NCR5380_init(struct Sc
 		first_instance = instance;
 	}
 
-#ifndef AUTOSENSE
-	if ((instance->cmd_per_lun > 1) || (instance->can_queue > 1))
-		printk("scsi%d: WARNING : support for multiple outstanding commands enabled\n"
-		       "        without AUTOSENSE option, contingent allegiance conditions may\n"
-		       "        be incorrectly cleared.\n", HOSTNO);
-#endif /* def AUTOSENSE */
-
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
@@ -2199,7 +2189,6 @@ static void NCR5380_information_transfer
 					else if (status_byte(cmd->SCp.Status) != GOOD)
 						cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
 
-#ifdef AUTOSENSE
 					if ((cmd->cmnd[0] == REQUEST_SENSE) &&
 						hostdata->ses.cmd_len) {
 						scsi_eh_restore_cmnd(cmd, &hostdata->ses);
@@ -2219,9 +2208,7 @@ static void NCR5380_information_transfer
 						local_irq_restore(flags);
 						dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
 							  "issue queue\n", H_NO(cmd));
-					} else
-#endif /* def AUTOSENSE */
-					{
+					} else {
 #ifdef NCR5380_STATS
 						collect_stats(hostdata, cmd);
 #endif
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-11-12 16:10:54.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-11-12 16:10:57.000000000 +1100
@@ -67,7 +67,6 @@
 
 #include <linux/module.h>
 
-#define AUTOSENSE
 /* For the Atari version, use only polled IO or REAL_DMA */
 #define	REAL_DMA
 /* Support tagged queuing? (on devices that are able to... :-) */
Index: linux/drivers/scsi/dmx3191d.c
===================================================================
--- linux.orig/drivers/scsi/dmx3191d.c	2014-11-12 16:10:46.000000000 +1100
+++ linux/drivers/scsi/dmx3191d.c	2014-11-12 16:10:57.000000000 +1100
@@ -33,7 +33,6 @@
 /*
  * Definitions for the generic 5380 driver.
  */
-#define AUTOSENSE
 
 #define NCR5380_read(reg)		inb(port + reg)
 #define NCR5380_write(reg, value)	outb(value, port + reg)
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2014-11-12 16:10:54.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2014-11-12 16:10:57.000000000 +1100
@@ -1,5 +1,4 @@
 
-#define AUTOSENSE
 #define PSEUDO_DMA
 #define DONT_USE_INTR
 #define UNSAFE			/* Leave interrupts enabled during pseudo-dma I/O */
@@ -30,9 +29,6 @@
 
 /*
  * Options : 
- * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
- *      for commands that return with a CHECK CONDITION status. 
- *
  * PSEUDO_DMA - enables PSEUDO-DMA hardware, should give a 3-4X performance
  * increase compared to polled I/O.
  *
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2014-11-12 16:10:51.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2014-11-12 16:10:57.000000000 +1100
@@ -80,8 +80,6 @@
 #define USLEEP_WAITLONG	500
 
 #define AUTOPROBE_IRQ
-#define AUTOSENSE
-
 
 #ifdef CONFIG_SCSI_GENERIC_NCR53C400
 #define NCR53C400_PSEUDO_DMA 1
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-11-12 16:10:51.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2014-11-12 16:10:57.000000000 +1100
@@ -48,8 +48,6 @@
 #include <scsi/scsi_host.h>
 #include "mac_scsi.h"
 
-/* These control the behaviour of the generic 5380 core */
-#define AUTOSENSE
 #define PSEUDO_DMA
 
 #include "NCR5380.h"
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2014-11-12 16:10:54.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2014-11-12 16:10:57.000000000 +1100
@@ -1,4 +1,3 @@
-#define AUTOSENSE
 #define PSEUDO_DMA
 #define UNSAFE  /* Not unsafe for PAS16 -- use it */
 #define PDEBUG 0
@@ -39,9 +38,6 @@
 
 /*
  * Options : 
- * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
- *      for commands that return with a CHECK CONDITION status. 
- *
  * LIMIT_TRANSFERSIZE - if defined, limit the pseudo-dma transfers to 512
  *      bytes at a time.  Since interrupts are disabled by default during
  *      these transfers, we might need this to give reasonable interrupt
Index: linux/drivers/scsi/sun3_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/sun3_NCR5380.c	2014-11-12 16:10:55.000000000 +1100
+++ linux/drivers/scsi/sun3_NCR5380.c	2014-11-12 16:10:57.000000000 +1100
@@ -629,9 +629,6 @@ static inline void NCR5380_all_init (voi
 static void __init NCR5380_print_options (struct Scsi_Host *instance)
 {
     printk(" generic options"
-#ifdef AUTOSENSE 
-    " AUTOSENSE"
-#endif
 #ifdef REAL_DMA
     " REAL DMA"
 #endif
@@ -788,14 +785,6 @@ static int __init NCR5380_init(struct Sc
 	first_instance = instance;
     }
 	
-
-#ifndef AUTOSENSE
-    if ((instance->cmd_per_lun > 1) || (instance->can_queue > 1))
-	 printk("scsi%d: WARNING : support for multiple outstanding commands enabled\n"
-	        "        without AUTOSENSE option, contingent allegiance conditions may\n"
-	        "        be incorrectly cleared.\n", HOSTNO);
-#endif /* def AUTOSENSE */
-
     NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
     NCR5380_write(MODE_REG, MR_BASE);
     NCR5380_write(TARGET_COMMAND_REG, 0);
@@ -2161,7 +2150,6 @@ static void NCR5380_information_transfer
 		    else if (status_byte(cmd->SCp.Status) != GOOD)
 			cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
 		    
-#ifdef AUTOSENSE
 		    if ((cmd->cmnd[0] == REQUEST_SENSE) &&
 			                        hostdata->ses.cmd_len) {
 			scsi_eh_restore_cmnd(cmd, &hostdata->ses);
@@ -2185,9 +2173,7 @@ static void NCR5380_information_transfer
 		        local_irq_restore(flags);
 			dprintk(NDEBUG_QUEUES, "scsi%d: REQUEST SENSE added to head of "
 				  "issue queue\n", H_NO(cmd));
-		   } else
-#endif /* def AUTOSENSE */
-		   {
+		   } else {
 #ifdef NCR5380_STATS
 		       collect_stats(hostdata, cmd);
 #endif
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-11-12 16:10:51.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-11-12 16:10:57.000000000 +1100
@@ -45,8 +45,6 @@
  * PARITY - enable parity checking.  Not supported.
  */
 
-#define AUTOSENSE
-
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/ctype.h>
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2014-11-12 16:10:54.000000000 +1100
+++ linux/drivers/scsi/t128.c	2014-11-12 16:10:57.000000000 +1100
@@ -1,4 +1,3 @@
-#define AUTOSENSE
 #define PSEUDO_DMA
 
 /*
@@ -40,9 +39,6 @@
 
 /*
  * Options : 
- * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
- *      for commands that return with a CHECK CONDITION status. 
- *
  * PSEUDO_DMA - enables PSEUDO-DMA hardware, should give a 3-4X performance
  * increase compared to polled I/O.
  *


