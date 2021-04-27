Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2F3C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCB38613B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239341AbhD0WAH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:07 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38838 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239426AbhD0V7j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E0FB9204238;
        Tue, 27 Apr 2021 23:58:52 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6OCLOMo70ZLO; Tue, 27 Apr 2021 23:58:49 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 317812041BB;
        Tue, 27 Apr 2021 23:58:48 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 49/83] sg: tag and more_async
Date:   Tue, 27 Apr 2021 17:56:59 -0400
Message-Id: <20210427215733.417746-51-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add tag tracking capability to the functionally similar pack_id.
The difference is that the sg user provides the pack_id while
the block layer generates the tag.

The more_async flag when set instructs the blk_get_request() not
to block which is does in the current driver on rare occasions
for some obscure reason.

Add debug_summary to /proc/scsi/sg/ and snapshot_summary to
/sys/kernel/debug/scsi_generic/ . Both give a summary of each
active sg file descriptor but don't go down to the request
level.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 301 +++++++++++++++++++++++++++++------------
 include/uapi/scsi/sg.h |   3 +
 2 files changed, 214 insertions(+), 90 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b141b0113f96..c0a4fbcc4aa2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -109,6 +109,7 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_ML_RESULT_MSK 0x0fff00ff	/* mid-level's 32 bit result value */
 
 #define SG_PACK_ID_WILDCARD (-1)
+#define SG_TAG_WILDCARD (-1)
 
 #define SG_ADD_RQ_MAX_RETRIES 40	/* to stop infinite _trylock(s) */
 
@@ -131,7 +132,9 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FFD_HIPRI_SEEN	3	/* could have HIPRI requests active */
 #define SG_FFD_TIME_IN_NS	4	/* set: time in nanoseconds, else ms */
 #define SG_FFD_Q_AT_TAIL	5	/* set: queue reqs at tail of blk q */
-#define SG_FFD_NO_DURATION	6	/* don't do command duration calc */
+#define SG_FFD_PREFER_TAG	6	/* prefer tag over pack_id (def) */
+#define SG_FFD_NO_DURATION	7	/* don't do command duration calc */
+#define SG_FFD_MORE_ASYNC	8	/* yield EBUSY more often */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -210,16 +213,17 @@ struct sg_request {	/* active SCSI command or inactive request */
 		struct sg_slice_hdr3 s_hdr3;  /* subset of sg_io_hdr */
 		struct sg_slice_hdr4 s_hdr4; /* reduced size struct sg_io_v4 */
 	};
-	u32 duration;		/* cmd duration in milliseconds */
-	u32 rq_flags;		/* hold user supplied flags */
+	u32 duration;		/* cmd duration in milli or nano seconds */
+	u32 rq_flags;		/* flags given in v3 and v4 */
 	u32 rq_idx;		/* my index within parent's srp_arr */
 	u32 rq_info;		/* info supplied by v3 and v4 interfaces */
 	u32 rq_result;		/* packed scsi request result from LLD */
 	int in_resid;		/* requested-actual byte count on data-in */
-	int pack_id;		/* user provided packet identifier field */
+	int pack_id;		/* v3 pack_id or in v4 request_extra field */
 	int sense_len;		/* actual sense buffer length (data-in) */
 	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */
 	u8 cmd_opcode;		/* first byte of SCSI cdb */
+	int tag;		/* block layer identifier of request */
 	blk_qc_t cookie;	/* ids 1 or more queues for blk_poll() */
 	u64 start_ns;		/* starting point of command duration calc */
 	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
@@ -304,7 +308,8 @@ static int sg_read_append(struct sg_request *srp, void __user *outp,
 static void sg_remove_sgat(struct sg_request *srp);
 static struct sg_fd *sg_add_sfp(struct sg_device *sdp);
 static void sg_remove_sfp(struct kref *);
-static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id);
+static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id,
+					    bool is_tag);
 static struct sg_request *sg_setup_req(struct sg_comm_wr_t *cwrp,
 				       int dxfr_len);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
