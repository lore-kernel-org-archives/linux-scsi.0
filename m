From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 12/28] blk_end_request: changing ub (take 3)
Date: Fri, 30 Nov 2007 18:29:49 -0500 (EST)
Message-ID: <20071130.182949.118947603.k-ueda@ct.jp.nec.com>
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

This patch converts ub to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/ub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/block/ub.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/ub.c
+++ 2.6.24-rc3-mm2/drivers/block/ub.c
@@ -816,8 +816,8 @@ static void ub_end_rq(struct request *rq
 		uptodate = 0;
 		rq->errors = scsi_status;
 	}
-	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
-	end_that_request_last(rq, uptodate);
+	if (__blk_end_request(rq, uptodate, blk_rq_bytes(rq)))
+		BUG();
 }
 
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
