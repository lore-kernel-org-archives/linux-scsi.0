Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53427C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21509613B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhD0WBO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:01:14 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39063 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239418AbhD0WAi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 3E867204196;
        Tue, 27 Apr 2021 23:59:49 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LrPrOdO2Zrl6; Tue, 27 Apr 2021 23:59:44 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 28DB7204197;
        Tue, 27 Apr 2021 23:59:41 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 82/83] sg: pollable and non-pollable requests
Date:   Tue, 27 Apr 2021 17:57:32 -0400
Message-Id: <20210427215733.417746-84-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pollable is a new categorization of requests that implies
ioctl(SG_IORECEIVE) can be used to complete a request. This new
category displaces "sync invocation" which originally meant that
ioctl(SG_IO) had been called. However multiple requests (mrq-s)
blur the "sync invocation" picture.

Whether or not a request will complete by itself or requires
ioctl(SG_IORECEIVE) [ioctl(SG_IORECEIVE_V3) or read(2)] and
associated helpers (e.g. ioctl(SG_GET_NUM_WAITING) and poll(2)) is
better. All requests can be divided into two groups that are
termed as pollable and non-pollable. Now both groups have their
own atomic counters for requests in AWAIT_RCV state: poll_waiting
and nonp_waiting. When a user calls ioctl(SG_GET_NUM_WAITING) they
are getting the current value of poll_waiting. The nonp_waiting
value is important for the driver's internal processing (e.g. of
shared variable blocking (svb) mrq-s) but is no business of a
user doing a single async request on the same file descriptor.

Some function names where changed for clarity.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 936 ++++++++++++++++++++++++----------------------
 1 file changed, 487 insertions(+), 449 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 773843a14038..5328befc0893 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -110,6 +110,12 @@ enum sg_shr_var {
 	SG_SHR_WS_RQ,		/* write-side sharing on this data carrying req */
 };
 
+enum sg_search_srp {
+	SG_SEARCH_ANY = 0,	/* searching unconstrained by pack_id or tag */
+	SG_SEARCH_BY_PACK_ID,
+	SG_SEARCH_BY_TAG,
+};
+
 /* If sum_of(dlen) of a fd exceeds this, write() will yield E2BIG */
 #define SG_TOT_FD_THRESHOLD (32 * 1024 * 1024)
 
@@ -124,10 +130,9 @@ enum sg_shr_var {
 #define SG_MAX_RSV_REQS 8	/* number of svb requests done asynchronously; assume small-ish */
 
 #define SG_PACK_ID_WILDCARD (-1)
-#define SG_TAG_WILDCARD (-1)
+#define SG_TAG_WILDCARD SG_PACK_ID_WILDCARD
 
 #define SG_ADD_RQ_MAX_RETRIES 40	/* to stop infinite _trylock(s) */
-#define SG_DEF_BLK_POLL_LOOP_COUNT 1000	/* may allow user to tweak this */
 
 /* Bit positions (flags) for sg_request::frq_lt_bm bitmask, lt: long term */
 #define SG_FRQ_LT_RESERVED	0	/* marks a reserved request */
@@ -136,16 +141,15 @@ enum sg_shr_var {
 /* Bit positions (flags) for sg_request::frq_pc_bm bitmask. pc: per command */
 #define SG_FRQ_PC_IS_V4I	0	/* true (set) when is v4 interface */
 #define SG_FRQ_PC_IS_ORPHAN	1	/* owner of request gone */
-#define SG_FRQ_PC_SYNC_INVOC	2	/* synchronous (blocking) invocation */
+#define SG_FRQ_PC_POLLABLE	2	/* sg_ioreceive may be called */
 #define SG_FRQ_PC_US_XFER	3	/* kernel<-->user_space data transfer */
 #define SG_FRQ_PC_ABORTING	4	/* in process of aborting this cmd */
 #define SG_FRQ_PC_DEACT_ORPHAN	5	/* not keeping orphan so de-activate */
 #define SG_FRQ_PC_RECEIVING	6	/* guard against multiple receivers */
 #define SG_FRQ_PC_FOR_MMAP	7	/* request needs PAGE_SIZE elements */
-#define SG_FRQ_PC_COUNT_ACTIVE	8	/* sfp->submitted + waiting active */
-#define SG_FRQ_PC_ISSUED	9	/* blk_execute_rq_nowait() finished */
-#define SG_FRQ_POLL_SLEPT	10	/* stop re-entry of hybrid_sleep() */
-#define SG_FRQ_PC_PART_MRQ	11	/* this cmd part of mrq array */
+#define SG_FRQ_PC_ISSUED	8	/* blk_execute_rq_nowait() finished */
+#define SG_FRQ_POLL_SLEPT	9	/* stop re-entry of hybrid_sleep() */
+#define SG_FRQ_PC_PART_MRQ	10	/* this cmd part of mrq array */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
@@ -164,6 +168,7 @@ enum sg_shr_var {
 #define SG_FFD_SVB_ACTIVE	13	/* shared variable blocking active */
 #define SG_FFD_RESHARE		14	/* reshare limits to single rsv req */
 #define SG_FFD_CAN_REUSE_BIO	15	/* uniform svb --> can re-use bio_s */
+#define SG_FFD_SIG_PEND		16	/* (fatal) signal pending */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -294,7 +299,8 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	int low_await_idx;	/* previous or lower await index */
 	u32 idx;		/* my index within parent's sfp_arr */
 	atomic_t submitted;	/* number inflight or awaiting receive */
-	atomic_t waiting;	/* number of requests awaiting receive */
+	atomic_t poll_waiting;	/* # of pollable requests awaiting receive */
+	atomic_t nonp_waiting;	/* # of non-pollable requests awaiting rcv */
 	atomic_t inactives;	/* number of inactive requests */
 	atomic_t sum_fd_dlens;	/* when tot_fd_thresh>0 this is sum_of(dlen) */
 	atomic_t mrq_id_abort;	/* inactive when 0, else id if aborted */
@@ -314,6 +320,15 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	struct sg_request *rsv_arr[SG_MAX_RSV_REQS];
 };
 
+struct sg_fd_pollable {		/* sfp plus adds context for completions */
+	struct sg_fd *fp;
+	bool pollable;		/* can async machinery find this req ? */
+	bool immed;		/* immed set on ioctl(sg_ioreceive) ? */
+	bool part_mrq;
+	enum sg_search_srp find_by;
+	int pack_id_tag;
+};
+
 struct sg_device { /* holds the state of each scsi generic device */
 	struct scsi_device *device;
 	wait_queue_head_t open_wait;    /* queue open() when O_EXCL present */
@@ -349,9 +364,9 @@ struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 };
 
 struct sg_mrq_hold {	/* for passing context between multiple requests (mrq) functions */
-	unsigned from_sg_io:1;
 	unsigned chk_abort:1;
-	unsigned immed:1;
+	unsigned immed:1;	/* may differ between sg_iosubmit and sg_ioreceive */
+	unsigned pollable:1;	/* same as immed bit during submission */
 	unsigned stop_if:1;
 	unsigned co_mmap:1;
 	unsigned ordered_wr:1;
@@ -393,7 +408,7 @@ static void sg_remove_srp(struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp, struct file *filp);
 static void sg_remove_sfp(struct kref *);
 static void sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side);
-static struct sg_request *sg_get_srp_by_id(struct sg_fd *sfp, int id, bool is_tag, bool part_mrq);
+static struct sg_request *sg_find_srp_from(struct sg_fd_pollable *sfp_p);
 static struct sg_request *sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int min_dev);
@@ -404,9 +419,8 @@ static int sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
 			   enum sg_rq_state new_st);
 static int sg_finish_rs_rq(struct sg_fd *sfp, struct sg_request *rs_srp, bool even_if_in_ws);
 static void sg_rq_chg_state_force(struct sg_request *srp, enum sg_rq_state new_st);
-static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);
-static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q,
-			     int loop_count);
+static int sg_sfp_blk_poll_first(struct sg_fd *sfp);
+static int sg_sfp_blk_poll_all(struct sg_fd *sfp, int loop_count);
 
 #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)
 static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
@@ -919,6 +933,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 			 current->comm, "not setting count and/or reply_len properly");
 	}
 	sg_comm_wr_init(&cwr);
+	__set_bit(SG_FRQ_PC_POLLABLE, cwr.frq_pc_bm);
 	cwr.h3p = h3p;
 	cwr.dlen = h3p->dxfer_len;
 	cwr.timeout = sfp->timeout;
@@ -990,7 +1005,8 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync, struct sg_reque
 		clear_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(hp->timeout);
 	sg_comm_wr_init(&cwr);
-	__assign_bit(SG_FRQ_PC_SYNC_INVOC, cwr.frq_pc_bm, (int)sync);
+	if (hp->flags & SGV4_FLAG_IMMED)
+		__set_bit(SG_FRQ_PC_POLLABLE, cwr.frq_pc_bm);
 	cwr.h3p = hp;
 	cwr.dlen = hp->dxfer_len;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
@@ -1152,79 +1168,17 @@ sg_side_str(struct sg_request *srp)
 }
 
 static inline int
-sg_num_waiting_maybe_acquire(struct sg_fd *sfp)
+sg_num_waiting_maybe_acquire(struct sg_fd_pollable *sfp_p)
 {
-	int num = atomic_read(&sfp->waiting);
+	struct sg_fd *fp = sfp_p->fp;
+	atomic_t *ap = sfp_p->pollable ? &fp->poll_waiting : &fp->nonp_waiting;
+	int num = atomic_read(ap);
 
 	if (num < 1)
-		num = atomic_read_acquire(&sfp->waiting);
+		num = atomic_read_acquire(ap);
 	return num;
 }
 
-/*
- * Looks for request in SG_RQ_AWAIT_RCV state on given fd that matches part_mrq. The first one
- * found is placed in SG_RQ_BUSY state and its address is returned. If none found returns NULL.
- */
-static struct sg_request *
-sg_get_any_srp(struct sg_fd *sfp, bool part_mrq)
-{
-	bool second = false;
-	int l_await_idx = READ_ONCE(sfp->low_await_idx);
-	unsigned long idx, s_idx, end_idx;
-	struct sg_request *srp;
-	struct xarray *xafp = &sfp->srp_arr;
-
-	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
-	idx = s_idx;
-	end_idx = ULONG_MAX;
-second_time:
-	for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
-	     srp;
-	     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
-		if (part_mrq != test_bit(SG_FRQ_PC_PART_MRQ, srp->frq_pc_bm))
-			continue;
-		if (likely(sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY) == 0)) {
-			WRITE_ONCE(sfp->low_await_idx, idx + 1);
-			return srp;
-		}
-	}
-	/* If not found so far, need to wrap around and search [0 ... s_idx) */
-	if (!srp && !second && s_idx > 0) {
-		end_idx = s_idx - 1;
-		s_idx = 0;
-		idx = s_idx;
-		second = true;
-		goto second_time;
-	}
-	return NULL;
-}
-
-/*
- * Returns true if a request is ready and its srp is written to *srpp . If nothing can be found
- * returns false and NULL --> *srpp . If an error is detected returns true with IS_ERR(*srpp)
- * also being true.
- */
-static bool
-sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
-{
-	if (SG_IS_DETACHING(sfp->parentdp)) {
-		*srpp = ERR_PTR(-ENODEV);
-		return true;
-	}
-	if (sg_num_waiting_maybe_acquire(sfp) < 1) {
-		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm)) {
-			int res = sg_sfp_blk_poll(sfp, 1);
-
-			if (res < 0) {
-				*srpp = ERR_PTR(res);
-				return true;
-			}
-		}
-	}
-	*srpp = sg_get_any_srp(sfp, true);
-	return !!*srpp;
-}
-
 /* N.B. After this function is completed what srp points to should be considered invalid. */
 static int
 sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_request *srp)
