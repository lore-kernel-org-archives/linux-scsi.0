Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5E5C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D6D8613FC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbhD0WAP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:15 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39009 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239438AbhD0V7q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 17:59:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 6CAE1204278;
        Tue, 27 Apr 2021 23:59:00 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tT4ljUe+TRhq; Tue, 27 Apr 2021 23:58:58 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id D1835204190;
        Tue, 27 Apr 2021 23:58:54 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 53/83] sg: rename some mrq variables
Date:   Tue, 27 Apr 2021 17:57:03 -0400
Message-Id: <20210427215733.417746-55-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While preparing for a larger change/addition to multiple
request (mrq) handling, some variable names have been
changed for greater clarity and/or brevity.

In sg_mrq_get_rq() -ENODATA was being returned via srpp when there
was no request waiting. It should only do that when no request has
been submitted. Submitted includes the number inflight plus the
number waiting. Fold sg_mrq_get_rq() into sg_mrq_get_ready_srp().
Fix sg_rec_state_v3v4() treatment of read-side's SG_RQ_AWAIT_RCV
state.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 120 +++++++++++++++++++++-------------------------
 1 file changed, 55 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 635a3e2b10e5..d30c0034d767 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -916,8 +916,8 @@ sg_sgv4_out_zero(struct sg_io_v4 *h4p)
 }
 
 /*
- * Takes a pointer to the controlling multiple request (mrq) object and a
- * pointer to the command array. The command array (with tot_reqs elements)
+ * Takes a pointer (cop) to the multiple request (mrq) control object and
+ * a pointer to the command array. The command array (with tot_reqs elements)
  * is written out (flushed) to user space pointer cop->din_xferp. The
  * secondary error value (s_res) is placed in the cop->spare_out field.
  */
