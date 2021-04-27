Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF10C43470
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A31D9613C5
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbhD0WAk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:40 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38838 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239195AbhD0WAJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E6C90204190;
        Tue, 27 Apr 2021 23:59:23 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JYXfPOEMaXae; Tue, 27 Apr 2021 23:59:22 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 11CBF2041BD;
        Tue, 27 Apr 2021 23:59:20 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 69/83] sg: add dlen to sg_comm_wr_t
Date:   Tue, 27 Apr 2021 17:57:19 -0400
Message-Id: <20210427215733.417746-71-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The data transfer length was being recalculated and passed as
a function argument. It is tidier to place it in struct
sg_comm_wr_t with other similar parameters.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 84 ++++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 1f6aae3909c7..ef3b42814b9a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -321,6 +321,7 @@ struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 	int timeout;
 	int cmd_len;
 	int rsv_idx;		/* wanted rsv_arr index, def: -1 (anyone) */
+	int dlen;		/* dout or din length in bytes */
 	int wr_offset;		/* non-zero if v4 and DOUT_OFFSET set */
 	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
 	union {		/* selector is frq_bm.SG_FRQ_IS_V4I */
@@ -375,7 +376,7 @@ static struct sg_request *sg_find_srp_by_id(struct sg_fd *sfp, int id,
 					    bool is_tag);
 static bool sg_mrq_get_ready_srp(struct sg_fd *sfp, struct sg_request **srpp);
 static struct sg_request *sg_setup_req(struct sg_comm_wr_t *cwrp,
-				       enum sg_shr_var sh_var, int dxfr_len);
+				       enum sg_shr_var sh_var);
 static void sg_deact_request(struct sg_fd *sfp, struct sg_request *srp);
 static struct sg_device *sg_get_dev(int min_dev);
 static void sg_device_destroy(struct kref *kref);
@@ -870,6 +871,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	}
 	sg_comm_wr_init(&cwr);
 	cwr.h3p = h3p;
+	cwr.dlen = h3p->dxfer_len;
 	cwr.timeout = sfp->timeout;
 	cwr.cmd_len = cmd_size;
 	cwr.sfp = sfp;
@@ -942,6 +944,7 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 	sg_comm_wr_init(&cwr);
 	__assign_bit(SG_FRQ_SYNC_INVOC, cwr.frq_bm, (int)sync);
 	cwr.h3p = hp;
+	cwr.dlen = hp->dxfer_len;
 	cwr.timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	cwr.cmd_len = hp->cmd_len;
 	cwr.sfp = sfp;
@@ -1280,6 +1283,7 @@ sg_mrq_submit(struct sg_fd *rq_sfp, struct sg_mrq_hold *mhp, int pos_hdr,
 		     (int)mhp->blocking);
 	__set_bit(SG_FRQ_IS_V4I, r_cwrp->frq_bm);
 	r_cwrp->h4p = hp;
+	r_cwrp->dlen = hp->din_xfer_len ? hp->din_xfer_len : hp->dout_xfer_len;
 	r_cwrp->timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 	if (hp->flags & SGV4_FLAG_DOUT_OFFSET)
 		r_cwrp->wr_offset = hp->spare_in;
