Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A37C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 15:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F3B864F21
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 15:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhCQPvZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 11:51:25 -0400
Received: from smtp.infotech.no ([82.134.31.41]:37229 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232714AbhCQPuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 11:50:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B111E2041BB;
        Wed, 17 Mar 2021 16:28:12 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nUyub1UfDVZi; Wed, 17 Mar 2021 16:28:10 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 3694320418C;
        Wed, 17 Mar 2021 16:28:09 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        dan.carpenter@oracle.com, colin.king@canonical.com
Subject: [PATCH v2 5/6] sg: tighten handling of struct request objects
Date:   Wed, 17 Mar 2021 11:27:57 -0400
Message-Id: <20210317152758.51689-6-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317152758.51689-1-dgilbert@interlog.com>
References: <20210317152758.51689-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The struct sg_request object is related to a struct request object
in the block layer. So a struct sg_request object holds a pointer
to the other object. And since an active struct request object is
shorter lived, then that pointer is set to NULL when it becomes
inactive. Tighten the handling of that pointer with READ_ONCE()
and WRITE_ONCE(). Also put a single lock around various state
variables in the completion callback (sg_rq_end_io() ) so observers
see either pre-change or post-change and not something in between.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c49f87c97dd4..f59ddf809f21 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -218,7 +218,7 @@ struct sg_request {	/* active SCSI command or inactive request */
 	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
 	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */
 	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */
-	struct request *rq;	/* released in sg_rq_end_io(), bio kept */
+	struct request *rqq;	/* released in sg_rq_end_io(), bio kept */
 	struct bio *bio;	/* kept until this req -->SG_RS_INACTIVE */
 	struct execute_work ew_orph;	/* harvest orphan request */
 };
@@ -1014,6 +1014,7 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 {
 	bool at_head, is_v4h, sync;
 	struct sg_device *sdp = sfp->parentdp;
+	struct request *rqq;
 
 	is_v4h = test_bit(SG_FRQ_IS_V4I, srp->frq_bm);
 	sync = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
@@ -1037,9 +1038,10 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 		atomic_inc(&sfp->submitted);
 		set_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm);
 	}
+	rqq = READ_ONCE(srp->rqq);
 	if (srp->rq_flags & SGV4_FLAG_HIPRI)
-		srp->rq->cmd_flags |= REQ_HIPRI;
-	blk_execute_rq_nowait(sdp->disk, srp->rq, (int)at_head, sg_rq_end_io);
+		rqq->cmd_flags |= REQ_HIPRI;
+	blk_execute_rq_nowait(sdp->disk, rqq, (int)at_head, sg_rq_end_io);
 	set_bit(SG_FRQ_ISSUED, srp->frq_bm);
 }
 
@@ -1116,7 +1118,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		goto err_out;
  	}
 
-	if (unlikely(test_bit(SG_FRQ_BLK_PUT_REQ, srp->frq_bm) || !srp->rq)) {
+	if (unlikely(test_bit(SG_FRQ_BLK_PUT_REQ, srp->frq_bm) || !srp->rqq)) {
 		res = -EIDRM;	/* this failure unexpected but observed */
 		goto err_out;
 	}
@@ -1125,7 +1127,7 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		res = -ENODEV;
 		goto err_out;
 	}
-	srp->rq->timeout = cwrp->timeout;
+	srp->rqq->timeout = cwrp->timeout;
 	sg_execute_cmd(fp, srp);
 	return srp;
 err_out:
@@ -2299,7 +2301,7 @@ sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count)
 		return -EINVAL;
 	xa_lock_irqsave(xafp, iflags);
 	xa_for_each(xafp, idx, srp) {
-		rqq = srp->rq;
+		rqq = READ_ONCE(srp->rqq);
 		if (rqq && (srp->rq_flags & SGV4_FLAG_HIPRI) &&
 		    atomic_read(&srp->rq_st) == SG_RS_INFLIGHT &&
 		    test_bit(SG_FRQ_ISSUED, srp->frq_bm)) {
@@ -2320,8 +2322,8 @@ sg_srp_blk_poll(struct sg_request *srp, int loop_count)
 {
 	if (!test_bit(SG_FRQ_ISSUED, srp->frq_bm))
 		return 0;	/* blk_execute_rq_nowait() may not have issued request */
-	return sg_srp_q_blk_poll(srp, srp->rq, srp->parentfp->parentdp->device->request_queue,
-				 loop_count);
+	return sg_srp_q_blk_poll(srp, READ_ONCE(srp->rqq),
+				 srp->parentfp->parentdp->device->request_queue, loop_count);
 }
 
 /*
@@ -2553,6 +2555,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	enum sg_rq_state rqq_state = SG_RS_AWAIT_RCV;
 	int a_resid, slen;
 	u32 rq_result;
+	unsigned long iflags;
 	struct sg_request *srp = rq->end_io_data;
 	struct scsi_request *scsi_rp = scsi_req(rq);
 	struct sg_device *sdp;
@@ -2624,7 +2627,10 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 			set_bit(SG_FRQ_DEACT_ORPHAN, srp->frq_bm);
 		}
 	}
-	set_bit(SG_FRQ_ISSUED, srp->frq_bm);
+	xa_lock_irqsave(&sfp->srp_arr, iflags);
+	__set_bit(SG_FRQ_ISSUED, srp->frq_bm);
+	sg_rq_chg_state_force_ulck(srp, rqq_state);
+	WRITE_ONCE(srp->rqq, NULL);
 	if (test_bit(SG_FRQ_COUNT_ACTIVE, srp->frq_bm)) {
 		int num = atomic_inc_return(&sfp->waiting);
 
@@ -2638,12 +2644,11 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 				WRITE_ONCE(sfp->low_await_idx, srp->rq_idx);
 		}
 	}
-	sg_rq_chg_state_force(srp, rqq_state);
+	xa_unlock_irqrestore(&sfp->srp_arr, iflags);
 	/*
 	 * Free the mid-level resources apart from the bio (if any). The bio's
 	 * blk_rq_unmap_user() can be called later from user context.
 	 */
-	srp->rq = NULL;
 	scsi_req_free_cmd(scsi_rp);
 	blk_put_request(rq);
 
@@ -3092,7 +3097,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	}
 	/* current sg_request protected by SG_RS_BUSY state */
 	scsi_rp = scsi_req(rq);
-	srp->rq = rq;
+	WRITE_ONCE(srp->rqq, rq);
 	if (rq_flags & SGV4_FLAG_HIPRI)
 		set_bit(SG_FFD_HIPRI_SEEN, sfp->ffd_bm);
 
@@ -3178,7 +3183,7 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	if (unlikely(res)) {		/* failure, free up resources */
 		if (likely(!test_and_set_bit(SG_FRQ_BLK_PUT_REQ,
 					     srp->frq_bm))) {
-			srp->rq = NULL;
+			WRITE_ONCE(srp->rqq, NULL);
 			blk_put_request(rq);
 		}
 	} else {
@@ -3214,9 +3219,9 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 
 	/* Expect blk_put_request(rq) already called in sg_rq_end_io() */
 	if (unlikely(!test_and_set_bit(SG_FRQ_BLK_PUT_REQ, srp->frq_bm))) {
-		struct request *rq = srp->rq;
+		struct request *rq = READ_ONCE(srp->rqq);
 
-		srp->rq = NULL;
+		WRITE_ONCE(srp->rqq, NULL);
 		if (rq) {       /* blk_get_request() may have failed */
 			if (scsi_req(rq))
 				scsi_req_free_cmd(scsi_req(rq));
-- 
2.25.1

