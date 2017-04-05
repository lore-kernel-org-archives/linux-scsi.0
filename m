From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/27] dm io: discards don't take a payload
Date: Wed,  5 Apr 2017 19:21:04 +0200
Message-ID: <20170405172125.22600-7-hch@lst.de>
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

Fix up do_region to not allocate a bio_vec for discards.  We've
got rid of the discard payload allocated by the caller years ago.

Obviously this wasn't actually harmful given how long it's been
there, but it's still good to avoid the pointless allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-io.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 03940bf36f6c..b808cbe22678 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -328,11 +328,17 @@ static void do_region(int op, int op_flags, unsigned region,
 		/*
 		 * Allocate a suitably sized-bio.
 		 */
-		if ((op == REQ_OP_DISCARD) || (op == REQ_OP_WRITE_SAME))
+		switch (op) {
+		case REQ_OP_DISCARD:
+			num_bvecs = 0;
+			break;
+		case REQ_OP_WRITE_SAME:
 			num_bvecs = 1;
-		else
+			break;
+		default:
 			num_bvecs = min_t(int, BIO_MAX_PAGES,
 					  dm_sector_div_up(remaining, (PAGE_SIZE >> SECTOR_SHIFT)));
+		}
 
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_iter.bi_sector = where->sector + (where->count - remaining);
-- 
2.11.0
