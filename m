Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E953CC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9651613B0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239226AbhD0WAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:39 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39089 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239476AbhD0WAF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 08EB2204275;
        Tue, 27 Apr 2021 23:59:20 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hBqJun0C7pA7; Tue, 27 Apr 2021 23:59:12 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 2251820426C;
        Tue, 27 Apr 2021 23:59:10 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 63/83] sg: shared variable blocking
Date:   Tue, 27 Apr 2021 17:57:13 -0400
Message-Id: <20210427215733.417746-65-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Increase the number of reserve requests per file descriptor
from 1 to SG_MAX_RSV_REQS. This is used to implement a new
type of variable blocking multiple requests that processes
request shares. This is done in a partially asynchronous
fashion.

For example up to SG_MAX_RSV_REQS read-side requests are
submitted. Then the responses for these read-side requests
are processed (which may include interruptible waits). After
this the matching write-side requests are issued and their
responses are processed.

The multiple request array presented for shared variable
blocking should be a sequence of read-side/write-side
requests. The only other commands that are accepted are
those that move no (user) data. TEST UNIT READY and
SYNCHRONIZE CACHE are examples of acceptable non-data commands.

Rename sg_remove_sgat() to the more accurate sg_remove_srp().

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 1949 +++++++++++++++++++++++++++-------------
 include/uapi/scsi/sg.h |    1 +
 2 files changed, 1328 insertions(+), 622 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index e43bb1673adc..c401047cae70 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -120,6 +120,8 @@ enum sg_shr_var {
 #define SG_DEFAULT_Q_AT SG_FD_Q_AT_HEAD /* for backward compatibility */
 #define SG_FL_MMAP_DIRECT (SG_FLAG_MMAP_IO | SG_FLAG_DIRECT_IO)
 
+#define SG_MAX_RSV_REQS 8
+
 /* Only take lower 4 bits of driver byte, all host byte and sense byte */
 #define SG_ML_RESULT_MSK 0x0fff00ff	/* mid-level's 32 bit result value */
 
@@ -140,6 +142,7 @@ enum sg_shr_var {
 #define SG_FRQ_COUNT_ACTIVE	8	/* sfp->submitted + waiting active */
 #define SG_FRQ_ISSUED		9	/* blk_execute_rq_nowait() finished */
 #define SG_FRQ_POLL_SLEPT	10	/* stop re-entry of hybrid_sleep() */
+#define SG_FRQ_RESERVED		11	/* marks a reserved request */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
@@ -155,6 +158,8 @@ enum sg_shr_var {
 #define SG_FFD_MORE_ASYNC	10	/* yield EBUSY more often */
 #define SG_FFD_MRQ_ABORT	11	/* SG_IOABORT + FLAG_MULTIPLE_REQS */
 #define SG_FFD_EXCL_WAITQ	12	/* append _exclusive to wait_event */
+#define SG_FFD_SVB_ACTIVE	13	/* shared variable blocking active */
+#define SG_FFD_RESHARE		14	/* reshare limits to single rsv req */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -261,6 +266,7 @@ struct sg_request {	/* active SCSI command or inactive request */
 	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */
 	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */
 	struct request *rqq;	/* released in sg_rq_end_io(), bio kept */
+	struct sg_request *sh_srp; /* read-side's write srp (or vice versa) */
 	struct bio *bio;	/* kept until this req -->SG_RQ_INACTIVE */
 	struct execute_work ew_orph;	/* harvest orphan request */
 };
@@ -286,11 +292,10 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	u8 next_cmd_len;	/* 0: automatic, >0: use on next write() */
 	unsigned long ffd_bm[1];	/* see SG_FFD_* defines above */
 	struct file *filp;	/* my identity when sharing */
-	struct sg_request *rsv_srp;/* one reserve request per fd */
-	struct sg_request *ws_srp; /* when rsv SG_SHR_RS_RQ, ptr to write-side */
 	struct sg_fd __rcu *share_sfp;/* fd share cross-references, else NULL */
 	struct fasync_struct *async_qp; /* used by asynchronous notification */
 	struct xarray srp_arr;	/* xarray of sg_request object pointers */
+	struct sg_request *rsv_arr[SG_MAX_RSV_REQS];
 	struct kref f_ref;
 	struct execute_work ew_fd;  /* harvest all fd resources and lists */
 };
@@ -314,6 +319,7 @@ struct sg_device { /* holds the state of each scsi generic device */
 struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 	int timeout;
 	int cmd_len;
+	int rsv_idx;		/* wanted rsv_arr index, def: -1 (anyone) */
 	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
 	union {		/* selector is frq_bm.SG_FRQ_IS_V4I */
 		struct sg_io_hdr *h3p;
@@ -324,6 +330,20 @@ struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 	const u8 *cmdp;
 };
 
+struct sg_mrq_hold {	/* for passing context between mrq functions */
+	bool blocking;
+	bool chk_abort;
+	bool immed;
+	bool stop_if;
+	int id_of_mrq;
+	int s_res;		/* secondary error: some-good-then-error */
+	u32 cdb_mxlen;		/* cdb length in cdb_ap, actual be may less */
+	u32 tot_reqs;		/* total number of requests and cdb_s */
+	struct sg_comm_wr_t *cwrp;
+	u8 *cdb_ap;		/* array of commands */
+	struct sg_io_v4 *a_hds;	/* array of request to execute */
+};
+
 /* tasklet or soft irq callback */
 static void sg_rq_end_io(struct request *rq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
@@ -345,7 +365,7 @@ static int sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp,
 			 void __user *p, struct sg_io_v4 *h4p);
 static int sg_read_append(struct sg_request *srp, void __user *outp,
 			  int num_xfer);
-static void sg_remove_sgat(struct sg_request *srp);
+static void sg_remove_srp(struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp, struct file *filp);
 static void sg_remove_sfp(struct kref *);
 static void sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side);
@@ -592,8 +612,7 @@ sg_open(struct inode *inode, struct file *filp)
 
 	res = 0;
 sg_put:
-	kref_put(&sdp->d_ref, sg_device_destroy);
-	/* if success, sdp->d_ref is incremented twice, decremented once */
+	kref_put(&sdp->d_ref, sg_device_destroy);  /* get: sg_get_dev() */
 	return res;
 
 out_undo:
@@ -653,7 +672,7 @@ sg_release(struct inode *inode, struct file *filp)
 
 	if (unlikely(xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_FREE))) {
 		SG_LOG(1, sfp, "%s: sfp already erased!!!\n", __func__);
-		return 0;       /* yell out but can't fail */
+		return 0;	/* yell out but can't fail */
 	}
 
 	mutex_lock(&sdp->open_rel_lock);
@@ -667,8 +686,7 @@ sg_release(struct inode *inode, struct file *filp)
 	    sg_fd_is_shared(sfp))
 		sg_remove_sfp_share(sfp, xa_get_mark(&sdp->sfp_arr, sfp->idx,
 						     SG_XA_FD_RS_SHARE));
-	kref_put(&sfp->f_ref, sg_remove_sfp);
-
+	kref_put(&sfp->f_ref, sg_remove_sfp);	/* init=1: sg_add_sfp() */
 	/*
 	 * Possibly many open()s waiting on exclude clearing, start many;
 	 * only open(O_EXCL)'s wait when open_cnt<2 and only start one.
@@ -831,6 +849,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	WRITE_ONCE(cwr.frq_bm[0], 0);
 	cwr.timeout = sfp->timeout;
 	cwr.cmd_len = cmd_size;
+	cwr.rsv_idx = -1;
 	cwr.sfp = sfp;
 	cwr.u_cmdp = p;
 	cwr.cmdp = NULL;
@@ -841,11 +860,15 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 static inline int
 sg_chk_mmap(struct sg_fd *sfp, int rq_flags, int len)
 {
+	struct sg_request *rsv_srp = sfp->rsv_arr[0];
+
 	if (unlikely(sfp->mmap_sz == 0))
 		return -EBADFD;
 	if (unlikely(atomic_read(&sfp->submitted) > 0))
 		return -EBUSY;  /* already active requests on fd */
-	if (unlikely(len > sfp->rsv_srp->sgat_h.buflen))
+	if (IS_ERR_OR_NULL(rsv_srp))
+		return -EPROTO;	/* first element always a reserve req */
+	if (unlikely(len > rsv_srp->sgatp->buflen))
 		return -ENOMEM; /* MMAP_IO size must fit in reserve */
 	if (unlikely(len > sfp->mmap_sz))
 		return -ENOMEM; /* MMAP_IO size can't exceed mmap() size */
@@ -900,6 +923,7 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 	cwr.h3p = hp;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	cwr.cmd_len = hp->cmd_len;
+	cwr.rsv_idx = -1;
 	cwr.sfp = sfp;
 	cwr.u_cmdp = hp->cmdp;
 	cwr.cmdp = NULL;
@@ -946,27 +970,33 @@ sg_mrq_arr_flush(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds, u32 tot_reqs,
 
 static int
 sg_mrq_1complet(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
-		struct sg_fd *w_sfp, int tot_reqs, struct sg_request *srp)
+		struct sg_fd *do_on_sfp, int tot_reqs, struct sg_request *srp)
 {
 	int s_res, indx;
 	struct sg_io_v4 *hp;
 
-	SG_LOG(3, w_sfp, "%s: start, tot_reqs=%d\n", __func__, tot_reqs);
 	if (unlikely(!srp))
 		return -EPROTO;
 	indx = srp->s_hdr4.mrq_ind;
+	if (unlikely(srp->parentfp != do_on_sfp)) {
+		SG_LOG(1, do_on_sfp, "%s: mrq_ind=%d, sfp out-of-sync\n",
+		       __func__, indx);
+		return -EPROTO;
+	}
+	SG_LOG(3, do_on_sfp, "%s: mrq_ind=%d, pack_id=%d\n", __func__, indx,
+	       srp->pack_id);
 	if (unlikely(indx < 0 || indx >= tot_reqs))
 		return -EPROTO;
 	hp = a_hds + indx;
-	s_res = sg_receive_v4(w_sfp, srp, NULL, hp);
+	s_res = sg_receive_v4(do_on_sfp, srp, NULL, hp);
 	if (unlikely(s_res == -EFAULT))
 		return s_res;
 	hp->info |= SG_INFO_MRQ_FINI;
-	if (w_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
+	if (do_on_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
 		s_res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
 		if (unlikely(s_res))	/* can only be -EFAULT */
 			return s_res;
-		kill_fasync(&w_sfp->async_qp, SIGPOLL, POLL_IN);
+		kill_fasync(&do_on_sfp->async_qp, SIGPOLL, POLL_IN);
 	}
 	return 0;
 }
@@ -992,36 +1022,47 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 		struct sg_fd *sfp, struct sg_fd *sec_sfp, int tot_reqs,
 		int mreqs, int sec_reqs)
 {
-	int res;
-	int sum_inflight = mreqs + sec_reqs;	/* may be < tot_reqs */
+	int res = 0;
+	int rres;
 	struct sg_request *srp;
 
 	SG_LOG(3, sfp, "%s: mreqs=%d, sec_reqs=%d\n", __func__, mreqs,
 	       sec_reqs);
-	for ( ; sum_inflight > 0; --sum_inflight, ++cop->info) {
-		srp = NULL;
-		if (mreqs > 0 && sg_mrq_get_ready_srp(sfp, &srp)) {
+	while (mreqs + sec_reqs > 0) {
+		while (mreqs > 0 && sg_mrq_get_ready_srp(sfp, &srp)) {
 			if (IS_ERR(srp)) {	/* -ENODATA: no mrqs here */
-				mreqs = 0;
-			} else {
-				--mreqs;
-				res = sg_mrq_1complet(cop, a_hds, sfp,
-						      tot_reqs, srp);
-				if (unlikely(res))
-					return res;
+				if (PTR_ERR(srp) == -ENODATA)
+					break;
+				res = PTR_ERR(srp);
+				break;
 			}
-		} else if (sec_reqs > 0 &&
-			   sg_mrq_get_ready_srp(sec_sfp, &srp)) {
+			--mreqs;
+			res = sg_mrq_1complet(cop, a_hds, sfp, tot_reqs, srp);
+			if (unlikely(res))
+				return res;
+			++cop->info;
+			if (cop->din_xfer_len > 0)
+				--cop->din_resid;
+		}
+		while (sec_reqs > 0 && sg_mrq_get_ready_srp(sec_sfp, &srp)) {
 			if (IS_ERR(srp)) {
-				sec_reqs = 0;
-			} else {
-				--sec_reqs;
-				res = sg_mrq_1complet(cop, a_hds, sec_sfp,
-						      tot_reqs, srp);
-				if (unlikely(res))
-					return res;
+				if (PTR_ERR(srp) == -ENODATA)
+					break;
+				res = PTR_ERR(srp);
+				break;
 			}
-		} else if (mreqs > 0) {
+			--sec_reqs;
+			rres = sg_mrq_1complet(cop, a_hds, sec_sfp, tot_reqs,
+					       srp);
+			if (unlikely(rres))
+				return rres;
+			++cop->info;
+			if (cop->din_xfer_len > 0)
+				--cop->din_resid;
+		}
+		if (res)
+			break;
+		if (mreqs > 0) {
 			res = sg_wait_mrq_event(sfp, &srp);
 			if (unlikely(res))
 				return res;	/* signal --> -ERESTARTSYS */
@@ -1033,8 +1074,12 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 						      tot_reqs, srp);
 				if (unlikely(res))
 					return res;
+				++cop->info;
+				if (cop->din_xfer_len > 0)
+					--cop->din_resid;
 			}
-		} else if (sec_reqs > 0) {
+		}
+		if (sec_reqs > 0) {
 			res = sg_wait_mrq_event(sec_sfp, &srp);
 			if (unlikely(res))
 				return res;	/* signal --> -ERESTARTSYS */
@@ -1046,14 +1091,13 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 						      tot_reqs, srp);
 				if (unlikely(res))
 					return res;
+				++cop->info;
+				if (cop->din_xfer_len > 0)
+					--cop->din_resid;
 			}
-		} else { /* expect one of the above conditions to be true */
-			return -EPROTO;
 		}
-		if (cop->din_xfer_len > 0)
-			--cop->din_resid;
-	}
-	return 0;
+	}	/* end of outer while loop (while requests still inflight) */
+	return res;
 }
 
 static int
@@ -1101,7 +1145,6 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 				       rip, k, "no IMMED with COMPLETE_B4");
 				return -ERANGE;
 			}
-			/* N.B. SGV4_FLAG_SIG_ON_OTHER is allowed */
 		}
 		if (sg_fd_is_shared(sfp)) {
 			if (!share_on_oth && share)
@@ -1135,6 +1178,422 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 	return 0;
 }
 
