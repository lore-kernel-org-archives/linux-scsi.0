Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70098C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349427AbiDLSVt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243571AbiDLSVs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:21:48 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C53E255A7
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:28 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id t4so18010734pgc.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vAvAdPiV+CMBL3q1ZKpWhCqvgC6GS7287yjxaluRU7M=;
        b=kwDWRIXAidZWOVo6/v2rRo7rMGivDgGRtKpU53HY8rIUwJLYLG7FAeQRqjfjTZ6GCv
         NgbD95XGOKbQ7tG/NGngwzQ3GCBPAv3FFB/vsa6eXSRwg1fjsIRYwFEozJ/lFrmQDID2
         bGpD/sjsHxM/FwMwvywHEP9seQKHUv5UW6BiP49+6ht9Yt7lEcl/tTaXq53mNCUS7v8D
         3XcP8129c9XMCpIuwfX5fA4bxnGvY0kq0znKNRpWAi0sysRBX/EO9B9aSr6Bf6OzDpsu
         UG3gzY0Ex1bXN5MtNK+3gZvYLX9DWomGMNXiZueHIE/VQ4B2D7C3Py5cmqo6VyiucF0U
         so3g==
X-Gm-Message-State: AOAM5320XjvjdafBj+GUzkVUnWETYiU0gxobAIteMQJ8pWb4oH50XDLz
        0XDthBghyif8xJ/jTUhAvVM=
X-Google-Smtp-Source: ABdhPJyeH07tUePgKg8Hp21Q0UYisraFxv2z6zYe7ZDIN34AymCMNfScnApC/G7OEblrmvGcYVm2cw==
X-Received: by 2002:a05:6a00:1490:b0:4fb:1544:bc60 with SMTP id v16-20020a056a00149000b004fb1544bc60mr5817460pfu.73.1649787568021;
        Tue, 12 Apr 2022 11:19:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:19:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Ye Bin <yebin10@huawei.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 03/29] scsi: ufs: Remove superfluous boolean conversions
Date:   Tue, 12 Apr 2022 11:18:27 -0700
Message-Id: <20220412181853.3715080-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove "? true : false" if the preceding expression yields a boolean or if
the result of the expression is assigned to a boolean since in these two
cases the "? true : false" part is superfluous.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 3 +--
 drivers/scsi/ufs/ufshcd.c   | 9 ++++-----
 drivers/scsi/ufs/ufshcd.h   | 2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 0d2e950d0865..808b677f6083 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -299,8 +299,7 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct phy *phy = host->generic_phy;
 	int ret = 0;
-	bool is_rate_B = (UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B)
-							? true : false;
+	bool is_rate_B = UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B;
 
 	/* Reset UFS Host Controller and PHY */
 	ret = ufs_qcom_host_reset(hba);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dbf50b50870b..983fac14b7cd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -712,8 +712,7 @@ static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
  */
 static inline bool ufshcd_is_device_present(struct ufs_hba *hba)
 {
-	return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
-						DEVICE_PRESENT) ? true : false;
+	return ufshcd_readl(hba, REG_CONTROLLER_STATUS) & DEVICE_PRESENT;
 }
 
 /**
@@ -840,7 +839,7 @@ ufshcd_get_rsp_upiu_data_seg_len(struct utp_upiu_rsp *ucd_rsp_ptr)
 static inline bool ufshcd_is_exception_event(struct utp_upiu_rsp *ucd_rsp_ptr)
 {
 	return be32_to_cpu(ucd_rsp_ptr->header.dword_2) &
-			MASK_RSP_EXCEPTION_EVENT ? true : false;
+			MASK_RSP_EXCEPTION_EVENT;
 }
 
 /**
@@ -1350,7 +1349,7 @@ static int ufshcd_devfreq_target(struct device *dev,
 	}
 
 	/* Decide based on the rounded-off frequency and update */
-	scale_up = (*freq == clki->max_freq) ? true : false;
+	scale_up = *freq == clki->max_freq;
 	if (!scale_up)
 		*freq = clki->min_freq;
 	/* Update the frequency */
@@ -2800,7 +2799,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
-	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
+	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba);
 
 	ufshcd_prepare_lrbp_crypto(scsi_cmd_to_rq(cmd), lrbp);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 949427714d0e..b2740b51a546 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -985,7 +985,7 @@ static inline bool ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
 
 static inline bool ufshcd_is_auto_hibern8_enabled(struct ufs_hba *hba)
 {
-	return FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) ? true : false;
+	return FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit);
 }
 
 static inline bool ufshcd_is_wb_allowed(struct ufs_hba *hba)
