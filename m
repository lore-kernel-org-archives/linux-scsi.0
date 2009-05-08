From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/18] z2ram: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:13 +0900
Message-ID: <1241751256-17435-16-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

z2ram processes requests one-by-one synchronously and can be easily
converted to dequeueing model.  Convert it.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/z2ram.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 6a13838..c909c1a 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -70,15 +70,21 @@ static struct gendisk *z2ram_gendisk;
 static void do_z2_request(struct request_queue *q)
 {
 	struct request *req;
-	while ((req = elv_next_request(q)) != NULL) {
+
+	req = elv_next_request(q);
+	if (req)
+		blkdev_dequeue_request(req);
+
+	while (req) {
 		unsigned long start = blk_rq_pos(req) << 9;
 		unsigned long len  = blk_rq_cur_bytes(req);
+		int err = 0;
 
 		if (start + len > z2ram_size) {
 			printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, count=%u\n",
 				blk_rq_pos(req), blk_rq_cur_sectors(req));
-			__blk_end_request_cur(req, -EIO);
-			continue;
+			err = -EIO;
+			goto done;
 		}
 		while (len) {
 			unsigned long addr = start & Z2RAM_CHUNKMASK;
@@ -93,7 +99,12 @@ static void do_z2_request(struct request_queue *q)
 			start += size;
 			len -= size;
 		}
-		__blk_end_request_cur(req, 0);
+	done:
+		if (!__blk_end_request_cur(req, err)) {
+			req = elv_next_request(q);
+			if (req)
+				blkdev_dequeue_request(req);
+		}
 	}
 }
 
-- 
1.6.0.2

