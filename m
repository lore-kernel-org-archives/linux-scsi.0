Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55591C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 22:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387821AbiEBWFJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 18:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347523AbiEBWDo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 18:03:44 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528AE6427
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 15:00:04 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C7FA221872;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UNLD8Dcg2QZ4NNoC2EZZguFhtqAeT2JdbTnVL+TobZk=;
        b=iBit0ICYDSAAawjE+CCwlaOHjSIeNNmfsllZSaTjGC28/XaLrjjcnlri20irdP6GyPNPEk
        eM1KK31+hVPk1BUFJ86dP94oqoFZT/OWsg59ZunIw57OmjYAsLgUEwwu1S54f2NVyhOroS
        hd4pB/id2e+s1GeC1AHpouTSUfKqKrw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528800;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UNLD8Dcg2QZ4NNoC2EZZguFhtqAeT2JdbTnVL+TobZk=;
        b=c+m17kFig+HbWSLbITOYGoJx41Wa+pCumCAega+3s3bBaz3hBYhRkCyExOzVmPWjT59g8D
        815MhybUxNEpY+BA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id C2D5F2C15B;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id BFEC05194156; Tue,  3 May 2022 00:00:00 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 06/11] bfa: Do not use scsi command to signal TMF status
Date:   Mon,  2 May 2022 23:59:46 +0200
Message-Id: <20220502215953.5463-12-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215953.5463-1-hare@suse.de>
References: <20220502215953.5463-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The bfa driver hijacks the scsi command to signal the TMF status,
which will no longer work if the TMF handler will be converted.
So rework TMF handling to not use a scsi command but rather add
new TMF fields to the per-device structure.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/bfa/bfad_im.c | 112 ++++++++++++++++++++-----------------
 drivers/scsi/bfa/bfad_im.h |   2 +
 2 files changed, 63 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 8419a1a89485..a446aa2d6b9a 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -147,13 +147,13 @@ void
 bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
 		   enum bfi_tskim_status tsk_status)
 {
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dtsk;
+	struct bfad_itnim_data_s *itnim_data =
+		(struct bfad_itnim_data_s *)dtsk;
 	wait_queue_head_t *wq;
 
-	bfad_priv(cmnd)->status |= tsk_status << 1;
-	set_bit(IO_DONE_BIT, &bfad_priv(cmnd)->status);
-	wq = bfad_priv(cmnd)->wq;
-	bfad_priv(cmnd)->wq = NULL;
+	itnim_data->tmf_status |= tsk_status << 1;
+	set_bit(IO_DONE_BIT, &itnim_data->tmf_status);
+	wq = itnim_data->tmf_wq;
 
 	if (wq)
 		wake_up(wq);
@@ -238,15 +238,16 @@ bfad_im_abort_handler(struct scsi_cmnd *cmnd)
 }
 
 static bfa_status_t
-bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
-		     struct bfad_itnim_s *itnim)
+bfad_im_target_reset_send(struct bfad_s *bfad,
+			  struct bfad_itnim_data_s *itnim_data)
 {
+	struct bfad_itnim_s *itnim = itnim_data->itnim;
 	struct bfa_tskim_s *tskim;
 	struct bfa_itnim_s *bfa_itnim;
 	bfa_status_t    rc = BFA_STATUS_OK;
 	struct scsi_lun scsilun;
 
-	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
+	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) itnim_data);
 	if (!tskim) {
 		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 			"target reset, fail to allocate tskim\n");
@@ -254,12 +255,6 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 		goto out;
 	}
 
