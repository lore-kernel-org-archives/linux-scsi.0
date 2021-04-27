Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD54CC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1C76613FF
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbhD0WAF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:05 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38982 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239478AbhD0V7f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 073CA2041D7;
        Tue, 27 Apr 2021 23:58:50 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IRuW97qzt4zw; Tue, 27 Apr 2021 23:58:46 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id E1FCE20426D;
        Tue, 27 Apr 2021 23:58:44 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 47/83] sg: add sg_set_get_extended ioctl
Date:   Tue, 27 Apr 2021 17:56:57 -0400
Message-Id: <20210427215733.417746-49-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add ioctl(SG_SET_GET_EXTENDED) together with its interface:
struct sg_extended_info which is 96 bytes long, only half
of which is currently used. The "SET_GET" component of the
name is to stress data flows towards and back from the ioctl.

That ioctl has three sections: one for getting and setting 32
bit quantities, a second section for manipulating boolean
(bit) flags, and a final section for reading 32 bit
quantities where a well known value is written and the
corresponding value is read back. Several settings can be
made in one invocation.

See the webpage at: https://sg.danny.cz/sg/sg_v40.html
specifically in section 14 titled: "IOCTLs".

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 274 +++++++++++++++++++++++++++++++++++++----
 include/uapi/scsi/sg.h |  69 +++++++++++
 2 files changed, 320 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d8628517fbe0..17a733d621c7 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -42,7 +42,7 @@ static char *sg_version_date = "20210421";
 #include <linux/ratelimit.h>
 #include <linux/uio.h>
 #include <linux/cred.h>			/* for sg_check_file_access() */
-#include <linux/proc_fs.h>
+#include <linux/proc_fs.h>		/* used if CONFIG_SCSI_PROC_FS */
 #include <linux/xarray.h>
 #include <linux/debugfs.h>
 
@@ -125,7 +125,9 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FFD_CMD_Q		1	/* clear: only 1 active req per fd */
 #define SG_FFD_KEEP_ORPHAN	2	/* policy for this fd */
 #define SG_FFD_HIPRI_SEEN	3	/* could have HIPRI requests active */
-#define SG_FFD_Q_AT_TAIL	4	/* set: queue reqs at tail of blk q */
+#define SG_FFD_TIME_IN_NS	4	/* set: time in nanoseconds, else ms */
+#define SG_FFD_Q_AT_TAIL	5	/* set: queue reqs at tail of blk q */
+#define SG_FFD_NO_DURATION	6	/* don't do command duration calc */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -317,6 +319,7 @@ static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 #define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
 #define SZ_SG_IO_V4 ((int)sizeof(struct sg_io_v4))  /* v4 header (in bsg.h) */
 #define SZ_SG_REQ_INFO ((int)sizeof(struct sg_req_info))
+#define SZ_SG_EXTENDED_INFO ((int)sizeof(struct sg_extended_info))
 
 /* There is a assert that SZ_SG_IO_V4 >= SZ_SG_IO_HDR in first function */
 
@@ -464,10 +467,10 @@ static int
 sg_open(struct inode *inode, struct file *filp)
 {
 	bool o_excl, non_block;
-	int min_dev = iminor(inode);
-	int op_flags = filp->f_flags;
 	int res;
 	__maybe_unused int o_count;
+	int min_dev = iminor(inode);
+	int op_flags = filp->f_flags;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 
@@ -1021,7 +1024,10 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 	is_v4h = test_bit(SG_FRQ_IS_V4I, srp->frq_bm);
 	sync = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
 	SG_LOG(3, sfp, "%s: is_v4h=%d\n", __func__, (int)is_v4h);
-	srp->start_ns = ktime_get_boottime_ns();
+	if (test_bit(SG_FFD_NO_DURATION, sfp->ffd_bm))
+		srp->start_ns = 0;
+	else
+		srp->start_ns = ktime_get_boottime_ns();/* assume always > 0 */
 	srp->duration = 0;
 
 	if (!is_v4h && srp->s_hdr3.interface_id == '\0')
@@ -1620,29 +1626,42 @@ sg_calc_sgat_param(struct sg_device *sdp)
 	sdp->max_sgat_sz = sz;
 }
 
