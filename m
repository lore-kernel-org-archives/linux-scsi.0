From: Matthew Wilcox <willy@debian.org>
Subject: [PATCH] ncr & sym1 patches
Date: Sat, 30 Aug 2003 20:08:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030830190823.GN13467@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:56217 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262008AbTH3TIY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Aug 2003 15:08:24 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.22)
	id 19tB5D-0003pn-IM
	for linux-scsi@vger.kernel.org; Sat, 30 Aug 2003 20:08:23 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Some misc sym1 and ncr driver changes.

Changelog:
 - Kconfig: Delete sym1 driver from Kconfig
 - Kconfig: Delete SCSI_NCR53C8XX_IOMAPPED, SCSI_NCR53C8XX_PQS_PDS
   and SCSI_NCR53C8XX_SYMBIOS_COMPAT options.
 - ncr53c8xx: Delete SCSI_NCR53C8XX_SYMBIOS_COMPAT option

Index: drivers/scsi/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/Kconfig,v
retrieving revision 1.1
retrieving revision 1.3
diff -u -p -r1.1 -r1.3
--- drivers/scsi/Kconfig	29 Jul 2003 17:01:28 -0000	1.1
+++ drivers/scsi/Kconfig	25 Aug 2003 19:49:06 -0000	1.3
@@ -989,36 +989,9 @@ config SCSI_NCR_Q720
 	  Unless you have an NCR manufactured machine, the chances are that
 	  you do not have this SCSI card, so say N.
 
-config SCSI_SYM53C8XX
-	tristate "SYM53C8XX SCSI support"
-	depends on PCI && SCSI_SYM53C8XX_2!=y && SCSI
-	---help---
-	  This driver supports all the features of recent 53C8XX chips (used
-	  in PCI SCSI controllers), notably the hardware phase mismatch
-	  feature of the SYM53C896.
-
-	  Older versions of the 53C8XX chips are not supported by this
-	  driver.  If your system uses either a 810 rev. < 16, a 815, or a 825
-	  rev. < 16 PCI SCSI processor, you must use the generic NCR53C8XX
-	  driver ("NCR53C8XX SCSI support" above) or configure both the
-	  NCR53C8XX and this SYM53C8XX drivers either as module or linked to
-	  the kernel image.
-
-	  When both drivers are linked into the kernel, the SYM53C8XX driver
-	  is called first at initialization and you can use the 'excl=ioaddr'
-	  driver boot option to exclude attachment of adapters by the
-	  SYM53C8XX driver.  For example, entering
-	  'sym53c8xx=excl:0xb400,excl=0xc000' at the lilo prompt prevents
-	  adapters at io address 0xb400 and 0xc000 from being attached by the
-	  SYM53C8XX driver, thus allowing the NCR53C8XX driver to attach them.
-	  The 'excl' option is also supported by the NCR53C8XX driver.
-
-	  Please read <file:Documentation/scsi/ncr53c8xx.txt> for more
-	  information.
-
 config SCSI_NCR53C8XX_DEFAULT_TAGS
 	int "  default tagged command queue depth"
-	depends on (SCSI_SYM53C8XX || SCSI_ZALON || SCSI_NCR_Q720)
+	depends on SCSI_ZALON || SCSI_NCR_Q720
 	default "8"
 	---help---
 	  "Tagged command queuing" is a feature of SCSI-2 which improves
@@ -1044,7 +1017,7 @@ config SCSI_NCR53C8XX_DEFAULT_TAGS
 
 config SCSI_NCR53C8XX_MAX_TAGS
 	int "  maximum number of queued commands"
-	depends on (SCSI_SYM53C8XX || SCSI_ZALON || SCSI_NCR_Q720)
+	depends on SCSI_ZALON || SCSI_NCR_Q720
 	default "32"
 	---help---
 	  This option allows you to specify the maximum number of commands
@@ -1061,7 +1034,7 @@ config SCSI_NCR53C8XX_MAX_TAGS
 
 config SCSI_NCR53C8XX_SYNC
 	int "  synchronous transfers frequency in MHz"
-	depends on (SCSI_SYM53C8XX || SCSI_ZALON || SCSI_NCR_Q720)
+	depends on SCSI_ZALON || SCSI_NCR_Q720
 	default "20"
 	---help---
 	  The SCSI Parallel Interface-2 Standard defines 5 classes of transfer
@@ -1095,7 +1068,7 @@ config SCSI_NCR53C8XX_SYNC
 
 config SCSI_NCR53C8XX_PROFILE
 	bool "  enable profiling"
-	depends on (SCSI_SYM53C8XX || SCSI_ZALON || SCSI_NCR_Q720)
+	depends on SCSI_ZALON || SCSI_NCR_Q720
 	help
 	  This option allows you to enable profiling information gathering.
 	  These statistics are not very accurate due to the low frequency
