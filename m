Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2995BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 10:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiDHKcy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 06:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234424AbiDHKcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 06:32:42 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859B3123BD2
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 03:30:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q19so12151463wrc.6
        for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2022 03:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jY9910bCEE6CaueSlgP25gbvDVfiGXDsvrMiuSTpRJs=;
        b=jsWE9NlqdY9/SnZcpgaHV4BD6QOqlfyg2175hi7mpFvIvvGKO/5VB3y5SQYsIool48
         q0ezcxUtdaSeifg74BPQOdqmfF+HkF409bMaQ5+yd1D3UtskedDg7YvCCd+PlbNJCGKG
         ocDsrxehwH7jZacxraizxpeLvTzKMPk26FO0ZjmkcjFHzvMenE3D6fK4LWbnD+pnHxmd
         wcYIlDRKu72LDJvT3/AnrBXVieAyOxRFGpeytFM6nKWYgAML1QMfIY1vqfK0C5N7ePCG
         Zg0VzZTPvaFtcKdkoDPq6Lik9rW6R12CGHBQGPJWzMa3Uu+2GzLld5WmR+6pc2AqK1qG
         UIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jY9910bCEE6CaueSlgP25gbvDVfiGXDsvrMiuSTpRJs=;
        b=yAG7JtZnHHmUOUehxTcU32CMseiRIDU6dtOA3cRg14GNIgchSkJjXlmNGcgGTOEaA6
         NWdQ0C/mf7O92B/VKuXGGtLucE2USklaMVtV/R9SrP9bKsEFRZ1xzBey5hfOxO9RlkJA
         zPM/8D+MT260R9i8fT9hwVvxZh+2daMjj5ss96ciopp/LQKzYjAMZQu6UNO8w2p5jUKh
         inX35xH5JR05adhSfk4M4bkV1YnKOdhnrMaJwRvje3m26UWMuOZQ8GrHiZdMAsCyk02q
         34gul45OCG63fYdOcAdxcDsOt65OuC8QSCfWdWznYty5Lmly5EIntnsjS08nB+dbvzQ2
         UHSg==
X-Gm-Message-State: AOAM5317xlwAs/Gf8KdKGHGzyO443OAGs0sPPcSjCzEdIHS2HfPysWRB
        iWScq1MiB6/3H4SPOwpbOK+d8g==
X-Google-Smtp-Source: ABdhPJz7CIVJbkvmN6/MgIloAdTYV6/4QzFk6iLUr6QPGdm9PGEazwHcKu8RnxJkoswxKN2QPLl+sg==
X-Received: by 2002:adf:90e9:0:b0:204:2ee:7d5 with SMTP id i96-20020adf90e9000000b0020402ee07d5mr13918145wri.536.1649413836155;
        Fri, 08 Apr 2022 03:30:36 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id n2-20020adfb742000000b00205eda3b3c1sm20181920wre.34.2022.04.08.03.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 03:30:35 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 3/4] scsi: ufs: ufshcd-pltfrm: constify pointed data
Date:   Fri,  8 Apr 2022 12:30:26 +0200
Message-Id: <20220408103027.311624-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220408103027.311624-1-krzysztof.kozlowski@linaro.org>
References: <20220408103027.311624-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Constify pointers to data which is not modified for code safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 10 +++++-----
 drivers/scsi/ufs/ufshcd-pltfrm.h |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 87975d1a21c8..3548897c3692 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -25,7 +25,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	int i;
 	struct device *dev = hba->dev;
 	struct device_node *np = dev->of_node;
-	char *name;
+	const char *name;
 	u32 *clkfreq = NULL;
 	struct ufs_clk_info *clki;
 	int len = 0;
@@ -78,8 +78,8 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	}
 
 	for (i = 0; i < sz; i += 2) {
-		ret = of_property_read_string_index(np,
-				"clock-names", i/2, (const char **)&name);
+		ret = of_property_read_string_index(np,	"clock-names", i/2,
+						    &name);
 		if (ret)
 			goto out;
 
@@ -207,8 +207,8 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
  *
  * Returns 0 on success, non-zero value on failure
  */
-int ufshcd_get_pwr_dev_param(struct ufs_dev_params *pltfrm_param,
-			     struct ufs_pa_layer_attr *dev_max,
+int ufshcd_get_pwr_dev_param(const struct ufs_dev_params *pltfrm_param,
+			     const struct ufs_pa_layer_attr *dev_max,
 			     struct ufs_pa_layer_attr *agreed_pwr)
 {
 	int min_pltfrm_gear;
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.h b/drivers/scsi/ufs/ufshcd-pltfrm.h
index c33e28ac6ef6..0f0c2942a5be 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.h
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.h
@@ -25,8 +25,8 @@ struct ufs_dev_params {
 	u32 desired_working_mode;
 };
 
-int ufshcd_get_pwr_dev_param(struct ufs_dev_params *dev_param,
-			     struct ufs_pa_layer_attr *dev_max,
+int ufshcd_get_pwr_dev_param(const struct ufs_dev_params *dev_param,
+			     const struct ufs_pa_layer_attr *dev_max,
 			     struct ufs_pa_layer_attr *agreed_pwr);
 void ufshcd_init_pwr_dev_param(struct ufs_dev_params *dev_param);
 int ufshcd_pltfrm_init(struct platform_device *pdev,
-- 
2.32.0

