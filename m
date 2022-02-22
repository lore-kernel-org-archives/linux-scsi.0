Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAA7C43219
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiBVPBZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiBVPAr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:00:47 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86E510E57B
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:00:02 -0800 (PST)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9E4F83FCAF
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645542001;
        bh=5q3Cvfs96FMgD3OViDSeZ+rSi5cV583JAJ+X+hKXLOQ=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=nvdcbnQ/xZ0r/RwvKIgZjHzAx3TJAiFIdoDMzVLTuLmTgk2SudTNQ/zerpVZye1ry
         vbySq38AVmiB3qAKeGAdfUifhW6BlX1WZtmZ63fl0RCi7BU7C6jkNQrCjgAbcSefu7
         GKeafwVaWoWWMLyRqaM2hg8qZC4sPwnUSdtgTOTD1GLvFncixf+4o9dlUEHtSt7Cpm
         ZAR6q/fQ2IJC/OCvEu16LXK34c3BnlNGU0eQtQGD4iRB7WfYP3c8JNZF+HJbxft8wu
         vkBX0ZNmkTjcdZKVmsAFAObQqUoL1e4nMsCR7RRiAXTA+ytFjSszY5ZkGqxbB6ny+6
         NQxsD6tWpP4Rg==
Received: by mail-ed1-f71.google.com with SMTP id r11-20020a508d8b000000b00410a4fa4768so11988152edh.9
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:00:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5q3Cvfs96FMgD3OViDSeZ+rSi5cV583JAJ+X+hKXLOQ=;
        b=x0lW5lqY9NAcZQCmGWVQQPmwlOwhLut+INTT7ur4tcTI02vLy35Bk+rxq42AjoQu+F
         CFNVfDnFg1pafwtCws8/o69YaGWEO33M9s5QitxyQl/KMrkbStM0bHzKPca/nO6JXDg8
         IeJNG+mbr7zt86MfWWeLxSIg88QlLMDKjeL5a2p8wlGhkpZlBlQG25hPZ7tp+9RZZw4b
         lDzYgGgVvB9CglJtSzKQ1f8XnmrpruvtEu5dIfawXkBM0DKIa2KPSTTt7LdYJftE4VEm
         ZM3VioQb9wjXDfIObn/3Oy0xgQOcH/+qEabr8jqF5qv/bR1t1EY5w3BXwf3bCViDJXl8
         N2sA==
X-Gm-Message-State: AOAM533GJRLsaZinn0h+bGeNR/jJVDo2AWFZeoU3yQxLCyMyRjq6bC2n
        Wa/C79sC4Q2QcFsffFP9mmujfP4ZCREMkmdRKfd4lzhvKRh8c9GRMRSy6Ai+AKSWYhdVv4dzuIE
        mfudMnqUy5gJ9jegV6VXK1TXEldj0WG7SK5CusYk=
X-Received: by 2002:a50:e144:0:b0:410:d813:92 with SMTP id i4-20020a50e144000000b00410d8130092mr26862677edl.9.1645542001140;
        Tue, 22 Feb 2022 07:00:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyMw582wnovmDAi/CIh3lxLYM2LG2ODyt+mkZ0ZiJXVQxrV8hjaQpoxhGRnSRAJris1bHJ60A==
X-Received: by 2002:a50:e144:0:b0:410:d813:92 with SMTP id i4-20020a50e144000000b00410d8130092mr26862658edl.9.1645542000976;
        Tue, 22 Feb 2022 07:00:00 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m2sm2467960ejb.20.2022.02.22.06.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 07:00:00 -0800 (PST)
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
Subject: [PATCH v2 13/15] arm64: dts: qcom: msm8996: drop unsupported UFS vddp-ref-clk-max-microamp
Date:   Tue, 22 Feb 2022 15:58:52 +0100
Message-Id: <20220222145854.358646-14-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
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

