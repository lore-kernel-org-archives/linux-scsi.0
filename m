Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1534DC6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 12:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjBNMDf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 07:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbjBNMDU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 07:03:20 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9901125B83
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 04:03:06 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id g6-20020a05600c310600b003e1f6dff952so842124wmo.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2023 04:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Neaw/O5slnDW9QMSl2Pz+9MncBXuZqGk8eJ99UPon8=;
        b=Hm+4BMd/MVWPVIKyhB8mQ3zNke9rmeP6luGeppyGvB6u5BEqZbOPFdG5lVKsiaimdf
         63N/1wKzaBgDCXWRi8QhhUB41FhfAKYCwbFSFW5JslxxUE67qDn1lXpYHl5SeUtqKlQE
         8oURD73w3G/qXQ4WCyReRb7hA3TZZTd0eSBm7A/AGxuq8C39EXhy5uysD8y12LhOVwLm
         9M7r8pHfG0SX7IlKJ6Uz+4i+7bQoZo3SEjg/+vIu8HTCVdwtTGg2iLaj3UB9LeNHKF5p
         PhCPWVFcSRj4hnz4UD6N6C/vU5lOp/dhGZiu5eBJA0z9Am6PvUUs3uCVB2fH9o1kkcxx
         7UzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Neaw/O5slnDW9QMSl2Pz+9MncBXuZqGk8eJ99UPon8=;
        b=zbGosEJ68t6ZwKvu3Pyv2hfxf8ujprPytJLHTmKSgNdlNEe8qNQCEDd848ZScpabzb
         w1Ms6syCV4LjTnqz1EyKZyGW90CvShJNA9l4nquJ0cOGVvV6hnq1BbLjKW8N7Ymdc478
         sRY1wQh3hfam3ZL94zZIOZPTyJQTlCCCQfKUrycyLX8d3zkSDGXn6gGMCRaj3LWTkYb4
         gNwmWMUVtNvwnUsTvvlBK/R8rwkQN1ouONd9p0cr3cWf/3LNeRRzkA8TZ0LP8K7n5Bmi
         fYrXeF0J5jrEX4flJBUFZS9lZ6fzXTsgQvvXjS9ukpkri1+Ke5IBvbO5CIOw0YyzaWNE
         UM3Q==
X-Gm-Message-State: AO0yUKXnhOTSm7VfYXBP0BgcNTxY4CfOLdVYD8831lTHrizfL8pjofkg
        zXMA2LCyNlJ6mo5AyTjrHXc2gw==
X-Google-Smtp-Source: AK7set9A6IJNKj2z6u6LryLL21uK4+nRo7suFA9VL+da+opeVI3AEQ5IC8/V6ow/stQ3g1ogLAAKGg==
X-Received: by 2002:a05:600c:3095:b0:3df:f860:3089 with SMTP id g21-20020a05600c309500b003dff8603089mr2462314wmn.32.1676376184286;
        Tue, 14 Feb 2023 04:03:04 -0800 (PST)
Received: from hackbox.lan ([94.52.112.99])
        by smtp.gmail.com with ESMTPSA id l40-20020a05600c1d2800b003dd1b00bd9asm18834846wms.32.2023.02.14.04.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 04:03:03 -0800 (PST)
From:   Abel Vesa <abel.vesa@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [RFC PATCH 3/5] arm64: dts: qcom: sdm630: Add the Inline Crypto Engine node
Date:   Tue, 14 Feb 2023 14:02:51 +0200
Message-Id: <20230214120253.1098426-4-abel.vesa@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214120253.1098426-1-abel.vesa@linaro.org>
References: <20230214120253.1098426-1-abel.vesa@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drop all values related to the ICE from the SDHC node and add a
dedicated ICE node.

Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index 5827cda270a0..67a6a27619d8 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -1330,9 +1330,8 @@ opp-200000000 {
 		sdhc_1: mmc@c0c4000 {
 			compatible = "qcom,sdm630-sdhci", "qcom,sdhci-msm-v5";
 			reg = <0x0c0c4000 0x1000>,
-			      <0x0c0c5000 0x1000>,
-			      <0x0c0c8000 0x8000>;
-			reg-names = "hc", "cqhci", "ice";
+			      <0x0c0c5000 0x1000>;
+			reg-names = "hc", "cqhci";
 
 			interrupts = <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>,
 					<GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
@@ -1340,9 +1339,8 @@ sdhc_1: mmc@c0c4000 {
 
 			clocks = <&gcc GCC_SDCC1_AHB_CLK>,
 				 <&gcc GCC_SDCC1_APPS_CLK>,
-				 <&xo_board>,
-				 <&gcc GCC_SDCC1_ICE_CORE_CLK>;
-			clock-names = "iface", "core", "xo", "ice";
+				 <&xo_board>;
+			clock-names = "iface", "core", "xo";
 
 			interconnects = <&a2noc 2 &a2noc 10>,
 					<&gnoc 0 &cnoc 27>;
@@ -1353,6 +1351,8 @@ sdhc_1: mmc@c0c4000 {
 			pinctrl-1 = <&sdc1_state_off>;
 			power-domains = <&rpmpd SDM660_VDDCX>;
 
+			qcom,ice = <&ice>;
+
 			bus-width = <8>;
 			non-removable;
 
@@ -1382,6 +1382,12 @@ opp-384000000 {
 			};
 		};
 
+		ice: inline-crypto-engine {
+			compatible = "qcom,inline-crypto-engine";
+			reg = <0x0c0c8000 0x8000>;
+			clocks = <&gcc GCC_SDCC1_ICE_CORE_CLK>;
+		};
+
 		usb2: usb@c2f8800 {
 			compatible = "qcom,sdm660-dwc3", "qcom,dwc3";
 			reg = <0x0c2f8800 0x400>;
-- 
2.34.1

