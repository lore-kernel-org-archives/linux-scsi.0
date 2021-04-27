Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43B0C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E1D6613F1
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbhD0WAO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:14 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38999 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239270AbhD0V7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 31920204277;
        Tue, 27 Apr 2021 23:58:58 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vodIH04KjH+h; Tue, 27 Apr 2021 23:58:54 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 358A52041BB;
        Tue, 27 Apr 2021 23:58:53 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 52/83] sg: add multiple request support
Date:   Tue, 27 Apr 2021 17:57:02 -0400
Message-Id: <20210427215733.417746-54-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before the write() and read() system calls were removed from
the bsg driver (around lk 4.15) bsg supported multiple SCSI
requests being submitted in a single invocation. It did this
by passing an array of struct sg_io_v4 objects to the write()
whose third argument (the size the second argument points to)
is then a multiple of sizeof(sg_io_v4).

Doing the same with ioctl(SG_IOSUBMIT) is not practical since
with an ioctl() there is no "length of passed object" argument.
Further the __IOWR macro used to generate the ioctl number for
SG_IOSUBMIT encodes the expected length of the passed object,
and that is the size of a _single_ struct sg_io_v4 object.
So an indirect approach is taken: any object passed to
ioctl(SG_IO), ioctl(SG_IOSUBMIT) and ioctl(SG_IORECEIVE) with
SGV4_FLAG_MULTIPLE_REQS set is interpreted as a "controlling
object". It is parsed differently from other struct sg_io_v4
objects. Its data-out buffer contains an array of "normal"
struct sg_io_v4 objects.

Multiple requests can be combined with shared file
descriptors with SGV4_FLAG_DO_ON_OTHER indicating the other
file descriptor (in the share) is to be used for the
command it appears with. Multiple requests can be combined
with shared requests.

As a further optimisation, an array of SCSI commands can
be passed from the user space via the controlling object's
request "pointer". Without that, the multiple request
logic would need to visit the user space once per command
to pick up each SCSI command (cdb).

See the webpage at: https://sg.danny.cz/sg/sg_v40.html
in the section titled: "10 Multiple requests"

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 784 +++++++++++++++++++++++++++++++++++++----
 include/uapi/scsi/sg.h |  15 +-
 2 files changed, 722 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f43cfd2ae739..635a3e2b10e5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -61,6 +61,7 @@ static char *sg_version_date = "20210421";
 #define SG_ALLOW_DIO_DEF 0
 
 #define SG_MAX_DEVS 32768
+#define SG_MAX_MULTI_REQ_SZ (2 * 1024 * 1024)
 
 /* Comment out the following line to compile out SCSI_LOGGING stuff */
 #define SG_DEBUG 1
@@ -75,7 +76,8 @@ static char *sg_version_date = "20210421";
 #define SG_PROC_OR_DEBUG_FS 1
 #endif
 
-/* SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
+/*
+ * SG_MAX_CDB_SIZE should be 260 (spc4r37 section 3.1.30) however the type
  * of sg_io_hdr::cmd_len can only represent 255. All SCSI commands greater
  * than 16 bytes are "variable length" whose length is a multiple of 4, so:
  */
@@ -213,6 +215,7 @@ struct sg_slice_hdr4 {	/* parts of sg_io_v4 object needed in async usage */
 	s16 dir;		/* data xfer direction; SG_DXFER_*  */
 	u16 cmd_len;		/* truncated of sg_io_v4::request_len */
 	u16 max_sb_len;		/* truncated of sg_io_v4::max_response_len */
+	u16 mrq_ind;		/* position in parentfp->mrq_arr */
 };
 
 struct sg_scatter_hold {     /* holding area for scsi scatter gather info */
@@ -257,7 +260,7 @@ struct sg_request {	/* active SCSI command or inactive request */
 
 struct sg_fd {		/* holds the state of a file descriptor */
 	struct sg_device *parentdp;	/* owning device */
-	wait_queue_head_t read_wait;	/* queue read until command done */
+	wait_queue_head_t cmpl_wait;	/* queue awaiting req completion */
 	struct mutex f_mutex;	/* serialize ioctls on this fd */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
@@ -310,6 +313,7 @@ struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 	};
 	struct sg_fd *sfp;
 	const u8 __user *u_cmdp;
+	const u8 *cmdp;
 };
 
 /* tasklet or soft irq callback */
@@ -327,6 +331,10 @@ static int sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp,
 static int sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 			struct sg_request **o_srp);
 static struct sg_request *sg_common_write(struct sg_comm_wr_t *cwrp);
+static int sg_wait_event_srp(struct sg_fd *sfp, void __user *p,
+			     struct sg_io_v4 *h4p, struct sg_request *srp);
+static int sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp,
+			 void __user *p, struct sg_io_v4 *h4p);
 static int sg_read_append(struct sg_request *srp, void __user *outp,
 			  int num_xfer);
 static void sg_remove_sgat(struct sg_request *srp);
@@ -335,6 +343,7 @@ static void sg_remove_sfp(struct kref *);
 static void sg_remove_sfp_share(struct sg_fd *sfp, bool is_rd_side);
 static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id,
 					    bool is_tag);
+static bool sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp);
 static struct sg_request *sg_setup_req(struct sg_comm_wr_t *cwrp,
 				       enum sg_shr_var sh_var, int dxfr_len);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
@@ -364,7 +373,6 @@ static const char *sg_shr_str(enum sg_shr_var sh_var, bool long_str);
 #define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
 #define SG_IS_O_NONBLOCK(sfp) (!!((sfp)->filp->f_flags & O_NONBLOCK))
 #define SG_RQ_ACTIVE(srp) (atomic_read(&(srp)->rq_st) != SG_RQ_INACTIVE)
-// #define SG_RQ_THIS_RQ(srp) ((srp)->sh_var == SG_SHR_RS_RQ)
 
 /*
  * Kernel needs to be built with CONFIG_SCSI_LOGGING to see log messages.
@@ -662,6 +670,16 @@ sg_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+/*
+ * ***********************************************************************
+ * write(2) related functions follow. They are shown before read(2) related
+ * functions. That is because SCSI commands/requests are first "written" to
+ * the SCSI device by using write(2), ioctl(SG_IOSUBMIT) or the first half
+ * of the synchronous ioctl(SG_IO) system call.
+ * ***********************************************************************
+ */
+
+/* This is the write(2) system call entry point. v4 interface disallowed. */
 static ssize_t
 sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 {
@@ -804,6 +822,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	cwr.cmd_len = cmd_size;
 	cwr.sfp = sfp;
 	cwr.u_cmdp = p;
+	cwr.cmdp = NULL;
 	srp = sg_common_write(&cwr);
 	return (IS_ERR(srp)) ? PTR_ERR(srp) : (int)count;
 }
@@ -831,7 +850,7 @@ sg_fetch_cmnd(struct sg_fd *sfp, const u8 __user *u_cdbp, int len, u8 *cdbp)
 		return -EMSGSIZE;
 	if (copy_from_user(cdbp, u_cdbp, len))
 		return -EFAULT;
