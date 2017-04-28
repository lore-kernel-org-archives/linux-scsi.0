From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH RFC] scsi: wait sd probing in manual scan
Date: Fri, 28 Apr 2017 15:48:19 +0800
Message-ID: <1493365699-25566-1-git-send-email-bergwolf@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

We have a guest init programe trying to mount a device after doing scsi host scan
at boot time. Occasionally it fails to find the device when mounting. After digging
a bit, it seems the root cause is sd async_schedule probing.

With async probing, there is no guarantee of device readiness when scsi host
scan finishes. However, users do expect to have a valid way to make sure device
is usable. Change scsi scan to wait sd probing in manual scan case so that we
don't leave user with random device state when scsi host scan returns.

Is this the right way to have such guarantee?

CC: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 drivers/scsi/scsi_scan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6f7128f..0208f40 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1077,6 +1077,11 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: device exists on %s\n",
 				dev_name(&sdev->sdev_gendev)));
+			/* sd probing uses async_schedule.  Wait until it finishes if this
+			 * is a user requested rescan.
+			 */
+			if (rescan == SCSI_SCAN_MANUAL && scsi_is_sdev_device(&sdev->sdev_gendev))
+				async_synchronize_full_domain(&scsi_sd_probe_domain);
 			if (sdevp)
 				*sdevp = sdev;
 			else
@@ -1176,6 +1181,12 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 		}
 	}

+	/* sd probing uses async_schedule.  Wait until it finishes if this
+	 * is a user requested rescan.
+	 */
+	if (rescan == SCSI_SCAN_MANUAL && scsi_is_sdev_device(&sdev->sdev_gendev))
+		async_synchronize_full_domain(&scsi_sd_probe_domain);
+
  out_free_result:
 	kfree(result);
  out_free_sdev:
-- 
2.7.4
