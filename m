Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49CFC3A59D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiJXDZt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJXDXJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:23:09 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C486C76578
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 20B122041CB;
        Mon, 24 Oct 2022 05:21:58 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TtXLUh1RxX87; Mon, 24 Oct 2022 05:21:57 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id E02BD2041AF;
        Mon, 24 Oct 2022 05:21:56 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v25 38/44] sg: track lowest inactive and await indexes
Date:   Sun, 23 Oct 2022 23:20:52 -0400
Message-Id: <20221024032058.14077-39-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use two integers in the sg_fd structure to track recent and lowest
xarray indexes that have become inactive or await a foreground
receive. This is used to shorten the number of xarray iterations
required prior to a match when queue (IO) depths are large, say
128.

Replace the req_cnt atomic in struct sg_fd with the inactives
atomic. With large queues, cycles were wasted checking the request
xarray for any inactives when there were none to be found.

Rename the sg_rq_state_chg_*() functions to sg_rq_chg_state_*()
since too many things start with "sg_rq_state". Also the new
function names emphasize the change part a little more.

Rename the struct request pointer from rq to rqq and when it read
and written to sg_request::rqq use READ_ONCE() and WRITE_ONCE()
macros.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 421 ++++++++++++++++++++++++++++------------------
 1 file changed, 256 insertions(+), 165 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index a37e1156e4c2..e5e1daab990e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -119,6 +119,7 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FRQ_DEACT_ORPHAN	6	/* not keeping orphan so de-activate */
 #define SG_FRQ_RECEIVING	7	/* guard against multiple receivers */
 #define SG_FRQ_FOR_MMAP		8	/* request needs PAGE_SIZE elements */
+#define SG_FRQ_COUNT_ACTIVE	9	/* sfp->submitted + waiting active */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
@@ -217,7 +218,7 @@ struct sg_request {	/* active SCSI command or inactive request */
 	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
 	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */
 	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */
-	struct request *rq;	/* released in sg_rq_end_io(), bio kept */
+	struct request *rqq;	/* released in sg_rq_end_io(), bio kept */
 	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
 	struct execute_work ew_orph;	/* harvest orphan request */
 };
@@ -228,10 +229,12 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	struct mutex f_mutex;	/* serialize ioctls on this fd */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
+	int low_used_idx;	/* previous or lower used index */
+	int low_await_idx;	/* previous or lower await index */
 	u32 idx;		/* my index within parent's sfp_arr */
 	atomic_t submitted;	/* number inflight or awaiting receive */
 	atomic_t waiting;	/* number of requests awaiting receive */
-	atomic_t req_cnt;	/* number of requests */
+	atomic_t inactives;	/* number of inactive requests */
 	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
 	int mmap_sz;		/* byte size of previous mmap() call */
 	unsigned long ffd_bm[1];	/* see SG_FFD_* defines above */
@@ -302,7 +305,9 @@ static struct sg_device *sg_get_dev(int min_dev);
 static void sg_device_destroy(struct kref *kref);
 static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first,
 					 int db_len);
+#if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(CONFIG_SG_DEBUG)
 static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
+#endif
 
 #define SG_WRITE_COUNT_LIMIT (32 * 1024 * 1024)
 
