Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FDFEB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 19:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjG0Trt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjG0Trs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 15:47:48 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48FAE73
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:47:47 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-686bc261111so1078997b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:47:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690487267; x=1691092067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1+muOaKlEtIiuKOybV1kcrb5SLO800kVpmFQnxaOW8U=;
        b=cP0oft4RHtQrN7cl9khWitC+NsjB1/8G96U3KXENHG7CWYiPLLur8rKv/v/fsJlQy/
         NUlJhO9K0k39YUn4DZH7DFWxP0WSQQLJgI0xsSbQaDsdfq58B+jJtx5jI6JHuJHdIzKU
         fVvnQWmyG07rZkYMH/nfctIDA4CT96PRlBKpJgKPZZCcEdESNYs41UPLcTZVNcyyg/Vm
         LxvQVWggSGQAyS+/WN0pEbdYiCuhL3CQ9SmybgahqutNQ/wOokhEev0PikmWfXRC3/71
         eKLWYcpy5VV73K9Gjryeb8/68XSxD0Pl616z3SEHLxfqBMJCtJhlO6gXjmzZAhG81jZ0
         AsSA==
X-Gm-Message-State: ABy/qLYy4MleRr+thJaozsXa0/TY6drjiOpl3Ej+H0ek6rJtnW76GoYA
        vQheLX7rAnzUzCx3d+Xcv0T7LGh39NE=
X-Google-Smtp-Source: APBJJlE5KUlQ/53jsMPA56VWYMorI2H7SpDEmGM4ZOs/JKsnGKrFcGWJ0fM8q4o50i+CTC6p70gJnA==
X-Received: by 2002:a05:6a00:1684:b0:687:570:5011 with SMTP id k4-20020a056a00168400b0068705705011mr132351pfc.24.1690487267317;
        Thu, 27 Jul 2023 12:47:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:607:27ba:91cb:68ee])
        by smtp.gmail.com with ESMTPSA id 35-20020a630b23000000b00551df489590sm1879203pgl.12.2023.07.27.12.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 12:47:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v2 09/12] scsi: ufs: Simplify ufshcd_abort_all()
Date:   Thu, 27 Jul 2023 12:41:21 -0700
Message-ID: <20230727194457.3152309-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org>
References: <20230727194457.3152309-1-bvanassche@acm.org>
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
