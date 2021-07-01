Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B30C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC0561406
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhGAVPq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:46 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:34329 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbhGAVPp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:45 -0400
Received: by mail-pf1-f175.google.com with SMTP id i6so7120407pfq.1
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0drnNsVJoLJiccixGTNQuPcT/+TAKcMCOuCLxgLYqWs=;
        b=Sokklv6dUI12Iym9PP8hV1x9NzqQX3kDpDTwSxQ0GnHwB/xnYUfRU7phvoyldf0HoM
         MEy9b3pBF6kQizTMQ5QHOmdKBXBBTD0FFhdbwi3XqGev7nmN9dOUs0nKTONyrsAmOMsB
         Ru8LE3wsFd8Z1VTngdwY5q/CKFBcs2UbMxX/gYLvd4xPqN1A7kgipXFnA3GCiYMroROc
         r3fTaZu002498STsGiXcDb3QAzaaqK2LGnBk6j3fjYm4aHcCexa4Wp/qsYfVeB5J5bCD
         st+SzOVhCuQLP2Kg1jpp4TNZMuLWUpuPTA5n0pxjnOtpLfMZk2S+0VSN72TC6/jf/H9y
         LX8w==
X-Gm-Message-State: AOAM530VhpLvACflxqqynCq7rDUDxcZ3tDind3BCrMKTb/6YRRjHhSXX
        pUP0gX1LlISiSPhQ/4lDRiU=
X-Google-Smtp-Source: ABdhPJzvrq1gTQ/D+xtpxuBxOAHETvgjBvQPeKBkcsZ5399BEkfsFxbfkdX2Yyfy+oEYmT8bHqPebA==
X-Received: by 2002:a63:4002:: with SMTP id n2mr1492562pga.124.1625173993280;
        Thu, 01 Jul 2021 14:13:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 10/21] ufs: Remove ufshcd_valid_tag()
Date:   Thu,  1 Jul 2021 14:12:13 -0700
Message-Id: <20210701211224.17070-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_add_host() allocates shost->can_queue tags. ufshcd_init() sets
shost->can_queue to hba->nutrs. In other words, we know that tag values
will be in the range [0, hba->nutrs). Hence remove the checks that
verify that blk_get_request() returns a tag in this range. This check
was introduced by commit 14497328b6a6 ("scsi: ufs: verify command tag
validity").

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 40 ++++++---------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2148e123e9db..2e6aa614e3f5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -253,11 +253,6 @@ static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
 static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
 
-static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
-{
-	return tag >= 0 && tag < hba->nutrs;
-}
-
 static inline void ufshcd_enable_irq(struct ufs_hba *hba)
 {
 	if (!hba->is_irq_enabled) {
@@ -2701,21 +2696,11 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
  */
 static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
+	struct ufs_hba *hba = shost_priv(host);
+	int tag = cmd->request->tag;
 	struct ufshcd_lrb *lrbp;
-	struct ufs_hba *hba;
-	int tag;
 	int err = 0;
 
-	hba = shost_priv(host);
-
-	tag = cmd->request->tag;
-	if (!ufshcd_valid_tag(hba, tag)) {
-		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
-		BUG();
-	}
-
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
@@ -2968,7 +2953,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 	tag = req->tag;
-	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		err = -EBUSY;
@@ -6673,7 +6657,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 	tag = req->tag;
-	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		err = -EBUSY;
@@ -6975,25 +6958,14 @@ static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
  */
 static int ufshcd_abort(struct scsi_cmnd *cmd)
 {
-	struct Scsi_Host *host;
-	struct ufs_hba *hba;
+	struct Scsi_Host *host = cmd->device->host;
+	struct ufs_hba *hba = shost_priv(host);
+	unsigned int tag = cmd->request->tag;
+	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	unsigned long flags;
-	unsigned int tag;
 	int err = 0;
-	struct ufshcd_lrb *lrbp;
 	u32 reg;
 
-	host = cmd->device->host;
-	hba = shost_priv(host);
-	tag = cmd->request->tag;
-	lrbp = &hba->lrb[tag];
-	if (!ufshcd_valid_tag(hba, tag)) {
-		dev_err(hba->dev,
-			"%s: invalid command tag %d: cmd=0x%p, cmd->request=0x%p",
-			__func__, tag, cmd, cmd->request);
-		BUG();
-	}
-
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* If command is already aborted/completed, return SUCCESS */
