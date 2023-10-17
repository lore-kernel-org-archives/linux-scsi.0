Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7832CDB482
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 10:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343548AbjJQKHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 06:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbjJQKHp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 06:07:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3337ED
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 03:07:41 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1404F1FF0E;
        Tue, 17 Oct 2023 10:07:40 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D042C2C663;
        Tue, 17 Oct 2023 10:07:39 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id F326651EBE86; Tue, 17 Oct 2023 12:07:39 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/16] bfa: Do not use scsi command to signal TMF status
Date:   Tue, 17 Oct 2023 12:07:15 +0200
Message-Id: <20231017100729.123506-3-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231017100729.123506-1-hare@suse.de>
References: <20231017100729.123506-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [2.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[5];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-3.00)[100.00%]
X-Rspamd-Queue-Id: 1404F1FF0E
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The bfa driver hijacks the scsi command to signal the TMF status,
which will no longer work if the TMF handler will be converted.
So rework TMF handling to not use a scsi command but rather add
new TMF fields to the per-device structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/bfa/bfad_im.c | 112 ++++++++++++++++++++-----------------
 drivers/scsi/bfa/bfad_im.h |   2 +
 2 files changed, 63 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index a9d3d8562d3c..ef352fc59458 100644
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
index 4353feedf76a..48e8c12969c9 100644
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
2.35.3

