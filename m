Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B5FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358680AbiDLSWO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358674AbiDLSWN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:22:13 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8A737001
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:54 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id g12-20020a17090a640c00b001cb59d7a57cso2348159pjj.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jLPy4g/P6lPqKcu5Q8el2I29IYha8Epe6ejgyk2dfiA=;
        b=icXpX0ETWmobSheO9Fz+bAZ8CTMRTtibzoLuWaFm8RKNAVW3Z8Y2yvf8nDxrI3t+se
         y/G3VoVS4fm1+JEpOAqRrsn0F17CXJFMXkq7i/QkgZt/WWxtZQA51eVBYJNrtKCngg0G
         S8P54GUUe3Fn/kGCaVRG67hesAbL6LNwnbSx83Aa1S/FbTAQOyKqpyIwaZe7XA/iDEZX
         fIGgkqK6GexJPX9DxVxVl8pE2iRCh6omeYKQmBzavKnBLOCJDfMdayQsX0dBEadtHQGu
         i4PmGum0UvEl/3uP0Ptp3Jj0kPbQGa334vtAhHPy6YkUHcsI6CG567KJ//mpJt1l1hNt
         E0MA==
X-Gm-Message-State: AOAM533FjRieMsT7pXbs+BpouSnl78ypc0n1HeK58f/Wp18y6kosBBXl
        Bs+1Tk6w+B1CR1Gkafbtz+k=
X-Google-Smtp-Source: ABdhPJxcLN5v0ifN5Hf+HuHdxhCUUvkSZ/pD3s152H+DbFgoTEa7WOgB4AP1WgL4zn1QbWyP68Sq1A==
X-Received: by 2002:a17:90b:4b46:b0:1cb:6edf:27f1 with SMTP id mi6-20020a17090b4b4600b001cb6edf27f1mr6385152pjb.173.1649787593653;
        Tue, 12 Apr 2022 11:19:53 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:19:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 05/29] scsi: ufs: Remove ufshcd_lrb.sense_bufflen
Date:   Tue, 12 Apr 2022 11:18:29 -0700
Message-Id: <20220412181853.3715080-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