-	/*
-	 * Set host_scribble to NULL to avoid aborting a task command if
-	 * happens.
-	 */
-	cmnd->host_scribble = NULL;
-	bfad_priv(cmnd)->status = 0;
 	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	/*
 	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
@@ -290,10 +285,11 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 static int
 bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 {
-	struct Scsi_Host *shost = cmnd->device->host;
+	struct scsi_device *sdev = cmnd->device;
+	struct Scsi_Host *shost = sdev->host;
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_itnim_data_s *itnim_data = cmnd->device->hostdata;
+	struct bfad_itnim_data_s *itnim_data = sdev->hostdata;
 	struct bfad_s         *bfad = im_port->bfad;
 	struct bfa_tskim_s *tskim;
 	struct bfad_itnim_s   *itnim;
@@ -305,14 +301,20 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 	struct scsi_lun scsilun;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	if (itnim_data->tmf_wq) {
+		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
+			"LUN reset, TMF already active");
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		rc = FAILED;
+		goto out;
+	}
 	itnim = itnim_data->itnim;
 	if (!itnim) {
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		rc = FAILED;
 		goto out;
 	}
-
-	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
+	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) itnim_data);
 	if (!tskim) {
 		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 				"LUN reset, fail to allocate tskim");
@@ -321,13 +323,8 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 		goto out;
 	}
 
-	/*
-	 * Set host_scribble to NULL to avoid aborting a task command
-	 * if happens.
-	 */
-	cmnd->host_scribble = NULL;
-	bfad_priv(cmnd)->wq = &wq;
-	bfad_priv(cmnd)->status = 0;
+	itnim_data->tmf_wq = &wq;
+	itnim_data->tmf_status = 0;
 	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	/*
 	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
@@ -342,14 +339,15 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 		rc = FAILED;
 		goto out;
 	}
-	int_to_scsilun(cmnd->device->lun, &scsilun);
+	int_to_scsilun(sdev->lun, &scsilun);
 	bfa_tskim_start(tskim, bfa_itnim, scsilun,
 			    FCP_TM_LUN_RESET, BFAD_LUN_RESET_TMO);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
-	wait_event(wq, test_bit(IO_DONE_BIT, &bfad_priv(cmnd)->status));
+	wait_event(wq, test_bit(IO_DONE_BIT, &itnim_data->tmf_status));
 
-	task_status = bfad_priv(cmnd)->status >> 1;
+	itnim_data->tmf_wq = NULL;
+	task_status = itnim_data->tmf_status >> 1;
 	if (task_status != BFI_TSKIM_STS_OK) {
 		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 			"LUN reset failure, status: %d\n", task_status);
@@ -368,35 +366,47 @@ bfad_im_reset_target_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct scsi_target *starget = scsi_target(cmnd->device);
+	struct fc_rport *rport = starget_to_rport(starget);
 	struct bfad_im_port_s *im_port =
 				(struct bfad_im_port_s *) shost->hostdata[0];
-	struct bfad_s         *bfad = im_port->bfad;
-	struct bfad_itnim_s   *itnim;
-	unsigned long   flags;
-	u32        rc, rtn = FAILED;
+	struct bfad_s *bfad = im_port->bfad;
+	struct bfad_itnim_data_s *itnim_data;
+	struct bfad_itnim_s *itnim;
+	unsigned long flags;
+	u32 rc, rtn = FAILED;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	enum bfi_tskim_status task_status;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	itnim = bfad_get_itnim(im_port, starget->id);
-	if (itnim) {
-		bfad_priv(cmnd)->wq = &wq;
-		rc = bfad_im_target_reset_send(bfad, cmnd, itnim);
-		if (rc == BFA_STATUS_OK) {
-			/* wait target reset to complete */
-			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-			wait_event(wq, test_bit(IO_DONE_BIT,
-						&bfad_priv(cmnd)->status));
-			spin_lock_irqsave(&bfad->bfad_lock, flags);
-
-			task_status = bfad_priv(cmnd)->status >> 1;
-			if (task_status != BFI_TSKIM_STS_OK)
-				BFA_LOG(KERN_ERR, bfad, bfa_log_level,
-					"target reset failure,"
-					" status: %d\n", task_status);
-			else
-				rtn = SUCCESS;
-		}
+	if (!rport->dd_data) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return rtn;
+	}
+	itnim_data = rport->dd_data;
+	if (itnim_data->tmf_wq) {
+		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
+			"target reset failed, TMF already active");
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		return rtn;
+	}
+	itnim = itnim_data->itnim;
+	itnim_data->tmf_wq = &wq;
+	itnim_data->tmf_status = 0;
+	rc = bfad_im_target_reset_send(bfad, itnim_data);
+	if (rc == BFA_STATUS_OK) {
+		/* wait target reset to complete */
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		wait_event(wq, test_bit(IO_DONE_BIT,
+					&itnim_data->tmf_status));
+		spin_lock_irqsave(&bfad->bfad_lock, flags);
+
+		task_status = itnim_data->tmf_status >> 1;
+		if (task_status != BFI_TSKIM_STS_OK)
+			BFA_LOG(KERN_ERR, bfad, bfa_log_level,
+				"target reset failure,"
+				" status: %d\n", task_status);
+		else
+			rtn = SUCCESS;
 	}
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index c03b225ea1ba..c9ead4217a7d 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -61,6 +61,8 @@ static inline struct bfad_cmd_priv *bfad_priv(struct scsi_cmnd *cmd)
 
 struct bfad_itnim_data_s {
 	struct bfad_itnim_s *itnim;
+	wait_queue_head_t *tmf_wq;
+	unsigned long tmf_status;
 };
 
 struct bfad_im_port_s {
-- 
2.29.2

