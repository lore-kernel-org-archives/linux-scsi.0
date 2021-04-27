Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B431C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BECE5613F1
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbhD0WAu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:50 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38909 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239382AbhD0WAe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 4546C2042AF;
        Tue, 27 Apr 2021 23:59:44 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LpjGiSu2a4Vx; Tue, 27 Apr 2021 23:59:40 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 3D9882041BD;
        Tue, 27 Apr 2021 23:59:37 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 79/83] sg: mrq: if uniform svb then re-use bio_s
Date:   Tue, 27 Apr 2021 17:57:29 -0400
Message-Id: <20210427215733.417746-81-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The array of sg_io_v4 objects given for share variable blocking
multiple requests (svb mrq) is pre-scanned to check for errors and
to apply certain fix-ups. Add further code to determine whether the
READs and WRITEs are of the same size and that no use is made of
SGV4_FLAG_DOUT_OFFSET. Also require that SGV4_FLAG_NO_DXFER is used
on the READs. If those requirements are met then term the svb mrq
as 'uniform svb' and set the SG_FFD_CAN_REUSE_BIO bit flag. To see
the benefit from this, the number of commands given to the uniform
svb needs to be greater than SG_MAX_RSV_REQS (currently 8).
Preferably two or more times that number.

As part of the above, divide the per sg_request bitmap (formerly:
frq_bm) into two bitmaps: frq_lt_bm and frq_pc_bm. The "lt" group
are long term, potentially spanning many SCSI commands that use a
sg_request object. The "pc" group are per command and pertain to
the current SCSI command being processed by the sg_request object.

