Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5B4C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3466A613F1
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbhD0WAw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:52 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39044 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239462AbhD0WAe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 972112041BD;
        Tue, 27 Apr 2021 23:59:44 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id F6MkjdoM9kVd; Tue, 27 Apr 2021 23:59:41 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id D97E1204278;
        Tue, 27 Apr 2021 23:59:38 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 80/83] sg: expand bvec usage; re-use bio_s
Date:   Tue, 27 Apr 2021 17:57:30 -0400
Message-Id: <20210427215733.417746-82-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rework sg_rq_map_kern() to use the newer bio_add_pc_page() and
blk_rq_append_bio() functions instead of blk_rq_map_kern(). Build
single bio with multiple bvec elements, each holding 1 or more
pages. This requires direct manipulation of this request
object field: nr_phys_segments .

Re-use bio_s. Having built a complex bio why throw it away after
one use if the driver knows (e.g. in mrq svb mode) that it will
be building exactly the same bio again and again? This requires
manipulating bio_get() and bio_put() plus remembering about
5 bio fields that are cleared by bio_reset().

More clearly mark that a request belongs to a larger multiple
requests (mrq) submission with the SG_FRQ_PC_PART_MRQ bit field.

Change the error strategy in sg_svb_mrq_first_come() and
sg_svb_mrq_ordered(): once started they must continue to move
forward, even in the face of errors. If not, then there will be
very hard to detect memory leaks or worse. Read-side requests
especially must not be left stranded.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 543 ++++++++++++++++++++++++++++------------------
 1 file changed, 328 insertions(+), 215 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 0a0b40a8ab65..26047a8ff1e2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -145,6 +145,7 @@ enum sg_shr_var {
 #define SG_FRQ_PC_COUNT_ACTIVE	8	/* sfp->submitted + waiting active */
 #define SG_FRQ_PC_ISSUED	9	/* blk_execute_rq_nowait() finished */
 #define SG_FRQ_POLL_SLEPT	10	/* stop re-entry of hybrid_sleep() */
+#define SG_FRQ_PC_PART_MRQ	11	/* this cmd part of mrq array */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
@@ -189,7 +190,6 @@ static int sg_allow_dio = SG_ALLOW_DIO_DEF;	/* ignored by code */
 
 static int scatter_elem_sz = SG_SCATTER_SZ;
 static bool no_attach_msg;
-static atomic_t sg_tmp_count_reused_bios;
 
 #define SG_DEF_SECTOR_SZ 512
 
@@ -226,10 +226,14 @@ struct sg_slice_hdr3 {
 
 struct sg_slice_hdr4 {	/* parts of sg_io_v4 object needed in async usage */
 	void __user *sbp;	/* derived from sg_io_v4::response */
+	bio_end_io_t *bi_end_io;
 	u64 usr_ptr;		/* hold sg_io_v4::usr_ptr as given (u64) */
 	int out_resid;
 	u32 wr_offset;		/* from v4::spare_in when flagged; in bytes */
 	u32 wr_len;		/* for shared reqs maybe < read-side */
+	unsigned int bi_size;	/* reuse_bio: from original bio */
+	unsigned short bi_opf;	/* reuse_bio: from original bio */
+	unsigned short bi_vcnt;	/* reuse_bio: from original bio */
 	s16 dir;		/* data xfer direction; SG_DXFER_*  */
 	u16 cmd_len;		/* truncated of sg_io_v4::request_len */
 	u16 max_sb_len;		/* truncated of sg_io_v4::max_response_len */
@@ -260,6 +264,7 @@ struct sg_request {	/* active SCSI command or inactive request */
 	u32 rq_idx;		/* my index within parent's srp_arr */
 	u32 rq_info;		/* info supplied by v3 and v4 interfaces */
 	u32 rq_result;		/* packed scsi request result from LLD */
+	u32 rsv_arr_idx;	/* my index in parentfp->rsv_arr */
 	int in_resid;		/* requested-actual byte count on data-in */
 	int pack_id;		/* v3 pack_id or in v4 request_extra field */
 	int sense_len;		/* actual sense buffer length (data-in) */
@@ -304,9 +309,9 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	struct fasync_struct *async_qp; /* used by asynchronous notification */
 	struct eventfd_ctx *efd_ctxp;	/* eventfd context or NULL */
 	struct xarray srp_arr;	/* xarray of sg_request object pointers */
-	struct sg_request *rsv_arr[SG_MAX_RSV_REQS];
 	struct kref f_ref;
 	struct execute_work ew_fd;  /* harvest all fd resources and lists */
+	struct sg_request *rsv_arr[SG_MAX_RSV_REQS];
 };
 
 struct sg_device { /* holds the state of each scsi generic device */
@@ -354,6 +359,7 @@ struct sg_mrq_hold {	/* for passing context between multiple requests (mrq) func
 	unsigned ordered_wr:1;
 	int id_of_mrq;
 	int s_res;		/* secondary error: some-good-then-error; in co.spare_out */
+	int dtd_errs;		/* incremented for each driver/transport/device error */
 	u32 cdb_mxlen;		/* cdb length in cdb_ap, actual be may less */
 	u32 tot_reqs;		/* total number of requests and cdb_s */
 	struct sg_comm_wr_t *cwrp;	/* cwrp->h4p is mrq control object */
@@ -397,8 +403,7 @@ static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first, int db_l
 static int sg_abort_req(struct sg_fd *sfp, struct sg_request *srp);
 static int sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
 			   enum sg_rq_state new_st);
-static int sg_finish_rs_rq(struct sg_fd *sfp, struct sg_request *rs_srp,
-			   bool even_if_in_ws);
+static int sg_finish_rs_rq(struct sg_fd *sfp, struct sg_request *rs_srp, bool even_if_in_ws);
 static void sg_rq_chg_state_force(struct sg_request *srp, enum sg_rq_state new_st);
 static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);
 static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q,
@@ -1010,6 +1015,14 @@ sg_v4h_partial_zero(struct sg_io_v4 *h4p)
 	memset((u8 *)h4p + off, 0, SZ_SG_IO_V4 - off);
 }
 
+static inline bool
+sg_v4_cmd_good(struct sg_io_v4 *h4p)
+{
+	return (scsi_status_is_good(h4p->device_status) &&
+		(h4p->driver_status & 0xf) == 0 &&
+		(h4p->transport_status & 0xff) == 0);
+}
+
 static void
 sg_sgat_zero(struct sg_scatter_hold *sgatp, int off, int nbytes)
 {
@@ -1198,33 +1211,28 @@ sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
 
 /* N.B. After this function is completed what srp points to should be considered invalid. */
 static int
-sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_request *srp)
+sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_request *srp)
 {
-	int s_res, indx;
+	int res, indx;
 	int tot_reqs = mhp->tot_reqs;
+	struct sg_fd *sfp = srp->parentfp;
 	struct sg_io_v4 *hp;
 	struct sg_io_v4 *a_hds = mhp->a_hds;
 	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 
-	if (unlikely(!srp))
-		return -EPROTO;
 	indx = srp->s_hdr4.mrq_ind;
-	if (unlikely(srp->parentfp != sfp)) {
-		SG_LOG(1, sfp, "%s: mrq_ind=%d, sfp out-of-sync\n", __func__, indx);
-		return -EPROTO;
-	}
 	SG_LOG(3, sfp, "%s: %s, mrq_ind=%d, pack_id=%d\n", __func__, sg_side_str(srp), indx,
 	       srp->pack_id);
 	if (unlikely(indx < 0 || indx >= tot_reqs))
 		return -EPROTO;
 	hp = a_hds + indx;
-	s_res = sg_receive_v4(sfp, srp, NULL, hp);
-	if (unlikely(!sg_result_is_good(srp->rq_result)))
+	res = sg_receive_v4(sfp, srp, NULL, hp);
+	if (unlikely(res))
+		return res;
+	if (unlikely(!sg_v4_cmd_good(hp)))
 		SG_LOG(2, sfp, "%s: %s, bad status: drv/tran/scsi=0x%x/0x%x/0x%x\n",
 		       __func__, sg_side_str(srp), hp->driver_status,
 		       hp->transport_status, hp->device_status);
-	if (unlikely(s_res == -EFAULT))
-		return s_res;
 	hp->info |= SG_INFO_MRQ_FINI;
 	++cop->info;
 	if (cop->din_xfer_len > 0)
@@ -1239,9 +1247,9 @@ sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_request *s
 				pr_info("%s: eventfd_signal problem\n", __func__);
 		}
 	} else if (sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
-		s_res = sg_mrq_arr_flush(mhp);
-		if (unlikely(s_res))	/* can only be -EFAULT */
-			return s_res;
+		res = sg_mrq_arr_flush(mhp);
+		if (unlikely(res))
+			return res;
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 	}
 	return 0;
