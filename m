Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 353ACC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B0C613FC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 21:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239537AbhD0WAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:38 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39071 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239473AbhD0WAF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1F77920424C;
        Tue, 27 Apr 2021 23:59:17 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZI9Z1je54nvh; Tue, 27 Apr 2021 23:59:15 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 7EB6F2041BD;
        Tue, 27 Apr 2021 23:59:14 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 65/83] sg: condition met is not an error
Date:   Tue, 27 Apr 2021 17:57:15 -0400
Message-Id: <20210427215733.417746-67-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Most, but not all, non-zero SCSI status values indicate there is
a problem with the current or earlier command. The main exception
is from the PRE-FETCH commands that return CONDITION MET (0x4)
when the specified blocks can/have fitted in the device's cache.
And somewhat strangely return the GOOD (0x0) status if it will/has
not fit. Clean up all SCSI status and associated error
processing.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 64 ++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dc85592112e2..ca6af752b23d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -122,9 +122,6 @@ enum sg_shr_var {
 
 #define SG_MAX_RSV_REQS 8
 
-/* Only take lower 4 bits of driver byte, all host byte and sense byte */
-#define SG_ML_RESULT_MSK 0x0fff00ff	/* mid-level's 32 bit result value */
-
 #define SG_PACK_ID_WILDCARD (-1)
 #define SG_TAG_WILDCARD (-1)
 
@@ -652,6 +649,19 @@ sg_fd_share_ptr(struct sg_fd *sfp)
 	return res_sfp;
 }
 
+/*
+ * Picks up driver or host (transport) errors and actual SCSI status problems.
+ * Specifically SAM_STAT_CONDITION_MET is _not_ an error.
+ */
+static inline bool
+sg_result_is_good(int rq_result)
+{
+	/* Take lower 4 bits of driver byte and all host byte */
+	const int ml_result_msk = 0x0fff0000;
+
+	return !(rq_result & ml_result_msk) && scsi_status_is_good(rq_result);
+}
+
 /*
  * Release resources associated with a prior, successful sg_open(). It can be
  * seen as the (final) close() call on a sg device file descriptor in the user
@@ -1306,9 +1316,7 @@ sg_process_most_mrq(struct sg_fd *fp, struct sg_fd *o_sfp,
 		}
 		++num_cmpl;
 		hp->info |= SG_INFO_MRQ_FINI;
-		if (mhp->stop_if && (hp->driver_status ||
-				     hp->transport_status ||
-				     hp->device_status)) {
+		if (mhp->stop_if && !sg_result_is_good(srp->rq_result)) {
 			SG_LOG(2, fp, "%s: %s=0x%x/0x%x/0x%x] cause exit\n",
 			       __func__, "STOP_IF and status [drv/tran/scsi",
 			       hp->driver_status, hp->transport_status,
@@ -2375,7 +2383,7 @@ sg_copy_sense(struct sg_request *srp, bool v4_active)
 	int scsi_stat;
 
 	/* If need be, copy the sense buffer to the user space */
