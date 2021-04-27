Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B07FC43470
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 598BC613F1
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239200AbhD0WAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:43 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39137 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239414AbhD0WAX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C2C82204296;
        Tue, 27 Apr 2021 23:59:36 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3bTwngQBzwJp; Tue, 27 Apr 2021 23:59:30 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 40B272041BD;
        Tue, 27 Apr 2021 23:59:29 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 74/83] sg: add ordered write flag
Date:   Tue, 27 Apr 2021 17:57:24 -0400
Message-Id: <20210427215733.417746-76-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new flag: SGV4_FLAG_ORDERED_WR which is only used in the
"shared variable blocking" (svb) method of multiple requests, on
the control object. Without this flags, write-side requests may
may be issued in a different order than either the order their
corresponding read-side requests were issued, or the order they
appear in the request array. [Both of those amount to the same
thing.] This occurs because write-side requests are issued when
the corresponding read-side request has completed and those
completions may be out-of-order.

With this flag on the control object, read-side request completions
are processed strictly in the order they were issued. This leads
to the desired effect of having the write-side requests issued in
the same order that they appear in the command array (and after
their corresponding read-side completions).

In svb, the chances are that the data length being read then
written is the same from one chunk to the next; perhaps smaller for
the last chunk. This will lead to the same write-side request object
being chosen as each read-write pair is processed. So provide the
previous write-side request object pointer as a candidate for the
current write-side object.

The important sg_setup_request() function is getting bloated again so
factor out sg_setup_req_new_srp() helper.

Clean up same variable namings to lessen (the author's)
confusion. Also do some checkpatch work.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 1889 ++++++++++++++++++++++------------------
 include/uapi/scsi/sg.h |    1 +
 2 files changed, 1047 insertions(+), 843 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c4421a426045..d6e18cb4df11 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -113,20 +113,21 @@ enum sg_shr_var {
 /* If sum_of(dlen) of a fd exceeds this, write() will yield E2BIG */
 #define SG_TOT_FD_THRESHOLD (32 * 1024 * 1024)
 
-#define SG_TIME_UNIT_MS 0	/* milliseconds */
-/* #define SG_TIME_UNIT_NS 1	   nanoseconds */
+#define SG_TIME_UNIT_MS 0	/* command duration unit: a millisecond */
+/* #define SG_TIME_UNIT_NS 1	   in nanoseconds, using high resolution timer (hrt) */
 #define SG_DEF_TIME_UNIT SG_TIME_UNIT_MS
 #define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 #define SG_FD_Q_AT_HEAD 0
 #define SG_DEFAULT_Q_AT SG_FD_Q_AT_HEAD /* for backward compatibility */
 #define SG_FL_MMAP_DIRECT (SG_FLAG_MMAP_IO | SG_FLAG_DIRECT_IO)
 
-#define SG_MAX_RSV_REQS 8
+#define SG_MAX_RSV_REQS 8	/* number of svb requests done asynchronously; assume small-ish */
 
 #define SG_PACK_ID_WILDCARD (-1)
 #define SG_TAG_WILDCARD (-1)
 
 #define SG_ADD_RQ_MAX_RETRIES 40	/* to stop infinite _trylock(s) */
+#define SG_DEF_BLK_POLL_LOOP_COUNT 1000	/* may allow user to tweak this */
 
 /* Bit positions (flags) for sg_request::frq_bm bitmask follow */
 #define SG_FRQ_IS_V4I		0	/* true (set) when is v4 interface */
@@ -333,16 +334,19 @@ struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 	struct sg_fd *sfp;
 	const u8 __user *u_cmdp;
 	const u8 *cmdp;
+	struct sg_request *possible_srp;	/* possible candidate for this request */
 };
 
-struct sg_mrq_hold {	/* for passing context between mrq functions */
-	bool blocking;
-	bool chk_abort;
-	bool immed;
-	bool stop_if;
-	bool co_mmap;
+struct sg_mrq_hold {	/* for passing context between multiple requests (mrq) functions */
+	unsigned from_sg_io:1;
+	unsigned chk_abort:1;
+	unsigned immed:1;
+	unsigned hipri:1;
+	unsigned stop_if:1;
+	unsigned co_mmap:1;
+	unsigned ordered_wr:1;
 	int id_of_mrq;
-	int s_res;		/* secondary error: some-good-then-error */
+	int s_res;		/* secondary error: some-good-then-error; in co.spare_out */
 	u32 cdb_mxlen;		/* cdb length in cdb_ap, actual be may less */
 	u32 tot_reqs;		/* total number of requests and cdb_s */
 	struct sg_comm_wr_t *cwrp;	/* cwrp->h4p is mrq control object */
@@ -351,6 +355,12 @@ struct sg_mrq_hold {	/* for passing context between mrq functions */
 	struct sg_scatter_hold *co_mmap_sgatp;
 };
 
+struct sg_svb_elem {	/* context of shared variable blocking (svb) per SG_MAX_RSV_REQS */
+	int ws_pos;			/* write-side position in user supplied sg_io_v4 array */
+	struct sg_request *rs_srp;	/* read-side object ptr, will be next */
+	struct sg_request *prev_ws_srp;	/* previous write-side object ptr, candidate for next */
+};
+
 /* tasklet or soft irq callback */
 static void sg_rq_end_io(struct request *rqq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
@@ -366,8 +376,6 @@ static int sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp,
 static int sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 			struct sg_request **o_srp);
 static struct sg_request *sg_common_write(struct sg_comm_wr_t *cwrp);
-static int sg_wait_event_srp(struct sg_fd *sfp, void __user *p,
-			     struct sg_io_v4 *h4p, struct sg_request *srp);
 static int sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp,
 			 void __user *p, struct sg_io_v4 *h4p);
 static int sg_read_append(struct sg_request *srp, void __user *outp,
@@ -378,7 +386,6 @@ static void sg_remove_sfp(struct kref *);
 static void sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side);
 static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id,
 					    bool is_tag);
-static bool sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp);
 static struct sg_request *sg_setup_req(struct sg_comm_wr_t *cwrp,
 				       enum sg_shr_var sh_var);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
@@ -387,9 +394,15 @@ static void sg_device_destroy(struct kref *kref);
 static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first,
 					 int db_len);
 static int sg_abort_req(struct sg_fd *sfp, struct sg_request *srp);
+static int sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
+			   enum sg_rq_state new_st);
+static int sg_finish_rs_rq(struct sg_fd *sfp, struct sg_request *rs_srp,
+			   bool even_if_in_ws);
+static void sg_rq_chg_state_force(struct sg_request *srp, enum sg_rq_state new_st);
 static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);
 static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q,
 			     int loop_count);
+
 #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)
 static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 static const char *sg_shr_str(enum sg_shr_var sh_var, bool long_str);
@@ -492,7 +505,7 @@ static void sg_take_snap(struct sg_fd *sfp, bool clear_first);
  * EPROTOTYPE	atomic state change failed unexpectedly
  * ERANGE	multiple requests: usually bad flag values
  * ERESTARTSYS	should not be seen in user space, associated with an
- *		interruptable wait; will restart system call or give EINTR
+ *		interruptible wait; will restart system call or give EINTR
  * EWOULDBLOCK	[aka EAGAIN]; additionally if the 'more async' flag is set
  *		SG_IOSUBMIT may yield this error
  */
@@ -1144,6 +1157,71 @@ sg_mrq_arr_flush(struct sg_mrq_hold *mhp)
 	return 0;
 }
 
+static inline const char *
+sg_side_str(struct sg_request *srp)
+{
+	return (srp->sh_var == SG_SHR_WS_NOT_SRQ || srp->sh_var == SG_SHR_WS_RQ) ? "write_side" :
+										   "read-side";
+}
+
+static inline int
+sg_num_waiting_maybe_acquire(struct sg_fd *sfp)
+{
+	int num = atomic_read(&sfp->waiting);
+
+	if (num < 1)
+		num = atomic_read_acquire(&sfp->waiting);
+	return num;
+}
+
+/*
+ * Returns true if a request is ready and its srp is written to *srpp . If nothing can be found
+ * returns false and NULL --> *srpp . If device is detaching, returns true and NULL --> *srpp .
+ */
+static bool
+sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
+{
+	bool second = false;
+	int l_await_idx = READ_ONCE(sfp->low_await_idx);
+	unsigned long idx, s_idx, end_idx;
+	struct sg_request *srp;
+	struct xarray *xafp = &sfp->srp_arr;
+
+	if (SG_IS_DETACHING(sfp->parentdp)) {
+		*srpp = ERR_PTR(-ENODEV);
+		return true;
+	}
+	if (sg_num_waiting_maybe_acquire(sfp) < 1)
+		goto fini;
+
+	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
+	idx = s_idx;
+	end_idx = ULONG_MAX;
+
+second_time:
+	for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
+	     srp;
+	     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
+		if (likely(sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY) == 0)) {
+			*srpp = srp;
+			WRITE_ONCE(sfp->low_await_idx, idx + 1);
+			return true;
+		}
+	}
+	/* If not found so far, need to wrap around and search [0 ... s_idx) */
+	if (!srp && !second && s_idx > 0) {
+		end_idx = s_idx - 1;
+		s_idx = 0;
+		idx = s_idx;
+		second = true;
+		goto second_time;
+	}
+fini:
+	*srpp = NULL;
+	return false;
+}
+
+/* N.B. After this function is completed what srp points to should be considered invalid. */
 static int
 sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
 		struct sg_request *srp)
@@ -1152,6 +1230,7 @@ sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
 	int tot_reqs = mhp->tot_reqs;
 	struct sg_io_v4 *hp;
 	struct sg_io_v4 *a_hds = mhp->a_hds;
+	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 
 	if (unlikely(!srp))
 		return -EPROTO;
@@ -1161,26 +1240,32 @@ sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
 		       __func__, indx);
 		return -EPROTO;
 	}
-	SG_LOG(3, sfp, "%s: mrq_ind=%d, pack_id=%d\n", __func__, indx,
-	       srp->pack_id);
+	SG_LOG(3, sfp, "%s: %s, mrq_ind=%d, pack_id=%d\n", __func__,
+	       sg_side_str(srp), indx, srp->pack_id);
 	if (unlikely(indx < 0 || indx >= tot_reqs))
 		return -EPROTO;
 	hp = a_hds + indx;
 	s_res = sg_receive_v4(sfp, srp, NULL, hp);
+	if (unlikely(!sg_result_is_good(srp->rq_result)))
+		SG_LOG(2, sfp, "%s: %s, bad status: drv/tran/scsi=0x%x/0x%x/0x%x\n",
+		       __func__, sg_side_str(srp), hp->driver_status,
+		       hp->transport_status, hp->device_status);
 	if (unlikely(s_res == -EFAULT))
 		return s_res;
 	hp->info |= SG_INFO_MRQ_FINI;
+	++cop->info;
+	if (cop->din_xfer_len > 0)
+		--cop->din_resid;
 	if (mhp->co_mmap) {
 		sg_sgat_cp_into(mhp->co_mmap_sgatp, indx * SZ_SG_IO_V4,
 				(const u8 *)hp, SZ_SG_IO_V4);
 		if (sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL))
 			kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
-		if (sfp->efd_ctxp && (srp->rq_flags & SGV4_FLAG_EVENTFD)) {
+		if (sfp->efd_ctxp && (hp->flags & SGV4_FLAG_EVENTFD)) {
 			u64 n = eventfd_signal(sfp->efd_ctxp, 1);
 
 			if (n != 1)
-				pr_info("%s: srp=%pK eventfd_signal problem\n",
-					__func__, srp);
+				pr_info("%s: eventfd_signal problem\n", __func__);
 		}
 	} else if (sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
 		s_res = sg_mrq_arr_flush(mhp);
@@ -1192,7 +1277,7 @@ sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
 }
 
 static int
-sg_wait_mrq_event(struct sg_fd *sfp, struct sg_request **srpp)
+sg_wait_any_mrq(struct sg_fd *sfp, struct sg_request **srpp)
 {
 	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm))
 		return __wait_event_interruptible_exclusive
@@ -1202,6 +1287,159 @@ sg_wait_mrq_event(struct sg_fd *sfp, struct sg_request **srpp)
 					  sg_mrq_get_ready_srp(sfp, srpp));
 }
 
