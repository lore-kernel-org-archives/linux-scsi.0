From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/25] dm kcopyd: switch to use REQ_OP_WRITE_ZEROES
Date: Fri, 31 Mar 2017 18:32:56 +0200
Message-ID: <20170331163313.31821-9-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:32945 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933395AbdCaQds (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 12:33:48 -0400
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

It seems like the code currently passes whatever it was using for writes
to WRITE SAME.  Just switch it to WRITE ZEROES, although that doesn't
need any payload.

Untested, and confused by the code, maybe someone who understands it
better than me can help..

Not-yet-signed-off-by: Christoph Hellwig <hch@lst.de>
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