-	if (O_RDWR != (sfp->filp->f_flags & O_ACCMODE)) { /* read-only */
+	if (O_RDWR != (sfp->filp->f_flags & O_ACCMODE)) {	/* read-only */
 		switch (sfp->parentdp->device->type) {
 		case TYPE_DISK:
 		case TYPE_RBC:
@@ -853,6 +872,8 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 	struct sg_comm_wr_t cwr;
 
 	/* now doing v3 blocking (sync) or non-blocking submission */
+	if (hp->flags & SGV4_FLAG_MULTIPLE_REQS)
+		return -ERANGE;		/* need to use v4 interface */
 	if (hp->flags & SG_FLAG_MMAP_IO) {
 		int res = sg_chk_mmap(sfp, hp->flags, hp->dxfer_len);
 
@@ -869,6 +890,7 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 	cwr.cmd_len = hp->cmd_len;
 	cwr.sfp = sfp;
 	cwr.u_cmdp = hp->cmdp;
+	cwr.cmdp = NULL;
 	srp = sg_common_write(&cwr);
 	if (IS_ERR(srp))
 		return PTR_ERR(srp);
@@ -877,6 +899,423 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 	return 0;
 }
 
+static void
+sg_sgv4_out_zero(struct sg_io_v4 *h4p)
+{
+	h4p->driver_status = 0;
+	h4p->transport_status = 0;
+	h4p->device_status = 0;
+	h4p->retry_delay = 0;
+	h4p->info = 0;
+	h4p->response_len = 0;
+	h4p->duration = 0;
+	h4p->din_resid = 0;
+	h4p->dout_resid = 0;
+	h4p->generated_tag = 0;
+	h4p->spare_out = 0;
+}
+
+/*
+ * Takes a pointer to the controlling multiple request (mrq) object and a
+ * pointer to the command array. The command array (with tot_reqs elements)
+ * is written out (flushed) to user space pointer cop->din_xferp. The
+ * secondary error value (s_res) is placed in the cop->spare_out field.
+ */
+static int
+sg_mrq_arr_flush(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds, u32 tot_reqs,
+		 int s_res)
+{
+	u32 sz = min(tot_reqs * SZ_SG_IO_V4, cop->din_xfer_len);
+	void __user *p = uptr64(cop->din_xferp);
+
+	if (s_res)
+		cop->spare_out = -s_res;
+	if (!p)
+		return 0;
+	if (sz > 0) {
+		if (copy_to_user(p, a_hds, sz))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+static int
+sg_mrq_1complet(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
+		struct sg_fd *w_sfp, int tot_reqs, struct sg_request *srp)
+{
+	int s_res, indx;
+	struct sg_io_v4 *siv4p;
+
+	SG_LOG(3, w_sfp, "%s: start, tot_reqs=%d\n", __func__, tot_reqs);
+	if (!srp)
+		return -EPROTO;
+	indx = srp->s_hdr4.mrq_ind;
+	if (indx < 0 || indx >= tot_reqs)
+		return -EPROTO;
+	siv4p = a_hds + indx;
+	s_res = sg_receive_v4(w_sfp, srp, NULL, siv4p);
+	if (s_res == -EFAULT)
+		return s_res;
+	siv4p->info |= SG_INFO_MRQ_FINI;
+	if (w_sfp->async_qp && (siv4p->flags & SGV4_FLAG_SIGNAL)) {
+		s_res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
+		if (unlikely(s_res))	/* can only be -EFAULT */
+			return s_res;
+		kill_fasync(&w_sfp->async_qp, SIGPOLL, POLL_IN);
+	}
+	return 0;
+}
+
+/*
+ * This is a fair-ish algorithm for an interruptible wait on two file
+ * descriptors. It favours the main fd over the secondary fd (sec_sfp).
+ */
+static int
+sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
+		struct sg_fd *sfp, struct sg_fd *sec_sfp, int tot_reqs,
+		int mreqs, int sec_reqs)
+{
+	int res;
+	int sum_inflight = mreqs + sec_reqs;	/* may be < tot_reqs */
+	struct sg_request *srp;
+
+	SG_LOG(3, sfp, "%s: mreqs=%d, sec_reqs=%d\n", __func__, mreqs,
+	       sec_reqs);
+	for ( ; sum_inflight > 0; --sum_inflight) {
+		srp = NULL;
+		if (mreqs > 0 && sg_mrq_get_ready_srp(sfp, &srp)) {
+			if (IS_ERR(srp)) {	/* -ENODATA: no mrqs here */
+				mreqs = 0;
+			} else {
+				--mreqs;
+				res = sg_mrq_1complet(cop, a_hds, sfp,
+						      tot_reqs, srp);
+				if (unlikely(res))
+					return res;
+			}
+		} else if (sec_reqs > 0 &&
+			   sg_mrq_get_ready_srp(sec_sfp, &srp)) {
+			if (IS_ERR(srp)) {
+				sec_reqs = 0;
+			} else {
+				--sec_reqs;
+				res = sg_mrq_1complet(cop, a_hds, sec_sfp,
+						      tot_reqs, srp);
+				if (unlikely(res))
+					return res;
+			}
+		} else if (mreqs > 0) {
+			res = wait_event_interruptible
+					(sfp->cmpl_wait,
+					 sg_mrq_get_ready_srp(sfp, &srp));
+			if (unlikely(res))
+				return res;	/* signal --> -ERESTARTSYS */
+			if (IS_ERR(srp)) {
+				mreqs = 0;
+			} else {
+				--mreqs;
+				res = sg_mrq_1complet(cop, a_hds, sfp,
+						      tot_reqs, srp);
+				if (unlikely(res))
+					return res;
+			}
+		} else if (sec_reqs > 0) {
+			res = wait_event_interruptible
+					(sec_sfp->cmpl_wait,
+					 sg_mrq_get_ready_srp(sec_sfp, &srp));
+			if (unlikely(res))
+				return res;	/* signal --> -ERESTARTSYS */
+			if (IS_ERR(srp)) {
+				sec_reqs = 0;
+			} else {
+				--sec_reqs;
+				res = sg_mrq_1complet(cop, a_hds, sec_sfp,
+						      tot_reqs, srp);
+				if (unlikely(res))
+					return res;
+			}
+		} else { /* expect one of the above conditions to be true */
+			return -EPROTO;
+		}
+		if (cop->din_xfer_len > 0)
+			--cop->din_resid;
+	}
+	return 0;
+}
+
+static int
+sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
+	      struct sg_io_v4 *a_hds, u8 *cdb_ap, struct sg_fd *sfp,
+	      u32 tot_reqs)
+{
+	bool immed = !!(cop->flags & SGV4_FLAG_IMMED);
+	bool have_mrq_sense = (cop->response && cop->max_response_len);
+	int k;
+	u32 cdb_alen = cop->request_len;
+	u32 cdb_mxlen = cdb_alen / tot_reqs;
+	u32 flags;
+	struct sg_io_v4 *siv4p;
+	__maybe_unused const char *rip = "request index";
+
+	/* Pre-check each request for anomalies */
+	for (k = 0, siv4p = a_hds; k < tot_reqs; ++k, ++siv4p) {
+		flags = siv4p->flags;
+		sg_sgv4_out_zero(siv4p);
+		if (siv4p->guard != 'Q' || siv4p->protocol != 0 ||
+		    siv4p->subprotocol != 0) {
+			SG_LOG(1, sfp, "%s: req index %u: %s or protocol\n",
+			       __func__, k, "bad guard");
+			return -ERANGE;
+		}
+		if (flags & SGV4_FLAG_MULTIPLE_REQS) {
+			SG_LOG(1, sfp, "%s: %s %u: no nested multi-reqs\n",
+			       __func__, rip, k);
+			return -ERANGE;
+		}
+		if (immed) {	/* only accept async submits on current fd */
+			if (flags & SGV4_FLAG_DO_ON_OTHER) {
+				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
+				       rip, k, "no IMMED with ON_OTHER");
+				return -ERANGE;
+			} else if (flags & SGV4_FLAG_SHARE) {
+				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
+				       rip, k, "no IMMED with FLAG_SHARE");
+				return -ERANGE;
+			} else if (flags & SGV4_FLAG_COMPLETE_B4) {
+				SG_LOG(1, sfp, "%s: %s %u, %s\n", __func__,
+				       rip, k, "no IMMED with COMPLETE_B4");
+				return -ERANGE;
+			}
+		}
+		if (!sg_fd_is_shared(sfp)) {
+			if (flags & SGV4_FLAG_SHARE) {
+				SG_LOG(1, sfp, "%s: %s %u, no share\n",
+				       __func__, rip, k);
+				return -ERANGE;
+			} else if (flags & SGV4_FLAG_DO_ON_OTHER) {
+				SG_LOG(1, sfp, "%s: %s %u, %s do on\n",
+				       __func__, rip, k, "no other fd to");
+				return -ERANGE;
+			}
+		}
+		if (cdb_ap) {
+			if (siv4p->request_len > cdb_mxlen) {
+				SG_LOG(1, sfp, "%s: %s %u, cdb too long\n",
+				       __func__, rip, k);
+				return -ERANGE;
+			}
+		}
+		if (have_mrq_sense && siv4p->response == 0 &&
+		    siv4p->max_response_len == 0) {
+			siv4p->response = cop->response;
+			siv4p->max_response_len = cop->max_response_len;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Implements the multiple request functionality. When blocking is true
+ * invocation was via ioctl(SG_IO), otherwise it was via ioctl(SG_IOSUBMIT).
+ * Only fully non-blocking if IMMED flag given or when ioctl(SG_IOSUBMIT)
+ * is used with O_NONBLOCK set on its file descriptor.
+ */
+static int
+sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
+{
+	bool set_this, set_other, immed, stop_if, f_non_block;
+	int res = 0;
+	int s_res = 0;	/* for secondary error: some-good-then-error, case */
+	int other_fp_sent = 0;
+	int this_fp_sent = 0;
+	int num_cmpl = 0;
+	const int shr_complet_b4 = SGV4_FLAG_SHARE | SGV4_FLAG_COMPLETE_B4;
+	unsigned long ul_timeout;
+	struct sg_io_v4 *cop = cwrp->h4p;
+	u32 k, n, flags, cdb_mxlen;
+	u32 blen = cop->dout_xfer_len;
+	u32 cdb_alen = cop->request_len;
+	u32 tot_reqs = blen / SZ_SG_IO_V4;
+	struct sg_io_v4 *siv4p;
+	u8 *cdb_ap = NULL;
+	struct sg_io_v4 *a_hds;
+	struct sg_fd *fp = cwrp->sfp;
+	struct sg_fd *o_sfp = sg_fd_share_ptr(fp);
+	struct sg_fd *rq_sfp;
+	struct sg_request *srp;
+	struct sg_device *sdp = fp->parentdp;
+
+	f_non_block = !!(fp->filp->f_flags & O_NONBLOCK);
+	immed = !!(cop->flags & SGV4_FLAG_IMMED);
+	stop_if = !!(cop->flags & SGV4_FLAG_STOP_IF);
+	if (blocking) {		/* came from ioctl(SG_IO) */
+		if (unlikely(immed)) {
+			SG_LOG(1, fp, "%s: ioctl(SG_IO) %s contradicts\n",
+			       __func__, "with SGV4_FLAG_IMMED");
+			return -ERANGE;
+		}
+		if (unlikely(f_non_block)) {
+			SG_LOG(6, fp, "%s: ioctl(SG_IO) %s O_NONBLOCK\n",
+			       __func__, "ignoring");
+			f_non_block = false;
+		}
+	}
+	if (!immed && f_non_block)
+		immed = true;
+	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, cdb_alen=%u\n", __func__,
+	       (immed ? "IMMED" : (blocking ?  "ordered blocking" :
+				   "variable blocking")), tot_reqs, cdb_alen);
+	sg_sgv4_out_zero(cop);
+
+	if (unlikely(tot_reqs > U16_MAX)) {
+		return -ERANGE;
+	} else if (unlikely(blen > SG_MAX_MULTI_REQ_SZ ||
+			    cdb_alen > SG_MAX_MULTI_REQ_SZ)) {
+		return  -E2BIG;
+	} else if (unlikely(immed && stop_if)) {
+		return -ERANGE;
+	} else if (unlikely(tot_reqs == 0)) {
+		return 0;
+	} else if (unlikely(!!cdb_alen != !!cop->request)) {
+		return -ERANGE;	/* both must be zero or both non-zero */
+	} else if (cdb_alen) {
+		if (unlikely(cdb_alen % tot_reqs))
+			return -ERANGE;
+		cdb_mxlen = cdb_alen / tot_reqs;
+		if (unlikely(cdb_mxlen < 6))
+			return -ERANGE;	/* too short for SCSI cdbs */
+	} else {
+		cdb_mxlen = 0;
+	}
+
+	if (unlikely(SG_IS_DETACHING(sdp)))
+		return -ENODEV;
+	else if (unlikely(o_sfp && SG_IS_DETACHING((o_sfp->parentdp))))
+		return -ENODEV;
+
+	a_hds = kcalloc(tot_reqs, SZ_SG_IO_V4, GFP_KERNEL | __GFP_NOWARN);
+	if (!a_hds)
+		return -ENOMEM;
+	n = tot_reqs * SZ_SG_IO_V4;
+	if (copy_from_user(a_hds, cuptr64(cop->dout_xferp), n)) {
+		res = -EFAULT;
+		goto fini;
+	}
+	if (cdb_alen > 0) {
+		cdb_ap = kzalloc(cdb_alen, GFP_KERNEL | __GFP_NOWARN);
+		if (unlikely(!cdb_ap)) {
+			res = -ENOMEM;
+			goto fini;
+		}
+		if (copy_from_user(cdb_ap, cuptr64(cop->request), cdb_alen)) {
+			res = -EFAULT;
+			goto fini;
+		}
+	}
+	/* do sanity checks on all requests before starting */
+	res = sg_mrq_sanity(sdp, cop, a_hds, cdb_ap, fp, tot_reqs);
+	if (unlikely(res))
+		goto fini;
+	set_this = false;
+	set_other = false;
+	/* Dispatch requests and optionally wait for response */
+	for (k = 0, siv4p = a_hds; k < tot_reqs; ++k, ++siv4p) {
+		flags = siv4p->flags;
+		if (flags & SGV4_FLAG_DO_ON_OTHER) {
+			rq_sfp = o_sfp;
+			if (!set_other) {
+				set_other = true;
+				set_bit(SG_FFD_CMD_Q, rq_sfp->ffd_bm);
+			}
+		} else {
+			rq_sfp = fp;
+			if (!set_this) {
+				set_this = true;
+				set_bit(SG_FFD_CMD_Q, rq_sfp->ffd_bm);
+			}
+		}
+		if (cdb_ap) {	/* already have array of cdbs */
+			cwrp->cmdp = cdb_ap + (k * cdb_mxlen);
+			cwrp->u_cmdp = NULL;
+		} else {	/* fetch each cdb from user space */
+			cwrp->cmdp = NULL;
+			cwrp->u_cmdp = cuptr64(siv4p->request);
+		}
+		cwrp->cmd_len = siv4p->request_len;
+		ul_timeout = msecs_to_jiffies(siv4p->timeout);
+		cwrp->frq_bm[0] = 0;
+		assign_bit(SG_FRQ_SYNC_INVOC, cwrp->frq_bm, (int)blocking);
+		set_bit(SG_FRQ_IS_V4I, cwrp->frq_bm);
+		cwrp->h4p = siv4p;
+		cwrp->timeout = min_t(unsigned long, ul_timeout, INT_MAX);
+		cwrp->sfp = rq_sfp;
+		srp = sg_common_write(cwrp);
+		if (IS_ERR(srp)) {
+			s_res = PTR_ERR(srp);
+			break;
+		}
+		srp->s_hdr4.mrq_ind = k;
+		if (immed || (!(blocking || (flags & shr_complet_b4)))) {
+			if (fp == rq_sfp)
+				++this_fp_sent;
+			else
+				++other_fp_sent;
+			continue;  /* defer completion until all submitted */
+		}
+		s_res = sg_wait_event_srp(rq_sfp, NULL, siv4p, srp);
+		if (s_res) {
+			if (s_res == -ERESTARTSYS) {
+				res = s_res;
+				goto fini;
+			}
+			break;
+		}
+		if (!srp) {
+			s_res = -EPROTO;
+			break;
+		}
+		++num_cmpl;
+		siv4p->info |= SG_INFO_MRQ_FINI;
+		if (stop_if && (siv4p->driver_status ||
+				siv4p->transport_status ||
+				siv4p->device_status)) {
+			SG_LOG(2, fp, "%s: %s=0x%x/0x%x/0x%x] cause exit\n",
+			       __func__, "STOP_IF and status [drv/tran/scsi",
+			       siv4p->driver_status, siv4p->transport_status,
+			       siv4p->device_status);
+			break;	/* cop::driver_status <-- 0 in this case */
+		}
+		if (rq_sfp->async_qp && (siv4p->flags & SGV4_FLAG_SIGNAL)) {
+			res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
+			if (unlikely(res))
+				break;
+			kill_fasync(&rq_sfp->async_qp, SIGPOLL, POLL_IN);
+		}
+	}	/* end of dispatch request and optionally wait loop */
+	cop->dout_resid = tot_reqs - k;
+	cop->info = k;
+	if (cop->din_xfer_len > 0) {
+		cop->din_resid = tot_reqs - num_cmpl;
+		cop->spare_out = -s_res;
+	}
+
+	if (immed)
+		goto fini;
+
+	if (res == 0 && (this_fp_sent + other_fp_sent) > 0) {
+		s_res = sg_mrq_complets(cop, a_hds, fp, o_sfp, tot_reqs,
+					this_fp_sent, other_fp_sent);
+		if (s_res == -EFAULT || s_res == -ERESTARTSYS)
+			res = s_res;	/* this may leave orphans */
+	}
+fini:
+	if (res == 0 && !immed)
+		res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
+	kfree(cdb_ap);
+	kfree(a_hds);
+	return res;
+}
+
 static int
 sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 	     bool sync, struct sg_request **o_srp)
@@ -886,6 +1325,27 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 	struct sg_request *srp;
 	struct sg_comm_wr_t cwr;
 
+	if (h4p->flags & SGV4_FLAG_MULTIPLE_REQS) {
+		/* want v4 async or sync with guard, din and dout and flags */
+		if (!h4p->dout_xferp || h4p->din_iovec_count ||
+		    h4p->dout_iovec_count ||
+		    (h4p->dout_xfer_len % SZ_SG_IO_V4))
+			return -ERANGE;
+		if (o_srp)
+			*o_srp = NULL;
+		memset(&cwr, 0, sizeof(cwr));
+		cwr.sfp = sfp;
+		cwr.h4p = h4p;
+		res = sg_do_multi_req(&cwr, sync);
+		if (unlikely(res))
+			return res;
+		if (p) {
+			/* Write back sg_io_v4 object for error/warning info */
+			if (copy_to_user(p, h4p, SZ_SG_IO_V4))
+				return -EFAULT;
+		}
+		return 0;
+	}
 	if (h4p->flags & SG_FLAG_MMAP_IO) {
 		int len = 0;
 
@@ -908,6 +1368,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	cwr.cmd_len = h4p->request_len;
 	cwr.u_cmdp = cuptr64(h4p->request);
+	cwr.cmdp = NULL;
 	srp = sg_common_write(&cwr);
 	if (IS_ERR(srp))
 		return PTR_ERR(srp);
@@ -928,14 +1389,14 @@ static int
 sg_ctl_iosubmit(struct sg_fd *sfp, void __user *p)
 {
 	int res;
-	u8 hdr_store[SZ_SG_IO_V4];
-	struct sg_io_v4 *h4p = (struct sg_io_v4 *)hdr_store;
+	struct sg_io_v4 h4;
+	struct sg_io_v4 *h4p = &h4;
 	struct sg_device *sdp = sfp->parentdp;
 
 	res = sg_allow_if_err_recovery(sdp, SG_IS_O_NONBLOCK(sfp));
 	if (res)
 		return res;
-	if (copy_from_user(hdr_store, p, SZ_SG_IO_V4))
+	if (copy_from_user(h4p, p, SZ_SG_IO_V4))
 		return -EFAULT;
 	if (h4p->guard == 'Q')
 		return sg_submit_v4(sfp, p, h4p, false, NULL);
@@ -946,8 +1407,8 @@ static int
 sg_ctl_iosubmit_v3(struct sg_fd *sfp, void __user *p)
 {
 	int res;
-	u8 hdr_store[SZ_SG_IO_V4];	/* max(v3interface, v4interface) */
-	struct sg_io_hdr *h3p = (struct sg_io_hdr *)hdr_store;
+	struct sg_io_hdr h3;
+	struct sg_io_hdr *h3p = &h3;
 	struct sg_device *sdp = sfp->parentdp;
 
 	res = sg_allow_if_err_recovery(sdp, SG_IS_O_NONBLOCK(sfp));
@@ -1237,7 +1698,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 			dxfr_len = h4p->dout_xfer_len;
 			dir = SG_DXFER_TO_DEV;
 		}
-	} else {                /* sg v3 interface so hi_p valid */
+	} else {			/* sg v3 interface so hi_p valid */
 		h4p = NULL;
 		hi_p = cwrp->h3p;
 		dir = hi_p->dxfer_direction;
@@ -1245,6 +1706,8 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		rq_flags = hi_p->flags;
 		pack_id = hi_p->pack_id;
 	}
+	if (rq_flags & SGV4_FLAG_MULTIPLE_REQS)
+		return ERR_PTR(-ERANGE);
 	if (sg_fd_is_shared(fp)) {
 		res = sg_share_chk_flags(fp, rq_flags, dxfr_len, dir, &sh_var);
 		if (unlikely(res < 0))
@@ -1290,6 +1753,14 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 	return ERR_PTR(res);
 }
 
+/*
+ * ***********************************************************************
+ * read(2) related functions follow. They are shown after write(2) related
+ * functions. Apart from read(2) itself, ioctl(SG_IORECEIVE) and the second
+ * half of the ioctl(SG_IO) share code with read(2).
+ * ***********************************************************************
+ */
+
 /*
  * This function is called by wait_event_interruptible in sg_read() and
  * sg_ctl_ioreceive(). wait_event_interruptible will return if this one
@@ -1302,7 +1773,7 @@ sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int id,
 	struct sg_request *srp;
 
 	if (unlikely(SG_IS_DETACHING(sfp->parentdp))) {
-		*srpp = NULL;
+		*srpp = ERR_PTR(-ENODEV);
 		return true;
 	}
 	srp = sg_find_srp_by_id(sfp, id, is_tag);
@@ -1388,11 +1859,11 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 			sh_sfp->ws_srp = NULL;
 			break;  /* nothing to do */
 		default:
-			err = -EPROTO;  /* Logic error */
+			err = -EPROTO;	/* Logic error */
 			SG_LOG(1, sfp,
 			       "%s: SHR_WS_RQ, bad read-side state: %s\n",
 			       __func__, sg_rq_st_str(mar_st, true));
-			break;  /* nothing to do */
+			break;	/* nothing to do */
 		}
 	}
 	if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
@@ -1410,7 +1881,7 @@ sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
 	case SG_SHR_RS_RQ:
 		{
 			int poll_type = POLL_OUT;
-			struct sg_fd *sh_sfp = sg_fd_share_ptr(sfp);
+			struct sg_fd *ws_sfp = sg_fd_share_ptr(sfp);
 
 			if ((srp->rq_result & SG_ML_RESULT_MSK) || other_err) {
 				set_bit(SG_FFD_READ_SIDE_ERR, sfp->ffd_bm);
@@ -1420,8 +1891,10 @@ sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
 			} else if (sr_st != SG_RQ_SHR_SWAP) {
 				sg_rq_chg_state_force(srp, SG_RQ_SHR_SWAP);
 			}
-			if (sh_sfp)
-				kill_fasync(&sh_sfp->async_qp, SIGPOLL,
+			if (ws_sfp && ws_sfp->async_qp &&
+			    (!test_bit(SG_FRQ_IS_V4I, srp->frq_bm) ||
+			     (srp->rq_flags & SGV4_FLAG_SIGNAL)))
+				kill_fasync(&ws_sfp->async_qp, SIGPOLL,
 					    poll_type);
 		}
 		break;
@@ -1495,6 +1968,99 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 	return err < 0 ? err : 0;
 }
 
+/*
+ * Returns negative on error including -ENODATA if there are no mrqs submitted
+ * nor waiting. Otherwise it returns the number of elements written to
+ * rsp_arr, which may be 0 if mrqs submitted but none waiting
+ */
+static int
+sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs,
+		      struct sg_io_v4 *rsp_arr)
+{
+	int k;
+	int res = 0;
+	struct sg_request *srp;
+
+	SG_LOG(3, sfp, "%s: max_mrqs=%d\n", __func__, max_mrqs);
+	for (k = 0; k < max_mrqs; ++k) {
+		if (!sg_mrq_get_ready_srp(sfp, &srp))
+			break;
+		if (IS_ERR(srp))
+			return k ? k : PTR_ERR(srp);
+		res = sg_receive_v4(sfp, srp, NULL, rsp_arr + k);
+		if (unlikely(res))
+			return res;
+		rsp_arr[k].info |= SG_INFO_MRQ_FINI;
+	}
+	if (non_block)
+		return k;
+
+	for ( ; k < max_mrqs; ++k) {
+		res = wait_event_interruptible
+				(sfp->cmpl_wait,
+				 sg_mrq_get_ready_srp(sfp, &srp));
+		if (unlikely(res))
+			return res;	/* signal --> -ERESTARTSYS */
+		if (IS_ERR(srp))
+			return k ? k : PTR_ERR(srp);
+		res = sg_receive_v4(sfp, srp, NULL, rsp_arr + k);
+		if (unlikely(res))
+			return res;
+		rsp_arr[k].info |= SG_INFO_MRQ_FINI;
+	}
+	return k;
+}
+
+/*
+ * Expected race as multiple concurrent calls with the same pack_id/tag can
+ * occur. Only one should succeed per request (more may succeed but will get
+ * different requests).
+ */
+static int
+sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p,
+		 bool non_block)
+{
+	int res = 0;
+	u32 len, n;
+	struct sg_io_v4 *rsp_v4_arr;
+	void __user *pp;
+
+	SG_LOG(3, sfp, "%s: non_block=%d\n", __func__, !!non_block);
+	n = cop->din_xfer_len;
+	if (n > SG_MAX_MULTI_REQ_SZ)
+		return -E2BIG;
+	if (!cop->din_xferp || n < SZ_SG_IO_V4 || (n % SZ_SG_IO_V4))
+		return -ERANGE;
+	n /= SZ_SG_IO_V4;
+	len = n * SZ_SG_IO_V4;
+	SG_LOG(3, sfp, "%s: %s, num_reqs=%u\n", __func__,
+	       (non_block ? "IMMED" : "blocking"), n);
+	rsp_v4_arr = kcalloc(n, SZ_SG_IO_V4, GFP_KERNEL);
+	if (!rsp_v4_arr)
+		return -ENOMEM;
+
+	sg_sgv4_out_zero(cop);
+	cop->din_resid = n;
+	res = sg_mrq_iorec_complets(sfp, non_block, n, rsp_v4_arr);
+	if (unlikely(res < 0))
+		goto fini;
+	cop->din_resid -= res;
+	cop->info = res;
+	if (copy_to_user(p, cop, sizeof(*cop)))
+		return -EFAULT;
+	res = 0;
+	pp = uptr64(cop->din_xferp);
+	if (pp) {
+		if (copy_to_user(pp, rsp_v4_arr, len))
+			res = -EFAULT;
+	} else {
+		pr_info("%s: cop->din_xferp==NULL ?_?\n", __func__);
+	}
+fini:
+	kfree(rsp_v4_arr);
+	return res;
+}
+
 /*
  * Called when ioctl(SG_IORECEIVE) received. Expects a v4 interface object.
  * Checks if O_NONBLOCK file flag given, if not checks given 'flags' field
@@ -1527,6 +2093,8 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 	if (h4p->flags & SGV4_FLAG_IMMED)
 		non_block = true;	/* set by either this or O_NONBLOCK */
 	SG_LOG(3, sfp, "%s: non_block(+IMMED)=%d\n", __func__, non_block);
