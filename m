Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E25BC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0230A613C5
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239437AbhD0WAl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:41 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38991 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239164AbhD0WAK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E7DA52042A1;
        Tue, 27 Apr 2021 23:59:25 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LP00tpAA1Qsz; Tue, 27 Apr 2021 23:59:23 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id AEE4220429C;
        Tue, 27 Apr 2021 23:59:22 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 70/83] sg: make use of struct sg_mrq_hold
Date:   Tue, 27 Apr 2021 17:57:20 -0400
Message-Id: <20210427215733.417746-72-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Not enough use was being made of the mrq parameters holding structure.
By using this more, significant reductions are made in the number of
passed parameters in the functions processing mrq requests.

Rename sg_sgv4_out_zero() to sg_v4h_partial_zero() and add a comment
above the function about what it does.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 61 ++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef3b42814b9a..bdb9b3dbf970 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -957,12 +957,12 @@ sg_submit_v3(struct sg_fd *sfp, struct sg_io_hdr *hp, bool sync,
 	return 0;
 }
 
-static void
-sg_sgv4_out_zero(struct sg_io_v4 *h4p)
+/* Clear from and including driver_status to end of sg_io_v4 object */
+static inline void
+sg_v4h_partial_zero(struct sg_io_v4 *h4p)
 {
-	const int off = offsetof(struct sg_io_v4, driver_status);
+	static const int off = offsetof(struct sg_io_v4, driver_status);
 
-	/* clear from and including driver_status to end of object */
 	memset((u8 *)h4p + off, 0, SZ_SG_IO_V4 - off);
 }
 
@@ -973,11 +973,13 @@ sg_sgv4_out_zero(struct sg_io_v4 *h4p)
  * secondary error value (s_res) is placed in the cop->spare_out field.
  */
 static int
