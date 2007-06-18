From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/11] Add scsi_destroy_device()
Date: Mon, 18 Jun 2007 11:01:28 +0200
Message-ID: <20070618090128.DE82FD44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:34314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbXFRJB3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 05:01:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


This patchs adds a new helper scsi_destroy_device(). It will transition
and sdev into the 'SDEV_DEL' state.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c   |    3 +--
 include/scsi/scsi_device.h |    6 ++++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a67f315..4874bdd 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -921,8 +921,7 @@ static inline void scsi_destroy_sdev(str
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+	scsi_destroy_device(sdev);
 }
 
 #ifdef CONFIG_SCSI_LOGGING
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2f3c5b8..dad55d2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -322,6 +322,12 @@ static inline unsigned int sdev_id(struc
 #define scmd_id(scmd) sdev_id((scmd)->device)
 #define scmd_channel(scmd) sdev_channel((scmd)->device)
 
+static inline void scsi_destroy_device(struct scsi_device *sdev)
+{
+	scsi_device_set_state(sdev, SDEV_DEL);
+	put_device(&sdev->sdev_gendev);
+}
+
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
 	return sdev->sdev_state != SDEV_OFFLINE;
-- 
1.4.3.4

