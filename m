Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F6AC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92B85613FF
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbhD0WAk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:40 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38982 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239352AbhD0WAI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id AE6DA204238;
        Tue, 27 Apr 2021 23:59:23 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CjlASc64JYte; Tue, 27 Apr 2021 23:59:20 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 6A1B1204190;
        Tue, 27 Apr 2021 23:59:19 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 68/83] sg: keep share and dout offset flags
Date:   Tue, 27 Apr 2021 17:57:18 -0400
Message-Id: <20210427215733.417746-70-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add new ability to have single READ followed by one or more
WRITEs. This is done by using the SGV4_FLAG_KEEP_SHARE flag
on all but the last WRITE request.

Further each WRITE (a "dout" operation) may start at a byte
offset by placing that offset in sg_io_v4::spare_in and setting
the SGV4_FLAG_DOUT_OFFSET flag.

Any shared WRITE's length may be less than or equal the prior
(and that includes when the "dout" offset is taken into account).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 244 ++++++++++++++++++++++++++++++-----------
 include/uapi/scsi/sg.h |   4 +-
 2 files changed, 181 insertions(+), 67 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 13a9c3f77715..1f6aae3909c7 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -220,6 +220,8 @@ struct sg_slice_hdr4 {	/* parts of sg_io_v4 object needed in async usage */
 	void __user *sbp;	/* derived from sg_io_v4::response */
 	u64 usr_ptr;		/* hold sg_io_v4::usr_ptr as given (u64) */
 	int out_resid;
+	u32 wr_offset;		/* from v4::spare_in when flagged; in bytes */
+	u32 wr_len;		/* for shared reqs maybe < read-side */
 	s16 dir;		/* data xfer direction; SG_DXFER_*  */
 	u16 cmd_len;		/* truncated of sg_io_v4::request_len */
 	u16 max_sb_len;		/* truncated of sg_io_v4::max_response_len */
@@ -315,9 +317,11 @@ struct sg_device { /* holds the state of each scsi generic device */
 };
 
 struct sg_comm_wr_t {  /* arguments to sg_common_write() */
+	bool keep_share;
 	int timeout;
 	int cmd_len;
 	int rsv_idx;		/* wanted rsv_arr index, def: -1 (anyone) */
+	int wr_offset;		/* non-zero if v4 and DOUT_OFFSET set */
 	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
 	union {		/* selector is frq_bm.SG_FRQ_IS_V4I */
 		struct sg_io_hdr *h3p;
@@ -710,6 +714,14 @@ sg_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static inline void
+sg_comm_wr_init(struct sg_comm_wr_t *cwrp)
+{
+	memset(cwrp, 0, sizeof(*cwrp));
+	WRITE_ONCE(cwrp->frq_bm[0], 0);
+	cwrp->rsv_idx = -1;
+}
+
 /*
  * ***********************************************************************
  * write(2) related functions follow. They are shown before read(2) related
@@ -856,14 +868,12 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 			 __func__, ohp->reply_len - (int)SZ_SG_HEADER,
 			 input_size, (unsigned int)opcode, current->comm);
 	}
+	sg_comm_wr_init(&cwr);
 	cwr.h3p = h3p;
-	WRITE_ONCE(cwr.frq_bm[0], 0);
 	cwr.timeout = sfp->timeout;
 	cwr.cmd_len = cmd_size;
-	cwr.rsv_idx = -1;
 	cwr.sfp = sfp;
 	cwr.u_cmdp = p;
-	cwr.cmdp = NULL;
 	srp = sg_common_write(&cwr);
 	return (IS_ERR(srp)) ? PTR_ERR(srp) : (int)count;
 }
@@ -929,15 +939,13 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 	if (test_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm))
 		clear_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(hp->timeout);
-	WRITE_ONCE(cwr.frq_bm[0], 0);
+	sg_comm_wr_init(&cwr);
 	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
 	cwr.h3p = hp;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	cwr.cmd_len = hp->cmd_len;
-	cwr.rsv_idx = -1;
 	cwr.sfp = sfp;
 	cwr.u_cmdp = hp->cmdp;
-	cwr.cmdp = NULL;
 	srp = sg_common_write(&cwr);
 	if (IS_ERR(srp))
 		return PTR_ERR(srp);
@@ -1118,6 +1126,7 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 {
 	bool have_mrq_sense = (cop->response && cop->max_response_len);
 	bool share_on_oth = false;
+	bool last_is_keep_share = false;
 	bool share;
 	int k;
 	u32 cdb_alen = cop->request_len;
@@ -1136,6 +1145,7 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 			       __func__, k, "bad guard");
 			return -ERANGE;
 		}
+		last_is_keep_share = !!(flags & SGV4_FLAG_KEEP_SHARE);
 		if (unlikely(flags & SGV4_FLAG_MULTIPLE_REQS)) {
 			SG_LOG(1, sfp, "%s: %s %u: no nested multi-reqs\n",
 			       __func__, rip, k);
@@ -1184,25 +1194,40 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 			hp->max_response_len = cop->max_response_len;
 		}
 	}
+	if (last_is_keep_share) {
+		SG_LOG(1, sfp,
+		       "%s: Can't set SGV4_FLAG_KEEP_SHARE on last mrq req\n",
+		       __func__);
+		return -ERANGE;
+	}
 	if (share_on_othp)
 		*share_on_othp = share_on_othp;
 	return 0;
 }
 
+/*
+ * Read operation (din) must precede any write (dout) operations and a din
+ * operation can't be last (data transferring) operations. Non data
+ * transferring operations can appear anywhere. Data transferring operations
+ * must have SGV4_FLAG_SHARE set. Dout operations must additionally have
+ * SGV4_FLAG_NO_DXFER and SGV4_FLAG_DO_ON_OTHER set. Din operations must
+ * not set SGV4_FLAG_DO_ON_OTHER.
+ */
 static bool
 sg_mrq_svb_chk(struct sg_io_v4 *a_hds, u32 tot_reqs)
 {
-	bool expect_rd;
+	bool last_rd = false;
+	bool seen_wr = false;
 	int k;
 	u32 flags;
 	struct sg_io_v4 *hp;
 
 	/* expect read-write pairs, all with SGV4_FLAG_NO_DXFER set */
-	for (k = 0, hp = a_hds, expect_rd = true; k < tot_reqs; ++k, ++hp) {
+	for (k = 0, hp = a_hds; k < tot_reqs; ++k, ++hp) {
 		flags = hp->flags;
 		if (flags & (SGV4_FLAG_COMPLETE_B4))
 			return false;
-		if (expect_rd) {
+		if (!seen_wr) {
 			if (hp->dout_xfer_len > 0)
 				return false;
 			if (hp->din_xfer_len > 0) {
@@ -1210,7 +1235,8 @@ sg_mrq_svb_chk(struct sg_io_v4 *a_hds, u32 tot_reqs)
 					return false;
 				if (flags & SGV4_FLAG_DO_ON_OTHER)
 					return false;
-				expect_rd = false;
+				seen_wr = true;
+				last_rd = true;
 			}
 			/* allowing commands with no dxfer */
 		} else {	/* checking write side */
@@ -1219,43 +1245,46 @@ sg_mrq_svb_chk(struct sg_io_v4 *a_hds, u32 tot_reqs)
 				    (SGV4_FLAG_NO_DXFER | SGV4_FLAG_SHARE |
 				     SGV4_FLAG_DO_ON_OTHER))
 					return false;
-				expect_rd = true;
+				last_rd = false;
+			}
+			if (hp->din_xfer_len > 0) {
+				if (!(flags & SGV4_FLAG_SHARE))
+					return false;
+				if (flags & SGV4_FLAG_DO_ON_OTHER)
+					return false;
+				last_rd = true;
 			}
-			if (hp->din_xfer_len > 0)
-				return false;
 		}
 	}
-	if (!expect_rd)
-		return false;
-	return true;
+	return !last_rd;
 }
 
 static struct sg_request *
 sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_hdr,
-	      int rsv_idx)
+	      int rsv_idx, bool keep_share)
 {
 	unsigned long ul_timeout;
 	struct sg_comm_wr_t r_cwr;
 	struct sg_comm_wr_t *r_cwrp = &r_cwr;
 	struct sg_io_v4 *hp = mhp->a_hds + pos_hdr;
 
-	if (mhp->cdb_ap) {	/* already have array of cdbs */
+	sg_comm_wr_init(r_cwrp);
+	if (mhp->cdb_ap)	/* already have array of cdbs */
 		r_cwrp->cmdp = mhp->cdb_ap + (pos_hdr * mhp->cdb_mxlen);
-		r_cwrp->u_cmdp = NULL;
-	} else {	/* fetch each cdb from user space */
-		r_cwrp->cmdp = NULL;
+	else			/* fetch each cdb from user space */
 		r_cwrp->u_cmdp = cuptr64(hp->request);
-	}
 	r_cwrp->cmd_len = hp->request_len;
 	r_cwrp->rsv_idx = rsv_idx;
 	ul_timeout = msecs_to_jiffies(hp->timeout);
-	r_cwrp->frq_bm[0] = 0;
 	__assign_bit(SG_FRQ_SYNC_INVOC, r_cwrp->frq_bm,
 		     (int)mhp->blocking);
 	__set_bit(SG_FRQ_IS_V4I, r_cwrp->frq_bm);
 	r_cwrp->h4p = hp;
 	r_cwrp->timeout = min_t(unsigned long, ul_timeout, INT_MAX);
+	if (hp->flags & SGV4_FLAG_DOUT_OFFSET)
+		r_cwrp->wr_offset = hp->spare_in;
 	r_cwrp->sfp = rq_sfp;
+	r_cwrp->keep_share = keep_share;
 	return sg_common_write(r_cwrp);
 }
 
@@ -1291,7 +1320,7 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 		}
 		flags = hp->flags;
 		rq_sfp = (flags & SGV4_FLAG_DO_ON_OTHER) ? o_sfp : fp;
