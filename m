From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 11/27] blk_end_request: changing sunvdc (take 2)
Date: Tue, 11 Sep 2007 15:00:01 -0400 (EDT)
Message-ID: <20070911.150001.39667186.k-ueda@ct.jp.nec.com>
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

This patch converts sunvdc to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/sunvdc.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -rupN 10-ps3disk-caller-change/drivers/block/sunvdc.c 11-sunvdc-caller-change/drivers/block/sunvdc.c
--- 10-ps3disk-caller-change/drivers/block/sunvdc.c	2007-08-27 21:32:35.000000000 -0400
+++ 11-sunvdc-caller-change/drivers/block/sunvdc.c	2007-09-10 18:03:31.000000000 -0400
@@ -213,10 +213,7 @@ static void vdc_end_special(struct vdc_p
 
 static void vdc_end_request(struct request *req, int uptodate, int num_sectors)
 {
-	if (end_that_request_first(req, uptodate, num_sectors))
-		return;
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
+	__blk_end_request(req, uptodate, num_sectors << 9);
 }
 
 static void vdc_end_one(struct vdc_port *port, struct vio_dring_state *dr,
