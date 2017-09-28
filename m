From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd: Do not override max_sectors_kb sysfs setting
Date: Wed, 27 Sep 2017 21:38:59 -0400
Message-ID: <20170928013859.1214-1-martin.petersen@oracle.com>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51975 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751881AbdI1BjG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2017 21:39:06 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8S1d5F3024718
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 28 Sep 2017 01:39:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8S1d3CH006890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 28 Sep 2017 01:39:03 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8S1d3Ij005744
        for <linux-scsi@vger.kernel.org>; Thu, 28 Sep 2017 01:39:03 GMT
In-Reply-To: <150309002518.8999.15900049133748830764.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

A user may lower the max_sectors_kb setting in sysfs to accommodate
certain workloads. Previously we would always set the max I/O size to
either the block layer default or the optional preferred I/O size
reported by the device.

Keep the current heuristics for the initial setting of max_sectors_kb.
For subsequent invocations, only update the current queue limit if it
exceeds the capabilities of the hardware.

Reported-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6549e5ce09ca..b18ba3235900 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3098,8 +3098,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_security(sdkp, buffer);
 	}
 
-	sdkp->first_scan = 0;
-
 	/*
 	 * We now have all cache related info, determine how we deal
 	 * with flush requests.
@@ -3114,7 +3112,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
 
 	/*
-	 * Use the device's preferred I/O size for reads and writes
+	 * Determine the device's preferred I/O size for reads and writes
 	 * unless the reported value is unreasonably small, large, or
 	 * garbage.
 	 */
@@ -3128,8 +3126,19 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
 				      (sector_t)BLK_DEF_MAX_SECTORS);
 
-	/* Combine with controller limits */
-	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
+	/* Do not exceed controller limit */
+	rw_max = min(rw_max, queue_max_hw_sectors(q));
+
+	/*
+	 * Only update max_sectors if previously unset or if the current value
+	 * exceeds the capabilities of the hardware.
+	 */
+	if (sdkp->first_scan ||
+	    q->limits.max_sectors > q->limits.max_dev_sectors ||
+	    q->limits.max_sectors > q->limits.max_hw_sectors)
+		q->limits.max_sectors = rw_max;
+
+	sdkp->first_scan = 0;
 
 	set_capacity(disk, logical_to_sectors(sdp, sdkp->capacity));
 	sd_config_write_same(sdkp);
-- 
2.14.1