Rework the sg_rq_map_kern() function.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 370 +++++++++++++++++++++++++++-------------------
 1 file changed, 222 insertions(+), 148 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ac7321ffbd05..0a0b40a8ab65 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -129,19 +129,22 @@ enum sg_shr_var {
 #define SG_ADD_RQ_MAX_RETRIES 40	/* to stop infinite _trylock(s) */
 #define SG_DEF_BLK_POLL_LOOP_COUNT 1000	/* may allow user to tweak this */
 
-/* Bit positions (flags) for sg_request::frq_bm bitmask follow */
-#define SG_FRQ_IS_V4I		0	/* true (set) when is v4 interface */
-#define SG_FRQ_IS_ORPHAN	1	/* owner of request gone */
-#define SG_FRQ_SYNC_INVOC	2	/* synchronous (blocking) invocation */
-#define SG_FRQ_US_XFER		3	/* kernel<-->user_space data transfer */
-#define SG_FRQ_ABORTING		4	/* in process of aborting this cmd */
-#define SG_FRQ_DEACT_ORPHAN	5	/* not keeping orphan so de-activate */
-#define SG_FRQ_RECEIVING	6	/* guard against multiple receivers */
-#define SG_FRQ_FOR_MMAP		7	/* request needs PAGE_SIZE elements */
-#define SG_FRQ_COUNT_ACTIVE	8	/* sfp->submitted + waiting active */
-#define SG_FRQ_ISSUED		9	/* blk_execute_rq_nowait() finished */
+/* Bit positions (flags) for sg_request::frq_lt_bm bitmask, lt: long term */
+#define SG_FRQ_LT_RESERVED	0	/* marks a reserved request */
+#define SG_FRQ_LT_REUSE_BIO	1	/* srp->bio primed for re-use */
+
+/* Bit positions (flags) for sg_request::frq_pc_bm bitmask. pc: per command */
+#define SG_FRQ_PC_IS_V4I	0	/* true (set) when is v4 interface */
+#define SG_FRQ_PC_IS_ORPHAN	1	/* owner of request gone */
+#define SG_FRQ_PC_SYNC_INVOC	2	/* synchronous (blocking) invocation */
+#define SG_FRQ_PC_US_XFER	3	/* kernel<-->user_space data transfer */
+#define SG_FRQ_PC_ABORTING	4	/* in process of aborting this cmd */
+#define SG_FRQ_PC_DEACT_ORPHAN	5	/* not keeping orphan so de-activate */
+#define SG_FRQ_PC_RECEIVING	6	/* guard against multiple receivers */
+#define SG_FRQ_PC_FOR_MMAP	7	/* request needs PAGE_SIZE elements */
+#define SG_FRQ_PC_COUNT_ACTIVE	8	/* sfp->submitted + waiting active */
+#define SG_FRQ_PC_ISSUED	9	/* blk_execute_rq_nowait() finished */
 #define SG_FRQ_POLL_SLEPT	10	/* stop re-entry of hybrid_sleep() */
-#define SG_FRQ_RESERVED		11	/* marks a reserved request */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
@@ -159,6 +162,7 @@ enum sg_shr_var {
 #define SG_FFD_EXCL_WAITQ	12	/* append _exclusive to wait_event */
 #define SG_FFD_SVB_ACTIVE	13	/* shared variable blocking active */
 #define SG_FFD_RESHARE		14	/* reshare limits to single rsv req */
+#define SG_FFD_CAN_REUSE_BIO	15	/* uniform svb --> can re-use bio_s */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -185,6 +189,7 @@ static int sg_allow_dio = SG_ALLOW_DIO_DEF;	/* ignored by code */
 
 static int scatter_elem_sz = SG_SCATTER_SZ;
 static bool no_attach_msg;
+static atomic_t sg_tmp_count_reused_bios;
 
 #define SG_DEF_SECTOR_SZ 512
 
@@ -264,7 +269,8 @@ struct sg_request {	/* active SCSI command or inactive request */
 	int tag;		/* block layer identifier of request */
 	blk_qc_t cookie;	/* ids 1 or more queues for blk_poll() */
 	u64 start_ns;		/* starting point of command duration calc */
-	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
+	unsigned long frq_lt_bm[1];	/* see SG_FRQ_LT_* defines above */
+	unsigned long frq_pc_bm[1];	/* see SG_FRQ_PC_* defines above */
 	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */
 	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */
 	struct request *rqq;	/* released in sg_rq_end_io(), bio kept */
@@ -327,8 +333,8 @@ struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 	int rsv_idx;		/* wanted rsv_arr index, def: -1 (anyone) */
 	int dlen;		/* dout or din length in bytes */
 	int wr_offset;		/* non-zero if v4 and DOUT_OFFSET set */
-	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
-	union {		/* selector is frq_bm.SG_FRQ_IS_V4I */
+	unsigned long frq_pc_bm[1];	/* see SG_FRQ_PC_* defines above */
+	union {		/* selector is frq_pc_bm.SG_FRQ_IS_V4I */
 		struct sg_io_hdr *h3p;
 		struct sg_io_v4 *h4p;
 	};
@@ -422,7 +428,7 @@ static void sg_take_snap(struct sg_fd *sfp, bool clear_first);
 #define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
 #define SG_IS_O_NONBLOCK(sfp) (!!((sfp)->filp->f_flags & O_NONBLOCK))
 #define SG_RQ_ACTIVE(srp) (atomic_read(&(srp)->rq_st) != SG_RQ_INACTIVE)
-#define SG_IS_V4I(srp) test_bit(SG_FRQ_IS_V4I, (srp)->frq_bm)
+#define SG_IS_V4I(srp) test_bit(SG_FRQ_PC_IS_V4I, (srp)->frq_pc_bm)
 
 /*
  * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log messages. 'depth' is a number
@@ -486,7 +492,8 @@ static void sg_take_snap(struct sg_fd *sfp, bool clear_first);
  *		SG_IOABORT: no match on pack_id or tag; mrq: no active reqs
  * ENODEV	target (SCSI) device associated with the fd has "disappeared"
  * ENOMEM	obvious; could be some pre-allocated cache that is exhausted
- * ENOMSG	data transfer setup needed or (direction) disallowed (sharing)
+ * ENOMSG	data transfer setup needed or (direction) disallowed (sharing);
+ *		inconsistency in share settings (mrq)
  * ENOSTR	write-side request abandoned due to read-side error or state
  * ENOTSOCK	sharing: file descriptor for sharing unassociated with sg driver
  * ENXIO	'no such device or address' SCSI mid-level processing errors
@@ -762,7 +769,7 @@ static inline void
 sg_comm_wr_init(struct sg_comm_wr_t *cwrp)
 {
 	memset(cwrp, 0, sizeof(*cwrp));
-	WRITE_ONCE(cwrp->frq_bm[0], 0);
+	/* WRITE_ONCE(cwrp->frq_pc_bm[0], 0); */
 	cwrp->rsv_idx = -1;
 }
 
@@ -979,7 +986,7 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync, struct sg_reque
 		clear_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(hp->timeout);
 	sg_comm_wr_init(&cwr);
-	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
+	__assign_bit(SG_FRQ_PC_SYNC_INVOC, cwr.frq_pc_bm, (int)sync);
 	cwr.h3p = hp;
 	cwr.dlen = hp->dxfer_len;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
@@ -1256,7 +1263,7 @@ sg_srp_hybrid_sleep(struct sg_request *srp)
 	enum hrtimer_mode mode;
 	ktime_t kt = ns_to_ktime(5000);
 
-	if (test_and_set_bit(SG_FRQ_POLL_SLEPT, srp->frq_bm))
+	if (test_and_set_bit(SG_FRQ_POLL_SLEPT, srp->frq_pc_bm))
 		return false;
 	if (kt == 0)
 		return false;
@@ -1303,7 +1310,7 @@ sg_wait_poll_for_given_srp(struct sg_fd *sfp, struct sg_request *srp, bool do_po
 	/* N.B. The SG_FFD_EXCL_WAITQ flag is ignored here. */
 	res = __wait_event_interruptible(sfp->cmpl_wait, sg_rq_landed(sdp, srp));
 	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
-		set_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
+		set_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm);
 		/* orphans harvested when sfp->keep_orphan is false */
 		sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
 		SG_LOG(1, sfp, "%s:  wait_event_interruptible(): %s[%d]\n", __func__,
@@ -1355,7 +1362,7 @@ sg_wait_poll_for_given_srp(struct sg_fd *sfp, struct sg_request *srp, bool do_po
 		return sg_rq_chg_state(srp, sr_st, SG_RQ_BUSY);
 	}
 	if (atomic_read_acquire(&srp->rq_st) != SG_RQ_AWAIT_RCV)
-		return (test_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm) &&
+		return (test_bit(SG_FRQ_PC_COUNT_ACTIVE, srp->frq_pc_bm) &&
 			atomic_read(&sfp->submitted) < 1) ? -ENODATA : 0;
 	return unlikely(sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY)) ? -EPROTO : 0;
 
@@ -1483,13 +1490,15 @@ sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp, struct sg_fd *sec_sf
  * a strict READ (like) thence WRITE (like) sequence on all data carrying commands; also
  * a dangling READ is not allowed at the end of a scb request array.
  */
-static bool
-sg_mrq_sanity(struct sg_mrq_hold *mhp, bool is_svb)
+static int
+sg_mrq_prepare(struct sg_mrq_hold *mhp, bool is_svb)
 {
 	bool last_is_keep_share = false;
 	bool expect_wr = false;
+	bool uniform_svb = true;	/* no dxfr to user space, all data moves same size */
 	bool share, have_mrq_sense, have_file_share;
-	int k;
+	int k, dlen;
+	int prev_dlen = 0;
 	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 	u32 cdb_alen = cop->request_len;
 	u32 cdb_mxlen = cdb_alen / mhp->tot_reqs;
@@ -1504,7 +1513,7 @@ sg_mrq_sanity(struct sg_mrq_hold *mhp, bool is_svb)
 	have_file_share = sg_fd_is_shared(sfp);
 	if (is_svb && unlikely(!have_file_share)) {
 		SG_LOG(1, sfp, "%s: share variable blocking (svb) needs file share\n", __func__);
-		return false;
+		return -ENOMSG;
 	}
 	/* Pre-check each request for anomalies, plus some preparation */
 	for (k = 0, hp = a_hds; k < mhp->tot_reqs; ++k, ++hp) {
@@ -1512,11 +1521,11 @@ sg_mrq_sanity(struct sg_mrq_hold *mhp, bool is_svb)
 		sg_v4h_partial_zero(hp);
 		if (unlikely(hp->guard != 'Q' || hp->protocol != 0 || hp->subprotocol != 0)) {
 			SG_LOG(1, sfp, "%s: req index %u: bad guard or protocol\n", __func__, k);
-			return false;
+			return -EPERM;
 		}
 		if (unlikely(flags & SGV4_FLAG_MULTIPLE_REQS)) {
 			SG_LOG(1, sfp, "%s: %s %u: no nested multi-reqs\n", __func__, rip, k);
-			return false;
+			return -ERANGE;
 		}
 		share = !!(flags & SGV4_FLAG_SHARE);
 		last_is_keep_share = !!(flags & SGV4_FLAG_KEEP_SHARE);
@@ -1524,27 +1533,27 @@ sg_mrq_sanity(struct sg_mrq_hold *mhp, bool is_svb)
 		    unlikely(flags & (SGV4_FLAG_DO_ON_OTHER | SGV4_FLAG_COMPLETE_B4))) {
 			SG_LOG(1, sfp, "%s: %s %u, no IMMED with ON_OTHER or COMPLETE_B4\n",
 			       __func__, rip, k);
-			return false;
+			return -ERANGE;
 		}
 		if (mhp->immed && unlikely(share)) {
 			SG_LOG(1, sfp, "%s: %s %u, no IMMED with FLAG_SHARE\n", __func__, rip, k);
-			return false;
+			return -ENOMSG;
 		}
 		if (mhp->co_mmap && (flags & SGV4_FLAG_MMAP_IO)) {
 			SG_LOG(1, sfp, "%s: %s %u, MMAP in co AND here\n", __func__, rip, k);
-			return false;
+			return -ERANGE;
 		}
 		if (unlikely(!have_file_share && share)) {
 			SG_LOG(1, sfp, "%s: %s %u, no file share\n", __func__, rip, k);
-			return false;
+			return -ENOMSG;
 		}
 		if (unlikely(!have_file_share && !!(flags & SGV4_FLAG_DO_ON_OTHER))) {
 			SG_LOG(1, sfp, "%s: %s %u, no other fd to do on\n", __func__, rip, k);
-			return false;
+			return -ENOMSG;
 		}
 		if (cdb_ap && unlikely(hp->request_len > cdb_mxlen)) {
 			SG_LOG(1, sfp, "%s: %s %u, cdb too long\n", __func__, rip, k);
-			return false;
+			return -ERANGE;
 		}
 		if (have_mrq_sense && hp->response == 0 && hp->max_response_len == 0) {
 			hp->response = cop->response;
@@ -1558,43 +1567,66 @@ sg_mrq_sanity(struct sg_mrq_hold *mhp, bool is_svb)
 		/* mrq share variable blocking (svb) additional constraints checked here */
 		if (unlikely(flags & (SGV4_FLAG_COMPLETE_B4 | SGV4_FLAG_KEEP_SHARE))) {
 			SG_LOG(1, sfp, "%s: %s %u: no KEEP_SHARE with svb\n", __func__, rip, k);
-			return false;
+			return -ENOMSG;
 		}
+		dlen = 0;
 		if (!expect_wr) {
+			dlen = hp->din_xfer_len;
 			if (hp->dout_xfer_len > 0)
 				goto bad_svb;
-			if (hp->din_xfer_len > 0) {
+			if (dlen > 0) {
 				if (!(flags & SGV4_FLAG_SHARE))
 					goto bad_svb;
 				if (flags & SGV4_FLAG_DO_ON_OTHER)
 					goto bad_svb;
 				expect_wr = true;
+				if (!(flags & SGV4_FLAG_NO_DXFER))
+					uniform_svb = false;
 			}
 			/* allowing commands with no dxfer (in both cases) */
 		} else {	/* checking write side */
-			if (hp->dout_xfer_len > 0) {
+			dlen = hp->dout_xfer_len;
+			if (dlen > 0) {
 				if (unlikely(~flags & (SGV4_FLAG_NO_DXFER | SGV4_FLAG_SHARE |
 						       SGV4_FLAG_DO_ON_OTHER)))
 					goto bad_svb;
 				expect_wr = false;
+				if (unlikely(flags & SGV4_FLAG_DOUT_OFFSET))
+					uniform_svb = false;
 			} else if (unlikely(hp->din_xfer_len > 0)) {
 				goto bad_svb;
 			}
 		}
+		if (!uniform_svb)
+			continue;
+		if (prev_dlen == 0)
+			prev_dlen = dlen;
+		else if (dlen != prev_dlen)
+			uniform_svb = false;
 	}		/* end of request array iterating loop */
 	if (last_is_keep_share) {
 		SG_LOG(1, sfp, "%s: Can't set SGV4_FLAG_KEEP_SHARE on last mrq req\n", __func__);
-		return false;
+		return -ENOMSG;
 	}
 	if (is_svb && expect_wr) {
 		SG_LOG(1, sfp, "%s: svb: unpaired READ at end of request array\n", __func__);
-		return false;
+		return -ENOMSG;
 	}
-	return true;
+	if (is_svb) {
+		bool cur_uniform_svb = test_bit(SG_FFD_CAN_REUSE_BIO, sfp->ffd_bm);
+
+		if (uniform_svb != cur_uniform_svb) {
+			if (uniform_svb)
+				set_bit(SG_FFD_CAN_REUSE_BIO, sfp->ffd_bm);
+			else
+				clear_bit(SG_FFD_CAN_REUSE_BIO, sfp->ffd_bm);
+		}
+	}
+	return 0;
 bad_svb:
 	SG_LOG(1, sfp, "%s: %s %u: svb alternating read-then-write or flags bad\n", __func__,
 	       rip, k);
-	return false;
+	return -ENOMSG;
 }
 
 /* rsv_idx>=0 only when this request is the write-side of a request share */
@@ -1615,8 +1647,8 @@ sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_in_rq_arr,
 	r_cwrp->cmd_len = hp->request_len;
 	r_cwrp->rsv_idx = rsv_idx;
 	ul_timeout = msecs_to_jiffies(hp->timeout);
-	__assign_bit(SG_FRQ_SYNC_INVOC, r_cwrp->frq_bm, (int)mhp->from_sg_io);
-	__set_bit(SG_FRQ_IS_V4I, r_cwrp->frq_bm);
+	__assign_bit(SG_FRQ_PC_SYNC_INVOC, r_cwrp->frq_pc_bm, (int)mhp->from_sg_io);
+	__set_bit(SG_FRQ_PC_IS_V4I, r_cwrp->frq_pc_bm);
 	r_cwrp->h4p = hp;
 	r_cwrp->dlen = hp->din_xfer_len ? hp->din_xfer_len : hp->dout_xfer_len;
 	r_cwrp->timeout = min_t(unsigned long, ul_timeout, INT_MAX);
@@ -1985,6 +2017,21 @@ sg_svb_mrq_ordered(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 	return 0;
 }
 
+static void
+sg_svb_cleanup(struct sg_fd *sfp)
+{
+	unsigned long idx;
+	struct xarray *xafp = &sfp->srp_arr;
+	struct sg_request *srp;
+
+	xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_INACTIVE) {
+		if (test_and_clear_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm)) {
+			bio_put(srp->bio);	/* _get() near end of sg_start_req() */
+			srp->bio = NULL;
+		}
+	}
+}
+
 /*
  * Processes shared variable blocking (svb) method for multiple requests (mrq). There are two
  * variants: unordered write-side requests; and ordered write-side requests. The read-side requests
@@ -2040,12 +2087,15 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp, struct sg_mrq_hold *mh
 	}
 	if (mhp->id_of_mrq)	/* can no longer do a mrq abort */
 		atomic_set(&fp->mrq_id_abort, 0);
+	if (test_and_clear_bit(SG_FFD_CAN_REUSE_BIO, fp->ffd_bm))
+		sg_svb_cleanup(fp);
 	return res;
 }
 
 #if IS_ENABLED(SG_LOG_ACTIVE)
+/* Returns a descriptive string for the different mrq varieties */
 static const char *
-sg_mrq_name(bool from_sg_io, u32 flags)
+sg_mrq_var_str(bool from_sg_io, u32 flags)
 {
 	if (!(flags & SGV4_FLAG_MULTIPLE_REQS))
 		return "_not_ multiple requests control object";
@@ -2063,7 +2113,8 @@ sg_mrq_name(bool from_sg_io, u32 flags)
  * Implements the multiple request functionality. When from_sg_io is true invocation was via
  * ioctl(SG_IO), otherwise it was via ioctl(SG_IOSUBMIT). Submit non-blocking if IMMED flag given
  * or when ioctl(SG_IOSUBMIT) is used with O_NONBLOCK set on its file descriptor. Hipri
- * non-blocking is when the HIPRI flag is given.
+ * non-blocking is when the HIPRI flag is given. Note that on this fd, svb cannot be started
+ * if any mrq is in progress and no mrq can be started if svb is in progress.
  */
 static int
 sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
@@ -2085,13 +2136,13 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	struct sg_mrq_hold mh;
 	struct sg_mrq_hold *mhp = &mh;
 #if IS_ENABLED(SG_LOG_ACTIVE)
-	const char *mrq_name;
+	const char *mrq_vs;
 #endif
 
 	mhp->cwrp = cwrp;
 	mhp->from_sg_io = from_sg_io; /* false if from SG_IOSUBMIT */
 #if IS_ENABLED(SG_LOG_ACTIVE)
-	mrq_name = sg_mrq_name(from_sg_io, cop->flags);
+	mrq_vs = sg_mrq_var_str(from_sg_io, cop->flags);
 #endif
 	f_non_block = !!(fp->filp->f_flags & O_NONBLOCK);
 	is_svb = !!(cop->flags & SGV4_FLAG_SHARE);	/* via ioctl(SG_IOSUBMIT) only */
@@ -2135,7 +2186,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	}
 	if (!mhp->immed && f_non_block)
 		mhp->immed = true;	/* hmm, think about this */
-	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, id_of_mrq=%d\n", __func__, mrq_name, tot_reqs,
+	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, id_of_mrq=%d\n", __func__, mrq_vs, tot_reqs,
 	       mhp->id_of_mrq);
 	sg_v4h_partial_zero(cop);
 
@@ -2177,8 +2228,13 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 
 	if (SG_IS_DETACHING(sdp) || (o_sfp && SG_IS_DETACHING(o_sfp->parentdp)))
 		return -ENODEV;
-	if (is_svb && unlikely(test_and_set_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm))) {
-		SG_LOG(1, fp, "%s: %s already active\n", __func__, mrq_name);
+	if (is_svb) {
+		if (unlikely(test_and_set_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm))) {
+			SG_LOG(1, fp, "%s: %s already active\n", __func__, mrq_vs);
+			return -EBUSY;
+		}
+	} else if (unlikely(test_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm))) {
+		SG_LOG(1, fp, "%s: %s disallowed with existing svb\n", __func__, mrq_vs);
 		return -EBUSY;
 	}
 	a_hds = kcalloc(tot_reqs, SZ_SG_IO_V4, GFP_KERNEL | __GFP_NOWARN);
