Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6757C43470
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C6A613FC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239507AbhD0WAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:18 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39030 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239503AbhD0V7u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 174D7204296;
        Tue, 27 Apr 2021 23:59:05 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CxKdL1NNlPGY; Tue, 27 Apr 2021 23:59:03 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 4B6BA204190;
        Tue, 27 Apr 2021 23:59:01 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 57/83] sg: add excl_wait flag
Date:   Tue, 27 Apr 2021 17:57:07 -0400
Message-Id: <20210427215733.417746-59-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The new SG_CTL_FLAGM_EXCL_WAITQ boolean flag can be set on a sg file
descriptor so that subsequent wait_event_interruptible() calls can
be changed to their "_exclusive()" variants. This is to address the
potential "thundering herd" problem with the wait_queue

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 83 ++++++++++++++++++++++++++++--------------
 include/uapi/scsi/sg.h | 29 ++++++++++-----
 2 files changed, 74 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4ccb7ab469f1..02435d2ef555 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -139,6 +139,7 @@ enum sg_shr_var {
 #define SG_FRQ_FOR_MMAP		7	/* request needs PAGE_SIZE elements */
 #define SG_FRQ_COUNT_ACTIVE	8	/* sfp->submitted + waiting active */
 #define SG_FRQ_ISSUED		9	/* blk_execute_rq_nowait() finished */
+#define SG_FRQ_POLL_SLEPT	10	/* stop re-entry of hybrid_sleep() */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
@@ -153,6 +154,7 @@ enum sg_shr_var {
 #define SG_FFD_NO_DURATION	9	/* don't do command duration calc */
 #define SG_FFD_MORE_ASYNC	10	/* yield EBUSY more often */
 #define SG_FFD_MRQ_ABORT	11	/* SG_IOABORT + FLAG_MULTIPLE_REQS */
+#define SG_FFD_EXCL_WAITQ	12	/* append _exclusive to wait_event */
 
 /* Bit positions (flags) for sg_device::fdev_bm bitmask follow */
 #define SG_FDEV_EXCLUDE		0	/* have fd open with O_EXCL */
@@ -962,6 +964,17 @@ sg_mrq_1complet(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 	return 0;
 }
 
+static int
+sg_wait_mrq_event(struct sg_fd *sfp, struct sg_request **srpp)
+{
+	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm))
+		return __wait_event_interruptible_exclusive
+					(sfp->cmpl_wait,
+					 sg_mrq_get_ready_srp(sfp, srpp));
+	return __wait_event_interruptible(sfp->cmpl_wait,
+					  sg_mrq_get_ready_srp(sfp, srpp));
+}
+
 /*
  * This is a fair-ish algorithm for an interruptible wait on two file
  * descriptors. It favours the main fd over the secondary fd (sec_sfp).
@@ -1002,9 +1015,7 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 					return res;
 			}
 		} else if (mreqs > 0) {
-			res = wait_event_interruptible
-					(sfp->cmpl_wait,
-					 sg_mrq_get_ready_srp(sfp, &srp));
+			res = sg_wait_mrq_event(sfp, &srp);
 			if (unlikely(res))
 				return res;	/* signal --> -ERESTARTSYS */
 			if (IS_ERR(srp)) {
@@ -1017,9 +1028,7 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 					return res;
 			}
 		} else if (sec_reqs > 0) {
-			res = wait_event_interruptible
-					(sec_sfp->cmpl_wait,
-					 sg_mrq_get_ready_srp(sec_sfp, &srp));
+			res = sg_wait_mrq_event(sec_sfp, &srp);
 			if (unlikely(res))
 				return res;	/* signal --> -ERESTARTSYS */
 			if (IS_ERR(srp)) {
@@ -1082,6 +1091,7 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 				       rip, k, "no IMMED with COMPLETE_B4");
 				return -ERANGE;
 			}
