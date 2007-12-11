From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 12/30] blk_end_request: changing ub (take 4)
Date: Tue, 11 Dec 2007 17:46:47 -0500 (EST)
Message-ID: <20071211.174647.75757994.k-ueda@ct.jp.nec.com>
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
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, zaitcev@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts ub to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

Cc: Pete Zaitcev <zaitcev@redhat.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/ub.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

Index: 2.6.24-rc4/drivers/block/ub.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/ub.c
+++ 2.6.24-rc4/drivers/block/ub.c
@@ -808,16 +808,16 @@ static void ub_rw_cmd_done(struct ub_dev
 
 static void ub_end_rq(struct request *rq, unsigned int scsi_status)
 {
-	int uptodate;
+	int error;
 
 	if (scsi_status == 0) {
-		uptodate = 1;
+		error = 0;
 	} else {
-		uptodate = 0;
+		error = -EIO;
 		rq->errors = scsi_status;
 	}
-	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
-	end_that_request_last(rq, uptodate);
+	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
+		BUG();
 }
 
 static int ub_rw_cmd_retry(struct ub_dev *sc, struct ub_lun *lun,
