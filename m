From: Denis Zaitsev <zzz@anda.ru>
Subject: [PATCH][TRIVIAL] (2.4.22) Allow aic7xxx_osm.c to be compiled without CONFIG_PCI
Date: Thu, 25 Sep 2003 15:16:18 +0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030925151618.C15849@natasha.ward.six>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gibbs@scsiguy.com, dledford@redhat.com
List-Id: linux-scsi@vger.kernel.org

This is the trivial #ifdef patch for CONFIG_PCI/EISA.  In my case it
allows the Adaptec SCSI driver (the "new" one) to be compiled for
non-PCI (EISA) system.  Else there are an <undefined symbol> errors.
The 2.6 branch needs the same patch, as I understand.

Please, apply it.  (I don't know who is the maintainer for now!)


--- drivers/scsi/aic7xxx/aic7xxx_osm.c.orig	2003-09-15 01:56:14.000000000 +0600
+++ drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-09-16 22:57:11.000000000 +0600
@@ -1552,6 +1552,7 @@ ahc_softc_comp(struct ahc_softc *lahc, s
 
 	/* Still equal.  Sort by BIOS address, ioport, or bus/slot/func. */
 	switch (rvalue) {
+#ifdef CONFIG_PCI
 	case AHC_PCI:
 	{
 		char primary_channel;
@@ -1584,6 +1585,8 @@ ahc_softc_comp(struct ahc_softc *lahc, s
 			value = 1;
 		break;
 	}
+#endif
+#ifdef CONFIG_EISA
 	case AHC_EISA:
 		if ((rahc->flags & AHC_BIOS_ENABLED) != 0) {
 			value = rahc->platform_data->bios_address
@@ -1593,6 +1596,7 @@ ahc_softc_comp(struct ahc_softc *lahc, s
 			      - lahc->bsh.ioport; 
 		}
 		break;
+#endif
 	default:
 		panic("ahc_softc_sort: invalid bus type");
 	}
