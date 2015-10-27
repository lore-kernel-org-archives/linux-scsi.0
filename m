From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: [RESEND PATCH] scsi_sysfs: Fix queue_ramp_up_period return code
Date: Tue, 27 Oct 2015 10:49:54 +0100
Message-ID: <562F48C2.1070803@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Vasu Dev <vasu.dev@intel.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Writing a number to /sys/bus/scsi/devices/<sdev>/queue_ramp_up_period
returns the value of that number instead of the number of bytes written.
This behavior can confuse programs expecting POSIX write() semantics.
Fix this by returning the number of bytes written instead.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: stable@vger.kernel.org
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b333389..6b0f292 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -898,7 +898,7 @@ sdev_store_queue_ramp_up_period(struct device *dev,
 		return -EINVAL;

 	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
-	return period;
+	return count;
 }

 static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
-- 
2.3.0