+/*
+ * Returns duration since srp->start_ns (using boot time as an epoch). Unit
+ * is nanoseconds when time_in_ns==true; else it is in milliseconds.
+ * For backward compatibility the duration is placed in a 32 bit unsigned
+ * integer. This limits the maximum nanosecond duration that can be
+ * represented (without wrapping) to about 4.3 seconds. If that is exceeded
+ * return equivalent of 3.999.. secs as it is more eye catching than the real
+ * number. Negative durations should not be possible but if they occur set
+ * duration to an unlikely 2 nanosec. Stalls in a request setup will have
+ * ts0==S64_MAX and will return 1 for an unlikely 1 nanosecond duration.
+ */
 static u32
-sg_calc_rq_dur(const struct sg_request *srp)
+sg_calc_rq_dur(const struct sg_request *srp, bool time_in_ns)
 {
 	ktime_t ts0 = ns_to_ktime(srp->start_ns);
 	ktime_t now_ts;
 	s64 diff;
 
-	if (ts0 == 0)
+	if (ts0 == 0)	/* only when SG_FFD_NO_DURATION is set */
 		return 0;
 	if (unlikely(ts0 == S64_MAX))	/* _prior_ to issuing req */
-		return 999999999;	/* eye catching */
+		return time_in_ns ? 1 : 999999999;
 	now_ts = ktime_get_boottime();
 	if (unlikely(ts0 > now_ts))
-		return 999999998;
-	/* unlikely req duration will exceed 2**32 milliseconds */
-	diff = ktime_ms_delta(now_ts, ts0);
+		return time_in_ns ? 2 : 999999998;
+	if (time_in_ns)
+		diff = ktime_to_ns(ktime_sub(now_ts, ts0));
+	else	/* unlikely req duration will exceed 2**32 milliseconds */
+		diff = ktime_ms_delta(now_ts, ts0);
 	return (diff > (s64)U32_MAX) ? 3999999999U : (u32)diff;
 }
 
 /* Return of U32_MAX means srp is inactive state */
 static u32
 sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