@@ -872,28 +877,28 @@ sg_ctl_iosubmit_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 #if IS_ENABLED(CONFIG_SG_LOG_ACTIVE)
 static void
 sg_rq_state_fail_msg(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
-		     enum sg_rq_state want_st, enum sg_rq_state act_old_st,
-		     const char *fromp)
+		     enum sg_rq_state want_st, const char *fromp)
 {
-	const char *eaw_rs = "expected_old,actual_old,wanted rq_st";
+	const char *eaw_rs = "expected_old,wanted rq_st";
 
 	if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
-		SG_LOG(1, sfp, "%s: %s: %s: %s,%s,%s\n",
+		SG_LOG(1, sfp, "%s: %s: %s,%s,%s\n",
 		       __func__, fromp, eaw_rs,
 		       sg_rq_st_str(exp_old_st, false),
-		       sg_rq_st_str(act_old_st, false),
 		       sg_rq_st_str(want_st, false));
 	else
-		pr_info("sg: %s: %s: %s: %d,%d,%d\n", __func__, fromp, eaw_rs,
-			(int)exp_old_st, (int)act_old_st, (int)want_st);
+		pr_info("sg: %s: %s: %s: %d,%d\n", __func__, fromp, eaw_rs,
+			(int)exp_old_st, (int)want_st);
 }
 #endif
 
+/* Functions ending in '_ulck' assume sfp->xa_lock held by caller. */
 static void
-sg_rq_state_force(struct sg_request *srp, enum sg_rq_state new_st)
+sg_rq_chg_state_force_ulck(struct sg_request *srp, enum sg_rq_state new_st)
 {
 	bool prev, want;
-	struct xarray *xafp = &srp->parentfp->srp_arr;
+	struct sg_fd *sfp = srp->parentfp;
+	struct xarray *xafp = &sfp->srp_arr;
 
 	atomic_set(&srp->rq_st, new_st);
 	want = (new_st == SG_RS_AWAIT_RCV);
@@ -907,15 +912,21 @@ sg_rq_state_force(struct sg_request *srp, enum sg_rq_state new_st)
 	want = (new_st == SG_RS_INACTIVE);
 	prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
 	if (prev != want) {
-		if (want)
+		if (want) {
+			int prev_idx = READ_ONCE(sfp->low_used_idx);
+
+			if (prev_idx < 0 || srp->rq_idx < prev_idx ||
+			    !xa_get_mark(xafp, prev_idx, SG_XA_RQ_INACTIVE))
+				WRITE_ONCE(sfp->low_used_idx, srp->rq_idx);
 			__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
-		else
+		} else {
 			__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
+		}
 	}
 }
 
 static void
-sg_rq_state_helper(struct xarray *xafp, struct sg_request *srp, int indic)
+sg_rq_chg_state_help(struct xarray *xafp, struct sg_request *srp, int indic)
 {
 	if (indic & 1)		/* from inactive state */
 		__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
@@ -929,8 +940,8 @@ sg_rq_state_helper(struct xarray *xafp, struct sg_request *srp, int indic)
 }
 
 /* Following array indexed by enum sg_rq_state, 0 means no xa mark change */
-static const int sg_rq_state_arr[] = {1, 0, 4, 0, 0};
-static const int sg_rq_state_mul2arr[] = {2, 0, 8, 0, 0};
+static const int sg_rq_state_arr[] = {1, 0, 4, 0};
+static const int sg_rq_state_mul2arr[] = {2, 0, 8, 0};
 
 /*
  * This function keeps the srp->rq_st state and associated marks on the
@@ -944,40 +955,56 @@ static const int sg_rq_state_mul2arr[] = {2, 0, 8, 0, 0};
  * spinlock is held.
  */
 static int
-sg_rq_state_chg(struct sg_request *srp, enum sg_rq_state old_st,
-		enum sg_rq_state new_st, bool force, const char *fromp)
+sg_rq_chg_state(struct sg_request *srp, enum sg_rq_state old_st,
+		enum sg_rq_state new_st)
 {
 	enum sg_rq_state act_old_st;
-	int indic;
-	unsigned long iflags;
-	struct xarray *xafp = &srp->parentfp->srp_arr;
+	int indic = sg_rq_state_arr[(int)old_st] + sg_rq_state_mul2arr[(int)new_st];
+	struct sg_fd *sfp = srp->parentfp;
 
-	if (force) {
-		xa_lock_irqsave(xafp, iflags);
-		sg_rq_state_force(srp, new_st);
-		xa_unlock_irqrestore(xafp, iflags);
-		return 0;
-	}
-	indic = sg_rq_state_arr[(int)old_st] +
-		sg_rq_state_mul2arr[(int)new_st];
-	act_old_st = (enum sg_rq_state)atomic_cmpxchg(&srp->rq_st, old_st,
-						      new_st);
-	if (act_old_st != old_st) {
-#if IS_ENABLED(CONFIG_SG_LOG_ACTIVE)
-		if (fromp)
-			sg_rq_state_fail_msg(srp->parentfp, old_st, new_st,
-					     act_old_st, fromp);
-#endif
-		return -EPROTOTYPE;	/* only used for this error type */
-	}
 	if (indic) {
+		unsigned long iflags;
+		struct xarray *xafp = &sfp->srp_arr;
+
 		xa_lock_irqsave(xafp, iflags);
-		sg_rq_state_helper(xafp, srp, indic);
+		act_old_st = (enum sg_rq_state)atomic_cmpxchg_relaxed(&srp->rq_st, old_st, new_st);
+		if (unlikely(act_old_st != old_st)) {
+			xa_unlock_irqrestore(xafp, iflags);
+			SG_LOG(1, sfp, "%s: unexpected old state: %s\n", __func__,
+			       sg_rq_st_str(act_old_st, false));
+			return -EPROTOTYPE;     /* only used for this error type */
+		}
+		if (new_st == SG_RS_INACTIVE) {
+			int prev_idx = READ_ONCE(sfp->low_used_idx);
+
+			if (prev_idx < 0 || srp->rq_idx < prev_idx ||
+			    !xa_get_mark(xafp, prev_idx, SG_XA_RQ_INACTIVE))
+				WRITE_ONCE(sfp->low_used_idx, srp->rq_idx);
+		}
+		sg_rq_chg_state_help(xafp, srp, indic);
 		xa_unlock_irqrestore(xafp, iflags);
+	} else {
+		act_old_st = (enum sg_rq_state)atomic_cmpxchg(&srp->rq_st, old_st, new_st);
+		if (unlikely(act_old_st != old_st)) {
+			SG_LOG(1, sfp, "%s: unexpected old state: %s\n", __func__,
+			       sg_rq_st_str(act_old_st, false));
+			return -EPROTOTYPE;     /* only used for this error type */
+		}
 	}
 	return 0;
 }
 
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
 static void
 sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 {
@@ -998,14 +1025,15 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 		at_head = !(srp->rq_flags & SG_FLAG_Q_AT_TAIL);
 
 	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
-	sg_rq_state_chg(srp, SG_RS_BUSY /* ignored */, SG_RS_INFLIGHT,
-			true, __func__);
+	sg_rq_chg_state_force(srp, SG_RS_INFLIGHT);
 
 	/* >>>>>>> send cmd/req off to other levels <<<<<<<< */
-	if (!sync)
+	if (!sync) {
 		atomic_inc(&sfp->submitted);
-	srp->rq->end_io = sg_rq_end_io;
-	blk_execute_rq_nowait(srp->rq, at_head);
+		set_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm);
+	}
+	srp->rqq->end_io = sg_rq_end_io;
+	blk_execute_rq_nowait(READ_ONCE(srp->rqq), (int)at_head);
 }
 
 /*
@@ -1080,7 +1108,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		res = -ENODEV;
 		goto err_out;
 	}
-	srp->rq->timeout = cwrp->timeout;
+	READ_ONCE(srp->rqq)->timeout = cwrp->timeout;
 	sg_execute_cmd(fp, srp);
 	return srp;
 err_out:
@@ -1197,10 +1225,6 @@ sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, size_t count,
 	hp->driver_status = driver_byte(rq_result);
 	err2 = put_sg_io_hdr(hp, buf);
 	err = err ? err : err2;
-	err2 = sg_rq_state_chg(srp, atomic_read(&srp->rq_st), SG_RS_INACTIVE,
-			       false, __func__);
-	if (err2)
-		err = err ? err : err2;
 err_out:
 	sg_finish_scsi_blk_rq(srp);
 	sg_deact_request(sfp, srp);
@@ -1211,7 +1235,7 @@ static int
 sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 	      struct sg_io_v4 *h4p)
 {
-	int err, err2;
+	int err;
 	u32 rq_result = srp->rq_result;
 
 	SG_LOG(3, sfp, "%s: p=%s, h4p=%s\n", __func__,
@@ -1246,10 +1270,6 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 		if (copy_to_user(p, h4p, SZ_SG_IO_V4))
 			err = err ? err : -EFAULT;
 	}
-	err2 = sg_rq_state_chg(srp, atomic_read(&srp->rq_st), SG_RS_INACTIVE,
-			       false, __func__);
-	if (err2)
-		err = err ? err : err2;
 	sg_finish_scsi_blk_rq(srp);
 	sg_deact_request(sfp, srp);
 	return err < 0 ? err : 0;
@@ -1615,6 +1635,7 @@ sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
 	case SG_RS_BUSY:
 		res = sg_calc_rq_dur(srp);
 		break;
+	case SG_RS_AWAIT_RCV:
 	case SG_RS_INACTIVE:
 		res = srp->duration;
 		is_dur = true;	/* completion has occurred, timing finished */
