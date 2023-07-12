Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597BAEB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbjGLK5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbjGLK44 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:56:56 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B3C19B
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:56:54 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b8bbce9980so45048335ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689159413; x=1691751413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=+PtBZ5U/uPeERQpI5byb7Cw2i1LitARzlq3AxNOTl7Y=;
        b=ZgqHagZOgbc87LfUpEBztQB8GBCa5uxX10kU9q+olbNfl+USgV0ti4RVmWx7jpr04O
         G/bY+NW1sKXCP2wUhasmnsyWv5YJfvLWUydnFd0uMVmInzIFvJBjfTrRyovUqIXhvjk5
         MTZ/otMmjkxFL3FHWg3lJgBPZrGX9NKlh891gGTAw9ZcwmRvHhkNGe9iGoj3EDvegvZn
         /Gv9q3NARKPh33TNbywB1vRyQJ6lHRBO6u6GkoKtfUycnkQLmx6QBKcS7TlSf25SL+Ej
         FOZjapND4foziHTSNpkf7g0HgdGtRWJ7C/dqoSj6BOOrtDwhBt7g5BNs7Nv/RPi9tgMm
         zXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159413; x=1691751413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+PtBZ5U/uPeERQpI5byb7Cw2i1LitARzlq3AxNOTl7Y=;
        b=jClwQv8aQllodajOrpEGCe2IFv1v68BxJ9ZSmfsFGsIXBJRHUTMzzi5TmtwhpO8o0M
         /wMoEdju2xUzIXs2nDO+aTpCIdpNiuTmDfxQj8LODFb7Z7HP3TusrK3yJayrcNjtJPTH
         XNLp/DwtS2L6XpjRcpJIUsAmm6Gcs3cCAmHQ4eFW8W81hf7hhgisI5ACfrVr2DG6XvDV
         L5Rg1Td2DsXKa5d10rVqo0F/nr56KzTPRFHG9tZG7/GWu3gbuGZfrDqjbx0hPuXuEzBZ
         uyilJhZv46puEf1eX30TnTiMlqV2HyxJ0BBW3IKCMDq2I7IU8Cme8Mtkzv9dmRMbMDu2
         mNuw==
X-Gm-Message-State: ABy/qLZwCjRov52BFshl6xwPt5CeDsXfYL/qGYGrsX6eEjfxE3Ykhhsa
        mciVrBx05rq6rNSVbYsSoDg8
X-Google-Smtp-Source: APBJJlG1zH4Cpy3DKaKMBYeGelgcfqkYkbQb37+JTlJYQuR2InUdsE1ntAvWDJ8cRo4Z1jhcTRnjkg==
X-Received: by 2002:a17:902:d38c:b0:1b5:5aa0:cfd9 with SMTP id e12-20020a170902d38c00b001b55aa0cfd9mr14692131pld.48.1689159413421;
        Wed, 12 Jul 2023 03:56:53 -0700 (PDT)
Received: from thinkpad ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id bd9-20020a170902830900b001b53c8659fesm3615647plb.30.2023.07.12.03.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:56:53 -0700 (PDT)
Received: from localhost.localdomain ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id k15-20020aa790cf000000b00666b3706be6sm3247860pfk.107.2023.07.12.03.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:35:17 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 11/14] scsi: ufs: host: Add support for parsing OPP
Date:   Wed, 12 Jul 2023 16:02:08 +0530
Message-Id: <20230712103213.101770-14-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
References: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TUID: gqyrDDXZHLic
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

OPP framework can be used to scale the clocks along with other entities
such as regulators, performance state etc... So let's add support for
parsing OPP from devicetree. OPP support in devicetree is added through
the "operating-points-v2" property which accepts the OPP table defining
clock frequency, regulator voltage, power domain performance state etc...

Since the UFS controller requires multiple clocks to be controlled for
proper working, devm_pm_opp_set_config() has been used which supports
scaling multiple clocks through custom ufshcd_opp_config_clks() callback.

It should be noted that the OPP support is not compatible with the old
"freq-table-hz" property. So only one can be used at a time even though
the UFS core supports both.

Co-developed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufshcd-pltfrm.c | 116 +++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 0b7430033047..068c22378c88 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -8,8 +8,10 @@
  *	Vinayak Holikatti <h.vinayak@samsung.com>
  */
 
