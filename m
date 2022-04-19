Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B013C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358406AbiDSXCC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358393AbiDSXBr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:47 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363FD38BDA
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:03 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id bo5so197590pfb.4
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J/MJzNqvlCtUnHD68INLBgpjwK6/TYRS8vbqLhrtU/k=;
        b=CxnMuAjGzvvYv+KXye/gA6VE/7/tFxTWytSwyyncr8x8Dy3gIrXTXoTMdBMdst1vHd
         vVf8j9IS33frRcbrXOgKo1Pe7wvGNaCFDervhYgGclW0+FqshSFsS9vhgbmBSQ41dls9
         TxnRsWjUZZ0IExhX6gIZudfd92a7/H+sQVPaQCA0uUmuDK9/rOCrJmmiXXpUU3RE1g0f
         3QOj+q1HrQGSjq03f2boBc1kASPSLYwLPeUzg7fei28qdhJW4UGF0KpflGCjY+AKbUdo
         lujJVUM2ZZ7eLlFC6xPCPsqZkBxVIaAJYk8PMkJDkndkzVvGQuLqxAOqpAd0U33WC+Xb
         AVtA==
X-Gm-Message-State: AOAM532ror8dNwDwWO7PCKCZZCUmJGVIL7mRHoa3H+ugOihb/f2WOEhx
        PrPptZHk70lrj1Yl5VnW6Ak=
X-Google-Smtp-Source: ABdhPJzWfrlvR38NSuTDb2X9yy4znY8iswxACuu+stwub4pxc1b0kKuQiYtb6dDJ8nUPiAx0wbT8Dw==
X-Received: by 2002:a65:52cc:0:b0:3a9:fd44:1d7 with SMTP id z12-20020a6552cc000000b003a9fd4401d7mr10469548pgp.211.1650409142629;
        Tue, 19 Apr 2022 15:59:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:59:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v3 22/28] scsi: ufs: qcom: Fix ufs_qcom_resume()
Date:   Tue, 19 Apr 2022 15:58:05 -0700
Message-Id: <20220419225811.4127248-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clearing hba->is_sys_suspended if ufs_qcom_resume() succeeds is wrong. That
variable must only be cleared if all actions involved in a resume succeed.
Hence remove the statement that clears hba->is_sys_suspended from
ufs_qcom_resume().

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 81c0fc51b7a7 ("ufs-qcom: add support for Qualcomm Technologies Inc platforms")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index dded29722880..98ed9e9f7e2e 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -640,12 +640,7 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			return err;
 	}
 
-	err = ufs_qcom_ice_resume(host);
-	if (err)
-		return err;
-
-	hba->is_sys_suspended = false;
-	return 0;
+	return ufs_qcom_ice_resume(host);
 }
 
 static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
