Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40E4C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0162613F1
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbhD0WAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:38 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39079 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239475AbhD0WAF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 06D9E20426F;
        Tue, 27 Apr 2021 23:59:19 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ccsY-ide5lQq; Tue, 27 Apr 2021 23:59:17 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 26878204190;
        Tue, 27 Apr 2021 23:59:15 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 66/83] sg: split sg_setup_req
Date:   Tue, 27 Apr 2021 17:57:16 -0400
Message-Id: <20210427215733.417746-68-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sg_setup_req() function was getting too long. It has been
split into a helper (sg_setup_req_ws_helper() ) and a function of
the same original name.

Rename all pointers to struct request from rq to rqq. This is to
better distinguish them from the other rq_* variables. Add
READ_ONCE/WRITE_ONCE macros to all accesses to srp->rqq .

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 331 +++++++++++++++++++++++-----------------------
 1 file changed, 162 insertions(+), 169 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ca6af752b23d..dcb9afe722c2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -343,7 +343,7 @@ struct sg_mrq_hold {	/* for passing context between mrq functions */
 };
 
 /* tasklet or soft irq callback */
-static void sg_rq_end_io(struct request *rq, blk_status_t status);
+static void sg_rq_end_io(struct request *rqq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
 static int sg_proc_init(void);
 static void sg_dfs_init(void);
@@ -3667,6 +3667,7 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 {
 	int res = 0;
 	enum sg_rq_state rq_st;
+	struct request *rqq;
 
 	if (test_and_set_bit(SG_FRQ_ABORTING, srp->frq_bm)) {
 		SG_LOG(1, sfp, "%s: already aborting req pack_id/tag=%d/%d\n",
@@ -3691,14 +3692,11 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 		break;		/* nothing to do here, return 0 */
 	case SG_RQ_INFLIGHT:	/* only attempt abort if inflight */
 		srp->rq_result |= (DRIVER_SOFT << 24);
-		{
-			struct request *rqq = READ_ONCE(srp->rqq);
-
-			if (likely(rqq)) {
-				SG_LOG(5, sfp, "%s: -->blk_abort_request srp=0x%pK\n",
-				       __func__, srp);
-				blk_abort_request(rqq);
-			}
+		rqq = READ_ONCE(srp->rqq);
+		if (likely(rqq)) {
+			SG_LOG(5, sfp, "%s: -->blk_abort_request srp=0x%pK\n",
+			       __func__, srp);
+			blk_abort_request(rqq);
 		}
 		break;
 	default:
@@ -4116,6 +4114,7 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 						      o_srp->frq_bm));
 				*rapp = n_srp;
 				sg_rq_chg_state_force_ulck(n_srp, SG_RQ_INACTIVE);
+				/* no bump of sfp->inactives since replacement */
 				xa_unlock_irqrestore(xafp, iflags);
 				SG_LOG(6, sfp, "%s: new rsv srp=0x%pK ++\n",
 				       __func__, n_srp);
@@ -4225,7 +4224,7 @@ sg_take_snap(struct sg_fd *sfp, bool clear_first)
 	}
 #if IS_ENABLED(SG_PROC_OR_DEBUG_FS)
 	if (true) {	/* for some declarations */
-		int n, prevlen, bp_len;
+		int prevlen, bp_len;
 		char *bp;
 
 		prevlen = strlen(snapped_buf);
@@ -5333,8 +5332,8 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 							     sfp->ffd_bm));
 	if (unlikely(!sg_result_is_good(rq_result) && slen > 0 &&
 		     test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm))) {
-		if ((rq_result & 0xff) == SAM_STAT_CHECK_CONDITION ||
-		    (rq_result & 0xff) == SAM_STAT_COMMAND_TERMINATED)
+		if ((rq_result & 0xfe) == SAM_STAT_CHECK_CONDITION ||
+		    (rq_result & 0xfe) == SAM_STAT_COMMAND_TERMINATED)
 			__scsi_print_sense(sdp->device, __func__, scsi_rp->sense, slen);
 	}
 	if (unlikely(slen > 0)) {
@@ -5825,8 +5824,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	 * blk_get_request(BLK_MQ_REQ_NOWAIT) yields EAGAIN (aka EWOULDBLOCK).
 	 */
 	rqq = blk_get_request(q, (r0w ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN),
-			      (test_bit(SG_FFD_MORE_ASYNC, sfp->ffd_bm) ?
-						BLK_MQ_REQ_NOWAIT : 0));
+			      (test_bit(SG_FFD_MORE_ASYNC, sfp->ffd_bm) ?  BLK_MQ_REQ_NOWAIT : 0));
 	if (IS_ERR(rqq)) {
 		res = PTR_ERR(rqq);
 		goto err_pre_blk_get;
@@ -5971,7 +5969,7 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 	}
 
 	/* Expect blk_put_request(rqq) already called in sg_rq_end_io() */
