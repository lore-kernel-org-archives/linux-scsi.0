Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C09CC3A59D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiJXDZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiJXDXA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:23:00 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 232D65FDEB
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D7ABC204237;
        Mon, 24 Oct 2022 05:21:35 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G9PlU4rcN6Xz; Mon, 24 Oct 2022 05:21:35 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id AA6962041AF;
        Mon, 24 Oct 2022 05:21:34 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v25 23/44] sg: xarray for reqs in fd
Date:   Sun, 23 Oct 2022 23:20:37 -0400
Message-Id: <20221024032058.14077-24-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the linked list and the fixed array of requests (max 16)
with an xarray. The xarray (srp_arr) has two marks: one for
INACTIVE state (i.e. available for re-use) requests; the other
is AWAIT state which is after the internal completion point of
a request and before the user space has fetched the response.

Of the five states in sg_request::rq_st, two are marked. They are
SG_RS_INACTIVE and SG_RS_AWAIT_RCV. This allows the request xarray
(sg_fd::srp_arr) to be searched (with xa_for_each_mark) on two
embedded sub-lists. The SG_RS_INACTIVE sub-list replaces the free
list. The SG_RS_AWAIT_RCV sub-list contains requests that have
reached their internal completion point but have not been read/
received by the user space. Add support functions for this and
partially wire them up.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 329 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 232 insertions(+), 97 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c545f4ae8532..ffcd2d396c3a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -78,7 +78,7 @@ static char *sg_version_date = "20190606";
 #define SG_MAX_CDB_SIZE 252
 
 /* Following enum contains the states of sg_request::rq_st */
