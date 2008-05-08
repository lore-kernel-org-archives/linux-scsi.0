From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 3/3] scsi: aic79xx aic79xx_pci.c fix shadowed variables
Date: Thu, 08 May 2008 12:08:54 -0700
Message-ID: <1210273734.19279.56.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:8221 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbYEHTI6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 15:08:58 -0400
Received: by wf-out-1314.google.com with SMTP id 27so830040wfd.4
        for <linux-scsi@vger.kernel.org>; Thu, 08 May 2008 12:08:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

OK to just reuse the outer declaration as it is never used again.
drivers/scsi/aic7xxx/aic79xx_pci.c:340:12: warning: symbol 'devconfig' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_pci.c:299:12: originally declared here

targpcistat is always assigned just before use, remove the inner declaration.
drivers/scsi/aic7xxx/aic79xx_pci.c:486:9: warning: symbol 'targpcistat' shadows an earlier one
drivers/scsi/aic7xxx/aic79xx_pci.c:429:9: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_pci.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index c25b6ad..9471caf 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -337,8 +337,6 @@ ahd_pci_config(struct ahd_softc *ahd, const struct ahd_pci_identity *entry)
 	 * 64bit bus (PCI64BIT set in devconfig).
 	 */
 	if ((ahd->flags & (AHD_39BIT_ADDRESSING|AHD_64BIT_ADDRESSING)) != 0) {
-		uint32_t devconfig;
-
 		if (bootverbose)
 			printf("%s: Enabling 39Bit Addressing\n",
 			       ahd_name(ahd));
@@ -483,8 +481,6 @@ ahd_pci_test_register_access(struct ahd_softc *ahd)
 		goto fail;
 
 	if ((ahd_inb(ahd, INTSTAT) & PCIINT) != 0) {
-		u_int targpcistat;
-
 		ahd_set_modes(ahd, AHD_MODE_CFG, AHD_MODE_CFG);
 		targpcistat = ahd_inb(ahd, TARGPCISTAT);
 		if ((targpcistat & STA) != 0)
-- 
1.5.5.1.404.g981f6