+static bool
+sg_srp_hybrid_sleep(struct sg_request *srp)
+{
+	struct hrtimer_sleeper hs;
+	enum hrtimer_mode mode;
+	ktime_t kt = ns_to_ktime(5000);
+
+	if (test_and_set_bit(SG_FRQ_POLL_SLEPT, srp->frq_bm))
+		return false;
+	if (kt == 0)
+		return false;
+
+	mode = HRTIMER_MODE_REL;
+	hrtimer_init_sleeper_on_stack(&hs, CLOCK_MONOTONIC, mode);
+	hrtimer_set_expires(&hs.timer, kt);
+
+	do {
+		if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT)
+			break;
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		hrtimer_sleeper_start_expires(&hs, mode);
+		if (hs.task)
+			io_schedule();
+		hrtimer_cancel(&hs.timer);
+		mode = HRTIMER_MODE_ABS;
+	} while (hs.task && !signal_pending(current));
+
+	__set_current_state(TASK_RUNNING);
+	destroy_hrtimer_on_stack(&hs.timer);
+	return true;
+}
+
+static inline bool
+sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
+{
+	return atomic_read_acquire(&srp->rq_st) != SG_RQ_INFLIGHT || SG_IS_DETACHING(sdp);
+}
+
+/* This is a blocking wait (or poll) for a given srp. */
+static int
+sg_wait_poll_for_given_srp(struct sg_fd *sfp, struct sg_request *srp, bool do_poll)
+{
+	int res;
+	struct sg_device *sdp = sfp->parentdp;
+
+	SG_LOG(3, sfp, "%s: do_poll=%d\n", __func__, (int)do_poll);
+	if (do_poll || (srp->rq_flags & SGV4_FLAG_HIPRI))
+		goto poll_loop;
+
+	if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT)
+		goto skip_wait;		/* and skip _acquire() */
+	/* N.B. The SG_FFD_EXCL_WAITQ flag is ignored here. */
+	res = __wait_event_interruptible(sfp->cmpl_wait,
+					 sg_rq_landed(sdp, srp));
+	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
+		set_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
+		/* orphans harvested when sfp->keep_orphan is false */
+		sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
+		SG_LOG(1, sfp, "%s:  wait_event_interruptible(): %s[%d]\n",
+		       __func__, (res == -ERESTARTSYS ? "ERESTARTSYS" : ""),
+		       res);
+		return res;
+	}
+skip_wait:
+	if (SG_IS_DETACHING(sdp))
+		goto detaching;
+	return sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
+poll_loop:
+	if (srp->rq_flags & SGV4_FLAG_HIPRI) {
+		long state = current->state;
+
+		do {
+			res = sg_srp_q_blk_poll(srp, sdp->device->request_queue,
+						SG_DEF_BLK_POLL_LOOP_COUNT);
+			if (res == -ENODATA || res > 0) {
+				__set_current_state(TASK_RUNNING);
+				break;
+			}
+			if (unlikely(res < 0)) {
+				__set_current_state(TASK_RUNNING);
+				return res;
+			}
+			if (signal_pending_state(state, current)) {
+				__set_current_state(TASK_RUNNING);
+				return -ERESTARTSYS;
+			}
+			if (SG_IS_DETACHING(sdp)) {
+				__set_current_state(TASK_RUNNING);
+				goto detaching;
+			}
+			cpu_relax();
+		} while (true);
+	} else {
+		enum sg_rq_state sr_st;
+
+		if (!sg_srp_hybrid_sleep(srp))
+			return -EINVAL;
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+		if (SG_IS_DETACHING(sdp))
+			goto detaching;
+		sr_st = atomic_read(&srp->rq_st);
+		if (unlikely(sr_st != SG_RQ_AWAIT_RCV))
+			return -EPROTO;         /* Logic error */
+		return sg_rq_chg_state(srp, sr_st, SG_RQ_BUSY);
+	}
+	if (atomic_read_acquire(&srp->rq_st) != SG_RQ_AWAIT_RCV)
+		return (test_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm) &&
+			atomic_read(&sfp->submitted) < 1) ? -ENODATA : 0;
+	return unlikely(sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY)) ? -EPROTO : 0;
+
+detaching:
+	sg_rq_chg_state_force(srp, SG_RQ_INACTIVE);
+	atomic_inc(&sfp->inactives);
+	return -ENODEV;
+}
+
+static struct sg_request *
+sg_mrq_poll_either(struct sg_fd *sfp, struct sg_fd *sec_sfp, bool *on_sfp)
+{
+	bool sig_pending = false;
+	long state = current->state;
+	struct sg_request *srp;
+
+	do {		/* alternating polling loop */
+		if (sfp) {
+			if (sg_mrq_get_ready_srp(sfp, &srp)) {
+				if (!srp)
+					return ERR_PTR(-ENODEV);
+				*on_sfp = true;
+				__set_current_state(TASK_RUNNING);
+				return srp;
+			}
+		}
+		if (sec_sfp && sfp != sec_sfp) {
+			if (sg_mrq_get_ready_srp(sec_sfp, &srp)) {
+				if (!srp)
+					return ERR_PTR(-ENODEV);
+				*on_sfp = false;
+				__set_current_state(TASK_RUNNING);
+				return srp;
+			}
+		}
+		if (signal_pending_state(state, current)) {
+			sig_pending = true;
+			break;
+		}
+		cpu_relax();
+	} while (!need_resched());
+	__set_current_state(TASK_RUNNING);
+	return ERR_PTR(sig_pending ? -ERESTARTSYS : -EAGAIN);
+}
+
 /*
  * This is a fair-ish algorithm for an interruptible wait on two file
  * descriptors. It favours the main fd over the secondary fd (sec_sfp).
@@ -1211,48 +1449,31 @@ static int
 sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
 		struct sg_fd *sec_sfp, int mreqs, int sec_reqs)
 {
-	int res = 0;
-	int rres;
+	bool on_sfp;
+	int res;
 	struct sg_request *srp;
-	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 
 	SG_LOG(3, sfp, "%s: mreqs=%d, sec_reqs=%d\n", __func__, mreqs,
 	       sec_reqs);
 	while (mreqs + sec_reqs > 0) {
 		while (mreqs > 0 && sg_mrq_get_ready_srp(sfp, &srp)) {
-			if (IS_ERR(srp)) {	/* -ENODATA: no mrqs here */
-				if (PTR_ERR(srp) == -ENODATA)
-					break;
-				res = PTR_ERR(srp);
-				break;
-			}
 			--mreqs;
 			res = sg_mrq_1complet(mhp, sfp, srp);
 			if (unlikely(res))
 				return res;
-			++cop->info;
-			if (cop->din_xfer_len > 0)
-				--cop->din_resid;
 		}
 		while (sec_reqs > 0 && sg_mrq_get_ready_srp(sec_sfp, &srp)) {
-			if (IS_ERR(srp)) {
-				if (PTR_ERR(srp) == -ENODATA)
-					break;
-				res = PTR_ERR(srp);
-				break;
-			}
 			--sec_reqs;
-			rres = sg_mrq_1complet(mhp, sec_sfp, srp);
-			if (unlikely(rres))
-				return rres;
-			++cop->info;
-			if (cop->din_xfer_len > 0)
-				--cop->din_resid;
+			res = sg_mrq_1complet(mhp, sec_sfp, srp);
+			if (unlikely(res))
+				return res;
 		}
+		if (mhp->hipri)
+			goto start_polling;
 		if (res)
 			break;
 		if (mreqs > 0) {
-			res = sg_wait_mrq_event(sfp, &srp);
+			res = sg_wait_any_mrq(sfp, &srp);
 			if (unlikely(res))
 				return res;	/* signal --> -ERESTARTSYS */
 			if (IS_ERR(srp)) {
@@ -1262,13 +1483,10 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
 				res = sg_mrq_1complet(mhp, sfp, srp);
 				if (unlikely(res))
 					return res;
-				++cop->info;
-				if (cop->din_xfer_len > 0)
-					--cop->din_resid;
 			}
 		}
 		if (sec_reqs > 0) {
-			res = sg_wait_mrq_event(sec_sfp, &srp);
+			res = sg_wait_any_mrq(sec_sfp, &srp);
 			if (unlikely(res))
 				return res;	/* signal --> -ERESTARTSYS */
 			if (IS_ERR(srp)) {
@@ -1278,20 +1496,43 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
 				res = sg_mrq_1complet(mhp, sec_sfp, srp);
 				if (unlikely(res))
 					return res;
-				++cop->info;
-				if (cop->din_xfer_len > 0)
-					--cop->din_resid;
 			}
 		}
 	}	/* end of outer while loop (while requests still inflight) */
-	return res;
+	return 0;
+start_polling:
+	while (mreqs + sec_reqs > 0) {
+		srp = sg_mrq_poll_either(sfp, sec_sfp, &on_sfp);
+		if (IS_ERR(srp))
+			return PTR_ERR(srp);
+		if (on_sfp) {
+			--mreqs;
+			res = sg_mrq_1complet(mhp, sfp, srp);
+			if (unlikely(res))
+				return res;
+		} else {
+			--sec_reqs;
+			res = sg_mrq_1complet(mhp, sec_sfp, srp);
+			if (unlikely(res))
+				return res;
+		}
+	}
+	return 0;
 }
 
-static int
-sg_mrq_sanity(struct sg_mrq_hold *mhp)
+/*
+ * Does once pass through the request array looking mainly for bad flag settings and other
+ * contradictions such as setting the SGV4_FLAG_SHARE flag when no file share is set up. Has
+ * code toward the end of the loop for checking the share variable blocking (svb) is using
+ * a strict READ (like) thence WRITE (like) sequence on all data carrying commands; also
+ * a dangling READ is not allowed at the end of a scb request array.
+ */
+static bool
+sg_mrq_sanity(struct sg_mrq_hold *mhp, bool is_svb)
 {
 	bool last_is_keep_share = false;
-	bool share, have_mrq_sense;
+	bool expect_wr = false;
+	bool share, have_mrq_sense, have_file_share;
 	int k;
 	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 	u32 cdb_alen = cop->request_len;
@@ -1304,149 +1545,116 @@ sg_mrq_sanity(struct sg_mrq_hold *mhp)
 	__maybe_unused const char *rip = "request index";
 
 	have_mrq_sense = (cop->response && cop->max_response_len);
+	have_file_share = sg_fd_is_shared(sfp);
+	if (is_svb && unlikely(!have_file_share)) {
+		SG_LOG(1, sfp, "%s: share variable blocking (svb) needs file share\n", __func__);
+		return false;
+	}
 	/* Pre-check each request for anomalies, plus some preparation */
 	for (k = 0, hp = a_hds; k < mhp->tot_reqs; ++k, ++hp) {
 		flags = hp->flags;
 		sg_v4h_partial_zero(hp);
-		if (unlikely(hp->guard != 'Q' || hp->protocol != 0 ||
-			     hp->subprotocol != 0)) {
-			SG_LOG(1, sfp, "%s: req index %u: %s or protocol\n",
-			       __func__, k, "bad guard");
-			return -ERANGE;
+		if (unlikely(hp->guard != 'Q' || hp->protocol != 0 || hp->subprotocol != 0)) {
+			SG_LOG(1, sfp, "%s: req index %u: bad guard or protocol\n", __func__, k);
+			return false;
 		}
-		last_is_keep_share = !!(flags & SGV4_FLAG_KEEP_SHARE);
 		if (unlikely(flags & SGV4_FLAG_MULTIPLE_REQS)) {
-			SG_LOG(1, sfp, "%s: %s %u: no nested multi-reqs\n",
-			       __func__, rip, k);
-			return -ERANGE;
+			SG_LOG(1, sfp, "%s: %s %u: no nested multi-reqs\n", __func__, rip, k);
+			return false;
 		}
 		share = !!(flags & SGV4_FLAG_SHARE);
-		if (mhp->immed) {/* only accept async submits on current fd */
-			if (unlikely(flags & SGV4_FLAG_DO_ON_OTHER)) {
-				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
-				       rip, k, "no IMMED with ON_OTHER");
-				return -ERANGE;
-			} else if (unlikely(share)) {
-				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
-				       rip, k, "no IMMED with FLAG_SHARE");
-				return -ERANGE;
-			} else if (unlikely(flags & SGV4_FLAG_COMPLETE_B4)) {
-				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
-				       rip, k, "no IMMED with COMPLETE_B4");
-				return -ERANGE;
-			}
+		last_is_keep_share = !!(flags & SGV4_FLAG_KEEP_SHARE);
+		if (mhp->immed &&
+		    unlikely(flags & (SGV4_FLAG_DO_ON_OTHER | SGV4_FLAG_COMPLETE_B4))) {
+			SG_LOG(1, sfp, "%s: %s %u, no IMMED with ON_OTHER or COMPLETE_B4\n",
+			       __func__, rip, k);
+			return false;
+		}
+		if (mhp->immed && unlikely(share)) {
+			SG_LOG(1, sfp, "%s: %s %u, no IMMED with FLAG_SHARE\n", __func__, rip, k);
+			return false;
 		}
 		if (mhp->co_mmap && (flags & SGV4_FLAG_MMAP_IO)) {
-			SG_LOG(1, sfp, "%s: %s %u, MMAP in co AND here\n",
-			       __func__, rip, k);
-			return -ERANGE;
+			SG_LOG(1, sfp, "%s: %s %u, MMAP in co AND here\n", __func__, rip, k);
+			return false;
 		}
-		if (!sg_fd_is_shared(sfp)) {
-			if (unlikely(share)) {
-				SG_LOG(1, sfp, "%s: %s %u, no share\n",
-				       __func__, rip, k);
-				return -ERANGE;
-			} else if (unlikely(flags & SGV4_FLAG_DO_ON_OTHER)) {
-				SG_LOG(1, sfp, "%s: %s %u, %s do on\n",
-				       __func__, rip, k, "no other fd to");
-				return -ERANGE;
-			}
+		if (unlikely(!have_file_share && share)) {
+			SG_LOG(1, sfp, "%s: %s %u, no file share\n", __func__, rip, k);
+			return false;
 		}
-		if (cdb_ap) {
-			if (unlikely(hp->request_len > cdb_mxlen)) {
-				SG_LOG(1, sfp, "%s: %s %u, cdb too long\n",
-				       __func__, rip, k);
-				return -ERANGE;
-			}
+		if (unlikely(!have_file_share && !!(flags & SGV4_FLAG_DO_ON_OTHER))) {
+			SG_LOG(1, sfp, "%s: %s %u, no other fd to do on\n", __func__, rip, k);
+			return false;
 		}
-		if (have_mrq_sense && hp->response == 0 &&
-		    hp->max_response_len == 0) {
+		if (cdb_ap && unlikely(hp->request_len > cdb_mxlen)) {
+			SG_LOG(1, sfp, "%s: %s %u, cdb too long\n", __func__, rip, k);
+			return false;
+		}
+		if (have_mrq_sense && hp->response == 0 && hp->max_response_len == 0) {
 			hp->response = cop->response;
 			hp->max_response_len = cop->max_response_len;
 		}
-	}
-	if (last_is_keep_share) {
-		SG_LOG(1, sfp,
-		       "%s: Can't set SGV4_FLAG_KEEP_SHARE on last mrq req\n",
-		       __func__);
-		return -ERANGE;
-	}
-	return 0;
-}
-
-/*
- * Read operation (din) must precede any write (dout) operations and a din
- * operation can't be last (data transferring) operations. Non data
- * transferring operations can appear anywhere. Data transferring operations
- * must have SGV4_FLAG_SHARE set. Dout operations must additionally have
- * SGV4_FLAG_NO_DXFER and SGV4_FLAG_DO_ON_OTHER set. Din operations must
- * not set SGV4_FLAG_DO_ON_OTHER.
- */
-static bool
-sg_mrq_svb_chk(struct sg_io_v4 *a_hds, u32 tot_reqs)
-{
-	bool last_rd = false;
-	bool seen_wr = false;
-	int k;
-	u32 flags;
-	struct sg_io_v4 *hp;
-
-	/* expect read-write pairs, all with SGV4_FLAG_NO_DXFER set */
-	for (k = 0, hp = a_hds; k < tot_reqs; ++k, ++hp) {
-		flags = hp->flags;
-		if (flags & SGV4_FLAG_COMPLETE_B4)
+		if (!is_svb)
+			continue;
+		/* mrq share variable blocking (svb) additional constraints checked here */
+		if (unlikely(flags & (SGV4_FLAG_COMPLETE_B4 | SGV4_FLAG_KEEP_SHARE))) {
+			SG_LOG(1, sfp, "%s: %s %u: no KEEP_SHARE with svb\n", __func__, rip, k);
 			return false;
-		if (!seen_wr) {
+		}
+		if (!expect_wr) {
 			if (hp->dout_xfer_len > 0)
-				return false;
+				goto bad_svb;
 			if (hp->din_xfer_len > 0) {
 				if (!(flags & SGV4_FLAG_SHARE))
-					return false;
+					goto bad_svb;
 				if (flags & SGV4_FLAG_DO_ON_OTHER)
-					return false;
-				seen_wr = true;
-				last_rd = true;
+					goto bad_svb;
+				expect_wr = true;
 			}
-			/* allowing commands with no dxfer */
+			/* allowing commands with no dxfer (in both cases) */
 		} else {	/* checking write side */
 			if (hp->dout_xfer_len > 0) {
-				if (~flags &
-				    (SGV4_FLAG_NO_DXFER | SGV4_FLAG_SHARE |
-				     SGV4_FLAG_DO_ON_OTHER))
-					return false;
-				last_rd = false;
-			}
-			if (hp->din_xfer_len > 0) {
-				if (!(flags & SGV4_FLAG_SHARE))
-					return false;
-				if (flags & SGV4_FLAG_DO_ON_OTHER)
-					return false;
-				last_rd = true;
+				if (unlikely(~flags & (SGV4_FLAG_NO_DXFER | SGV4_FLAG_SHARE |
+						       SGV4_FLAG_DO_ON_OTHER)))
+					goto bad_svb;
+				expect_wr = false;
+			} else if (unlikely(hp->din_xfer_len > 0)) {
+				goto bad_svb;
 			}
 		}
+	}		/* end of request array iterating loop */
+	if (last_is_keep_share) {
+		SG_LOG(1, sfp, "%s: Can't set SGV4_FLAG_KEEP_SHARE on last mrq req\n", __func__);
+		return false;
+	}
+	if (is_svb && expect_wr) {
+		SG_LOG(1, sfp, "%s: svb: unpaired READ at end of request array\n", __func__);
+		return false;
 	}
-	return !last_rd;
+	return true;
+bad_svb:
+	SG_LOG(1, sfp, "%s: %s %u: svb alternating read-then-write or flags bad\n", __func__,
+	       rip, k);
+	return false;
 }
-
 static struct sg_request *
-sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_hdr,
-	      int rsv_idx, bool keep_share)
+sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_in_rq_arr, int rsv_idx,
+	      struct sg_request *possible_srp)
 {
 	unsigned long ul_timeout;
 	struct sg_comm_wr_t r_cwr;
 	struct sg_comm_wr_t *r_cwrp = &r_cwr;
-	struct sg_io_v4 *hp = mhp->a_hds + pos_hdr;
+	struct sg_io_v4 *hp = mhp->a_hds + pos_in_rq_arr;
 
 	sg_comm_wr_init(r_cwrp);
 	if (mhp->cdb_ap)	/* already have array of cdbs */
-		r_cwrp->cmdp = mhp->cdb_ap + (pos_hdr * mhp->cdb_mxlen);
+		r_cwrp->cmdp = mhp->cdb_ap + (pos_in_rq_arr * mhp->cdb_mxlen);
 	else			/* fetch each cdb from user space */
 		r_cwrp->u_cmdp = cuptr64(hp->request);
 	r_cwrp->cmd_len = hp->request_len;
 	r_cwrp->rsv_idx = rsv_idx;
 	ul_timeout = msecs_to_jiffies(hp->timeout);
-	__assign_bit(SG_FRQ_SYNC_INVOC, r_cwrp->frq_bm,
-		     (int)mhp->blocking);
+	__assign_bit(SG_FRQ_SYNC_INVOC, r_cwrp->frq_bm, (int)mhp->from_sg_io);
 	__set_bit(SG_FRQ_IS_V4I, r_cwrp->frq_bm);
 	r_cwrp->h4p = hp;
 	r_cwrp->dlen = hp->din_xfer_len ? hp->din_xfer_len : hp->dout_xfer_len;
@@ -1454,7 +1662,7 @@ sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_hdr,
 	if (hp->flags & SGV4_FLAG_DOUT_OFFSET)
 		r_cwrp->wr_offset = hp->spare_in;
 	r_cwrp->sfp = rq_sfp;
-	r_cwrp->keep_share = keep_share;
+	r_cwrp->possible_srp = possible_srp;
 	return sg_common_write(r_cwrp);
 }
 
@@ -1490,7 +1698,7 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 		}
 		flags = hp->flags;
 		rq_sfp = (flags & SGV4_FLAG_DO_ON_OTHER) ? o_sfp : fp;
