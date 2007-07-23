From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Enable 16-bit CDBs for aic7xxx/aic79xxx
Date: Mon, 23 Jul 2007 10:47:23 +0200
Message-ID: <46A46B1B.4010306@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070202000902010603020800"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:39671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296AbXGWIrZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jul 2007 04:47:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070202000902010603020800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi James,

this patch enables 16-bit CDBs for aic7xxx and aic79xx. aic7xxx actuallys
supports up to 32-bit CDBs, so it might be that aic79xx does that, too.
But this would include some more hacking, so this is way easier.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------070202000902010603020800
Content-Type: text/plain;
 name="aic7xxx-enable-16byte-cdbs"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx-enable-16byte-cdbs"

Enable 16-bit CDBs for aic7xxx/aix79xx

The patch enables support for 16-bit CDBs in aic7xxx and aic79xx.
aic7xxx can actually support up to 32-bit CDBs, should they ever see
the light of day.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 286ab83..8502085 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1089,6 +1089,7 @@ ahd_linux_register_host(struct ahd_softc *ahd, struct scsi_host_template *templa
 	host->max_id = (ahd->features & AHD_WIDE) ? 16 : 8;
 	host->max_lun = AHD_NUM_LUNS;
 	host->max_channel = 0;
+	host->max_cmd_len = MAX_CDB_LEN;
 	host->sg_tablesize = AHD_NSEG;
 	ahd_lock(ahd, &s);
 	ahd_set_unit(ahd, ahd_linux_unit++);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 1803ab6..a6b3071 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1047,6 +1047,7 @@ ahc_linux_register_host(struct ahc_softc *ahc, struct scsi_host_template *templa
 	host->max_id = (ahc->features & AHC_WIDE) ? 16 : 8;
 	host->max_lun = AHC_NUM_LUNS;
 	host->max_channel = (ahc->features & AHC_TWIN) ? 1 : 0;
+	host->max_cmd_len = 32;
 	host->sg_tablesize = AHC_NSEG;
 	ahc_lock(ahc, &s);
 	ahc_set_unit(ahc, ahc_linux_unit++);

--------------070202000902010603020800--
