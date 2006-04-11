From: akpm@osdl.org
Subject: [patch 14/15] aic7xxx: ahc_pci_write_config() fix
Date: Mon, 10 Apr 2006 23:27:19 -0700
Message-ID: <200604110728.k3B7S1I7015361@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:2697 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932287AbWDKH3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 03:29:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, vda@ilport.com.ua


From: Denis Vlasenko <vda@ilport.com.ua>

Fix ahc_pci_write_config's (wrong order of arguments).

Signed-off-by: Denis Vlasenko <vda@ilport.com.ua>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic7xxx_pci.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_pci.c~aic7xxx-ahc_pci_write_config-fix drivers/scsi/aic7xxx/aic7xxx_pci.c
--- devel/drivers/scsi/aic7xxx/aic7xxx_pci.c~aic7xxx-ahc_pci_write_config-fix	2006-04-10 00:19:55.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic7xxx_pci.c	2006-04-10 00:19:55.000000000 -0700
@@ -2036,12 +2036,12 @@ ahc_pci_resume(struct ahc_softc *ahc)
 	 * that the OS doesn't know about and rely on our chip
 	 * reset handler to handle the rest.
 	 */
-	ahc_pci_write_config(ahc->dev_softc, DEVCONFIG, /*bytes*/4,
-			     ahc->bus_softc.pci_softc.devconfig);
-	ahc_pci_write_config(ahc->dev_softc, PCIR_COMMAND, /*bytes*/1,
-			     ahc->bus_softc.pci_softc.command);
-	ahc_pci_write_config(ahc->dev_softc, CSIZE_LATTIME, /*bytes*/1,
-			     ahc->bus_softc.pci_softc.csize_lattime);
+	ahc_pci_write_config(ahc->dev_softc, DEVCONFIG,
+			     ahc->bus_softc.pci_softc.devconfig, /*bytes*/4);
+	ahc_pci_write_config(ahc->dev_softc, PCIR_COMMAND,
+			     ahc->bus_softc.pci_softc.command, /*bytes*/1);
+	ahc_pci_write_config(ahc->dev_softc, CSIZE_LATTIME,
+			     ahc->bus_softc.pci_softc.csize_lattime, /*bytes*/1);
 	if ((ahc->flags & AHC_HAS_TERM_LOGIC) != 0) {
 		struct	seeprom_descriptor sd;
 		u_int	sxfrctl1;
_