+	if (h4p->flags & SGV4_FLAG_MULTIPLE_REQS)
+		return sg_mrq_ioreceive(sfp, h4p, p, non_block);
 	/* read in part of v3 or v4 header for pack_id or tag based find */
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm)) {
 		use_tag = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm);
@@ -1544,12 +2112,12 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 		if (non_block)
 			return -EAGAIN;
 		res = wait_event_interruptible
-				(sfp->read_wait,
+				(sfp->cmpl_wait,
 				 sg_get_ready_srp(sfp, &srp, id, use_tag));
-		if (unlikely(SG_IS_DETACHING(sdp)))
-			return -ENODEV;
 		if (res)
 			return res;	/* signal --> -ERESTARTSYS */
+		if (IS_ERR(srp))
+			return PTR_ERR(srp);
 	}	/* now srp should be valid */
 	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
 		cpu_relax();
@@ -1588,6 +2156,8 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 	if (h3p->flags & SGV4_FLAG_IMMED)
 		non_block = true;	/* set by either this or O_NONBLOCK */
 	SG_LOG(3, sfp, "%s: non_block(+IMMED)=%d\n", __func__, non_block);
+	if (h3p->flags & SGV4_FLAG_MULTIPLE_REQS)
+		return -EINVAL;
 
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm))
 		pack_id = h3p->pack_id;
