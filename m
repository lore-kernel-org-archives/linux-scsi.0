From: akpm@linux-foundation.org
Subject: [patch 8/9] scsi: aic79xx aic79xx_pci.c fix shadowed variables
Date: Wed, 14 May 2008 16:23:34 -0700
Message-ID: <200805142323.m4ENNZax026868@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbYENXYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 19:24:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com

From: Harvey Harrison <harvey.harrison@gmail.com>

OK to just reuse the outer declaration as it is never used again.
drivers/scsi/aic7xxx/aic79xx_pci.c:340:12: warning: symbol 'devconfig' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_pci.c:299:12: originally declared here

targpcistat is always assigned just before use, remove the inner declaration.
drivers/scsi/aic7xxx/aic79xx_pci.c:486:9: warning: symbol 'targpcistat' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_pci.c:429:9: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_pci.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables
+++ a/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -337,8 +337,6 @@ ahd_pci_config(struct ahd_softc *ahd, co
 	 * 64bit bus (PCI64BIT set in devconfig).
 	 */
 	if ((ahd->flags & (AHD_39BIT_ADDRESSING|AHD_64BIT_ADDRESSING)) != 0) {
-		uint32_t devconfig;
-
 		if (bootverbose)
 			printf("%s: Enabling 39Bit Addressing\n",
 			       ahd_name(ahd));
@@ -483,8 +481,6 @@ ahd_pci_test_register_access(struct ahd_
 		goto fail;
 
 	if ((ahd_inb(ahd, INTSTAT) & PCIINT) != 0) {
-		u_int targpcistat;
-
 		ahd_set_modes(ahd, AHD_MODE_CFG, AHD_MODE_CFG);
 		targpcistat = ahd_inb(ahd, TARGPCISTAT);
 		if ((targpcistat & STA) != 0)
_