-	scsi_stat = srp->rq_result & 0xff;
+	scsi_stat = srp->rq_result & 0xfe;
 	if (unlikely((scsi_stat & SAM_STAT_CHECK_CONDITION) ||
 		     (driver_byte(srp->rq_result) & DRIVER_SENSE))) {
 		int sb_len = min_t(int, SCSI_SENSE_BUFFERSIZE, srp->sense_len);
@@ -2411,13 +2419,13 @@ sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 	u32 rq_res = srp->rq_result;
 	enum sg_shr_var sh_var = srp->sh_var;
 
-	if (unlikely(srp->rq_result & 0xff)) {
+	if (unlikely(!scsi_status_is_good(rq_res))) {
 		int sb_len_wr = sg_copy_sense(srp, v4_active);
 
 		if (unlikely(sb_len_wr < 0))
 			return sb_len_wr;
 	}
-	if (rq_res & SG_ML_RESULT_MSK)
+	if (!sg_result_is_good(rq_res))
 		srp->rq_info |= SG_INFO_CHECK;
 	if (unlikely(test_bit(SG_FRQ_ABORTING, srp->frq_bm)))
 		srp->rq_info |= SG_INFO_ABORTED;
@@ -2478,7 +2486,7 @@ sg_complete_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool other_err)
 			int poll_type = POLL_OUT;
 			struct sg_fd *ws_sfp = sg_fd_share_ptr(sfp);
 
-			if (unlikely((srp->rq_result & SG_ML_RESULT_MSK) ||
+			if (unlikely(!sg_result_is_good(srp->rq_result) ||
 				     other_err)) {
 				set_bit(SG_FFD_READ_SIDE_ERR, sfp->ffd_bm);
 				if (sr_st != SG_RQ_BUSY)
@@ -2797,7 +2805,7 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 	     struct sg_request *srp)
 {
 	int res = 0;
-	u32 rq_result = srp->rq_result;
+	u32 rq_res = srp->rq_result;
 	struct sg_header *h2p;
 	struct sg_slice_hdr3 *sh3p;
 	struct sg_header a_v2hdr;
@@ -2809,11 +2817,11 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 	h2p->pack_len = h2p->reply_len; /* old, strange behaviour */
 	h2p->pack_id = sh3p->pack_id;
 	h2p->twelve_byte = (srp->cmd_opcode >= 0xc0 && sh3p->cmd_len == 12);
-	h2p->target_status = status_byte(rq_result);
-	h2p->host_status = host_byte(rq_result);
-	h2p->driver_status = driver_byte(rq_result);
-	if (unlikely((CHECK_CONDITION & status_byte(rq_result)) ||
-		     (DRIVER_SENSE & driver_byte(rq_result)))) {
+	h2p->target_status = status_byte(rq_res);
+	h2p->host_status = host_byte(rq_res);
+	h2p->driver_status = driver_byte(rq_res);
+	if (unlikely(!scsi_status_is_good(rq_res) ||
+		     (driver_byte(rq_res) & DRIVER_SENSE))) {
 		if (likely(srp->sense_bp)) {
 			u8 *sbp = srp->sense_bp;
 
@@ -2823,7 +2831,7 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 			mempool_free(sbp, sg_sense_pool);
 		}
 	}
-	switch (unlikely(host_byte(rq_result))) {
+	switch (unlikely(host_byte(rq_res))) {
 	/*
 	 * This following setting of 'result' is for backward compatibility
 	 * and is best ignored by the user who should use target, host and
@@ -2847,7 +2855,7 @@ sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
 		h2p->result = EIO;
 		break;
 	case DID_ERROR:
-		h2p->result = (status_byte(rq_result) == GOOD) ? 0 : EIO;
+		h2p->result = sg_result_is_good(rq_res) ? 0 : EIO;
 		break;
 	default:
 		h2p->result = EIO;
@@ -2998,7 +3006,7 @@ static int
 sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, void __user *p)
 {
 	int err, err2;
-	int rq_result = srp->rq_result;
+	int rq_res = srp->rq_result;
 	struct sg_io_hdr hdr3;
 	struct sg_io_hdr *hp = &hdr3;
 
@@ -3012,11 +3020,11 @@ sg_receive_v3(struct sg_fd *sfp, struct sg_request *srp, void __user *p)
 	hp->resid = srp->in_resid;
 	hp->pack_id = srp->pack_id;
 	hp->duration = srp->duration;
-	hp->status = rq_result & 0xff;
-	hp->masked_status = status_byte(rq_result);
-	hp->msg_status = msg_byte(rq_result);
-	hp->host_status = host_byte(rq_result);
-	hp->driver_status = driver_byte(rq_result);
+	hp->status = rq_res & 0xff;
+	hp->masked_status = status_byte(rq_res);
+	hp->msg_status = msg_byte(rq_res);
+	hp->host_status = host_byte(rq_res);
+	hp->driver_status = driver_byte(rq_res);
 	err2 = put_sg_io_hdr(hp, p);
 	err = err ? err : err2;
 	sg_complete_v3v4(sfp, srp, err < 0);
@@ -3447,7 +3455,7 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 		rip->duration = 0;
 	rip->orphan = test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
 	rip->sg_io_owned = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
-	rip->problem = !!(srp->rq_result & SG_ML_RESULT_MSK);
+	rip->problem = !sg_result_is_good(srp->rq_result);
 	rip->pack_id = test_bit(SG_FFD_PREFER_TAG, sfp->ffd_bm) ?
 				srp->tag : srp->pack_id;
 	rip->usr_ptr = test_bit(SG_FRQ_IS_V4I, srp->frq_bm) ?
@@ -5315,7 +5323,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 			srp->in_resid = a_resid;
 		}
 	}
-	if (unlikely(test_bit(SG_FRQ_ABORTING, srp->frq_bm)) && rq_result == 0)
+	if (unlikely(test_bit(SG_FRQ_ABORTING, srp->frq_bm)) && sg_result_is_good(rq_result))
 		srp->rq_result |= (DRIVER_HARD << 24);
 
 	SG_LOG(6, sfp, "%s: pack/tag_id=%d/%d, cmd=0x%x, res=0x%x\n", __func__,
@@ -5323,7 +5331,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	if (srp->start_ns > 0)	/* zero only when SG_FFD_NO_DURATION is set */
 		srp->duration = sg_calc_rq_dur(srp, test_bit(SG_FFD_TIME_IN_NS,
 							     sfp->ffd_bm));
-	if (unlikely((rq_result & SG_ML_RESULT_MSK) && slen > 0 &&
+	if (unlikely(!sg_result_is_good(rq_result) && slen > 0 &&
 		     test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm))) {
 		if ((rq_result & 0xff) == SAM_STAT_CHECK_CONDITION ||
 		    (rq_result & 0xff) == SAM_STAT_COMMAND_TERMINATED)
@@ -6522,7 +6530,7 @@ sg_setup_req(struct sg_comm_wr_t *cwrp, enum sg_shr_var sh_var, int dxfr_len)
 		rs_st = atomic_read(&rs_rsv_srp->rq_st);
 		switch (rs_st) {
 		case SG_RQ_AWAIT_RCV:
-			if (unlikely(rs_rsv_srp->rq_result & SG_ML_RESULT_MSK)) {
+			if (!sg_result_is_good(rs_rsv_srp->rq_result)) {
 				/* read-side done but error occurred */
 				r_srp = ERR_PTR(-ENOSTR);
 				break;
-- 
2.25.1

