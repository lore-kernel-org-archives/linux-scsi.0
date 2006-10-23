From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] aic79xx: Print out signalling
Date: Mon, 23 Oct 2006 15:26:37 +0200
Message-ID: <453CC30D.7000406@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010807070002050503050508"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39564 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S964843AbWJWN0j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Oct 2006 09:26:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010807070002050503050508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

as aic7xxx already prints out the signalling we should do it for aic79xx 
also.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------010807070002050503050508
Content-Type: text/plain;
 name="0004-aic79xx-expose-the-bus-settings-to-sysfs.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0004-aic79xx-expose-the-bus-settings-to-sysfs.txt"

From: Hannes Reinecke <hare@suse.de>
Date: Mon Oct 23 12:57:57 2006 +0200
Subject: aic79xx: expose the bus settings to sysfs

This is a cross-post of a similar patch for aic7xxx;
only it's a bit simpler here as we don't support HVD
and all controller actually implement this register.
I hope.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 drivers/scsi/aic7xxx/aic79xx_osm.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

1b8d86e6da593f28026986be12cd406789eb5ddc
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index d5375db..c43650e 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2692,7 +2692,25 @@ static void ahd_linux_set_hold_mcs(struc
 	ahd_unlock(ahd, &flags);
 }
 
+static void ahd_linux_get_signalling(struct Scsi_Host *shost)
+{
+	struct ahd_softc *ahd = *(struct ahd_softc **)shost->hostdata;
+	unsigned long flags;
+	u8 mode;
 
+	ahd_lock(ahd, &flags);
+	ahd_pause(ahd);
+	mode = ahd_inb(ahd, SBLKCTL);
+	ahd_unpause(ahd);
+	ahd_unlock(ahd, &flags);
+
+	if (mode & ENAB40)
+		spi_signalling(shost) = SPI_SIGNAL_LVD;
+	else if (mode & ENAB20)
+		spi_signalling(shost) = SPI_SIGNAL_SE;
+	else
+		spi_signalling(shost) = SPI_SIGNAL_UNKNOWN;
+}
 
 static struct spi_function_template ahd_linux_transport_functions = {
 	.set_offset	= ahd_linux_set_offset,
@@ -2717,6 +2735,7 @@ static struct spi_function_template ahd_
 	.show_pcomp_en	= 1,
 	.set_hold_mcs	= ahd_linux_set_hold_mcs,
 	.show_hold_mcs	= 1,
+	.get_signalling = ahd_linux_get_signalling,
 };
 
 static int __init
-- 
1.3.1


--------------010807070002050503050508--
