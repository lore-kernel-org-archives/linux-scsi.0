From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/18] ps3disk: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:07 +0900
Message-ID: <1241751256-17435-10-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Other than in issue error paths, ps3disk always completely finishes
fetched requests.  With full completion on error paths, it can be
easily converted to dequeueing model.

* After L1 r/w call failure, ps3disk_submit_request_sg() now fails the
  whole request.  Issue failure isn't likely to benefit from partial
  retry anyway and ps3disk uses full failure in completion error path
  too, so I don't think this amounts to any meaningful functionality
  loss.

* flush completion is converted to _all for consistency.  It doesn't
  make any functional difference.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/block/ps3disk.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 8d58308..f4d8db9 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -157,7 +157,7 @@ static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
 	if (res) {
 		dev_err(&dev->sbd.core, "%s:%u: %s failed %d\n", __func__,
 			__LINE__, op, res);
-		__blk_end_request_cur(req, -EIO);
+		__blk_end_request_all(req, -EIO);
 		return 0;
 	}
 
@@ -179,7 +179,7 @@ static int ps3disk_submit_flush_request(struct ps3_storage_device *dev,
 	if (res) {
 		dev_err(&dev->sbd.core, "%s:%u: sync cache failed 0x%llx\n",
 			__func__, __LINE__, res);
-		__blk_end_request_cur(req, -EIO);
+		__blk_end_request_all(req, -EIO);
 		return 0;
 	}
 
@@ -195,6 +195,8 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
 	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
 
 	while ((req = elv_next_request(q))) {
+		blkdev_dequeue_request(req);
+
 		if (blk_fs_request(req)) {
 			if (ps3disk_submit_request_sg(dev, req))
 				break;
@@ -204,7 +206,7 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
 				break;
 		} else {
 			blk_dump_rq_flags(req, DEVICE_NAME " bad request");
-			__blk_end_request_cur(req, -EIO);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 	}
-- 
1.6.0.2

