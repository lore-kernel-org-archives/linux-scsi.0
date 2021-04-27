Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C10C43600
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F5B7613B0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbhD0WAl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:41 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38999 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239478AbhD0WAP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 328BA2042A6;
        Tue, 27 Apr 2021 23:59:28 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 84sC0w6VpzWG; Tue, 27 Apr 2021 23:59:25 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 556012041BD;
        Tue, 27 Apr 2021 23:59:24 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 71/83] sg: add mmap IO option for mrq metadata
Date:   Tue, 27 Apr 2021 17:57:21 -0400
Message-Id: <20210427215733.417746-73-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SG_FLAG_MMAP_IO is not very useful on individual elements in a
multiple request invocation. That is because a mrq invocation involves
one or maybe two file descriptors. mmap()-ed IO buffers are bound to a
single file descriptor. And one or possibly two is not enough IO data
buffers for mrq to be practical.

This patch adds SG_FLAG_MMAP_IO functionality to the control object in
a mrq request. When set on a mrq control object, then instead of the
returning metadata being send to din_xferp, it is sent, one element at
a time (on its completion) to the mmap(2)-ed buffer. So the user space
program must call mmap(2) before using the SG_FLAG_MMAP_IO (and that
now applies to all usages of that flag, the code was too lenient in
that area prior to this).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 202 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 172 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index bdb9b3dbf970..48bf5ccca5b5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -338,13 +338,15 @@ struct sg_mrq_hold {	/* for passing context between mrq functions */
 	bool chk_abort;
 	bool immed;
 	bool stop_if;
+	bool co_mmap;
 	int id_of_mrq;
 	int s_res;		/* secondary error: some-good-then-error */
 	u32 cdb_mxlen;		/* cdb length in cdb_ap, actual be may less */
 	u32 tot_reqs;		/* total number of requests and cdb_s */
-	struct sg_comm_wr_t *cwrp;
+	struct sg_comm_wr_t *cwrp;	/* cwrp->h4p is mrq control object */
 	u8 *cdb_ap;		/* array of commands */
 	struct sg_io_v4 *a_hds;	/* array of request to execute */
+	struct sg_scatter_hold *co_mmap_sgatp;
 };
 
 /* tasklet or soft irq callback */
@@ -966,6 +968,109 @@ sg_v4h_partial_zero(struct sg_io_v4 *h4p)
 	memset((u8 *)h4p + off, 0, SZ_SG_IO_V4 - off);
 }
 
