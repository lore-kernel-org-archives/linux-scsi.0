Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5267AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B7B461130
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhJTVnL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:43:11 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:53761 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhJTVnK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:43:10 -0400
Received: by mail-pj1-f49.google.com with SMTP id ls18so3406187pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Y7yOxU3tCp9lN6l2cYvO5CbHMnWzRaysyMKwAxgTFU=;
        b=N2iUmx3i0MAMgIVTKGPjnlHpGTAdEouDwZicxWPEXSXgg75XFudBMiwjNmB+YP7wUu
         T7lOEcWkysmD8KSLthP52PjsUk3jRUGN/RkyG/ecKVfxcVr7X2RCoPX+83rs3EQz7fZK
         TaapFjqmmEKqSTaTitXOiYEz2uW+oi/uHOBmFhJcRfYzataOtblWBPZnKIDcCVMhTBWh
         YLbEqf7IIR0p1YhEYsI0YucmlTSXLUnMx2+5novuCoMth8mkJlj1ckjCB8OQgbmpr4dn
         1Mo+mIN6zU5qhdiNaOzXpouaBhPkIvvlOVZrI/Kddkg0+Qs5fgp33WbCxevkQRLMmkPH
         7YCw==
X-Gm-Message-State: AOAM531ONCKR2BYHyX23X6OK3rrtGz1390978k5UaZDNneFu8RveyoJ8
        /FsVXBAwEjY1luWch8CdpBt7vQgtOvI=
X-Google-Smtp-Source: ABdhPJxdSbMENEIuMzh2DEem19Pedkj7DN44z3BAMuyTz4nsvLxV6hdtLFKrfQSz9YbzLaLiPiY5+A==
X-Received: by 2002:a17:90b:1645:: with SMTP id il5mr1631863pjb.158.1634766055794;
        Wed, 20 Oct 2021 14:40:55 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:40:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 04/10] scsi: ufs: Log error handler activity
Date:   Wed, 20 Oct 2021 14:40:18 -0700
Message-Id: <20211020214024.2007615-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
References: <20211020214024.2007615-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kernel logs are hard to comprehend without information about what the
UFS error handler is doing. Hence this patch that logs information
about error handler activity.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 610be6746f74..49623bf3e876 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -132,6 +132,14 @@ enum {
 	UFSHCD_CAN_QUEUE	= 32,
 };
 
+static const char *const ufshcd_state_name[] = {
+	[UFSHCD_STATE_RESET]			= "reset",
+	[UFSHCD_STATE_OPERATIONAL]		= "operational",
+	[UFSHCD_STATE_ERROR]			= "error",
+	[UFSHCD_STATE_EH_SCHEDULED_FATAL]	= "eh_fatal",
+	[UFSHCD_STATE_EH_SCHEDULED_NON_FATAL]	= "eh_non_fatal",
+};
+
 /* UFSHCD error handling flags */
 enum {
 	UFSHCD_EH_IN_PROGRESS = (1 << 0),
@@ -6069,6 +6077,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	hba = container_of(work, struct ufs_hba, eh_work);
 
+	dev_info(hba->dev,
+		 "%s started; HBA state %s; powered %d; shutting down %d; saved_err = %d; saved_uic_err = %d; force_reset = %d%s\n",
+		 __func__, ufshcd_state_name[hba->ufshcd_state],
+		 hba->is_powered, hba->shutting_down, hba->saved_err,
+		 hba->saved_uic_err, hba->force_reset,
+		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
+
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ufshcd_err_handling_should_stop(hba)) {
@@ -6163,6 +6178,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 			err_xfer = true;
 			goto lock_skip_pending_xfer_clear;
 		}
+		dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
+			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
 	}
 
 	/* Clear pending task management requests */
@@ -6243,6 +6260,9 @@ static void ufshcd_err_handler(struct work_struct *work)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->host_sem);
+
+	dev_info(hba->dev, "%s finished; HBA state %s\n", __func__,
+		 ufshcd_state_name[hba->ufshcd_state]);
 }
 
 /**
@@ -6539,6 +6559,10 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 	err = ufshcd_wait_for_register(hba,
 			REG_UTP_TASK_REQ_DOOR_BELL,
 			mask, 0, 1000, 1000);
+
+	dev_err(hba->dev, "Clearing task management function with tag %d %s\n",
+		tag, err ? "succeeded" : "failed");
+
 out:
 	return err;
 }
