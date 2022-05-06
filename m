Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A03C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 10:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390995AbiEFKfS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 06:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390994AbiEFKfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 06:35:07 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3635262BFB
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 03:31:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id g6so13644001ejw.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 May 2022 03:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G7AKvMZPXvXSnfImyNv30/Tu154Oa9ejf/GkvDjzFBY=;
        b=Z8cFLDFsO5ZuGKiEQJA03dJNctu2elENQQ0uxCdgWJmVkg61HPj3j9GZ87Kz0PJTVp
         HhFbD+MXuribyNGlSjqe4zeE0Ty9YxwOyMP2VeQuNR/TWNeVogE1eD2qK8NTkrJuSB+S
         GQfnac9V/6qH12wFzEKptjotXX+cbzvmhc1hut6c/rihIRA0nV0yaXdj08N2fhqdkwF/
         uCpgQkipkN6khlNu7K35YUhmeqVUH/58DsCmlGH3meVthU3rxOhbPVD7i4zaSMdLLhtB
         a2osizx9oSJNsSftMpB6t3vLMGYmNZw/nCvC2Y0VXnf6fwToppdP9L/CrFbwJihkIi9r
         Qcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G7AKvMZPXvXSnfImyNv30/Tu154Oa9ejf/GkvDjzFBY=;
        b=wNz+KjIPQ1sy68mwy9X9lhG2GSshnb9hWSiFnsSCFds0/JxQxTdQVvlEL07yyjS2f3
         2YZe1wCU3D4o1uzRRbSn2J9MF8FQ2I1IUQqosZNBzUorM22nC+3ytKk/cdHAfXOddn7/
         AeYbzQP7SLGwsa5POVHHMj1l+JiE2Uw5QKitaWoRbwl8jVzKSl5ucht64tzjRpzmTTdA
         QfkLkJUVEZ58nW9qhCudYF3+Sr3GIhACFCAeDcfCbXVKAIQJy8S0O8Tqs1PtPY1reQOO
         K6TN9KIX1Z5Jp0eor+VKaLvDuj+/bQmtJl81A+87+6obkU+whGau+rfCEXbB5wWwLrOU
         IYNA==
X-Gm-Message-State: AOAM531JByXVtgbflhZF0n+QIcCUMDdOzbm5bPnfHOaOk07/54rtIz5w
        SgNdNsL2vv67spkxYrl7mC9fww==
X-Google-Smtp-Source: ABdhPJy+dR+cjNHSaFFy83lVt8fb779H9yBeKHxCkXUgxaa8JTcod6EQOvNGYenOtbBL5+BSuTUxbw==
X-Received: by 2002:a17:906:9c83:b0:6df:839a:a6d0 with SMTP id fj3-20020a1709069c8300b006df839aa6d0mr2296006ejc.419.1651833082631;
        Fri, 06 May 2022 03:31:22 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id em10-20020a170907288a00b006f3ef214e6dsm1726957ejc.211.2022.05.06.03.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 03:31:22 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 2/3] scsi: ufs: ufshcd-pltfrm: constify pointed data
Date:   Fri,  6 May 2022 12:31:14 +0200
Message-Id: <20220506103115.307410-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220506103115.307410-1-krzysztof.kozlowski@linaro.org>
References: <20220506103115.307410-1-krzysztof.kozlowski@linaro.org>
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
index f5313f407617..3ab555f6e66e 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
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