@@ -1382,8 +1390,6 @@ sg_mrq_poll_either(struct sg_fd *sfp, struct sg_fd *sec_sfp, bool *on_sfp)
 		if (sfp) {
 			if (sg_mrq_get_ready_srp(sfp, &srp)) {
 				__set_current_state(TASK_RUNNING);
-				if (!srp)
-					return ERR_PTR(-ENODEV);
 				*on_sfp = true;
 				return srp;
 			}
@@ -1391,8 +1397,6 @@ sg_mrq_poll_either(struct sg_fd *sfp, struct sg_fd *sec_sfp, bool *on_sfp)
 		if (sec_sfp && sfp != sec_sfp) {
 			if (sg_mrq_get_ready_srp(sec_sfp, &srp)) {
 				__set_current_state(TASK_RUNNING);
-				if (!srp)
-					return ERR_PTR(-ENODEV);
 				*on_sfp = false;
 				return srp;
 			}
@@ -1420,14 +1424,18 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sf
 	SG_LOG(3, sfp, "%s: mreqs=%d, sec_reqs=%d\n", __func__, mreqs, sec_reqs);
 	while (mreqs + sec_reqs > 0) {
 		while (mreqs > 0 && sg_mrq_get_ready_srp(sfp, &srp)) {
+			if (IS_ERR(srp))
+				return PTR_ERR(srp);
 			--mreqs;
-			res = sg_mrq_1complet(mhp, sfp, srp);
+			res = sg_mrq_1complet(mhp, srp);
 			if (unlikely(res))
 				return res;
 		}
 		while (sec_reqs > 0 && sg_mrq_get_ready_srp(sec_sfp, &srp)) {
+			if (IS_ERR(srp))
+				return PTR_ERR(srp);
 			--sec_reqs;
-			res = sg_mrq_1complet(mhp, sec_sfp, srp);
+			res = sg_mrq_1complet(mhp, srp);
 			if (unlikely(res))
 				return res;
 		}
@@ -1443,7 +1451,7 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sf
 				mreqs = 0;
 			} else {
 				--mreqs;
-				res = sg_mrq_1complet(mhp, sfp, srp);
+				res = sg_mrq_1complet(mhp, srp);
 				if (unlikely(res))
 					return res;
 			}
@@ -1456,7 +1464,7 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sf
 				sec_reqs = 0;
 			} else {
 				--sec_reqs;
-				res = sg_mrq_1complet(mhp, sec_sfp, srp);
+				res = sg_mrq_1complet(mhp, srp);
 				if (unlikely(res))
 					return res;
 			}
@@ -1470,12 +1478,12 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sf
 			return PTR_ERR(srp);
 		if (on_sfp) {
 			--mreqs;
-			res = sg_mrq_1complet(mhp, sfp, srp);
+			res = sg_mrq_1complet(mhp, srp);
 			if (unlikely(res))
 				return res;
 		} else {
 			--sec_reqs;
-			res = sg_mrq_1complet(mhp, sec_sfp, srp);
+			res = sg_mrq_1complet(mhp, srp);
 			if (unlikely(res))
 				return res;
 		}
@@ -1649,6 +1657,7 @@ sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_in_rq_arr,
 	ul_timeout = msecs_to_jiffies(hp->timeout);
 	__assign_bit(SG_FRQ_PC_SYNC_INVOC, r_cwrp->frq_pc_bm, (int)mhp->from_sg_io);
 	__set_bit(SG_FRQ_PC_IS_V4I, r_cwrp->frq_pc_bm);
+	__set_bit(SG_FRQ_PC_PART_MRQ, r_cwrp->frq_pc_bm);
 	r_cwrp->h4p = hp;
 	r_cwrp->dlen = hp->din_xfer_len ? hp->din_xfer_len : hp->dout_xfer_len;
 	r_cwrp->timeout = min_t(unsigned long, ul_timeout, INT_MAX);
@@ -1704,15 +1713,18 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *m
 				++other_fp_sent;
 			continue;  /* defer completion until all submitted */
 		}
