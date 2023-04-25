Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8107C77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 23:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbjDYXaa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 19:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjDYXa2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 19:30:28 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50317B463
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:30:25 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-63b46186c03so7643326b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:30:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682465425; x=1685057425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8dze6nh/OPwDpU/XRdaupD7Ed+vZa8VeVZlE7w1md38=;
        b=gsBiU5TiMeRyJes3wEFa+ISjbGnvwNVuI7RHLT2XLM/yi7Yj/bjt1QGh2OS+QcxS/9
         JWwZ7Rj+JPAFGb4osaZzW5JBUooWkDQOWDClbFfDwilTgidviImaCGbPrtFn4GcBgRaZ
         NstkswXmBP6R6aY+H03q25gzgi47+2gZIg5g/dFcgsCE/kxCVsP0ueoVhjK69OVNZrGA
         /E+5YU/2UxKifxbKcuZ/Dl0UwArhxW8sDglT1EvvzLRlgqJ9Zu5oDzomtycHkg/ljTFz
         uq83oU92R3xDTDGHrTQU9gsbevimVbm2mQaCTjTDCBWKhDva0uE+KDeokp0VyxdSiSCr
         7q2Q==
X-Gm-Message-State: AAQBX9eOsngmmsQtSqGBS/bxsZg8xXfMA+aMxEJSoOlRDqcasClGip0s
        joRGPsVpFeusSg5Y9OVp064=
X-Google-Smtp-Source: AKy350ZumjSN3A7UOJfu5RYLeYd5VEyakzDKd23jrPi8VywCPRc8dENFR3MHuW8NqJbogAgOf0scjw==
X-Received: by 2002:a05:6a00:2d8d:b0:63d:254a:3901 with SMTP id fb13-20020a056a002d8d00b0063d254a3901mr26991519pfb.25.1682465424655;
        Tue, 25 Apr 2023 16:30:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5099:ad7c:6c1:9570])
        by smtp.gmail.com with ESMTPSA id b20-20020a056a0002d400b006348cb791f4sm9829941pft.192.2023.04.25.16.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:30:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 2/4] scsi: ufs: Fix handling of lrbp->cmd
Date:   Tue, 25 Apr 2023 16:29:52 -0700
Message-ID: <20230425232954.1229916-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230425232954.1229916-1-bvanassche@acm.org>
References: <20230425232954.1229916-1-bvanassche@acm.org>
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
index 0e2a0656858a..c691ddf09698 100644
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
