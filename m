Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70818C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55D9D613F1
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239495AbhD0WAQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:16 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39014 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239127AbhD0V7r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2D475204279;
        Tue, 27 Apr 2021 23:59:02 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IXGMwICUUfgY; Tue, 27 Apr 2021 23:59:00 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 07DD7204275;
        Tue, 27 Apr 2021 23:58:57 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 55/83] sg: mrq abort
Date:   Tue, 27 Apr 2021 17:57:05 -0400
Message-Id: <20210427215733.417746-57-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add ability to abort current and remaining (unsubmitted) part
of a multiple requests invocation. Any multiple requests
invocation that the user may want to abort later must be given
a non-zero mrq pack_id (in the request_extra field of the
control object). There can only be one of these non-zero
mrq pack_ids outstanding at a time per file descriptor.

Any requests in a multiple request invocation that have already
reached their internal completion point when the mrq abort is
issued must be processed in the normal fashion. Any inflight
requests will have blk_abort_request() called on them. Those
remaining requests that have not yet been submitted will be
dropped. The ctl_obj.info field is set to number of received
requests that have been processed. The ctl_obj.resid_out field
in the number of requests given less the number actually
submitted. The ctl_obj.resid_in field in the number of given
requests less the number actually received and processed
(i.e. given - ctl_obj.info).

