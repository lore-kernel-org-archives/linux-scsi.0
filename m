Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65FE3C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B36E61400
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbhD0WAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:18 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39027 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239501AbhD0V7s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B6139204197;
        Tue, 27 Apr 2021 23:59:03 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id b9HMWyWLc+eN; Tue, 27 Apr 2021 23:59:02 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id A3BFE2041AC;
        Tue, 27 Apr 2021 23:58:59 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 56/83] sg: reduce atomic operations
Date:   Tue, 27 Apr 2021 17:57:06 -0400
Message-Id: <20210427215733.417746-58-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Various renamings and reductions of atomic operations:
  - rename mrq control object pointer from cv4p to mrqcp
  - change sense of internal file descriptor bitop
    SG_FFD_CMD_Q, now SG_FFD_NO_CMD_Q
  - add early exit to sg_find_srp_by_id() if waiting
    atomic < 1
  - change some atomic bitops into non-atomic variant

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 100 ++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3d659ff90788..4ccb7ab469f1 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -142,7 +142,7 @@ enum sg_shr_var {
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
-#define SG_FFD_CMD_Q		1	/* clear: only 1 active req per fd */
+#define SG_FFD_NO_CMD_Q		1	/* set: only 1 active req per fd */
 #define SG_FFD_KEEP_ORPHAN	2	/* policy for this fd */
 #define SG_FFD_HIPRI_SEEN	3	/* could have HIPRI requests active */
 #define SG_FFD_TIME_IN_NS	4	/* set: time in nanoseconds, else ms */
@@ -882,8 +882,9 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 		if (unlikely(res))
 			return res;
 	}
-	/* when v3 seen, allow cmd_q on this fd (def: no cmd_q) */
-	set_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
+	/* when v3 seen, allow cmd_q on this fd (def: cmd_q) */
+	if (test_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm))
+		clear_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(hp->timeout);
 	WRITE_ONCE(cwr.frq_bm[0], 0);
 	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
@@ -904,17 +905,10 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 static void
 sg_sgv4_out_zero(struct sg_io_v4 *h4p)
 {
-	h4p->driver_status = 0;
-	h4p->transport_status = 0;
-	h4p->device_status = 0;
-	h4p->retry_delay = 0;
-	h4p->info = 0;
-	h4p->response_len = 0;
-	h4p->duration = 0;
-	h4p->din_resid = 0;
-	h4p->dout_resid = 0;
-	h4p->generated_tag = 0;
-	h4p->spare_out = 0;
+	const int off = offsetof(struct sg_io_v4, driver_status);
+
+	/* clear from and including driver_status to end of object */
+	memset((u8 *)h4p + off, 0, SZ_SG_IO_V4 - off);
 }
 
 /*
@@ -984,7 +978,7 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 
 	SG_LOG(3, sfp, "%s: mreqs=%d, sec_reqs=%d\n", __func__, mreqs,
 	       sec_reqs);
-	for ( ; sum_inflight > 0; --sum_inflight) {
+	for ( ; sum_inflight > 0; --sum_inflight, ++cop->info) {
 		srp = NULL;
 		if (mreqs > 0 && sg_mrq_get_ready_srp(sfp, &srp)) {
 			if (IS_ERR(srp)) {	/* -ENODATA: no mrqs here */
@@ -1248,13 +1242,17 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 			rq_sfp = o_sfp;
 			if (!set_other) {
 				set_other = true;
-				set_bit(SG_FFD_CMD_Q, rq_sfp->ffd_bm);
+				if (test_bit(SG_FFD_NO_CMD_Q, rq_sfp->ffd_bm))
+					clear_bit(SG_FFD_NO_CMD_Q,
+						  rq_sfp->ffd_bm);
 			}
 		} else {
 			rq_sfp = fp;
 			if (!set_this) {
 				set_this = true;
-				set_bit(SG_FFD_CMD_Q, rq_sfp->ffd_bm);
+				if (test_bit(SG_FFD_NO_CMD_Q, rq_sfp->ffd_bm))
+					clear_bit(SG_FFD_NO_CMD_Q,
+						  rq_sfp->ffd_bm);
 			}
 		}
 		if (cdb_ap) {	/* already have array of cdbs */
@@ -1380,7 +1378,8 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 			return res;
 	}
 	/* once v4 (or v3) seen, allow cmd_q on this fd (def: no cmd_q) */
