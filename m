Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DE0EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjGXU2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjGXU2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:28:06 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D4112C
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:28:05 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6689430d803so2830470b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230485; x=1690835285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1+muOaKlEtIiuKOybV1kcrb5SLO800kVpmFQnxaOW8U=;
        b=eYLx7DtvNxUqBoUEugzMguO00P4T2zzbd/bgwPuAvb7rt8BzJ69OetURXtuv77GSz1
         ewLwfbK8fsf/ZZpeRbBSrqheBkg5ooljTDfOapbpsklUWuIlzyOJHkkYTxMt/e75pQ95
         7ASwLGY9C/YPft+YScFYtVLu0A0nFKt3aR9zzAGEK3yt8VSQYbfQd/bUeQe5OkOLbBVh
         KC6IwRS52cNKGZtuUcMAnUI+0WDQX3gEpRyVQZO3/uayvt+p+KwmS9lwc+E+exU4EExl
         bXasDJKEYeK5YQ5AgSliZijE1lPDy+euAodtv1dCR0gPN3o8sku7j8XWfCeE7vojUM+f
         R3pw==
X-Gm-Message-State: ABy/qLZUEu/KuDw+HsQqi4GKkK8CyoSjCWBcY0mKyRYT3IWgBxgDaYN3
        DowRGL5Gye+iQ46cYUIR0bY=
X-Google-Smtp-Source: APBJJlE2BrxNkVILf+ycM0+TjIfnMppEugnamIV9MrTloFoaKUoko3AyOCAPL7yvWPkLfwcL86LA5g==
X-Received: by 2002:a05:6a00:23c1:b0:682:5a68:5645 with SMTP id g1-20020a056a0023c100b006825a685645mr11367298pfc.11.1690230484905;
        Mon, 24 Jul 2023 13:28:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:28:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH 09/12] scsi: ufs: Simplify ufshcd_abort_all()
Date:   Mon, 24 Jul 2023 13:16:44 -0700
Message-ID: <20230724202024.3379114-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724202024.3379114-1-bvanassche@acm.org>
References: <20230724202024.3379114-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unify the MCQ and legacy code paths. This patch reworks code introduced by
commit ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode").

Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 46 +++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c0031cf8855c..bf76ea59ba6c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6387,6 +6387,22 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
 	return false;
 }
 
+static bool ufshcd_abort_one(struct request *rq, void *priv)
+{
+	int *ret = priv;
+	u32 tag = rq->tag;
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
+	struct ufs_hba *hba = shost_priv(shost);
+
+	*ret = ufshcd_try_to_abort_task(hba, tag);
+	dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
+		hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
+		*ret ? "failed" : "succeeded");
+	return *ret == 0;
+}
+
 /**
  * ufshcd_abort_all - Abort all pending commands.
  * @hba: Host bus adapter pointer.
@@ -6395,34 +6411,12 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
  */
 static bool ufshcd_abort_all(struct ufs_hba *hba)
 {
-	int tag, ret;
+	int tag, ret = 0;
 
-	if (is_mcq_enabled(hba)) {
-		struct ufshcd_lrb *lrbp;
-		int tag;
+	blk_mq_tagset_busy_iter(&hba->host->tag_set, ufshcd_abort_one, &ret);
+	if (ret)
+		goto out;
 
-		for (tag = 0; tag < hba->nutrs; tag++) {
-			lrbp = &hba->lrb[tag];
-			if (!ufshcd_cmd_inflight(lrbp->cmd))
-				continue;
-			ret = ufshcd_try_to_abort_task(hba, tag);
-			dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
-				hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
-				ret ? "failed" : "succeeded");
-			if (ret)
-				goto out;
-		}
-	} else {
-		/* Clear pending transfer requests */
-		for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
-			ret = ufshcd_try_to_abort_task(hba, tag);
-			dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
-				hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
-				ret ? "failed" : "succeeded");
-			if (ret)
-				goto out;
-		}
-	}
 	/* Clear pending task management requests */
 	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
 		ret = ufshcd_clear_tm_cmd(hba, tag);