@@ -1599,12 +2169,12 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 		if (non_block)
 			return -EAGAIN;
 		res = wait_event_interruptible
-				(sfp->read_wait,
+				(sfp->cmpl_wait,
 				 sg_get_ready_srp(sfp, &srp, pack_id, false));
-		if (unlikely(SG_IS_DETACHING(sdp)))
-			return -ENODEV;
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
+		if (IS_ERR(srp))
+			return PTR_ERR(srp);
 	}	/* now srp should be valid */
 	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
 		cpu_relax();
@@ -1782,12 +2352,12 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 		if (non_block) /* O_NONBLOCK or v3::flags & SGV4_FLAG_IMMED */
 			return -EAGAIN;
 		ret = wait_event_interruptible
-				(sfp->read_wait,
+				(sfp->cmpl_wait,
 				 sg_get_ready_srp(sfp, &srp, want_id, false));
-		if (unlikely(SG_IS_DETACHING(sdp)))
-			return -ENODEV;
 		if (ret)	/* -ERESTARTSYS as signal hit process */
 			return ret;
+		if (IS_ERR(srp))
+			return PTR_ERR(srp);
 		/* otherwise srp should be valid */
 	}
 	if (test_and_set_bit(SG_FRQ_RECEIVING, srp->frq_bm)) {
@@ -1840,6 +2410,7 @@ sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, void __user *p)
 	hp->driver_status = driver_byte(rq_result);
 	err2 = put_sg_io_hdr(hp, p);
 	err = err ? err : err2;