-	set_bit(SG_FFD_CMD_Q, sfp->ffd_bm);
+	if (test_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm))
+		clear_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm);
 	ul_timeout = msecs_to_jiffies(h4p->timeout);
 	cwr.sfp = sfp;
 	WRITE_ONCE(cwr.frq_bm[0], 0);
@@ -1728,14 +1727,14 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		pack_id = hi_p->pack_id;
 	}
 	if (unlikely(rq_flags & SGV4_FLAG_MULTIPLE_REQS))
-		return ERR_PTR(-ERANGE);
+		return ERR_PTR(-ERANGE);  /* only control object sets this */
 	if (sg_fd_is_shared(fp)) {
 		res = sg_share_chk_flags(fp, rq_flags, dxfr_len, dir, &sh_var);
 		if (unlikely(res < 0))
 			return ERR_PTR(res);
 	} else {
 		sh_var = SG_SHR_NONE;
-		if (rq_flags & SGV4_FLAG_SHARE)
+		if (unlikely(rq_flags & SGV4_FLAG_SHARE))
 			return ERR_PTR(-ENOMSG);
 	}
 	if (unlikely(dxfr_len >= SZ_256M))
@@ -2828,17 +2827,14 @@ sg_rq_landed(struct sg_device *sdp, struct sg_request *srp)
 	return atomic_read_acquire(&srp->rq_st) != SG_RQ_INFLIGHT || SG_IS_DETACHING(sdp);
 }
 
-/*
- * This is a blocking wait for a specific srp. When h4p is non-NULL, it is
- * the blocking multiple request case
- */
+/* This is a blocking wait then complete for a specific srp. */
 static int
 sg_wait_event_srp(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		  struct sg_request *srp)
 {
 	int res;
-	enum sg_rq_state sr_st;
 	struct sg_device *sdp = sfp->parentdp;
+	enum sg_rq_state sr_st;
 
 	if (atomic_read(&srp->rq_st) != SG_RQ_INFLIGHT)
 		goto skip_wait;		/* and skip _acquire() */
@@ -2993,8 +2989,10 @@ sg_match_first_mrq_after(struct sg_fd *sfp, int pack_id,
 	unsigned long idx;
 	struct sg_request *srp;
 
-	if (atomic_read(&sfp->waiting) < 1)
-		return NULL;
+	if (atomic_read(&sfp->waiting) < 1) {
+		if (atomic_read_acquire(&sfp->waiting) < 1)
+			return NULL;
+	}
 once_more:
 	xa_for_each_marked(&sfp->srp_arr, idx, srp, SG_XA_RQ_AWAIT) {
 		if (unlikely(!srp))
@@ -4170,16 +4168,16 @@ sg_ioctl_common(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 		       val);
 		res = put_user(val, ip);
 		return res;
-	case SG_SET_COMMAND_Q:
+	case SG_SET_COMMAND_Q:	/* set by driver whenever v3 or v4 req seen */
 		SG_LOG(3, sfp, "%s:    SG_SET_COMMAND_Q\n", __func__);
 		res = get_user(val, ip);
 		if (unlikely(res))
 			return res;
-		assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, !!val);
+		assign_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm, !val);
 		return 0;
 	case SG_GET_COMMAND_Q:
 		SG_LOG(3, sfp, "%s:    SG_GET_COMMAND_Q\n", __func__);
-		return put_user(test_bit(SG_FFD_CMD_Q, sfp->ffd_bm), ip);
+		return put_user(!test_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm), ip);
 	case SG_SET_KEEP_ORPHAN:
 		SG_LOG(3, sfp, "%s:    SG_SET_KEEP_ORPHAN\n", __func__);
 		res = get_user(val, ip);