-	   bool *is_durp)
+	   bool time_in_ns, bool *is_durp)
 {
 	bool is_dur = false;
 	u32 res = U32_MAX;
@@ -1650,7 +1669,7 @@ sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
 	switch (sr_stp ? *sr_stp : atomic_read(&srp->rq_st)) {
 	case SG_RS_INFLIGHT:
 	case SG_RS_BUSY:
-		res = sg_calc_rq_dur(srp);
+		res = sg_calc_rq_dur(srp, time_in_ns);
 		break;
 	case SG_RS_AWAIT_RCV:
 	case SG_RS_INACTIVE:
@@ -1672,7 +1691,8 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 	unsigned long iflags;
 
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
-	rip->duration = sg_get_dur(srp, NULL, NULL);
+	rip->duration = sg_get_dur(srp, NULL, test_bit(SG_FFD_TIME_IN_NS,
+						       sfp->ffd_bm), NULL);
 	if (rip->duration == U32_MAX)
 		rip->duration = 0;
 	rip->orphan = test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
@@ -1996,6 +2016,200 @@ static int put_compat_request_table(struct compat_sg_req_info __user *o,
 }
 #endif
 
+/*
+ * Processing of ioctl(SG_SET_GET_EXTENDED(SG_SEIM_CTL_FLAGS)) which is a set
+ * of boolean flags. Access abbreviations: [rw], read-write; [ro], read-only;
+ * [wo], write-only; [raw], read after write; [rbw], read before write.
+ */
+static void
+sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
+{
+	bool flg = false;
+	const u32 c_flgs_wm = seip->ctl_flags_wr_mask;
+	const u32 c_flgs_rm = seip->ctl_flags_rd_mask;
+	const u32 c_flgs_val_in = seip->ctl_flags;
+	u32 c_flgs_val_out = c_flgs_val_in;
+	struct sg_device *sdp = sfp->parentdp;
+
+	/* TIME_IN_NS boolean, [raw] time in nanoseconds (def: millisecs) */
+	if (c_flgs_wm & SG_CTL_FLAGM_TIME_IN_NS)
+		assign_bit(SG_FFD_TIME_IN_NS, sfp->ffd_bm,
+			   !!(c_flgs_val_in & SG_CTL_FLAGM_TIME_IN_NS));
+	if (c_flgs_rm & SG_CTL_FLAGM_TIME_IN_NS) {
+		if (test_bit(SG_FFD_TIME_IN_NS, sfp->ffd_bm))
+			c_flgs_val_out |= SG_CTL_FLAGM_TIME_IN_NS;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_TIME_IN_NS;
+	}
+	/* OTHER_OPENS boolean, [ro] any other sg open fds on this dev? */
+	if (c_flgs_rm & SG_CTL_FLAGM_OTHER_OPENS) {
+		if (atomic_read(&sdp->open_cnt) > 1)
+			c_flgs_val_out |= SG_CTL_FLAGM_OTHER_OPENS;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_OTHER_OPENS;
+	}
+	/* Q_TAIL boolean, [raw] 1: queue at tail; 0: head (def: depends) */
+	if (c_flgs_wm & SG_CTL_FLAGM_Q_TAIL)
+		assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm,
+			   !!(c_flgs_val_in & SG_CTL_FLAGM_Q_TAIL));
+	if (c_flgs_rm & SG_CTL_FLAGM_Q_TAIL) {
+		if (test_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm))
+			c_flgs_val_out |= SG_CTL_FLAGM_Q_TAIL;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_Q_TAIL;
+	}
+	/* NO_DURATION boolean, [rbw] */
+	if (c_flgs_rm & SG_CTL_FLAGM_NO_DURATION)
+		flg = test_bit(SG_FFD_NO_DURATION, sfp->ffd_bm);
+	if (c_flgs_wm & SG_CTL_FLAGM_NO_DURATION)
+		assign_bit(SG_FFD_NO_DURATION, sfp->ffd_bm,
+			   !!(c_flgs_val_in & SG_CTL_FLAGM_NO_DURATION));
+	if (c_flgs_rm & SG_CTL_FLAGM_NO_DURATION) {
+		if (flg)
+			c_flgs_val_out |= SG_CTL_FLAGM_NO_DURATION;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_NO_DURATION;
+	}
+
+	if (c_flgs_val_in != c_flgs_val_out)
+		seip->ctl_flags = c_flgs_val_out;
+}
+
+static void
+sg_extended_read_value(struct sg_fd *sfp, struct sg_extended_info *seip)
+{
+	u32 uv;
+	unsigned long idx, idx2;
+	struct sg_fd *a_sfp;
+	struct sg_device *sdp = sfp->parentdp;
+	struct sg_request *srp;
+
+	switch (seip->read_value) {
+	case SG_SEIRV_INT_MASK:
+		seip->read_value = SG_SEIM_ALL_BITS;
+		break;
+	case SG_SEIRV_BOOL_MASK:
+		seip->read_value = SG_CTL_FLAGM_ALL_BITS;
+		break;
+	case SG_SEIRV_VERS_NUM:
+		seip->read_value = sg_version_num;
+		break;
+	case SG_SEIRV_INACT_RQS:
+		uv = 0;
+		xa_for_each_marked(&sfp->srp_arr, idx, srp,
+				   SG_XA_RQ_INACTIVE) {
+			if (!srp)
+				continue;
+			++uv;
+		}
+		seip->read_value = uv;
+		break;
+	case SG_SEIRV_DEV_INACT_RQS:
+		uv = 0;
+		xa_for_each(&sdp->sfp_arr, idx2, a_sfp) {
+			if (!a_sfp)
+				continue;
+			xa_for_each_marked(&a_sfp->srp_arr, idx, srp,
+					   SG_XA_RQ_INACTIVE) {
+				if (!srp)
+					continue;
+				++uv;
+			}
+		}
+		seip->read_value = uv;
+		break;
+	case SG_SEIRV_SUBMITTED:  /* counts all non-blocking on active list */
+		seip->read_value = (u32)atomic_read(&sfp->submitted);
+		break;
+	case SG_SEIRV_DEV_SUBMITTED: /* sum(submitted) on all fd's siblings */
+		uv = 0;
+		xa_for_each(&sdp->sfp_arr, idx2, a_sfp) {
+			if (!a_sfp)
+				continue;
+			uv += (u32)atomic_read(&a_sfp->submitted);
+		}
+		seip->read_value = uv;
+		break;
+	default:
+		SG_LOG(6, sfp, "%s: can't decode %d --> read_value\n",
+		       __func__, seip->read_value);
+		seip->read_value = 0;
+		break;
+	}
+}
+
+/* Called when processing ioctl(SG_SET_GET_EXTENDED) */
+static int
+sg_ctl_extended(struct sg_fd *sfp, void __user *p)
+{
+	int result = 0;
+	int ret = 0;
+	int n, s_wr_mask, s_rd_mask;
+	u32 or_masks;
+	struct sg_device *sdp = sfp->parentdp;
+	struct sg_extended_info *seip;
+	struct sg_extended_info sei;
+
+	seip = &sei;
+	if (copy_from_user(seip, p, SZ_SG_EXTENDED_INFO))
+		return -EFAULT;
+	s_wr_mask = seip->sei_wr_mask;
+	s_rd_mask = seip->sei_rd_mask;
+	or_masks = s_wr_mask | s_rd_mask;
+	if (or_masks == 0) {
+		SG_LOG(2, sfp, "%s: both masks 0, do nothing\n", __func__);
+		return 0;
+	}
+	SG_LOG(3, sfp, "%s: wr_mask=0x%x rd_mask=0x%x\n", __func__, s_wr_mask,
+	       s_rd_mask);
+	/* check all boolean flags for either wr or rd mask set in or_mask */
+	if (or_masks & SG_SEIM_CTL_FLAGS)
+		sg_extended_bool_flags(sfp, seip);
+	/* yields minor_index (type: u32) [ro] */
+	if (or_masks & SG_SEIM_MINOR_INDEX) {
+		if (s_wr_mask & SG_SEIM_MINOR_INDEX) {
+			SG_LOG(2, sfp, "%s: writing to minor_index ignored\n",
+			       __func__);
+		}
+		if (s_rd_mask & SG_SEIM_MINOR_INDEX)
+			seip->minor_index = sdp->index;
+	}
+	if ((s_rd_mask & SG_SEIM_READ_VAL) && (s_wr_mask & SG_SEIM_READ_VAL))
+		sg_extended_read_value(sfp, seip);
+	if (or_masks & SG_SEIM_BLK_POLL) {
+		n = 0;
+		if (s_wr_mask & SG_SEIM_BLK_POLL) {
+			result = sg_sfp_blk_poll(sfp, seip->num);
+			if (result < 0) {
+				if (ret == 0)
+					ret = result;
+			} else {
+				n = result;
+			}
+		}
+		if (s_rd_mask & SG_SEIM_BLK_POLL)
+			seip->num = n;
+	}
+	/* reserved_sz [raw], since may be reduced by other limits */
+	if (s_wr_mask & SG_SEIM_RESERVED_SIZE) {
+		mutex_lock(&sfp->f_mutex);
+		result = sg_set_reserved_sz(sfp, (int)seip->reserved_sz);
+		if (ret == 0 && result)
+			ret = result;
+		mutex_unlock(&sfp->f_mutex);
+	}
+	if (s_rd_mask & SG_SEIM_RESERVED_SIZE)
+		seip->reserved_sz = (u32)min_t(int,
+					       sfp->rsv_srp->sgat_h.buflen,
+					       sdp->max_sgat_sz);
+	/* copy to user space if int or boolean read mask non-zero */
+	if (s_rd_mask || seip->ctl_flags_rd_mask) {
+		if (copy_to_user(p, seip, SZ_SG_EXTENDED_INFO))
+			ret = ret ? ret : -EFAULT;
+	}
+	return ret;
+}
+
 /*
  * For backward compatibility, output SG_MAX_QUEUE sg_req_info objects. First
  * fetch from the active list then, if there is still room, from the free
@@ -2110,6 +2324,9 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		res = sg_ctl_abort(sdp, sfp, p);
 		mutex_unlock(&sfp->f_mutex);
 		return res;
+	case SG_SET_GET_EXTENDED:
+		SG_LOG(3, sfp, "%s:    SG_SET_GET_EXTENDED\n", __func__);
+		return sg_ctl_extended(sfp, p);
 	case SG_GET_SCSI_ID:
 		return sg_ctl_scsi_id(sdev, sfp, p);
 	case SG_SET_FORCE_PACK_ID:
@@ -2660,8 +2877,10 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	}
 
 	SG_LOG(6, sfp, "%s: pack_id=%d, res=0x%x\n", __func__, srp->pack_id,
-	       rq_result);
-	srp->duration = sg_calc_rq_dur(srp);
+	       srp->rq_result);
+	if (srp->start_ns > 0)	/* zero only when SG_FFD_NO_DURATION is set */
+		srp->duration = sg_calc_rq_dur(srp, test_bit(SG_FFD_TIME_IN_NS,
+							     sfp->ffd_bm));
 	if (unlikely((rq_result & SG_ML_RESULT_MSK) && slen > 0 &&
 		     test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm))) {
 		u32 scsi_stat = rq_result & 0xff;
@@ -3788,6 +4007,9 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 	r_srp->sgat_h.dlen = dxfr_len;/* must be <= r_srp->sgat_h.buflen */
 	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
 fini:
+	/* If setup stalls (e.g. blk_get_request()) debug shows 'elap=1 ns' */
+	if (test_bit(SG_FFD_TIME_IN_NS, fp->ffd_bm))
+		r_srp->start_ns = S64_MAX;
 	if (IS_ERR(r_srp))
 		SG_LOG(1, fp, "%s: err=%ld\n", __func__, PTR_ERR(r_srp));
 	if (!IS_ERR(r_srp))
@@ -3847,6 +4069,7 @@ sg_add_sfp(struct sg_device *sdp)
 	__assign_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm, SG_DEF_FORCE_PACK_ID);
 	__assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, SG_DEF_COMMAND_Q);
 	__assign_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm, SG_DEF_KEEP_ORPHAN);
