From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/19] md: cleanup bio op / flags handling in raid1_write_request
Date: Fri, 27 Jan 2017 17:35:01 +0100
Message-ID: <1485534918-18239-3-git-send-email-hch@lst.de>
References: <1485534918-18239-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:32770 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933449AbdA0Qfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2017 11:35:36 -0500
In-Reply-To: <1485534918-18239-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com

No need for the local variables, the bio is still live and we can just
assign the bits we want directly.  Make me wonder why we can't assign
all the bio flags to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/md/raid1.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b0f647..67b0365 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1170,10 +1170,6 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	int i, disks;
 	struct bitmap *bitmap = mddev->bitmap;
 	unsigned long flags;
-	const int op = bio_op(bio);
-	const unsigned long do_sync = (bio->bi_opf & REQ_SYNC);
-	const unsigned long do_flush_fua = (bio->bi_opf &
-						(REQ_PREFLUSH | REQ_FUA));
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
 	struct raid1_plug_cb *plug = NULL;
@@ -1389,7 +1385,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				   conf->mirrors[i].rdev->data_offset);
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		bio_set_op_attrs(mbio, op, do_flush_fua | do_sync);
+		mbio->bi_opf = bio_op(bio) |
+			(bio->bi_opf & (REQ_SYNC | REQ_PREFLUSH | REQ_FUA));
 		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags) &&
 		    !test_bit(WriteMostly, &conf->mirrors[i].rdev->flags) &&
 		    conf->raid_disks - mddev->degraded > 1)
-- 
2.1.4

