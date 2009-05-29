From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH block#for-2.6.31] block: fix an oops on BLKPREP_KILL
Date: Fri, 29 May 2009 22:18:23 +0000
Message-ID: <1243635503.2919.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, Jens Axboe <Jens.Axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Doing a bit of torture testing, I ran across a BUG in the block
subsystem (at blk-core.c:2048): the test for if the request is queued.

It turns out the trigger was a BLKPREP_KILL coming out of the SCSI prep
function.  Currently for BLKPREP_KILL requests, we send them straight
into __blk_end_request_all() with an error, but they've never been
dequeued, so they trip the bug.  Fix this by starting requests before
killing them.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 8b3b74e..9a0568c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1789,6 +1789,7 @@ struct request *blk_peek_request(struct request_queue *q)
 			break;
 		} else if (ret == BLKPREP_KILL) {
 			rq->cmd_flags |= REQ_QUIET;
+			blk_start_request(rq);
 			__blk_end_request_all(rq, -EIO);
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);


