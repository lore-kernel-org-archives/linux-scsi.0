From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/07] aic79xx: use tcq functions
Date: Wed, 08 Mar 2006 12:56:56 +0100
Message-ID: <440EC688.3040702@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050500010600020502030901"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:63205 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751234AbWCHL44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 06:56:56 -0500
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id DB60A1D82E
	for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2006 12:56:55 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050500010600020502030901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This patch converts aic79xx to use the midlayer-supplied tcq
functions.

We also set the queuedepth to '1' if tcq is disabled; the
aic79xx driver gets confused otherwise. Will set it back to
'2' once I figure out how to queue requests in the driver.

Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------050500010600020502030901
Content-Type: text/plain;
 name="02-aic79xx-use-tcq-functions.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-aic79xx-use-tcq-functions.txt"

[PATCH 02/07] aic79xx: use tcq functions

This patch converts aic79xx to use the midlayer-supplied tcq
functions.

We also set the queuedepth to '1' if tcq is disabled; the
aic79xx driver gets confused otherwise. Will set it back to
'2' once I figure out how to queue requests in the driver.

Signed-off-by: Hannes Reinecke <hare@suse.de>

---

 drivers/scsi/aic7xxx/aic79xx_osm.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

2cb1ba5e7ad88ae1353f9d0804bdb46244050962
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index bd2be6a..be40681 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1342,14 +1342,12 @@ ahd_platform_set_tags(struct ahd_softc *
 
 	switch ((dev->flags & (AHD_DEV_Q_BASIC|AHD_DEV_Q_TAGGED))) {
 	case AHD_DEV_Q_BASIC:
-		scsi_adjust_queue_depth(sdev,
-					MSG_SIMPLE_TASK,
-					dev->openings + dev->active);
+		scsi_set_tag_type(sdev, MSG_SIMPLE_TASK);
+		scsi_activate_tcq(sdev, dev->openings + dev->active);
 		break;
 	case AHD_DEV_Q_TAGGED:
-		scsi_adjust_queue_depth(sdev,
-					MSG_ORDERED_TASK,
-					dev->openings + dev->active);
+		scsi_set_tag_type(sdev, MSG_ORDERED_TASK);
+		scsi_activate_tcq(sdev, dev->openings + dev->active);
 		break;
 	default:
 		/*
@@ -1358,9 +1356,7 @@ ahd_platform_set_tags(struct ahd_softc *
 		 * serially on the controller/device.  This should
 		 * remove some latency.
 		 */
-		scsi_adjust_queue_depth(sdev,
-					/*NON-TAGGED*/0,
-					/*queue depth*/2);
+		scsi_deactivate_tcq(sdev, 1);
 		break;
 	}
 }
-- 
1.1.3

--------------050500010600020502030901--