@@ -2205,11 +2261,10 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool from_sg_io)
 	mhp->cdb_ap = cdb_ap;
 	mhp->a_hds = a_hds;
 	mhp->cdb_mxlen = cdb_mxlen;
-	/* do sanity checks on all requests before starting */
-	if (unlikely(!sg_mrq_sanity(mhp, is_svb))) {
-		res = -ERANGE;
+	/* do pre-scan on mrq array for sanity and fix-ups */
+	res = sg_mrq_prepare(mhp, is_svb);
+	if (unlikely(res))
 		goto fini;
-	}
 
 	/* override cmd queuing setting to allow */
 	clear_bit(SG_FFD_NO_CMD_Q, fp->ffd_bm);
@@ -2276,8 +2331,8 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p, bool from_
 		clear_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(h4p->timeout);
 	cwr.sfp = sfp;
-	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)from_sg_io);
-	__set_bit(SG_FRQ_IS_V4I, cwr.frq_bm);
+	__assign_bit(SG_FRQ_PC_SYNC_INVOC, cwr.frq_pc_bm, (int)from_sg_io);
+	__set_bit(SG_FRQ_PC_IS_V4I, cwr.frq_pc_bm);
 	cwr.h4p = h4p;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	cwr.cmd_len = h4p->request_len;
