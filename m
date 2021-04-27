Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D9CC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 820A1613FF
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbhD0V74 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 17:59:56 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38966 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239468AbhD0V7c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 227502041C0;
        Tue, 27 Apr 2021 23:58:47 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hIU5MNe-m8kY; Tue, 27 Apr 2021 23:58:44 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 460182041BB;
        Tue, 27 Apr 2021 23:58:43 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 46/83] sg: add sg_ioabort ioctl
Date:   Tue, 27 Apr 2021 17:56:56 -0400
Message-Id: <20210427215733.417746-48-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add ioctl(SG_IOABORT) that acts as a front-end to
blk_abort_request() which is only called if the request
is "inflight". The request to abort is matched via its
pack_id and the scope of the search is the current
device.

That scope will be fine tuned in a later patch to being
either all file descriptors belonging to the current
device, or just the current file descriptor.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 170 ++++++++++++++++++++++++++++++-----------
 include/uapi/scsi/sg.h |   3 +
 2 files changed, 128 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b5dc274a57c0..d8628517fbe0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -113,6 +113,7 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FRQ_IS_ORPHAN	1	/* owner of request gone */
 #define SG_FRQ_SYNC_INVOC	2	/* synchronous (blocking) invocation */
 #define SG_FRQ_NO_US_XFER	3	/* no user space transfer of data */
+#define SG_FRQ_ABORTING		4	/* in process of aborting this cmd */
 #define SG_FRQ_DEACT_ORPHAN	6	/* not keeping orphan so de-activate */
 #define SG_FRQ_RECEIVING	7	/* guard against multiple receivers */
 #define SG_FRQ_FOR_MMAP		8	/* request needs PAGE_SIZE elements */
@@ -1794,6 +1795,93 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	return res;
 }
 
+static struct sg_request *
+sg_match_request(struct sg_fd *sfp, int id)
+{
+	int num_waiting = atomic_read(&sfp->waiting);
+	unsigned long idx;
+	struct sg_request *srp;
+
+	if (num_waiting < 1)
+		return NULL;
+	if (id == SG_PACK_ID_WILDCARD) {
+		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT)
+			return srp;
+	} else {
+		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
+			if (id == srp->pack_id)
+				return srp;
+		}
+	}
+	return NULL;
+}
+
+static int
+sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
+{
+	int res, pack_id, id;
+	unsigned long iflags, idx;
+	struct sg_fd *o_sfp;
+	struct sg_request *srp;
+	struct sg_io_v4 io_v4;
+	struct sg_io_v4 *h4p = &io_v4;
+
+	if (copy_from_user(h4p, p, SZ_SG_IO_V4))
+		return -EFAULT;
+	if (h4p->guard != 'Q' || h4p->protocol != 0 || h4p->subprotocol != 0)
+		return -EPERM;
+	pack_id = h4p->request_extra;
+	id = pack_id;
+
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	srp = sg_match_request(sfp, id);
+	if (!srp) {	/* assume device (not just fd) scope */
+		xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+		xa_for_each(&sdp->sfp_arr, idx, o_sfp) {
+			if (o_sfp == sfp)
+				continue;	/* already checked */
+			srp = sg_match_request(o_sfp, id);
+			if (srp) {
+				sfp = o_sfp;
+				xa_lock_irqsave(&sfp->srp_arr, iflags);
+				break;
+			}
+		}
+		if (!srp)
+			return -ENODATA;
+	}
+
+	set_bit(SG_FRQ_ABORTING, srp->frq_bm);
+	res = 0;
+	switch (atomic_read(&srp->rq_st)) {
+	case SG_RS_BUSY:
+		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		res = -EBUSY;	/* shouldn't occur often */
+		break;
+	case SG_RS_INACTIVE:	/* inactive on rq_list not good */
+		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		res = -EPROTO;
+		break;
+	case SG_RS_AWAIT_RCV:	/* user should still do completion */
+		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		break;		/* nothing to do here, return 0 */
+	case SG_RS_INFLIGHT:	/* only attempt abort if inflight */
+		srp->rq_result |= (DRIVER_SOFT << 24);
+		{
+			struct request *rqq = READ_ONCE(srp->rqq);
+
+			if (rqq)
+				blk_abort_request(rqq);
+		}
+		break;
+	default:
+		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
+		break;
+	}
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
+	return res;
+}
+
 /*
  * First normalize want_rsv_sz to be >= sfp->sgat_elem_sz and
  * <= max_segment_size. Exit if that is the same as old size; otherwise
@@ -1929,8 +2017,6 @@ sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
 		return -ENOMEM;
 	val = 0;
 	xa_for_each(&sfp->srp_arr, idx, srp) {
-		if (!srp)
-			continue;
 		if (val >= SG_MAX_QUEUE)
 			break;
 		if (xa_get_mark(&sfp->srp_arr, idx, SG_XA_RQ_INACTIVE))
@@ -1939,8 +2025,6 @@ sg_ctl_req_tbl(struct sg_fd *sfp, void __user *p)
 		val++;
 	}
 	xa_for_each(&sfp->srp_arr, idx, srp) {
-		if (!srp)
-			continue;
 		if (val >= SG_MAX_QUEUE)
 			break;
 		if (!xa_get_mark(&sfp->srp_arr, idx, SG_XA_RQ_INACTIVE))
@@ -1990,7 +2074,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 {
 	bool read_only = O_RDWR != (filp->f_flags & O_ACCMODE);
 	int val;
-	int result = 0;
+	int res = 0;
 	int __user *ip = p;
 	struct sg_request *srp;
 	struct scsi_device *sdev;
@@ -2018,13 +2102,21 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	case SG_IORECEIVE_V3:
 		SG_LOG(3, sfp, "%s:    SG_IORECEIVE_V3\n", __func__);
 		return sg_ctl_ioreceive_v3(filp, sfp, p);
+	case SG_IOABORT:
+		SG_LOG(3, sfp, "%s:    SG_IOABORT\n", __func__);
+		if (read_only)
+			return -EPERM;
+		mutex_lock(&sfp->f_mutex);
+		res = sg_ctl_abort(sdp, sfp, p);
+		mutex_unlock(&sfp->f_mutex);
+		return res;
 	case SG_GET_SCSI_ID:
 		return sg_ctl_scsi_id(sdev, sfp, p);
 	case SG_SET_FORCE_PACK_ID:
 		SG_LOG(3, sfp, "%s:    SG_SET_FORCE_PACK_ID\n", __func__);
-		result = get_user(val, ip);
-		if (result)
-			return result;
+		res = get_user(val, ip);
+		if (res)
+			return res;
 		assign_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm, !!val);
 		return 0;
 	case SG_GET_PACK_ID:    /* or tag of oldest "read"-able, -1 if none */
