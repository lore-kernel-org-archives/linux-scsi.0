From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/30] ide: remove unnecessary
	blk_queue_flushing() test in do_ide_request()
Date: Wed, 25 Aug 2010 17:47:18 +0200
Message-ID: <1282751267-3530-2-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@l
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Unplugging from a request function doesn't really help much (it's
already in the request_fn) and soon block layer will be updated to mix
barrier sequence with other commands, so there's no need to treat
queue flushing any differently.

ide was the only user of blk_queue_flushing().  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: David S. Miller <davem@davemloft.net>
---
 drivers/ide/ide-io.c   |   13 -------------
 include/linux/blkdev.h |    1 -
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index a381be8..999dac0 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -441,19 +441,6 @@ void do_ide_request(struct request_queue *q)
 	struct request	*rq = NULL;
 	ide_startstop_t	startstop;
 
-	/*
-	 * drive is doing pre-flush, ordered write, post-flush sequence. even
-	 * though that is 3 requests, it must be seen as a single transaction.
-	 * we must not preempt this drive until that is complete
-	 */
-	if (blk_queue_flushing(q))
-		/*
-		 * small race where queue could get replugged during
-		 * the 3-request flush cycle, just yank the plug since
-		 * we want it to finish asap
-		 */
-		blk_remove_plug(q);
-
 	spin_unlock_irq(q->queue_lock);
 
 	/* HLD do_request() callback might sleep, make sure it's okay */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2c54906..015375c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -521,7 +521,6 @@ enum {
 #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
 #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
 #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
-#define blk_queue_flushing(q)	((q)->ordseq)
 #define blk_queue_stackable(q)	\
 	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
 #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
-- 
1.7.1
