Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35262C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347247AbiDSXBN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiDSXBI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:08 -0400
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EC0387A7
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:25 -0700 (PDT)
Received: by mail-pf1-f181.google.com with SMTP id x80so208846pfc.1
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vAvAdPiV+CMBL3q1ZKpWhCqvgC6GS7287yjxaluRU7M=;
        b=npQn+DF8QRpFT4UgYeox99CP9oniM86Gv935dEwqxG73pC2Bg/yMka7M7txO24WPSO
         UJSIPA+2kJairjYUHwU93T8UJv1cDOghuJE4pY8wvN6FltvfTaDsCiytSCjJTYnjXuzl
         a1saJvCo/PaEsXfy9r6XUt6w/YPhRQgs8WmBM4pXthEZS0BsBLij/k3B8ppeZeyP618E
         LAzRFa42pyQ8cwoeehPnyjus9aZj6Y9LlDON8qp3bl9XqW+DVBsB2LIVD6PCWcGMdbvw
         e8FIs/sV/MsSHwX9ZytVDair2eYLBDtoSrVaVKQpoxwMyd6sKaI/UdHoIkqOrI9Zgtw/
         phlg==
X-Gm-Message-State: AOAM533k0MWTkUwTlYCqBS9FJpaUFeLxwf2gVgMyoL0TdDKEeoJB6G8T
        Dk9rOmD2Ony2gPX1eBMpSZXLZ7EFlarUSw==
X-Google-Smtp-Source: ABdhPJwzN5CqV51kkiHHsXZLPYO0lq5mzGM+L84Wk0l7g37nPRk8gBjjlR3gZ15v4JlkKFouSv8FAg==
X-Received: by 2002:a05:6a00:2181:b0:4f6:f1b1:1ba7 with SMTP id h1-20020a056a00218100b004f6f1b11ba7mr20157710pfi.73.1650409104565;
        Tue, 19 Apr 2022 15:58:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 03/28] scsi: ufs: Remove superfluous boolean conversions
Date:   Tue, 19 Apr 2022 15:57:46 -0700
Message-Id: <20220419225811.4127248-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
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