@@ -2049,18 +2141,18 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		       sdp->max_sgat_sz);
 		return put_user(sdp->max_sgat_sz, ip);
 	case SG_SET_RESERVED_SIZE:
-		result = get_user(val, ip);
-		if (!result) {
+		res = get_user(val, ip);
+		if (!res) {
 			if (val >= 0 && val <= (1024 * 1024 * 1024)) {
 				mutex_lock(&sfp->f_mutex);
-				result = sg_set_reserved_sz(sfp, val);
+				res = sg_set_reserved_sz(sfp, val);
 				mutex_unlock(&sfp->f_mutex);
 			} else {
 				SG_LOG(3, sfp, "%s: invalid size\n", __func__);
-				result = -EINVAL;
+				res = -EINVAL;
 			}
 		}
-		return result;
+		return res;
 	case SG_GET_RESERVED_SIZE:
 		mutex_lock(&sfp->f_mutex);
 		val = min_t(int, sfp->rsv_srp->sgat_h.buflen,
@@ -2068,13 +2160,13 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		mutex_unlock(&sfp->f_mutex);
 		SG_LOG(3, sfp, "%s:    SG_GET_RESERVED_SIZE=%d\n",
 		       __func__, val);
-		result = put_user(val, ip);
-		return result;
+		res = put_user(val, ip);
+		return res;
 	case SG_SET_COMMAND_Q:
 		SG_LOG(3, sfp, "%s:    SG_SET_COMMAND_Q\n", __func__);
-		result = get_user(val, ip);
-		if (result)
-			return result;
+		res = get_user(val, ip);
+		if (res)
+			return res;
 		assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, !!val);
 		return 0;
 	case SG_GET_COMMAND_Q:
@@ -2082,9 +2174,9 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return put_user(test_bit(SG_FFD_CMD_Q, sfp->ffd_bm), ip);
 	case SG_SET_KEEP_ORPHAN:
 		SG_LOG(3, sfp, "%s:    SG_SET_KEEP_ORPHAN\n", __func__);
-		result = get_user(val, ip);
-		if (result)
-			return result;
+		res = get_user(val, ip);
+		if (res)
+			return res;
 		assign_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm, !!val);
 		return 0;
 	case SG_GET_KEEP_ORPHAN:
@@ -2101,9 +2193,9 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		break;
 	case SG_SET_TIMEOUT:
 		SG_LOG(3, sfp, "%s:    SG_SET_TIMEOUT\n", __func__);
-		result = get_user(val, ip);
-		if (result)
-			return result;
+		res = get_user(val, ip);
+		if (res)
+			return res;
 		if (val < 0)
 			return -EIO;
 		if (val >= mult_frac((s64)INT_MAX, USER_HZ, HZ))
