Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401D7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 15:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8C8D64F6C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 15:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbhCQPvb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 11:51:31 -0400
Received: from smtp.infotech.no ([82.134.31.41]:37228 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhCQPuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 11:50:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id C1AE020418C;
        Wed, 17 Mar 2021 16:28:13 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Sft+3LYc+dWk; Wed, 17 Mar 2021 16:28:11 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id B5B11204278;
        Wed, 17 Mar 2021 16:28:10 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        dan.carpenter@oracle.com, colin.king@canonical.com
Subject: [PATCH v2 6/6] sg: remove debugging remnants
Date:   Wed, 17 Mar 2021 11:27:58 -0400
Message-Id: <20210317152758.51689-7-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317152758.51689-1-dgilbert@interlog.com>
References: <20210317152758.51689-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove check whether the sg_request object's xarray mark indicates
that it is 'free' (it shouldn't be in sg_common_write() ). This was
added as part of scattergun debugging to find a problem that was
fixed elsewhere. The associated SG_LOG message has never been seen
in testing.

Likewise the SG_FRQ_BLK_PUT_REQ bit in the sg_request::frq_bm
bitmask was part of debugging.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 42 ++++++++++++------------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f59ddf809f21..f36a6a262774 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -115,10 +115,9 @@ enum sg_rq_state {	/* N.B. sg_rq_state_arr assumes SG_RS_AWAIT_RCV==2 */
 #define SG_FRQ_NO_US_XFER	3	/* no user space transfer of data */
 #define SG_FRQ_DEACT_ORPHAN	6	/* not keeping orphan so de-activate */
 #define SG_FRQ_RECEIVING	7	/* guard against multiple receivers */
-#define SG_FRQ_BLK_PUT_REQ	8	/* set when blk_put_request() called */
-#define SG_FRQ_FOR_MMAP		9	/* request needs PAGE_SIZE elements */
-#define SG_FRQ_COUNT_ACTIVE	10	/* sfp->submitted + waiting active */
-#define SG_FRQ_ISSUED		11	/* blk_execute_rq_nowait() finished */
+#define SG_FRQ_FOR_MMAP		8	/* request needs PAGE_SIZE elements */
+#define SG_FRQ_COUNT_ACTIVE	9	/* sfp->submitted + waiting active */
+#define SG_FRQ_ISSUED		10	/* blk_execute_rq_nowait() finished */
 
 /* Bit positions (flags) for sg_fd::ffd_bm bitmask follow */
 #define SG_FFD_FORCE_PACKID	0	/* receive only given pack_id/tag */
@@ -1118,15 +1117,6 @@ sg_common_write(struct sg_comm_wr_t *cwrp)
 		goto err_out;
  	}
 
-	if (unlikely(test_bit(SG_FRQ_BLK_PUT_REQ, srp->frq_bm) || !srp->rqq)) {
-		res = -EIDRM;	/* this failure unexpected but observed */
-		goto err_out;
-	}
-	if (xa_get_mark(&fp->srp_arr, srp->rq_idx, SG_XA_RQ_FREE)) {
-		SG_LOG(1, fp, "%s: ahhh, request erased!!!\n", __func__);
-		res = -ENODEV;
-		goto err_out;
-	}
 	srp->rqq->timeout = cwrp->timeout;
 	sg_execute_cmd(fp, srp);
 	return srp;
@@ -2562,10 +2552,6 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	struct sg_fd *sfp;
 
 	/* Expect 0 --> 1 transition, otherwise processed elsewhere */
-	if (unlikely(test_and_set_bit(SG_FRQ_BLK_PUT_REQ, srp->frq_bm))) {
-		pr_info("%s: srp=%pK already completed\n", __func__, srp);
-		return;
-	}
 	sfp = srp->parentfp;
 	sdp = sfp->parentdp;
 
@@ -3181,11 +3167,8 @@ sg_start_req(struct sg_request *srp, struct sg_comm_wr_t *cwrp, int dxfer_dir)
 	}
 fini:
 	if (unlikely(res)) {		/* failure, free up resources */
-		if (likely(!test_and_set_bit(SG_FRQ_BLK_PUT_REQ,
-					     srp->frq_bm))) {
-			WRITE_ONCE(srp->rqq, NULL);
-			blk_put_request(rq);
-		}
+		WRITE_ONCE(srp->rqq, NULL);
+		blk_put_request(rq);
 	} else {
 		srp->bio = rq->bio;
 	}
@@ -3206,6 +3189,7 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 {
 	int ret;
 	struct sg_fd *sfp = srp->parentfp;
+	struct request *rqq = READ_ONCE(srp->rqq);
 
 	SG_LOG(4, sfp, "%s: srp=0x%pK%s\n", __func__, srp,
 	       (srp->parentfp->rsv_srp == srp) ? " rsv" : "");
@@ -3217,15 +3201,13 @@ sg_finish_scsi_blk_rq(struct sg_request *srp)
 		atomic_dec(&sfp->waiting);
 	}
 
-	/* Expect blk_put_request(rq) already called in sg_rq_end_io() */
-	if (unlikely(!test_and_set_bit(SG_FRQ_BLK_PUT_REQ, srp->frq_bm))) {
-		struct request *rq = READ_ONCE(srp->rqq);
-
+	/* Expect blk_put_request(rqq) already called in sg_rq_end_io() */
+	if (unlikely(rqq)) {
 		WRITE_ONCE(srp->rqq, NULL);
-		if (rq) {       /* blk_get_request() may have failed */
-			if (scsi_req(rq))
-				scsi_req_free_cmd(scsi_req(rq));
-			blk_put_request(rq);
+		if (rqq) {       /* blk_get_request() may have failed */
+			if (scsi_req(rqq))
+				scsi_req_free_cmd(scsi_req(rqq));
+			blk_put_request(rqq);
 		}
 	}
 	if (srp->bio) {
-- 
2.25.1