+			/* N.B. SGV4_FLAG_SIG_ON_OTHER is allowed */
 		}
 		if (!sg_fd_is_shared(sfp)) {
 			if (unlikely(flags & SGV4_FLAG_SHARE)) {
@@ -1113,8 +1123,9 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 /*
  * Implements the multiple request functionality. When 'blocking' is true
  * invocation was via ioctl(SG_IO), otherwise it was via ioctl(SG_IOSUBMIT).
- * Only fully non-blocking if IMMED flag given or when ioctl(SG_IOSUBMIT)
- * is used with O_NONBLOCK set on its file descriptor.
+ * Submit non-blocking if IMMED flag given or when ioctl(SG_IOSUBMIT)
+ * is used with O_NONBLOCK set on its file descriptor. Hipri non-blocking
+ * is when the HIPRI flag is given.
  */
 static int
 sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
@@ -1174,8 +1185,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 		immed = true;
 	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, id_of_mrq=%d\n", __func__,
 	       (immed ? "IMMED" : (blocking ?  "ordered blocking" :
-				   "variable blocking")),
-	       tot_reqs, id_of_mrq);
+				   "variable blocking")), tot_reqs, id_of_mrq);
 	sg_sgv4_out_zero(cop);
 
 	if (unlikely(tot_reqs > U16_MAX)) {
@@ -2018,9 +2028,7 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs,
 		return k;
 
 	for ( ; k < max_mrqs; ++k) {
-		res = wait_event_interruptible
-				(sfp->cmpl_wait,
-				 sg_mrq_get_ready_srp(sfp, &srp));
+		res = sg_wait_mrq_event(sfp, &srp);
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
@@ -2083,6 +2091,19 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p,
 	return res;
 }
 
+static int
+sg_wait_id_event(struct sg_fd *sfp, struct sg_request **srpp, int id,
+		 bool is_tag)
+{
+	if (test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm))
+		return __wait_event_interruptible_exclusive
+				(sfp->cmpl_wait,
+				 sg_get_ready_srp(sfp, srpp, id, is_tag));
+	return __wait_event_interruptible
+			(sfp->cmpl_wait,
+			 sg_get_ready_srp(sfp, srpp, id, is_tag));
+}
+
 /*
  * Called when ioctl(SG_IORECEIVE) received. Expects a v4 interface object.
  * Checks if O_NONBLOCK file flag given, if not checks given 'flags' field
@@ -2134,9 +2155,7 @@ sg_ctl_ioreceive(struct sg_fd *sfp, void __user *p)
 			return -ENODEV;
 		if (non_block)
 			return -EAGAIN;
-		res = wait_event_interruptible
-				(sfp->cmpl_wait,
-				 sg_get_ready_srp(sfp, &srp, id, use_tag));
+		res = sg_wait_id_event(sfp, &srp, id, use_tag);
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
@@ -2191,9 +2210,7 @@ sg_ctl_ioreceive_v3(struct sg_fd *sfp, void __user *p)
 			return -ENODEV;
 		if (non_block)
 			return -EAGAIN;
-		res = wait_event_interruptible
-				(sfp->cmpl_wait,
-				 sg_get_ready_srp(sfp, &srp, pack_id, false));
+		res = sg_wait_id_event(sfp, &srp, pack_id, false);
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
 		if (IS_ERR(srp))
@@ -2351,7 +2368,7 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 					int flgs;
 
 					ret = get_user(flgs, &h3_up->flags);
-					if (ret)
+					if (unlikely(ret))
 						return ret;
 					if (flgs & SGV4_FLAG_IMMED)
 						non_block = true;
@@ -2374,9 +2391,7 @@ sg_read(struct file *filp, char __user *p, size_t count, loff_t *ppos)
 			return -ENODEV;
 		if (non_block) /* O_NONBLOCK or v3::flags & SGV4_FLAG_IMMED */
 			return -EAGAIN;
-		ret = wait_event_interruptible
-				(sfp->cmpl_wait,
-				 sg_get_ready_srp(sfp, &srp, want_id, false));
+		ret = sg_wait_id_event(sfp, &srp, want_id, false);
 		if (unlikely(ret))  /* -ERESTARTSYS as signal hit process */
 			return ret;
 		if (IS_ERR(srp))
@@ -2846,9 +2861,9 @@ sg_wait_event_srp(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		goto skip_wait;
 	}
 	SG_LOG(3, sfp, "%s: about to wait_event...()\n", __func__);