-		srp = sg_mrq_submit(rq_sfp, mhp, j, -1, false);
+		srp = sg_mrq_submit(rq_sfp, mhp, j, -1, NULL);
 		if (IS_ERR(srp)) {
 			mhp->s_res = PTR_ERR(srp);
 			break;
@@ -1499,50 +1707,24 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 		if (mhp->chk_abort)
 			atomic_set(&srp->s_hdr4.pack_id_of_mrq,
 				   mhp->id_of_mrq);
-		if (mhp->immed ||
-		    (!(mhp->blocking || (flags & shr_complet_b4)))) {
+		if (mhp->immed || (!(mhp->from_sg_io || (flags & shr_complet_b4)))) {
 			if (fp == rq_sfp)
 				++this_fp_sent;
 			else
 				++other_fp_sent;
 			continue;  /* defer completion until all submitted */
 		}
-		mhp->s_res = sg_wait_event_srp(rq_sfp, NULL, hp, srp);
+		mhp->s_res = sg_wait_poll_for_given_srp(rq_sfp, srp, mhp->hipri);
 		if (unlikely(mhp->s_res)) {
-			if (mhp->s_res == -ERESTARTSYS)
+			if (mhp->s_res == -ERESTARTSYS || mhp->s_res == -ENODEV)
 				return mhp->s_res;
 			break;
 		}
+		res = sg_mrq_1complet(mhp, rq_sfp, srp);
+		if (unlikely(res))
+			break;
 		++num_cmpl;
-		hp->info |= SG_INFO_MRQ_FINI;
-		if (mhp->stop_if && !sg_result_is_good(srp->rq_result)) {
-			SG_LOG(2, fp, "%s: %s=0x%x/0x%x/0x%x] cause exit\n",
-			       __func__, "STOP_IF and status [drv/tran/scsi",
-			       hp->driver_status, hp->transport_status,
-			       hp->device_status);
-			break;	/* cop->driver_status <-- 0 in this case */
-		}
-		if (mhp->co_mmap) {
-			sg_sgat_cp_into(mhp->co_mmap_sgatp, j * SZ_SG_IO_V4,
-					(const u8 *)hp, SZ_SG_IO_V4);
-			if (rq_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL))
-				kill_fasync(&rq_sfp->async_qp, SIGPOLL,
-					    POLL_IN);
-			if (rq_sfp->efd_ctxp &&
-			    (srp->rq_flags & SGV4_FLAG_EVENTFD)) {
-				u64 n = eventfd_signal(rq_sfp->efd_ctxp, 1);
-
-				if (n != 1)
-					pr_info("%s: eventfd_signal prob\n",
-						__func__);
-			}
-		} else if (rq_sfp->async_qp &&
-			   (hp->flags & SGV4_FLAG_SIGNAL)) {
-			res = sg_mrq_arr_flush(mhp);
-			if (unlikely(res))
-				break;
-			kill_fasync(&rq_sfp->async_qp, SIGPOLL, POLL_IN);
-		}
+
 	}	/* end of dispatch request and optionally wait response loop */
 	cop->dout_resid = mhp->tot_reqs - num_subm;
 	cop->info = mhp->immed ? num_subm : num_cmpl;
@@ -1565,238 +1747,342 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 	return res;
 }
 
+/* For multiple requests (mrq) share variable blocking (svb) with no SGV4_FLAG_ORDERED_WR */
 static int
-sg_find_srp_idx(struct sg_fd *sfp, const struct sg_request *srp)
+sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp, int ra_ind,
+		      int *num_submp)
 {
-	int k;
-	struct sg_request **rapp = sfp->rsv_arr;
+	bool chk_oth_first = false;
+	bool is_first = true;
+	enum sg_rq_state rq_st;
+	int this_fp_sent = 0;
+	int other_fp_sent = 0;
+	int res = 0;
+	int first_err = 0;
+	int k, m, idx, ws_pos, num_reads, sent, dir;
+	struct sg_io_v4 *hp = mhp->a_hds + ra_ind;
+	struct sg_request *srp;
+	struct sg_request *rs_srp;
+	struct sg_svb_elem svb_arr[SG_MAX_RSV_REQS];
+
+	memset(svb_arr, 0, sizeof(svb_arr));
+	for (k = 0; k < SG_MAX_RSV_REQS && ra_ind < mhp->tot_reqs;
+	     ++hp, ++ra_ind, is_first = false) {
+		if (hp->flags & SGV4_FLAG_DO_ON_OTHER) {
+			if (hp->dout_xfer_len > 0) {	/* need to await read-side completion */
+				svb_arr[k].ws_pos = ra_ind;
+				++k;
+				continue;  /* deferred to next loop */
+			}
+			if (is_first)
+				chk_oth_first = true;
+			SG_LOG(6, o_sfp, "%s: subm-nodat p_id=%d on write-side\n", __func__,
+			       (int)hp->request_extra);
+			srp = sg_mrq_submit(o_sfp, mhp, ra_ind, -1, NULL);
+			if (!IS_ERR(srp))
+				++other_fp_sent;
+		} else {
+			rs_srp = (hp->din_xfer_len > 0) ? svb_arr[k].rs_srp : NULL;
+			SG_LOG(6, fp, "%s: submit p_id=%d on read-side\n", __func__,
+			       (int)hp->request_extra);
+			srp = sg_mrq_submit(fp, mhp, ra_ind, -1, rs_srp);
+			if (!IS_ERR(srp))
+				++this_fp_sent;
+		}
+		if (IS_ERR(srp)) {
+			mhp->s_res = PTR_ERR(srp);
+			if (first_err == 0)
+				first_err = mhp->s_res;
+			SG_LOG(1, fp, "%s: sg_mrq_submit() err: %d\n", __func__, mhp->s_res);
+			break;	/* stop doing rs submits */
+		}
+		++*num_submp;
+		if (hp->din_xfer_len > 0)
+			svb_arr[k].rs_srp = srp;
+		srp->s_hdr4.mrq_ind = ra_ind;
+		if (mhp->chk_abort)
+			atomic_set(&srp->s_hdr4.pack_id_of_mrq, mhp->id_of_mrq);
+	}	/* end of read-side submission, write-side defer loop */
 
-	for (k = 0; k < SG_MAX_RSV_REQS; ++k, ++rapp) {
-		if (*rapp == srp)
-			return k;
+	num_reads = k;
+	sent = this_fp_sent + other_fp_sent;
+
+	for (k = 0; k < sent; ++k) {
+		if (other_fp_sent > 0 && sg_mrq_get_ready_srp(o_sfp, &srp)) {
+other_found:
+			--other_fp_sent;
+			res = sg_mrq_1complet(mhp, o_sfp, srp);
+			if (unlikely(res))
+				break;
+			continue;  /* do available submits first */
+		}
+		if (this_fp_sent > 0 && sg_mrq_get_ready_srp(fp, &srp)) {
+this_found:
+			--this_fp_sent;
+			dir = srp->s_hdr4.dir;
+			res = sg_mrq_1complet(mhp, fp, srp);
+			if (unlikely(res))
+				break;
+			if (dir != SG_DXFER_FROM_DEV)
+				continue;
+			if (test_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm))
+				continue;
+			/* read-side req completed, submit its write-side(s) */
+			rs_srp = srp;
+			for (m = 0; m < num_reads; ++m) {
+				if (rs_srp == svb_arr[m].rs_srp)
+					break;
+			}
+			if (m >= num_reads) {
+				SG_LOG(1, fp, "%s: rs [pack_id=%d]: missing ws\n", __func__,
+				       srp->pack_id);
+				continue;
+			}
+			rq_st = atomic_read(&rs_srp->rq_st);
+			if (rq_st == SG_RQ_INACTIVE)
+				continue;       /* probably an error, bypass paired write-side rq */
+			else if (rq_st != SG_RQ_SHR_SWAP) {
+				SG_LOG(1, fp, "%s: expect rs_srp to be in shr_swap\n", __func__);
+				res = -EPROTO;
+				break;
+			}
+			ws_pos = svb_arr[m].ws_pos;
+			for (idx = 0; idx < SG_MAX_RSV_REQS; ++idx) {
+				if (fp->rsv_arr[idx] == srp)
+					break;
+			}
+			if (idx >= SG_MAX_RSV_REQS) {
+				SG_LOG(1, fp, "%s: srp not in rsv_arr\n", __func__);
+				res = -EPROTO;
+				break;
+			}
+			SG_LOG(6, o_sfp, "%s: ws_pos=%d, rs_idx=%d\n", __func__, ws_pos, idx);
+			srp = sg_mrq_submit(o_sfp, mhp, ws_pos, idx, svb_arr[m].prev_ws_srp);
+			if (IS_ERR(srp)) {
+				mhp->s_res = PTR_ERR(srp);
+				if (mhp->s_res == -EFBIG) {	/* out of reserve slots */
+					if (first_err)
+						break;
+					res = mhp->s_res;
+					break;
+				}
+				if (first_err == 0)
+					first_err = mhp->s_res;
+				svb_arr[m].prev_ws_srp = NULL;
+				SG_LOG(1, o_sfp, "%s: mrq_submit(oth)->%d\n", __func__, mhp->s_res);
+				continue;
+			}
+			svb_arr[m].prev_ws_srp = srp;
+			++*num_submp;
+			++other_fp_sent;
+			++sent;
+			srp->s_hdr4.mrq_ind = ws_pos;
+			if (mhp->chk_abort)
+				atomic_set(&srp->s_hdr4.pack_id_of_mrq, mhp->id_of_mrq);
+			continue;  /* do available submits first */
+		}
+		/* waits maybe interrupted by signals (-ERESTARTSYS) */
+		if (chk_oth_first)
+			goto oth_first;
+this_second:
+		if (this_fp_sent > 0) {
+			res = sg_wait_any_mrq(fp, &srp);
+			if (unlikely(res))
+				break;
+			goto this_found;
+		}
+		if (chk_oth_first)
+			continue;
+oth_first:
+		if (other_fp_sent > 0) {
+			res = sg_wait_any_mrq(o_sfp, &srp);
+			if (unlikely(res))
+				break;
+			goto other_found;
+		}
+		if (chk_oth_first)
+			goto this_second;
+	}	/* end of loop for deferred ws submits and all responses */
+
+	if (res == 0 && first_err)
+		res = first_err;
+	return res;
+}
+
+static int
+sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp, int ra_ind,
+		   int *num_submp)
+{
+	enum sg_rq_state rq_st;
+	int k, m, res, idx, ws_pos, num_reads;
+	int this_fp_sent = 0;
+	int other_fp_sent = 0;
+	struct sg_io_v4 *hp = mhp->a_hds + ra_ind;
+	struct sg_request *srp;
+	struct sg_request *rs_srp;
+	struct sg_svb_elem svb_arr[SG_MAX_RSV_REQS];
+
+	memset(svb_arr, 0, sizeof(svb_arr));
+	for (k = 0; k < SG_MAX_RSV_REQS && ra_ind < mhp->tot_reqs; ++hp, ++ra_ind) {
+		if (hp->flags & SGV4_FLAG_DO_ON_OTHER) {
+			if (hp->dout_xfer_len > 0) {
+				/* need to await read-side completion */
+				svb_arr[k].ws_pos = ra_ind;
+				++k;
+				continue;  /* deferred to next loop */
+			}
+			SG_LOG(6, o_sfp, "%s: subm-nodat p_id=%d on write-side\n", __func__,
+			       (int)hp->request_extra);
+			srp = sg_mrq_submit(o_sfp, mhp, ra_ind, -1, NULL);
+			if (!IS_ERR(srp))
+				++other_fp_sent;
+		} else {
+			rs_srp = (hp->din_xfer_len > 0) ? svb_arr[k].rs_srp : NULL;
+			SG_LOG(6, fp, "%s: submit p_id=%d on read-side\n", __func__,
+			       (int)hp->request_extra);
+			srp = sg_mrq_submit(fp, mhp, ra_ind, -1, rs_srp);
+			if (!IS_ERR(srp))
+				++this_fp_sent;
+		}
+		if (IS_ERR(srp)) {
+			mhp->s_res = PTR_ERR(srp);
+			res = mhp->s_res;	/* don't loop again */
+			SG_LOG(1, fp, "%s: sg_mrq_submit() err: %d\n", __func__, res);
+			break;
+		}
+		++*num_submp;
+		if (hp->din_xfer_len > 0)
+			svb_arr[k].rs_srp = srp;
+		srp->s_hdr4.mrq_ind = ra_ind;
+		if (mhp->chk_abort)
+			atomic_set(&srp->s_hdr4.pack_id_of_mrq, mhp->id_of_mrq);
+	}	/* end of first, inner for loop */
+
+	num_reads = k;
+
+	if (this_fp_sent + other_fp_sent <= 0)
+		return 0;
+	for (m = 0; m < num_reads; ++m) {
+		rs_srp = svb_arr[m].rs_srp;
+		if (!rs_srp)
+			continue;
+		res = sg_wait_poll_for_given_srp(fp, rs_srp, mhp->hipri);
+		if (unlikely(res))
+			return res;
+		--this_fp_sent;
+		res = sg_mrq_1complet(mhp, fp, rs_srp);
+		if (unlikely(res))
+			return res;
+		if (test_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm))
+			continue;
+		rq_st = atomic_read(&rs_srp->rq_st);
+		if (rq_st == SG_RQ_INACTIVE)
+			continue;       /* probably an error, bypass paired write-side rq */
+		else if (rq_st != SG_RQ_SHR_SWAP) {
+			SG_LOG(1, fp, "%s: expect rs_srp to be in shr_swap\n", __func__);
+			res = -EPROTO;
+			break;
+		}
+		ws_pos = svb_arr[m].ws_pos;
+		for (idx = 0; idx < SG_MAX_RSV_REQS; ++idx) {
+			if (fp->rsv_arr[idx] == rs_srp)
+				break;
+		}
+		if (idx >= SG_MAX_RSV_REQS) {
+			SG_LOG(1, rs_srp->parentfp, "%s: srp not in rsv_arr\n", __func__);
+			res = -EPROTO;
+			return res;
+		}
+		SG_LOG(6, o_sfp, "%s: ws_pos=%d, rs_idx=%d\n", __func__, ws_pos, idx);
+		srp = sg_mrq_submit(o_sfp, mhp, ws_pos, idx, svb_arr[m].prev_ws_srp);
+		if (IS_ERR(srp)) {
+			mhp->s_res = PTR_ERR(srp);
+			res = mhp->s_res;
+			SG_LOG(1, o_sfp,
+			       "%s: mrq_submit(oth)->%d\n",
+				__func__, res);
+			return res;
+		}
+		svb_arr[m].prev_ws_srp = srp;
+		++*num_submp;
+		++other_fp_sent;
+		srp->s_hdr4.mrq_ind = ws_pos;
+		if (mhp->chk_abort)
+			atomic_set(&srp->s_hdr4.pack_id_of_mrq,
+				   mhp->id_of_mrq);
 	}
