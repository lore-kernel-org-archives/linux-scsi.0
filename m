Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE44C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Feb 2022 18:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiBSSqV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 13:46:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242897AbiBSSqT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 13:46:19 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE573178BD0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 10:46:00 -0800 (PST)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id F2A8C402E6
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645296359;
        bh=eJ6HQrRnH7eCjaR+k7F77ct8AqISDRTidseB01nTcCM=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=jW6DWiNMtuUSYkoNS8Z4CjBwgSwZWnHasheVPDyf/SEXPf0Kqd4gz4/uWX93BCqaf
         DIDAorSTOqikEiiMyiE4zNULFYSjD6OkAVFycqPI4oN6W877AYAueEeY6F4feARK9L
         T4HdgSqrXn2uQSCYhYgJnSXVAa5TY7aMdSXUil87qLmJ44PMOlwxMIlx8iPp/4mYUn
         09Z7iFFgJ441Em/zQU7bAS3r2B34T+/WzhiYoWnx0V+sJUfIE7Mazoj1DkkDhnpZie
         nWiMVywTwJwsiDe1d5kKGB2riGstPaeRPorch0bLSd9kflBBFowD8O+69VKpo1ee4Y
         rwM1AfU1t1+Wg==
Received: by mail-ej1-f69.google.com with SMTP id q3-20020a17090676c300b006a9453c33b0so3799406ejn.13
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 10:45:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eJ6HQrRnH7eCjaR+k7F77ct8AqISDRTidseB01nTcCM=;
        b=iv55yGu67X99OwH69FaK3VjcKzhSbl5A+7s42s29PuDYk/8NtoUhqbM/840VzyFcT/
         2jVU8tjJGzR/pHWcnoBRm0HxxtrI1u6d71mquSx0YZ1c9G95zdTaklEuRfBr1qhsqBCC
         J7bML+H2aIG6jmZLXf0LUOwpFlksKgZe0FfklkCFFvpDQku/DpBFcq5NhdENoldgG7j9
         48eqaAvc2rLk6VetGmsh/O8lCnStCJc9JSI/1f9rmATPMf4eRDXEOI4clCijP5Bh3vUH
         lyraHSDbbLZwX5OcKfWHIZDAe2oEtqQPhY90T6Ga3bOGpKpGJU4OAV0a/m4R0qI3RVbk
         /M9A==
X-Gm-Message-State: AOAM5312SNEh3JUz7WzKQF8Kv+hqEIM2xTidjdftFK+5ZXCNSW938qHe
        sGQd7d90AswqwKVg8OSE0IKlsSQcBF300yJMoZw8VZqKoI4vMb9EmZDXtFKqS+2K+8lhK9Carne
        9kHgirs+1WLbo6CWWyQl9zLSrvrbcJULfG9DQKh0=
X-Received: by 2002:aa7:c612:0:b0:40f:2a41:bddb with SMTP id h18-20020aa7c612000000b0040f2a41bddbmr13789842edq.291.1645296358467;
        Sat, 19 Feb 2022 10:45:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCUQahoUlw1/KaqiAKlfUzjGeKC0o8en5bVZWTPpKsIDqk+8vzgYr9LfT4H6VG0K4MxnLXbw==
X-Received: by 2002:aa7:c612:0:b0:40f:2a41:bddb with SMTP id h18-20020aa7c612000000b0040f2a41bddbmr13789828edq.291.1645296358336;
        Sat, 19 Feb 2022 10:45:58 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id j11sm4847509eda.106.2022.02.19.10.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 10:45:57 -0800 (PST)
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
Subject: [RFC PATCH 8/8] arm64: dts: ti: use 'freq-table' in UFS node
Date:   Sat, 19 Feb 2022 19:45:54 +0100
Message-Id: <20220219184554.44887-1-krzysztof.kozlowski@canonical.com>
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
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 599861259a30..c3afef0321ae 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -1257,7 +1257,9 @@ ufs@4e84000 {
 			compatible = "cdns,ufshc-m31-16nm", "jedec,ufs-2.0";
 			reg = <0x0 0x4e84000 0x0 0x10000>;
 			interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
-			freq-table-hz = <250000000 250000000>, <19200000 19200000>, <19200000 19200000>;
+			freq-table = <250000000 250000000
+				      19200000 19200000
+				      19200000 19200000>;
 			clocks = <&k3_clks 277 0>, <&k3_clks 277 1>, <&k3_clks 277 1>;
 			clock-names = "core_clk", "phy_clk", "ref_clk";
 			dma-coherent;
-- 
2.32.0

