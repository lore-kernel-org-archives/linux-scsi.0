Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4090D33993
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714160; cv=none; b=p504Csx4c2d0upfEXcRKfUPYQoShFm9jjieEG9d21NXMeARX/gcEbercG8VNY+Q5HIvssha9zzTrQ1+nxToxCgaP4oLXomPo/HnUnRGTOUPz7DDio0dLglE7di3HpPca5D+oP1fdvh5w00Tlm8QwoHYuFL7IRdIy1wAQKc5LOZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714160; c=relaxed/simple;
	bh=1VvOuhWjvj71xqQt5RYWXApfWEIxQvtC71cwobnVVu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bvwle4mcTMaFZT4zKiVLQdoEl6CDm3lv0qf5yYVvBIXyfXc2BCs57B7iSjyGLVihT/PolnRK/RPJEgDkUoluRDl+FHZHsa9wKiArXj/oMjaYVk5ngAvcmfARM/LtgEZnctpYFRHEvSAC0yMCSpv+8IXtXSKFFnAy+gzm/ISqnrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eyytB+uV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TNvaF3MB; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eyytB+uV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TNvaF3MB"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606AXpPv2429817
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 15:42:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=MLIJ2bjx/wd
	klJkhrSWUlgRRBVAS9xQIXwyJjqZ7yCo=; b=eyytB+uVPnyJa9vFr/B8gLZaHT+
	T2qtPt5JgWioJOE0XxNRhDo4py8MOIifY0zujjXIZPo2va/iG9lZN5bH9lWgZJBV
	3/00mULF3N28foRaYxPUSrioP6UWDRG+QmrMcrcJC57JQCdfdfwfdtMRuSCH6Cyk
	1kqKAoRLnQRPGjQeBf35f+WgswbK0bgKN3Dx45u7cFSumANDFCpnYYTDxGdXFj7H
	NLKdsNn5H572jjyjPN1f3EnXOaXEzd09p/Qu7//Rbabchrtp0ze1m2B6FlUfzao9
	zUGKYIkZcMOnIjItolyrmmFicjvf4PgbQDdPs638atr/8x+rIt0XTpG9ztA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgr73ac3g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 15:42:35 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29f177f4d02so24135935ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 07:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767714154; x=1768318954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLIJ2bjx/wdklJkhrSWUlgRRBVAS9xQIXwyJjqZ7yCo=;
        b=TNvaF3MB4zN6oq+BROHVhGfVlc+ZpcthKUsoaO6Sts9UytjFZod/Ueh18baoqix2hV
         evhRHiChDM+zl94AkiZ4W0fS3T3aVuuwZCBG6cC3G1HegwZpv8YGskkGLOSMFNXcJwEy
         8og+PfCl7Li8lfRHRCix5CFCDeGpoJSFSq+Si2l6wmLQjkWQ2bGFOh5sSjKlAvCYgH14
         a8s3tCbGeeRNLlghnr8DGBwSe1kQ1JS0p1QwyI580Nbf+xsywVpT+METFCsyMgFthhAk
         QhAJ98AKw8UI2VxOI8CEvbWCOVmmOAbqpjOs+JH+RI4ju/BMoYxwhTkTy4dze1CsE0eI
         MdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714154; x=1768318954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MLIJ2bjx/wdklJkhrSWUlgRRBVAS9xQIXwyJjqZ7yCo=;
        b=NQ/rXllYUbMeKPC5k5OZ00ZZTVm2NhqdETviuOfJZJfV+CSEunudftmjQgyUd2gJZi
         vzQA3hPCNAplpur2MVbfnbut7TLpewNct9e+EZGhCxu5UFFpIz5NYMUgQteIaRPaygqf
         3Ltl19AsH3Ym2ooLrBSKlnQsL94BiC7uwUFLG3jlvwcLct2ya2NNmAnGwn9puD68P5xr
         TLhnFsOMjhklT7PAC7aXt8hSyOZc8cB6i7bdQHjHX4DE3mraw0I5tsnZ8lCGQODC3dj6
         GkqIcG+V7vMb2npwW8o05YIZSfGpRIVHHljFJt9XWomOrL73N6ZfgW2Rdsy0zUTiwVx/
         y2jw==
X-Forwarded-Encrypted: i=1; AJvYcCUarC5lGcKEX7/iGl0t/4o01ITTylZHto8wm8p3j1Lv7JbEfDnV1NB+Go0qNaeu8RiDcubbEQivcK+4@vger.kernel.org
X-Gm-Message-State: AOJu0YywIXqsPQiFQB0PH+ZuSoDjzRr4O8cr/ueyJcchlEwkqE0Nygrz
	NVc4PQlsAbPVTwcal20r5Htep0g6tAePDOc2wqKhflIVDPMTDCtOV6XiCYzq7yI4+1xpC6FK82p
	kluliLD8XFw9RZ35bBc0p6JQHZWHfFUhnjMQFdi77uwiQwiq6/1zpy4EcDCQTN0hT
X-Gm-Gg: AY/fxX7XPkbv+hiHx1tJCaJkCepw2DLPHJvSSDupVDS8BXaosaGFvuXEl6E4Z19Yw0m
	/ZYFwj3CLBomnVBrg8M8rsY075JCLis/7QjQEjAajzyzrzwYnRaJypieY8jBNRLZx1E0hJXzmYs
	EQG3q05G2Q11JgBJ49m6+epP0+UQyYIaGDsZbSZVqnGdWItY2ciAWMN7y1iZcDGMucXnaejKWmd
	/tuuPC/37XOi6fMdT7kqcVwBaANwNSi3RKl9Tgoo/rdWZ0u51+op9ZO0FMMP7h68BpziReKjdYo
	3VyPth36aV/+8bCtUcHo8iMRLhOWKU1Y/ef/X5vUCOBs41zstxupXP7GLjbeO3Dn2ucLSbT6mFY
	GORgOUWxi2R3895Oio7X8QiF/h4qRiXMsC93jbNVuJF7PNjDPc2PU