-	return -1;
+	while (this_fp_sent > 0) {	/* non-data requests */
+		res = sg_wait_any_mrq(fp, &srp);
+		if (unlikely(res))
+			return res;
+		--this_fp_sent;
+		res = sg_mrq_1complet(mhp, fp, srp);
+		if (unlikely(res))
+			return res;
+	}
+	while (other_fp_sent > 0) {
+		res = sg_wait_any_mrq(o_sfp, &srp);
+		if (unlikely(res))
+			return res;
+		--other_fp_sent;
+		res = sg_mrq_1complet(mhp, o_sfp, srp);
+		if (unlikely(res))
+			return res;
+	}
+	return 0;
 }
 
 /*
- * Processes shared variable blocking. First inner loop submits a chunk of
- * requests (some read-side, some non-data) but defers any write-side requests. The
- * second inner loop processes the completions from the first inner loop, plus
- * for any completed read-side request it submits the paired write-side request. The
- * second inner loop also waits for the completions of those write-side requests.
- * The outer loop then moves onto the next chunk, working its way through
- * the multiple requests. The user sees a blocking command, but the chunks
- * are run in parallel apart from read-write ordering requirement.
- * N.B. Only one svb mrq permitted per file descriptor at a time.
+ * Processes shared variable blocking (svb) method for multiple requests (mrq). There are two
+ * variants: unordered write-side requests; and ordered write-side requests. The read-side requests
+ * are always issued in the order specified in the request array. The unordered write-side requests
+ * are processed on a "first come, first serve" basis, with the majority of the work done by
+ * sg_svb_mrq_first_come(). Likewise sg_svb_mrq_ordered() handles the majoity of the ordered
+ * write-side requests variant. Those two functions process a "chunk" of mrq_s at a time. This
+ * function loops until request array is exhausted and does some clean-up. N.B. the "only one mrq
+ * per fd" rule is enforced by the SG_FFD_SVB_ACTIVE file descriptor flag.
  */
 static int
 sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 		   struct sg_mrq_hold *mhp)
 {
 	bool aborted = false;
-	bool chk_oth_first, keep_share;
-	int k, j, i, m, rcv_before, idx, ws_pos, sent;
-	int this_fp_sent, other_fp_sent;
+	int j, delta_subm, subm_before, cmpl_before;
 	int num_subm = 0;
 	int num_cmpl = 0;
 	int res = 0;
-	struct sg_fd *rq_sfp;
 	struct sg_io_v4 *cop = mhp->cwrp->h4p;
-	struct sg_io_v4 *hp;		/* ptr to request object in a_hds */
-	struct sg_request *srp;
-	struct sg_request *rs_srp;
-	struct sg_io_v4 *a_hds = mhp->a_hds;
-	int ws_pos_a[SG_MAX_RSV_REQS];	/* write-side hdr pos within a_hds */
-	struct sg_request *rs_srp_a[SG_MAX_RSV_REQS];
 
 	SG_LOG(3, fp, "%s: id_of_mrq=%d, tot_reqs=%d, enter\n", __func__,
 	       mhp->id_of_mrq, mhp->tot_reqs);
 
-	/* work through mrq array, SG_MAX_RSV_REQS read-side requests at a time */
-	for (hp = a_hds, j = 0; j < mhp->tot_reqs; ) {
-		this_fp_sent = 0;
-		other_fp_sent = 0;
-		chk_oth_first = false;
-		for (k = 0; k < SG_MAX_RSV_REQS && j < mhp->tot_reqs;
-		     ++hp, ++j) {
-			if (mhp->chk_abort &&
-			    test_and_clear_bit(SG_FFD_MRQ_ABORT, fp->ffd_bm)) {
-				SG_LOG(1, fp,
-				       "%s: id_of_mrq=%d aborting at pos=%d\n",
-				       __func__, mhp->id_of_mrq, num_subm);
-				aborted = true;
-				/*
-				 * after mrq abort detected, complete those
-				 * already submitted, but don't submit any more
-				 */
-			}
-			if (aborted)
-				break;
-			if (hp->flags & SGV4_FLAG_DO_ON_OTHER) {
-				if (hp->dout_xfer_len > 0) {
-					/* need to await read-side completion */
-					ws_pos_a[k] = j;
-					++k;
-					continue;  /* deferred to next loop */
-				}
-				chk_oth_first = true;
-				SG_LOG(6, o_sfp,
-				       "%s: subm-nodat p_id=%d on write-side\n",
-				       __func__, (int)hp->request_extra);
-				rq_sfp = o_sfp;
-			} else {
-				SG_LOG(6, fp, "%s: submit p_id=%d on read-side\n",
-				       __func__, (int)hp->request_extra);
-				rq_sfp = fp;
-			}
-			srp = sg_mrq_submit(rq_sfp, mhp, j, -1, false);
-			if (IS_ERR(srp)) {
-				mhp->s_res = PTR_ERR(srp);
-				res = mhp->s_res;	/* don't loop again */
-				SG_LOG(1, rq_sfp, "%s: mrq_submit()->%d\n",
-				       __func__, res);
-				break;
-			}
-			num_subm++;
-			if (hp->din_xfer_len > 0)
-				rs_srp_a[k] = srp;
-			srp->s_hdr4.mrq_ind = j;
-			if (mhp->chk_abort)
-				atomic_set(&srp->s_hdr4.pack_id_of_mrq,
-					   mhp->id_of_mrq);
-			if (fp == rq_sfp)
-				++this_fp_sent;
-			else
-				++other_fp_sent;
+	/* outer loop: SG_MAX_RSV_REQS read-side requests (chunks) at a time */
+	for (j = 0; j < mhp->tot_reqs; j += delta_subm) {
+		if (mhp->chk_abort &&
+		    test_and_clear_bit(SG_FFD_MRQ_ABORT, fp->ffd_bm)) {
+			SG_LOG(1, fp, "%s: id_of_mrq=%d aborting at pos=%d\n", __func__,
+			       mhp->id_of_mrq, num_subm);
+			aborted = true;
 		}
-		sent = this_fp_sent + other_fp_sent;
-		if (sent <= 0)
+		if (aborted)
+			break;
+
+		subm_before = num_subm;
+		cmpl_before = cop->info;
+		if (mhp->ordered_wr)
+			res = sg_svb_mrq_ordered(fp, o_sfp, mhp, j, &num_subm);
+		else	/* write-side request done on first come, first served basis */
+			res = sg_svb_mrq_first_come(fp, o_sfp, mhp, j, &num_subm);
+		delta_subm = num_subm - subm_before;
+		num_cmpl += (cop->info - cmpl_before);
+		if (res || delta_subm == 0)	/* error or didn't make progress */
 			break;
-		/*
-		 * We have just submitted a fixed number read-side reqs and any
-		 * others (that don't move data). Now we pick up their
-		 * responses. Any responses that were read-side requests have
-		 * their paired write-side submitted. Finally we wait for those
-		 * paired write-side to complete.
-		 */
-		rcv_before = cop->info;
-		for (i = 0; i < sent; ++i) {	/* now process responses */
-			if (other_fp_sent > 0 &&
-			    sg_mrq_get_ready_srp(o_sfp, &srp)) {
-other_found:
-				if (IS_ERR(srp)) {
-					res = PTR_ERR(srp);
-					break;
-				}
-				--other_fp_sent;
-				res = sg_mrq_1complet(mhp, o_sfp, srp);
-				if (unlikely(res))
-					return res;
-				++cop->info;
-				if (cop->din_xfer_len > 0)
-					--cop->din_resid;
-				continue;  /* do available submits first */
-			}
-			if (this_fp_sent > 0 &&
-			    sg_mrq_get_ready_srp(fp, &srp)) {
-this_found:
-				if (IS_ERR(srp)) {
-					res = PTR_ERR(srp);
-					break;
-				}
-				--this_fp_sent;
-				res = sg_mrq_1complet(mhp, fp, srp);
-				if (unlikely(res))
-					return res;
-				++cop->info;
-				if (cop->din_xfer_len > 0)
-					--cop->din_resid;
-				if (srp->s_hdr4.dir != SG_DXFER_FROM_DEV)
-					continue;
-				if (test_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm))
-					continue;
-				/* read-side req completed, submit its write-side */
-				rs_srp = srp;
-				for (m = 0; m < k; ++m) {
-					if (rs_srp == rs_srp_a[m])
-						break;
-				}
-				if (m >= k) {
-					SG_LOG(1, rs_srp->parentfp,
-					       "%s: m >= %d, pack_id=%d\n",
-					       __func__, k, rs_srp->pack_id);
-					res = -EPROTO;
-					break;
-				}
-				ws_pos = ws_pos_a[m];
-				idx = sg_find_srp_idx(fp, rs_srp);
-				if (idx < 0) {
-					SG_LOG(1, rs_srp->parentfp,
-					       "%s: idx < 0\n", __func__);
-					res = -EPROTO;
-					break;
-				}
-				keep_share = false;
-another_dout:
-				SG_LOG(6, o_sfp,
-				       "%s: submit ws_pos=%d, rs_idx=%d\n",
-				       __func__, ws_pos, idx);
-				srp = sg_mrq_submit(o_sfp, mhp, ws_pos, idx,
-						    keep_share);
-				if (IS_ERR(srp)) {
-					mhp->s_res = PTR_ERR(srp);
-					res = mhp->s_res;
-					SG_LOG(1, o_sfp,
-					       "%s: mrq_submit(oth)->%d\n",
-						__func__, res);
-					break;
-				}
-				++num_subm;
-				++other_fp_sent;
-				++sent;
-				srp->s_hdr4.mrq_ind = ws_pos;
-				if (srp->rq_flags & SGV4_FLAG_KEEP_SHARE) {
-					++ws_pos;  /* next for same read-side */
-					keep_share = true;
-					goto another_dout;
-				}
-				if (mhp->chk_abort)
-					atomic_set(&srp->s_hdr4.pack_id_of_mrq,
-						   mhp->id_of_mrq);
-				continue;  /* do available submits first */
-			}
-			/* waits maybe interrupted by signals (-ERESTARTSYS) */
-			if (chk_oth_first)
-				goto oth_first;
-this_second:
-			if (this_fp_sent > 0) {
-				res = sg_wait_mrq_event(fp, &srp);
-				if (unlikely(res))
-					return res;
-				goto this_found;
-			}
-			if (chk_oth_first)
-				continue;
-oth_first:
-			if (other_fp_sent > 0) {
-				res = sg_wait_mrq_event(o_sfp, &srp);
-				if (unlikely(res))
-					return res;
-				goto other_found;
-			}
-			if (chk_oth_first)
-				goto this_second;
-		}	/* end of response/write_side_submit/write_side_response loop */
 		if (unlikely(mhp->s_res == -EFAULT ||
 			     mhp->s_res == -ERESTARTSYS))
 			res = mhp->s_res;	/* this may leave orphans */
-		num_cmpl += (cop->info - rcv_before);
 		if (res)
 			break;
-		if (aborted)
-			break;
-	}	/* end of outer for loop */
-
+	}
 	cop->dout_resid = mhp->tot_reqs - num_subm;
 	if (cop->din_xfer_len > 0) {
 		cop->din_resid = mhp->tot_reqs - num_cmpl;
@@ -1809,11 +2095,11 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 
 #if IS_ENABLED(SG_LOG_ACTIVE)
 static const char *
-sg_mrq_name(bool blocking, u32 flags)
+sg_mrq_name(bool from_sg_io, u32 flags)
 {
 	if (!(flags & SGV4_FLAG_MULTIPLE_REQS))
 		return "_not_ multiple requests control object";
-	if (blocking)
+	if (from_sg_io)
 		return "ordered blocking";
 	if (flags & SGV4_FLAG_IMMED)
 		return "submit or full non-blocking";
@@ -1824,16 +2110,16 @@ sg_mrq_name(bool blocking, u32 flags)
 #endif
 
 /*
- * Implements the multiple request functionality. When 'blocking' is true
+ * Implements the multiple request functionality. When 'from_sg_io' is true
  * invocation was via ioctl(SG_IO), otherwise it was via ioctl(SG_IOSUBMIT).
  * Submit non-blocking if IMMED flag given or when ioctl(SG_IOSUBMIT)
  * is used with O_NONBLOCK set on its file descriptor. Hipri non-blocking
  * is when the HIPRI flag is given.
  */
 static int
-sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
+sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 {
-	bool f_non_block, co_share;
+	bool f_non_block, is_svb;
 	int res = 0;
 	int existing_id;
 	u32 cdb_mxlen;
@@ -1854,14 +2140,16 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 #endif
 
 	mhp->cwrp = cwrp;
-	mhp->blocking = blocking;
+	mhp->from_sg_io = from_sg_io; /* false if from SG_IOSUBMIT */
 #if IS_ENABLED(SG_LOG_ACTIVE)
-	mrq_name = sg_mrq_name(blocking, cop->flags);
+	mrq_name = sg_mrq_name(from_sg_io, cop->flags);
 #endif
 	f_non_block = !!(fp->filp->f_flags & O_NONBLOCK);
-	co_share = !!(cop->flags & SGV4_FLAG_SHARE);
+	is_svb = !!(cop->flags & SGV4_FLAG_SHARE);	/* via ioctl(SG_IOSUBMIT) only */
 	mhp->immed = !!(cop->flags & SGV4_FLAG_IMMED);
+	mhp->hipri = !!(cop->flags & SGV4_FLAG_HIPRI);
 	mhp->stop_if = !!(cop->flags & SGV4_FLAG_STOP_IF);
+	mhp->ordered_wr = !!(cop->flags & SGV4_FLAG_ORDERED_WR);
 	mhp->co_mmap = !!(cop->flags & SGV4_FLAG_MMAP_IO);
 	if (mhp->co_mmap)
 		mhp->co_mmap_sgatp = fp->rsv_arr[0]->sgatp;
@@ -1881,13 +2169,13 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	} else {
 		mhp->chk_abort = false;
 	}
-	if (blocking) {		/* came from ioctl(SG_IO) */
+	if (from_sg_io) {
 		if (unlikely(mhp->immed)) {
 			SG_LOG(1, fp, "%s: ioctl(SG_IO) %s contradicts\n",
 			       __func__, "with SGV4_FLAG_IMMED");
 			return -ERANGE;
 		}
-		if (unlikely(co_share)) {
+		if (unlikely(is_svb)) {
 			SG_LOG(1, fp, "%s: ioctl(SG_IO) %s contradicts\n",
 			       __func__, "with SGV4_FLAG_SHARE");
 			return -ERANGE;
@@ -1899,7 +2187,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 		}
 	}
 	if (!mhp->immed && f_non_block)
-		mhp->immed = true;
+		mhp->immed = true;	/* hmm, think about this */
 	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, id_of_mrq=%d\n", __func__,
 	       mrq_name, tot_reqs, mhp->id_of_mrq);
 	sg_v4h_partial_zero(cop);
@@ -1943,10 +2231,16 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 
 	if (SG_IS_DETACHING(sdp) || (o_sfp && SG_IS_DETACHING(o_sfp->parentdp)))
 		return -ENODEV;
-
+	if (is_svb && unlikely(test_and_set_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm))) {
+		SG_LOG(1, fp, "%s: %s already active\n", __func__, mrq_name);
+		return -EBUSY;
+	}
 	a_hds = kcalloc(tot_reqs, SZ_SG_IO_V4, GFP_KERNEL | __GFP_NOWARN);
-	if (unlikely(!a_hds))
+	if (unlikely(!a_hds)) {
+		if (is_svb)
+			clear_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm);
 		return -ENOMEM;
+	}
 	if (copy_from_user(a_hds, cuptr64(cop->dout_xferp),
 			   tot_reqs * SZ_SG_IO_V4)) {
 		res = -EFAULT;
@@ -1967,40 +2261,29 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	mhp->a_hds = a_hds;
 	mhp->cdb_mxlen = cdb_mxlen;
 	/* do sanity checks on all requests before starting */
-	res = sg_mrq_sanity(mhp);
-	if (unlikely(res))
+	if (unlikely(!sg_mrq_sanity(mhp, is_svb))) {
+		res = -ERANGE;
 		goto fini;
+	}
 
 	/* override cmd queuing setting to allow */
 	clear_bit(SG_FFD_NO_CMD_Q, fp->ffd_bm);
 	if (o_sfp)
 		clear_bit(SG_FFD_NO_CMD_Q, o_sfp->ffd_bm);
 
-	if (co_share) {
-		bool ok;
-
-		/* check for 'shared' variable blocking (svb) */
-		ok = sg_mrq_svb_chk(a_hds, tot_reqs);
-		if (!ok) {
-			SG_LOG(1, fp, "%s: %s failed on req(s)\n", __func__,
-			       mrq_name);
-			res = -ERANGE;
-			goto fini;
-		}
-		if (test_and_set_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm)) {
-			SG_LOG(1, fp, "%s: %s already active\n", __func__,
-			       mrq_name);
-			res = -EBUSY;
-			goto fini;
-		}
+	if (is_svb)
 		res = sg_process_svb_mrq(fp, o_sfp, mhp);
-		clear_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm);
-	} else {
+	else
 		res = sg_process_most_mrq(fp, o_sfp, mhp);
-	}
 fini:
-	if (likely(res == 0) && !mhp->immed)
-		res = sg_mrq_arr_flush(mhp);
+	if (!mhp->immed) {		/* for the blocking mrq invocations */
+		int rres = sg_mrq_arr_flush(mhp);
+
+		if (unlikely(rres > 0 && res == 0))
+			res = rres;
+	}
+	if (is_svb)
+		clear_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm);
 	kfree(cdb_ap);
 	kfree(a_hds);
 	return res;
