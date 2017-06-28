From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 31/47] bfa: Do not use scsi command to signal TMF status
Date: Wed, 28 Jun 2017 10:32:57 +0200
Message-ID: <1498638793-44672-32-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751754AbdF1IdY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:24 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bfa driver hijacks the scsi command to signal the TMF status,
which will no longer work if the TMF handler will be converted.
So rework TMF handling to not use a scsi command but rather add
new TMF fields to the per-device structure.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/bfa/bfad_im.c | 109 ++++++++++++++++++++++++---------------------
 drivers/scsi/bfa/bfad_im.h |   2 +
 2 files changed, 61 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 24e657a..ae77ba1 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -158,13 +158,12 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
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
@@ -249,15 +248,16 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
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
@@ -265,12 +265,6 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
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
@@ -301,10 +295,11 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
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
@@ -316,14 +311,20 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
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
@@ -332,13 +333,8 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
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
@@ -353,15 +349,16 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
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
@@ -378,37 +375,49 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
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
index c81ec2a..e57ea05 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -54,6 +54,8 @@ void bfad_im_scsi_host_free(struct bfad_s *bfad,
 
 struct bfad_itnim_data_s {
 	struct bfad_itnim_s *itnim;
+	wait_queue_head_t *tmf_wq;
+	unsigned long tmf_status;
 };
 
 struct bfad_im_port_s {
-- 
1.8.5.6
