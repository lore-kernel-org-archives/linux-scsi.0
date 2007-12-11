From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 13/30] blk_end_request: changing viodasd (take 4)
Date: Tue, 11 Dec 2007 17:47:14 -0500 (EST)
Message-ID: <20071211.174714.42908160.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts viodasd to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, viodasd_end_request(),
is changed.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/viodasd.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

Index: 2.6.24-rc4/drivers/block/viodasd.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/viodasd.c
+++ 2.6.24-rc4/drivers/block/viodasd.c
@@ -229,13 +229,10 @@ static struct block_device_operations vi
 /*
  * End a request
  */
-static void viodasd_end_request(struct request *req, int uptodate,
+static void viodasd_end_request(struct request *req, int error,
 		int num_sectors)
 {
-	if (end_that_request_first(req, uptodate, num_sectors))
-		return;
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
+	__blk_end_request(req, error, num_sectors << 9);
 }
 
 /*
@@ -374,12 +371,12 @@ static void do_viodasd_request(struct re
 		blkdev_dequeue_request(req);
 		/* check that request contains a valid command */
 		if (!blk_fs_request(req)) {
-			viodasd_end_request(req, 0, req->hard_nr_sectors);
+			viodasd_end_request(req, -EIO, req->hard_nr_sectors);
 			continue;
 		}
 		/* Try sending the request */
 		if (send_request(req) != 0)
-			viodasd_end_request(req, 0, req->hard_nr_sectors);
+			viodasd_end_request(req, -EIO, req->hard_nr_sectors);
 	}
 }
 
@@ -591,7 +588,7 @@ static int viodasd_handle_read_write(str
 	num_req_outstanding--;
 	spin_unlock_irqrestore(&viodasd_spinlock, irq_flags);
 
-	error = event->xRc != HvLpEvent_Rc_Good;
+	error = (event->xRc == HvLpEvent_Rc_Good) ? 0 : -EIO;
 	if (error) {
 		const struct vio_error_entry *err;
 		err = vio_lookup_rc(viodasd_err_table, bevent->sub_result);
@@ -601,7 +598,7 @@ static int viodasd_handle_read_write(str
 	}
 	qlock = req->q->queue_lock;
 	spin_lock_irqsave(qlock, irq_flags);
-	viodasd_end_request(req, !error, num_sect);
+	viodasd_end_request(req, error, num_sect);
 	spin_unlock_irqrestore(qlock, irq_flags);
 
 	/* Finally, try to get more requests off of this device's queue */
