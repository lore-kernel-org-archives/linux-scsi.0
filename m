Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8BAFA373D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiJXD0H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiJXDXJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:23:09 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49CA075486
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:22:01 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DF2C12041BD;
        Mon, 24 Oct 2022 05:22:00 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dggw5tCBkvan; Mon, 24 Oct 2022 05:22:00 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id A6FB72041AF;
        Mon, 24 Oct 2022 05:21:59 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v25 40/44] sg: no_dxfer: move to/from kernel buffers
Date:   Sun, 23 Oct 2022 23:20:54 -0400
Message-Id: <20221024032058.14077-41-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the NO_DXFER flag is use on a command/request, the data-in
and data-out buffers (if present) should not be ignored. Add
sg_rq_map_kern() function to handle this. Uses a single bio with
multiple bvec_s usually each holding multiple pages, if necessary.
The driver default element size is 32 KiB so if PAGE_SIZE is 4096
then get_order()==3 .

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 78 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f6acb1cffc57..94f55ce27c64 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2278,6 +2278,24 @@ static const struct vm_operations_struct sg_mmap_vm_ops = {
 	.close = sg_vma_close,
 };
 
+static inline void
+sg_bio_get(struct bio *bio)
+{
+	bio_get(bio);
+}
+
+static void
+sg_bio_put(struct bio *bio)
+{
+	if (unlikely(bio_flagged(bio, BIO_REFFED))) {
+		WARN_ON(!atomic_read(&bio->__bi_cnt));
+		if (!atomic_dec_and_test(&bio->__bi_cnt))
+			return;
+	}
+	bio_uninit(bio);
+	kfree(bio);
+}
+
 /*
  * Entry point for mmap(2) system call. For mmap(2) to work, request's
  * scatter gather list needs to be order 0 which it is unlikely to be
@@ -2792,6 +2810,59 @@ exit_sg(void)
 	idr_destroy(&sg_index_idr);
 }
 
+static struct bio *
+sg_mk_kern_bio(int bvec_cnt)
+{
+	struct bio *biop;
+
+	if (bvec_cnt > BIO_MAX_VECS)
+		return NULL;
+	biop = bio_kmalloc(bvec_cnt, GFP_ATOMIC);
+	if (!biop)
+		return NULL;
+	return biop;
+}
+
+/*
+ * Setup to move data between kernel buffers managed by this driver and a SCSI device. Note that
+ * there is no corresponding 'unmap' call as is required by blk_rq_map_user() . Uses a single
+ * bio with an expanded appended bvec if necessary.
+ */
+static int
+sg_rq_map_kern(struct sg_request *srp, struct request_queue *q, struct request *rqq, int rw_ind)
+{
+	struct sg_scatter_hold *schp = &srp->sgat_h;
+	struct bio *bio;
+	int k, ln;
+	int op_flags = 0;
+	int num_sgat = schp->num_sgat;
+	int dlen = schp->dlen;
+	int pg_sz = 1 << (PAGE_SHIFT + schp->page_order);
+
+	SG_LOG(4, srp->parentfp, "%s: dlen=%d, pg_sz=%d\n", __func__, dlen, pg_sz);
+	if (num_sgat <= 0)
+		return 0;
+	if (rw_ind == WRITE)
+		op_flags = REQ_SYNC | REQ_IDLE;
+	bio = sg_mk_kern_bio(num_sgat);
+	if (!bio)
+		return -ENOMEM;
+	bio_init(bio, NULL, bio->bi_inline_vecs, num_sgat, (req_op(rqq) | op_flags));
+	bio->bi_end_io = sg_bio_put;
+
+	for (k = 0; k < num_sgat && dlen > 0; ++k, dlen -= ln) {
+		ln = min_t(int, dlen, pg_sz);
+		if (bio_add_pc_page(q, bio, schp->pages[k], ln, 0) < ln) {
+			sg_bio_put(bio);
+			return -EINVAL;
+		}
+	}
+	/* used blk_rq_append_bio() before but this is simpler */
+	blk_rq_bio_prep(rqq, bio, num_sgat);
+	rqq->nr_phys_segments = (1 << schp->page_order) * num_sgat;
+	return 0;
+}
+
 static inline void
 sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
 		struct rq_map_data *mdp)
@@ -2916,8 +2987,11 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		md->from_user = (dxfer_dir == SG_DXFER_TO_FROM_DEV);
 	}
 
-	res = blk_rq_map_user_io(rqq, md, up, dxfer_len, GFP_ATOMIC,
-				 iov_count, iov_count, 1, r0w);
+	if (us_xfer)
+		res = blk_rq_map_user_io(rqq, md, up, dxfer_len, GFP_ATOMIC,
+					 iov_count, iov_count, 1, r0w);
+	else 	/* transfer data to/from kernel buffers */
+		res = sg_rq_map_kern(srp, q, rqq, r0w);
 fini:
 	if (unlikely(res)) {		/* failure, free up resources */
 		WRITE_ONCE(srp->rqq, NULL);
-- 
2.37.3

