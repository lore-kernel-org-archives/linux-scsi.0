From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH] scsi: ratelimit error messages
Date: Sun, 22 Jan 2017 16:34:51 +0800
Message-ID: <1485074091-7571-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:53963 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751065AbdAVIem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jan 2017 03:34:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Wei Fang <fangwei1@huawei.com>

If we continue to send IOs when the scsi device is offline/deleting,
a lot of error messages will be printked, and may appear on serial
console. It will extremly slow down the system.

Fix this by using printk_ratelimit().

I noticed that printk_ratelimit() is warnned not to use, but using
printk_ratelimited() will lose the messages printked by sdev_printk(),
maybe we should remove all printk_ratelimit() in scsi layer next time
by rewriting sdev_printk().

Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 drivers/scsi/scsi_lib.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9e1e14..faebf74 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1222,8 +1222,9 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			 * commands.  The device must be brought online
 			 * before trying any recovery commands.
 			 */
-			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to offline device\n");
+			if (printk_ratelimit())
+				sdev_printk(KERN_ERR, sdev,
+					    "rejecting I/O to offline device\n");
 			ret = BLKPREP_KILL;
 			break;
 		case SDEV_DEL:
@@ -1231,8 +1232,9 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			 * If the device is fully deleted, we refuse to
 			 * process any commands as well.
 			 */
-			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to dead device\n");
+			if (printk_ratelimit())
+				sdev_printk(KERN_ERR, sdev,
+					    "rejecting I/O to dead device\n");
 			ret = BLKPREP_KILL;
 			break;
 		case SDEV_BLOCK:
@@ -1711,8 +1713,9 @@ static void scsi_request_fn(struct request_queue *q)
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
-			sdev_printk(KERN_ERR, sdev,
-				    "rejecting I/O to offline device\n");
+			if (printk_ratelimit())
+				sdev_printk(KERN_ERR, sdev,
+					    "rejecting I/O to offline device\n");
 			scsi_kill_request(req, q);
 			continue;
 		}
-- 
2.4.11

