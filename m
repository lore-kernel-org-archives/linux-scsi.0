Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80DBC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352737AbiDLSWX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358682AbiDLSWW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:22:22 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3A93BF88
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:20:03 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id c23so17565172plo.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6GfqIOmo1kqFihHls2Z1VsQph6E/ifS15/w+btDWXlE=;
        b=gyxMjAwjYF3Diz7TsDrBf+ZBXe5DyZEnaS1avQkczWOG7w1N+cY7GDg3VNOvPrBZYQ
         YCQtb2qPD1RXkOQ1z9w0/3GVjRYkuNcG3obSrdiYNhOQ6gTxU5gThZ/kHF/+gOL1LtAw
         aFBW+93aZ0VKQZ7oWYsDJzLLNXf36aEGGZ+KZsHFS2w/3Noj+AcoQDy9WlfvuVzDzcrd
         CKAbTsUFDN/+8t5l7vjV0R0uAdNImA0FJo82Wb0S1OQnNQVlN01DVBhXZOvZ4LbJ9OgD
         Y8lkjovw+P9NVfJ6lIKe3VXTqVVnG9MQLIOSWui7MBZc/9n0HbM/5xD8TjRrByNZCRgd
         BZag==
X-Gm-Message-State: AOAM532CpWbeDYWwy2CvwL8f1PDIIF51LCChc6FFm+PZ9Dc4oesHniv3
        BAtivkBiLjZcaXi3dF2za9g=
X-Google-Smtp-Source: ABdhPJwhbdx6MOZTxhjGbS7qo0ioNRZ7I97H1aPT3BJNJfsiGLpG/AwEy4jSksG06aTBoBy4QNGqEQ==
X-Received: by 2002:a17:902:d48b:b0:158:558d:c58a with SMTP id c11-20020a170902d48b00b00158558dc58amr13267590plg.105.1649787602828;
        Tue, 12 Apr 2022 11:20:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:20:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 06/29] scsi: ufs: Remove ufshcd_lrb.sense_buffer
Date:   Tue, 12 Apr 2022 11:18:30 -0700
Message-Id: <20220412181853.3715080-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
