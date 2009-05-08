From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/18] swim3: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:04 +0900
Message-ID: <1241751256-17435-7-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

swim3 has at most single request in flight and already tracks it using
fd_req.  Convert it to dequeuing model by updating request fetching
and wrapping completion function.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/swim3.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index c1b9a4d..f48c6dd 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -251,6 +251,20 @@ static int floppy_release(struct gendisk *disk, fmode_t mode);
 static int floppy_check_change(struct gendisk *disk);
 static int floppy_revalidate(struct gendisk *disk);
 
+static bool swim3_end_request(int err, unsigned int nr_bytes)
+{
+	if (__blk_end_request(fd_req, err, nr_bytes))
+		return true;
+
+	fd_req = NULL;
+	return false;
+}
+
+static bool swim3_end_request_cur(int err)
+{
+	return swim3_end_request(err, blk_rq_cur_bytes(fd_req));
+}
+
 static void swim3_select(struct floppy_state *fs, int sel)
 {
 	struct swim3 __iomem *sw = fs->swim3;
@@ -310,7 +324,14 @@ static void start_request(struct floppy_state *fs)
 		wake_up(&fs->wait);
 		return;
 	}
-	while (fs->state == idle && (req = elv_next_request(swim3_queue))) {
+	while (fs->state == idle) {
+		if (!fd_req) {
+			fd_req = elv_next_request(swim3_queue);
+			if (!fd_req)
+				break;
+			blkdev_dequeue_request(fd_req);
+		}
+		req = fd_req;
 #if 0
 		printk("do_fd_req: dev=%s cmd=%d sec=%ld nr_sec=%u buf=%p\n",
 		       req->rq_disk->disk_name, req->cmd,
@@ -320,11 +341,11 @@ static void start_request(struct floppy_state *fs)
 #endif
 
 		if (blk_rq_pos(req) >= fs->total_secs) {
-			__blk_end_request_cur(req, -EIO);
+			swim3_end_request_cur(-EIO);
 			continue;
 		}
 		if (fs->ejected) {
-			__blk_end_request_cur(req, -EIO);
+			swim3_end_request_cur(-EIO);
 			continue;
 		}
 
@@ -332,7 +353,7 @@ static void start_request(struct floppy_state *fs)
 			if (fs->write_prot < 0)
 				fs->write_prot = swim3_readbit(fs, WRITE_PROT);
 			if (fs->write_prot) {
-				__blk_end_request_cur(req, -EIO);
+				swim3_end_request_cur(-EIO);
 				continue;
 			}
 		}
@@ -505,7 +526,7 @@ static void act(struct floppy_state *fs)
 		case do_transfer:
 			if (fs->cur_cyl != fs->req_cyl) {
 				if (fs->retries > 5) {
-					__blk_end_request_cur(fd_req, -EIO);
+					swim3_end_request_cur(-EIO);
 					fs->state = idle;
 					return;
 				}
@@ -537,7 +558,7 @@ static void scan_timeout(unsigned long data)
 	out_8(&sw->intr_enable, 0);
 	fs->cur_cyl = -1;
 	if (fs->retries > 5) {
-		__blk_end_request_cur(fd_req, -EIO);
+		swim3_end_request_cur(-EIO);
 		fs->state = idle;
 		start_request(fs);
 	} else {
@@ -556,7 +577,7 @@ static void seek_timeout(unsigned long data)
 	out_8(&sw->select, RELAX);
 	out_8(&sw->intr_enable, 0);
 	printk(KERN_ERR "swim3: seek timeout\n");
-	__blk_end_request_cur(fd_req, -EIO);
+	swim3_end_request_cur(-EIO);
 	fs->state = idle;
 	start_request(fs);
 }
@@ -580,7 +601,7 @@ static void settle_timeout(unsigned long data)
 		return;
 	}
 	printk(KERN_ERR "swim3: seek settle timeout\n");
-	__blk_end_request_cur(fd_req, -EIO);
+	swim3_end_request_cur(-EIO);
 	fs->state = idle;
 	start_request(fs);
 }
@@ -603,7 +624,7 @@ static void xfer_timeout(unsigned long data)
 	printk(KERN_ERR "swim3: timeout %sing sector %ld\n",
 	       (rq_data_dir(fd_req)==WRITE? "writ": "read"),
 	       (long)blk_rq_pos(fd_req));
-	__blk_end_request_cur(fd_req, -EIO);
+	swim3_end_request_cur(-EIO);
 	fs->state = idle;
 	start_request(fs);
 }
@@ -634,7 +655,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				printk(KERN_ERR "swim3: seen sector but cyl=ff?\n");
 				fs->cur_cyl = -1;
 				if (fs->retries > 5) {
-					__blk_end_request_cur(fd_req, -EIO);
+					swim3_end_request_cur(-EIO);
 					fs->state = idle;
 					start_request(fs);
 				} else {
@@ -717,7 +738,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				printk("swim3: error %sing block %ld (err=%x)\n",
 				       rq_data_dir(fd_req) == WRITE? "writ": "read",
 				       (long)blk_rq_pos(fd_req), err);
-				__blk_end_request_cur(fd_req, -EIO);
+				swim3_end_request_cur(-EIO);
 				fs->state = idle;
 			}
 		} else {
@@ -726,12 +747,12 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 				printk(KERN_ERR "swim3: fd dma: stat=%x resid=%d\n", stat, resid);
 				printk(KERN_ERR "  state=%d, dir=%x, intr=%x, err=%x\n",
 				       fs->state, rq_data_dir(fd_req), intr, err);
-				__blk_end_request_cur(fd_req, -EIO);
+				swim3_end_request_cur(-EIO);
 				fs->state = idle;
 				start_request(fs);
 				break;
 			}
-			if (__blk_end_request(fd_req, 0, fs->scount << 9)) {
+			if (swim3_end_request(0, fs->scount << 9)) {
 				fs->req_sector += fs->scount;
 				if (fs->req_sector > fs->secpertrack) {
 					fs->req_sector -= fs->secpertrack;
-- 
1.6.0.2