-		mhp->s_res = sg_wait_poll_for_given_srp(rq_sfp, srp, mhp->hipri);
-		if (unlikely(mhp->s_res)) {
-			if (mhp->s_res == -ERESTARTSYS || mhp->s_res == -ENODEV)
-				return mhp->s_res;
+		res = sg_wait_poll_for_given_srp(rq_sfp, srp, mhp->hipri);
+		if (unlikely(res)) {
+			mhp->s_res = res;
+			if (res == -ERESTARTSYS || res == -ENODEV)
+				return res;
 			break;
 		}
-		res = sg_mrq_1complet(mhp, rq_sfp, srp);
-		if (unlikely(res))
+		res = sg_mrq_1complet(mhp, srp);
+		if (unlikely(res)) {
+			mhp->s_res = res;
 			break;
+		}
 		++num_cmpl;
 	}	/* end of dispatch request and optionally wait response loop */
 	cop->dout_resid = mhp->tot_reqs - num_subm;
@@ -1725,28 +1737,54 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *m
 	if (mhp->immed)
 		return res;
 	if (likely(res == 0 && (this_fp_sent + other_fp_sent) > 0)) {
-		mhp->s_res = sg_mrq_complets(mhp, fp, o_sfp, this_fp_sent, other_fp_sent);
-		if (unlikely(mhp->s_res == -EFAULT || mhp->s_res == -ERESTARTSYS))
-			res = mhp->s_res;	/* this may leave orphans */
+		res = sg_mrq_complets(mhp, fp, o_sfp, this_fp_sent, other_fp_sent);
+		if (res)
+			mhp->s_res = res;	/* this may leave orphans */
 	}
 	if (mhp->id_of_mrq)	/* can no longer do a mrq abort */
 		atomic_set(&fp->mrq_id_abort, 0);
 	return res;
 }
 
+static bool
+sg_svb_err_process(struct sg_mrq_hold *mhp, int m_ind, struct sg_fd *fp, int res, bool rs)
+{
+	__maybe_unused const char *ss = rs ? "read-side" : "write-side";
+
+	if (res) {
+		if (mhp->s_res == 0)
+			mhp->s_res = res;
+		SG_LOG(1, fp, "%s: %s failure, res=%d\n", __func__, ss, res);
+	} else {
+		struct sg_io_v4 *hp = mhp->a_hds + m_ind;
+
+		++mhp->dtd_errs;
+		SG_LOG(2, fp, "%s: %s, bad status: drv/trans_host/scsi=0x%x/0x%x/0x%x\n",
+		       __func__, ss, hp->driver_status, hp->transport_status, hp->device_status);
+	}
+	return mhp->stop_if;
+}
+
+static inline void
+sg_svb_zero_elem(struct sg_svb_elem *svb_ap, int m)
+{
+	svb_ap[m].rs_srp = NULL;
+	svb_ap[m].prev_ws_srp = NULL;
+}
+
 /* For multiple requests (mrq) share variable blocking (svb) with no SGV4_FLAG_ORDERED_WR */
 static int
 sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp, int ra_ind,
 		      int *num_submp)
 {
 	bool chk_oth_first = false;
+	bool stop_triggered = false;
 	bool is_first = true;
+	bool rs_fail;
 	enum sg_rq_state rq_st;
 	int this_fp_sent = 0;
 	int other_fp_sent = 0;
-	int res = 0;
-	int first_err = 0;
-	int k, m, idx, ws_pos, num_reads, sent, dir;
+	int k, m, res, idx, ws_pos, num_reads, sent, dir, m_ind;
 	struct sg_io_v4 *hp = mhp->a_hds + ra_ind;
 	struct sg_request *srp;
 	struct sg_request *rs_srp;
@@ -1778,15 +1816,13 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 		}
 		if (IS_ERR(srp)) {
 			mhp->s_res = PTR_ERR(srp);
-			if (first_err == 0)
-				first_err = mhp->s_res;
 			SG_LOG(1, fp, "%s: sg_mrq_submit() err: %d\n", __func__, mhp->s_res);
 			break;	/* stop doing rs submits */
 		}
 		++*num_submp;
+		srp->s_hdr4.mrq_ind = ra_ind;
 		if (hp->din_xfer_len > 0)
 			svb_arr[k].rs_srp = srp;
-		srp->s_hdr4.mrq_ind = ra_ind;
 		if (mhp->chk_abort)
 			atomic_set(&srp->s_hdr4.pack_id_of_mrq, mhp->id_of_mrq);
 	}	/* end of read-side submission, write-side defer loop */
@@ -1794,26 +1830,41 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 	num_reads = k;
 	sent = this_fp_sent + other_fp_sent;
 
+	/*
+	 * It is important _not_ to break out of this loop as that will lead to hard to detect
+	 * memory leaks. We must wait for inflight requests to complete before final cleanup.
+	 */
 	for (k = 0; k < sent; ++k) {
 		if (other_fp_sent > 0 && sg_mrq_get_ready_srp(o_sfp, &srp)) {
+			if (IS_ERR(srp)) {
+				mhp->s_res = PTR_ERR(srp);
+				continue;
+			}
 other_found:
 			--other_fp_sent;
-			res = sg_mrq_1complet(mhp, o_sfp, srp);
-			if (unlikely(res))
-				break;
+			m_ind = srp->s_hdr4.mrq_ind;
+			res = sg_mrq_1complet(mhp, srp);
+			if (unlikely(res || !sg_v4_cmd_good(mhp->a_hds + m_ind)))
+				stop_triggered = sg_svb_err_process(mhp, m_ind, o_sfp, res, false);
 			continue;  /* do available submits first */
 		}
 		if (this_fp_sent > 0 && sg_mrq_get_ready_srp(fp, &srp)) {
+			if (IS_ERR(srp)) {
+				mhp->s_res = PTR_ERR(srp);
+				continue;
+			}
 this_found:
 			--this_fp_sent;
 			dir = srp->s_hdr4.dir;
-			res = sg_mrq_1complet(mhp, fp, srp);
-			if (unlikely(res))
-				break;
+			rs_fail = false;
+			m_ind = srp->s_hdr4.mrq_ind;
+			res = sg_mrq_1complet(mhp, srp);
+			if (unlikely(res || !sg_v4_cmd_good(mhp->a_hds + m_ind))) {
+				rs_fail = true;
+				stop_triggered = sg_svb_err_process(mhp, m_ind, fp, res, true);
+			}
 			if (dir != SG_DXFER_FROM_DEV)
 				continue;
-			if (test_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm))
-				continue;
 			/* read-side req completed, submit its write-side(s) */
 			rs_srp = srp;
 			for (m = 0; m < num_reads; ++m) {
@@ -1825,37 +1876,27 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 				       srp->pack_id);
 				continue;
 			}
