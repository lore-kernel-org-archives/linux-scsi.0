Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024DCE743C3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbjJBPtt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbjJBPtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:49:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C46E3
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:49:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id F32BF2187B;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J0BOS1VGUNZ8Q/4/fxB8uhHSDzTbVnTTMhqCVkw2/ss=;
        b=CJqeD9lxNJhj2ZeC4HaZZFVqW50b8samRnZcuCXluEjTeCDB5ZVPf4WPmEuY30qTXZ8wMJ
        abr81LrVQ54DhbN30kBohOWTZYeCrplqKB45OY4WLoAoO8zCkVGSRg61qmxhrYC8ys1m6X
        PBUc0bFXdFQjD8JPI+4rbZjQhPGtdYE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261771;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J0BOS1VGUNZ8Q/4/fxB8uhHSDzTbVnTTMhqCVkw2/ss=;
        b=Yq0+KDFpg3t04tEUQPzuqIeuEaXvC2Kng7saskfL+7jkyDrXXe7O8YUnrXBsuoTwsaIcmQ
        /OKtT3pFJxFSS3BQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D4E9D2C161;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id ED02651E757B; Mon,  2 Oct 2023 17:49:30 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/15] csiostor: use separate TMF command
Date:   Mon,  2 Oct 2023 17:49:27 +0200
Message-Id: <20231002154927.68643-16-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154927.68643-1-hare@suse.de>
References: <20231002154927.68643-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set one command aside as a TMF command, and use this command to
send the TMF. This avoids having to rely on the passed-in scsi
command when resetting the device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/csiostor/csio_scsi.c | 72 ++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 05e1a63e00c3..08597de49b7f 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1724,7 +1724,10 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 	}
 
 	cmnd->result = (((host_status) << 16) | scsi_status);
-	scsi_done(cmnd);
+	if (csio_priv(cmnd)->fc_tm_flags == FCP_TMF_LUN_RESET)
+		blk_mq_set_request_complete(scsi_cmd_to_rq(cmnd));
+	else
+		scsi_done(cmnd);
 
 	/* Wake up waiting threads */
 	csio_scsi_cmnd(req) = NULL;
@@ -1752,7 +1755,10 @@ csio_scsi_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 		}
 
 		cmnd->result = (((host_status) << 16) | scsi_status);
-		scsi_done(cmnd);
+		if (csio_priv(cmnd)->fc_tm_flags == FCP_TMF_LUN_RESET)
+			blk_mq_set_request_complete(scsi_cmd_to_rq(cmnd));
+		else
+			scsi_done(cmnd);
 		csio_scsi_cmnd(req) = NULL;
 		CSIO_INC_STATS(csio_hw_to_scsim(hw), n_tot_success);
 	} else {
@@ -2056,17 +2062,21 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 
 	/* Wake up the TM handler thread */
 	csio_scsi_cmnd(req) = NULL;
+	cmnd->host_scribble = NULL;
 }
 
 static int
 csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 {
-	struct csio_lnode *ln = shost_priv(cmnd->device->host);
+	struct scsi_device *sdev = cmnd->device;
+	struct csio_lnode *ln = shost_priv(sdev->host);
 	struct csio_hw *hw = csio_lnode_to_hw(ln);
 	struct csio_scsim *scsim = csio_hw_to_scsim(hw);
-	struct csio_rnode *rn = (struct csio_rnode *)(cmnd->device->hostdata);
+	struct csio_rnode *rn = (struct csio_rnode *)(sdev->hostdata);
 	struct csio_ioreq *ioreq = NULL;
 	struct csio_scsi_qset *sqset;
+	struct scsi_cmnd *tmf_cmnd;
+	struct request *req;
 	unsigned long flags;
 	int retval;
 	int count, ret;
@@ -2074,17 +2084,17 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	struct csio_scsi_level_data sld;
 
 	if (!rn)
-		goto fail;
+		return FAILED;
 
 	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
-		      cmnd->device->lun, rn->flowid, rn->scsi_id);
+		      sdev->lun, rn->flowid, rn->scsi_id);
 
 	if (!csio_is_lnode_ready(ln)) {
 		csio_err(hw,
 			 "LUN reset cannot be issued on non-ready"
 			 " local node vnpi:0x%x (LUN:%llu)\n",
-			 ln->vnp_flowid, cmnd->device->lun);
-		goto fail;
+			 ln->vnp_flowid, sdev->lun);
+		return FAILED;
 	}
 
 	/* Lnode is ready, now wait on rport node readiness */
@@ -2103,10 +2113,19 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 		csio_err(hw,
 			 "LUN reset cannot be issued on non-ready"
 			 " remote node ssni:0x%x (LUN:%llu)\n",
-			 rn->flowid, cmnd->device->lun);
-		goto fail;
+			 rn->flowid, sdev->lun);
+		return FAILED;
 	}
 