-enum sg_rq_state {
+enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 	SG_RS_INACTIVE = 0,	/* request not in use (e.g. on fl) */
 	SG_RS_INFLIGHT,		/* active: cmd/req issued, no response yet */
 	SG_RS_AWAIT_RCV,	/* have response from LLD, awaiting receive */
@@ -117,6 +117,11 @@ enum sg_rq_state {
 #define SG_FDEV_DETACHING	1	/* may be unexpected device removal */
 #define SG_FDEV_LOG_SENSE	2	/* set by ioctl(SG_SET_DEBUG) */
 
+/* xarray 'mark's allow sub-lists within main array/list. */
+#define SG_XA_RQ_FREE XA_MARK_0	/* xarray sets+clears */
+#define SG_XA_RQ_INACTIVE XA_MARK_1
+#define SG_XA_RQ_AWAIT XA_MARK_2
+
 static int sg_big_buff = SG_DEF_RESERVED_SIZE;
 /*
  * This variable is accessible via /proc/scsi/sg/def_reserved_size . Each
@@ -156,11 +161,11 @@ struct sg_device;		/* forward declarations */
 struct sg_fd;
 
 struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
-	struct list_head entry;	/* list entry */
 	struct sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
 	struct sg_io_hdr header;  /* scsi command+info, see <scsi/sg.h> */
 	u8 sense_b[SCSI_SENSE_BUFFERSIZE];
 	u32 duration;		/* cmd duration in milliseconds */
+	u32 rq_idx;		/* my index within parent's srp_arr */
 	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
 	char orphan;		/* 1 -> drop on sight, 0 -> normal */
 	u32 rq_result;		/* packed scsi request result from LLD */
@@ -179,24 +184,23 @@ struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
 struct sg_fd {		/* holds the state of a file descriptor */
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
-	spinlock_t rq_list_lock;	/* protect access to list in req_arr */
 	struct mutex f_mutex;	/* protect against changes in this fd */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	u32 idx;		/* my index within parent's sfp_arr */
-	atomic_t submitted;	/* number inflight or awaiting read */
-	atomic_t waiting;	/* number of requests awaiting read */
+	atomic_t submitted;	/* number inflight or awaiting receive */
+	atomic_t waiting;	/* number of requests awaiting receive */
+	atomic_t req_cnt;	/* number of requests */
 	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
 	struct sg_scatter_hold reserve;	/* buffer for this file descriptor */
-	struct list_head rq_list; /* head of request list */
-	struct fasync_struct *async_qp;	/* used by asynchronous notification */
-	struct sg_request req_arr[SG_MAX_QUEUE];/* use as singly-linked list */
 	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
 	char cmd_q;		/* 1 -> allow command queuing, 0 -> don't */
 	u8 next_cmd_len;	/* 0: automatic, >0: use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
 	char res_in_use;	/* 1 -> 'reserve' array in use */
+	struct fasync_struct *async_qp;	/* used by asynchronous notification */
+	struct xarray srp_arr;
 	struct kref f_ref;
 	struct execute_work ew_fd;  /* harvest all fd resources and lists */
 };
@@ -276,6 +280,7 @@ static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 
 #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(CONFIG_SG_DEBUG)
 #define SG_LOG_BUFF_SZ 48
+#define CONFIG_SG_LOG_ACTIVE 1
 
 #define SG_LOG(depth, sfp, fmt, a...)					\
 	do {								\
@@ -295,7 +300,7 @@ static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 	} while (0)
 #else
 #define SG_LOG(depth, sfp, fmt, a...) do { } while (0)
-#endif	/* end of CONFIG_SCSI_LOGGING && SG_DEBUG conditional */
+#endif	/* end of CONFIG_SCSI_LOGGING && CONFIG_SG_DEBUG conditional */
 
 
 /*
@@ -725,6 +730,115 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 	return count;
 }
 
+#if IS_ENABLED(CONFIG_SG_LOG_ACTIVE)
+static void
+sg_rq_state_fail_msg(struct sg_fd *sfp, enum sg_rq_state exp_old_st,
+		     enum sg_rq_state want_st, enum sg_rq_state act_old_st,
+		     const char *fromp)
+{
+	const char *eaw_rs = "expected_old,actual_old,wanted rq_st";
+
+	if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
+		SG_LOG(1, sfp, "%s: %s: %s: %s,%s,%s\n",
+		       __func__, fromp, eaw_rs,
+		       sg_rq_st_str(exp_old_st, false),
+		       sg_rq_st_str(act_old_st, false),
+		       sg_rq_st_str(want_st, false));
+	else
+		pr_info("sg: %s: %s: %s: %d,%d,%d\n", __func__, fromp, eaw_rs,
+			(int)exp_old_st, (int)act_old_st, (int)want_st);
+}
+#endif
+
+static void
+sg_rq_state_force(struct sg_request *srp, enum sg_rq_state new_st)
+{
+	bool prev, want;
+	struct xarray *xafp = &srp->parentfp->srp_arr;
+
+	atomic_set(&srp->rq_st, new_st);
+	want = (new_st == SG_RS_AWAIT_RCV);
+	prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
+	if (prev != want) {
+		if (want)
+			__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
+		else
+			__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
+	}
+	want = (new_st == SG_RS_INACTIVE);
+	prev = xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
+	if (prev != want) {
+		if (want)
+			__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
+		else
+			__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
+	}
+}
+
+static void
+sg_rq_state_helper(struct xarray *xafp, struct sg_request *srp, int indic)
+{
+	if (indic & 1)		/* from inactive state */
+		__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
+	else if (indic & 2)	/* to inactive state */
+		__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE);
+
+	if (indic & 4)		/* from await state */
+		__xa_clear_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
+	else if (indic & 8)	/* to await state */
+		__xa_set_mark(xafp, srp->rq_idx, SG_XA_RQ_AWAIT);
+}
+
+/* Following array indexed by enum sg_rq_state, 0 means no xa mark change */
+static const int sg_rq_state_arr[] = {1, 0, 4, 0, 0};
+static const int sg_rq_state_mul2arr[] = {2, 0, 8, 0, 0};
+
+/*
+ * This function keeps the srp->rq_st state and associated marks on the
+ * owning xarray's element in sync. If force is true then new_st is stored
+ * in srp->rq_st and xarray marks are set accordingly (and old_st is
+ * ignored); and 0 is returned.
+ * If force is false, then atomic_cmpxchg() is called. If the actual
+ * srp->rq_st is not old_st, then -EPROTOTYPE is returned. If the actual
+ * srp->rq_st is old_st then it is replaced by new_st and the xarray marks
+ * are setup accordingly and 0 is returned. This assumes srp_arr xarray
+ * spinlock is held.
+ */
+static int
+sg_rq_state_chg(struct sg_request *srp, enum sg_rq_state old_st,
+		enum sg_rq_state new_st, bool force, const char *fromp)
+{
+	enum sg_rq_state act_old_st;
+	int indic;
+	unsigned long iflags;
+	struct xarray *xafp = &srp->parentfp->srp_arr;
+
+	if (force) {
+		xa_lock_irqsave(xafp, iflags);
+		sg_rq_state_force(srp, new_st);
+		xa_unlock_irqrestore(xafp, iflags);
+		return 0;
+	}
+	indic = sg_rq_state_arr[(int)old_st] +
+		sg_rq_state_mul2arr[(int)new_st];
+	act_old_st = (enum sg_rq_state)atomic_cmpxchg(&srp->rq_st, old_st,
+						      new_st);
+	if (act_old_st != old_st) {
+#if IS_ENABLED(CONFIG_SG_LOG_ACTIVE)
+		if (fromp)
+			sg_rq_state_fail_msg(srp->parentfp, old_st, new_st,
+					     act_old_st, fromp);
+#endif
+		return -EPROTOTYPE;	/* only used for this error type */
+	}
+	if (indic) {
+		xa_lock_irqsave(xafp, iflags);
+		sg_rq_state_helper(xafp, srp, indic);
+		xa_unlock_irqrestore(xafp, iflags);
+	}
+	return 0;
+}
+
 /*
  * All writes and submits converge on this function to launch the SCSI
  * command/request (via blk_execute_rq_nowait). Returns a pointer to a
@@ -763,16 +877,8 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 		sg_deact_request(sfp, srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
-	if (SG_IS_DETACHING(sdp)) {
-		if (srp->bio) {
-			blk_mq_free_request(srp->rq);
-			srp->rq = NULL;
-		}
-
-		sg_finish_scsi_blk_rq(srp);
-		sg_deact_request(sfp, srp);
-		return -ENODEV;
-	}
+	if (SG_IS_DETACHING(sdp))
+		goto err_out;
 
 	hp->duration = jiffies_to_msecs(jiffies);
 	if (hp->interface_id != '\0' &&	/* v3 (or later) interface */