+			if (stop_triggered || rs_fail) {
+				sg_svb_zero_elem(svb_arr, m);
+				continue;
+			}
 			rq_st = atomic_read(&rs_srp->rq_st);
-			if (rq_st == SG_RQ_INACTIVE)
-				continue;       /* probably an error, bypass paired write-side rq */
-			else if (rq_st != SG_RQ_SHR_SWAP) {
+			if (rq_st == SG_RQ_INACTIVE) {
+				sg_svb_zero_elem(svb_arr, m);
+				continue;  /* probably an error, bypass paired write-side rq */
+			} else if (rq_st != SG_RQ_SHR_SWAP) {
 				SG_LOG(1, fp, "%s: expect rs_srp to be in shr_swap\n", __func__);
-				res = -EPROTO;
-				break;
+				mhp->s_res = -EPROTO;
+				sg_svb_zero_elem(svb_arr, m);
+				continue;
 			}
 			ws_pos = svb_arr[m].ws_pos;
-			for (idx = 0; idx < SG_MAX_RSV_REQS; ++idx) {
-				if (fp->rsv_arr[idx] == srp)
-					break;
-			}
-			if (idx >= SG_MAX_RSV_REQS) {
-				SG_LOG(1, fp, "%s: srp not in rsv_arr\n", __func__);
-				res = -EPROTO;
-				break;
-			}
+			idx = srp->rsv_arr_idx;
 			SG_LOG(6, o_sfp, "%s: ws_pos=%d, rs_idx=%d\n", __func__, ws_pos, idx);
 			srp = sg_mrq_submit(o_sfp, mhp, ws_pos, idx, svb_arr[m].prev_ws_srp);
 			if (IS_ERR(srp)) {
+				sg_svb_zero_elem(svb_arr, m);
 				mhp->s_res = PTR_ERR(srp);
-				if (mhp->s_res == -EFBIG) {	/* out of reserve slots */
-					if (first_err)
-						break;
-					res = mhp->s_res;
-					break;
-				}
-				if (first_err == 0)
-					first_err = mhp->s_res;
-				svb_arr[m].prev_ws_srp = NULL;
 				SG_LOG(1, o_sfp, "%s: sg_mrq_submit(oth)->%d\n", __func__,
 				       mhp->s_res);
 				continue;
@@ -1876,8 +1917,11 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 		if (this_fp_sent > 0) {
 			res = sg_wait_any_mrq(fp, &srp);
 			if (unlikely(res))
-				break;
-			goto this_found;
+				mhp->s_res = res;
+			else if (IS_ERR(srp))
+				mhp->s_res = PTR_ERR(srp);
+			else
+				goto this_found;
 		}
 		if (chk_oth_first)
 			continue;
@@ -1885,24 +1929,31 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 		if (other_fp_sent > 0) {
 			res = sg_wait_any_mrq(o_sfp, &srp);
 			if (unlikely(res))
-				break;
-			goto other_found;
+				mhp->s_res = res;
+			else if (IS_ERR(srp))
+				mhp->s_res = PTR_ERR(srp);
+			else
+				goto other_found;
 		}
 		if (chk_oth_first)
 			goto this_second;
 	}	/* end of loop for deferred ws submits and rs+ws responses */
 
-	if (res == 0 && first_err)
-		res = first_err;
-	return res;
+	if (mhp->s_res) {
+		if (mhp->stop_if)
+			stop_triggered = true;
+	}
+	return stop_triggered ? -ECANCELED : 0;
 }
 
 static int
 sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp, int ra_ind,
 		   int *num_submp)
 {
+	bool stop_triggered = false;
+	bool rs_fail;
 	enum sg_rq_state rq_st;
-	int k, m, res, idx, ws_pos, num_reads;
+	int k, m, res, idx, ws_pos, num_reads, m_ind;
 	int this_fp_sent = 0;
 	int other_fp_sent = 0;
 	struct sg_io_v4 *hp = mhp->a_hds + ra_ind;
@@ -1949,45 +2000,46 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 	num_reads = k;
 
 	if (this_fp_sent + other_fp_sent <= 0)
-		return 0;
+		goto fini;
+
 	for (m = 0; m < num_reads; ++m) {
 		rs_srp = svb_arr[m].rs_srp;
 		if (!rs_srp)
 			continue;
 		res = sg_wait_poll_for_given_srp(fp, rs_srp, mhp->hipri);
 		if (unlikely(res))
-			return res;
+			mhp->s_res = res;
 		--this_fp_sent;
-		res = sg_mrq_1complet(mhp, fp, rs_srp);
-		if (unlikely(res))
-			return res;
-		if (test_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm))
+		rs_fail = false;
+		m_ind = rs_srp->s_hdr4.mrq_ind;
+		res = sg_mrq_1complet(mhp, rs_srp);
+		if (unlikely(res || !sg_v4_cmd_good(mhp->a_hds + m_ind))) {
+			rs_fail = true;
+			stop_triggered = sg_svb_err_process(mhp, m_ind, fp, res, true);
+		}
+		if (unlikely(stop_triggered || rs_fail)) {
+			sg_svb_zero_elem(svb_arr, m);
 			continue;
+		}
 		rq_st = atomic_read(&rs_srp->rq_st);
-		if (rq_st == SG_RQ_INACTIVE)
+		if (rq_st == SG_RQ_INACTIVE) {
+			sg_svb_zero_elem(svb_arr, m);
 			continue;       /* probably an error, bypass paired write-side rq */
-		else if (rq_st != SG_RQ_SHR_SWAP) {
+		} else if (rq_st != SG_RQ_SHR_SWAP) {
 			SG_LOG(1, fp, "%s: expect rs_srp to be in shr_swap\n", __func__);
-			res = -EPROTO;
-			break;
+			mhp->s_res = -EPROTO;
+			sg_svb_zero_elem(svb_arr, m);
+			continue;
 		}
 		ws_pos = svb_arr[m].ws_pos;
-		for (idx = 0; idx < SG_MAX_RSV_REQS; ++idx) {
-			if (fp->rsv_arr[idx] == rs_srp)
-				break;
-		}
-		if (idx >= SG_MAX_RSV_REQS) {
-			SG_LOG(1, rs_srp->parentfp, "%s: srp not in rsv_arr\n", __func__);
-			res = -EPROTO;
-			return res;
-		}
+		idx = rs_srp->rsv_arr_idx;
 		SG_LOG(6, o_sfp, "%s: ws_pos=%d, rs_idx=%d\n", __func__, ws_pos, idx);
 		srp = sg_mrq_submit(o_sfp, mhp, ws_pos, idx, svb_arr[m].prev_ws_srp);
 		if (IS_ERR(srp)) {
+			sg_svb_zero_elem(svb_arr, m);
 			mhp->s_res = PTR_ERR(srp);
-			res = mhp->s_res;
-			SG_LOG(1, o_sfp, "%s: mrq_submit(oth)->%d\n", __func__, res);
-			return res;
+			SG_LOG(1, o_sfp, "%s: mrq_submit(oth)->%d\n", __func__, mhp->s_res);
+			continue;
 		}
 		svb_arr[m].prev_ws_srp = srp;
 		++*num_submp;
@@ -1997,24 +2049,54 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 			atomic_set(&srp->s_hdr4.pack_id_of_mrq, mhp->id_of_mrq);
 	}
 	while (this_fp_sent > 0) {	/* non-data requests */
-		res = sg_wait_any_mrq(fp, &srp);
-		if (unlikely(res))
-			return res;
 		--this_fp_sent;
-		res = sg_mrq_1complet(mhp, fp, srp);
+		res = sg_wait_any_mrq(fp, &srp);
+		if (unlikely(res)) {
+			mhp->s_res = res;
+			continue;
+		}
+		if (IS_ERR(srp)) {
+			mhp->s_res = PTR_ERR(srp);
+			continue;
+		}
+		m_ind = srp->s_hdr4.mrq_ind;
+		res = sg_mrq_1complet(mhp, srp);
 		if (unlikely(res))
-			return res;
+			mhp->s_res = res;
 	}
 	while (other_fp_sent > 0) {
-		res = sg_wait_any_mrq(o_sfp, &srp);
-		if (unlikely(res))
-			return res;
 		--other_fp_sent;
-		res = sg_mrq_1complet(mhp, o_sfp, srp);
+		res = sg_wait_any_mrq(o_sfp, &srp);
+		if (unlikely(res)) {
+			mhp->s_res = res;
+			continue;
+		}
+		if (IS_ERR(srp)) {
+			mhp->s_res = PTR_ERR(srp);
+			continue;
+		}
+		m_ind = srp->s_hdr4.mrq_ind;
+		res = sg_mrq_1complet(mhp, srp);
 		if (unlikely(res))
-			return res;
+			mhp->s_res = res;
+	}
+fini:
+	if (mhp->s_res) {
+		if (mhp->stop_if)
+			stop_triggered = true;
+	}
+	return stop_triggered ? -ECANCELED : 0;
+}
+
+static inline void
+sg_svb_srp_cleanup(struct sg_request *srp)
+{
+	if (test_and_clear_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm)) {
+		if (srp->bio) {
+			bio_put(srp->bio);	/* _get() near end of sg_start_req() */
+			srp->bio = NULL;
+		}
 	}