-	if (rqq) {       /* blk_get_request() may have failed */
+	if (rqq) {	/* blk_get_request() may have failed */
 		WRITE_ONCE(srp->rqq, NULL);
 		if (scsi_req(rqq))
 			scsi_req_free_cmd(scsi_req(rqq));
@@ -6440,172 +6438,145 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
 	} while (true);
 }
 
+static struct sg_request *
+sg_setup_req_ws_helper(struct sg_fd *fp, int rsv_idx)
+{
+	int res;
+	struct sg_request *r_srp;
+	enum sg_rq_state rs_sr_st;
+	struct sg_fd *rs_sfp = sg_fd_share_ptr(fp);
+
+	if (unlikely(!rs_sfp))
+		return ERR_PTR(-EPROTO);
+	/*
+	 * There may be contention with another potential write-side trying
+	 * to pair with this read-side. The loser will receive an
+	 * EADDRINUSE errno. The winner advances read-side's rq_state:
+	 *     SG_RQ_SHR_SWAP --> SG_RQ_SHR_IN_WS
+	 */
+	if (rsv_idx >= 0)
+		r_srp = rs_sfp->rsv_arr[rsv_idx];
+	else
+		r_srp = sg_get_probable_read_side(rs_sfp);
+	if (unlikely(!r_srp))
+		return ERR_PTR(-ENOSTR);
+
+	rs_sr_st = atomic_read(&r_srp->rq_st);
+	switch (rs_sr_st) {
+	case SG_RQ_SHR_SWAP:
+		break;
+	case SG_RQ_AWAIT_RCV:
+	case SG_RQ_INFLIGHT:
+	case SG_RQ_BUSY:
+		return ERR_PTR(-EBUSY);	/* too early for write-side req */
+	case SG_RQ_INACTIVE:
+		SG_LOG(1, fp, "%s: write-side finds read-side inactive\n",
+		       __func__);
+		return ERR_PTR(-EADDRNOTAVAIL);
+	case SG_RQ_SHR_IN_WS:
+		SG_LOG(1, fp, "%s: write-side find read-side shr_in_ws\n",
+		       __func__);
+		return ERR_PTR(-EADDRINUSE);
+	}
+	res = sg_rq_chg_state(r_srp, rs_sr_st, SG_RQ_SHR_IN_WS);
+	if (unlikely(res))
+		return ERR_PTR(-EADDRINUSE);
+	return r_srp;
+}
+
 /*
  * Setup an active request (soon to carry a SCSI command) to the current file
- * descriptor by creating a new one or re-using a request from the free
- * list (fl). If successful returns a valid pointer to a sg_request object
- * which is in the SG_RQ_BUSY state. On failure returns a negated errno value
- * twisted by ERR_PTR() macro. Note that once a file share is established,
- * the read-side's reserve request can only be used in a request share.
+ * descriptor by creating a new one or re-using a request marked inactive.
+ * If successful returns a valid pointer to a sg_request object which is in
+ * the SG_RQ_BUSY state. On failure returns a negated errno value twisted by
+ * ERR_PTR() macro. Note that once a file share is established, the read-side
+ * side's reserve request can only be used in a request share.
  */
 static struct sg_request *
 sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 {
-	bool act_empty = false;
 	bool allow_rsv = true;		/* see note above */
 	bool mk_new_srp = true;
 	bool new_rsv_srp = false;
+	bool no_reqs = false;
 	bool ws_rq = false;
+	bool some_inactive = false;
 	bool try_harder = false;
 	bool second = false;
-	bool has_inactive = false;
 	bool is_rsv;
 	int ra_idx = 0;
-	int res, l_used_idx;
+	int l_used_idx;
 	u32 sum_dlen;
 	unsigned long idx, s_idx, end_idx, iflags;
 	enum sg_rq_state sr_st;
-	enum sg_rq_state rs_st = SG_RQ_INACTIVE;
 	struct sg_fd *fp = cwrp->sfp;
-	struct sg_request *r_srp = NULL; /* returned value won't be NULL */
-	struct sg_request *low_srp = NULL;
+	struct sg_request *r_srp; /* returned value won't be NULL */
 	struct sg_request *rs_rsv_srp = NULL;
-	struct sg_fd *rs_sfp = NULL;
 	struct xarray *xafp = &fp->srp_arr;
-	__maybe_unused const char *cp = NULL;
+	__maybe_unused const char *cp = "";
 	__maybe_unused char b[64];
 
-	b[0] = '\0';
 	switch (sh_var) {
-	case SG_SHR_NONE:
-	case SG_SHR_WS_NOT_SRQ:
-		break;
 	case SG_SHR_RS_RQ:
-		if (test_bit(SG_FFD_RESHARE, fp->ffd_bm))
-			ra_idx = 0;
-		else
-			ra_idx = sg_get_idx_available(fp);
+		cp = "rs_rq";
+		ra_idx = (test_bit(SG_FFD_RESHARE, fp->ffd_bm)) ? 0 : sg_get_idx_available(fp);
 		if (ra_idx < 0) {
 			new_rsv_srp = true;
-			cp = "m_rq";
 			goto good_fini;
 		}
 		r_srp = fp->rsv_arr[ra_idx];
 		sr_st = atomic_read(&r_srp->rq_st);
 		if (sr_st == SG_RQ_INACTIVE) {
-			res = sg_rq_chg_state(r_srp, sr_st, SG_RQ_BUSY);
-			if (likely(res == 0)) {
+			int res = sg_rq_chg_state(r_srp, sr_st, SG_RQ_BUSY);
+
+			if (unlikely(res)) {
+				r_srp = NULL;
+			} else {
 				r_srp->sh_srp = NULL;
 				mk_new_srp = false;
-				cp = "rs_rq";
-				goto good_fini;
 			}
+		} else {
+			SG_LOG(1, fp, "%s: no reserve request available\n", __func__);
+			r_srp = ERR_PTR(-EFBIG);
 		}
-		/* Did not find the reserve request available */
-		r_srp = ERR_PTR(-EFBIG);
-		break;
-	case SG_SHR_RS_NOT_SRQ:
-		allow_rsv = false;
-		break;
+		if (IS_ERR(r_srp))
+			goto err_out;
+		if (mk_new_srp)
+			new_rsv_srp = true;
+		goto good_fini;
 	case SG_SHR_WS_RQ:
-		rs_sfp = sg_fd_share_ptr(fp);
-		if (unlikely(!rs_sfp)) {
-			r_srp = ERR_PTR(-EPROTO);
-			break;
-		}
-		/*
-		 * There may be contention with another potential write-side trying
-		 * to pair with this read-side. The loser will receive an
-		 * EADDRINUSE errno. The winner advances read-side's rq_state:
-		 *     SG_RQ_SHR_SWAP --> SG_RQ_SHR_IN_WS
-		 */
-		if (cwrp->rsv_idx >= 0)
-			rs_rsv_srp = rs_sfp->rsv_arr[cwrp->rsv_idx];
-		else
-			rs_rsv_srp = sg_get_probable_read_side(rs_sfp);
-		if (!rs_rsv_srp) {
-			r_srp = ERR_PTR(-ENOSTR);
-			break;
-		}
-		rs_st = atomic_read(&rs_rsv_srp->rq_st);
-		switch (rs_st) {
-		case SG_RQ_AWAIT_RCV:
-			if (!sg_result_is_good(rs_rsv_srp->rq_result)) {
-				/* read-side done but error occurred */
-				r_srp = ERR_PTR(-ENOSTR);
-				break;
-			}
-			ws_rq = true;
-			break;
-		case SG_RQ_SHR_SWAP:
-			ws_rq = true;
-			if (unlikely(rs_st == SG_RQ_AWAIT_RCV))
-				break;
-			res = sg_rq_chg_state(rs_rsv_srp, rs_st, SG_RQ_SHR_IN_WS);
-			if (unlikely(res))
-				r_srp = ERR_PTR(-EADDRINUSE);
-			break;
-		case SG_RQ_INFLIGHT:
-		case SG_RQ_BUSY:
-			SG_LOG(6, fp, "%s: write-side finds read-side: %s\n", __func__,
-			       sg_rq_st_str(rs_st, true));
-			r_srp = ERR_PTR(-EBUSY);
-			break;
-		case SG_RQ_INACTIVE:
-			r_srp = ERR_PTR(-EADDRNOTAVAIL);
-			break;
-		case SG_RQ_SHR_IN_WS:
-		default:
-			r_srp = ERR_PTR(-EADDRINUSE);
-			break;
-		}
-		break;
-	}
-	if (IS_ERR(r_srp)) {
-		if (PTR_ERR(r_srp) == -EBUSY)
+		cp = "rs_rq";
+		rs_rsv_srp = sg_setup_req_ws_helper(fp, cwrp->rsv_idx);
+		if (IS_ERR(rs_rsv_srp)) {
+			r_srp = rs_rsv_srp;
 			goto err_out;
-#if IS_ENABLED(SG_LOG_ACTIVE)
-		if (sh_var == SG_SHR_RS_RQ) {
-			snprintf(b, sizeof(b), "SG_SHR_RS_RQ --> sr_st=%s",
-				 sg_rq_st_str(sr_st, false));
-		} else if (sh_var == SG_SHR_WS_RQ && rs_sfp) {
-			char c[32];
-			const char *ccp;
-
-			if (rs_rsv_srp)
-				ccp = sg_get_rsv_str(rs_rsv_srp, "[", "]",
-						     sizeof(c), c);
-			else
-				ccp = "? ";
-			snprintf(b, sizeof(b), "SHR_WS_RQ --> rs_sr%s_st=%s",
-				 ccp, sg_rq_st_str(rs_st, false));
-		} else {
-			snprintf(b, sizeof(b), "sh_var=%s",
-				 sg_shr_str(sh_var, false));
 		}
-#endif
-		goto err_out;
-	}
-	cp = "";
-
-	if (ws_rq) {	/* write-side dlen may be <= read-side's dlen */
+		/* write-side dlen may be <= read-side's dlen */
 		if (unlikely(dxfr_len > rs_rsv_srp->sgatp->dlen)) {
-			SG_LOG(4, fp, "%s: write-side dlen [%d] > read-side dlen\n",
+			SG_LOG(1, fp, "%s: bad, write-side dlen [%d] > read-side's\n",
 			       __func__, dxfr_len);
 			r_srp = ERR_PTR(-E2BIG);
 			goto err_out;
 		}
+		ws_rq = true;
 		dxfr_len = 0;	/* any srp for write-side will do, pick smallest */
+		break;
+	case SG_SHR_RS_NOT_SRQ:
+		allow_rsv = false;
+		break;
+	default:
+		break;
 	}
 
 start_again:
-	cp = "";
 	if (xa_empty(xafp)) {
-		act_empty = true;
+		no_reqs = true;
 		mk_new_srp = true;
 	} else if (atomic_read(&fp->inactives) <= 0) {
 		mk_new_srp = true;
 	} else if (likely(!try_harder) && dxfr_len < SG_DEF_SECTOR_SZ) {
+		struct sg_request *low_srp = NULL;
+
 		l_used_idx = READ_ONCE(fp->low_used_idx);
 		s_idx = (l_used_idx < 0) ? 0 : l_used_idx;
 		if (l_used_idx >= 0 && xa_get_mark(xafp, s_idx, SG_XA_RQ_INACTIVE)) {
@@ -6622,53 +6593,75 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 			}
 		}
 		xa_for_each_marked(xafp, idx, r_srp, SG_XA_RQ_INACTIVE) {
-			has_inactive = true;
-			if (!allow_rsv &&
-			    test_bit(SG_FRQ_RESERVED, r_srp->frq_bm))
-				continue;
-			if (!low_srp && dxfr_len < SG_DEF_SECTOR_SZ) {
-				low_srp = r_srp;
-				break;
+			if (allow_rsv || !test_bit(SG_FRQ_RESERVED, r_srp->frq_bm)) {
+				if (r_srp->sgat_h.buflen <= SG_DEF_SECTOR_SZ) {
+					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
+						continue;
+					mk_new_srp = false;
+					break;
+				} else if (!low_srp) {
+					low_srp = r_srp;
+				}
 			}
 		}
-		/* If dxfr_len is small, use lowest inactive request */
-		if (low_srp) {
+		if (mk_new_srp && low_srp) {	/* no candidate yet */
+			/* take non-NULL low_srp, irrespective of r_srp->sgat_h.buflen size */
 			r_srp = low_srp;
-			if (unlikely(sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY)))
-				goto start_again; /* gone to another thread */
-			atomic_dec(&fp->inactives);
-			cp = "lowest inactive in srp_arr";
-			mk_new_srp = false;
+			if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY) == 0) {
+				mk_new_srp = false;
+				atomic_dec(&fp->inactives);
+			}
 		}
 	} else {
+		cp = "larger from srp_arr";
 		l_used_idx = READ_ONCE(fp->low_used_idx);
 		s_idx = (l_used_idx < 0) ? 0 : l_used_idx;
 		idx = s_idx;
 		end_idx = ULONG_MAX;
+
+		if (allow_rsv) {
 second_time:
-		for (r_srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE);
-		     r_srp;
-		     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
-			if (!allow_rsv &&
-			    test_bit(SG_FRQ_RESERVED, r_srp->frq_bm))
-				continue;
-			if (r_srp->sgat_h.buflen >= dxfr_len) {
-				if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
-					continue;
-				atomic_dec(&fp->inactives);
-				WRITE_ONCE(fp->low_used_idx, idx + 1);
-				cp = "near front of srp_arr";
-				mk_new_srp = false;
-				break;
+			for (r_srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE);
+			     r_srp;
+			     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
+				if (dxfr_len <= r_srp->sgat_h.buflen) {
+					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
+						continue;
+					atomic_dec(&fp->inactives);
+					WRITE_ONCE(fp->low_used_idx, idx + 1);
+					mk_new_srp = false;
+					break;
+				}
+			}
+			if (!r_srp && !second && s_idx > 0) {
+				end_idx = s_idx - 1;
+				s_idx = 0;
+				idx = s_idx;
+				second = true;
+				goto second_time;
+			}
+		} else {
+second_time_2:
+			for (r_srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE);
+			     r_srp;
+			     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
+				if (dxfr_len <= r_srp->sgat_h.buflen &&
+				    !test_bit(SG_FRQ_RESERVED, r_srp->frq_bm)) {
+					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
+						continue;
+					atomic_dec(&fp->inactives);
+					WRITE_ONCE(fp->low_used_idx, idx + 1);
+					mk_new_srp = false;
+					break;
+				}
+			}
+			if (!r_srp && !second && s_idx > 0) {
+				end_idx = s_idx - 1;
+				s_idx = 0;
+				idx = s_idx;
+				second = true;
+				goto second_time_2;
 			}
-		}
-		/* If not found so far, need to wrap around and search [0 ... start_idx) */
-		if (!r_srp && !second && s_idx > 0) {
-			end_idx = s_idx - 1;
-			s_idx = 0;
-			idx = s_idx;
-			second = true;
-			goto second_time;
 		}
 	}
 have_existing:
@@ -6713,10 +6706,10 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		}
 		if (IS_ERR(r_srp))	/* NULL is _not_ an ERR here */
 			goto err_out;
