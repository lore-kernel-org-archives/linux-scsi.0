From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/27] dm kcopyd: switch to use
	REQ_OP_WRITE_ZEROES
Date: Wed,  5 Apr 2017 19:21:06 +0200
Message-ID: <20170405172125.22600-9-hch@lst.de>
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

It seems like the code currently passes whatever it was using for writes
to WRITE SAME.  Just switch it to WRITE ZEROES, although that doesn't
need any payload.

Untested, and confused by the code, maybe someone who understands it
better than me can help..

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-kcopyd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 9e9d04cb7d51..f85846741d50 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -733,11 +733,11 @@ int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 		job->pages = &zero_page_list;
 
 		/*
-		 * Use WRITE SAME to optimize zeroing if all dests support it.
+		 * Use WRITE ZEROES to optimize zeroing if all dests support it.
 		 */
-		job->rw = REQ_OP_WRITE_SAME;
+		job->rw = REQ_OP_WRITE_ZEROES;
 		for (i = 0; i < job->num_dests; i++)
-			if (!bdev_write_same(job->dests[i].bdev)) {
+			if (!bdev_write_zeroes_sectors(job->dests[i].bdev)) {
 				job->rw = WRITE;
 				break;
 			}
-- 
2.11.0