@@ -2596,11 +2651,11 @@ sg_get_probable_read_side(struct sg_fd *sfp)
 	struct sg_request *rs_srp;
 	struct sg_request *rs_inactive_srp = NULL;
 
-	for (rapp = sfp->rsv_arr; rapp < rapp + SG_MAX_RSV_REQS; ++rapp) {
+	for (rapp = sfp->rsv_arr; rapp < sfp->rsv_arr + SG_MAX_RSV_REQS; ++rapp) {
 		rs_srp = *rapp;
 		if (IS_ERR_OR_NULL(rs_srp) || rs_srp->sh_srp)
 			continue;
-		switch (atomic_read_acquire(&rs_srp->rq_st)) {
+		switch (atomic_read(&rs_srp->rq_st)) {
 		case SG_RQ_INFLIGHT:
 		case SG_RQ_AWAIT_RCV:
 		case SG_RQ_BUSY:
@@ -2685,7 +2740,7 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 		srp->start_ns = ktime_get_boottime_ns();/* assume always > 0 */
 	srp->duration = 0;
 
-	if (!test_bit(SG_FRQ_IS_V4I, srp->frq_bm) && srp->s_hdr3.interface_id == '\0')
+	if (!test_bit(SG_FRQ_PC_IS_V4I, srp->frq_pc_bm) && srp->s_hdr3.interface_id == '\0')
 		at_head = true;	/* backward compatibility for v1+v2 interfaces */
 	else if (test_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm))
 		/* cmd flags can override sfd setting */
@@ -2696,16 +2751,16 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 	kref_get(&sfp->f_ref); /* put usually in: sg_rq_end_io() */
 	sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
 	/* >>>>>>> send cmd/req off to other levels <<<<<<<< */
-	if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
+	if (!test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm)) {
 		atomic_inc(&sfp->submitted);
-		set_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm);
+		set_bit(SG_FRQ_PC_COUNT_ACTIVE, srp->frq_pc_bm);
 	}
 	if (srp->rq_flags & SGV4_FLAG_HIPRI) {
 		rqq->cmd_flags |= REQ_HIPRI;
 		srp->cookie = request_to_qc_t(rqq->mq_hctx, rqq);
 	}
 	blk_execute_rq_nowait(sdp->disk, rqq, (int)at_head, sg_rq_end_io);
-	set_bit(SG_FRQ_ISSUED, srp->frq_bm);
+	set_bit(SG_FRQ_PC_ISSUED, srp->frq_pc_bm);
 }
 
 /*
@@ -2729,7 +2784,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 	struct sg_io_hdr *hi_p;
 	struct sg_io_v4 *h4p;
 
-	if (likely(test_bit(SG_FRQ_IS_V4I, cwrp->frq_bm))) {
+	if (likely(test_bit(SG_FRQ_PC_IS_V4I, cwrp->frq_pc_bm))) {
 		h4p = cwrp->h4p;
 		hi_p = NULL;
 		dir = SG_DXFER_NONE;
@@ -2830,7 +2885,7 @@ sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int id, bool is_ta
 
 /* Returns number of bytes copied to user space provided sense buffer or negated errno value. */
 static int
