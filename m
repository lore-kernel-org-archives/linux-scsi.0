From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic7xxx/79xx: fix another potential panic due to a non
	existent target
Date: Fri, 05 Aug 2005 16:24:54 -0500
Message-ID: <1123277094.5003.72.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:57297 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263142AbVHEVY6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 17:24:58 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j75LOsA10018
	for <linux-scsi@vger.kernel.org>; Fri, 5 Aug 2005 17:24:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

I ran into this one sending bus resets across the hardware.

James
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1617,9 +1617,9 @@ ahd_send_async(struct ahd_softc *ahd, ch
 		 * are identical to those last reported.
 		 */
 		starget = ahd->platform_data->starget[target];
-		targ = scsi_transport_target_data(starget);
-		if (targ == NULL)
+		if (starget == NULL)
 			break;
+		targ = scsi_transport_target_data(starget);
 
 		target_ppr_options =
 			(spi_dt(starget) ? MSG_EXT_PPR_DT_REQ : 0)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1614,9 +1614,9 @@ ahc_send_async(struct ahc_softc *ahc, ch
 		if (channel == 'B')
 			target_offset += 8;
 		starget = ahc->platform_data->starget[target_offset];
-		targ = scsi_transport_target_data(starget);
-		if (targ == NULL)
+		if (starget == NULL)
 			break;
+		targ = scsi_transport_target_data(starget);
 
 		target_ppr_options =
 			(spi_dt(starget) ? MSG_EXT_PPR_DT_REQ : 0)