-	return 0;
 }
 
 static void
@@ -2024,12 +2106,8 @@ sg_svb_cleanup(struct sg_fd *sfp)
 	struct xarray *xafp = &sfp->srp_arr;
 	struct sg_request *srp;
 
-	xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_INACTIVE) {
-		if (test_and_clear_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm)) {
-			bio_put(srp->bio);	/* _get() near end of sg_start_req() */
-			srp->bio = NULL;
-		}
-	}
+	xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_INACTIVE)
+		sg_svb_srp_cleanup(srp);
 }
 
 /*
@@ -2089,7 +2167,7 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 		atomic_set(&fp->mrq_id_abort, 0);
 	if (test_and_clear_bit(SG_FFD_CAN_REUSE_BIO, fp->ffd_bm))
 		sg_svb_cleanup(fp);
-	return res;
+	return res == -ECANCELED ? 0 : res;
 }
 
 #if IS_ENABLED(SG_LOG_ACTIVE)
@@ -2156,6 +2234,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	mhp->id_of_mrq = (int)cop->request_extra;
 	mhp->tot_reqs = tot_reqs;
 	mhp->s_res = 0;
+	mhp->dtd_errs = 0;
 	if (mhp->id_of_mrq) {
 		existing_id = atomic_cmpxchg(&fp->mrq_id_abort, 0, mhp->id_of_mrq);
 		if (existing_id && existing_id != mhp->id_of_mrq) {
@@ -2205,11 +2284,15 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 		else
 			return -EPROTO;
 	}
+	if (din_len > 0) {
+		if (unlikely(din_len > SG_MAX_MULTI_REQ_SZ))
+			return  -E2BIG;
+	} else if (dout_len > 0) {
+		if (unlikely(dout_len > SG_MAX_MULTI_REQ_SZ))
+			return  -E2BIG;
+	}
 	if (unlikely(tot_reqs > U16_MAX)) {
 		return -ERANGE;
-	} else if (unlikely(dout_len > SG_MAX_MULTI_REQ_SZ || din_len > SG_MAX_MULTI_REQ_SZ ||
-			    cdb_alen > SG_MAX_MULTI_REQ_SZ)) {
-		return  -E2BIG;
 	} else if (unlikely(mhp->immed && mhp->stop_if)) {
 		return -ERANGE;
 	} else if (unlikely(tot_reqs == 0)) {
@@ -2217,6 +2300,8 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	} else if (unlikely(!!cdb_alen != !!cop->request)) {
 		return -ERANGE;	/* both must be zero or both non-zero */
 	} else if (cdb_alen) {
+		if (unlikely(cdb_alen > SG_MAX_MULTI_REQ_SZ))
+			return  -E2BIG;
 		if (unlikely(cdb_alen % tot_reqs))
 			return -ERANGE;
 		cdb_mxlen = cdb_alen / tot_reqs;
@@ -2681,7 +2766,6 @@ sg_get_rsv_str(struct sg_request *srp, const char *leadin, const char *leadout,
 {
 	int k, i_len, o_len, len;
 	struct sg_fd *sfp;
-	struct sg_request **rapp;
 
 	if (!b || b_len < 1)
 		return b;
@@ -2696,13 +2780,9 @@ sg_get_rsv_str(struct sg_request *srp, const char *leadin, const char *leadout,
 	sfp = srp->parentfp;
 	if (!sfp)
 		goto blank;
-	rapp = sfp->rsv_arr;
-	for (k = 0; k < SG_MAX_RSV_REQS; ++k, ++rapp) {
-		if (srp == *rapp)
-			break;
-	}
-	if (k >= SG_MAX_RSV_REQS)
+	if (!test_bit(SG_FRQ_LT_RESERVED, srp->frq_lt_bm))
 		goto blank;
+	k = srp->rsv_arr_idx;
 	scnprintf(b, b_len, "%srsv%d%s", leadin, k, leadout);
 	return b;
 blank:
@@ -2803,8 +2883,6 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		rq_flags = hi_p->flags;
 		pack_id = hi_p->pack_id;
 	}
-	if (unlikely(rq_flags & SGV4_FLAG_MULTIPLE_REQS))
-		return ERR_PTR(-ERANGE);  /* only control object sets this */
 	if (sg_fd_is_shared(fp)) {
 		res = sg_share_chk_flags(fp, rq_flags, dlen, dir, &sh_var);
 		if (unlikely(res < 0))
@@ -2852,6 +2930,12 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 	sg_execute_cmd(fp, srp);
 	return srp;
 err_out:
+	if (srp->sh_var == SG_SHR_WS_RQ) {
+		struct sg_request *rs_srp = srp->sh_srp;
+
+		if (rs_srp)
+			sg_finish_rs_rq(NULL, rs_srp, true);
+	}
 	sg_deact_request(fp, srp);
 	return ERR_PTR(res);
 }
@@ -3644,70 +3728,81 @@ sg_finish_rs_rq(struct sg_fd *sfp, struct sg_request *rs_srp, bool even_if_in_ws
 	bool found_one = false;
 	int res = -EINVAL;
 	int k;
-	enum sg_rq_state sr_st;
+	enum sg_rq_state rq_st;
 	unsigned long iflags;
 	struct sg_fd *rs_sfp;
-	struct sg_request *rs_rsv_srp;
-	struct sg_device *sdp = sfp->parentdp;
-
-	rs_sfp = sg_fd_share_ptr(sfp);
-	if (unlikely(!rs_sfp))
-		goto fini;
-	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE))
-		rs_sfp = sfp;
 
-	for (k = 0; k < SG_MAX_RSV_REQS; ++k) {
-		res = -EINVAL;
-		rs_rsv_srp = rs_sfp->rsv_arr[k];
-		if (rs_srp) {
-			if (rs_srp != rs_rsv_srp)
+	if (rs_srp) {
+		if (rs_srp->sh_var != SG_SHR_RS_RQ) {
+			res = -EPROTO;
+			goto err;
+		}
+		rs_sfp = rs_srp->parentfp;
+	} else {
+		if (!sfp)
+			goto err;
+		if (xa_get_mark(&sfp->parentdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE)) {
+			rs_sfp = sfp;
+		} else if (sg_fd_is_shared(sfp)) {	/* must be write-side */
+			rs_sfp = sg_fd_share_ptr(sfp);
+		} else {
+			pr_warn("%s: non sharing fd given\n", __func__);
+			res = -EINVAL;
+			goto err;
+		}
+		for (k = 0; k < SG_MAX_RSV_REQS; ++k) {
+			rs_srp = rs_sfp->rsv_arr[k];
+			if (IS_ERR_OR_NULL(rs_srp))
 				continue;
+			if (atomic_read(&rs_srp->rq_st) == SG_RQ_SHR_SWAP)
+				break;
 		}
-		if (IS_ERR_OR_NULL(rs_rsv_srp))
-			continue;
-		xa_lock_irqsave(&rs_sfp->srp_arr, iflags);
-		sr_st = atomic_read(&rs_rsv_srp->rq_st);
-		switch (sr_st) {
-		case SG_RQ_SHR_SWAP:
-			found_one = true;
-			break;
-		case SG_RQ_SHR_IN_WS:
-			if (even_if_in_ws)
-				found_one = true;
-			else
-				res = -EBUSY;
-			break;
-		case SG_RQ_BUSY:
-			res = -EBUSY;
-			break;
-		default:
+		if (k >= SG_MAX_RSV_REQS) {
 			res = -EINVAL;
-			break;
+			goto fini;
 		}
-		if (found_one)
-			goto found;
-		xa_unlock_irqrestore(&rs_sfp->srp_arr, iflags);
-		if (rs_srp)
-			return res;	/* found rs_srp but was in wrong state */
 	}
-fini:
+	xa_lock_irqsave(&rs_sfp->srp_arr, iflags);
+	rq_st = atomic_read(&rs_srp->rq_st);
+	switch (rq_st) {
+	case SG_RQ_SHR_SWAP:
+		found_one = true;
+		break;
+	case SG_RQ_SHR_IN_WS:
+	case SG_RQ_BUSY:
+		if (even_if_in_ws)
+			found_one = true;
+		else
+			res = -EBUSY;
+		break;
+	default:
+		res = -EINVAL;
+		break;
+	}
+	if (found_one)
+		goto found;
+	xa_unlock_irqrestore(&rs_sfp->srp_arr, iflags);
+err:
 	if (unlikely(res))
-		SG_LOG(1, sfp, "%s: err=%d\n", __func__, -res);
+		SG_LOG(1, rs_sfp, "%s: err=%d\n", __func__, -res);
+	if (rs_srp)
+		goto fini;
 	return res;
 found:
-	res = sg_rq_chg_state_ulck(rs_rsv_srp, sr_st, SG_RQ_BUSY);
+	res = sg_rq_chg_state_ulck(rs_srp, rq_st, SG_RQ_BUSY);
 	if (!res)
 		atomic_inc(&rs_sfp->inactives);
-	rs_rsv_srp->tag = SG_TAG_WILDCARD;
-	rs_rsv_srp->sh_var = SG_SHR_NONE;
-	rs_rsv_srp->in_resid = 0;
-	rs_rsv_srp->rq_info = 0;
-	rs_rsv_srp->sense_len = 0;
-	rs_rsv_srp->sh_srp = NULL;
+	rs_srp->tag = SG_TAG_WILDCARD;
+	rs_srp->sh_var = SG_SHR_NONE;
+	rs_srp->in_resid = 0;
+	rs_srp->rq_info = 0;
+	rs_srp->sense_len = 0;
+	rs_srp->sh_srp = NULL;
 	xa_unlock_irqrestore(&rs_sfp->srp_arr, iflags);
-	sg_finish_scsi_blk_rq(rs_rsv_srp);
-	sg_deact_request(rs_rsv_srp->parentfp, rs_rsv_srp);
-	return 0;
+fini:
+	sg_finish_scsi_blk_rq(rs_srp);
+	sg_deact_request(rs_sfp, rs_srp);
+	return res;
 }
 
 static void
@@ -4126,6 +4221,8 @@ sg_match_first_mrq_after(struct sg_fd *sfp, int pack_id, struct sg_request *afte
 				look_for_after = false;
 			continue;
 		}
+		if (!test_bit(SG_FRQ_PC_PART_MRQ, srp->frq_pc_bm))
+			continue;
 		id = atomic_read(&srp->s_hdr4.pack_id_of_mrq);
 		if (id == 0)	/* mrq_pack_ids cannot be zero */
 			continue;
@@ -4584,6 +4681,7 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 				__clear_bit(SG_FRQ_LT_RESERVED, o_srp->frq_lt_bm);
 				__set_bit(SG_FRQ_LT_RESERVED, t_srp->frq_lt_bm);
 				__assign_bit(SG_FRQ_LT_REUSE_BIO, t_srp->frq_lt_bm, is_reuse_bio);
+				o_srp->rsv_arr_idx = 0;
 				*rapp = t_srp;
 				xa_unlock_irqrestore(xafp, iflags);
 				sg_remove_srp(n_srp);
@@ -5871,7 +5969,8 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 		u64 n = eventfd_signal(sfp->efd_ctxp, 1);
 
 		if (n != 1)
-			pr_info("%s: srp=%pK eventfd_signal problem\n", __func__, srp);
+			pr_info("%s: srp->pack_id=%d eventfd_signal problem\n", __func__,
+				srp->pack_id);
 	}
 	kref_put(&sfp->f_ref, sg_remove_sfp);	/* get in: sg_execute_cmd() */
 }
@@ -6259,7 +6358,7 @@ sg_rq_map_kern(struct sg_request *srp, struct request_queue *q, struct request *
 static int
 sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 {
-	bool bump_bio_get = false;
+	bool first_reuse_bio = false;
 	bool no_dxfer, us_xfer;
 	int res = 0;
 	int dlen = cwrp->dlen;
@@ -6271,7 +6370,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	struct scsi_request *scsi_rp;
 	struct sg_fd *sfp = cwrp->sfp;
 	struct sg_device *sdp;
-	struct sg_scatter_hold *req_schp;
+	struct sg_scatter_hold *schp;
 	struct request_queue *q;
 	struct rq_map_data *md = (void *)srp; /* want any non-NULL value */
 	u8 *long_cmdp = NULL;
@@ -6349,7 +6448,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	__assign_bit(SG_FRQ_PC_US_XFER, srp->frq_pc_bm, !no_dxfer && us_xfer);
 	rqq->end_io_data = srp;
 	scsi_rp->retries = SG_DEFAULT_RETRIES;
-	req_schp = srp->sgatp;
+	schp = srp->sgatp;
 
 	if (no_dxfer) {
 		SG_LOG(4, sfp, "%s: no data xfer [0x%pK]\n", __func__, srp);
@@ -6361,22 +6460,33 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		md = NULL;
 		if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
 			cp = "direct_io, ";
-	} else if (test_bit(SG_FFD_CAN_REUSE_BIO, sfp->ffd_bm)) {
+	} else if (test_bit(SG_FFD_CAN_REUSE_BIO, sfp->ffd_bm) &&
+		   test_bit(SG_FRQ_PC_PART_MRQ, srp->frq_pc_bm)) {
 		if (test_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm)) {
-			if (srp->bio) {
+			if (srp->bio) {		/* 2,3,4 ... reuse bio handling */
+				bio_reset(srp->bio);
+				srp->bio->bi_iter.bi_size = srp->s_hdr4.bi_size;
+				srp->bio->bi_opf = srp->s_hdr4.bi_opf;
+				srp->bio->bi_vcnt = srp->s_hdr4.bi_vcnt;
+				srp->bio->bi_end_io = srp->s_hdr4.bi_end_io;
 				res = blk_rq_append_bio(rqq, &srp->bio);
+				rqq->nr_phys_segments = (1 << schp->page_order) * schp->num_sgat;
+				bio_get(rqq->bio);
+				/*
+				 * balancing bio_put() is either in:
+				 *     - normal case: in sg_mk_kern_bio(), or
+				 *     - error case: in sg_common_write() after err_out label
+				 */
 				if (res)
 					SG_LOG(1, sfp, "%s: blk_rq_append_bio err=%d\n", __func__,
 					       res);
-				md = NULL;
-				atomic_inc(&sg_tmp_count_reused_bios);
 			} else {
 				res = -EPROTO;
 			}
 			goto fini;
 		} else {	/* first use of bio, almost normal setup */
 			md = &map_data;
-			bump_bio_get = true;
+			first_reuse_bio = true;
 		}
 	} else {	/* normal indirect IO */
 		md = &map_data;
@@ -6389,16 +6499,16 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 			struct sg_request *r_srp = sfp->rsv_arr[0];
 
 			reserve0 = (r_srp == srp);
-			if (unlikely(!reserve0 || dlen > req_schp->buflen))
+			if (unlikely(!reserve0 || dlen > schp->buflen))
 				res = reserve0 ? -ENOMEM : -EBUSY;
-		} else if (req_schp->buflen == 0) {
+		} else if (schp->buflen == 0) {
 			res = sg_mk_sgat(srp, sfp, max_t(int, dlen, sfp->sgat_elem_sz));
 		}
 		if (unlikely(res))
 			goto fini;
-		md->pages = req_schp->pages;
-		md->page_order = req_schp->page_order;
-		md->nr_entries = req_schp->num_sgat;
+		md->pages = schp->pages;
+		md->page_order = schp->page_order;
+		md->nr_entries = schp->num_sgat;
 		md->offset = 0;
 		md->null_mapped = !up;
 		md->from_user = (dxfer_dir == SG_DXFER_TO_FROM_DEV);
@@ -6434,9 +6544,13 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		res = sg_rq_map_kern(srp, q, rqq, r0w);
 		if (res)
 			goto fini;
-		if (bump_bio_get) {	/* keep bio alive to re-use next time */
+		if (first_reuse_bio) {	/* keep bio alive to re-use, hold some bio fields */
+			srp->s_hdr4.bi_size = rqq->bio->bi_iter.bi_size;
+			srp->s_hdr4.bi_opf = rqq->bio->bi_opf;
+			srp->s_hdr4.bi_vcnt = rqq->bio->bi_vcnt;
+			srp->s_hdr4.bi_end_io = rqq->bio->bi_end_io;
 			set_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm);
-			bio_get(rqq->bio);	/* _put() in sg_svb_cleanup() */
+			bio_get(rqq->bio);	/* _put() in sg_svb_srp_cleanup() */
 		}
 	}
 fini:
@@ -6478,9 +6592,8 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 			clear_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
 		atomic_dec_return_release(&sfp->waiting);
 	}
-
 	/* Expect blk_put_request(rqq) already called in sg_rq_end_io() */
-	if (rqq) {	/* blk_get_request() may have failed */
+	if (unlikely(rqq)) {
 		WRITE_ONCE(srp->rqq, NULL);
 		if (scsi_req(rqq))
 			scsi_req_free_cmd(scsi_req(rqq));
@@ -6494,10 +6607,10 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 			ret = blk_rq_unmap_user(bio);
 			if (unlikely(ret))	/* -EINTR (-4) can be ignored */
 				SG_LOG(6, sfp, "%s: blk_rq_unmap_user() --> %d\n", __func__, ret);
+		}
+		if (!test_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm))
 			srp->bio = NULL;
-		} else if (!test_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm)) {
-			srp->bio = NULL;
-		} /* else may be able to re-use this bio [mrq, uniform svb] */
+		/* else may be able to re-use this bio [mrq, uniform svb] */
 	}
 	/* In worst case, READ data returned to user space by this point */
 }