@@ -1271,30 +1225,45 @@ sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_request *srp)
 	return 0;
 }
 
+/*
+ * This function wraps sg_find_srp_from() so it can be called as a predicate for
+ * wait_event_interruptible().
+ */
+static bool
+sg_find_srp_pred(struct sg_fd_pollable *sfp_p, struct sg_request **srpp)
+{
+	struct sg_request *srp;
+	struct sg_fd *fp = sfp_p->fp;
+
+	if (SG_IS_DETACHING(fp->parentdp))
+		srp = ERR_PTR(-ENODEV);
+	else
+		srp = sg_find_srp_from(sfp_p);
+	*srpp = srp;	/* Warning: IS_ERR(srp) may also be true */
+	return !!srp;
+}
+
 static int
-sg_wait_any_mrq(struct sg_fd *sfp, struct sg_mrq_hold *mhp, struct sg_request **srpp)
+sg_wait_any_mrq(struct sg_fd_pollable *sfp_p, struct sg_mrq_hold *mhp, struct sg_request **srpp)
 {
-	bool hipri = mhp->hipri || test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
+	struct sg_fd *fp = sfp_p->fp;
+	bool hipri = mhp->hipri || test_bit(SG_FFD_HIPRI_SEEN, fp->ffd_bm);
+	int res;
 
 	if (hipri) {
 		long state = current->state;
 		struct sg_request *srp;
 
+		set_bit(SG_FFD_HIPRI_SEEN, fp->ffd_bm);
 		do {
-			if (hipri) {
-				int res = sg_sfp_blk_poll(sfp, SG_DEF_BLK_POLL_LOOP_COUNT);
-
-				if (res < 0)
-					return res;
-			}
-			srp = sg_get_any_srp(sfp, true);
+			srp = sg_find_srp_from(sfp_p);
 			if (IS_ERR(srp))
 				return PTR_ERR(srp);
 			if (srp) {
 				__set_current_state(TASK_RUNNING);
 				break;
 			}
-			if (SG_IS_DETACHING(sfp->parentdp)) {
+			if (SG_IS_DETACHING(fp->parentdp)) {
 				__set_current_state(TASK_RUNNING);
 				return -ENODEV;
 			}
@@ -1307,10 +1276,20 @@ sg_wait_any_mrq(struct sg_fd *sfp, struct sg_mrq_hold *mhp, struct sg_request **
 		*srpp = srp;
 		return 0;
 	}
-	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm))
-		return __wait_event_interruptible_exclusive(sfp->cmpl_wait,
-							    sg_mrq_get_ready_srp(sfp, srpp));
-	return __wait_event_interruptible(sfp->cmpl_wait, sg_mrq_get_ready_srp(sfp, srpp));
+	if (test_bit(SG_FFD_EXCL_WAITQ, fp->ffd_bm))
+		res = __wait_event_interruptible_exclusive
+				(fp->cmpl_wait, sg_find_srp_pred(sfp_p, srpp));
+	else
+		res = __wait_event_interruptible(fp->cmpl_wait, sg_find_srp_pred(sfp_p, srpp));
+	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
+		set_bit(SG_FFD_SIG_PEND, fp->ffd_bm);
+		SG_LOG(1, fp, "%s:  wait_event_interruptible(): %s[%d]\n", __func__,
+		       (res == -ERESTARTSYS ? "ERESTARTSYS" : ""), res);
+		return res;
+	}
+	if (SG_IS_DETACHING(fp->parentdp))
+		return -ENODEV;
+	return 0;
 }
 
 static inline bool
@@ -1324,19 +1303,24 @@ sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
  * SGV4_FLAG_HIPRI is set this functions goes into a polling loop.
  */
 static int
-sg_poll_wait4_given_srp(struct sg_fd *sfp, struct sg_request *srp)
+sg_poll_wait4_given_srp(struct sg_fd_pollable *sfp_p, struct sg_request *srp)
 {
 	int res;
-	struct sg_device *sdp = sfp->parentdp;
+	struct sg_fd *fp = sfp_p->fp;
+	struct sg_device *sdp = fp->parentdp;
 
 	if (srp->rq_flags & SGV4_FLAG_HIPRI) {
 		long state = current->state;
+		struct request_queue *q = sdp->device->request_queue;
 
-		SG_LOG(3, sfp, "%s: polling\n", __func__);
+		SG_LOG(3, fp, "%s: polling\n", __func__);
 		do {
-			res = sg_srp_q_blk_poll(srp, sdp->device->request_queue,
-						SG_DEF_BLK_POLL_LOOP_COUNT);
-			if (res == -ENODATA || res > 0) {
+			if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT) {
+				__set_current_state(TASK_RUNNING);
+				break;
+			}
+			res = blk_poll(q, srp->cookie, false /* do not spin */);
+			if (res > 0 && atomic_read(&srp->rq_st) == SG_RQ_AWAIT_RCV) {
 				__set_current_state(TASK_RUNNING);
 				break;
 			}
@@ -1355,47 +1339,55 @@ sg_poll_wait4_given_srp(struct sg_fd *sfp, struct sg_request *srp)
 			cpu_relax();
 		} while (true);
 	} else {
-		SG_LOG(3, sfp, "%s: wait_event\n", __func__);
+		SG_LOG(3, fp, "%s: wait_event\n", __func__);
 		/* N.B. The SG_FFD_EXCL_WAITQ flag is ignored here. */
-		res = __wait_event_interruptible(sfp->cmpl_wait, sg_rq_landed(sdp, srp));
+		res = __wait_event_interruptible(fp->cmpl_wait, sg_rq_landed(sdp, srp));
 		if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
-			set_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm);
-			/* orphans harvested when sfp->keep_orphan is false */
-			sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
-			SG_LOG(1, sfp, "%s:  wait_event_interruptible(): %s[%d]\n", __func__,
+			set_bit(SG_FFD_SIG_PEND, fp->ffd_bm);
+			/* pollable requests may be harvested */
+			SG_LOG(1, fp, "%s:  wait_event_interruptible(): %s[%d]\n", __func__,
 			       (res == -ERESTARTSYS ? "ERESTARTSYS" : ""), res);
 			return res;
 		}
 	}
 	if (atomic_read_acquire(&srp->rq_st) != SG_RQ_AWAIT_RCV)
-		return (test_bit(SG_FRQ_PC_COUNT_ACTIVE, srp->frq_pc_bm) &&
-			atomic_read(&sfp->submitted) < 1) ? -ENODATA : 0;
+		return (atomic_read(&fp->submitted) < 1) ? -ENODATA : 0;
 	return unlikely(sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY)) ? -EPROTO : 0;
 
 detaching:
 	sg_rq_chg_state_force(srp, SG_RQ_INACTIVE);
-	atomic_inc(&sfp->inactives);
+	atomic_inc(&fp->inactives);
 	return -ENODEV;
 }
 
 static struct sg_request *