@@ -788,6 +894,21 @@ sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 	srp->rq->end_io = sg_rq_end_io;
 	blk_execute_rq_nowait(srp->rq, at_head);
 	return 0;
+err_out:
+	if (srp->bio) {
+		blk_mq_free_request(srp->rq);
+		srp->rq = NULL;
+	}
+	sg_finish_scsi_blk_rq(srp);
+	sg_deact_request(sfp, srp);
+	return -ENODEV;
+}
+
+static inline int
+sg_rstate_chg(struct sg_request *srp, enum sg_rq_state old_st,
+	      enum sg_rq_state new_st)
+{
+	return sg_rq_state_chg(srp, old_st, new_st, false, __func__);
 }
 
 /*
@@ -1153,12 +1274,9 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 static int
 srp_done(struct sg_fd *sfp, struct sg_request *srp)
 {
-	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&sfp->rq_list_lock, flags);
 	ret = srp->done;
-	spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
 	return ret;
 }
 
@@ -1181,17 +1299,13 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 			true, &srp);
 	if (res < 0)
 		return res;
-	res = wait_event_interruptible
-		(sfp->read_wait, srp_done(sfp, srp));
-	spin_lock_irq(&sfp->rq_list_lock);
+	res = wait_event_interruptible(sfp->read_wait, srp_done(sfp, srp));
 	if (srp->done) {
 		srp->done = 2;
-		spin_unlock_irq(&sfp->rq_list_lock);
 		res = sg_receive_v3(sfp, srp, SZ_SG_IO_HDR, buf);
 		return (res < 0) ? res : 0;
 	}
 	srp->orphan = 1;
-	spin_unlock_irq(&sfp->rq_list_lock);
 	return res;
 }
 
@@ -1240,7 +1354,7 @@ static int
 sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
 {
 	int result, val;
-	unsigned long iflags;
+	unsigned long idx;
 	struct sg_request *srp;
 	sg_req_info_t *rinfop;
 
@@ -1248,15 +1362,17 @@ sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
 			 GFP_KERNEL);
 	if (!rinfop)
 		return -ENOMEM;
-	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 	val = 0;
-	list_for_each_entry(srp, &sfp->rq_list, entry) {
+	xa_for_each(&sfp->srp_arr, idx, srp) {
+		if (!srp)
+			continue;
+		if (xa_get_mark(&sfp->srp_arr, idx, SG_XA_RQ_AWAIT))
+			continue;
 		if (val >= SG_MAX_QUEUE)
 			break;
 		sg_fill_request_element(sfp, srp, rinfop + val);
 		val++;
 	}
-	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 #ifdef CONFIG_COMPAT
 	if (in_compat_syscall())
 		result = put_compat_request_table(p, rinfop);
@@ -1301,7 +1417,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	int __user *ip = p;
 	struct sg_request *srp;
 	struct scsi_device *sdev;
-	unsigned long iflags;
+	unsigned long idx;
 	__maybe_unused const char *pmlp = ", pass to mid-level";
 
 	SG_LOG(6, sfp, "%s: cmd=0x%x, O_NONBLOCK=%d\n", __func__, cmd_in,
@@ -1324,14 +1440,15 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return 0;
 	case SG_GET_PACK_ID:    /* or tag of oldest "read"-able, -1 if none */
 		val = -1;