-sg_copy_sense(struct sg_request *srp, bool v4_active)
+sg_copy_sense(struct sg_request *srp)
 {
 	int sb_len_ret = 0;
 	int scsi_stat;
@@ -2845,7 +2900,7 @@ sg_copy_sense(struct sg_request *srp, bool v4_active)
 		void __user *up;
 
 		srp->sense_bp = NULL;
-		if (v4_active) {
+		if (SG_IS_V4I(srp)) {
 			up = uptr64(srp->s_hdr4.sbp);
 			mx_sb_len = srp->s_hdr4.max_sb_len;
 		} else {
@@ -2866,7 +2921,7 @@ sg_copy_sense(struct sg_request *srp, bool v4_active)
 }
 
 static int
-sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
+sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp)
 {
 	int err = 0;
 	u32 rq_res = srp->rq_result;
@@ -2877,13 +2932,13 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	if (unlikely(!sg_result_is_good(rq_res))) {
 		srp->rq_info |= SG_INFO_CHECK;
 		if (!scsi_status_is_good(rq_res)) {
-			int sb_len_wr = sg_copy_sense(srp, v4_active);
+			int sb_len_wr = sg_copy_sense(srp);
 
 			if (unlikely(sb_len_wr < 0))
 				return sb_len_wr;
 		}
 	}
-	if (unlikely(test_bit(SG_FRQ_ABORTING, srp->frq_bm)))
+	if (unlikely(test_bit(SG_FRQ_PC_ABORTING, srp->frq_pc_bm)))
 		srp->rq_info |= SG_INFO_ABORTED;
 
 	if (sh_var == SG_SHR_WS_RQ && sg_fd_is_shared(sfp)) {
@@ -2930,7 +2985,7 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	rs_srp->sh_var = SG_SHR_NONE;
 	sg_rq_chg_state_force(rs_srp, SG_RQ_INACTIVE);
 	atomic_inc(&rs_srp->parentfp->inactives);
-	rs_srp->frq_bm[0] &= (1 << SG_FRQ_RESERVED);
+	rs_srp->frq_pc_bm[0] = 0;
 	rs_srp->in_resid = 0;
 	rs_srp->rq_info = 0;
 	rs_srp->sense_len = 0;
@@ -3008,7 +3063,7 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p, struct
 
 	SG_LOG(3, sfp, "%s: p=%s, h4p=%s\n", __func__, (p ? "given" : "NULL"),
 	       (h4p ? "given" : "NULL"));
-	err = sg_rec_state_v3v4(sfp, srp, true);
+	err = sg_rec_state_v3v4(sfp, srp);
 	h4p->guard = 'Q';
 	h4p->protocol = 0;
 	h4p->subprotocol = 0;
@@ -3155,7 +3210,7 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool n
 	return res;
 }
 
-// sg_wait_id_event
+/* Either wait for command completion matching id ('-1': any); or poll for it if do_poll==true */
 static int
 sg_wait_poll_by_id(struct sg_fd *sfp, struct sg_request **srpp, int id,
 		   bool is_tag, int do_poll)
@@ -3248,7 +3303,7 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 	}
-	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
+	if (test_and_set_bit(SG_FRQ_PC_RECEIVING, srp->frq_pc_bm)) {
 		cpu_relax();
 		goto try_again;
 	}
@@ -3302,7 +3357,7 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 		if (IS_ERR(srp))
 			return PTR_ERR(srp);
 	}
-	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
+	if (test_and_set_bit(SG_FRQ_PC_RECEIVING, srp->frq_pc_bm)) {
 		cpu_relax();
 		goto try_again;
 	}
@@ -3475,7 +3530,7 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 		if (IS_ERR(srp))
 			return PTR_ERR(srp);
 	}
-	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
+	if (test_and_set_bit(SG_FRQ_PC_RECEIVING, srp->frq_pc_bm)) {
 		cpu_relax();
 		goto try_again;
 	}
@@ -3511,7 +3566,7 @@ sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, void __user *p)
 
 	SG_LOG(3, sfp, "%s: sh_var: %s srp=0x%pK\n", __func__, sg_shr_str(srp->sh_var, false),
 	       srp);
-	err = sg_rec_state_v3v4(sfp, srp, false);
+	err = sg_rec_state_v3v4(sfp, srp);
 	memset(hp, 0, sizeof(*hp));
 	memcpy(hp, &srp->s_hdr3, sizeof(srp->s_hdr3));
 	hp->sb_len_wr = srp->sense_len;
@@ -3645,7 +3700,6 @@ sg_finish_rs_rq(struct sg_fd *sfp, struct sg_request *rs_srp, bool even_if_in_ws
 		atomic_inc(&rs_sfp->inactives);
 	rs_rsv_srp->tag = SG_TAG_WILDCARD;
 	rs_rsv_srp->sh_var = SG_SHR_NONE;
-	set_bit(SG_FRQ_RESERVED, rs_rsv_srp->frq_bm);
 	rs_rsv_srp->in_resid = 0;
 	rs_rsv_srp->rq_info = 0;
 	rs_rsv_srp->sense_len = 0;
@@ -3758,7 +3812,7 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 			rsv_srp = *rapp;
 			if (IS_ERR_OR_NULL(rsv_srp) || rsv_srp->sh_var != SG_SHR_RS_RQ)
 				continue;
-			sr_st = atomic_read_acquire(&rsv_srp->rq_st);
+			sr_st = atomic_read(&rsv_srp->rq_st);
 			switch (sr_st) {
 			case SG_RQ_SHR_SWAP:
 				set_inactive = true;
@@ -3949,8 +4003,8 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp, struct sg_req
 	rip->duration = sg_get_dur(srp, NULL, test_bit(SG_FFD_TIME_IN_NS, sfp->ffd_bm), NULL);
 	if (rip->duration == U32_MAX)
 		rip->duration = 0;
-	rip->orphan = test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
-	rip->sg_io_owned = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
+	rip->orphan = test_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm);
+	rip->sg_io_owned = test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm);
 	rip->problem = !sg_result_is_good(srp->rq_result);
 	rip->pack_id = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm) ? srp->tag : srp->pack_id;
 	rip->usr_ptr = SG_IS_V4I(srp) ? uptr64(srp->s_hdr4.usr_ptr) : srp->s_hdr3.usr_ptr;
@@ -4095,7 +4149,7 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 	enum sg_rq_state rq_st;
 	struct request *rqq;
 
-	if (test_and_set_bit(SG_FRQ_ABORTING, srp->frq_bm)) {
+	if (test_and_set_bit(SG_FRQ_PC_ABORTING, srp->frq_pc_bm)) {
 		SG_LOG(1, sfp, "%s: already aborting req pack_id/tag=%d/%d\n", __func__,
 		       srp->pack_id, srp->tag);
 		goto fini;	/* skip quietly if already aborted */
@@ -4105,16 +4159,16 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 	       sg_rq_st_str(rq_st, false));
 	switch (rq_st) {
 	case SG_RQ_BUSY:
-		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		clear_bit(SG_FRQ_PC_ABORTING, srp->frq_pc_bm);
 		res = -EBUSY;	/* should not occur often */
 		break;
 	case SG_RQ_INACTIVE:	/* perhaps done already */
-		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		clear_bit(SG_FRQ_PC_ABORTING, srp->frq_pc_bm);
 		break;
 	case SG_RQ_AWAIT_RCV:	/* user should still do completion */
 	case SG_RQ_SHR_SWAP:
 	case SG_RQ_SHR_IN_WS:
-		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		clear_bit(SG_FRQ_PC_ABORTING, srp->frq_pc_bm);
 		break;		/* nothing to do here, return 0 */
 	case SG_RQ_INFLIGHT:	/* only attempt abort if inflight */
 		srp->rq_result |= (DRIVER_SOFT << 24);
@@ -4125,7 +4179,7 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 		}
 		break;
 	default:
-		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		clear_bit(SG_FRQ_PC_ABORTING, srp->frq_pc_bm);
 		break;
 	}
 fini:
