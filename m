From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 22/27] blk_end_request: changing xsysace (take 2)
Date: Tue, 11 Sep 2007 15:03:49 -0400 (EDT)
Message-ID: <20070911.150349.43387432.k-ueda@ct.jp.nec.com>
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

This patch converts xsysace to use blk_end_request().

xsysace is a little bit different from "normal" drivers.
xsysace driver has a state machine in it.
It calls end_that_request_first() and end_that_request_last()
from different states. (ACE_FSM_STATE_REQ_TRANSFER and
ACE_FSM_STATE_REQ_COMPLETE, respectively.)

However, those states are consecutive and without any interruption
inbetween.
So we can just follow the standard conversion rule (b) mentioned in
the patch subject "[PATCH 01/27] blk_end_request: add new request
completion interface".

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/xsysace.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -rupN 21-ide-scsi-caller-change/drivers/block/xsysace.c 22-xsysace-caller-change/drivers/block/xsysace.c
--- 21-ide-scsi-caller-change/drivers/block/xsysace.c	2007-09-10 17:32:11.000000000 -0400
+++ 22-xsysace-caller-change/drivers/block/xsysace.c	2007-09-10 18:14:20.000000000 -0400
@@ -696,7 +696,7 @@ static void ace_fsm_dostate(struct ace_d
 
 		/* bio finished; is there another one? */
 		i = ace->req->current_nr_sectors;
-		if (end_that_request_first(ace->req, 1, i)) {
+		if (__blk_end_request(ace->req, 1, i)) {
 			/* dev_dbg(ace->dev, "next block; h=%li c=%i\n",
 			 *      ace->req->hard_nr_sectors,
 			 *      ace->req->current_nr_sectors);
@@ -711,9 +711,6 @@ static void ace_fsm_dostate(struct ace_d
 		break;
 
 	case ACE_FSM_STATE_REQ_COMPLETE:
-		/* Complete the block request */
-		blkdev_dequeue_request(ace->req);
-		end_that_request_last(ace->req, 1);
 		ace->req = NULL;
 
 		/* Finished request; go to idle state */
