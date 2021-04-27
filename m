Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F01C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC59613FC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbhD0WAP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:15 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39003 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239492AbhD0V7q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 985992041BB;
        Tue, 27 Apr 2021 23:58:58 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id E9xB4dmSm1Ja; Tue, 27 Apr 2021 23:58:52 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 74C382041AC;
        Tue, 27 Apr 2021 23:58:51 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 51/83] sg: add shared requests
Date:   Tue, 27 Apr 2021 17:57:01 -0400
Message-Id: <20210427215733.417746-53-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add request sharing which is invoked on a shared file descriptor by
using SGV4_FLAG_SHARE. The file share is asymmetric: the read-side
is assumed to do data-in command (e.g. READ) first, followed by the
write-side doing a data-out command (e.g. WRITE). The read-side
may also set SG_FLAG_NO_DXFER and the write-side must set that flag.
If both sides set that flag then a single bio is used and the user
space doesn't "see" the data. If the read-side does not set
SG_FLAG_NO_DXFER then the read data is copied to the user space.
And that copy to user space can replaced by using SG_FLAG_MMAP_IO
(but that adds some other overheads).

See the webpage at: https://sg.danny.cz/sg/sg_v40.html
in the section titled: "8 Request sharing".

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 1203 +++++++++++++++++++++++++++++-----------
 include/uapi/scsi/sg.h |    8 +
 2 files changed, 892 insertions(+), 319 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index fb3782b1f9c7..f43cfd2ae739 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -89,11 +89,22 @@ static mempool_t *sg_sense_pool;
 #define cuptr64(usp_val) ((const void __user *)(uintptr_t)(usp_val))
 
 /* Following enum contains the states of sg_request::rq_st */
-enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
-	SG_RS_INACTIVE = 0,	/* request not in use (e.g. on fl) */
-	SG_RS_INFLIGHT,		/* active: cmd/req issued, no response yet */
-	SG_RS_AWAIT_RCV,	/* have response from LLD, awaiting receive */
-	SG_RS_BUSY,		/* temporary state should rarely be seen */
+enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RQ_AWAIT_RCV==2 */
+	SG_RQ_INACTIVE = 0,	/* request not in use (e.g. on fl) */
+	SG_RQ_INFLIGHT,		/* active: cmd/req issued, no response yet */
+	SG_RQ_AWAIT_RCV,	/* have response from LLD, awaiting receive */
+	SG_RQ_BUSY,		/* temporary state should rarely be seen */
+	SG_RQ_SHR_SWAP,		/* read-side: is finished, await swap to write-side */
+	SG_RQ_SHR_IN_WS,	/* read-side: waits while write-side inflight */
+};
+
+/* write-side sets up sharing: ioctl(ws_fd,SG_SET_GET_EXTENDED(SHARE_FD(rs_fd))) */
+enum sg_shr_var {
+	SG_SHR_NONE = 0,	/* no sharing on this fd, so _not_ shared request */
+	SG_SHR_RS_NOT_SRQ,	/* read-side fd but _not_ shared request */
+	SG_SHR_RS_RQ,		/* read-side sharing on this request */
+	SG_SHR_WS_NOT_SRQ,	/* write-side fd but _not_ shared request */
+	SG_SHR_WS_RQ,		/* write-side sharing on this request */
 };
 
 /* If sum_of(dlen) of a fd exceeds this, write() will yield E2BIG */
@@ -119,13 +130,13 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FRQ_IS_V4I		0	/* true (set) when is v4 interface */
 #define SG_FRQ_IS_ORPHAN	1	/* owner of request gone */
 #define SG_FRQ_SYNC_INVOC	2	/* synchronous (blocking) invocation */
-#define SG_FRQ_NO_US_XFER	3	/* no user space transfer of data */
+#define SG_FRQ_US_XFER		3	/* kernel<-->user_space data transfer */
 #define SG_FRQ_ABORTING		4	/* in process of aborting this cmd */
-#define SG_FRQ_DEACT_ORPHAN	6	/* not keeping orphan so de-activate */
-#define SG_FRQ_RECEIVING	7	/* guard against multiple receivers */
-#define SG_FRQ_FOR_MMAP		8	/* request needs PAGE_SIZE elements */
-#define SG_FRQ_COUNT_ACTIVE	9	/* sfp->submitted + waiting active */
-#define SG_FRQ_ISSUED		10	/* blk_execute_rq_nowait() finished */
+#define SG_FRQ_DEACT_ORPHAN	5	/* not keeping orphan so de-activate */
+#define SG_FRQ_RECEIVING	6	/* guard against multiple receivers */
+#define SG_FRQ_FOR_MMAP		7	/* request needs PAGE_SIZE elements */
+#define SG_FRQ_COUNT_ACTIVE	8	/* sfp->submitted + waiting active */
+#define SG_FRQ_ISSUED		9	/* blk_execute_rq_nowait() finished */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
@@ -134,10 +145,11 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FFD_HIPRI_SEEN	3	/* could have HIPRI requests active */
 #define SG_FFD_TIME_IN_NS	4	/* set: time in nanoseconds, else ms */
 #define SG_FFD_Q_AT_TAIL	5	/* set: queue reqs at tail of blk q */
-#define SG_FFD_PREFER_TAG	6	/* prefer tag over pack_id (def) */
-#define SG_FFD_RELEASE		7	/* release (close) underway */
-#define SG_FFD_NO_DURATION	8	/* don't do command duration calc */
-#define SG_FFD_MORE_ASYNC	9	/* yield EBUSY more often */
+#define SG_FFD_READ_SIDE_ERR	6	/* prior read-side of share failed */
+#define SG_FFD_PREFER_TAG	7	/* prefer tag over pack_id (def) */
+#define SG_FFD_RELEASE		8	/* release (close) underway */
+#define SG_FFD_NO_DURATION	9	/* don't do command duration calc */
+#define SG_FFD_MORE_ASYNC	10	/* yield EBUSY more often */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -216,6 +228,7 @@ struct sg_fd;
 
 struct sg_request {	/* active SCSI command or inactive request */
 	struct sg_scatter_hold sgat_h;	/* hold buffer, perhaps scatter list */
+	struct sg_scatter_hold *sgatp;	/* ptr to prev unless write-side shr req */
 	union {
 		struct sg_slice_hdr3 s_hdr3;  /* subset of sg_io_hdr */
 		struct sg_slice_hdr4 s_hdr4; /* reduced size struct sg_io_v4 */
@@ -229,6 +242,7 @@ struct sg_request {	/* active SCSI command or inactive request */
 	int pack_id;		/* v3 pack_id or in v4 request_extra field */
 	int sense_len;		/* actual sense buffer length (data-in) */
 	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */
+	enum sg_shr_var sh_var;	/* sharing variety, SG_SHR_NONE=0 if none */
 	u8 cmd_opcode;		/* first byte of SCSI cdb */
 	int tag;		/* block layer identifier of request */
 	blk_qc_t cookie;	/* ids 1 or more queues for blk_poll() */
@@ -237,7 +251,7 @@ struct sg_request {	/* active SCSI command or inactive request */
 	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */
 	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */
 	struct request *rqq;	/* released in sg_rq_end_io(), bio kept */
-	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
+	struct bio *bio;	/* kept until this req -->SG_RQ_INACTIVE */
 	struct execute_work ew_orph;	/* harvest orphan request */
 };
 
@@ -262,6 +276,7 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	unsigned long ffd_bm[1];	/* see SG_FFD_* defines above */
 	struct file *filp;	/* my identity when sharing */
 	struct sg_request *rsv_srp;/* one reserve request per fd */
+	struct sg_request *ws_srp; /* when rsv SG_SHR_RS_RQ, ptr to write-side */
 	struct sg_fd __rcu *share_sfp;/* fd share cross-references, else NULL */
 	struct fasync_struct *async_qp; /* used by asynchronous notification */
 	struct xarray srp_arr;	/* xarray of sg_request object pointers */
@@ -317,10 +332,11 @@ static int sg_read_append(struct sg_request *srp, void __user *outp,
 static void sg_remove_sgat(struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp, struct file *filp);
 static void sg_remove_sfp(struct kref *);
+static void sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side);
 static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id,
 					    bool is_tag);
 static struct sg_request *sg_setup_req(struct sg_comm_wr_t *cwrp,
-				       int dxfr_len);
+				       enum sg_shr_var sh_var, int dxfr_len);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int min_dev);
 static void sg_device_destroy(struct kref *kref);
@@ -331,6 +347,7 @@ static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q,
 			     int loop_count);
 #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)
 static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
+static const char *sg_shr_str(enum sg_shr_var sh_var, bool long_str);
 #endif
 
 #define SG_WRITE_COUNT_LIMIT (32 * 1024 * 1024)
@@ -345,7 +362,9 @@ static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 
 #define SG_IS_DETACHING(sdp) test_bit(SG_FDEV_DETACHING, (sdp)->fdev_bm)
 #define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
-#define SG_RS_ACTIVE(srp) (atomic_read(&(srp)->rq_st) != SG_RS_INACTIVE)
+#define SG_IS_O_NONBLOCK(sfp) (!!((sfp)->filp->f_flags & O_NONBLOCK))
+#define SG_RQ_ACTIVE(srp) (atomic_read(&(srp)->rq_st) != SG_RQ_INACTIVE)
+// #define SG_RQ_THIS_RQ(srp) ((srp)->sh_var == SG_SHR_RS_RQ)
 
 /*
  * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log messages.
@@ -427,7 +446,7 @@ sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 			mutex_unlock(&sdp->open_rel_lock);
 			res = wait_event_interruptible
 					(sdp->open_wait,
-					 (SG_IS_DETACHING(sdp) ||
+					 (unlikely(SG_IS_DETACHING(sdp)) ||
 					  atomic_read(&sdp->open_cnt) == 0));
 			mutex_lock(&sdp->open_rel_lock);
 
@@ -441,7 +460,7 @@ sg_wait_open_event(struct sg_device *sdp, bool o_excl)
 			mutex_unlock(&sdp->open_rel_lock);
 			res = wait_event_interruptible
 					(sdp->open_wait,
-					 (SG_IS_DETACHING(sdp) ||
+					 (unlikely(SG_IS_DETACHING(sdp)) ||
 					  !SG_HAVE_EXCLUDE(sdp)));
 			mutex_lock(&sdp->open_rel_lock);
 
@@ -497,7 +516,7 @@ sg_open(struct inode *inode, struct file *filp)
 	nonseekable_open(inode, filp);
 	o_excl = !!(op_flags & O_EXCL);
 	non_block = !!(op_flags & O_NONBLOCK);
-	if (o_excl && ((op_flags & O_ACCMODE) == O_RDONLY))
+	if (unlikely(o_excl) && ((op_flags & O_ACCMODE) == O_RDONLY))
 		return -EPERM;/* not permitted, need write access for O_EXCL */
 	sdp = sg_get_dev(min_dev);	/* increments sdp->d_ref */
 	if (IS_ERR(sdp))
@@ -572,8 +591,15 @@ sg_open(struct inode *inode, struct file *filp)
 	goto sg_put;
 }
 
+static inline bool
+sg_fd_is_shared(struct sg_fd *sfp)
+{
+	return !xa_get_mark(&sfp->parentdp->sfp_arr, sfp->idx,
+			    SG_XA_FD_UNSHARED);
+}
+
 static inline struct sg_fd *
-sg_fd_shared_ptr(struct sg_fd *sfp)
+sg_fd_share_ptr(struct sg_fd *sfp)
 {
 	struct sg_fd *res_sfp;
 	struct sg_device *sdp = sfp->parentdp;
@@ -618,6 +644,10 @@ sg_release(struct inode *inode, struct file *filp)
 		SG_LOG(1, sfp, "%s: second release on this fd ? ?\n",
 		       __func__);
 	scsi_autopm_put_device(sdp->device);
+	if (!xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_FREE) &&
+	    sg_fd_is_shared(sfp))
+		sg_remove_sfp_share(sfp, xa_get_mark(&sdp->sfp_arr, sfp->idx,
+						     SG_XA_FD_RS_SHARE));
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 
 	/*
@@ -826,7 +856,7 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 	if (hp->flags & SG_FLAG_MMAP_IO) {
 		int res = sg_chk_mmap(sfp, hp->flags, hp->dxfer_len);
 
-		if (res)
+		if (unlikely(res))
 			return res;
 	}
 	/* when v3 seen, allow cmd_q on this fd (def: no cmd_q) */
@@ -864,7 +894,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		else if (h4p->dout_xferp)
 			len = h4p->dout_xfer_len;
 		res = sg_chk_mmap(sfp, h4p->flags, len);
-		if (res)
+		if (unlikely(res))
 			return res;
 	}
 	/* once v4 (or v3) seen, allow cmd_q on this fd (def: no cmd_q) */
@@ -902,7 +932,7 @@ sg_ctl_iosubmit(struct sg_fd *sfp, void __user *p)
 	struct sg_io_v4 *h4p = (struct sg_io_v4 *)hdr_store;
 	struct sg_device *sdp = sfp->parentdp;
 
-	res = sg_allow_if_err_recovery(sdp, (sfp->filp->f_flags & O_NONBLOCK));
+	res = sg_allow_if_err_recovery(sdp, SG_IS_O_NONBLOCK(sfp));
 	if (res)
 		return res;
 	if (copy_from_user(hdr_store, p, SZ_SG_IO_V4))
