Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255B9C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiBVPBR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiBVPAl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:00:41 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D26A10E569
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:00:01 -0800 (PST)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BAB463FCA0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645541999;
        bh=1gnJNDJDw/4tQtVmWxy7bj3CuaQdR4fw8lY4W6WZrSM=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=vDelxuptU+1RsiG1XNMnqzPLG68Kj7oOId3FKP6Qllhw7w02zirucPsD5Qz2/vA9G
         XGYkplyjMue87p17hCQ+9UWAGpDAums+emkOFOdbjAH0oC+JhQvaiCpwTfkk6kEqtB
         3WLSNO8EPlD2kyD61lfRUk6L+Dz24Lrgqa296yhvU0b/PuiviHdBt7ecpFIMNPhQWG
         cDGiiCiAw12/p81NC4nwBm5UvhJaSC9wckuqdwMk7tW4k41LIzI/VRfMQz+O12cv83
         iAH4vyCEpoIJBVH3Tan/oM+Y2p84t3Jr7pE6/OZ7Y5m7Rkah2SauARswKccfFakUYR
         JoN7PYNVf1Zkw==
Received: by mail-ej1-f72.google.com with SMTP id kw5-20020a170907770500b006ba314a753eso5848586ejc.21
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1gnJNDJDw/4tQtVmWxy7bj3CuaQdR4fw8lY4W6WZrSM=;
        b=1R16WmSfYsMJnMCyhFO7sxHhP77M2UJmBajy835NU7GWl3SZdAyMpIOW2fw2mky/sw
         /xYVsWqIdA2TW3se935G+OBCqYRTpTa9v097ofPJG/jowwnAfimebISUmZT7/0BDip54
         USkQWsvRyC2pJTczYKNcPLnb1LG/qIshscaAOZNRJIYFWN3EfeSGzSb7q3v2R8v5ipl6
         8tApuhGoJ/zpJ3jxTrvWoKSeFvEsakp+kMp1tSG38bh+ErMYE3KjJxyRkjRGZ6C91nY6
         onyCbQkpZg1m5fuq9fuvZRpCaMKEFtQgwEErUYGBqePPdm1zWAcNNy9mX1LnOR+t4TWO
         HpiA==
X-Gm-Message-State: AOAM533oAhJkq45jYPNltNvjlRyVIXgkghWPdHD1atFs0JOLUeE9u3+n
        odstOnE2VcrtM8Updx1mgtpt6DWIekvBkJNAg8FJ/o4v7d2CFCoG14Y5s1j3NA1jp4ebbAXVoLB
        XP5V2Ez3+ReTe5D/f9+ToUEKgAwz8CNUa7j70oJY=
X-Received: by 2002:a17:906:b155:b0:6c9:ea2d:3363 with SMTP id bt21-20020a170906b15500b006c9ea2d3363mr19204650ejb.729.1645541999450;
        Tue, 22 Feb 2022 06:59:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2oukZ+ozjlCm/noxM1LqqYguIfKnFdQpkzhzOSXTFSlmiKD/vXLNfpJoPvuzwYTi07oxrug==
X-Received: by 2002:a17:906:b155:b0:6c9:ea2d:3363 with SMTP id bt21-20020a170906b15500b006c9ea2d3363mr19204621ejb.729.1645541999288;
        Tue, 22 Feb 2022 06:59:59 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m2sm2467960ejb.20.2022.02.22.06.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 06:59:58 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jan Kotas <jank@cadence.com>, Li Wei <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 12/15] arm64: dts: qcom: use 'freq-table' in UFS node
Date:   Tue, 22 Feb 2022 15:58:51 +0100
Message-Id: <20220222145854.358646-13-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'freq-table-hz' property is deprecated by UFS bindings.
The uint32-array requires also element to be passed within one <> block.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi  | 2 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi  | 2 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi  | 2 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi  | 2 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi  | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index c85825ea1623..fad1bbfa1c0a 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -1761,7 +1761,7 @@ ufshc: ufshc@624000 {
 				<&rpmcc RPM_SMD_LN_BB_CLK>,
 				<&gcc GCC_UFS_TX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_RX_SYMBOL_0_CLK>;
-			freq-table-hz =
+			freq-table =
 				<100000000 200000000>,
 				<0 0>,
 				<0 0>,
diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 2fda21e810c9..87336c5866c0 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -990,7 +990,7 @@ ufshc: ufshc@1da4000 {
 				<&gcc GCC_UFS_TX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_RX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_RX_SYMBOL_1_CLK>;
-			freq-table-hz =
+			freq-table =
 				<50000000 200000000>,
 				<0 0>,
 				<0 0>,
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 0d6286d27dd4..23caa29e7862 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2274,7 +2274,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>,
 				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
-			freq-table-hz =
+			freq-table =
 				<50000000 200000000>,
 				<0 0>,
 				<0 0>,
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index d15fee495238..db2ac197c630 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1782,7 +1782,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>,
 				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
-			freq-table-hz =
+			freq-table =
 				<37500000 300000000>,
 				<0 0>,
 				<0 0>,
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index fdaf303ba047..8c9e3c4ac5ac 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2133,7 +2133,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
-			freq-table-hz =
+			freq-table =
 				<37500000 300000000>,
 				<0 0>,
 				<0 0>,
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index d242bab69c2e..a26bd3f13d4a 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1935,7 +1935,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
-			freq-table-hz =
+			freq-table =
 				<75000000 300000000>,
 				<75000000 300000000>,
 				<0 0>,
diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 934e29b9e153..edb904b58c0c 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1398,7 +1398,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
-			freq-table-hz =
+			freq-table =
 				<75000000 300000000>,
 				<0 0>,
 				<0 0>,
-- 
2.32.0