@@ -1104,60 +1077,15 @@ config SCSI_NCR53C8XX_PROFILE
 
 	  The normal answer therefore is N.
 
-config SCSI_NCR53C8XX_IOMAPPED
-	bool "  use normal IO"
-	depends on SCSI_SYM53C8XX && !(SCSI_ZALON || SCSI_NCR_Q720)
-	help
-	  If you say Y here, the driver will use normal IO, as opposed to
-	  memory mapped IO. Memory mapped IO has less latency than normal IO
-	  and works for most Intel-based hardware. Under Linux/Alpha only
-	  normal IO is currently supported by the driver and so, this option
-	  has no effect on those systems.
-
-	  The normal answer therefore is N; try Y only if you encounter SCSI
-	  related problems.
-
-config SCSI_NCR53C8XX_PQS_PDS
-	bool "  include support for the NCR PQS/PDS SCSI card"
-	depends on SCSI_SYM53C8XX
-	help
-	  Say Y here if you have a special SCSI adapter produced by NCR
-	  corporation called a PCI Quad SCSI or PCI Dual SCSI. You do not need
-	  this if you do not have one of these adapters. However, since this
-	  device is detected as a specific PCI device, this option is quite
-	  safe.
-
-	  The common answer here is N, but answering Y is safe.
-
 config SCSI_NCR53C8XX_NO_DISCONNECT
 	bool "  not allow targets to disconnect"
-	depends on (SCSI_SYM53C8XX || SCSI_ZALON || SCSI_NCR_Q720) && SCSI_NCR53C8XX_DEFAULT_TAGS=0
+	depends on (SCSI_ZALON || SCSI_NCR_Q720) && SCSI_NCR53C8XX_DEFAULT_TAGS=0
 	help
 	  This option is only provided for safety if you suspect some SCSI
 	  device of yours to not support properly the target-disconnect
 	  feature. In that case, you would say Y here. In general however, to
 	  not allow targets to disconnect is not reasonable if there is more
 	  than 1 device on a SCSI bus. The normal answer therefore is N.
-
-config SCSI_NCR53C8XX_SYMBIOS_COMPAT
-	bool "  assume boards are SYMBIOS compatible (EXPERIMENTAL)"
-	depends on (SCSI_SYM53C8XX || SCSI_ZALON || SCSI_NCR_Q720 ) && EXPERIMENTAL
-	---help---
-	  This option allows you to enable some features depending on GPIO
-	  wiring. These General Purpose Input/Output pins can be used for
-	  vendor specific features or implementation of the standard SYMBIOS
-	  features. Genuine SYMBIOS controllers use GPIO0 in output for
-	  controller LED and GPIO3 bit as a flag indicating
-	  singled-ended/differential interface. The Tekram DC-390U/F boards
-	  uses a different GPIO wiring.
-
-	  Your answer to this question is ignored if all your controllers have
-	  NVRAM, since the driver is able to detect the board type from the
-	  NVRAM format.
-
-	  If all the controllers in your system are genuine SYMBIOS boards or
-	  use BIOS and drivers from SYMBIOS, you would want to say Y here,
-	  otherwise N. N is the safe answer.
 
 config SCSI_MCA_53C9X
 	tristate "NCR MCA 53C9x SCSI support"
Index: drivers/scsi/sym53c8xx_defs.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_defs.h,v
retrieving revision 1.1
retrieving revision 1.2
diff -u -p -r1.1 -r1.2
--- drivers/scsi/sym53c8xx_defs.h	29 Jul 2003 17:01:30 -0000	1.1
+++ drivers/scsi/sym53c8xx_defs.h	25 Aug 2003 19:49:06 -0000	1.2
@@ -259,17 +259,6 @@
 #endif
 
 /*
- * Vendor specific stuff
- */
-#ifdef CONFIG_SCSI_NCR53C8XX_SYMBIOS_COMPAT
-#define SCSI_NCR_SETUP_LED_PIN		(1)
-#define SCSI_NCR_SETUP_DIFF_SUPPORT	(4)
-#else
-#define SCSI_NCR_SETUP_LED_PIN		(0)
-#define SCSI_NCR_SETUP_DIFF_SUPPORT	(0)
-#endif
-
-/*
  * Settle time after reset at boot-up
  */
 #define SCSI_NCR_SETUP_SETTLE_TIME	(2)
@@ -926,10 +915,10 @@ struct ncr_driver_setup {
 	SCSI_NCR_SETUP_DEFAULT_SYNC,		\
 	0x00,					\
 	7,					\
-	SCSI_NCR_SETUP_LED_PIN,			\
+	0,					\
 	1,					\
 	SCSI_NCR_SETUP_SETTLE_TIME,		\
-	SCSI_NCR_SETUP_DIFF_SUPPORT,		\
+	0,					\
 	0,					\
 	1,					\
 	0,					\

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