@@ -4436,7 +4434,7 @@ sg_poll(struct file *filp, poll_table *wait)
 
 	if (SG_IS_DETACHING(sfp->parentdp))
 		p_res |= EPOLLHUP;
-	else if (likely(test_bit(SG_FFD_CMD_Q, sfp->ffd_bm)))
+	else if (likely(!test_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm)))
 		p_res |= EPOLLOUT | EPOLLWRNORM;
 	else if (atomic_read(&sfp->submitted) == 0)
 		p_res |= EPOLLOUT | EPOLLWRNORM;
@@ -5113,7 +5111,7 @@ sg_set_map_data(const struct sg_scatter_hold *schp, bool up_valid,
 static int
 sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 {
-	bool reserved, us_xfer;
+	bool reserved, no_xfer, us_xfer;
 	int res = 0;
 	int dxfer_len = 0;
 	int r0w = READ;
@@ -5201,16 +5199,16 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		goto err_out;
 	scsi_rp->cmd_len = cwrp->cmd_len;
 	srp->cmd_opcode = scsi_rp->cmd[0];
+	no_xfer = dxfer_len <= 0 || dxfer_dir == SG_DXFER_NONE;
 	us_xfer = !(rq_flags & (SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO));
-	assign_bit(SG_FRQ_US_XFER, srp->frq_bm, us_xfer);
+	__assign_bit(SG_FRQ_US_XFER, srp->frq_bm, !no_xfer && us_xfer);
 	reserved = (sfp->rsv_srp == srp);
 	rqq->end_io_data = srp;
 	scsi_rp->retries = SG_DEFAULT_RETRIES;
 	req_schp = srp->sgatp;
 
-	if (dxfer_len <= 0 || dxfer_dir == SG_DXFER_NONE) {
+	if (no_xfer) {
 		SG_LOG(4, sfp, "%s: no data xfer [0x%pK]\n", __func__, srp);
-		clear_bit(SG_FRQ_US_XFER, srp->frq_bm);
 		goto fini;	/* path of reqs with no din nor dout */
 	} else if (unlikely(rq_flags & SG_FLAG_DIRECT_IO) && iov_count == 0 &&
 		   !sdp->device->host->unchecked_isa_dma &&
@@ -5773,14 +5771,16 @@ sg_build_reserve(struct sg_fd *sfp, int buflen)
 /*
  * Setup an active request (soon to carry a SCSI command) to the current file
  * descriptor by creating a new one or re-using a request from the free
- * list (fl). If successful returns a valid pointer in SG_RQ_BUSY state. On
- * failure returns a negated errno value twisted by ERR_PTR() macro.
+ * list (fl). If successful returns a valid pointer to a sg_request object
+ * which is in the SG_RQ_BUSY state. On failure returns a negated errno value
+ * twisted by ERR_PTR() macro. Note that once a file share is established,
+ * the read-side's reserve request can only be used in a request share.
  */
 static struct sg_request *
 sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 {
 	bool act_empty = false;
-	bool allow_rsv = true;
+	bool allow_rsv = true;		/* see note above */
 	bool mk_new_srp = true;
 	bool ws_rq = false;
 	bool try_harder = false;
@@ -5872,6 +5872,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 	if (IS_ERR(r_srp)) {
 		if (PTR_ERR(r_srp) == -EBUSY)
 			goto err_out;
+#if IS_ENABLED(SG_LOG_ACTIVE)
 		if (sh_var == SG_SHR_RS_RQ)
 			snprintf(b, sizeof(b), "SG_SHR_RS_RQ --> sr_st=%s",
 				 sg_rq_st_str(sr_st, false));
@@ -5881,6 +5882,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		else
 			snprintf(b, sizeof(b), "sh_var=%s",
 				 sg_shr_str(sh_var, false));
+#endif
 		goto err_out;
 	}
 	cp = "";
@@ -5907,11 +5909,14 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		s_idx = (l_used_idx < 0) ? 0 : l_used_idx;
 		if (l_used_idx >= 0 && xa_get_mark(xafp, s_idx, SG_XA_RQ_INACTIVE)) {
 			r_srp = xa_load(xafp, s_idx);
-			if (r_srp && r_srp->sgat_h.buflen <= SG_DEF_SECTOR_SZ) {
-				if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY) == 0) {
-					mk_new_srp = false;
-					atomic_dec(&fp->inactives);
-					goto have_existing;
+			if (r_srp && (allow_rsv || rsv_srp != r_srp)) {
+				if (r_srp->sgat_h.buflen <= SG_DEF_SECTOR_SZ) {
+					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE,
+							    SG_RQ_BUSY) == 0) {
+						mk_new_srp = false;
+						atomic_dec(&fp->inactives);
+						goto have_existing;
+					}
 				}
 			}
 		}
@@ -5972,12 +5977,13 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 
 good_fini:
 	if (mk_new_srp) {	/* Need new sg_request object */
-		bool allow_cmd_q = test_bit(SG_FFD_CMD_Q, fp->ffd_bm);
+		bool disallow_cmd_q = test_bit(SG_FFD_NO_CMD_Q, fp->ffd_bm);
 		int res;
 		u32 n_idx;
 
 		cp = "new";
-		if (!allow_cmd_q && atomic_read(&fp->submitted) > 0) {
+		r_srp = NULL;
+		if (disallow_cmd_q && atomic_read(&fp->submitted) > 0) {
 			r_srp = ERR_PTR(-EDOM);
 			SG_LOG(6, fp, "%s: trying 2nd req but cmd_q=false\n",
 			       __func__);
@@ -6102,7 +6108,7 @@ sg_add_sfp(struct sg_device *sdp, struct file *filp)
 	sfp->filp = filp;
 	/* other bits in sfp->ffd_bm[1] cleared by kzalloc() above */
 	__assign_bit(SG_FFD_FORCE_PACKID, sfp->ffd_bm, SG_DEF_FORCE_PACK_ID);
-	__assign_bit(SG_FFD_CMD_Q, sfp->ffd_bm, SG_DEF_COMMAND_Q);
+	__assign_bit(SG_FFD_NO_CMD_Q, sfp->ffd_bm, !SG_DEF_COMMAND_Q);
 	__assign_bit(SG_FFD_KEEP_ORPHAN, sfp->ffd_bm, SG_DEF_KEEP_ORPHAN);
 	__assign_bit(SG_FFD_TIME_IN_NS, sfp->ffd_bm, SG_DEF_TIME_UNIT);
 	__assign_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm, SG_DEFAULT_Q_AT);
@@ -6616,7 +6622,7 @@ sg_proc_debug_fd(struct sg_fd *fp, char *obp, int len, unsigned long idx,
 		n += scnprintf(obp + n, len - n, "timeout=%ds rs", to / 1000);
 	n += scnprintf(obp + n, len - n, "v_buflen=%d%s idx=%lu\n   cmd_q=%d ",
 		       fp->rsv_srp->sgatp->buflen, cp, idx,
-		       (int)test_bit(SG_FFD_CMD_Q, fp->ffd_bm));
+		       (int)!test_bit(SG_FFD_NO_CMD_Q, fp->ffd_bm));
 	n += scnprintf(obp + n, len - n,
 		       "f_packid=%d k_orphan=%d ffd_bm=0x%lx\n",
 		       (int)test_bit(SG_FFD_FORCE_PACKID, fp->ffd_bm),
-- 
2.25.1