@@ -2008,7 +2291,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 
 static int
 sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
-	     bool sync, struct sg_request **o_srp)
+	     bool from_sg_io, struct sg_request **o_srp)
 {
 	int res = 0;
 	int dlen;
@@ -2029,7 +2312,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 			*o_srp = NULL;
 		cwr.sfp = sfp;
 		cwr.h4p = h4p;
-		res = sg_do_multi_req(&cwr, sync);
+		res = sg_do_multi_req(&cwr, from_sg_io);
 		if (unlikely(res))
 			return res;
 		if (likely(p)) {
@@ -2049,7 +2332,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		clear_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(h4p->timeout);
 	cwr.sfp = sfp;
-	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
+	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)from_sg_io);
 	__set_bit(SG_FRQ_IS_V4I, cwr.frq_bm);
 	cwr.h4p = h4p;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
@@ -2062,7 +2345,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		return PTR_ERR(srp);
 	if (o_srp)
 		*o_srp = srp;
-	if (p && !sync && (srp->rq_flags & SGV4_FLAG_YIELD_TAG)) {
+	if (p && !from_sg_io && (srp->rq_flags & SGV4_FLAG_YIELD_TAG)) {
 		u64 gen_tag = srp->tag;
 		struct sg_io_v4 __user *h4_up = (struct sg_io_v4 __user *)p;
 
@@ -2239,12 +2522,11 @@ static const int sg_rq_state_arr[] = {1, 0, 4, 0, 0, 0};
 static const int sg_rq_state_mul2arr[] = {2, 0, 8, 0, 0, 0};
 
 /*
- * This function keeps the srp->rq_st state and associated marks on the
- * owning xarray's element in sync. An attempt si made to change state with
- * a call to atomic_cmpxchg(). If the actual srp->rq_st is not old_st, then
- * -EPROTOTYPE is returned. If the actual srp->rq_st is old_st then it is
- * replaced by new_st and the xarray marks are setup accordingly and 0 is
- * returned. This assumes srp_arr xarray spinlock is held.
+ * This function keeps the srp->rq_st state and associated marks on the owning xarray's element in
+ * sync. An attempt si made to change state with a call to atomic_cmpxchg(). If the actual
+ * srp->rq_st is not old_st, then -EPROTOTYPE is returned. If the actual srp->rq_st is old_st then
+ * it is replaced by new_st and the xarray marks are setup accordingly and 0 is returned. This
+ * function (and others ending in '_ulck') assumes srp_arr xarray spinlock is already held.
  */
 static int
 sg_rq_chg_state_ulck(struct sg_request *srp, enum sg_rq_state old_st,
@@ -2376,37 +2658,29 @@ sg_get_idx_available(struct sg_fd *sfp)
 static struct sg_request *
 sg_get_probable_read_side(struct sg_fd *sfp)
 {
-	struct sg_request **rapp = sfp->rsv_arr;
-	struct sg_request **end_rapp = rapp + SG_MAX_RSV_REQS;
+	struct sg_request **rapp;
 	struct sg_request *rs_srp;
+	struct sg_request *rs_inactive_srp = NULL;
 
-	for ( ; rapp < end_rapp; ++rapp) {
+	for (rapp = sfp->rsv_arr; rapp < rapp + SG_MAX_RSV_REQS; ++rapp) {
 		rs_srp = *rapp;
 		if (IS_ERR_OR_NULL(rs_srp) || rs_srp->sh_srp)
 			continue;
-		switch (atomic_read(&rs_srp->rq_st)) {
+		switch (atomic_read_acquire(&rs_srp->rq_st)) {
 		case SG_RQ_INFLIGHT:
 		case SG_RQ_AWAIT_RCV:
 		case SG_RQ_BUSY:
 		case SG_RQ_SHR_SWAP:
 			return rs_srp;
-		default:
-			break;
-		}
-	}
-	/* Subsequent dout data transfers (e.g. WRITE) on a request share */
-	for (rapp = sfp->rsv_arr; rapp < end_rapp; ++rapp) {
-		rs_srp = *rapp;
-		if (IS_ERR_OR_NULL(rs_srp) || rs_srp->sh_srp)
-			continue;
-		switch (atomic_read(&rs_srp->rq_st)) {
 		case SG_RQ_INACTIVE:
-			return rs_srp;
+			if (!rs_inactive_srp)
+				rs_inactive_srp = rs_srp;
+			break;
 		default:
 			break;
 		}
 	}
-	return NULL;
+	return rs_inactive_srp;
 }
 
 /*
@@ -2468,11 +2742,10 @@ sg_get_rsv_str_lck(struct sg_request *srp, const char *leadin,
 static void
 sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 {
-	bool at_head, sync;
+	bool at_head;
 	struct sg_device *sdp = sfp->parentdp;
 	struct request *rqq = READ_ONCE(srp->rqq);
 
-	sync = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
 	SG_LOG(3, sfp, "%s: pack_id=%d\n", __func__, srp->pack_id);
 	if (test_bit(SG_FFD_NO_DURATION, sfp->ffd_bm))
 		srp->start_ns = 0;
@@ -2491,7 +2764,7 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 	kref_get(&sfp->f_ref); /* put usually in: sg_rq_end_io() */
 	sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
 	/* >>>>>>> send cmd/req off to other levels <<<<<<<< */
-	if (!sync) {
+	if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
 		atomic_inc(&sfp->submitted);
 		set_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm);
 	}
@@ -2550,6 +2823,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		res = sg_share_chk_flags(fp, rq_flags, dlen, dir, &sh_var);
 		if (unlikely(res < 0))
 			return ERR_PTR(res);
+		cwrp->keep_share = !!(rq_flags & SGV4_FLAG_KEEP_SHARE);
 	} else {
 		sh_var = SG_SHR_NONE;
 		if (unlikely(rq_flags & SGV4_FLAG_SHARE))
@@ -2673,14 +2947,15 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	enum sg_rq_state rs_st = SG_RQ_INACTIVE;
 	struct sg_request *rs_srp;
 
-	if (unlikely(!scsi_status_is_good(rq_res))) {
-		int sb_len_wr = sg_copy_sense(srp, v4_active);
+	if (unlikely(!sg_result_is_good(rq_res))) {
+		srp->rq_info |= SG_INFO_CHECK;
+		if (!scsi_status_is_good(rq_res)) {
+			int sb_len_wr = sg_copy_sense(srp, v4_active);
 
-		if (unlikely(sb_len_wr < 0))
-			return sb_len_wr;
+			if (unlikely(sb_len_wr < 0))
+				return sb_len_wr;
+		}
 	}
-	if (!sg_result_is_good(rq_res))
-		srp->rq_info |= SG_INFO_CHECK;
 	if (unlikely(test_bit(SG_FRQ_ABORTING, srp->frq_bm)))
 		srp->rq_info |= SG_INFO_ABORTED;
 
@@ -2881,7 +3156,7 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs,
 		return k;
 
 	for ( ; k < max_mrqs; ++k) {
-		res = sg_wait_mrq_event(sfp, &srp);
+		res = sg_wait_any_mrq(sfp, &srp);
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
@@ -2945,10 +3220,14 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p,
 	return res;
 }
 
+// sg_wait_id_event
 static int
-sg_wait_id_event(struct sg_fd *sfp, struct sg_request **srpp, int id,
-		 bool is_tag)
+sg_wait_poll_by_id(struct sg_fd *sfp, struct sg_request **srpp, int id,
+		   bool is_tag, int do_poll)
 {
+	if (do_poll)
+		goto poll_loop;
+
 	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm))
 		return __wait_event_interruptible_exclusive
 				(sfp->cmpl_wait,
@@ -2956,6 +3235,28 @@ sg_wait_id_event(struct sg_fd *sfp, struct sg_request **srpp, int id,
 	return __wait_event_interruptible
 			(sfp->cmpl_wait,
 			 sg_get_ready_srp(sfp, srpp, id, is_tag));
+poll_loop:
+	{
+		bool sig_pending = false;
+		long state = current->state;
+		struct sg_request *srp;
+
+		do {
+			srp = sg_find_srp_by_id(sfp, id, is_tag);
+			if (srp) {
+				__set_current_state(TASK_RUNNING);
+				*srpp = srp;
+				return 0;
+			}
+			if (signal_pending_state(state, current)) {
+				sig_pending = true;
+				break;
+			}
+			cpu_relax();
+		} while (!need_resched());
+		__set_current_state(TASK_RUNNING);
+		return sig_pending ? -ERESTARTSYS : -EAGAIN;
+	}
 }
 
 /*
@@ -2988,9 +3289,10 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 	if (unlikely(h4p->guard != 'Q' || h4p->protocol != 0 ||
 		     h4p->subprotocol != 0))
 		return -EPERM;
+	SG_LOG(3, sfp, "%s: non_block=%d, immed=%d, hipri=%d\n", __func__, non_block,
+	       !!(h4p->flags & SGV4_FLAG_IMMED), !!(h4p->flags & SGV4_FLAG_HIPRI));
 	if (h4p->flags & SGV4_FLAG_IMMED)
 		non_block = true;	/* set by either this or O_NONBLOCK */
-	SG_LOG(3, sfp, "%s: non_block(+IMMED)=%d\n", __func__, non_block);
 	if (h4p->flags & SGV4_FLAG_MULTIPLE_REQS)
 		return sg_mrq_ioreceive(sfp, h4p, p, non_block);
 	/* read in part of v3 or v4 header for pack_id or tag based find */
@@ -3001,20 +3303,20 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 		else
 			pack_id = h4p->request_extra;
 	}
-	id = use_tag ? tag : pack_id;
-try_again:
-	srp = sg_find_srp_by_id(sfp, id, use_tag);
-	if (!srp) {     /* nothing available so wait on packet or */
-		if (SG_IS_DETACHING(sdp))
-			return -ENODEV;
-		if (non_block)
-			return -EAGAIN;
-		res = sg_wait_id_event(sfp, &srp, id, use_tag);
-		if (unlikely(res))
-			return res;	/* signal --> -ERESTARTSYS */
+	id = use_tag ? tag : pack_id;
+try_again:
+	if (non_block) {
+		srp = sg_find_srp_by_id(sfp, id, use_tag);
+		if (!srp)
+			return SG_IS_DETACHING(sdp) ? -ENODEV : -EAGAIN;
+	} else {
+		res = sg_wait_poll_by_id(sfp, &srp, pack_id, use_tag,
+					 !!(h4p->flags & SGV4_FLAG_HIPRI));
 		if (IS_ERR(srp))
 			return PTR_ERR(srp);
-	}	/* now srp should be valid */
+		if (unlikely(res))
+			return res;	/* signal --> -ERESTARTSYS */
+	}
 	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
 		cpu_relax();
 		goto try_again;
@@ -3058,18 +3360,18 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm))
 		pack_id = h3p->pack_id;
 try_again:
-	srp = sg_find_srp_by_id(sfp, pack_id, false);
-	if (!srp) {     /* nothing available so wait on packet or */
-		if (SG_IS_DETACHING(sdp))
-			return -ENODEV;
-		if (non_block)
-			return -EAGAIN;
-		res = sg_wait_id_event(sfp, &srp, pack_id, false);
+	if (non_block) {
+		srp = sg_find_srp_by_id(sfp, pack_id, false);
+		if (!srp)
+			return SG_IS_DETACHING(sdp) ? -ENODEV : -EAGAIN;
+	} else {
+		res = sg_wait_poll_by_id(sfp, &srp, pack_id, false,
+					 !!(h3p->flags & SGV4_FLAG_HIPRI));
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
 			return PTR_ERR(srp);
-	}	/* now srp should be valid */
+	}
 	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
 		cpu_relax();
 		goto try_again;
@@ -3239,18 +3541,16 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 		}
 	}
 try_again:
