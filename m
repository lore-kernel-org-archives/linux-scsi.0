From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 10/30] blk_end_request: changing sunvdc (take 4)
Date: Tue, 11 Dec 2007 17:45:04 -0500 (EST)
Message-ID: <20071211.174504.82055916.k-ueda@ct.jp.nec.com>
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
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, davem@davemloft.net
List-Id: linux-scsi@vger.kernel.org

This patch converts sunvdc to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, vdc_end_request(),
is changed.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/sunvdc.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

Index: 2.6.24-rc4/drivers/block/sunvdc.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/sunvdc.c
+++ 2.6.24-rc4/drivers/block/sunvdc.c
@@ -212,12 +212,9 @@ static void vdc_end_special(struct vdc_p
 	vdc_finish(&port->vio, -err, WAITING_FOR_GEN_CMD);
 }
 
-static void vdc_end_request(struct request *req, int uptodate, int num_sectors)
+static void vdc_end_request(struct request *req, int error, int num_sectors)
 {
-	if (end_that_request_first(req, uptodate, num_sectors))
-		return;
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
+	__blk_end_request(req, error, num_sectors << 9);
 }
 
 static void vdc_end_one(struct vdc_port *port, struct vio_dring_state *dr,
@@ -242,7 +239,7 @@ static void vdc_end_one(struct vdc_port 
 
 	rqe->req = NULL;
 
-	vdc_end_request(req, !desc->status, desc->size >> 9);
+	vdc_end_request(req, (desc->status ? -EIO : 0), desc->size >> 9);
 
 	if (blk_queue_stopped(port->disk->queue))
 		blk_start_queue(port->disk->queue);
@@ -456,7 +453,7 @@ static void do_vdc_request(struct reques
 
 		blkdev_dequeue_request(req);
 		if (__send_request(req) < 0)
-			vdc_end_request(req, 0, req->hard_nr_sectors);
+			vdc_end_request(req, -EIO, req->hard_nr_sectors);
 	}
 }
 
