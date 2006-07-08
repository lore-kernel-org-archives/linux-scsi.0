From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] aic7[9x]xx: Remove last vestiges of reverse_scan
Date: Sat, 8 Jul 2006 14:02:26 -0600
Message-ID: <20060708200226.GG1605@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38874 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1030302AbWGHUC1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 16:02:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Remove last vestiges of the reverse_scan paramater from aic7xxx and aic79xx.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: ./drivers/scsi/aic7xxx/aic79xx_osm.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c,v
retrieving revision 1.23
diff -u -p -r1.23 aic79xx_osm.c
--- ./drivers/scsi/aic7xxx/aic79xx_osm.c	6 Jul 2006 12:23:21 -0000	1.23
+++ ./drivers/scsi/aic7xxx/aic79xx_osm.c	8 Jul 2006 20:00:31 -0000
@@ -243,25 +243,6 @@ ahd_print_path(struct ahd_softc *ahd, st
 static uint32_t aic79xx_no_reset;
 
 /*
- * Certain PCI motherboards will scan PCI devices from highest to lowest,
- * others scan from lowest to highest, and they tend to do all kinds of
- * strange things when they come into contact with PCI bridge chips.  The
- * net result of all this is that the PCI card that is actually used to boot
- * the machine is very hard to detect.  Most motherboards go from lowest
- * PCI slot number to highest, and the first SCSI controller found is the
- * one you boot from.  The only exceptions to this are when a controller
- * has its BIOS disabled.  So, we by default sort all of our SCSI controllers
- * from lowest PCI slot number to highest PCI slot number.  We also force
- * all controllers with their BIOS disabled to the end of the list.  This
- * works on *almost* all computers.  Where it doesn't work, we have this
- * option.  Setting this option to non-0 will reverse the order of the sort
- * to highest first, then lowest, but will still leave cards with their BIOS
- * disabled at the very end.  That should fix everyone up unless there are
- * really strange cirumstances.
- */
-static uint32_t aic79xx_reverse_scan;
-
-/*
  * Should we force EXTENDED translation on a controller.
  *     0 == Use whatever is in the SEEPROM or default to off
  *     1 == Use whatever is in the SEEPROM or default to on
@@ -350,7 +331,6 @@ MODULE_PARM_DESC(aic79xx,
 "				periodically to prevent tag starvation.\n"
 "				This may be required by some older disk\n"
 "				or drives/RAID arrays.\n"
-"	reverse_scan		Sort PCI devices highest Bus/Slot to lowest\n"
 "	tag_info:<tag_str>	Set per-target tag depth\n"
 "	global_tag_depth:<int>	Global tag depth for all targets on all buses\n"
 "	slewrate:<slewrate_list>Set the signal slew rate (0-15).\n"
@@ -1031,7 +1011,6 @@ aic79xx_setup(char *s)
 #ifdef AHD_DEBUG
 		{ "debug", &ahd_debug },
 #endif
-		{ "reverse_scan", &aic79xx_reverse_scan },
 		{ "periodic_otag", &aic79xx_periodic_otag },
 		{ "pci_parity", &aic79xx_pci_parity },
 		{ "seltime", &aic79xx_seltime },
Index: ./drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c,v
retrieving revision 1.24
diff -u -p -r1.24 aic7xxx_osm.c
--- ./drivers/scsi/aic7xxx/aic7xxx_osm.c	6 Jul 2006 12:23:21 -0000	1.24
+++ ./drivers/scsi/aic7xxx/aic7xxx_osm.c	8 Jul 2006 20:00:31 -0000
@@ -353,7 +353,6 @@ MODULE_PARM_DESC(aic7xxx,
 "				periodically to prevent tag starvation.\n"
 "				This may be required by some older disk\n"
 "				drives or RAID arrays.\n"
-"	reverse_scan		Sort PCI devices highest Bus/Slot to lowest\n"
 "	tag_info:<tag_str>	Set per-target tag depth\n"
 "	global_tag_depth:<int>	Global tag depth for every target\n"
 "				on every bus\n"
