Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE64C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9050E613FE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbhD0WAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:51 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38953 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239463AbhD0WAf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B256B204278;
        Tue, 27 Apr 2021 23:59:47 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id c3VqD-MuRw3L; Tue, 27 Apr 2021 23:59:44 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 811CF204279;
        Tue, 27 Apr 2021 23:59:40 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 81/83] sg: blk_poll/hipri work for mrq
Date:   Tue, 27 Apr 2021 17:57:31 -0400
Message-Id: <20210427215733.417746-83-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are several variants here to cope with. The SGV4_FLAG_HIPRI
flag may be set on the control object and/or set on any number of
requests in the req_arr. To simplify things, if that flag is
set on the control object, then its is set internally on each
request in req_arr. That leaves the case were this flag is cleared
on the control object, but set on some or all of the requests in
req_arr. That will work but it may not be the best approach, see
the next paragraph.

For the shared variable blocking mrq method, if the SGV4_FLAG_HIPRI
flag is set on the control object, then an interleaved blk_poll()
algorithm is performed on inflight requests. This should give
better results than doing blk_poll() on each request until it is
completed before moving onto the next inflight request.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 449 ++++++++++++++++++++++++++--------------------
 1 file changed, 253 insertions(+), 196 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 26047a8ff1e2..773843a14038 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -332,7 +332,6 @@ struct sg_device { /* holds the state of each scsi generic device */
 };
 
 struct sg_comm_wr_t {  /* arguments to sg_common_write() */
-	bool keep_share;
 	int timeout;
 	int cmd_len;
 	int rsv_idx;		/* wanted rsv_arr index, def: -1 (anyone) */
@@ -353,10 +352,10 @@ struct sg_mrq_hold {	/* for passing context between multiple requests (mrq) func
 	unsigned from_sg_io:1;
 	unsigned chk_abort:1;
 	unsigned immed:1;
-	unsigned hipri:1;
 	unsigned stop_if:1;
 	unsigned co_mmap:1;
 	unsigned ordered_wr:1;
+	unsigned hipri:1;
 	int id_of_mrq;
 	int s_res;		/* secondary error: some-good-then-error; in co.spare_out */
 	int dtd_errs;		/* incremented for each driver/transport/device error */
@@ -394,7 +393,7 @@ static void sg_remove_srp(struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp, struct file *filp);
 static void sg_remove_sfp(struct kref *);
 static void sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side);
-static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag);
+static struct sg_request *sg_get_srp_by_id(struct sg_fd *sfp, int id, bool is_tag, bool part_mrq);
 static struct sg_request *sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int min_dev);
@@ -1163,11 +1162,11 @@ sg_num_waiting_maybe_acquire(struct sg_fd *sfp)
 }
 
 /*
- * Returns true if a request is ready and its srp is written to *srpp . If nothing can be found
- * returns false and NULL --> *srpp . If device is detaching, returns true and NULL --> *srpp .
+ * Looks for request in SG_RQ_AWAIT_RCV state on given fd that matches part_mrq. The first one
+ * found is placed in SG_RQ_BUSY state and its address is returned. If none found returns NULL.
  */
-static bool
-sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
+static struct sg_request *
+sg_get_any_srp(struct sg_fd *sfp, bool part_mrq)
 {
 	bool second = false;
 	int l_await_idx = READ_ONCE(sfp->low_await_idx);
@@ -1175,25 +1174,18 @@ sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
 	struct sg_request *srp;
 	struct xarray *xafp = &sfp->srp_arr;
 
-	if (SG_IS_DETACHING(sfp->parentdp)) {
-		*srpp = ERR_PTR(-ENODEV);
-		return true;
-	}
-	if (sg_num_waiting_maybe_acquire(sfp) < 1)
-		goto fini;
-
 	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
 	idx = s_idx;
 	end_idx = ULONG_MAX;
-
 second_time:
 	for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
 	     srp;
 	     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
+		if (part_mrq != test_bit(SG_FRQ_PC_PART_MRQ, srp->frq_pc_bm))
+			continue;
 		if (likely(sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY) == 0)) {
-			*srpp = srp;
 			WRITE_ONCE(sfp->low_await_idx, idx + 1);
-			return true;
+			return srp;
 		}
 	}
 	/* If not found so far, need to wrap around and search [0 ... s_idx) */
@@ -1204,9 +1196,33 @@ sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
 		second = true;
 		goto second_time;
 	}
