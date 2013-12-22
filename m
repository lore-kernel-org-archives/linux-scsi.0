From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: status of block-integrity
Date: Sun, 22 Dec 2013 12:45:55 -0800
Message-ID: <1387745155.5567.96.camel@haakon3.risingtidesystems.com>
References: <20131222192128.GA28532@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131222192128.GA28532@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2013-12-22 at 11:21 -0800, Christoph Hellwig wrote:
> We have the block integrity code to support DIF/DIX in the the tree for
> about 5 and a half years, and we still don't have a single consumer of
> it.  By normal kernel rules it should never have been merged, or at
> least the bitrot long removed.

Is not sd_dif.c a consumer of blk_integrity.c logic..?

> Given that we'll have a lot of work to do in this area with block
> multiqueue I think it's time to either kill it off for good or make sure
> we can actually use and test it.

Speak of the devil..

I've been working on enabling DIF support in scsi-mq recently, and
AFAICT the only part that is required in blk-mq for DIF emulation to
function with scsi-debug is the following patch.

commit 1428a390cc16025f93905852777d4afd8aeba05d
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sun Dec 22 11:58:49 2013 +0000

    blk-mq: Add bio_integrity setup to blk_mq_make_request
    
    This patch adds the missing bio_integrity_enabled() +
    bio_integrity_prep() setup into blk_mq_make_request()
    in order to use DIF protection with scsi-mq.
    
    Cc: Jens Axboe <axboe@kernel.dk>
    Cc: Martin K. Petersen <martin.petersen@oracle.com>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c79126e..a520c39 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -916,6 +916,11 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 
        blk_queue_bounce(q, &bio);
 
+       if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
+               bio_endio(bio, -EIO);
+               return;
+       }
+
        if (use_plug && blk_attempt_plug_merge(q, bio, &request_count))
                return;
