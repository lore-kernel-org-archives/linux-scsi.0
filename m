From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Fri, 18 Aug 2017 16:00:25 -0500
Message-ID: <150309002518.8999.15900049133748830764.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0052.outbound.protection.outlook.com ([104.47.36.52]:58982
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751695AbdHRVAc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Aug 2017 17:00:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

prevent systemd-udevd from changing a device's sysfs entry
max_sectors_kb back to the default value.
 - max_sectors_kb can be tweaked for better performance.
 - udev can be triggered by sg_logs -t or scsi_temperature, ...
 - sd_revalidate_disk is called from udev by ioctl BLKRRPART

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/sd.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bea36ad..457dc7c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3055,6 +3055,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	sector_t old_capacity = sdkp->capacity;
 	unsigned char *buffer;
 	unsigned int dev_max, rw_max;
+	unsigned int max_sectors;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -3128,9 +3129,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
 				      (sector_t)BLK_DEF_MAX_SECTORS);
 
-	/* Combine with controller limits */
-	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
+	/* Check for max_sectors_kb update through sysfs */
+	if (q->limits.max_sectors < min(rw_max, queue_max_hw_sectors(q)))
+		max_sectors = q->limits.max_sectors;
+	else
+		max_sectors = min(rw_max, queue_max_hw_sectors(q));
 
+	/* Combine with controller limits */
+	q->limits.max_sectors = max_sectors;
 	set_capacity(disk, logical_to_sectors(sdp, sdkp->capacity));
 	sd_config_write_same(sdkp);
 	kfree(buffer);