@@ -969,6 +969,7 @@ sg_mrq_1complet(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 /*
  * This is a fair-ish algorithm for an interruptible wait on two file
  * descriptors. It favours the main fd over the secondary fd (sec_sfp).
+ * Increments cop->info for each successful completion.
  */
 static int
 sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
@@ -1046,23 +1047,22 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 static int
 sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 	      struct sg_io_v4 *a_hds, u8 *cdb_ap, struct sg_fd *sfp,
-	      u32 tot_reqs)
+	      bool immed, u32 tot_reqs)
 {
-	bool immed = !!(cop->flags & SGV4_FLAG_IMMED);
 	bool have_mrq_sense = (cop->response && cop->max_response_len);
 	int k;
 	u32 cdb_alen = cop->request_len;
 	u32 cdb_mxlen = cdb_alen / tot_reqs;
 	u32 flags;
-	struct sg_io_v4 *siv4p;
+	struct sg_io_v4 *hp;
 	__maybe_unused const char *rip = "request index";
 
-	/* Pre-check each request for anomalies */
-	for (k = 0, siv4p = a_hds; k < tot_reqs; ++k, ++siv4p) {
-		flags = siv4p->flags;
-		sg_sgv4_out_zero(siv4p);
-		if (siv4p->guard != 'Q' || siv4p->protocol != 0 ||
-		    siv4p->subprotocol != 0) {
+	/* Pre-check each request for anomalies, plus some preparation */
+	for (k = 0, hp = a_hds; k < tot_reqs; ++k, ++hp) {
+		flags = hp->flags;
+		sg_sgv4_out_zero(hp);
+		if (unlikely(hp->guard != 'Q' || hp->protocol != 0 ||
+			     hp->subprotocol != 0)) {
 			SG_LOG(1, sfp, "%s: req index %u: %s or protocol\n",
 			       __func__, k, "bad guard");
 			return -ERANGE;
@@ -1099,23 +1099,23 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 			}
 		}
 		if (cdb_ap) {
-			if (siv4p->request_len > cdb_mxlen) {
+			if (unlikely(hp->request_len > cdb_mxlen)) {
 				SG_LOG(1, sfp, "%s: %s %u, cdb too long\n",
 				       __func__, rip, k);
 				return -ERANGE;
 			}
 		}
-		if (have_mrq_sense && siv4p->response == 0 &&
-		    siv4p->max_response_len == 0) {
-			siv4p->response = cop->response;
-			siv4p->max_response_len = cop->max_response_len;
+		if (have_mrq_sense && hp->response == 0 &&
+		    hp->max_response_len == 0) {
+			hp->response = cop->response;
+			hp->max_response_len = cop->max_response_len;
 		}
 	}
 	return 0;
 }
 
 /*
- * Implements the multiple request functionality. When blocking is true
+ * Implements the multiple request functionality. When 'blocking' is true
  * invocation was via ioctl(SG_IO), otherwise it was via ioctl(SG_IOSUBMIT).
  * Only fully non-blocking if IMMED flag given or when ioctl(SG_IOSUBMIT)
  * is used with O_NONBLOCK set on its file descriptor.
@@ -1123,7 +1123,7 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 static int
 sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 {
-	bool set_this, set_other, immed, stop_if, f_non_block;
+	bool immed, stop_if, f_non_block;
 	int res = 0;
 	int s_res = 0;	/* for secondary error: some-good-then-error, case */
 	int other_fp_sent = 0;
@@ -1136,9 +1136,9 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	u32 blen = cop->dout_xfer_len;
 	u32 cdb_alen = cop->request_len;
 	u32 tot_reqs = blen / SZ_SG_IO_V4;
-	struct sg_io_v4 *siv4p;
 	u8 *cdb_ap = NULL;
-	struct sg_io_v4 *a_hds;
+	struct sg_io_v4 *hp;		/* ptr to request object in a_hds */
+	struct sg_io_v4 *a_hds;		/* array of request objects */
 	struct sg_fd *fp = cwrp->sfp;
 	struct sg_fd *o_sfp = sg_fd_share_ptr(fp);
 	struct sg_fd *rq_sfp;
@@ -1213,40 +1213,31 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 		}
 	}
 	/* do sanity checks on all requests before starting */
-	res = sg_mrq_sanity(sdp, cop, a_hds, cdb_ap, fp, tot_reqs);
+	res = sg_mrq_sanity(sdp, cop, a_hds, cdb_ap, fp, immed, tot_reqs);
 	if (unlikely(res))
 		goto fini;
-	set_this = false;
-	set_other = false;
-	/* Dispatch requests and optionally wait for response */
-	for (k = 0, siv4p = a_hds; k < tot_reqs; ++k, ++siv4p) {
-		flags = siv4p->flags;
-		if (flags & SGV4_FLAG_DO_ON_OTHER) {
-			rq_sfp = o_sfp;
-			if (!set_other) {
-				set_other = true;
-				set_bit(SG_FFD_CMD_Q, rq_sfp->ffd_bm);
-			}
-		} else {
-			rq_sfp = fp;
-			if (!set_this) {
-				set_this = true;
-				set_bit(SG_FFD_CMD_Q, rq_sfp->ffd_bm);
-			}
-		}
+	/* override cmd queuing setting to allow */
+	set_bit(SG_FFD_CMD_Q, fp->ffd_bm);
+	if (o_sfp)
+		set_bit(SG_FFD_CMD_Q, o_sfp->ffd_bm);
+
+	/* Dispatch (submit) requests and optionally wait for response */
+	for (hp = a_hds, k = 0; num_cmpl < tot_reqs; ++hp, ++k) {
+		flags = hp->flags;
+		rq_sfp = (flags & SGV4_FLAG_DO_ON_OTHER) ? o_sfp : fp;
 		if (cdb_ap) {	/* already have array of cdbs */
 			cwrp->cmdp = cdb_ap + (k * cdb_mxlen);
 			cwrp->u_cmdp = NULL;
 		} else {	/* fetch each cdb from user space */
 			cwrp->cmdp = NULL;
-			cwrp->u_cmdp = cuptr64(siv4p->request);
+			cwrp->u_cmdp = cuptr64(hp->request);
 		}
-		cwrp->cmd_len = siv4p->request_len;
-		ul_timeout = msecs_to_jiffies(siv4p->timeout);
+		cwrp->cmd_len = hp->request_len;
+		ul_timeout = msecs_to_jiffies(hp->timeout);
 		cwrp->frq_bm[0] = 0;
-		assign_bit(SG_FRQ_SYNC_INVOC, cwrp->frq_bm, (int)blocking);
-		set_bit(SG_FRQ_IS_V4I, cwrp->frq_bm);
-		cwrp->h4p = siv4p;
+		__assign_bit(SG_FRQ_SYNC_INVOC, cwrp->frq_bm, (int)blocking);
+		__set_bit(SG_FRQ_IS_V4I, cwrp->frq_bm);
+		cwrp->h4p = hp;
 		cwrp->timeout = min_t(unsigned long, ul_timeout, INT_MAX);
 		cwrp->sfp = rq_sfp;
 		srp = sg_common_write(cwrp);
@@ -1262,8 +1253,8 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 				++other_fp_sent;
 			continue;  /* defer completion until all submitted */
 		}
-		s_res = sg_wait_event_srp(rq_sfp, NULL, siv4p, srp);
-		if (s_res) {
+		s_res = sg_wait_event_srp(rq_sfp, NULL, hp, srp);
+		if (unlikely(s_res)) {
 			if (s_res == -ERESTARTSYS) {
 				res = s_res;
 				goto fini;
@@ -1275,25 +1266,24 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 			break;
 		}
 		++num_cmpl;
-		siv4p->info |= SG_INFO_MRQ_FINI;
-		if (stop_if && (siv4p->driver_status ||
-				siv4p->transport_status ||
-				siv4p->device_status)) {
+		hp->info |= SG_INFO_MRQ_FINI;
+		if (stop_if && (hp->driver_status || hp->transport_status ||
+				hp->device_status)) {
 			SG_LOG(2, fp, "%s: %s=0x%x/0x%x/0x%x] cause exit\n",
 			       __func__, "STOP_IF and status [drv/tran/scsi",
-			       siv4p->driver_status, siv4p->transport_status,
-			       siv4p->device_status);
-			break;	/* cop::driver_status <-- 0 in this case */
+			       hp->driver_status, hp->transport_status,
+			       hp->device_status);
+			break;	/* cop->driver_status <-- 0 in this case */
 		}
-		if (rq_sfp->async_qp && (siv4p->flags & SGV4_FLAG_SIGNAL)) {
+		if (rq_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
 			res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
 			if (unlikely(res))
 				break;
 			kill_fasync(&rq_sfp->async_qp, SIGPOLL, POLL_IN);
 		}
-	}	/* end of dispatch request and optionally wait loop */
-	cop->dout_resid = tot_reqs - k;
-	cop->info = k;
+	}	/* end of dispatch request and optionally wait response loop */
+	cop->dout_resid = tot_reqs - num_cmpl;
+	cop->info = num_cmpl;
 	if (cop->din_xfer_len > 0) {
 		cop->din_resid = tot_reqs - num_cmpl;
 		cop->spare_out = -s_res;
@@ -1624,21 +1614,20 @@ sg_rq_chg_state_force(struct sg_request *srp, enum sg_rq_state new_st)
 static void
 sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 {
-	bool at_head, is_v4h, sync;
+	bool at_head, sync;
 	struct sg_device *sdp = sfp->parentdp;
 	struct request *rqq = READ_ONCE(srp->rqq);
 
-	is_v4h = test_bit(SG_FRQ_IS_V4I, srp->frq_bm);
 	sync = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
-	SG_LOG(3, sfp, "%s: is_v4h=%d\n", __func__, (int)is_v4h);
+	SG_LOG(3, sfp, "%s: pack_id=%d\n", __func__, srp->pack_id);
 	if (test_bit(SG_FFD_NO_DURATION, sfp->ffd_bm))
 		srp->start_ns = 0;
 	else
 		srp->start_ns = ktime_get_boottime_ns();/* assume always > 0 */
 	srp->duration = 0;
 
-	if (!is_v4h && srp->s_hdr3.interface_id == '\0')
-		at_head = true;	/* backward compatibility: v1+v2 interfaces */
+	if (!test_bit(SG_FRQ_IS_V4I, srp->frq_bm) && srp->s_hdr3.interface_id == '\0')
+		at_head = true;	/* backward compatibility for v1+v2 interfaces */
 	else if (test_bit(SG_FFD_Q_AT_TAIL, sfp->ffd_bm))
 		/* cmd flags can override sfd setting */
 		at_head = !!(srp->rq_flags & SG_FLAG_Q_AT_HEAD);
@@ -1854,10 +1843,11 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 			sg_rq_chg_state_force(rs_srp, SG_RQ_INACTIVE);
 			atomic_inc(&sh_sfp->inactives);
 			break;
-		case SG_RQ_INACTIVE:
 		case SG_RQ_AWAIT_RCV:
+			break;
+		case SG_RQ_INACTIVE:
 			sh_sfp->ws_srp = NULL;
-			break;  /* nothing to do */
+			break;	/* nothing to do */
 		default:
 			err = -EPROTO;	/* Logic error */
 			SG_LOG(1, sfp,
-- 
2.25.1

