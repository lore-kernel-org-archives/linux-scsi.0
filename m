Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8424DC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354124AbiBKWdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354118AbiBKWdm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:42 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1189CD54
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:41 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id y5so18660548pfe.4
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tc5twZAeUFlYiGHnzMUwF6Wqn/lA5wVbiTacuuNXQCw=;
        b=3EMgVQee2KLDB3jeBn90WxyNx/o7HHDfC1n1StdjFRTn2jmqprMh5s6BtJo7a7uGNr
         xKsgSl/Td2Ca5bTErgAKuKP3fmyfvWK3EkSJUqyPvrc6Im/xbhehWzuCzTOo+/S5kDa7
         /XizreXNjLqQBtSqJ7qP4v7TaSuQiPXg4SbijmV+/sU+0QO281mw57bmYh1UP+AyRibh
         V63taCaV7pLwCh84ZOM8FPoxUx5jaS743StNopljYxcVTNOjT/VEmx4Jq0L12wfi+jRu
         DN22kulqNqL1LoEDre9foUC6kvCX/VFQh1favi5mh79I3FHxt9HEbpOgVsJkFtnWAfnM
         DPZA==
X-Gm-Message-State: AOAM531oegLnzKWctne+rRvgcxn+lm3OH7wBWomd8j1AOj7lzRnqfVBL
        68/8BylYk12QqD6K2rUrww8=
X-Google-Smtp-Source: ABdhPJwtQsTX1Xcd6CfUNYog2leBB8RMrmbUrlCR23ApP5+HbKYxxJaFRUMLtBmk73VibmwS+gYThA==
X-Received: by 2002:aa7:8701:: with SMTP id b1mr3615818pfo.54.1644618820477;
        Fri, 11 Feb 2022 14:33:40 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:39 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 17/48] scsi: bfa: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:16 -0800
Message-Id: <20220211223247.14369-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bfa/bfad_im.c | 27 ++++++++++++++-------------
 drivers/scsi/bfa/bfad_im.h | 16 ++++++++++++++++
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 759d2bb1ecdd..8419a1a89485 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -150,10 +150,10 @@ bfa_cb_tskim_done(void *bfad, struct bfad_tskim_s *dtsk,
 	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dtsk;
 	wait_queue_head_t *wq;
 
-	cmnd->SCp.Status |= tsk_status << 1;
-	set_bit(IO_DONE_BIT, (unsigned long *)&cmnd->SCp.Status);
-	wq = (wait_queue_head_t *) cmnd->SCp.ptr;
-	cmnd->SCp.ptr = NULL;
+	bfad_priv(cmnd)->status |= tsk_status << 1;
+	set_bit(IO_DONE_BIT, &bfad_priv(cmnd)->status);
+	wq = bfad_priv(cmnd)->wq;
+	bfad_priv(cmnd)->wq = NULL;
 
 	if (wq)
 		wake_up(wq);
@@ -259,7 +259,7 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 	 * happens.
 	 */
 	cmnd->host_scribble = NULL;
-	cmnd->SCp.Status = 0;
+	bfad_priv(cmnd)->status = 0;
 	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	/*
 	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
@@ -326,8 +326,8 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 	 * if happens.
 	 */
 	cmnd->host_scribble = NULL;
-	cmnd->SCp.ptr = (char *)&wq;
-	cmnd->SCp.Status = 0;
+	bfad_priv(cmnd)->wq = &wq;
+	bfad_priv(cmnd)->status = 0;
 	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	/*
 	 * bfa_itnim can be NULL if the port gets disconnected and the bfa
@@ -347,10 +347,9 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
 			    FCP_TM_LUN_RESET, BFAD_LUN_RESET_TMO);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
-	wait_event(wq, test_bit(IO_DONE_BIT,
-			(unsigned long *)&cmnd->SCp.Status));
+	wait_event(wq, test_bit(IO_DONE_BIT, &bfad_priv(cmnd)->status));
 
-	task_status = cmnd->SCp.Status >> 1;
+	task_status = bfad_priv(cmnd)->status >> 1;
 	if (task_status != BFI_TSKIM_STS_OK) {
 		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 			"LUN reset failure, status: %d\n", task_status);
@@ -381,16 +380,16 @@ bfad_im_reset_target_handler(struct scsi_cmnd *cmnd)
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	itnim = bfad_get_itnim(im_port, starget->id);
 	if (itnim) {
-		cmnd->SCp.ptr = (char *)&wq;
+		bfad_priv(cmnd)->wq = &wq;
 		rc = bfad_im_target_reset_send(bfad, cmnd, itnim);
 		if (rc == BFA_STATUS_OK) {
 			/* wait target reset to complete */
 			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 			wait_event(wq, test_bit(IO_DONE_BIT,
-					(unsigned long *)&cmnd->SCp.Status));
+						&bfad_priv(cmnd)->status));
 			spin_lock_irqsave(&bfad->bfad_lock, flags);
 
-			task_status = cmnd->SCp.Status >> 1;
+			task_status = bfad_priv(cmnd)->status >> 1;
 			if (task_status != BFI_TSKIM_STS_OK)
 				BFA_LOG(KERN_ERR, bfad, bfa_log_level,
 					"target reset failure,"
@@ -797,6 +796,7 @@ struct scsi_host_template bfad_im_scsi_host_template = {
 	.name = BFAD_DRIVER_NAME,
 	.info = bfad_im_info,
 	.queuecommand = bfad_im_queuecommand,
+	.cmd_size = sizeof(struct bfad_cmd_priv),
 	.eh_timed_out = fc_eh_timed_out,
 	.eh_abort_handler = bfad_im_abort_handler,
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
@@ -819,6 +819,7 @@ struct scsi_host_template bfad_im_vport_template = {
 	.name = BFAD_DRIVER_NAME,
 	.info = bfad_im_info,
 	.queuecommand = bfad_im_queuecommand,
+	.cmd_size = sizeof(struct bfad_cmd_priv),
 	.eh_timed_out = fc_eh_timed_out,
 	.eh_abort_handler = bfad_im_abort_handler,
 	.eh_device_reset_handler = bfad_im_reset_lun_handler,
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 829345b514d1..c03b225ea1ba 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -43,6 +43,22 @@ u32 bfad_im_supported_speeds(struct bfa_s *bfa);
  */
 #define IO_DONE_BIT			0
 
+/**
+ * struct bfad_cmd_priv - private data per SCSI command.
+ * @status: Lowest bit represents IO_DONE. The next seven bits hold a value of
+ * type enum bfi_tskim_status.
+ * @wq: Wait queue used to wait for completion of an operation.
+ */
+struct bfad_cmd_priv {
+	unsigned long status;
+	wait_queue_head_t *wq;
+};
+
+static inline struct bfad_cmd_priv *bfad_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 struct bfad_itnim_data_s {
 	struct bfad_itnim_s *itnim;
 };
