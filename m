From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: use async_probe cookie to avoid deadlocks
Date: Tue, 21 Mar 2017 13:14:35 +0100
Message-ID: <1490098475-21884-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47507 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756597AbdCUMPF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Mar 2017 08:15:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hck@suse.de, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

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
 drivers/scsi/sd.c | 7 ++++---
 drivers/scsi/sd.h | 3 +++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fb9b4d2..9f932e4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -48,7 +48,6 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
-#include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/pr.h>
@@ -3217,7 +3216,8 @@ static int sd_probe(struct device *dev)
 	dev_set_drvdata(dev, sdkp);
 
 	get_device(&sdkp->dev);	/* prevent release before async_schedule */
-	async_schedule_domain(sd_probe_async, sdkp, &scsi_sd_probe_domain);
+	sdkp->async_probe = async_schedule_domain(sd_probe_async, sdkp,
+						  &scsi_sd_probe_domain);
 
 	return 0;
 
@@ -3256,7 +3256,8 @@ static int sd_remove(struct device *dev)
 	scsi_autopm_get_device(sdkp->device);
 
 	async_synchronize_full_domain(&scsi_sd_pm_domain);
-	async_synchronize_full_domain(&scsi_sd_probe_domain);
+	async_synchronize_cookie_domain(sdkp->async_probe,
+					&scsi_sd_probe_domain);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4dac35e..d4b5826 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -1,6 +1,8 @@
 #ifndef _SCSI_DISK_H
 #define _SCSI_DISK_H
 
+#include <linux/async.h>
+
 /*
  * More than enough for everybody ;)  The huge number of majors
  * is a leftover from 16bit dev_t days, we don't really need that
@@ -73,6 +75,7 @@ struct scsi_disk {
 	unsigned int	zones_optimal_nonseq;
 	unsigned int	zones_max_open;
 #endif
+	async_cookie_t	async_probe;
 	atomic_t	openers;
 	sector_t	capacity;	/* size in logical blocks */
 	u32		max_xfer_blocks;
-- 
1.8.5.6
