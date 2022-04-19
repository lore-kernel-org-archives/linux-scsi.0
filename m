Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFACC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358370AbiDSXBU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347267AbiDSXBO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:14 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F243387A7
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:30 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id j8so84286pll.11
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6yPV4+N1twKu/2lNcbRy4894tcz7EpVJPYAfwszUkss=;
        b=fDt+ynWbNmIRz05AbhV7x22mPRiQt/Z4o0dNbJ0gBFVXvGurMyogC0kk/0F+nYiHDW
         g2kLkq33nOwCiKxJ9TGCS2T5Vje7qWBe2KoPd53Oa9iTYvgxwDJtF3EuJ0svUBkbNVWP
         uvq4AFZEK6Fpoj9YQu27uv0Y5u4w7uSfUxgPK2/bAp61pVsp3RT4jPfUTyX4fVESJ9PX
         QrcsAs/JZsh91HKVTiHOQyR3qrYI9J4ptDeqx48ovWkzW0Cbazeho6sLCTzIBBrEpiEz
         NALjcBylJHcGikitLq7V5Av4RZCsDVoIh+4Tl8t6SAB46ZG8Kt2duVffPWPsB+D58NdM
         q1Sg==
X-Gm-Message-State: AOAM530ER+u9rZxSLStzf2IUrw+xWjP8c+GsNIBlUh3l7EYa3TsyxW9u
        JasarSCYr5Tbrqg5RT83H5U=
X-Google-Smtp-Source: ABdhPJzBFOLpW6lMEZR81DrRZZyZuIDB0hL2+vuCMLcl9/KV0fpP9Splp5fzpBTvmLpKv2FUx7OwdA==
X-Received: by 2002:a17:902:8496:b0:158:a8e0:516b with SMTP id c22-20020a170902849600b00158a8e0516bmr17992994plo.4.1650409109919;
        Tue, 19 Apr 2022 15:58:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 06/28] scsi: ufs: Remove ufshcd_lrb.sense_buffer
Date:   Tue, 19 Apr 2022 15:57:49 -0700
Message-Id: <20220419225811.4127248-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
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

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++-----
 drivers/scsi/ufs/ufshcd.h | 2 --
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e52e86b0b7a3..d4ef31e1a409 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2127,15 +2127,17 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
  */
 static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 {
+	u8 *const sense_buffer = lrbp->cmd->sense_buffer;
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
