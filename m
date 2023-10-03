Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0C7E7544A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 11:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbjJCLOB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239968AbjJCLNw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 07:13:52 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C878FC4
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 04:13:38 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1c724577e1fso5790495ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 04:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696331618; x=1696936418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0fZoRzqsVsl2DrqFfH7FNxDnDstpZGeIPe8SX7WYfkY=;
        b=mE3tyuTssyR9u7zxZb1EfssSkpsODPYSX+gPI1iHVW055RQwOL2XmkOcqcZY7Fah41
         fpqsc8FhIiedASF9A4qXbM5MTretnSsYfQ9X75sdSxaeRbs5rGop/0jf63BZLQT8cdUu
         9UgTNagwilTkKMl1jXgXnAIbgZB2ylFc2CXa3iMwGUOscvrJ6hGroVlqTtZPfnnCWHdP
         YG9CJEimI9Why6Xw8je1kVc9uOzFSDu/oEnbw40yMhMhBcAW1PAX9skZOgMFLIsFtEfd
         QXznWgFZcD6/MzJeeR41zToYIguFNagGt0geYkPniecxzxw9TYvKOKjTS0P7VNN47NJk
         vZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696331618; x=1696936418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0fZoRzqsVsl2DrqFfH7FNxDnDstpZGeIPe8SX7WYfkY=;
        b=NWe+eET+edFRvgC3SZ/VtMaMQk+DD58wYaBT+TjlgthVdWljNxQEGyV6B7AxgB2JVk
         WKDiZe+ADrwPqq+9qHptiQIup5D3Xf+99pjbdZLJP7w2NHMLyNgK1F+Vm9zHIGD+fMRr
         azGaR1rsGa/hIJKtLG5sF7lmdGjy0Av63Av2EYYJOcvneGJkunJjOYdZebGm+ObaoDE0
         Odi1RWgLhVXcrriiUpoOarucyYi30YhjxSInYtPNY2oAtOtIA9usvNlzlHUCaSaOVp5I
         kHCZySkr4eparaafSYmqooyXHlXKLfzK2Dv21lk781HJqH1IVLDdor+c6fSYiU6KnIPl
         hDFw==
X-Gm-Message-State: AOJu0YzV7t/RekcfLxo3mEnoRbf2hWfye/ITzImiYna90HtDlro86Hbs
        +Kn2mHBGJn2P3YF91MyD0bUL
X-Google-Smtp-Source: AGHT+IHimmOQzpDGDJsIUW5ccfjJhRsInwIKVfH6YjjvLY8aQEgOfwuc6gtSNSt75+EIe69jWEejeQ==
X-Received: by 2002:a17:903:2348:b0:1c7:2661:91e1 with SMTP id c8-20020a170903234800b001c7266191e1mr17095416plh.15.1696331617759;
        Tue, 03 Oct 2023 04:13:37 -0700 (PDT)
Received: from localhost.localdomain ([117.217.185.220])
        by smtp.gmail.com with ESMTPSA id d9-20020a170903230900b001ab2b4105ddsm1250328plh.60.2023.10.03.04.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 04:13:37 -0700 (PDT)
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
Subject: [PATCH v4 5/6] arm64: dts: qcom: sdm845: Add OPP table support to UFSHC
Date:   Tue,  3 Oct 2023 16:42:31 +0530
Message-Id: <20231003111232.42663-6-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231003111232.42663-1-manivannan.sadhasivam@linaro.org>
References: <20231003111232.42663-1-manivannan.sadhasivam@linaro.org>
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
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 42 +++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 055ca80c0075..2ea6eb44953e 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2605,22 +2605,44 @@ ufs_mem_hc: ufshc@1d84000 {
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
+
+			operating-points-v2 = <&ufs_opp_table>;
 
 			interconnects = <&aggre1_noc MASTER_UFS_MEM 0 &mem_noc SLAVE_EBI1 0>,
 					<&gladiator_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_UFS_MEM_CFG 0>;
 			interconnect-names = "ufs-ddr", "cpu-ufs";
 
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

