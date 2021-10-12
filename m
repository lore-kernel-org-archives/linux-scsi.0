Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1F2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 714D26109E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhJLV5M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:57:12 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:45643 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbhJLV5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 17:57:09 -0400
Received: by mail-pg1-f174.google.com with SMTP id f5so346578pgc.12
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 14:55:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pYX3xRAh13byE2f3iL+TWa6syl7q5ZRx6XhBypBsG7c=;
        b=EFI0SL5eZcEEzNC4L8c9uPE3HPfrffWMC0qGgiwLMr2656kB8Cp9B+RN8Mhy+QzSSv
         ENjEP79c3UiefPq4LD+FIHVyMC68TQvQmPvVCWwdM1BS4ndf6SYUuLxK7I28WFsB3TYI
         4yr/bpBWj62puEl1OYwo5RPPXDJw0PVj2M3xAe3C2TUEQDVIGb927xvvURwMzSBtD3+p
         4/GH9e3cIGTBj/YRrl6GAKeIQzuETAu8CwbiOG9aeRcd3CgTek5vtPug+MWKnwyIKfOd
         8AznhtX4331qNybAtXBlu/VWrK1fAs124qbyzO0+HNVJM0jsfhoHfX5949N0hvvv+fyK
         g4kQ==
X-Gm-Message-State: AOAM532nc06Dj5Wyqu6/htCE7mtbl4OXvFhOo92A6EGRr4oobTjmnjL7
        uR4oV2l8Z4e0NLgAHL+yJM8=
X-Google-Smtp-Source: ABdhPJwLklobbal4SpnzsY6Y2HFY9iqajUQqQ8SpGXN5MPzPmqr9zIxh0deYSIM9euL4qMm7cl0yzw==
X-Received: by 2002:a63:4766:: with SMTP id w38mr24754357pgk.104.1634075707400;
        Tue, 12 Oct 2021 14:55:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id m73sm12038730pfd.152.2021.10.12.14.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:55:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 4/5] scsi: ufs: Log error handler activity
Date:   Tue, 12 Oct 2021 14:54:32 -0700
Message-Id: <20211012215433.3725777-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012215433.3725777-1-bvanassche@acm.org>
References: <20211012215433.3725777-1-bvanassche@acm.org>
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
index cb55ba3cb3e6..ecfe1f124f8a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -134,6 +134,14 @@ enum {
 	UFSHCD_CAN_QUEUE	= 32,
 };
 
+static const char *const ufshcd_state_name[] = {
+	[UFSHCD_STATE_RESET]			= "reset",
+	[UFSHCD_STATE_OPERATIONAL]		= "operational",
+	[UFSHCD_STATE_ERROR]			= "error",
+	[UFSHCD_STATE_EH_SCHEDULED_FATAL]	= "eh_will_reset",
+	[UFSHCD_STATE_EH_SCHEDULED_NON_FATAL]	= "eh_wont_reset",
+};
+
 /* UFSHCD error handling flags */
 enum {
 	UFSHCD_EH_IN_PROGRESS = (1 << 0),
@@ -6065,6 +6073,13 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 	int pmc_err;
 	int tag;
 
+	dev_info(hba->dev,
+		 "%s started; HBA state %s; powered %d; shutting down %d; saved_err = %d; saved_uic_err = %d; force_reset = %d%s\n",
+		 __func__, ufshcd_state_name[hba->ufshcd_state],
+		 hba->is_powered, hba->shutting_down, hba->saved_err,
+		 hba->saved_uic_err, hba->force_reset,
+		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
+
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->host->host_eh_scheduled = 0;
@@ -6160,6 +6175,8 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 			err_xfer = true;
 			goto lock_skip_pending_xfer_clear;
 		}
+		dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
+			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
 	}
 
 	/* Clear pending task management requests */
@@ -6240,6 +6257,9 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->host_sem);
+
+	dev_info(hba->dev, "%s finished; HBA state %s\n", __func__,
+		 ufshcd_state_name[hba->ufshcd_state]);
 }
 
 /**
@@ -6554,6 +6574,10 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
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
