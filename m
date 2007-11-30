From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 05/28] blk_end_request: changing um (take 3)
Date: Fri, 30 Nov 2007 18:26:35 -0500 (EST)
Message-ID: <20071130.182635.31637441.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts um to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 arch/um/drivers/ubd_kern.c |   10 +---------
 1 files changed, 1 insertion(+), 9 deletions(-)

Index: 2.6.24-rc3-mm2/arch/um/drivers/ubd_kern.c
===================================================================
--- 2.6.24-rc3-mm2.orig/arch/um/drivers/ubd_kern.c
+++ 2.6.24-rc3-mm2/arch/um/drivers/ubd_kern.c
@@ -481,15 +481,7 @@ int thread_fd = -1;
 
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