@@ -850,6 +855,14 @@ sg_submit_v4(struct file *filp, struct sg_fd *sfp, void __user *p,
 		return PTR_ERR(srp);
 	if (o_srp)
 		*o_srp = srp;
+	if (p && !sync && (srp->rq_flags & SGV4_FLAG_YIELD_TAG)) {
+		u64 gen_tag = srp->tag;
+		struct sg_io_v4 __user *h4_up = (struct sg_io_v4 __user *)p;
+
+		if (unlikely(copy_to_user(&h4_up->generated_tag, &gen_tag,
+					  sizeof(gen_tag))))
+			return -EFAULT;
+	}
 	return res;
 }
 
@@ -875,7 +888,7 @@ static int
 sg_ctl_iosubmit_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 {
 	int res;
-	u8 hdr_store[SZ_SG_IO_V4];      /* max(v3interface, v4interface) */
+	u8 hdr_store[SZ_SG_IO_V4];	/* max(v3interface, v4interface) */
 	struct sg_io_hdr *h3p = (struct sg_io_hdr *)hdr_store;
 	struct sg_device *sdp = sfp->parentdp;
 
@@ -1146,7 +1159,8 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
  * returns true (or an event like a signal (e.g. control-C) occurs).
  */
 static inline bool
-sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int pack_id)
+sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int id,
+		 bool is_tag)
 {
 	struct sg_request *srp;
 
@@ -1154,7 +1168,7 @@ sg_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp, int pack_id)
 		*srpp = NULL;
 		return true;
 	}
-	srp = sg_find_srp_by_id(sfp, pack_id);
+	srp = sg_find_srp_by_id(sfp, id, is_tag);
 	*srpp = srp;
 	return !!srp;
 }
@@ -1294,6 +1308,8 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p,
 	h4p->usr_ptr = srp->s_hdr4.usr_ptr;
 	h4p->response = (uintptr_t)srp->s_hdr4.sbp;
 	h4p->request_extra = srp->pack_id;
+	if (test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm))
+		h4p->generated_tag = srp->tag;
 	if (p) {
 		if (copy_to_user(p, h4p, SZ_SG_IO_V4))
 			err = err ? err : -EFAULT;
@@ -1314,8 +1330,10 @@ static int
 sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 {
 	bool non_block = !!(filp->f_flags & O_NONBLOCK);
+	bool use_tag = false;
 	int res, id;
 	int pack_id = SG_PACK_ID_WILDCARD;
+	int tag = SG_TAG_WILDCARD;
 	u8 v4_holder[SZ_SG_IO_V4];
 	struct sg_io_v4 *h4p = (struct sg_io_v4 *)v4_holder;
 	struct sg_device *sdp = sfp->parentdp;
@@ -1334,9 +1352,16 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 		non_block = true;	/* set by either this or O_NONBLOCK */
 	SG_LOG(3, sfp, "%s: non_block(+IMMED)=%d\n", __func__, non_block);
 	/* read in part of v3 or v4 header for pack_id or tag based find */
-	id = pack_id;
+	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm)) {
+		use_tag = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm);
+		if (use_tag)
+			tag = h4p->request_tag;	/* top 32 bits ignored */
+		else
+			pack_id = h4p->request_extra;
+	}
+	id = use_tag ? tag : pack_id;
 try_again:
-	srp = sg_find_srp_by_id(sfp, id);
+	srp = sg_find_srp_by_id(sfp, id, use_tag);
 	if (!srp) {     /* nothing available so wait on packet or */
 		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
@@ -1344,7 +1369,7 @@ sg_ctl_ioreceive(struct file *filp, struct sg_fd *sfp, void __user *p)
 			return -EAGAIN;
 		res = wait_event_interruptible(sfp->read_wait,
 					       sg_get_ready_srp(sfp, &srp,
-								id));
+								id, use_tag));
 		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
 		if (res)
@@ -1391,7 +1416,7 @@ sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 	if (test_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm))
 		pack_id = h3p->pack_id;
 try_again:
-	srp = sg_find_srp_by_id(sfp, pack_id);
+	srp = sg_find_srp_by_id(sfp, pack_id, false);
 	if (!srp) {     /* nothing available so wait on packet or */
 		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
@@ -1399,7 +1424,7 @@ sg_ctl_ioreceive_v3(struct file *filp, struct sg_fd *sfp, void __user *p)
 			return -EAGAIN;
 		res = wait_event_interruptible
 				(sfp->read_wait,
-				 sg_get_ready_srp(sfp, &srp, pack_id));
+				 sg_get_ready_srp(sfp, &srp, pack_id, false));
 		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
 		if (unlikely(res))