ioctl(sg_fd, SG_IOABORT, &ctl_obj) is used to issue a mrq abort.
The flags field must have SGV4_FLAG_MULTIPLE_REQS set and the
request_extra field must be set to the non-zero mrq pack_id.
SG_PACK_ID_WILDCARD can be given for the mrq pack_id.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 274 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 237 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 27d9ac801f11..3d659ff90788 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -152,6 +152,7 @@ enum sg_shr_var {
 #define SG_FFD_RELEASE		8	/* release (close) underway */
 #define SG_FFD_NO_DURATION	9	/* don't do command duration calc */
 #define SG_FFD_MORE_ASYNC	10	/* yield EBUSY more often */
+#define SG_FFD_MRQ_ABORT	11	/* SG_IOABORT + FLAG_MULTIPLE_REQS */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -215,7 +216,8 @@ struct sg_slice_hdr4 {	/* parts of sg_io_v4 object needed in async usage */
 	s16 dir;		/* data xfer direction; SG_DXFER_*  */
 	u16 cmd_len;		/* truncated of sg_io_v4::request_len */
 	u16 max_sb_len;		/* truncated of sg_io_v4::max_response_len */
-	u16 mrq_ind;		/* position in parentfp->mrq_arr */
+	u16 mrq_ind;		/* mrq submit order, origin 0 */
+	atomic_t pack_id_of_mrq;	/* mrq pack_id, active when > 0 */
 };
 
 struct sg_scatter_hold {     /* holding area for scsi scatter gather info */
@@ -271,6 +273,7 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	atomic_t waiting;	/* number of requests awaiting receive */
 	atomic_t inactives;	/* number of inactive requests */
 	atomic_t sum_fd_dlens;	/* when tot_fd_thresh>0 this is sum_of(dlen) */
+	atomic_t mrq_id_abort;	/* inactive when 0, else id if aborted */
 	int tot_fd_thresh;	/* E2BIG if sum_of(dlen) > this, 0: ignore */
 	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
 	int mmap_sz;		/* byte size of previous mmap() call */
@@ -410,7 +413,6 @@ static const char *sg_shr_str(enum sg_shr_var sh_var, bool long_str);
 #define SG_LOG(depth, sfp, fmt, a...) do { } while (0)
 #endif	/* end of CONFIG_SCSI_LOGGING && SG_DEBUG conditional */
 
-
 /*
  * The SCSI interfaces that use read() and write() as an asynchronous variant of
  * ioctl(..., SG_IO, ...) are fundamentally unsafe, since there are lots of ways
@@ -944,7 +946,7 @@ sg_mrq_1complet(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 		struct sg_fd *w_sfp, int tot_reqs, struct sg_request *srp)
 {
 	int s_res, indx;
-	struct sg_io_v4 *siv4p;
+	struct sg_io_v4 *hp;
 
 	SG_LOG(3, w_sfp, "%s: start, tot_reqs=%d\n", __func__, tot_reqs);
 	if (unlikely(!srp))
@@ -952,12 +954,12 @@ sg_mrq_1complet(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 	indx = srp->s_hdr4.mrq_ind;
 	if (unlikely(indx < 0 || indx >= tot_reqs))
 		return -EPROTO;
-	siv4p = a_hds + indx;
-	s_res = sg_receive_v4(w_sfp, srp, NULL, siv4p);
+	hp = a_hds + indx;
+	s_res = sg_receive_v4(w_sfp, srp, NULL, hp);
 	if (unlikely(s_res == -EFAULT))
 		return s_res;
-	siv4p->info |= SG_INFO_MRQ_FINI;
-	if (w_sfp->async_qp && (siv4p->flags & SGV4_FLAG_SIGNAL)) {
+	hp->info |= SG_INFO_MRQ_FINI;
+	if (w_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
 		s_res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
 		if (unlikely(s_res))	/* can only be -EFAULT */
 			return s_res;
@@ -1123,16 +1125,19 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 static int
 sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 {
-	bool immed, stop_if, f_non_block;
+	bool chk_abort = false;
+	bool set_this, set_other, immed, stop_if, f_non_block;
 	int res = 0;
 	int s_res = 0;	/* for secondary error: some-good-then-error, case */
 	int other_fp_sent = 0;
 	int this_fp_sent = 0;
+	int num_subm = 0;
 	int num_cmpl = 0;
 	const int shr_complet_b4 = SGV4_FLAG_SHARE | SGV4_FLAG_COMPLETE_B4;
+	int id_of_mrq, existing_id;
+	u32 n, flags, cdb_mxlen;
 	unsigned long ul_timeout;
-	struct sg_io_v4 *cop = cwrp->h4p;
-	u32 k, n, flags, cdb_mxlen;
+	struct sg_io_v4 *cop = cwrp->h4p;	/* controlling object */
 	u32 blen = cop->dout_xfer_len;
 	u32 cdb_alen = cop->request_len;
 	u32 tot_reqs = blen / SZ_SG_IO_V4;
@@ -1148,6 +1153,17 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	f_non_block = !!(fp->filp->f_flags & O_NONBLOCK);
 	immed = !!(cop->flags & SGV4_FLAG_IMMED);
 	stop_if = !!(cop->flags & SGV4_FLAG_STOP_IF);
+	id_of_mrq = (int)cop->request_extra;
+	if (id_of_mrq) {
+		existing_id = atomic_cmpxchg(&fp->mrq_id_abort, 0, id_of_mrq);
+		if (existing_id && existing_id != id_of_mrq) {
+			SG_LOG(1, fp, "%s: existing id=%d id_of_mrq=%d\n",
+			       __func__, existing_id, id_of_mrq);
+			return -EDOM;
+		}
+		clear_bit(SG_FFD_MRQ_ABORT, fp->ffd_bm);
+		chk_abort = true;
+	}
 	if (blocking) {		/* came from ioctl(SG_IO) */
 		if (unlikely(immed)) {
 			SG_LOG(1, fp, "%s: ioctl(SG_IO) %s contradicts\n",
@@ -1162,9 +1178,10 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	}
 	if (!immed && f_non_block)
 		immed = true;
-	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, cdb_alen=%u\n", __func__,
+	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, id_of_mrq=%d\n", __func__,
 	       (immed ? "IMMED" : (blocking ?  "ordered blocking" :
-				   "variable blocking")), tot_reqs, cdb_alen);
+				   "variable blocking")),
+	       tot_reqs, id_of_mrq);
 	sg_sgv4_out_zero(cop);
 
 	if (unlikely(tot_reqs > U16_MAX)) {
@@ -1216,17 +1233,32 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	res = sg_mrq_sanity(sdp, cop, a_hds, cdb_ap, fp, immed, tot_reqs);
 	if (unlikely(res))
 		goto fini;
-	/* override cmd queuing setting to allow */
-	set_bit(SG_FFD_CMD_Q, fp->ffd_bm);
-	if (o_sfp)
-		set_bit(SG_FFD_CMD_Q, o_sfp->ffd_bm);
-
+	set_this = false;
+	set_other = false;
 	/* Dispatch (submit) requests and optionally wait for response */
-	for (hp = a_hds, k = 0; num_cmpl < tot_reqs; ++hp, ++k) {
+	for (hp = a_hds; num_subm < tot_reqs; ++hp) {
+		if (chk_abort && test_and_clear_bit(SG_FFD_MRQ_ABORT,
+						    fp->ffd_bm)) {
+			SG_LOG(1, fp, "%s: id_of_mrq=%d aborting at ind=%d\n",
+			       __func__, id_of_mrq, num_subm);
+			break;	/* N.B. rest not submitted */
+		}
 		flags = hp->flags;
-		rq_sfp = (flags & SGV4_FLAG_DO_ON_OTHER) ? o_sfp : fp;
+		if (flags & SGV4_FLAG_DO_ON_OTHER) {
+			rq_sfp = o_sfp;
+			if (!set_other) {
+				set_other = true;
+				set_bit(SG_FFD_CMD_Q, rq_sfp->ffd_bm);
+			}
+		} else {
+			rq_sfp = fp;
+			if (!set_this) {
+				set_this = true;
+				set_bit(SG_FFD_CMD_Q, rq_sfp->ffd_bm);
+			}
+		}
 		if (cdb_ap) {	/* already have array of cdbs */
-			cwrp->cmdp = cdb_ap + (k * cdb_mxlen);
+			cwrp->cmdp = cdb_ap + (num_subm * cdb_mxlen);
 			cwrp->u_cmdp = NULL;
 		} else {	/* fetch each cdb from user space */
 			cwrp->cmdp = NULL;
@@ -1245,7 +1277,9 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 			s_res = PTR_ERR(srp);
 			break;
 		}
-		srp->s_hdr4.mrq_ind = k;
+		srp->s_hdr4.mrq_ind = num_subm++;
+		if (chk_abort)
+			atomic_set(&srp->s_hdr4.pack_id_of_mrq, id_of_mrq);
 		if (immed || (!(blocking || (flags & shr_complet_b4)))) {
 			if (fp == rq_sfp)
 				++this_fp_sent;
@@ -1278,8 +1312,8 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 			kill_fasync(&rq_sfp->async_qp, SIGPOLL, POLL_IN);
 		}
 	}	/* end of dispatch request and optionally wait response loop */
-	cop->dout_resid = tot_reqs - num_cmpl;
-	cop->info = num_cmpl;
+	cop->dout_resid = tot_reqs - num_subm;
+	cop->info = num_cmpl;		/* number received */
 	if (cop->din_xfer_len > 0) {
 		cop->din_resid = tot_reqs - num_cmpl;
 		cop->spare_out = -s_res;
@@ -1294,6 +1328,8 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 		if (unlikely(s_res == -EFAULT || s_res == -ERESTARTSYS))
 			res = s_res;	/* this may leave orphans */
 	}
+	if (id_of_mrq)	/* can no longer do a mrq abort */
+		atomic_set(&fp->mrq_id_abort, 0);
 fini:
 	if (likely(res == 0) && !immed)
 		res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
@@ -2032,7 +2068,7 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p,
 	if (unlikely(res < 0))
 		goto fini;
 	cop->din_resid -= res;
-	cop->info = res;
+	cop->info = res;	/* number received */
 	if (copy_to_user(p, cop, sizeof(*cop)))
 		return -EFAULT;
 	res = 0;
@@ -2914,7 +2950,6 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
  */
 static struct sg_request *
 sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
-		__must_hold(&sfp->rq_list_lock)
 {
 	int num_waiting = atomic_read(&sfp->waiting);
 	unsigned long idx;
@@ -2942,6 +2977,48 @@ sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
 	return NULL;
 }
 
+/*
+ * Looks for first request following 'after_rp' (or the start if after_rp is
+ * NULL) whose pack_id_of_mrq matches the given pack_id. If after_rp is
+ * non-NULL and it is not found, then the search restarts from the beginning
+ * of the list. If no match is found then NULL is returned.
+ */
+static struct sg_request *
+sg_match_first_mrq_after(struct sg_fd *sfp, int pack_id,
+			 struct sg_request *after_rp)
+{
+	bool found = false;
+	bool look_for_after = after_rp ? true : false;
+	int id;
+	unsigned long idx;
+	struct sg_request *srp;
+
+	if (atomic_read(&sfp->waiting) < 1)
+		return NULL;
+once_more:
+	xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
+		if (unlikely(!srp))
+			continue;
+		if (look_for_after) {
+			if (after_rp == srp)
+				look_for_after = false;
+			continue;
+		}
+		id = atomic_read(&srp->s_hdr4.pack_id_of_mrq);
+		if (id == 0)	/* mrq_pack_ids cannot be zero */
+			continue;
+		if (pack_id == SG_PACK_ID_WILDCARD || pack_id == id) {
+			found = true;
+			break;
+		}
+	}
+	if (look_for_after) {	/* after_rp may now be on free list */
+		look_for_after = false;
+		goto once_more;
+	}
+	return found ? srp : NULL;
+}
+
 static int
 sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 		__must_hold(&sfp->srp_arr->xa_lock)
@@ -2990,6 +3067,117 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 	return res;
 }
 
