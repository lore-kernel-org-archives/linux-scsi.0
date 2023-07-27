Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4A4EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 19:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjG0Trl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjG0Trj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 15:47:39 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C750273C
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:47:39 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-686f090310dso1232537b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690487259; x=1691092059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2D1xHoKfalDYWBUfepMx6KObMJsgfk41H0uALlZS5/o=;
        b=joTU4o++rn+ar4bsZe3BEcybEQZHelf5SU26Y/njW+T/FTB76dKZb1WhDbYbgvCMnU
         jENofWkLC4CZgX3FBXZKOy/tk8XS6vwujIgslyABMGcxY/xWkYOb3Q2bwBF0KNJMOAq1
         2xu5rpITTMpeB7ro0/KgBVL+YXIoWjiiCIyIZpL6NIjawmLLixetUnoVqtTOX48H2j+l
         B2R7YxqER04xkgey6wr/eS3n6iFsP4+cSa09d7mGxUCSgVSvu48+PdMlaY8KxFCVs9eO
         xjAShqWnpu2I3B5qWeBtFaxSPlG2q4bmrVXvvoU0sfwWEYD8jCPnAulLb/WeeW9hAPdn
         ccrA==
X-Gm-Message-State: ABy/qLajRD0JmsIgk7/qztcavUj+4UMN6I2pFFg1ZIi9AI6QjZh6aWas
        uyNCzzN9LW5tNkog2ALRGCY=
X-Google-Smtp-Source: APBJJlHZArv0vbPJclbgCBj7YeKI4C4SA6iu+JyhwsMqJlPCgHeDE7FXNGxyLg5eVY27+ecKcWwAGQ==
X-Received: by 2002:a05:6a21:66c9:b0:133:f0b9:856d with SMTP id ze9-20020a056a2166c900b00133f0b9856dmr67163pzb.17.1690487258649;
        Thu, 27 Jul 2023 12:47:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:607:27ba:91cb:68ee])
        by smtp.gmail.com with ESMTPSA id 35-20020a630b23000000b00551df489590sm1879203pgl.12.2023.07.27.12.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 12:47:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v2 08/12] scsi: ufs: Remove a local variable from ufshcd_abort_all()
Date:   Thu, 27 Jul 2023 12:41:20 -0700
Message-ID: <20230727194457.3152309-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org>
References: <20230727194457.3152309-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No functionality is changed. This patch prepares for unifying the MCQ
and legacy code paths in this function.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 19c210ef74f5..c0031cf8855c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6387,9 +6387,14 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
 	return false;
 }
 
+/**
+ * ufshcd_abort_all - Abort all pending commands.
+ * @hba: Host bus adapter pointer.
+ *
+ * Return: true if and only if the host controller needs to be reset.
+ */
 static bool ufshcd_abort_all(struct ufs_hba *hba)
 {
-	bool needs_reset = false;
 	int tag, ret;
 
 	if (is_mcq_enabled(hba)) {
@@ -6404,10 +6409,8 @@ static bool ufshcd_abort_all(struct ufs_hba *hba)
 			dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
 				hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
 				ret ? "failed" : "succeeded");
-			if (ret) {
-				needs_reset = true;
+			if (ret)
 				goto out;
-			}
 		}
 	} else {
 		/* Clear pending transfer requests */
@@ -6416,25 +6419,22 @@ static bool ufshcd_abort_all(struct ufs_hba *hba)
 			dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
 				hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
 				ret ? "failed" : "succeeded");
-			if (ret) {
-				needs_reset = true;
+			if (ret)
 				goto out;
-			}
 		}
 	}
 	/* Clear pending task management requests */
 	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
-		if (ufshcd_clear_tm_cmd(hba, tag)) {
-			needs_reset = true;
+		ret = ufshcd_clear_tm_cmd(hba, tag);
+		if (ret)
 			goto out;
-		}
 	}
 
 out:
 	/* Complete the requests that are cleared by s/w */
 	ufshcd_complete_requests(hba, false);
 
-	return needs_reset;
+	return ret != 0;
 }
 
 /**