+	sg_complete_v3v4(sfp, srp, err < 0);
 	sg_finish_scsi_blk_rq(srp);
 	sg_deact_request(sfp, srp);
 	return err;
@@ -2094,7 +2665,7 @@ sg_do_unshare(struct sg_fd *sfp, bool unshare_val)
 	struct sg_fd *o_sfp = sg_fd_share_ptr(sfp);
 	struct sg_device *sdp = sfp->parentdp;
 
-	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_UNSHARED)) {
+	if (!sg_fd_is_shared(sfp)) {
 		SG_LOG(1, sfp, "%s: not shared ? ?\n", __func__);
 		return;	/* no share to undo */
 	}
@@ -2176,7 +2747,6 @@ sg_calc_rq_dur(const struct sg_request *srp, bool time_in_ns)
 	return (diff > (s64)U32_MAX) ? 3999999999U : (u32)diff;
 }
 
-/* Return of U32_MAX means srp is inactive state */
 static u32
 sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
 	   bool time_in_ns, bool *is_durp)
@@ -2255,7 +2825,7 @@ sg_wait_event_srp(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 	}
 	SG_LOG(3, sfp, "%s: about to wait_event...()\n", __func__);
 	/* usually will be woken up by sg_rq_end_io() callback */
-	res = wait_event_interruptible(sfp->read_wait,
+	res = wait_event_interruptible(sfp->cmpl_wait,
 				       sg_rq_landed(sdp, srp));
 	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
 		set_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
@@ -2344,6 +2914,7 @@ sg_ctl_sg_io(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
  */
 static struct sg_request *
 sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
+		__must_hold(&sfp->rq_list_lock)
 {
 	int num_waiting = atomic_read(&sfp->waiting);
 	unsigned long idx;
@@ -2376,7 +2947,8 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		__must_hold(sfp->f_mutex)
 {
 	bool use_tag;
-	int res, pack_id, tag, id;
+	int pack_id, tag, id;
+	int res = 0;
 	unsigned long iflags, idx;
 	struct sg_fd *o_sfp;
 	struct sg_request *srp;
@@ -2412,16 +2984,16 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 			return -ENODATA;
 	}
 
-	set_bit(SG_FRQ_ABORTING, srp->frq_bm);
-	res = 0;
+	if (test_and_set_bit(SG_FRQ_ABORTING, srp->frq_bm))
+		goto fini;
+
 	switch (atomic_read(&srp->rq_st)) {
 	case SG_RQ_BUSY:
 		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
 		res = -EBUSY;	/* should not occur often */
 		break;
-	case SG_RQ_INACTIVE:	/* inactive on rq_list not good */
+	case SG_RQ_INACTIVE:	/* perhaps done already */
 		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
-		res = -EPROTO;
 		break;
 	case SG_RQ_AWAIT_RCV:	/* user should still do completion */
 	case SG_RQ_SHR_SWAP:
@@ -2441,6 +3013,7 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 		clear_bit(SG_FRQ_ABORTING, srp->frq_bm);
 		break;
 	}
+fini:
 	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 	return res;
 }
@@ -2469,8 +3042,7 @@ sg_find_sfp_helper(struct sg_fd *from_sfp, struct sg_fd *pair_sfp,
 
 	if (unlikely(!mutex_trylock(&pair_sfp->f_mutex)))
 		return -EPROBE_DEFER;	/* use to suggest re-invocation */
-	if (unlikely(!xa_get_mark(&pair_sdp->sfp_arr, pair_sfp->idx,
-				  SG_XA_FD_UNSHARED)))
+	if (unlikely(sg_fd_is_shared(pair_sfp)))
 		res = -EADDRNOTAVAIL;
 	else if (unlikely(SG_HAVE_EXCLUDE(pair_sdp)))
 		res = -EPERM;
@@ -2569,8 +3141,7 @@ sg_find_sfp_by_fd(const struct file *search_for, int search_fd,
 			if (unlikely(!sdp || SG_IS_DETACHING(sdp)))
 				continue;
 			xa_for_each(&sdp->sfp_arr, idx, sfp) {
-				if (xa_get_mark(&sdp->sfp_arr, idx,
-						SG_XA_FD_UNSHARED))
+				if (!sg_fd_is_shared(sfp))
 					continue;
 				if (search_for == sfp->filp) {
 					res = -EADDRNOTAVAIL;  /* already */
@@ -2608,8 +3179,7 @@ sg_fd_share(struct sg_fd *ws_sfp, int m_fd)
 	if (unlikely(m_fd < 0))
 		return -EBADF;
 
-	if (unlikely(!xa_get_mark(&ws_sfp->parentdp->sfp_arr, ws_sfp->idx,
-				  SG_XA_FD_UNSHARED)))
+	if (unlikely(sg_fd_is_shared(ws_sfp)))
 		return -EADDRINUSE;  /* don't allow chain of shares */
 	/* Alternate approach: fcheck_files(current->files, m_fd) */
 	filp = fget(m_fd);
@@ -2726,8 +3296,7 @@ sg_set_reserved_sz(struct sg_fd *sfp, int want_rsv_sz)
 	struct sg_device *sdp = sfp->parentdp;
 	struct xarray *xafp = &sfp->srp_arr;
 
-	if (unlikely(!xa_get_mark(&sfp->parentdp->sfp_arr, sfp->idx,
-				  SG_XA_FD_UNSHARED)))
+	if (unlikely(sg_fd_is_shared(sfp)))
 		return -EBUSY;	/* this fd can't be either side of share */
 	o_srp = sfp->rsv_srp;
 	if (!o_srp)
@@ -2824,7 +3393,7 @@ static bool
 sg_any_persistent_orphans(struct sg_fd *sfp)
 {
 	if (test_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm)) {
-		int num_waiting = atomic_read(&sfp->waiting);
+		int num_waiting = atomic_read_acquire(&sfp->waiting);
 		unsigned long idx;
 		struct sg_request *srp;
 		struct xarray *xafp = &sfp->srp_arr;
@@ -2832,8 +3401,6 @@ sg_any_persistent_orphans(struct sg_fd *sfp)
 		if (num_waiting < 1)
 			return false;
 		xa_for_each_marked(xafp, idx, srp, SG_XA_RQ_AWAIT) {
-			if (unlikely(!srp))
-				continue;
 			if (test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm))
 				return true;
 		}
@@ -2916,10 +3483,10 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 		c_flgs_val_out &= ~SG_CTL_FLAGM_UNSHARE;	/* clear bit */
 	/* IS_SHARE boolean: [ro] true if fd may be read-side or write-side share */
 	if (c_flgs_rm & SG_CTL_FLAGM_IS_SHARE) {
-		if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_UNSHARED))
-			c_flgs_val_out &= ~SG_CTL_FLAGM_IS_SHARE;
-		else
+		if (sg_fd_is_shared(sfp))
 			c_flgs_val_out |= SG_CTL_FLAGM_IS_SHARE;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_IS_SHARE;
 	}
 	/* IS_READ_SIDE boolean: [ro] true if this fd may be a read-side share */
 	if (c_flgs_rm & SG_CTL_FLAGM_IS_READ_SIDE) {
@@ -3335,6 +3902,7 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
 		return put_user(val, ip);
 	case SG_GET_NUM_WAITING:
+		/* Want as fast as possible, with a useful result */
 		if (test_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm))
 			sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready */
 		val = atomic_read(&sfp->waiting);
@@ -3625,7 +4193,7 @@ sg_poll(struct file *filp, poll_table *wait)
 		sg_sfp_blk_poll(sfp, 0);	/* LLD may have some ready to push up */
 	num = atomic_read(&sfp->waiting);
 	if (num < 1) {
-		poll_wait(filp, &sfp->read_wait, wait);
+		poll_wait(filp, &sfp->cmpl_wait, wait);
 		num = atomic_read(&sfp->waiting);
 	}
 	if (num > 0)
@@ -3866,8 +4434,8 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	if (test_bit(SG_FRQ_ABORTING, srp->frq_bm) && rq_result == 0)
 		srp->rq_result |= (DRIVER_HARD << 24);
 
-	SG_LOG(6, sfp, "%s: pack_id=%d, tag=%d, res=0x%x\n", __func__,
-	       srp->pack_id, srp->tag, srp->rq_result);
+	SG_LOG(6, sfp, "%s: pack/tag_id=%d/%d, cmd=0x%x, res=0x%x\n", __func__,
+	       srp->pack_id, srp->tag, srp->cmd_opcode, srp->rq_result);
 	if (srp->start_ns > 0)	/* zero only when SG_FFD_NO_DURATION is set */
 		srp->duration = sg_calc_rq_dur(srp, test_bit(SG_FFD_TIME_IN_NS,
 							     sfp->ffd_bm));
@@ -3936,8 +4504,10 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	if (likely(rqq_state == SG_RQ_AWAIT_RCV)) {
 		/* Wake any sg_read()/ioctl(SG_IORECEIVE) awaiting this req */
 		if (!(srp->rq_flags & SGV4_FLAG_HIPRI))
-			wake_up_interruptible(&sfp->read_wait);
-		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
+			wake_up_interruptible(&sfp->cmpl_wait);
+		if (sfp->async_qp && (!test_bit(SG_FRQ_IS_V4I, srp->frq_bm) ||
+				      (srp->rq_flags & SGV4_FLAG_SIGNAL)))
+			kill_fasync(&sfp->async_qp, SIGPOLL, POLL_IN);
 		kref_put(&sfp->f_ref, sg_remove_sfp);
 	} else {        /* clean up orphaned request that aren't being kept */
 		INIT_WORK(&srp->ew_orph.work, sg_rq_end_io_usercontext);
@@ -4008,6 +4578,7 @@ sg_add_device_helper(struct gendisk *disk, struct scsi_device *scsidp)
 	xa_init_flags(&sdp->sfp_arr, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	init_waitqueue_head(&sdp->open_wait);
 	clear_bit(SG_FDEV_DETACHING, sdp->fdev_bm);
+	atomic_set(&sdp->open_cnt, 0);
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
 	error = 0;
@@ -4142,8 +4713,9 @@ sg_remove_device(struct device *cl_dev, struct class_interface *cl_intf)
 					"%s: 0x%pK\n", __func__, sdp));
 
 	xa_for_each(&sdp->sfp_arr, idx, sfp) {
-		wake_up_interruptible_all(&sfp->read_wait);
-		kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
+		wake_up_interruptible_all(&sfp->cmpl_wait);
+		if (sfp->async_qp)
+			kill_fasync(&sfp->async_qp, SIGPOLL, POLL_HUP);
 	}
 	wake_up_interruptible_all(&sdp->open_wait);
 
@@ -4310,7 +4882,6 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	int dxfer_len = 0;
 	int r0w = READ;
 	u32 rq_flags = srp->rq_flags;
-	int blk_flgs;
 	unsigned int iov_count = 0;
 	void __user *up;
 	struct request *rqq;
@@ -4327,8 +4898,10 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	sdp = sfp->parentdp;
 	if (cwrp->cmd_len > BLK_MAX_CDB) {	/* for longer SCSI cdb_s */
 		long_cmdp = kzalloc(cwrp->cmd_len, GFP_KERNEL);
-		if (!long_cmdp)
-			return -ENOMEM;
+		if (!long_cmdp) {
+			res = -ENOMEM;
+			goto err_out;
+		}
 		SG_LOG(5, sfp, "%s: long_cmdp=0x%pK ++\n", __func__, long_cmdp);
 	}
 	if (test_bit(SG_FRQ_IS_V4I, srp->frq_bm)) {
@@ -4364,13 +4937,13 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	 * boolean set on this file descriptor, returns -EAGAIN if
 	 * blk_get_request(BLK_MQ_REQ_NOWAIT) yields EAGAIN (aka EWOULDBLOCK).
 	 */
-	blk_flgs = (test_bit(SG_FFD_MORE_ASYNC, sfp->ffd_bm)) ?
-						BLK_MQ_REQ_NOWAIT : 0;
 	rqq = blk_get_request(q, (r0w ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN),
-			      blk_flgs);
+			      (test_bit(SG_FFD_MORE_ASYNC, sfp->ffd_bm) ?
+						BLK_MQ_REQ_NOWAIT : 0));
 	if (IS_ERR(rqq)) {
 		kfree(long_cmdp);
-		return PTR_ERR(rqq);
+		res = PTR_ERR(rqq);
+		goto err_out;
 	}
 	/* current sg_request protected by SG_RQ_BUSY state */
 	scsi_rp = scsi_req(rqq);
@@ -4384,10 +4957,12 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	if (cwrp->u_cmdp)
 		res = sg_fetch_cmnd(sfp, cwrp->u_cmdp, cwrp->cmd_len,
 				    scsi_rp->cmd);
+	else if (cwrp->cmdp)
+		memcpy(scsi_rp->cmd, cwrp->cmdp, cwrp->cmd_len);
 	else
 		res = -EPROTO;
 	if (res)
-		goto fini;
+		goto err_out;
 	scsi_rp->cmd_len = cwrp->cmd_len;
 	srp->cmd_opcode = scsi_rp->cmd[0];
 	us_xfer = !(rq_flags & (SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO));
@@ -4467,6 +5042,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	} else {
 		srp->bio = rqq->bio;
 	}
+err_out:
 	SG_LOG((res ? 1 : 4), sfp, "%s: %s %s res=%d [0x%pK]\n", __func__,
 	       sg_shr_str(srp->sh_var, false), cp, res, srp);
 	return res;
@@ -4620,7 +5196,7 @@ sg_remove_sgat(struct sg_request *srp)
 
 	SG_LOG(4, sfp, "%s: num_sgat=%d%s\n", __func__, schp->num_sgat,
 	       ((srp->parentfp ? (sfp->rsv_srp == srp) : false) ?
-		" [rsv]" : ""));
+							" [rsv]" : ""));
 	sg_remove_sgat_helper(sfp, schp);
 
 	if (sfp->tot_fd_thresh > 0) {
@@ -4809,6 +5385,65 @@ sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 	return srp;
 }
 
+/*
+ * Returns true if a request is ready and its srp is written to *srpp . If
+ * nothing can be found (because nothing is currently submitted) then true
+ * is returned and ERR_PTR(-ENODATA) --> *srpp . If nothing is found but
+ * sfp has requests submitted, returns false and NULL --> *srpp .
+ */
+static bool
+sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp)
+{
+	bool second = false;
+	int num_waiting, res;
+	int l_await_idx = READ_ONCE(sfp->low_await_idx);
+	unsigned long idx, s_idx, end_idx;
+	struct sg_request *srp;
+	struct xarray *xafp = &sfp->srp_arr;
+
+	if (unlikely(SG_IS_DETACHING(sfp->parentdp))) {
+		*srpp = ERR_PTR(-ENODEV);
+		return true;
+	}
+	if (atomic_read(&sfp->submitted) < 1) {
+		*srpp = ERR_PTR(-ENODATA);
+		return true;
+	}
+	num_waiting = atomic_read_acquire(&sfp->waiting);
+	if (num_waiting < 1)
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
+		res = sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
+		if (likely(res == 0)) {
+			*srpp = srp;
+			WRITE_ONCE(sfp->low_await_idx, idx + 1);
+			return true;
+		}
+#if IS_ENABLED(SG_LOG_ACTIVE)
+		sg_rq_state_fail_msg(sfp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY, __func__);
+#endif
+	}
+	/* If not found so far, need to wrap around and search [0 ... end_idx) */
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
 /*
  * Makes a new sg_request object. If 'first' is set then use GFP_KERNEL which
  * may take time but has improved chance of success, otherwise use GFP_ATOMIC.
@@ -4819,7 +5454,7 @@ static struct sg_request *
 sg_mk_srp(struct sg_fd *sfp, bool first)
 {
 	struct sg_request *srp;
-	gfp_t gfp =  __GFP_NOWARN;
+	gfp_t gfp = __GFP_NOWARN;
 
 	if (first)      /* prepared to wait if none already outstanding */
 		srp = kzalloc(sizeof(*srp), gfp | GFP_KERNEL);