+#include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm_opp.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 
@@ -17,6 +19,8 @@
 #include "ufshcd-pltfrm.h"
 #include <ufs/unipro.h>
 
+#include <trace/events/ufs.h>
+
 #define UFSHCD_DEFAULT_LANES_PER_DIRECTION		2
 
 static int ufshcd_parse_clock_info(struct ufs_hba *hba)
@@ -205,6 +209,112 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
 	}
 }
 
+static int ufshcd_opp_config_clks(struct device *dev, struct opp_table *opp_table,
+				  struct dev_pm_opp *opp, void *data,
+				  bool scaling_down)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct list_head *head = &hba->clk_list_head;
+	struct ufs_clk_info *clki;
+	unsigned long freq;
+	u8 idx = 0;
+	int ret;
+
+	list_for_each_entry(clki, head, list) {
+		if (!IS_ERR_OR_NULL(clki->clk)) {
+			freq = dev_pm_opp_get_freq_indexed(opp, idx++);
+
+			/* Do not set rate for clocks having frequency as 0 */
+			if (!freq)
+				continue;
+
+			ret = clk_set_rate(clki->clk, freq);
+			if (ret) {
+				dev_err(dev, "%s: %s clk set rate(%ldHz) failed, %d\n",
+					__func__, clki->name, freq, ret);
+				return ret;
+			}
+
+			trace_ufshcd_clk_scaling(dev_name(dev),
+				(scaling_down ? "scaled down" : "scaled up"),
+				clki->name, hba->clk_scaling.target_freq, freq);
+		}
+	}
+
+	return 0;
+}
+
+static int ufshcd_parse_operating_points(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct device_node *np = dev->of_node;
+	struct dev_pm_opp_config config = {};
+	struct ufs_clk_info *clki;
+	const char **clk_names;
+	int cnt, i, ret;
+
+	if (!of_find_property(np, "operating-points-v2", NULL))
+		return 0;
+
+	if (of_find_property(np, "freq-table-hz", NULL)) {
+		dev_err(dev, "%s: operating-points and freq-table-hz are incompatible\n",
+			 __func__);
+		return -EINVAL;
+	}
+
+	cnt = of_property_count_strings(np, "clock-names");
+	if (cnt <= 0) {
+		dev_err(dev, "%s: Missing clock-names\n",  __func__);
+		return -ENODEV;
+	}
+
+	/* OPP expects clk_names to be NULL terminated */
+	clk_names = devm_kcalloc(dev, cnt + 1, sizeof(*clk_names), GFP_KERNEL);
+	if (!clk_names)
+		return -ENOMEM;
+
+	/*
+	 * We still need to get reference to all clocks as the UFS core uses
+	 * them separately.
+	 */
+	for (i = 0; i < cnt; i++) {
+		ret = of_property_read_string_index(np, "clock-names", i,
+						    &clk_names[i]);
+		if (ret)
+			return ret;
+
+		clki = devm_kzalloc(dev, sizeof(*clki), GFP_KERNEL);
+		if (!clki)
+			return -ENOMEM;
+
+		clki->name = devm_kstrdup(dev, clk_names[i], GFP_KERNEL);
+		if (!clki->name)
+			return -ENOMEM;
+
+		if (!strcmp(clk_names[i], "ref_clk"))
+			clki->keep_link_active = true;
+
+		list_add_tail(&clki->list, &hba->clk_list_head);
+	}
+
+	config.clk_names = clk_names,
+	config.config_clks = ufshcd_opp_config_clks;
+
+	ret = devm_pm_opp_set_config(dev, &config);
+	if (ret)
+		return ret;
+
+	ret = devm_pm_opp_of_add_table(dev);
+	if (ret) {
+		dev_err(dev, "Failed to add OPP table: %d\n", ret);
+		return ret;
+	}
+
+	hba->use_pm_opp = true;
+
+	return 0;
+}
+
 /**
  * ufshcd_get_pwr_dev_param - get finally agreed attributes for
  *                            power mode change
@@ -371,6 +481,12 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	ufshcd_init_lanes_per_dir(hba);
 
+	err = ufshcd_parse_operating_points(hba);
+	if (err) {
+		dev_err(dev, "%s: OPP parse failed %d\n", __func__, err);
+		goto dealloc_host;
+	}
+
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Initialization failed\n");
-- 
2.25.1

