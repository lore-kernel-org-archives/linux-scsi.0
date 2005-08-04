From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aic79xx: fixup DT setting
Date: Thu, 04 Aug 2005 09:16:59 +0200
Message-ID: <42F1C0EB.40404@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070606030108030902040101"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51685 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S261940AbVHDHRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2005 03:17:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070606030108030902040101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi James,

this patch is just a cross-port of your fixup for aic7xxx DT settings.
As the same restrictions apply for aic79xx also (DT requires wide
transfers) the dt setting routine should be modified equivalently.
And an invalid period setting will be catched by ahd_find_syncrate() anyw=
ay.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------070606030108030902040101
Content-Type: text/plain;
 name="aic79xx-fix-dt-setting"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx-fix-dt-setting"

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2440,6 +2440,7 @@ static void ahd_linux_set_dt(struct scsi
 	unsigned int ppr_options = tinfo->goal.ppr_options
 		& ~MSG_EXT_PPR_DT_REQ;
 	unsigned int period = tinfo->goal.period;
+	unsigned int width = tinfo->goal.width;
 	unsigned long flags;
 
 #ifdef AHD_DEBUG
@@ -2449,8 +2450,8 @@ static void ahd_linux_set_dt(struct scsi
 #endif
 	if (dt) {
 		ppr_options |= MSG_EXT_PPR_DT_REQ;
-		if (period > 9)
-			period = 9; /* at least 12.5ns for DT */
+		if (!width)
+			ahd_linux_set_width(starget, 1);
 	} else {
 		if (period <= 9)
 			period = 10; /* If resetting DT, period must be >= 25ns */

--------------070606030108030902040101--