@@ -6936,6 +7049,7 @@ sg_setup_req_new_srp(struct sg_comm_wr_t *cwrp, bool new_rsv_srp, bool no_reqs,
 	       r_srp);
 	if (new_rsv_srp) {
 		fp->rsv_arr[ra_idx] = r_srp;
+		r_srp->rsv_arr_idx = ra_idx;
 		set_bit(SG_FRQ_LT_RESERVED, r_srp->frq_lt_bm);
 		r_srp->sh_srp = NULL;
 	}
@@ -6970,7 +7084,6 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 	bool no_reqs = false;
 	bool ws_rq = false;
 	bool try_harder = false;
-	bool keep_frq_pc_bm = false;
 	bool second = false;
 	int res, ra_idx, l_used_idx;
 	int dlen = cwrp->dlen;
@@ -6993,7 +7106,6 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 				r_srp = NULL;
 			} else {
 				atomic_dec(&fp->inactives);
-				keep_frq_pc_bm = true;
 				r_srp->sh_srp = NULL;
 				goto final_setup;
 			}
@@ -7048,7 +7160,6 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 				if (likely(res == 0)) {
 					/* possible_srp bypasses loop to find candidate */
 					mk_new_srp = false;
-					keep_frq_pc_bm = true;
 					goto final_setup;
 				}
 			}