-		srp = sg_mrq_submit(rq_sfp, mhp, j, -1);
+		srp = sg_mrq_submit(rq_sfp, mhp, j, -1, false);
 		if (IS_ERR(srp)) {
 			mhp->s_res = PTR_ERR(srp);
 			break;
@@ -1382,7 +1411,7 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 		   struct sg_mrq_hold *mhp)
 {
 	bool aborted = false;
-	bool chk_oth_first;
+	bool chk_oth_first, keep_share;
 	int k, j, i, m, rcv_before, idx, ws_pos, sent;
 	int this_fp_sent, other_fp_sent;
 	int num_subm = 0;
@@ -1437,7 +1466,7 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 				       __func__, (int)hp->request_extra);
 				rq_sfp = fp;
 			}
-			srp = sg_mrq_submit(rq_sfp, mhp, j, -1);
+			srp = sg_mrq_submit(rq_sfp, mhp, j, -1, false);
 			if (IS_ERR(srp)) {
 				mhp->s_res = PTR_ERR(srp);
 				res = mhp->s_res;	/* don't loop again */
@@ -1526,10 +1555,13 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 					res = -EPROTO;
 					break;
 				}
+				keep_share = false;
+another_dout:
 				SG_LOG(6, o_sfp,
 				       "%s: submit ws_pos=%d, rs_idx=%d\n",
 				       __func__, ws_pos, idx);
