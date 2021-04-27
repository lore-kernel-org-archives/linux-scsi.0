Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38985C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 123FC613F1
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbhD0V74 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 17:59:56 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38975 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239476AbhD0V7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:34 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C45A620426F;
        Tue, 27 Apr 2021 23:58:49 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DF0bVsOobclb; Tue, 27 Apr 2021 23:58:47 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 89A60204190;
        Tue, 27 Apr 2021 23:58:46 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 48/83] sg: sgat_elem_sz and sum_fd_dlens
Date:   Tue, 27 Apr 2021 17:56:58 -0400
Message-Id: <20210427215733.417746-50-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Wire up some more capabilities of ioctl(SG_SET_GET_EXTENDED). One
is the size of each internal scatter gather list element. This
defaults to 2^15 and was fixed in previous versions of this
driver. If the user provides a value, it must be a power of
2 (bytes) and no less than PAGE_SIZE.

sum_fd_dlens provides user control over a mechanism designed to
stop the starvation of the host machine's memory. Since requests
per file descriptor are no longer limited to 16, thousands could
be queued up by a badly designed program. If each one requests
a large buffer (say 128 KB each for READs) then without this
mechanism, the OOM killer may be called on to save the machine.
The driver counts the cumulative size of data buffers
outstanding held by each file descriptor. Once that figure
exceeds a default size of 32 MB, further submissions on that
file descriptor are failed with E2BIG.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 68 ++++++++++++++++++++++++++++++++++++++----
 include/uapi/scsi/sg.h |  1 +
 2 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 17a733d621c7..b141b0113f96 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -94,7 +94,11 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 	SG_RS_BUSY,		/* temporary state should rarely be seen */
 };
 
+/* If sum_of(dlen) of a fd exceeds this, write() will yield E2BIG */
+#define SG_TOT_FD_THRESHOLD (32 * 1024 * 1024)
+
 #define SG_TIME_UNIT_MS 0	/* milliseconds */
+/* #define SG_TIME_UNIT_NS 1	   nanoseconds */
 #define SG_DEF_TIME_UNIT SG_TIME_UNIT_MS
 #define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 #define SG_FD_Q_AT_HEAD 0
@@ -238,6 +242,8 @@ struct sg_fd {		/* holds the state of a file descriptor */
 	atomic_t submitted;	/* number inflight or awaiting receive */
 	atomic_t waiting;	/* number of requests awaiting receive */
 	atomic_t inactives;	/* number of inactive requests */
+	atomic_t sum_fd_dlens;	/* when tot_fd_thresh>0 this is sum_of(dlen) */
+	int tot_fd_thresh;	/* E2BIG if sum_of(dlen) > this, 0: ignore */
 	int sgat_elem_sz;	/* initialized to scatter_elem_sz */
 	int mmap_sz;		/* byte size of previous mmap() call */
 	unsigned long ffd_bm[1];	/* see SG_FFD_* defines above */
@@ -2144,8 +2150,8 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 {
 	int result = 0;
 	int ret = 0;
-	int n, s_wr_mask, s_rd_mask;
-	u32 or_masks;
+	int n, j, s_wr_mask, s_rd_mask;
+	u32 uv, or_masks;
 	struct sg_device *sdp = sfp->parentdp;
 	struct sg_extended_info *seip;
 	struct sg_extended_info sei;
@@ -2162,6 +2168,19 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 	}
 	SG_LOG(3, sfp, "%s: wr_mask=0x%x rd_mask=0x%x\n", __func__, s_wr_mask,
 	       s_rd_mask);
+	/* tot_fd_thresh (u32), [rbw] [limit for sum of active cmd dlen_s] */
+	if (or_masks & SG_SEIM_TOT_FD_THRESH) {
+		u32 hold = sfp->tot_fd_thresh;
+
+		if (s_wr_mask & SG_SEIM_TOT_FD_THRESH) {
+			uv = seip->tot_fd_thresh;
+			if (uv > 0 && uv < PAGE_SIZE)
+				uv = PAGE_SIZE;
+			sfp->tot_fd_thresh = uv;
+		}
+		if (s_rd_mask & SG_SEIM_TOT_FD_THRESH)
+			seip->tot_fd_thresh = hold;
+	}
 	/* check all boolean flags for either wr or rd mask set in or_mask */
 	if (or_masks & SG_SEIM_CTL_FLAGS)
 		sg_extended_bool_flags(sfp, seip);
@@ -2176,6 +2195,7 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 	}
 	if ((s_rd_mask & SG_SEIM_READ_VAL) && (s_wr_mask & SG_SEIM_READ_VAL))
 		sg_extended_read_value(sfp, seip);
+	/* call blk_poll() on this fd's HIPRI requests [raw] */
 	if (or_masks & SG_SEIM_BLK_POLL) {
 		n = 0;
 		if (s_wr_mask & SG_SEIM_BLK_POLL) {
@@ -2188,7 +2208,24 @@ sg_ctl_extended(struct sg_fd *sfp, void __user *p)
 			}
 		}
 		if (s_rd_mask & SG_SEIM_BLK_POLL)