@@ -7178,11 +7289,10 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			goto start_again;
 	}
 final_setup:
-	if (!keep_frq_pc_bm)
-		r_srp->frq_pc_bm[0] = cwrp->frq_pc_bm[0];
+	r_srp->frq_pc_bm[0] = cwrp->frq_pc_bm[0];
 	r_srp->sgatp->dlen = dlen;	/* must be <= r_srp->sgat_h.buflen */
 	r_srp->sh_var = sh_var;
-	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
+	r_srp->cmd_opcode = cwrp->cmdp ? cwrp->cmdp[0] : 0xff;	/* get later if in user space */
 	/* If setup stalls (e.g. blk_get_request()) debug shows 'elap=1 ns' */
 	if (test_bit(SG_FFD_TIME_IN_NS, fp->ffd_bm))
 		r_srp->start_ns = S64_MAX;
@@ -7754,6 +7864,8 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, bool inactive,
 			       sg_shr_str(srp->sh_var, false));
 	if (srp->sgatp->num_sgat > 1)
 		n += scnprintf(obp + n, len - n, " sgat=%d", srp->sgatp->num_sgat);
+	if (test_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm))
+		n += scnprintf(obp + n, len - n, " re-use_bio");
 	cp = (srp->rq_flags & SGV4_FLAG_HIPRI) ? "hipri " : "";
 	n += scnprintf(obp + n, len - n, " %sop=0x%02x\n", cp, srp->cmd_opcode);
 	if (inactive && rq_st != SG_RQ_INACTIVE)
