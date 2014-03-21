From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Attach VPD page after slave_configure()
Date: Fri, 21 Mar 2014 09:02:14 +0100
Message-ID: <1395388934-105873-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbaCUICW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2014 04:02:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The LLDD might disable the LUN in slave_configure(), so we should
attach the VPD pages afterwards.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1bac49d..27f96d5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -953,9 +953,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
-	if (sdev->scsi_level >= SCSI_3)
-		scsi_attach_vpd(sdev);
-
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
@@ -973,6 +970,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		}
 	}
 
+	if (sdev->scsi_level >= SCSI_3)
+		scsi_attach_vpd(sdev);
+
 	sdev->max_queue_depth = sdev->queue_depth;
 
 	/*
-- 
1.7.12.4

