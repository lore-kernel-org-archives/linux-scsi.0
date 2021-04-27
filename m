Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FADC43462
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A4CC613FC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbhD0WAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:39 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39093 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239138AbhD0WAF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D2C3B2041C0;
        Tue, 27 Apr 2021 23:59:20 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id g39H5nvaSKPm; Tue, 27 Apr 2021 23:59:19 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id C24AB2041BD;
        Tue, 27 Apr 2021 23:59:17 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 67/83] sg: finish after read-side request
Date:   Tue, 27 Apr 2021 17:57:17 -0400
Message-Id: <20210427215733.417746-69-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace dual role sg_change_after_read_side_rq() with single role
sg_finish_rs_rq(). Its purpose is to terminate a request share
after its first half (i.e. the read-side). The termination makes
the read-side's reserve request available for re-use.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 90 +++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dcb9afe722c2..13a9c3f77715 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -100,13 +100,13 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RQ_AWAIT_RCV==2 */
 	SG_RQ_SHR_IN_WS,	/* read-side: waits while write-side inflight */
 };
 
-/* write-side sets up sharing: ioctl(ws_fd,SG_SET_GET_EXTENDED(SHARE_FD(rs_fd))) */
+/* these varieties of share requests are known before a request is created */
 enum sg_shr_var {
-	SG_SHR_NONE = 0,	/* no sharing on this fd, so _not_ shared request */
-	SG_SHR_RS_NOT_SRQ,	/* read-side fd but _not_ shared request */
-	SG_SHR_RS_RQ,		/* read-side sharing on this request */
-	SG_SHR_WS_NOT_SRQ,	/* write-side fd but _not_ shared request */
-	SG_SHR_WS_RQ,		/* write-side sharing on this request */
+	SG_SHR_NONE = 0,	/* no sharing on owning fd */
+	SG_SHR_RS_NOT_SRQ,	/* read-side sharing on fd but not on this req */
+	SG_SHR_RS_RQ,		/* read-side sharing on this data carrying req */
+	SG_SHR_WS_NOT_SRQ,	/* write-side sharing on fd but not on this req */
+	SG_SHR_WS_RQ,		/* write-side sharing on this data carrying req */
 };
 
 /* If sum_of(dlen) of a fd exceeds this, write() will yield E2BIG */
@@ -1503,6 +1503,8 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 					--cop->din_resid;
 				if (srp->s_hdr4.dir != SG_DXFER_FROM_DEV)
 					continue;
+				if (test_bit(SG_FFD_READ_SIDE_ERR, fp->ffd_bm))
+					continue;
 				/* read-side req completed, submit its write-side */
 				rs_srp = srp;
 				for (m = 0; m < k; ++m) {
@@ -3077,19 +3079,18 @@ sg_calc_sgat_param(struct sg_device *sdp)
 }
 
 /*
- * Only valid for shared file descriptors, else -EINVAL. Should only be
- * called after a read-side request has successfully completed so that
- * there is valid data in reserve buffer. If fini1_again0 is true then
- * read-side is taken out of the state waiting for a write-side request and the
- * read-side is put in the inactive state. If fini1_again0 is false (0) then
- * the read-side (assuming it is inactive) is put in a state waiting for
- * a write-side request. This function is called when the write mask is set on
- * ioctl(SG_SET_GET_EXTENDED(SG_CTL_FLAGM_READ_SIDE_FINI)).
+ * Only valid for shared file descriptors. Designed to be called after a
+ * read-side request has successfully completed leaving valid data in a
+ * reserve request buffer. The read-side is moved from SG_RQ_SHR_SWAP
+ * to SG_RQ_INACTIVE state and returns 0. Acts on first reserve requests.
+ * Otherwise -EINVAL is returned, unless write-side is in progress in
+ * which case -EBUSY is returned.
  */
 static int
