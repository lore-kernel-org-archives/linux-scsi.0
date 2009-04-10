From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 1/3] block/blk-map.c: blk_rq_append_bio should ensure it's not appending a chain
Date: Fri, 10 Apr 2009 07:48:21 -0400
Message-ID: <20090410114821.GA10602@havoc.gtf.org>
References: <20090402015455.GA14087@havoc.gtf.org> <20090407225302.GA14248@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934857AbZDJLsm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090407225302.GA14248@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, osd-dev@open-osd.org
List-Id: linux-scsi@vger.kernel.org


Add a standard bit of list safety.  The other functions called in
blk_rq_append_bio() are written to assume only a single bio is passed to
them.  Therefore, it is an error to _ever_ pass a list to this function.

Enforce this error by ensuring the bio list is guaranteed to only append
a single list item with each blk_rq_append_bio() call.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/block/blk-map.c b/block/blk-map.c
index f103729..a7eeac4 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -19,6 +19,7 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 	else {
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
+		bio->bi_next = NULL;
 
 		rq->data_len += bio->bi_size;
 	}