@@ -1650,7 +1671,7 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 static inline bool
 sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
 {
-	return atomic_read(&srp->rq_st) != SG_RS_INFLIGHT ||
+	return atomic_read_acquire(&srp->rq_st) != SG_RS_INFLIGHT ||
 	       unlikely(SG_IS_DETACHING(sdp));
 }
 
@@ -1666,6 +1687,8 @@ sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, void __user *p,
 	enum sg_rq_state sr_st;
 	struct sg_device *sdp = sfp->parentdp;
 
+	if (atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)
+		goto skip_wait;		/* and skip _acquire() */
 	SG_LOG(3, sfp, "%s: about to wait_event...()\n", __func__);
 	/* usually will be woken up by sg_rq_end_io() callback */
 	res = wait_event_interruptible(sfp->read_wait,
@@ -1678,16 +1701,22 @@ sg_wait_event_srp(struct file *filp, struct sg_fd *sfp, void __user *p,
 		       __func__, res);
 		return res;
 	}
+skip_wait:
 	if (unlikely(SG_IS_DETACHING(sdp))) {
-		atomic_set(&srp->rq_st, SG_RS_INACTIVE);
+		sg_rq_chg_state_force(srp, SG_RS_INACTIVE);
+		atomic_inc(&sfp->inactives);
 		return -ENODEV;
 	}
 	sr_st = atomic_read(&srp->rq_st);
 	if (unlikely(sr_st != SG_RS_AWAIT_RCV))
 		return -EPROTO;         /* Logic error */
