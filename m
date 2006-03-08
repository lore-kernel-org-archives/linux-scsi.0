From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/07] aic79xx: use BIOS settings
Date: Wed, 08 Mar 2006 12:59:35 +0100
Message-ID: <440EC727.7020505@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000408040104010901010900"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:3485 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751697AbWCHL7g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 06:59:36 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 13308EE23
	for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2006 12:59:35 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000408040104010901010900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This patch fixes the aic79xx driver to properly respond to BIOS
settings.

Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------000408040104010901010900
Content-Type: text/plain;
 name="06-aic79xx-use-bios-settings.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="06-aic79xx-use-bios-settings.txt"

[PATCH 06/07] aic79xx: use BIOS settings

This patch fixes the aic79xx driver to properly respond to BIOS
settings.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 drivers/scsi/aic7xxx/aic79xx_osm.c |   35 ++++++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 7 deletions(-)

c307cfff586012f91b62f6836c08b301748ea603
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 13b7ac2..7b9dbef 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -481,6 +481,7 @@ ahd_linux_target_alloc(struct scsi_targe
 {
 	struct	ahd_softc *ahd =
 		*((struct ahd_softc **)dev_to_shost(&starget->dev)->hostdata);
+	struct seeprom_config *sc = ahd->seep_config;
 	unsigned long flags;
 	struct scsi_target **ahd_targp = ahd_linux_target_in_softc(starget);
 	struct ahd_linux_target *targ = scsi_transport_target_data(starget);
@@ -496,18 +497,38 @@ ahd_linux_target_alloc(struct scsi_targe
 	*ahd_targp = starget;
 	memset(targ, 0, sizeof(*targ));
 
+	if (sc) {
+		int flags = sc->device_flags[starget->id];
+
+		tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
+					    starget->id, &tstate);
+
+		if ((flags  & CFPACKETIZED) == 0) {
+			/* Do not negotiate packetized transfers */
+			spi_rd_strm(starget) = 0;
+			spi_pcomp_en(starget) = 0;
+			spi_rti(starget) = 0;
+			spi_wr_flow(starget) = 0;
+			spi_hold_mcs(starget) = 0;
+		} else {
+			if ((ahd->features & AHD_RTI) == 0)
+				spi_rti(starget) = 0;
+		}
+
+		if ((flags & CFQAS) == 0)
+			spi_qas(starget) = 0;
+
+		/* Transinfo values have been set to BIOS settings */
+		spi_max_width(starget) = (flags & CFWIDEB) ? 1 : 0;
+		spi_min_period(starget) = tinfo->user.period;
+		spi_max_offset(starget) = tinfo->user.offset;
+	}
+
 	tinfo = ahd_fetch_transinfo(ahd, channel, ahd->our_id,
 				    starget->id, &tstate);
 	ahd_compile_devinfo(&devinfo, ahd->our_id, starget->id,
 			    CAM_LUN_WILDCARD, channel,
 			    ROLE_INITIATOR);
-	spi_min_period(starget) = AHD_SYNCRATE_MAX; /* We can do U320 */
-	if ((ahd->bugs & AHD_PACED_NEGTABLE_BUG) != 0)
-		spi_max_offset(starget) = MAX_OFFSET_PACED_BUG;
-	else
-		spi_max_offset(starget) = MAX_OFFSET_PACED;
-	spi_max_width(starget) = ahd->features & AHD_WIDE;
-
 	ahd_set_syncrate(ahd, &devinfo, 0, 0, 0,
 			 AHD_TRANS_GOAL, /*paused*/FALSE);
 	ahd_set_width(ahd, &devinfo, MSG_EXT_WDTR_BUS_8_BIT,
-- 
1.1.3

--------------000408040104010901010900--
