Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0663CCA47C
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 10:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbiFMKHH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 06:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbiFMKHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 06:07:05 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FDE25C8
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 03:07:04 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id s12so10186721ejx.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 03:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZGEshUVR72se0cly2sjnnLyILAX1UOXEx9LJVGIAmRA=;
        b=jwgEfOivK6xbWY9rmeyxxzqERA4hxbJmU7zY8cqXCuPBK6ptEsHPI7FxquijIHvMTO
         Yhmpvr/RhQV30q9xRySOditrPS9+hKmlwMZEnB3BRtnfcgvczaiELl1okDAszPIx3oXe
         RPAX4m9CXaoHGjPRC3T+ngwv67GhdsK0+nEm+MPrMoKyZLrjo8YiUT1aZmxr0lFed7WZ
         VonynU5csyqJAYCONWsoFVc0t7eNpHZ7JnG67OGaOuufsM3xuDbL0CJSCBUHh7PYy8RX
         cpyumM4tQSXsXCETFTVbcnxePjkAe9ZUoX11IXkcDEE0Zn2SyOs53v1p9IaAK/3SgN+f
         boGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZGEshUVR72se0cly2sjnnLyILAX1UOXEx9LJVGIAmRA=;
        b=F++JUgHmFEdFhKEManDouyaG4J1SRUhELgA1hlcbVzVUXon+icWrp8aLHdW6ZlPRFi
         h1affLG2l6rRythHNHunbSQDbcsoLNwdwbiQiUc5lqdVFcT7ChzpSUF+GCiXdIbjhyUb
         4osy6twjvDdZrcdhLfXUVevNfq+pSKLdnyjqb49pGGSrKOJoLAzlKFQ7xbUpNZ2XU2Cg
         8nOSMcIUF0iGJcIk1254ulhLdCCEJzyfKJcOCB6CIiN4xQfpQpvnr6Goh9Yxfp1bLY3B
         hFJIXta4hNuEe+NCVJeM78x9e4Th4aAA5tHg8tf6Wt+xDZkupBVGRJJ4rN1svx1AqHxA
         6rgg==
X-Gm-Message-State: AOAM530USVIdQnBe6xWaBFRLD2pmTr2rzbxvsU2gyymLEaBITYQeYNWR
        +qcP4cgHwEQr9Z3dnLq5389n/w==
X-Google-Smtp-Source: ABdhPJy1hl/o2TfsysynVpPKCaGGb0ZFi6E0t4i1npezDW4+GAs2tyVdYaAjzownmGggCWQf116zPA==
X-Received: by 2002:a17:906:180c:b0:6fe:9a3e:3d5b with SMTP id v12-20020a170906180c00b006fe9a3e3d5bmr52108425eje.202.1655114822640;
        Mon, 13 Jun 2022 03:07:02 -0700 (PDT)
Received: from krzk-bin.monzoon.net (80-254-69-65.dynamic.monzoon.net. [80.254.69.65])
        by smtp.gmail.com with ESMTPSA id v2-20020a170906858200b006fe921fcb2dsm3639911ejx.49.2022.06.13.03.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 03:07:02 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v3 2/3] scsi: ufs: ufshcd-pltfrm: constify pointed data
Date:   Mon, 13 Jun 2022 12:06:54 +0200
Message-Id: <20220613100655.105301-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220613100655.105301-1-krzysztof.kozlowski@linaro.org>
References: <20220613100655.105301-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Constify pointers to data which is not modified for code safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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