@@ -1561,15 +1586,15 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 		}
 	}
 try_again:
-	srp = sg_find_srp_by_id(sfp, want_id);
+	srp = sg_find_srp_by_id(sfp, want_id, false);
 	if (!srp) {	/* nothing available so wait on packet to arrive or */
 		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
 		if (non_block) /* O_NONBLOCK or v3::flags & SGV4_FLAG_IMMED */
 			return -EAGAIN;
-		ret = wait_event_interruptible(sfp->read_wait,
-					       sg_get_ready_srp(sfp, &srp,
-								want_id));
+		ret = wait_event_interruptible
+				(sfp->read_wait,
+				 sg_get_ready_srp(sfp, &srp, want_id, false));
 		if (unlikely(SG_IS_DETACHING(sdp)))
 			return -ENODEV;
 		if (ret)	/* -ERESTARTSYS as signal hit process */
@@ -1704,10 +1729,10 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 	rip->orphan = test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
 	rip->sg_io_owned = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
 	rip->problem = !!(srp->rq_result & SG_ML_RESULT_MSK);
-	rip->pack_id = srp->pack_id;
+	rip->pack_id = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm) ?
+				srp->tag : srp->pack_id;
 	rip->usr_ptr = test_bit(SG_FRQ_IS_V4I, srp->frq_bm) ?
 			uptr64(srp->s_hdr4.usr_ptr) : srp->s_hdr3.usr_ptr;
-	rip->usr_ptr = srp->s_hdr3.usr_ptr;
 	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 }
 
@@ -1821,18 +1846,27 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	return res;
 }
 
+/* When use_tag is true then id is a tag, else it is a pack_id. */
 static struct sg_request *