@@ -4915,7 +5550,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 	enum sg_rq_state sr_st;
 	enum sg_rq_state rs_sr_st = SG_RQ_INACTIVE;
 	struct sg_fd *fp = cwrp->sfp;
-	struct sg_request *r_srp = NULL;	/* request to return */
+	struct sg_request *r_srp = NULL; /* returned value won't be NULL */
 	struct sg_request *low_srp = NULL;
 	__maybe_unused struct sg_request *rsv_srp;
 	struct sg_request *rs_rsv_srp = NULL;
@@ -4942,6 +5577,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 				goto good_fini;
 			}
 		}
+		/* Did not find the reserve request available */
 		r_srp = ERR_PTR(-EBUSY);
 		break;
 	case SG_SHR_RS_NOT_SRQ:
@@ -4954,7 +5590,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 			break;
 		}
 		/*
-		 * Contention here may be with another potential write-side trying
+		 * There may be contention with another potential write-side trying
 		 * to pair with this read-side. The loser will receive an
 		 * EADDRINUSE errno. The winner advances read-side's rq_state:
 		 *     SG_RQ_SHR_SWAP --> SG_RQ_SHR_IN_WS
@@ -4964,6 +5600,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		switch (rs_sr_st) {
 		case SG_RQ_AWAIT_RCV:
 			if (rs_rsv_srp->rq_result & SG_ML_RESULT_MSK) {
+				/* read-side done but error occurred */
 				r_srp = ERR_PTR(-ENOSTR);
 				break;
 			}
