Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA803C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352479AbiDSXBP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347208AbiDSXBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:12 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE55738BDB
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:28 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id e62-20020a17090a6fc400b001d2cd8e9b0aso190348pjk.5
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jLPy4g/P6lPqKcu5Q8el2I29IYha8Epe6ejgyk2dfiA=;
        b=ZWCbmIrUn/XzutGCR8l5xpqBj7rgaJ4VpwNdk4FdXuvDFR/rcSqYJ3e9UVdQUFOA3L
         7micgxhyHfCugpJDp9IxuiH/sHJAwuGgo9atzC7+XUbzVaVDZIHM+hb2o/nEzCjq5t1m
         26z8/wKt7Thj3fp4KZ9cEnL9UoSQQapvHSC5TXUAHeHQnCy4PU+pbWQMyE1PYJug066T
         bQmV2N0RpIoJEmVGS2Wfu0J3ahycnw6L+k4Y4esqjdoEBA8b9NuQbexJD0B0pQ2VVp0a
         MRi/hbHYFaufBytFbMqb3a6HsrwbBXYrEsyoCFXTnuZIw9MBQ8FTHeROSpFTyzF+um7j
         QFEA==
X-Gm-Message-State: AOAM530JedwV8a19BbsJC5PVz3sJQK/VOkLPm7P8Wp6q3Pl3GRkez2Ml
        HP2l774m6SkGeBzvseUpccQ=
X-Google-Smtp-Source: ABdhPJx4jD2yLe1/tNRgh8BEuuCAiM/raMV7iS80qQffg/xAdjd6DNJDamJYx/DUlLUaH6wqLxn2yQ==
X-Received: by 2002:a17:902:9b98:b0:156:52b1:b100 with SMTP id y24-20020a1709029b9800b0015652b1b100mr17662280plp.174.1650409108196;
        Tue, 19 Apr 2022 15:58:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 05/28] scsi: ufs: Remove ufshcd_lrb.sense_bufflen
Date:   Tue, 19 Apr 2022 15:57:48 -0700
Message-Id: <20220419225811.4127248-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_lrb.sense_bufflen is set but never read. Hence remove this struct
member.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Keoseong Park <keosung.park@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ---
 drivers/scsi/ufs/ufshcd.h | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c60519372b3b..e52e86b0b7a3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2789,7 +2789,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
-	lrbp->sense_bufflen = UFS_SENSE_SIZE;
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
@@ -2830,7 +2829,6 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int tag)
 {
 	lrbp->cmd = NULL;
-	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
@@ -6802,7 +6800,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
-	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b2740b51a546..b6162b208d99 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -182,7 +182,6 @@ struct ufs_pm_lvl_states {
  * @ucd_req_dma_addr: UPIU request dma address for debug
  * @cmd: pointer to SCSI command
  * @sense_buffer: pointer to sense buffer address of the SCSI command
- * @sense_bufflen: Length of the sense buffer
  * @scsi_status: SCSI status of the command
  * @command_type: SCSI, UFS, Query.
  * @task_tag: Task tag of the command
@@ -207,7 +206,6 @@ struct ufshcd_lrb {
 
 	struct scsi_cmnd *cmd;
 	u8 *sense_buffer;
-	unsigned int sense_bufflen;
 	int scsi_status;
 
 	int command_type;