+static int
+sg_mrq_abort_inflight(struct sg_fd *sfp, int pack_id)
+{
+	bool got_ebusy = false;
+	int res = 0;
+	unsigned long iflags;
+	struct sg_request *srp;
+	struct sg_request *prev_srp;
+
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	for (prev_srp = NULL; true; prev_srp = srp) {
+		srp = sg_match_first_mrq_after(sfp, pack_id, prev_srp);
+		if (!srp)
+			break;
+		res = sg_abort_req(sfp, srp);
+		if (res == -EBUSY)	/* check rest of active list */
+			got_ebusy = true;
+		else if (res)
+			break;
+	}
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+	if (res)
+		return res;
+	return got_ebusy ? -EBUSY : 0;
+}
+
+/*
+ * Implements ioctl(SG_IOABORT) when SGV4_FLAG_MULTIPLE_REQS set. pack_id is
+ * non-zero and is from the request_extra field. dev_scope is set when
+ * SGV4_FLAG_DEV_SCOPE is given; in that case there is one level of recursion
+ * if there is no match or clash with given sfp. Will abort the first
+ * mrq that matches then exit. Can only do mrq abort if the mrq submission
+ * used a non-zero ctl_obj.request_extra (pack_id).
+ */
+static int
+sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
+		__must_hold(sfp->f_mutex)
+{
+	int existing_id;
+	int res = 0;
+	unsigned long idx;
+	struct sg_device *sdp;
+	struct sg_fd *o_sfp;
+	struct sg_fd *s_sfp;
+
+	if (pack_id != SG_PACK_ID_WILDCARD)
+		SG_LOG(3, sfp, "%s: pack_id=%d, dev_scope=%s\n", __func__,
+		       pack_id, (dev_scope ? "true" : "false"));
+	existing_id = atomic_read(&sfp->mrq_id_abort);
+	if (existing_id == 0) {
+		if (dev_scope)
+			goto check_whole_dev;
+		SG_LOG(1, sfp, "%s: sfp->mrq_id_abort is 0, nothing to do\n",
+		       __func__);
+		return -EADDRNOTAVAIL;
+	}
+	if (pack_id == SG_PACK_ID_WILDCARD) {
+		pack_id = existing_id;
+		SG_LOG(3, sfp, "%s: wildcard becomes pack_id=%d\n", __func__,
+		       pack_id);
+	} else if (pack_id != existing_id) {
+		if (dev_scope)
+			goto check_whole_dev;
+		SG_LOG(1, sfp, "%s: want id=%d, got sfp->mrq_id_abort=%d\n",
+		       __func__, pack_id, existing_id);
+		return -EADDRINUSE;
+	}
+	if (test_and_set_bit(SG_FFD_MRQ_ABORT, sfp->ffd_bm))
+		SG_LOG(2, sfp, "%s: repeated SG_IOABORT on mrq_id=%d\n",
+		       __func__, pack_id);
+
+	/* now look for inflight requests matching that mrq pack_id */
+	xa_lock(&sfp->srp_arr);
+	res = sg_mrq_abort_inflight(sfp, pack_id);
+	if (res == -EBUSY) {
+		res = sg_mrq_abort_inflight(sfp, pack_id);
+		if (res)
+			goto fini;
+	}
+	s_sfp = sg_fd_share_ptr(sfp);
+	if (s_sfp) {	/* SGV4_FLAG_DO_ON_OTHER may have been used */
+		xa_unlock(&sfp->srp_arr);
+		sfp = s_sfp;	/* if share, check other fd */
+		xa_lock(&sfp->srp_arr);
+		if (sg_fd_is_shared(sfp))
+			goto fini;
+		/* tough luck if other fd used same mrq pack_id */
+		res = sg_mrq_abort_inflight(sfp, pack_id);
+		if (res == -EBUSY)
+			res = sg_mrq_abort_inflight(sfp, pack_id);
+	}
+fini:
+	xa_unlock(&sfp->srp_arr);
+	return res;
+
+check_whole_dev:
+	res = -ENODATA;
+	sdp = sfp->parentdp;
+	xa_for_each(&sdp->sfp_arr, idx, o_sfp) {
+		if (o_sfp == sfp)
+			continue;       /* already checked */
+		xa_lock(&o_sfp->srp_arr);
+		/* recurse, dev_scope==false is stopping condition */
+		res = sg_mrq_abort(o_sfp, pack_id, false);
+		xa_unlock(&o_sfp->srp_arr);
+		if (res == 0)
+			break;
+	}
+	return res;
+}
+
 /*
  * Tries to abort an inflight request/command. First it checks the current fd
  * for a match on pack_id or tag. If there is a match, aborts that match.
@@ -3001,8 +3189,8 @@ static int
 sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		__must_hold(sfp->f_mutex)
 {
-	bool use_tag;
-	int pack_id, tag, id;
+	bool use_tag, dev_scope;
+	int pack_id, id;
 	int res = 0;
 	unsigned long iflags, idx;
 	struct sg_fd *o_sfp;
@@ -3014,16 +3202,21 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		return -EFAULT;
 	if (h4p->guard != 'Q' || h4p->protocol != 0 || h4p->subprotocol != 0)
 		return -EPERM;
+	dev_scope = !!(h4p->flags & SGV4_FLAG_DEV_SCOPE);
 	pack_id = h4p->request_extra;
-	tag = h4p->request_tag;
+	if (h4p->flags & SGV4_FLAG_MULTIPLE_REQS) {
+		if (pack_id == 0)
+			return -ENOSTR;
+		return sg_mrq_abort(sfp, pack_id, dev_scope);
+	}
 	use_tag = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm);
-	id = use_tag ? tag : pack_id;
+	id = use_tag ? (int)h4p->request_tag : pack_id;
 
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	srp = sg_match_request(sfp, use_tag, id);
 	if (!srp) {	/* assume device (not just fd) scope */
 		xa_unlock_irqrestore(&sfp->srp_arr, iflags);