+	__assign_bit(SG_FFD_TIME_IN_NS, sfp->ffd_bm, SG_DEF_TIME_UNIT);
 	__assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm, SG_DEFAULT_Q_AT);
 	/*
 	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may
@@ -4260,13 +4483,15 @@ sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 
 /* Writes debug info for one sg_request in obp buffer */
 static int
-sg_proc_debug_sreq(struct sg_request *srp, int to, char *obp, int len)
+sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, char *obp,
+		   int len)
 {
 	bool is_v3v4, v4, is_dur;
 	int n = 0;
 	u32 dur;
 	enum sg_rq_state rq_st;
 	const char *cp;
+	const char *tp = t_in_ns ? "ns" : "ms";
 
 	if (len < 1)
 		return 0;
@@ -4279,15 +4504,15 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, char *obp, int len)
 		cp = (srp->rq_info & SG_INFO_DIRECT_IO_MASK) ?
 				"     dio>> " : "     ";
 	rq_st = atomic_read(&srp->rq_st);
-	dur = sg_get_dur(srp, &rq_st, &is_dur);
+	dur = sg_get_dur(srp, &rq_st, t_in_ns, &is_dur);
 	n += scnprintf(obp + n, len - n, "%s%s: dlen=%d/%d id=%d", cp,
 		       sg_rq_st_str(rq_st, false), srp->sgat_h.dlen,
 		       srp->sgat_h.buflen, (int)srp->pack_id);
 	if (is_dur)	/* cmd/req has completed, waiting for ... */
