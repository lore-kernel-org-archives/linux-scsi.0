From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 19/27] blk_end_request: changing s390 (take 2)
Date: Tue, 11 Sep 2007 15:02:49 -0400 (EDT)
Message-ID: <20070911.150249.78157677.k-ueda@ct.jp.nec.com>
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

This patch converts s390 to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/s390/block/dasd.c      |    4 +---
 drivers/s390/char/tape_block.c |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff -rupN 18-mmc-caller-change/drivers/s390/block/dasd.c 19-s390-caller-change/drivers/s390/block/dasd.c
--- 18-mmc-caller-change/drivers/s390/block/dasd.c	2007-08-27 21:32:35.000000000 -0400
+++ 19-s390-caller-change/drivers/s390/block/dasd.c	2007-09-10 18:09:25.000000000 -0400
@@ -1080,10 +1080,8 @@ dasd_int_handler(struct ccw_device *cdev
 static inline void
 dasd_end_request(struct request *req, int uptodate)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	if (__blk_end_request(req, uptodate, blk_rq_size(req)))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
 }
 
 /*
diff -rupN 18-mmc-caller-change/drivers/s390/char/tape_block.c 19-s390-caller-change/drivers/s390/char/tape_block.c
--- 18-mmc-caller-change/drivers/s390/char/tape_block.c	2007-08-27 21:32:35.000000000 -0400
+++ 19-s390-caller-change/drivers/s390/char/tape_block.c	2007-09-10 18:09:25.000000000 -0400
@@ -76,9 +76,8 @@ tapeblock_trigger_requeue(struct tape_de
 static void
 tapeblock_end_request(struct request *req, int uptodate)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	if (__blk_end_request(req, uptodate, blk_rq_size(req)))
 		BUG();
-	end_that_request_last(req, uptodate);
 }
 
 static void