@@ -2129,9 +2221,9 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return put_user((int)sdev->host->unchecked_isa_dma, ip);
 	case SG_NEXT_CMD_LEN:	/* active only in v2 interface */
 		SG_LOG(3, sfp, "%s:    SG_NEXT_CMD_LEN\n", __func__);
-		result = get_user(val, ip);
-		if (result)
-			return result;
+		res = get_user(val, ip);
+		if (res)
+			return res;
 		if (val > SG_MAX_CDB_SIZE)
 			return -ENOMEM;
 		mutex_lock(&sfp->f_mutex);
@@ -2154,9 +2246,9 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 				     p);
 	case SG_SET_DEBUG:
 		SG_LOG(3, sfp, "%s:    SG_SET_DEBUG\n", __func__);
-		result = get_user(val, ip);
-		if (result)
-			return result;
+		res = get_user(val, ip);
+		if (res)
+			return res;
 		assign_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm, !!val);
 		if (val == 0)	/* user can force recalculation */
 			sg_calc_sgat_param(sdp);
@@ -2201,9 +2293,9 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 			return -EPERM;	/* don't know, so take safer approach */
 		break;
 	}
-	result = sg_allow_if_err_recovery(sdp, filp->f_flags & O_NDELAY);
-	if (unlikely(result))
-		return result;
+	res = sg_allow_if_err_recovery(sdp, filp->f_flags & O_NDELAY);
+	if (unlikely(res))
+		return res;
 	return -ENOIOCTLCMD;
 }
 
@@ -2844,8 +2936,6 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 					"%s: 0x%pK\n", __func__, sdp));
 
 	xa_for_each(&sdp->sfp_arr, idx, sfp) {
-		if (!sfp)
-			continue;
 		wake_up_interruptible_all(&sfp->read_wait);
 		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
@@ -3867,8 +3957,6 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 
 	/* Cleanup any responses which were never read(). */
 	xa_for_each(xafp, idx, srp) {
-		if (!srp)
-			continue;
 		if (!xa_get_mark(xafp, srp->rq_idx, SG_XA_RQ_INACTIVE))
 			sg_finish_scsi_blk_rq(srp);
 		if (srp->sgat_h.buflen > 0)
@@ -4173,7 +4261,6 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 /* Writes debug info for one sg_request in obp buffer */
 static int
 sg_proc_debug_sreq(struct sg_request *srp, int to, char *obp, int len)
-		__must_hold(sfp->srp_arr.xa_lock)
 {
 	bool is_v3v4, v4, is_dur;
 	int n = 0;
@@ -4243,8 +4330,6 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 	k = 0;
 	xa_lock_irqsave(&fp->srp_arr, iflags);
 	xa_for_each(&fp->srp_arr, idx, srp) {
-		if (!srp)
-			continue;
 		if (xa_get_mark(&fp->srp_arr, idx, SG_XA_RQ_INACTIVE))
 			continue;
 		n += sg_proc_debug_sreq(srp, fp->timeout, obp + n, len - n);
@@ -4259,8 +4344,6 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 		n += scnprintf(obp + n, len - n, "     No requests active\n");
 	k = 0;
 	xa_for_each_marked(&fp->srp_arr, idx, srp, SG_XA_RQ_INACTIVE) {
-		if (!srp)
-			continue;
 		if (k == 0)
 			n += scnprintf(obp + n, len - n, "   Inactives:\n");
 		n += sg_proc_debug_sreq(srp, fp->timeout, obp + n, len - n);
@@ -4278,7 +4361,6 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 /* Writes debug info for one sg device (including its sg fds) in obp buffer */
 static int
 sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len, int *fd_counterp)
-		__must_hold(sg_index_lock)
 {
 	int n = 0;
 	int my_count = 0;
@@ -4298,8 +4380,6 @@ sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len, int *fd_counterp)
 		       ilog2(sdp->max_sgat_sz), sdp->max_sgat_elems,
 		       SG_HAVE_EXCLUDE(sdp), atomic_read(&sdp->open_cnt));
 	xa_for_each(&sdp->sfp_arr, idx, fp) {
-		if (!fp)
-			continue;
 		++*countp;
 		n += scnprintf(obp + n, len - n, "  FD(%d): ", *countp);
 		n += sg_proc_debug_fd(fp, obp + n, len - n, idx);
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 079ef6c57aea..2b1b9df6c114 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -364,6 +364,9 @@ struct sg_header {
 /* Gives some v3 identifying info to driver, receives associated response */
 #define SG_IORECEIVE_V3 _IOWR(SG_IOCTL_MAGIC_NUM, 0x46, struct sg_io_hdr)
 
+/* Provides identifying info about a prior submission (e.g. a tag) */
+#define SG_IOABORT _IOW(SG_IOCTL_MAGIC_NUM, 0x43, struct sg_io_v4)
+
 /* command queuing is always on when the v3 or v4 interface is used */
 #define SG_DEF_COMMAND_Q 0
 
-- 
2.25.1

