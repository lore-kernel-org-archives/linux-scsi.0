Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D1DEB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjGXU2A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjGXU15 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:27:57 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B7712C
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:27:56 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-666ed230c81so4532957b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:27:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230476; x=1690835276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2D1xHoKfalDYWBUfepMx6KObMJsgfk41H0uALlZS5/o=;
        b=O+vqIx4VlC/uaDyDCvTdORDD/axDGCncFO+j579SpyM0b2OaE927auCzLDlaPPlUHk
         qYeOgy85gWKwyBgRS7trpzs/4Ixcb/Xj4YJzASJNPyP7ov+lCd7rvV/TSnHriOu98k43
         Uwn+XcxAU2Y2AbCLbvNoDY8/6le0iJbPxO1NOojJ3ySSDc1p6KmjHXwDJucWqzmu9InA
         QZU/iy87gDJn3mDvc7vvpi/TOmKC93e4bQPPEJT64qPvil6v6Yp+agyGPX4AOhvQAMrp
         k3MySt0e23XAMZZqxHVAwPReAqkWx8rKZdKfUOZL0HKjO0azFBwQihdJi2AJHzOBWpWM
         etbQ==
X-Gm-Message-State: ABy/qLYUGqTg3o7zT5aud2Ic43f2hQ6VEh1/Kpflp8muNG429lI89+OU
        w2/Y8gTty1NSFeEg6I24M+k=
X-Google-Smtp-Source: APBJJlG2YWYERIjGw5zu0Qt7vv7IZUBU4xwVM6eXgbnjJVt7stOrCJ41Pi0e6el6oLHzcDK55lT35w==
X-Received: by 2002:a05:6a20:190:b0:133:215e:746d with SMTP id 16-20020a056a20019000b00133215e746dmr12704110pzy.41.1690230476185;
        Mon, 24 Jul 2023 13:27:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:27:55 -0700 (PDT)
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
Subject: [PATCH 08/12] scsi: ufs: Remove a local variable from ufshcd_abort_all()
Date:   Mon, 24 Jul 2023 13:16:43 -0700
Message-ID: <20230724202024.3379114-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724202024.3379114-1-bvanassche@acm.org>
References: <20230724202024.3379114-1-bvanassche@acm.org>
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
