From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH v4 2/2] libata: Utilize new SCSI event infrastructure
Date: Mon, 29 Oct 2007 10:42:09 -0400 (EDT)
Message-ID: <20071029144209.AEE9F1F816B@havoc.gtf.org>
References: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:47293 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbXJ2OmK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 10:42:10 -0400
In-Reply-To: <15624bab8dc0206e384ac8314257a900e60127c1.1193668176.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
Cc: akpm@linux-foundation.org

An end to CD-ROM polling (if you have a device that supports AN)...
hooray!

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ata/libata-scsi.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f752edd..e6d5627 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -773,6 +773,9 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->flags & ATA_DFLAG_AN)
+		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
+
 	if (dev->flags & ATA_DFLAG_NCQ) {
 		int depth;
 
@@ -3225,10 +3228,11 @@ static void ata_scsi_handle_link_detach(struct ata_link *link)
  */
 void ata_scsi_media_change_notify(struct ata_device *dev)
 {
-#ifdef OTHER_AN_PATCHES_HAVE_BEEN_APPLIED
-	if (dev->sdev)
-		scsi_device_event_notify(dev->sdev, SDEV_MEDIA_CHANGE);
-#endif
+	if (dev->sdev) {
+		DECLARE_BITMAP(map, SDEV_EVT_MAXBITS);
+		__set_bit(SDEV_EVT_MEDIA_CHANGE, map);
+		sdev_evt_notify(dev->sdev, map);
+	}
 }
 
 /**
-- 
1.5.2.4