+	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
+				 BLK_MQ_REQ_NOWAIT);
+	if (!req) {
+		csio_err(hw,
+			 "LUN reset TMF already busy (LUN:%llu)\n",
+			 sdev->lun);
+		return FAILED;
+	}
+	tmf_cmnd = blk_mq_rq_to_pdu(req);
 	/* Get a free ioreq structure - SM is already set to uninit */
 	ioreq = csio_get_scsi_ioreq_lock(hw, scsim);
 
@@ -2123,11 +2142,11 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	ioreq->iq_idx		= sqset->iq_idx;
 	ioreq->eq_idx		= sqset->eq_idx;
 
-	csio_scsi_cmnd(ioreq)	= cmnd;
-	cmnd->host_scribble	= (unsigned char *)ioreq;
-	csio_priv(cmnd)->wr_status = 0;
+	csio_scsi_cmnd(ioreq)	= tmf_cmnd;
+	tmf_cmnd->host_scribble	= (unsigned char *)ioreq;
+	csio_priv(tmf_cmnd)->wr_status = 0;
 
-	csio_priv(cmnd)->fc_tm_flags = FCP_TMF_LUN_RESET;
+	csio_priv(tmf_cmnd)->fc_tm_flags = FCP_TMF_LUN_RESET;
 	ioreq->tmo		= CSIO_SCSI_LUNRST_TMO_MS / 1000;
 
 	/*
@@ -2144,30 +2163,33 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	sld.level = CSIO_LEV_LUN;
 	sld.lnode = ioreq->lnode;
 	sld.rnode = ioreq->rnode;
-	sld.oslun = cmnd->device->lun;
+	sld.oslun = sdev->lun;
 
+	WRITE_ONCE(req->state, MQ_RQ_IN_FLIGHT);
 	spin_lock_irqsave(&hw->lock, flags);
 	/* Kick off TM SM on the ioreq */
 	retval = csio_scsi_start_tm(ioreq);
 	spin_unlock_irqrestore(&hw->lock, flags);
 
 	if (retval != 0) {
+		blk_mq_set_request_complete(req);
 		csio_err(hw, "Failed to issue LUN reset, req:%p, status:%d\n",
 			    ioreq, retval);
+		tmf_cmnd->host_scribble = NULL;
 		goto fail_ret_ioreq;
 	}
 
 	csio_dbg(hw, "Waiting max %d secs for LUN reset completion\n",
 		    count * (CSIO_SCSI_TM_POLL_MS / 1000));
 	/* Wait for completion */
-	while ((((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd)
+	while ((((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == tmf_cmnd)
 								&& count--)
 		msleep(CSIO_SCSI_TM_POLL_MS);
 
 	/* LUN reset timed-out */
-	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd) {
+	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == tmf_cmnd) {
 		csio_err(hw, "LUN reset (%d:%llu) timed out\n",
-			 cmnd->device->id, cmnd->device->lun);
+			 sdev->id, sdev->lun);
 
 		spin_lock_irq(&hw->lock);
 		csio_scsi_drvcleanup(ioreq);
@@ -2178,10 +2200,10 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	}
 
 	/* LUN reset returned, check cached status */
-	if (csio_priv(cmnd)->wr_status != FW_SUCCESS) {
+	if (csio_priv(tmf_cmnd)->wr_status != FW_SUCCESS) {
 		csio_err(hw, "LUN reset failed (%d:%llu), status: %d\n",
-			 cmnd->device->id, cmnd->device->lun,
-			 csio_priv(cmnd)->wr_status);
+			 sdev->id, sdev->lun,
+			 csio_priv(tmf_cmnd)->wr_status);
 		goto fail;
 	}
 
@@ -2201,7 +2223,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	if (retval != 0) {
 		csio_err(hw,
 			 "Attempt to abort I/Os during LUN reset of %llu"
-			 " returned %d\n", cmnd->device->lun, retval);
+			 " returned %d\n", sdev->lun, retval);
 		/* Return I/Os back to active_q */
 		spin_lock_irq(&hw->lock);
 		list_splice_tail_init(&local_q, &scsim->active_q);
@@ -2212,14 +2234,16 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	CSIO_INC_STATS(rn, n_lun_rst);
 
 	csio_info(hw, "LUN reset occurred (%d:%llu)\n",
-		  cmnd->device->id, cmnd->device->lun);
-
+		  sdev->id, sdev->lun);
+	blk_mq_free_request(req);
 	return SUCCESS;
 
 fail_ret_ioreq:
 	csio_put_scsi_ioreq_lock(hw, scsim, ioreq);
 fail:
 	CSIO_INC_STATS(rn, n_lun_rst_fail);
+	if (req)
+		blk_mq_free_request(req);
 	return FAILED;
 }
 
-- 
2.35.3

