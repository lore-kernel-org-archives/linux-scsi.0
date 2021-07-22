Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 060D0C636C8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D688661261
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhGVCyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:54:45 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:33283 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhGVCyn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:54:43 -0400
Received: by mail-pl1-f176.google.com with SMTP id d1so2972476plg.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YtHjWG741Fo7oeicGEAF+sAbKiOHHBo9FEtRS7qWSZE=;
        b=W3HfljT7DU7xBkQktqIZlBn6O3wJMuIlS/kui+yGhPDyxx8nKnHT1LsNE/mU1OTHdS
         aTNSFxYP6uVNV+U9khWJWh1XEDM2xGZLlLJnc8osL+6rx6AiZgcM70f2PpuGHmnq4T0M
         8wMXDuQuWw8hK+RAKTeM2QcXJEtHW86S4mrd1nyoKPRapPgdhhM/owMTIfgg3+5a+eBn
         4GzXhUh0qYza10Z0RZdSyWikL93H74jcCAVBA97hT0tqDICd4m1ySfJVfKM++ebP/5G+
         zsOqN08ODzx5EK5OEJkj4PAWJDltCburqeS5py83HOjM0FPJGQXXcwJZMl864f04He/t
         NheA==
X-Gm-Message-State: AOAM531H/Hofp/iTCnkDTKgr19KFeM+2oFohd9FBrAuL5fKK7t8rnaAL
        Hi/yY1UHFeu0MrDQW8swqw4=
X-Google-Smtp-Source: ABdhPJxAiu+Zidbzdz6RFmLxP7AOg6ehwgpskBIxuHMn04tJa0j616KlnhnN1VTWe9hxmH7yePVzTA==
X-Received: by 2002:a65:450d:: with SMTP id n13mr39265765pgq.13.1626924918186;
        Wed, 21 Jul 2021 20:35:18 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 06/18] scsi: ufs: Remove ufshcd_valid_tag()
Date:   Wed, 21 Jul 2021 20:34:27 -0700
Message-Id: <20210722033439.26550-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_add_host() allocates shost->can_queue tags. ufshcd_init() sets
shost->can_queue to hba->nutrs. In other words, we know that tag values
will less than hba->nutrs. Hence remove the checks that verify that
blk_get_request() returns a tag less than hba->nutrs. This check
was introduced by commit 14497328b6a6 ("scsi: ufs: verify command tag
validity").

Keep the tag >= 0 check because it helps to detect use-after-free issues.

Reviewed-by: Bean Huo <beanhuo@micron.com>
CC: Avri Altman <avri.altman@wdc.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 42 ++++++++++-----------------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 17afd1b0bd2c..ec12cd4eae03 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -252,11 +252,6 @@ static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
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
@@ -2700,20 +2695,12 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
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
+	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -2967,7 +2954,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 	tag = req->tag;
-	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
+	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 	/* Set the timeout such that the SCSI error handler is not activated. */
 	req->timeout = msecs_to_jiffies(2 * timeout);
 	blk_mq_start_request(req);
@@ -6677,7 +6664,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		goto out_unlock;
 	}
 	tag = req->tag;
-	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
+	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
 	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
 		err = -EBUSY;
@@ -6979,24 +6966,15 @@ static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
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
+	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
 
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
