Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D259C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243451AbiBHR0K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384315AbiBHR0E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:04 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA58BC061579
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:01 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id om7so3792080pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+TdCkgEpl9qrz18nbjVlJLcMFGbVv4+lZpPH1AVIuOU=;
        b=EyUJSKM31SRIGkr7lfJuOApY641uLEdUQHofhA5MbYaDOPGSzghxPWKf/V4xD2ExfV
         ybFjDwRe9IKOLdT8F9d5a7wS52e7jDanSFjOUL1Qll8jlGYjroDuNCqJoD78REqyisxH
         tHIZqWG8/fcsh23SVAiG1mZJgkxN9rj+xcyoQpFmuA4oVzHpd2skZWpAgo9xW6r8l82y
         nfYhnsIc/cJpid8DOIKIlDkxagMBbopVkWaMiS9Hvmi6rlcTc2Hb1o5yeJ514/S53taM
         SfaMcK4yCWtCXT9XgvNZv8eYiNnnHivrrUfAQn5DIrq20FoGD8ECKQ+etnBSMWh0ISID
         MtvQ==
X-Gm-Message-State: AOAM531zWwBNmYv47yLw6/yrByOfyAqJuBmFnlyVVeaGaQUZyY+3zPhM
        ekXJbNF5IRDB+6cHOmoEvLM=
X-Google-Smtp-Source: ABdhPJwdaYLjUAm1htXfoPL88N6no5U3RoigU9z1C0hgBVWmu37U15prS0OpbKLE4vPUO8hRf1sBHQ==
X-Received: by 2002:a17:902:c942:: with SMTP id i2mr5261207pla.137.1644341161023;
        Tue, 08 Feb 2022 09:26:01 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:00 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 13/44] bfa: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:24:43 -0800
Message-Id: <20220208172514.3481-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

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