@@ -7800,6 +7912,8 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx, bool r
 		n += scnprintf(obp + n, len - n, " excl_waitq");
 	if (test_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm))
 		n += scnprintf(obp + n, len - n, " svb");
+	if (test_bit(SG_FFD_CAN_REUSE_BIO, fp->ffd_bm))
+		n += scnprintf(obp + n, len - n, " can_reuse_bio");
 	n += scnprintf(obp + n, len - n, " fd_bm=0x%lx\n", fp->ffd_bm[0]);
 	n += scnprintf(obp + n, len - n,
 		       "   mmap_sz=%d low_used_idx=%d low_await_idx=%d sum_fd_dlens=%u\n",
@@ -7899,9 +8013,8 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v, bool reduced)
 
 	b1[0] = '\0';
 	if (it && it->index == 0)
-		seq_printf(s, "max_active_device=%d  def_reserved_size=%d  num_reused_bios=%d\n",
-			   (int)it->max, def_reserved_size,
-			   atomic_read(&sg_tmp_count_reused_bios));
+		seq_printf(s, "max_active_device=%d  def_reserved_size=%d\n",
+			   (int)it->max, def_reserved_size);
 	fdi_p = it ? &it->fd_index : &k;
 	bp = kzalloc(bp_len, __GFP_NOWARN | GFP_KERNEL);
 	if (unlikely(!bp)) {
-- 
2.25.1