X-Received: by 2002:a17:903:28d:b0:2a0:e94e:5df6 with SMTP id d9443c01a7336-2a3e2d50ee6mr31548935ad.50.1767714154446;
        Tue, 06 Jan 2026 07:42:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG8z5h8zFxPhnIGTIfe++GibD1jOODn/FGkyxORNyREEj+xu/75UvgF1cMqHKzdEKJIebZ7MA==
X-Received: by 2002:a17:903:28d:b0:2a0:e94e:5df6 with SMTP id d9443c01a7336-2a3e2d50ee6mr31548735ad.50.1767714153970;
        Tue, 06 Jan 2026 07:42:33 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd492esm26606395ad.98.2026.01.06.07.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:42:33 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH V4 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for x1e80100 SoC
Date: Tue,  6 Jan 2026 21:12:06 +0530
Message-Id: <20260106154207.1871487-4-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260106154207.1871487-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20260106154207.1871487-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=QrxTHFyd c=1 sm=1 tr=0 ts=695d2d6b cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=-wAyGzpI3j0i2zLxvnIA:9
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: t_vv_1rsPsj3aenLTJ9UeX4Thhc6rxyq
X-Proofpoint-GUID: t_vv_1rsPsj3aenLTJ9UeX4Thhc6rxyq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzNiBTYWx0ZWRfX7kK7Sm8f5Lu4
 T3N3nQ7PskYSbuip0P53b3nQav/cE+1d5lX8FnZl8CRUXh2YMvcEDOUeQGwKdI49O100qoO9UFQ
 zKnLRS2e9sD+PyxRyVevsXBmk4k1VWKEUayl6OoMpK0+mRn+7ChTQzjXziKsxyNTK2+XtVLAf8O
 mR9cm+53G6ZhCktnuLUcQ1JMcEnEgCAN4orWaCnwg7q2Vze7GP5C7/jKAA1bV5NSyxkvqM0uOTV
 Xh7Lp0+k5HXp5qRlLdTwGZj1M5qce/cebsf482jnAHzC+e5vbn/UAAHHtP082lA5/Fd0/n5xk/L
 nQePHvy3ptNhZK81vjaoLS1v8OSJ48kPf3xho29r2UrLMFMWX8sK80pUU8CF8SHWWgPMFmtUbgQ
 IDH8xKBSka81LqpXL+y50mSoGkKYz816G0jNn9/o85cPNmomRBRHUOH7wuivTZ/w3m4xzKHRJ5v
 +oJG6NkPrK1uQzFt0CQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060136

Add UFS host controller and PHY nodes for x1e80100 SoC.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 122 +++++++++++++++++++++++++++-
 1 file changed, 119 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index f7d71793bc77..25c838102280 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -835,9 +835,9 @@ gcc: clock-controller@100000 {
 				 <0>,
 				 <0>,
 				 <0>,
-				 <0>,
-				 <0>,
-				 <0>;
+				 <&ufs_mem_phy 0>,
+				 <&ufs_mem_phy 1>,
+				 <&ufs_mem_phy 2>;
 
 			power-domains = <&rpmhpd RPMHPD_CX>;
 			#clock-cells = <1>;
@@ -3848,6 +3848,122 @@ pcie4_phy: phy@1c0e000 {
 			status = "disabled";
 		};
 
+		ufs_mem_phy: phy@1d80000 {
+			compatible = "qcom,x1e80100-qmp-ufs-phy",
+				     "qcom,sm8550-qmp-ufs-phy";
+			reg = <0x0 0x01d80000 0x0 0x2000>;
+
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
+				 <&tcsr TCSR_UFS_PHY_CLKREF_EN>;
+
+			clock-names = "ref",
+				      "ref_aux",
+				      "qref";
+			resets = <&ufs_mem_hc 0>;
+			reset-names = "ufsphy";
+
+			power-domains = <&gcc GCC_UFS_MEM_PHY_GDSC>;
+
+			#clock-cells = <1>;
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
+		ufs_mem_hc: ufshc@1d84000 {
+			compatible = "qcom,x1e80100-ufshc",
+				     "qcom,sm8550-ufshc",
+				     "qcom,ufshc";
+			reg = <0x0 0x01d84000 0x0 0x3000>;
+
+			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
+
+			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
+				 <&gcc GCC_UFS_PHY_AHB_CLK>,
+				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
+				 <&rpmhcc RPMH_LN_BB_CLK3>,
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
+
+			operating-points-v2 = <&ufs_opp_table>;
+
+			resets = <&gcc GCC_UFS_PHY_BCR>;
+			reset-names = "rst";
+
+			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "ufs-ddr",
+					     "cpu-ufs";
+
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
+
+			iommus = <&apps_smmu 0x1a0 0>;
+			dma-coherent;
+
+			lanes-per-direction = <2>;
+
+			phys = <&ufs_mem_phy>;
+			phy-names = "ufsphy";
+
+			#reset-cells = <1>;
+
+			status = "disabled";
+
+			ufs_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-75000000 {
+					opp-hz = /bits/ 64 <75000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <75000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <150000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <300000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
+		};
+
 		cryptobam: dma-controller@1dc4000 {
 			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
 			reg = <0x0 0x01dc4000 0x0 0x28000>;
-- 
2.34.1

