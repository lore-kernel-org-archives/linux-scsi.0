Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3525DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbhK3XiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:38:01 -0500
Received: from mail-pj1-f53.google.com ([209.85.216.53]:34462 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240990AbhK3Xh7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:37:59 -0500
Received: by mail-pj1-f53.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so14760837pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:34:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vDeLtFp+3z7D62tVexY/RvJu1DgY2LTjCyBZ7zIvdqI=;
        b=ypsK3NiXrZuSrtWLdtRtqvZPwdxHZTFxUSSJq4yjEVH9NnezFEHJwr2SPkS5utYgCP
         6pbovGOGQst3gGOxLKx2G/iExBW0tcJP4DTWfOztVcF5s/0jJTmAvqsj2OaepsRdtWiy
         bBVg/0aCVF5XLkH743TYMhTX781MX+n0Eizm9Sow4dJzIAKjqztmIQGhS5hyHQHY7cs2
         bzGTXJROc82bhq+he6NRIwFIPznB8VhktT5zW9jfLn7lYsR/aSySaWDVcU6l9oxCbOHf
         8TzUb+yn/DyC+xwXi6yjc9zp8NueTw1gh2xEsdOjHhI1Fa8TUuS+Sif5+UfidWzuilL0
         Olwg==
X-Gm-Message-State: AOAM530pGfmZM2jXIjNL1L84Zh1ulVURLqlrJnF5jRQpTN9QgSaLsu6g
        xHTq09cFCXT0MUrR/ZTVtCY=
X-Google-Smtp-Source: ABdhPJxUgdJ4HywbujqMKvQJS/BSSoyKUF0O9MXHBRro2XkEbgmPYCFuM/uTNzx5myh7keEood3m+A==
X-Received: by 2002:a17:90a:c58d:: with SMTP id l13mr2715902pjt.189.1638315279882;
        Tue, 30 Nov 2021 15:34:39 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:34:39 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 12/17] scsi: ufs: Introduce ufshcd_release_scsi_cmd()
Date:   Tue, 30 Nov 2021 15:33:19 -0800
Message-Id: <20211130233324.1402448-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The only functional change in this patch is that scsi_done() is now called
after ufshcd_release() and ufshcd_clk_scaling_update_busy() instead of
before.

The next patch in this series will introduce a call to
ufshcd_release_scsi_cmd() in the abort handler.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4e9755c060af..8703e4a70256 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5213,6 +5213,18 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 	return retval;
 }
 
+/* Release the resources allocated for processing a SCSI command. */
+static void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
+				    struct ufshcd_lrb *lrbp)
+{
+	struct scsi_cmnd *cmd = lrbp->cmd;
+
+	scsi_dma_unmap(cmd);
+	lrbp->cmd = NULL;	/* Mark the command as completed. */
+	ufshcd_release(hba);
+	ufshcd_clk_scaling_update_busy(hba);
+}
+
 /**
  * __ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
@@ -5223,7 +5235,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
-	int result;
 	int index;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
@@ -5234,15 +5245,10 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 				ufshcd_update_monitor(hba, lrbp);
 			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
-			result = ufshcd_transfer_rsp_status(hba, lrbp);
-			scsi_dma_unmap(cmd);
-			cmd->result = result;
-			/* Mark completed command as NULL in LRB */
-			lrbp->cmd = NULL;
+			cmd->result = ufshcd_transfer_rsp_status(hba, lrbp);
+			ufshcd_release_scsi_cmd(hba, lrbp);
 			/* Do not touch lrbp after scsi done */
 			scsi_done(cmd);
-			ufshcd_release(hba);
-			ufshcd_clk_scaling_update_busy(hba);
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			if (hba->dev_cmd.complete) {