-sg_change_after_read_side_rq(struct sg_fd *sfp, bool fini1_again0)
+sg_finish_rs_rq(struct sg_fd *sfp)
 {
 	int res = -EINVAL;
+	int k;
 	enum sg_rq_state sr_st;
 	unsigned long iflags;
 	struct sg_fd *rs_sfp;
@@ -3101,51 +3102,44 @@ sg_change_after_read_side_rq(struct sg_fd *sfp, bool fini1_again0)
 		goto fini;
 	if (xa_get_mark(&sdp->sfp_arr, sfp->idx, SG_XA_FD_RS_SHARE))
 		rs_sfp = sfp;
-	rs_rsv_srp = rs_sfp->rsv_arr[0];
-	if (IS_ERR_OR_NULL(rs_rsv_srp))
-		goto fini;
 
-	res = 0;
-	xa_lock_irqsave(&rs_sfp->srp_arr, iflags);
-	sr_st = atomic_read(&rs_rsv_srp->rq_st);
-	if (fini1_again0) {	/* finish req share after read-side req */
+	for (k = 0; k < SG_MAX_RSV_REQS; ++k) {
+		res = -EINVAL;
+		rs_rsv_srp = rs_sfp->rsv_arr[k];
+		if (IS_ERR_OR_NULL(rs_rsv_srp))
+			continue;
+		xa_lock_irqsave(&rs_sfp->srp_arr, iflags);
+		sr_st = atomic_read(&rs_rsv_srp->rq_st);
 		switch (sr_st) {
 		case SG_RQ_SHR_SWAP:
-			rs_rsv_srp->sh_var = SG_SHR_RS_NOT_SRQ;
-			rs_rsv_srp = NULL;
-			res = sg_rq_chg_state(rs_rsv_srp, sr_st, SG_RQ_INACTIVE);
+			res = sg_rq_chg_state_ulck(rs_rsv_srp, sr_st, SG_RQ_BUSY);
 			if (!res)
 				atomic_inc(&rs_sfp->inactives);
+			rs_rsv_srp->tag = SG_TAG_WILDCARD;
+			rs_rsv_srp->sh_var = SG_SHR_NONE;
+			set_bit(SG_FRQ_RESERVED, rs_rsv_srp->frq_bm);
+			rs_rsv_srp->in_resid = 0;
+			rs_rsv_srp->rq_info = 0;
+			rs_rsv_srp->sense_len = 0;
+			rs_rsv_srp->sh_srp = NULL;
+			sg_finish_scsi_blk_rq(rs_rsv_srp);
+			sg_deact_request(rs_rsv_srp->parentfp, rs_rsv_srp);
 			break;
 		case SG_RQ_SHR_IN_WS:	/* too late, write-side rq active */
 		case SG_RQ_BUSY:
-			res = -EAGAIN;
+			res = -EBUSY;
 			break;
 		default:
 			res = -EINVAL;
 			break;
 		}
-	} else {	/* again: tweak state to allow another write-side request */
-		switch (sr_st) {
-		case SG_RQ_INACTIVE:
-			rs_rsv_srp->sh_var = SG_SHR_RS_RQ;
-			res = sg_rq_chg_state(rs_rsv_srp, sr_st, SG_RQ_SHR_SWAP);
-			break;
-		case SG_RQ_SHR_SWAP:
-			break;	/* already done, redundant call? */
-		default:	/* all other states */
-			res = -EBUSY;	/* read-side busy doing ... */
-			break;
-		}
+		xa_unlock_irqrestore(&rs_sfp->srp_arr, iflags);
+		if (res == 0)
+			return res;
 	}
-	xa_unlock_irqrestore(&rs_sfp->srp_arr, iflags);
 fini:
-	if (unlikely(res)) {
+	if (unlikely(res))
 		SG_LOG(1, sfp, "%s: err=%d\n", __func__, -res);
-	} else {
-		SG_LOG(6, sfp, "%s: okay, fini1_again0=%d\n", __func__,
-		       fini1_again0);
-	}
 	return res;
 }
 
@@ -4354,11 +4348,9 @@ sg_extended_bool_flags(struct sg_fd *sfp, struct sg_extended_info *seip)
 			c_flgs_val_out &= ~SG_CTL_FLAGM_READ_SIDE_FINI;
 		}
 	}
-	if (c_flgs_wm & SG_CTL_FLAGM_READ_SIDE_FINI) {
-		bool rs_fini_wm = !!(c_flgs_val_in & SG_CTL_FLAGM_READ_SIDE_FINI);
-
-		res = sg_change_after_read_side_rq(sfp, rs_fini_wm);
-	}
+	if ((c_flgs_wm & SG_CTL_FLAGM_READ_SIDE_FINI) &&
+	    (c_flgs_val_in & SG_CTL_FLAGM_READ_SIDE_FINI))
+		res = sg_finish_rs_rq(sfp);
 	/* READ_SIDE_ERR boolean, [ro] share: read-side finished with error */
 	if (c_flgs_rm & SG_CTL_FLAGM_READ_SIDE_ERR) {
 		rs_sfp = sg_fd_share_ptr(sfp);
-- 
2.25.1

