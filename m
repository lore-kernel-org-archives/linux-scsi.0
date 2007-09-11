From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 14/27] blk_end_request: changing viodasd (take 2)
Date: Tue, 11 Sep 2007 15:01:10 -0400 (EDT)
Message-ID: <20070911.150110.78388754.k-ueda@ct.jp.nec.com>
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

This patch converts viodasd to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/viodasd.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -rupN 13-ub-caller-change/drivers/block/viodasd.c 14-viodasd-caller-change/drivers/block/viodasd.c
--- 13-ub-caller-change/drivers/block/viodasd.c	2007-08-27 21:32:35.000000000 -0400
+++ 14-viodasd-caller-change/drivers/block/viodasd.c	2007-09-10 18:05:02.000000000 -0400
@@ -275,10 +275,7 @@ static struct block_device_operations vi
 static void viodasd_end_request(struct request *req, int uptodate,
 		int num_sectors)
 {
-	if (end_that_request_first(req, uptodate, num_sectors))
-		return;
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
+	__blk_end_request(req, uptodate, num_sectors << 9);
 }
 
 /*