-	res = sg_rq_state_chg(srp, sr_st, SG_RS_BUSY, false, __func__);
-	if (unlikely(res))
+	res = sg_rq_chg_state(srp, sr_st, SG_RS_BUSY);
+	if (unlikely(res)) {
+#if IS_ENABLED(CONFIG_SG_LOG_ACTIVE)
+		sg_rq_state_fail_msg(sfp, sr_st, SG_RS_BUSY, __func__);
+#endif
 		return res;
+	}
 	if (test_bit(SG_FRQ_IS_V4I, srp->frq_bm))
 		res = sg_receive_v4(sfp, srp, p, h4p);
 	else
@@ -1939,7 +1968,10 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
 		return put_user(val, ip);
 	case SG_GET_NUM_WAITING:
-		return put_user(atomic_read(&sfp->waiting), ip);
+		val = atomic_read(&sfp->waiting);
+		if (val)
+			return put_user(val, ip);
+		return put_user(atomic_read_acquire(&sfp->waiting), ip);
 	case SG_GET_SG_TABLESIZE:
 		SG_LOG(3, sfp, "%s:    SG_GET_SG_TABLESIZE=%d\n", __func__,
 		       sdp->max_sgat_sz);
@@ -2127,11 +2159,16 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 static __poll_t
 sg_poll(struct file *filp, poll_table * wait)
 {
+	int num;
 	__poll_t p_res = 0;
 	struct sg_fd *sfp = filp->private_data;
 
-	poll_wait(filp, &sfp->read_wait, wait);
-	if (atomic_read(&sfp->waiting) > 0)
+	num = atomic_read(&sfp->waiting);
+	if (num < 1) {
+		poll_wait(filp, &sfp->read_wait, wait);
+		num = atomic_read(&sfp->waiting);
+	}
+	if (num > 0)
 		p_res = EPOLLIN | EPOLLRDNORM;
 
 	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
@@ -2335,7 +2372,7 @@ sg_check_sense(struct sg_device *sdp, struct sg_request *srp, int sense_len)
 {
 	int driver_stat;
 	u32 rq_res = srp->rq_result;
-	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(srp->rq);
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(READ_ONCE(srp->rqq));
 	u8 *sbp = scmd ? scmd->sense_buffer : NULL;
 
 	if (!sbp)
@@ -2370,32 +2407,18 @@ sg_check_sense(struct sg_device *sdp, struct sg_request *srp, int sense_len)
  * (sync) usage, sg_ctl_sg_io() waits to be woken up by this callback.
  */
 static enum rq_end_io_ret
-sg_rq_end_io(struct request *rq, blk_status_t status)
+sg_rq_end_io(struct request *rqq, blk_status_t status)
 {
 	enum sg_rq_state rqq_state = SG_RS_AWAIT_RCV;
 	int a_resid, slen;
-	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
-	struct sg_request *srp = rq->end_io_data;
+	unsigned long iflags;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rqq);
+	struct sg_request *srp = rqq->end_io_data;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 
-	if (!srp) {
-		WARN_ONCE("%s: srp unexpectedly NULL\n", __func__);
-		return RQ_END_IO_NONE;
-	}
-	if (WARN_ON(atomic_read(&srp->rq_st) != SG_RS_INFLIGHT)) {
-		pr_warn("%s: bad rq_st=%d\n", __func__,
-			atomic_read(&srp->rq_st));
-		goto early_err;
-	}
 	sfp = srp->parentfp;
-	if (unlikely(!sfp)) {
-		WARN_ONCE(1, "%s: sfp unexpectedly NULL", __func__);
-		goto early_err;
-	}
 	sdp = sfp->parentdp;
-	if (unlikely(SG_IS_DETACHING(sdp)))
-		pr_info("%s: device detaching\n", __func__);
 
 	srp->rq_result = scmd->result;
 	slen = min_t(int, scmd->sense_len, SCSI_SENSE_BUFFERSIZE);
@@ -2403,7 +2426,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 
 	if (a_resid) {
 		if (test_bit(SG_FRQ_IS_V4I, srp->frq_bm)) {
-			if (rq_data_dir(rq) == READ)
+			if (rq_data_dir(rqq) == READ)
 				srp->in_resid = a_resid;
 			else
 				srp->s_hdr4.out_resid = a_resid;
@@ -2447,17 +2470,29 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 			set_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm);
 		}
 	}
-	if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
-		atomic_inc(&sfp->waiting);
-	if (unlikely(sg_rq_state_chg(srp, SG_RS_INFLIGHT, rqq_state,
-				     false, __func__)))
-		pr_warn("%s: can't set rq_st\n", __func__);
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	sg_rq_chg_state_force_ulck(srp, rqq_state);
+	WRITE_ONCE(srp->rqq, NULL);
+	if (test_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
+		int num = atomic_inc_return(&sfp->waiting);
+
+		if (num < 2) {
+			WRITE_ONCE(sfp->low_await_idx, srp->rq_idx);
+		} else {
+			int l_await_idx = READ_ONCE(sfp->low_await_idx);
+
+			if (l_await_idx < 0 || srp->rq_idx < l_await_idx ||
+			    !xa_get_mark(&sfp->srp_arr, l_await_idx, SG_XA_RQ_AWAIT))
+				WRITE_ONCE(sfp->low_await_idx, srp->rq_idx);
+		}
+	}
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+
 	/*
 	 * Free the mid-level resources apart from the bio (if any). The bio's
 	 * blk_rq_unmap_user() can be called later from user context.
 	 */
-	srp->rq = NULL;
-	blk_mq_free_request(rq);
+	blk_mq_free_request(rqq);
 
 	if (likely(rqq_state == SG_RS_AWAIT_RCV)) {
 		/* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
@@ -2469,10 +2504,6 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 		schedule_work(&srp->ew_orph.work);
 	}
 	return RQ_END_IO_NONE;
-
-early_err:
-	srp->rq = NULL;
-	return RQ_END_IO_FREE;
 }
 
 static const struct file_operations sg_fops = {
@@ -2807,7 +2838,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	u32 rq_flags = srp->rq_flags;
 	unsigned int iov_count = 0;
 	void __user *up;
-	struct request *rq;
+	struct request *rqq;
 	struct scsi_cmnd *scmd;
 	struct sg_fd *sfp = cwrp->sfp;
 	struct sg_device *sdp;
@@ -2856,12 +2887,12 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	 * do not want to use BLK_MQ_REQ_NOWAIT here because userspace might
 	 * not expect an EWOULDBLOCK from this condition.
 	 */
-	rq = scsi_alloc_request(q, (r0w ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN), 0);
-	if (IS_ERR(rq))
-		return PTR_ERR(rq);
+	rqq = scsi_alloc_request(q, (r0w ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN), 0);
+	if (IS_ERR(rqq))
+		return PTR_ERR(rqq);
 	/* current sg_request protected by SG_RS_BUSY state */
-	scmd = blk_mq_rq_to_pdu(rq);
-	srp->rq = rq;
+	scmd = blk_mq_rq_to_pdu(rqq);
+	WRITE_ONCE(srp->rqq, rqq);
 
 	if (cwrp->u_cmdp)
 		res = sg_fetch_cmnd(cwrp->filp, sfp, cwrp->u_cmdp,
@@ -2875,7 +2906,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	us_xfer = !(rq_flags & (SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO));
 	assign_bit(SG_FRQ_NO_US_XFER, srp->frq_bm, !us_xfer);
 	reserved = (sfp->rsv_srp == srp);
-	rq->end_io_data = srp;
+	rqq->end_io_data = srp;
 	scmd->retries = SG_DEFAULT_RETRIES;
 	req_schp = &srp->sgat_h;
 
@@ -2910,15 +2941,16 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		md->from_user = (dxfer_dir == SG_DXFER_TO_FROM_DEV);
 	}
 
-	res = blk_rq_map_user_io(rq, md, up, dxfer_len, GFP_ATOMIC,
+	res = blk_rq_map_user_io(rqq, md, up, dxfer_len, GFP_ATOMIC,
 				 iov_count, iov_count, 1, r0w);
 fini:
 	if (unlikely(res)) {		/* failure, free up resources */
-		srp->rq = NULL;
+		WRITE_ONCE(srp->rqq, NULL);
 		SG_LOG(1, sfp, "%s: blk_rq_map_user_io() failed, iov_count=%d\n",
 		       __func__, iov_count);
+		blk_mq_free_request(rqq);
 	} else {
-		srp->bio = rq->bio;
+		srp->bio = rqq->bio;
 	}
 	SG_LOG((res ? 1 : 4), sfp, "%s: %s res=%d [0x%pK]\n", __func__, cp,
 	       res, srp);
@@ -2937,19 +2969,19 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 {
 	int ret;
 	struct sg_fd *sfp = srp->parentfp;
-	struct request *rq = srp->rq;
+	struct request *rqq = READ_ONCE(srp->rqq);
 
 	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp,
 	       (srp->parentfp->rsv_srp == srp) ? " rsv" : "");
-	if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
+	if (test_and_clear_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
 		atomic_dec(&sfp->submitted);
 		atomic_dec(&sfp->waiting);
 	}
 
-	/* Expect blk_mq_free_request(rq) already called in sg_rq_end_io() */
-	if (rq) {	/* blk_get_request() may have failed */
-		srp->rq = NULL;
-		blk_mq_free_request(rq);
+	/* Expect blk_mq_free_request(rqq) already called in sg_rq_end_io() */
+	if (rqq) {       /* scsi_alloc_request() may have failed */
+		WRITE_ONCE(srp->rqq, NULL);
+		blk_mq_free_request(rqq);
 	}
 	if (srp->bio) {
 		bool us_xfer = !test_bit(SG_FRQ_NO_US_XFER, srp->frq_bm);
@@ -3127,23 +3159,34 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id, bool *busy)
 	__maybe_unused bool is_bad_st = false;
 	__maybe_unused enum sg_rq_state bad_sr_st = SG_RS_INACTIVE;
 	bool search_for_1 = (pack_id != SG_PACK_ID_WILDCARD);
+	bool second = false;
 	int res;
 	int num_waiting = atomic_read(&sfp->waiting);
-	unsigned long idx;
+	int l_await_idx = READ_ONCE(sfp->low_await_idx);
+	unsigned long idx, s_idx;
+	unsigned long end_idx = ULONG_MAX;
 	struct sg_request *srp = NULL;
 	struct xarray *xafp = &sfp->srp_arr;
 
 	*busy = false;
-	if (num_waiting < 1)
-		return NULL;
+	if (num_waiting < 1) {
+		num_waiting = atomic_read_acquire(&sfp->waiting);
+		if (num_waiting < 1)
+			return NULL;
+	}
+
+	s_idx = (l_await_idx < 0) ? 0 : l_await_idx;
+	idx = s_idx;
 	if (unlikely(search_for_1)) {
-		xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_AWAIT) {
+second_time:
+		for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
+		     srp;
+		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
 			if (test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
 				continue;
 			if (srp->pack_id != pack_id)
 				continue;
-			res = sg_rq_state_chg(srp, SG_RS_AWAIT_RCV, SG_RS_BUSY,
-					      false, __func__);
+			res = sg_rq_chg_state(srp, SG_RS_AWAIT_RCV, SG_RS_BUSY);
 			if (likely(res == 0))
 				goto good;
 			/* else another caller got it, move on */
@@ -3153,14 +3196,43 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id, bool *busy)
 			}
 			break;
 		}
-	} else {        /* search for any request is more likely */
-		xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_AWAIT) {
+		/* If not found so far, need to wrap around and search [0 ... s_idx) */
+		if (!srp && !second && s_idx > 0) {
+			end_idx = s_idx - 1;
+			s_idx = 0;
+			idx = s_idx;
+			second = true;
+			goto second_time;
+		}
+	} else {
+		/*
+		 * Searching for _any_ request is the more likely usage. Start searching with the
+		 * last xarray index that was used. In the case of a large-ish IO depth, it is
+		 * likely that the second (relative) position will be the request we want, if it
+		 * is ready. If there is no queuing and the "last used" has been re-used then the
+		 * first (relative) position will be the request we want.
+		 */
+second_time2:
+		for (srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_AWAIT);
+		     srp;
+		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
 			if (test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
 				continue;
-			res = sg_rq_state_chg(srp, SG_RS_AWAIT_RCV, SG_RS_BUSY,
-					      false, __func__);
-			if (likely(res == 0))
+			res = sg_rq_chg_state(srp, SG_RS_AWAIT_RCV, SG_RS_BUSY);
+			if (likely(res == 0)) {
+				WRITE_ONCE(sfp->low_await_idx, idx + 1);
 				goto good;
+			}
+#if IS_ENABLED(CONFIG_SG_LOG_ACTIVE)
+			sg_rq_state_fail_msg(sfp, SG_RS_AWAIT_RCV, SG_RS_BUSY, __func__);
+#endif
+		}
+		if (!srp && !second && s_idx > 0) {
+			end_idx = s_idx - 1;
+			s_idx = 0;
+			idx = s_idx;
+			second = true;
+			goto second_time2;
 		}
 	}
 	/* here if one of above loops does _not_ find a match */
@@ -3288,11 +3360,13 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 	bool found = false;
 	bool mk_new_srp = true;
 	bool try_harder = false;
-	int num_inactive = 0;
-	unsigned long idx, last_idx, iflags;
+	bool second = false;
+	bool has_inactive = false;
+	int l_used_idx;
+	unsigned long idx, s_idx, end_idx, iflags;
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_request *r_srp = NULL;	/* request to return */
-	struct sg_request *last_srp = NULL;
+	struct sg_request *low_srp = NULL;
 	struct xarray *xafp = &fp->srp_arr;
 	__maybe_unused const char *cp;
 
@@ -3301,42 +3375,66 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 	if (xa_empty(xafp)) {
 		act_empty = true;
 		mk_new_srp = true;
+	} else if (atomic_read(&fp->inactives) <= 0) {
+		mk_new_srp = true;
 	} else if (!try_harder && dxfr_len < SG_DEF_SECTOR_SZ) {
-		last_idx = ~0UL;
+		l_used_idx = READ_ONCE(fp->low_used_idx);
+		s_idx = (l_used_idx < 0) ? 0 : l_used_idx;
+		if (l_used_idx >= 0 && xa_get_mark(xafp, s_idx, SG_XA_RQ_INACTIVE)) {
+			r_srp = xa_load(xafp, s_idx);
+			if (r_srp && r_srp->sgat_h.buflen <= SG_DEF_SECTOR_SZ) {
+				if (sg_rq_chg_state(r_srp, SG_RS_INACTIVE, SG_RS_BUSY) == 0) {
+					found = true;
+					atomic_dec(&fp->inactives);
+					goto have_existing;
+				}
+			}
+		}
 		xa_for_each_marked(xafp, idx, r_srp, SG_XA_RQ_INACTIVE) {
-			if (!r_srp)
-				continue;
-			++num_inactive;
-			if (dxfr_len < SG_DEF_SECTOR_SZ) {
-				last_idx = idx;
-				last_srp = r_srp;
-				continue;
+			has_inactive = true;
+			if (!low_srp && dxfr_len < SG_DEF_SECTOR_SZ) {
+				low_srp = r_srp;
+				break;
 			}
 		}
-		/* If dxfr_len is small, use last inactive request */
-		if (last_idx != ~0UL && last_srp) {
-			r_srp = last_srp;
-			if (sg_rq_state_chg(r_srp, SG_RS_INACTIVE, SG_RS_BUSY,
-					    false, __func__))
+		/* If dxfr_len is small, use lowest inactive request */
+		if (low_srp) {
+			r_srp = low_srp;
+			if (sg_rq_chg_state(r_srp, SG_RS_INACTIVE, SG_RS_BUSY))
 				goto start_again; /* gone to another thread */
+			atomic_dec(&fp->inactives);
 			cp = "toward end of srp_arr";
 			found = true;
 		}
 	} else {
-		xa_for_each_marked(xafp, idx, r_srp, SG_XA_RQ_INACTIVE) {
-			if (!r_srp)
-				continue;
+		l_used_idx = READ_ONCE(fp->low_used_idx);
+		s_idx = (l_used_idx < 0) ? 0 : l_used_idx;
+		idx = s_idx;
+		end_idx = ULONG_MAX;
+second_time:
+		for (r_srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE);
+		     r_srp;
+		     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
 			if (r_srp->sgat_h.buflen >= dxfr_len) {
-				if (sg_rq_state_chg
-					(r_srp, SG_RS_INACTIVE, SG_RS_BUSY,
-					 false, __func__))
+				if (sg_rq_chg_state(r_srp, SG_RS_INACTIVE, SG_RS_BUSY))
 					continue;
-				cp = "from front of srp_arr";
+				atomic_dec(&fp->inactives);
+				WRITE_ONCE(fp->low_used_idx, idx + 1);
+				cp = "near front of srp_arr";
 				found = true;
 				break;
 			}
 		}
+		/* If not found so far, need to wrap around and search [0 ... start_idx) */
+		if (!r_srp && !second && s_idx > 0) {
+			end_idx = s_idx - 1;
+			s_idx = 0;
+			idx = s_idx;
+			second = true;
+			goto second_time;
+		}
 	}
+have_existing:
 	if (found) {
 		r_srp->in_resid = 0;
 		r_srp->rq_info = 0;
@@ -3349,7 +3447,6 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 		bool allow_cmd_q = test_bit(SG_FFD_CMD_Q, fp->ffd_bm);
 		int res;
 		u32 n_idx;
-		struct xa_limit xal = { .max = 0, .min = 0 };
 
 		cp = "new";
 		if (!allow_cmd_q && atomic_read(&fp->submitted) > 0) {
@@ -3361,16 +3458,14 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 		r_srp = sg_mk_srp_sgat(fp, act_empty, dxfr_len);
 		if (IS_ERR(r_srp)) {
 			if (!try_harder && dxfr_len < SG_DEF_SECTOR_SZ &&
-			    num_inactive > 0) {
+			    has_inactive) {
 				try_harder = true;
 				goto start_again;
 			}
 			goto fini;
 		}
-		atomic_set(&r_srp->rq_st, SG_RS_BUSY);
 		xa_lock_irqsave(xafp, iflags);
-		xal.max = atomic_inc_return(&fp->req_cnt);
-		res = __xa_alloc(xafp, &n_idx, r_srp, xal, GFP_KERNEL);
+		res = __xa_alloc(xafp, &n_idx, r_srp, xa_limit_32b, GFP_KERNEL);
 		xa_unlock_irqrestore(xafp, iflags);
 		if (res < 0) {
 			SG_LOG(1, fp, "%s: xa_alloc() failed, errno=%d\n",
@@ -3413,7 +3508,8 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 	sbp = srp->sense_bp;
 	srp->sense_bp = NULL;
 	WRITE_ONCE(srp->frq_bm[0], 0);
-	sg_rq_state_chg(srp, 0, SG_RS_INACTIVE, true /* force */, __func__);
+	sg_rq_chg_state_force(srp, SG_RS_INACTIVE);
+	atomic_inc(&sfp->inactives);
 	/* maybe orphaned req, thus never read */
 	if (sbp)
 		mempool_free(sbp, sg_sense_pool);
@@ -3432,7 +3528,6 @@ sg_add_sfp(struct sg_device *sdp)
 	struct sg_request *srp = NULL;
 	struct xarray *xadp = &sdp->sfp_arr;
 	struct xarray *xafp;
-	struct xa_limit xal;
 
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
@@ -3449,8 +3544,6 @@ sg_add_sfp(struct sg_device *sdp)
 	__assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, SG_DEF_COMMAND_Q);
 	__assign_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm, SG_DEF_KEEP_ORPHAN);
 	__assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm, SG_DEFAULT_Q_AT);
-	atomic_set(&sfp->submitted, 0);
-	atomic_set(&sfp->waiting, 0);
 	/*
 	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may
 	 * be given as driver/module parameter (e.g. 'scatter_elem_sz=8192').
@@ -3462,7 +3555,7 @@ sg_add_sfp(struct sg_device *sdp)
 	sfp->parentdp = sdp;
 	atomic_set(&sfp->submitted, 0);
 	atomic_set(&sfp->waiting, 0);
-	atomic_set(&sfp->req_cnt, 0);
+	atomic_set(&sfp->inactives, 0);
 
 	if (unlikely(SG_IS_DETACHING(sdp))) {
 		SG_LOG(1, sfp, "%s: detaching\n", __func__);
@@ -3474,8 +3567,6 @@ sg_add_sfp(struct sg_device *sdp)
 
 	rbuf_len = min_t(int, sg_big_buff, sdp->max_sgat_sz);
 	if (rbuf_len > 0) {
-		struct xa_limit xalrq = { .max = 0, .min = 0 };
-
 		srp = sg_build_reserve(sfp, rbuf_len);
 		if (IS_ERR(srp)) {
 			err = PTR_ERR(srp);
@@ -3491,8 +3582,7 @@ sg_add_sfp(struct sg_device *sdp)
 			       __func__, rbuf_len, srp->sgat_h.buflen);
 		}
 		xa_lock_irqsave(xafp, iflags);
-		xalrq.max = atomic_inc_return(&sfp->req_cnt);
-		res = __xa_alloc(xafp, &idx, srp, xalrq, GFP_ATOMIC);
+		res = __xa_alloc(xafp, &idx, srp, xa_limit_32b, GFP_ATOMIC);
 		xa_unlock_irqrestore(xafp, iflags);
 		if (res < 0) {
 			SG_LOG(1, sfp, "%s: xa_alloc(srp) bad, errno=%d\n",
@@ -3504,20 +3594,19 @@ sg_add_sfp(struct sg_device *sdp)
 		}
 		srp->rq_idx = idx;
 		srp->parentfp = sfp;
-		sg_rq_state_chg(srp, 0, SG_RS_INACTIVE, true, __func__);
+		sg_rq_chg_state_force(srp, SG_RS_INACTIVE);
+		atomic_inc(&sfp->inactives);
 	}
 	if (!reduced) {
 		SG_LOG(4, sfp, "%s: built reserve buflen=%d\n", __func__,
 		       rbuf_len);
 	}
 	xa_lock_irqsave(xadp, iflags);
-	xal.min = 0;
-	xal.max = atomic_read(&sdp->open_cnt);
-	res = __xa_alloc(xadp, &idx, sfp, xal, GFP_KERNEL);
+	res = __xa_alloc(xadp, &idx, sfp, xa_limit_32b, GFP_KERNEL);
 	xa_unlock_irqrestore(xadp, iflags);
 	if (res < 0) {
 		pr_warn("%s: xa_alloc(sdp) bad, o_count=%d, errno=%d\n",
-			__func__, xal.max, -res);
+			__func__, atomic_read(&sdp->open_cnt), -res);
 		if (srp) {
 			sg_remove_sgat(srp);
 			kfree(srp);
@@ -3929,11 +4018,13 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 		       (int)test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm),
 		       (int)test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm),
 		       fp->ffd_bm[0]);
-	n += scnprintf(obp + n, len - n, "   mmap_sz=%d\n", fp->mmap_sz);
 	n += scnprintf(obp + n, len - n,
-		       "   submitted=%d waiting=%d   open thr_id=%d\n",
+		       "   mmap_sz=%d low_used_idx=%d low_await_idx=%d\n",
+		       fp->mmap_sz, READ_ONCE(fp->low_used_idx), READ_ONCE(fp->low_await_idx));
+	n += scnprintf(obp + n, len - n,
+		       "   submitted=%d waiting=%d inactives=%d   open thr_id=%d\n",
 		       atomic_read(&fp->submitted),
-		       atomic_read(&fp->waiting), fp->tid);
+		       atomic_read(&fp->waiting), atomic_read(&fp->inactives), fp->tid);
 	k = 0;
 	xa_lock_irqsave(&fp->srp_arr, iflags);
 	xa_for_each(&fp->srp_arr, idx, srp) {
-- 
2.37.3