-				srp = sg_mrq_submit(o_sfp, mhp, ws_pos, idx);
+				srp = sg_mrq_submit(o_sfp, mhp, ws_pos, idx,
+						    keep_share);
 				if (IS_ERR(srp)) {
 					mhp->s_res = PTR_ERR(srp);
 					res = mhp->s_res;
@@ -1542,6 +1574,11 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 				++other_fp_sent;
 				++sent;
 				srp->s_hdr4.mrq_ind = ws_pos;
+				if (srp->rq_flags & SGV4_FLAG_KEEP_SHARE) {
+					++ws_pos;  /* next for same read-side */
+					keep_share = true;
+					goto another_dout;
+				}
 				if (mhp->chk_abort)
 					atomic_set(&srp->s_hdr4.pack_id_of_mrq,
 						   mhp->id_of_mrq);
@@ -1773,6 +1810,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 	struct sg_request *srp;
 	struct sg_comm_wr_t cwr;
 
+	sg_comm_wr_init(&cwr);
 	if (h4p->flags & SGV4_FLAG_MULTIPLE_REQS) {
 		/* want v4 async or sync with guard, din and dout and flags */
 		if (!h4p->dout_xferp || h4p->din_iovec_count ||
@@ -1781,7 +1819,6 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 			return -ERANGE;
 		if (o_srp)
 			*o_srp = NULL;
-		memset(&cwr, 0, sizeof(cwr));
 		cwr.sfp = sfp;
 		cwr.h4p = h4p;
 		res = sg_do_multi_req(&cwr, sync);
@@ -1810,15 +1847,14 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		clear_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(h4p->timeout);
 	cwr.sfp = sfp;
-	WRITE_ONCE(cwr.frq_bm[0], 0);
 	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
 	__set_bit(SG_FRQ_IS_V4I, cwr.frq_bm);
 	cwr.h4p = h4p;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	cwr.cmd_len = h4p->request_len;
-	cwr.rsv_idx = -1;
+	if (h4p->flags & SGV4_FLAG_DOUT_OFFSET)
+		cwr.wr_offset = h4p->spare_in;
 	cwr.u_cmdp = cuptr64(h4p->request);
-	cwr.cmdp = NULL;
 	srp = sg_common_write(&cwr);
 	if (IS_ERR(srp))
 		return PTR_ERR(srp);
@@ -2156,6 +2192,18 @@ sg_get_probable_read_side(struct sg_fd *sfp)
 			break;
 		}
 	}
+	/* Subsequent dout data transfers (e.g. WRITE) on a request share */
+	for (rapp = sfp->rsv_arr; rapp < end_rapp; ++rapp) {
+		rs_srp = *rapp;
+		if (IS_ERR_OR_NULL(rs_srp) || rs_srp->sh_srp)
+			continue;
+		switch (atomic_read(&rs_srp->rq_st)) {
+		case SG_RQ_INACTIVE:
+			return rs_srp;
+		default:
+			break;
+		}
+	}
 	return NULL;
 }
 