-			seip->num = n;
+			seip->num = n;		/* number completed by LLD */
+	}
+	/* override scatter gather element size [rbw] (def: SG_SCATTER_SZ) */
+	if (or_masks & SG_SEIM_SGAT_ELEM_SZ) {
+		n = sfp->sgat_elem_sz;
+		if (s_wr_mask & SG_SEIM_SGAT_ELEM_SZ) {
+			j = (int)seip->sgat_elem_sz;
+			if (!is_power_of_2(j) || j < (int)PAGE_SIZE) {
+				SG_LOG(1, sfp, "%s: %s not power of 2, %s\n",
+				       __func__, "sgat element size",
+				       "or less than PAGE_SIZE");
+				ret = -EINVAL;
+			} else {
+				sfp->sgat_elem_sz = j;
+			}
+		}
+		if (s_rd_mask & SG_SEIM_SGAT_ELEM_SZ)
+			seip->sgat_elem_sz = n; /* prior value if rw */
 	}
 	/* reserved_sz [raw], since may be reduced by other limits */
 	if (s_wr_mask & SG_SEIM_RESERVED_SIZE) {
@@ -3586,6 +3623,8 @@ sg_mk_sgat(struct sg_request *srp, struct sg_fd *sfp, int minlen)
 	schp->page_order = order;
 	schp->num_sgat = k;
 	schp->buflen = align_sz;
+	if (sfp->tot_fd_thresh > 0)
+		atomic_add(align_sz, &sfp->sum_fd_dlens);
 	return 0;
 err_out:
 	k = pgp - schp->pages;
@@ -3634,6 +3673,14 @@ sg_remove_sgat(struct sg_request *srp)
 		" [rsv]" : ""));
 	sg_remove_sgat_helper(sfp, schp);
 
+	if (sfp->tot_fd_thresh > 0) {
+		/* this is a subtraction, error if it goes negative */
+		if (atomic_add_negative(-schp->buflen, &sfp->sum_fd_dlens)) {
+			SG_LOG(2, sfp, "%s: logic error: this dlen > %s\n",
+			       __func__, "sum_fd_dlens");
+			atomic_set(&sfp->sum_fd_dlens, 0);
+		}
+	}
 	memset(schp, 0, sizeof(*schp));         /* zeros buflen and dlen */
 }
 
@@ -3886,6 +3933,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 	bool second = false;
 	bool has_inactive = false;
 	int l_used_idx;
+	u32 sum_dlen;
 	unsigned long idx, s_idx, end_idx, iflags;
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_request *r_srp = NULL;	/* request to return */
@@ -3977,6 +4025,13 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, int dxfr_len)
 			SG_LOG(6, fp, "%s: trying 2nd req but cmd_q=false\n",
 			       __func__);
 			goto fini;
+		} else if (fp->tot_fd_thresh > 0) {
+			sum_dlen = atomic_read(&fp->sum_fd_dlens) + dxfr_len;
+			if (sum_dlen > (u32)fp->tot_fd_thresh) {
+				r_srp = ERR_PTR(-E2BIG);
+				SG_LOG(2, fp, "%s: sum_of_dlen(%u) > %s\n",
+				       __func__, sum_dlen, "tot_fd_thresh");
+			}
 		}
 		r_srp = sg_mk_srp_sgat(fp, act_empty, dxfr_len);
 		if (IS_ERR(r_srp)) {
@@ -4071,6 +4126,8 @@ sg_add_sfp(struct sg_device *sdp)
 	__assign_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm, SG_DEF_KEEP_ORPHAN);
 	__assign_bit(SG_FFD_TIME_IN_NS, sfp->ffd_bm, SG_DEF_TIME_UNIT);
 	__assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm, SG_DEFAULT_Q_AT);
+	sfp->tot_fd_thresh = SG_TOT_FD_THRESHOLD;
+	atomic_set(&sfp->sum_fd_dlens, 0);
 	/*
 	 * SG_SCATTER_SZ initializes scatter_elem_sz but different value may
 	 * be given as driver/module parameter (e.g. 'scatter_elem_sz=8192').
@@ -4547,8 +4604,9 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx)
 		       (int)test_bit(SG_FFD_KEEP_ORPHAN, fp->ffd_bm),
 		       fp->ffd_bm[0]);
 	n += scnprintf(obp + n, len - n,
-		       "   mmap_sz=%d low_used_idx=%d low_await_idx=%d\n",
-		       fp->mmap_sz, READ_ONCE(fp->low_used_idx), READ_ONCE(fp->low_await_idx));
+		       "   mmap_sz=%d low_used_idx=%d low_await_idx=%d sum_fd_dlens=%u\n",
+		       fp->mmap_sz, READ_ONCE(fp->low_used_idx), READ_ONCE(fp->low_await_idx),
+		       atomic_read(&fp->sum_fd_dlens));
 	n += scnprintf(obp + n, len - n,
 		       "   submitted=%d waiting=%d inactives=%d   open thr_id=%d\n",
 		       atomic_read(&fp->submitted),
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 74f177583fce..532f0f0a56be 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -169,6 +169,7 @@ typedef struct sg_req_info {	/* used by SG_GET_REQUEST_TABLE ioctl() */
 #define SG_SEIM_CTL_FLAGS	0x1	/* ctl_flags_mask bits in ctl_flags */
 #define SG_SEIM_READ_VAL	0x2	/* write SG_SEIRV_*, read back value */
 #define SG_SEIM_RESERVED_SIZE	0x4	/* reserved_sz of reserve request */
+#define SG_SEIM_TOT_FD_THRESH	0x8	/* tot_fd_thresh of data buffers */
 #define SG_SEIM_MINOR_INDEX	0x10	/* sg device minor index number */
 #define SG_SEIM_SGAT_ELEM_SZ	0x80	/* sgat element size (>= PAGE_SIZE) */
 #define SG_SEIM_BLK_POLL	0x100	/* call blk_poll, uses 'num' field */
-- 
2.25.1

