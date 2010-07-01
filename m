From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] scsi: address leak in the error path of discard page
 allocation
Date: Thu, 1 Jul 2010 09:03:28 -0400
Message-ID: <20100701130328.GB19605@redhat.com>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab0GANDq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2010 09:03:46 -0400
Content-Disposition: inline
In-Reply-To: <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org

On Thu, Jul 01 2010 at  6:49am -0400,
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This fixes discard page leak by using q->unprep_rq_fn facility.
> 
> q->unprep_rq_fn is called when all the data buffer (req->bio and
> scsi_data_buffer) in the request is freed.
> 
> sd_unprep() uses rq->buffer to free discard page allocated in
> sd_prepare_discard().
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks for sorting this out Tomo, all 3 patches work great!

BTW, there is one remaining (rare) leak in the allocation path.

The following patch serves to fix it but I'm not sure if there is a more
elegant way to address this.

An alternative would be to check if the page is already allocated
(before allocating the page in scsi_setup_discard_cmnd)?

Please advise, thanks.
Mike



From: Mike Snitzer <snitzer@redhat.com>
Subject: scsi: address leak in the error path of discard page allocation

Be sure to free the discard page if scsi_setup_blk_pc_cmnd fails.
E.g. Returning BLKPREP_DEFER from scsi_setup_blk_pc_cmnd will not cause
the request to be processed by sd_unprep_fn before the request is
retried (preparation included).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---
 block/blk-core.c       |   23 +++++++++++++++++++++++
 drivers/scsi/sd.c      |    6 +++++-
 include/linux/blkdev.h |    1 +
 3 files changed, 29 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c
+++ linux-2.6/drivers/scsi/sd.c
@@ -466,7 +466,11 @@ static int scsi_setup_discard_cmnd(struc
 
 	blk_add_request_payload(rq, page, len);
 	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
-	rq->buffer = page_address(page);
+	if (ret != BLKPREP_OK) {
+		blk_clear_request_payload(rq);
+		__free_page(page);
+	} else
+		rq->buffer = page_address(page);
 	return ret;
 }
 
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -1164,6 +1164,29 @@ void blk_add_request_payload(struct requ
 }
 EXPORT_SYMBOL_GPL(blk_add_request_payload);
 
+/**
+ * blk_clear_request_payload - clear a request's payload
+ * @rq: request to update
+ *
+ * The driver needs to take care of freeing the payload itself.
+ */
+void blk_clear_request_payload(struct request *rq)
+{
+	struct bio *bio = rq->bio;
+
+	rq->__data_len = rq->resid_len = 0;
+	rq->nr_phys_segments = 0;
+	rq->buffer = NULL;
+
+	bio->bi_size = 0;
+	bio->bi_vcnt = 0;
+	bio->bi_phys_segments = 0;
+
+	bio->bi_io_vec->bv_page = NULL;
+	bio->bi_io_vec->bv_len = 0;
+}
+EXPORT_SYMBOL_GPL(blk_clear_request_payload);
+
 void init_request_from_bio(struct request *req, struct bio *bio)
 {
 	req->cpu = bio->bi_comp_cpu;
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -781,6 +781,7 @@ extern void blk_insert_request(struct re
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern void blk_add_request_payload(struct request *rq, struct page *page,
 		unsigned int len);
+extern void blk_clear_request_payload(struct request *rq);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
 extern int blk_lld_busy(struct request_queue *q);
 extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