@@ -4992,7 +5629,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 	}
 	if (IS_ERR(r_srp)) {
 		if (PTR_ERR(r_srp) == -EBUSY)
-			goto err_out2;
+			goto err_out;
 		if (sh_var == SG_SHR_RS_RQ)
 			snprintf(b, sizeof(b), "SG_SHR_RS_RQ --> sr_st=%s",
 				 sg_rq_st_str(sr_st, false));
@@ -5153,12 +5790,11 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 	} else if (sh_var == SG_SHR_RS_RQ && test_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm))
 		clear_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm);
 err_out:
-	if (IS_ERR(r_srp) && b[0])
+	if (IS_ERR(r_srp) && PTR_ERR(r_srp) != -EBUSY && b[0])
 		SG_LOG(1, fp, "%s: bad %s\n", __func__, b);
 	if (!IS_ERR(r_srp))
 		SG_LOG(4, fp, "%s: %s %sr_srp=0x%pK\n", __func__, cp,
 		       ((r_srp == fp->rsv_srp) ? "[rsv] " : ""), r_srp);
-err_out2:
 	return r_srp;
 }
 
@@ -5214,7 +5850,7 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 	sfp = kzalloc(sizeof(*sfp), GFP_ATOMIC | __GFP_NOWARN);
 	if (!sfp)
 		return ERR_PTR(-ENOMEM);
