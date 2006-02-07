From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] aic79xx: Remove dead code
Date: Tue, 07 Feb 2006 08:54:10 +0100
Message-ID: <43E85222.50207@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010701050100070402090208"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:22451 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S965000AbWBGHyL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 02:54:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "emmanuel.fuste" <emmanuel.fuste@laposte.net>

This is a multi-part message in MIME format.
--------------010701050100070402090208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This patch removes some dead code.

Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------010701050100070402090208
Content-Type: text/plain;
 name="0003-aic79xx-Remove-dead-code.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0003-aic79xx-Remove-dead-code.txt"

Subject: [PATCH 3/3] aic79xx: Remove dead code

This patch removes some dead code.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 drivers/scsi/aic7xxx/aic79xx_core.c |    1 -
 drivers/scsi/aic7xxx/aic79xx_osm.c  |   59 -----------------------------------
 drivers/scsi/aic7xxx/aic79xx_osm.h  |    2 -
 3 files changed, 0 insertions(+), 62 deletions(-)

dc28b7528833db6b56c172682445c2ccb32aa11f
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 342f779..e1bd0fd 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -7094,7 +7094,6 @@ ahd_pause_and_flushwork(struct ahd_softc
 
 	ahd_flush_qoutfifo(ahd);
 
-	ahd_platform_flushwork(ahd);
 	ahd->flags &= ~AHD_ALL_INTERRUPTS;
 }
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index be40681..4533b9e 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -806,59 +806,6 @@ ahd_dmamap_unload(struct ahd_softc *ahd,
 }
 
 /********************* Platform Dependent Functions ***************************/
-/*
- * Compare "left hand" softc with "right hand" softc, returning:
- * < 0 - lahd has a lower priority than rahd
- *   0 - Softcs are equal
- * > 0 - lahd has a higher priority than rahd
- */
-int
-ahd_softc_comp(struct ahd_softc *lahd, struct ahd_softc *rahd)
-{
-	int	value;
-
-	/*
-	 * Under Linux, cards are ordered as follows:
-	 *	1) PCI devices that are marked as the boot controller.
-	 *	2) PCI devices with BIOS enabled sorted by bus/slot/func.
-	 *	3) All remaining PCI devices sorted by bus/slot/func.
-	 */
-#if 0
-	value = (lahd->flags & AHD_BOOT_CHANNEL)
-	      - (rahd->flags & AHD_BOOT_CHANNEL);
-	if (value != 0)
-		/* Controllers set for boot have a *higher* priority */
-		return (value);
-#endif
-
-	value = (lahd->flags & AHD_BIOS_ENABLED)
-	      - (rahd->flags & AHD_BIOS_ENABLED);
-	if (value != 0)
-		/* Controllers with BIOS enabled have a *higher* priority */
-		return (value);
-
-	/* Still equal.  Sort by bus/slot/func. */
-	if (aic79xx_reverse_scan != 0)
-		value = ahd_get_pci_bus(lahd->dev_softc)
-		      - ahd_get_pci_bus(rahd->dev_softc);
-	else
-		value = ahd_get_pci_bus(rahd->dev_softc)
-		      - ahd_get_pci_bus(lahd->dev_softc);
-	if (value != 0)
-		return (value);
-	if (aic79xx_reverse_scan != 0)
-		value = ahd_get_pci_slot(lahd->dev_softc)
-		      - ahd_get_pci_slot(rahd->dev_softc);
-	else
-		value = ahd_get_pci_slot(rahd->dev_softc)
-		      - ahd_get_pci_slot(lahd->dev_softc);
-	if (value != 0)
-		return (value);
-
-	value = rahd->channel - lahd->channel;
-	return (value);
-}
-
 static void
 ahd_linux_setup_iocell_info(u_long index, int instance, int targ, int32_t value)
 {
@@ -1602,12 +1549,6 @@ ahd_linux_isr(int irq, void *dev_id, str
 }
 
 void
-ahd_platform_flushwork(struct ahd_softc *ahd)
-{
-
-}
-
-void
 ahd_send_async(struct ahd_softc *ahd, char channel,
 	       u_int target, u_int lun, ac_code code, void *arg)
 {
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 1f60590..fc00def 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -875,8 +875,6 @@ int	ahd_platform_abort_scbs(struct ahd_s
 				role_t role, uint32_t status);
 irqreturn_t
 	ahd_linux_isr(int irq, void *dev_id, struct pt_regs * regs);
-void	ahd_platform_flushwork(struct ahd_softc *ahd);
-int	ahd_softc_comp(struct ahd_softc *, struct ahd_softc *);
 void	ahd_done(struct ahd_softc*, struct scb*);
 void	ahd_send_async(struct ahd_softc *, char channel,
 		       u_int target, u_int lun, ac_code, void *);
-- 
1.1.3

--------------010701050100070402090208--