-sg_match_request(struct sg_fd *sfp, int id)
+sg_match_request(struct sg_fd *sfp, bool use_tag, int id)
 {
 	int num_waiting = atomic_read(&sfp->waiting);
 	unsigned long idx;
 	struct sg_request *srp;
 
-	if (num_waiting < 1)
-		return NULL;
+	if (num_waiting < 1) {
+		num_waiting = atomic_read_acquire(&sfp->waiting);
+		if (num_waiting < 1)
+			return NULL;
+	}
 	if (id == SG_PACK_ID_WILDCARD) {
 		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT)
 			return srp;
+	} else if (use_tag) {
+		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
+			if (id == srp->tag)
+				return srp;
+		}
 	} else {
 		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
 			if (id == srp->pack_id)
@@ -1845,7 +1879,8 @@ sg_match_request(struct sg_fd *sfp, int id)
 static int
 sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 {
-	int res, pack_id, id;
+	bool use_tag;
+	int res, pack_id, tag, id;
 	unsigned long iflags, idx;
 	struct sg_fd *o_sfp;
 	struct sg_request *srp;
@@ -1857,16 +1892,18 @@ sg_ctl_abort(struct sg_device *sdp, struct sg_fd *sfp, void __user *p)
 	if (h4p->guard != 'Q' || h4p->protocol != 0 || h4p->subprotocol != 0)
 		return -EPERM;
 	pack_id = h4p->request_extra;
-	id = pack_id;
+	tag = h4p->request_tag;
+	use_tag = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm);
+	id = use_tag ? tag : pack_id;
 
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
-	srp = sg_match_request(sfp, id);
+	srp = sg_match_request(sfp, use_tag, id);
 	if (!srp) {	/* assume device (not just fd) scope */
 		xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 		xa_for_each(&sdp->sfp_arr, idx, o_sfp) {
 			if (o_sfp == sfp)
 				continue;	/* already checked */
-			srp = sg_match_request(o_sfp, id);
+			srp = sg_match_request(o_sfp, use_tag, id);
 			if (srp) {
 				sfp = o_sfp;
 				xa_lock_irqsave(&sfp->srp_arr, iflags);
@@ -2047,6 +2084,16 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 		else
 			c_flgs_val_out &= ~SG_CTL_FLAGM_TIME_IN_NS;
 	}
+	/* TAG_FOR_PACK_ID boolean, [raw] search by tag or pack_id (def) */
+	if (c_flgs_wm & SG_CTL_FLAGM_TAG_FOR_PACK_ID)
+		assign_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm,
+			   !!(c_flgs_val_in & SG_CTL_FLAGM_TAG_FOR_PACK_ID));
+	if (c_flgs_rm & SG_CTL_FLAGM_TAG_FOR_PACK_ID) {
+		if (test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm))
+			c_flgs_val_out |= SG_CTL_FLAGM_TAG_FOR_PACK_ID;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_TAG_FOR_PACK_ID;
+	}
 	/* OTHER_OPENS boolean, [ro] any other sg open fds on this dev? */
 	if (c_flgs_rm & SG_CTL_FLAGM_OTHER_OPENS) {
 		if (atomic_read(&sdp->open_cnt) > 1)
@@ -2076,6 +2123,18 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 		else
 			c_flgs_val_out &= ~SG_CTL_FLAGM_NO_DURATION;
 	}
+	/* MORE_ASYNC boolean, [rbw] */
+	if (c_flgs_rm & SG_CTL_FLAGM_MORE_ASYNC)
+		flg = test_bit(SG_FFD_MORE_ASYNC, sfp->ffd_bm);
+	if (c_flgs_wm & SG_CTL_FLAGM_MORE_ASYNC)
+		assign_bit(SG_FFD_MORE_ASYNC, sfp->ffd_bm,
+			   !!(c_flgs_val_in & SG_CTL_FLAGM_MORE_ASYNC));
+	if (c_flgs_rm & SG_CTL_FLAGM_MORE_ASYNC) {
+		if (flg)
+			c_flgs_val_out |= SG_CTL_FLAGM_MORE_ASYNC;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_MORE_ASYNC;
+	}
 
 	if (c_flgs_val_in != c_flgs_val_out)
 		seip->ctl_flags = c_flgs_val_out;
@@ -2103,24 +2162,16 @@ sg_extended_read_value(struct sg_fd *sfp, struct sg_extended_info *seip)
 	case SG_SEIRV_INACT_RQS:
 		uv = 0;
 		xa_for_each_marked(&sfp->srp_arr, idx, srp,
-				   SG_XA_RQ_INACTIVE) {
-			if (!srp)
-				continue;
+				   SG_XA_RQ_INACTIVE)
 			++uv;
-		}
 		seip->read_value = uv;
 		break;
 	case SG_SEIRV_DEV_INACT_RQS:
 		uv = 0;
 		xa_for_each(&sdp->sfp_arr, idx2, a_sfp) {
-			if (!a_sfp)
-				continue;
 			xa_for_each_marked(&a_sfp->srp_arr, idx, srp,
-					   SG_XA_RQ_INACTIVE) {
-				if (!srp)
-					continue;
+					   SG_XA_RQ_INACTIVE)
 				++uv;
-			}
 		}
 		seip->read_value = uv;
 		break;
@@ -2129,11 +2180,8 @@ sg_extended_read_value(struct sg_fd *sfp, struct sg_extended_info *seip)
 		break;
 	case SG_SEIRV_DEV_SUBMITTED: /* sum(submitted) on all fd's siblings */
 		uv = 0;
-		xa_for_each(&sdp->sfp_arr, idx2, a_sfp) {
-			if (!a_sfp)
-				continue;
+		xa_for_each(&sdp->sfp_arr, idx2, a_sfp)
 			uv += (u32)atomic_read(&a_sfp->submitted);
-		}
 		seip->read_value = uv;
 		break;
 	default:
@@ -2375,10 +2423,21 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		return 0;
 	case SG_GET_PACK_ID:    /* or tag of oldest "read"-able, -1 if none */
 		val = -1;
-		xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
-			if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
-				val = srp->pack_id;
-				break;
+		if (test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm)) {
+			xa_for_each_marked(&sfp->srp_arr, idx, srp,
+					   SG_XA_RQ_AWAIT) {
+				if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
+					val = srp->tag;
+					break;
+				}
+			}
+		} else {
+			xa_for_each_marked(&sfp->srp_arr, idx, srp,
+					   SG_XA_RQ_AWAIT) {
+				if (!test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm)) {
+					val = srp->pack_id;
+					break;
+				}
 			}
 		}
 		SG_LOG(3, sfp, "%s:    SG_GET_PACK_ID=%d\n", __func__, val);
