Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 171A6C43214
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F35A260720
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235993AbhHQJRm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:42 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33326 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239383AbhHQJRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:17 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 79B1721D71;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/qqau6iRJhTarNpzpM+BK4TSRMqSL+XqvwgHs6oQh0=;
        b=speac0dmF1hsnP1ucTP992OdsscbEhvNqmOCkhkk8/q8cji6sXqBnldKakx+q+suvJuDGa
        oRVy3mouEjkDgg5D1dLM8V8coRrSYsoKYeUIQzWoJCv1KUjWB/nIQpSCypiugKsoMXoy1L
        cIDFQhAKX4B23+ARtjvZsvvpB/T+aSc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/qqau6iRJhTarNpzpM+BK4TSRMqSL+XqvwgHs6oQh0=;
        b=4pUcrtCoFo50jbKKvliF+wKq0FCU5bDZKzSdRZ41gDXtFQHufADyL4TZRbfu/RrNb8Y/2e
        u+CJ1q9iDc3EzfCA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 72D9DA3BB1;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6F927518CEA1; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 33/51] bfa: Do not use scsi command to signal TMF status
Date:   Tue, 17 Aug 2021 11:14:38 +0200
Message-Id: <20210817091456.73342-34-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
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
 drivers/scsi/bfa/bfad_im.c | 109 ++++++++++++++++++++-----------------
 drivers/scsi/bfa/bfad_im.h |   2 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 6b5841b1c06e..0cd5f5d7cc6b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -147,13 +147,12 @@ void
 bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
 		   enum bfi_tskim_status tsk_status)
 {
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dtsk;
+	struct bfad_itnim_data_s *itnim_data = (struct bfad_itnim_data_s *)dtsk;
 	wait_queue_head_t *wq;
 
-	cmnd->SCp.Status |= tsk_status << 1;
-	set_bit(IO_DONE_BIT, (unsigned long *)&cmnd->SCp.Status);
-	wq = (wait_queue_head_t *) cmnd->SCp.ptr;
-	cmnd->SCp.ptr = NULL;
+	itnim_data->tmf_status |= tsk_status << 1;
+	set_bit(IO_DONE_BIT, &itnim_data->tmf_status);
+	wq = itnim_data->tmf_wq;
 
 	if (wq)
 		wake_up(wq);
@@ -238,15 +237,16 @@ bfad_im_abort_handler(struct scsi_cmnd *cmnd)
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
@@ -254,12 +254,6 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 		goto out;
 	}
 
-	/*
-	 * Set host_scribble to NULL to avoid aborting a task command if
-	 * happens.
-	 */
-	cmnd->host_scribble = NULL;
-	cmnd->SCp.Status = 0;
 	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	/*
 	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
@@ -290,10 +284,11 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
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
@@ -305,14 +300,20 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
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
@@ -321,13 +322,8 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 		goto out;
 	}
 
-	/*
-	 * Set host_scribble to NULL to avoid aborting a task command
-	 * if happens.
-	 */
-	cmnd->host_scribble = NULL;
-	cmnd->SCp.ptr = (char *)&wq;
-	cmnd->SCp.Status = 0;
+	itnim_data->tmf_wq = &wq;
+	itnim_data->tmf_status = 0;
 	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	/*
 	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
@@ -342,15 +338,16 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 		rc = FAILED;
 		goto out;
 	}
-	int_to_scsilun(cmnd->device->lun, &scsilun);
+	int_to_scsilun(sdev->lun, &scsilun);
 	bfa_tskim_start(tskim, bfa_itnim, scsilun,
 			    FCP_TM_LUN_RESET, BFAD_LUN_RESET_TMO);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
-	wait_event(wq, test_bit(IO_DONE_BIT,
-			(unsigned long *)&cmnd->SCp.Status));
-
-	task_status = cmnd->SCp.Status >> 1;
+	wait_event(wq, test_bit(IO_DONE_BIT, &itnim_data->tmf_status));
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	itnim_data->tmf_wq = NULL;
+	task_status = itnim_data->tmf_status >> 1;
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	if (task_status != BFI_TSKIM_STS_OK) {
 		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 			"LUN reset failure, status: %d\n", task_status);
@@ -367,37 +364,49 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 static int
 bfad_im_reset_target_handler(struct scsi_cmnd *cmnd)
 {
-	struct Scsi_Host *shost = cmnd->device->host;
 	struct scsi_target *starget = scsi_target(cmnd->device);
+	struct fc_rport *rport = starget_to_rport(starget);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct bfad_itnim_data_s *itnim_data;
+	struct bfad_itnim_s *itnim;
 	struct bfad_im_port_s *im_port =
 				(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s         *bfad = im_port->bfad;
-	struct bfad_itnim_s   *itnim;
 	unsigned long   flags;
 	u32        rc, rtn = FAILED;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 	enum bfi_tskim_status task_status;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	itnim = bfad_get_itnim(im_port, starget->id);
-	if (itnim) {
-		cmnd->SCp.ptr = (char *)&wq;
-		rc = bfad_im_target_reset_send(bfad, cmnd, itnim);
-		if (rc == BFA_STATUS_OK) {
-			/* wait target reset to complete */
-			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-			wait_event(wq, test_bit(IO_DONE_BIT,
-					(unsigned long *)&cmnd->SCp.Status));
-			spin_lock_irqsave(&bfad->bfad_lock, flags);
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
 
-			task_status = cmnd->SCp.Status >> 1;
-			if (task_status != BFI_TSKIM_STS_OK)
-				BFA_LOG(KERN_ERR, bfad, bfa_log_level,
-					"target reset failure,"
-					" status: %d\n", task_status);
-			else
-				rtn = SUCCESS;
-		}
+	itnim_data->tmf_wq = &wq;
+	itnim_data->tmf_status = 0;
+	rc = bfad_im_target_reset_send(bfad, itnim_data);
+	if (rc == BFA_STATUS_OK) {
+		/* wait target reset to complete */
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		wait_event(wq, test_bit(IO_DONE_BIT, &itnim_data->tmf_status));
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
index f16d4b219e44..93fffd4e13bd 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -45,6 +45,8 @@ u32 bfad_im_supported_speeds(struct bfa_s *bfa);
 
 struct bfad_itnim_data_s {
 	struct bfad_itnim_s *itnim;
+	wait_queue_head_t *tmf_wq;
+	unsigned long tmf_status;
 };
 
 struct bfad_im_port_s {
-- 
2.29.2

