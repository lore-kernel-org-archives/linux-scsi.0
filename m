From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH v5 2/2] libata: Utilize new SCSI event infrastructure
Date: Mon, 29 Oct 2007 17:31:58 -0400 (EDT)
Message-ID: <137ca918a21e98763766b0e1b93aa2ea19293424.1193692827.git.jeff@garzik.org>
References: <1e0190fe71e148eb044c16b805738908ae2fe0bc.1193692827.git.jeff@garzik.org>
	<1193677315.3383.59.camel@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:52461 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbXJ2VcA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 17:32:00 -0400
In-Reply-To: <1e0190fe71e148eb044c16b805738908ae2fe0bc.1193692827.git.jeff@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

An end to CD-ROM polling (if you have a device that supports AN)...
hooray!

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ata/libata-scsi.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 93bd36c..3cbee22 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -841,6 +841,9 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->flags & ATA_DFLAG_AN)
+		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
+
 	if (dev->flags & ATA_DFLAG_NCQ) {
 		int depth;
 
@@ -3293,10 +3296,9 @@ static void ata_scsi_handle_link_detach(struct ata_link *link)
  */
 void ata_scsi_media_change_notify(struct ata_device *dev)
 {
-#ifdef OTHER_AN_PATCHES_HAVE_BEEN_APPLIED
 	if (dev->sdev)
-		scsi_device_event_notify(dev->sdev, SDEV_MEDIA_CHANGE);
-#endif
+		sdev_evt_send_simple(dev->sdev, SDEV_EVT_MEDIA_CHANGE,
+				     GFP_ATOMIC);
 }
 
 /**
-- 
1.5.2.4