@@ -1806,11 +1810,14 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 	     bool sync, struct sg_request **o_srp)
 {
 	int res = 0;
+	int dlen;
 	unsigned long ul_timeout;
 	struct sg_request *srp;
 	struct sg_comm_wr_t cwr;
 
 	sg_comm_wr_init(&cwr);
+	dlen = h4p->din_xfer_len ? h4p->din_xfer_len : h4p->dout_xfer_len;
+	cwr.dlen = dlen;
 	if (h4p->flags & SGV4_FLAG_MULTIPLE_REQS) {
 		/* want v4 async or sync with guard, din and dout and flags */
 		if (!h4p->dout_xferp || h4p->din_iovec_count ||
@@ -1832,13 +1839,7 @@ sg_submit_v4(struct sg_fd *sfp, void __user *p, struct sg_io_v4 *h4p,
 		return 0;
 	}
 	if (h4p->flags & SG_FLAG_MMAP_IO) {
-		int len = 0;
-
-		if (h4p->din_xferp)
-			len = h4p->din_xfer_len;
-		else if (h4p->dout_xferp)
-			len = h4p->dout_xfer_len;
-		res = sg_chk_mmap(sfp, h4p->flags, len);
+		res = sg_chk_mmap(sfp, h4p->flags, dlen);
 		if (unlikely(res))
 			return res;
 	}
@@ -2312,7 +2313,8 @@ static struct sg_request *
 sg_common_write(struct sg_comm_wr_t *cwrp)
 {
 	int res = 0;
-	int dxfr_len, dir;
+	int dlen = cwrp->dlen;
+	int dir;
 	int pack_id = SG_PACK_ID_WILDCARD;
 	u32 rq_flags;
 	enum sg_shr_var sh_var;
@@ -2325,31 +2327,26 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 	if (likely(test_bit(SG_FRQ_IS_V4I, cwrp->frq_bm))) {
 		h4p = cwrp->h4p;
 		hi_p = NULL;
-		dxfr_len = 0;
 		dir = SG_DXFER_NONE;
 		rq_flags = h4p->flags;
 		pack_id = h4p->request_extra;
-		if (unlikely(h4p->din_xfer_len && h4p->dout_xfer_len)) {
+		if (unlikely(h4p->din_xfer_len && h4p->dout_xfer_len))
 			return ERR_PTR(-EOPNOTSUPP);
-		} else if (h4p->din_xfer_len) {
-			dxfr_len = h4p->din_xfer_len;
+		else if (h4p->din_xfer_len)
 			dir = SG_DXFER_FROM_DEV;
-		} else if (h4p->dout_xfer_len) {
-			dxfr_len = h4p->dout_xfer_len;
+		else if (h4p->dout_xfer_len)
 			dir = SG_DXFER_TO_DEV;
-		}
 	} else {			/* sg v3 interface so hi_p valid */
 		h4p = NULL;
 		hi_p = cwrp->h3p;
 		dir = hi_p->dxfer_direction;
-		dxfr_len = hi_p->dxfer_len;
 		rq_flags = hi_p->flags;
 		pack_id = hi_p->pack_id;
 	}
 	if (unlikely(rq_flags & SGV4_FLAG_MULTIPLE_REQS))
 		return ERR_PTR(-ERANGE);  /* only control object sets this */
 	if (sg_fd_is_shared(fp)) {
-		res = sg_share_chk_flags(fp, rq_flags, dxfr_len, dir, &sh_var);
+		res = sg_share_chk_flags(fp, rq_flags, dlen, dir, &sh_var);
 		if (unlikely(res < 0))
 			return ERR_PTR(res);
 	} else {
@@ -2357,10 +2354,10 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		if (unlikely(rq_flags & SGV4_FLAG_SHARE))
 			return ERR_PTR(-ENOMSG);    /* no file share found */
 	}
-	if (unlikely(dxfr_len >= SZ_256M))
+	if (unlikely(dlen >= SZ_256M))
 		return ERR_PTR(-EINVAL);
 
-	srp = sg_setup_req(cwrp, sh_var, dxfr_len);
+	srp = sg_setup_req(cwrp, sh_var);
 	if (IS_ERR(srp))
 		return srp;
 	srp->rq_flags = rq_flags;
@@ -2376,7 +2373,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		srp->s_hdr4.mrq_ind = 0;
 		if (dir == SG_DXFER_TO_DEV) {
 			srp->s_hdr4.wr_offset = cwrp->wr_offset;
-			srp->s_hdr4.wr_len = dxfr_len;
+			srp->s_hdr4.wr_len = dlen;
 		}
 	} else {	/* v3 interface active */
 		memcpy(&srp->s_hdr3, hi_p, sizeof(srp->s_hdr3));
@@ -5867,7 +5864,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 {
 	bool no_dxfer, us_xfer;
 	int res = 0;
-	int dxfer_len = 0;
+	int dlen = cwrp->dlen;
 	int r0w = READ;
 	u32 rq_flags = srp->rq_flags;
 	unsigned int iov_count = 0;
@@ -5898,11 +5895,9 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		if (dxfer_dir == SG_DXFER_TO_DEV) {
 			r0w = WRITE;
 			up = uptr64(h4p->dout_xferp);
-			dxfer_len = (int)h4p->dout_xfer_len;
 			iov_count = h4p->dout_iovec_count;
 		} else if (dxfer_dir == SG_DXFER_FROM_DEV) {
 			up = uptr64(h4p->din_xferp);
-			dxfer_len = (int)h4p->din_xfer_len;
 			iov_count = h4p->din_iovec_count;
 		} else {
 			up = NULL;
@@ -5911,12 +5906,11 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		struct sg_slice_hdr3 *sh3p = &srp->s_hdr3;
 
 		up = sh3p->dxferp;
-		dxfer_len = (int)sh3p->dxfer_len;
 		iov_count = sh3p->iovec_count;
 		r0w = dxfer_dir == SG_DXFER_TO_DEV ? WRITE : READ;
 	}
-	SG_LOG(4, sfp, "%s: dxfer_len=%d%s\n", __func__, dxfer_len,
-	       (dxfer_len ? (r0w ? ", data-OUT" : ", data-IN") : ""));
+	SG_LOG(4, sfp, "%s: dlen=%d%s\n", __func__, dlen,
+	       (dlen ? (r0w ? ", data-OUT" : ", data-IN") : ""));
 	q = sdp->device->request_queue;
 
 	/*
@@ -5954,7 +5948,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		goto fini;
 	scsi_rp->cmd_len = cwrp->cmd_len;
 	srp->cmd_opcode = scsi_rp->cmd[0];
-	no_dxfer = dxfer_len <= 0 || dxfer_dir == SG_DXFER_NONE;
+	no_dxfer = dlen <= 0 || dxfer_dir == SG_DXFER_NONE;
 	us_xfer = !(rq_flags & (SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO));
 	__assign_bit(SG_FRQ_US_XFER, srp->frq_bm, !no_dxfer && us_xfer);
 	rqq->end_io_data = srp;
@@ -5966,7 +5960,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		goto fini;	/* path of reqs with no din nor dout */
 	} else if (unlikely(rq_flags & SG_FLAG_DIRECT_IO) && iov_count == 0 &&
 		   !sdp->device->host->unchecked_isa_dma &&
-		   blk_rq_aligned(q, (unsigned long)up, dxfer_len)) {
+		   blk_rq_aligned(q, (unsigned long)up, dlen)) {
 		srp->rq_info |= SG_INFO_DIRECT_IO;
 		md = NULL;
 		if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
@@ -5982,11 +5976,10 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 			struct sg_request *r_srp = sfp->rsv_arr[0];
 
 			reserve0 = (r_srp == srp);
-			if (unlikely(!reserve0 ||
-				     dxfer_len > req_schp->buflen))
+			if (unlikely(!reserve0 || dlen > req_schp->buflen))
 				res = reserve0 ? -ENOMEM : -EBUSY;
 		} else if (req_schp->buflen == 0) {
-			int up_sz = max_t(int, dxfer_len, sfp->sgat_elem_sz);
+			int up_sz = max_t(int, dlen, sfp->sgat_elem_sz);
 
 			res = sg_mk_sgat(srp, sfp, up_sz);
 		}
@@ -6008,7 +6001,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		if (unlikely(res < 0))
 			goto fini;
 
-		iov_iter_truncate(&i, dxfer_len);
+		iov_iter_truncate(&i, dlen);
 		if (unlikely(!iov_iter_count(&i))) {
 			kfree(iov);
 			res = -EINVAL;
@@ -6021,7 +6014,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 		if (IS_ENABLED(CONFIG_SCSI_PROC_FS))
 			cp = "iov_count > 0";
 	} else if (us_xfer) { /* setup for transfer data to/from user space */
-		res = blk_rq_map_user(q, rqq, md, up, dxfer_len, GFP_ATOMIC);
+		res = blk_rq_map_user(q, rqq, md, up, dlen, GFP_ATOMIC);
 #if IS_ENABLED(SG_LOG_ACTIVE)
 		if (unlikely(res))
 			SG_LOG(1, sfp, "%s: blk_rq_map_user() res=%d\n",
@@ -6595,7 +6588,7 @@ sg_setup_req_ws_helper(struct sg_comm_wr_t *cwrp)
  * side's reserve request can only be used in a request share.
  */
 static struct sg_request *
-sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
+sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var)
 {
 	bool allow_rsv = true;		/* see note above */
 	bool mk_new_srp = true;
@@ -6608,6 +6601,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 	bool is_rsv;
 	int ra_idx = 0;
 	int l_used_idx;
+	int dlen = cwrp->dlen;
 	u32 sum_dlen;
 	unsigned long idx, s_idx, end_idx, iflags;
 	enum sg_rq_state sr_st;
@@ -6654,15 +6648,15 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 			goto err_out;
 		}
 		/* write-side dlen may be <= read-side's dlen */
-		if (unlikely(dxfr_len + cwrp->wr_offset >
+		if (unlikely(dlen + cwrp->wr_offset >
 			     rs_rsv_srp->sgatp->dlen)) {
 			SG_LOG(1, fp, "%s: bad, write-side dlen [%d] > read-side's\n",
-			       __func__, dxfr_len);
+			       __func__, dlen);
 			r_srp = ERR_PTR(-E2BIG);
 			goto err_out;
 		}
 		ws_rq = true;
-		dxfr_len = 0;	/* any srp for write-side will do, pick smallest */
+		dlen = 0;	/* any srp for write-side will do, pick smallest */
 		break;
 	case SG_SHR_RS_NOT_SRQ:
 		allow_rsv = false;
@@ -6677,7 +6671,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		mk_new_srp = true;
 	} else if (atomic_read(&fp->inactives) <= 0) {
 		mk_new_srp = true;
-	} else if (likely(!try_harder) && dxfr_len < SG_DEF_SECTOR_SZ) {
+	} else if (likely(!try_harder) && dlen < SG_DEF_SECTOR_SZ) {
 		struct sg_request *low_srp = NULL;
 
 		l_used_idx = READ_ONCE(fp->low_used_idx);
@@ -6728,7 +6722,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 			for (r_srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE);
 			     r_srp;
 			     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
-				if (dxfr_len <= r_srp->sgat_h.buflen) {
+				if (r_srp->sgat_h.buflen >= dlen) {
 					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
 						continue;
 					atomic_dec(&fp->inactives);
@@ -6749,7 +6743,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 			for (r_srp = xa_find(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE);
 			     r_srp;
 			     r_srp = xa_find_after(xafp, &idx, end_idx, SG_XA_RQ_INACTIVE)) {
-				if (dxfr_len <= r_srp->sgat_h.buflen &&
+				if (r_srp->sgat_h.buflen >= dlen &&
 				    !test_bit(SG_FRQ_RESERVED, r_srp->frq_bm)) {
 					if (sg_rq_chg_state(r_srp, SG_RQ_INACTIVE, SG_RQ_BUSY))
 						continue;
@@ -6789,7 +6783,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 			       __func__);
 			goto err_out;
 		} else if (fp->tot_fd_thresh > 0) {
-			sum_dlen = atomic_read(&fp->sum_fd_dlens) + dxfr_len;
+			sum_dlen = atomic_read(&fp->sum_fd_dlens) + dlen;
 			if (unlikely(sum_dlen > (u32)fp->tot_fd_thresh)) {
 				r_srp = ERR_PTR(-E2BIG);
 				SG_LOG(2, fp, "%s: sum_of_dlen(%u) > %s\n",
@@ -6810,9 +6804,9 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		}
 		if (IS_ERR(r_srp))	/* NULL is _not_ an ERR here */
 			goto err_out;
-		r_srp = sg_mk_srp_sgat(fp, no_reqs, dxfr_len);
+		r_srp = sg_mk_srp_sgat(fp, no_reqs, dlen);
 		if (IS_ERR(r_srp)) {
-			if (!try_harder && dxfr_len < SG_DEF_SECTOR_SZ &&
+			if (!try_harder && dlen < SG_DEF_SECTOR_SZ &&
 			    some_inactive) {
 				try_harder = true;
 				goto start_again;
@@ -6852,7 +6846,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		set_bit(SG_FRQ_IS_V4I, r_srp->frq_bm);
 	if (test_bit(SG_FRQ_SYNC_INVOC, cwrp->frq_bm))
 		set_bit(SG_FRQ_SYNC_INVOC, r_srp->frq_bm);
-	r_srp->sgatp->dlen = dxfr_len;/* must be <= r_srp->sgat_h.buflen */
+	r_srp->sgatp->dlen = dlen;	/* must be <= r_srp->sgat_h.buflen */
 	r_srp->sh_var = sh_var;
 	r_srp->cmd_opcode = 0xff;  /* set invalid opcode (VS), 0x0 is TUR */
 	/* If setup stalls (e.g. blk_get_request()) debug shows 'elap=1 ns' */
-- 
2.25.1

