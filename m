Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7C1C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C2F561357
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhGIU34 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:29:56 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:38419 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbhGIU34 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:29:56 -0400
Received: by mail-pg1-f177.google.com with SMTP id h4so11089249pgp.5
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Ntj/bvMAxLIpLT1WsjuA3LgZB7irv2YvgmITcVnPzM=;
        b=mbguzSRa+2eV22i94sLFdRv+IBDxAElKLOT6xFWetsf4+k23/EJbLBQechuVKyLFtV
         VLOCctls5s6uHnrcBaRd7swtSYJZK2KKMa1a6zN9PAf/NRU/CydipMw3C6Wg11OlEUI/
         XQbO+n87++2P+FZxnkqVvPSSA+FWrHxeqVfeg1LcT66rf+KrxGOOC48KrEpHWFwcrE6g
         Ff2JP3eR/tYXyzVGztlEbW5OOeLXR4n27uWfTShV4YQuehnNyBUnnmPShl8K2nMm8w60
         DmLuTzN72Y9aA8CRcswmY3AmE1AjSWpPO9OXw85nx6iudAT1A8nqnmX/u8lVLkWur/3N
         HzeA==
X-Gm-Message-State: AOAM532gsYTXthblCsZ1/W8vM+Jf6jpKaX7HSmN3N8qyMOhT0CEMBsOI
        wXTj9XcJ4g0v1rPGmgKf1G8=
X-Google-Smtp-Source: ABdhPJx6vWRCpZfFxklkIooBF1T5mqWV0wqFDHIdHA2RMDSeSPuzoq4pIMDuuf3YbP0FJvmDa1tzCQ==
X-Received: by 2002:a63:230c:: with SMTP id j12mr39759617pgj.382.1625862432140;
        Fri, 09 Jul 2021 13:27:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 05/19] scsi: ufs: Use DECLARE_COMPLETION_ONSTACK() where appropriate
Date:   Fri,  9 Jul 2021 13:26:24 -0700
Message-Id: <20210709202638.9480-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
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