@@ -2326,6 +2374,10 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		srp->s_hdr4.dir = dir;
 		srp->s_hdr4.out_resid = 0;
 		srp->s_hdr4.mrq_ind = 0;
+		if (dir == SG_DXFER_TO_DEV) {
+			srp->s_hdr4.wr_offset = cwrp->wr_offset;
+			srp->s_hdr4.wr_len = dxfr_len;
+		}
 	} else {	/* v3 interface active */
 		memcpy(&srp->s_hdr3, hi_p, sizeof(srp->s_hdr3));
 	}
@@ -2420,6 +2472,8 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	int err = 0;
 	u32 rq_res = srp->rq_result;
 	enum sg_shr_var sh_var = srp->sh_var;
+	enum sg_rq_state rs_st = SG_RQ_INACTIVE;
+	struct sg_request *rs_srp;
 
 	if (unlikely(!scsi_status_is_good(rq_res))) {
 		int sb_len_wr = sg_copy_sense(srp, v4_active);
@@ -2433,27 +2487,28 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 		srp->rq_info |= SG_INFO_ABORTED;
 
 	if (sh_var == SG_SHR_WS_RQ && sg_fd_is_shared(sfp)) {
-		enum sg_rq_state rs_st;
-		struct sg_request *rs_srp = srp->sh_srp;
+		__maybe_unused char b[32];
 
+		rs_srp = srp->sh_srp;
 		if (!rs_srp)
 			return -EPROTO;
 		rs_st = atomic_read(&rs_srp->rq_st);
 
 		switch (rs_st) {
 		case SG_RQ_SHR_SWAP:
+			if (!(srp->rq_flags & SGV4_FLAG_KEEP_SHARE))
+				goto set_inactive;
+			SG_LOG(6, sfp, "%s: hold onto %s share\n",
+			       __func__, sg_get_rsv_str(rs_srp, "", "",
+							sizeof(b), b));
+			break;
 		case SG_RQ_SHR_IN_WS:
-			/* make read-side request available for re-use */
-			rs_srp->tag = SG_TAG_WILDCARD;
-			rs_srp->sh_var = SG_SHR_NONE;
-			sg_rq_chg_state_force(rs_srp, SG_RQ_INACTIVE);
-			atomic_inc(&rs_srp->parentfp->inactives);
-			rs_srp->frq_bm[0] = 0;
-			__set_bit(SG_FRQ_RESERVED, rs_srp->frq_bm);
-			rs_srp->in_resid = 0;
-			rs_srp->rq_info = 0;
-			rs_srp->sense_len = 0;
-			rs_srp->sh_srp = NULL;
+			if (!(srp->rq_flags & SGV4_FLAG_KEEP_SHARE))
+				goto set_inactive;
+			err = sg_rq_chg_state(rs_srp, rs_st, SG_RQ_SHR_SWAP);
+			SG_LOG(6, sfp, "%s: hold onto %s share\n",
+			       __func__, sg_get_rsv_str(rs_srp, "", "",
+							sizeof(b), b));
 			break;
 		case SG_RQ_AWAIT_RCV:
 			break;
@@ -2472,6 +2527,18 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	if (SG_IS_DETACHING(sfp->parentdp))
 		srp->rq_info |= SG_INFO_DEVICE_DETACHING;
 	return err;
+set_inactive:
+	/* make read-side request available for re-use */
+	rs_srp->tag = SG_TAG_WILDCARD;
+	rs_srp->sh_var = SG_SHR_NONE;
+	sg_rq_chg_state_force(rs_srp, SG_RQ_INACTIVE);
+	atomic_inc(&rs_srp->parentfp->inactives);
+	rs_srp->frq_bm[0] &= (1 << SG_FRQ_RESERVED);
+	rs_srp->in_resid = 0;
+	rs_srp->rq_info = 0;
+	rs_srp->sense_len = 0;
+	rs_srp->sh_srp = NULL;
+	return err;
 }
 
 static void
@@ -3978,7 +4045,7 @@ sg_fd_share(struct sg_fd *ws_sfp, int m_fd)
 /*
  * After checking the proposed file share relationship is unique and
  * valid, sets up pointers between read-side and write-side sg_fd objects.
- * Return 0 on success or negated errno value.
+ * Allows previous write-side to be the same as the new new_ws_fd .
  */
 static int
 sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
@@ -3996,15 +4063,21 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 		return -EBADF;
 	if (unlikely(!xa_get_mark(&rs_sfp->parentdp->sfp_arr, rs_sfp->idx,
 				  SG_XA_FD_RS_SHARE)))
-		return -EINVAL;
-	/* SG_XA_FD_RS_SHARE set impiles ws_sfp is valid */
+		res = -EINVAL;	/* invalid unless prev_sl==new_sl */
 
 	/* Alternate approach: fcheck_files(current->files, m_fd) */
 	filp = fget(new_ws_fd);
 	if (unlikely(!filp))
 		return -ENOENT;
-	if (unlikely(rs_sfp->filp == filp)) {/* share with self is confusing */
-		res = -ELOOP;
+	if (unlikely(rs_sfp->filp == filp)) {
+		res = -ELOOP;	/* share with self is confusing */
+		goto fini;
+	}
+	if (res == -EINVAL) {
+		if (ws_sfp && ws_sfp->filp == filp) {
+			found = true;
+			res = 0;	/* prev_sl==new_sl is okay */
+		}	/* else it is invalid and res is still -EINVAL */
 		goto fini;
 	}
 	SG_LOG(6, ws_sfp, "%s: write-side fd ok, scan for filp=0x%pK\n", __func__,
@@ -4014,7 +4087,7 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 	if (!IS_ERR(ws_sfp))
 		found = !!ws_sfp;
 fini:
-	/* paired with filp=fget(new_ws_fd) above */
+	/* fput() paired with filp=fget(new_ws_fd) above */
 	fput(filp);
 	if (unlikely(res))
 		return res;
@@ -5717,8 +5790,9 @@ sg_mk_kern_bio(int bvec_cnt)
 static int
 sg_rq_map_kern(struct sg_request *srp, struct request_queue *q, struct request *rqq, int rw_ind)
 {
-	struct sg_scatter_hold *schp = &srp->sgat_h;
+	struct sg_scatter_hold *schp = srp->sgatp;
 	struct bio *bio;
+	bool have_bio = false;
 	int k, ln;
 	int op_flags = 0;
 	int num_sgat = schp->num_sgat;
@@ -5732,12 +5806,48 @@ sg_rq_map_kern(struct sg_request *srp, struct request_queue *q, struct request *
 		return 0;
 	if (rw_ind == WRITE)
 		op_flags = REQ_SYNC | REQ_IDLE;
-	bio = sg_mk_kern_bio(num_sgat);
-	if (!bio)
-		return -ENOMEM;
-	bio->bi_opf = req_op(rqq) | op_flags;
-
-	for (k = 0; k < num_sgat && dlen > 0; ++k, dlen -= ln) {
+	k = 0;		/* N.B. following condition may increase k */
+	if (test_bit(SG_FRQ_IS_V4I, srp->frq_bm)) {
+		struct sg_slice_hdr4 *slh4p = &srp->s_hdr4;
+
+		if (slh4p->dir == SG_DXFER_TO_DEV) {
+			u32 wr_len = slh4p->wr_len;
+			u32 wr_off = slh4p->wr_offset;
+
+			if (wr_off > 0) {  /* skip over wr_off, conditionally add partial page */
+				for (ln = 0; k < num_sgat && wr_off > 0; ++k, wr_off -= ln)
+					ln = min_t(int, wr_off, pg_sz);
+				bio = sg_mk_kern_bio(num_sgat + 1 - k);
+				if (!bio)
+					return -ENOMEM;
+				bio->bi_opf = req_op(rqq) | op_flags;
+				have_bio = true;
+				if (ln < pg_sz) {	/* k > 0 since num_sgat > 0 */
+					int rlen = pg_sz - ln;
+					struct page *pg = schp->pages[k - 1];
+
+					if (bio_add_pc_page(q, bio, pg, rlen, ln) < rlen) {
+						bio_put(bio);
+						return -EINVAL;
+					}
+					wr_len -= pg_sz - ln;
+				}
+				dlen = wr_len;
+				SG_LOG(5, srp->parentfp, "%s:   wr_off=%u wr_len=%u\n", __func__,
+				       wr_off, wr_len);
+			} else {
+				if (wr_len < dlen)
+					dlen = wr_len;	/* short write, offset 0 */
+			}
+		}
+	}
+	if (!have_bio) {
+		bio = sg_mk_kern_bio(num_sgat - k);
+		if (!bio)
+			return -ENOMEM;
+		bio->bi_opf = req_op(rqq) | op_flags;
+	}
+	for ( ; k < num_sgat && dlen > 0; ++k, dlen -= ln) {
 		ln = min_t(int, dlen, pg_sz);
 		if (bio_add_pc_page(q, bio, schp->pages[k], ln, 0) < ln) {
 			bio_put(bio);
@@ -6431,23 +6541,23 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
 }
 
 static struct sg_request *
-sg_setup_req_ws_helper(struct sg_fd *fp, int rsv_idx)
+sg_setup_req_ws_helper(struct sg_comm_wr_t *cwrp)
 {
 	int res;
 	struct sg_request *r_srp;
 	enum sg_rq_state rs_sr_st;
+	struct sg_fd *fp = cwrp->sfp;
 	struct sg_fd *rs_sfp = sg_fd_share_ptr(fp);
 
 	if (unlikely(!rs_sfp))
 		return ERR_PTR(-EPROTO);
 	/*
-	 * There may be contention with another potential write-side trying
-	 * to pair with this read-side. The loser will receive an
-	 * EADDRINUSE errno. The winner advances read-side's rq_state:
-	 *     SG_RQ_SHR_SWAP --> SG_RQ_SHR_IN_WS
+	 * There may be contention with another potential write-side trying to pair with this
+	 * read-side. The loser will receive an EADDRINUSE errno. The winner advances read-side's
+	 * rq_state:	SG_RQ_SHR_SWAP --> SG_RQ_SHR_IN_WS
 	 */
-	if (rsv_idx >= 0)
-		r_srp = rs_sfp->rsv_arr[rsv_idx];
+	if (cwrp->rsv_idx >= 0)
+		r_srp = rs_sfp->rsv_arr[cwrp->rsv_idx];
 	else
 		r_srp = sg_get_probable_read_side(rs_sfp);
 	if (unlikely(!r_srp))
@@ -6538,13 +6648,14 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		goto good_fini;
 	case SG_SHR_WS_RQ:
 		cp = "rs_rq";
-		rs_rsv_srp = sg_setup_req_ws_helper(fp, cwrp->rsv_idx);
+		rs_rsv_srp = sg_setup_req_ws_helper(cwrp);
 		if (IS_ERR(rs_rsv_srp)) {
 			r_srp = rs_rsv_srp;
 			goto err_out;
 		}
 		/* write-side dlen may be <= read-side's dlen */
-		if (unlikely(dxfr_len > rs_rsv_srp->sgatp->dlen)) {
+		if (unlikely(dxfr_len + cwrp->wr_offset >
+			     rs_rsv_srp->sgatp->dlen)) {
 			SG_LOG(1, fp, "%s: bad, write-side dlen [%d] > read-side's\n",
 			       __func__, dxfr_len);
 			r_srp = ERR_PTR(-E2BIG);
@@ -6589,6 +6700,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 				if (r_srp->sgat_h.buflen <= SG_DEF_SECTOR_SZ) {
 					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
 						continue;
+					atomic_dec(&fp->inactives);
 					mk_new_srp = false;
 					break;
 				} else if (!low_srp) {
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index a3f3d244d2af..52eccedf2f33 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -114,6 +114,7 @@ typedef struct sg_io_hdr {
 #define SGV4_FLAG_YIELD_TAG 0x8  /* sg_io_v4::generated_tag set after SG_IOS */
 #define SGV4_FLAG_Q_AT_TAIL SG_FLAG_Q_AT_TAIL
 #define SGV4_FLAG_Q_AT_HEAD SG_FLAG_Q_AT_HEAD
+#define SGV4_FLAG_DOUT_OFFSET  0x40	/* dout byte offset in v4::spare_in */
 #define SGV4_FLAG_COMPLETE_B4  0x100	/* mrq: complete this rq before next */
 #define SGV4_FLAG_SIGNAL 0x200	/* v3: ignored; v4 signal on completion */
 #define SGV4_FLAG_IMMED 0x400   /* issue request and return immediately ... */
@@ -123,7 +124,8 @@ typedef struct sg_io_hdr {
 #define SGV4_FLAG_SHARE 0x4000	/* share IO buffer; needs SG_SEIM_SHARE_FD */
 #define SGV4_FLAG_DO_ON_OTHER 0x8000 /* available on either of shared pair */
 #define SGV4_FLAG_NO_DXFER SG_FLAG_NO_DXFER /* but keep dev<-->kernel xfr */
-#define SGV4_FLAG_MULTIPLE_REQS 0x20000	/* 1 or more sg_io_v4-s in data-in */
+#define SGV4_FLAG_KEEP_SHARE 0x20000  /* ... buffer for another dout command */
+#define SGV4_FLAG_MULTIPLE_REQS 0x40000	/* 1 or more sg_io_v4-s in data-in */
 
 /* Output (potentially OR-ed together) in v3::info or v4::info field */
 #define SG_INFO_OK_MASK 0x1
-- 
2.25.1