@@ -4523,10 +4577,13 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 		use_new_srp = true;
 		xa_for_each_marked(xafp, idx, t_srp, SG_XA_RQ_INACTIVE) {
 			if (t_srp != o_srp && new_sz <= t_srp->sgatp->buflen) {
+				bool is_reuse_bio = test_bit(SG_FRQ_LT_REUSE_BIO,
+							     o_srp->frq_lt_bm);
 				use_new_srp = false;
 				xa_lock_irqsave(xafp, iflags);
-				__clear_bit(SG_FRQ_RESERVED, o_srp->frq_bm);
-				__set_bit(SG_FRQ_RESERVED, t_srp->frq_bm);
+				__clear_bit(SG_FRQ_LT_RESERVED, o_srp->frq_lt_bm);
+				__set_bit(SG_FRQ_LT_RESERVED, t_srp->frq_lt_bm);
+				__assign_bit(SG_FRQ_LT_REUSE_BIO, t_srp->frq_lt_bm, is_reuse_bio);
 				*rapp = t_srp;
 				xa_unlock_irqrestore(xafp, iflags);
 				sg_remove_srp(n_srp);
@@ -4543,8 +4600,10 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 			idx = o_srp->rq_idx;
 			cxc_srp = __xa_cmpxchg(xafp, idx, o_srp, n_srp, GFP_ATOMIC);
 			if (o_srp == cxc_srp) {
-				__assign_bit(SG_FRQ_RESERVED, n_srp->frq_bm,
-					     test_bit(SG_FRQ_RESERVED, o_srp->frq_bm));
+				__assign_bit(SG_FRQ_LT_RESERVED, n_srp->frq_lt_bm,
+					     test_bit(SG_FRQ_LT_RESERVED, o_srp->frq_lt_bm));
+				__assign_bit(SG_FRQ_LT_REUSE_BIO, n_srp->frq_lt_bm,
+					     test_bit(SG_FRQ_LT_REUSE_BIO, o_srp->frq_lt_bm));
 				*rapp = n_srp;
 				sg_rq_chg_state_force_ulck(n_srp, SG_RQ_INACTIVE);
 				/* no bump of sfp->inactives since replacement */
@@ -4608,7 +4667,7 @@ sg_any_persistent_orphans(struct sg_fd *sfp)
 		if (sg_num_waiting_maybe_acquire(sfp) < 1)
 			return false;
 		xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_AWAIT) {
-			if (test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm))
+			if (test_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm))
 				return true;
 		}
 	}
@@ -4771,7 +4830,7 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 		if (rs_sfp && !IS_ERR_OR_NULL(rs_sfp->rsv_arr[0])) {
 			struct sg_request *res_srp = rs_sfp->rsv_arr[0];
 
-			if (atomic_read_acquire(&res_srp->rq_st) == SG_RQ_SHR_SWAP)
+			if (atomic_read(&res_srp->rq_st) == SG_RQ_SHR_SWAP)
 				c_flgs_val_out |= SG_CTL_FLAGM_READ_SIDE_FINI;
 			else
 				c_flgs_val_out &= ~SG_CTL_FLAGM_READ_SIDE_FINI;
@@ -5215,14 +5274,14 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp, uns
 		val = -1;
 		if (test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm)) {
 			xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
-				if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
+				if (!test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm)) {
 					val = srp->tag;
 					break;
 				}
 			}
 		} else {
 			xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
-				if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
+				if (!test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm)) {
 					val = srp->pack_id;
 					break;
 				}
@@ -5471,9 +5530,9 @@ sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
 	xa_lock_irqsave(xafp, iflags);
 	xa_for_each(xafp, idx, srp) {
 		if ((srp->rq_flags & SGV4_FLAG_HIPRI) &&
-		    !test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm) &&
+		    !test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm) &&
 		    atomic_read(&srp->rq_st) == SG_RQ_INFLIGHT &&
-		    test_bit(SG_FRQ_ISSUED, srp->frq_bm)) {
+		    test_bit(SG_FRQ_PC_ISSUED, srp->frq_pc_bm)) {
 			xa_unlock_irqrestore(xafp, iflags);
 			n = sg_srp_q_blk_poll(srp, q, loop_count);
 			if (n == -ENODATA)
@@ -5655,7 +5714,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	}
 	if (srp->sgat_h.page_order > 0 || req_sz > (unsigned long)srp->sgat_h.buflen) {
 		sg_remove_srp(srp);
-		set_bit(SG_FRQ_FOR_MMAP, srp->frq_bm);
+		set_bit(SG_FRQ_PC_FOR_MMAP, srp->frq_pc_bm);
 		res = sg_mk_sgat(srp, sfp, req_sz);
 		if (res) {
 			SG_LOG(1, sfp, "%s: sg_mk_sgat failed, wanted=%lu\n", __func__, req_sz);
@@ -5688,7 +5747,7 @@ sg_uc_rq_end_io_orphaned(struct work_struct *work)
 		return;
 	}
 	SG_LOG(3, sfp, "%s: srp=0x%pK\n", __func__, srp);
-	if (test_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm)) {
+	if (test_bit(SG_FRQ_PC_DEACT_ORPHAN, srp->frq_pc_bm)) {
 		sg_finish_scsi_blk_rq(srp);	/* clean up orphan case */
 		sg_deact_request(sfp, srp);
 	}
@@ -5730,7 +5789,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 			srp->in_resid = a_resid;
 		}
 	}
-	if (unlikely(test_bit(SG_FRQ_ABORTING, srp->frq_bm)) && sg_result_is_good(rq_result))
+	if (unlikely(test_bit(SG_FRQ_PC_ABORTING, srp->frq_pc_bm)) && sg_result_is_good(rq_result))
 		srp->rq_result |= (DRIVER_HARD << 24);
 
 	SG_LOG(6, sfp, "%s: pack/tag_id=%d/%d, cmd=0x%x, res=0x%x\n", __func__, srp->pack_id,
@@ -5764,19 +5823,19 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 		}
 	}
 	srp->sense_len = slen;
-	if (unlikely(test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm))) {
+	if (unlikely(test_bit(SG_FRQ_PC_IS_ORPHAN, srp->frq_pc_bm))) {
 		if (test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm)) {
-			__clear_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
+			__clear_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm);
 		} else {
 			rqq_state = SG_RQ_BUSY;
-			__set_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm);
+			__set_bit(SG_FRQ_PC_DEACT_ORPHAN, srp->frq_pc_bm);
 		}
 	}
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
-	__set_bit(SG_FRQ_ISSUED, srp->frq_bm);
+	__set_bit(SG_FRQ_PC_ISSUED, srp->frq_pc_bm);
 	sg_rq_chg_state_force_ulck(srp, rqq_state);	/* normally --> SG_RQ_AWAIT_RCV */
 	WRITE_ONCE(srp->rqq, NULL);
