From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix aic7xxx performance issues since 2.6.12-rc2
Date: Thu, 04 Aug 2005 13:28:40 -0500
Message-ID: <1123180120.5026.42.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:17861 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262510AbVHDS2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 14:28:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <axboe@suse.de>, mason@suse.com, Suparna Bhattacharya <suparna@in.ibm.com>

Several people noticed we dropped quite a bit on benchmark figures.  OK,
it was my fault but unfortunately I discovered I ran out of brown paper
bags a while ago and forgot to reorder them.

The issue is that a construct introduced in the conversion keyed off
whether the block request was tagged or not.  However, the aic7xxx
driver doesn't properly set up the block layer TCQ (it uses the wrong
API), so the driver now things all requests are untagged and we keep it
to a queue depth of a single element.  Oops.

The fix is to use the correct TCQ API.

James

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1264,14 +1264,12 @@ ahc_platform_set_tags(struct ahc_softc *
 	}
 	switch ((dev->flags & (AHC_DEV_Q_BASIC|AHC_DEV_Q_TAGGED))) {
 	case AHC_DEV_Q_BASIC:
-		scsi_adjust_queue_depth(sdev,
-					MSG_SIMPLE_TASK,
-					dev->openings + dev->active);
+		scsi_set_tag_type(sdev, MSG_SIMPLE_TAG);
+		scsi_activate_tcq(sdev, dev->openings + dev->active);
 		break;
 	case AHC_DEV_Q_TAGGED:
-		scsi_adjust_queue_depth(sdev,
-					MSG_ORDERED_TASK,
-					dev->openings + dev->active);
+		scsi_set_tag_type(sdev, MSG_ORDERED_TAG);
+		scsi_activate_tcq(sdev, dev->openings + dev->active);
 		break;
 	default:
 		/*
@@ -1280,9 +1278,7 @@ ahc_platform_set_tags(struct ahc_softc *
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