+static bool
+sg_mrq_svb_chk(struct sg_io_v4 *a_hds, u32 tot_reqs)
+{
+	bool expect_rd;
+	int k;
+	u32 flags;
+	struct sg_io_v4 *hp;
+
+	/* expect read-write pairs, all with SGV4_FLAG_NO_DXFER set */
+	for (k = 0, hp = a_hds, expect_rd = true; k < tot_reqs; ++k, ++hp) {
+		flags = hp->flags;
+		if (flags & (SGV4_FLAG_COMPLETE_B4))
+			return false;
+		if (expect_rd) {
+			if (hp->dout_xfer_len > 0)
+				return false;
+			if (hp->din_xfer_len > 0) {
+				if (!(flags & SGV4_FLAG_SHARE))
+					return false;
+				if (flags & SGV4_FLAG_DO_ON_OTHER)
+					return false;
+				expect_rd = false;
+			}
+			/* allowing commands with no dxfer */
+		} else {	/* checking write side */
+			if (hp->dout_xfer_len > 0) {
+				if (~flags &
+				    (SGV4_FLAG_NO_DXFER | SGV4_FLAG_SHARE |
+				     SGV4_FLAG_DO_ON_OTHER))
+					return false;
+				expect_rd = true;
+			}
+			if (hp->din_xfer_len > 0)
+				return false;
+		}
+	}
+	if (!expect_rd)
+		return false;
+	return true;
+}
+
+static struct sg_request *
+sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_hdr,
+	      int rsv_idx)
+{
+	unsigned long ul_timeout;
+	struct sg_comm_wr_t r_cwr;
+	struct sg_comm_wr_t *r_cwrp = &r_cwr;
+	struct sg_io_v4 *hp = mhp->a_hds + pos_hdr;
+
+	if (mhp->cdb_ap) {	/* already have array of cdbs */
+		r_cwrp->cmdp = mhp->cdb_ap + (pos_hdr * mhp->cdb_mxlen);
+		r_cwrp->u_cmdp = NULL;
+	} else {	/* fetch each cdb from user space */
+		r_cwrp->cmdp = NULL;
+		r_cwrp->u_cmdp = cuptr64(hp->request);
+	}
+	r_cwrp->cmd_len = hp->request_len;
+	r_cwrp->rsv_idx = rsv_idx;
+	ul_timeout = msecs_to_jiffies(hp->timeout);
+	r_cwrp->frq_bm[0] = 0;
+	__assign_bit(SG_FRQ_SYNC_INVOC, r_cwrp->frq_bm,
+		     (int)mhp->blocking);
+	__set_bit(SG_FRQ_IS_V4I, r_cwrp->frq_bm);
+	r_cwrp->h4p = hp;
+	r_cwrp->timeout = min_t(unsigned long, ul_timeout, INT_MAX);
+	r_cwrp->sfp = rq_sfp;
+	return sg_common_write(r_cwrp);
+}
+
+/*
+ * Processes most mrq requests apart from those from "shared variable
+ * blocking" (svb) method which is processed in sg_process_svb_mrq().
+ */
+static int
+sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
+		    struct sg_mrq_hold *mhp)
+{
+	int flags, j;
+	int num_subm = 0;
+	int num_cmpl = 0;
+	int res = 0;
+	int other_fp_sent = 0;
+	int this_fp_sent = 0;
+	const int shr_complet_b4 = SGV4_FLAG_SHARE | SGV4_FLAG_COMPLETE_B4;
+	struct sg_fd *rq_sfp;
+	struct sg_io_v4 *cop = mhp->cwrp->h4p;
+	struct sg_io_v4 *hp;		/* ptr to request object in a_hds */
+	struct sg_request *srp;
+
+	SG_LOG(3, fp, "%s: id_of_mrq=%d, tot_reqs=%d, enter\n", __func__,
+	       mhp->id_of_mrq, mhp->tot_reqs);
+	/* Dispatch (submit) requests and optionally wait for response */
+	for (hp = mhp->a_hds, j = 0; num_subm < mhp->tot_reqs; ++hp, ++j) {
+		if (mhp->chk_abort && test_and_clear_bit(SG_FFD_MRQ_ABORT,
+							 fp->ffd_bm)) {
+			SG_LOG(1, fp, "%s: id_of_mrq=%d aborting at ind=%d\n",
+			       __func__, mhp->id_of_mrq, num_subm);
+			break;	/* N.B. rest not submitted */
+		}
+		flags = hp->flags;
+		rq_sfp = (flags & SGV4_FLAG_DO_ON_OTHER) ? o_sfp : fp;
+		srp = sg_mrq_submit(rq_sfp, mhp, j, -1);
+		if (IS_ERR(srp)) {
+			mhp->s_res = PTR_ERR(srp);
+			break;
+		}
+		srp->s_hdr4.mrq_ind = num_subm++;
+		if (mhp->chk_abort)
+			atomic_set(&srp->s_hdr4.pack_id_of_mrq,
+				   mhp->id_of_mrq);
+		if (mhp->immed ||
+		    (!(mhp->blocking || (flags & shr_complet_b4)))) {
+			if (fp == rq_sfp)
+				++this_fp_sent;
+			else
+				++other_fp_sent;
+			continue;  /* defer completion until all submitted */
+		}
+		mhp->s_res = sg_wait_event_srp(rq_sfp, NULL, hp, srp);
+		if (unlikely(mhp->s_res)) {
+			if (mhp->s_res == -ERESTARTSYS)
+				return mhp->s_res;
+			break;
+		}
+		++num_cmpl;
+		hp->info |= SG_INFO_MRQ_FINI;
+		if (mhp->stop_if && (hp->driver_status ||
+				     hp->transport_status ||
+				     hp->device_status)) {
+			SG_LOG(2, fp, "%s: %s=0x%x/0x%x/0x%x] cause exit\n",
+			       __func__, "STOP_IF and status [drv/tran/scsi",
+			       hp->driver_status, hp->transport_status,
+			       hp->device_status);
+			break;	/* cop->driver_status <-- 0 in this case */
+		}
+		if (rq_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
+			res = sg_mrq_arr_flush(cop, mhp->a_hds, mhp->tot_reqs,
+					       mhp->s_res);
+			if (unlikely(res))
+				break;
+			kill_fasync(&rq_sfp->async_qp, SIGPOLL, POLL_IN);
+		}
+	}	/* end of dispatch request and optionally wait response loop */
+	cop->dout_resid = mhp->tot_reqs - num_subm;
+	cop->info = mhp->immed ? num_subm : num_cmpl;
+	if (cop->din_xfer_len > 0) {
+		cop->din_resid = mhp->tot_reqs - num_cmpl;
+		cop->spare_out = -mhp->s_res;
+	}
+
+	if (mhp->immed)
+		return res;
+	if (likely(res == 0 && (this_fp_sent + other_fp_sent) > 0)) {
+		mhp->s_res = sg_mrq_complets(cop, mhp->a_hds, fp, o_sfp,
+					     mhp->tot_reqs, this_fp_sent,
+					     other_fp_sent);
+		if (unlikely(mhp->s_res == -EFAULT ||
+			     mhp->s_res == -ERESTARTSYS))
+			res = mhp->s_res;	/* this may leave orphans */
+	}
+	if (mhp->id_of_mrq)	/* can no longer do a mrq abort */
+		atomic_set(&fp->mrq_id_abort, 0);
+	return res;
+}
+
+static int
+sg_find_srp_idx(struct sg_fd *sfp, const struct sg_request *srp)
+{
+	int k;
+	struct sg_request **rapp = sfp->rsv_arr;
+
+	for (k = 0; k < SG_MAX_RSV_REQS; ++k, ++rapp) {
+		if (*rapp == srp)
+			return k;
+	}
+	return -1;
+}
+
+/*
+ * Processes shared variable blocking. First inner loop submits a chunk of
+ * requests (some read-side, some non-data) but defers any write-side requests. The
+ * second inner loop processes the completions from the first inner loop, plus
+ * for any completed read-side request it submits the paired write-side request. The
+ * second inner loop also waits for the completions of those write-side requests.
+ * The outer loop then moves onto the next chunk, working its way through
+ * the multiple requests. The user sees a blocking command, but the chunks
+ * are run in parallel apart from read-write ordering requirement.
+ * N.B. Only one svb mrq permitted per file descriptor at a time.
+ */
+static int
+sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
+		   struct sg_mrq_hold *mhp)
+{
+	bool aborted = false;
+	bool chk_oth_first;
+	int k, j, i, m, rcv_before, idx, ws_pos, sent;
+	int this_fp_sent, other_fp_sent;
+	int num_subm = 0;
+	int num_cmpl = 0;
+	int res = 0;
+	struct sg_fd *rq_sfp;
+	struct sg_io_v4 *cop = mhp->cwrp->h4p;
+	struct sg_io_v4 *hp;		/* ptr to request object in a_hds */
+	struct sg_request *srp;
+	struct sg_request *rs_srp;
+	struct sg_io_v4 *a_hds = mhp->a_hds;
+	int ws_pos_a[SG_MAX_RSV_REQS];	/* write-side hdr pos within a_hds */
+	struct sg_request *rs_srp_a[SG_MAX_RSV_REQS];
+
+	SG_LOG(3, fp, "%s: id_of_mrq=%d, tot_reqs=%d, enter\n", __func__,
+	       mhp->id_of_mrq, mhp->tot_reqs);
+
+	/* work through mrq array, SG_MAX_RSV_REQS read-side requests at a time */
+	for (hp = a_hds, j = 0; j < mhp->tot_reqs; ) {
+		this_fp_sent = 0;
+		other_fp_sent = 0;
+		chk_oth_first = false;
+		for (k = 0; k < SG_MAX_RSV_REQS && j < mhp->tot_reqs;
+		     ++hp, ++j) {
+			if (mhp->chk_abort &&
+			    test_and_clear_bit(SG_FFD_MRQ_ABORT, fp->ffd_bm)) {
+				SG_LOG(1, fp,
+				       "%s: id_of_mrq=%d aborting at pos=%d\n",
+				       __func__, mhp->id_of_mrq, num_subm);
+				aborted = true;
+				/*
+				 * after mrq abort detected, complete those
+				 * already submitted, but don't submit any more
+				 */
+			}
+			if (aborted)
+				break;
+			if (hp->flags & SGV4_FLAG_DO_ON_OTHER) {
+				if (hp->dout_xfer_len > 0) {
+					/* need to await read-side completion */
+					ws_pos_a[k] = j;
+					++k;
+					continue;  /* deferred to next loop */
+				}
+				chk_oth_first = true;
+				SG_LOG(6, o_sfp,
+				       "%s: subm-nodat p_id=%d on write-side\n",
+				       __func__, (int)hp->request_extra);
+				rq_sfp = o_sfp;
+			} else {
+				SG_LOG(6, fp, "%s: submit p_id=%d on read-side\n",
+				       __func__, (int)hp->request_extra);
+				rq_sfp = fp;
+			}
+			srp = sg_mrq_submit(rq_sfp, mhp, j, -1);
+			if (IS_ERR(srp)) {
+				mhp->s_res = PTR_ERR(srp);
+				res = mhp->s_res;	/* don't loop again */
+				SG_LOG(1, rq_sfp, "%s: mrq_submit()->%d\n",
+				       __func__, res);
+				break;
+			}
+			num_subm++;
+			if (hp->din_xfer_len > 0)
+				rs_srp_a[k] = srp;
+			srp->s_hdr4.mrq_ind = j;
+			if (mhp->chk_abort)
+				atomic_set(&srp->s_hdr4.pack_id_of_mrq,
+					   mhp->id_of_mrq);
+			if (fp == rq_sfp)
+				++this_fp_sent;
+			else
+				++other_fp_sent;
+		}
+		sent = this_fp_sent + other_fp_sent;
+		if (sent <= 0)
+			break;
+		/*
+		 * We have just submitted a fixed number read-side reqs and any
+		 * others (that don't move data). Now we pick up their
+		 * responses. Any responses that were read-side requests have
+		 * their paired write-side submitted. Finally we wait for those
+		 * paired write-side to complete.
+		 */
+		rcv_before = cop->info;
+		for (i = 0; i < sent; ++i) {	/* now process responses */
+			if (other_fp_sent > 0 &&
+			    sg_mrq_get_ready_srp(o_sfp, &srp)) {
+other_found:
+				if (IS_ERR(srp)) {
+					res = PTR_ERR(srp);
+					break;
+				}
+				--other_fp_sent;
+				res = sg_mrq_1complet(cop, a_hds, o_sfp,
+						      mhp->tot_reqs, srp);
+				if (unlikely(res))
+					return res;
+				++cop->info;
+				if (cop->din_xfer_len > 0)
+					--cop->din_resid;
+				continue;  /* do available submits first */
+			}
+			if (this_fp_sent > 0 &&
+			    sg_mrq_get_ready_srp(fp, &srp)) {
+this_found:
+				if (IS_ERR(srp)) {
+					res = PTR_ERR(srp);
+					break;
+				}
+				--this_fp_sent;
+				res = sg_mrq_1complet(cop, a_hds, fp,
+						      mhp->tot_reqs, srp);
+				if (unlikely(res))
+					return res;
+				++cop->info;
+				if (cop->din_xfer_len > 0)
+					--cop->din_resid;
+				if (srp->s_hdr4.dir != SG_DXFER_FROM_DEV)
+					continue;
+				/* read-side req completed, submit its write-side */
+				rs_srp = srp;
+				for (m = 0; m < k; ++m) {
+					if (rs_srp == rs_srp_a[m])
+						break;
+				}
+				if (m >= k) {
+					SG_LOG(1, rs_srp->parentfp,
+					       "%s: m >= %d, pack_id=%d\n",
+					       __func__, k, rs_srp->pack_id);
+					res = -EPROTO;
+					break;
+				}
+				ws_pos = ws_pos_a[m];
+				idx = sg_find_srp_idx(fp, rs_srp);
+				if (idx < 0) {
+					SG_LOG(1, rs_srp->parentfp,
+					       "%s: idx < 0\n", __func__);
+					res = -EPROTO;
+					break;
+				}
+				SG_LOG(6, o_sfp,
+				       "%s: submit ws_pos=%d, rs_idx=%d\n",
+				       __func__, ws_pos, idx);
+				srp = sg_mrq_submit(o_sfp, mhp, ws_pos, idx);
+				if (IS_ERR(srp)) {
+					mhp->s_res = PTR_ERR(srp);
+					res = mhp->s_res;
+					SG_LOG(1, o_sfp,
+					       "%s: mrq_submit(oth)->%d\n",
+						__func__, res);
+					break;
+				}
+				++num_subm;
+				++other_fp_sent;
+				++sent;
+				srp->s_hdr4.mrq_ind = ws_pos;
+				if (mhp->chk_abort)
+					atomic_set(&srp->s_hdr4.pack_id_of_mrq,
+						   mhp->id_of_mrq);
+				continue;  /* do available submits first */
+			}
+			/* waits maybe interrupted by signals (-ERESTARTSYS) */
+			if (chk_oth_first)
+				goto oth_first;
+this_second:
+			if (this_fp_sent > 0) {
+				res = sg_wait_mrq_event(fp, &srp);
+				if (unlikely(res))
+					return res;
+				goto this_found;
+			}
+			if (chk_oth_first)
+				continue;
+oth_first:
+			if (other_fp_sent > 0) {
+				res = sg_wait_mrq_event(o_sfp, &srp);
+				if (unlikely(res))
+					return res;
+				goto other_found;
+			}
+			if (chk_oth_first)
+				goto this_second;
+		}	/* end of response/write_side_submit/write_side_response loop */
+		if (unlikely(mhp->s_res == -EFAULT ||
+			     mhp->s_res == -ERESTARTSYS))
+			res = mhp->s_res;	/* this may leave orphans */
+		num_cmpl += (cop->info - rcv_before);
+		if (res)
+			break;
+		if (aborted)
+			break;
+	}	/* end of outer for loop */
+
+	cop->dout_resid = mhp->tot_reqs - num_subm;
+	if (cop->din_xfer_len > 0) {
+		cop->din_resid = mhp->tot_reqs - num_cmpl;
+		cop->spare_out = -mhp->s_res;
+	}
+	if (mhp->id_of_mrq)	/* can no longer do a mrq abort */
+		atomic_set(&fp->mrq_id_abort, 0);
+	return res;
+}
+
+#if IS_ENABLED(SG_LOG_ACTIVE)
+static const char *
+sg_mrq_name(bool blocking, u32 flags)
+{
+	if (!(flags & SGV4_FLAG_MULTIPLE_REQS))
+		return "_not_ multiple requests control object";
+	if (blocking)
+		return "ordered blocking";
+	if (flags & SGV4_FLAG_IMMED)
+		return "submit or full non-blocking";
+	if (flags & SGV4_FLAG_SHARE)
+		return "shared variable blocking";
+	return "variable blocking";
+}
+#endif
+
 /*
  * Implements the multiple request functionality. When 'blocking' is true
  * invocation was via ioctl(SG_IO), otherwise it was via ioctl(SG_IOSUBMIT).
@@ -1145,47 +1604,51 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 static int
 sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 {
-	bool chk_abort = false;
-	bool set_this, set_other, immed, stop_if, f_non_block;
+	bool f_non_block, share_on_oth;
 	int res = 0;
-	int s_res = 0;	/* for secondary error: some-good-then-error, case */
-	int other_fp_sent = 0;
-	int this_fp_sent = 0;
-	int num_subm = 0;
-	int num_cmpl = 0;
-	const int shr_complet_b4 = SGV4_FLAG_SHARE | SGV4_FLAG_COMPLETE_B4;
-	int id_of_mrq, existing_id;
-	u32 n, flags, cdb_mxlen;
-	unsigned long ul_timeout;
+	int existing_id;
+	u32 cdb_mxlen;
 	struct sg_io_v4 *cop = cwrp->h4p;	/* controlling object */
 	u32 blen = cop->dout_xfer_len;
 	u32 cdb_alen = cop->request_len;
 	u32 tot_reqs = blen / SZ_SG_IO_V4;
 	u8 *cdb_ap = NULL;
-	struct sg_io_v4 *hp;		/* ptr to request object in a_hds */
 	struct sg_io_v4 *a_hds;		/* array of request objects */
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_fd *o_sfp = sg_fd_share_ptr(fp);
-	struct sg_fd *rq_sfp;
-	struct sg_request *srp;
 	struct sg_device *sdp = fp->parentdp;
+	struct sg_mrq_hold mh;
+	struct sg_mrq_hold *mhp = &mh;
+#if IS_ENABLED(SG_LOG_ACTIVE)
+	const char *mrq_name;
+#endif
 
+	mhp->cwrp = cwrp;
+	mhp->blocking = blocking;
+#if IS_ENABLED(SG_LOG_ACTIVE)
+	mrq_name = sg_mrq_name(blocking, cop->flags);
+#endif
 	f_non_block = !!(fp->filp->f_flags & O_NONBLOCK);
-	immed = !!(cop->flags & SGV4_FLAG_IMMED);
-	stop_if = !!(cop->flags & SGV4_FLAG_STOP_IF);
-	id_of_mrq = (int)cop->request_extra;
-	if (id_of_mrq) {
-		existing_id = atomic_cmpxchg(&fp->mrq_id_abort, 0, id_of_mrq);
-		if (existing_id && existing_id != id_of_mrq) {
+	mhp->immed = !!(cop->flags & SGV4_FLAG_IMMED);
+	mhp->stop_if = !!(cop->flags & SGV4_FLAG_STOP_IF);
+	mhp->id_of_mrq = (int)cop->request_extra;
+	mhp->tot_reqs = tot_reqs;
+	mhp->s_res = 0;
+	if (mhp->id_of_mrq) {
+		existing_id = atomic_cmpxchg(&fp->mrq_id_abort, 0,
+					     mhp->id_of_mrq);
+		if (existing_id && existing_id != mhp->id_of_mrq) {
 			SG_LOG(1, fp, "%s: existing id=%d id_of_mrq=%d\n",
-			       __func__, existing_id, id_of_mrq);
+			       __func__, existing_id, mhp->id_of_mrq);
 			return -EDOM;
 		}
 		clear_bit(SG_FFD_MRQ_ABORT, fp->ffd_bm);
-		chk_abort = true;
+		mhp->chk_abort = true;
+	} else {
+		mhp->chk_abort = false;
 	}
 	if (blocking) {		/* came from ioctl(SG_IO) */
-		if (unlikely(immed)) {
+		if (unlikely(mhp->immed)) {
 			SG_LOG(1, fp, "%s: ioctl(SG_IO) %s contradicts\n",
 			       __func__, "with SGV4_FLAG_IMMED");
 			return -ERANGE;
@@ -1196,11 +1659,10 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 			f_non_block = false;
 		}
 	}
-	if (!immed && f_non_block)
-		immed = true;
+	if (!mhp->immed && f_non_block)
+		mhp->immed = true;
 	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, id_of_mrq=%d\n", __func__,
-	       (immed ? "IMMED" : (blocking ?  "ordered blocking" :
-				   "variable blocking")), tot_reqs, id_of_mrq);
+	       mrq_name, tot_reqs, mhp->id_of_mrq);
 	sg_sgv4_out_zero(cop);
 
 	if (unlikely(tot_reqs > U16_MAX)) {
@@ -1208,7 +1670,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	} else if (unlikely(blen > SG_MAX_MULTI_REQ_SZ ||
 			    cdb_alen > SG_MAX_MULTI_REQ_SZ)) {
 		return  -E2BIG;
-	} else if (unlikely(immed && stop_if)) {
+	} else if (unlikely(mhp->immed && mhp->stop_if)) {
 		return -ERANGE;
 	} else if (unlikely(tot_reqs == 0)) {
 		return 0;
@@ -1224,16 +1686,14 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 		cdb_mxlen = 0;
 	}
 
-	if (SG_IS_DETACHING(sdp))
-		return -ENODEV;
-	else if (unlikely(o_sfp && SG_IS_DETACHING((o_sfp->parentdp))))
+	if (SG_IS_DETACHING(sdp) || (o_sfp && SG_IS_DETACHING(o_sfp->parentdp)))
 		return -ENODEV;
 
 	a_hds = kcalloc(tot_reqs, SZ_SG_IO_V4, GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!a_hds))
 		return -ENOMEM;