-		spin_lock_irqsave(&sfp->rq_list_lock, iflags);
-		list_for_each_entry(srp, &sfp->rq_list, entry) {
+		srp = NULL;
+		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
+			if (!srp)
+				continue;
 			if ((1 == srp->done) && (!srp->sg_io_owned)) {
 				val = srp->header.pack_id;
 				break;
 			}
 		}
-		spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 		SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
 		return put_user(val, ip);
 	case SG_GET_NUM_WAITING:
@@ -1719,10 +1836,10 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	struct sg_request *srp = rq->end_io_data;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
-	unsigned long iflags;
 	unsigned int ms;
 	int resid, slen;
 	int done = 1;
+	unsigned long iflags;
 
 	if (WARN_ON(srp->done != 0))
 		return RQ_END_IO_NONE;
@@ -1763,7 +1880,6 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	srp->rq = NULL;
 	blk_mq_free_request(rq);
 
-	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (unlikely(srp->orphan)) {
 		if (sfp->keep_orphan)
 			srp->sg_io_owned = 0;
@@ -1771,12 +1887,14 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 			done = 0;
 	}
 	srp->done = done;
-	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
 	if (likely(done)) {
 		/* Now wake up any sg_read() that is waiting for this
 		 * packet.
 		 */
+		xa_lock_irqsave(&sfp->srp_arr, iflags);
+		__xa_set_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_AWAIT);
+		xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 		wake_up_interruptible(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		kref_put(&sfp->f_ref, sg_remove_sfp);
@@ -2371,15 +2489,17 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
  * SG_RS_AWAIT_RCV state and SG_IS_DETACHING() is true and there is at least
  * one request in SG_RS_INFLIGHT state; in all other cases *busy is set false.
  */
+
 static struct sg_request *
 sg_find_srp_by_id(struct sg_fd *sfp, int pack_id, bool *busy)
 {
+	unsigned long idx;
 	struct sg_request *resp;
-	unsigned long iflags;
 
 	*busy = false;
-	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
-	list_for_each_entry(resp, &sfp->rq_list, entry) {
+	xa_for_each_marked(&sfp->srp_arr, idx, resp, SG_XA_RQ_AWAIT) {
+		if (!resp)
+			continue;
 		/* look for requests that are not SG_IO owned */
 		if ((!resp->sg_io_owned) &&
 		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
@@ -2389,14 +2509,12 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id, bool *busy)
 				break;
 			case 1: /* request done; response ready to return */
 				resp->done = 2;	/* guard against other readers */
-				spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 				return resp;
 			case 2: /* response already being returned */
 				break;
 			}
 		}
 	}
-	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return NULL;
 }
 
