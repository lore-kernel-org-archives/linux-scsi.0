Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A669C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242520AbiCaWg5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiCaWg4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:36:56 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09081C947A
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:07 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id bx5so751297pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:35:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cil1wjyy9cGXEvv//poa7J3kIRAGc49AXlG4NO0BSCk=;
        b=R5r+yEyB3ephlmbjKX2bjGaKRh653blT6oMyR2NdCgwLrkFskAxJA8nMvStQSvLfnO
         I41Un+KbQNquIUzWGwAlNLIa6MRND61E2CQL78bdEtnUsqvw6wMcXkdWQelsFD+JRLR3
         yvhujXahG7gVB7RGElFuxhLc7odu31V03QY6xov+7wDrOMeoBJyfOV7OKL0rMBTSAwxg
         /UeDwYvFcDBmJuTS/cCj/Dt9nXO8qYyxUcAdWrBzpl/Q2lhmAr6dVeFbamV++AVqWqMJ
         LuRTxPPU50y1jN2a6ngIxwzYZLxiBemxWeji6CN9VWez8vxtnl4MKr3WL269cn7ikYbX
         htvg==
X-Gm-Message-State: AOAM532QUt4bb346gamDYAXTWQA4wpVlDXvqj1EyqfLEm4VhBJg3hMC+
        cwJ7MoiYRrkA/bLzWXRghyE=
X-Google-Smtp-Source: ABdhPJy/VDxZArgL9Xoa+UzrlETXvxi7kUahd9pWyvy59do0zcQya+xwnwKlbpy690C6mH1RW3YWbw==
X-Received: by 2002:a17:902:6808:b0:156:39c9:4c40 with SMTP id h8-20020a170902680800b0015639c94c40mr7073050plk.13.1648766107139;
        Thu, 31 Mar 2022 15:35:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:35:06 -0700 (PDT)
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
Subject: [PATCH 03/29] scsi: ufs: Simplify statements that return a boolean
Date:   Thu, 31 Mar 2022 15:33:58 -0700
Message-Id: <20220331223424.1054715-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert "if (expr) return true; else return false;" into "return expr;"
if either 'expr' is a boolean expression or the return type of the
function is 'bool'.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-qcom.h |  5 +----
 drivers/scsi/ufs/ufshcd.c   | 22 +++++-----------------
 2 files changed, 6 insertions(+), 21 deletions(-)

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
