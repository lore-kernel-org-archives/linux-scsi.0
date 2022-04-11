Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7A5C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 02:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244394AbiDKCdD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 22:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244434AbiDKCcZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 22:32:25 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6614338BEC
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 19:29:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0A0872041C0;
        Mon, 11 Apr 2022 04:29:32 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id W2YwH5LbBHPi; Mon, 11 Apr 2022 04:29:30 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 4392F204179;
        Mon, 11 Apr 2022 04:29:29 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v24 42/46] sg: remove unit attention check for device changed
Date:   Sun, 10 Apr 2022 22:28:32 -0400
Message-Id: <20220411022836.11871-43-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411022836.11871-1-dgilbert@interlog.com>
References: <20220411022836.11871-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI mid-layer now checks for SCSI UNIT ATTENTIONs and takes
the appropriate actions. This means that the sg driver no longer
needs to do this check.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 49 ++++++++++++-----------------------------------
 1 file changed, 12 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 71d86537601d..c180cd21ab65 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2371,39 +2371,6 @@ sg_rq_end_io_usercontext(struct work_struct *work)
 	kref_put(&sfp->f_ref, sg_remove_sfp);
 }
 
-static void
-sg_check_sense(struct sg_device *sdp, struct sg_request *srp, int sense_len)
-{
-	int driver_stat;
-	u32 rq_res = srp->rq_result;
-	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(READ_ONCE(srp->rqq));
-	u8 *sbp = scmd ? scmd->sense_buffer : NULL;
-
-	if (!sbp)
-		return;
-	driver_stat = driver_byte(rq_res);
-	if (driver_stat & DRIVER_SENSE) {
-		struct scsi_sense_hdr ssh;
-
-		if (scsi_normalize_sense(sbp, sense_len, &ssh)) {
-			if (!scsi_sense_is_deferred(&ssh)) {
-				if (ssh.sense_key == UNIT_ATTENTION) {
-					if (sdp->device->removable)
-						sdp->device->changed = 1;
-				}
-			}
-		}
-	}
-	if (test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm) > 0) {
-		int scsi_stat = rq_res & 0xff;
-
-		if (scsi_stat == SAM_STAT_CHECK_CONDITION ||
-		    scsi_stat == SAM_STAT_COMMAND_TERMINATED)
-			__scsi_print_sense(sdp->device, __func__, sbp,
-					   sense_len);
-	}
-}
-
 /*
  * This "bottom half" (soft interrupt) handler is called by the mid-level
  * when a request has completed or failed. This callback is registered in a
@@ -2415,6 +2382,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 {
 	enum sg_rq_state rqq_state = SG_RS_AWAIT_RCV;
 	int a_resid, slen;
+	u32 rq_result;
 	unsigned long iflags;
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rqq);
 	struct sg_request *srp = rqq->end_io_data;
@@ -2424,7 +2392,8 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	sfp = srp->parentfp;
 	sdp = sfp->parentdp;
 
-	srp->rq_result = scmd->result;
+	rq_result = scmd->result;
+	srp->rq_result = rq_result;
 	slen = min_t(int, scmd->sense_len, SCSI_SENSE_BUFFERSIZE);
 	a_resid = scmd->resid_len;
 
@@ -2440,10 +2409,16 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	}
 
 	SG_LOG(6, sfp, "%s: pack_id=%d, res=0x%x\n", __func__, srp->pack_id,
-	       srp->rq_result);
+	       rq_result);
 	srp->duration = sg_calc_rq_dur(srp);
-	if (unlikely((srp->rq_result & SG_ML_RESULT_MSK) && slen > 0))
-		sg_check_sense(sdp, srp, slen);
+	if (unlikely((rq_result & SG_ML_RESULT_MSK) && slen > 0 &&
+		     test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm))) {
+		u32 scsi_stat = rq_result & 0xff;
+
+		if (scsi_stat == SAM_STAT_CHECK_CONDITION ||
+		    scsi_stat == SAM_STAT_COMMAND_TERMINATED)
+			__scsi_print_sense(sdp->device, __func__, scmd->sense_buffer, slen);
+	}
 	if (slen > 0) {
 		if (scmd->sense_buffer && !srp->sense_bp) {
 			srp->sense_bp = mempool_alloc(sg_sense_pool, GFP_ATOMIC);
-- 
2.25.1