-	srp = sg_find_srp_by_id(sfp, want_id, false);
-	if (!srp) {	/* nothing available so wait on packet to arrive or */
-		if (SG_IS_DETACHING(sdp))
-			return -ENODEV;
-		if (non_block) /* O_NONBLOCK or v3::flags & SGV4_FLAG_IMMED */
-			return -EAGAIN;
-		ret = sg_wait_id_event(sfp, &srp, want_id, false);
-		if (unlikely(ret))  /* -ERESTARTSYS as signal hit process */
-			return ret;
+	if (non_block) {
+		srp = sg_find_srp_by_id(sfp, want_id, false);
+		if (!srp)
+			return SG_IS_DETACHING(sdp) ? -ENODEV : -EAGAIN;
+	} else {
+		ret = sg_wait_poll_by_id(sfp, &srp, want_id, false, false);
+		if (unlikely(ret))
+			return ret;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
 			return PTR_ERR(srp);
-		/* otherwise srp should be valid */
 	}
 	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
 		cpu_relax();
@@ -3354,16 +3654,18 @@ sg_calc_sgat_param(struct sg_device *sdp)
 }
 
 /*
- * Only valid for shared file descriptors. Designed to be called after a
- * read-side request has successfully completed leaving valid data in a
- * reserve request buffer. The read-side is moved from SG_RQ_SHR_SWAP
- * to SG_RQ_INACTIVE state and returns 0. Acts on first reserve requests.
- * Otherwise -EINVAL is returned, unless write-side is in progress in
+ * Only valid for shared file descriptors. Designed to be called after a read-side request has
+ * successfully completed leaving valid data in a reserve request buffer. May also be called after
+ * a write-side request that has the SGV4_FLAG_KEEP_SHARE flag set. If rs_srp is NULL, acts
+ * on first reserve request in SG_RQ_SHR_SWAP state, making it inactive and returning 0. If rs_srp
+ * is non-NULL and is a reserve request and is in SG_RQ_SHR_SWAP state, makes it busy then
+ * inactive and returns 0. Otherwise -EINVAL is returned, unless write-side is in progress in
  * which case -EBUSY is returned.
  */
 static int
-sg_finish_rs_rq(struct sg_fd *sfp)
+sg_finish_rs_rq(struct sg_fd *sfp, struct sg_request *rs_srp, bool even_if_in_ws)
 {
+	bool found_one = false;
 	int res = -EINVAL;
 	int k;
 	enum sg_rq_state sr_st;
@@ -3381,26 +3683,24 @@ sg_finish_rs_rq(struct sg_fd *sfp)
 	for (k = 0; k < SG_MAX_RSV_REQS; ++k) {
 		res = -EINVAL;
 		rs_rsv_srp = rs_sfp->rsv_arr[k];
+		if (rs_srp) {
+			if (rs_srp != rs_rsv_srp)
+				continue;
+		}
 		if (IS_ERR_OR_NULL(rs_rsv_srp))
 			continue;
 		xa_lock_irqsave(&rs_sfp->srp_arr, iflags);
 		sr_st = atomic_read(&rs_rsv_srp->rq_st);
 		switch (sr_st) {
 		case SG_RQ_SHR_SWAP:
-			res = sg_rq_chg_state_ulck(rs_rsv_srp, sr_st, SG_RQ_BUSY);
-			if (!res)
-				atomic_inc(&rs_sfp->inactives);
-			rs_rsv_srp->tag = SG_TAG_WILDCARD;
-			rs_rsv_srp->sh_var = SG_SHR_NONE;
-			set_bit(SG_FRQ_RESERVED, rs_rsv_srp->frq_bm);
-			rs_rsv_srp->in_resid = 0;
-			rs_rsv_srp->rq_info = 0;
-			rs_rsv_srp->sense_len = 0;
-			rs_rsv_srp->sh_srp = NULL;
-			sg_finish_scsi_blk_rq(rs_rsv_srp);
-			sg_deact_request(rs_rsv_srp->parentfp, rs_rsv_srp);
+			found_one = true;
+			break;
+		case SG_RQ_SHR_IN_WS:
+			if (even_if_in_ws)
+				found_one = true;
+			else
+				res = -EBUSY;
 			break;
-		case SG_RQ_SHR_IN_WS:	/* too late, write-side rq active */
 		case SG_RQ_BUSY:
 			res = -EBUSY;
 			break;
@@ -3408,14 +3708,31 @@ sg_finish_rs_rq(struct sg_fd *sfp)
 			res = -EINVAL;
 			break;
 		}
+		if (found_one)
+			goto found;
 		xa_unlock_irqrestore(&rs_sfp->srp_arr, iflags);
-		if (res == 0)
-			return res;
+		if (rs_srp)
+			return res;	/* found rs_srp but was in wrong state */
 	}
 fini:
 	if (unlikely(res))
 		SG_LOG(1, sfp, "%s: err=%d\n", __func__, -res);
 	return res;
+found:
+	res = sg_rq_chg_state_ulck(rs_rsv_srp, sr_st, SG_RQ_BUSY);
+	if (!res)
+		atomic_inc(&rs_sfp->inactives);
+	rs_rsv_srp->tag = SG_TAG_WILDCARD;
+	rs_rsv_srp->sh_var = SG_SHR_NONE;
+	set_bit(SG_FRQ_RESERVED, rs_rsv_srp->frq_bm);
+	rs_rsv_srp->in_resid = 0;
+	rs_rsv_srp->rq_info = 0;
+	rs_rsv_srp->sense_len = 0;
+	rs_rsv_srp->sh_srp = NULL;
+	xa_unlock_irqrestore(&rs_sfp->srp_arr, iflags);
+	sg_finish_scsi_blk_rq(rs_rsv_srp);
+	sg_deact_request(rs_rsv_srp->parentfp, rs_rsv_srp);
+	return 0;
 }
 
 static void
@@ -3523,7 +3840,7 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 			if (IS_ERR_OR_NULL(rsv_srp) ||
 			    rsv_srp->sh_var != SG_SHR_RS_RQ)
 				continue;
-			sr_st = atomic_read(&rsv_srp->rq_st);
+			sr_st = atomic_read_acquire(&rsv_srp->rq_st);
 			switch (sr_st) {
 			case SG_RQ_SHR_SWAP:
 				set_inactive = true;
@@ -3732,66 +4049,6 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 }
 
-static inline bool
-sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
-{
-	return atomic_read_acquire(&srp->rq_st) != SG_RQ_INFLIGHT || SG_IS_DETACHING(sdp);
-}
-
-/* This is a blocking wait then complete for a specific srp. */
-static int
-sg_wait_event_srp(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
-		  struct sg_request *srp)
-{
-	int res;
-	struct sg_device *sdp = sfp->parentdp;
-	enum sg_rq_state sr_st;
-
-	if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT)
-		goto skip_wait;		/* and skip _acquire() */
-	if (srp->rq_flags & SGV4_FLAG_HIPRI) {
-		/* call blk_poll(), spinning till found */
-		res = sg_srp_q_blk_poll(srp, sdp->device->request_queue, -1);
-		if (res != -ENODATA && unlikely(res < 0))
-			return res;
-		goto skip_wait;
-	}
-	SG_LOG(3, sfp, "%s: about to wait_event...()\n", __func__);
-	/* N.B. The SG_FFD_EXCL_WAITQ flag is ignored here. */
-	res = __wait_event_interruptible(sfp->cmpl_wait,
-					 sg_rq_landed(sdp, srp));
-	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
-		set_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
-		/* orphans harvested when sfp->keep_orphan is false */
-		sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
-		SG_LOG(1, sfp, "%s:  wait_event_interruptible(): %s[%d]\n",
-		       __func__, (res == -ERESTARTSYS ? "ERESTARTSYS" : ""),
-		       res);
-		return res;
-	}
-skip_wait:
-	if (SG_IS_DETACHING(sdp)) {
-		sg_rq_chg_state_force(srp, SG_RQ_INACTIVE);
-		atomic_inc(&sfp->inactives);
-		return -ENODEV;
-	}
-	sr_st = atomic_read(&srp->rq_st);
-	if (unlikely(sr_st != SG_RQ_AWAIT_RCV))
-		return -EPROTO;         /* Logic error */
-	res = sg_rq_chg_state(srp, sr_st, SG_RQ_BUSY);
-	if (unlikely(res)) {
-#if IS_ENABLED(SG_LOG_ACTIVE)
-		sg_rq_state_fail_msg(sfp, sr_st, SG_RQ_BUSY, __func__);
-#endif
-		return res;
-	}
-	if (SG_IS_V4I(srp))
-		res = sg_receive_v4(sfp, srp, p, h4p);
-	else
-		res = sg_receive_v3(sfp, srp, p);
-	return (res < 0) ? res : 0;
-}
-
 /*
  * Handles ioctl(SG_IO) for blocking (sync) usage of v3 or v4 interface.
  * Returns 0 on success else a negated errno.
@@ -3799,6 +4056,7 @@ sg_wait_event_srp(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 static int
 sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 {
+	bool is_v4, hipri;
 	int res;
 	struct sg_request *srp = NULL;
 	u8 hu8arr[SZ_SG_IO_V4];
@@ -3828,8 +4086,12 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 				   ((u8 __user *)p) + v3_len,
 				   SZ_SG_IO_V4 - v3_len))
 			return -EFAULT;
+		is_v4 = true;
+		hipri = !!(h4p->flags & SGV4_FLAG_HIPRI);
 		res = sg_submit_v4(sfp, p, h4p, true, &srp);
 	} else if (h3p->interface_id == 'S') {
+		is_v4 = false;
+		hipri = !!(h3p->flags & SGV4_FLAG_HIPRI);
 		res = sg_submit_v3(sfp, h3p, true, &srp);
 	} else {
 		pr_info_once("sg: %s: v3 or v4 interface only here\n",
@@ -3840,7 +4102,7 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		return res;
 	if (!srp)	/* mrq case: already processed all responses */
 		return res;
-	res = sg_wait_event_srp(sfp, p, h4p, srp);
+	res = sg_wait_poll_for_given_srp(sfp, srp, hipri);
 #if IS_ENABLED(SG_LOG_ACTIVE)
 	if (unlikely(res))
 		SG_LOG(1, sfp, "%s: %s=0x%pK  state: %s, share: %s\n",
@@ -3848,19 +4110,15 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		       sg_rq_st_str(atomic_read(&srp->rq_st), false),
 		       sg_shr_str(srp->sh_var, false));
 #endif
+	if (likely(res == 0)) {
+		if (is_v4)
+			res = sg_receive_v4(sfp, srp, p, h4p);
+		else
+			res = sg_receive_v3(sfp, srp, p);
+	}
 	return res;
 }
 
-static inline int
-sg_num_waiting_maybe_acquire(struct sg_fd *sfp)
-{
-	int num = atomic_read(&sfp->waiting);
-
-	if (num < 1)
-		num = atomic_read_acquire(&sfp->waiting);
-	return num;
-}
-
 /*
  * When use_tag is true then id is a tag, else it is a pack_id. Returns
  * valid srp if match, else returns NULL.
@@ -3943,7 +4201,7 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 		       __func__, srp->pack_id, srp->tag);
 		goto fini;	/* skip quietly if already aborted */
 	}