-sg_mrq_arr_flush(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds, u32 tot_reqs,
-		 int s_res)
+sg_mrq_arr_flush(struct sg_mrq_hold *mhp)
 {
-	u32 sz = min(tot_reqs * SZ_SG_IO_V4, cop->din_xfer_len);
+	int s_res = mhp->s_res;
+	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 	void __user *p = uptr64(cop->din_xferp);
+	struct sg_io_v4 *a_hds = mhp->a_hds;
+	u32 sz = min(mhp->tot_reqs * SZ_SG_IO_V4, cop->din_xfer_len);
 
 	if (unlikely(s_res))
 		cop->spare_out = -s_res;
@@ -991,11 +993,13 @@ sg_mrq_arr_flush(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds, u32 tot_reqs,
 }
 
 static int
-sg_mrq_1complet(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
-		struct sg_fd *do_on_sfp, int tot_reqs, struct sg_request *srp)
+sg_mrq_1complet(struct sg_mrq_hold *mhp, struct sg_fd *do_on_sfp,
+		struct sg_request *srp)
 {
 	int s_res, indx;
+	int tot_reqs = mhp->tot_reqs;
 	struct sg_io_v4 *hp;
+	struct sg_io_v4 *a_hds = mhp->a_hds;
 
 	if (unlikely(!srp))
 		return -EPROTO;
@@ -1015,7 +1019,7 @@ sg_mrq_1complet(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 		return s_res;
 	hp->info |= SG_INFO_MRQ_FINI;
 	if (do_on_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
-		s_res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, s_res);
+		s_res = sg_mrq_arr_flush(mhp);
 		if (unlikely(s_res))	/* can only be -EFAULT */
 			return s_res;
 		kill_fasync(&do_on_sfp->async_qp, SIGPOLL, POLL_IN);
@@ -1040,13 +1044,13 @@ sg_wait_mrq_event(struct sg_fd *sfp, struct sg_request **srpp)
  * Increments cop->info for each successful completion.
  */
 static int
-sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
-		struct sg_fd *sfp, struct sg_fd *sec_sfp, int tot_reqs,
-		int mreqs, int sec_reqs)
+sg_mrq_complets(struct sg_mrq_hold *mhp, struct sg_fd *sfp,
+		struct sg_fd *sec_sfp, int mreqs, int sec_reqs)
 {
 	int res = 0;
 	int rres;
 	struct sg_request *srp;
+	struct sg_io_v4 *cop = mhp->cwrp->h4p;
 
 	SG_LOG(3, sfp, "%s: mreqs=%d, sec_reqs=%d\n", __func__, mreqs,
 	       sec_reqs);
@@ -1059,7 +1063,7 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 				break;
 			}
 			--mreqs;
-			res = sg_mrq_1complet(cop, a_hds, sfp, tot_reqs, srp);
+			res = sg_mrq_1complet(mhp, sfp, srp);
 			if (unlikely(res))
 				return res;
 			++cop->info;
@@ -1074,8 +1078,7 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 				break;
 			}
 			--sec_reqs;
-			rres = sg_mrq_1complet(cop, a_hds, sec_sfp, tot_reqs,
-					       srp);
+			rres = sg_mrq_1complet(mhp, sec_sfp, srp);
 			if (unlikely(rres))
 				return rres;
 			++cop->info;
@@ -1092,8 +1095,7 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 				mreqs = 0;
 			} else {
 				--mreqs;
-				res = sg_mrq_1complet(cop, a_hds, sfp,
-						      tot_reqs, srp);
+				res = sg_mrq_1complet(mhp, sfp, srp);
 				if (unlikely(res))
 					return res;
 				++cop->info;
@@ -1109,8 +1111,7 @@ sg_mrq_complets(struct sg_io_v4 *cop, struct sg_io_v4 *a_hds,
 				sec_reqs = 0;
 			} else {
 				--sec_reqs;
-				res = sg_mrq_1complet(cop, a_hds, sec_sfp,
-						      tot_reqs, srp);
+				res = sg_mrq_1complet(mhp, sec_sfp, srp);
 				if (unlikely(res))
 					return res;
 				++cop->info;
@@ -1141,7 +1142,7 @@ sg_mrq_sanity(struct sg_device *sdp, struct sg_io_v4 *cop,
 	/* Pre-check each request for anomalies, plus some preparation */
 	for (k = 0, hp = a_hds; k < tot_reqs; ++k, ++hp) {
 		flags = hp->flags;
-		sg_sgv4_out_zero(hp);
+		sg_v4h_partial_zero(hp);
 		if (unlikely(hp->guard != 'Q' || hp->protocol != 0 ||
 			     hp->subprotocol != 0)) {
 			SG_LOG(1, sfp, "%s: req index %u: %s or protocol\n",
@@ -1357,8 +1358,7 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 			break;	/* cop->driver_status <-- 0 in this case */
 		}
 		if (rq_sfp->async_qp && (hp->flags & SGV4_FLAG_SIGNAL)) {
-			res = sg_mrq_arr_flush(cop, mhp->a_hds, mhp->tot_reqs,
-					       mhp->s_res);
+			res = sg_mrq_arr_flush(mhp);
 			if (unlikely(res))
 				break;
 			kill_fasync(&rq_sfp->async_qp, SIGPOLL, POLL_IN);
@@ -1374,8 +1374,7 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 	if (mhp->immed)
 		return res;
 	if (likely(res == 0 && (this_fp_sent + other_fp_sent) > 0)) {
-		mhp->s_res = sg_mrq_complets(cop, mhp->a_hds, fp, o_sfp,
-					     mhp->tot_reqs, this_fp_sent,
+		mhp->s_res = sg_mrq_complets(mhp, fp, o_sfp, this_fp_sent,
 					     other_fp_sent);
 		if (unlikely(mhp->s_res == -EFAULT ||
 			     mhp->s_res == -ERESTARTSYS))
@@ -1510,8 +1509,7 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 					break;
 				}
 				--other_fp_sent;
-				res = sg_mrq_1complet(cop, a_hds, o_sfp,
-						      mhp->tot_reqs, srp);
+				res = sg_mrq_1complet(mhp, o_sfp, srp);
 				if (unlikely(res))
 					return res;
 				++cop->info;
@@ -1527,8 +1525,7 @@ sg_process_svb_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 					break;
 				}
 				--this_fp_sent;
-				res = sg_mrq_1complet(cop, a_hds, fp,
-						      mhp->tot_reqs, srp);
+				res = sg_mrq_1complet(mhp, fp, srp);
 				if (unlikely(res))
 					return res;
 				++cop->info;
@@ -1715,7 +1712,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 		mhp->immed = true;
 	SG_LOG(3, fp, "%s: %s, tot_reqs=%u, id_of_mrq=%d\n", __func__,
 	       mrq_name, tot_reqs, mhp->id_of_mrq);
-	sg_sgv4_out_zero(cop);
+	sg_v4h_partial_zero(cop);
 
 	if (unlikely(tot_reqs > U16_MAX)) {
 		return -ERANGE;
@@ -1799,7 +1796,7 @@ sg_do_multi_req(struct sg_comm_wr_t *cwrp, bool blocking)
 	}
 fini:
 	if (likely(res == 0) && !mhp->immed)
-		res = sg_mrq_arr_flush(cop, a_hds, tot_reqs, mhp->s_res);
+		res = sg_mrq_arr_flush(mhp);
 	kfree(cdb_ap);
 	kfree(a_hds);
 	return res;
@@ -2712,7 +2709,7 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p,
 	if (unlikely(!rsp_v4_arr))
 		return -ENOMEM;
 
-	sg_sgv4_out_zero(cop);
+	sg_v4h_partial_zero(cop);
 	cop->din_resid = n;
 	res = sg_mrq_iorec_complets(sfp, non_block, n, rsp_v4_arr);
 	if (unlikely(res < 0))
-- 
2.25.1

