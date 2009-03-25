From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] aic7xxx leaves timer running on init failure
Date: Wed, 25 Mar 2009 11:19:37 +0100
Message-ID: <20090325101937.EC23518C607@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36498 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZCYKTk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 06:19:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


aic79xx leaves timers inserted when ahd_init() (which inserts
two timers at its very end) succeeds but ahd_pci_map_int()
fails. In this case ahd->init_level gets incremented to 5 only
when that function succeeds, but ahd_free() calls ahd_shutdown()
only when ahd->init_level == 5, and ahd_shutdown() is where the
timers get removed. Since the freeing of the IRQ is not controlled
by ahd->init_level, we should increment init_level prior to
calling ahd_pci_map_int().

Reported-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aic7xxx/aic79xx_pci.c |    6 ++----
 drivers/scsi/aic7xxx/aic7xxx_pci.c |    8 ++------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index a734d77..b8423c4 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -377,14 +377,12 @@ ahd_pci_config(struct ahd_softc *ahd, const struct ahd_pci_identity *entry)
 	error = ahd_init(ahd);
 	if (error != 0)
 		return (error);
+	ahd->init_level++;
 
 	/*
 	 * Allow interrupts now that we are completely setup.
 	 */
-	error = ahd_pci_map_int(ahd);
-	if (!error)
-		ahd->init_level++;
-	return error;
+	return ahd_pci_map_int(ahd);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index c07cb6e..4347c8d 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -960,16 +960,12 @@ ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry)
 	error = ahc_init(ahc);
 	if (error != 0)
 		return (error);
+	ahc->init_level++;
 
 	/*
 	 * Allow interrupts now that we are completely setup.
 	 */
-	error = ahc_pci_map_int(ahc);
-	if (error != 0)
-		return (error);
-
-	ahc->init_level++;
-	return (0);
+	return ahc_pci_map_int(ahc);
 }
 
 /*
-- 
1.5.3.2

