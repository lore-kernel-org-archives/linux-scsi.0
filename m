From: Matthew Wilcox <willy@debian.org>
Subject: The death of CONFIG_SCSI_NCR53C7xx
Date: Thu, 29 May 2003 19:58:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030529185846.GC28581@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:34491 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262494AbTE2Sp2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 14:45:28 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.14)
	id 19LSbu-00023C-Ae
	for linux-scsi@vger.kernel.org; Thu, 29 May 2003 19:58:46 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Looks to me like there's some vestiges of his option hanging around but
it's not really used.  This is 2.5.70:

linux-2.5$ find -type f |xargs grep SCSI_NCR53C7xx
(skip the defconfigs... they're all "is not set")
./drivers/scsi/53c7xx.c:#ifdef CONFIG_SCSI_NCR53C7xx_FAST
./drivers/scsi/Kconfig:config SCSI_NCR53C7xx
./drivers/scsi/Kconfig:config SCSI_NCR53C7xx_sync
./drivers/scsi/Kconfig: depends on SCSI_NCR53C7xx
./drivers/scsi/Kconfig:config SCSI_NCR53C7xx_FAST
./drivers/scsi/Kconfig: depends on SCSI_NCR53C7xx
./drivers/scsi/Kconfig:config SCSI_NCR53C7xx_DISCONNECT
./drivers/scsi/Kconfig: depends on SCSI_NCR53C7xx

There are two problems here.  One is that there's a bunch of useless
Kconfig options hanging around; the other is that all the m68k people
don't get the option to run at 10MB/s because they'd have to enable an
option which doesn't exist any more.

Here's a patch.

Index: drivers/scsi/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.5/drivers/scsi/Kconfig,v
retrieving revision 1.13
diff -u -p -r1.13 Kconfig
--- drivers/scsi/Kconfig	27 May 2003 17:25:20 -0000	1.13
+++ drivers/scsi/Kconfig	29 May 2003 18:51:18 -0000
@@ -876,60 +876,6 @@ config 53C700_LE_ON_BE
 	depends on SCSI_LASI700
 	default y
 
-config SCSI_NCR53C7xx
-	tristate "NCR53c7,8xx SCSI support"
-	depends on SCSI && PCI
-	---help---
-	  This is a driver for the 53c7 and 8xx NCR family of SCSI
-	  controllers, not to be confused with the NCR 5380 controllers.  It
-	  is explained in section 3.8 of the SCSI-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
-	  of the box, you may have to change some settings in
-	  <file:drivers/scsi/53c7,8xx.h>.  Please read
-	  <file:Documentation/scsi/ncr53c7xx.txt> for the available boot time
-	  command line options.
-
-	  Note: there is another driver for the 53c8xx family of controllers
-	  ("NCR53C8XX SCSI support" below).  If you want to use them both, you
-	  need to say M to both and build them as modules, but only one may be
-	  active at a time. If you have a 53c8xx board, it's better to use the
-	  other driver.
-
-	  This driver is also available as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want).
-	  The module will be called 53c7,8xx.  If you want to compile it as
-	  a module, say M here and read <file:Documentation/modules.txt>.
-
-config SCSI_NCR53C7xx_sync
-	bool "always negotiate synchronous transfers"
-	depends on SCSI_NCR53C7xx
-	help
-	  In general, this is good; however, it is a bit dangerous since there
-	  are some broken SCSI devices out there. Take your chances. Safe bet
-	  is N.
-
-config SCSI_NCR53C7xx_FAST
-	bool "allow FAST-SCSI [10MHz]"
-	depends on SCSI_NCR53C7xx
-	help
-	  This will enable 10MHz FAST-SCSI transfers with your host
-	  adapter. Some systems have problems with that speed, so it's safest
-	  to say N here.
-
-config SCSI_NCR53C7xx_DISCONNECT
-	bool "allow DISCONNECT"
-	depends on SCSI_NCR53C7xx
-	help
-	  This enables the disconnect/reconnect feature of the NCR SCSI
-	  controller. When you say Y here, a slow SCSI device will not lock
-	  the SCSI bus while processing a request, allowing simultaneous use
-	  of e.g. a SCSI hard disk and SCSI tape or CD-ROM drive, and
-	  providing much better performance when using slow and fast SCSI
-	  devices at the same time. Some devices, however, do not operate
-	  properly with this option enabled, and will cause your SCSI system
-	  to hang, which might cause a system crash. The safe answer
-	  therefore is to say N.
-
 config SCSI_SYM53C8XX_2
 	tristate "SYM53C8XX Version 2 SCSI support"
 	depends on PCI && SCSI
@@ -1715,6 +1634,14 @@ config BLZ603EPLUS_SCSI
 	help
 	  If you have an Amiga 1200 with a Phase5 Blizzard PowerUP 603e+
 	  accelerator, say Y. Otherwise, say N.
+
+config SCSI_NCR53C7xx_FAST
+	bool "allow FAST-SCSI [10MHz]"
+	depends on A4000T_SCSI || A4091_SCSI || BLZ603EPLUS_SCSI || WARPENGINE_SCSI || MVME16x_SCSI || BVME6000_SCSI
+	help
+	  This will enable 10MHz FAST-SCSI transfers with your host
+	  adapter. Some systems have problems with that speed, so it's safest
+	  to say N here.
 
 config OKTAGON_SCSI
 	tristate "BSC Oktagon SCSI support (EXPERIMENTAL)"

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
