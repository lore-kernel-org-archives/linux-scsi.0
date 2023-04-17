Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9AFC77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 23:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjDQXHd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 19:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjDQXHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 19:07:32 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A279710D7
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 16:07:31 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2472740a0dbso1101605a91.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 16:07:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681772851; x=1684364851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ziGprZkk8j+M0/3bRl/A6OK/JI6ipKWWQmLV76IMOM=;
        b=Aqpue6oRVTRpuPmIqd7zNKnu6cb/88bCOzTsn8xUb9ZoGLP4XBvNsFxOBa1Byo7H3P
         ztulcoNzKLopHTCX1/DwUX5o7RcXI4uARvyyYgtluYJsxNyajxmXNpLmAMZFIXSb/CA0
         AlSem2gnVmKASlN6T2uWKMTjMDjihZ9ArTIhDpcc1TI3ZYsHvAEtYLti3WoJqRpJeIxG
         ANZzRSGA8L/IK0I6YTZv1JH+gtlmNrPVDRem2vq1wM9m2ys+88iCGrkVMLyFOIVwGKxE
         Qvw50VLC82TmCCr4NsyU/pF4Lqgsmn8cCOX+i+uZ+QW4oasJdHPKznZbFASXDyNcyBpR
         gndw==
X-Gm-Message-State: AAQBX9dbqfFcFdHPZOFvLuCApQ/euZCf+aYWuc5qHGQGXBi8yFBishYK
        bFVZjJ/B51qbAEI5rrONITk=
X-Google-Smtp-Source: AKy350ZmvkaXF8s/gJHfltPN14gJZG3K8eELb3+VII+xUgGpU0hph2gCF1raAv1wg2IQlY4mah2EaQ==
X-Received: by 2002:a17:90a:7106:b0:237:44c3:df0b with SMTP id h6-20020a17090a710600b0023744c3df0bmr81282pjk.32.1681772851232;
        Mon, 17 Apr 2023 16:07:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2cdd:e77:b589:1518])
        by smtp.gmail.com with ESMTPSA id t4-20020a17090ad14400b002478d21de2bsm2539576pjw.36.2023.04.17.16.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 16:07:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bart Van Assche <bvanassche@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Santosh Y <santoshsy@gmail.com>
Subject: [PATCH v2 4/4] scsi: ufs: Fix handling of lrbp->cmd
Date:   Mon, 17 Apr 2023 16:06:56 -0700
Message-ID: <20230417230656.523826-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230417230656.523826-1-bvanassche@acm.org>
References: <20230417230656.523826-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@google.com>

ufshcd_queuecommand() may be called two times in a row for a SCSI
command before it is completed. Additionally, a single SCSI command may
be completed twice. Hence make the following changes:
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
Signed-off-by: Bart Van Assche <bvanassche@google.com>
---
 drivers/ufs/core/ufshcd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6831eb1afc30..4f4c5ba66bac 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2952,7 +2952,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		(hba->clk_gating.state != CLKS_ON));
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
@@ -2968,7 +2967,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
-		lrbp->cmd = NULL;
 		ufshcd_release(hba);
 		goto out;
 	}
@@ -5429,7 +5427,6 @@ static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
 	struct scsi_cmnd *cmd = lrbp->cmd;
 
 	scsi_dma_unmap(cmd);
-	lrbp->cmd = NULL;	/* Mark the command as completed. */
 	ufshcd_release(hba);
 	ufshcd_clk_scaling_update_busy(hba);
 }
@@ -7044,7 +7041,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0;
@@ -7216,7 +7212,6 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = UFS_UPIU_RPMB_WLUN;
