Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DBFC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38D0261B27
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhKSUBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:45 -0500
Received: from mail-pl1-f178.google.com ([209.85.214.178]:41889 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbhKSUBd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:33 -0500
Received: by mail-pl1-f178.google.com with SMTP id k4so8904268plx.8
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gr9lk7OLlGH/9s2+Hsph1AE6NAJoOz+DZ7zixmjW1pY=;
        b=08PMgqIWe6kHkXEPVKgyGIslMoIAWahLZNssIjlU9C3avVBHp0RdgBVT5LKdLG7uae
         ttbqMS4fwB1JCyBqBDnj14ZYVraR4wz+YMgq5A0Jm1EFD3DGIdyj1qX1M6DGPuKO9YA2
         A+TX4xlBMN2uzhmeDHmBtFKoBHN5Nzci76su+hiEGdU7YIijlRgMf95bKgGzQu2L2LHl
         cbqMYtlychB26IXHlLsuNrXUof2S/HXxPTX+JKYWUBkZNHg0eNmle+E/NVlTsl9PfQjd
         ZQ5ZmQz064zJy6kKxjNltMols4LNaMRHuWX/SBFqaq4GlM8AKH+s/cOj1V2N6cKBLuZ0
         /qAg==
X-Gm-Message-State: AOAM531P6X0yoq+HMVT50ZmFlNWtcuSu+pDL+Bnvb74aL5G/QkGaAjhN
        NlOw0H+UoQQiYKDC/ilyuzs=
X-Google-Smtp-Source: ABdhPJxUILoNmZe1ggAiCmcpRhASHIGBwnOILtmM2sQoKxsjfCdIjyzJmKGdDOFLz2ElmfcMe8wZdw==
X-Received: by 2002:a17:903:41c1:b0:141:f28f:729e with SMTP id u1-20020a17090341c100b00141f28f729emr79180673ple.34.1637351910757;
        Fri, 19 Nov 2021 11:58:30 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:30 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 14/20] scsi: ufs: Introduce ufshcd_release_scsi_cmd()
Date:   Fri, 19 Nov 2021 11:57:37 -0800
Message-Id: <20211119195743.2817-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The only functional change in this patch is that scsi_done() is now called
after ufshcd_release() and ufshcd_clk_scaling_update_busy().

The next patch in this series will introduce a call to
ufshcd_release_scsi_cmd() in the abort handler.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 03f4772fc2e2..39dcf997a638 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5248,6 +5248,18 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
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
@@ -5258,9 +5270,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
-	int result;
 	int index;
-	bool update_scaling = false;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
@@ -5270,26 +5280,19 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
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
-			update_scaling = true;
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			if (hba->dev_cmd.complete) {
 				ufshcd_add_command_trace(hba, index,
 							 UFS_DEV_COMP);
 				complete(hba->dev_cmd.complete);
-				update_scaling = true;
+				ufshcd_clk_scaling_update_busy(hba);
 			}
 		}
-		if (update_scaling)
-			ufshcd_clk_scaling_update_busy(hba);
 	}
 }
 
