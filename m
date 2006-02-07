From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] aic79xx: use tcq functions
Date: Tue, 07 Feb 2006 08:53:28 +0100
Message-ID: <43E851F8.8070704@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030901020707000904020402"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:16819 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S965006AbWBGHx3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 02:53:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "emmanuel.fuste" <emmanuel.fuste@laposte.net>

This is a multi-part message in MIME format.
--------------030901020707000904020402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This patch converts aic79xx to use the midlayer-supplied tcq
functions.

Signed-off-by: Hannes Reinecke <hare@suse.de>

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------030901020707000904020402
Content-Type: text/plain;
 name="0002-aic79xx-use-tcq-functions.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-aic79xx-use-tcq-functions.txt"

Subject: [PATCH 2/3] aic79xx: use tcq functions

This patch converts aic79xx to use the midlayer-supplied tcq
functions.

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
+		scsi_deactivate_tcq(sdev, 2);
 		break;
 	}
 }
-- 
1.1.3

--------------030901020707000904020402--