-	if (test_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
+	if (test_bit(SG_FRQ_PC_COUNT_ACTIVE, srp->frq_pc_bm)) {
 		int num = atomic_inc_return(&sfp->waiting);
 
 		if (num < 2) {
@@ -6200,6 +6259,7 @@ sg_rq_map_kern(struct sg_request *srp, struct request_queue *q, struct request *
 static int
 sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 {
+	bool bump_bio_get = false;
 	bool no_dxfer, us_xfer;
 	int res = 0;
 	int dlen = cwrp->dlen;
@@ -6286,7 +6346,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	srp->cmd_opcode = scsi_rp->cmd[0];
 	no_dxfer = dlen <= 0 || dxfer_dir == SG_DXFER_NONE;
 	us_xfer = !(rq_flags & (SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO));
-	__assign_bit(SG_FRQ_US_XFER, srp->frq_bm, !no_dxfer && us_xfer);
+	__assign_bit(SG_FRQ_PC_US_XFER, srp->frq_pc_bm, !no_dxfer && us_xfer);
 	rqq->end_io_data = srp;
 	scsi_rp->retries = SG_DEFAULT_RETRIES;
 	req_schp = srp->sgatp;
@@ -6301,7 +6361,24 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		md = NULL;
 		if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
 			cp = "direct_io, ";
-	} else {	/* normal IO and failed conditions for dio path */
+	} else if (test_bit(SG_FFD_CAN_REUSE_BIO, sfp->ffd_bm)) {
+		if (test_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm)) {
+			if (srp->bio) {
+				res = blk_rq_append_bio(rqq, &srp->bio);
+				if (res)
+					SG_LOG(1, sfp, "%s: blk_rq_append_bio err=%d\n", __func__,
+					       res);
+				md = NULL;
+				atomic_inc(&sg_tmp_count_reused_bios);
+			} else {
+				res = -EPROTO;
+			}
+			goto fini;
+		} else {	/* first use of bio, almost normal setup */
+			md = &map_data;
+			bump_bio_get = true;
+		}
+	} else {	/* normal indirect IO */
 		md = &map_data;
 	}
 
@@ -6355,6 +6432,12 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 #endif
 	} else {	/* transfer data to/from kernel buffers */
 		res = sg_rq_map_kern(srp, q, rqq, r0w);
+		if (res)
+			goto fini;
+		if (bump_bio_get) {	/* keep bio alive to re-use next time */
+			set_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm);
+			bio_get(rqq->bio);	/* _put() in sg_svb_cleanup() */
+		}
 	}
 fini:
 	if (unlikely(res)) {		/* failure, free up resources */
@@ -6385,11 +6468,12 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 	int ret;
 	struct sg_fd *sfp = srp->parentfp;
 	struct request *rqq = READ_ONCE(srp->rqq);
+	struct bio *bio;
 	__maybe_unused char b[32];
 
 	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp, sg_get_rsv_str_lck(srp, " ", "",
 									      sizeof(b), b));
-	if (test_and_clear_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
+	if (test_and_clear_bit(SG_FRQ_PC_COUNT_ACTIVE, srp->frq_pc_bm)) {
 		if (atomic_dec_and_test(&sfp->submitted))
 			clear_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
 		atomic_dec_return_release(&sfp->waiting);
@@ -6402,16 +6486,18 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 			scsi_req_free_cmd(scsi_req(rqq));
 		blk_put_request(rqq);
 	}
-	if (likely(srp->bio)) {
-		bool us_xfer = test_bit(SG_FRQ_US_XFER, srp->frq_bm);
-		struct bio *bio = srp->bio;
+	bio = srp->bio;
+	if (likely(bio)) {
+		bool us_xfer = test_bit(SG_FRQ_PC_US_XFER, srp->frq_pc_bm);
 
-		srp->bio = NULL;
-		if (us_xfer && bio) {
+		if (us_xfer) {
 			ret = blk_rq_unmap_user(bio);
 			if (unlikely(ret))	/* -EINTR (-4) can be ignored */
 				SG_LOG(6, sfp, "%s: blk_rq_unmap_user() --> %d\n", __func__, ret);
-		}
+			srp->bio = NULL;
+		} else if (!test_bit(SG_FRQ_LT_REUSE_BIO, srp->frq_lt_bm)) {
+			srp->bio = NULL;
+		} /* else may be able to re-use this bio [mrq, uniform svb] */
 	}
 	/* In worst case, READ data returned to user space by this point */
 }
@@ -6444,7 +6530,8 @@ sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
 		return -ENOMEM;
 
 	/* elem_sz must be power of 2 and >= PAGE_SIZE */
-	elem_sz = test_bit(SG_FRQ_FOR_MMAP, srp->frq_bm) ? (int)PAGE_SIZE : sfp->sgat_elem_sz;
+	elem_sz = test_bit(SG_FRQ_PC_FOR_MMAP, srp->frq_pc_bm) ? (int)PAGE_SIZE :
+								 sfp->sgat_elem_sz;
 	if (sdp && unlikely(sdp->device->host->unchecked_isa_dma))
 		mask_ap |= GFP_DMA;
 	o_order = get_order(elem_sz);
@@ -6606,7 +6693,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 		for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
 		     srp;
 		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
-			if (test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
+			if (test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm))
 				continue;
 			if (unlikely(is_tag)) {
 				if (srp->tag != id)
@@ -6639,7 +6726,7 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 		for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
 		     srp;
 		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
-			if (test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
+			if (test_bit(SG_FRQ_PC_SYNC_INVOC, srp->frq_pc_bm))
 				continue;
 			res = sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
 			if (likely(res == 0)) {
@@ -6849,7 +6936,7 @@ sg_setup_req_new_srp(struct sg_comm_wr_t *cwrp, bool new_rsv_srp, bool no_reqs,
 	       r_srp);
 	if (new_rsv_srp) {
 		fp->rsv_arr[ra_idx] = r_srp;
-		set_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
+		set_bit(SG_FRQ_LT_RESERVED, r_srp->frq_lt_bm);
 		r_srp->sh_srp = NULL;
 	}
 	xa_lock_irqsave(xafp, iflags);
@@ -6883,7 +6970,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 	bool no_reqs = false;
 	bool ws_rq = false;
 	bool try_harder = false;
-	bool keep_frq_bm = false;
+	bool keep_frq_pc_bm = false;
 	bool second = false;
 	int res, ra_idx, l_used_idx;
 	int dlen = cwrp->dlen;
@@ -6906,7 +6993,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 				r_srp = NULL;
 			} else {
 				atomic_dec(&fp->inactives);
-				keep_frq_bm = true;
+				keep_frq_pc_bm = true;
 				r_srp->sh_srp = NULL;
 				goto final_setup;
 			}
@@ -6917,7 +7004,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			goto maybe_new;
 		}
 		r_srp = fp->rsv_arr[ra_idx];
-		sr_st = atomic_read_acquire(&r_srp->rq_st);
+		sr_st = atomic_read(&r_srp->rq_st);
 		if (sr_st == SG_RQ_INACTIVE) {
 			res = sg_rq_chg_state(r_srp, sr_st, SG_RQ_BUSY);
 			if (unlikely(res)) {
@@ -6955,13 +7042,13 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 		ws_rq = true;
 		r_srp = cwrp->possible_srp;
 		if (r_srp) {
-			sr_st = atomic_read_acquire(&r_srp->rq_st);
+			sr_st = atomic_read(&r_srp->rq_st);
 			if (sr_st == SG_RQ_INACTIVE && dlen <= r_srp->sgat_h.buflen) {
 				res = sg_rq_chg_state(r_srp, sr_st, SG_RQ_BUSY);
 				if (likely(res == 0)) {
 					/* possible_srp bypasses loop to find candidate */
 					mk_new_srp = false;
-					keep_frq_bm = true;
+					keep_frq_pc_bm = true;
 					goto final_setup;
 				}
 			}
@@ -6990,7 +7077,8 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 		s_idx = (l_used_idx < 0) ? 0 : l_used_idx;
 		if (l_used_idx >= 0 && xa_get_mark(xafp, s_idx, SG_XA_RQ_INACTIVE)) {
 			r_srp = xa_load(xafp, s_idx);
-			if (r_srp && (allow_rsv || !test_bit(SG_FRQ_RESERVED, r_srp->frq_bm))) {
+			if (r_srp &&
+			    (allow_rsv || !test_bit(SG_FRQ_LT_RESERVED, r_srp->frq_lt_bm))) {
 				if (r_srp->sgat_h.buflen <= SG_DEF_SECTOR_SZ) {
 					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE,
 							    SG_RQ_BUSY) == 0) {
@@ -7002,7 +7090,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			}
 		}
 		xa_for_each_marked(xafp, idx, r_srp, SG_XA_RQ_INACTIVE) {
-			if (allow_rsv || !test_bit(SG_FRQ_RESERVED, r_srp->frq_bm)) {
+			if (allow_rsv || !test_bit(SG_FRQ_LT_RESERVED, r_srp->frq_lt_bm)) {
 				if (r_srp->sgat_h.buflen <= SG_DEF_SECTOR_SZ) {
 					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
 						continue;
@@ -7056,7 +7144,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			     r_srp;
 			     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
 				if (dlen <= r_srp->sgat_h.buflen &&
-				    !test_bit(SG_FRQ_RESERVED, r_srp->frq_bm)) {
+				    !test_bit(SG_FRQ_LT_RESERVED, r_srp->frq_lt_bm)) {
 					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
 						continue;
 					atomic_dec(&fp->inactives);
@@ -7090,19 +7178,8 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 			goto start_again;
 	}
 final_setup:
-	if (!keep_frq_bm) {
-		/* keep SG_FRQ_RESERVED setting from prior/new r_srp; clear rest */
-		bool is_rsv = test_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
-
-		r_srp->frq_bm[0] = 0;
-		if (is_rsv)
-			set_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
-		/* r_srp inherits these flags from cwrp->frq_bm */
-		if (test_bit(SG_FRQ_IS_V4I, cwrp->frq_bm))
-			set_bit(SG_FRQ_IS_V4I, r_srp->frq_bm);
-		if (test_bit(SG_FRQ_SYNC_INVOC, cwrp->frq_bm))
-			set_bit(SG_FRQ_SYNC_INVOC, r_srp->frq_bm);
-	}
+	if (!keep_frq_pc_bm)
+		r_srp->frq_pc_bm[0] = cwrp->frq_pc_bm[0];
 	r_srp->sgatp->dlen = dlen;	/* must be <= r_srp->sgat_h.buflen */
 	r_srp->sh_var = sh_var;
 	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
@@ -7143,7 +7220,6 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 static void
 sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 {
-	bool is_rsv;
 	enum sg_rq_state sr_st;
 	u8 *sbp;
 
@@ -7152,15 +7228,12 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 	SG_LOG(3, sfp, "%s: srp=%pK\n", __func__, srp);
 	sbp = srp->sense_bp;
 	srp->sense_bp = NULL;
-	sr_st = atomic_read_acquire(&srp->rq_st);
+	sr_st = atomic_read(&srp->rq_st);
 	if (sr_st != SG_RQ_SHR_SWAP) {
 		/* Called from many contexts, don't know whether xa locks held. So assume not. */
 		sg_rq_chg_state_force(srp, SG_RQ_INACTIVE);
 		atomic_inc(&sfp->inactives);
-		is_rsv = test_bit(SG_FRQ_RESERVED, srp->frq_bm);
-		WRITE_ONCE(srp->frq_bm[0], 0);
-		if (is_rsv)
-			__set_bit(SG_FRQ_RESERVED, srp->frq_bm);
+		WRITE_ONCE(srp->frq_pc_bm[0], 0);
 		srp->tag = SG_TAG_WILDCARD;
 		srp->in_resid = 0;
 		srp->rq_info = 0;
@@ -7250,7 +7323,7 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 		}
 		srp->rq_idx = idx;
 		srp->parentfp = sfp;
-		__set_bit(SG_FRQ_RESERVED, srp->frq_bm);
+		__set_bit(SG_FRQ_LT_RESERVED, srp->frq_lt_bm);
 		sg_rq_chg_state_force_ulck(srp, SG_RQ_INACTIVE);
 		atomic_inc(&sfp->inactives);
 		xa_unlock_irqrestore(xafp, iflags);
@@ -7747,8 +7820,8 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx, bool r
 		if (xa_get_mark(&fp->srp_arr, idx, SG_XA_RQ_INACTIVE))
 			continue;
 		if (set_debug)
-			n += scnprintf(obp + n, len - n, "     rq_bm=0x%lx", srp->frq_bm[0]);
-		else if (test_bit(SG_FRQ_ABORTING, srp->frq_bm))
+			n += scnprintf(obp + n, len - n, "     rq_pc_bm=0x%lx", srp->frq_pc_bm[0]);
+		else if (test_bit(SG_FRQ_PC_ABORTING, srp->frq_pc_bm))
 			n += scnprintf(obp + n, len - n, "     abort>> ");
 		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, false, obp + n, len - n);
 		++k;
@@ -7765,7 +7838,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx, bool r
 		if (k == 0)
 			n += scnprintf(obp + n, len - n, "   Inactives:\n");
 		if (set_debug)
-			n += scnprintf(obp + n, len - n, "     rq_bm=0x%lx", srp->frq_bm[0]);
+			n += scnprintf(obp + n, len - n, "     rq_lt_bm=0x%lx", srp->frq_lt_bm[0]);
 		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, true, obp + n, len - n);
 		++k;
 		if ((k % 8) == 0) {	/* don't hold up things too long */
@@ -7826,8 +7899,9 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v, bool reduced)
 
 	b1[0] = '\0';
 	if (it && it->index == 0)
-		seq_printf(s, "max_active_device=%d  def_reserved_size=%d\n", (int)it->max,
-			   def_reserved_size);
+		seq_printf(s, "max_active_device=%d  def_reserved_size=%d  num_reused_bios=%d\n",
+			   (int)it->max, def_reserved_size,
+			   atomic_read(&sg_tmp_count_reused_bios));
 	fdi_p = it ? &it->fd_index : &k;
 	bp = kzalloc(bp_len, __GFP_NOWARN | GFP_KERNEL);
 	if (unlikely(!bp)) {
-- 
2.25.1

