From: Jens Axboe <axboe@fb.com>
Subject: [PATCH] fix host max depth checking for the 'queue_depth' sysfs
 interface
Date: Mon, 13 Jul 2015 08:24:39 -0600
Message-ID: <20150713142439.GA14427@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51377 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbbGMOZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jul 2015 10:25:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>


Commit 1e6f2416044c0 changed the scsi sysfs 'queue_depth' code to
rejects depths higher than the scsi host template setting. But lots
of hosts set this to 1, and update the settings in the scsi host
when the controller/devices probing happens.

This breaks (at least) mpt2sas and mpt3sas runtime setting of queue
depth, returning EINVAL for all settings but '1'. And once it's set to
1, there's no way to go back up.

Cc: stable@kernel.org
Fixes: 1e6f2416044c0 "scsi: don't allow setting of queue_depth bigger than can_queue"
Signed-off-by: Jens Axboe <axboe@fb.com>
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1ac38e73df7e..9ad41168d26d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -859,7 +859,7 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 
 	depth = simple_strtoul(buf, NULL, 0);
 
-	if (depth < 1 || depth > sht->can_queue)
+	if (depth < 1 || depth > sdev->host->can_queue)
 		return -EINVAL;
 
 	retval = sht->change_queue_depth(sdev, depth);
-- 
2.4.1.168.g1ea28e1

-- 
Jens Axboe

