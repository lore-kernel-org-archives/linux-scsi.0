Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BA0C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF54C613FE
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbhD0WAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:49 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38843 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239504AbhD0WAd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 8CC692042AD;
        Tue, 27 Apr 2021 23:59:41 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VpheI3HCMxW5; Tue, 27 Apr 2021 23:59:39 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 95C59204197;
        Tue, 27 Apr 2021 23:59:35 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 78/83] sg: max to read for mrq sg_ioreceive
Date:   Tue, 27 Apr 2021 17:57:28 -0400
Message-Id: <20210427215733.417746-80-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When using a multiple request (mrq) ioctl(SG_IORECEIVE) the size of the
supplied response array dictates an implicit maximum number of
responses that can be read by an invocation. An explicit maximum number
to read can be given in the control object's request_priority field. A
value of 0 in this field uses the implicit maximum value.

The mrq ioctl(SG_IORECEIVE) control object can now take the
SGV4_FLAG_IMMED flag, if so only those responses associated with
completed requests will be reported.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 56 ++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 37a3361dec31..ac7321ffbd05 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1314,6 +1314,7 @@ sg_wait_poll_for_given_srp(struct sg_fd *sfp, struct sg_request *srp, bool do_po
 	if (SG_IS_DETACHING(sdp))
 		goto detaching;
 	return sg_rq_chg_state(srp, SG_RQ_AWAIT_RCV, SG_RQ_BUSY);
+
 poll_loop:
 	if (srp->rq_flags & SGV4_FLAG_HIPRI) {
 		long state = current->state;
@@ -1367,37 +1368,34 @@ sg_wait_poll_for_given_srp(struct sg_fd *sfp, struct sg_request *srp, bool do_po
 static struct sg_request *
 sg_mrq_poll_either(struct sg_fd *sfp, struct sg_fd *sec_sfp, bool *on_sfp)
 {
-	bool sig_pending = false;
 	long state = current->state;
 	struct sg_request *srp;
 
 	do {		/* alternating polling loop */
 		if (sfp) {
 			if (sg_mrq_get_ready_srp(sfp, &srp)) {
+				__set_current_state(TASK_RUNNING);
 				if (!srp)
 					return ERR_PTR(-ENODEV);
 				*on_sfp = true;
-				__set_current_state(TASK_RUNNING);
 				return srp;
 			}
 		}
 		if (sec_sfp && sfp != sec_sfp) {
 			if (sg_mrq_get_ready_srp(sec_sfp, &srp)) {
+				__set_current_state(TASK_RUNNING);
 				if (!srp)
 					return ERR_PTR(-ENODEV);
 				*on_sfp = false;
-				__set_current_state(TASK_RUNNING);
 				return srp;
 			}
 		}
 		if (signal_pending_state(state, current)) {
-			sig_pending = true;
-			break;
+			__set_current_state(TASK_RUNNING);
+			return ERR_PTR(-ERESTARTSYS);
 		}
 		cpu_relax();
-	} while (!need_resched());
-	__set_current_state(TASK_RUNNING);
-	return ERR_PTR(sig_pending ? -ERESTARTSYS : -EAGAIN);
+	} while (true);
 }
 
 /*
@@ -3054,21 +3052,25 @@ sg_receive_v4(struct sg_fd *sfp, struct sg_request *srp, void __user *p, struct
  * of elements written to rsp_arr, which may be 0 if mrqs submitted but none waiting
  */
 static int
-sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs, struct sg_io_v4 *rsp_arr)
+sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_rcv, int num_rsp_arr,
+		      struct sg_io_v4 *rsp_arr)
 {
 	int k, idx;
 	int res = 0;
 	struct sg_request *srp;
 
-	SG_LOG(3, sfp, "%s: max_mrqs=%d\n", __func__, max_mrqs);
-	for (k = 0; k < max_mrqs; ++k) {
+	SG_LOG(3, sfp, "%s: num_rsp_arr=%d, max_rcv=%d", __func__, num_rsp_arr, max_rcv);
+	if (max_rcv == 0 || max_rcv > num_rsp_arr)
+		max_rcv = num_rsp_arr;
+	k = 0;
+	for ( ; k < max_rcv; ++k) {
 		if (!sg_mrq_get_ready_srp(sfp, &srp))
 			break;
 		if (IS_ERR(srp))
 			return k ? k /* some but not all */ : PTR_ERR(srp);
 		if (srp->rq_flags & SGV4_FLAG_REC_ORDER) {
 			idx = srp->s_hdr4.mrq_ind;
-			if (idx >= max_mrqs)
+			if (idx >= num_rsp_arr)
 				idx = 0;	/* overwrite index 0 when trouble */
 		} else {
 			idx = k;	/* completion order */
@@ -3076,12 +3078,12 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs, struct sg
 		res = sg_receive_v4(sfp, srp, NULL, rsp_arr + idx);
 		if (unlikely(res))
 			return res;
-		rsp_arr[k].info |= SG_INFO_MRQ_FINI;
+		rsp_arr[idx].info |= SG_INFO_MRQ_FINI;
 	}
-	if (non_block)
+	if (non_block || k >= max_rcv)
 		return k;
-
-	for ( ; k < max_mrqs; ++k) {
+	SG_LOG(6, sfp, "%s: received=%d, max=%d\n", __func__, k, max_rcv);
+	for ( ; k < max_rcv; ++k) {
 		res = sg_wait_any_mrq(sfp, &srp);
 		if (unlikely(res))
 			return res;	/* signal --> -ERESTARTSYS */
@@ -3089,7 +3091,7 @@ sg_mrq_iorec_complets(struct sg_fd *sfp, bool non_block, int max_mrqs, struct sg
 			return k ? k : PTR_ERR(srp);
 		if (srp->rq_flags & SGV4_FLAG_REC_ORDER) {
 			idx = srp->s_hdr4.mrq_ind;
-			if (idx >= max_mrqs)
+			if (idx >= num_rsp_arr)
 				idx = 0;
 		} else {
 			idx = k;
@@ -3111,6 +3113,7 @@ static int
 sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool non_block)
 {
 	int res = 0;
+	int max_rcv;
 	u32 len, n;
 	struct sg_io_v4 *rsp_v4_arr;
 	void __user *pp;
@@ -3123,14 +3126,16 @@ sg_mrq_ioreceive(struct sg_fd *sfp, struct sg_io_v4 *cop, void __user *p, bool n
 		return -ERANGE;
 	n /= SZ_SG_IO_V4;
 	len = n * SZ_SG_IO_V4;
-	SG_LOG(3, sfp, "%s: %s, num_reqs=%u\n", __func__, (non_block ? "IMMED" : "blocking"), n);
+	max_rcv = cop->din_iovec_count;
+	SG_LOG(3, sfp, "%s: %s, num_reqs=%u, max_rcv=%d\n", __func__,
+	       (non_block ? "IMMED" : "blocking"), n, max_rcv);
 	rsp_v4_arr = kcalloc(n, SZ_SG_IO_V4, GFP_KERNEL);
 	if (unlikely(!rsp_v4_arr))
 		return -ENOMEM;
 
 	sg_v4h_partial_zero(cop);
 	cop->din_resid = n;
-	res = sg_mrq_iorec_complets(sfp, non_block, n, rsp_v4_arr);
+	res = sg_mrq_iorec_complets(sfp, non_block, max_rcv, n, rsp_v4_arr);
 	if (unlikely(res < 0))
 		goto fini;
 	cop->din_resid -= res;
@@ -3164,7 +3169,6 @@ sg_wait_poll_by_id(struct sg_fd *sfp, struct sg_request **srpp, int id,
 	return __wait_event_interruptible(sfp->cmpl_wait, sg_get_ready_srp(sfp, srpp, id, is_tag));
 poll_loop:
 	{
-		bool sig_pending = false;
 		long state = current->state;
 		struct sg_request *srp;
 
@@ -3175,14 +3179,16 @@ sg_wait_poll_by_id(struct sg_fd *sfp, struct sg_request **srpp, int id,
 				*srpp = srp;
 				return 0;
 			}
+			if (SG_IS_DETACHING(sfp->parentdp)) {
+				__set_current_state(TASK_RUNNING);
+				return -ENODEV;
+			}
 			if (signal_pending_state(state, current)) {
-				sig_pending = true;
-				break;
+				__set_current_state(TASK_RUNNING);
+				return -ERESTARTSYS;
 			}
 			cpu_relax();
-		} while (!need_resched());
-		__set_current_state(TASK_RUNNING);
-		return sig_pending ? -ERESTARTSYS : -EAGAIN;
+		} while (true);
 	}
 }
 
-- 
2.25.1