@@ -2466,31 +2584,51 @@ sg_build_reserve(struct sg_fd *sfp, int req_size)
 static struct sg_request *
 sg_setup_req(struct sg_fd *sfp)
 {
-	int k;
-	unsigned long iflags;
-	struct sg_request *rp = sfp->req_arr;
-
-	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
-	if (!list_empty(&sfp->rq_list)) {
-		if (!sfp->cmd_q)
-			goto out_unlock;
-
-		for (k = 0; k < SG_MAX_QUEUE; ++k, ++rp) {
-			if (!rp->parentfp)
-				break;
+	bool found = false;
+	int res;
+	unsigned long idx, iflags;
+	struct sg_request *rp;
+	struct xarray *xafp = &sfp->srp_arr;
+
+	if (!xa_empty(xafp)) {
+		xa_for_each_marked(xafp, idx, rp, SG_XA_RQ_INACTIVE) {
+			if (!rp)
+				continue;
+			if (sg_rstate_chg(rp, SG_RS_INACTIVE, SG_RS_BUSY))
+				continue;
+			memset(rp, 0, sizeof(*rp));
+			rp->rq_idx = idx;
+			xa_lock_irqsave(xafp, iflags);
+			__xa_clear_mark(xafp, idx, SG_XA_RQ_INACTIVE);
+			xa_unlock_irqrestore(xafp, iflags);
+			found = true;
+			break;
 		}
-		if (k >= SG_MAX_QUEUE)
-			goto out_unlock;
 	}
-	memset(rp, 0, sizeof(struct sg_request));
+	if (!found) {
+		rp = kzalloc(sizeof(*rp), GFP_KERNEL);
+		if (!rp)
+			return NULL;
+	}
 	rp->parentfp = sfp;
 	rp->header.duration = jiffies_to_msecs(jiffies);
-	list_add_tail(&rp->entry, &sfp->rq_list);
-	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	if (!found) {
+		u32 n_idx;
+		struct xa_limit xal = { .max = 0, .min = 0 };
+
+		atomic_set(&rp->rq_st, SG_RS_BUSY);
+		xa_lock_irqsave(xafp, iflags);
+		xal.max = atomic_inc_return(&sfp->req_cnt);
+		res = __xa_alloc(xafp, &n_idx, rp, xal, GFP_KERNEL);
+		xa_unlock_irqrestore(xafp, iflags);
+		if (res < 0) {
+			pr_warn("%s: don't expect xa_alloc() to fail, errno=%d\n",
+				__func__,  -res);
+			return NULL;
+		}
+		rp->rq_idx = n_idx;
+	}
 	return rp;
-out_unlock:
-	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return NULL;
 }
 
 static void
@@ -2500,22 +2638,10 @@ sg_deact_request(struct sg_fd *sfp, struct sg_request *srp)
 
 	if (WARN_ON(!sfp || !srp))
 		return;
-	if (list_empty(&sfp->rq_list))
-		return;
-	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
-	if (!list_empty(&srp->entry)) {
-		list_del(&srp->entry);
-		srp->parentfp = NULL;
-	}
-	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-
-	/*
-	 * If the device is detaching, wakeup any readers in case we just
-	 * removed the last response, which would leave nothing for them to
-	 * return other than -ENODEV.
-	 */
-	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
-		wake_up_interruptible_all(&sfp->read_wait);
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	__xa_set_mark(&sfp->srp_arr, srp->rq_idx, SG_XA_RQ_INACTIVE);
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+	atomic_set(&srp->rq_st, SG_RS_INACTIVE);
 }
 
 static struct sg_fd *
@@ -2532,8 +2658,7 @@ sg_add_sfp(struct sg_device *sdp)
 		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&sfp->read_wait);
