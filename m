Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF48EC77B70
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 19:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbjDFTra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237874AbjDFTrV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 15:47:21 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B253D8A63
        for <linux-scsi@vger.kernel.org>; Thu,  6 Apr 2023 12:47:19 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i9so40626354wrp.3
        for <linux-scsi@vger.kernel.org>; Thu, 06 Apr 2023 12:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112; t=1680810438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdoFuvtIQt2NqvRE5WG6+GxxM/OuV38vuGKtX+YJ/oA=;
        b=SvFxuanpWLhcNjuey1PPT6Kber/vnFoJOSqAB4aJX37Gp+zGhrgBd5cnkikwvVVstz
         k39TEWIBgJIVt0gn2tNH5znrIuOAACrCmY7NsazbHzORG6jwHEnPqrg6PHlSnPUDxJoy
         gzB2GJBRX60/og19CLchYBnP53Ax5oXPEPCKfwD6UZnt9jfo6gk5sYiOGlg9vk7KrFon
         G3OjiJ0wK5fQQEmIpIDzMMMAROicAayWvfNJ9UV9c7N85olr2qhLPt28tg6a+/JMBlOo
         nZqokLp0RiWhvQdbeWdYgeKjyyVudyqWHcNCNPepCi2ufCpkFdcrfXo8DAMT9+Ti1WfF
         qf1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680810438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vdoFuvtIQt2NqvRE5WG6+GxxM/OuV38vuGKtX+YJ/oA=;
        b=kexIekhnQU6oSgJCw5USRuBtGPoHaC3ksABT6N5BY4QWW1WKZzIxYYSla1eYShUKND
         3Q+FXRY4OPvLdpW/e51tBENy46Khs/pxcgWjpP8jjI1p8sHrlnZNiA9YnIwDRVk3thSE
         0KRXME16pVh5nevqNbMYFKYObcfTRu/FGG6y/cEBvmgX0noXl5nasnuX5uHv8KNBEP6x
         K1lYO+HA/BYO2h0VVUF+5OFAgV6urBr3nm8f/Dw8jE9hgZ5r0e05OhoTGNEDYlnIBw4o
         gUy2YpdTS200EElZmfKVeJpWjt7dqTT/r1NW5DkR8p6pDPxKw7V/6efFMX451W1JitFF
         paiQ==
X-Gm-Message-State: AAQBX9fxTXmCzvxvCoHkL9Byyh8R46DIG1Ez2PuF/Br8c61YMm6cmKum
        8LVV8mh6UkDWRW24itZQODDXzw==
X-Google-Smtp-Source: AKy350aNnlf3gSYxJSTtE/BexI80dm8UtqpOVNHh8HpGfQPy/nglUjePfhBAir3VH2FNKqX403IzBA==
X-Received: by 2002:a5d:63cc:0:b0:2de:ffec:e48a with SMTP id c12-20020a5d63cc000000b002deffece48amr6997346wrw.29.1680810437811;
        Thu, 06 Apr 2023 12:47:17 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:4793:cb9a:340b:2f72])
        by smtp.gmail.com with ESMTPSA id k15-20020a056000004f00b002c71dd1109fsm2593323wrx.47.2023.04.06.12.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 12:47:17 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v2 4/5] arm64: dts: qcom: sa8775p: add UFS nodes
Date:   Thu,  6 Apr 2023 21:47:02 +0200
Message-Id: <20230406194703.495836-5-brgl@bgdev.pl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230406194703.495836-1-brgl@bgdev.pl>
References: <20230406194703.495836-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add nodes for the UFS and its PHY on sa8775p platforms.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 58 +++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index 2343df7e0ea4..5de0fbbe9752 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -585,6 +585,64 @@ &clk_virt SLAVE_QUP_CORE_1 QCOM_ICC_TAG_ALWAYS>,
 			};
 		};
 
+		ufs_mem_hc: ufs@1d84000 {
+			compatible = "qcom,sa8775p-ufshc", "qcom,ufshc", "jedec,ufs-2.0";
+			reg = <0x0 0x01d84000 0x0 0x3000>;
+			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
+			phys = <&ufs_mem_phy>;
+			phy-names = "ufsphy";
+			lanes-per-direction = <2>;
+			#reset-cells = <1>;
+			resets = <&gcc GCC_UFS_PHY_BCR>;
+			reset-names = "rst";
+			power-domains = <&gcc UFS_PHY_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
+			iommus = <&apps_smmu 0x100 0x0>;
+			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>,
+				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
+				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
+				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
+			clock-names = "core_clk",
+				      "bus_aggr_clk",
+				      "iface_clk",
+				      "core_clk_unipro",
+				      "ref_clk",
+				      "tx_lane0_sync_clk",
+				      "rx_lane0_sync_clk",
+				      "rx_lane1_sync_clk";
+			freq-table-hz = <75000000 300000000>,
+					<0 0>,
+					<0 0>,
+					<75000000 300000000>,
+					<0 0>,
+					<0 0>,
+					<0 0>,
+					<0 0>;
+			status = "disabled";
+		};
+
+		ufs_mem_phy: phy@1d87000 {
+			compatible = "qcom,sa8775p-qmp-ufs-phy";
+			reg = <0x0 0x01d87000 0x0 0xe10>;
+			/*
+			 * Yes, GCC_EDP_REF_CLKREF_EN is correct in qref. It
+			 * enables the CXO clock to eDP *and* UFS PHY.
+			 */
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
+				 <&gcc GCC_EDP_REF_CLKREF_EN>;
+			clock-names = "ref", "ref_aux", "qref";
+			power-domains = <&gcc UFS_PHY_GDSC>;
+			resets = <&ufs_mem_hc 0>;
+			reset-names = "ufsphy";
+			#phy-cells = <0>;
+			status = "disabled";
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;
-- 
2.37.2

