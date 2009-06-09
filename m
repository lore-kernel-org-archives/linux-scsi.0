From: Jens Axboe <jens.axboe@oracle.com>
Subject: [GIT PULL] block fix for 2.6.30
Date: Tue, 9 Jun 2009 15:20:57 +0200
Message-ID: <20090609132057.GM11363@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:57414 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbZFINUz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jun 2009 09:20:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Hi Linus,

Just a single fix, fixes a bad warning caused by some debug code that
triggers for a non-problem. Please pull for 2.6.30!

  git://git.kernel.dk/linux-2.6-block.git for-linus

FUJITA Tomonori (1):
      bsg: setting rq->bio to NULL

 block/bsg.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 206060e..dd81be4 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -315,6 +315,7 @@ out:
 	blk_put_request(rq);
 	if (next_rq) {
 		blk_rq_unmap_user(next_rq->bio);
+		next_rq->bio = NULL;
 		blk_put_request(next_rq);
 	}
 	return ERR_PTR(ret);
@@ -448,6 +449,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 		hdr->dout_resid = rq->data_len;
 		hdr->din_resid = rq->next_rq->data_len;
 		blk_rq_unmap_user(bidi_bio);
+		rq->next_rq->bio = NULL;
 		blk_put_request(rq->next_rq);
 	} else if (rq_data_dir(rq) == READ)
 		hdr->din_resid = rq->data_len;
@@ -466,6 +468,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	blk_rq_unmap_user(bio);
 	if (rq->cmd != rq->__cmd)
 		kfree(rq->cmd);
+	rq->bio = NULL;
 	blk_put_request(rq);
 
 	return ret;

-- 
Jens Axboe

