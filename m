Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F170EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242515AbiCaWgw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242520AbiCaWgt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:36:49 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A531EDA1E
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:01 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id s11so881329pfu.13
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y6M6ikwLXoNnW4QFjFmtiJbbtABf1/qScfJYDWRT9wk=;
        b=U1+LGzT2lpHDCnDwJcptG6dFsS1xFI/xNmm/xHknt4TfNa20yG63TNOXHUgQQSVN8D
         7ERWZAlymrstnSVQreN2vnK+sUEkMl/OWEf5QJASq+K4FgXZ+OfapcIjfnAsdhMCA4m6
         yF1wl66JJmS9wiWEBu74whuqyVR2yDXXs7IQkwS3uOBNEGpiYlG5DIyemTUO7+SqUiR0
         Oh3xbApG1YdhGkMCu6CCmqyyuL2vPSoGTQbkm5rIX3xCfS9TkIIO+PNmDZTZUwLF8vRP
         /N8RsBiqAL/jVHL7lZHmh5ksjNceVC/dN8/w62eKLp07dMocDl3RWBdS+OqNgDVDCr6W
         JvUA==
X-Gm-Message-State: AOAM530NovmfrBN5mRTUlnCWFpzD3pfuxN6pOG1Zm91zh64vhdFAKH1y
        hvWCLthovlbLKh8cy5tFA7Q=
X-Google-Smtp-Source: ABdhPJx5FamrOobfshCaUb+85OQeWBgGwXnZ0w3CI2RH70fHk0qqzfSrO8FTazt54yYpXZTm6gY44Q==
X-Received: by 2002:aa7:8753:0:b0:4fb:7b8b:44df with SMTP id g19-20020aa78753000000b004fb7b8b44dfmr7702158pfo.48.1648766100963;
        Thu, 31 Mar 2022 15:35:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:35:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 02/29] scsi: ufs: Remove superfluous boolean conversions
Date:   Thu, 31 Mar 2022 15:33:57 -0700
Message-Id: <20220331223424.1054715-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove "? true : false" if the preceding expression yields a boolean or if
the result of the expression is assigned to a boolean since in these two
cases the "? true : false" part is superfluous.

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
