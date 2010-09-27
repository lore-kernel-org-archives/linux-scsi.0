From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] block: eliminate potential for infinite loop in
 blkdev_issue_discard
Date: Mon, 27 Sep 2010 14:13:22 -0400
Message-ID: <20100927181321.GC14180@redhat.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
 <1285605664-27027-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab0I0SNc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 14:13:32 -0400
Content-Disposition: inline
In-Reply-To: <1285605664-27027-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com

Due to the recently identified overflow in read_capacity_16() it was
possible for max_discard_sectors to be zero but still have discards
enabled on the associated device's queue.

Eliminate the possibility for blkdev_issue_discard to infinitely loop.

Interestingly this issue wasn't identified until a device, whose
discard_granularity was 0 due to read_capacity_16 overflow, was consumed
by blk_stack_limits() to construct limits for a higher-level DM
multipath device.  The multipath device's resulting limits never had the
discard limits stacked because blk_stack_limits() will only do so if
the bottom device's discard_granularity != 0.  This resulted in the
multipath device's limits.max_discard_sectors being 0.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-lib.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index c392029..186f249 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -56,7 +56,10 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	 * granularity
 	 */
 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
-	if (q->limits.discard_granularity) {
+	if (unlikely(!max_discard_sectors)) {
+		/* Avoid infinite loop (below) */
+		return -EOPNOTSUPP;
+	} else if (q->limits.discard_granularity) {
 		unsigned int disc_sects = q->limits.discard_granularity >> 9;
 
 		max_discard_sectors &= ~(disc_sects - 1);