-fini:
-	*srpp = NULL;
-	return false;
+	return NULL;
+}
+
+/*
+ * Returns true if a request is ready and its srp is written to *srpp . If nothing can be found
+ * returns false and NULL --> *srpp . If an error is detected returns true with IS_ERR(*srpp)
+ * also being true.
+ */
+static bool
+sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
+{
+	if (SG_IS_DETACHING(sfp->parentdp)) {
+		*srpp = ERR_PTR(-ENODEV);
+		return true;
+	}
+	if (sg_num_waiting_maybe_acquire(sfp) < 1) {
+		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm)) {
+			int res = sg_sfp_blk_poll(sfp, 1);
+
+			if (res < 0) {
+				*srpp = ERR_PTR(res);
+				return true;
+			}
+		}
+	}
+	*srpp = sg_get_any_srp(sfp, true);
+	return !!*srpp;
 }
 
 /* N.B. After this function is completed what srp points to should be considered invalid. */
@@ -1256,84 +1272,67 @@ sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_request *srp)
 }
 
 static int
-sg_wait_any_mrq(struct sg_fd *sfp, struct sg_request **srpp)
+sg_wait_any_mrq(struct sg_fd *sfp, struct sg_mrq_hold *mhp, struct sg_request **srpp)
 {
+	bool hipri = mhp->hipri || test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
+
+	if (hipri) {
+		long state = current->state;
+		struct sg_request *srp;
+
+		do {
+			if (hipri) {
+				int res = sg_sfp_blk_poll(sfp, SG_DEF_BLK_POLL_LOOP_COUNT);
+
+				if (res < 0)
+					return res;
+			}
+			srp = sg_get_any_srp(sfp, true);
+			if (IS_ERR(srp))
+				return PTR_ERR(srp);
+			if (srp) {
+				__set_current_state(TASK_RUNNING);
+				break;
+			}
+			if (SG_IS_DETACHING(sfp->parentdp)) {
+				__set_current_state(TASK_RUNNING);
+				return -ENODEV;
+			}
+			if (signal_pending_state(state, current)) {
+				__set_current_state(TASK_RUNNING);
+				return -ERESTARTSYS;
+			}
+			cpu_relax();
+		} while (true);
+		*srpp = srp;
+		return 0;
+	}
 	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm))
 		return __wait_event_interruptible_exclusive(sfp->cmpl_wait,
 							    sg_mrq_get_ready_srp(sfp, srpp));
 	return __wait_event_interruptible(sfp->cmpl_wait, sg_mrq_get_ready_srp(sfp, srpp));
 }
 
-static bool
-sg_srp_hybrid_sleep(struct sg_request *srp)
-{
-	struct hrtimer_sleeper hs;
-	enum hrtimer_mode mode;
-	ktime_t kt = ns_to_ktime(5000);
-
-	if (test_and_set_bit(SG_FRQ_POLL_SLEPT, srp->frq_pc_bm))
-		return false;
-	if (kt == 0)
-		return false;
-
-	mode = HRTIMER_MODE_REL;
-	hrtimer_init_sleeper_on_stack(&hs, CLOCK_MONOTONIC, mode);
-	hrtimer_set_expires(&hs.timer, kt);
-
-	do {
-		if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT)
-			break;
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		hrtimer_sleeper_start_expires(&hs, mode);
-		if (hs.task)
-			io_schedule();
-		hrtimer_cancel(&hs.timer);
-		mode = HRTIMER_MODE_ABS;
-	} while (hs.task && !signal_pending(current));
-
-	__set_current_state(TASK_RUNNING);
-	destroy_hrtimer_on_stack(&hs.timer);
-	return true;
-}
-
 static inline bool
 sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
 {
 	return atomic_read_acquire(&srp->rq_st) != SG_RQ_INFLIGHT || SG_IS_DETACHING(sdp);
 }
 
-/* This is a blocking wait (or poll) for a given srp. */
+/*
+ * This is a blocking wait (or poll) for a given srp to reach completion. If
+ * SGV4_FLAG_HIPRI is set this functions goes into a polling loop.
+ */
 static int
