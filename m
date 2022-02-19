Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C991C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Feb 2022 18:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242082AbiBSSnb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 13:43:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242927AbiBSSnP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 13:43:15 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C92275E4
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 10:42:41 -0800 (PST)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6C1074092E
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 18:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645296157;
        bh=eds4hwJvnu4NA5qKYzbOl5rJlIyGJooNPDbjWhSXxPA=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=fTjNbmylLjXP0VN1lczGMn7EWl0yR/zOu58pVD0L5rRcLgyeQEfIqto0WPKTuVfJM
         VtNm8KVCeF2Mwd85R4fpwmole6OYXnVdFEPBuxZwZ/EeN41e3IFnIHe7r+gxmpRxup
         TM/hUwupkBT48qzKxzfTVQ1JlyFB4Ybw4IeW6Jj5ebNCNfkHFS6/4MrYjwlTVi9VM/
         GAiv1lQkhs1PaskYjyBGV2rBSofAGT1TMoIbQGVs7FM5s9pRCINzUBnFoE/df1Pa+t
         V/77b0QegT6/g2JUONoomAQxMh3nHO4S4UmTgIsZIjMrWHokBngmDY5a3vDWldZ50l
         koZU5oMA3qe+Q==
Received: by mail-ed1-f72.google.com with SMTP id d11-20020a50c88b000000b00410ba7a14acso7587019edh.6
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 10:42:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eds4hwJvnu4NA5qKYzbOl5rJlIyGJooNPDbjWhSXxPA=;
        b=v9AW/Mo8Ugsb5qXhRBepVuj3i1/q/uvC3yuFJBASyCJtp32uzJWDml15lNKDNeZHKK
         4KZyv+x4dz1+nnWGRxO/ivm4KkBtBm+hJ4aqziLdoMxDeoKfiIIPqhf/NC6SJ/UMa/LH
         Yqx9LDEIqoQ/FeMKx7tnwsSvWWbXdRS/he+aWLC/UpfOFQnJpG8byOcOyu+S8gbmppfp
         AS7v1AngQ8hASc/GCZtLsqTa7RaFQ5RS/IAkho+82dkunnqhQb7qM8HbW23BlgWmuOp/
         FP34gQ5JvHSonjRcYzJKpfJWl0ePrLRb3WP8a4sIz4YdNcPhN9SU0VE+za78j2fjQvzj
         7Z2w==
X-Gm-Message-State: AOAM5328LVDkXerlfBTuUrFqb37NFOc21++9aps2AZP4hI8hs1xw+xP1
        Y+pKO8L6LzZ2VBU9JpEiNb/zyZ3n/EcGqpKXc6v52C+sIYHp3khg1dpEsKe+Y87PJ2WRO5Q/TUQ
        fp03jRPQDhFmk96DD4qNSM13VERuOFnAgZD6flms=
X-Received: by 2002:a17:906:8557:b0:6cf:2730:b5cf with SMTP id h23-20020a170906855700b006cf2730b5cfmr10757172ejy.368.1645296156513;
        Sat, 19 Feb 2022 10:42:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyiBlObuIE4yboQDPgcUgD7fnjCG8ClJXJKKeDYvCOmZcNc7+X05uMuAKMAKm2NUzCGxOVM8g==
X-Received: by 2002:a17:906:8557:b0:6cf:2730:b5cf with SMTP id h23-20020a170906855700b006cf2730b5cfmr10757162ejy.368.1645296156345;
        Sat, 19 Feb 2022 10:42:36 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id j8sm6680745edw.40.2022.02.19.10.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 10:42:35 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Wei Xu <xuwei5@hisilicon.com>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jan Kotas <jank@cadence.com>, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [RFC PATCH 6/8] arm64: dts: exynos: use 'freq-table' in UFS node
Date:   Sat, 19 Feb 2022 19:42:22 +0100
Message-Id: <20220219184224.44339-7-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220219184224.44339-1-krzysztof.kozlowski@canonical.com>
References: <20220219184224.44339-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'freq-table-hz' property is deprecated by UFS bindings.
The uint32-array requires also element to be passed within one <> block.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm64/boot/dts/exynos/exynos7.dtsi      | 3 ++-
 arch/arm64/boot/dts/exynos/exynosautov9.dtsi | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index e38bb02a2152..beeca27a7415 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -656,7 +656,8 @@ ufs: ufs@15570000 {
 			clocks = <&clock_fsys1 ACLK_UFS20_LINK>,
 				<&clock_fsys1 SCLK_UFSUNIPRO20_USER>;
 			clock-names = "core_clk", "sclk_unipro_main";
-			freq-table-hz = <0 0>, <0 0>;
+			freq-table = <0 0
+				      0 0>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
 			phys = <&ufs_phy>;
diff --git a/arch/arm64/boot/dts/exynos/exynosautov9.dtsi b/arch/arm64/boot/dts/exynos/exynosautov9.dtsi
index 807d500d6022..0d00543952c6 100644
--- a/arch/arm64/boot/dts/exynos/exynosautov9.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynosautov9.dtsi
@@ -311,7 +311,8 @@ ufs_0: ufs0@17e00000 {
 			clocks = <&ufs_core_clock>,
 				<&ufs_core_clock>;
 			clock-names = "core_clk", "sclk_unipro_main";
-			freq-table-hz = <0 0>, <0 0>;
+			freq-table = <0 0
+				      0 0>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&ufs_rst_n &ufs_refclk_out>;
 			phys = <&ufs_0_phy>;
-- 
2.32.0

