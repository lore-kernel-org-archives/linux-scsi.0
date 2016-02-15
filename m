From: Alan <gnomes@lxorguk.ukuu.org.uk>
Subject: [PATCH] aic7xxx: Fix queue depth handling
Date: Mon, 15 Feb 2016 18:53:15 +0000
Message-ID: <20160215185301.27731.20754.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44796 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbcBOSx1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2016 13:53:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.com, linux-scsi@vger.kernel.org

We were setting the queue depth correctly, then setting it back to two. If
you hit this as a bisection point then please send me an email as it would
imply we've been hiding other bugs with this one.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index b846a46..fc6a831 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1336,6 +1336,7 @@ ahc_platform_set_tags(struct ahc_softc *ahc, struct scsi_device *sdev,
 	case AHC_DEV_Q_TAGGED:
 		scsi_change_queue_depth(sdev,
 				dev->openings + dev->active);
+		break;
 	default:
 		/*
 		 * We allow the OS to queue 2 untagged transactions to

