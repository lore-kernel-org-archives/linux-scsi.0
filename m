Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F0AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357656AbiDLSWH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358680AbiDLSWE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:22:04 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CE830F67
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:45 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id be5so11542381plb.13
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=49vD+yJktDl5B70k2zHugEv8CSNXmVnBJwG39FhcNPI=;
        b=Q/YE0oNvaxL5WTvO6zIof/KCN8Id8aswJaiGKlpkh5Qlrs58mRIlGhnLgiyXjOsbqK
         OcRaa6572rhV7DgL4NygERWnvNj+CFuTSpCvrdqiORXZGZmOSdDm/bX2ZE1CC4yWeSAq
         lRO1BQL/fXMK+utg+0BkbqPELdsppaXJNOmMceOItEGTCeMDyw0DjNTjvef7pnbCxtrT
         ua7s1jdBdtm6KBuTXZ4HZePEaPbPeFOPTc7EEKIeWfhROQC5WbUtLRASDaa2Aq9mulTi
         h/W7jq6RbcVm9TTiDDHDVS0V0HpJLdaKboCUpXLdaO/NfDaxw498Uputo9n+GjaDg7YG
         gTyw==
X-Gm-Message-State: AOAM533e2a9H/xyWYChRFQ+8TN7LD1dccIlvtqOjiUfDhl2flKkeRDn+
        VTl3u6fi7ywDPgMkkR8Q9L0=
X-Google-Smtp-Source: ABdhPJzsekVpsGGF/ASvt9wiT+wxO4XMhtjcMizcp6UBUo1zt/rEKvqQ9uk4yESfUbVFRg8iC6BCKQ==
X-Received: by 2002:a17:90b:1e44:b0:1ca:9eb8:e1ec with SMTP id pi4-20020a17090b1e4400b001ca9eb8e1ecmr6526603pjb.63.1649787584406;
        Tue, 12 Apr 2022 11:19:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:19:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v2 04/29] scsi: ufs: Simplify statements that return a boolean
Date:   Tue, 12 Apr 2022 11:18:28 -0700
Message-Id: <20220412181853.3715080-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert "if (expr) return true; else return false;" into "return expr;"
if either 'expr' is a boolean expression or the return type of the
function is 'bool'.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-qcom.h |  5 +----
 drivers/scsi/ufs/ufshcd.c   | 22 +++++-----------------
 drivers/scsi/ufs/ufshpb.c   |  8 ++------
 3 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 8208e3a3ef59..51570224a6e2 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -239,10 +239,7 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host);
 
 static inline bool ufs_qcom_cap_qunipro(struct ufs_qcom_host *host)
 {
-	if (host->caps & UFS_QCOM_CAP_QUNIPRO)
-		return true;
-	else
-		return false;
+	return host->caps & UFS_QCOM_CAP_QUNIPRO;
 }
 
 /* ufs-qcom-ice.c */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 983fac14b7cd..c60519372b3b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -939,10 +939,7 @@ static bool ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
 	 * logic simple, we will only do manual tuning if local unipro version
 	 * doesn't support ver1.6 or later.
 	 */
-	if (ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6)
-		return true;
-	else
-		return false;
+	return ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6;
 }
 
 /**
@@ -2216,10 +2213,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
  */
 static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
 {
-	if (ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY)
-		return true;
-	else
-		return false;
+	return ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY;
 }
 
 /**
@@ -5781,10 +5775,7 @@ static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
 		return false;
 	}
 	/* Let it continue to flush when available buffer exceeds threshold */
-	if (avail_buf < hba->vps->wb_flush_threshold)
-		return true;
-
-	return false;
+	return avail_buf < hba->vps->wb_flush_threshold;
 }
 
 static void ufshcd_wb_force_disable(struct ufs_hba *hba)
@@ -5863,11 +5854,8 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 		return false;
 	}
 
-	if (!hba->dev_info.b_presrv_uspc_en) {
-		if (avail_buf <= UFS_WB_BUF_REMAIN_PERCENT(10))
-			return true;
-		return false;
-	}
+	if (!hba->dev_info.b_presrv_uspc_en)
+		return avail_buf <= UFS_WB_BUF_REMAIN_PERCENT(10);
 
 	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
 }
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index b2bec19022cd..ebd8fc8fc109 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -90,12 +90,8 @@ static bool ufshpb_is_general_lun(int lun)
 
 static bool ufshpb_is_pinned_region(struct ufshpb_lu *hpb, int rgn_idx)
 {
-	if (hpb->lu_pinned_end != PINNED_NOT_SET &&
-	    rgn_idx >= hpb->lu_pinned_start &&
-	    rgn_idx <= hpb->lu_pinned_end)
-		return true;
-
-	return false;
+	return hpb->lu_pinned_end != PINNED_NOT_SET &&
+	       rgn_idx >= hpb->lu_pinned_start && rgn_idx <= hpb->lu_pinned_end;
 }
 
 static void ufshpb_kick_map_work(struct ufshpb_lu *hpb)
