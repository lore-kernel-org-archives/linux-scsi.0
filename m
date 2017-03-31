From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/25] dm io: discards don't take a payload
Date: Fri, 31 Mar 2017 18:32:54 +0200
Message-ID: <20170331163313.31821-7-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57253 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933272AbdCaQdh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 12:33:37 -0400
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

Fix up do_region to not allocate a bio_vec for discards.  We've
got rid of the discard payload allocated by the caller years ago.

Obviously this wasn't actually harmful given how long it's been
there, but it's still good to avoid the pointless allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
