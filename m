From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/7] scsi: Set request queue runtime PM status back to active on resume
Date: Thu, 18 Feb 2016 10:54:12 +0200
Message-ID: <1455785657-22924-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We treat system suspend of SCSI devices pretty much the same as runtime
suspend. If the device is already runtime suspended we leave it to that
state during system suspend. On resume from system sleep we then resume the
device and correct the runtime PM status back to "active".

There is a problem with this because runtime PM status of the request queue
in question is not changed (it will be in "suspended" state). When SCSI
disk driver (sd.c) resumes the disk it sends START message to the device
and because the request queue is still in "suspended" state
blk_pm_peek_request() returns NULL preventing resume of the disk.

The issue can be reproduced with following commands:

  # echo auto > /sys/block/sda/device/power/control
  # echo 15000 > /sys/block/sda/device/power/autosuspend_delay_ms
  [   57.191706] sd 0:0:0:0: [sda] Synchronizing SCSI cache
  [   57.380015] sd 0:0:0:0: [sda] Stopping disk

Now suspend the machine:

  # rtcwake -s10 -mmem

This ends up in soft lockup because resume is not proceeding accordingly
and userspace is never restarted. Also there is nothing printed to the
console.

Fix this by forcing request queue status to "active" before the disk is
resumed.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/scsi/scsi_pm.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 459abe1dcc87..b44c1bb687a2 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -139,6 +139,16 @@ static int scsi_bus_resume_common(struct device *dev,
 	else
 		fn = NULL;
 
+	/*
+	 * Forcibly set runtime PM status of request queue to "active" to
+	 * make sure we can again get requests from the queue (see also
+	 * blk_pm_peek_request()).
+	 *
+	 * The resume hook will correct runtime PM status of the disk.
+	 */
+	if (scsi_is_sdev_device(dev) && pm_runtime_suspended(dev))
+		blk_set_runtime_active(to_scsi_device(dev)->request_queue);
+
 	if (fn) {
 		async_schedule_domain(fn, dev, &scsi_sd_pm_domain);
 
-- 
2.7.0
