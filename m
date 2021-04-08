Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4C1C43461
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 01:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CA2C61165
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 01:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhDHBrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Apr 2021 21:47:05 -0400
Received: from smtp.infotech.no ([82.134.31.41]:45299 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231267AbhDHBqp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Apr 2021 21:46:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2635020418D;
        Thu,  8 Apr 2021 03:46:30 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OqYEZGoSE8oI; Thu,  8 Apr 2021 03:46:28 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 8E60C20418F;
        Thu,  8 Apr 2021 03:46:23 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v17 43/45] sg: no_dxfer: move to/from kernel buffers
Date:   Wed,  7 Apr 2021 21:45:29 -0400
Message-Id: <20210408014531.248890-44-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210408014531.248890-1-dgilbert@interlog.com>
References: <20210408014531.248890-1-dgilbert@interlog.com>
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

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9205f126db82..0982cb031be9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2849,6 +2849,63 @@ exit_sg(void)
 	idr_destroy(&sg_index_idr);
 }
 
+static struct bio *
+sg_mk_kern_bio(int bvec_cnt)
+{
+	struct bio *biop;
+
+	if (bvec_cnt > BIO_MAX_PAGES)
+		return NULL;
+	biop = bio_alloc(GFP_ATOMIC, bvec_cnt);
+	if (!biop)
+		return NULL;
+	biop->bi_end_io = bio_put;
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
+	int num_segs = (1 << schp->page_order) * num_sgat;
+	int res = 0;
+
+	SG_LOG(4, srp->parentfp, "%s: dlen=%d, pg_sz=%d\n", __func__, dlen, pg_sz);
+	if (num_sgat <= 0)
+		return 0;
+	if (rw_ind == WRITE)
+		op_flags = REQ_SYNC | REQ_IDLE;
+	bio = sg_mk_kern_bio(num_sgat);
+	if (!bio)
+		return -ENOMEM;
+	bio->bi_opf = req_op(rqq) | op_flags;
+
+	for (k = 0; k < num_sgat && dlen > 0; ++k, dlen -= ln) {
+		ln = min_t(int, dlen, pg_sz);
+		if (bio_add_pc_page(q, bio, schp->pages[k], ln, 0) < ln) {
+			bio_put(bio);
+			return -EINVAL;
+		}
+	}
+	res = blk_rq_append_bio(rqq, &bio);
+	if (unlikely(res))
+		bio_put(bio);
+	else
+		rqq->nr_phys_segments = num_segs;
+	return res;
+}
+
 static inline void
 sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
 		struct rq_map_data *mdp)
@@ -3010,6 +3067,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		if (IS_ENABLED(CONFIG_SCSI_PROC_FS) && res)
 			SG_LOG(1, sfp, "%s: blk_rq_map_user() res=%d\n",
 			       __func__, res);
+	} else {	/* transfer data to/from kernel buffers */
+		res = sg_rq_map_kern(srp, q, rqq, r0w);
 	}
 fini:
 	if (unlikely(res)) {		/* failure, free up resources */
-- 
2.25.1