-sg_wait_poll_for_given_srp(struct sg_fd *sfp, struct sg_request *srp, bool do_poll)
+sg_poll_wait4_given_srp(struct sg_fd *sfp, struct sg_request *srp)
 {
 	int res;
 	struct sg_device *sdp = sfp->parentdp;
 
-	SG_LOG(3, sfp, "%s: do_poll=%d\n", __func__, (int)do_poll);
-	if (do_poll || (srp->rq_flags & SGV4_FLAG_HIPRI))
-		goto poll_loop;
-
-	if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT)
-		goto skip_wait;		/* and skip _acquire() */
-	/* N.B. The SG_FFD_EXCL_WAITQ flag is ignored here. */
-	res = __wait_event_interruptible(sfp->cmpl_wait, sg_rq_landed(sdp, srp));
-	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
-		set_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm);
-		/* orphans harvested when sfp->keep_orphan is false */
-		sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
-		SG_LOG(1, sfp, "%s:  wait_event_interruptible(): %s[%d]\n", __func__,
-		       (res == -ERESTARTSYS ? "ERESTARTSYS" : ""), res);
-		return res;
-	}
-skip_wait:
-	if (SG_IS_DETACHING(sdp))
-		goto detaching;
-	return sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
-
-poll_loop:
 	if (srp->rq_flags & SGV4_FLAG_HIPRI) {
 		long state = current->state;
 
+		SG_LOG(3, sfp, "%s: polling\n", __func__);
 		do {
 			res = sg_srp_q_blk_poll(srp, sdp->device->request_queue,
 						SG_DEF_BLK_POLL_LOOP_COUNT);
@@ -1356,18 +1355,17 @@ sg_wait_poll_for_given_srp(struct sg_fd *sfp, struct sg_request *srp, bool do_po
 			cpu_relax();
 		} while (true);
 	} else {
-		enum sg_rq_state sr_st;
-
-		if (!sg_srp_hybrid_sleep(srp))
-			return -EINVAL;
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-		if (SG_IS_DETACHING(sdp))
-			goto detaching;
-		sr_st = atomic_read(&srp->rq_st);
-		if (unlikely(sr_st != SG_RQ_AWAIT_RCV))
-			return -EPROTO;         /* Logic error */
-		return sg_rq_chg_state(srp, sr_st, SG_RQ_BUSY);
+		SG_LOG(3, sfp, "%s: wait_event\n", __func__);
+		/* N.B. The SG_FFD_EXCL_WAITQ flag is ignored here. */
+		res = __wait_event_interruptible(sfp->cmpl_wait, sg_rq_landed(sdp, srp));
+		if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
+			set_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm);
+			/* orphans harvested when sfp->keep_orphan is false */
+			sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
+			SG_LOG(1, sfp, "%s:  wait_event_interruptible(): %s[%d]\n", __func__,
+			       (res == -ERESTARTSYS ? "ERESTARTSYS" : ""), res);
+			return res;
+		}
 	}
 	if (atomic_read_acquire(&srp->rq_st) != SG_RQ_AWAIT_RCV)
 		return (test_bit(SG_FRQ_PC_COUNT_ACTIVE, srp->frq_pc_bm) &&
@@ -1444,7 +1442,7 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sf
 		if (res)
 			break;
 		if (mreqs > 0) {
-			res = sg_wait_any_mrq(sfp, &srp);
+			res = sg_wait_any_mrq(sfp, mhp, &srp);
 			if (unlikely(res))
 				return res;	/* signal --> -ERESTARTSYS */
 			if (IS_ERR(srp)) {
@@ -1457,7 +1455,7 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sf
 			}
 		}
 		if (sec_reqs > 0) {
-			res = sg_wait_any_mrq(sec_sfp, &srp);
+			res = sg_wait_any_mrq(sec_sfp, mhp, &srp);
 			if (unlikely(res))
 				return res;	/* signal --> -ERESTARTSYS */
 			if (IS_ERR(srp)) {
@@ -1551,13 +1549,16 @@ sg_mrq_prepare(struct sg_mrq_hold *mhp, bool is_svb)
 			SG_LOG(1, sfp, "%s: %s %u, MMAP in co AND here\n", __func__, rip, k);
 			return -ERANGE;
 		}
-		if (unlikely(!have_file_share && share)) {
-			SG_LOG(1, sfp, "%s: %s %u, no file share\n", __func__, rip, k);
-			return -ENOMSG;
-		}
-		if (unlikely(!have_file_share && !!(flags & SGV4_FLAG_DO_ON_OTHER))) {
-			SG_LOG(1, sfp, "%s: %s %u, no other fd to do on\n", __func__, rip, k);
-			return -ENOMSG;
+		if (!have_file_share) {
+			if (unlikely(share || (flags & SGV4_FLAG_DO_ON_OTHER))) {
+				if (share)
+					SG_LOG(1, sfp, "%s: %s %u, no file share\n", __func__,
+					       rip, k);
+				else
+					SG_LOG(1, sfp, "%s: %s %u, no other fd to do on\n",
+					       __func__, rip, k);
+				return -ENOMSG;
+			}
 		}
 		if (cdb_ap && unlikely(hp->request_len > cdb_mxlen)) {
 			SG_LOG(1, sfp, "%s: %s %u, cdb too long\n", __func__, rip, k);
@@ -1567,10 +1568,16 @@ sg_mrq_prepare(struct sg_mrq_hold *mhp, bool is_svb)
 			hp->response = cop->response;
 			hp->max_response_len = cop->max_response_len;
 		}
+		if (mhp->hipri) {
+			if (!(hp->flags & SGV4_FLAG_HIPRI))
+				hp->flags |= SGV4_FLAG_HIPRI;
+		}	/* HIPRI may be set on hp->flags and _not_ on the control object */
 		if (!is_svb) {
-			if (cop->flags & SGV4_FLAG_REC_ORDER)
-				hp->flags |= SGV4_FLAG_REC_ORDER;
-			continue;
+			if (cop->flags & SGV4_FLAG_REC_ORDER) {
+				if (!(hp->flags & SGV4_FLAG_REC_ORDER))
+					hp->flags |= SGV4_FLAG_REC_ORDER;
+			}
+			continue;	/* <<< non-svb skip rest of loop */
 		}
 		/* mrq share variable blocking (svb) additional constraints checked here */
 		if (unlikely(flags & (SGV4_FLAG_COMPLETE_B4 | SGV4_FLAG_KEEP_SHARE))) {
@@ -1713,7 +1720,7 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *m
 				++other_fp_sent;
 			continue;  /* defer completion until all submitted */
 		}
-		res = sg_wait_poll_for_given_srp(rq_sfp, srp, mhp->hipri);
+		res = sg_poll_wait4_given_srp(rq_sfp, srp);
 		if (unlikely(res)) {
 			mhp->s_res = res;
 			if (res == -ERESTARTSYS || res == -ENODEV)
@@ -1915,7 +1922,7 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 			goto oth_first;
 this_second:
 		if (this_fp_sent > 0) {
-			res = sg_wait_any_mrq(fp, &srp);
+			res = sg_wait_any_mrq(fp, mhp, &srp);
 			if (unlikely(res))
 				mhp->s_res = res;
 			else if (IS_ERR(srp))
@@ -1927,7 +1934,7 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 			continue;
 oth_first:
 		if (other_fp_sent > 0) {
-			res = sg_wait_any_mrq(o_sfp, &srp);
+			res = sg_wait_any_mrq(o_sfp, mhp, &srp);
 			if (unlikely(res))
 				mhp->s_res = res;
 			else if (IS_ERR(srp))
@@ -2006,7 +2013,7 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 		rs_srp = svb_arr[m].rs_srp;
 		if (!rs_srp)
 			continue;
-		res = sg_wait_poll_for_given_srp(fp, rs_srp, mhp->hipri);
+		res = sg_poll_wait4_given_srp(fp, rs_srp);
 		if (unlikely(res))
 			mhp->s_res = res;
 		--this_fp_sent;
@@ -2050,7 +2057,7 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 	}
 	while (this_fp_sent > 0) {	/* non-data requests */
 		--this_fp_sent;
-		res = sg_wait_any_mrq(fp, &srp);
+		res = sg_wait_any_mrq(fp, mhp, &srp);
 		if (unlikely(res)) {
 			mhp->s_res = res;
 			continue;
@@ -2066,7 +2073,7 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 	}
 	while (other_fp_sent > 0) {
 		--other_fp_sent;
-		res = sg_wait_any_mrq(o_sfp, &srp);
+		res = sg_wait_any_mrq(o_sfp, mhp, &srp);
 		if (unlikely(res)) {
 			mhp->s_res = res;
 			continue;
@@ -2199,7 +2206,6 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 {
 	bool f_non_block, is_svb;
 	int res = 0;
-	int existing_id;
 	u32 cdb_mxlen;
 	struct sg_io_v4 *cop = cwrp->h4p;	/* controlling object */
 	u32 dout_len = cop->dout_xfer_len;
@@ -2210,13 +2216,33 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	struct sg_io_v4 *a_hds;			/* array of request objects */
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_fd *o_sfp = sg_fd_share_ptr(fp);
-	struct sg_device *sdp = fp->parentdp;
 	struct sg_mrq_hold mh;
 	struct sg_mrq_hold *mhp = &mh;
 #if IS_ENABLED(SG_LOG_ACTIVE)
 	const char *mrq_vs;
 #endif
 
+	if (unlikely(SG_IS_DETACHING(fp->parentdp) || (o_sfp && SG_IS_DETACHING(o_sfp->parentdp))))
+		return -ENODEV;
+	if (unlikely(tot_reqs == 0))
+		return 0;
+	if (unlikely(tot_reqs > U16_MAX))
+		return -E2BIG;
+	if (unlikely(!!cdb_alen != !!cop->request))
+		return -ERANGE;	/* both must be zero or both non-zero */
+	if (cdb_alen) {
+		if (unlikely(cdb_alen > SG_MAX_MULTI_REQ_SZ))
+			return  -E2BIG;
+		if (unlikely(cdb_alen % tot_reqs))
+			return -ERANGE;
+		cdb_mxlen = cdb_alen / tot_reqs;
+		if (unlikely(cdb_mxlen < 6))
+			return -ERANGE;	/* too short for SCSI cdbs */
+	} else {
+		cdb_mxlen = 0;
+	}
+	if (unlikely(din_len > SG_MAX_MULTI_REQ_SZ || dout_len > SG_MAX_MULTI_REQ_SZ))
+		return  -E2BIG;
 	mhp->cwrp = cwrp;
 	mhp->from_sg_io = from_sg_io; /* false if from SG_IOSUBMIT */
 #if IS_ENABLED(SG_LOG_ACTIVE)
@@ -2227,7 +2253,10 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	mhp->immed = !!(cop->flags & SGV4_FLAG_IMMED);
 	mhp->hipri = !!(cop->flags & SGV4_FLAG_HIPRI);
 	mhp->stop_if = !!(cop->flags & SGV4_FLAG_STOP_IF);
+	if (unlikely(mhp->immed && mhp->stop_if))
+		return -ERANGE;
 	mhp->ordered_wr = !!(cop->flags & SGV4_FLAG_ORDERED_WR);
+	mhp->hipri = !!(cop->flags & SGV4_FLAG_HIPRI);
 	mhp->co_mmap = !!(cop->flags & SGV4_FLAG_MMAP_IO);
 	if (mhp->co_mmap)
 		mhp->co_mmap_sgatp = fp->rsv_arr[0]->sgatp;
@@ -2236,7 +2265,8 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	mhp->s_res = 0;
 	mhp->dtd_errs = 0;
 	if (mhp->id_of_mrq) {
-		existing_id = atomic_cmpxchg(&fp->mrq_id_abort, 0, mhp->id_of_mrq);
+		int existing_id = atomic_cmpxchg(&fp->mrq_id_abort, 0, mhp->id_of_mrq);
+
 		if (existing_id && existing_id != mhp->id_of_mrq) {
 			SG_LOG(1, fp, "%s: existing id=%d id_of_mrq=%d\n", __func__, existing_id,
 			       mhp->id_of_mrq);
@@ -2284,42 +2314,13 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 		else
 			return -EPROTO;
 	}
-	if (din_len > 0) {
-		if (unlikely(din_len > SG_MAX_MULTI_REQ_SZ))
-			return  -E2BIG;
-	} else if (dout_len > 0) {
-		if (unlikely(dout_len > SG_MAX_MULTI_REQ_SZ))
-			return  -E2BIG;
-	}
-	if (unlikely(tot_reqs > U16_MAX)) {
-		return -ERANGE;
-	} else if (unlikely(mhp->immed && mhp->stop_if)) {
-		return -ERANGE;
-	} else if (unlikely(tot_reqs == 0)) {
-		return 0;
-	} else if (unlikely(!!cdb_alen != !!cop->request)) {
-		return -ERANGE;	/* both must be zero or both non-zero */
-	} else if (cdb_alen) {
-		if (unlikely(cdb_alen > SG_MAX_MULTI_REQ_SZ))
-			return  -E2BIG;
-		if (unlikely(cdb_alen % tot_reqs))
-			return -ERANGE;
-		cdb_mxlen = cdb_alen / tot_reqs;
-		if (unlikely(cdb_mxlen < 6))
-			return -ERANGE;	/* too short for SCSI cdbs */
-	} else {
-		cdb_mxlen = 0;
-	}
-
-	if (SG_IS_DETACHING(sdp) || (o_sfp && SG_IS_DETACHING(o_sfp->parentdp)))
-		return -ENODEV;
 	if (is_svb) {
 		if (unlikely(test_and_set_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm))) {
 			SG_LOG(1, fp, "%s: %s already active\n", __func__, mrq_vs);
 			return -EBUSY;
 		}
 	} else if (unlikely(test_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm))) {
-		SG_LOG(1, fp, "%s: %s disallowed with existing svb\n", __func__, mrq_vs);
+		SG_LOG(1, fp, "%s: svb active on this fd so %s disallowed\n", __func__, mrq_vs);
 		return -EBUSY;
 	}
 	a_hds = kcalloc(tot_reqs, SZ_SG_IO_V4, GFP_KERNEL | __GFP_NOWARN);
@@ -2887,7 +2888,6 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		res = sg_share_chk_flags(fp, rq_flags, dlen, dir, &sh_var);
 		if (unlikely(res < 0))
 			return ERR_PTR(res);
-		cwrp->keep_share = !!(rq_flags & SGV4_FLAG_KEEP_SHARE);
 	} else {
 		sh_var = SG_SHR_NONE;
 		if (unlikely(rq_flags & SGV4_FLAG_SHARE))
@@ -2962,8 +2962,21 @@ sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int id, bool is_ta
 		*srpp = ERR_PTR(-ENODEV);
 		return true;
 	}
-	srp = sg_find_srp_by_id(sfp, id, is_tag);
-	*srpp = srp;
+	srp = sg_get_srp_by_id(sfp, id, is_tag, false);
+	*srpp = srp;	/* Warning: IS_ERR(srp) may be true */
+	return !!srp;
+}
+
+static inline bool
+sg_get_any_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
+{
+	struct sg_request *srp;
+
+	if (SG_IS_DETACHING(sfp->parentdp))
+		srp = ERR_PTR(-ENODEV);
+	else
+		srp = sg_get_any_srp(sfp, false);
+	*srpp = srp;	/* Warning: IS_ERR(srp) may be true */
 	return !!srp;
 }
 
@@ -3191,17 +3204,19 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p, struct
  * of elements written to rsp_arr, which may be 0 if mrqs submitted but none waiting
  */
 static int
-sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_rcv, int num_rsp_arr,
-		      struct sg_io_v4 *rsp_arr)
+sg_mrq_iorec_complets(struct sg_fd *sfp, struct sg_mrq_hold *mhp, bool non_block, int max_rcv)
 {
 	int k, idx;
 	int res = 0;
 	struct sg_request *srp;
+	struct sg_io_v4 *rsp_arr = mhp->a_hds;
 
-	SG_LOG(3, sfp, "%s: num_rsp_arr=%d, max_rcv=%d", __func__, num_rsp_arr, max_rcv);
-	if (max_rcv == 0 || max_rcv > num_rsp_arr)
-		max_rcv = num_rsp_arr;
+	SG_LOG(3, sfp, "%s: num_responses=%d, max_rcv=%d, hipri=%u\n", __func__,
+	       mhp->tot_reqs, max_rcv, mhp->hipri);
+	if (max_rcv == 0 || max_rcv > mhp->tot_reqs)
+		max_rcv = mhp->tot_reqs;
 	k = 0;
+recheck:
 	for ( ; k < max_rcv; ++k) {
 		if (!sg_mrq_get_ready_srp(sfp, &srp))
 			break;
@@ -3209,7 +3224,7 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_rcv, int num_rs
 			return k ? k /* some but not all */ : PTR_ERR(srp);
 		if (srp->rq_flags & SGV4_FLAG_REC_ORDER) {
 			idx = srp->s_hdr4.mrq_ind;
-			if (idx >= num_rsp_arr)
+			if (idx >= mhp->tot_reqs)
 				idx = 0;	/* overwrite index 0 when trouble */
 		} else {
 			idx = k;	/* completion order */
@@ -3221,16 +3236,24 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_rcv, int num_rs
 	}
 	if (non_block || k >= max_rcv)
 		return k;
+	if (mhp->hipri) {
+		if (SG_IS_DETACHING(sfp->parentdp))
+			return -ENODEV;
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+		cpu_relax();
+		goto recheck;
+	}
 	SG_LOG(6, sfp, "%s: received=%d, max=%d\n", __func__, k, max_rcv);
 	for ( ; k < max_rcv; ++k) {
-		res = sg_wait_any_mrq(sfp, &srp);
+		res = sg_wait_any_mrq(sfp, mhp, &srp);
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
 			return k ? k : PTR_ERR(srp);
 		if (srp->rq_flags & SGV4_FLAG_REC_ORDER) {
 			idx = srp->s_hdr4.mrq_ind;
-			if (idx >= num_rsp_arr)
+			if (idx >= mhp->tot_reqs)
 				idx = 0;
 		} else {
 			idx = k;
@@ -3256,6 +3279,8 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool n
 	u32 len, n;
 	struct sg_io_v4 *rsp_v4_arr;
 	void __user *pp;
+	struct sg_mrq_hold mh;
+	struct sg_mrq_hold *mhp = &mh;
 
 	SG_LOG(3, sfp, "%s: non_block=%d\n", __func__, !!non_block);
 	n = cop->din_xfer_len;
@@ -3263,9 +3288,12 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool n
 		return -E2BIG;
 	if (unlikely(!cop->din_xferp || n < SZ_SG_IO_V4 || (n % SZ_SG_IO_V4)))
 		return -ERANGE;
+	memset(mhp, 0, sizeof(*mhp));
 	n /= SZ_SG_IO_V4;
+	mhp->tot_reqs = n;
 	len = n * SZ_SG_IO_V4;
 	max_rcv = cop->din_iovec_count;
+	mhp->hipri = !!(cop->flags & SGV4_FLAG_HIPRI);
 	SG_LOG(3, sfp, "%s: %s, num_reqs=%u, max_rcv=%d\n", __func__,
 	       (non_block ? "IMMED" : "blocking"), n, max_rcv);
 	rsp_v4_arr = kcalloc(n, SZ_SG_IO_V4, GFP_KERNEL);
@@ -3274,7 +3302,8 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool n
 
 	sg_v4h_partial_zero(cop);
 	cop->din_resid = n;
-	res = sg_mrq_iorec_complets(sfp, non_block, max_rcv, n, rsp_v4_arr);
+	mhp->a_hds = rsp_v4_arr;
+	res = sg_mrq_iorec_complets(sfp, mhp, non_block, max_rcv);
 	if (unlikely(res < 0))
 		goto fini;
 	cop->din_resid -= res;
@@ -3294,41 +3323,70 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool n
 	return res;
 }
 
-/* Either wait for command completion matching id ('-1': any); or poll for it if do_poll==true */
+static struct sg_request *
+sg_poll_wait4_srp(struct sg_fd *sfp, int id, bool is_tag, bool part_mrq)
+{
+	long state = current->state;
+	struct sg_request *srp;
+
+	do {
+		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm)) {
+			int res = sg_sfp_blk_poll(sfp, SG_DEF_BLK_POLL_LOOP_COUNT);
+
+			if (res < 0)
+				return ERR_PTR(res);
+		}
+		if (id == -1)
+			srp = sg_get_any_srp(sfp, part_mrq);
+		else
+			srp = sg_get_srp_by_id(sfp, id, is_tag, part_mrq);
+		if (IS_ERR(srp))
+			return srp;
+		if (srp) {
+			__set_current_state(TASK_RUNNING);
+			return srp;
+		}
+		if (SG_IS_DETACHING(sfp->parentdp)) {
+			__set_current_state(TASK_RUNNING);
+			return ERR_PTR(-ENODEV);
+		}
+		if (signal_pending_state(state, current)) {
+			__set_current_state(TASK_RUNNING);
+			return ERR_PTR(-ERESTARTSYS);
+		}
+		cpu_relax();
+	} while (true);
+}
+
+/*
+ * Called from read(), ioctl(SG_IORECEIVE) or ioctl(SG_IORECEIVE_V3). Either wait event for
+ * command completion matching id ('-1': any); or poll for it if do_poll==true
+ */
 static int
 sg_wait_poll_by_id(struct sg_fd *sfp, struct sg_request **srpp, int id,
 		   bool is_tag, int do_poll)
 {
-	if (do_poll)
-		goto poll_loop;
+	if (do_poll) {
+		struct sg_request *srp = sg_poll_wait4_srp(sfp, id, is_tag, false);
 
-	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm))
-		return __wait_event_interruptible_exclusive
+		if (IS_ERR(srp))
+			return PTR_ERR(srp);
+		*srpp = srp;
+		return 0;
+	}
+	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm)) {
+		if (id == -1)
+			return __wait_event_interruptible_exclusive
+					(sfp->cmpl_wait, sg_get_any_ready_srp(sfp, srpp));
+		else
+			return __wait_event_interruptible_exclusive
 					(sfp->cmpl_wait, sg_get_ready_srp(sfp, srpp, id, is_tag));
-	return __wait_event_interruptible(sfp->cmpl_wait, sg_get_ready_srp(sfp, srpp, id, is_tag));
-poll_loop:
-	{
-		long state = current->state;
-		struct sg_request *srp;
-
-		do {
-			srp = sg_find_srp_by_id(sfp, id, is_tag);
-			if (srp) {
-				__set_current_state(TASK_RUNNING);
-				*srpp = srp;
-				return 0;
-			}
-			if (SG_IS_DETACHING(sfp->parentdp)) {
-				__set_current_state(TASK_RUNNING);
-				return -ENODEV;
-			}
-			if (signal_pending_state(state, current)) {
-				__set_current_state(TASK_RUNNING);
-				return -ERESTARTSYS;
-			}
-			cpu_relax();
-		} while (true);
 	}
+	if (id == -1)
+		return __wait_event_interruptible(sfp->cmpl_wait, sg_get_any_ready_srp(sfp, srpp));
+	else
+		return __wait_event_interruptible(sfp->cmpl_wait, sg_get_ready_srp(sfp, srpp, id,
+						  is_tag));
 }
 
 /*
@@ -3376,7 +3434,7 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 	id = use_tag ? tag : pack_id;
 try_again:
 	if (non_block) {
-		srp = sg_find_srp_by_id(sfp, id, use_tag);
+		srp = sg_get_srp_by_id(sfp, id, use_tag, false /* part_mrq */);
 		if (!srp)
 			return SG_IS_DETACHING(sdp) ? -ENODEV : -EAGAIN;
 	} else {
@@ -3430,7 +3488,7 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 		pack_id = h3p->pack_id;
 try_again:
 	if (non_block) {
-		srp = sg_find_srp_by_id(sfp, pack_id, false);
+		srp = sg_get_srp_by_id(sfp, pack_id, false, false);
 		if (!srp)
 			return SG_IS_DETACHING(sdp) ? -ENODEV : -EAGAIN;
 	} else {
@@ -3604,11 +3662,11 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 	}
 try_again:
 	if (non_block) {
-		srp = sg_find_srp_by_id(sfp, want_id, false);
+		srp = sg_get_srp_by_id(sfp, want_id, false, false /* part_mrq */);
 		if (!srp)
 			return SG_IS_DETACHING(sdp) ? -ENODEV : -EAGAIN;
 	} else {
-		ret = sg_wait_poll_by_id(sfp, &srp, want_id, false, false);
+		ret = sg_wait_poll_by_id(sfp, &srp, want_id, false, false /* do_poll */);
 		if (unlikely(ret))
 			return ret;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
@@ -3715,8 +3773,7 @@ sg_calc_sgat_param(struct sg_device *sdp)
 
 /*
  * Only valid for shared file descriptors. Designed to be called after a read-side request has
- * successfully completed leaving valid data in a reserve request buffer. May also be called after
- * a write-side request that has the SGV4_FLAG_KEEP_SHARE flag set. If rs_srp is NULL, acts
+ * successfully completed leaving valid data in a reserve request buffer. If rs_srp is NULL, acts
  * on first reserve request in SG_RQ_SHR_SWAP state, making it inactive and returning 0. If rs_srp
  * is non-NULL and is a reserve request and is in SG_RQ_SHR_SWAP state, makes it busy then
  * inactive and returns 0. Otherwise -EINVAL is returned, unless write-side is in progress in
@@ -4110,7 +4167,7 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp, struct sg_req
 static int
 sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 {
-	bool is_v4, hipri;
+	bool is_v4;
 	int res;
 	struct sg_request *srp = NULL;
 	u8 hu8arr[SZ_SG_IO_V4];
@@ -4139,11 +4196,9 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 				   SZ_SG_IO_V4 - v3_len))
 			return -EFAULT;
 		is_v4 = true;
-		hipri = !!(h4p->flags & SGV4_FLAG_HIPRI);
 		res = sg_submit_v4(sfp, p, h4p, true, &srp);
 	} else if (h3p->interface_id == 'S') {
 		is_v4 = false;
-		hipri = !!(h3p->flags & SGV4_FLAG_HIPRI);
 		res = sg_submit_v3(sfp, h3p, true, &srp);
 	} else {
 		pr_info_once("sg: %s: v3 or v4 interface only here\n", __func__);
@@ -4153,7 +4208,7 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		return res;
 	if (!srp)	/* mrq case: already processed all responses */
 		return res;
-	res = sg_wait_poll_for_given_srp(sfp, srp, hipri);
+	res = sg_poll_wait4_given_srp(sfp, srp);
 #if IS_ENABLED(SG_LOG_ACTIVE)
 	if (unlikely(res))
 		SG_LOG(1, sfp, "%s: unexpected srp=0x%pK  state: %s, share: %s\n", __func__,
@@ -6779,7 +6834,7 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
  * from SG_RQ_AWAIT_RCV to SG_RQ_BUSY.
  */
 static struct sg_request *
-sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
+sg_get_srp_by_id(struct sg_fd *sfp, int id, bool is_tag, bool part_mrq)
 {
 	__maybe_unused bool is_bad_st = false;
 	bool search_for_1 = (id != SG_TAG_WILDCARD);
@@ -6802,11 +6857,13 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
 	idx = s_idx;
 	if (unlikely(search_for_1)) {
-second_time:
+second_time_for_1:
 		for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
 		     srp;
 		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
-			if (test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm))
+			if (part_mrq != test_bit(SG_FRQ_PC_PART_MRQ, srp->frq_pc_bm))
+				continue;
+			if (!part_mrq && test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm))
 				continue;
 			if (unlikely(is_tag)) {
 				if (srp->tag != id)
@@ -6825,7 +6882,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 			s_idx = 0;
 			idx = s_idx;
 			second = true;
-			goto second_time;
+			goto second_time_for_1;
 		}
 	} else {
 		/*
@@ -6835,7 +6892,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 		 * is ready. If there is no queuing and the "last used" has been re-used then the
 		 * first (relative) position will be the request we want.
 		 */
-second_time2:
+second_time_for_any:
 		for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
 		     srp;
 		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
@@ -6855,7 +6912,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 			s_idx = 0;
 			idx = s_idx;
 			second = true;
-			goto second_time2;
+			goto second_time_for_any;
 		}
 	}
 	return NULL;
-- 
2.25.1

