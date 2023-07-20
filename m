Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26270EB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 05:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjGTFnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Jul 2023 01:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjGTFnE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jul 2023 01:43:04 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777FA2723
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 22:42:33 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-53482b44007so192200a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 22:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689831727; x=1690436527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUaVdZJ28qH1inEDT0bdOsxGBg7b/AdUYV5SKgyveWU=;
        b=mh1H/anh338JtwO3z10DsiXxyHqIkGBPUCQH1SlsfJOR5z1W73B+9IYQ5Gdt588Bbk
         MhtTYC9SLaLZ7oChxbHvWWtTZdsYeyTSfItYfPgkj+fg+ORnnvGl2oQTsSFBFh7E2dYE
         Yxr8jDaJPBxxsTy9Uollrp3BoTGPgj74Ro5rTJUVQgltAF2OWG8upOtKqx8mVt+j0KQo
         ElIM3TeMiZLyQWhBYRHX/ctsMI1sY21GW17Ktbc9Hgh+22q+RdlviNnZCm/DTaxlnw/r
         pyQVDszDxXuwXDEGh8YTdkjLqDfr4o8Ggk2XpVQ8w6iM3KvVOlwFBvNGE0zuRC6fVoWg
         X8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689831727; x=1690436527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WUaVdZJ28qH1inEDT0bdOsxGBg7b/AdUYV5SKgyveWU=;
        b=GDn5UTF18xvrLgZtJ6ol/BN65mvXz7f5e8w/yRZYP907H/YjxMwZ5nPTXtPP36xbid
         IsiaqxnJY3frIn6E18BpLaTcGGMynOg6J6hLQ2DIlzVYxlybV5XW6/uK/9MUUGvWnY0U
         653l4DyCGmyfQ4Buck6iJTcujSpwWvwVzxjUBPJNpXkN8gN+J6JfQ9j1OuDWIo1D7W5W
         6IR8/XTKtE5A3FuLg8NhxJohZu+TcPRLBwo8P5MxTibKSaQT/9hfkr340obnn1Mm/dA/
         Zofsw9JGa5lRRfkpZRCBVzxkmYLLHDrso6qQNZViwUXHqJ5HM+khXpe3Fo22mJDb6rp6
         HQNA==
X-Gm-Message-State: ABy/qLYpbAVB1Yp64ssvXaEsEmlZb+HDulEIzMEP/2SeZslOBdqqAqVw
        z08fuLPgOLzDi5vPDuwskIzL
X-Google-Smtp-Source: APBJJlHdJJHT8pomhZmx6MwnSWLmuvtkXIUZ6UJieDMEcrxmojfWRmgSamoma61dciQ8UZExOidTNQ==
X-Received: by 2002:a05:6a20:4c9:b0:134:d823:e3aa with SMTP id 9-20020a056a2004c900b00134d823e3aamr3785080pzd.36.1689831727584;
        Wed, 19 Jul 2023 22:42:07 -0700 (PDT)
Received: from localhost.localdomain ([117.206.119.70])
        by smtp.gmail.com with ESMTPSA id r2-20020a170902be0200b001b85bb5fd77sm263367pls.119.2023.07.19.22.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 22:42:07 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 05/15] arm64: dts: qcom: sdm845: Add OPP table support to UFSHC
Date:   Thu, 20 Jul 2023 11:10:50 +0530
Message-Id: <20230720054100.9940-6-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230720054100.9940-1-manivannan.sadhasivam@linaro.org>
References: <20230720054100.9940-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

UFS host controller, when scaling gears, should choose appropriate
performance state of RPMh power domain controller along with clock
frequency. So let's add the OPP table support to specify both clock
frequency and RPMh performance states replacing the old "freq-table-hz"
property.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
[mani: Splitted pd change and used rpmhpd_opp_low_svs]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 41 +++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 89520a9fe1e3..e04a3cbb1017 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2605,18 +2605,39 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>,
 				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
-			freq-table-hz =
-				<50000000 200000000>,
-				<0 0>,
-				<0 0>,
-				<37500000 150000000>,
-				<0 0>,
-				<0 0>,
-				<0 0>,
-				<0 0>,
-				<75000000 300000000>;
 
+			operating-points-v2 = <&ufs_opp_table>;
 			status = "disabled";
+
+			ufs_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-50000000 {
+					opp-hz = /bits/ 64 <50000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <37500000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <75000000>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-200000000 {
+					opp-hz = /bits/ 64 <200000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <150000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		ufs_mem_phy: phy@1d87000 {
-- 
2.25.1

