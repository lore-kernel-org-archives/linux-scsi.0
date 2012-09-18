From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v2 2/4] scsi: sd: enter stop power condition on runtime suspend
Date: Tue, 18 Sep 2012 15:00:29 +0800
Message-ID: <1347951631-1592-3-git-send-email-aaron.lu@intel.com>
References: <1347951631-1592-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32964 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab2IRHBA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 03:01:00 -0400
In-Reply-To: <1347951631-1592-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Oliver Neukum <oneukum@suse.de>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>

On runtime suspend, put device into stop power condition.

For standard scsi device, no need to synchronize cache.
For ata devices, issue synchronize cache before enter standby state
as reflected by the sync_before_stop flag.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-scsi.c |  1 +
 drivers/scsi/sd.c         | 10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8ec81ca..9307f52 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1117,6 +1117,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 	} else {
 		sdev->sector_size = ata_id_logical_sector_size(dev->id);
 		sdev->manage_start_stop = 1;
+		sdev->sync_before_stop = 1;
 	}
 
 	/*
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..7b0f07a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2866,18 +2866,24 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 	int ret = 0;
+	bool sync;
 
 	if (!sdkp)
 		return 0;	/* this can happen */
 
-	if (sdkp->WCE) {
+	if (!sdkp->device->manage_start_stop)
+		sync = !!sdkp->WCE;
+	else
+		sync = sdkp->device->sync_before_stop && !!sdkp->WCE;
+
+	if (sync) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp);
 		if (ret)
 			goto done;
 	}
 
-	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
+	if (sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		ret = sd_start_stop_device(sdkp, 0);
 	}
-- 
1.7.12.21.g871e293