-	rq_st = atomic_read(&srp->rq_st);
+	rq_st = atomic_read_acquire(&srp->rq_st);
 	SG_LOG(3, sfp, "%s: req pack_id/tag=%d/%d, status=%s\n", __func__,
 	       srp->pack_id, srp->tag, sg_rq_st_str(rq_st, false));
 	switch (rq_st) {
@@ -4252,8 +4510,9 @@ sg_fd_share(struct sg_fd *ws_sfp, int m_fd)
 
 /*
  * After checking the proposed file share relationship is unique and
- * valid, sets up pointers between read-side and write-side sg_fd objects.
- * Allows previous write-side to be the same as the new new_ws_fd .
+ * valid, sets up pointers between read-side and write-side sg_fd objects. Allows
+ * previous write-side to be the same as the new write-side (fd). Return 0 on success
+ * or negated errno value.
  */
 static int
 sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
@@ -4447,6 +4706,7 @@ static int put_compat_request_table(struct compat_sg_req_info __user *o,
 				    struct sg_req_info *rinfo)
 {
 	int i;
+
 	for (i = 0; i < SG_MAX_QUEUE; i++) {
 		if (copy_to_user(o + i, rinfo + i, offsetof(sg_req_info_t, usr_ptr)) ||
 		    put_user((uintptr_t)rinfo[i].usr_ptr, &o[i].usr_ptr) ||
@@ -4638,7 +4898,7 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 		if (rs_sfp && !IS_ERR_OR_NULL(rs_sfp->rsv_arr[0])) {
 			struct sg_request *res_srp = rs_sfp->rsv_arr[0];
 
-			if (atomic_read(&res_srp->rq_st) == SG_RQ_SHR_SWAP)
+			if (atomic_read_acquire(&res_srp->rq_st) == SG_RQ_SHR_SWAP)
 				c_flgs_val_out |= SG_CTL_FLAGM_READ_SIDE_FINI;
 			else
 				c_flgs_val_out &= ~SG_CTL_FLAGM_READ_SIDE_FINI;
@@ -4647,8 +4907,8 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 		}
 	}
 	if ((c_flgs_wm & SG_CTL_FLAGM_READ_SIDE_FINI) &&
-	    (c_flgs_val_in & SG_CTL_FLAGM_READ_SIDE_FINI))
-		res = sg_finish_rs_rq(sfp);
+	    (c_flgs_val_out & SG_CTL_FLAGM_READ_SIDE_FINI))
+		res = sg_finish_rs_rq(sfp, NULL, false);
 	/* READ_SIDE_ERR boolean, [ro] share: read-side finished with error */
 	if (c_flgs_rm & SG_CTL_FLAGM_READ_SIDE_ERR) {
 		struct sg_fd *rs_sfp = sg_fd_share_ptr(sfp);
@@ -4835,10 +5095,8 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 	}
 	/* yields minor_index (type: u32) [ro] */
 	if (or_masks & SG_SEIM_MINOR_INDEX) {
-		if (s_wr_mask & SG_SEIM_MINOR_INDEX) {
-			SG_LOG(2, sfp, "%s: writing to minor_index ignored\n",
-			       __func__);
-		}
+		if (s_wr_mask & SG_SEIM_MINOR_INDEX)
+			SG_LOG(2, sfp, "%s: writing to minor_index ignored\n", __func__);
 		if (s_rd_mask & SG_SEIM_MINOR_INDEX)
 			seip->minor_index = sdp->index;
 	}
@@ -4892,7 +5150,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 		n = 0;
 		if (s_wr_mask & SG_SEIM_BLK_POLL) {
 			result = sg_sfp_blk_poll(sfp, seip->num);
-			if (result < 0) {
+			if (unlikely(result < 0)) {
 				if (ret == 0)
 					ret = result;
 			} else {
@@ -5035,8 +5293,11 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	switch (cmd_in) {
 	case SG_GET_NUM_WAITING:
 		/* Want as fast as possible, with a useful result */
-		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
-			sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready */
+		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm)) {
+			res = sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready */
+			if (unlikely(res < 0))
+				return res;
+		}
 		val = atomic_read(&sfp->waiting);
 		if (val)
 			return put_user(val, ip);
@@ -5360,7 +5621,7 @@ sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
 	struct request_queue *q = sdev ? sdev->request_queue : NULL;
 	struct xarray *xafp = &sfp->srp_arr;
 
-	if (!q)
+	if (unlikely(!q))
 		return -EINVAL;
 	xa_lock_irqsave(xafp, iflags);
 	xa_for_each(xafp, idx, srp) {
@@ -5863,8 +6124,9 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 		if (unlikely(error))
 			pr_err("%s: unable to make symlink 'generic' back "
 			       "to sg%d\n", __func__, sdp->index);
-	} else
+	} else {
 		pr_warn("%s: sg_sys Invalid\n", __func__);
+	}
 
 	sdp->create_ns = ktime_get_boottime_ns();
 	sg_calc_sgat_param(sdp);
@@ -6494,16 +6756,15 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 			if (copy_to_user(outp, page_address(pgp), num_xfer))
 				res = -EFAULT;
 			break;
-		} else {
-			if (copy_to_user(outp, page_address(pgp), num)) {
-				res = -EFAULT;
-				break;
-			}
-			num_xfer -= num;
-			if (num_xfer <= 0)
-				break;
-			outp += num;
 		}
+		if (copy_to_user(outp, page_address(pgp), num)) {
+			res = -EFAULT;
+			break;
+		}
+		num_xfer -= num;
+		if (num_xfer <= 0)
+			break;
+		outp += num;
 	}
 	return res;
 }
@@ -6520,10 +6781,8 @@ static struct sg_request *
 sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 {
 	__maybe_unused bool is_bad_st = false;
-	__maybe_unused enum sg_rq_state bad_sr_st = SG_RQ_INACTIVE;
 	bool search_for_1 = (id != SG_TAG_WILDCARD);
 	bool second = false;
-	enum sg_rq_state sr_st;
 	int res;
 	int l_await_idx = READ_ONCE(sfp->low_await_idx);
 	unsigned long idx, s_idx;
@@ -6531,8 +6790,11 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 	struct sg_request *srp = NULL;
 	struct xarray *xafp = &sfp->srp_arr;
 
-	if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
-		sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready to push up */
+	if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm)) {
+		res = sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready to push up */
+		if (unlikely(res < 0))
+			return ERR_PTR(res);
+	}
 	if (sg_num_waiting_maybe_acquire(sfp) < 1)
 		return NULL;
 
@@ -6552,30 +6814,9 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 				if (srp->pack_id != id)
 					continue;
 			}
-			sr_st = atomic_read(&srp->rq_st);
-			switch (sr_st) {
-			case SG_RQ_AWAIT_RCV:
-				res = sg_rq_chg_state(srp, sr_st, SG_RQ_BUSY);
-				if (likely(res == 0))
-					goto good;
-				/* else another caller got it, move on */
-				if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
-					is_bad_st = true;
-					bad_sr_st = atomic_read(&srp->rq_st);
-				}
-				break;
-			case SG_RQ_SHR_IN_WS:
+			res = sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
+			if (likely(res == 0))
 				goto good;
-			case SG_RQ_INFLIGHT:
-				break;
-			default:
-				if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
-					is_bad_st = true;
-					bad_sr_st = sr_st;
-				}
-				break;
-			}
-			break;
 		}
 		/* If not found so far, need to wrap around and search [0 ... s_idx) */
 		if (!srp && !second && s_idx > 0) {
@@ -6616,21 +6857,6 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 			goto second_time2;
 		}
 	}
-	/* here if one of above loops does _not_ find a match */
-	if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
-		if (search_for_1) {
-			__maybe_unused const char *cptp = is_tag ? "tag=" :
-								   "pack_id=";
-
-			if (unlikely(is_bad_st))
-				SG_LOG(1, sfp, "%s: %s%d wrong state: %s\n",
-				       __func__, cptp, id,
-				       sg_rq_st_str(bad_sr_st, true));
-			else
-				SG_LOG(6, sfp, "%s: %s%d not awaiting read\n",
-				       __func__, cptp, id);
-		}
-	}
 	return NULL;
 good:
 	SG_LOG(5, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__,
@@ -6638,64 +6864,6 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 	return srp;
 }
 
-/*
- * Returns true if a request is ready and its srp is written to *srpp . If
- * nothing can be found (because nothing is currently submitted) then true
- * is returned and ERR_PTR(-ENODATA) --> *srpp . If nothing is found but
- * sfp has requests submitted, returns false and NULL --> *srpp .
- */
-static bool
-sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
-{
-	bool second = false;
-	int res;
-	int l_await_idx = READ_ONCE(sfp->low_await_idx);
-	unsigned long idx, s_idx, end_idx;
-	struct sg_request *srp;
-	struct xarray *xafp = &sfp->srp_arr;
-
-	if (SG_IS_DETACHING(sfp->parentdp)) {
-		*srpp = ERR_PTR(-ENODEV);
-		return true;
-	}
-	if (atomic_read(&sfp->submitted) < 1) {
-		*srpp = ERR_PTR(-ENODATA);
-		return true;
-	}
-	if (sg_num_waiting_maybe_acquire(sfp) < 1)
-		goto fini;
-
-	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
-	idx = s_idx;
-	end_idx = ULONG_MAX;
-
-second_time:
-	for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
-	     srp;
-	     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
-		res = sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
-		if (likely(res == 0)) {
-			*srpp = srp;
-			WRITE_ONCE(sfp->low_await_idx, idx + 1);
-			return true;
-		}
-#if IS_ENABLED(SG_LOG_ACTIVE)
-		sg_rq_state_fail_msg(sfp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY, __func__);
-#endif
-	}
-	/* If not found so far, need to wrap around and search [0 ... end_idx) */
-	if (!srp && !second && s_idx > 0) {
-		end_idx = s_idx - 1;
-		s_idx = 0;
-		idx = s_idx;
-		second = true;
-		goto second_time;
-	}
-fini:
-	*srpp = NULL;
-	return false;
-}
-
 /*
  * Makes a new sg_request object. If 'first' is set then use GFP_KERNEL which
  * may take time but has improved chance of success, otherwise use GFP_ATOMIC.
@@ -6797,7 +6965,7 @@ static struct sg_request *
 sg_setup_req_ws_helper(struct sg_comm_wr_t *cwrp)
 {
 	int res;
-	struct sg_request *r_srp;
+	struct sg_request *rs_srp;
 	enum sg_rq_state rs_sr_st;
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_fd *rs_sfp = sg_fd_share_ptr(fp);
@@ -6810,32 +6978,94 @@ sg_setup_req_ws_helper(struct sg_comm_wr_t *cwrp)
 	 * rq_state:	SG_RQ_SHR_SWAP --> SG_RQ_SHR_IN_WS
 	 */
 	if (cwrp->rsv_idx >= 0)
-		r_srp = rs_sfp->rsv_arr[cwrp->rsv_idx];
+		rs_srp = rs_sfp->rsv_arr[cwrp->rsv_idx];
 	else
-		r_srp = sg_get_probable_read_side(rs_sfp);
-	if (unlikely(!r_srp))
+		rs_srp = sg_get_probable_read_side(rs_sfp);
+	if (unlikely(!rs_srp))
 		return ERR_PTR(-ENOSTR);
 
-	rs_sr_st = atomic_read(&r_srp->rq_st);
+	rs_sr_st = atomic_read(&rs_srp->rq_st);
 	switch (rs_sr_st) {
 	case SG_RQ_SHR_SWAP:
 		break;
 	case SG_RQ_AWAIT_RCV:
 	case SG_RQ_INFLIGHT:
-	case SG_RQ_BUSY:
-		return ERR_PTR(-EBUSY);	/* too early for write-side req */
-	case SG_RQ_INACTIVE:
-		SG_LOG(1, fp, "%s: write-side finds read-side inactive\n",
-		       __func__);
+	case SG_RQ_BUSY:	/* too early for write-side req */
+		return ERR_PTR(-EBUSY);
+	case SG_RQ_INACTIVE:	/* read-side may have ended with an error */
+		SG_LOG(1, fp, "%s: write-side finds read-side inactive\n", __func__);
 		return ERR_PTR(-EADDRNOTAVAIL);
-	case SG_RQ_SHR_IN_WS:
-		SG_LOG(1, fp, "%s: write-side find read-side shr_in_ws\n",
-		       __func__);
+	case SG_RQ_SHR_IN_WS:	/* write-side already being processed, why another? */
+		SG_LOG(1, fp, "%s: write-side find read-side shr_in_ws\n", __func__);
 		return ERR_PTR(-EADDRINUSE);
 	}
-	res = sg_rq_chg_state(r_srp, rs_sr_st, SG_RQ_SHR_IN_WS);
+	res = sg_rq_chg_state(rs_srp, rs_sr_st, SG_RQ_SHR_IN_WS);
 	if (unlikely(res))
 		return ERR_PTR(-EADDRINUSE);
+	return rs_srp;
+}
+
+static struct sg_request *
+sg_setup_req_new_srp(struct sg_comm_wr_t *cwrp, bool new_rsv_srp, bool no_reqs,
+		     bool *try_harderp)
+{
+	struct sg_fd *fp = cwrp->sfp;
+	int dlen = cwrp->dlen;
+	int res;
+	int ra_idx = 0;
+	u32 n_idx, sum_dlen;
+	unsigned long iflags;
+	struct sg_request *r_srp = NULL;
+	struct xarray *xafp = &fp->srp_arr;
+
+	if (test_bit(SG_FFD_NO_CMD_Q, fp->ffd_bm) && atomic_read(&fp->submitted) > 0) {
+		SG_LOG(6, fp, "%s: trying 2nd req but cmd_q=false\n", __func__);
+		return ERR_PTR(-EDOM);
+	} else if (fp->tot_fd_thresh > 0) {
+		sum_dlen = atomic_read(&fp->sum_fd_dlens) + dlen;
+		if (unlikely(sum_dlen > (u32)fp->tot_fd_thresh)) {
+			SG_LOG(2, fp, "%s: sum_of_dlen(%u) > tot_fd_thresh\n", __func__,
+			       sum_dlen);
+			return ERR_PTR(-E2BIG);
+		}
+	}
+	if (new_rsv_srp) {
+		ra_idx = sg_get_idx_new(fp);
+		if (ra_idx < 0) {
+			ra_idx = sg_get_idx_available(fp);
+			if (ra_idx < 0) {
+				SG_LOG(1, fp, "%s: run out of read-side reqs\n", __func__);
+				return ERR_PTR(-EFBIG);
+			}
+		}
+	}
+	r_srp = sg_mk_srp_sgat(fp, no_reqs, dlen);
+	if (IS_ERR(r_srp)) {
+		if (!*try_harderp && dlen < SG_DEF_SECTOR_SZ) {
+			*try_harderp = true;
+			return NULL;
+		}
+		return r_srp;
+	}
+	SG_LOG(4, fp, "%s: %smk_new_srp=0x%pK ++\n", __func__, (new_rsv_srp ? "rsv " : ""),
+	       r_srp);
+	if (new_rsv_srp) {
+		fp->rsv_arr[ra_idx] = r_srp;
+		set_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
+		r_srp->sh_srp = NULL;
+	}
+	xa_lock_irqsave(xafp, iflags);
+	res = __xa_alloc(xafp, &n_idx, r_srp, xa_limit_32b, GFP_ATOMIC);
+	if (unlikely(res < 0)) {
+		xa_unlock_irqrestore(xafp, iflags);
+		sg_remove_srp(r_srp);
+		kfree(r_srp);
+		SG_LOG(1, fp, "%s: xa_alloc() failed, errno=%d\n", __func__,  -res);
+		return ERR_PTR(-EPROTOTYPE);
+	}
+	r_srp->rq_idx = n_idx;
+	r_srp->parentfp = fp;
+	xa_unlock_irqrestore(xafp, iflags);
 	return r_srp;
 }
 
@@ -6855,15 +7085,12 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 	bool new_rsv_srp = false;
 	bool no_reqs = false;
 	bool ws_rq = false;
-	bool some_inactive = false;
 	bool try_harder = false;
+	bool keep_frq_bm = false;
 	bool second = false;
-	bool is_rsv;
-	int ra_idx = 0;
-	int l_used_idx;
+	int res, ra_idx, l_used_idx;
 	int dlen = cwrp->dlen;
