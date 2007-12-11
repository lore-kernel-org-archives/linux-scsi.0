From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 05/30] blk_end_request: changing um (take 4)
Date: Tue, 11 Dec 2007 17:42:53 -0500 (EST)
Message-ID: <20071211.174253.106440139.k-ueda@ct.jp.nec.com>
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
Cc: linux-scsi@vger.kernel.org, jdike@karaya.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts um to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, ubd_end_request(),
is changed.

Cc: Jeff Dike <jdike@karaya.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 arch/um/drivers/ubd_kern.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

Index: 2.6.24-rc4/arch/um/drivers/ubd_kern.c
===================================================================
--- 2.6.24-rc4.orig/arch/um/drivers/ubd_kern.c
+++ 2.6.24-rc4/arch/um/drivers/ubd_kern.c
@@ -475,17 +475,9 @@ static void do_ubd_request(struct reques
 /* Only changed by ubd_init, which is an initcall. */
 int thread_fd = -1;
 
-static void ubd_end_request(struct request *req, int bytes, int uptodate)
+static void ubd_end_request(struct request *req, int bytes, int error)
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
+	blk_end_request(req, error, bytes);
 }
 
 /* Callable only from interrupt context - otherwise you need to do
@@ -493,10 +485,10 @@ static void ubd_end_request(struct reque
 static inline void ubd_finish(struct request *req, int bytes)
 {
 	if(bytes < 0){
-		ubd_end_request(req, 0, 0);
+		ubd_end_request(req, 0, -EIO);
 		return;
 	}
-	ubd_end_request(req, bytes, 1);
+	ubd_end_request(req, bytes, 0);
 }
 
 static LIST_HEAD(restart);