@@ -920,7 +950,7 @@ sg_ctl_iosubmit_v3(struct sg_fd *sfp, void __user *p)
 	struct sg_io_hdr *h3p = (struct sg_io_hdr *)hdr_store;
 	struct sg_device *sdp = sfp->parentdp;
 
-	res = sg_allow_if_err_recovery(sdp, (sfp->filp->f_flags & O_NONBLOCK));
+	res = sg_allow_if_err_recovery(sdp, SG_IS_O_NONBLOCK(sfp));
 	if (unlikely(res))
 		return res;
 	if (copy_from_user(h3p, p, SZ_SG_IO_HDR))
@@ -930,6 +960,54 @@ sg_ctl_iosubmit_v3(struct sg_fd *sfp, void __user *p)
 	return -EPERM;
 }
 
+/*
+ * Assumes sharing has been established at the file descriptor level and now we
+ * check the rq_flags of a new request/command. SGV4_FLAG_NO_DXFER may or may
+ * not be used on the read-side, it must be used on the write-side. Also
+ * returns (via *sh_varp) the proposed sg_request::sh_var of the new request
+ * yet to be built/re-used.
+ */
+static int
+sg_share_chk_flags(struct sg_fd *sfp, u32 rq_flags, int dxfer_len, int dir,
+		   enum sg_shr_var *sh_varp)
+{
+	bool is_read_side = xa_get_mark(&sfp->parentdp->sfp_arr, sfp->idx,
+					SG_XA_FD_RS_SHARE);
+	int result = 0;
+	enum sg_shr_var sh_var = SG_SHR_NONE;
+
+	if (rq_flags & SGV4_FLAG_SHARE) {
+		if (rq_flags & SG_FLAG_DIRECT_IO)
+			result = -EINVAL; /* since no control of data buffer */
+		else if (dxfer_len < 1)
+			result = -ENODATA;
+		else if (is_read_side) {
+			sh_var = SG_SHR_RS_RQ;
+			if (dir != SG_DXFER_FROM_DEV)
+				result = -ENOMSG;
+			if (rq_flags & SGV4_FLAG_NO_DXFER) {
+				/* rule out some contradictions */
+				if (rq_flags & SG_FL_MMAP_DIRECT)
+					result = -ENODATA;
+			}
+		} else {			/* fd is write-side */
+			sh_var = SG_SHR_WS_RQ;
+			if (dir != SG_DXFER_TO_DEV)
+				result = -ENOMSG;
+			if (!(rq_flags & SGV4_FLAG_NO_DXFER))
+				result = -ENOMSG;
+			if (rq_flags & SG_FL_MMAP_DIRECT)
+				result = -ENODATA;
+		}
+	} else if (is_read_side) {
+		sh_var = SG_SHR_RS_NOT_SRQ;
+	} else {
+		sh_var = SG_SHR_WS_NOT_SRQ;
+	}
+	*sh_varp = sh_var;
+	return result;
+}
+
 #if IS_ENABLED(SG_LOG_ACTIVE)
 static void
 sg_rq_state_fail_msg(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
@@ -949,38 +1027,6 @@ sg_rq_state_fail_msg(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
 #endif
 
 /* Functions ending in '_ulck' assume sfp->xa_lock held by caller. */
-static void
-sg_rq_chg_state_force_ulck(struct sg_request *srp, enum sg_rq_state new_st)
-{
-	bool prev, want;
-	struct sg_fd *sfp = srp->parentfp;
-	struct xarray *xafp = &sfp->srp_arr;
-
-	atomic_set(&srp->rq_st, new_st);
-	want = (new_st == SG_RS_AWAIT_RCV);
-	prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
-	if (prev != want) {
-		if (want)
-			__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
-		else
-			__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
-	}
-	want = (new_st == SG_RS_INACTIVE);
-	prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
-	if (prev != want) {
-		if (want) {
-			int prev_idx = READ_ONCE(sfp->low_used_idx);
-
-			if (prev_idx < 0 || srp->rq_idx < prev_idx ||
-			    !xa_get_mark(xafp, prev_idx, SG_XA_RQ_INACTIVE))
-				WRITE_ONCE(sfp->low_used_idx, srp->rq_idx);
-			__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
-		} else {
-			__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
-		}
-	}
-}
-
 static void
 sg_rq_chg_state_help(struct xarray *xafp, struct sg_request *srp, int indic)
 {
@@ -996,21 +1042,42 @@ sg_rq_chg_state_help(struct xarray *xafp, struct sg_request *srp, int indic)
 }
 
 /* Following array indexed by enum sg_rq_state, 0 means no xa mark change */
-static const int sg_rq_state_arr[] = {1, 0, 4, 0};
-static const int sg_rq_state_mul2arr[] = {2, 0, 8, 0};
+static const int sg_rq_state_arr[] = {1, 0, 4, 0, 0, 0};
+static const int sg_rq_state_mul2arr[] = {2, 0, 8, 0, 0, 0};
 
 /*
  * This function keeps the srp->rq_st state and associated marks on the
- * owning xarray's element in sync. If force is true then new_st is stored
- * in srp->rq_st and xarray marks are set accordingly (and old_st is
- * ignored); and 0 is returned.
- * If force is false, then atomic_cmpxchg() is called. If the actual
- * srp->rq_st is not old_st, then -EPROTOTYPE is returned. If the actual
- * srp->rq_st is old_st then it is replaced by new_st and the xarray marks
- * are setup accordingly and 0 is returned. This assumes srp_arr xarray
- * spinlock is held.
+ * owning xarray's element in sync. An attempt si made to change state with
+ * a call to atomic_cmpxchg(). If the actual srp->rq_st is not old_st, then
+ * -EPROTOTYPE is returned. If the actual srp->rq_st is old_st then it is
+ * replaced by new_st and the xarray marks are setup accordingly and 0 is
+ * returned. This assumes srp_arr xarray spinlock is held.
  */
 static int
+sg_rq_chg_state_ulck(struct sg_request *srp, enum sg_rq_state old_st,
+		     enum sg_rq_state new_st)
+{
+	enum sg_rq_state act_old_st;
+	int indic;
+
+	indic = sg_rq_state_arr[(int)old_st] +
+		sg_rq_state_mul2arr[(int)new_st];
+	act_old_st = (enum sg_rq_state)atomic_cmpxchg(&srp->rq_st, old_st,
+						      new_st);
+	if (act_old_st != old_st) {
+#if IS_ENABLED(SG_LOG_ACTIVE)
+		SG_LOG(1, srp->parentfp, "%s: unexpected old state: %s\n",
+		       __func__, sg_rq_st_str(act_old_st, false));
+#endif
+		return -EPROTOTYPE;	/* only used for this error type */
+	}
+	if (indic)
+		sg_rq_chg_state_help(&srp->parentfp->srp_arr, srp, indic);
+	return 0;
+}
+
+/* Similar to sg_rq_chg_state_ulck() but uses the xarray spinlock */
+static int
 sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
 		enum sg_rq_state new_st)
 {
@@ -1030,7 +1097,7 @@ sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
 			       sg_rq_st_str(act_old_st, false));
 			return -EPROTOTYPE;     /* only used for this error type */
 		}
-		if (new_st == SG_RS_INACTIVE) {
+		if (new_st == SG_RQ_INACTIVE) {
 			int prev_idx = READ_ONCE(sfp->low_used_idx);
 
 			if (prev_idx < 0 || srp->rq_idx < prev_idx ||
@@ -1050,6 +1117,38 @@ sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
 	return 0;
 }
 
+static void
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
 static void
 sg_rq_chg_state_force(struct sg_request *srp, enum sg_rq_state new_st)
 {
@@ -1086,7 +1185,7 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 		at_head = !(srp->rq_flags & SG_FLAG_Q_AT_TAIL);
 
 	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
-	sg_rq_chg_state_force(srp, SG_RS_INFLIGHT);
+	sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
 
 	/* >>>>>>> send cmd/req off to other levels <<<<<<<< */
 	if (!sync) {
@@ -1115,6 +1214,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 	int dxfr_len, dir;
 	int pack_id = SG_PACK_ID_WILDCARD;
 	u32 rq_flags;
+	enum sg_shr_var sh_var;
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_device *sdp = fp->parentdp;
 	struct sg_request *srp;
@@ -1145,10 +1245,19 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		rq_flags = hi_p->flags;
 		pack_id = hi_p->pack_id;
 	}
+	if (sg_fd_is_shared(fp)) {
+		res = sg_share_chk_flags(fp, rq_flags, dxfr_len, dir, &sh_var);
+		if (unlikely(res < 0))
+			return ERR_PTR(res);
+	} else {
+		sh_var = SG_SHR_NONE;
+		if (rq_flags & SGV4_FLAG_SHARE)
+			return ERR_PTR(-ENOMSG);
+	}
 	if (dxfr_len >= SZ_256M)
 		return ERR_PTR(-EINVAL);
 
-	srp = sg_setup_req(cwrp, dxfr_len);
+	srp = sg_setup_req(cwrp, sh_var, dxfr_len);
 	if (IS_ERR(srp))
 		return srp;
 	srp->rq_flags = rq_flags;
@@ -1235,8 +1344,6 @@ sg_copy_sense(struct sg_request *srp, bool v4_active)
 			sb_len_ret = min_t(int, sb_len_ret, sb_len);
 			if (copy_to_user(up, sbp, sb_len_ret))
 				sb_len_ret = -EFAULT;
-		} else {
-			sb_len_ret = 0;
 		}
 		mempool_free(sbp, sg_sense_pool);
 	}
@@ -1246,7 +1353,10 @@ sg_copy_sense(struct sg_request *srp, bool v4_active)
 static int
 sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 {
+	int err = 0;
 	u32 rq_res = srp->rq_result;
+	enum sg_shr_var sh_var = srp->sh_var;
+	struct sg_fd *sh_sfp;
 
 	if (unlikely(srp->rq_result & 0xff)) {
 		int sb_len_wr = sg_copy_sense(srp, v4_active);
@@ -1256,9 +1366,86 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	}
 	if (rq_res & SG_ML_RESULT_MSK)
 		srp->rq_info |= SG_INFO_CHECK;
+	if (test_bit(SG_FRQ_ABORTING, srp->frq_bm))
+		srp->rq_info |= SG_INFO_ABORTED;
+
+	sh_sfp = sg_fd_share_ptr(sfp);
+	if (sh_var == SG_SHR_WS_RQ && sg_fd_is_shared(sfp)) {
+		struct sg_request *rs_srp = sh_sfp->rsv_srp;
+		enum sg_rq_state mar_st = atomic_read(&rs_srp->rq_st);
+
+		switch (mar_st) {
+		case SG_RQ_SHR_SWAP:
+		case SG_RQ_SHR_IN_WS:
+			/* make read-side request available for re-use */
+			rs_srp->tag = SG_TAG_WILDCARD;
+			rs_srp->sh_var = SG_SHR_NONE;
+			sg_rq_chg_state_force(rs_srp, SG_RQ_INACTIVE);
+			atomic_inc(&sh_sfp->inactives);
+			break;
+		case SG_RQ_INACTIVE:
+		case SG_RQ_AWAIT_RCV:
+			sh_sfp->ws_srp = NULL;
+			break;  /* nothing to do */
+		default:
+			err = -EPROTO;  /* Logic error */
+			SG_LOG(1, sfp,
+			       "%s: SHR_WS_RQ, bad read-side state: %s\n",
+			       __func__, sg_rq_st_str(mar_st, true));
+			break;  /* nothing to do */
+		}
+	}
 	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
 		srp->rq_info |= SG_INFO_DEVICE_DETACHING;
-	return 0;
+	return err;
+}
+
+static void
+sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
+{
+	enum sg_rq_state sr_st = atomic_read(&srp->rq_st);
+
+	/* advance state machine, send signal to write-side if appropriate */
+	switch (srp->sh_var) {
+	case SG_SHR_RS_RQ:
+		{
+			int poll_type = POLL_OUT;
+			struct sg_fd *sh_sfp = sg_fd_share_ptr(sfp);
+
+			if ((srp->rq_result & SG_ML_RESULT_MSK) || other_err) {
+				set_bit(SG_FFD_READ_SIDE_ERR, sfp->ffd_bm);
+				if (sr_st != SG_RQ_BUSY)
+					sg_rq_chg_state_force(srp, SG_RQ_BUSY);
+				poll_type = POLL_HUP;   /* "Hang-UP flag */
+			} else if (sr_st != SG_RQ_SHR_SWAP) {
+				sg_rq_chg_state_force(srp, SG_RQ_SHR_SWAP);
+			}
+			if (sh_sfp)
+				kill_fasync(&sh_sfp->async_qp, SIGPOLL,
+					    poll_type);
+		}
+		break;
+	case SG_SHR_WS_RQ:      /* cleanup both on write-side completion */
+		{
+			struct sg_fd *rs_sfp = sg_fd_share_ptr(sfp);
+
+			if (rs_sfp) {
+				rs_sfp->ws_srp = NULL;
+				if (rs_sfp->rsv_srp)
+					rs_sfp->rsv_srp->sh_var =
+							SG_SHR_RS_NOT_SRQ;
+			}
+		}
+		srp->sh_var = SG_SHR_WS_NOT_SRQ;
+		srp->sgatp = &srp->sgat_h;
+		if (sr_st != SG_RQ_BUSY)
+			sg_rq_chg_state_force(srp, SG_RQ_BUSY);
+		break;
+	default:
+		if (sr_st != SG_RQ_BUSY)
+			sg_rq_chg_state_force(srp, SG_RQ_BUSY);
+		break;
+	}
 }
 
 static int
@@ -1283,10 +1470,10 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 	h4p->duration = srp->duration;
 	switch (srp->s_hdr4.dir) {
 	case SG_DXFER_FROM_DEV:
-		h4p->din_xfer_len = srp->sgat_h.dlen;
+		h4p->din_xfer_len = srp->sgatp->dlen;
 		break;
 	case SG_DXFER_TO_DEV:
-		h4p->dout_xfer_len = srp->sgat_h.dlen;
+		h4p->dout_xfer_len = srp->sgatp->dlen;
 		break;
 	default:
 		break;
@@ -1302,6 +1489,7 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 		if (copy_to_user(p, h4p, SZ_SG_IO_V4))
 			err = err ? err : -EFAULT;
 	}
+	sg_complete_v3v4(sfp, srp, err < 0);
 	sg_finish_scsi_blk_rq(srp);
 	sg_deact_request(sfp, srp);
 	return err < 0 ? err : 0;
@@ -1317,7 +1505,7 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 static int
 sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 {
-	bool non_block = !!(sfp->filp->f_flags & O_NONBLOCK);
+	bool non_block = SG_IS_O_NONBLOCK(sfp);
 	bool use_tag = false;
 	int res, id;
 	int pack_id = SG_PACK_ID_WILDCARD;
@@ -1355,9 +1543,9 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 			return -ENODEV;
 		if (non_block)
 			return -EAGAIN;
-		res = wait_event_interruptible(sfp->read_wait,
-					       sg_get_ready_srp(sfp, &srp,
-								id, use_tag));
+		res = wait_event_interruptible
+				(sfp->read_wait,
+				 sg_get_ready_srp(sfp, &srp, id, use_tag));
 		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
 		if (res)
@@ -1380,7 +1568,7 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 static int
 sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 {
-	bool non_block = !!(sfp->filp->f_flags & O_NONBLOCK);
+	bool non_block = SG_IS_O_NONBLOCK(sfp);
 	int res;
 	int pack_id = SG_PACK_ID_WILDCARD;
 	u8 v3_holder[SZ_SG_IO_HDR];
@@ -1566,6 +1754,19 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 				ret = get_user(want_id, &h3_up->pack_id);
 				if (ret)
 					return ret;
+				if (!non_block) {
+					int flgs;
+
+					ret = get_user(flgs, &h3_up->flags);
+					if (ret)
+						return ret;
+					if (flgs & SGV4_FLAG_IMMED)
+						non_block = true;
+				}
+			} else if (v3_hdr->interface_id == 'Q') {
+				pr_info_once("sg: %s: v4 interface%s here\n",
+					     __func__, " disallowed");
+				return -EPERM;
 			} else {
 				return -EPERM;
 			}
@@ -1622,7 +1823,8 @@ sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, void __user *p)
 	struct sg_io_hdr hdr3;
 	struct sg_io_hdr *hp = &hdr3;
 
-	SG_LOG(3, sfp, "%s: srp=0x%pK\n", __func__, srp);
+	SG_LOG(3, sfp, "%s: sh_var: %s srp=0x%pK\n", __func__,
+	       sg_shr_str(srp->sh_var, false), srp);
 	err = sg_rec_state_v3v4(sfp, srp, false);
 	memset(hp, 0, sizeof(*hp));
 	memcpy(hp, &srp->s_hdr3, sizeof(srp->s_hdr3));
@@ -1687,92 +1889,192 @@ sg_calc_sgat_param(struct sg_device *sdp)
 }
 
 /*
- * Depending on which side is calling for the unshare, it is best to unshare
- * the other side first. For example: if the invocation is from the read-side
- * fd then rd_first should be false so the write-side is unshared first.
+ * Only valid for shared file descriptors, else -EINVAL. Should only be
+ * called after a read-side request has successfully completed so that
+ * there is valid data in reserve buffer. If fini1_again0 is true then
+ * read-side is taken out of the state waiting for a write-side request and the
+ * read-side is put in the inactive state. If fini1_again0 is false (0) then
+ * the read-side (assuming it is inactive) is put in a state waiting for
+ * a write-side request. This function is called when the write mask is set on
+ * ioctl(SG_SET_GET_EXTENDED(SG_CTL_FLAGM_READ_SIDE_FINI)).
  */