-	u32 sum_dlen;
-	unsigned long idx, s_idx, end_idx, iflags;
+	unsigned long idx, s_idx, end_idx;
 	enum sg_rq_state sr_st;
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_request *r_srp; /* returned value won't be NULL */
@@ -6875,16 +7102,27 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 	switch (sh_var) {
 	case SG_SHR_RS_RQ:
 		cp = "rs_rq";
+		if (cwrp->possible_srp) {
+			r_srp = cwrp->possible_srp;
+			res = sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY);
+			if (unlikely(res)) {
+				r_srp = NULL;
+			} else {
+				atomic_dec(&fp->inactives);
+				keep_frq_bm = true;
+				r_srp->sh_srp = NULL;
+				goto final_setup;
+			}
+		}
 		ra_idx = (test_bit(SG_FFD_RESHARE, fp->ffd_bm)) ? 0 : sg_get_idx_available(fp);
 		if (ra_idx < 0) {
 			new_rsv_srp = true;
-			goto good_fini;
+			goto maybe_new;
 		}
 		r_srp = fp->rsv_arr[ra_idx];
-		sr_st = atomic_read(&r_srp->rq_st);
+		sr_st = atomic_read_acquire(&r_srp->rq_st);
 		if (sr_st == SG_RQ_INACTIVE) {
-			int res = sg_rq_chg_state(r_srp, sr_st, SG_RQ_BUSY);
-
+			res = sg_rq_chg_state(r_srp, sr_st, SG_RQ_BUSY);
 			if (unlikely(res)) {
 				r_srp = NULL;
 			} else {
@@ -6897,9 +7135,12 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 		}
 		if (IS_ERR(r_srp))
 			goto err_out;
-		if (mk_new_srp)
+		if (mk_new_srp) {
 			new_rsv_srp = true;
-		goto good_fini;
+			goto maybe_new;
+		} else {
+			goto final_setup;
+		}
 	case SG_SHR_WS_RQ:
 		cp = "rs_rq";
 		rs_rsv_srp = sg_setup_req_ws_helper(cwrp);
@@ -6916,6 +7157,20 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			goto err_out;
 		}
 		ws_rq = true;
+		r_srp = cwrp->possible_srp;
+		if (r_srp) {
+			sr_st = atomic_read_acquire(&r_srp->rq_st);
+			if (sr_st == SG_RQ_INACTIVE && dlen <= r_srp->sgat_h.buflen) {
+				res = sg_rq_chg_state(r_srp, sr_st, SG_RQ_BUSY);
+				if (likely(res == 0)) {
+					/* possible_srp bypasses loop to find candidate */
+					mk_new_srp = false;
+					keep_frq_bm = true;
+					goto final_setup;
+				}
+			}
+			r_srp = NULL;
+		}
 		dlen = 0;	/* any srp for write-side will do, pick smallest */
 		break;
 	case SG_SHR_RS_NOT_SRQ:
@@ -6931,9 +7186,10 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 		mk_new_srp = true;
 	} else if (atomic_read(&fp->inactives) <= 0) {
 		mk_new_srp = true;
-	} else if (likely(!try_harder) && dlen < SG_DEF_SECTOR_SZ) {
+	} else if (dlen < SG_DEF_SECTOR_SZ && likely(!try_harder)) {
 		struct sg_request *low_srp = NULL;
 
+		cp = "small dlen from inactives";
 		l_used_idx = READ_ONCE(fp->low_used_idx);
 		s_idx = (l_used_idx < 0) ? 0 : l_used_idx;
 		if (l_used_idx >= 0 && xa_get_mark(xafp, s_idx, SG_XA_RQ_INACTIVE)) {
@@ -6965,13 +7221,13 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 		if (mk_new_srp && low_srp) {	/* no candidate yet */
 			/* take non-NULL low_srp, irrespective of r_srp->sgat_h.buflen size */
 			r_srp = low_srp;
-			if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY) == 0) {
+			if (likely(sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY) == 0)) {
 				mk_new_srp = false;
 				atomic_dec(&fp->inactives);
 			}
 		}
 	} else {
-		cp = "larger from srp_arr";
+		cp = "larger dlen from inactives";
 		l_used_idx = READ_ONCE(fp->low_used_idx);
 		s_idx = (l_used_idx < 0) ? 0 : l_used_idx;
 		idx = s_idx;
@@ -6982,7 +7238,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			for (r_srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE);
 			     r_srp;
 			     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
-				if (r_srp->sgat_h.buflen >= dlen) {
+				if (dlen <= r_srp->sgat_h.buflen) {
 					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
 						continue;
 					atomic_dec(&fp->inactives);
@@ -7003,7 +7259,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			for (r_srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE);
 			     r_srp;
 			     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
-				if (r_srp->sgat_h.buflen >= dlen &&
+				if (dlen <= r_srp->sgat_h.buflen &&
 				    !test_bit(SG_FRQ_RESERVED, r_srp->frq_bm)) {
 					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
 						continue;
@@ -7023,89 +7279,34 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 		}
 	}
 have_existing:
-	if (!mk_new_srp) {
+	if (!mk_new_srp) {		/* re-using an existing sg_request object */
 		r_srp->in_resid = 0;
 		r_srp->rq_info = 0;
 		r_srp->sense_len = 0;
 	}
-
-good_fini:
+maybe_new:
 	if (mk_new_srp) {	/* Need new sg_request object */
-		bool disallow_cmd_q = test_bit(SG_FFD_NO_CMD_Q, fp->ffd_bm);
-		int res;
-		u32 n_idx;
-
 		cp = "new";
-		r_srp = NULL;
-		if (disallow_cmd_q && atomic_read(&fp->submitted) > 0) {
-			r_srp = ERR_PTR(-EDOM);
-			SG_LOG(6, fp, "%s: trying 2nd req but cmd_q=false\n",
-			       __func__);
-			goto err_out;
-		} else if (fp->tot_fd_thresh > 0) {
-			sum_dlen = atomic_read(&fp->sum_fd_dlens) + dlen;
-			if (unlikely(sum_dlen > (u32)fp->tot_fd_thresh)) {
-				r_srp = ERR_PTR(-E2BIG);
-				SG_LOG(2, fp, "%s: sum_of_dlen(%u) > %s\n",
-				       __func__, sum_dlen, "tot_fd_thresh");
-			}
-		}
-		if (!IS_ERR(r_srp) && new_rsv_srp) {
-			ra_idx = sg_get_idx_new(fp);
-			if (ra_idx < 0) {
-				ra_idx = sg_get_idx_available(fp);
-				if (ra_idx < 0) {
-					SG_LOG(1, fp,
-					       "%s: no read-side reqs available\n",
-					       __func__);
-					r_srp = ERR_PTR(-EFBIG);
-				}
-			}
-		}
-		if (IS_ERR(r_srp))	/* NULL is _not_ an ERR here */
-			goto err_out;
-		r_srp = sg_mk_srp_sgat(fp, no_reqs, dlen);
-		if (IS_ERR(r_srp)) {
-			if (!try_harder && dlen < SG_DEF_SECTOR_SZ &&
-			    some_inactive) {
-				try_harder = true;
-				goto start_again;
-			}
+		r_srp = sg_setup_req_new_srp(cwrp, new_rsv_srp, no_reqs, &try_harder);
+		if (IS_ERR(r_srp))
 			goto err_out;
-		}
-		SG_LOG(4, fp, "%s: %smk_new_srp=0x%pK ++\n", __func__,
-		       (new_rsv_srp ? "rsv " : ""), r_srp);
-		if (new_rsv_srp) {
-			fp->rsv_arr[ra_idx] = r_srp;
+		if (!r_srp && try_harder)
+			goto start_again;
+	}
+final_setup:
+	if (!keep_frq_bm) {
+		/* keep SG_FRQ_RESERVED setting from prior/new r_srp; clear rest */
+		bool is_rsv = test_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
+
+		r_srp->frq_bm[0] = 0;
+		if (is_rsv)
 			set_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
-			r_srp->sh_srp = NULL;
-		}
-		xa_lock_irqsave(xafp, iflags);
-		res = __xa_alloc(xafp, &n_idx, r_srp, xa_limit_32b, GFP_ATOMIC);
-		xa_unlock_irqrestore(xafp, iflags);
-		if (unlikely(res < 0)) {
-			xa_unlock_irqrestore(xafp, iflags);
-			sg_remove_srp(r_srp);
-			kfree(r_srp);
-			r_srp = ERR_PTR(-EPROTOTYPE);
-			SG_LOG(1, fp, "%s: xa_alloc() failed, errno=%d\n",
-			       __func__,  -res);
-			goto err_out;
-		}
-		r_srp->rq_idx = n_idx;
-		r_srp->parentfp = fp;
-		xa_unlock_irqrestore(xafp, iflags);
+		/* r_srp inherits these flags from cwrp->frq_bm */
+		if (test_bit(SG_FRQ_IS_V4I, cwrp->frq_bm))
+			set_bit(SG_FRQ_IS_V4I, r_srp->frq_bm);
+		if (test_bit(SG_FRQ_SYNC_INVOC, cwrp->frq_bm))
+			set_bit(SG_FRQ_SYNC_INVOC, r_srp->frq_bm);
 	}
-	/* keep SG_FRQ_RESERVED setting from prior/new r_srp; clear rest */
-	is_rsv = test_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
-	WRITE_ONCE(r_srp->frq_bm[0], 0);
-	if (is_rsv)
-		set_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
-	/* r_srp inherits these 3 flags from cwrp->frq_bm */
-	if (test_bit(SG_FRQ_IS_V4I, cwrp->frq_bm))
-		set_bit(SG_FRQ_IS_V4I, r_srp->frq_bm);
-	if (test_bit(SG_FRQ_SYNC_INVOC, cwrp->frq_bm))
-		set_bit(SG_FRQ_SYNC_INVOC, r_srp->frq_bm);
 	r_srp->sgatp->dlen = dlen;	/* must be <= r_srp->sgat_h.buflen */
 	r_srp->sh_var = sh_var;
 	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
@@ -7140,7 +7341,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 
 /*
  * Sets srp to SG_RQ_INACTIVE unless it was in SG_RQ_SHR_SWAP state. Also
- * change the asociated xarray entry flags to be consistent with
+ * change the associated xarray entry flags to be consistent with
  * SG_RQ_INACTIVE. Since this function can be called from many contexts,
  * then assume no xa locks held.
  * The state machine should insure that two threads should never race here.
@@ -7157,7 +7358,7 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 	SG_LOG(3, sfp, "%s: srp=%pK\n", __func__, srp);
 	sbp = srp->sense_bp;
 	srp->sense_bp = NULL;
-	sr_st = atomic_read(&srp->rq_st);
+	sr_st = atomic_read_acquire(&srp->rq_st);
 	if (sr_st != SG_RQ_SHR_SWAP) {
 		/*
 		 * Can be called from many contexts and it is hard to know
@@ -7621,17 +7822,16 @@ sg_proc_seq_show_dev(struct seq_file *s, void *v)
 
 	read_lock_irqsave(&sg_index_lock, iflags);
 	sdp = it ? sg_lookup_dev(it->index) : NULL;
-	if (unlikely(!sdp || !sdp->device || SG_IS_DETACHING(sdp)))
+	if (unlikely(!sdp || !sdp->device) || SG_IS_DETACHING(sdp)) {
 		seq_puts(s, "-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n");
-	else {
+	} else {
 		scsidp = sdp->device;
 		seq_printf(s, "%d\t%d\t%d\t%llu\t%d\t%d\t%d\t%d\t%d\n",
-			      scsidp->host->host_no, scsidp->channel,
-			      scsidp->id, scsidp->lun, (int)scsidp->type,
-			      1,
-			      (int) scsidp->queue_depth,
-			      (int) scsi_device_busy(scsidp),
-			      (int) scsi_device_online(scsidp));
+			   scsidp->host->host_no, scsidp->channel,
+			   scsidp->id, scsidp->lun, (int)scsidp->type, 1,
+			   (int)scsidp->queue_depth,
+			   (int)scsi_device_busy(scsidp),
+			   (int)scsi_device_online(scsidp));
 	}
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return 0;
@@ -7663,8 +7863,7 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 
 /* Writes debug info for one sg_request in obp buffer */
 static int
-sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, char *obp,
-		   int len)
+sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, bool inactive, char *obp, int len)
 {
 	bool is_v3v4, v4, is_dur;
 	int n = 0;
@@ -7708,6 +7907,13 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, char *obp,
 		n += scnprintf(obp + n, len - n, " sgat=%d", srp->sgatp->num_sgat);
 	cp = (srp->rq_flags & SGV4_FLAG_HIPRI) ? "hipri " : "";
 	n += scnprintf(obp + n, len - n, " %sop=0x%02x\n", cp, srp->cmd_opcode);
+	if (inactive && rq_st != SG_RQ_INACTIVE) {
+		if (xa_get_mark(&srp->parentfp->srp_arr, srp->rq_idx, SG_XA_RQ_INACTIVE))
+			cp = "still marked inactive, BAD";
+		else
+			cp = "no longer marked inactive";
+		n += scnprintf(obp + n, len - n, "       <<< xarray %s >>>\n", cp);
+	}
 	return n;
 }
 
@@ -7767,8 +7973,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 	xa_lock_irqsave(&fp->srp_arr, iflags);
 	xa_for_each(&fp->srp_arr, idx, srp) {
 		if (srp->rq_idx != (unsigned long)idx)
-			n += scnprintf(obp + n, len - n,
-				       ">>> xa_index=%lu, rq_idx=%d, bad\n",
+			n += scnprintf(obp + n, len - n, ">>> BAD: xa_index!=rq_idx [%lu,%u]\n",
 				       idx, srp->rq_idx);
 		if (xa_get_mark(&fp->srp_arr, idx, SG_XA_RQ_INACTIVE))
 			continue;
@@ -7778,8 +7983,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		else if (test_bit(SG_FRQ_ABORTING, srp->frq_bm))
 			n += scnprintf(obp + n, len - n,
 				       "     abort>> ");
-		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, obp + n,
-					len - n);
+		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, false, obp + n, len - n);
 		++k;
 		if ((k % 8) == 0) {	/* don't hold up isr_s too long */
 			xa_unlock_irqrestore(&fp->srp_arr, iflags);
@@ -7796,8 +8000,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		if (set_debug)
 			n += scnprintf(obp + n, len - n, "     rq_bm=0x%lx",
 				       srp->frq_bm[0]);
-		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns,
-					obp + n, len - n);
+		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, true, obp + n, len - n);
 		++k;
 		if ((k % 8) == 0) {	/* don't hold up isr_s too long */
 			xa_unlock_irqrestore(&fp->srp_arr, iflags);
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 148a5f2786ee..236ac4678f71 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -127,6 +127,7 @@ typedef struct sg_io_hdr {
 #define SGV4_FLAG_NO_DXFER SG_FLAG_NO_DXFER /* but keep dev<-->kernel xfr */
 #define SGV4_FLAG_KEEP_SHARE 0x20000  /* ... buffer for another dout command */
 #define SGV4_FLAG_MULTIPLE_REQS 0x40000	/* 1 or more sg_io_v4-s in data-in */
+#define SGV4_FLAG_ORDERED_WR 0x80000	/* svb: issue in-order writes */
 
 /* Output (potentially OR-ed together) in v3::info or v4::info field */
 #define SG_INFO_OK_MASK 0x1
-- 
2.25.1

