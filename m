Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1674C43217
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 11:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiCFLM5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 06:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233304AbiCFLMs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 06:12:48 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E6F60AA9
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 03:11:56 -0800 (PST)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 85A3B3F1C5
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 11:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646565107;
        bh=xb1NVPmzCu//acWeZYDa5U/h0JIp5bKXDfT7rDv6gyY=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=S+4p8kkhbzibOv19ElYbW8rCy8jjtXInu9Nuvt2vjkL9D/QtiDo5lRZttAwuhpyhm
         YEODHPcgioh1ithfzDj3VLQx9E0Ed6+0M5yrn38H4jGZb3SlPFKYQlCDPeJMu3Ta/r
         0p21lZxSGA8RLECAKpgHVR8M9176QNAJgaXGhSqOkJLqzUwCyHi6MlwkjwgcGa1WQ3
         FzxixdX/aaZEhiOoWoUOEFWb2Rl+VsrTF13LNU1GExR/DsdSFKa2CgtnSw2L0+gNwi
         3AcsLVu770sWzSOwVKjJE1hb2tMNl6D/cZwSLIdjdlqDhfX0i34nbL6AmvOonYrOg1
         o5pSHgjvp76YQ==
Received: by mail-ed1-f70.google.com with SMTP id x5-20020a50ba85000000b004161d68ace6so1641614ede.15
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2022 03:11:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xb1NVPmzCu//acWeZYDa5U/h0JIp5bKXDfT7rDv6gyY=;
        b=ZvvKN0yXZQnFg8emYe/gIqvo6TTc9XPrtJUdBucwiS2azL6jAk00uWKCdPljwVZW4L
         JjOxB3QITlmYeZULwsyeGYk/s1i0R32aOUrSfpwla4Ul8dH056GoQdvdqlcZJ0JDqnZu
         tDMVLIPnyWyvMl7xJodPXcdBU0SAk+nyvCljCaj4HTwSSZNcK7QH9ugw2b7sNyObr2Ww
         IQOAeBTvDglPb0KHxyVW5PLusI7RJCS7y1ay4Dk2kjowEs6bnV08LcFUcUQ3SmsQrGXW
         IsmHnI5T60szkgSkSrKHJfciQvq4688N0wkdvVoz56JTxqgzW57sfw4Y6qNqONudTezn
         N3Kg==
X-Gm-Message-State: AOAM5301NhbMXVUm//igm9T3P5cm5zhZn7qwvmDV81t2+1nbDxNr5p0R
        bqzslumPLYYVaMEEgG/0j3w+HdtFX8TuMBrYP6qQ6jnVWLB6b1m8mmqoRudubGcxuK+trtfpRQ5
        l4G67XoglHZ7MPDJOitVRm6mbfpwQIG5+fEM4eZs=
X-Received: by 2002:a17:906:3ad1:b0:6ce:a880:7745 with SMTP id z17-20020a1709063ad100b006cea8807745mr5480161ejd.46.1646565104762;
        Sun, 06 Mar 2022 03:11:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkqOPNZGWUEHHQJ1DdvnKzAnwvejxildLb9k95BB+Ex4BtuNUf/GcST/RwEz/yOnL8XuyPOQ==
X-Received: by 2002:a17:906:3ad1:b0:6ce:a880:7745 with SMTP id z17-20020a1709063ad100b006cea8807745mr5480132ejd.46.1646565104528;
        Sun, 06 Mar 2022 03:11:44 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id a9-20020a1709066d4900b006da888c3ef0sm3720444ejt.108.2022.03.06.03.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 03:11:43 -0800 (PST)
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
Subject: [PATCH v3 09/12] arm64: dts: hisilicon: align 'freq-table-hz' with dtschema in UFS
Date:   Sun,  6 Mar 2022 12:11:22 +0100
Message-Id: <20220306111125.116455-10-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
References: <20220306111125.116455-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The DT schema expects 'freq-table-hz' property to be an uint32-matrix,
which is also easier to read.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi | 4 ++--
 arch/arm64/boot/dts/hisilicon/hi3670.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
index 8bd6d7e8a474..6b3057a09251 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
@@ -1045,8 +1045,8 @@ ufs: ufs@ff3b0000 {
 			clocks = <&crg_ctrl HI3660_CLK_GATE_UFSIO_REF>,
 				<&crg_ctrl HI3660_CLK_GATE_UFSPHY_CFG>;
 			clock-names = "ref_clk", "phy_clk";
-			freq-table-hz = <0 0
-					 0 0>;
+			freq-table-hz = <0 0>,
+					<0 0>;
 			/* offset: 0x84; bit: 12 */
 			resets = <&crg_rst 0x84 12>;
 			reset-names = "rst";
diff --git a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi b/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
index 636c8817df7e..3125c3869c69 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3670.dtsi
@@ -671,8 +671,8 @@ ufs: ufs@ff3c0000 {
 			clocks = <&crg_ctrl HI3670_CLK_GATE_UFSIO_REF>,
 				 <&crg_ctrl HI3670_CLK_GATE_UFS_SUBSYS>;
 			clock-names = "ref_clk", "phy_clk";
-			freq-table-hz = <0 0
-					 0 0>;
+			freq-table-hz = <0 0>,
+					<0 0>;
 			/* offset: 0x84; bit: 12 */
 			resets = <&crg_rst 0x84 12>;
 			reset-names = "rst";
-- 
2.32.0

