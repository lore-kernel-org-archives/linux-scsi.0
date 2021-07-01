Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230ADC11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A12E6128A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhGAVPl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:41 -0400
Received: from mail-pl1-f181.google.com ([209.85.214.181]:42754 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234178AbhGAVPk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:40 -0400
Received: by mail-pl1-f181.google.com with SMTP id v13so4408315ple.9
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eLRav2F9P0CKV8wXIqmVa3QfKQwuN7Z1cO/8S1fxJqA=;
        b=mq8SfV5y6TOsJ0YUsXZduIZsLUDcswAS1Jdo1YH05hP1FY1dfNaeUrSV3Cphmqlzoa
         IriULJrx/RlP9pqt/GIHHctXFP37+Rohq5kOu+YEbWxJE72kZNJVliigQ0SC9T4iBZUz
         AXnp+/qc0pAcfUPCYPEDy2xz7fB0YR80ZIibFCteQq4jemcDJsK4kvZlGGhZDUl9/Ik7
         3FeVpDzmq734jbDAhTM0fv6Mfr7wSJN5C4+chVuFUvhm3qLOZxHF29GGc1nQtFV7md9K
         ufcnDxLHcDmrZrMycmzmxWLcnVGSwuhYPEkHyQq4MzE7uukUkiUgBRbMC46ztH8nLFZN
         38RQ==
X-Gm-Message-State: AOAM533qKMjgR+DRstb3isz6Bfxh/f4rBbfuphb2acfLd8plD7h0rfc/
        57NimsO3I1tEFmmMoYvByyY=
X-Google-Smtp-Source: ABdhPJzzHk/UWOXS3EoO4TEHkfmrv8MyCl0v9pytC2uRA5Ph5JNg2lcZKmOH3DdHVxSgw9kLg59mNg==
X-Received: by 2002:a17:90a:1da3:: with SMTP id v32mr12083782pjv.192.1625173989559;
        Thu, 01 Jul 2021 14:13:09 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH 09/21] ufs: Use DECLARE_COMPLETION_ONSTACK() where appropriate
Date:   Thu,  1 Jul 2021 14:12:12 -0700
Message-Id: <20210701211224.17070-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
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
index 86ca9e1ce5aa..2148e123e9db 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2949,11 +2949,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
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
 
@@ -2975,7 +2975,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		goto out;
 	}
 
-	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
@@ -3980,14 +3979,13 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
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
@@ -6660,11 +6658,11 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
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
@@ -6682,7 +6680,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		goto out;
 	}
 
-	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