-	n = tot_reqs * SZ_SG_IO_V4;
-	if (copy_from_user(a_hds, cuptr64(cop->dout_xferp), n)) {
+	if (copy_from_user(a_hds, cuptr64(cop->dout_xferp),
+			   tot_reqs * SZ_SG_IO_V4)) {
 		res = -EFAULT;
 		goto fini;
 	}
@@ -1249,114 +1709,45 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 		}
 	}
 	/* do sanity checks on all requests before starting */
-	res = sg_mrq_sanity(sdp, cop, a_hds, cdb_ap, fp, immed, tot_reqs,
-			    NULL);
+	res = sg_mrq_sanity(sdp, cop, a_hds, cdb_ap, fp, mhp->immed,
+			    tot_reqs, &share_on_oth);
 	if (unlikely(res))
 		goto fini;
-	set_this = false;
-	set_other = false;
-	/* Dispatch (submit) requests and optionally wait for response */
-	for (hp = a_hds; num_subm < tot_reqs; ++hp) {
-		if (chk_abort && test_and_clear_bit(SG_FFD_MRQ_ABORT,
-						    fp->ffd_bm)) {
-			SG_LOG(1, fp, "%s: id_of_mrq=%d aborting at ind=%d\n",
-			       __func__, id_of_mrq, num_subm);
-			break;	/* N.B. rest not submitted */
-		}
-		flags = hp->flags;
-		if (flags & SGV4_FLAG_DO_ON_OTHER) {
-			rq_sfp = o_sfp;
-			if (!set_other) {
-				set_other = true;
-				if (test_bit(SG_FFD_NO_CMD_Q, rq_sfp->ffd_bm))
-					clear_bit(SG_FFD_NO_CMD_Q,
-						  rq_sfp->ffd_bm);
-			}
-		} else {
-			rq_sfp = fp;
-			if (!set_this) {
-				set_this = true;
-				if (test_bit(SG_FFD_NO_CMD_Q, rq_sfp->ffd_bm))
-					clear_bit(SG_FFD_NO_CMD_Q,
-						  rq_sfp->ffd_bm);
-			}
-		}
-		if (cdb_ap) {	/* already have array of cdbs */
-			cwrp->cmdp = cdb_ap + (num_subm * cdb_mxlen);
-			cwrp->u_cmdp = NULL;
-		} else {	/* fetch each cdb from user space */
-			cwrp->cmdp = NULL;
-			cwrp->u_cmdp = cuptr64(hp->request);
-		}
-		cwrp->cmd_len = hp->request_len;
-		ul_timeout = msecs_to_jiffies(hp->timeout);
-		cwrp->frq_bm[0] = 0;
-		__assign_bit(SG_FRQ_SYNC_INVOC, cwrp->frq_bm, (int)blocking);
-		__set_bit(SG_FRQ_IS_V4I, cwrp->frq_bm);
-		cwrp->h4p = hp;
-		cwrp->timeout = min_t(unsigned long, ul_timeout, INT_MAX);
-		cwrp->sfp = rq_sfp;
-		srp = sg_common_write(cwrp);
-		if (IS_ERR(srp)) {
-			s_res = PTR_ERR(srp);
-			break;
-		}
-		srp->s_hdr4.mrq_ind = num_subm++;
-		if (chk_abort)
-			atomic_set(&srp->s_hdr4.pack_id_of_mrq, id_of_mrq);
-		if (immed || (!(blocking || (flags & shr_complet_b4)))) {
-			if (fp == rq_sfp)
-				++this_fp_sent;
-			else
-				++other_fp_sent;
-			continue;  /* defer completion until all submitted */
-		}
-		s_res = sg_wait_event_srp(rq_sfp, NULL, hp, srp);
-		if (unlikely(s_res)) {
-			if (s_res == -ERESTARTSYS) {
-				res = s_res;
-				goto fini;
-			}
-			break;
-		}
-		++num_cmpl;
-		hp->info |= SG_INFO_MRQ_FINI;
-		if (stop_if && (hp->driver_status || hp->transport_status ||
-				hp->device_status)) {
-			SG_LOG(2, fp, "%s: %s=0x%x/0x%x/0x%x] cause exit\n",
-			       __func__, "STOP_IF and status [drv/tran/scsi",
-			       hp->driver_status, hp->transport_status,
-			       hp->device_status);
-			break;	/* cop->driver_status <-- 0 in this case */
-		}
-		if (rq_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
-			res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
-			if (unlikely(res))
-				break;
-			kill_fasync(&rq_sfp->async_qp, SIGPOLL, POLL_IN);
-		}
-	}	/* end of dispatch request and optionally wait response loop */
-	cop->dout_resid = tot_reqs - num_subm;
-	cop->info = num_cmpl;		/* number received */
-	if (cop->din_xfer_len > 0) {
-		cop->din_resid = tot_reqs - num_cmpl;
-		cop->spare_out = -s_res;
-	}
 
-	if (immed)
-		goto fini;
+	/* override cmd queuing setting to allow */
+	clear_bit(SG_FFD_NO_CMD_Q, fp->ffd_bm);
+	if (o_sfp)
+		clear_bit(SG_FFD_NO_CMD_Q, o_sfp->ffd_bm);
 
-	if (likely(res == 0 && (this_fp_sent + other_fp_sent) > 0)) {
-		s_res = sg_mrq_complets(cop, a_hds, fp, o_sfp, tot_reqs,
-					this_fp_sent, other_fp_sent);
-		if (unlikely(s_res == -EFAULT || s_res == -ERESTARTSYS))
-			res = s_res;	/* this may leave orphans */
+	mhp->cdb_ap = cdb_ap;
+	mhp->a_hds = a_hds;
+	mhp->cdb_mxlen = cdb_mxlen;
+
+	if (!mhp->immed && !blocking && share_on_oth) {
+		bool ok;
+
+		/* check for 'shared' variable blocking (svb) */
+		ok = sg_mrq_svb_chk(a_hds, tot_reqs);
+		if (!ok) {
+			SG_LOG(1, fp, "%s: %s failed on req(s)\n", __func__,
+			       mrq_name);
+			res = -ERANGE;
+			goto fini;
+		}
+		if (test_and_set_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm)) {
+			SG_LOG(1, fp, "%s: %s already active\n", __func__,
+			       mrq_name);
+			res = -EBUSY;
+			goto fini;
+		}
+		res = sg_process_svb_mrq(fp, o_sfp, mhp);
+		clear_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm);
+	} else {
+		res = sg_process_most_mrq(fp, o_sfp, mhp);
 	}
-	if (id_of_mrq)	/* can no longer do a mrq abort */
-		atomic_set(&fp->mrq_id_abort, 0);
 fini:
-	if (likely(res == 0) && !immed)
-		res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
+	if (likely(res == 0) && !mhp->immed)
+		res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, mhp->s_res);
 	kfree(cdb_ap);
 	kfree(a_hds);
 	return res;
@@ -1414,6 +1805,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 	cwr.h4p = h4p;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	cwr.cmd_len = h4p->request_len;
+	cwr.rsv_idx = -1;
 	cwr.u_cmdp = cuptr64(h4p->request);
 	cwr.cmdp = NULL;
 	srp = sg_common_write(&cwr);
