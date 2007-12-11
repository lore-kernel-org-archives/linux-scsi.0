From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 15/30] blk_end_request: changing viocd (take 4)
Date: Tue, 11 Dec 2007 17:47:52 -0500 (EST)
Message-ID: <20071211.174752.76777839.k-ueda@ct.jp.nec.com>
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

This patch converts viocd to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, viocd_end_request(),
is changed.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/cdrom/viocd.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

Index: 2.6.24-rc4/drivers/cdrom/viocd.c
===================================================================
--- 2.6.24-rc4.orig/drivers/cdrom/viocd.c
+++ 2.6.24-rc4/drivers/cdrom/viocd.c
@@ -289,7 +289,7 @@ static int send_request(struct request *
 	return 0;
 }
 
-static void viocd_end_request(struct request *req, int uptodate)
+static void viocd_end_request(struct request *req, int error)
 {
 	int nsectors = req->hard_nr_sectors;
 
@@ -302,11 +302,8 @@ static void viocd_end_request(struct req
 	if (!nsectors)
 		nsectors = 1;
 
-	if (end_that_request_first(req, uptodate, nsectors))
+	if (__blk_end_request(req, error, nsectors << 9))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 }
 
 static int rwreq;
@@ -317,11 +314,11 @@ static void do_viocd_request(struct requ
 
 	while ((rwreq == 0) && ((req = elv_next_request(q)) != NULL)) {
 		if (!blk_fs_request(req))
-			viocd_end_request(req, 0);
+			viocd_end_request(req, -EIO);
 		else if (send_request(req) < 0) {
 			printk(VIOCD_KERN_WARNING
 					"unable to send message to OS/400!");
-			viocd_end_request(req, 0);
+			viocd_end_request(req, -EIO);
 		} else
 			rwreq++;
 	}
@@ -532,9 +529,9 @@ return_complete:
 					"with rc %d:0x%04X: %s\n",
 					req, event->xRc,
 					bevent->sub_result, err->msg);
-			viocd_end_request(req, 0);
+			viocd_end_request(req, -EIO);
 		} else
-			viocd_end_request(req, 1);
+			viocd_end_request(req, 0);
 
 		/* restart handling of incoming requests */
 		spin_unlock_irqrestore(&viocd_reqlock, flags);
