From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 15/28] blk_end_request: changing viocd (take 3)
Date: Fri, 30 Nov 2007 18:30:54 -0500 (EST)
Message-ID: <20071130.183054.66181916.k-ueda@ct.jp.nec.com>
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

This patch converts viocd to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/cdrom/viocd.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/cdrom/viocd.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/cdrom/viocd.c
+++ 2.6.24-rc3-mm2/drivers/cdrom/viocd.c
@@ -302,11 +302,8 @@ static void viocd_end_request(struct req
 	if (!nsectors)
 		nsectors = 1;
 
-	if (end_that_request_first(req, uptodate, nsectors))
+	if (__blk_end_request(req, uptodate, nsectors << 9))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 }
 
 static int rwreq;