@@ -1485,11 +1877,12 @@ sg_share_chk_flags(struct sg_fd *sfp, u32 rq_flags, int dxfer_len, int dir,
 	enum sg_shr_var sh_var = SG_SHR_NONE;
 
 	if (rq_flags & SGV4_FLAG_SHARE) {
-		if (unlikely(rq_flags & SG_FLAG_DIRECT_IO))
+		if (unlikely(rq_flags & SG_FLAG_DIRECT_IO)) {
 			result = -EINVAL; /* since no control of data buffer */
-		else if (unlikely(dxfer_len < 1))
-			result = -ENODATA;
-		else if (is_read_side) {
+		} else if (unlikely(dxfer_len < 1)) {
+			sh_var = is_read_side ? SG_SHR_RS_NOT_SRQ :
+						SG_SHR_WS_NOT_SRQ;
+		} else if (is_read_side) {
 			sh_var = SG_SHR_RS_RQ;
 			if (unlikely(dir != SG_DXFER_FROM_DEV))
 				result = -ENOMSG;
@@ -1498,7 +1891,7 @@ sg_share_chk_flags(struct sg_fd *sfp, u32 rq_flags, int dxfer_len, int dir,
 				if (unlikely(rq_flags & SG_FL_MMAP_DIRECT))
 					result = -ENODATA;
 			}
-		} else {			/* fd is write-side */
+		} else {
 			sh_var = SG_SHR_WS_RQ;
 			if (unlikely(dir != SG_DXFER_TO_DEV))
 				result = -ENOMSG;
@@ -1536,6 +1929,49 @@ sg_rq_state_fail_msg(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
 
 /* Functions ending in '_ulck' assume sfp->xa_lock held by caller. */
 static void
+sg_rq_chg_state_force_ulck(struct sg_request *srp, enum sg_rq_state new_st)
+{
+	bool prev, want;
+	struct sg_fd *sfp = srp->parentfp;
+	struct xarray *xafp = &sfp->srp_arr;
+
+	atomic_set(&srp->rq_st, new_st);
+	want = (new_st == SG_RQ_AWAIT_RCV);
+	prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
+	if (prev != want) {
+		if (want)
+			__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
+		else
+			__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
+	}
+	want = (new_st == SG_RQ_INACTIVE);
+	prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
+	if (prev != want) {
+		if (want) {
+			int prev_idx = READ_ONCE(sfp->low_used_idx);
+
+			if (prev_idx < 0 || srp->rq_idx < prev_idx ||
+			    !xa_get_mark(xafp, prev_idx, SG_XA_RQ_INACTIVE))
+				WRITE_ONCE(sfp->low_used_idx, srp->rq_idx);
+			__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
+		} else {
+			__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
+		}
+	}
+}
+
+static void
+sg_rq_chg_state_force(struct sg_request *srp, enum sg_rq_state new_st)
+{
+	unsigned long iflags;
+	struct xarray *xafp = &srp->parentfp->srp_arr;
+
+	xa_lock_irqsave(xafp, iflags);
+	sg_rq_chg_state_force_ulck(srp, new_st);
+	xa_unlock_irqrestore(xafp, iflags);
+}
+
+static inline void
 sg_rq_chg_state_help(struct xarray *xafp, struct sg_request *srp, int indic)
 {
 	if (indic & 1)		/* from inactive state */
@@ -1565,13 +2001,10 @@ static int
 sg_rq_chg_state_ulck(struct sg_request *srp, enum sg_rq_state old_st,
 		     enum sg_rq_state new_st)
 {
-	enum sg_rq_state act_old_st;
-	int indic;
+	enum sg_rq_state act_old_st =
+			(enum sg_rq_state)atomic_cmpxchg_relaxed(&srp->rq_st, old_st, new_st);
+	int indic = sg_rq_state_arr[(int)old_st] + sg_rq_state_mul2arr[(int)new_st];
 
-	indic = sg_rq_state_arr[(int)old_st] +
-		sg_rq_state_mul2arr[(int)new_st];
-	act_old_st = (enum sg_rq_state)atomic_cmpxchg(&srp->rq_st, old_st,
-						      new_st);
 	if (unlikely(act_old_st != old_st)) {
 #if IS_ENABLED(SG_LOG_ACTIVE)
 		SG_LOG(1, srp->parentfp, "%s: unexpected old state: %s\n",
@@ -1579,8 +2012,19 @@ sg_rq_chg_state_ulck(struct sg_request *srp, enum sg_rq_state old_st,
 #endif
 		return -EPROTOTYPE;	/* only used for this error type */
 	}
-	if (indic)
-		sg_rq_chg_state_help(&srp->parentfp->srp_arr, srp, indic);
+	if (indic) {
+		struct sg_fd *sfp = srp->parentfp;
+
+		if (new_st == SG_RQ_INACTIVE) {
+			int prev_idx = READ_ONCE(sfp->low_used_idx);
+			struct xarray *xafp = &sfp->srp_arr;
+
+			if (prev_idx < 0 || srp->rq_idx < prev_idx ||
+			    !xa_get_mark(xafp, prev_idx, SG_XA_RQ_INACTIVE))
+				WRITE_ONCE(sfp->low_used_idx, srp->rq_idx);
+		}
+		sg_rq_chg_state_help(&sfp->srp_arr, srp, indic);
+	}
 	return 0;
 }
 
@@ -1625,47 +2069,139 @@ sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
 	return 0;
 }
 
-static void
-sg_rq_chg_state_force_ulck(struct sg_request *srp, enum sg_rq_state new_st)
+/*
+ * Returns index of an unused element in sfp's rsv_arr, or -1 if it is full.
+ * Marks that element's rsv_srp with ERR_PTR(-EBUSY) to reserve that index.
+ */
+static int
+sg_get_idx_new(struct sg_fd *sfp)
 {
-	bool prev, want;
-	struct sg_fd *sfp = srp->parentfp;
-	struct xarray *xafp = &sfp->srp_arr;
+	int k;
+	struct sg_request **rapp = sfp->rsv_arr;
 
-	atomic_set(&srp->rq_st, new_st);
-	want = (new_st == SG_RQ_AWAIT_RCV);
-	prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
-	if (prev != want) {
-		if (want)
-			__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
-		else
-			__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
+	for (k = 0; k < SG_MAX_RSV_REQS; ++k, ++rapp) {
+		if (!*rapp) {
+			*rapp = ERR_PTR(-EBUSY);
+			return k;
+		}
 	}
-	want = (new_st == SG_RQ_INACTIVE);
-	prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
-	if (prev != want) {
-		if (want) {
-			int prev_idx = READ_ONCE(sfp->low_used_idx);
+	return -1;
+}
 
-			if (prev_idx < 0 || srp->rq_idx < prev_idx ||
-			    !xa_get_mark(xafp, prev_idx, SG_XA_RQ_INACTIVE))
-				WRITE_ONCE(sfp->low_used_idx, srp->rq_idx);
-			__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
-		} else {
-			__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
+static int
+sg_get_idx_new_lck(struct sg_fd *sfp)
+{
+	int res;
+	unsigned long iflags;
+
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	res = sg_get_idx_new(sfp);
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+	return res;
+}
+
+/*
+ * Looks for an available element index in sfp's rsv_arr. That element's
+ * sh_srp must be NULL and will be set to ERR_PTR(-EBUSY). If no element
+ * is available then returns -1.
+ */
+static int
+sg_get_idx_available(struct sg_fd *sfp)
+{
+	int k;
+	struct sg_request **rapp = sfp->rsv_arr;
+	struct sg_request *srp;
+
+	for (k = 0; k < SG_MAX_RSV_REQS; ++k, ++rapp) {
+		srp = *rapp;
+		if (!IS_ERR_OR_NULL(srp)) {
+			if (!srp->sh_srp && !SG_RQ_ACTIVE(srp)) {
+				srp->sh_srp = ERR_PTR(-EBUSY);
+				return k;
+			}
 		}
 	}
+	return -1;
 }
 
-static void
-sg_rq_chg_state_force(struct sg_request *srp, enum sg_rq_state new_st)
+static struct sg_request *
+sg_get_probable_read_side(struct sg_fd *sfp)
+{
+	struct sg_request **rapp = sfp->rsv_arr;
+	struct sg_request **end_rapp = rapp + SG_MAX_RSV_REQS;
+	struct sg_request *rs_srp;
+
+	for ( ; rapp < end_rapp; ++rapp) {
+		rs_srp = *rapp;
+		if (IS_ERR_OR_NULL(rs_srp) || rs_srp->sh_srp)
+			continue;
+		switch (atomic_read(&rs_srp->rq_st)) {
+		case SG_RQ_INFLIGHT:
+		case SG_RQ_AWAIT_RCV:
+		case SG_RQ_BUSY:
+		case SG_RQ_SHR_SWAP:
+			return rs_srp;
+		default:
+			break;
+		}
+	}
+	return NULL;
+}
+
+/*
+ * Returns string of the form: <leadin>rsv<num><leadout> if srp is one of
+ * the reserve requests. Otherwise a blank string of length <leadin> plus
+ * length of <leadout> is returned.
+ */
+static const char *
+sg_get_rsv_str(struct sg_request *srp, const char *leadin,
+	       const char *leadout, int b_len, char *b)
+{
+	int k, i_len, o_len, len;
+	struct sg_fd *sfp;
+	struct sg_request **rapp;
+
+	if (!b || b_len < 1)
+		return b;
+	if (!leadin)
+		leadin = "";
+	if (!leadout)
+		leadout = "";
+	i_len = strlen(leadin);
+	o_len = strlen(leadout);
+	if (!srp)
+		goto blank;
+	sfp = srp->parentfp;
+	if (!sfp)
+		goto blank;
+	rapp = sfp->rsv_arr;
+	for (k = 0; k < SG_MAX_RSV_REQS; ++k, ++rapp) {
+		if (srp == *rapp)
+			break;
+	}
+	if (k >= SG_MAX_RSV_REQS)
+		goto blank;
+	scnprintf(b, b_len, "%srsv%d%s", leadin, k, leadout);
+	return b;
+blank:
+	len = min_t(int, i_len + o_len, b_len - 1);
+	for (k = 0; k < len; ++k)
+		b[k] = ' ';
+	b[len] = '\0';
+	return b;
+}
+
+static inline const char *
+sg_get_rsv_str_lck(struct sg_request *srp, const char *leadin,
+		   const char *leadout, int b_len, char *b)
 {
 	unsigned long iflags;
-	struct xarray *xafp = &srp->parentfp->srp_arr;
+	const char *cp;
 
-	xa_lock_irqsave(xafp, iflags);
-	sg_rq_chg_state_force_ulck(srp, new_st);
-	xa_unlock_irqrestore(xafp, iflags);
+	xa_lock_irqsave(&srp->parentfp->srp_arr, iflags);
+	cp = sg_get_rsv_str(srp, leadin, leadout, b_len, b);
+	xa_unlock_irqrestore(&srp->parentfp->srp_arr, iflags);
+	return cp;
 }
 
 static void
@@ -1691,9 +2227,8 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 	else            /* this sfd is defaulting to head */
 		at_head = !(srp->rq_flags & SG_FLAG_Q_AT_TAIL);
 
-	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
+	kref_get(&sfp->f_ref); /* put usually in: sg_rq_end_io() */
 	sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
-
 	/* >>>>>>> send cmd/req off to other levels <<<<<<<< */
 	if (!sync) {
 		atomic_inc(&sfp->submitted);
@@ -1761,7 +2296,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 	} else {
 		sh_var = SG_SHR_NONE;
 		if (unlikely(rq_flags & SGV4_FLAG_SHARE))
-			return ERR_PTR(-ENOMSG);
+			return ERR_PTR(-ENOMSG);    /* no file share found */
 	}
 	if (unlikely(dxfr_len >= SZ_256M))
 		return ERR_PTR(-EINVAL);
@@ -1779,6 +2314,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		srp->s_hdr4.cmd_len = h4p->request_len;
 		srp->s_hdr4.dir = dir;
 		srp->s_hdr4.out_resid = 0;
+		srp->s_hdr4.mrq_ind = 0;
 	} else {	/* v3 interface active */
 		memcpy(&srp->s_hdr3, hi_p, sizeof(srp->s_hdr3));
 	}
@@ -1873,7 +2409,6 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	int err = 0;
 	u32 rq_res = srp->rq_result;
 	enum sg_shr_var sh_var = srp->sh_var;
-	struct sg_fd *sh_sfp;
 
 	if (unlikely(srp->rq_result & 0xff)) {
 		int sb_len_wr = sg_copy_sense(srp, v4_active);
@@ -1886,30 +2421,40 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	if (unlikely(test_bit(SG_FRQ_ABORTING, srp->frq_bm)))
 		srp->rq_info |= SG_INFO_ABORTED;
 
-	sh_sfp = sg_fd_share_ptr(sfp);
 	if (sh_var == SG_SHR_WS_RQ && sg_fd_is_shared(sfp)) {
-		struct sg_request *rs_srp = sh_sfp->rsv_srp;
-		enum sg_rq_state mar_st = atomic_read(&rs_srp->rq_st);
+		enum sg_rq_state rs_st;
+		struct sg_request *rs_srp = srp->sh_srp;
+
+		if (!rs_srp)
+			return -EPROTO;
+		rs_st = atomic_read(&rs_srp->rq_st);
 
-		switch (mar_st) {
+		switch (rs_st) {
 		case SG_RQ_SHR_SWAP:
 		case SG_RQ_SHR_IN_WS:
 			/* make read-side request available for re-use */
 			rs_srp->tag = SG_TAG_WILDCARD;
 			rs_srp->sh_var = SG_SHR_NONE;
 			sg_rq_chg_state_force(rs_srp, SG_RQ_INACTIVE);
-			atomic_inc(&sh_sfp->inactives);
+			atomic_inc(&rs_srp->parentfp->inactives);
+			rs_srp->frq_bm[0] = 0;
+			__set_bit(SG_FRQ_RESERVED, rs_srp->frq_bm);
+			rs_srp->in_resid = 0;
+			rs_srp->rq_info = 0;
+			rs_srp->sense_len = 0;
+			rs_srp->sh_srp = NULL;
 			break;
 		case SG_RQ_AWAIT_RCV:
 			break;
 		case SG_RQ_INACTIVE:
-			sh_sfp->ws_srp = NULL;
-			break;	/* nothing to do */
+			/* remove request share mapping */
+			rs_srp->sh_srp = NULL;
+			break;
 		default:
 			err = -EPROTO;	/* Logic error */
 			SG_LOG(1, sfp,
 			       "%s: SHR_WS_RQ, bad read-side state: %s\n",
-			       __func__, sg_rq_st_str(mar_st, true));
+			       __func__, sg_rq_st_str(rs_st, true));
 			break;	/* nothing to do */
 		}
 	}
@@ -1924,6 +2469,8 @@ sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
 	enum sg_rq_state sr_st = atomic_read(&srp->rq_st);
 
 	/* advance state machine, send signal to write-side if appropriate */
+	SG_LOG(4, sfp, "%s: %pK: sh_var=%s\n", __func__, srp,
+	       sg_shr_str(srp->sh_var, true));
 	switch (srp->sh_var) {
 	case SG_SHR_RS_RQ:
 		{
@@ -1939,29 +2486,32 @@ sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
 			} else if (sr_st != SG_RQ_SHR_SWAP) {
 				sg_rq_chg_state_force(srp, SG_RQ_SHR_SWAP);
 			}
-			if (ws_sfp && ws_sfp->async_qp &&
+			if (ws_sfp && ws_sfp->async_qp && !srp->sh_srp &&
 			    (!test_bit(SG_FRQ_IS_V4I, srp->frq_bm) ||
 			     (srp->rq_flags & SGV4_FLAG_SIGNAL)))
 				kill_fasync(&ws_sfp->async_qp, SIGPOLL,
 					    poll_type);
 		}
 		break;
-	case SG_SHR_WS_RQ:      /* cleanup both on write-side completion */
-		{
-			struct sg_fd *rs_sfp = sg_fd_share_ptr(sfp);
+	case SG_SHR_WS_RQ:	/* cleanup both on write-side completion */
+		if (likely(sg_fd_is_shared(sfp))) {
+			struct sg_request *rs_srp = srp->sh_srp;
 
-			if (likely(rs_sfp)) {
-				rs_sfp->ws_srp = NULL;
-				if (rs_sfp->rsv_srp)
-					rs_sfp->rsv_srp->sh_var =
-							SG_SHR_RS_NOT_SRQ;
+			if (rs_srp) {
+				rs_srp->sh_srp = NULL;
+				rs_srp->sh_var = SG_SHR_RS_NOT_SRQ;
+			} else {
+				SG_LOG(2, sfp, "%s: write-side's paired read is missing\n",
+				       __func__);
 			}
 		}
 		srp->sh_var = SG_SHR_WS_NOT_SRQ;
+		srp->sh_srp = NULL;
 		srp->sgatp = &srp->sgat_h;
 		if (sr_st != SG_RQ_BUSY)
 			sg_rq_chg_state_force(srp, SG_RQ_BUSY);
 		break;
+	case SG_SHR_WS_NOT_SRQ:
 	default:
 		if (sr_st != SG_RQ_BUSY)
 			sg_rq_chg_state_force(srp, SG_RQ_BUSY);
@@ -2017,6 +2567,7 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 }
 
 /*
+ * Invoked when user calls ioctl(SG_IORECEIVE, SGV4_FLAG_MULTIPLE_REQS).
  * Returns negative on error including -ENODATA if there are no mrqs submitted
  * nor waiting. Otherwise it returns the number of elements written to
  * rsp_arr, which may be 0 if mrqs submitted but none waiting
@@ -2059,7 +2610,7 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs,
 
 /*
  * Invoked when user calls ioctl(SG_IORECEIVE, SGV4_FLAG_MULTIPLE_REQS).
- * Expected race as multiple concurrent calls with the same pack_id/tag can
+ * Expected race as many concurrent calls with the same pack_id/tag can
  * occur. Only one should succeed per request (more may succeed but will get
  * different requests).
  */
@@ -2541,7 +3092,7 @@ sg_change_after_read_side_rq(struct sg_fd *sfp, bool fini1_again0)
 		goto fini;
 	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE))
 		rs_sfp = sfp;
-	rs_rsv_srp = sfp->rsv_srp;
+	rs_rsv_srp = rs_sfp->rsv_arr[0];
 	if (IS_ERR_OR_NULL(rs_rsv_srp))
 		goto fini;
 
@@ -2592,18 +3143,27 @@ sg_change_after_read_side_rq(struct sg_fd *sfp, bool fini1_again0)
 static void
 sg_unshare_rs_fd(struct sg_fd *rs_sfp, bool lck)
 {
+	int k;
 	unsigned long iflags = 0;
 	struct sg_device *sdp = rs_sfp->parentdp;
+	struct sg_request **rapp = rs_sfp->rsv_arr;
 	struct xarray *xadp = &sdp->sfp_arr;
+	struct sg_request *r_srp;
 
-	rcu_assign_pointer(rs_sfp->share_sfp, NULL);
 	if (lck)
-		xa_lock_irqsave(xadp, iflags);
-	rs_sfp->ws_srp = NULL;
+		xa_lock_irqsave_nested(xadp, iflags, 1);
+	__clear_bit(SG_FFD_RESHARE, rs_sfp->ffd_bm);
+	for (k = 0; k < SG_MAX_RSV_REQS; ++k, ++rapp) {
+		r_srp = *rapp;
+		if (IS_ERR_OR_NULL(r_srp))
+			continue;
+		r_srp->sh_srp = NULL;
+	}
 	__xa_set_mark(xadp, rs_sfp->idx, SG_XA_FD_UNSHARED);
 	__xa_clear_mark(xadp, rs_sfp->idx, SG_XA_FD_RS_SHARE);
 	if (lck)
 		xa_unlock_irqrestore(xadp, iflags);
+	rcu_assign_pointer(rs_sfp->share_sfp, NULL);
 	kref_put(&rs_sfp->f_ref, sg_remove_sfp);/* get: sg_find_sfp_by_fd() */
 }
 
@@ -2614,13 +3174,13 @@ sg_unshare_ws_fd(struct sg_fd *ws_sfp, bool lck)
 	struct sg_device *sdp = ws_sfp->parentdp;
 	struct xarray *xadp = &sdp->sfp_arr;
 
-	rcu_assign_pointer(ws_sfp->share_sfp, NULL);
 	if (lck)
-		xa_lock_irqsave(xadp, iflags);
+		xa_lock_irqsave_nested(xadp, iflags, 1);
 	__xa_set_mark(xadp, ws_sfp->idx, SG_XA_FD_UNSHARED);
 	/* SG_XA_FD_RS_SHARE mark should be already clear */
 	if (lck)
 		xa_unlock_irqrestore(xadp, iflags);
+	rcu_assign_pointer(ws_sfp->share_sfp, NULL);
 	kref_put(&ws_sfp->f_ref, sg_remove_sfp);/* get: sg_find_sfp_by_fd() */
 }
 
@@ -2633,74 +3193,95 @@ sg_unshare_ws_fd(struct sg_fd *ws_sfp, bool lck)
  */
 static void
 sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
+		__must_hold(sfp->parentdp->open_rel_lock)
 {
 	__maybe_unused int res = 0;
+	int k, retry_count;
 	unsigned long iflags;
 	enum sg_rq_state sr_st;
+	struct sg_request **rapp;
 	struct sg_device *sdp = sfp->parentdp;
 	struct sg_device *sh_sdp;
 	struct sg_fd *sh_sfp;
 	struct sg_request *rsv_srp = NULL;
 	struct sg_request *ws_srp;
 	struct xarray *xadp = &sdp->sfp_arr;
+	struct xarray *xafp = &sfp->srp_arr;
 
 	SG_LOG(3, sfp, "%s: sfp=%pK %s\n", __func__, sfp,
 	       (is_rd_side ? "read-side" : "write-side"));
 	xa_lock_irqsave(xadp, iflags);
+	retry_count = 0;
+try_again:
+	if (is_rd_side && !xa_get_mark(xadp, sfp->idx, SG_XA_FD_RS_SHARE))
+		goto fini;
 	sh_sfp = sg_fd_share_ptr(sfp);
-	if (!sg_fd_is_shared(sfp))
-		goto err_out;
+	if (unlikely(!sh_sfp))
+		goto fini;
 	sh_sdp = sh_sfp->parentdp;
-	if (is_rd_side) {
-		bool set_inactive = false;
-
-		if (unlikely(!xa_get_mark(xadp, sfp->idx,
-					  SG_XA_FD_RS_SHARE))) {
-			xa_unlock_irqrestore(xadp, iflags);
+	if (!xa_trylock(xafp)) {
+		/*
+		 * The other side of the share might be closing as well, avoid
+		 * deadlock. Should clear relatively quickly.
+		 */
+		xa_unlock_irqrestore(xadp, iflags);
+		if (++retry_count > SG_ADD_RQ_MAX_RETRIES) {
+			SG_LOG(1, sfp, "%s: retry_count>>\n", __func__);
 			return;
 		}
-		rsv_srp = sfp->rsv_srp;
-		if (unlikely(!rsv_srp))
-			goto fini;
-		if (unlikely(rsv_srp->sh_var != SG_SHR_RS_RQ))
-			goto fini;
-		sr_st = atomic_read(&rsv_srp->rq_st);
-		switch (sr_st) {
-		case SG_RQ_SHR_SWAP:
-			set_inactive = true;
-			break;
-		case SG_RQ_SHR_IN_WS:
-			ws_srp = sfp->ws_srp;
-			if (ws_srp && !IS_ERR(ws_srp)) {
-				ws_srp->sh_var = SG_SHR_WS_NOT_SRQ;
-				sfp->ws_srp = NULL;
+		mutex_unlock(&sdp->open_rel_lock);
+		cpu_relax();
+		mutex_lock(&sdp->open_rel_lock);
+		xa_lock_irqsave(xadp, iflags);
+		goto try_again;
+	}
+	/* have acquired xafp lock */
+	if (is_rd_side) {
+		rapp = sfp->rsv_arr;
+		for (k = 0; k < SG_MAX_RSV_REQS; ++k, ++rapp) {
+			bool set_inactive = false;
+
+			rsv_srp = *rapp;
+			if (IS_ERR_OR_NULL(rsv_srp) ||
+			    rsv_srp->sh_var != SG_SHR_RS_RQ)
+				continue;
+			sr_st = atomic_read(&rsv_srp->rq_st);
+			switch (sr_st) {
+			case SG_RQ_SHR_SWAP:
+				set_inactive = true;
+				break;
+			case SG_RQ_SHR_IN_WS:
+				ws_srp = rsv_srp->sh_srp;
+				if (!IS_ERR_OR_NULL(ws_srp) &&
+				    !test_bit(SG_FFD_RELEASE,
+					      sh_sfp->ffd_bm)) {
+					ws_srp->sh_var = SG_SHR_WS_NOT_SRQ;
+				}
+				rsv_srp->sh_srp = NULL;
+				set_inactive = true;
+				break;
+			default:
+				break;
+			}
+			rsv_srp->sh_var = SG_SHR_NONE;
+			if (set_inactive) {
+				res = sg_rq_chg_state_ulck(rsv_srp, sr_st, SG_RQ_INACTIVE);
+				if (!res)
+					atomic_inc(&sfp->inactives);
 			}
-			set_inactive = true;
-			break;
-		default:
-			break;
-		}
-		rsv_srp->sh_var = SG_SHR_NONE;
-		if (set_inactive) {
-			res = sg_rq_chg_state_ulck(rsv_srp, sr_st, SG_RQ_INACTIVE);
-			if (!res)
-				atomic_inc(&sfp->inactives);
 		}
-fini:
 		if (!xa_get_mark(&sh_sdp->sfp_arr, sh_sfp->idx,
 				 SG_XA_FD_FREE) && sg_fd_is_shared(sh_sfp))
 			sg_unshare_ws_fd(sh_sfp, sdp != sh_sdp);
 		sg_unshare_rs_fd(sfp, false);
-	} else {
-		if (unlikely(!sg_fd_is_shared(sfp))) {
-			xa_unlock_irqrestore(xadp, iflags);
-			return;
-		} else if (!xa_get_mark(&sh_sdp->sfp_arr, sh_sfp->idx,
-					SG_XA_FD_FREE))
+	} else {			/* is write-side of share */
+		if (!xa_get_mark(&sh_sdp->sfp_arr, sh_sfp->idx,
+				 SG_XA_FD_FREE) && sg_fd_is_shared(sh_sfp))
 			sg_unshare_rs_fd(sh_sfp, sdp != sh_sdp);
 		sg_unshare_ws_fd(sfp, false);
 	}
-err_out:
+	xa_unlock(xafp);
+fini:
 	xa_unlock_irqrestore(xadp, iflags);
 }
 
@@ -2713,27 +3294,31 @@ static void
 sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
 		__must_hold(sfp->f_mutex)
 {
-	bool retry;
+	bool retry, same_sdp_s;
 	int retry_count = 0;
+	unsigned long iflags;
 	struct sg_request *rs_rsv_srp;
 	struct sg_fd *rs_sfp;
 	struct sg_fd *ws_sfp;
 	struct sg_fd *o_sfp = sg_fd_share_ptr(sfp);
 	struct sg_device *sdp = sfp->parentdp;
+	struct xarray *xadp = &sdp->sfp_arr;
 
-	if (!sg_fd_is_shared(sfp)) {
+	if (unlikely(!o_sfp)) {
 		SG_LOG(1, sfp, "%s: not shared ? ?\n", __func__);
 		return;	/* no share to undo */
 	}
 	if (!unshare_val)
 		return;		/* when unshare value is zero, it's a NOP */
+	same_sdp_s = (o_sfp && sfp->parentdp == o_sfp->parentdp);
 again:
 	retry = false;
 	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE)) {
 		rs_sfp = sfp;
 		ws_sfp = o_sfp;
-		rs_rsv_srp = rs_sfp->rsv_srp;
-		if (rs_rsv_srp && rs_rsv_srp->sh_var != SG_SHR_RS_RQ) {
+		rs_rsv_srp = rs_sfp->rsv_arr[0];
+		if (!IS_ERR_OR_NULL(rs_rsv_srp) &&
+		    rs_rsv_srp->sh_var != SG_SHR_RS_RQ) {
 			if (unlikely(!mutex_trylock(&ws_sfp->f_mutex))) {
 				if (++retry_count > SG_ADD_RQ_MAX_RETRIES)
 					SG_LOG(1, sfp,
@@ -2743,7 +3328,16 @@ sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
 					retry = true;
 				goto fini;
 			}
-			sg_unshare_rs_fd(rs_sfp, true);
+			if (same_sdp_s) {
+				xa_lock_irqsave(xadp, iflags);
+				/* write-side is 'other' so do first */
+				sg_unshare_ws_fd(ws_sfp, false);
+				sg_unshare_rs_fd(rs_sfp, false);
+				xa_unlock_irqrestore(xadp, iflags);
+			} else {
+				sg_unshare_ws_fd(ws_sfp, true);
+				sg_unshare_rs_fd(rs_sfp, true);
+			}
 			mutex_unlock(&ws_sfp->f_mutex);
 		}
 	} else {			/* called on write-side fd */
@@ -2757,10 +3351,19 @@ sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
 				retry = true;
 			goto fini;
 		}
-		rs_rsv_srp = rs_sfp->rsv_srp;
-		if (rs_rsv_srp->sh_var != SG_SHR_RS_RQ) {
-			sg_unshare_rs_fd(rs_sfp, true);
-			sg_unshare_ws_fd(ws_sfp, true);
+		rs_rsv_srp = rs_sfp->rsv_arr[0];
+		if (!IS_ERR_OR_NULL(rs_rsv_srp) &&
+		    rs_rsv_srp->sh_var != SG_SHR_RS_RQ) {
+			if (same_sdp_s) {
+				xa_lock_irqsave(xadp, iflags);
+				/* read-side is 'other' so do first */
+				sg_unshare_rs_fd(rs_sfp, false);
+				sg_unshare_ws_fd(ws_sfp, false);
+				xa_unlock_irqrestore(xadp, iflags);
+			} else {
+				sg_unshare_rs_fd(rs_sfp, true);
+				sg_unshare_ws_fd(ws_sfp, true);
+			}
 		}
 		mutex_unlock(&rs_sfp->f_mutex);
 	}
@@ -2970,6 +3573,16 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	return res;
 }
 
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
 /*
  * When use_tag is true then id is a tag, else it is a pack_id. Returns
  * valid srp if match, else returns NULL.
@@ -2977,15 +3590,11 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 static struct sg_request *
 sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
 {
-	int num_waiting = atomic_read(&sfp->waiting);
 	unsigned long idx;
 	struct sg_request *srp;
 
-	if (num_waiting < 1) {
-		num_waiting = atomic_read_acquire(&sfp->waiting);
-		if (num_waiting < 1)
-			return NULL;
-	}
+	if (sg_num_waiting_maybe_acquire(sfp) < 1)
+		return NULL;
 	if (id == SG_PACK_ID_WILDCARD) {
 		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT)
 			return srp;
@@ -3019,14 +3628,10 @@ sg_match_first_mrq_after(struct sg_fd *sfp, int pack_id,
 	unsigned long idx;
 	struct sg_request *srp;
 
-	if (atomic_read(&sfp->waiting) < 1) {
-		if (atomic_read_acquire(&sfp->waiting) < 1)
-			return NULL;
-	}
+	if (sg_num_waiting_maybe_acquire(sfp) < 1)
+		return NULL;
 once_more:
 	xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
-		if (unlikely(!srp))
-			continue;
 		if (look_for_after) {
 			if (after_rp == srp)
 				look_for_after = false;
@@ -3095,16 +3700,15 @@ sg_abort_req(struct sg_fd *sfp, struct sg_request *srp)
 	return res;
 }
 
+/* Holding xa_lock_irq(&sfp->srp_arr) */
 static int
 sg_mrq_abort_inflight(struct sg_fd *sfp, int pack_id)
 {
 	bool got_ebusy = false;
 	int res = 0;
-	unsigned long iflags;
 	struct sg_request *srp;
 	struct sg_request *prev_srp;
 
-	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	for (prev_srp = NULL; true; prev_srp = srp) {
 		srp = sg_match_first_mrq_after(sfp, pack_id, prev_srp);
 		if (!srp)
@@ -3115,7 +3719,6 @@ sg_mrq_abort_inflight(struct sg_fd *sfp, int pack_id)
 		else if (res)
 			break;
 	}
-	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 	if (res)
 		return res;
 	return got_ebusy ? -EBUSY : 0;
@@ -3135,7 +3738,7 @@ sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
 {
 	int existing_id;
 	int res = 0;
-	unsigned long idx;
+	unsigned long idx, iflags;
 	struct sg_device *sdp;
 	struct sg_fd *o_sfp;
 	struct sg_fd *s_sfp;
@@ -3167,7 +3770,7 @@ sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
 		       __func__, pack_id);
 
 	/* now look for inflight requests matching that mrq pack_id */
-	xa_lock(&sfp->srp_arr);
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	res = sg_mrq_abort_inflight(sfp, pack_id);
 	if (res == -EBUSY) {
 		res = sg_mrq_abort_inflight(sfp, pack_id);
@@ -3175,11 +3778,11 @@ sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
 			goto fini;
 	}
 	s_sfp = sg_fd_share_ptr(sfp);
-	if (s_sfp) {	/* SGV4_FLAG_DO_ON_OTHER may have been used */
-		xa_unlock(&sfp->srp_arr);
-		sfp = s_sfp;	/* if share, check other fd */
-		xa_lock(&sfp->srp_arr);
-		if (sg_fd_is_shared(sfp))
+	if (s_sfp) {	/* SGV4_FLAG_DO_ON_OTHER possible */
+		xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+		sfp = s_sfp;	/* if share, switch to other fd */
+		xa_lock_irqsave(&sfp->srp_arr, iflags);
+		if (!sg_fd_is_shared(sfp))
 			goto fini;
 		/* tough luck if other fd used same mrq pack_id */
 		res = sg_mrq_abort_inflight(sfp, pack_id);
@@ -3187,7 +3790,7 @@ sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
 			res = sg_mrq_abort_inflight(sfp, pack_id);
 	}
 fini:
-	xa_unlock(&sfp->srp_arr);
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 	return res;
 
 check_whole_dev:
@@ -3196,10 +3799,10 @@ sg_mrq_abort(struct sg_fd *sfp, int pack_id, bool dev_scope)
 	xa_for_each(&sdp->sfp_arr, idx, o_sfp) {
 		if (o_sfp == sfp)
 			continue;       /* already checked */
-		xa_lock(&o_sfp->srp_arr);
+		mutex_lock(&o_sfp->f_mutex);
 		/* recurse, dev_scope==false is stopping condition */
 		res = sg_mrq_abort(o_sfp, pack_id, false);
-		xa_unlock(&o_sfp->srp_arr);
+		mutex_unlock(&o_sfp->f_mutex);
 		if (res == 0)
 			break;
 	}
@@ -3235,12 +3838,13 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	if (h4p->flags & SGV4_FLAG_MULTIPLE_REQS) {
 		if (pack_id == 0)
 			return -ENOSTR;
-		return sg_mrq_abort(sfp, pack_id, dev_scope);
+		res = sg_mrq_abort(sfp, pack_id, dev_scope);
+		return res;
 	}
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	use_tag = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm);
 	id = use_tag ? (int)h4p->request_tag : pack_id;
 
-	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	srp = sg_match_request(sfp, use_tag, id);
 	if (!srp) {	/* assume device (not just fd) scope */
 		xa_unlock_irqrestore(&sfp->srp_arr, iflags);
@@ -3311,7 +3915,7 @@ sg_find_sfp_by_fd(const struct file *search_for, struct sg_fd *from_sfp,
 		__xa_set_mark(&from_sdp->sfp_arr, from_sfp->idx,
 			      SG_XA_FD_RS_SHARE);
 	else
-		kref_get(&from_sfp->f_ref);/* so unshare done before release */
+		kref_get(&from_sfp->f_ref);  /* undone: sg_unshare_*_fd() */
 	if (from_sdp != sdp) {
 		xa_unlock_irqrestore(&from_sdp->sfp_arr, iflags);
 		xa_lock_irqsave(&sdp->sfp_arr, iflags);
@@ -3338,7 +3942,6 @@ sg_fd_share(struct sg_fd *ws_sfp, int m_fd)
 {
 	bool found = false;
 	int res = 0;
-	int retry_count = 0;
 	struct file *filp;
 	struct sg_fd *rs_sfp;
 
@@ -3360,22 +3963,9 @@ sg_fd_share(struct sg_fd *ws_sfp, int m_fd)
 	}
 	SG_LOG(6, ws_sfp, "%s: read-side fd okay, scan for filp=0x%pK\n",
 	       __func__, filp);
-again:
 	rs_sfp = sg_find_sfp_by_fd(filp, ws_sfp, false);
-	if (IS_ERR(rs_sfp)) {
-		res = PTR_ERR(rs_sfp);
-		if (res == -EPROBE_DEFER) {
-			if (unlikely(++retry_count > SG_ADD_RQ_MAX_RETRIES)) {
-				res = -EBUSY;
-			} else {
-				res = 0;
-				cpu_relax();
-				goto again;
-			}
-		}
-	} else {
+	if (!IS_ERR(rs_sfp))
 		found = !!rs_sfp;
-	}
 fini:
 	/* paired with filp=fget(m_fd) above */
 	fput(filp);
@@ -3395,8 +3985,6 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 {
 	bool found = false;
 	int res = 0;
-	int retry_count = 0;
-	enum sg_rq_state rq_st;
 	struct file *filp;
 	struct sg_fd *ws_sfp = sg_fd_share_ptr(rs_sfp);
 
@@ -3408,17 +3996,7 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 	if (unlikely(!xa_get_mark(&rs_sfp->parentdp->sfp_arr, rs_sfp->idx,
 				  SG_XA_FD_RS_SHARE)))
 		return -EINVAL;
-	if (unlikely(!ws_sfp))
-		return -EINVAL;
-	if (unlikely(!rs_sfp->rsv_srp))
-		res = -EPROTO;	/* Internal error */
-	rq_st = atomic_read(&rs_sfp->rsv_srp->rq_st);
-	if (!(rq_st == SG_RQ_INACTIVE || rq_st == SG_RQ_SHR_SWAP))
-		res = -EBUSY;		/* read-side reserve buffer busy */
-	if (rs_sfp->ws_srp)
-		res = -EBUSY;	/* previous write-side request not finished */
-	if (unlikely(res))
-		return res;
+	/* SG_XA_FD_RS_SHARE set impiles ws_sfp is valid */
 
 	/* Alternate approach: fcheck_files(current->files, m_fd) */
 	filp = fget(new_ws_fd);
@@ -3430,28 +4008,22 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 	}
 	SG_LOG(6, ws_sfp, "%s: write-side fd ok, scan for filp=0x%pK\n", __func__,
 	       filp);
-	sg_unshare_ws_fd(ws_sfp, false);
-again:
+	sg_unshare_ws_fd(ws_sfp, true);
 	ws_sfp = sg_find_sfp_by_fd(filp, rs_sfp, true);
-	if (IS_ERR(ws_sfp)) {
-		res = PTR_ERR(ws_sfp);
-		if (res == -EPROBE_DEFER) {
-			if (unlikely(++retry_count > SG_ADD_RQ_MAX_RETRIES)) {
-				res = -EBUSY;
-			} else {
-				res = 0;
-				cpu_relax();
-				goto again;
-			}
-		}
-	} else {
+	if (!IS_ERR(ws_sfp))
 		found = !!ws_sfp;
-	}
 fini:
 	/* paired with filp=fget(new_ws_fd) above */
 	fput(filp);
 	if (unlikely(res))
 		return res;
+	if (found) {	/* can only reshare rsv_arr[0] */
+		struct sg_request *rs_srp = rs_sfp->rsv_arr[0];
+
+		if (!IS_ERR_OR_NULL(rs_srp))
+			rs_srp->sh_srp = NULL;
+		set_bit(SG_FFD_RESHARE, rs_sfp->ffd_bm);
+	}
 	return found ? 0 : -ENOTSOCK; /* ENOTSOCK for fd exists but not sg */
 }
 
@@ -3469,76 +4041,92 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 {
 	bool use_new_srp = false;
 	int res = 0;
-	int new_sz, blen;
-	unsigned long idx, iflags;
+	int k, new_sz, blen;
+	unsigned long idx = 0;
+	unsigned long iflags;
 	struct sg_request *o_srp;       /* prior reserve sg_request */
 	struct sg_request *n_srp;       /* new sg_request, may be used */
 	struct sg_request *t_srp;       /* other fl entries */
 	struct sg_device *sdp = sfp->parentdp;
+	struct sg_request **rapp = &sfp->rsv_arr[SG_MAX_RSV_REQS - 1];
 	struct xarray *xafp = &sfp->srp_arr;
 
 	if (unlikely(sg_fd_is_shared(sfp)))
 		return -EBUSY;	/* this fd can't be either side of share */
-	o_srp = sfp->rsv_srp;
-	if (unlikely(!o_srp))
-		return -EPROTO;
 	new_sz = min_t(int, want_rsv_sz, sdp->max_sgat_sz);
 	new_sz = max_t(int, new_sz, sfp->sgat_elem_sz);
-	blen = o_srp->sgatp->buflen;
 	SG_LOG(3, sfp, "%s: was=%d, ask=%d, new=%d (sgat_elem_sz=%d)\n",
-	       __func__, blen, want_rsv_sz, new_sz, sfp->sgat_elem_sz);
-	if (blen == new_sz)
-		return 0;
-	n_srp = sg_mk_srp_sgat(sfp, true /* can take time */, new_sz);
-	if (IS_ERR(n_srp))
-		return PTR_ERR(n_srp);
-	/* new sg_request object, sized correctly is now available */
+	       __func__, *rapp ? (*rapp)->sgatp->buflen : -1,
+	       want_rsv_sz, new_sz, sfp->sgat_elem_sz);
+	if (unlikely(sfp->mmap_sz > 0))
+		return -EBUSY;	/* existing pages possibly pinned */
+
+	for (k = SG_MAX_RSV_REQS - 1; k >= 0; --k, --rapp) {
+		o_srp = *rapp;
+		if (IS_ERR_OR_NULL(o_srp))
+			continue;
+		blen = o_srp->sgatp->buflen;
+		if (blen == new_sz)
+			continue;
+		/* new sg_request object, sized correctly is now available */
+		n_srp = sg_mk_srp_sgat(sfp, true /* can take time */, new_sz);
+		if (IS_ERR(n_srp))
+			return PTR_ERR(n_srp);
 try_again:
-	o_srp = sfp->rsv_srp;
-	if (unlikely(!o_srp)) {
-		res = -EPROTO;
-		goto fini;
-	}
-	if (unlikely(SG_RQ_ACTIVE(o_srp) || sfp->mmap_sz > 0)) {
-		res = -EBUSY;
-		goto fini;
-	}
-	use_new_srp = true;
-	xa_for_each(xafp, idx, t_srp) {
-		if (t_srp != o_srp && new_sz <= t_srp->sgatp->buflen &&
-		    !SG_RQ_ACTIVE(t_srp)) {
-			use_new_srp = false;
-			sfp->rsv_srp = t_srp;
-			break;
+		o_srp = *rapp;
+		if (unlikely(SG_RQ_ACTIVE(o_srp))) {
+			res = -EBUSY;
+			goto fini;
 		}
-	}
-	if (use_new_srp) {
-		struct sg_request *cxc_srp;
+		use_new_srp = true;
+		xa_for_each_marked(xafp, idx, t_srp, SG_XA_RQ_INACTIVE) {
+			if (t_srp != o_srp && new_sz <= t_srp->sgatp->buflen) {
+				use_new_srp = false;
+				xa_lock_irqsave(xafp, iflags);
+				__clear_bit(SG_FRQ_RESERVED, o_srp->frq_bm);
+				__set_bit(SG_FRQ_RESERVED, t_srp->frq_bm);
+				*rapp = t_srp;
+				xa_unlock_irqrestore(xafp, iflags);
+				sg_remove_srp(n_srp);
+				kfree(n_srp);
+				n_srp = NULL;
+				break;
+			}
+		}
+		if (use_new_srp) {
+			struct sg_request *cxc_srp;
 
-		xa_lock_irqsave(xafp, iflags);
-		n_srp->rq_idx = o_srp->rq_idx;
-		idx = o_srp->rq_idx;
-		cxc_srp = __xa_cmpxchg(xafp, idx, o_srp, n_srp, GFP_ATOMIC);
-		if (o_srp == cxc_srp) {
-			sfp->rsv_srp = n_srp;
-			sg_rq_chg_state_force_ulck(n_srp, SG_RQ_INACTIVE);
-			/* don't bump inactives, since replaced an inactive */
-			xa_unlock_irqrestore(xafp, iflags);
-			SG_LOG(6, sfp, "%s: new rsv srp=0x%pK ++\n", __func__,
-			       n_srp);
-			sg_remove_sgat(o_srp);
-			kfree(o_srp);
-		} else {
-			xa_unlock_irqrestore(xafp, iflags);
-			SG_LOG(1, sfp, "%s: xa_cmpxchg() failed, again\n",
-			       __func__);
-			goto try_again;
+			xa_lock_irqsave(xafp, iflags);
+			n_srp->rq_idx = o_srp->rq_idx;
+			idx = o_srp->rq_idx;
+			cxc_srp = __xa_cmpxchg(xafp, idx, o_srp, n_srp,
+					       GFP_ATOMIC);
+			if (o_srp == cxc_srp) {
+				__assign_bit(SG_FRQ_RESERVED, n_srp->frq_bm,
+					     test_bit(SG_FRQ_RESERVED,
+						      o_srp->frq_bm));
+				*rapp = n_srp;
+				sg_rq_chg_state_force_ulck(n_srp, SG_RQ_INACTIVE);
+				xa_unlock_irqrestore(xafp, iflags);
+				SG_LOG(6, sfp, "%s: new rsv srp=0x%pK ++\n",
+				       __func__, n_srp);
+				n_srp = NULL;
+				sg_remove_srp(o_srp);
+				kfree(o_srp);
+				o_srp = NULL;
+			} else {
+				xa_unlock_irqrestore(xafp, iflags);
+				SG_LOG(1, sfp, "%s: xa_cmpxchg()-->retry\n",
+				       __func__);
+				goto try_again;
+			}
 		}
 	}
+	return res;
 fini:
-	if (!use_new_srp) {
-		sg_remove_sgat(n_srp);
-		kfree(n_srp);   /* no-one else has seen n_srp, so safe */
+	if (n_srp) {
+		sg_remove_srp(n_srp);
+		kfree(n_srp);	/* nothing has seen n_srp, so safe */
 	}
 	return res;
 }
@@ -3574,16 +4162,12 @@ static bool
 sg_any_persistent_orphans(struct sg_fd *sfp)
 {
 	if (test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm)) {
-		int num_waiting = atomic_read(&sfp->waiting);
 		unsigned long idx;
 		struct sg_request *srp;
 		struct xarray *xafp = &sfp->srp_arr;
 
-		if (num_waiting < 1) {
-			num_waiting = atomic_read_acquire(&sfp->waiting);
-			if (num_waiting < 1)
-				return false;
-		}
+		if (sg_num_waiting_maybe_acquire(sfp) < 1)
+			return false;
 		xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_AWAIT) {
 			if (test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm))
 				return true;
@@ -3592,9 +4176,17 @@ sg_any_persistent_orphans(struct sg_fd *sfp)
 	return false;
 }
 
-/* Ignore append if size already over half of available buffer */
+/*
+ * Will clear_first if size already over half of available buffer.
+ *
+ * N.B. This function is a useful debug aid to be called inline with its
+ * output going to /sys/kernel/debug/scsi_generic/snapped for later
+ * examination. Best to call it with no locks held and that implies that
+ * the driver state may change while it is processing. Interpret the
+ * result with this in mind.
+ */
 static void
-sg_take_snap(struct sg_fd *sfp, bool dont_append)
+sg_take_snap(struct sg_fd *sfp, bool clear_first)
 {
 	u32 hour, minute, second;
 	u64 n;
@@ -3619,7 +4211,7 @@ sg_take_snap(struct sg_fd *sfp, bool dont_append)
 				      GFP_KERNEL | __GFP_NOWARN);
 		if (!snapped_buf)
 			goto fini;
-	} else if (dont_append) {
+	} else if (clear_first) {
 		memset(snapped_buf, 0, SG_SNAP_BUFF_SZ);
 	}
 #if IS_ENABLED(SG_PROC_OR_DEBUG_FS)
@@ -3653,10 +4245,11 @@ sg_take_snap(struct sg_fd *sfp, bool dont_append)
  * of boolean flags. Access abbreviations: [rw], read-write; [ro], read-only;
  * [wo], write-only; [raw], read after write; [rbw], read before write.
  */
-static void
+static int
 sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 {
 	bool flg = false;
+	int res = 0;
 	const u32 c_flgs_wm = seip->ctl_flags_wr_mask;
 	const u32 c_flgs_rm = seip->ctl_flags_rd_mask;
 	const u32 c_flgs_val_in = seip->ctl_flags;
@@ -3740,10 +4333,10 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 	 * reading: read-side is finished, awaiting action by write-side;
 	 * when written: 1 --> write-side doesn't want to continue
 	 */
-	if (c_flgs_rm & SG_CTL_FLAGM_READ_SIDE_FINI) {
+	if ((c_flgs_rm & SG_CTL_FLAGM_READ_SIDE_FINI) && sg_fd_is_shared(sfp)) {
 		rs_sfp = sg_fd_share_ptr(sfp);
-		if (rs_sfp && rs_sfp->rsv_srp) {
-			struct sg_request *res_srp = rs_sfp->rsv_srp;
+		if (rs_sfp && !IS_ERR_OR_NULL(rs_sfp->rsv_arr[0])) {
+			struct sg_request *res_srp = rs_sfp->rsv_arr[0];
 
 			if (atomic_read(&res_srp->rq_st) == SG_RQ_SHR_SWAP)
 				c_flgs_val_out |= SG_CTL_FLAGM_READ_SIDE_FINI;
@@ -3756,7 +4349,7 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 	if (c_flgs_wm & SG_CTL_FLAGM_READ_SIDE_FINI) {
 		bool rs_fini_wm = !!(c_flgs_val_in & SG_CTL_FLAGM_READ_SIDE_FINI);
 
-		sg_change_after_read_side_rq(sfp, rs_fini_wm);
+		res = sg_change_after_read_side_rq(sfp, rs_fini_wm);
 	}
 	/* READ_SIDE_ERR boolean, [ro] share: read-side finished with error */
 	if (c_flgs_rm & SG_CTL_FLAGM_READ_SIDE_ERR) {
@@ -3819,6 +4412,7 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 
 	if (c_flgs_val_in != c_flgs_val_out)
 		seip->ctl_flags = c_flgs_val_out;
+	return res;
 }
 
 static void
@@ -3865,6 +4459,9 @@ sg_extended_read_value(struct sg_fd *sfp, struct sg_extended_info *seip)
 			uv += (u32)atomic_read(&a_sfp->submitted);
 		seip->read_value = uv;
 		break;
+	case SG_SEIRV_MAX_RSV_REQS:
+		seip->read_value = SG_MAX_RSV_REQS;
+		break;
 	default:
 		SG_LOG(6, sfp, "%s: can't decode %d --> read_value\n",
 		       __func__, seip->read_value);
@@ -3911,8 +4508,11 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 			seip->tot_fd_thresh = hold;
 	}
 	/* check all boolean flags for either wr or rd mask set in or_mask */
-	if (or_masks & SG_SEIM_CTL_FLAGS)
-		sg_extended_bool_flags(sfp, seip);
+	if (or_masks & SG_SEIM_CTL_FLAGS) {
+		result = sg_extended_bool_flags(sfp, seip);
+		if (ret == 0 && unlikely(result))
+			ret = result;
+	}
 	/* yields minor_index (type: u32) [ro] */
 	if (or_masks & SG_SEIM_MINOR_INDEX) {
 		if (s_wr_mask & SG_SEIM_MINOR_INDEX) {
@@ -3937,7 +4537,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 			struct sg_fd *sh_sfp = sg_fd_share_ptr(sfp);
 
 			seip->share_fd = sh_sfp ? sh_sfp->parentdp->index :
-						   U32_MAX;
+						  U32_MAX;
 		}
 		mutex_unlock(&sfp->f_mutex);
 	}
@@ -3998,10 +4598,12 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 			ret = result;
 		mutex_unlock(&sfp->f_mutex);
 	}
-	if (s_rd_mask & SG_SEIM_RESERVED_SIZE)
-		seip->reserved_sz = (u32)min_t(int,
-					       sfp->rsv_srp->sgatp->buflen,
+	if (s_rd_mask & SG_SEIM_RESERVED_SIZE) {
+		struct sg_request *r_srp = sfp->rsv_arr[0];
+
+		seip->reserved_sz = (u32)min_t(int, r_srp->sgatp->buflen,
 					       sdp->max_sgat_sz);
+	}
 	/* copy to user space if int or boolean read mask non-zero */
 	if (s_rd_mask || seip->ctl_flags_rd_mask) {
 		if (copy_to_user(p, seip, SZ_SG_EXTENDED_INFO))
@@ -4096,11 +4698,20 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	unsigned long idx;
 	__maybe_unused const char *pmlp = ", pass to mid-level";
 
-	SG_LOG(6, sfp, "%s: cmd=0x%x, O_NONBLOCK=%d\n", __func__, cmd_in,
-	       !!(filp->f_flags & O_NONBLOCK));
+	SG_LOG(6, sfp, "%s: cmd=0x%x, O_NONBLOCK=%d%s\n", __func__, cmd_in,
+	       !!(filp->f_flags & O_NONBLOCK),
+	       (cmd_in == SG_GET_NUM_WAITING ? ", SG_GET_NUM_WAITING" : ""));
 	sdev = sdp->device;
 
 	switch (cmd_in) {
+	case SG_GET_NUM_WAITING:
+		/* Want as fast as possible, with a useful result */
+		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
+			sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready */
+		val = atomic_read(&sfp->waiting);
+		if (val)
+			return put_user(val, ip);
+		return put_user(atomic_read_acquire(&sfp->waiting), ip);
 	case SG_IO:
 		if (SG_IS_DETACHING(sdp))
 			return -ENODEV;
@@ -4169,18 +4780,10 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		}
 		SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
 		return put_user(val, ip);
-	case SG_GET_NUM_WAITING:
-		/* Want as fast as possible, with a useful result */
-		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
-			sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready */
-		val = atomic_read(&sfp->waiting);
-		if (val)
-			return put_user(val, ip);
-		return put_user(atomic_read_acquire(&sfp->waiting), ip);
 	case SG_GET_SG_TABLESIZE:
 		SG_LOG(3, sfp, "%s:    SG_GET_SG_TABLESIZE=%d\n", __func__,
-		       sdp->max_sgat_sz);
-		return put_user(sdp->max_sgat_sz, ip);
+		       sdp->max_sgat_elems);
+		return put_user(sdp->max_sgat_elems, ip);
 	case SG_SET_RESERVED_SIZE:
 		res = get_user(val, ip);
 		if (likely(!res)) {
@@ -4195,13 +4798,17 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		}
 		return res;
 	case SG_GET_RESERVED_SIZE:
-		mutex_lock(&sfp->f_mutex);
-		val = min_t(int, sfp->rsv_srp->sgatp->buflen,
-			    sdp->max_sgat_sz);
-		mutex_unlock(&sfp->f_mutex);
+		{
+			struct sg_request *r_srp = sfp->rsv_arr[0];
+
+			mutex_lock(&sfp->f_mutex);
+			val = min_t(int, r_srp->sgatp->buflen,
+				    sdp->max_sgat_sz);
+			mutex_unlock(&sfp->f_mutex);
+			res = put_user(val, ip);
+		}
 		SG_LOG(3, sfp, "%s:    SG_GET_RESERVED_SIZE=%d\n", __func__,
 		       val);
-		res = put_user(val, ip);
 		return res;
 	case SG_SET_COMMAND_Q:	/* set by driver whenever v3 or v4 req seen */
 		SG_LOG(3, sfp, "%s:    SG_SET_COMMAND_Q\n", __func__);
@@ -4495,7 +5102,7 @@ sg_vma_open(struct vm_area_struct *vma)
 		pr_warn("%s: sfp null\n", __func__);
 		return;
 	}
-	kref_get(&sfp->f_ref);
+	kref_get(&sfp->f_ref);	/* put in: sg_vma_close() */
 }
 
 static void
@@ -4540,8 +5147,8 @@ sg_vma_fault(struct vm_fault *vmf)
 		SG_LOG(1, sfp, "%s: device detaching\n", __func__);
 		goto out_err;
 	}
-	srp = sfp->rsv_srp;
-	if (unlikely(!srp)) {
+	srp = sfp->rsv_arr[0];
+	if (IS_ERR_OR_NULL(srp)) {
 		SG_LOG(1, sfp, "%s: srp%s\n", __func__, nbp);
 		goto out_err;
 	}
@@ -4594,7 +5201,8 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		pr_warn("sg: %s: sfp is NULL\n", __func__);
 		return -ENXIO;
 	}
-	mutex_lock(&sfp->f_mutex);
+	if (unlikely(!mutex_trylock(&sfp->f_mutex)))
+		return -EBUSY;
 	req_sz = vma->vm_end - vma->vm_start;
 	SG_LOG(3, sfp, "%s: vm_start=%pK, len=%d\n", __func__,
 	       (void *)vma->vm_start, (int)req_sz);
@@ -4603,7 +5211,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 		goto fini;
 	}
 	/* Check reserve request is inactive and has large enough buffer */
-	srp = sfp->rsv_srp;
+	srp = sfp->rsv_arr[0];
 	if (SG_RQ_ACTIVE(srp)) {
 		res = -EBUSY;
 		goto fini;
@@ -4620,7 +5228,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	}
 	if (srp->sgat_h.page_order > 0 ||
 	    req_sz > (unsigned long)srp->sgat_h.buflen) {
-		sg_remove_sgat(srp);
+		sg_remove_srp(srp);
 		set_bit(SG_FRQ_FOR_MMAP, srp->frq_bm);
 		res = sg_mk_sgat(srp, sfp, req_sz);
 		if (res) {
@@ -4661,7 +5269,7 @@ sg_uc_rq_end_io_orphaned(struct work_struct *work)
 		sg_finish_scsi_blk_rq(srp);	/* clean up orphan case */
 		sg_deact_request(sfp, srp);
 	}
-	kref_put(&sfp->f_ref, sg_remove_sfp);
+	kref_put(&sfp->f_ref, sg_remove_sfp); /* get in: sg_execute_cmd() */
 }
 
 /*
@@ -4748,7 +5356,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	}
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	__set_bit(SG_FRQ_ISSUED, srp->frq_bm);
-	sg_rq_chg_state_force_ulck(srp, rqq_state);
+	sg_rq_chg_state_force_ulck(srp, rqq_state);	/* normally --> SG_RQ_AWAIT_RCV */
 	WRITE_ONCE(srp->rqq, NULL);
 	if (test_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
 		int num = atomic_inc_return(&sfp->waiting);
@@ -4775,16 +5383,15 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 		/* clean up orphaned request that aren't being kept */
 		INIT_WORK(&srp->ew_orph.work, sg_uc_rq_end_io_orphaned);
 		schedule_work(&srp->ew_orph.work);
+		/* kref_put(f_ref) done in sg_uc_rq_end_io_orphaned() */
 		return;
 	}
-	/* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
 	if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
 		wake_up_interruptible(&sfp->cmpl_wait);
 	if (sfp->async_qp && (!test_bit(SG_FRQ_IS_V4I, srp->frq_bm) ||
 			      (srp->rq_flags & SGV4_FLAG_SIGNAL)))
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
-	kref_put(&sfp->f_ref, sg_remove_sfp);
-	return;
+	kref_put(&sfp->f_ref, sg_remove_sfp);	/* get in: sg_execute_cmd() */
 }
 
 static const struct file_operations sg_fops = {
@@ -4851,6 +5458,7 @@ sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 	clear_bit(SG_FDEV_DETACHING, sdp->fdev_bm);
 	atomic_set(&sdp->open_cnt, 0);
 	sdp->index = k;
+	/* set d_ref to 1; corresponding put in: sg_remove_device() */
 	kref_init(&sdp->d_ref);
 	error = 0;
 
@@ -4977,12 +5585,13 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 	if (unlikely(!sdp))
 		return;
 	/* set this flag as soon as possible as it could be a surprise */
-	if (test_and_set_bit(SG_FDEV_DETACHING, sdp->fdev_bm))
+	if (test_and_set_bit(SG_FDEV_DETACHING, sdp->fdev_bm)) {
+		pr_warn("%s: multiple entries: sg%u\n", __func__, sdp->index);
 		return; /* only want to do following once per device */
-
+	}
 	SCSI_LOG_TIMEOUT(3, sdev_printk(KERN_INFO, sdp->device,
-					"%s: 0x%pK\n", __func__, sdp));
-
+					"%s: sg%u 0x%pK\n", __func__,
+					sdp->index, sdp));
 	xa_for_each(&sdp->sfp_arr, idx, sfp) {
 		wake_up_interruptible_all(&sfp->cmpl_wait);
 		if (sfp->async_qp)
@@ -4995,6 +5604,7 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 	cdev_del(sdp->cdev);
 	sdp->cdev = NULL;
 
+	/* init to 1: kref_init() in sg_add_device_helper() */
 	kref_put(&sdp->d_ref, sg_device_destroy);
 }
 
@@ -5135,21 +5745,10 @@ sg_rq_map_kern(struct sg_request *srp, struct request_queue *q, struct request *
 	return res;
 }
 
-static inline void
-sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
-		struct rq_map_data *mdp)
-{
-	mdp->pages = schp->pages;
-	mdp->page_order = schp->page_order;
-	mdp->nr_entries = schp->num_sgat;
-	mdp->offset = 0;
-	mdp->null_mapped = !up_valid;
-}
-
 static int
 sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 {
-	bool reserved, no_xfer, us_xfer;
+	bool no_dxfer, us_xfer;
 	int res = 0;
 	int dxfer_len = 0;
 	int r0w = READ;
@@ -5172,7 +5771,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		long_cmdp = kzalloc(cwrp->cmd_len, GFP_KERNEL);
 		if (unlikely(!long_cmdp)) {
 			res = -ENOMEM;
-			goto err_out;
+			goto err_pre_blk_get;
 		}
 		SG_LOG(5, sfp, "%s: long_cmdp=0x%pK ++\n", __func__, long_cmdp);
 	}
@@ -5199,8 +5798,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		iov_count = sh3p->iovec_count;
 		r0w = dxfer_dir == SG_DXFER_TO_DEV ? WRITE : READ;
 	}
-	SG_LOG(4, sfp, "%s: dxfer_len=%d, data-%s\n", __func__, dxfer_len,
-	       (r0w ? "OUT" : "IN"));
+	SG_LOG(4, sfp, "%s: dxfer_len=%d%s\n", __func__, dxfer_len,
+	       (dxfer_len ? (r0w ? ", data-OUT" : ", data-IN") : ""));
 	q = sdp->device->request_queue;
 
 	/*
@@ -5213,9 +5812,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 			      (test_bit(SG_FFD_MORE_ASYNC, sfp->ffd_bm) ?
 						BLK_MQ_REQ_NOWAIT : 0));
 	if (IS_ERR(rqq)) {
-		kfree(long_cmdp);
 		res = PTR_ERR(rqq);
-		goto err_out;
+		goto err_pre_blk_get;
 	}
 	/* current sg_request protected by SG_RQ_BUSY state */
 	scsi_rp = scsi_req(rqq);
@@ -5224,8 +5822,11 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		srp->tag = rqq->tag;
 	if (rq_flags & SGV4_FLAG_HIPRI)
 		set_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
-	if (cwrp->cmd_len > BLK_MAX_CDB)
+	if (cwrp->cmd_len > BLK_MAX_CDB) {
 		scsi_rp->cmd = long_cmdp;	/* transfer ownership */
+		/* this heap freed in scsi_req_free_cmd() */
+		long_cmdp = NULL;
+	}
 	if (cwrp->u_cmdp)
 		res = sg_fetch_cmnd(sfp, cwrp->u_cmdp, cwrp->cmd_len,
 				    scsi_rp->cmd);
@@ -5234,18 +5835,17 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	else
 		res = -EPROTO;
 	if (unlikely(res))
-		goto err_out;
+		goto fini;
 	scsi_rp->cmd_len = cwrp->cmd_len;
 	srp->cmd_opcode = scsi_rp->cmd[0];
-	no_xfer = dxfer_len <= 0 || dxfer_dir == SG_DXFER_NONE;
+	no_dxfer = dxfer_len <= 0 || dxfer_dir == SG_DXFER_NONE;
 	us_xfer = !(rq_flags & (SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO));
-	__assign_bit(SG_FRQ_US_XFER, srp->frq_bm, !no_xfer && us_xfer);
-	reserved = (sfp->rsv_srp == srp);
+	__assign_bit(SG_FRQ_US_XFER, srp->frq_bm, !no_dxfer && us_xfer);
 	rqq->end_io_data = srp;
 	scsi_rp->retries = SG_DEFAULT_RETRIES;
 	req_schp = srp->sgatp;
 
-	if (no_xfer) {
+	if (no_dxfer) {
 		SG_LOG(4, sfp, "%s: no data xfer [0x%pK]\n", __func__, srp);
 		goto fini;	/* path of reqs with no din nor dout */
 	} else if (unlikely(rq_flags & SG_FLAG_DIRECT_IO) && iov_count == 0 &&
@@ -5262,9 +5862,13 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	if (likely(md)) {	/* normal, "indirect" IO */
 		if (unlikely(rq_flags & SG_FLAG_MMAP_IO)) {
 			/* mmap IO must use and fit in reserve request */
-			if (unlikely(!reserved ||
+			bool reserve0;
+			struct sg_request *r_srp = sfp->rsv_arr[0];
+
+			reserve0 = (r_srp == srp);
+			if (unlikely(!reserve0 ||
 				     dxfer_len > req_schp->buflen))
-				res = reserved ? -ENOMEM : -EBUSY;
+				res = reserve0 ? -ENOMEM : -EBUSY;
 		} else if (req_schp->buflen == 0) {
 			int up_sz = max_t(int, dxfer_len, sfp->sgat_elem_sz);
 
@@ -5272,8 +5876,11 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		}
 		if (unlikely(res))
 			goto fini;
-
-		sg_set_map_data(req_schp, !!up, md);
+		md->pages = req_schp->pages;
+		md->page_order = req_schp->page_order;
+		md->nr_entries = req_schp->num_sgat;
+		md->offset = 0;
+		md->null_mapped = !up;
 		md->from_user = (dxfer_dir == SG_DXFER_TO_FROM_DEV);
 	}
 
@@ -5282,7 +5889,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		struct iov_iter i;
 
 		res = import_iovec(r0w, up, iov_count, 0, &iov, &i);
-		if (res < 0)
+		if (unlikely(res < 0))
 			goto fini;
 
 		iov_iter_truncate(&i, dxfer_len);
@@ -5317,9 +5924,10 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	} else {
 		srp->bio = rqq->bio;
 	}
-err_out:
+err_pre_blk_get:
 	SG_LOG((res ? 1 : 4), sfp, "%s: %s %s res=%d [0x%pK]\n", __func__,
 	       sg_shr_str(srp->sh_var, false), cp, res, srp);
+	kfree(long_cmdp);
 	return res;
 }
 
@@ -5336,13 +5944,14 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 	int ret;
 	struct sg_fd *sfp = srp->parentfp;
 	struct request *rqq = READ_ONCE(srp->rqq);
+	__maybe_unused char b[32];
 
 	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp,
-	       (srp->parentfp->rsv_srp == srp) ? " rsv" : "");
+	       sg_get_rsv_str_lck(srp, " ", "", sizeof(b), b));
 	if (test_and_clear_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
 		if (atomic_dec_and_test(&sfp->submitted))
 			clear_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
-		atomic_dec(&sfp->waiting);
+		atomic_dec_return_release(&sfp->waiting);
 	}
 
 	/* Expect blk_put_request(rqq) already called in sg_rq_end_io() */
@@ -5443,7 +6052,7 @@ sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
 }
 
 static void
-sg_remove_sgat_helper(struct sg_fd *sfp, struct sg_scatter_hold *schp)
+sg_remove_sgat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 {
 	int k;
 	void *p;
@@ -5464,15 +6073,19 @@ sg_remove_sgat_helper(struct sg_fd *sfp, struct sg_scatter_hold *schp)
 
 /* Remove the data (possibly a sgat list) held by srp, not srp itself */
 static void
-sg_remove_sgat(struct sg_request *srp)
+sg_remove_srp(struct sg_request *srp)
 {
-	struct sg_scatter_hold *schp = &srp->sgat_h; /* care: remove own data */
-	struct sg_fd *sfp = srp->parentfp;
+	struct sg_scatter_hold *schp;
+	struct sg_fd *sfp;
+	__maybe_unused char b[48];
 
+	if (!srp)
+		return;
+	schp = &srp->sgat_h; /* care: remove own data */
+	sfp = srp->parentfp;
 	SG_LOG(4, sfp, "%s: num_sgat=%d%s\n", __func__, schp->num_sgat,
-	       ((srp->parentfp ? (sfp->rsv_srp == srp) : false) ?
-							" [rsv]" : ""));
-	sg_remove_sgat_helper(sfp, schp);
+	       sg_get_rsv_str_lck(srp, " [", "]", sizeof(b), b));
+	sg_remove_sgat(sfp, schp);
 
 	if (sfp->tot_fd_thresh > 0) {
 		/* this is a subtraction, error if it goes negative */
@@ -5527,7 +6140,7 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 }
 
 /*
- * If there are multiple requests outstanding, the speed of this function is
+ * If there are many requests outstanding, the speed of this function is
  * important. 'id' is pack_id when is_tag=false, otherwise it is a tag. Both
  * SG_PACK_ID_WILDCARD and SG_TAG_WILDCARD are -1 and that case is typically
  * the fast path. This function is only used in the non-blocking cases.
@@ -5543,7 +6156,6 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 	bool second = false;
 	enum sg_rq_state sr_st;
 	int res;
-	int num_waiting = atomic_read(&sfp->waiting);
 	int l_await_idx = READ_ONCE(sfp->low_await_idx);
 	unsigned long idx, s_idx;
 	unsigned long end_idx = ULONG_MAX;
@@ -5552,11 +6164,8 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 
 	if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
 		sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready to push up */
-	if (num_waiting < 1) {
-		num_waiting = atomic_read_acquire(&sfp->waiting);
-		if (num_waiting < 1)
-			return NULL;
-	}
+	if (sg_num_waiting_maybe_acquire(sfp) < 1)
+		return NULL;
 
 	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
 	idx = s_idx;
@@ -5670,7 +6279,7 @@ static bool
 sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
 {
 	bool second = false;
-	int num_waiting, res;
+	int res;
 	int l_await_idx = READ_ONCE(sfp->low_await_idx);
 	unsigned long idx, s_idx, end_idx;
 	struct sg_request *srp;
@@ -5684,12 +6293,8 @@ sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
 		*srpp = ERR_PTR(-ENODATA);
 		return true;
 	}
-	num_waiting = atomic_read(&sfp->waiting);
-	if (num_waiting < 1) {
-		num_waiting = atomic_read_acquire(&sfp->waiting);
-		if (num_waiting < 1)
-			goto fini;
-	}
+	if (sg_num_waiting_maybe_acquire(sfp) < 1)
+		goto fini;
 
 	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
 	idx = s_idx;
@@ -5727,9 +6332,10 @@ sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
  * may take time but has improved chance of success, otherwise use GFP_ATOMIC.
  * Note that basic initialization is done but srp is not added to either sfp
  * list. On error returns twisted negated errno value (not NULL).
+ * N.B. Initializes new srp state to SG_RQ_BUSY.
  */
 static struct sg_request *
-sg_mk_srp(struct sg_fd *sfp, bool first)
+sg_mk_only_srp(struct sg_fd *sfp, bool first)
 {
 	struct sg_request *srp;
 	gfp_t gfp = __GFP_NOWARN;
@@ -5754,7 +6360,7 @@ static struct sg_request *
 sg_mk_srp_sgat(struct sg_fd *sfp, bool first, int db_len)
 {
 	int res;
-	struct sg_request *n_srp = sg_mk_srp(sfp, first);
+	struct sg_request *n_srp = sg_mk_only_srp(sfp, first);
 
 	if (IS_ERR(n_srp))
 		return n_srp;
@@ -5779,14 +6385,22 @@ static struct sg_request *
 sg_build_reserve(struct sg_fd *sfp, int buflen)
 {
 	bool go_out = false;
-	int res;
+	int res, idx;
 	struct sg_request *srp;
+	struct sg_request **rapp;
 
 	SG_LOG(3, sfp, "%s: buflen=%d\n", __func__, buflen);
-	srp = sg_mk_srp(sfp, xa_empty(&sfp->srp_arr));
-	if (IS_ERR(srp))
+	idx = sg_get_idx_new_lck(sfp);
+	if (idx < 0) {
+		SG_LOG(1, sfp, "%s: sg_get_idx_new_lck() failed\n", __func__);
+		return ERR_PTR(-EFBIG);
+	}
+	rapp = sfp->rsv_arr + idx;
+	srp = sg_mk_only_srp(sfp, xa_empty(&sfp->srp_arr));
+	if (IS_ERR(srp)) {
+		*rapp = NULL;
 		return srp;
-	sfp->rsv_srp = srp;
+	}
 	do {
 		if (buflen < (int)PAGE_SIZE) {
 			buflen = PAGE_SIZE;
@@ -5794,14 +6408,18 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
 		}
 		res = sg_mk_sgat(srp, sfp, buflen);
 		if (likely(res == 0)) {
-			SG_LOG(4, sfp, "%s: final buflen=%d, srp=0x%pK ++\n",
-			       __func__, buflen, srp);
+			*rapp = srp;
+			SG_LOG(4, sfp,
+			       "%s: rsv%d: final buflen=%d, srp=0x%pK ++\n",
+			       __func__, idx, buflen, srp);
 			return srp;
 		}
-		if (go_out)
+		if (go_out) {
+			*rapp = NULL;
 			return ERR_PTR(res);
+		}
 		/* failed so remove, halve buflen, try again */
-		sg_remove_sgat(srp);
+		sg_remove_srp(srp);
 		buflen >>= 1;   /* divide by 2 */
 	} while (true);
 }
@@ -5820,19 +6438,21 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 	bool act_empty = false;
 	bool allow_rsv = true;		/* see note above */
 	bool mk_new_srp = true;
+	bool new_rsv_srp = false;
 	bool ws_rq = false;
 	bool try_harder = false;
 	bool second = false;
 	bool has_inactive = false;
+	bool is_rsv;
+	int ra_idx = 0;
 	int res, l_used_idx;
 	u32 sum_dlen;
 	unsigned long idx, s_idx, end_idx, iflags;
 	enum sg_rq_state sr_st;
-	enum sg_rq_state rs_sr_st = SG_RQ_INACTIVE;
+	enum sg_rq_state rs_st = SG_RQ_INACTIVE;
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_request *r_srp = NULL; /* returned value won't be NULL */
 	struct sg_request *low_srp = NULL;
-	__maybe_unused struct sg_request *rsv_srp;
 	struct sg_request *rs_rsv_srp = NULL;
 	struct sg_fd *rs_sfp = NULL;
 	struct xarray *xafp = &fp->srp_arr;
@@ -5840,25 +6460,33 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 	__maybe_unused char b[64];
 
 	b[0] = '\0';
-	rsv_srp = fp->rsv_srp;
-
 	switch (sh_var) {
 	case SG_SHR_NONE:
 	case SG_SHR_WS_NOT_SRQ:
 		break;
 	case SG_SHR_RS_RQ:
-		sr_st = atomic_read(&rsv_srp->rq_st);
+		if (test_bit(SG_FFD_RESHARE, fp->ffd_bm))
+			ra_idx = 0;
+		else
+			ra_idx = sg_get_idx_available(fp);
+		if (ra_idx < 0) {
+			new_rsv_srp = true;
+			cp = "m_rq";
+			goto good_fini;
+		}
+		r_srp = fp->rsv_arr[ra_idx];
+		sr_st = atomic_read(&r_srp->rq_st);
 		if (sr_st == SG_RQ_INACTIVE) {
-			res = sg_rq_chg_state(rsv_srp, sr_st, SG_RQ_BUSY);
+			res = sg_rq_chg_state(r_srp, sr_st, SG_RQ_BUSY);
 			if (likely(res == 0)) {
-				r_srp = rsv_srp;
+				r_srp->sh_srp = NULL;
 				mk_new_srp = false;
 				cp = "rs_rq";
 				goto good_fini;
 			}
 		}
 		/* Did not find the reserve request available */
-		r_srp = ERR_PTR(-EBUSY);
+		r_srp = ERR_PTR(-EFBIG);
 		break;
 	case SG_SHR_RS_NOT_SRQ:
 		allow_rsv = false;
@@ -5875,26 +6503,36 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		 * EADDRINUSE errno. The winner advances read-side's rq_state:
 		 *     SG_RQ_SHR_SWAP --> SG_RQ_SHR_IN_WS
 		 */
-		rs_rsv_srp = rs_sfp->rsv_srp;
-		rs_sr_st = atomic_read(&rs_rsv_srp->rq_st);
-		switch (rs_sr_st) {
+		if (cwrp->rsv_idx >= 0)
+			rs_rsv_srp = rs_sfp->rsv_arr[cwrp->rsv_idx];
+		else
+			rs_rsv_srp = sg_get_probable_read_side(rs_sfp);
+		if (!rs_rsv_srp) {
+			r_srp = ERR_PTR(-ENOSTR);
+			break;
+		}
+		rs_st = atomic_read(&rs_rsv_srp->rq_st);
+		switch (rs_st) {
 		case SG_RQ_AWAIT_RCV:
 			if (unlikely(rs_rsv_srp->rq_result & SG_ML_RESULT_MSK)) {
 				/* read-side done but error occurred */
 				r_srp = ERR_PTR(-ENOSTR);
 				break;
 			}
-			fallthrough;
+			ws_rq = true;
+			break;
 		case SG_RQ_SHR_SWAP:
 			ws_rq = true;
-			if (unlikely(rs_sr_st == SG_RQ_AWAIT_RCV))
+			if (unlikely(rs_st == SG_RQ_AWAIT_RCV))
 				break;
-			res = sg_rq_chg_state(rs_rsv_srp, rs_sr_st, SG_RQ_SHR_IN_WS);
+			res = sg_rq_chg_state(rs_rsv_srp, rs_st, SG_RQ_SHR_IN_WS);
 			if (unlikely(res))
 				r_srp = ERR_PTR(-EADDRINUSE);
 			break;
 		case SG_RQ_INFLIGHT:
 		case SG_RQ_BUSY:
+			SG_LOG(6, fp, "%s: write-side finds read-side: %s\n", __func__,
+			       sg_rq_st_str(rs_st, true));
 			r_srp = ERR_PTR(-EBUSY);
 			break;
 		case SG_RQ_INACTIVE:
@@ -5911,15 +6549,24 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		if (PTR_ERR(r_srp) == -EBUSY)
 			goto err_out;
 #if IS_ENABLED(SG_LOG_ACTIVE)
-		if (sh_var == SG_SHR_RS_RQ)
+		if (sh_var == SG_SHR_RS_RQ) {
 			snprintf(b, sizeof(b), "SG_SHR_RS_RQ --> sr_st=%s",
 				 sg_rq_st_str(sr_st, false));
-		else if (sh_var == SG_SHR_WS_RQ && rs_sfp)
-			snprintf(b, sizeof(b), "SG_SHR_WS_RQ-->rs_sr_st=%s",
-				 sg_rq_st_str(rs_sr_st, false));
-		else
+		} else if (sh_var == SG_SHR_WS_RQ && rs_sfp) {
+			char c[32];
+			const char *ccp;
+
+			if (rs_rsv_srp)
+				ccp = sg_get_rsv_str(rs_rsv_srp, "[", "]",
+						     sizeof(c), c);
+			else
+				ccp = "? ";
+			snprintf(b, sizeof(b), "SHR_WS_RQ --> rs_sr%s_st=%s",
+				 ccp, sg_rq_st_str(rs_st, false));
+		} else {
 			snprintf(b, sizeof(b), "sh_var=%s",
 				 sg_shr_str(sh_var, false));
+		}
 #endif
 		goto err_out;
 	}
@@ -5947,7 +6594,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		s_idx = (l_used_idx < 0) ? 0 : l_used_idx;
 		if (l_used_idx >= 0 && xa_get_mark(xafp, s_idx, SG_XA_RQ_INACTIVE)) {
 			r_srp = xa_load(xafp, s_idx);
-			if (r_srp && (allow_rsv || rsv_srp != r_srp)) {
+			if (r_srp && (allow_rsv || !test_bit(SG_FRQ_RESERVED, r_srp->frq_bm))) {
 				if (r_srp->sgat_h.buflen <= SG_DEF_SECTOR_SZ) {
 					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE,
 							    SG_RQ_BUSY) == 0) {
@@ -5960,7 +6607,8 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		}
 		xa_for_each_marked(xafp, idx, r_srp, SG_XA_RQ_INACTIVE) {
 			has_inactive = true;
-			if (!allow_rsv && rsv_srp == r_srp)
+			if (!allow_rsv &&
+			    test_bit(SG_FRQ_RESERVED, r_srp->frq_bm))
 				continue;
 			if (!low_srp && dxfr_len < SG_DEF_SECTOR_SZ) {
 				low_srp = r_srp;
@@ -5985,7 +6633,8 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		for (r_srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE);
 		     r_srp;
 		     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
-			if (!allow_rsv && rsv_srp == r_srp)
+			if (!allow_rsv &&
+			    test_bit(SG_FRQ_RESERVED, r_srp->frq_bm))
 				continue;
 			if (r_srp->sgat_h.buflen >= dxfr_len) {
 				if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
@@ -6025,7 +6674,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 			r_srp = ERR_PTR(-EDOM);
 			SG_LOG(6, fp, "%s: trying 2nd req but cmd_q=false\n",
 			       __func__);
-			goto fini;
+			goto err_out;
 		} else if (fp->tot_fd_thresh > 0) {
 			sum_dlen = atomic_read(&fp->sum_fd_dlens) + dxfr_len;
 			if (unlikely(sum_dlen > (u32)fp->tot_fd_thresh)) {
@@ -6034,6 +6683,20 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 				       __func__, sum_dlen, "tot_fd_thresh");
 			}
 		}
+		if (!IS_ERR(r_srp) && new_rsv_srp) {
+			ra_idx = sg_get_idx_new(fp);
+			if (ra_idx < 0) {
+				ra_idx = sg_get_idx_available(fp);
+				if (ra_idx < 0) {
+					SG_LOG(1, fp,
+					       "%s: no read-side reqs available\n",
+					       __func__);
+					r_srp = ERR_PTR(-EFBIG);
+				}
+			}
+		}
+		if (IS_ERR(r_srp))	/* NULL is _not_ an ERR here */
+			goto err_out;
 		r_srp = sg_mk_srp_sgat(fp, act_empty, dxfr_len);
 		if (IS_ERR(r_srp)) {
 			if (!try_harder && dxfr_len < SG_DEF_SECTOR_SZ &&
@@ -6041,46 +6704,70 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 				try_harder = true;
 				goto start_again;
 			}
-			goto fini;
+			goto err_out;
+		}
+		SG_LOG(4, fp, "%s: %smk_new_srp=0x%pK ++\n", __func__,
+		       (new_rsv_srp ? "rsv " : ""), r_srp);
+		if (new_rsv_srp) {
+			fp->rsv_arr[ra_idx] = r_srp;
+			set_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
+			r_srp->sh_srp = NULL;
 		}
 		xa_lock_irqsave(xafp, iflags);
-		res = __xa_alloc(xafp, &n_idx, r_srp, xa_limit_32b, GFP_KERNEL);
+		res = __xa_alloc(xafp, &n_idx, r_srp, xa_limit_32b, GFP_ATOMIC);
 		xa_unlock_irqrestore(xafp, iflags);
 		if (unlikely(res < 0)) {
-			sg_remove_sgat(r_srp);
+			xa_unlock_irqrestore(xafp, iflags);
+			sg_remove_srp(r_srp);
 			kfree(r_srp);
 			r_srp = ERR_PTR(-EPROTOTYPE);
 			SG_LOG(1, fp, "%s: xa_alloc() failed, errno=%d\n",
 			       __func__,  -res);
-			goto fini;
+			goto err_out;
 		}
-		idx = n_idx;
-		r_srp->rq_idx = idx;
+		r_srp->rq_idx = n_idx;
 		r_srp->parentfp = fp;
-		sg_rq_chg_state_force(r_srp, SG_RQ_BUSY);
-		SG_LOG(4, fp, "%s: mk_new_srp=0x%pK ++\n", __func__, r_srp);
+		xa_unlock_irqrestore(xafp, iflags);
 	}
-	/* following copes with unlikely case where frq_bm > one ulong */
-	WRITE_ONCE(r_srp->frq_bm[0], cwrp->frq_bm[0]);	/* assumes <= 32 req flags */
+	/* keep SG_FRQ_RESERVED setting from prior/new r_srp; clear rest */
+	is_rsv = test_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
+	WRITE_ONCE(r_srp->frq_bm[0], 0);
+	if (is_rsv)
+		set_bit(SG_FRQ_RESERVED, r_srp->frq_bm);
+	/* r_srp inherits these 3 flags from cwrp->frq_bm */
+	if (test_bit(SG_FRQ_IS_V4I, cwrp->frq_bm))
+		set_bit(SG_FRQ_IS_V4I, r_srp->frq_bm);
+	if (test_bit(SG_FRQ_SYNC_INVOC, cwrp->frq_bm))
+		set_bit(SG_FRQ_SYNC_INVOC, r_srp->frq_bm);
 	r_srp->sgatp->dlen = dxfr_len;/* must be <= r_srp->sgat_h.buflen */
 	r_srp->sh_var = sh_var;
 	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
-fini:
 	/* If setup stalls (e.g. blk_get_request()) debug shows 'elap=1 ns' */
 	if (test_bit(SG_FFD_TIME_IN_NS, fp->ffd_bm))
 		r_srp->start_ns = S64_MAX;
 	if (ws_rq && rs_rsv_srp) {
-		rs_sfp->ws_srp = r_srp;
 		/* write-side "shares" the read-side reserve request's data buffer */
 		r_srp->sgatp = &rs_rsv_srp->sgat_h;
-	} else if (sh_var == SG_SHR_RS_RQ && test_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm))
+		rs_rsv_srp->sh_srp = r_srp;
+		r_srp->sh_srp = rs_rsv_srp;
+	} else if (sh_var == SG_SHR_RS_RQ && test_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm)) {
 		clear_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm);
+	}
 err_out:
-	if (IS_ERR(r_srp) && PTR_ERR(r_srp) != -EBUSY && b[0])
-		SG_LOG(1, fp, "%s: bad %s\n", __func__, b);
-	if (!IS_ERR(r_srp))
+#if IS_ENABLED(SG_LOG_ACTIVE)
+	if (IS_ERR(r_srp)) {
+		int err = -PTR_ERR(r_srp);
+
+		if (err == EBUSY)
+			SG_LOG(4, fp, "%s: EBUSY (as ptr err)\n", __func__);
+		else
+			SG_LOG(1, fp, "%s: %s err=%d\n", __func__, b, err);
+	} else {
 		SG_LOG(4, fp, "%s: %s %sr_srp=0x%pK\n", __func__, cp,
-		       ((r_srp == fp->rsv_srp) ? "[rsv] " : ""), r_srp);
+		       sg_get_rsv_str_lck(r_srp, "[", "] ", sizeof(b), b),
+		       r_srp);
+	}
+#endif
 	return r_srp;
 }
 
@@ -6094,25 +6781,31 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 static void
 sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 {
+	bool is_rsv;
 	enum sg_rq_state sr_st;
 	u8 *sbp;
 
 	if (WARN_ON(!sfp || !srp))
 		return;
+	SG_LOG(3, sfp, "%s: srp=%pK\n", __func__, srp);
 	sbp = srp->sense_bp;
 	srp->sense_bp = NULL;
 	sr_st = atomic_read(&srp->rq_st);
-	if (sr_st != SG_RQ_SHR_SWAP) { /* mark _BUSY then _INACTIVE at end */
+	if (sr_st != SG_RQ_SHR_SWAP) {
 		/*
 		 * Can be called from many contexts and it is hard to know
 		 * whether xa locks held. So assume not.
 		 */
 		sg_rq_chg_state_force(srp, SG_RQ_INACTIVE);
 		atomic_inc(&sfp->inactives);
+		is_rsv = test_bit(SG_FRQ_RESERVED, srp->frq_bm);
 		WRITE_ONCE(srp->frq_bm[0], 0);
+		if (is_rsv)
+			__set_bit(SG_FRQ_RESERVED, srp->frq_bm);
 		srp->tag = SG_TAG_WILDCARD;
 		srp->in_resid = 0;
 		srp->rq_info = 0;
+		srp->sense_len = 0;
 	}
 	/* maybe orphaned req, thus never read */
 	if (sbp)
@@ -6130,16 +6823,15 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 	unsigned long iflags;
 	struct sg_fd *sfp;
 	struct sg_request *srp = NULL;
-	struct xarray *xadp = &sdp->sfp_arr;
 	struct xarray *xafp;
+	struct xarray *xadp;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (unlikely(!sfp))
 		return ERR_PTR(-ENOMEM);
 	init_waitqueue_head(&sfp->cmpl_wait);
 	xa_init_flags(&sfp->srp_arr, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
-	xafp = &sfp->srp_arr;
-	kref_init(&sfp->f_ref);
+	kref_init(&sfp->f_ref);		/* init to 1; put: sg_release() */
 	mutex_init(&sfp->f_mutex);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
@@ -6152,6 +6844,9 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 	__assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm, SG_DEFAULT_Q_AT);
 	sfp->tot_fd_thresh = SG_TOT_FD_THRESHOLD;
 	atomic_set(&sfp->sum_fd_dlens, 0);
+	atomic_set(&sfp->submitted, 0);
+	atomic_set(&sfp->waiting, 0);
+	atomic_set(&sfp->inactives, 0);
 	/*
 	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may
 	 * be given as driver/module parameter (e.g. 'scatter_elem_sz=8192').
@@ -6161,12 +6856,9 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 	 */
 	sfp->sgat_elem_sz = scatter_elem_sz;
 	sfp->parentdp = sdp;
-	atomic_set(&sfp->submitted, 0);
-	atomic_set(&sfp->waiting, 0);
-	atomic_set(&sfp->inactives, 0);
 
 	if (SG_IS_DETACHING(sdp)) {
-		SG_LOG(1, sfp, "%s: detaching\n", __func__);
+		SG_LOG(1, sfp, "%s: sg%u detaching\n", __func__, sdp->index);
 		kfree(sfp);
 		return ERR_PTR(-ENODEV);
 	}
@@ -6175,6 +6867,7 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 
 	rbuf_len = min_t(int, sg_big_buff, sdp->max_sgat_sz);
 	if (rbuf_len > 0) {
+		xafp = &sfp->srp_arr;
 		srp = sg_build_reserve(sfp, rbuf_len);
 		if (IS_ERR(srp)) {
 			err = PTR_ERR(srp);
@@ -6191,41 +6884,44 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 		}
 		xa_lock_irqsave(xafp, iflags);
 		res = __xa_alloc(xafp, &idx, srp, xa_limit_32b, GFP_ATOMIC);
-		if (!res) {
-			srp->rq_idx = idx;
-			srp->parentfp = sfp;
-			sg_rq_chg_state_force_ulck(srp, SG_RQ_INACTIVE);
-			atomic_inc(&sfp->inactives);
-		}
-		xa_unlock_irqrestore(xafp, iflags);
 		if (res < 0) {
 			SG_LOG(1, sfp, "%s: xa_alloc(srp) bad, errno=%d\n",
 			       __func__,  -res);
-			sg_remove_sgat(srp);
+			xa_unlock_irqrestore(xafp, iflags);
+			sg_remove_srp(srp);
 			kfree(srp);
 			kfree(sfp);
 			return ERR_PTR(-EPROTOTYPE);
 		}
+		srp->rq_idx = idx;
+		srp->parentfp = sfp;
+		sg_rq_chg_state_force_ulck(srp, SG_RQ_INACTIVE);
+		atomic_inc(&sfp->inactives);
+		__set_bit(SG_FRQ_RESERVED, srp->frq_bm);
+		xa_unlock_irqrestore(xafp, iflags);
 	}
 	if (!reduced) {
 		SG_LOG(4, sfp, "%s: built reserve buflen=%d\n", __func__,
 		       rbuf_len);
 	}
+	xadp = &sdp->sfp_arr;
 	xa_lock_irqsave(xadp, iflags);
-	res = __xa_alloc(xadp, &idx, sfp, xa_limit_32b, GFP_KERNEL);
-	xa_unlock_irqrestore(xadp, iflags);
+	res = __xa_alloc(xadp, &idx, sfp, xa_limit_32b, GFP_ATOMIC);
 	if (unlikely(res < 0)) {
+		xa_unlock_irqrestore(xadp, iflags);
 		pr_warn("%s: xa_alloc(sdp) bad, o_count=%d, errno=%d\n",
 			__func__, atomic_read(&sdp->open_cnt), -res);
 		if (srp) {
-			sg_remove_sgat(srp);
+			sg_remove_srp(srp);
 			kfree(srp);
 		}
 		kfree(sfp);
 		return ERR_PTR(res);
 	}
 	sfp->idx = idx;
-	kref_get(&sdp->d_ref);
+	__xa_set_mark(xadp, idx, SG_XA_FD_UNSHARED);
+	xa_unlock_irqrestore(xadp, iflags);
+	kref_get(&sdp->d_ref);	/* put in: sg_uc_remove_sfp() */
 	__module_get(THIS_MODULE);
 	SG_LOG(3, sfp, "%s: success, sfp=0x%pK ++\n", __func__, sfp);
 	return sfp;
@@ -6259,14 +6955,13 @@ sg_uc_remove_sfp(struct work_struct *work)
 		return;
 	}
 	sdp = sfp->parentdp;
-	xadp = &sdp->sfp_arr;
 
 	/* Cleanup any responses which were never read(). */
 	xa_for_each(xafp, idx, srp) {
 		if (!xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE))
 			sg_finish_scsi_blk_rq(srp);
 		if (srp->sgatp->buflen > 0)
-			sg_remove_sgat(srp);
+			sg_remove_srp(srp);
 		if (unlikely(srp->sense_bp)) {
 			mempool_free(srp->sense_bp, sg_sense_pool);
 			srp->sense_bp = NULL;
@@ -6285,6 +6980,7 @@ sg_uc_remove_sfp(struct work_struct *work)
 		SG_LOG(1, sfp, "%s: expected submitted=0 got %d\n",
 		       __func__, subm);
 	xa_destroy(xafp);
+	xadp = &sdp->sfp_arr;
 	xa_lock_irqsave(xadp, iflags);
 	e_sfp = __xa_erase(xadp, sfp->idx);
 	xa_unlock_irqrestore(xadp, iflags);
@@ -6297,7 +6993,7 @@ sg_uc_remove_sfp(struct work_struct *work)
 	kfree(sfp);
 
 	scsi_device_put(sdp->device);
-	kref_put(&sdp->d_ref, sg_device_destroy);
+	kref_put(&sdp->d_ref, sg_device_destroy);	/* get: sg_add_sfp() */
 	module_put(THIS_MODULE);
 }
 
@@ -6337,7 +7033,7 @@ sg_get_dev(int min_dev)
 		 */
 		sdp = ERR_PTR(-ENODEV);
 	} else
-		kref_get(&sdp->d_ref);
+		kref_get(&sdp->d_ref);	/* put: sg_open() */
 	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return sdp;
 }
@@ -6607,23 +7303,26 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, char *obp,
 	enum sg_rq_state rq_st;
 	const char *cp;
 	const char *tp = t_in_ns ? "ns" : "ms";
+	char b[32];
 
 	if (unlikely(len < 1))
 		return 0;
 	v4 = test_bit(SG_FRQ_IS_V4I, srp->frq_bm);
 	is_v3v4 = v4 ? true : (srp->s_hdr3.interface_id != '\0');
-	if (srp->parentfp->rsv_srp == srp)
+	sg_get_rsv_str(srp, "     ", "", sizeof(b), b);
+	if (strlen(b) > 5)
 		cp = (is_v3v4 && (srp->rq_flags & SG_FLAG_MMAP_IO)) ?
-				"     mmap>> " : "     rsv>> ";
+					" mmap" : "";
 	else
-		cp = (srp->rq_info & SG_INFO_DIRECT_IO_MASK) ?
-				"     dio>> " : "     ";
+		cp = (srp->rq_info & SG_INFO_DIRECT_IO_MASK) ? " dio" : "";
 	rq_st = atomic_read(&srp->rq_st);
 	dur = sg_get_dur(srp, &rq_st, t_in_ns, &is_dur);
-	n += scnprintf(obp + n, len - n, "%s%s: dlen=%d/%d id=%d", cp,
-		       sg_rq_st_str(rq_st, false), srp->sgatp->dlen,
+	n += scnprintf(obp + n, len - n, "%s%s>> %s:%d dlen=%d/%d id=%d", b,
+		       cp, sg_rq_st_str(rq_st, false), srp->rq_idx, srp->sgatp->dlen,
 		       srp->sgatp->buflen, (int)srp->pack_id);
-	if (is_dur)	/* cmd/req has completed, waiting for ... */
+	if (test_bit(SG_FFD_NO_DURATION, srp->parentfp->ffd_bm))
+		;
+	else if (is_dur)	/* cmd/req has completed, waiting for ... */
 		n += scnprintf(obp + n, len - n, " dur=%u%s", dur, tp);
 	else if (dur < U32_MAX) { /* in-flight or busy (so ongoing) */
 		if ((srp->rq_flags & SGV4_FLAG_YIELD_TAG) &&
@@ -6636,9 +7335,10 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, char *obp,
 	if (srp->sh_var != SG_SHR_NONE)
 		n += scnprintf(obp + n, len - n, " shr=%s",
 			       sg_shr_str(srp->sh_var, false));
+	if (srp->sgatp->num_sgat > 1)
+		n += scnprintf(obp + n, len - n, " sgat=%d", srp->sgatp->num_sgat);
 	cp = (srp->rq_flags & SGV4_FLAG_HIPRI) ? "hipri " : "";
-	n += scnprintf(obp + n, len - n, " sgat=%d %sop=0x%02x\n",
-		       srp->sgatp->num_sgat, cp, srp->cmd_opcode);
+	n += scnprintf(obp + n, len - n, " %sop=0x%02x\n", cp, srp->cmd_opcode);
 	return n;
 }
 
@@ -6653,7 +7353,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 	int to, k;
 	unsigned long iflags;
 	const char *cp;
-	struct sg_request *srp;
+	struct sg_request *srp = fp->rsv_arr[0];
 	struct sg_device *sdp = fp->parentdp;
 
 	if (sg_fd_is_shared(fp))
@@ -6671,14 +7371,19 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		n += scnprintf(obp + n, len - n, "timeout=%dms rs", to);
 	else
 		n += scnprintf(obp + n, len - n, "timeout=%ds rs", to / 1000);
-	n += scnprintf(obp + n, len - n, "v_buflen=%d%s idx=%lu\n   cmd_q=%d ",
-		       fp->rsv_srp->sgatp->buflen, cp, idx,
-		       (int)!test_bit(SG_FFD_NO_CMD_Q, fp->ffd_bm));
-	n += scnprintf(obp + n, len - n,
-		       "f_packid=%d k_orphan=%d ffd_bm=0x%lx\n",
-		       (int)test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm),
-		       (int)test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm),
-		       fp->ffd_bm[0]);
+	n += scnprintf(obp + n, len - n, "v_buflen=%d%s fd_idx=%lu\n  ",
+		       (srp ? srp->sgatp->buflen : -1), cp, idx);
+	if (test_bit(SG_FFD_NO_CMD_Q, fp->ffd_bm))
+		n += scnprintf(obp + n, len - n, " no_cmd_q");
+	if (test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm))
+		n += scnprintf(obp + n, len - n, " force_packid");
+	if (test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm))
+		n += scnprintf(obp + n, len - n, " keep_orphan");
+	if (test_bit(SG_FFD_EXCL_WAITQ, fp->ffd_bm))
+		n += scnprintf(obp + n, len - n, " excl_waitq");
+	if (test_bit(SG_FFD_SVB_ACTIVE, fp->ffd_bm))
+		n += scnprintf(obp + n, len - n, " svb");
+	n += scnprintf(obp + n, len - n, " fd_bm=0x%lx\n", fp->ffd_bm[0]);
 	n += scnprintf(obp + n, len - n,
 		       "   mmap_sz=%d low_used_idx=%d low_await_idx=%d sum_fd_dlens=%u\n",
 		       fp->mmap_sz, READ_ONCE(fp->low_used_idx), READ_ONCE(fp->low_await_idx),
@@ -6699,7 +7404,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		if (xa_get_mark(&fp->srp_arr, idx, SG_XA_RQ_INACTIVE))
 			continue;
 		if (set_debug)
-			n += scnprintf(obp + n, len - n, "     frq_bm=0x%lx  ",
+			n += scnprintf(obp + n, len - n, "     rq_bm=0x%lx",
 				       srp->frq_bm[0]);
 		else if (test_bit(SG_FRQ_ABORTING, srp->frq_bm))
 			n += scnprintf(obp + n, len - n,
@@ -6720,7 +7425,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		if (k == 0)
 			n += scnprintf(obp + n, len - n, "   Inactives:\n");
 		if (set_debug)
-			n += scnprintf(obp + n, len - n, "     frq_bm=0x%lx  ",
+			n += scnprintf(obp + n, len - n, "     rq_bm=0x%lx",
 				       srp->frq_bm[0]);
 		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns,
 					obp + n, len - n);
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index bf947ebe06dd..a1f35fd34816 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -222,6 +222,7 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 #define SG_SEIRV_DEV_INACT_RQS	0x4	/* sum(inactive rqs) on owning dev */
 #define SG_SEIRV_SUBMITTED	0x5	/* number of mrqs submitted+unread */
 #define SG_SEIRV_DEV_SUBMITTED	0x6	/* sum(submitted) on all dev's fds */
+#define SG_SEIRV_MAX_RSV_REQS	0x7	/* maximum reserve requests */
 
 /*
  * A pointer to the following structure is passed as the third argument to
-- 
2.25.1