-	init_waitqueue_head(&sfp->read_wait);
+	init_waitqueue_head(&sfp->cmpl_wait);
 	xa_init_flags(&sfp->srp_arr, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
 	xafp = &sfp->srp_arr;
 	kref_init(&sfp->f_ref);
@@ -5722,11 +6358,11 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 	struct sg_request *srp;
 	struct sg_device *sdp = fp->parentdp;
 
-	if (xa_get_mark(&sdp->sfp_arr, fp->idx, SG_XA_FD_UNSHARED))
-		cp = "";
-	else
+	if (sg_fd_is_shared(fp))
 		cp = xa_get_mark(&sdp->sfp_arr, fp->idx, SG_XA_FD_RS_SHARE) ?
-			" shr_rs" : " shr_ws";
+			" shr_rs" : " shr_rs";
+	else
+		cp = "";
 	/* sgat=-1 means unavailable */
 	to = (fp->timeout >= 0) ? jiffies_to_msecs(fp->timeout) : -999;
 	if (to < 0)
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 272001a69d01..e1919eadf036 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -32,7 +32,11 @@
 #include <linux/types.h>
 #include <linux/major.h>
 
-/* bsg.h contains the sg v4 user space interface structure (sg_io_v4). */
+/*
+ * bsg.h contains the sg v4 user space interface structure (sg_io_v4).
+ * That structure is also used as the controlling object when multiple
+ * requests are issued with one ioctl() call.
+ */
 #include <linux/bsg.h>
 
 /*
@@ -110,11 +114,16 @@ typedef struct sg_io_hdr {
 #define SGV4_FLAG_YIELD_TAG 0x8  /* sg_io_v4::generated_tag set after SG_IOS */
 #define SGV4_FLAG_Q_AT_TAIL SG_FLAG_Q_AT_TAIL
 #define SGV4_FLAG_Q_AT_HEAD SG_FLAG_Q_AT_HEAD
+#define SGV4_FLAG_COMPLETE_B4  0x100
+#define SGV4_FLAG_SIGNAL  0x200	/* v3: ignored; v4 signal on completion */
 #define SGV4_FLAG_IMMED 0x400 /* for polling with SG_IOR, ignored in SG_IOS */
 #define SGV4_FLAG_HIPRI 0x800 /* request will use blk_poll to complete */
-#define SGV4_FLAG_DEV_SCOPE 0x1000 /* permit SG_IOABORT to have wider scope */
-#define SGV4_FLAG_SHARE 0x2000	/* share IO buffer; needs SG_SEIM_SHARE_FD */
+#define SGV4_FLAG_STOP_IF 0x1000	/* Stops sync mrq if error or warning */
+#define SGV4_FLAG_DEV_SCOPE 0x2000 /* permit SG_IOABORT to have wider scope */
+#define SGV4_FLAG_SHARE 0x4000	/* share IO buffer; needs SG_SEIM_SHARE_FD */
+#define SGV4_FLAG_DO_ON_OTHER 0x8000 /* available on either of shared pair */
 #define SGV4_FLAG_NO_DXFER SG_FLAG_NO_DXFER /* but keep dev<-->kernel xfr */
+#define SGV4_FLAG_MULTIPLE_REQS 0x20000	/* n sg_io_v4s in data-in */
 
 /* Output (potentially OR-ed together) in v3::info or v4::info field */
 #define SG_INFO_OK_MASK 0x1
-- 
2.25.1