@@ -2664,7 +2723,7 @@ sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
  * flags OR-ed together.
  */
 static __poll_t
-sg_poll(struct file *filp, poll_table * wait)
+sg_poll(struct file *filp, poll_table *wait)
 {
 	int num;
 	__poll_t p_res = 0;
@@ -3078,7 +3137,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 	struct scsi_device *scsidp = to_scsi_device(cl_dev->parent);
 	struct gendisk *disk;
 	struct sg_device *sdp = NULL;
-	struct cdev * cdev = NULL;
+	struct cdev *cdev = NULL;
 	int error;
 	unsigned long iflags;
 
@@ -3360,6 +3419,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	int dxfer_len = 0;
 	int r0w = READ;
 	u32 rq_flags = srp->rq_flags;
+	int blk_flgs;
 	unsigned int iov_count = 0;
 	void __user *up;
 	struct request *rqq;
@@ -3408,17 +3468,15 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	q = sdp->device->request_queue;
 
 	/*
-	 * NOTE
-	 *
-	 * With scsi-mq enabled, there are a fixed number of preallocated
-	 * requests equal in number to shost->can_queue.  If all of the
-	 * preallocated requests are already in use, then blk_get_request()
-	 * will sleep until an active command completes, freeing up a request.
-	 * Although waiting in an asynchronous interface is less than ideal, we
-	 * do not want to use BLK_MQ_REQ_NOWAIT here because userspace might
-	 * not expect an EWOULDBLOCK from this condition.
+	 * For backward compatibility default to using blocking variant even
+	 * when in non-blocking (async) mode. If the SG_CTL_FLAGM_MORE_ASYNC
+	 * boolean set on this file descriptor, returns -EAGAIN if
+	 * blk_get_request(BLK_MQ_REQ_NOWAIT) yields EAGAIN (aka EWOULDBLOCK).
 	 */
-	rqq = blk_get_request(q, (r0w ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN), 0);
+	blk_flgs = (test_bit(SG_FFD_MORE_ASYNC, sfp->ffd_bm)) ?
+						BLK_MQ_REQ_NOWAIT : 0;
+	rqq = blk_get_request(q, (r0w ? REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN),
+			      blk_flgs);
 	if (IS_ERR(rqq)) {
 		kfree(long_cmdp);
 		return PTR_ERR(rqq);
@@ -3426,9 +3484,10 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	/* current sg_request protected by SG_RS_BUSY state */
 	scsi_rp = scsi_req(rqq);
 	WRITE_ONCE(srp->rqq, rqq);
+	if (rq_flags & SGV4_FLAG_YIELD_TAG)
+		srp->tag = rqq->tag;
 	if (rq_flags & SGV4_FLAG_HIPRI)
 		set_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
-
 	if (cwrp->cmd_len > BLK_MAX_CDB)
 		scsi_rp->cmd = long_cmdp;	/* transfer ownership */
 	if (cwrp->u_cmdp)
@@ -3727,18 +3786,20 @@ sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 
 /*
  * If there are multiple requests outstanding, the speed of this function is
- * important. SG_PACK_ID_WILDCARD is -1 and that case is typically
+ * important. 'id' is pack_id when is_tag=false, otherwise it is a tag. Both
+ * SG_PACK_ID_WILDCARD and SG_TAG_WILDCARD are -1 and that case is typically
  * the fast path. This function is only used in the non-blocking cases.
  * Returns pointer to (first) matching sg_request or NULL. If found,
  * sg_request state is moved from SG_RS_AWAIT_RCV to SG_RS_BUSY.
  */
 static struct sg_request *
-sg_find_srp_by_id(struct sg_fd *sfp, int pack_id)
+sg_find_srp_by_id(struct sg_fd *sfp, int id, bool is_tag)
 {
 	__maybe_unused bool is_bad_st = false;
 	__maybe_unused enum sg_rq_state bad_sr_st = SG_RS_INACTIVE;
-	bool search_for_1 = (pack_id != SG_PACK_ID_WILDCARD);
+	bool search_for_1 = (id != SG_TAG_WILDCARD);
 	bool second = false;
+	enum sg_rq_state sr_st;
 	int res;
 	int num_waiting = atomic_read(&sfp->waiting);
 	int l_await_idx = READ_ONCE(sfp->low_await_idx);
@@ -3764,15 +3825,33 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id)
 		     srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_AWAIT)) {
 			if (test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm))
 				continue;
