Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E015C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiBVPBD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiBVPAl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:00:41 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BA910E554
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:59 -0800 (PST)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 002D63FCAC
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 14:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645541998;
        bh=AXkZYdVX5Zodn+3WZgtIGj/ZSa6Qs/Xzl3ZJQ9geNsQ=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ENcy3AYPdFcEFGtoER2h5QD3vZwZM6W1hH+bG1Hfkvrl8YAgoLoQZeDu/1HfyKAqM
         iIpWEyV4woCcTKPT9Jj6gzfW8kWpCZhGQyFUM82owgN5jFG7zJDoYPYv2KE69Zy8bV
         9iDMfGXnCTHczEOTaB0fv7pMJTdLW+27uxLFxhABckSZBXlHvB8+ko3phuDbrD3D9L
         pyMTLcthx2y2ImjAxpBEsWBMa8APk+Ys3mWeA/HO3W7r26EEL9S/jaAC4k/JYbXToA
         bOd90q9E3dQF4ZpHkSmHD81r9GCWyg2NCr8khrb64AkY3kk1RbcMQPyEcbz69XBK72
         e8NSrgfrj+54w==
Received: by mail-ed1-f70.google.com with SMTP id e10-20020a056402190a00b00410f20467abso12088168edz.14
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AXkZYdVX5Zodn+3WZgtIGj/ZSa6Qs/Xzl3ZJQ9geNsQ=;
        b=aTKg/h4VbKsF0DEy1urGc61INVI4ENlPE6+sjXu1Fl8w+SWzXb5BQhUvvdYahJfRmC
         vB1paLA9dwGElDp0zKNXPF85TA4og6wdFcBWxWjtArffYerURYPdN1lmTSjRCaVTA46t
         6BDTffsrMPwUXD4TAIgWK1D3bfrAjhMLwo2LIddIROjCK2NTrNxDcK6Z2WcS9TxDGMQX
         zGbLKg+EBI5cla2NUqu77HCBttOjJnkAVkw+zTEVOHs1MDGY0aE7mH+sMdB1uBXSt2SH
         2LBD4PMbO6WwUuA4D8G+ygYRPLp1Cm4d1TUD2gV7hW11biDFz8k3BOPe3nVcluXslZqQ
         cfTw==
X-Gm-Message-State: AOAM530JbxyWiHrXO75Q9XP4kGLl0foZ92ObGPyxGxXKTN0gN8XWU+td
        vi7zjwgEkZbt9h6AgXCMnLTLSuGOTVJ6AyK74kjqhI/ghB0NfDaCZtzvJVB27V8on9kq0gRUJDh
        91xHMi4M7PLrXRX8Vasw5hxYELqJ1xJWUK4NtGuA=
X-Received: by 2002:aa7:c703:0:b0:410:b96a:6bf with SMTP id i3-20020aa7c703000000b00410b96a06bfmr26705750edq.439.1645541997725;
        Tue, 22 Feb 2022 06:59:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwfSFtNX/a3KL4lHPEAhSPb3vHh30FiudcrzDoMBrPmGyj5vo81xOj/2DV7Q8M391vFSdj/vQ==
X-Received: by 2002:aa7:c703:0:b0:410:b96a:6bf with SMTP id i3-20020aa7c703000000b00410b96a06bfmr26705712edq.439.1645541997526;
        Tue, 22 Feb 2022 06:59:57 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m2sm2467960ejb.20.2022.02.22.06.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 06:59:56 -0800 (PST)
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
Subject: [PATCH v2 11/15] arm64: dts: ti: use 'freq-table' in UFS node
Date:   Tue, 22 Feb 2022 15:58:50 +0100
Message-Id: <20220222145854.358646-12-krzysztof.kozlowski@canonical.com>
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
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 599861259a30..34aff40c6b8e 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -1257,7 +1257,9 @@ ufs@4e84000 {
 			compatible = "cdns,ufshc-m31-16nm", "jedec,ufs-2.0";
 			reg = <0x0 0x4e84000 0x0 0x10000>;
 			interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
-			freq-table-hz = <250000000 250000000>, <19200000 19200000>, <19200000 19200000>;
+			freq-table = <250000000 250000000>,
+				     <19200000 19200000>,
+				     <19200000 19200000>;
 			clocks = <&k3_clks 277 0>, <&k3_clks 277 1>, <&k3_clks 277 1>;
 			clock-names = "core_clk", "phy_clk", "ref_clk";
 			dma-coherent;
-- 
2.32.0