+static int
+sg_change_after_read_side_rq(struct sg_fd *sfp, bool fini1_again0)
+{
+	int res = 0;
+	enum sg_rq_state sr_st;
+	unsigned long iflags;
+	struct sg_fd *rs_sfp;
+	struct sg_request *rs_rsv_srp = NULL;
+	struct sg_device *sdp = sfp->parentdp;
+
+	rs_sfp = sg_fd_share_ptr(sfp);
+	if (unlikely(!rs_sfp)) {
+		res = -EINVAL;
+	} else if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE)) {
+		rs_rsv_srp = sfp->rsv_srp;
+		rs_sfp = sfp;
+	} else {	/* else called on write-side */
+		rs_rsv_srp = rs_sfp->rsv_srp;
+	}
+	if (res || !rs_rsv_srp)
+		goto fini;
+
+	xa_lock_irqsave(&rs_sfp->srp_arr, iflags);
+	sr_st = atomic_read(&rs_rsv_srp->rq_st);
+	if (fini1_again0) {
+		switch (sr_st) {
+		case SG_RQ_SHR_SWAP:
+			rs_rsv_srp->sh_var = SG_SHR_RS_NOT_SRQ;
+			rs_rsv_srp = NULL;
+			res = sg_rq_chg_state(rs_rsv_srp, sr_st, SG_RQ_INACTIVE);
+			if (!res)
+				atomic_inc(&rs_sfp->inactives);
+			break;
+		case SG_RQ_SHR_IN_WS:	/* too late, write-side rq active */
+		case SG_RQ_BUSY:
+			res = -EAGAIN;
+			break;
+		default:	/* read-side in SG_RQ_SHR_SWAIT is bad */
+			res = -EINVAL;
+			break;
+		}
+	} else {
+		switch (sr_st) {
+		case SG_RQ_INACTIVE:
+			rs_rsv_srp->sh_var = SG_SHR_RS_RQ;
+			res = sg_rq_chg_state(rs_rsv_srp, sr_st, SG_RQ_SHR_SWAP);
+			break;
+		case SG_RQ_SHR_SWAP:
+			break;	/* already done, redundant call? */
+		default:	/* all other states */
+			res = -EBUSY;	/* read-side busy doing ... */
+			break;
+		}
+	}
+	xa_unlock_irqrestore(&rs_sfp->srp_arr, iflags);
+fini:
+	if (unlikely(res)) {
+		SG_LOG(1, sfp, "%s: err=%d\n", __func__, -res);
+	} else {
+		SG_LOG(6, sfp, "%s: okay, fini1_again0=%d\n", __func__,
+		       fini1_again0);
+	}
+	return res;
+}
+
 static void
-sg_unshare_fds(struct sg_fd *rs_sfp, bool rs_lck, struct sg_fd *ws_sfp,
-	       bool ws_lck, bool rs_first)
+sg_unshare_rs_fd(struct sg_fd *rs_sfp, bool lck)
 {
-	bool diff_sdps = true;
 	unsigned long iflags = 0;
-	struct sg_device *sdp;
-	struct xarray *xap;
-
-	if (rs_lck && ws_lck &&  rs_sfp && ws_sfp &&
-	    rs_sfp->parentdp == ws_sfp->parentdp)
-		diff_sdps = false;
-	if (!rs_first && ws_sfp)
-		goto wr_first;
-rd_first:
-	if (rs_sfp) {
-		sdp = rs_sfp->parentdp;
-		xap = &sdp->sfp_arr;
-		rcu_assign_pointer(rs_sfp->share_sfp, NULL);
-		if (rs_lck && (rs_first || diff_sdps))
-			xa_lock_irqsave(xap, iflags);
-		__xa_set_mark(xap, rs_sfp->idx, SG_XA_FD_UNSHARED);
-		__xa_clear_mark(xap, rs_sfp->idx, SG_XA_FD_RS_SHARE);
-		if (rs_lck && (!rs_first || diff_sdps))
-			xa_unlock_irqrestore(xap, iflags);
-		kref_put(&sdp->d_ref, sg_device_destroy);
-	}
-	if (!rs_first || !ws_sfp)
-		return;
-wr_first:
-	if (ws_sfp) {
-		sdp = ws_sfp->parentdp;
-		xap = &sdp->sfp_arr;
-		rcu_assign_pointer(ws_sfp->share_sfp, NULL);
-		if (ws_lck && (!rs_first || diff_sdps))
-			xa_lock_irqsave(xap, iflags);
-		__xa_set_mark(xap, ws_sfp->idx, SG_XA_FD_UNSHARED);
-		/* SG_XA_FD_RS_SHARE mark should be already clear */
-		if (ws_lck && (rs_first || diff_sdps))
-			xa_unlock_irqrestore(xap, iflags);
-		kref_put(&sdp->d_ref, sg_device_destroy);
-	}
-	if (!rs_first && rs_sfp)
-		goto rd_first;
+	struct sg_device *sdp = rs_sfp->parentdp;
+	struct xarray *xadp = &sdp->sfp_arr;
+
+	rcu_assign_pointer(rs_sfp->share_sfp, NULL);
+	if (lck)
+		xa_lock_irqsave(xadp, iflags);
+	rs_sfp->ws_srp = NULL;
+	__xa_set_mark(xadp, rs_sfp->idx, SG_XA_FD_UNSHARED);
+	__xa_clear_mark(xadp, rs_sfp->idx, SG_XA_FD_RS_SHARE);
+	if (lck)
+		xa_unlock_irqrestore(xadp, iflags);
+	kref_put(&rs_sfp->f_ref, sg_remove_sfp);/* get: sg_find_sfp_helper() */
+}
+
+static void
+sg_unshare_ws_fd(struct sg_fd *ws_sfp, bool lck)
+{
+	unsigned long iflags;
+	struct sg_device *sdp = ws_sfp->parentdp;
+	struct xarray *xadp = &sdp->sfp_arr;
+
+	rcu_assign_pointer(ws_sfp->share_sfp, NULL);
+	if (lck)
+		xa_lock_irqsave(xadp, iflags);
+	__xa_set_mark(xadp, ws_sfp->idx, SG_XA_FD_UNSHARED);
+	/* SG_XA_FD_RS_SHARE mark should be already clear */
+	if (lck)
+		xa_unlock_irqrestore(xadp, iflags);
+	kref_put(&ws_sfp->f_ref, sg_remove_sfp);/* get: sg_find_sfp_helper() */
 }
 
 /*
- * Clean up loose ends that occur when clsong a file descriptor which is
+ * Clean up loose ends that occur when closing a file descriptor which is
  * part of a file share. There may be request shares in various states using
- * this file share so care is needed.
+ * this file share so care is needed. Potential race when both sides of fd
+ * share have their fd_s closed (i.e. sg_release()) at around the same time
+ * is the reason for rechecking the FD_RS_SHARE or FD_UNSHARED marks.
  */
 static void
 sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
 {
+	__maybe_unused int res = 0;
 	unsigned long iflags;
-	struct sg_fd *o_sfp = sg_fd_shared_ptr(sfp);
-	struct sg_device *sdp;
-	struct xarray *xap;
+	enum sg_rq_state sr_st;
+	struct sg_device *sdp = sfp->parentdp;
+	struct sg_device *sh_sdp;
+	struct sg_fd *sh_sfp;
+	struct sg_request *rsv_srp = NULL;
+	struct sg_request *ws_srp;
+	struct xarray *xadp = &sdp->sfp_arr;
 
-	SG_LOG(3, sfp, "%s: sfp=0x%pK, o_sfp=0x%pK%s\n", __func__, sfp, o_sfp,
-	       (is_rd_side ? " read-side" : ""));
+	SG_LOG(3, sfp, "%s: sfp=%pK %s\n", __func__, sfp,
+	       (is_rd_side ? "read-side" : "write-side"));
+	xa_lock_irqsave(xadp, iflags);
+	sh_sfp = sg_fd_share_ptr(sfp);
+	if (!sg_fd_is_shared(sfp))
+		goto err_out;
+	sh_sdp = sh_sfp->parentdp;
 	if (is_rd_side) {
-		sdp = sfp->parentdp;
-		xap = &sdp->sfp_arr;
-		xa_lock_irqsave(xap, iflags);
-		if (!xa_get_mark(xap, sfp->idx, SG_XA_FD_RS_SHARE)) {
-			xa_unlock_irqrestore(xap, iflags);
+		bool set_inactive = false;
+
+		if (!xa_get_mark(xadp, sfp->idx, SG_XA_FD_RS_SHARE)) {
+			xa_unlock_irqrestore(xadp, iflags);
 			return;
 		}
-		sg_unshare_fds(sfp, false, NULL, false, true);
-		xa_unlock_irqrestore(&sdp->sfp_arr, iflags);
+		rsv_srp = sfp->rsv_srp;
+		if (!rsv_srp)
+			goto fini;
+		if (rsv_srp->sh_var != SG_SHR_RS_RQ)
+			goto fini;
+		sr_st = atomic_read(&rsv_srp->rq_st);
+		switch (sr_st) {
+		case SG_RQ_SHR_SWAP:
+			set_inactive = true;
+			break;
+		case SG_RQ_SHR_IN_WS:
+			ws_srp = sfp->ws_srp;
+			if (ws_srp && !IS_ERR(ws_srp)) {
+				ws_srp->sh_var = SG_SHR_WS_NOT_SRQ;
+				sfp->ws_srp = NULL;
+			}
+			set_inactive = true;
+			break;
+		default:
+			break;
+		}
+		rsv_srp->sh_var = SG_SHR_NONE;
+		if (set_inactive) {
+			res = sg_rq_chg_state_ulck(rsv_srp, sr_st, SG_RQ_INACTIVE);
+			if (!res)
+				atomic_inc(&sfp->inactives);
+		}
+fini:
+		if (!xa_get_mark(&sh_sdp->sfp_arr, sh_sfp->idx,
+				 SG_XA_FD_FREE) && sg_fd_is_shared(sh_sfp))
+			sg_unshare_ws_fd(sh_sfp, sdp != sh_sdp);
+		sg_unshare_rs_fd(sfp, false);
 	} else {
-		sdp = sfp->parentdp;
-		xap = &sdp->sfp_arr;
-		xa_lock_irqsave(xap, iflags);
-		if (xa_get_mark(xap, sfp->idx, SG_XA_FD_UNSHARED)) {
-			xa_unlock_irqrestore(xap, iflags);
+		if (!sg_fd_is_shared(sfp)) {
+			xa_unlock_irqrestore(xadp, iflags);
 			return;
-		}
-		sg_unshare_fds(NULL, false, sfp, false, false);
-		xa_unlock_irqrestore(xap, iflags);
+		} else if (!xa_get_mark(&sh_sdp->sfp_arr, sh_sfp->idx,
+					SG_XA_FD_FREE))
+			sg_unshare_rs_fd(sh_sfp, sdp != sh_sdp);
+		sg_unshare_ws_fd(sfp, false);
 	}
+err_out:
+	xa_unlock_irqrestore(xadp, iflags);
 }
 
 /*
@@ -1782,41 +2084,45 @@ sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side)
  */
 static void
 sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
+		__must_hold(sfp->f_mutex)
 {
 	bool retry;
 	int retry_count = 0;
-	unsigned long iflags;
+	struct sg_request *rs_rsv_srp;
 	struct sg_fd *rs_sfp;
 	struct sg_fd *ws_sfp;
-	struct sg_fd *o_sfp = sg_fd_shared_ptr(sfp);
+	struct sg_fd *o_sfp = sg_fd_share_ptr(sfp);
 	struct sg_device *sdp = sfp->parentdp;
 
 	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_UNSHARED)) {
 		SG_LOG(1, sfp, "%s: not shared ? ?\n", __func__);
-		return; /* no share to undo */
+		return;	/* no share to undo */
 	}
 	if (!unshare_val)
