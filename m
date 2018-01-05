From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/2] Fix a race condition between SPI domain validation and system suspend
Date: Fri,  5 Jan 2018 09:19:09 -0800
Message-ID: <20180105171909.11839-3-bart.vanassche@wdc.com>
References: <20180105171909.11839-1-bart.vanassche@wdc.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20180105171909.11839-1-bart.vanassche@wdc.com>
Sender: linux-pm-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Woody Suwalski <terraluna977@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Avoid that the following warning is reported when suspending a system
that is using the mptspi driver:

WARNING: CPU: 0 PID: 4187 at drivers/scsi/scsi_lib.c:2960 scsi_device_quiesce+0x20/0xb0
EIP: scsi_device_quiesce+0x20/0xb0
Call Trace:
 spi_dv_device+0x65/0x5f0 [scsi_transport_spi]
 mptspi_dv_device+0x4d/0x170 [mptspi]
 mptspi_dv_renegotiate_work+0x49/0xc0 [mptspi]
 process_one_work+0x190/0x2e0
 worker_thread+0x37/0x3f0
 kthread+0xcb/0x100
 ret_from_fork+0x19/0x24

Fixes: 3a0a529971ec ("block, scsi: Make SCSI quiesce and resume work reliably")
Reported-by: Woody Suwalski <terraluna977@gmail.com>
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: linux-pm@vger.kernel.org
---
 drivers/scsi/scsi_transport_spi.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 10ebb213ddb3..871ea582029e 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -26,6 +26,7 @@
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
 #include <linux/slab.h>
+#include <linux/suspend.h>
 #include <scsi/scsi.h>
 #include "scsi_priv.h"
 #include <scsi/scsi_device.h>
@@ -1009,11 +1010,20 @@ spi_dv_device(struct scsi_device *sdev)
 	u8 *buffer;
 	const int len = SPI_MAX_ECHO_BUFFER_SIZE*2;
 
+	/*
+	 * Because this function and the power management code both call
+	 * scsi_device_quiesce(), it is not safe to perform domain validation
+	 * while suspend or resume is in progress. Hence the
+	 * lock/unlock_system_sleep() calls.
+	 */
+	lock_system_sleep();
+
 	if (unlikely(spi_dv_in_progress(starget)))
-		return;
+		goto unlock;
 
 	if (unlikely(scsi_device_get(sdev)))
-		return;
+		goto unlock;
+
 	spi_dv_in_progress(starget) = 1;
 
 	buffer = kzalloc(len, GFP_KERNEL);
@@ -1049,6 +1059,8 @@ spi_dv_device(struct scsi_device *sdev)
  out_put:
 	spi_dv_in_progress(starget) = 0;
 	scsi_device_put(sdev);
+unlock:
+	unlock_system_sleep();
 }
 EXPORT_SYMBOL(spi_dv_device);
 
-- 
2.15.1
