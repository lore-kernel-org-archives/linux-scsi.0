From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 12/27] blk_end_request: changing sx8 (take 2)
Date: Tue, 11 Sep 2007 15:00:32 -0400 (EDT)
Message-ID: <20070911.150032.15584999.k-ueda@ct.jp.nec.com>
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

This patch converts sx8 to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/sx8.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -rupN 11-sunvdc-caller-change/drivers/block/sx8.c 12-sx8-caller-change/drivers/block/sx8.c
--- 11-sunvdc-caller-change/drivers/block/sx8.c	2007-08-27 21:32:35.000000000 -0400
+++ 12-sx8-caller-change/drivers/block/sx8.c	2007-09-10 18:04:02.000000000 -0400
@@ -747,11 +747,9 @@ static inline void carm_end_request_queu
 	struct request *req = crq->rq;
 	int rc;
 
-	rc = end_that_request_first(req, uptodate, req->hard_nr_sectors);
+	rc = __blk_end_request(req, uptodate, blk_rq_size(req));
 	assert(rc == 0);
 
-	end_that_request_last(req, uptodate);
-
 	rc = carm_put_request(host, crq);
 	assert(rc == 0);
 }