-			if (srp->pack_id != pack_id)
-				continue;
-			res = sg_rq_chg_state(srp, SG_RS_AWAIT_RCV, SG_RS_BUSY);
-			if (likely(res == 0))
-				goto good;
-			/* else another caller got it, move on */
-			if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
-				is_bad_st = true;
-				bad_sr_st = atomic_read(&srp->rq_st);
+			if (is_tag) {
+				if (srp->tag != id)
+					continue;
+			} else {
+				if (srp->pack_id != id)
+					continue;
+			}
+			sr_st = atomic_read(&srp->rq_st);
+			switch (sr_st) {
+			case SG_RS_AWAIT_RCV:
+				res = sg_rq_chg_state(srp, sr_st, SG_RS_BUSY);
+				if (likely(res == 0))
+					goto good;
+				/* else another caller got it, move on */
+				if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
+					is_bad_st = true;
+					bad_sr_st = atomic_read(&srp->rq_st);
+				}
+				break;
+			case SG_RS_INFLIGHT:
+				break;
+			default:
+				if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
+					is_bad_st = true;
+					bad_sr_st = sr_st;
+				}
+				break;
 			}
 			break;
 		}
@@ -3818,21 +3897,22 @@ sg_find_srp_by_id(struct sg_fd *sfp, int pack_id)
 	/* here if one of above loops does _not_ find a match */
 	if (IS_ENABLED(CONFIG_SCSI_PROC_FS)) {
 		if (search_for_1) {
-			__maybe_unused const char *cptp = "pack_id=";
+			__maybe_unused const char *cptp = is_tag ? "tag=" :
+								   "pack_id=";
 
 			if (is_bad_st)
 				SG_LOG(1, sfp, "%s: %s%d wrong state: %s\n",
-				       __func__, cptp, pack_id,
+				       __func__, cptp, id,
 				       sg_rq_st_str(bad_sr_st, true));
 			else
 				SG_LOG(6, sfp, "%s: %s%d not awaiting read\n",
-				       __func__, cptp, pack_id);
+				       __func__, cptp, id);
 		}
 	}
 	return NULL;
 good:
-	SG_LOG(5, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__, "pack_id=",
-	       pack_id, srp);
+	SG_LOG(5, sfp, "%s: %s%d found [srp=0x%pK]\n", __func__,
+	       (is_tag ? "tag=" : "pack_id="), id, srp);
 	return srp;
 }
 
@@ -3855,6 +3935,7 @@ sg_mk_srp(struct sg_fd *sfp, bool first)
 	if (srp) {
 		atomic_set(&srp->rq_st, SG_RS_BUSY);
 		srp->parentfp = sfp;
+		srp->tag = SG_TAG_WILDCARD;
 		return srp;
 	} else {
 		return ERR_PTR(-ENOMEM);
@@ -4291,14 +4372,18 @@ sg_lookup_dev(int dev)
 	return idr_find(&sg_index_idr, dev);
 }
 
+/*
+ * Returns valid pointer to a sg_device object on success or a negated
+ * errno value on failure. Does not return NULL.
+ */
 static struct sg_device *
-sg_get_dev(int dev)
+sg_get_dev(int min_dev)
 {
 	struct sg_device *sdp;
-	unsigned long flags;
+	unsigned long iflags;
 
-	read_lock_irqsave(&sg_index_lock, flags);
-	sdp = sg_lookup_dev(dev);
+	read_lock_irqsave(&sg_index_lock, iflags);
+	sdp = sg_lookup_dev(min_dev);
 	if (!sdp)
 		sdp = ERR_PTR(-ENXIO);
 	else if (SG_IS_DETACHING(sdp)) {
@@ -4308,8 +4393,7 @@ sg_get_dev(int dev)
 		sdp = ERR_PTR(-ENODEV);
 	} else
 		kref_get(&sdp->d_ref);
-	read_unlock_irqrestore(&sg_index_lock, flags);
-
+	read_unlock_irqrestore(&sg_index_lock, iflags);
 	return sdp;
 }
 
