Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A11C2C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 20:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjEXUhS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 16:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjEXUhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 16:37:16 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DC210B
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 13:37:15 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2553f2706bfso201746a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 13:37:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684960635; x=1687552635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11dlsUxeIT9kbH4dHEV1w/hQN2ZednujI/Fc46fxKH8=;
        b=bAXoEysuulkM0RkuNOsBJL0vxRppVQ81jKlW1dB3Bf4czkbXxXS9JL5Wcvn/T3qIXh
         /DDOMyoyia7izCKZPqXE6U0ioDGbAxsHckPUFyjboUWhy59R2YUL6MWBsvQeMKaCGdd4
         iCFmSRvIqSPu7WxmPNzYLKIk2grGy4Z8fKpoPRFl0t5P7OzND4qYdBavKnQo/ZHVTSr5
         7alVw2d1Yz86QW7J4EQ9AQikb0U8+aTGJh1aCybS9+WGbTHfbtOrPy9i+KD4voJHLZfA
         s6w8CWtZxYY5ymgOmrh9PXT2khwBPuVa6wb0TodQV8lv/Wt55tZfmGZkbg4D/uUp7KVF
         W7+Q==
X-Gm-Message-State: AC+VfDxypn10pawsSa+SlXhtLRvqwTPP98IOq7z/wWsMBlPSNrO/6JP2
        PAzWVsDvRX1G68+cFhbSJaU=
X-Google-Smtp-Source: ACHHUZ4HeWmGVGFx7OMU9ZOBfc/Se1Y5iJxNmqCjeA5K19hlc/t6bimDmgA5kurEl1yEDYCzftDhxA==
X-Received: by 2002:a17:90b:3ec2:b0:253:3d30:e6f9 with SMTP id rm2-20020a17090b3ec200b002533d30e6f9mr468323pjb.15.1684960635261;
        Wed, 24 May 2023 13:37:15 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id a7-20020a17090a70c700b002535dc42bb5sm1690122pjm.47.2023.05.24.13.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 13:37:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>,
        Santosh Y <santoshsy@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH v3 2/4] scsi: ufs: Fix handling of lrbp->cmd
Date:   Wed, 24 May 2023 13:36:20 -0700
Message-ID: <20230524203659.1394307-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230524203659.1394307-1-bvanassche@acm.org>
References: <20230524203659.1394307-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufshcd.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dc4b047db27e..3a7598120d23 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2931,7 +2931,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		(hba->clk_gating.state != CLKS_ON));
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
@@ -2947,7 +2946,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
-		lrbp->cmd = NULL;
 		ufshcd_release(hba);
 		goto out;
 	}
@@ -3166,7 +3164,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
+	lrbp->cmd = NULL;
 	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
 	if (unlikely(err))
 		goto out;
@@ -5408,7 +5406,6 @@ static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
 	struct scsi_cmnd *cmd = lrbp->cmd;
 
 	scsi_dma_unmap(cmd);
-	lrbp->cmd = NULL;	/* Mark the command as completed. */
 	ufshcd_release(hba);
 	ufshcd_clk_scaling_update_busy(hba);
 }
@@ -7023,7 +7020,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0;
@@ -7195,7 +7191,6 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
-	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = UFS_UPIU_RPMB_WLUN;