-	spin_lock_init(&sfp->rq_list_lock);
-	INIT_LIST_HEAD(&sfp->rq_list);
+	xa_init_flags(&sfp->srp_arr, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	kref_init(&sfp->f_ref);
 	mutex_init(&sfp->f_mutex);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
@@ -2552,6 +2677,7 @@ sg_add_sfp(struct sg_device *sdp)
 	sfp->parentdp = sdp;
 	atomic_set(&sfp->submitted, 0);
 	atomic_set(&sfp->waiting, 0);
+	atomic_set(&sfp->req_cnt, 0);
 
 	if (SG_IS_DETACHING(sdp)) {
 		kfree(sfp);
@@ -2598,11 +2724,13 @@ static void
 sg_remove_sfp_usercontext(struct work_struct *work)
 {
 	__maybe_unused int o_count;
-	unsigned long iflags;
+	unsigned long idx, iflags;
 	struct sg_device *sdp;
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew_fd.work);
 	struct sg_fd *e_sfp;
 	struct sg_request *srp;
+	struct sg_request *e_srp;
+	struct xarray *xafp = &sfp->srp_arr;
 
 	if (!sfp) {
 		pr_warn("sg: %s: sfp is NULL\n", __func__);
@@ -2611,15 +2739,20 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 	sdp = sfp->parentdp;
 
 	/* Cleanup any responses which were never read(). */
-	spin_lock_irqsave(&sfp->rq_list_lock, iflags);
-	while (!list_empty(&sfp->rq_list)) {
-		srp = list_first_entry(&sfp->rq_list, struct sg_request, entry);
-		sg_finish_scsi_blk_rq(srp);
-		list_del(&srp->entry);
-		srp->parentfp = NULL;
-	}
-	spin_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-
+	xa_for_each(xafp, idx, srp) {
+		if (!srp)
+			continue;
+		if (!xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE))
+			sg_finish_scsi_blk_rq(srp);
+		xa_lock_irqsave(xafp, iflags);
+		e_srp = __xa_erase(xafp, srp->rq_idx);
+		xa_unlock_irqrestore(xafp, iflags);
+		if (srp != e_srp)
+			SG_LOG(1, sfp, "%s: xa_erase() return unexpected\n",
+			       __func__);
+		kfree(srp);
+	}
+	xa_destroy(xafp);
 	if (sfp->reserve.buflen > 0) {
 		SG_LOG(6, sfp, "%s:    buflen=%d, num_sgat=%d\n", __func__,
 		       (int)sfp->reserve.buflen, (int)sfp->reserve.num_sgat);
@@ -2708,7 +2841,9 @@ sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
 		return long_str ? "unknown" : "unk";
 	}
 }
-#else
+
+#elif IS_ENABLED(CONFIG_SG_LOG_ACTIVE)
+
 static const char *
 sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
 {
@@ -2960,7 +3095,7 @@ static void
 sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 {
 	int k, new_interface, blen, usg;
-	unsigned long idx;
+	unsigned long idx, idx2;
 	struct sg_request *srp;
 	struct sg_fd *fp;
 	const struct sg_io_hdr *hp;
@@ -2972,7 +3107,6 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 		if (!fp)
 			continue;
 		k++;
-		spin_lock(&fp->rq_list_lock); /* irqs already disabled */
 		seq_printf(s, "   FD(%d): timeout=%dms buflen=%d (res)sgat=%d idx=%lu\n",
 			   k, jiffies_to_msecs(fp->timeout),
 			   fp->reserve.buflen, (int)fp->reserve.num_sgat, idx);
@@ -2982,7 +3116,9 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 		seq_printf(s, "   submitted=%d waiting=%d\n",
 			   atomic_read(&fp->submitted),
 			   atomic_read(&fp->waiting));
-		list_for_each_entry(srp, &fp->rq_list, entry) {
+		xa_for_each(&fp->srp_arr, idx2, srp) {
+			if (!srp)
+				continue;
 			hp = &srp->header;
 			new_interface = (hp->interface_id == '\0') ? 0 : 1;
 			if (srp->res_used) {
@@ -3018,9 +3154,8 @@ sg_proc_debug_helper(struct seq_file *s, struct sg_device *sdp)
 				   (int)srp->data.cmd_opcode,
 				   sg_rq_st_str(SG_RS_INACTIVE, false));
 		}
-		if (list_empty(&fp->rq_list))
+		if (xa_empty(&fp->srp_arr))
 			seq_puts(s, "     No requests active\n");
-		spin_unlock(&fp->rq_list_lock);
 	}
 }
 
-- 
2.37.3

