Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01938C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383433AbhLCXYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:24:47 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:38757 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383432AbhLCXYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:24:46 -0500
Received: by mail-pj1-f47.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so6310584pju.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:21:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OfYIjYMvSESmJftxJGkLriH/+C/5Xhx2gxHA+6duJzg=;
        b=NqstqAibXdm6rIVJ7M3MihwuVRAD4JYhg/q1Dh6F+0uf4j0LT3KEzElIuLHAg2vhI/
         iwDg/nQrk8D4rp7OMCGPxjyLbxZRnLTViqFUIfHLQY+f2jDAe73T/yOyDpEwtt/1adja
         sGyAuLvpYe2lvyDIZDDfd8ElBC9xUsiS3WJKiPdwL6AOld4Pf4EkgwyIGfZtfc8puFvj
         xx5/8ljxWi9u4Bl4USSrOsdPltyhjoHAVy3ODlK3Ptjot3FydZ9F55h5FwC5tPB8g92T
         Jr8Xy+f2OGeIVzG9gHvFfwBUppnvZeqSqu9qw4NQ4ky19sLomH4RHCgerENdTpIECpl2
         Lw8Q==
X-Gm-Message-State: AOAM530IO8vOMs6EMkrVj+RDE+Z8afTHF7mEljdy1fqWIEdMMQdIjNhH
        zTncsjyWDBD+cuLsakXobKg=
X-Google-Smtp-Source: ABdhPJxZ+Ij/AunIYHYd2SoWWZY71qCvwq/uKp2T7MRnxKlYpS1CkcELWfvAB6Q6mRaK06iPSYxdYA==
X-Received: by 2002:a17:90a:1919:: with SMTP id 25mr18012540pjg.154.1638573681851;
        Fri, 03 Dec 2021 15:21:21 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:21:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v4 12/17] scsi: ufs: Introduce ufshcd_release_scsi_cmd()
Date:   Fri,  3 Dec 2021 15:19:45 -0800
Message-Id: <20211203231950.193369-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
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

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 27574aef5374..5a641610dd74 100644
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
