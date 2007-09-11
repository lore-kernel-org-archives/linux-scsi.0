From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 05/27] blk_end_request: changing um (take 2)
Date: Tue, 11 Sep 2007 14:57:53 -0400 (EDT)
Message-ID: <20070911.145753.91448649.k-ueda@ct.jp.nec.com>
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

This patch converts um to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 arch/um/drivers/ubd_kern.c |   10 +---------
 1 files changed, 1 insertion(+), 9 deletions(-)

diff -rupN 04-arm-caller-change/arch/um/drivers/ubd_kern.c 05-um-caller-change/arch/um/drivers/ubd_kern.c
--- 04-arm-caller-change/arch/um/drivers/ubd_kern.c	2007-08-27 21:32:35.000000000 -0400
+++ 05-um-caller-change/arch/um/drivers/ubd_kern.c	2007-09-10 17:59:35.000000000 -0400
@@ -476,15 +476,7 @@ int thread_fd = -1;
 
 static void ubd_end_request(struct request *req, int bytes, int uptodate)
 {
-	if (!end_that_request_first(req, uptodate, bytes >> 9)) {
-		struct ubd *dev = req->rq_disk->private_data;
-		unsigned long flags;
-
-		add_disk_randomness(req->rq_disk);
-		spin_lock_irqsave(&dev->lock, flags);
-		end_that_request_last(req, uptodate);
-		spin_unlock_irqrestore(&dev->lock, flags);
-	}
+	blk_end_request(req, uptodate, bytes);
 }
 
 /* Callable only from interrupt context - otherwise you need to do