-		if (!(h4p->flags & SGV4_FLAG_DEV_SCOPE))
+		if (!dev_scope)
 			return -ENODATA;
 		xa_for_each(&sdp->sfp_arr, idx, o_sfp) {
 			if (o_sfp == sfp)
@@ -3430,13 +3623,16 @@ static bool
 sg_any_persistent_orphans(struct sg_fd *sfp)
 {
 	if (test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm)) {
-		int num_waiting = atomic_read_acquire(&sfp->waiting);
+		int num_waiting = atomic_read(&sfp->waiting);
 		unsigned long idx;
 		struct sg_request *srp;
 		struct xarray *xafp = &sfp->srp_arr;
 
-		if (num_waiting < 1)
-			return false;
+		if (num_waiting < 1) {
+			num_waiting = atomic_read_acquire(&sfp->waiting);
+			if (num_waiting < 1)
+				return false;
+		}
 		xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_AWAIT) {
 			if (test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm))
 				return true;
@@ -3902,7 +4098,8 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 			return -ENODEV;
 		if (unlikely(read_only))
 			return -EPERM;
-		mutex_lock(&sfp->f_mutex);
+		if (!mutex_trylock(&sfp->f_mutex))
+			return -EAGAIN;
 		res = sg_ctl_abort(sdp, sfp, p);
 		mutex_unlock(&sfp->f_mutex);
 		return res;
@@ -5451,9 +5648,12 @@ sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
 		*srpp = ERR_PTR(-ENODATA);
 		return true;
 	}
-	num_waiting = atomic_read_acquire(&sfp->waiting);
-	if (num_waiting < 1)
-		goto fini;
+	num_waiting = atomic_read(&sfp->waiting);
+	if (num_waiting < 1) {
+		num_waiting = atomic_read_acquire(&sfp->waiting);
+		if (num_waiting < 1)
+			goto fini;
+	}
 
 	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
 	idx = s_idx;
-- 
2.25.1