@@ -4404,7 +4488,7 @@ dev_seq_next(struct seq_file *s, void *v, loff_t *pos)
 	struct sg_proc_deviter *it = s->private;
 
 	*pos = ++it->index;
-	return (it->index < it->max) ? it : NULL;
+	return (it->index < (int)it->max) ? it : NULL;
 }
 
 static void
@@ -4567,9 +4651,14 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, char *obp,
 		       srp->sgat_h.buflen, (int)srp->pack_id);
 	if (is_dur)	/* cmd/req has completed, waiting for ... */
 		n += scnprintf(obp + n, len - n, " dur=%u%s", dur, tp);
-	else if (dur < U32_MAX)	/* in-flight or busy (so ongoing) */
+	else if (dur < U32_MAX) { /* in-flight or busy (so ongoing) */
+		if ((srp->rq_flags & SGV4_FLAG_YIELD_TAG) &&
+		    srp->tag != SG_TAG_WILDCARD)
+			n += scnprintf(obp + n, len - n, " tag=0x%x",
+				       srp->tag);
 		n += scnprintf(obp + n, len - n, " t_o/elap=%us/%u%s",
 			       to / 1000, dur, tp);
+	}
 	cp = (srp->rq_flags & SGV4_FLAG_HIPRI) ? "hipri " : "";
 	n += scnprintf(obp + n, len - n, " sgat=%d %sop=0x%02x\n",
 		       srp->sgat_h.num_sgat, cp, srp->cmd_opcode);
@@ -4578,7 +4667,8 @@ sg_proc_debug_sreq(struct sg_request *srp, int to, bool t_in_ns, char *obp,
 
 /* Writes debug info for one sg fd (including its sg requests) in obp buffer */
 static int
-sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
+sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
+		 bool reduced)
 {
 	bool t_in_ns = test_bit(SG_FFD_TIME_IN_NS, fp->ffd_bm);
 	int n = 0;
@@ -4611,6 +4701,8 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 		       "   submitted=%d waiting=%d inactives=%d   open thr_id=%d\n",
 		       atomic_read(&fp->submitted),
 		       atomic_read(&fp->waiting), atomic_read(&fp->inactives), fp->tid);
+	if (reduced)
+		return n;
 	k = 0;
 	xa_lock_irqsave(&fp->srp_arr, iflags);
 	xa_for_each(&fp->srp_arr, idx, srp) {
@@ -4646,7 +4738,8 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 
 /* Writes debug info for one sg device (including its sg fds) in obp buffer */
 static int
-sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len, int *fd_counterp)
+sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len,
+		   int *fd_counterp, bool reduced)
 {
 	int n = 0;
 	int my_count = 0;
@@ -4668,14 +4761,13 @@ sg_proc_debug_sdev(struct sg_device *sdp, char *obp, int len, int *fd_counterp)
 	xa_for_each(&sdp->sfp_arr, idx, fp) {
 		++*countp;
 		n += scnprintf(obp + n, len - n, "  FD(%d): ", *countp);
-		n += sg_proc_debug_fd(fp, obp + n, len - n, idx);
+		n += sg_proc_debug_fd(fp, obp + n, len - n, idx, reduced);
 	}
 	return n;
 }
 
-/* Called via dbg_seq_ops once for each sg device */
 static int
-sg_proc_seq_show_debug(struct seq_file *s, void *v)
+sg_proc_seq_show_debug(struct seq_file *s, void *v, bool reduced)
 {
 	bool found = false;
 	bool trunc = false;
@@ -4737,7 +4829,8 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v)
 			snprintf(b1, sizeof(b1), " >>> device=%s  %s\n",
 				 disk_name, "detaching pending close\n");
 		else if (sdp->device) {
-			n = sg_proc_debug_sdev(sdp, bp, bp_len, fdi_p);
+			n = sg_proc_debug_sdev(sdp, bp, bp_len, fdi_p,
+					       reduced);
 			if (n >= bp_len - 1) {
 				trunc = true;
 				if (bp[bp_len - 2] != '\n')
@@ -4769,6 +4862,18 @@ sg_proc_seq_show_debug(struct seq_file *s, void *v)
 	return 0;
 }
 
+static int
+sg_proc_seq_show_debug_full(struct seq_file *s, void *v)
+{
+	return sg_proc_seq_show_debug(s, v, false);
+}
+
+static int
+sg_proc_seq_show_debug_summ(struct seq_file *s, void *v)
+{
+	return sg_proc_seq_show_debug(s, v, true);
+}
+
 #endif         /* SG_PROC_OR_DEBUG_FS */
 
 #if IS_ENABLED(CONFIG_SCSI_PROC_FS)
@@ -4807,7 +4912,14 @@ static const struct seq_operations debug_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
-	.show  = sg_proc_seq_show_debug,
+	.show  = sg_proc_seq_show_debug_full,
+};
+
+static const struct seq_operations debug_summ_seq_ops = {
+	.start = dev_seq_start,
+	.next  = dev_seq_next,
+	.stop  = dev_seq_stop,
+	.show  = sg_proc_seq_show_debug_summ,
 };
 
 static int