-sg_mrq_poll_either(struct sg_fd *sfp, struct sg_fd *sec_sfp, bool *on_sfp)
+sg_mrq_poll_either(struct sg_fd_pollable *sfp_p, struct sg_fd *sec_sfp, bool *on_first)
 {
 	long state = current->state;
+	struct sg_fd *fp = sfp_p->fp;
 	struct sg_request *srp;
+	struct sg_fd_pollable a_sfpoll = *sfp_p;
 
-	do {		/* alternating polling loop */
-		if (sfp) {
-			if (sg_mrq_get_ready_srp(sfp, &srp)) {
+	do {		/* first poll read-side, then poll write-side */
+		if (fp) {
+			a_sfpoll.fp = fp;
+			srp = sg_find_srp_from(&a_sfpoll);
+			if (IS_ERR(srp))
+				return srp;
+			if (srp) {
 				__set_current_state(TASK_RUNNING);
-				*on_sfp = true;
+				*on_first = true;
 				return srp;
 			}
 		}
-		if (sec_sfp && sfp != sec_sfp) {
-			if (sg_mrq_get_ready_srp(sec_sfp, &srp)) {
+		if (sec_sfp && fp != sec_sfp) {
+			a_sfpoll.fp = sec_sfp;
+			srp = sg_find_srp_from(&a_sfpoll);
+			if (IS_ERR(srp))
+				return srp;
+			if (srp) {
 				__set_current_state(TASK_RUNNING);
-				*on_sfp = false;
+				*on_first = false;
 				return srp;
 			}
 		}
@@ -1412,26 +1404,36 @@ sg_mrq_poll_either(struct sg_fd *sfp, struct sg_fd *sec_sfp, bool *on_sfp)
  * main fd over the secondary fd (sec_sfp). Increments cop->info for each successful completion.
  */
 static int
-sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sfp, int mreqs,
-		int sec_reqs)
+sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd_pollable *sfp_p, struct sg_fd *sec_sfp,
+		int mreqs, int sec_reqs)
 {
-	bool on_sfp;
+	bool on_first;
 	int res;
 	struct sg_request *srp;
+	struct sg_fd *fp = sfp_p->fp;
+	struct sg_fd_pollable a_sfpoll = *sfp_p;
 
-	SG_LOG(3, sfp, "%s: mreqs=%d, sec_reqs=%d\n", __func__, mreqs, sec_reqs);
+	SG_LOG(3, fp, "%s: mreqs=%d, sec_reqs=%d\n", __func__, mreqs, sec_reqs);
 	while (mreqs + sec_reqs > 0) {
-		while (mreqs > 0 && sg_mrq_get_ready_srp(sfp, &srp)) {
+		while (mreqs > 0) {
+			a_sfpoll.fp = fp;
+			srp = sg_find_srp_from(&a_sfpoll);
 			if (IS_ERR(srp))
 				return PTR_ERR(srp);
+			if (!srp)
+				break;
 			--mreqs;
 			res = sg_mrq_1complet(mhp, srp);
 			if (unlikely(res))
 				return res;
 		}
-		while (sec_reqs > 0 && sg_mrq_get_ready_srp(sec_sfp, &srp)) {
+		while (sec_reqs > 0) {
+			a_sfpoll.fp = sec_sfp;
+			srp = sg_find_srp_from(&a_sfpoll);
 			if (IS_ERR(srp))
 				return PTR_ERR(srp);
+			if (!srp)
+				break;
 			--sec_reqs;
 			res = sg_mrq_1complet(mhp, srp);
 			if (unlikely(res))
@@ -1442,7 +1444,8 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sf
 		if (res)
 			break;
 		if (mreqs > 0) {
-			res = sg_wait_any_mrq(sfp, mhp, &srp);
+			a_sfpoll.fp = fp;
+			res = sg_wait_any_mrq(&a_sfpoll, mhp, &srp);
 			if (unlikely(res))
 				return res;	/* signal --> -ERESTARTSYS */
 			if (IS_ERR(srp)) {
@@ -1455,7 +1458,8 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sf
 			}
 		}
 		if (sec_reqs > 0) {
-			res = sg_wait_any_mrq(sec_sfp, mhp, &srp);
+			a_sfpoll.fp = sec_sfp;
+			res = sg_wait_any_mrq(&a_sfpoll, mhp, &srp);
 			if (unlikely(res))
 				return res;	/* signal --> -ERESTARTSYS */
 			if (IS_ERR(srp)) {
@@ -1471,10 +1475,11 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sf
 	return 0;
 start_polling:
 	while (mreqs + sec_reqs > 0) {
-		srp = sg_mrq_poll_either(sfp, sec_sfp, &on_sfp);
+		a_sfpoll.fp = fp;
+		srp = sg_mrq_poll_either(&a_sfpoll, sec_sfp, &on_first);
 		if (IS_ERR(srp))
 			return PTR_ERR(srp);
-		if (on_sfp) {
+		if (on_first) {
 			--mreqs;
 			res = sg_mrq_1complet(mhp, srp);
 			if (unlikely(res))
@@ -1662,7 +1667,7 @@ sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_in_rq_arr,
 	r_cwrp->cmd_len = hp->request_len;
 	r_cwrp->rsv_idx = rsv_idx;
 	ul_timeout = msecs_to_jiffies(hp->timeout);
-	__assign_bit(SG_FRQ_PC_SYNC_INVOC, r_cwrp->frq_pc_bm, (int)mhp->from_sg_io);
+	__assign_bit(SG_FRQ_PC_POLLABLE, r_cwrp->frq_pc_bm, (int)mhp->pollable);
 	__set_bit(SG_FRQ_PC_IS_V4I, r_cwrp->frq_pc_bm);
 	__set_bit(SG_FRQ_PC_PART_MRQ, r_cwrp->frq_pc_bm);
 	r_cwrp->h4p = hp;
@@ -1680,7 +1685,7 @@ sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_in_rq_arr,
  * is processed in sg_process_svb_mrq().
  */
 static int
-sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp)
+sg_process_most_mrq(struct sg_fd_pollable *sfp_p, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp)
 {
 	int flags, j;
 	int num_subm = 0;
@@ -1693,6 +1698,8 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *m
 	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 	struct sg_io_v4 *hp;		/* ptr to request object in a_hds */
 	struct sg_request *srp;
+	struct sg_fd *fp = sfp_p->fp;
+	struct sg_fd_pollable a_sfpoll = *sfp_p;
 
 	SG_LOG(3, fp, "%s: id_of_mrq=%d, tot_reqs=%d, enter\n", __func__, mhp->id_of_mrq,
 	       mhp->tot_reqs);
@@ -1713,14 +1720,15 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *m
 		srp->s_hdr4.mrq_ind = num_subm++;
 		if (mhp->chk_abort)
 			atomic_set(&srp->s_hdr4.pack_id_of_mrq, mhp->id_of_mrq);
-		if (mhp->immed || (!(mhp->from_sg_io || (flags & shr_complet_b4)))) {
+		if (mhp->immed || !(flags & shr_complet_b4)) {
 			if (fp == rq_sfp)
 				++this_fp_sent;
 			else
 				++other_fp_sent;
 			continue;  /* defer completion until all submitted */
 		}
-		res = sg_poll_wait4_given_srp(rq_sfp, srp);
+		a_sfpoll.fp = rq_sfp;
+		res = sg_poll_wait4_given_srp(&a_sfpoll, srp);
 		if (unlikely(res)) {
 			mhp->s_res = res;
 			if (res == -ERESTARTSYS || res == -ENODEV)
@@ -1744,8 +1752,9 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *m
 	if (mhp->immed)
 		return res;
 	if (likely(res == 0 && (this_fp_sent + other_fp_sent) > 0)) {
-		res = sg_mrq_complets(mhp, fp, o_sfp, this_fp_sent, other_fp_sent);
-		if (res)
+		a_sfpoll.fp = fp;
+		res = sg_mrq_complets(mhp, &a_sfpoll, o_sfp, this_fp_sent, other_fp_sent);
+		if (unlikely(res))
 			mhp->s_res = res;	/* this may leave orphans */
 	}
 	if (mhp->id_of_mrq)	/* can no longer do a mrq abort */
@@ -1781,8 +1790,8 @@ sg_svb_zero_elem(struct sg_svb_elem *svb_ap, int m)
 
 /* For multiple requests (mrq) share variable blocking (svb) with no SGV4_FLAG_ORDERED_WR */
 static int
-sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp, int ra_ind,
-		      int *num_submp)
+sg_svb_mrq_first_come(struct sg_fd_pollable *sfp_p, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp,
+		      int ra_ind, int *num_submp)
 {
 	bool chk_oth_first = false;
 	bool stop_triggered = false;
@@ -1795,6 +1804,8 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 	struct sg_io_v4 *hp = mhp->a_hds + ra_ind;
 	struct sg_request *srp;
 	struct sg_request *rs_srp;
+	struct sg_fd *fp = sfp_p->fp;
+	struct sg_fd_pollable a_sfpoll = *sfp_p;
 	struct sg_svb_elem svb_arr[SG_MAX_RSV_REQS];
 
 	memset(svb_arr, 0, sizeof(svb_arr));
@@ -1842,24 +1853,35 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 	 * memory leaks. We must wait for inflight requests to complete before final cleanup.
 	 */
 	for (k = 0; k < sent; ++k) {
-		if (other_fp_sent > 0 && sg_mrq_get_ready_srp(o_sfp, &srp)) {
+		a_sfpoll.fp = o_sfp;
+		if (other_fp_sent > 0) {
+			a_sfpoll.fp = o_sfp;
+			srp = sg_find_srp_from(&a_sfpoll);
 			if (IS_ERR(srp)) {
 				mhp->s_res = PTR_ERR(srp);
 				continue;
-			}
+			} else if (srp) {
 other_found:
-			--other_fp_sent;
-			m_ind = srp->s_hdr4.mrq_ind;
-			res = sg_mrq_1complet(mhp, srp);
-			if (unlikely(res || !sg_v4_cmd_good(mhp->a_hds + m_ind)))
-				stop_triggered = sg_svb_err_process(mhp, m_ind, o_sfp, res, false);
-			continue;  /* do available submits first */
+				--other_fp_sent;
+				m_ind = srp->s_hdr4.mrq_ind;
+				res = sg_mrq_1complet(mhp, srp);
+				if (unlikely(res || !sg_v4_cmd_good(mhp->a_hds + m_ind)))
+					stop_triggered = sg_svb_err_process(mhp, m_ind, o_sfp, res,
+									    false);
+				continue;  /* do available submits first */
+			}
 		}
-		if (this_fp_sent > 0 && sg_mrq_get_ready_srp(fp, &srp)) {
+		if (this_fp_sent > 0) {
+			a_sfpoll.fp = fp;
+			srp = sg_find_srp_from(&a_sfpoll);
 			if (IS_ERR(srp)) {
 				mhp->s_res = PTR_ERR(srp);
 				continue;
 			}
+		} else {
+			srp = NULL;
+		}
+		if (srp) {
 this_found:
 			--this_fp_sent;
 			dir = srp->s_hdr4.dir;
@@ -1922,7 +1944,8 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 			goto oth_first;
 this_second:
 		if (this_fp_sent > 0) {
-			res = sg_wait_any_mrq(fp, mhp, &srp);
+			a_sfpoll.fp = fp;
+			res = sg_wait_any_mrq(&a_sfpoll, mhp, &srp);
 			if (unlikely(res))
 				mhp->s_res = res;
 			else if (IS_ERR(srp))
@@ -1934,7 +1957,8 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 			continue;
 oth_first:
 		if (other_fp_sent > 0) {
-			res = sg_wait_any_mrq(o_sfp, mhp, &srp);
+			a_sfpoll.fp = o_sfp;
+			res = sg_wait_any_mrq(&a_sfpoll, mhp, &srp);
 			if (unlikely(res))
 				mhp->s_res = res;
 			else if (IS_ERR(srp))
@@ -1954,8 +1978,8 @@ sg_svb_mrq_first_come(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold
 }
 
 static int
-sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp, int ra_ind,
-		   int *num_submp)
+sg_svb_mrq_ordered(struct sg_fd_pollable *sfp_p, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp,
+		   int ra_ind, int *num_submp)
 {
 	bool stop_triggered = false;
 	bool rs_fail;
@@ -1966,6 +1990,8 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 	struct sg_io_v4 *hp = mhp->a_hds + ra_ind;
 	struct sg_request *srp;
 	struct sg_request *rs_srp;
+	struct sg_fd *fp = sfp_p->fp;
+	struct sg_fd_pollable a_sfpoll = *sfp_p;
 	struct sg_svb_elem svb_arr[SG_MAX_RSV_REQS];
 
 	memset(svb_arr, 0, sizeof(svb_arr));
@@ -2013,7 +2039,8 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 		rs_srp = svb_arr[m].rs_srp;
 		if (!rs_srp)
 			continue;
-		res = sg_poll_wait4_given_srp(fp, rs_srp);
+		a_sfpoll.fp = fp;
+		res = sg_poll_wait4_given_srp(&a_sfpoll, rs_srp);
 		if (unlikely(res))
 			mhp->s_res = res;
 		--this_fp_sent;
@@ -2057,7 +2084,8 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 	}
 	while (this_fp_sent > 0) {	/* non-data requests */
 		--this_fp_sent;
-		res = sg_wait_any_mrq(fp, mhp, &srp);
+		a_sfpoll.fp = fp;
+		res = sg_wait_any_mrq(&a_sfpoll, mhp, &srp);
 		if (unlikely(res)) {
 			mhp->s_res = res;
 			continue;
@@ -2073,7 +2101,8 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 	}
 	while (other_fp_sent > 0) {
 		--other_fp_sent;
-		res = sg_wait_any_mrq(o_sfp, mhp, &srp);
+		a_sfpoll.fp = o_sfp;
+		res = sg_wait_any_mrq(&a_sfpoll, mhp, &srp);
 		if (unlikely(res)) {
 			mhp->s_res = res;
 			continue;
@@ -2128,7 +2157,7 @@ sg_svb_cleanup(struct sg_fd *sfp)
  * per fd" rule is enforced by the SG_FFD_SVB_ACTIVE file descriptor flag.
  */
 static int
-sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp)
+sg_process_svb_mrq(struct sg_fd_pollable *sfp_p, struct sg_fd *o_sfp, struct sg_mrq_hold *mhp)
 {
 	bool aborted = false;
 	int j, delta_subm, subm_before, cmpl_before;
@@ -2136,6 +2165,7 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 	int num_cmpl = 0;
 	int res = 0;
 	struct sg_io_v4 *cop = mhp->cwrp->h4p;
+	struct sg_fd *fp = sfp_p->fp;
 
 	SG_LOG(3, fp, "%s: id_of_mrq=%d, tot_reqs=%d, enter\n", __func__, mhp->id_of_mrq,
 	       mhp->tot_reqs);
@@ -2153,9 +2183,9 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 		subm_before = num_subm;
 		cmpl_before = cop->info;
 		if (mhp->ordered_wr)
-			res = sg_svb_mrq_ordered(fp, o_sfp, mhp, j, &num_subm);
+			res = sg_svb_mrq_ordered(sfp_p, o_sfp, mhp, j, &num_subm);
 		else	/* write-side request done on first come, first served basis */
-			res = sg_svb_mrq_first_come(fp, o_sfp, mhp, j, &num_subm);
+			res = sg_svb_mrq_first_come(sfp_p, o_sfp, mhp, j, &num_subm);
 		delta_subm = num_subm - subm_before;
 		num_cmpl += (cop->info - cmpl_before);
 		if (res || delta_subm == 0)	/* error or didn't make progress */
@@ -2221,8 +2251,9 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 #if IS_ENABLED(SG_LOG_ACTIVE)
 	const char *mrq_vs;
 #endif
+	struct sg_fd_pollable a_sfpoll;
 
-	if (unlikely(SG_IS_DETACHING(fp->parentdp) || (o_sfp && SG_IS_DETACHING(o_sfp->parentdp))))
+	if (SG_IS_DETACHING(fp->parentdp) || (o_sfp && SG_IS_DETACHING(o_sfp->parentdp)))
 		return -ENODEV;
 	if (unlikely(tot_reqs == 0))
 		return 0;
@@ -2244,13 +2275,13 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	if (unlikely(din_len > SG_MAX_MULTI_REQ_SZ || dout_len > SG_MAX_MULTI_REQ_SZ))
 		return  -E2BIG;
 	mhp->cwrp = cwrp;
-	mhp->from_sg_io = from_sg_io; /* false if from SG_IOSUBMIT */
 #if IS_ENABLED(SG_LOG_ACTIVE)
 	mrq_vs = sg_mrq_var_str(from_sg_io, cop->flags);
 #endif
 	f_non_block = !!(fp->filp->f_flags & O_NONBLOCK);
 	is_svb = !!(cop->flags & SGV4_FLAG_SHARE);	/* via ioctl(SG_IOSUBMIT) only */
 	mhp->immed = !!(cop->flags & SGV4_FLAG_IMMED);
+	mhp->pollable = mhp->immed;
 	mhp->hipri = !!(cop->flags & SGV4_FLAG_HIPRI);
 	mhp->stop_if = !!(cop->flags & SGV4_FLAG_STOP_IF);
 	if (unlikely(mhp->immed && mhp->stop_if))
@@ -2264,6 +2295,12 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	mhp->tot_reqs = tot_reqs;
 	mhp->s_res = 0;
 	mhp->dtd_errs = 0;
+	a_sfpoll.fp = fp;
+	a_sfpoll.pollable = mhp->immed;
+	a_sfpoll.immed = mhp->immed;
+	a_sfpoll.part_mrq = true;
+	a_sfpoll.find_by = SG_SEARCH_ANY;
+	a_sfpoll.pack_id_tag = -1;
 	if (mhp->id_of_mrq) {
 		int existing_id = atomic_cmpxchg(&fp->mrq_id_abort, 0, mhp->id_of_mrq);
 
@@ -2358,9 +2395,9 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 		clear_bit(SG_FFD_NO_CMD_Q, o_sfp->ffd_bm);
 
 	if (is_svb)
-		res = sg_process_svb_mrq(fp, o_sfp, mhp);
+		res = sg_process_svb_mrq(&a_sfpoll, o_sfp, mhp);
 	else
-		res = sg_process_most_mrq(fp, o_sfp, mhp);
+		res = sg_process_most_mrq(&a_sfpoll, o_sfp, mhp);
 fini:
 	if (!mhp->immed) {		/* for the blocking mrq invocations */
 		int rres = sg_mrq_arr_flush(mhp);
@@ -2417,8 +2454,9 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p, bool from_
 		clear_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(h4p->timeout);
 	cwr.sfp = sfp;
-	__assign_bit(SG_FRQ_PC_SYNC_INVOC, cwr.frq_pc_bm, (int)from_sg_io);
 	__set_bit(SG_FRQ_PC_IS_V4I, cwr.frq_pc_bm);
+	if (h4p->flags & SGV4_FLAG_IMMED)
+		__set_bit(SG_FRQ_PC_POLLABLE, cwr.frq_pc_bm);
 	cwr.h4p = h4p;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	cwr.cmd_len = h4p->request_len;
@@ -2831,15 +2869,12 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 
 	kref_get(&sfp->f_ref); /* put usually in: sg_rq_end_io() */
 	sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
-	/* >>>>>>> send cmd/req off to other levels <<<<<<<< */
-	if (!test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm)) {
-		atomic_inc(&sfp->submitted);
-		set_bit(SG_FRQ_PC_COUNT_ACTIVE, srp->frq_pc_bm);
-	}
+	atomic_inc(&sfp->submitted);
 	if (srp->rq_flags & SGV4_FLAG_HIPRI) {
 		rqq->cmd_flags |= REQ_HIPRI;
 		srp->cookie = request_to_qc_t(rqq->mq_hctx, rqq);
 	}
+	/* >>>>>>> send cmd/req off to other levels <<<<<<<< */
 	blk_execute_rq_nowait(sdp->disk, rqq, (int)at_head, sg_rq_end_io);
 	set_bit(SG_FRQ_PC_ISSUED, srp->frq_pc_bm);
 }
@@ -2948,38 +2983,6 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
  * *********************************************************************************************
  */
 
-/*
- * This function is called by wait_event_interruptible in sg_read() and sg_ctl_ioreceive().
- * wait_event_interruptible will return if this one returns true (or an event like a signal (e.g.
- * control-C) occurs).
- */
-static inline bool
-sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int id, bool is_tag)
-{
-	struct sg_request *srp;
-
-	if (SG_IS_DETACHING(sfp->parentdp)) {
-		*srpp = ERR_PTR(-ENODEV);
-		return true;
-	}
-	srp = sg_get_srp_by_id(sfp, id, is_tag, false);
-	*srpp = srp;	/* Warning: IS_ERR(srp) may be true */
-	return !!srp;
-}
-
-static inline bool
-sg_get_any_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
-{
-	struct sg_request *srp;
-
-	if (SG_IS_DETACHING(sfp->parentdp))
-		srp = ERR_PTR(-ENODEV);
-	else
-		srp = sg_get_any_srp(sfp, false);
-	*srpp = srp;	/* Warning: IS_ERR(srp) may be true */
-	return !!srp;
-}
-
 /* Returns number of bytes copied to user space provided sense buffer or negated errno value. */
 static int
 sg_copy_sense(struct sg_request *srp)
@@ -3204,24 +3207,26 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p, struct
  * of elements written to rsp_arr, which may be 0 if mrqs submitted but none waiting
  */
 static int
-sg_mrq_iorec_complets(struct sg_fd *sfp, struct sg_mrq_hold *mhp, bool non_block, int max_rcv)
+sg_mrq_iorec_complets(struct sg_fd_pollable *sfp_p, struct sg_mrq_hold *mhp, int max_rcv)
 {
 	int k, idx;
 	int res = 0;
 	struct sg_request *srp;
 	struct sg_io_v4 *rsp_arr = mhp->a_hds;
+	struct sg_fd *fp = sfp_p->fp;
 
-	SG_LOG(3, sfp, "%s: num_responses=%d, max_rcv=%d, hipri=%u\n", __func__,
+	SG_LOG(3, fp, "%s: num_responses=%d, max_rcv=%d, hipri=%u\n", __func__,
 	       mhp->tot_reqs, max_rcv, mhp->hipri);
 	if (max_rcv == 0 || max_rcv > mhp->tot_reqs)
 		max_rcv = mhp->tot_reqs;
 	k = 0;
 recheck:
 	for ( ; k < max_rcv; ++k) {
-		if (!sg_mrq_get_ready_srp(sfp, &srp))
-			break;
+		srp = sg_find_srp_from(sfp_p);
 		if (IS_ERR(srp))
 			return k ? k /* some but not all */ : PTR_ERR(srp);
+		if (!srp)
+			break;
 		if (srp->rq_flags & SGV4_FLAG_REC_ORDER) {
 			idx = srp->s_hdr4.mrq_ind;
 			if (idx >= mhp->tot_reqs)
@@ -3229,24 +3234,24 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, struct sg_mrq_hold *mhp, bool non_block
 		} else {
 			idx = k;	/* completion order */
 		}
-		res = sg_receive_v4(sfp, srp, NULL, rsp_arr + idx);
+		res = sg_receive_v4(fp, srp, NULL, rsp_arr + idx);
 		if (unlikely(res))
 			return res;
 		rsp_arr[idx].info |= SG_INFO_MRQ_FINI;
 	}
-	if (non_block || k >= max_rcv)
+	if (sfp_p->immed || k >= max_rcv)
 		return k;
 	if (mhp->hipri) {
-		if (SG_IS_DETACHING(sfp->parentdp))
+		if (SG_IS_DETACHING(fp->parentdp))
 			return -ENODEV;
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 		cpu_relax();
 		goto recheck;
 	}
-	SG_LOG(6, sfp, "%s: received=%d, max=%d\n", __func__, k, max_rcv);
+	SG_LOG(6, fp, "%s: received=%d, max=%d\n", __func__, k, max_rcv);
 	for ( ; k < max_rcv; ++k) {
-		res = sg_wait_any_mrq(sfp, mhp, &srp);
+		res = sg_wait_any_mrq(sfp_p, mhp, &srp);
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
@@ -3258,7 +3263,7 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, struct sg_mrq_hold *mhp, bool non_block
 		} else {
 			idx = k;
 		}
-		res = sg_receive_v4(sfp, srp, NULL, rsp_arr + idx);
+		res = sg_receive_v4(fp, srp, NULL, rsp_arr + idx);
 		if (unlikely(res))
 			return res;
 		rsp_arr[k].info |= SG_INFO_MRQ_FINI;
@@ -3272,7 +3277,7 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, struct sg_mrq_hold *mhp, bool non_block
  * may succeed but will get different requests).
  */
 static int
-sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool non_block)
+sg_mrq_ioreceive(struct sg_fd_pollable *sfp_p, struct sg_io_v4 *cop, void __user *p)
 {
 	int res = 0;
 	int max_rcv;
@@ -3281,8 +3286,10 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool n
 	void __user *pp;
 	struct sg_mrq_hold mh;
 	struct sg_mrq_hold *mhp = &mh;
+	struct sg_fd *fp = sfp_p->fp;
 
-	SG_LOG(3, sfp, "%s: non_block=%d\n", __func__, !!non_block);
+	SG_LOG(3, fp, "%s: immed=%d\n", __func__, sfp_p->immed);
+	sfp_p->part_mrq = true;
 	n = cop->din_xfer_len;
 	if (unlikely(n > SG_MAX_MULTI_REQ_SZ))
 		return -E2BIG;
@@ -3294,8 +3301,8 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool n
 	len = n * SZ_SG_IO_V4;
 	max_rcv = cop->din_iovec_count;
 	mhp->hipri = !!(cop->flags & SGV4_FLAG_HIPRI);
-	SG_LOG(3, sfp, "%s: %s, num_reqs=%u, max_rcv=%d\n", __func__,
-	       (non_block ? "IMMED" : "blocking"), n, max_rcv);
+	SG_LOG(3, fp, "%s: %s, num_reqs=%u, max_rcv=%d\n", __func__,
+	       (sfp_p->immed ? "IMMED" : "blocking"), n, max_rcv);
 	rsp_v4_arr = kcalloc(n, SZ_SG_IO_V4, GFP_KERNEL);
 	if (unlikely(!rsp_v4_arr))
 		return -ENOMEM;
@@ -3303,7 +3310,7 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool n
 	sg_v4h_partial_zero(cop);
 	cop->din_resid = n;
 	mhp->a_hds = rsp_v4_arr;
-	res = sg_mrq_iorec_complets(sfp, mhp, non_block, max_rcv);
+	res = sg_mrq_iorec_complets(sfp_p, mhp, max_rcv);
 	if (unlikely(res < 0))
 		goto fini;
 	cop->din_resid -= res;
@@ -3316,37 +3323,36 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool n
 		if (copy_to_user(pp, rsp_v4_arr, len))
 			res = -EFAULT;
 	} else {
-		SG_LOG(1, sfp, "%s: cop->din_xferp==NULL ?_?\n", __func__);
+		SG_LOG(1, fp, "%s: cop->din_xferp==NULL ?_?\n", __func__);
 	}
 fini:
 	kfree(rsp_v4_arr);
 	return res;
 }
 
+/* Returns first srp that meets the constraints in sfp_p */
 static struct sg_request *
-sg_poll_wait4_srp(struct sg_fd *sfp, int id, bool is_tag, bool part_mrq)
+sg_poll4_any_srp(struct sg_fd_pollable *sfp_p)
 {
 	long state = current->state;
 	struct sg_request *srp;
+	struct sg_fd *fp = sfp_p->fp;
 
 	do {
-		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm)) {
-			int res = sg_sfp_blk_poll(sfp, SG_DEF_BLK_POLL_LOOP_COUNT);
+		if (test_bit(SG_FFD_HIPRI_SEEN, fp->ffd_bm)) {
+			int res = sg_sfp_blk_poll_first(fp);
 
 			if (res < 0)
 				return ERR_PTR(res);
 		}
-		if (id == -1)
-			srp = sg_get_any_srp(sfp, part_mrq);
-		else
-			srp = sg_get_srp_by_id(sfp, id, is_tag, part_mrq);
+		srp = sg_find_srp_from(sfp_p);
 		if (IS_ERR(srp))
 			return srp;
 		if (srp) {
 			__set_current_state(TASK_RUNNING);
 			return srp;
 		}
-		if (SG_IS_DETACHING(sfp->parentdp)) {
+		if (SG_IS_DETACHING(fp->parentdp)) {
 			__set_current_state(TASK_RUNNING);
 			return ERR_PTR(-ENODEV);
 		}
@@ -3359,34 +3365,37 @@ sg_poll_wait4_srp(struct sg_fd *sfp, int id, bool is_tag, bool part_mrq)
 }
 
 /*
- * Called from read(), ioctl(SG_IORECEIVE) or ioctl(SG_IORECEIVE_V3). Either wait event for
- * command completion matching id ('-1': any); or poll for it if do_poll==true
+ * Called from read(), ioctl(SG_IORECEIVE) or ioctl(SG_IORECEIVE_V3). Poll or wait_event
+ * depending hipri setting.
  */
 static int
-sg_wait_poll_by_id(struct sg_fd *sfp, struct sg_request **srpp, int id,
-		   bool is_tag, int do_poll)
+sg_poll_or_wait_ev_srp(struct sg_fd_pollable *sfp_p, struct sg_request **srpp, bool hipri)
 {
-	if (do_poll) {
-		struct sg_request *srp = sg_poll_wait4_srp(sfp, id, is_tag, false);
+	int res;
+	struct sg_fd *fp = sfp_p->fp;
+
+	if (hipri) {
+		struct sg_request *srp = sg_poll4_any_srp(sfp_p);
 
 		if (IS_ERR(srp))
 			return PTR_ERR(srp);
 		*srpp = srp;
 		return 0;
 	}
-	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm)) {
-		if (id == -1)
-			return __wait_event_interruptible_exclusive
-					(sfp->cmpl_wait, sg_get_any_ready_srp(sfp, srpp));
-		else
-			return __wait_event_interruptible_exclusive
-					(sfp->cmpl_wait, sg_get_ready_srp(sfp, srpp, id, is_tag));
-	}
-	if (id == -1)
-		return __wait_event_interruptible(sfp->cmpl_wait, sg_get_any_ready_srp(sfp, srpp));
+	if (test_bit(SG_FFD_EXCL_WAITQ, fp->ffd_bm))
+		res = __wait_event_interruptible_exclusive(fp->cmpl_wait,
+							   sg_find_srp_pred(sfp_p, srpp));
 	else
-		return __wait_event_interruptible(sfp->cmpl_wait, sg_get_ready_srp(sfp, srpp, id,
-						  is_tag));
+		res = __wait_event_interruptible(fp->cmpl_wait, sg_find_srp_pred(sfp_p, srpp));
+	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
+		set_bit(SG_FFD_SIG_PEND, fp->ffd_bm);
+		SG_LOG(1, fp, "%s:  wait_event_interruptible(): %s[%d]\n", __func__,
+		       (res == -ERESTARTSYS ? "ERESTARTSYS" : ""), res);
+		return res;
+	}
+	if (SG_IS_DETACHING(fp->parentdp))
+		return -ENODEV;
+	return 0;
 }
 
 /*
@@ -3399,14 +3408,12 @@ static int
 sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 {
 	bool non_block = SG_IS_O_NONBLOCK(sfp);
-	bool use_tag = false;
-	int res, id;
-	int pack_id = SG_PACK_ID_WILDCARD;
-	int tag = SG_TAG_WILDCARD;
+	int res;
 	struct sg_io_v4 h4;
 	struct sg_io_v4 *h4p = &h4;
 	struct sg_device *sdp = sfp->parentdp;
 	struct sg_request *srp;
+	struct sg_fd_pollable a_sfpoll;
 
 	res = sg_allow_if_err_recovery(sdp, non_block);
 	if (unlikely(res))
@@ -3421,29 +3428,36 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 	       !!(h4p->flags & SGV4_FLAG_IMMED), !!(h4p->flags & SGV4_FLAG_HIPRI));
 	if (h4p->flags & SGV4_FLAG_IMMED)
 		non_block = true;	/* set by either this or O_NONBLOCK */
+	a_sfpoll.fp = sfp;
+	a_sfpoll.pollable = true;
+	a_sfpoll.immed = non_block;
 	if (h4p->flags & SGV4_FLAG_MULTIPLE_REQS)
-		return sg_mrq_ioreceive(sfp, h4p, p, non_block);
+		return sg_mrq_ioreceive(&a_sfpoll, h4p, p);
+	a_sfpoll.part_mrq = false;
 	/* read in part of v3 or v4 header for pack_id or tag based find */
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm)) {
-		use_tag = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm);
-		if (use_tag)
-			tag = h4p->request_tag;	/* top 32 bits ignored */
-		else
-			pack_id = h4p->request_extra;
+		if (test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm)) {
+			a_sfpoll.find_by = SG_SEARCH_BY_TAG;
+			a_sfpoll.pack_id_tag = h4p->request_tag;/* top 32 bits ignored */
+		} else {
+			a_sfpoll.find_by = SG_SEARCH_BY_PACK_ID;
+			a_sfpoll.pack_id_tag = h4p->request_extra;
+		}
+	} else {
+		a_sfpoll.find_by = SG_SEARCH_ANY;
+		a_sfpoll.pack_id_tag = SG_PACK_ID_WILDCARD;
 	}
-	id = use_tag ? tag : pack_id;
 try_again:
 	if (non_block) {
-		srp = sg_get_srp_by_id(sfp, id, use_tag, false /* part_mrq */);
+		srp = sg_find_srp_from(&a_sfpoll);
 		if (!srp)
 			return SG_IS_DETACHING(sdp) ? -ENODEV : -EAGAIN;
 	} else {
-		res = sg_wait_poll_by_id(sfp, &srp, pack_id, use_tag,
-					 !!(h4p->flags & SGV4_FLAG_HIPRI));
-		if (IS_ERR(srp))
-			return PTR_ERR(srp);
+		res = sg_poll_or_wait_ev_srp(&a_sfpoll, &srp, !!(h4p->flags & SGV4_FLAG_HIPRI));
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
+		if (IS_ERR(srp))
+			return PTR_ERR(srp);
 	}
 	if (test_and_set_bit(SG_FRQ_PC_RECEIVING, srp->frq_pc_bm)) {
 		cpu_relax();
@@ -3463,11 +3477,11 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 {
 	bool non_block = SG_IS_O_NONBLOCK(sfp);
 	int res;
-	int pack_id = SG_PACK_ID_WILDCARD;
 	struct sg_io_hdr h3;
 	struct sg_io_hdr *h3p = &h3;
 	struct sg_device *sdp = sfp->parentdp;
 	struct sg_request *srp;
+	struct sg_fd_pollable a_sfpoll;
 
 	res = sg_allow_if_err_recovery(sdp, non_block);
 	if (unlikely(res))
@@ -3480,20 +3494,28 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 		return -EPERM;
 	if (h3p->flags & SGV4_FLAG_IMMED)
 		non_block = true;	/* set by either this or O_NONBLOCK */
+	a_sfpoll.fp = sfp;
+	a_sfpoll.pollable = true;
+	a_sfpoll.immed = non_block;
+	a_sfpoll.part_mrq = false;
 	SG_LOG(3, sfp, "%s: non_block(+IMMED)=%d\n", __func__, non_block);
 	if (unlikely(h3p->flags & SGV4_FLAG_MULTIPLE_REQS))
 		return -EINVAL;
 
-	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm))
-		pack_id = h3p->pack_id;
+	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm)) {
+		a_sfpoll.find_by = SG_SEARCH_BY_PACK_ID;
+		a_sfpoll.pack_id_tag = h3p->pack_id;
+	} else {
+		a_sfpoll.find_by = SG_SEARCH_ANY;
+		a_sfpoll.pack_id_tag = SG_PACK_ID_WILDCARD;
+	}
 try_again:
 	if (non_block) {
-		srp = sg_get_srp_by_id(sfp, pack_id, false, false);
+		srp = sg_find_srp_from(&a_sfpoll);
 		if (!srp)
 			return SG_IS_DETACHING(sdp) ? -ENODEV : -EAGAIN;
 	} else {
-		res = sg_wait_poll_by_id(sfp, &srp, pack_id, false,
-					 !!(h3p->flags & SGV4_FLAG_HIPRI));
+		res = sg_poll_or_wait_ev_srp(&a_sfpoll, &srp, !!(h3p->flags & SGV4_FLAG_HIPRI));
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
@@ -3597,13 +3619,13 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 {
 	bool could_be_v3;
 	bool non_block = !!(filp->f_flags & O_NONBLOCK);
-	int want_id = SG_PACK_ID_WILDCARD;
 	int hlen, ret;
 	struct sg_device *sdp = NULL;
 	struct sg_fd *sfp;
 	struct sg_request *srp = NULL;
 	struct sg_header *h2p = NULL;
 	struct sg_io_hdr a_sg_io_hdr;
+	struct sg_fd_pollable a_sfpoll;
 
 	/*
 	 * This could cause a response to be stranded. Close the associated file descriptor to
@@ -3623,6 +3645,9 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 	could_be_v3 = (count >= SZ_SG_IO_HDR);
 	hlen = could_be_v3 ? SZ_SG_IO_HDR : SZ_SG_HEADER;
 	h2p = (struct sg_header *)&a_sg_io_hdr;
+	a_sfpoll.fp = sfp;
+	a_sfpoll.pollable = true;
+	a_sfpoll.part_mrq = false;
 
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm) && (int)count >= hlen) {
 		/*
@@ -3635,6 +3660,7 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 			struct sg_io_hdr *v3_hdr = (struct sg_io_hdr *)h2p;
 
 			if (likely(v3_hdr->interface_id == 'S')) {
+				int want_id;
 				struct sg_io_hdr __user *h3_up;
 
 				h3_up = (struct sg_io_hdr __user *)p;
@@ -3650,23 +3676,31 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 					if (flgs & SGV4_FLAG_IMMED)
 						non_block = true;
 				}
+				a_sfpoll.find_by = SG_SEARCH_BY_PACK_ID;
+				a_sfpoll.pack_id_tag = want_id;
 			} else if (v3_hdr->interface_id == 'Q') {
 				pr_info_once("sg: %s: v4 interface disallowed here\n", __func__);
 				return -EPERM;
 			} else {
 				return -EPERM;
 			}
-		} else { /* for v1+v2 interfaces, this is the 3rd integer */
-			want_id = h2p->pack_id;
+		} else { /* for v1+v2 interfaces, pack_id is the 3rd integer */
+			a_sfpoll.find_by = SG_SEARCH_BY_PACK_ID;
+			a_sfpoll.pack_id_tag = h2p->pack_id;
 		}
+	} else {
+		a_sfpoll.find_by = SG_SEARCH_ANY;
+		a_sfpoll.pack_id_tag = SG_PACK_ID_WILDCARD;
 	}
+	a_sfpoll.immed = non_block;
+
 try_again:
 	if (non_block) {
-		srp = sg_get_srp_by_id(sfp, want_id, false, false /* part_mrq */);
+		srp = sg_find_srp_from(&a_sfpoll);
 		if (!srp)
 			return SG_IS_DETACHING(sdp) ? -ENODEV : -EAGAIN;
 	} else {
-		ret = sg_wait_poll_by_id(sfp, &srp, want_id, false, false /* do_poll */);
+		ret = sg_poll_or_wait_ev_srp(&a_sfpoll, &srp, false);
 		if (unlikely(ret))
 			return ret;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
@@ -4156,7 +4190,7 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp, struct sg_req
 	if (rip->duration == U32_MAX)
 		rip->duration = 0;
 	rip->orphan = test_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm);
-	rip->sg_io_owned = test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm);
+	rip->sg_io_owned = !test_bit(SG_FRQ_PC_POLLABLE, srp->frq_pc_bm);
 	rip->problem = !sg_result_is_good(srp->rq_result);
 	rip->pack_id = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm) ? srp->tag : srp->pack_id;
 	rip->usr_ptr = SG_IS_V4I(srp) ? uptr64(srp->s_hdr4.usr_ptr) : srp->s_hdr3.usr_ptr;
@@ -4173,6 +4207,7 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	u8 hu8arr[SZ_SG_IO_V4];
 	struct sg_io_hdr *h3p = (struct sg_io_hdr *)hu8arr;
 	struct sg_io_v4 *h4p = (struct sg_io_v4 *)hu8arr;
+	struct sg_fd_pollable a_sfpoll;
 
 	SG_LOG(3, sfp, "%s:  SG_IO%s\n", __func__,
 	       (SG_IS_O_NONBLOCK(sfp) ? " O_NONBLOCK ignored" : ""));
@@ -4195,9 +4230,13 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		if (copy_from_user(hu8arr + v3_len, ((u8 __user *)p) + v3_len,
 				   SZ_SG_IO_V4 - v3_len))
 			return -EFAULT;
+		if (h4p->flags & SGV4_FLAG_IMMED)
+			return -EINVAL;
 		is_v4 = true;
 		res = sg_submit_v4(sfp, p, h4p, true, &srp);
 	} else if (h3p->interface_id == 'S') {
+		if (h3p->flags & SGV4_FLAG_IMMED)
+			return -EINVAL;
 		is_v4 = false;
 		res = sg_submit_v3(sfp, h3p, true, &srp);
 	} else {
@@ -4208,7 +4247,11 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		return res;
 	if (!srp)	/* mrq case: already processed all responses */
 		return res;
-	res = sg_poll_wait4_given_srp(sfp, srp);
+	a_sfpoll.fp = sfp;
+	a_sfpoll.pollable = false;
+	a_sfpoll.immed = false;
+	a_sfpoll.part_mrq = false;
+	res = sg_poll_wait4_given_srp(&a_sfpoll, srp);
 #if IS_ENABLED(SG_LOG_ACTIVE)
 	if (unlikely(res))
 		SG_LOG(1, sfp, "%s: unexpected srp=0x%pK  state: %s, share: %s\n", __func__,
@@ -4229,23 +4272,24 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
  * returns NULL.
  */
 static struct sg_request *
-sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
+sg_match_request(struct sg_fd_pollable *sfp_p, bool use_tag, int id)
 {
 	unsigned long idx;
 	struct sg_request *srp;
+	struct sg_fd *fp = sfp_p->fp;
 
-	if (sg_num_waiting_maybe_acquire(sfp) < 1)
+	if (sg_num_waiting_maybe_acquire(sfp_p) < 1)
 		return NULL;
 	if (id == SG_PACK_ID_WILDCARD) {
-		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT)
+		xa_for_each_marked(&fp->srp_arr, idx, srp, SG_XA_RQ_AWAIT)
 			return srp;
 	} else if (use_tag) {
-		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
+		xa_for_each_marked(&fp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
 			if (id == srp->tag)
 				return srp;
 		}
 	} else {
-		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
+		xa_for_each_marked(&fp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
 			if (id == srp->pack_id)
 				return srp;
 		}
@@ -4259,18 +4303,19 @@ sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
  * search restarts from the beginning of the list. If no match is found then NULL is returned.
  */
 static struct sg_request *
-sg_match_first_mrq_after(struct sg_fd *sfp, int pack_id, struct sg_request *after_rp)
+sg_match_first_mrq_after(struct sg_fd_pollable *sfp_p, int pack_id, struct sg_request *after_rp)
 {
 	bool found = false;
 	bool look_for_after = after_rp ? true : false;
 	int id;
 	unsigned long idx;
 	struct sg_request *srp;
+	struct sg_fd *fp = sfp_p->fp;
 
-	if (sg_num_waiting_maybe_acquire(sfp) < 1)
+	if (sg_num_waiting_maybe_acquire(sfp_p) < 1)
 		return NULL;
 once_more:
-	xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
+	xa_for_each_marked(&fp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
 		if (look_for_after) {
 			if (after_rp == srp)
 				look_for_after = false;
@@ -4340,18 +4385,19 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 
 /* Holding xa_lock_irq(&sfp->srp_arr) */
 static int
-sg_mrq_abort_inflight(struct sg_fd *sfp, int pack_id)
+sg_mrq_abort_inflight(struct sg_fd_pollable *sfp_p, int pack_id)
 {
 	bool got_ebusy = false;
 	int res = 0;
 	struct sg_request *srp;
 	struct sg_request *prev_srp;
+	struct sg_fd *fp = sfp_p->fp;
 
 	for (prev_srp = NULL; true; prev_srp = srp) {
-		srp = sg_match_first_mrq_after(sfp, pack_id, prev_srp);
+		srp = sg_match_first_mrq_after(sfp_p, pack_id, prev_srp);
 		if (!srp)
 			break;
-		res = sg_abort_req(sfp, srp);
+		res = sg_abort_req(fp, srp);
 		if (res == -EBUSY)	/* check rest of active list */
 			got_ebusy = true;
 		else if (res)
@@ -4370,7 +4416,7 @@ sg_mrq_abort_inflight(struct sg_fd *sfp, int pack_id)
  * ctl_obj.request_extra (pack_id).
  */
 static int
-sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
+sg_mrq_abort(struct sg_fd_pollable *sfp_p, int pack_id, bool dev_scope)
 		__must_hold(sfp->f_mutex)
 {
 	int existing_id;
@@ -4379,63 +4425,67 @@ sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
 	struct sg_device *sdp;
 	struct sg_fd *o_sfp;
 	struct sg_fd *s_sfp;
+	struct sg_fd *fp = sfp_p->fp;
 
 	if (pack_id != SG_PACK_ID_WILDCARD)
-		SG_LOG(3, sfp, "%s: pack_id=%d, dev_scope=%s\n", __func__, pack_id,
+		SG_LOG(3, fp, "%s: pack_id=%d, dev_scope=%s\n", __func__, pack_id,
 		       (dev_scope ? "true" : "false"));
-	existing_id = atomic_read(&sfp->mrq_id_abort);
+	existing_id = atomic_read(&fp->mrq_id_abort);
 	if (existing_id == 0) {
 		if (dev_scope)
 			goto check_whole_dev;
-		SG_LOG(1, sfp, "%s: sfp->mrq_id_abort is 0, nothing to do\n", __func__);
+		SG_LOG(1, fp, "%s: sfp->mrq_id_abort is 0, nothing to do\n", __func__);
 		return -EADDRNOTAVAIL;
 	}
 	if (pack_id == SG_PACK_ID_WILDCARD) {
 		pack_id = existing_id;
-		SG_LOG(3, sfp, "%s: wildcard becomes pack_id=%d\n", __func__, pack_id);
+		SG_LOG(3, fp, "%s: wildcard becomes pack_id=%d\n", __func__, pack_id);
 	} else if (pack_id != existing_id) {
 		if (dev_scope)
 			goto check_whole_dev;
-		SG_LOG(1, sfp, "%s: want id=%d, got sfp->mrq_id_abort=%d\n", __func__, pack_id,
+		SG_LOG(1, fp, "%s: want id=%d, got sfp->mrq_id_abort=%d\n", __func__, pack_id,
 		       existing_id);
 		return -EADDRINUSE;
 	}
-	if (test_and_set_bit(SG_FFD_MRQ_ABORT, sfp->ffd_bm))
-		SG_LOG(2, sfp, "%s: repeated SG_IOABORT on mrq_id=%d\n", __func__, pack_id);
+	if (test_and_set_bit(SG_FFD_MRQ_ABORT, fp->ffd_bm))
+		SG_LOG(2, fp, "%s: repeated SG_IOABORT on mrq_id=%d\n", __func__, pack_id);
 
 	/* now look for inflight requests matching that mrq pack_id */
-	xa_lock_irqsave(&sfp->srp_arr, iflags);
-	res = sg_mrq_abort_inflight(sfp, pack_id);
+	xa_lock_irqsave(&fp->srp_arr, iflags);
+	res = sg_mrq_abort_inflight(sfp_p, pack_id);
 	if (res == -EBUSY) {
-		res = sg_mrq_abort_inflight(sfp, pack_id);
+		res = sg_mrq_abort_inflight(sfp_p, pack_id);
 		if (res)
 			goto fini;
 	}
-	s_sfp = sg_fd_share_ptr(sfp);
+	s_sfp = sg_fd_share_ptr(fp);
 	if (s_sfp) {	/* SGV4_FLAG_DO_ON_OTHER possible */
-		xa_unlock_irqrestore(&sfp->srp_arr, iflags);
-		sfp = s_sfp;	/* if share, switch to other fd */
-		xa_lock_irqsave(&sfp->srp_arr, iflags);
-		if (!sg_fd_is_shared(sfp))
+		xa_unlock_irqrestore(&fp->srp_arr, iflags);
+		fp = s_sfp;	/* if share, switch to other fd */
+		xa_lock_irqsave(&fp->srp_arr, iflags);
+		if (!sg_fd_is_shared(fp))
 			goto fini;
 		/* tough luck if other fd used same mrq pack_id */
-		res = sg_mrq_abort_inflight(sfp, pack_id);
+		res = sg_mrq_abort_inflight(sfp_p, pack_id);
 		if (res == -EBUSY)
-			res = sg_mrq_abort_inflight(sfp, pack_id);
+			res = sg_mrq_abort_inflight(sfp_p, pack_id);
 	}
 fini:
-	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+	xa_unlock_irqrestore(&fp->srp_arr, iflags);
 	return res;
 
 check_whole_dev:
 	res = -ENODATA;
-	sdp = sfp->parentdp;
+	sdp = fp->parentdp;
 	xa_for_each(&sdp->sfp_arr, idx, o_sfp) {
-		if (o_sfp == sfp)
+		struct sg_fd_pollable a_sfpoll = *sfp_p;
+
+		if (o_sfp == fp)
 			continue;       /* already checked */
 		mutex_lock(&o_sfp->f_mutex);
+		a_sfpoll.fp = o_sfp;
 		/* recurse, dev_scope==false is stopping condition */
-		res = sg_mrq_abort(o_sfp, pack_id, false);
+		res = sg_mrq_abort(&a_sfpoll, pack_id, false);
 		mutex_unlock(&o_sfp->f_mutex);
 		if (res == 0)
 			break;
@@ -4461,6 +4511,7 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	struct sg_request *srp;
 	struct sg_io_v4 io_v4;
 	struct sg_io_v4 *h4p = &io_v4;
+	struct sg_fd_pollable a_sfpoll;
 
 	if (copy_from_user(h4p, p, SZ_SG_IO_V4))
 		return -EFAULT;
@@ -4468,17 +4519,22 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		return -EPERM;
 	dev_scope = !!(h4p->flags & SGV4_FLAG_DEV_SCOPE);
 	pack_id = h4p->request_extra;
+	a_sfpoll.fp = sfp;
+	a_sfpoll.pollable = true;
+	a_sfpoll.immed = true;
 	if (h4p->flags & SGV4_FLAG_MULTIPLE_REQS) {
+		a_sfpoll.part_mrq = true;
 		if (pack_id == 0)
 			return -ENOSTR;
-		res = sg_mrq_abort(sfp, pack_id, dev_scope);
+		res = sg_mrq_abort(&a_sfpoll, pack_id, dev_scope);
 		return res;
 	}
+	a_sfpoll.part_mrq = false;
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	use_tag = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm);
 	id = use_tag ? (int)h4p->request_tag : pack_id;
 
-	srp = sg_match_request(sfp, use_tag, id);
+	srp = sg_match_request(&a_sfpoll, use_tag, id);
 	if (!srp) {	/* assume device (not just fd) scope */
 		xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 		if (!dev_scope)
@@ -4486,7 +4542,8 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		xa_for_each(&sdp->sfp_arr, idx, o_sfp) {
 			if (o_sfp == sfp)
 				continue;	/* already checked */
-			srp = sg_match_request(o_sfp, use_tag, id);
+			a_sfpoll.fp = o_sfp;
+			srp = sg_match_request(&a_sfpoll, use_tag, id);
 			if (srp) {
 				sfp = o_sfp;
 				xa_lock_irqsave(&sfp->srp_arr, iflags);
@@ -4817,8 +4874,6 @@ sg_any_persistent_orphans(struct sg_fd *sfp)
 		struct sg_request *srp;
 		struct xarray *xafp = &sfp->srp_arr;
 
-		if (sg_num_waiting_maybe_acquire(sfp) < 1)
-			return false;
 		xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_AWAIT) {
 			if (test_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm))
 				return true;
@@ -5228,7 +5283,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 	if (or_masks & SG_SEIM_BLK_POLL) {
 		n = 0;
 		if (s_wr_mask & SG_SEIM_BLK_POLL) {
-			result = sg_sfp_blk_poll(sfp, seip->num);
+			result = sg_sfp_blk_poll_all(sfp, seip->num);
 			if (unlikely(result < 0)) {
 				if (ret == 0)
 					ret = result;
@@ -5368,14 +5423,14 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp, uns
 	case SG_GET_NUM_WAITING:
 		/* Want as fast as possible, with a useful result */
 		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm)) {
-			res = sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready */
+			res = sg_sfp_blk_poll_all(sfp, 1);	/* LLD may have some ready */
 			if (unlikely(res < 0))
 				return res;
 		}
-		val = atomic_read(&sfp->waiting);
+		val = atomic_read(&sfp->poll_waiting);
 		if (val)
 			return put_user(val, ip);
-		return put_user(atomic_read_acquire(&sfp->waiting), ip);
+		return put_user(atomic_read_acquire(&sfp->poll_waiting), ip);
 	case SG_IO:
 		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
@@ -5423,18 +5478,18 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp, uns
 			return res;
 		assign_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm, !!val);
 		return 0;
-	case SG_GET_PACK_ID:    /* or tag of oldest "read"-able, -1 if none */
+	case SG_GET_PACK_ID:    /* or tag of oldest pollable, -1 if none */
 		val = -1;
 		if (test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm)) {
 			xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
-				if (!test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm)) {
+				if (test_bit(SG_FRQ_PC_POLLABLE, srp->frq_pc_bm)) {
 					val = srp->tag;
 					break;
 				}
 			}
 		} else {
 			xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
-				if (!test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm)) {
+				if (test_bit(SG_FRQ_PC_POLLABLE, srp->frq_pc_bm)) {
 					val = srp->pack_id;
 					break;
 				}
@@ -5637,67 +5692,56 @@ sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 #endif
 
 /*
- * If the sg_request object is not inflight, return -ENODATA. This function
- * returns 1 if the given object was in inflight state and is in await_rcv
- * state after blk_poll() returns 1 or more. If blk_poll() fails, then that
- * (negative) value is returned. Otherwise returns 0. Note that blk_poll()
- * may complete unrelated requests that share the same q and cookie.
+ * Calls blk_poll(spin <- false) loop_count times. If loop_count is 0 then call blk_poll() once.
+ * If loop_count is negative then call blk_poll(spin <- true)) once for each request. If
+ * blk_poll() reports something other than 0 then returns at that point.
  */
 static int
-sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q, int loop_count)
+sg_sfp_blk_poll_all(struct sg_fd *sfp, int loop_count)
 {
+	int res = 0;
 	int k, n, num;
+	unsigned long idx;
+	struct sg_request *srp;
+	struct scsi_device *sdev = sfp->parentdp->device;
+	struct request_queue *q = sdev ? sdev->request_queue : NULL;
 
+	if (unlikely(!q))
+		return -EINVAL;
 	num = (loop_count < 1) ? 1 : loop_count;
-	for (k = 0; k < num; ++k) {
-		if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT)
-			return -ENODATA;
-		n = blk_poll(q, srp->cookie, loop_count < 0 /* spin if negative */);
-		if (n > 0)
-			return atomic_read(&srp->rq_st) == SG_RQ_AWAIT_RCV;
-		if (n < 0)
-			return n;
+	xa_for_each(&sfp->srp_arr, idx, srp) {
+		if ((srp->rq_flags & SGV4_FLAG_HIPRI) &&
+		    atomic_read(&srp->rq_st) == SG_RQ_INFLIGHT &&
+		    test_bit(SG_FRQ_PC_ISSUED, srp->frq_pc_bm)) {
+			for (k = 0; k < num; ++k) {
+				n = blk_poll(q, srp->cookie, loop_count < 0);
+				if (n < 0)
+					return n;
+				if (n > 0)
+					res += n;
+			}
+		}
 	}
-	return 0;
+	return res;
 }
 
-/*
- * Check all requests on this sfp that are both inflight and HIPRI. That check involves calling
- * blk_poll(spin<-false) loop_count times. If loop_count is 0 then call blk_poll once.
- * If loop_count is negative then call blk_poll(spin <- true)) once for each request.
- * Returns number found (could be 0) or a negated errno value.
- */
 static int
-sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
+sg_sfp_blk_poll_first(struct sg_fd *sfp)
 {
-	int res = 0;
-	int n;
-	unsigned long idx, iflags;
+	unsigned long idx;
 	struct sg_request *srp;
 	struct scsi_device *sdev = sfp->parentdp->device;
 	struct request_queue *q = sdev ? sdev->request_queue : NULL;
-	struct xarray *xafp = &sfp->srp_arr;
 
 	if (unlikely(!q))
 		return -EINVAL;
-	xa_lock_irqsave(xafp, iflags);
-	xa_for_each(xafp, idx, srp) {
+	xa_for_each(&sfp->srp_arr, idx, srp) {
 		if ((srp->rq_flags & SGV4_FLAG_HIPRI) &&
-		    !test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm) &&
 		    atomic_read(&srp->rq_st) == SG_RQ_INFLIGHT &&
-		    test_bit(SG_FRQ_PC_ISSUED, srp->frq_pc_bm)) {
-			xa_unlock_irqrestore(xafp, iflags);
-			n = sg_srp_q_blk_poll(srp, q, loop_count);
-			if (n == -ENODATA)
-				n = 0;
-			if (unlikely(n < 0))
-				return n;
-			xa_lock_irqsave(xafp, iflags);
-			res += n;
-		}
+		    test_bit(SG_FRQ_PC_ISSUED, srp->frq_pc_bm))
+			return blk_poll(q, srp->cookie, false);
 	}
-	xa_unlock_irqrestore(xafp, iflags);
-	return res;
+	return 0;
 }
 
 /* Implements the poll(2) system call. Returns various EPOLL* flags OR-ed together. */
@@ -5709,11 +5753,11 @@ sg_poll(struct file *filp, poll_table *wait)
 	struct sg_fd *sfp = filp->private_data;
 
 	if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
-		sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready to push up */
-	num = atomic_read(&sfp->waiting);
+		sg_sfp_blk_poll_all(sfp, 1);	/* LLD may have some ready to push up */
+	num = atomic_read(&sfp->poll_waiting);
 	if (num < 1) {
 		poll_wait(filp, &sfp->cmpl_wait, wait);
-		num = atomic_read(&sfp->waiting);
+		num = atomic_read(&sfp->poll_waiting);
 	}
 	if (num > 0)
 		p_res = EPOLLIN | EPOLLRDNORM;
@@ -5916,7 +5960,7 @@ static void
 sg_rq_end_io(struct request *rqq, blk_status_t status)
 {
 	enum sg_rq_state rqq_state = SG_RQ_AWAIT_RCV;
-	int a_resid, slen;
+	int a_resid, slen, num;
 	u32 rq_result;
 	unsigned long iflags;
 	struct sg_request *srp = rqq->end_io_data;
@@ -5976,30 +6020,31 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 		}
 	}
 	srp->sense_len = slen;
-	if (unlikely(test_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm))) {
-		if (test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm)) {
-			__clear_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm);
-		} else {
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	if (unlikely(test_bit(SG_FFD_SIG_PEND, sfp->ffd_bm))) {
+		__set_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm);
+		if (test_bit(SG_FRQ_PC_POLLABLE, srp->frq_pc_bm) &&
+		    (!test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm))) {
 			rqq_state = SG_RQ_BUSY;
+			/* since ! KEEP_ORPHAN then we will harvest it */
 			__set_bit(SG_FRQ_PC_DEACT_ORPHAN, srp->frq_pc_bm);
 		}
 	}
-	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	__set_bit(SG_FRQ_PC_ISSUED, srp->frq_pc_bm);
 	sg_rq_chg_state_force_ulck(srp, rqq_state);	/* normally --> SG_RQ_AWAIT_RCV */
 	WRITE_ONCE(srp->rqq, NULL);
-	if (test_bit(SG_FRQ_PC_COUNT_ACTIVE, srp->frq_pc_bm)) {
-		int num = atomic_inc_return(&sfp->waiting);
+	if (test_bit(SG_FRQ_PC_POLLABLE, srp->frq_pc_bm))
+		num = atomic_inc_return(&sfp->poll_waiting);
+	else
+		num = atomic_inc_return(&sfp->nonp_waiting);
+	if (num < 2) {
+		WRITE_ONCE(sfp->low_await_idx, srp->rq_idx);
+	} else {
+		int l_await_idx = READ_ONCE(sfp->low_await_idx);
 
-		if (num < 2) {
+		if (l_await_idx < 0 || srp->rq_idx < l_await_idx ||
+		    !xa_get_mark(&sfp->srp_arr, l_await_idx, SG_XA_RQ_AWAIT))
 			WRITE_ONCE(sfp->low_await_idx, srp->rq_idx);
-		} else {
-			int l_await_idx = READ_ONCE(sfp->low_await_idx);
-
-			if (l_await_idx < 0 || srp->rq_idx < l_await_idx ||
-			    !xa_get_mark(&sfp->srp_arr, l_await_idx, SG_XA_RQ_AWAIT))
-				WRITE_ONCE(sfp->low_await_idx, srp->rq_idx);
-		}
 	}
 	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 	/*
@@ -6007,7 +6052,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	 * can be called later from user context.
 	 */
 	scsi_req_free_cmd(scsi_rp);
-	blk_put_request(rqq);
+	blk_put_request(rqq);		/* may want to delay this in HIPRI case */
 
 	if (unlikely(rqq_state != SG_RQ_AWAIT_RCV)) {
 		/* clean up orphaned request that aren't being kept */
@@ -6640,13 +6685,18 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 	struct bio *bio;
 	__maybe_unused char b[32];
 
+	if (xa_get_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_INACTIVE)) {
+		SG_LOG(1, sfp, "%s: warning: already inactive srp=0x%pK\n", __func__, srp);
+		return;
+	}
 	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp, sg_get_rsv_str_lck(srp, " ", "",
 									      sizeof(b), b));
-	if (test_and_clear_bit(SG_FRQ_PC_COUNT_ACTIVE, srp->frq_pc_bm)) {
-		if (atomic_dec_and_test(&sfp->submitted))
-			clear_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
-		atomic_dec_return_release(&sfp->waiting);
-	}
+	if (atomic_dec_and_test(&sfp->submitted))
+		clear_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
+	if (test_bit(SG_FRQ_PC_POLLABLE, srp->frq_pc_bm))
+		atomic_dec_return_release(&sfp->poll_waiting);
+	else
+		atomic_dec_return_release(&sfp->nonp_waiting);
 	/* Expect blk_put_request(rqq) already called in sg_rq_end_io() */
 	if (unlikely(rqq)) {
 		WRITE_ONCE(srp->rqq, NULL);
@@ -6827,98 +6877,78 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 }
 
 /*
- * If there are many requests outstanding, the speed of this function is important. 'id' is pack_id
- * when is_tag=false, otherwise it is a tag. Both SG_PACK_ID_WILDCARD and SG_TAG_WILDCARD are -1
- * and that case is typically the fast path. This function is only used in the non-blocking cases.
- * Returns pointer to (first) matching sg_request or NULL. If found, sg_request state is moved
- * from SG_RQ_AWAIT_RCV to SG_RQ_BUSY.
+ * If there are many requests outstanding, the speed of this function is important. If the
+ * number waiting (divided into two counts: poll_waiting and nonp_waiting) is 0 then returns
+ * NULL. Otherwise it checks all the awaiting requests (after applying the constraints in
+ * sfp_p) and the first it finds, it tries to place it in busy state. If that succeeds the
+ * address of the request (a srp) is returned. If it fails, it keeps looking. If the requests
+ * are exhausted before one can be placed in busy state, then NULL is returned.
  */
 static struct sg_request *
-sg_get_srp_by_id(struct sg_fd *sfp, int id, bool is_tag, bool part_mrq)
+sg_find_srp_from(struct sg_fd_pollable *sfp_p)
 {
 	__maybe_unused bool is_bad_st = false;
-	bool search_for_1 = (id != SG_TAG_WILDCARD);
+	bool search_for_any = (sfp_p->find_by == SG_SEARCH_ANY || sfp_p->pack_id_tag == -1);
 	bool second = false;
 	int res;
-	int l_await_idx = READ_ONCE(sfp->low_await_idx);
 	unsigned long idx, s_idx;
 	unsigned long end_idx = ULONG_MAX;
+	struct sg_fd *fp = sfp_p->fp;
+	int l_await_idx = READ_ONCE(fp->low_await_idx);
 	struct sg_request *srp = NULL;
-	struct xarray *xafp = &sfp->srp_arr;
+	struct xarray *xafp = &fp->srp_arr;
 
-	if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm)) {
-		res = sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready to push up */
+	if (test_bit(SG_FFD_HIPRI_SEEN, fp->ffd_bm)) {
+		res = sg_sfp_blk_poll_first(fp);	/* LLD may have some ready to push up */
 		if (unlikely(res < 0))
 			return ERR_PTR(res);
 	}
-	if (sg_num_waiting_maybe_acquire(sfp) < 1)
+	if (sg_num_waiting_maybe_acquire(sfp_p) < 1)
 		return NULL;
 
 	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
 	idx = s_idx;
-	if (unlikely(search_for_1)) {
-second_time_for_1:
-		for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
-		     srp;
-		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
-			if (part_mrq != test_bit(SG_FRQ_PC_PART_MRQ, srp->frq_pc_bm))
-				continue;
-			if (!part_mrq && test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm))
-				continue;
-			if (unlikely(is_tag)) {
-				if (srp->tag != id)
+	/* first search from [s_idx ... end_idx) */
+second_time:
+	for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
+	     srp;
+	     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
+		if (sfp_p->part_mrq != test_bit(SG_FRQ_PC_PART_MRQ, srp->frq_pc_bm))
+			continue;
+		if (sfp_p->pollable != test_bit(SG_FRQ_PC_POLLABLE, srp->frq_pc_bm))
+			continue;
+		if (unlikely(!search_for_any)) {
+			if (sfp_p->find_by == SG_SEARCH_BY_TAG) {
+				if (srp->tag != sfp_p->pack_id_tag)
 					continue;
 			} else {
-				if (srp->pack_id != id)
+				if (srp->pack_id != sfp_p->pack_id_tag)
 					continue;
 			}
-			res = sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
-			if (likely(res == 0))
-				goto good;
-		}
-		/* If not found so far, need to wrap around and search [0 ... s_idx) */
-		if (!srp && !second && s_idx > 0) {
-			end_idx = s_idx - 1;
-			s_idx = 0;
-			idx = s_idx;
-			second = true;
-			goto second_time_for_1;
 		}
-	} else {
-		/*
-		 * Searching for _any_ request is the more likely usage. Start searching with the
-		 * last xarray index that was used. In the case of a large-ish IO depth, it is
-		 * likely that the second (relative) position will be the request we want, if it
-		 * is ready. If there is no queuing and the "last used" has been re-used then the
-		 * first (relative) position will be the request we want.
-		 */
-second_time_for_any:
-		for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
-		     srp;
-		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
-			if (test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm))
-				continue;
-			res = sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
-			if (likely(res == 0)) {
-				WRITE_ONCE(sfp->low_await_idx, idx + 1);
-				goto good;
-			}
+		res = sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
+		if (likely(res == 0)) {
+			if (search_for_any)
+				WRITE_ONCE(fp->low_await_idx, idx + 1);
+			goto good;
+		}
 #if IS_ENABLED(SG_LOG_ACTIVE)
-			sg_rq_state_fail_msg(sfp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY, __func__);
+		sg_rq_state_fail_msg(fp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY, __func__);
 #endif
-		}
-		if (!srp && !second && s_idx > 0) {
-			end_idx = s_idx - 1;
-			s_idx = 0;
-			idx = s_idx;
-			second = true;
-			goto second_time_for_any;
-		}
+	}
+	/* If not found so far, need to wrap around and search [0 ... s_idx) */
+	if (!srp && !second && s_idx > 0) {
+		end_idx = s_idx - 1;
+		s_idx = 0;
+		idx = s_idx;
+		second = true;
+		goto second_time;
 	}
 	return NULL;
 good:
-	SG_LOG(5, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, (is_tag ? "tag=" : "pack_id="),
-	       id, srp);
+	SG_LOG(5, fp, "%s: %s%d found [srp=0x%pK]\n", __func__,
+	       ((sfp_p->find_by == SG_SEARCH_BY_TAG) ? "tag=" : "pack_id="), sfp_p->pack_id_tag,
+	       srp);
 	return srp;
 }
 
@@ -7392,6 +7422,10 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 
 	if (WARN_ON(!sfp || !srp))
 		return;
+	if (xa_get_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_INACTIVE)) {
+		SG_LOG(4, sfp, "%s: warning: already inactive srp=0x%pK\n", __func__, srp);
+		return;
+	}
 	SG_LOG(3, sfp, "%s: srp=%pK\n", __func__, srp);
 	sbp = srp->sense_bp;
 	srp->sense_bp = NULL;
@@ -7444,7 +7478,8 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 	sfp->tot_fd_thresh = SG_TOT_FD_THRESHOLD;
 	atomic_set(&sfp->sum_fd_dlens, 0);
 	atomic_set(&sfp->submitted, 0);
-	atomic_set(&sfp->waiting, 0);
+	atomic_set(&sfp->poll_waiting, 0);
+	atomic_set(&sfp->nonp_waiting, 0);
 	atomic_set(&sfp->inactives, 0);
 	/*
 	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may be given as driver
@@ -7921,6 +7956,8 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, bool inactive,
 			       sg_shr_str(srp->sh_var, false));
 	if (srp->sgatp->num_sgat > 1)
 		n += scnprintf(obp + n, len - n, " sgat=%d", srp->sgatp->num_sgat);
+	if (test_bit(SG_FRQ_PC_POLLABLE, srp->frq_lt_bm))
+		n += scnprintf(obp + n, len - n, " pollable");
 	if (test_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm))
 		n += scnprintf(obp + n, len - n, " re-use_bio");
 	cp = (srp->rq_flags & SGV4_FLAG_HIPRI) ? "hipri " : "";
@@ -7977,9 +8014,10 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx, bool r
 		       fp->mmap_sz, READ_ONCE(fp->low_used_idx), READ_ONCE(fp->low_await_idx),
 		       atomic_read(&fp->sum_fd_dlens));
 	n += scnprintf(obp + n, len - n,
-		       "   submitted=%d waiting=%d inactives=%d   open thr_id=%d\n",
-		       atomic_read(&fp->submitted), atomic_read(&fp->waiting),
-		       atomic_read(&fp->inactives), fp->tid);
+		       "   submitted=%d poll_waiting=%d nonp_waiting=%d inactives=%d   %s=%d\n",
+		       atomic_read(&fp->submitted), atomic_read(&fp->poll_waiting),
+		       atomic_read(&fp->nonp_waiting), atomic_read(&fp->inactives),
+		       "open thr_id", fp->tid);
 	if (reduced)
 		return n;
 	k = 0;
-- 
2.25.1