-		n += scnprintf(obp + n, len - n, " dur=%ums", dur);
+		n += scnprintf(obp + n, len - n, " dur=%u%s", dur, tp);
 	else if (dur < U32_MAX)	/* in-flight or busy (so ongoing) */
-		n += scnprintf(obp + n, len - n, " t_o/elap=%us/%ums",
-			       to / 1000, dur);
+		n += scnprintf(obp + n, len - n, " t_o/elap=%us/%u%s",
+			       to / 1000, dur, tp);
 	cp = (srp->rq_flags & SGV4_FLAG_HIPRI) ? "hipri " : "";
 	n += scnprintf(obp + n, len - n, " sgat=%d %sop=0x%02x\n",
 		       srp->sgat_h.num_sgat, cp, srp->cmd_opcode);
@@ -4298,6 +4523,7 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, char *obp, int len)
 static int
 sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 {
+	bool t_in_ns = test_bit(SG_FFD_TIME_IN_NS, fp->ffd_bm);
 	int n = 0;
 	int to, k;
 	unsigned long iflags;
@@ -4332,7 +4558,8 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 	xa_for_each(&fp->srp_arr, idx, srp) {
 		if (xa_get_mark(&fp->srp_arr, idx, SG_XA_RQ_INACTIVE))
 			continue;
-		n += sg_proc_debug_sreq(srp, fp->timeout, obp + n, len - n);
+		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns, obp + n,
+					len - n);
 		++k;
 		if ((k % 8) == 0) {     /* don't hold up isr_s too long */
 			xa_unlock_irqrestore(&fp->srp_arr, iflags);
@@ -4346,7 +4573,8 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 	xa_for_each_marked(&fp->srp_arr, idx, srp, SG_XA_RQ_INACTIVE) {
 		if (k == 0)
 			n += scnprintf(obp + n, len - n, "   Inactives:\n");
-		n += sg_proc_debug_sreq(srp, fp->timeout, obp + n, len - n);
+		n += sg_proc_debug_sreq(srp, fp->timeout, t_in_ns,
+					obp + n, len - n);
 		++k;
 		if ((k % 8) == 0) {     /* don't hold up isr_s too long */
 			xa_unlock_irqrestore(&fp->srp_arr, iflags);
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 2b1b9df6c114..74f177583fce 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -156,6 +156,72 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 	int unused;
 } sg_req_info_t;
 
+/*
+ * The following defines are for manipulating struct sg_extended_info which
+ * is abbreviated to "SEI". A following "M" (i.e. "_SEIM_") indicates a
+ * mask. Most mask values correspond to a integer (usually a uint32_t) apart
+ * from SG_SEIM_CTL_FLAGS which is for boolean values packed into an integer.
+ * The mask values for those booleans start with "SG_CTL_FLAGM_". The scope
+ * of these settings, like most other ioctls, is usually that of the file
+ * descriptor the ioctl is executed on. The "rd:" indication means read-only,
+ * attempts to write to them are ignored. "rd>" means action when reading.
+ */
+#define SG_SEIM_CTL_FLAGS	0x1	/* ctl_flags_mask bits in ctl_flags */
+#define SG_SEIM_READ_VAL	0x2	/* write SG_SEIRV_*, read back value */
+#define SG_SEIM_RESERVED_SIZE	0x4	/* reserved_sz of reserve request */
+#define SG_SEIM_MINOR_INDEX	0x10	/* sg device minor index number */
+#define SG_SEIM_SGAT_ELEM_SZ	0x80	/* sgat element size (>= PAGE_SIZE) */
+#define SG_SEIM_BLK_POLL	0x100	/* call blk_poll, uses 'num' field */
+#define SG_SEIM_ALL_BITS	0x1ff	/* should be OR of previous items */
+
+/* flag and mask values for boolean fields follow */
+#define SG_CTL_FLAGM_TIME_IN_NS	0x1	/* time: nanosecs (def: millisecs) */
+#define SG_CTL_FLAGM_OTHER_OPENS 0x4	/* rd: other sg fd_s on this dev */
+#define SG_CTL_FLAGM_ORPHANS	0x8	/* rd: orphaned requests on this fd */
+#define SG_CTL_FLAGM_Q_TAIL	0x10	/* used for future cmds on this fd */
+#define SG_CTL_FLAGM_NO_DURATION 0x400	/* don't calc command duration */
+#define SG_CTL_FLAGM_ALL_BITS	0xfff	/* should be OR of previous items */
+
+/* Write one of the following values to sg_extended_info::read_value, get... */
+#define SG_SEIRV_INT_MASK	0x0	/* get SG_SEIM_ALL_BITS */
+#define SG_SEIRV_BOOL_MASK	0x1	/* get SG_CTL_FLAGM_ALL_BITS */
+#define SG_SEIRV_VERS_NUM	0x2	/* get driver version number as int */
+#define SG_SEIRV_INACT_RQS	0x3	/* number of inactive requests */
+#define SG_SEIRV_DEV_INACT_RQS	0x4	/* sum(inactive rqs) on owning dev */
+#define SG_SEIRV_SUBMITTED	0x5	/* number of mrqs submitted+unread */
+#define SG_SEIRV_DEV_SUBMITTED	0x6	/* sum(submitted) on all dev's fds */
+
+/*
+ * A pointer to the following structure is passed as the third argument to
+ * ioctl(SG_SET_GET_EXTENDED). Each bit in the *_wr_mask fields causes the
+ * corresponding integer (e.g. reserved_sz) or bit (e.g. the
+ * SG_CTL_FLAG_TIME_IN_NS bit in ctl_flags) to be read from the user space
+ * and modify the driver. Each bit in the *_rd_mask fields causes the
+ * corresponding integer or bit to be fetched from the driver and written
+ * back to the user space. If the same bit is set in both the *_wr_mask and
+ * corresponding *_rd_mask fields, then which one comes first depends on the
+ * setting but no other operation will split the two. This structure is
+ * padded to 96 bytes to allow for new values to be added in the future.
+ */
+
+/* If both sei_wr_mask and sei_rd_mask are 0, this ioctl does nothing */
+struct sg_extended_info {
+	__u32	sei_wr_mask;	/* OR-ed SG_SEIM_* user->driver values */
+	__u32	sei_rd_mask;	/* OR-ed SG_SEIM_* driver->user values */
+	__u32	ctl_flags_wr_mask;	/* OR-ed SG_CTL_FLAGM_* values */
+	__u32	ctl_flags_rd_mask;	/* OR-ed SG_CTL_FLAGM_* values */
+	__u32	ctl_flags;	/* bit values OR-ed, see SG_CTL_FLAGM_* */
+	__u32	read_value;	/* write SG_SEIRV_*, read back related */
+
+	__u32	reserved_sz;	/* data/sgl size of pre-allocated request */
+	__u32	tot_fd_thresh;	/* total data/sgat for this fd, 0: no limit */
+	__u32	minor_index;	/* rd: kernel's sg device minor number */
+	__u32	share_fd;	/* SHARE_FD and CHG_SHARE_FD use this */
+	__u32	sgat_elem_sz;	/* sgat element size (must be power of 2) */
+	__s32	num;		/* blk_poll: loop_count (-1 -> spin)) */
+	__u8	pad_to_96[48];	/* pad so struct is 96 bytes long */
+};
+
 /*
  * IOCTLs: Those ioctls that are relevant to the SG 3.x drivers follow.
  * [Those that only apply to the SG 2.x drivers are at the end of the file.]
@@ -185,6 +251,9 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
  */
 #define SG_IOCTL_MAGIC_NUM 0x22
 
+#define SG_SET_GET_EXTENDED _IOWR(SG_IOCTL_MAGIC_NUM, 0x51,	\
+				  struct sg_extended_info)
+
 /* The following ioctl has a 'sg_scsi_id_t *' object as its 3rd argument. */
 #define SG_GET_SCSI_ID 0x2276   /* Yields fd's bus, chan, dev, lun + type */
 /* SCSI id information can also be obtained from SCSI_IOCTL_GET_IDLUN */
-- 
2.25.1

