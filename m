From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 08/30] blk_end_request: changing nbd (take 4)
Date: Tue, 11 Dec 2007 17:44:06 -0500 (EST)
Message-ID: <20071211.174406.35360021.k-ueda@ct.jp.nec.com>
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
Cc: linux-scsi@vger.kernel.org, Paul.Clements@steeleye.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts nbd to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

Cc: Paul Clements <Paul.Clements@steeleye.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/nbd.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

Index: 2.6.24-rc4/drivers/block/nbd.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/nbd.c
+++ 2.6.24-rc4/drivers/block/nbd.c
@@ -100,17 +100,15 @@ static const char *nbdcmd_to_ascii(int c
 
 static void nbd_end_request(struct request *req)
 {
-	int uptodate = (req->errors == 0) ? 1 : 0;
+	int error = req->errors ? -EIO : 0;
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
 	dprintk(DBG_BLKDEV, "%s: request %p: %s\n", req->rq_disk->disk_name,
-			req, uptodate? "done": "failed");
+			req, error ? "failed" : "done");
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (!end_that_request_first(req, uptodate, req->nr_sectors)) {
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, error, req->nr_sectors << 9);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
