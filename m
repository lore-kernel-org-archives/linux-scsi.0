From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] Remove CONFIG_SCSI_DC390T_NOGENSUPP
Date: Thu, 5 Feb 2004 13:43:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040205124303.GA18046@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:38822 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265228AbUBEMnM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 07:43:12 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Now that the Am53C974 driver is gone it doesn't make sense to not
support all Am53C974-based cards, and the amount of code under the ifdef
is tiny anyways.


--- 1.53/drivers/scsi/Kconfig	Mon Feb  2 21:51:02 2004
+++ edited/drivers/scsi/Kconfig	Wed Feb  4 03:57:04 2004
@@ -1250,28 +1250,9 @@
 
 	  Note that this driver does NOT support Tekram DC390W/U/F, which are
 	  based on NCR/Symbios chips. Use "NCR53C8XX SCSI support" for those.
-	  Also note that there is another generic Am53C974 driver,
-	  "AM53/79C974 PCI SCSI support" below.  You can pick either one.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called tmscsim.
-
-config SCSI_DC390T_NOGENSUPP
-	bool "_omit_ support for non-DC390 adapters"
-	depends on SCSI_DC390T
-	---help---
-	  If you say N here, the DC390(T) SCSI driver relies on the DC390
-	  EEPROM to get initial values for its settings, such as speed,
-	  termination, etc.  If it can't find this EEPROM, it will use
-	  defaults or the user supplied boot/module parameters.  For details
-	  on driver configuration see <file:Documentation/scsi/tmscsim.txt>.
-
-	  If you say Y here and if no EEPROM is found, the driver gives up and
-	  thus only supports Tekram DC390(T) adapters.  This can be useful if
-	  you have a DC390(T) and another Am53C974 based adapter, which, for
-	  some reason, you want to drive with the other AM53C974 driver.
-
-	  If unsure, say N.
 
 config SCSI_T128
 	tristate "Trantor T128/T128F/T228 SCSI support"
--- 1.25/drivers/scsi/tmscsim.c	Fri Dec 19 16:53:43 2003
+++ edited/drivers/scsi/tmscsim.c	Wed Feb  4 03:57:39 2004
@@ -518,7 +518,6 @@
 }
 
 
-#ifndef CONFIG_SCSI_DC390T_NOGENSUPP
 int __initdata tmscsim_def[] = {7, 0 /* 10MHz */,
 		PARITY_CHK_ | SEND_START_ | EN_DISCONNECT_
 		| SYNC_NEGO_ | TAG_QUEUEING_,
@@ -546,7 +545,6 @@
 	if (tmscsim[4] >   5) tmscsim[4] =   4;
 	if (tmscsim[5] > 180) tmscsim[5] = 180;
 }
-#endif
 
 /* Override defaults on cmdline:
  * tmscsim: AdaptID, MaxSpeed (Index), DevMode (Bitmapped), AdaptMode (Bitmapped)
@@ -2105,10 +2103,6 @@
     
     if (dc390_CheckEEpromCheckSum (PDEV, index))
     {
-#ifdef CONFIG_SCSI_DC390T_NOGENSUPP
-	printk (KERN_ERR "DC390_init: No EEPROM found!\n");
-	return( -1 );
-#else
 	int speed;
 	dc390_adapname = "AM53C974";
 	printk (KERN_INFO "DC390_init: No EEPROM found! Trying default settings ...\n");
@@ -2120,7 +2114,6 @@
 		" DevMode=0x%02x, AdaptMode=0x%02x, TaggedCmnds=%i (%i), DelayReset=%is\n", 
 		tmscsim[0], tmscsim[1], speed/10, speed%10,
 		(UCHAR)tmscsim[2], (UCHAR)tmscsim[3], tmscsim[4], 2 << (tmscsim[4]), tmscsim[5]);
-#endif
     }
     else
     {
