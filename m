Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609D2C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242174AbiCaWhG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiCaWhE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:37:04 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536841C8A8E
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:17 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id y6so894202plg.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HiW2AyQg3ym/s5oidqTt2YvgjHcpPGM+vkm/7uiHDAM=;
        b=Q6W60Algh0B3uIJNbuOCfd3Ekj+AzinZpUUgV6Tg8z66bzpqmkBf8cMqkyat2ohN8j
         dDFdB4fOTVZYoPLDZriNLG8AuOQvL8a8dg9QssRWPYf6luUrCs0CPFfaeAKzC0z9Y+I4
         dkWcDkyuVVxq/KmcTweLSXJFf5rSZw/yoD3X68pdmX+ZmTt8xbPC5CcWRye678JeTXq2
         5vhOIveOY0nGwItYQ/1jSVz6Eg6ZlhY4la87sZlltIQ10vOOrdbBTEfpSciZYLq6o3kv
         QaBJQoFhiLxybJgECabSZNkk/DVd5QAMJoojJ4qopLMEeDRUShPERLWz/w30nZdoLs2A
         29KQ==
X-Gm-Message-State: AOAM530JqKzWRVlKWX06+XPmMre2sj63+De0DhAj7tS9l4n2/JZ2YZt2
        TfSAro0XIOr/l0ltHJYsmBE=
X-Google-Smtp-Source: ABdhPJxO+9iFQgzfmUgb7g1fovKL4G/1GMgEaANMjQogmt/7MMo6NCmqcujeIwutiGzC702J8U9FWA==
X-Received: by 2002:a17:90b:1e04:b0:1c6:fbac:b0e2 with SMTP id pg4-20020a17090b1e0400b001c6fbacb0e2mr8483068pjb.207.1648766116768;
        Thu, 31 Mar 2022 15:35:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:35:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 04/29] scsi: ufs: Remove ufshcd_lrb.sense_bufflen
Date:   Thu, 31 Mar 2022 15:33:59 -0700
Message-Id: <20220331223424.1054715-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_lrb.sense_bufflen is set but never read. Hence remove this struct
member.

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
