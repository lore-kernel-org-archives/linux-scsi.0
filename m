Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C78EC433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 11:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbiCFLOS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 06:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbiCFLNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 06:13:44 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC84D37A2B
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 03:12:33 -0800 (PST)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 21F5E3F63D
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 11:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646565140;
        bh=5q3Cvfs96FMgD3OViDSeZ+rSi5cV583JAJ+X+hKXLOQ=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=okZaPcoN62wlDoNxRjU1gaIpgYPMQHNH58rMTFWD+hr1iz9Hfhvj94DrP36LIk8wS
         py0s850ymKBFJDDHjvp7AKSDiWtppoh8WLcPJLTh12URw9JO46i3b+8RjchBqTI/us
         L/q5nBxObFVgvMDwI/pHs5BN4+oTAyHQ5UlZkoNrtUNNmI6Tw41oAUnzFJaTcMYUly
         Ejdud3O3kJfbjqd3tA97nQxsyRwSqUMr68QuU0AMkc1fAy5AC8h7nNkRUdMd7Sl3LE
         C2dnZfutzwpRCENtYsO5FQmALz071qMI46rFK2qu28Flc6QaM9G2s3u/1aPAOqZpqy
         n/cUTvDygoL4Q==
Received: by mail-ed1-f72.google.com with SMTP id n11-20020a50cc4b000000b00415e939bf9eso4588599edi.22
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2022 03:12:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5q3Cvfs96FMgD3OViDSeZ+rSi5cV583JAJ+X+hKXLOQ=;
        b=rOQjuXL4xWGROV1bEjcfGbTnU6IfpFlaPlSkQ+YB92YQubnTvTt03tMJisYNk5XYKa
         dGmz9EwLDWFinuvMq/SRg8hY2UMb1v4tTETpG+16B8HLwpAgsn0fI5ZnJKZ1mIibWrkO
         ls7VOHqrFF6EFbJvBoJkI3pLJpuT5kZz2YVHKkXlLM/EXoGckMvoMsTT1JH5YSnnDSUF
         YrocTGkS2R8c9LKYTD4TwmWEWBCer/uGPRT4GcX6LQbXY1ttjHpb8oPPE8tqKvgXS1JJ
         +GXKZkPn4/1LbuwBXNAxCrb4Xt2zjBdUgz0HhJGyigddTGY2lDAteqAMiYXgNljbp/e1
         FZkA==
X-Gm-Message-State: AOAM532RHYv33+BliCrJ+OfrOry8BYTQMIIdRdbmPfsTU1Q3vFdXo2in
        f8ntmscgc3NOWSjr3GtjLEkAmg776ORyrQvzRjWP70W8GjlWhSF9VO5NeJ1kegx1DE4dYNejY7F
        kYU8twatTUNddYt8ZePo4DZZc7OlMTMJcGklH+mg=
X-Received: by 2002:a05:6402:278f:b0:410:d242:465e with SMTP id b15-20020a056402278f00b00410d242465emr6368189ede.292.1646565106223;
        Sun, 06 Mar 2022 03:11:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwW1Ya1zhxY85xcQnirVjPnpGI6XhFX2Sj/phtUq064BY75zEOeymYAnMlQ9+XNNG3HRgb2Sw==
X-Received: by 2002:a05:6402:278f:b0:410:d242:465e with SMTP id b15-20020a056402278f00b00410d242465emr6368175ede.292.1646565106043;
        Sun, 06 Mar 2022 03:11:46 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709066d4900b006da888c3ef0sm3720444ejt.108.2022.03.06.03.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 03:11:45 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jan Kotas <jank@cadence.com>, Li Wei <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v3 10/12] arm64: dts: qcom: msm8996: drop unsupported UFS vddp-ref-clk-max-microamp
Date:   Sun,  6 Mar 2022 12:11:23 +0100
Message-Id: <20220306111125.116455-11-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
References: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The property vddp-ref-clk-max-microamp (for VDDP ref clk supply which is
l25 regulator) is not documented in MSM8996 UFS PHY bindings
(qcom,msm8996-qmp-ufs-phy).  It is mentioned in the other UFS PHY
bindings for qcom,msm8996-ufs-phy-qmp-14nm.

The MSM8996-based Xiaomi devices configure l25 regulator in a
conflicting way:
1. with maximum 100 uAmp for VDDP ref clk supply of UFS PHY,
2. with maximum 450 mAmp for VCCQ supply of UFS.

Since the vddp-ref-clk-max-microamp property is basically not
documented for that UFS PHY and has a conflicting values, drop it
entirely as it looks like not tested and not used ever.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
index 7a9fcbe9bb31..3ade756e1cd9 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
@@ -341,7 +341,6 @@ &ufsphy {
 	vdda-pll-max-microamp = <9440>;
 
 	vddp-ref-clk-supply = <&vreg_l25a_1p2>;
-	vddp-ref-clk-max-microamp = <100>;
 	vddp-ref-clk-always-on;
 };
 
-- 
2.32.0

