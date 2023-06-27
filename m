Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8002BC001B0
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jun 2023 08:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjF0I3B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jun 2023 04:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjF0I2Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jun 2023 04:28:16 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1AC26A4
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:28:10 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-98d25cbbb43so643256666b.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jun 2023 01:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1687854489; x=1690446489;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j8uhdc0vGRhVZn7i76kQPqxuDPzGvhRMJMMuHesHRx0=;
        b=jA3lP92ZFZ2gqMx6lDW6O07ihkd3l3XzaGJxuC/g2wtwdnfKVTbxH8xMCmMBhFkAfn
         XhRWbXQmZW9VfqvKgM9V/ufYcXvvOcE0Pr7oqA1TBEw8ivcUkqoOPWNrFgbJc/kxkxw3
         fyqQIMK2YqEJvvN/YHps3MSQuC08HiFJ5o7pDNwEVCWtwE1efv8ygroRZZlTrho0NP//
         9EER9mVtiNQMkxuGU1pLiLj8pD8fcA4HObgafIcVSDg0PCVhE1Kfqz0au+iBg6dl2wRa
         cyN6klB5VHWvtkGIH/be8fHAYD9RHnPxEtksmQEkAZHUzs2YDxBi4nBDRKY6ZhLbl8E4
         Asag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687854489; x=1690446489;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j8uhdc0vGRhVZn7i76kQPqxuDPzGvhRMJMMuHesHRx0=;
        b=LqPOm1XP0Cyu0n9uv8xfVZBF531bc5SbC6CJIVI/ELy9GjkCsxUfNLLqpjITiNZ3WS
         fZ7ZP80x02hDYZC2JFbJ3HfBbtYDJcDEjvIkg+mk4ZyUliH+NP/p83wjUFOPc2iQdcQD
         WSRhrTDmBwqgIuyuUEFwgISMdvkjT0DwSVY7Q27mgsH7EpEo9EC1vu/GzL/jo59xlSOZ
         lgpxzXhFPx/9XBFaY7ArJEDve4DriSRYaqI6YEdtuUeAmS0yC/piscHS3OQ7VmmKF/Fp
         N+MeKs7TLSG+N4nSlSK29XMYGhcdKA8GDr1rA0wr4jbeRmH84D/W41h5LzMNQF93foet
         rb1Q==
X-Gm-Message-State: AC+VfDwAleue5R7zzgHFdn5X2jHYmwUq4EHZWwMwLEnp50HWbxfqVzwX
        nhq8T1oO89Odz9yb7Hf+jNgTXA==
X-Google-Smtp-Source: ACHHUZ4b8ooGad04xAZNZR46c7dDBigN6joEZVBjCg51B/ahsXcmBhiabKcqs0pCUO20Iz0Jg4YNQA==
X-Received: by 2002:a17:907:5c8:b0:974:7713:293f with SMTP id wg8-20020a17090705c800b009747713293fmr29242940ejb.41.1687854489185;
        Tue, 27 Jun 2023 01:28:09 -0700 (PDT)
Received: from [172.16.240.113] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id kt19-20020a170906aad300b009894b476310sm4253038ejb.163.2023.06.27.01.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 01:28:08 -0700 (PDT)
From:   Luca Weiss <luca.weiss@fairphone.com>
Date:   Tue, 27 Jun 2023 10:28:05 +0200
Subject: [PATCH v5 5/5] arm64: dts: qcom: sm8450: Use standalone ICE node
 for UFS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221209-dt-binding-ufs-v5-5-c9a58c0a53f5@fairphone.com>
References: <20221209-dt-binding-ufs-v5-0-c9a58c0a53f5@fairphone.com>
In-Reply-To: <20221209-dt-binding-ufs-v5-0-c9a58c0a53f5@fairphone.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Iskren Chernev <me@iskren.info>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.12.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the ICE driver now merged let's convert the ufs node to use the new
style.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 5cd7296c7660..79627117a776 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -4120,9 +4120,7 @@ system-cache-controller@19200000 {
 		ufs_mem_hc: ufshc@1d84000 {
 			compatible = "qcom,sm8450-ufshc", "qcom,ufshc",
 				     "jedec,ufs-2.0";
-			reg = <0 0x01d84000 0 0x3000>,
-			      <0 0x01d88000 0 0x8000>;
-			reg-names = "std", "ice";
+			reg = <0 0x01d84000 0 0x3000>;
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&ufs_mem_phy_lanes>;
 			phy-names = "ufsphy";
@@ -4147,8 +4145,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				"ref_clk",
 				"tx_lane0_sync_clk",
 				"rx_lane0_sync_clk",
-				"rx_lane1_sync_clk",
-				"ice_core_clk";
+				"rx_lane1_sync_clk";
 			clocks =
 				<&gcc GCC_UFS_PHY_AXI_CLK>,
 				<&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
@@ -4157,8 +4154,7 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&rpmhcc RPMH_CXO_CLK>,
 				<&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
-				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>,
-				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
 			freq-table-hz =
 				<75000000 300000000>,
 				<0 0>,
@@ -4167,8 +4163,9 @@ ufs_mem_hc: ufshc@1d84000 {
 				<75000000 300000000>,
 				<0 0>,
 				<0 0>,
-				<0 0>,
-				<75000000 300000000>;
+				<0 0>;
+			qcom,ice = <&ice>;
+
 			status = "disabled";
 		};
 
@@ -4198,6 +4195,13 @@ ufs_mem_phy_lanes: phy@1d87400 {
 			};
 		};
 
+		ice: crypto@1d88000 {
+			compatible = "qcom,sm8450-inline-crypto-engine",
+				     "qcom,inline-crypto-engine";
+			reg = <0 0x01d88000 0 0x8000>;
+			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0 0x01dc4000 0 0x28000>;

-- 
2.41.0

