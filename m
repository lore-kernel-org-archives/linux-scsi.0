Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E655C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242599AbiCaWji (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242593AbiCaWjh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:39:37 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0862E1FF406
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:49 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id s8so888260pfk.12
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rsCcXtVo4RpyGgj67PZ1rYHYE8rvm8iA/l2XkhNusoA=;
        b=F0Dps5tXUOMkfro1vf/UUXzOq0nr6CQ/4HlZf/BS75c1Lt41YsH5cCrvyzvPr/Vo2j
         2xDuVaZnhk71F717pPbcAhmVxzPNXyVMvK5I/GVS0Usbevp5/WKUWT4M1QByDJONk+2P
         zmI3oL4k9btW1ChUg8MpSXwVjZZon1EpZ1jAO8A1q5p6CCdZ5odEMXQXMskAsnu/f01x
         mXyMo31pDc+xVmz0Dz17YoVgXTB0qGYs22JVrDErqiXMjvmoItAeYpYCVCBMq5FICaOe
         QUgbwXJ9mo6DJYUFLJGqoL02jjcaYVS4IlRqRFrQi3ETQnQkkfTMrYbx0YJgUqAaYx2x
         cTpg==
X-Gm-Message-State: AOAM5315esPhSLQRXHLGd7XEvcKZKArN8D7B+gY3n5j7qe3KCaUmyDig
        j6TTJxlOMCs8Jd3y036xkC8=
X-Google-Smtp-Source: ABdhPJzx4flSytAkIJG59urxVy7DGIQ4BNZ3dp3PFD26DkPpyGYTPlEh32yjV7TFiHWjp8BQ+OnqFQ==
X-Received: by 2002:a05:6a00:8cc:b0:4bc:3def:b616 with SMTP id s12-20020a056a0008cc00b004bc3defb616mr7739779pfu.18.1648766268367;
        Thu, 31 Mar 2022 15:37:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:37:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Inki Dae <inki.dae@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 19/29] scsi: ufs: Remove the TRUE and FALSE definitions
Date:   Thu, 31 Mar 2022 15:34:14 -0700
Message-Id: <20220331223424.1054715-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the Linux kernel coding style document
(Documentation/process/coding-style.rst) it is recommended to use the type
'bool' and also the values 'true' and 'false'. Hence this patch that
removes the definitions and uses of TRUE and FALSE from the UFS driver.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-exynos.c |  4 ++--
 drivers/scsi/ufs/ufs-exynos.h |  8 ++++----
 drivers/scsi/ufs/ufshcd.c     |  8 ++++----
 drivers/scsi/ufs/unipro.h     | 14 --------------
 4 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
index 474a4a064a68..0b99c74955ef 100644
--- a/drivers/scsi/ufs/ufs-exynos.c
+++ b/drivers/scsi/ufs/ufs-exynos.c
@@ -704,7 +704,7 @@ static void exynos_ufs_establish_connt(struct exynos_ufs *ufs)
 
 	/* local unipro attributes */
 	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID), DEV_ID);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), TRUE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), true);
 	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), PEER_DEV_ID);
 	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID), PEER_CPORT_ID);
 	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), CPORT_DEF_FLAGS);
@@ -1028,7 +1028,7 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
 
 	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)
 		ufshcd_dme_set(hba,
-			UIC_ARG_MIB(T_DBG_SKIP_INIT_HIBERN8_EXIT), TRUE);
+			UIC_ARG_MIB(T_DBG_SKIP_INIT_HIBERN8_EXIT), true);
 
 	if (attr->pa_granularity) {
 		exynos_ufs_enable_dbg_mode(hba);
diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index 1c33e5466082..0b0a3d530ca6 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -248,22 +248,22 @@ long exynos_ufs_calc_time_cntr(struct exynos_ufs *, long);
 
 static inline void exynos_ufs_enable_ov_tm(struct ufs_hba *hba)
 {
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), TRUE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), true);
 }
 
 static inline void exynos_ufs_disable_ov_tm(struct ufs_hba *hba)
 {
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), FALSE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), false);
 }
 
 static inline void exynos_ufs_enable_dbg_mode(struct ufs_hba *hba)
 {
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), TRUE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), true);
 }
 
 static inline void exynos_ufs_disable_dbg_mode(struct ufs_hba *hba)
 {
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), FALSE);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), false);
 }
 
 #endif /* _UFS_EXYNOS_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c36658d97774..c81b5f3f0b9a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4325,18 +4325,18 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			pwr_mode->lane_rx);
 	if (pwr_mode->pwr_rx == FASTAUTO_MODE ||
 			pwr_mode->pwr_rx == FAST_MODE)
-		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), TRUE);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), true);
 	else
-		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), FALSE);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), false);
 
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), pwr_mode->gear_tx);
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES),
 			pwr_mode->lane_tx);
 	if (pwr_mode->pwr_tx == FASTAUTO_MODE ||
 			pwr_mode->pwr_tx == FAST_MODE)
-		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), TRUE);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), true);
 	else
-		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), FALSE);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), false);
 
 	if (pwr_mode->pwr_rx == FASTAUTO_MODE ||
 	    pwr_mode->pwr_tx == FASTAUTO_MODE ||
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index bdd0fa6a3c74..91152d8386e6 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -298,20 +298,6 @@ enum ufs_unipro_ver {
 #define T_TC0TXMAXSDUSIZE	0x4060
 #define T_TC1TXMAXSDUSIZE	0x4061
 
-#ifdef FALSE
-#undef FALSE
-#endif
-
-#ifdef TRUE
-#undef TRUE
-#endif
-
-/* Boolean attribute values */
-enum {
-	FALSE = 0,
-	TRUE,
-};
-
 /* CPort setting */
 #define E2EFC_ON	(1 << 0)
 #define E2EFC_OFF	(0 << 0)