-		return;
+		return;		/* when unshare value is zero, it's a NOP */
 again:
 	retry = false;
-	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE)) {
 		rs_sfp = sfp;
 		ws_sfp = o_sfp;
-		if (!xa_trylock(&ws_sfp->srp_arr)) {
-			if (++retry_count > SG_ADD_RQ_MAX_RETRIES)
-				SG_LOG(1, sfp, "%s: cannot get write-side lock\n",
-				       __func__);
-			else
-				retry = true;
-			goto fini;
+		rs_rsv_srp = rs_sfp->rsv_srp;
+		if (rs_rsv_srp && rs_rsv_srp->sh_var != SG_SHR_RS_RQ) {
+			if (unlikely(!mutex_trylock(&ws_sfp->f_mutex))) {
+				if (++retry_count > SG_ADD_RQ_MAX_RETRIES)
+					SG_LOG(1, sfp,
+					       "%s: cannot get write-side lock\n",
+					       __func__);
+				else
+					retry = true;
+				goto fini;
+			}
+			sg_unshare_rs_fd(rs_sfp, true);
+			mutex_unlock(&ws_sfp->f_mutex);
 		}
-		sg_unshare_fds(rs_sfp, false, ws_sfp, false, false);
-		xa_unlock(&ws_sfp->srp_arr);
 	} else {			/* called on write-side fd */
 		rs_sfp = o_sfp;
 		ws_sfp = sfp;
-		if (!xa_trylock(&rs_sfp->srp_arr)) {
+		if (unlikely(!mutex_trylock(&rs_sfp->f_mutex))) {
 			if (++retry_count > SG_ADD_RQ_MAX_RETRIES)
 				SG_LOG(1, sfp, "%s: cannot get read side lock\n",
 				       __func__);
@@ -1824,12 +2130,15 @@ sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
 				retry = true;
 			goto fini;
 		}
-		sg_unshare_fds(rs_sfp, false, ws_sfp, false, true);
-		xa_unlock(&rs_sfp->srp_arr);
+		rs_rsv_srp = rs_sfp->rsv_srp;
+		if (rs_rsv_srp->sh_var != SG_SHR_RS_RQ) {
+			sg_unshare_rs_fd(rs_sfp, true);
+			sg_unshare_ws_fd(ws_sfp, true);
+		}
+		mutex_unlock(&rs_sfp->f_mutex);
 	}
 fini:
-	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
-	if (retry) {
+	if (unlikely(retry)) {
 		cpu_relax();
 		goto again;
 	}
@@ -1876,12 +2185,14 @@ sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
 	u32 res = U32_MAX;
 
 	switch (sr_stp ? *sr_stp : atomic_read(&srp->rq_st)) {
-	case SG_RS_INFLIGHT:
-	case SG_RS_BUSY:
+	case SG_RQ_INFLIGHT:
+	case SG_RQ_BUSY:
 		res = sg_calc_rq_dur(srp, time_in_ns);
 		break;
-	case SG_RS_AWAIT_RCV:
-	case SG_RS_INACTIVE:
+	case SG_RQ_AWAIT_RCV:
+	case SG_RQ_SHR_SWAP:
+	case SG_RQ_SHR_IN_WS:
+	case SG_RQ_INACTIVE:
 		res = srp->duration;
 		is_dur = true;	/* completion has occurred, timing finished */
 		break;
@@ -1917,7 +2228,7 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 static inline bool
 sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
 {
-	return atomic_read_acquire(&srp->rq_st) != SG_RS_INFLIGHT ||
+	return atomic_read_acquire(&srp->rq_st) != SG_RQ_INFLIGHT ||
 	       unlikely(SG_IS_DETACHING(sdp));
 }
 
@@ -1933,7 +2244,7 @@ sg_wait_event_srp(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 	enum sg_rq_state sr_st;
 	struct sg_device *sdp = sfp->parentdp;
 
-	if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
+	if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT)
 		goto skip_wait;		/* and skip _acquire() */
 	if (srp->rq_flags & SGV4_FLAG_HIPRI) {
 		/* call blk_poll(), spinning till found */
@@ -1949,24 +2260,25 @@ sg_wait_event_srp(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
 		set_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
 		/* orphans harvested when sfp->keep_orphan is false */
-		atomic_set(&srp->rq_st, SG_RS_INFLIGHT);
-		SG_LOG(1, sfp, "%s:  wait_event_interruptible gave %d\n",
-		       __func__, res);
+		sg_rq_chg_state_force(srp, SG_RQ_INFLIGHT);
+		SG_LOG(1, sfp, "%s:  wait_event_interruptible(): %s[%d]\n",
+		       __func__, (res == -ERESTARTSYS ? "ERESTARTSYS" : ""),
+		       res);
 		return res;
 	}
 skip_wait:
 	if (unlikely(SG_IS_DETACHING(sdp))) {
-		sg_rq_chg_state_force(srp, SG_RS_INACTIVE);
+		sg_rq_chg_state_force(srp, SG_RQ_INACTIVE);
 		atomic_inc(&sfp->inactives);
 		return -ENODEV;
 	}
 	sr_st = atomic_read(&srp->rq_st);
-	if (unlikely(sr_st != SG_RS_AWAIT_RCV))
+	if (unlikely(sr_st != SG_RQ_AWAIT_RCV))
 		return -EPROTO;         /* Logic error */
-	res = sg_rq_chg_state(srp, sr_st, SG_RS_BUSY);
+	res = sg_rq_chg_state(srp, sr_st, SG_RQ_BUSY);
 	if (unlikely(res)) {
 #if IS_ENABLED(SG_LOG_ACTIVE)
-		sg_rq_state_fail_msg(sfp, sr_st, SG_RS_BUSY, __func__);
+		sg_rq_state_fail_msg(sfp, sr_st, SG_RQ_BUSY, __func__);
 #endif
 		return res;
 	}
@@ -1991,8 +2303,7 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	struct sg_io_v4 *h4p = (struct sg_io_v4 *)hu8arr;
 
 	SG_LOG(3, sfp, "%s:  SG_IO%s\n", __func__,
-	       ((sfp->filp->f_flags & O_NONBLOCK) ? " O_NONBLOCK ignored" :
-						    ""));
+	       (SG_IS_O_NONBLOCK(sfp) ? " O_NONBLOCK ignored" : ""));
 	res = sg_allow_if_err_recovery(sdp, false);
 	if (res)
 		return res;
@@ -2017,14 +2328,20 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	if (!srp)	/* mrq case: already processed all responses */
 		return res;
 	res = sg_wait_event_srp(sfp, p, h4p, srp);
-	if (res)
-		SG_LOG(1, sfp, "%s: %s=0x%pK  state: %s\n", __func__,
-		       "unexpected srp", srp,
-		       sg_rq_st_str(atomic_read(&srp->rq_st), false));
+#if IS_ENABLED(SG_LOG_ACTIVE)
+	if (unlikely(res))
+		SG_LOG(1, sfp, "%s: %s=0x%pK  state: %s, share: %s\n",
+		       __func__, "unexpected srp", srp,
+		       sg_rq_st_str(atomic_read(&srp->rq_st), false),
+		       sg_shr_str(srp->sh_var, false));
+#endif
 	return res;
 }
 
-/* When use_tag is true then id is a tag, else it is a pack_id. */
+/*
+ * When use_tag is true then id is a tag, else it is a pack_id. Returns
+ * valid srp if match, else returns NULL.
+ */
 static struct sg_request *
 sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
 {
@@ -2056,6 +2373,7 @@ sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
 
 static int
 sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
+		__must_hold(sfp->f_mutex)
 {
 	bool use_tag;
 	int res, pack_id, tag, id;
@@ -2078,6 +2396,8 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	srp = sg_match_request(sfp, use_tag, id);
 	if (!srp) {	/* assume device (not just fd) scope */
 		xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+		if (!(h4p->flags & SGV4_FLAG_DEV_SCOPE))
+			return -ENODATA;
 		xa_for_each(&sdp->sfp_arr, idx, o_sfp) {
 			if (o_sfp == sfp)
 				continue;	/* already checked */
@@ -2095,18 +2415,20 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	set_bit(SG_FRQ_ABORTING, srp->frq_bm);
 	res = 0;
 	switch (atomic_read(&srp->rq_st)) {
-	case SG_RS_BUSY:
+	case SG_RQ_BUSY:
 		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
-		res = -EBUSY;	/* shouldn't occur often */
+		res = -EBUSY;	/* should not occur often */
 		break;
-	case SG_RS_INACTIVE:	/* inactive on rq_list not good */
+	case SG_RQ_INACTIVE:	/* inactive on rq_list not good */
 		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
 		res = -EPROTO;
 		break;
-	case SG_RS_AWAIT_RCV:	/* user should still do completion */
+	case SG_RQ_AWAIT_RCV:	/* user should still do completion */
+	case SG_RQ_SHR_SWAP:
+	case SG_RQ_SHR_IN_WS:
 		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
 		break;		/* nothing to do here, return 0 */
-	case SG_RS_INFLIGHT:	/* only attempt abort if inflight */
+	case SG_RQ_INFLIGHT:	/* only attempt abort if inflight */
 		srp->rq_result |= (DRIVER_SOFT << 24);
 		{
 			struct request *rqq = READ_ONCE(srp->rqq);
@@ -2160,7 +2482,7 @@ sg_find_sfp_helper(struct sg_fd *from_sfp, struct sg_fd *pair_sfp,
 	xa_lock_irqsave(&from_sdp->sfp_arr, iflags);
 	rcu_assign_pointer(from_sfp->share_sfp, pair_sfp);
 	__xa_clear_mark(&from_sdp->sfp_arr, from_sfp->idx, SG_XA_FD_UNSHARED);
-	kref_get(&from_sdp->d_ref);	/* treat share like pseudo open() */
+	kref_get(&from_sfp->f_ref);	/* so unshare done before release */
 	if (from_rd_side)
 		__xa_set_mark(&from_sdp->sfp_arr, from_sfp->idx,
 			      SG_XA_FD_RS_SHARE);
@@ -2176,7 +2498,7 @@ sg_find_sfp_helper(struct sg_fd *from_sfp, struct sg_fd *pair_sfp,
 	if (!from_rd_side)
 		__xa_set_mark(&pair_sdp->sfp_arr, pair_sfp->idx,
 			      SG_XA_FD_RS_SHARE);
-	kref_get(&pair_sdp->d_ref);	/* keep symmetry */
+	kref_get(&pair_sfp->f_ref);	/* keep symmetry */
 	xa_unlock_irqrestore(&pair_sdp->sfp_arr, iflags);
 	return 0;
 }
@@ -2336,7 +2658,7 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 	int res = 0;
 	int retry_count = 0;
 	struct file *filp;
-	struct sg_fd *ws_sfp = sg_fd_shared_ptr(rs_sfp);
+	struct sg_fd *ws_sfp = sg_fd_share_ptr(rs_sfp);
 
 	SG_LOG(3, ws_sfp, "%s:  new_write_side_fd: %d\n", __func__, new_ws_fd);
 	if (unlikely(!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO)))
@@ -2357,7 +2679,7 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
 	}
 	SG_LOG(6, ws_sfp, "%s: write-side fd ok, scan for filp=0x%pK\n", __func__,
 	       filp);
-	sg_unshare_fds(NULL, false, ws_sfp, false, false);
+	sg_unshare_ws_fd(ws_sfp, false);
 again:
 	ws_sfp = sg_find_sfp_by_fd(filp, new_ws_fd, rs_sfp, true);
 	if (IS_ERR(ws_sfp)) {
@@ -2386,7 +2708,7 @@ sg_fd_reshare(struct sg_fd *rs_sfp, int new_ws_fd)
  * First normalize want_rsv_sz to be >= sfp->sgat_elem_sz and
  * <= max_segment_size. Exit if that is the same as old size; otherwise
  * create a new candidate request of the new size. Then decide whether to
- * re-use an existing free list request (least buflen >= required size) or
+ * re-use an existing inactive request (least buflen >= required size) or
  * use the new candidate. If new one used, leave old one but it is no longer
  * the reserved request. Returns 0 on success, else a negated errno value.
  */
@@ -2404,12 +2726,15 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 	struct sg_device *sdp = sfp->parentdp;
 	struct xarray *xafp = &sfp->srp_arr;
 
+	if (unlikely(!xa_get_mark(&sfp->parentdp->sfp_arr, sfp->idx,
+				  SG_XA_FD_UNSHARED)))
+		return -EBUSY;	/* this fd can't be either side of share */
 	o_srp = sfp->rsv_srp;
 	if (!o_srp)
 		return -EPROTO;
 	new_sz = min_t(int, want_rsv_sz, sdp->max_sgat_sz);
 	new_sz = max_t(int, new_sz, sfp->sgat_elem_sz);
-	blen = o_srp->sgat_h.buflen;
+	blen = o_srp->sgatp->buflen;
 	SG_LOG(3, sfp, "%s: was=%d, ask=%d, new=%d (sgat_elem_sz=%d)\n",
 	       __func__, blen, want_rsv_sz, new_sz, sfp->sgat_elem_sz);
 	if (blen == new_sz)
@@ -2424,15 +2749,14 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 		res = -EPROTO;
 		goto fini;
 	}
-	if (SG_RS_ACTIVE(o_srp) || sfp->mmap_sz > 0) {
+	if (SG_RQ_ACTIVE(o_srp) || sfp->mmap_sz > 0) {
 		res = -EBUSY;
 		goto fini;
 	}
 	use_new_srp = true;
 	xa_for_each(xafp, idx, t_srp) {
-		if (t_srp != o_srp && new_sz <= t_srp->sgat_h.buflen &&
-		    !SG_RS_ACTIVE(t_srp)) {
-			/* good candidate on free list, use */
+		if (t_srp != o_srp && new_sz <= t_srp->sgatp->buflen &&
+		    !SG_RQ_ACTIVE(t_srp)) {
 			use_new_srp = false;
 			sfp->rsv_srp = t_srp;
 			break;
@@ -2447,7 +2771,7 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 		cxc_srp = __xa_cmpxchg(xafp, idx, o_srp, n_srp, GFP_ATOMIC);
 		if (o_srp == cxc_srp) {
 			sfp->rsv_srp = n_srp;
-			sg_rq_chg_state_force_ulck(n_srp, SG_RS_INACTIVE);
+			sg_rq_chg_state_force_ulck(n_srp, SG_RQ_INACTIVE);
 			/* don't bump inactives, since replaced an inactive */
 			xa_unlock_irqrestore(xafp, iflags);
 			SG_LOG(6, sfp, "%s: new rsv srp=0x%pK ++\n", __func__,
@@ -2496,6 +2820,27 @@ static int put_compat_request_table(struct compat_sg_req_info __user *o,
 }
 #endif
 
+static bool
+sg_any_persistent_orphans(struct sg_fd *sfp)
+{
+	if (test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm)) {
+		int num_waiting = atomic_read(&sfp->waiting);
+		unsigned long idx;
+		struct sg_request *srp;
+		struct xarray *xafp = &sfp->srp_arr;
+
+		if (num_waiting < 1)
+			return false;
+		xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_AWAIT) {
+			if (unlikely(!srp))
+				continue;
+			if (test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm))
+				return true;
+		}
+	}
+	return false;
+}
+
 /*
  * Processing of ioctl(SG_SET_GET_EXTENDED(SG_SEIM_CTL_FLAGS)) which is a set
  * of boolean flags. Access abbreviations: [rw], read-write; [ro], read-only;
@@ -2509,6 +2854,7 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 	const u32 c_flgs_rm = seip->ctl_flags_rd_mask;
 	const u32 c_flgs_val_in = seip->ctl_flags;
 	u32 c_flgs_val_out = c_flgs_val_in;
+	struct sg_fd *rs_sfp;
 	struct sg_device *sdp = sfp->parentdp;
 
 	/* TIME_IN_NS boolean, [raw] time in nanoseconds (def: millisecs) */
@@ -2531,6 +2877,13 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 		else
 			c_flgs_val_out &= ~SG_CTL_FLAGM_TAG_FOR_PACK_ID;
 	}
+	/* ORPHANS boolean, [ro] does this fd have any orphan requests? */
+	if (c_flgs_rm & SG_CTL_FLAGM_ORPHANS) {
+		if (sg_any_persistent_orphans(sfp))
+			c_flgs_val_out |= SG_CTL_FLAGM_ORPHANS;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_ORPHANS;
+	}
 	/* OTHER_OPENS boolean, [ro] any other sg open fds on this dev? */
 	if (c_flgs_rm & SG_CTL_FLAGM_OTHER_OPENS) {
 		if (atomic_read(&sdp->open_cnt) > 1)
@@ -2554,10 +2907,58 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 	 * a shared commands is inflight, waits a little while for it
 	 * to finish.
 	 */
-	if (c_flgs_wm & SG_CTL_FLAGM_UNSHARE)
+	if (c_flgs_wm & SG_CTL_FLAGM_UNSHARE) {
+		mutex_lock(&sfp->f_mutex);
 		sg_do_unshare(sfp, !!(c_flgs_val_in & SG_CTL_FLAGM_UNSHARE));
+		mutex_unlock(&sfp->f_mutex);
+	}
 	if (c_flgs_rm & SG_CTL_FLAGM_UNSHARE)
-		c_flgs_val_out &= ~SG_CTL_FLAGM_UNSHARE;   /* clear bit */
+		c_flgs_val_out &= ~SG_CTL_FLAGM_UNSHARE;	/* clear bit */
+	/* IS_SHARE boolean: [ro] true if fd may be read-side or write-side share */
+	if (c_flgs_rm & SG_CTL_FLAGM_IS_SHARE) {
+		if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_UNSHARED))
+			c_flgs_val_out &= ~SG_CTL_FLAGM_IS_SHARE;
+		else
+			c_flgs_val_out |= SG_CTL_FLAGM_IS_SHARE;
+	}
+	/* IS_READ_SIDE boolean: [ro] true if this fd may be a read-side share */
+	if (c_flgs_rm & SG_CTL_FLAGM_IS_READ_SIDE) {
+		if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE))
+			c_flgs_val_out |= SG_CTL_FLAGM_IS_READ_SIDE;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_IS_READ_SIDE;
+	}
+	/*
+	 * READ_SIDE_FINI boolean, [rbw] should be called by write-side; when
+	 * reading: read-side is finished, awaiting action by write-side;
+	 * when written: 1 --> write-side doesn't want to continue
+	 */
+	if (c_flgs_rm & SG_CTL_FLAGM_READ_SIDE_FINI) {
+		rs_sfp = sg_fd_share_ptr(sfp);
+		if (rs_sfp && rs_sfp->rsv_srp) {
+			struct sg_request *res_srp = rs_sfp->rsv_srp;
+
+			if (atomic_read(&res_srp->rq_st) == SG_RQ_SHR_SWAP)
+				c_flgs_val_out |= SG_CTL_FLAGM_READ_SIDE_FINI;
+			else
+				c_flgs_val_out &= ~SG_CTL_FLAGM_READ_SIDE_FINI;
+		} else {
+			c_flgs_val_out &= ~SG_CTL_FLAGM_READ_SIDE_FINI;
+		}
+	}
+	if (c_flgs_wm & SG_CTL_FLAGM_READ_SIDE_FINI) {
+		bool rs_fini_wm = !!(c_flgs_val_in & SG_CTL_FLAGM_READ_SIDE_FINI);
+
+		sg_change_after_read_side_rq(sfp, rs_fini_wm);
+	}
+	/* READ_SIDE_ERR boolean, [ro] share: read-side finished with error */
+	if (c_flgs_rm & SG_CTL_FLAGM_READ_SIDE_ERR) {
+		rs_sfp = sg_fd_share_ptr(sfp);
+		if (rs_sfp && test_bit(SG_FFD_READ_SIDE_ERR, rs_sfp->ffd_bm))
+			c_flgs_val_out |= SG_CTL_FLAGM_READ_SIDE_ERR;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_READ_SIDE_ERR;
+	}
 	/* NO_DURATION boolean, [rbw] */
 	if (c_flgs_rm & SG_CTL_FLAGM_NO_DURATION)
 		flg = test_bit(SG_FFD_NO_DURATION, sfp->ffd_bm);
@@ -2700,7 +3101,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 		}
 		/* if share then yield device number of (other) read-side */
 		if (s_rd_mask & SG_SEIM_SHARE_FD) {
-			struct sg_fd *sh_sfp = sg_fd_shared_ptr(sfp);
+			struct sg_fd *sh_sfp = sg_fd_share_ptr(sfp);
 
 			seip->share_fd = sh_sfp ? sh_sfp->parentdp->index :
 						   U32_MAX;
@@ -2717,7 +3118,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 		}
 		/* if share then yield device number of (other) write-side */
 		if (s_rd_mask & SG_SEIM_CHG_SHARE_FD) {
-			struct sg_fd *sh_sfp = sg_fd_shared_ptr(sfp);
+			struct sg_fd *sh_sfp = sg_fd_share_ptr(sfp);
 
 			seip->share_fd = sh_sfp ? sh_sfp->parentdp->index :
 						  U32_MAX;
@@ -2766,7 +3167,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 	}
 	if (s_rd_mask & SG_SEIM_RESERVED_SIZE)
 		seip->reserved_sz = (u32)min_t(int,
-					       sfp->rsv_srp->sgat_h.buflen,
+					       sfp->rsv_srp->sgatp->buflen,
 					       sdp->max_sgat_sz);
 	/* copy to user space if int or boolean read mask non-zero */
 	if (s_rd_mask || seip->ctl_flags_rd_mask) {
@@ -2863,27 +3264,37 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 
 	SG_LOG(6, sfp, "%s: cmd=0x%x, O_NONBLOCK=%d\n", __func__, cmd_in,
 	       !!(filp->f_flags & O_NONBLOCK));
-	if (unlikely(SG_IS_DETACHING(sdp)))
-		return -ENODEV;
 	sdev = sdp->device;
 
 	switch (cmd_in) {
 	case SG_IO:
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
 		return sg_ctl_sg_io(sdp, sfp, p);
 	case SG_IOSUBMIT:
 		SG_LOG(3, sfp, "%s:    SG_IOSUBMIT\n", __func__);
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
 		return sg_ctl_iosubmit(sfp, p);
 	case SG_IOSUBMIT_V3:
 		SG_LOG(3, sfp, "%s:    SG_IOSUBMIT_V3\n", __func__);
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
 		return sg_ctl_iosubmit_v3(sfp, p);
 	case SG_IORECEIVE:
 		SG_LOG(3, sfp, "%s:    SG_IORECEIVE\n", __func__);
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
 		return sg_ctl_ioreceive(sfp, p);
 	case SG_IORECEIVE_V3:
 		SG_LOG(3, sfp, "%s:    SG_IORECEIVE_V3\n", __func__);
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
 		return sg_ctl_ioreceive_v3(sfp, p);
 	case SG_IOABORT:
 		SG_LOG(3, sfp, "%s:    SG_IOABORT\n", __func__);
+		if (unlikely(SG_IS_DETACHING(sdp)))
+			return -ENODEV;
 		if (read_only)
 			return -EPERM;
 		mutex_lock(&sfp->f_mutex);
@@ -2949,7 +3360,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return res;
 	case SG_GET_RESERVED_SIZE:
 		mutex_lock(&sfp->f_mutex);
-		val = min_t(int, sfp->rsv_srp->sgat_h.buflen,
+		val = min_t(int, sfp->rsv_srp->sgatp->buflen,
 			    sdp->max_sgat_sz);
 		mutex_unlock(&sfp->f_mutex);
 		SG_LOG(3, sfp, "%s:    SG_GET_RESERVED_SIZE=%d\n",
@@ -3149,11 +3560,11 @@ sg_srp_q_blk_poll(struct sg_request *srp, struct request_queue *q, int loop_coun
 
 	num = (loop_count < 1) ? 1 : loop_count;
 	for (k = 0; k < num; ++k) {
-		if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
+		if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT)
 			return -ENODATA;
 		n = blk_poll(q, srp->cookie, loop_count < 0 /* spin if negative */);
 		if (n > 0)
-			return atomic_read(&srp->rq_st) == SG_RS_AWAIT_RCV;
+			return atomic_read(&srp->rq_st) == SG_RQ_AWAIT_RCV;
 		if (n < 0)
 			return n;
 	}
@@ -3183,7 +3594,7 @@ sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
 	xa_for_each(xafp, idx, srp) {
 		if ((srp->rq_flags & SGV4_FLAG_HIPRI) &&
 		    !test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm) &&
-		    atomic_read(&srp->rq_st) == SG_RS_INFLIGHT &&
+		    atomic_read(&srp->rq_st) == SG_RQ_INFLIGHT &&
 		    test_bit(SG_FRQ_ISSUED, srp->frq_bm)) {
 			xa_unlock_irqrestore(xafp, iflags);
 			n = sg_srp_q_blk_poll(srp, q, loop_count);
@@ -3299,7 +3710,7 @@ sg_vma_fault(struct vm_fault *vmf)
 		goto out_err;
 	}
 	mutex_lock(&sfp->f_mutex);
-	rsv_schp = &srp->sgat_h;
+	rsv_schp = srp->sgatp;
 	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= (unsigned int)rsv_schp->buflen) {
 		SG_LOG(1, sfp, "%s: offset[%lu] >= rsv.buflen\n", __func__,
@@ -3357,7 +3768,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	}
 	/* Check reserve request is inactive and has large enough buffer */
 	srp = sfp->rsv_srp;
-	if (SG_RS_ACTIVE(srp)) {
+	if (SG_RQ_ACTIVE(srp)) {
 		res = -EBUSY;
 		goto fini;
 	}
@@ -3425,7 +3836,7 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 static void
 sg_rq_end_io(struct request *rqq, blk_status_t status)
 {
-	enum sg_rq_state rqq_state = SG_RS_AWAIT_RCV;
+	enum sg_rq_state rqq_state = SG_RQ_AWAIT_RCV;
 	int a_resid, slen;
 	u32 rq_result;
 	unsigned long iflags;
@@ -3452,18 +3863,18 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 			srp->in_resid = a_resid;
 		}
 	}
+	if (test_bit(SG_FRQ_ABORTING, srp->frq_bm) && rq_result == 0)
+		srp->rq_result |= (DRIVER_HARD << 24);
 
-	SG_LOG(6, sfp, "%s: pack_id=%d, res=0x%x\n", __func__, srp->pack_id,
-	       srp->rq_result);
+	SG_LOG(6, sfp, "%s: pack_id=%d, tag=%d, res=0x%x\n", __func__,
+	       srp->pack_id, srp->tag, srp->rq_result);
 	if (srp->start_ns > 0)	/* zero only when SG_FFD_NO_DURATION is set */
 		srp->duration = sg_calc_rq_dur(srp, test_bit(SG_FFD_TIME_IN_NS,
 							     sfp->ffd_bm));
 	if (unlikely((rq_result & SG_ML_RESULT_MSK) && slen > 0 &&
 		     test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm))) {
-		u32 scsi_stat = rq_result & 0xff;
-
-		if (scsi_stat == SAM_STAT_CHECK_CONDITION ||
-		    scsi_stat == SAM_STAT_COMMAND_TERMINATED)
+		if ((rq_result & 0xff) == SAM_STAT_CHECK_CONDITION ||
+		    (rq_result & 0xff) == SAM_STAT_COMMAND_TERMINATED)
 			__scsi_print_sense(sdp->device, __func__, scsi_rp->sense, slen);
 	}
 	if (slen > 0) {
@@ -3491,10 +3902,10 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	srp->sense_len = slen;
 	if (unlikely(test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm))) {
 		if (test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm)) {
-			clear_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
+			__clear_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
 		} else {
-			rqq_state = SG_RS_BUSY;
-			set_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm);
+			rqq_state = SG_RQ_BUSY;
+			__set_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm);
 		}
 	}
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
@@ -3522,7 +3933,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	scsi_req_free_cmd(scsi_rp);
 	blk_put_request(rqq);
 
-	if (likely(rqq_state == SG_RS_AWAIT_RCV)) {
+	if (likely(rqq_state == SG_RQ_AWAIT_RCV)) {
 		/* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
 		if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
 			wake_up_interruptible(&sfp->read_wait);
@@ -3649,7 +4060,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 		goto cdev_add_err;
 
 	sdp->cdev = cdev;
-	if (sg_sysfs_valid) {
+	if (likely(sg_sysfs_valid)) {
 		struct device *sg_class_member;
 
 		sg_class_member = device_create(sg_sysfs_class, cl_dev->parent,
@@ -3663,7 +4074,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 		}
 		error = sysfs_create_link(&scsidp->sdev_gendev.kobj,
 					  &sg_class_member->kobj, "generic");
-		if (error)
+		if (unlikely(error))
 			pr_err("%s: unable to make symlink 'generic' back "
 			       "to sg%d\n", __func__, sdp->index);
 	} else
@@ -3674,7 +4085,6 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 		    "type %d\n", sdp->index, scsidp->type);
 
 	dev_set_drvdata(cl_dev, sdp);
-
 	return 0;
 
 cdev_add_err:
@@ -3694,7 +4104,7 @@ static void
 sg_device_destroy(struct kref *kref)
 {
 	struct sg_device *sdp = container_of(kref, struct sg_device, d_ref);
-	unsigned long flags;
+	unsigned long iflags;
 
 	SCSI_LOG_TIMEOUT(1, pr_info("[tid=%d] %s: sdp idx=%d, sdp=0x%pK --\n",
 				    (current ? current->pid : -1), __func__,
@@ -3706,9 +4116,9 @@ sg_device_destroy(struct kref *kref)
 	 */
 
 	xa_destroy(&sdp->sfp_arr);
-	write_lock_irqsave(&sg_index_lock, flags);
+	write_lock_irqsave(&sg_index_lock, iflags);
 	idr_remove(&sg_index_idr, sdp->index);
-	write_unlock_irqrestore(&sg_index_lock, flags);
+	write_unlock_irqrestore(&sg_index_lock, iflags);
 
 	put_disk(sdp->disk);
 	kfree(sdp);
@@ -3962,7 +4372,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		kfree(long_cmdp);
 		return PTR_ERR(rqq);
 	}
-	/* current sg_request protected by SG_RS_BUSY state */
+	/* current sg_request protected by SG_RQ_BUSY state */
 	scsi_rp = scsi_req(rqq);
 	WRITE_ONCE(srp->rqq, rqq);
 	if (rq_flags & SGV4_FLAG_YIELD_TAG)
@@ -3981,15 +4391,15 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	scsi_rp->cmd_len = cwrp->cmd_len;
 	srp->cmd_opcode = scsi_rp->cmd[0];
 	us_xfer = !(rq_flags & (SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO));
-	assign_bit(SG_FRQ_NO_US_XFER, srp->frq_bm, !us_xfer);
+	assign_bit(SG_FRQ_US_XFER, srp->frq_bm, us_xfer);
 	reserved = (sfp->rsv_srp == srp);
 	rqq->end_io_data = srp;
 	scsi_rp->retries = SG_DEFAULT_RETRIES;
-	req_schp = &srp->sgat_h;
+	req_schp = srp->sgatp;
 
 	if (dxfer_len <= 0 || dxfer_dir == SG_DXFER_NONE) {
 		SG_LOG(4, sfp, "%s: no data xfer [0x%pK]\n", __func__, srp);
-		set_bit(SG_FRQ_NO_US_XFER, srp->frq_bm);
+		clear_bit(SG_FRQ_US_XFER, srp->frq_bm);
 		goto fini;	/* path of reqs with no din nor dout */
 	} else if ((rq_flags & SG_FLAG_DIRECT_IO) && iov_count == 0 &&
 		   !sdp->device->host->unchecked_isa_dma &&
@@ -4057,8 +4467,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	} else {
 		srp->bio = rqq->bio;
 	}
-	SG_LOG((res ? 1 : 4), sfp, "%s: %s res=%d [0x%pK]\n", __func__, cp,
-	       res, srp);
+	SG_LOG((res ? 1 : 4), sfp, "%s: %s %s res=%d [0x%pK]\n", __func__,
+	       sg_shr_str(srp->sh_var, false), cp, res, srp);
 	return res;
 }
 
@@ -4092,7 +4502,7 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 		blk_put_request(rqq);
 	}
 	if (srp->bio) {
-		bool us_xfer = !test_bit(SG_FRQ_NO_US_XFER, srp->frq_bm);
+		bool us_xfer = test_bit(SG_FRQ_US_XFER, srp->frq_bm);
 		struct bio *bio = srp->bio;
 
 		srp->bio = NULL;
@@ -4118,7 +4528,7 @@ sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
 	gfp_t mask_ap = GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
 	gfp_t mask_kz = GFP_ATOMIC | __GFP_NOWARN;
 	struct sg_device *sdp = sfp->parentdp;
-	struct sg_scatter_hold *schp = &srp->sgat_h;
+	struct sg_scatter_hold *schp = srp->sgatp;
 	struct page **pgp;
 
 	if (unlikely(minlen <= 0)) {
@@ -4234,7 +4644,7 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 {
 	int k, num, res;
 	struct page *pgp;
-	struct sg_scatter_hold *schp = &srp->sgat_h;
+	struct sg_scatter_hold *schp = srp->sgatp;
 
 	SG_LOG(4, srp->parentfp, "%s: num_xfer=%d\n", __func__, num_xfer);
 	if (unlikely(!outp || num_xfer <= 0))
@@ -4271,13 +4681,13 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
  * SG_PACK_ID_WILDCARD and SG_TAG_WILDCARD are -1 and that case is typically
  * the fast path. This function is only used in the non-blocking cases.
  * Returns pointer to (first) matching sg_request or NULL. If found,
- * sg_request state is moved from SG_RS_AWAIT_RCV to SG_RS_BUSY.
+ * sg_request state is moved from SG_RQ_AWAIT_RCV to SG_RQ_BUSY.
  */
 static struct sg_request *
 sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 {
 	__maybe_unused bool is_bad_st = false;
-	__maybe_unused enum sg_rq_state bad_sr_st = SG_RS_INACTIVE;
+	__maybe_unused enum sg_rq_state bad_sr_st = SG_RQ_INACTIVE;
 	bool search_for_1 = (id != SG_TAG_WILDCARD);
 	bool second = false;
 	enum sg_rq_state sr_st;
@@ -4315,8 +4725,8 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 			}
 			sr_st = atomic_read(&srp->rq_st);
 			switch (sr_st) {
-			case SG_RS_AWAIT_RCV:
-				res = sg_rq_chg_state(srp, sr_st, SG_RS_BUSY);
+			case SG_RQ_AWAIT_RCV:
+				res = sg_rq_chg_state(srp, sr_st, SG_RQ_BUSY);
 				if (likely(res == 0))
 					goto good;
 				/* else another caller got it, move on */
@@ -4325,7 +4735,9 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 					bad_sr_st = atomic_read(&srp->rq_st);
 				}
 				break;
-			case SG_RS_INFLIGHT:
+			case SG_RQ_SHR_IN_WS:
+				goto good;
+			case SG_RQ_INFLIGHT:
 				break;
 			default:
 				if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
@@ -4358,13 +4770,13 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
 			if (test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
 				continue;
-			res = sg_rq_chg_state(srp, SG_RS_AWAIT_RCV, SG_RS_BUSY);
+			res = sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
 			if (likely(res == 0)) {
 				WRITE_ONCE(sfp->low_await_idx, idx + 1);
 				goto good;
 			}
 #if IS_ENABLED(SG_LOG_ACTIVE)
-			sg_rq_state_fail_msg(sfp, SG_RS_AWAIT_RCV, SG_RS_BUSY, __func__);
+			sg_rq_state_fail_msg(sfp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY, __func__);
 #endif
 		}
 		if (!srp && !second && s_idx > 0) {
@@ -4414,9 +4826,11 @@ sg_mk_srp(struct sg_fd *sfp, bool first)
 	else
 		srp = kzalloc(sizeof(*srp), gfp | GFP_ATOMIC);
 	if (srp) {
-		atomic_set(&srp->rq_st, SG_RS_BUSY);
+		atomic_set(&srp->rq_st, SG_RQ_BUSY);
+		srp->sh_var = SG_SHR_NONE;
 		srp->parentfp = sfp;
 		srp->tag = SG_TAG_WILDCARD;
+		srp->sgatp = &srp->sgat_h; /* only write-side share changes sgatp */
 		return srp;
 	} else {
 		return ERR_PTR(-ENOMEM);
@@ -4445,7 +4859,7 @@ sg_mk_srp_sgat(struct sg_fd *sfp, bool first, int db_len)
  * Irrespective of the given reserve request size, the minimum size requested
  * will be PAGE_SIZE (often 4096 bytes). Returns a pointer to reserve object or
  * a negated errno value twisted by ERR_PTR() macro. The actual number of bytes
- * allocated (maybe less than buflen) is in srp->sgat_h.buflen . Note that this
+ * allocated (maybe less than buflen) is in srp->sgatp->buflen . Note that this
  * function is only called in contexts where locking is not required.
  */
 static struct sg_request *
@@ -4482,26 +4896,125 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
 /*
  * Setup an active request (soon to carry a SCSI command) to the current file
  * descriptor by creating a new one or re-using a request from the free
- * list (fl). If successful returns a valid pointer in SG_RS_BUSY state. On
+ * list (fl). If successful returns a valid pointer in SG_RQ_BUSY state. On
  * failure returns a negated errno value twisted by ERR_PTR() macro.
  */
 static struct sg_request *
-sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
+sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 {
 	bool act_empty = false;
-	bool found = false;
+	bool allow_rsv = true;
 	bool mk_new_srp = true;
+	bool ws_rq = false;
 	bool try_harder = false;
 	bool second = false;
 	bool has_inactive = false;
-	int l_used_idx;
+	int res, l_used_idx;
 	u32 sum_dlen;
 	unsigned long idx, s_idx, end_idx, iflags;
+	enum sg_rq_state sr_st;
+	enum sg_rq_state rs_sr_st = SG_RQ_INACTIVE;
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_request *r_srp = NULL;	/* request to return */
 	struct sg_request *low_srp = NULL;
+	__maybe_unused struct sg_request *rsv_srp;
+	struct sg_request *rs_rsv_srp = NULL;
+	struct sg_fd *rs_sfp = NULL;
 	struct xarray *xafp = &fp->srp_arr;
 	__maybe_unused const char *cp;
+	char b[48];
+
+	b[0] = '\0';
+	rsv_srp = fp->rsv_srp;
+
+	switch (sh_var) {
+	case SG_SHR_NONE:
+	case SG_SHR_WS_NOT_SRQ:
+		break;
+	case SG_SHR_RS_RQ:
+		sr_st = atomic_read(&rsv_srp->rq_st);
+		if (sr_st == SG_RQ_INACTIVE) {
+			res = sg_rq_chg_state(rsv_srp, sr_st, SG_RQ_BUSY);
+			if (likely(res == 0)) {
+				r_srp = rsv_srp;
+				mk_new_srp = false;
+				cp = "rs_rq";
+				goto good_fini;
+			}
+		}
+		r_srp = ERR_PTR(-EBUSY);
+		break;
+	case SG_SHR_RS_NOT_SRQ:
+		allow_rsv = false;
+		break;
+	case SG_SHR_WS_RQ:
+		rs_sfp = sg_fd_share_ptr(fp);
+		if (!sg_fd_is_shared(fp)) {
+			r_srp = ERR_PTR(-EPROTO);
+			break;
+		}
+		/*
+		 * Contention here may be with another potential write-side trying
+		 * to pair with this read-side. The loser will receive an
+		 * EADDRINUSE errno. The winner advances read-side's rq_state:
+		 *     SG_RQ_SHR_SWAP --> SG_RQ_SHR_IN_WS
+		 */
+		rs_rsv_srp = rs_sfp->rsv_srp;
+		rs_sr_st = atomic_read(&rs_rsv_srp->rq_st);
+		switch (rs_sr_st) {
+		case SG_RQ_AWAIT_RCV:
+			if (rs_rsv_srp->rq_result & SG_ML_RESULT_MSK) {
+				r_srp = ERR_PTR(-ENOSTR);
+				break;
+			}
+			fallthrough;
+		case SG_RQ_SHR_SWAP:
+			ws_rq = true;
+			if (rs_sr_st == SG_RQ_AWAIT_RCV)
+				break;
+			res = sg_rq_chg_state(rs_rsv_srp, rs_sr_st, SG_RQ_SHR_IN_WS);
+			if (unlikely(res))
+				r_srp = ERR_PTR(-EADDRINUSE);
+			break;
+		case SG_RQ_INFLIGHT:
+		case SG_RQ_BUSY:
+			r_srp = ERR_PTR(-EBUSY);
+			break;
+		case SG_RQ_INACTIVE:
+			r_srp = ERR_PTR(-EADDRNOTAVAIL);
+			break;
+		case SG_RQ_SHR_IN_WS:
+		default:
+			r_srp = ERR_PTR(-EADDRINUSE);
+			break;
+		}
+		break;
+	}
+	if (IS_ERR(r_srp)) {
+		if (PTR_ERR(r_srp) == -EBUSY)
+			goto err_out2;
+		if (sh_var == SG_SHR_RS_RQ)
+			snprintf(b, sizeof(b), "SG_SHR_RS_RQ --> sr_st=%s",
+				 sg_rq_st_str(sr_st, false));
+		else if (sh_var == SG_SHR_WS_RQ && rs_sfp)
+			snprintf(b, sizeof(b), "SG_SHR_WS_RQ-->rs_sr_st=%s",
+				 sg_rq_st_str(rs_sr_st, false));
+		else
+			snprintf(b, sizeof(b), "sh_var=%s",
+				 sg_shr_str(sh_var, false));
+		goto err_out;
+	}
+	cp = "";
+
+	if (ws_rq) {	/* write-side dlen may be smaller than read-side's dlen */
+		if (dxfr_len > rs_rsv_srp->sgatp->dlen) {
+			SG_LOG(4, fp, "%s: write-side dlen [%d] > read-side dlen\n",
+			       __func__, dxfr_len);
+			r_srp = ERR_PTR(-E2BIG);
+			goto err_out;
+		}
+		dxfr_len = 0;	/* any srp for write-side will do, pick smallest */
+	}
 
 start_again:
 	cp = "";
@@ -4516,8 +5029,8 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 		if (l_used_idx >= 0 && xa_get_mark(xafp, s_idx, SG_XA_RQ_INACTIVE)) {
 			r_srp = xa_load(xafp, s_idx);
 			if (r_srp && r_srp->sgat_h.buflen <= SG_DEF_SECTOR_SZ) {
-				if (sg_rq_chg_state(r_srp, SG_RS_INACTIVE, SG_RS_BUSY) == 0) {
-					found = true;
+				if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY) == 0) {
+					mk_new_srp = false;
 					atomic_dec(&fp->inactives);
 					goto have_existing;
 				}
@@ -4525,6 +5038,8 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 		}
 		xa_for_each_marked(xafp, idx, r_srp, SG_XA_RQ_INACTIVE) {
 			has_inactive = true;
+			if (!allow_rsv && rsv_srp == r_srp)
+				continue;
 			if (!low_srp && dxfr_len < SG_DEF_SECTOR_SZ) {
 				low_srp = r_srp;
 				break;
@@ -4533,11 +5048,11 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 		/* If dxfr_len is small, use lowest inactive request */
 		if (low_srp) {
 			r_srp = low_srp;
-			if (sg_rq_chg_state(r_srp, SG_RS_INACTIVE, SG_RS_BUSY))
+			if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
 				goto start_again; /* gone to another thread */
 			atomic_dec(&fp->inactives);
-			cp = "toward end of srp_arr";
-			found = true;
+			cp = "lowest inactive in srp_arr";
+			mk_new_srp = false;
 		}
 	} else {
 		l_used_idx = READ_ONCE(fp->low_used_idx);
@@ -4548,13 +5063,15 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 		for (r_srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE);
 		     r_srp;
 		     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
+			if (!allow_rsv && rsv_srp == r_srp)
+				continue;
 			if (r_srp->sgat_h.buflen >= dxfr_len) {
-				if (sg_rq_chg_state(r_srp, SG_RS_INACTIVE, SG_RS_BUSY))
+				if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
 					continue;
 				atomic_dec(&fp->inactives);
 				WRITE_ONCE(fp->low_used_idx, idx + 1);
 				cp = "near front of srp_arr";
-				found = true;
+				mk_new_srp = false;
 				break;
 			}
 		}
@@ -4568,15 +5085,14 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 		}
 	}
 have_existing:
-	if (found) {
+	if (!mk_new_srp) {
 		r_srp->in_resid = 0;
 		r_srp->rq_info = 0;
 		r_srp->sense_len = 0;
-		mk_new_srp = false;
-	} else {
-		mk_new_srp = true;
 	}
-	if (mk_new_srp) {
+
+good_fini:
+	if (mk_new_srp) {	/* Need new sg_request object */
 		bool allow_cmd_q = test_bit(SG_FFD_CMD_Q, fp->ffd_bm);
 		int res;
 		u32 n_idx;
@@ -4608,51 +5124,74 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 		res = __xa_alloc(xafp, &n_idx, r_srp, xa_limit_32b, GFP_KERNEL);
 		xa_unlock_irqrestore(xafp, iflags);
 		if (res < 0) {
-			SG_LOG(1, fp, "%s: xa_alloc() failed, errno=%d\n",
-			       __func__,  -res);
 			sg_remove_sgat(r_srp);
 			kfree(r_srp);
 			r_srp = ERR_PTR(-EPROTOTYPE);
+			SG_LOG(1, fp, "%s: xa_alloc() failed, errno=%d\n",
+			       __func__,  -res);
 			goto fini;
 		}
 		idx = n_idx;
 		r_srp->rq_idx = idx;
 		r_srp->parentfp = fp;
+		sg_rq_chg_state_force(r_srp, SG_RQ_BUSY);
 		SG_LOG(4, fp, "%s: mk_new_srp=0x%pK ++\n", __func__, r_srp);
 	}
+	/* following copes with unlikely case where frq_bm > one ulong */
 	WRITE_ONCE(r_srp->frq_bm[0], cwrp->frq_bm[0]);	/* assumes <= 32 req flags */
-	r_srp->sgat_h.dlen = dxfr_len;/* must be <= r_srp->sgat_h.buflen */
+	r_srp->sgatp->dlen = dxfr_len;/* must be <= r_srp->sgat_h.buflen */
+	r_srp->sh_var = sh_var;
 	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
 fini:
 	/* If setup stalls (e.g. blk_get_request()) debug shows 'elap=1 ns' */
 	if (test_bit(SG_FFD_TIME_IN_NS, fp->ffd_bm))
 		r_srp->start_ns = S64_MAX;
-	if (IS_ERR(r_srp))
-		SG_LOG(1, fp, "%s: err=%ld\n", __func__, PTR_ERR(r_srp));
+	if (ws_rq && rs_rsv_srp) {
+		rs_sfp->ws_srp = r_srp;
+		/* write-side "shares" the read-side reserve request's data buffer */
+		r_srp->sgatp = &rs_rsv_srp->sgat_h;
+	} else if (sh_var == SG_SHR_RS_RQ && test_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm))
+		clear_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm);
+err_out:
+	if (IS_ERR(r_srp) && b[0])
+		SG_LOG(1, fp, "%s: bad %s\n", __func__, b);
 	if (!IS_ERR(r_srp))
 		SG_LOG(4, fp, "%s: %s %sr_srp=0x%pK\n", __func__, cp,
 		       ((r_srp == fp->rsv_srp) ? "[rsv] " : ""), r_srp);
+err_out2:
 	return r_srp;
 }
 
 /*
- * Moves a completed sg_request object to the free list and sets it to
- * SG_RS_INACTIVE which makes it available for re-use. Requests with no data
- * associated are appended to the tail of the free list while other requests
- * are prepended to the head of the free list.
+ * Sets srp to SG_RQ_INACTIVE unless it was in SG_RQ_SHR_SWAP state. Also
+ * change the asociated xarray entry flags to be consistent with
+ * SG_RQ_INACTIVE. Since this function can be called from many contexts,
+ * then assume no xa locks held.
+ * The state machine should insure that two threads should never race here.
  */
 static void
 sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 {
+	enum sg_rq_state sr_st;
 	u8 *sbp;
 
 	if (WARN_ON(!sfp || !srp))
 		return;
 	sbp = srp->sense_bp;
 	srp->sense_bp = NULL;
-	WRITE_ONCE(srp->frq_bm[0], 0);
-	sg_rq_chg_state_force(srp, SG_RS_INACTIVE);
-	atomic_inc(&sfp->inactives);
+	sr_st = atomic_read(&srp->rq_st);
+	if (sr_st != SG_RQ_SHR_SWAP) { /* mark _BUSY then _INACTIVE at end */
+		/*
+		 * Can be called from many contexts and it is hard to know
+		 * whether xa locks held. So assume not.
+		 */
+		sg_rq_chg_state_force(srp, SG_RQ_INACTIVE);
+		atomic_inc(&sfp->inactives);
+		WRITE_ONCE(srp->frq_bm[0], 0);
+		srp->tag = SG_TAG_WILDCARD;
+		srp->in_resid = 0;
+		srp->rq_info = 0;
+	}
 	/* maybe orphaned req, thus never read */
 	if (sbp)
 		mempool_free(sbp, sg_sense_pool);
@@ -4722,14 +5261,20 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 			kfree(sfp);
 			return ERR_PTR(err);
 		}
-		if (srp->sgat_h.buflen < rbuf_len) {
+		if (srp->sgatp->buflen < rbuf_len) {
 			reduced = true;
 			SG_LOG(2, sfp,
 			       "%s: reserve reduced from %d to buflen=%d\n",
-			       __func__, rbuf_len, srp->sgat_h.buflen);
+			       __func__, rbuf_len, srp->sgatp->buflen);
 		}
 		xa_lock_irqsave(xafp, iflags);
 		res = __xa_alloc(xafp, &idx, srp, xa_limit_32b, GFP_ATOMIC);
+		if (!res) {
+			srp->rq_idx = idx;
+			srp->parentfp = sfp;
+			sg_rq_chg_state_force_ulck(srp, SG_RQ_INACTIVE);
+			atomic_inc(&sfp->inactives);
+		}
 		xa_unlock_irqrestore(xafp, iflags);
 		if (res < 0) {
 			SG_LOG(1, sfp, "%s: xa_alloc(srp) bad, errno=%d\n",
@@ -4739,10 +5284,6 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 			kfree(sfp);
 			return ERR_PTR(-EPROTOTYPE);
 		}
-		srp->rq_idx = idx;
-		srp->parentfp = sfp;
-		sg_rq_chg_state_force(srp, SG_RS_INACTIVE);
-		atomic_inc(&sfp->inactives);
 	}
 	if (!reduced) {
 		SG_LOG(4, sfp, "%s: built reserve buflen=%d\n", __func__,
@@ -4802,7 +5343,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	xa_for_each(xafp, idx, srp) {
 		if (!xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE))
 			sg_finish_scsi_blk_rq(srp);
-		if (srp->sgat_h.buflen > 0)
+		if (srp->sgatp->buflen > 0)
 			sg_remove_sgat(srp);
 		if (srp->sense_bp) {
 			mempool_free(srp->sense_bp, sg_sense_pool);
@@ -4842,29 +5383,14 @@ static void
 sg_remove_sfp(struct kref *kref)
 {
 	struct sg_fd *sfp = container_of(kref, struct sg_fd, f_ref);
-	struct sg_device *sdp = sfp->parentdp;
-	struct xarray *xap = &sdp->sfp_arr;
-
-	if (!xa_get_mark(xap, sfp->idx, SG_XA_FD_UNSHARED)) {
-		struct sg_fd *o_sfp;
-
-		o_sfp = sg_fd_shared_ptr(sfp);
-		if (o_sfp && !test_bit(SG_FFD_RELEASE, o_sfp->ffd_bm) &&
-		    !xa_get_mark(xap, sfp->idx, SG_XA_FD_UNSHARED)) {
-			mutex_lock(&o_sfp->f_mutex);
-			sg_remove_sfp_share
-				(sfp, xa_get_mark(xap, sfp->idx,
-						  SG_XA_FD_RS_SHARE));
-			mutex_unlock(&o_sfp->f_mutex);
-		}
-	}
+
 	INIT_WORK(&sfp->ew_fd.work, sg_remove_sfp_usercontext);
 	schedule_work(&sfp->ew_fd.work);
 }
 
-/* must be called with sg_index_lock held */
 static struct sg_device *
 sg_lookup_dev(int dev)
+	__must_hold(&sg_index_lock)
 {
 	return idr_find(&sg_index_idr, dev);
 }
@@ -4899,14 +5425,37 @@ static const char *
 sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
 {
 	switch (rq_st) {	/* request state */
-	case SG_RS_INACTIVE:
+	case SG_RQ_INACTIVE:
 		return long_str ? "inactive" :  "ina";
-	case SG_RS_INFLIGHT:
+	case SG_RQ_INFLIGHT:
 		return long_str ? "inflight" : "act";
-	case SG_RS_AWAIT_RCV:
+	case SG_RQ_AWAIT_RCV:
 		return long_str ? "await_receive" : "rcv";
-	case SG_RS_BUSY:
+	case SG_RQ_BUSY:
 		return long_str ? "busy" : "bsy";
+	case SG_RQ_SHR_SWAP:	/* only an active read-side has this */
+		return long_str ? "share swap" : "s_wp";
+	case SG_RQ_SHR_IN_WS:	/* only an active read-side has this */
+		return long_str ? "share write-side active" : "ws_a";
+	default:
+		return long_str ? "unknown" : "unk";
+	}
+}
+
+static const char *
+sg_shr_str(enum sg_shr_var sh_var, bool long_str)
+{
+	switch (sh_var) {	/* share variety of request */
+	case SG_SHR_NONE:
+		return long_str ? "none" :  "-";
+	case SG_SHR_RS_RQ:
+		return long_str ? "read-side request" :  "rs_rq";
+	case SG_SHR_RS_NOT_SRQ:
+		return long_str ? "read-side, not share request" :  "rs_nsh";
+	case SG_SHR_WS_RQ:
+		return long_str ? "write-side request" :  "ws_rq";
+	case SG_SHR_WS_NOT_SRQ:
+		return long_str ? "write-side, not share request" :  "ws_nsh";
 	default:
 		return long_str ? "unknown" : "unk";
 	}
@@ -4919,6 +5468,12 @@ sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
 {
 	return "";
 }
+
+static const char *
+sg_shr_str(enum sg_shr_var sh_var, bool long_str)
+{
+	return "";
+}
 #endif
 
 #if IS_ENABLED(SG_PROC_OR_DEBUG_FS)
@@ -4935,8 +5490,8 @@ static struct sg_dfs_context_t {
 } sg_dfs_cxt;
 
 struct sg_proc_deviter {
-	loff_t	index;
-	size_t	max;
+	loff_t index;
+	size_t max;
 	int fd_index;
 };
 
@@ -4963,7 +5518,7 @@ dev_seq_start(struct seq_file *s, loff_t *pos)
 
 	it->index = *pos;
 	it->max = sg_last_dev();
-	if (it->index >= it->max)
+	if (it->index >= (int)it->max)
 		return NULL;
 	return it;
 }
@@ -5040,7 +5595,7 @@ sg_proc_write_dressz(struct file *filp, const char __user *buffer,
 		sg_big_buff = k;
 		return count;
 	}
-	return -ERANGE;
+	return -EDOM;
 }
 
 static int
@@ -5074,7 +5629,7 @@ sg_proc_seq_show_dev(struct seq_file *s, void *v)
 		scsidp = sdp->device;
 		seq_printf(s, "%d\t%d\t%d\t%llu\t%d\t%d\t%d\t%d\t%d\n",
 			      scsidp->host->host_no, scsidp->channel,
-			      scsidp->id, scsidp->lun, (int) scsidp->type,
+			      scsidp->id, scsidp->lun, (int)scsidp->type,
 			      1,
 			      (int) scsidp->queue_depth,
 			      (int) scsi_device_busy(scsidp),
@@ -5133,8 +5688,8 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, char *obp,
 	rq_st = atomic_read(&srp->rq_st);
 	dur = sg_get_dur(srp, &rq_st, t_in_ns, &is_dur);
 	n += scnprintf(obp + n, len - n, "%s%s: dlen=%d/%d id=%d", cp,
-		       sg_rq_st_str(rq_st, false), srp->sgat_h.dlen,
-		       srp->sgat_h.buflen, (int)srp->pack_id);
+		       sg_rq_st_str(rq_st, false), srp->sgatp->dlen,
+		       srp->sgatp->buflen, (int)srp->pack_id);
 	if (is_dur)	/* cmd/req has completed, waiting for ... */
 		n += scnprintf(obp + n, len - n, " dur=%u%s", dur, tp);
 	else if (dur < U32_MAX) { /* in-flight or busy (so ongoing) */
@@ -5145,9 +5700,12 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, char *obp,
 		n += scnprintf(obp + n, len - n, " t_o/elap=%us/%u%s",
 			       to / 1000, dur, tp);
 	}
+	if (srp->sh_var != SG_SHR_NONE)
+		n += scnprintf(obp + n, len - n, " shr=%s",
+			       sg_shr_str(srp->sh_var, false));
 	cp = (srp->rq_flags & SGV4_FLAG_HIPRI) ? "hipri " : "";
 	n += scnprintf(obp + n, len - n, " sgat=%d %sop=0x%02x\n",
-		       srp->sgat_h.num_sgat, cp, srp->cmd_opcode);
+		       srp->sgatp->num_sgat, cp, srp->cmd_opcode);
 	return n;
 }
 
@@ -5160,8 +5718,15 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 	int n = 0;
 	int to, k;
 	unsigned long iflags;
+	const char *cp;
 	struct sg_request *srp;
+	struct sg_device *sdp = fp->parentdp;
 
+	if (xa_get_mark(&sdp->sfp_arr, fp->idx, SG_XA_FD_UNSHARED))
+		cp = "";
+	else
+		cp = xa_get_mark(&sdp->sfp_arr, fp->idx, SG_XA_FD_RS_SHARE) ?
+			" shr_rs" : " shr_ws";
 	/* sgat=-1 means unavailable */
 	to = (fp->timeout >= 0) ? jiffies_to_msecs(fp->timeout) : -999;
 	if (to < 0)
@@ -5171,8 +5736,8 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		n += scnprintf(obp + n, len - n, "timeout=%dms rs", to);
 	else
 		n += scnprintf(obp + n, len - n, "timeout=%ds rs", to / 1000);
-	n += scnprintf(obp + n, len - n, "v_buflen=%d idx=%lu\n   cmd_q=%d ",
-		       fp->rsv_srp->sgat_h.buflen, idx,
+	n += scnprintf(obp + n, len - n, "v_buflen=%d%s idx=%lu\n   cmd_q=%d ",
+		       fp->rsv_srp->sgatp->buflen, cp, idx,
 		       (int)test_bit(SG_FFD_CMD_Q, fp->ffd_bm));
 	n += scnprintf(obp + n, len - n,
 		       "f_packid=%d k_orphan=%d ffd_bm=0x%lx\n",
@@ -5311,10 +5876,10 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v, bool reduced)
 	if (!xa_empty(&sdp->sfp_arr)) {
 		found = true;
 		disk_name = (sdp->disk ? sdp->disk->disk_name : "?_?");
-		if (SG_IS_DETACHING(sdp))
+		if (SG_IS_DETACHING(sdp)) {
 			snprintf(b1, sizeof(b1), " >>> device=%s  %s\n",
 				 disk_name, "detaching pending close\n");
-		else if (sdp->device) {
+		} else if (sdp->device) {
 			n = sg_proc_debug_sdev(sdp, bp, bp_len, fdi_p,
 					       reduced);
 			if (n >= bp_len - 1) {
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 5c8a7c2c3191..272001a69d01 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -112,6 +112,9 @@ typedef struct sg_io_hdr {
 #define SGV4_FLAG_Q_AT_HEAD SG_FLAG_Q_AT_HEAD
 #define SGV4_FLAG_IMMED 0x400 /* for polling with SG_IOR, ignored in SG_IOS */
 #define SGV4_FLAG_HIPRI 0x800 /* request will use blk_poll to complete */
+#define SGV4_FLAG_DEV_SCOPE 0x1000 /* permit SG_IOABORT to have wider scope */
+#define SGV4_FLAG_SHARE 0x2000	/* share IO buffer; needs SG_SEIM_SHARE_FD */
+#define SGV4_FLAG_NO_DXFER SG_FLAG_NO_DXFER /* but keep dev<-->kernel xfr */
 
 /* Output (potentially OR-ed together) in v3::info or v4::info field */
 #define SG_INFO_OK_MASK 0x1
@@ -184,7 +187,12 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 #define SG_CTL_FLAGM_OTHER_OPENS 0x4	/* rd: other sg fd_s on this dev */
 #define SG_CTL_FLAGM_ORPHANS	0x8	/* rd: orphaned requests on this fd */
 #define SG_CTL_FLAGM_Q_TAIL	0x10	/* used for future cmds on this fd */
+#define SG_CTL_FLAGM_IS_SHARE	0x20	/* rd: fd is read-side or write-side share */
+#define SG_CTL_FLAGM_IS_READ_SIDE 0x40	/* rd: this fd is read-side share */
 #define SG_CTL_FLAGM_UNSHARE	0x80	/* undo share after inflight cmd */
+/* rd> 1: read-side finished 0: not; wr> 1: finish share post read-side */
+#define SG_CTL_FLAGM_READ_SIDE_FINI 0x100 /* wr> 0: setup for repeat write-side req */
+#define SG_CTL_FLAGM_READ_SIDE_ERR 0x200 /* rd: sharing, read-side got error */
 #define SG_CTL_FLAGM_NO_DURATION 0x400	/* don't calc command duration */
 #define SG_CTL_FLAGM_MORE_ASYNC	0x800	/* yield EAGAIN in more cases */
 #define SG_CTL_FLAGM_ALL_BITS	0xfff	/* should be OR of previous items */
-- 
2.25.1

