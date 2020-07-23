Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30817C433EA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09E4A20792
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VLzuVAzw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgGWMY6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728846AbgGWMY5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:24:57 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB40C0619DC
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:24:57 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f18so4996085wrs.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mCXO0Gr/A00l7Lne4sBK8Frz9I2gxXn2t7va3NQnE+k=;
        b=VLzuVAzwLVM/dZrwghui32Cthrp/jLIjGRFYoekwj6rOfYdWN+Ca8euH5j0gmIclVA
         DPGAmw1kGbUVZEsPzHiJS4mVA4nIS/w0UhXhvtODtvdzRx0u3R/sEMZwyCzDADT/E9iu
         vLDxEbeoH+2JdqhS/3o/A9XdzqzYaakIGrL8NYVb3/bFEM+CIqVptPUaom3/SoHEeGNy
         sLA228efpCsVu2LU5uwYHYJjtRMQQlQyjtUkunjK29dLPWUIqm6go4LnmxMhmQcTNcuN
         K+Bn4hm1c0VKWz+h46vh5QR8aI/QuPomXCz/us8WLkqhjS4TOlcTzxWt1lj0K1kR4iqs
         V2tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mCXO0Gr/A00l7Lne4sBK8Frz9I2gxXn2t7va3NQnE+k=;
        b=l9/71BVbeOgCageOYcPCLZmyVSfaeHshdhgSQAVQWwS/Lz/T68/o6nsRZ38NPoYtQ8
         WzKvaIHMLE8YA44xocAgSXaHa6+PwVccGdxptm6TDF8y6CF1Ruz32UwUpDXxxCaH13UC
         /aoxmkY/eiSZs9iH+q6bUAe9X+p/Z5kuTCwYdpHnzVzLpnEFQ+4mXizsrxKIMON0YkuR
         xXVGkGhJYt9+SaBDBEf0kMLBVbDoTeRvSwHuFQ9i+6PZz6l3O5aIBaKfAc6MVcr50tfM
         MVlS+PvjQGvLSU1UlDRv8j6S7eT5BgG5gXcIquLTMIenWoGjPph7YYsWccWWJy2JtHPD
         VQZw==
X-Gm-Message-State: AOAM5322ngDdQ7nSMkoOw8zNcWWPei1OJxHLepFDaoFDYF4K/W2F+9Sd
        sFs9kH2bC2xiG4cHEm0s3JQSbA==
X-Google-Smtp-Source: ABdhPJyHdbt4arhYy1wxPK9DL4Wp99G0wUnJEmOEIFHYKnmyhpXMeS1JDOviOFALkqZ19VIiGO62Sw==
X-Received: by 2002:adf:cf0c:: with SMTP id o12mr3829930wrj.265.1595507095851;
        Thu, 23 Jul 2020 05:24:55 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:24:55 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 05/40] scsi: ufs: ufs-exynos: Make stubs 'static inline'
Date:   Thu, 23 Jul 2020 13:24:11 +0100
Message-Id: <20200723122446.1329773-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Else the compiler complains of missing prototypes.

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/scsi/ufs/ufs-exynos.c:23:
 drivers/scsi/ufs/ufs-exynos.h:302:6: warning: no previous prototype for ‘exynos_ufs_cmd_log_start’ [-Wmissing-prototypes]
 302 | void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
 | ^~~~~~~~~~~~~~~~~~~~~~~~
 drivers/scsi/ufs/ufs-exynos.h:307:6: warning: no previous prototype for ‘exynos_ufs_cmd_log_end’ [-Wmissing-prototypes]
 307 | void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
 | ^~~~~~~~~~~~~~~~~~~~~~
 drivers/scsi/ufs/ufs-exynos.h:312:5: warning: no previous prototype for ‘exynos_ufs_init_dbg’ [-Wmissing-prototypes]
 312 | int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev)
 | ^~~~~~~~~~~~~~~~~~~
 drivers/scsi/ufs/ufs-exynos.h:317:6: warning: no previous prototype for ‘exynos_ufs_dump_info’ [-Wmissing-prototypes]
 317 | void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev)
 | ^~~~~~~~~~~~~~~~~~~~

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Kukjin Kim <kgene@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ufs/ufs-exynos.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
index d86d0a0f74780..0908283a76936 100644
--- a/drivers/scsi/ufs/ufs-exynos.h
+++ b/drivers/scsi/ufs/ufs-exynos.h
@@ -299,22 +299,22 @@ void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
 int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev);
 void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev);
 #else
-void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
-			      struct ufs_hba *hba, int tag)
+static inline void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
+					    struct ufs_hba *hba, int tag)
 {
 }
 
-void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
-			    struct ufs_hba *hba, int tag)
+static inline void exynos_ufs_cmd_log_end(struct ufs_exynos_handle *handle,
+					  struct ufs_hba *hba, int tag)
 {
 }
 
-int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev)
+static inline int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle, struct device *dev)
 {
 	return 0;
 }
 
-void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev)
+static inline void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev)
 {
 }
 
-- 
2.25.1

