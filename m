From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/18] hd: dequeue and track in-flight request
Date: Fri,  8 May 2009 11:54:02 +0900
Message-ID: <1241751256-17435-5-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

hd has at most single request in flight.  Till now, whenever it needs
to access the in-flight request it called elv_next_request().  This
patch makes hd track the in-flight request directly and dequeue it
when processing starts.  The added complexity is minimal and this will
help future block layer changes.

[ Impact: dequeue in-flight request, one elv_next_request() per request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/hd.c |   63 +++++++++++++++++++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index a3b3994..288ab63 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -98,10 +98,9 @@
 
 static DEFINE_SPINLOCK(hd_lock);
 static struct request_queue *hd_queue;
+static struct request *hd_req;
 
 #define MAJOR_NR HD_MAJOR
-#define QUEUE (hd_queue)
-#define CURRENT elv_next_request(hd_queue)
 
 #define TIMEOUT_VALUE	(6*HZ)
 #define	HD_DELAY	0
@@ -195,11 +194,24 @@ static void __init hd_setup(char *str, int *ints)
 	NR_HD = hdind+1;
 }
 
+static bool hd_end_request(int err, unsigned int bytes)
+{
+	if (__blk_end_request(hd_req, err, bytes))
+		return true;
+	hd_req = NULL;
+	return false;
+}
+
+static bool hd_end_request_cur(int err)
+{
+	return hd_end_request(err, blk_rq_cur_bytes(hd_req));
+}
+
 static void dump_status(const char *msg, unsigned int stat)
 {
 	char *name = "hd?";
-	if (CURRENT)
-		name = CURRENT->rq_disk->disk_name;
+	if (hd_req)
+		name = hd_req->rq_disk->disk_name;
 
 #ifdef VERBOSE_ERRORS
 	printk("%s: %s: status=0x%02x { ", name, msg, stat & 0xff);
@@ -227,8 +239,8 @@ static void dump_status(const char *msg, unsigned int stat)
 		if (hd_error & (BBD_ERR|ECC_ERR|ID_ERR|MARK_ERR)) {
 			printk(", CHS=%d/%d/%d", (inb(HD_HCYL)<<8) + inb(HD_LCYL),
 				inb(HD_CURRENT) & 0xf, inb(HD_SECTOR));
-			if (CURRENT)
-				printk(", sector=%ld", blk_rq_pos(CURRENT));
+			if (hd_req)
+				printk(", sector=%ld", blk_rq_pos(hd_req));
 		}
 		printk("\n");
 	}
@@ -406,11 +418,12 @@ static void unexpected_hd_interrupt(void)
  */
 static void bad_rw_intr(void)
 {
-	struct request *req = CURRENT;
+	struct request *req = hd_req;
+
 	if (req != NULL) {
 		struct hd_i_struct *disk = req->rq_disk->private_data;
 		if (++req->errors >= MAX_ERRORS || (hd_error & BBD_ERR)) {
-			__blk_end_request_cur(req, -EIO);
+			hd_end_request_cur(-EIO);
 			disk->special_op = disk->recalibrate = 1;
 		} else if (req->errors % RESET_FREQ == 0)
 			reset = 1;
@@ -454,14 +467,14 @@ static void read_intr(void)
 	return;
 
 ok_to_read:
-	req = CURRENT;
+	req = hd_req;
 	insw(HD_DATA, req->buffer, 256);
 #ifdef DEBUG
 	printk("%s: read: sector %ld, remaining = %u, buffer=%p\n",
 	       req->rq_disk->disk_name, blk_rq_pos(req) + 1,
 	       blk_rq_sectors(req) - 1, req->buffer+512);
 #endif
-	if (__blk_end_request(req, 0, 512)) {
+	if (hd_end_request(0, 512)) {
 		SET_HANDLER(&read_intr);
 		return;
 	}
@@ -475,7 +488,7 @@ ok_to_read:
 
 static void write_intr(void)
 {
-	struct request *req = CURRENT;
+	struct request *req = hd_req;
 	int i;
 	int retries = 100000;
 
@@ -494,7 +507,7 @@ static void write_intr(void)
 	return;
 
 ok_to_write:
-	if (__blk_end_request(req, 0, 512)) {
+	if (hd_end_request(0, 512)) {
 		SET_HANDLER(&write_intr);
 		outsw(HD_DATA, req->buffer, 256);
 		return;
@@ -525,18 +538,18 @@ static void hd_times_out(unsigned long dummy)
 
 	do_hd = NULL;
 
-	if (!CURRENT)
+	if (!hd_req)
 		return;
 
 	spin_lock_irq(hd_queue->queue_lock);
 	reset = 1;
-	name = CURRENT->rq_disk->disk_name;
+	name = hd_req->rq_disk->disk_name;
 	printk("%s: timeout\n", name);
-	if (++CURRENT->errors >= MAX_ERRORS) {
+	if (++hd_req->errors >= MAX_ERRORS) {
 #ifdef DEBUG
 		printk("%s: too many errors\n", name);
 #endif
-		__blk_end_request_cur(CURRENT, -EIO);
+		hd_end_request_cur(-EIO);
 	}
 	hd_request();
 	spin_unlock_irq(hd_queue->queue_lock);
@@ -551,7 +564,7 @@ static int do_special_op(struct hd_i_struct *disk, struct request *req)
 	}
 	if (disk->head > 16) {
 		printk("%s: cannot handle device with more than 16 heads - giving up\n", req->rq_disk->disk_name);
-		__blk_end_request_cur(req, -EIO);
+		hd_end_request_cur(-EIO);
 	}
 	disk->special_op = 0;
 	return 1;
@@ -578,11 +591,15 @@ static void hd_request(void)
 repeat:
 	del_timer(&device_timer);
 
-	req = CURRENT;
-	if (!req) {
-		do_hd = NULL;
-		return;
+	if (!hd_req) {
+		hd_req = elv_next_request(hd_queue);
+		if (!hd_req) {
+			do_hd = NULL;
+			return;
+		}
+		blkdev_dequeue_request(hd_req);
 	}
+	req = hd_req;
 
 	if (reset) {
 		reset_hd();
@@ -595,7 +612,7 @@ repeat:
 	    ((block+nsect) > get_capacity(req->rq_disk))) {
 		printk("%s: bad access: block=%d, count=%d\n",
 			req->rq_disk->disk_name, block, nsect);
-		__blk_end_request_cur(req, -EIO);
+		hd_end_request_cur(-EIO);
 		goto repeat;
 	}
 
@@ -635,7 +652,7 @@ repeat:
 			break;
 		default:
 			printk("unknown hd-command\n");
-			__blk_end_request_cur(req, -EIO);
+			hd_end_request_cur(-EIO);
 			break;
 		}
 	}
-- 
1.6.0.2

