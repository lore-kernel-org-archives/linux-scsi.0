Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD66BC7EE2A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 22:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjEQWcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 18:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjEQWcH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 18:32:07 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C220C6188
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:32:05 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-253504c84aeso652499a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 15:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684362725; x=1686954725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cd63F8ZEJ+QmTVryeuCYl4qYVheSeqpWxhheBVjnX+c=;
        b=cN6Hx79L1sc3/CtSRNy7uas9VaMkYALsBwZzoNvBKRnQdlzFiKC959/aZF2sgHE3jg
         hZb3jFxsKXcXbrK1Exj4a19hxjapFVXr1uG2lHG7NdmlqI0UHjZHuByfjoSee5QqIQpd
         rsALtXbIz9mUZW3SqzpWVj8aYB79dLF8Qcxd30+P6fZPJ29iY8SwKbY3FD0V/xLKiytA
         AEffbbtwyR/mEzQOLsittKGeLNCi8lDRhsanYICZXOzeal0Vyj3a0mde1Mf6s/dWs3zA
         I0ejKcnS9BiZT1dgr7GmpF8LnPhWMr/lEyg/PLL0BQBuZxAVibt49v5SQ+aG5t2n95ph
         DMCQ==
X-Gm-Message-State: AC+VfDwZue2d8ITpH45Me9NcLb/J1OPYKEmva+72VKCePohpRSEoLwO2
        KqZkADqkm0A+dtEz/0lhRy8VBFX7/4s=
X-Google-Smtp-Source: ACHHUZ7vuB85PnSFW8qKovGZNs5BDOVZehY9jgucFVHcYrwIKU6gzEfZbOWo7ZV00xVqZ4hmyMgtmQ==
X-Received: by 2002:a17:90a:7644:b0:250:c758:13a0 with SMTP id s4-20020a17090a764400b00250c75813a0mr349631pjl.41.1684362724947;
        Wed, 17 May 2023 15:32:04 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id n1-20020a17090a9f0100b00250d908a771sm61938pjp.50.2023.05.17.15.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:32:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 2/4] scsi: ufs: Fix handling of lrbp->cmd
Date:   Wed, 17 May 2023 15:31:55 -0700
Message-ID: <20230517223157.1068210-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517223157.1068210-1-bvanassche@acm.org>
References: <20230517223157.1068210-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_queuecommand() may be called two times in a row for a SCSI
command before it is completed. Hence make the following changes:
- In the functions that submit a command, do not check the old value of
  lrbp->cmd nor clear lrbp->cmd in error paths.
- In ufshcd_release_scsi_cmd(), do not clear lrbp->cmd.

See also scsi_send_eh_cmnd().

This patch prevents that the following appears if a command times out:

WARNING: at drivers/ufs/core/ufshcd.c:2965 ufshcd_queuecommand+0x6f8/0x9a8
Call trace:
 ufshcd_queuecommand+0x6f8/0x9a8
 scsi_send_eh_cmnd+0x2c0/0x960
 scsi_eh_test_devices+0x100/0x314
 scsi_eh_ready_devs+0xd90/0x114c
 scsi_error_handler+0x2b4/0xb70
 kthread+0x16c/0x1e0

Fixes: 5a0b0cb9bee7 ("[SCSI] ufs: Add support for sending NOP OUT UPIU")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 37337d411466..68d9e24fac98 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2928,7 +2928,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		(hba->clk_gating.state != CLKS_ON));
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
@@ -2944,7 +2943,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
-		lrbp->cmd = NULL;
 		ufshcd_release(hba);
 		goto out;
 	}
@@ -5405,7 +5403,6 @@ static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
 	struct scsi_cmnd *cmd = lrbp->cmd;
 
 	scsi_dma_unmap(cmd);
-	lrbp->cmd = NULL;	/* Mark the command as completed. */
 	ufshcd_release(hba);
 	ufshcd_clk_scaling_update_busy(hba);
 }
@@ -7020,7 +7017,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0;
@@ -7192,7 +7188,6 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = UFS_UPIU_RPMB_WLUN;
