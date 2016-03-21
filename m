From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 19/23] ncr5380: Update usage documentation
Date: Mon, 21 Mar 2016 13:32:08 +1100
Message-ID: <20160321023154.583991106@telegraphics.com.au>
References: <20160321023149.604138431@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52842 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbcCUEFd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2016 00:05:33 -0400
Content-Disposition: inline; filename=ncr5380-update-documentation
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

Update kernel parameter documentation for atari_scsi, mac_scsi and
g_NCR5380 drivers. Remove duplication.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 Documentation/scsi/g_NCR5380.txt       |   17 ++++++---------
 Documentation/scsi/scsi-parameters.txt |   11 +++++++---
 drivers/scsi/g_NCR5380.c               |   36 ---------------------------------
 3 files changed, 16 insertions(+), 48 deletions(-)

Index: linux/Documentation/scsi/scsi-parameters.txt
===================================================================
--- linux.orig/Documentation/scsi/scsi-parameters.txt	2016-03-21 13:31:06.000000000 +1100
+++ linux/Documentation/scsi/scsi-parameters.txt	2016-03-21 13:31:42.000000000 +1100
@@ -27,13 +27,15 @@ parameters may be changed at runtime by
 	aic79xx=	[HW,SCSI]
 			See Documentation/scsi/aic79xx.txt.
 
-	atascsi=	[HW,SCSI] Atari SCSI
+	atascsi=	[HW,SCSI]
+			See drivers/scsi/atari_scsi.c.
 
 	BusLogic=	[HW,SCSI]
 			See drivers/scsi/BusLogic.c, comment before function
 			BusLogic_ParseDriverOptions().
 
 	dtc3181e=	[HW,SCSI]
+			See Documentation/scsi/g_NCR5380.txt.
 
 	eata=		[HW,SCSI]
 
@@ -51,8 +53,8 @@ parameters may be changed at runtime by
 	ips=		[HW,SCSI] Adaptec / IBM ServeRAID controller
 			See header of drivers/scsi/ips.c.
 
-	mac5380=	[HW,SCSI] Format:
-			<can_queue>,<cmd_per_lun>,<sg_tablesize>,<hostid>,<use_tags>
+	mac5380=	[HW,SCSI]
+			See drivers/scsi/mac_scsi.c.
 
 	max_luns=	[SCSI] Maximum number of LUNs to probe.
 			Should be between 1 and 2^32-1.
@@ -65,10 +67,13 @@ parameters may be changed at runtime by
 			See header of drivers/scsi/NCR_D700.c.
 
 	ncr5380=	[HW,SCSI]
+			See Documentation/scsi/g_NCR5380.txt.
 
 	ncr53c400=	[HW,SCSI]
+			See Documentation/scsi/g_NCR5380.txt.
 
 	ncr53c400a=	[HW,SCSI]
+			See Documentation/scsi/g_NCR5380.txt.
 
 	ncr53c406a=	[HW,SCSI]
 
Index: linux/Documentation/scsi/g_NCR5380.txt
===================================================================
--- linux.orig/Documentation/scsi/g_NCR5380.txt	2016-03-21 13:31:06.000000000 +1100
+++ linux/Documentation/scsi/g_NCR5380.txt	2016-03-21 13:31:42.000000000 +1100
@@ -23,11 +23,10 @@ supported by the driver.
 
 If the default configuration does not work for you, you can use the kernel
 command lines (eg using the lilo append command):
-	ncr5380=port,irq,dma
-	ncr53c400=port,irq
-or
-	ncr5380=base,irq,dma
-	ncr53c400=base,irq
+	ncr5380=addr,irq
+	ncr53c400=addr,irq
+	ncr53c400a=addr,irq
+	dtc3181e=addr,irq
 
 The driver does not probe for any addresses or ports other than those in
 the OVERRIDE or given to the kernel as above.
@@ -36,19 +35,17 @@ This driver provides some information on
 /proc/scsi/g_NCR5380/x where x is the scsi card number as detected at boot
 time. More info to come in the future.
 
-When NCR53c400 support is compiled in, BIOS parameters will be returned by
-the driver (the raw 5380 driver does not and I don't plan to fiddle with
-it!).
-
 This driver works as a module.
 When included as a module, parameters can be passed on the insmod/modprobe
 command line:
   ncr_irq=xx   the interrupt
   ncr_addr=xx  the port or base address (for port or memory
                mapped, resp.)
-  ncr_dma=xx   the DMA
   ncr_5380=1   to set up for a NCR5380 board
   ncr_53c400=1 to set up for a NCR53C400 board
+  ncr_53c400a=1 to set up for a NCR53C400A board
+  dtc_3181e=1  to set up for a Domex Technology Corp 3181E board
+  hp_c2502=1   to set up for a Hewlett Packard C2502 board
 e.g.
 modprobe g_NCR5380 ncr_irq=5 ncr_addr=0x350 ncr_5380=1
   for a port mapped NCR5380 board or
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-03-21 13:31:40.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-03-21 13:31:42.000000000 +1100
@@ -18,42 +18,8 @@
  *
  * Added ISAPNP support for DTC436 adapters,
  * Thomas Sailer, sailer@ife.ee.ethz.ch
- */
-
-/* 
- * TODO : flesh out DMA support, find some one actually using this (I have
- * 	a memory mapped Trantor board that works fine)
- */
-
-/*
- * The card is detected and initialized in one of several ways : 
- * 1.  With command line overrides - NCR5380=port,irq may be 
- *     used on the LILO command line to override the defaults.
- *
- * 2.  With the GENERIC_NCR5380_OVERRIDE compile time define.  This is 
- *     specified as an array of address, irq, dma, board tuples.  Ie, for
- *     one board at 0x350, IRQ5, no dma, I could say  
- *     -DGENERIC_NCR5380_OVERRIDE={{0xcc000, 5, DMA_NONE, BOARD_NCR5380}}
- * 
- * -1 should be specified for no or DMA interrupt, -2 to autoprobe for an 
- * 	IRQ line if overridden on the command line.
  *
- * 3.  When included as a module, with arguments passed on the command line:
- *         ncr_irq=xx	the interrupt
- *         ncr_addr=xx  the port or base address (for port or memory
- *              	mapped, resp.)
- *         ncr_dma=xx	the DMA
- *         ncr_5380=1	to set up for a NCR5380 board
- *         ncr_53c400=1	to set up for a NCR53C400 board
- *     e.g.
- *     modprobe g_NCR5380 ncr_irq=5 ncr_addr=0x350 ncr_5380=1
- *       for a port mapped NCR5380 board or
- *     modprobe g_NCR5380 ncr_irq=255 ncr_addr=0xc8000 ncr_53c400=1
- *       for a memory mapped NCR53C400 board with interrupts disabled.
- * 
- * 255 should be specified for no or DMA interrupt, 254 to autoprobe for an 
- * 	IRQ line if overridden on the command line.
- *     
+ * See Documentation/scsi/g_NCR5380.txt for more info.
  */
 
 #include <asm/io.h>