+static void
+sg_sgat_zero(struct sg_scatter_hold *sgatp, int off, int nbytes)
+{
+	int k, rem, off_pl_nbyt;
+	int ind = 0;
+	int pg_ind = 0;
+	int num_sgat = sgatp->num_sgat;
+	int elem_sz = PAGE_SIZE * (1 << sgatp->page_order);
+	struct page *pg_ep = sgatp->pages[pg_ind];
+
+	if (off >= sgatp->dlen)
+		return;
+	off_pl_nbyt = off + nbytes;
+	if (off_pl_nbyt >= sgatp->dlen) {
+		nbytes = sgatp->dlen - off;
+		off_pl_nbyt = off + nbytes;
+	}
+	/* first loop steps over off bytes, second loop zeros nbytes */
+	for (k = 0; k < off; k += rem) {
+		rem = off - k;
+		if (rem >= elem_sz) {
+			++pg_ind;
+			if (pg_ind >= num_sgat)
+				return;
+			rem = elem_sz;
+			ind = 0;
+		} else {
+			ind = elem_sz - rem;
+		}
+	}
+	pg_ep = sgatp->pages[pg_ind];
+	for ( ; k < off_pl_nbyt; k += rem) {
+		rem = off_pl_nbyt - k;
+		if (rem >= elem_sz) {
+			memset((u8 *)pg_ep + ind, 0, elem_sz - ind);
+			if (++pg_ind >= num_sgat)
+				return;
+			pg_ep = sgatp->pages[pg_ind];
+			rem = elem_sz;
+			ind = 0;
+		} else {
+			memset((u8 *)pg_ep + ind, 0, rem - ind);
+			ind = elem_sz - rem;
+		}
+	}
+}
+
+/*
+ * Copies nbytes from the start of 'fromp' into sgatp (this driver's scatter
+ * gather list representation) starting at byte offset 'off'. If nbytes is
+ * too long then it is trimmed.
+ */
+static void
+sg_sgat_cp_into(struct sg_scatter_hold *sgatp, int off, const u8 *fromp,
+		int nbytes)
+{
+	int k, rem, off_pl_nbyt;
+	int ind = 0;
+	int from_off = 0;
+	int pg_ind = 0;
+	int num_sgat = sgatp->num_sgat;
+	int elem_sz = PAGE_SIZE * (1 << sgatp->page_order);
+	struct page *pg_ep = sgatp->pages[pg_ind];
+
+	if (off >= sgatp->dlen)
+		return;
+	off_pl_nbyt = off + nbytes;
+	if (off_pl_nbyt >= sgatp->dlen) {
+		nbytes = sgatp->dlen - off;
+		off_pl_nbyt = off + nbytes;
+	}
+	/* first loop steps over off bytes, second loop zeros nbytes */
+	for (k = 0; k < off; k += rem) {
+		rem = off - k;
+		if (rem >= elem_sz) {
+			++pg_ind;
+			if (pg_ind >= num_sgat)
+				return;
+			rem = elem_sz;
+			ind = 0;
+		} else {
+			ind = elem_sz - rem;
+		}
+	}
+	pg_ep = sgatp->pages[pg_ind];
+	for ( ; k < off_pl_nbyt; k += rem) {
+		rem = off_pl_nbyt - k;
+		if (rem >= elem_sz) {
+			memcpy((u8 *)pg_ep + ind, fromp + from_off,
+			       elem_sz - ind);
+			if (++pg_ind >= num_sgat)
+				return;
+			pg_ep = sgatp->pages[pg_ind];
+			rem = elem_sz;
+			ind = 0;
+			from_off += elem_sz - ind;
+		} else {
+			memcpy((u8 *)pg_ep + ind, fromp + from_off, rem - ind);
+			/* last time around, no need to update indexes */
+		}
+	}
+}
+
 /*
  * Takes a pointer (cop) to the multiple request (mrq) control object and
  * a pointer to the command array. The command array (with tot_reqs elements)
@@ -1018,7 +1123,12 @@ sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *do_on_sfp,
 	if (unlikely(s_res == -EFAULT))
 		return s_res;
 	hp->info |= SG_INFO_MRQ_FINI;
-	if (do_on_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
+	if (mhp->co_mmap) {
+		sg_sgat_cp_into(mhp->co_mmap_sgatp, indx * SZ_SG_IO_V4,
+				(const u8 *)hp, SZ_SG_IO_V4);
+		if (do_on_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL))
+			kill_fasync(&do_on_sfp->async_qp, SIGPOLL, POLL_IN);
+	} else if (do_on_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
 		s_res = sg_mrq_arr_flush(mhp);
 		if (unlikely(s_res))	/* can only be -EFAULT */
 			return s_res;
@@ -1124,23 +1234,24 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
 }
 
 static int
-sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
-	      struct sg_io_v4 *a_hds, u8 *cdb_ap, struct sg_fd *sfp,
-	      bool immed, u32 tot_reqs, bool *share_on_othp)
+sg_mrq_sanity(struct sg_mrq_hold *mhp)
 {
-	bool have_mrq_sense = (cop->response && cop->max_response_len);
-	bool share_on_oth = false;
 	bool last_is_keep_share = false;
-	bool share;
+	bool share, have_mrq_sense;
 	int k;
+	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 	u32 cdb_alen = cop->request_len;
-	u32 cdb_mxlen = cdb_alen / tot_reqs;
+	u32 cdb_mxlen = cdb_alen / mhp->tot_reqs;
 	u32 flags;
+	struct sg_fd *sfp = mhp->cwrp->sfp;
+	struct sg_io_v4 *a_hds = mhp->a_hds;
+	u8 *cdb_ap = mhp->cdb_ap;
 	struct sg_io_v4 *hp;
 	__maybe_unused const char *rip = "request index";
 
+	have_mrq_sense = (cop->response && cop->max_response_len);
 	/* Pre-check each request for anomalies, plus some preparation */
-	for (k = 0, hp = a_hds; k < tot_reqs; ++k, ++hp) {
+	for (k = 0, hp = a_hds; k < mhp->tot_reqs; ++k, ++hp) {
 		flags = hp->flags;
 		sg_v4h_partial_zero(hp);
 		if (unlikely(hp->guard != 'Q' || hp->protocol != 0 ||
@@ -1156,7 +1267,7 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 			return -ERANGE;
 		}
 		share = !!(flags & SGV4_FLAG_SHARE);
-		if (immed) {	/* only accept async submits on current fd */
+		if (mhp->immed) {/* only accept async submits on current fd */
 			if (unlikely(flags & SGV4_FLAG_DO_ON_OTHER)) {
 				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
 				       rip, k, "no IMMED with ON_OTHER");
@@ -1171,10 +1282,12 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 				return -ERANGE;
 			}
 		}
-		if (sg_fd_is_shared(sfp)) {
-			if (!share_on_oth && share)
-				share_on_oth = true;
-		} else {
+		if (mhp->co_mmap && (flags & SGV4_FLAG_MMAP_IO)) {
+			SG_LOG(1, sfp, "%s: %s %u, MMAP in co AND here\n",
+			       __func__, rip, k);
+			return -ERANGE;
+		}
+		if (!sg_fd_is_shared(sfp)) {
 			if (unlikely(share)) {
 				SG_LOG(1, sfp, "%s: %s %u, no share\n",
 				       __func__, rip, k);
@@ -1204,8 +1317,6 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 		       __func__);
 		return -ERANGE;
 	}
-	if (share_on_othp)
-		*share_on_othp = share_on_othp;
 	return 0;
 }
 
@@ -1229,7 +1340,7 @@ sg_mrq_svb_chk(struct sg_io_v4 *a_hds, u32 tot_reqs)
 	/* expect read-write pairs, all with SGV4_FLAG_NO_DXFER set */
 	for (k = 0, hp = a_hds; k < tot_reqs; ++k, ++hp) {
 		flags = hp->flags;
-		if (flags & (SGV4_FLAG_COMPLETE_B4))
+		if (flags & SGV4_FLAG_COMPLETE_B4)
 			return false;
 		if (!seen_wr) {
 			if (hp->dout_xfer_len > 0)
@@ -1357,7 +1468,14 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 			       hp->device_status);
 			break;	/* cop->driver_status <-- 0 in this case */
 		}
-		if (rq_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
+		if (mhp->co_mmap) {
+			sg_sgat_cp_into(mhp->co_mmap_sgatp, j * SZ_SG_IO_V4,
+					(const u8 *)hp, SZ_SG_IO_V4);
+			if (rq_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL))
+				kill_fasync(&rq_sfp->async_qp, SIGPOLL,
+					    POLL_IN);
+		} else if (rq_sfp->async_qp &&
+			   (hp->flags & SGV4_FLAG_SIGNAL)) {
 			res = sg_mrq_arr_flush(mhp);
 			if (unlikely(res))
 				break;
@@ -1653,14 +1771,15 @@ sg_mrq_name(bool blocking, u32 flags)
 static int
 sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 {
-	bool f_non_block, share_on_oth;
+	bool f_non_block, co_share;
 	int res = 0;
 	int existing_id;
 	u32 cdb_mxlen;
 	struct sg_io_v4 *cop = cwrp->h4p;	/* controlling object */
-	u32 blen = cop->dout_xfer_len;
+	u32 dout_len = cop->dout_xfer_len;
+	u32 din_len = cwrp->dlen;
 	u32 cdb_alen = cop->request_len;
-	u32 tot_reqs = blen / SZ_SG_IO_V4;
+	u32 tot_reqs = dout_len / SZ_SG_IO_V4;
 	u8 *cdb_ap = NULL;
 	struct sg_io_v4 *a_hds;		/* array of request objects */
 	struct sg_fd *fp = cwrp->sfp;
@@ -1678,8 +1797,12 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	mrq_name = sg_mrq_name(blocking, cop->flags);
 #endif
 	f_non_block = !!(fp->filp->f_flags & O_NONBLOCK);
+	co_share = !!(cop->flags & SGV4_FLAG_SHARE);
 	mhp->immed = !!(cop->flags & SGV4_FLAG_IMMED);
 	mhp->stop_if = !!(cop->flags & SGV4_FLAG_STOP_IF);
+	mhp->co_mmap = !!(cop->flags & SGV4_FLAG_MMAP_IO);
+	if (mhp->co_mmap)
+		mhp->co_mmap_sgatp = fp->rsv_arr[0]->sgatp;
 	mhp->id_of_mrq = (int)cop->request_extra;
 	mhp->tot_reqs = tot_reqs;
 	mhp->s_res = 0;
@@ -1702,6 +1825,11 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 			       __func__, "with SGV4_FLAG_IMMED");
 			return -ERANGE;
 		}
+		if (unlikely(co_share)) {
+			SG_LOG(1, fp, "%s: ioctl(SG_IO) %s contradicts\n",
+			       __func__, "with SGV4_FLAG_SHARE");
+			return -ERANGE;
+		}
 		if (unlikely(f_non_block)) {
 			SG_LOG(6, fp, "%s: ioctl(SG_IO) %s O_NONBLOCK\n",
 			       __func__, "ignoring");
@@ -1714,9 +1842,25 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	       mrq_name, tot_reqs, mhp->id_of_mrq);
 	sg_v4h_partial_zero(cop);
 
+	if (mhp->co_mmap) {
+		struct sg_request *srp = fp->rsv_arr[0];
+
+		if (unlikely(fp->mmap_sz == 0))
+			return -EBADFD;	/* want mmap() active on fd */
+		if ((int)din_len > fp->mmap_sz)
+			return  -E2BIG;
+		if (cop->din_xferp)
+			pr_info_once("%s: co::din_xferp ignored due to SGV4_FLAG_MMAP_IO\n",
+				     __func__);
+		if (srp)
+			sg_sgat_zero(srp->sgatp, 0 /* offset */, fp->mmap_sz);
+		else
+			return -EPROTO;
+	}
 	if (unlikely(tot_reqs > U16_MAX)) {
 		return -ERANGE;
-	} else if (unlikely(blen > SG_MAX_MULTI_REQ_SZ ||
+	} else if (unlikely(dout_len > SG_MAX_MULTI_REQ_SZ ||
+			    din_len > SG_MAX_MULTI_REQ_SZ ||
 			    cdb_alen > SG_MAX_MULTI_REQ_SZ)) {
 		return  -E2BIG;
 	} else if (unlikely(mhp->immed && mhp->stop_if)) {
@@ -1757,9 +1901,11 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 			goto fini;
 		}
 	}
+	mhp->cdb_ap = cdb_ap;
+	mhp->a_hds = a_hds;
+	mhp->cdb_mxlen = cdb_mxlen;
 	/* do sanity checks on all requests before starting */
-	res = sg_mrq_sanity(sdp, cop, a_hds, cdb_ap, fp, mhp->immed,
-			    tot_reqs, &share_on_oth);
+	res = sg_mrq_sanity(mhp);
 	if (unlikely(res))
 		goto fini;
 
@@ -1768,11 +1914,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	if (o_sfp)
 		clear_bit(SG_FFD_NO_CMD_Q, o_sfp->ffd_bm);
 
-	mhp->cdb_ap = cdb_ap;
-	mhp->a_hds = a_hds;
-	mhp->cdb_mxlen = cdb_mxlen;
-
-	if (!mhp->immed && !blocking && share_on_oth) {
+	if (co_share) {
 		bool ok;
 
 		/* check for 'shared' variable blocking (svb) */
-- 
2.25.1