@@ -4821,6 +4933,7 @@ sg_proc_init(void)
 
 	proc_create("allow_dio", 0644, p, &adio_proc_ops);
 	proc_create_seq("debug", 0444, p, &debug_seq_ops);
+	proc_create_seq("debug_summary", 0444, p, &debug_summ_seq_ops);
 	proc_create("def_reserved_size", 0644, p, &dressz_proc_ops);
 	proc_create_single("device_hdr", 0444, p, sg_proc_seq_show_devhdr);
 	proc_create_seq("devices", 0444, p, &dev_seq_ops);
@@ -5002,13 +5115,21 @@ static const struct seq_operations sg_snapshot_seq_ops = {
 	.start = dev_seq_start,
 	.next  = dev_seq_next,
 	.stop  = dev_seq_stop,
-	.show  = sg_proc_seq_show_debug,
+	.show  = sg_proc_seq_show_debug_full,
+};
+
+static const struct seq_operations sg_snapshot_summ_seq_ops = {
+	.start = dev_seq_start,
+	.next  = dev_seq_next,
+	.stop  = dev_seq_stop,
+	.show  = sg_proc_seq_show_debug_summ,
 };
 
 static const struct sg_dfs_attr sg_dfs_attrs[] = {
 	{"snapshot", 0400, .seq_ops = &sg_snapshot_seq_ops},
 	{"snapshot_devs", 0600, sg_dfs_snapshot_devs_show,
 	 sg_dfs_snapshot_devs_write},
+	{"snapshot_summary", 0400, .seq_ops = &sg_snapshot_summ_seq_ops},
 	{ },
 };
 
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 532f0f0a56be..7d11905dd787 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -107,6 +107,7 @@ typedef struct sg_io_hdr {
  */
 #define SGV4_FLAG_DIRECT_IO SG_FLAG_DIRECT_IO
 #define SGV4_FLAG_MMAP_IO SG_FLAG_MMAP_IO
+#define SGV4_FLAG_YIELD_TAG 0x8  /* sg_io_v4::generated_tag set after SG_IOS */
 #define SGV4_FLAG_Q_AT_TAIL SG_FLAG_Q_AT_TAIL
 #define SGV4_FLAG_Q_AT_HEAD SG_FLAG_Q_AT_HEAD
 #define SGV4_FLAG_IMMED 0x400 /* for polling with SG_IOR, ignored in SG_IOS */
@@ -177,10 +178,12 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 
 /* flag and mask values for boolean fields follow */
 #define SG_CTL_FLAGM_TIME_IN_NS	0x1	/* time: nanosecs (def: millisecs) */
+#define SG_CTL_FLAGM_TAG_FOR_PACK_ID 0x2 /* prefer tag over pack_id (def) */
 #define SG_CTL_FLAGM_OTHER_OPENS 0x4	/* rd: other sg fd_s on this dev */
 #define SG_CTL_FLAGM_ORPHANS	0x8	/* rd: orphaned requests on this fd */
 #define SG_CTL_FLAGM_Q_TAIL	0x10	/* used for future cmds on this fd */
 #define SG_CTL_FLAGM_NO_DURATION 0x400	/* don't calc command duration */
+#define SG_CTL_FLAGM_MORE_ASYNC	0x800	/* yield EAGAIN in more cases */
 #define SG_CTL_FLAGM_ALL_BITS	0xfff	/* should be OR of previous items */
 
 /* Write one of the following values to sg_extended_info::read_value, get... */
-- 
2.25.1

