From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] sd: use async_probe cookie to avoid deadlocks
Date: Tue, 12 Dec 2017 09:57:52 +0100
Message-ID: <1513069072-32514-5-git-send-email-hare@suse.de>
References: <1513069072-32514-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46996 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752152AbdLLI55 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Dec 2017 03:57:57 -0500
In-Reply-To: <1513069072-32514-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

With the current design we're waiting for all async probes to
finish when removing any sd device.
This might lead to a livelock where the 'remove' call is blocking
for any probe calls to finish, and the probe calls are waiting for
a response, which will never be processes as the thread handling
the responses is waiting for the remove call to finish.
Which is completely pointless as we only _really_ care for the
probe on _this_ device to be completed; any other probing can
happily continue for all we care.
So save the async probing cookie in the structure and only wait
if this specific probe is still active.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sd.c | 6 ++++--
 drivers/scsi/sd.h | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index abbab17..7bf20ca 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3416,7 +3416,8 @@ static int sd_probe(struct device *dev)
 	dev_set_drvdata(dev, sdkp);
 
 	get_device(&sdkp->dev);	/* prevent release before async_schedule */
-	async_schedule_domain(sd_probe_async, sdkp, &scsi_sd_probe_domain);
+	sdkp->async_probe = async_schedule_domain(sd_probe_async, sdkp,
+						  &scsi_sd_probe_domain);
 
 	return 0;
 
@@ -3454,7 +3455,8 @@ static int sd_remove(struct device *dev)
 	scsi_autopm_get_device(sdkp->device);
 
 	async_synchronize_full_domain(&scsi_sd_pm_domain);
-	async_synchronize_full_domain(&scsi_sd_probe_domain);
+	async_synchronize_cookie_domain(sdkp->async_probe,
+					&scsi_sd_probe_domain);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 320de75..d8aff29 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -2,6 +2,8 @@
 #ifndef _SCSI_DISK_H
 #define _SCSI_DISK_H
 
+#include <linux/async.h>
+
 /*
  * More than enough for everybody ;)  The huge number of majors
  * is a leftover from 16bit dev_t days, we don't really need that
@@ -73,6 +75,7 @@ struct scsi_disk {
 	struct device	dev;
 	struct gendisk	*disk;
 	struct opal_dev *opal_dev;
+	async_cookie_t  async_probe;
 #ifdef CONFIG_BLK_DEV_ZONED
 	unsigned int	nr_zones;
 	unsigned int	zone_blocks;
-- 
1.8.5.6
