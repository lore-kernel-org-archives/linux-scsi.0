Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1992C636C8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BFE461261
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhGVCyn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:54:43 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:42811 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhGVCyk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:54:40 -0400
Received: by mail-pl1-f171.google.com with SMTP id v14so2949234plg.9
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LpI2d7GgOwsdcKaD/y+g/lzSPb1tbQyo56Gc3mKL63c=;
        b=cY6rFc0ww3x3W4gqcVgP7Ps1iTpsW7VIuInxDDV00zfAcajvzUZJQ3BhOgYbgMs6eP
         Z3RNgSx9hE1mI6ae+D4bCcGKgpgP707Z/Kn1nxFwhYVLmudv2YQHFdwkRA6S2dr2RAmb
         jkdObvSVDoQ9yCdIoa3hfV73L5s8mTPplnH7nyd+fzPIQxgzCJ1yH6cJVvNz9EH3JpfA
         32PSZYwJz6BZmDrfr33IwGp9adwToKxUYnd+oh0Zh47XWwKn2yDELRmk0o05WdM/zKcI
         p88yOXpGKGFNKh9Uno5ja5Gr+NwtJ0LiRiRpljcKTpgU5R65UsTuxyUUWHqN9+sBU7kH
         j/4w==
X-Gm-Message-State: AOAM532FQvcBJhyBYozXboV7FpoIh/t1JkyWhKynAY0JwxEPs1vPcLek
        ub0lztrB7gtlvQslptkYcJw=
X-Google-Smtp-Source: ABdhPJzDnV8iXWGEIdNHt+YAywRELL3LRDL1JzTEQYwoiYTkFiAK3JBuwWPNrZqEM9SQVhAiyBt+Lw==
X-Received: by 2002:a62:3045:0:b029:32b:880f:c03a with SMTP id w66-20020a6230450000b029032b880fc03amr39664358pfw.22.1626924914917;
        Wed, 21 Jul 2021 20:35:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH v3 05/18] scsi: ufs: Use DECLARE_COMPLETION_ONSTACK() where appropriate
Date:   Wed, 21 Jul 2021 20:34:26 -0700
Message-Id: <20210722033439.26550-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From Documentation/scheduler/completion.rst: "When a completion is declared
as a local variable within a function, then the initialization should
always use DECLARE_COMPLETION_ONSTACK() explicitly, not just to make
lockdep happy, but also to make it clear that limited scope had been
considered and is intentional."

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 36b60afcce34..17afd1b0bd2c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2948,11 +2948,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
 {
 	struct request_queue *q = hba->cmd_queue;
+	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request *req;
 	struct ufshcd_lrb *lrbp;
 	int err;
 	int tag;
-	struct completion wait;
 
 	down_read(&hba->clk_scaling_lock);
 
@@ -2977,7 +2977,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		goto out;
 	}
 
-	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
@@ -3984,14 +3983,13 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
  */
 static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 {
-	struct completion uic_async_done;
+	DECLARE_COMPLETION_ONSTACK(uic_async_done);
 	unsigned long flags;
 	u8 status;
 	int ret;
 	bool reenable_intr = false;
 
 	mutex_lock(&hba->uic_cmd_mutex);
-	init_completion(&uic_async_done);
 	ufshcd_add_delay_before_dme_cmd(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -6664,11 +6662,11 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					enum query_opcode desc_op)
 {
 	struct request_queue *q = hba->cmd_queue;
+	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request *req;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 	int tag;
-	struct completion wait;
 	u8 upiu_flags;
 
 	down_read(&hba->clk_scaling_lock);
@@ -6686,7 +6684,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		goto out;
 	}
 
-	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