-		r_srp = sg_mk_srp_sgat(fp, act_empty, dxfr_len);
+		r_srp = sg_mk_srp_sgat(fp, no_reqs, dxfr_len);
 		if (IS_ERR(r_srp)) {
 			if (!try_harder && dxfr_len < SG_DEF_SECTOR_SZ &&
-			    has_inactive) {
+			    some_inactive) {
 				try_harder = true;
 				goto start_again;
 			}
@@ -6777,7 +6770,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		if (err == EBUSY)
 			SG_LOG(4, fp, "%s: EBUSY (as ptr err)\n", __func__);
 		else
-			SG_LOG(1, fp, "%s: %s err=%d\n", __func__, b, err);
+			SG_LOG(1, fp, "%s: err=%d\n", __func__, err);
 	} else {
 		SG_LOG(4, fp, "%s: %s %sr_srp=0x%pK\n", __func__, cp,
 		       sg_get_rsv_str_lck(r_srp, "[", "] ", sizeof(b), b),
@@ -6911,9 +6904,9 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 		}
 		srp->rq_idx = idx;
 		srp->parentfp = sfp;
+		__set_bit(SG_FRQ_RESERVED, srp->frq_bm);
 		sg_rq_chg_state_force_ulck(srp, SG_RQ_INACTIVE);
 		atomic_inc(&sfp->inactives);
-		__set_bit(SG_FRQ_RESERVED, srp->frq_bm);
 		xa_unlock_irqrestore(xafp, iflags);
 	}
 	if (!reduced) {
-- 
2.25.1