-	/* usually will be woken up by sg_rq_end_io() callback */
-	res = wait_event_interruptible(sfp->cmpl_wait,
-				       sg_rq_landed(sdp, srp));
+	/* N.B. The SG_FFD_EXCL_WAITQ flag is ignored here. */
+	res = __wait_event_interruptible(sfp->cmpl_wait,
+					 sg_rq_landed(sdp, srp));
 	if (unlikely(res)) { /* -ERESTARTSYS because signal hit thread */
 		set_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
 		/* orphans harvested when sfp->keep_orphan is false */
@@ -3316,7 +3331,7 @@ sg_find_sfp_by_fd(const struct file *search_for, int search_fd,
 	++num_d;
 	for (k = 0; k < num_d; ++k) {
 		sdp = idr_find(&sg_index_idr, k);
-		if (unlikely(!sdp || SG_IS_DETACHING(sdp)))
+		if (unlikely(!sdp) || SG_IS_DETACHING(sdp))
 			continue;
 		xa_for_each_marked(&sdp->sfp_arr, idx, sfp,
 				   SG_XA_FD_UNSHARED) {
@@ -3354,7 +3369,7 @@ sg_find_sfp_by_fd(const struct file *search_for, int search_fd,
 		++num_d;
 		for (k = 0; k < num_d; ++k) {
 			sdp = idr_find(&sg_index_idr, k);
-			if (unlikely(!sdp || SG_IS_DETACHING(sdp)))
+			if (unlikely(!sdp) || SG_IS_DETACHING(sdp))
 				continue;
 			xa_for_each(&sdp->sfp_arr, idx, sfp) {
 				if (!sg_fd_is_shared(sfp))
@@ -3781,6 +3796,18 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 		else
 			c_flgs_val_out &= ~SG_CTL_FLAGM_MORE_ASYNC;
 	}
+	/* EXCL_WAITQ boolean, [rbw] */
+	if (c_flgs_rm & SG_CTL_FLAGM_EXCL_WAITQ)
+		flg = test_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm);
+	if (c_flgs_wm & SG_CTL_FLAGM_EXCL_WAITQ)
+		assign_bit(SG_FFD_EXCL_WAITQ, sfp->ffd_bm,
+			   !!(c_flgs_val_in & SG_CTL_FLAGM_EXCL_WAITQ));
+	if (c_flgs_rm & SG_CTL_FLAGM_EXCL_WAITQ) {
+		if (flg)
+			c_flgs_val_out |= SG_CTL_FLAGM_EXCL_WAITQ;
+		else
+			c_flgs_val_out &= ~SG_CTL_FLAGM_EXCL_WAITQ;
+	}
 
 	if (c_flgs_val_in != c_flgs_val_out)
 		seip->ctl_flags = c_flgs_val_out;
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index e1919eadf036..8b3fe773dfd5 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -114,16 +114,16 @@ typedef struct sg_io_hdr {
 #define SGV4_FLAG_YIELD_TAG 0x8  /* sg_io_v4::generated_tag set after SG_IOS */
 #define SGV4_FLAG_Q_AT_TAIL SG_FLAG_Q_AT_TAIL
 #define SGV4_FLAG_Q_AT_HEAD SG_FLAG_Q_AT_HEAD
-#define SGV4_FLAG_COMPLETE_B4  0x100
-#define SGV4_FLAG_SIGNAL  0x200	/* v3: ignored; v4 signal on completion */
-#define SGV4_FLAG_IMMED 0x400 /* for polling with SG_IOR, ignored in SG_IOS */
+#define SGV4_FLAG_COMPLETE_B4  0x100	/* mrq: complete this rq before next */
+#define SGV4_FLAG_SIGNAL 0x200	/* v3: ignored; v4 signal on completion */
+#define SGV4_FLAG_IMMED 0x400   /* issue request and return immediately ... */
 #define SGV4_FLAG_HIPRI 0x800 /* request will use blk_poll to complete */
 #define SGV4_FLAG_STOP_IF 0x1000	/* Stops sync mrq if error or warning */
 #define SGV4_FLAG_DEV_SCOPE 0x2000 /* permit SG_IOABORT to have wider scope */
 #define SGV4_FLAG_SHARE 0x4000	/* share IO buffer; needs SG_SEIM_SHARE_FD */
 #define SGV4_FLAG_DO_ON_OTHER 0x8000 /* available on either of shared pair */
 #define SGV4_FLAG_NO_DXFER SG_FLAG_NO_DXFER /* but keep dev<-->kernel xfr */
-#define SGV4_FLAG_MULTIPLE_REQS 0x20000	/* n sg_io_v4s in data-in */
+#define SGV4_FLAG_MULTIPLE_REQS 0x20000	/* 1 or more sg_io_v4-s in data-in */
 
 /* Output (potentially OR-ed together) in v3::info or v4::info field */
 #define SG_INFO_OK_MASK 0x1
@@ -151,7 +151,7 @@ typedef struct sg_scsi_id {
 	short h_cmd_per_lun;/* host (adapter) maximum commands per lun */
 	short d_queue_depth;/* device (or adapter) maximum queue length */
 	union {
-		int unused[2];  /* as per version 3 driver */
+		int unused[2];	/* as per version 3 driver */
 		__u8 scsi_lun[8];  /* full 8 byte SCSI LUN [in v4 driver] */
 	};
 } sg_scsi_id_t;
@@ -163,8 +163,14 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 	/* sg_io_owned set imples synchronous, clear implies asynchronous */
 	char sg_io_owned;/* 0 -> complete with read(), 1 -> owned by SG_IO */
 	char problem;	/* 0 -> no problem detected, 1 -> error to report */
+	/* If SG_CTL_FLAGM_TAG_FOR_PACK_ID set on fd then next field is tag */
 	int pack_id;	/* pack_id, in v4 driver may be tag instead */
 	void __user *usr_ptr;	/* user provided pointer in v3+v4 interface */
+	/*
+	 * millisecs elapsed since the command started (req_state==1) or
+	 * command duration (req_state==2). Will be in nanoseconds after
+	 * the SG_SET_GET_EXTENDED{TIME_IN_NS} ioctl.
+	 */
 	unsigned int duration;
 	int unused;
 } sg_req_info_t;
@@ -199,12 +205,13 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 #define SG_CTL_FLAGM_IS_SHARE	0x20	/* rd: fd is read-side or write-side share */
 #define SG_CTL_FLAGM_IS_READ_SIDE 0x40	/* rd: this fd is read-side share */
 #define SG_CTL_FLAGM_UNSHARE	0x80	/* undo share after inflight cmd */
-/* rd> 1: read-side finished 0: not; wr> 1: finish share post read-side */
+/* rd> 1: read-side finished, 0: not; wr> 1: finish share post read-side */
 #define SG_CTL_FLAGM_READ_SIDE_FINI 0x100 /* wr> 0: setup for repeat write-side req */
 #define SG_CTL_FLAGM_READ_SIDE_ERR 0x200 /* rd: sharing, read-side got error */
 #define SG_CTL_FLAGM_NO_DURATION 0x400	/* don't calc command duration */
 #define SG_CTL_FLAGM_MORE_ASYNC	0x800	/* yield EAGAIN in more cases */
-#define SG_CTL_FLAGM_ALL_BITS	0xfff	/* should be OR of previous items */
+#define SG_CTL_FLAGM_EXCL_WAITQ 0x1000	/* only 1 wake up per response */
+#define SG_CTL_FLAGM_ALL_BITS	0x1fff	/* should be OR of previous items */
 
 /* Write one of the following values to sg_extended_info::read_value, get... */
 #define SG_SEIRV_INT_MASK	0x0	/* get SG_SEIM_ALL_BITS */
@@ -437,9 +444,11 @@ struct sg_header {
 /*
  * New ioctls to replace async (non-blocking) write()/read() interface.
  * Present in version 4 and later of the sg driver [>20190427]. The
- * SG_IOSUBMIT and SG_IORECEIVE ioctls accept the sg_v4 interface based on
- * struct sg_io_v4 found in <include/uapi/linux/bsg.h>. These objects are
- * passed by a pointer in the third argument of the ioctl.
+ * SG_IOSUBMIT_V3 and SG_IORECEIVE_V3 ioctls accept the sg_v3 interface
+ * based on struct sg_io_hdr shown above. The SG_IOSUBMIT and SG_IORECEIVE
+ * ioctls accept the sg_v4 interface based on struct sg_io_v4 found in
+ * <include/uapi/linux/bsg.h>. These objects are passed by a pointer in
+ * the third argument of the ioctl.
  *
  * Data may be transferred both from the user space to the driver by these
  * ioctls. Hence the _IOWR macro is used here to generate the ioctl number
-- 
2.25.1

