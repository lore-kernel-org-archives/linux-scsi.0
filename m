Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28912C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jun 2022 10:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiFWKYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jun 2022 06:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiFWKYn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2022 06:24:43 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B3B3D1D5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 03:24:41 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id lw20so17714258ejb.4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 03:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OcOxzRrmout0J6KGnfy+0CFuX6gez+EVlPisuTa/Efo=;
        b=XXHC1h9NIZtSXCdxkZC4+2oX9kyJq0XfXoQRxh/3fYGxrkAM7yJJkZXGwKFVEPXVKM
         qeeqdGJuhE41gxChF0BRzJmR8ELmhG+QgmesJX9uThU4trQu4aMoVbP6dVx4ya6H6xhO
         75wgzV14RihAQZgf20b/xXmyzAnreJYWHz7zCzTIz7mjRYM8tWwo/JSCveoP8Lnl4+w+
         6jOAC3CgH2u+K0d4wTYUhMqqKyHDWIsO10yNJPuqTwtMUqMEj/7yOrVi91SEbqTTJEUQ
         zieybDJZ1vziRz5yMLWK2Kx+EdEhJJ8H0x3uj4PWHhzYWz5F50IFmxoonty0WBgNHBew
         fRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcOxzRrmout0J6KGnfy+0CFuX6gez+EVlPisuTa/Efo=;
        b=rZpN+bSg4gaW84GEIhh8w2bFafSJY/QdaBq6Q+54IBHFcj58Ep/ILKA9rvUBi8wdtp
         oDRZiRvDCzalpvdlMRY5w+L3Dq5jPkz31pEHHNxkclNYHSKHSnWzltgpG58+X7hhmySx
         9J7AvfQB2vK/jm75v7IEGfOHtD/3UcUkFjrlhcRKPKOxi93cyaPS2Ia4n/sYoYF7bdzL
         S+/Tm2YJw4LPmeb9Y6VxugZI4Ft4gVGrqJXHsTmsnuPt29YSpe+Q2rvtXK5gZv19lh8Y
         Bk3qGWdCKZDeDoY3FfTJ6DG218kTslmLDRrfgvcmShZF221cAf43hsphVYrNYW6g+uOs
         pSdg==
X-Gm-Message-State: AJIora+uOQjbGIFEV1c7JM3T8K+fzZedEJ2Xr2ZyP9/470sCv4Ivnukr
        1qB8wltx6naP39IcQN1AMEojng==
X-Google-Smtp-Source: AGRyM1v+zfjYyrIJHG7DNkBmGM+zEYv9Y2gwhU7r8LrRr5hAnM0h81pD2+LM9BZAFfGUuis78PUwdA==
X-Received: by 2002:a17:906:1c9:b0:712:1115:42a5 with SMTP id 9-20020a17090601c900b00712111542a5mr7234837ejj.662.1655979880272;
        Thu, 23 Jun 2022 03:24:40 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id 15-20020a170906300f00b006f3ef214dd9sm10692128ejz.63.2022.06.23.03.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 03:24:39 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 2/3] scsi: ufs: ufshcd-pltfrm: constify pointed data
Date:   Thu, 23 Jun 2022 12:24:31 +0200
Message-Id: <20220623102432.108059-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220623102432.108059-1-krzysztof.kozlowski@linaro.org>
References: <20220623102432.108059-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Constify pointers to data which is not modified for code safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/host/ufshcd-pltfrm.c | 10 +++++-----
 drivers/ufs/host/ufshcd-pltfrm.h |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index e7332cc65b1f..e0b7c02092cc 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -26,7 +26,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	int i;
 	struct device *dev = hba->dev;
 	struct device_node *np = dev->of_node;
-	char *name;
+	const char *name;
 	u32 *clkfreq = NULL;
 	struct ufs_clk_info *clki;
 	int len = 0;
@@ -79,8 +79,8 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	}
 
 	for (i = 0; i < sz; i += 2) {
-		ret = of_property_read_string_index(np,
-				"clock-names", i/2, (const char **)&name);
+		ret = of_property_read_string_index(np,	"clock-names", i/2,
+						    &name);
 		if (ret)
 			goto out;
 
@@ -208,8 +208,8 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
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
diff --git a/drivers/ufs/host/ufshcd-pltfrm.h b/drivers/ufs/host/ufshcd-pltfrm.h
index 43c2e412bd99..fead72998dca 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.h
+++ b/drivers/ufs/host/ufshcd-pltfrm.h
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
2.34.1

