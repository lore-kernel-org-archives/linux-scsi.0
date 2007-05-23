From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 7/9] Remove obsolete scsi_destroy_sdev() function
Date: Wed, 23 May 2007 10:55:49 +0200
Message-ID: <20070523085549.239CDD44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:35174 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758084AbXEWIzu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 04:55:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


scsi_destroy_sdev() is now obsolete. Delete it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 82fad00..2653015 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -941,14 +941,6 @@ static int scsi_add_lun(struct scsi_devi
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
-static inline void scsi_destroy_sdev(struct scsi_device *sdev)
-{
-	scsi_device_set_state(sdev, SDEV_DEL);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	scsi_destroy_device(sdev);
-}
-
 #ifdef CONFIG_SCSI_LOGGING
 /** 
  * scsi_inq_str - print INQUIRY data from min to max index,
-- 
1.4.3.4

