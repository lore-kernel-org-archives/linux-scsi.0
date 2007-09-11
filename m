From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 09/27] blk_end_request: changing nbd (take 2)
Date: Tue, 11 Sep 2007 14:59:24 -0400 (EDT)
Message-ID: <20070911.145924.85814380.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts nbd to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/nbd.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -rupN 08-lguest-caller-change/drivers/block/nbd.c 09-nbd-caller-change/drivers/block/nbd.c
--- 08-lguest-caller-change/drivers/block/nbd.c	2007-09-10 17:32:11.000000000 -0400
+++ 09-nbd-caller-change/drivers/block/nbd.c	2007-09-10 18:02:30.000000000 -0400
@@ -107,9 +107,7 @@ static void nbd_end_request(struct reque
 			req, uptodate? "done": "failed");
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (!end_that_request_first(req, uptodate, req->nr_sectors)) {
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, uptodate, req->nr_sectors << 9);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
