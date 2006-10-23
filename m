From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] aic79xx: set precompensation
Date: Mon, 23 Oct 2006 15:24:23 +0200
Message-ID: <453CC287.3000300@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010706070309030605000008"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:1164 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S964840AbWJWNYZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Oct 2006 09:24:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010706070309030605000008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi all,

we really should update the IOCELL chip whenever we change the 
precompensation.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------010706070309030605000008
Content-Type: text/plain;
 name="0002-aic79xx-Set-precompensation-correctly.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-aic79xx-Set-precompensation-correctly.txt"

From: Hannes Reinecke <hare@suse.de>
Date: Mon Oct 23 11:02:57 2006 +0200
Subject: aic79xx: Set precompensation correctly

aic79xx has a special 'iocell' chip which handles the precompensation.
If it's set via DV we should make sure to set the chip correctly, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 drivers/scsi/aic7xxx/aic79xx_osm.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

2f3de401cc38fa20f861470c035a7d088bc23ede
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index f8e6048..d5375db 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2634,8 +2634,22 @@ #ifdef AHD_DEBUG
 		       pcomp ? "Enable" : "Disable");
 #endif
 
-	if (pcomp)
+	if (pcomp) {
+		uint8_t precomp;
+
+		if (ahd->unit < ARRAY_SIZE(aic79xx_iocell_info)) {
+			struct ahd_linux_iocell_opts *iocell_opts;
+
+			iocell_opts = &aic79xx_iocell_info[ahd->unit];
+			precomp = iocell_opts->precomp;
+		} else {
+			precomp = AIC79XX_DEFAULT_PRECOMP;
+		}
 		ppr_options |= MSG_EXT_PPR_PCOMP_EN;
+		AHD_SET_PRECOMP(ahd, precomp);
+	} else {
+		AHD_SET_PRECOMP(ahd, 0);
+	}
 
 	ahd_compile_devinfo(&devinfo, shost->this_id, starget->id, 0,
 			    starget->channel + 'A', ROLE_INITIATOR);
-- 
1.3.1


--------------010706070309030605000008--
