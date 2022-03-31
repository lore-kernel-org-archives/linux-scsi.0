Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5100C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242516AbiCaWhQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242522AbiCaWhP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:37:15 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9181C8A8E
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:27 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id y10so917868pfa.7
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yq/Wr3ZUs+deSjtUgLCt5NOJQZY5v0ynROMTARR4zb0=;
        b=cfUvbbqa9Z0nhsrGpu4I+o09/INBmu7cIRznePaUIvK9GCbydmlnJTAlckPkzmAq1s
         JMRXnylWWoWXdTmU1FNpdT5hZMbjbh7E/w3Kt6+Y6FESE4StttSV4VKgrvpMNW0kBYpc
         bIMwTHySuThLvjDBsODKhPs/6bo7AI8fiPIjlDES8lAQG+gtdzvXiPmgIyw+x+XL7VtO
         /J/B8zbGMgU9M287Ltq18YZaqji+cTEqPYvSWNNnwTtx0QeIYOHGEUmdaykr/BZBESR+
         kAsAmoD49yuwaflbNz+COgVxMRqi/cNt+wg23QW6dpV1bcrYpLypWsIrnKATH2PMnDhw
         XxBA==
X-Gm-Message-State: AOAM532UG4OPrSFoAuEmwSKMLFYX917zuXbRkGflv+I0tAKHpE9n2iTq
        blndkfeP/2e+VmOFXQrJOCs=
X-Google-Smtp-Source: ABdhPJyvGznMgu5swFjnRyvwDHK4RwEQmrHO7FOqPOBaHIxPxNULH6fbrnnCA/CyT5BA8/dsGY8vPQ==
X-Received: by 2002:a63:35c3:0:b0:380:6a04:cecc with SMTP id c186-20020a6335c3000000b003806a04ceccmr12636343pga.455.1648766126431;
        Thu, 31 Mar 2022 15:35:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:35:25 -0700 (PDT)
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
Subject: [PATCH 05/29] scsi: ufs: Remove ufshcd_lrb.sense_buffer
Date:   Thu, 31 Mar 2022 15:34:00 -0700
Message-Id: <20220331223424.1054715-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_lrb.sense_buffer is NULL if ufshcd_lrb.cmd is NULL and
ufshcd_lrb.sense_buffer points at cmd->sense_buffer if ufshcd_lrb.cmd
is set. In other words, the ufshcd_lrb.sense_buffer member is identical
to cmd->sense_buffer. Hence this patch that removes the
ufshcd_lrb.sense_buffer structure member.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++-----
 drivers/scsi/ufs/ufshcd.h | 2 --
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e52e86b0b7a3..eddaa57b6aad 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2127,15 +2127,17 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
  */
 static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 {
+	u8 *sense_buffer = lrbp->cmd ? lrbp->cmd->sense_buffer : NULL;
 	int len;
-	if (lrbp->sense_buffer &&
+
+	if (sense_buffer &&
 	    ufshcd_get_rsp_upiu_data_seg_len(lrbp->ucd_rsp_ptr)) {
 		int len_to_copy;
 
 		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sr.sense_data_len);
 		len_to_copy = min_t(int, UFS_SENSE_SIZE, len);
 
-		memcpy(lrbp->sense_buffer, lrbp->ucd_rsp_ptr->sr.sense_data,
+		memcpy(sense_buffer, lrbp->ucd_rsp_ptr->sr.sense_data,
 		       len_to_copy);
 	}
 }
@@ -2789,7 +2791,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = cmd;
-	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba);
@@ -2829,7 +2830,6 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 		struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int tag)
 {
 	lrbp->cmd = NULL;
-	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
@@ -6800,7 +6800,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
 	lrbp->cmd = NULL;
-	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0;
 	lrbp->intr_cmd = true;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b6162b208d99..b9f17219ca18 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -181,7 +181,6 @@ struct ufs_pm_lvl_states {
  * @ucd_rsp_dma_addr: UPIU response dma address for debug
  * @ucd_req_dma_addr: UPIU request dma address for debug
  * @cmd: pointer to SCSI command
- * @sense_buffer: pointer to sense buffer address of the SCSI command
  * @scsi_status: SCSI status of the command
  * @command_type: SCSI, UFS, Query.
  * @task_tag: Task tag of the command
@@ -205,7 +204,6 @@ struct ufshcd_lrb {
 	dma_addr_t ucd_prdt_dma_addr;
 
 	struct scsi_cmnd *cmd;
-	u8 *sense_buffer;
 	int scsi_status;
 
 	int command_type;
