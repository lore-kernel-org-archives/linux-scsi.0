From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/27] rsxx: remove the discard_zeroes_data flag
Date: Wed,  5 Apr 2017 19:21:18 +0200
Message-ID: <20170405172125.22600-21-hch@lst.de>
References: <20170405172125.22600-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170405172125.22600-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

rsxx only supports discarding on large alignments, so the zeroing code
would always fall back to explicit writings of zeroes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/block/rsxx/dev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index f81d70b39d10..9c566364ac9c 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -300,7 +300,6 @@ int rsxx_setup_dev(struct rsxx_cardinfo *card)
 						RSXX_HW_BLK_SIZE >> 9);
 		card->queue->limits.discard_granularity = RSXX_HW_BLK_SIZE;
 		card->queue->limits.discard_alignment   = RSXX_HW_BLK_SIZE;
-		card->queue->limits.discard_zeroes_data = 1;
 	}
 
 	card->queue->queuedata = card;
-- 
2.11.0
