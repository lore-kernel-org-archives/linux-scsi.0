Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FE9346A04
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 14:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767624441; cv=none; b=AMNhmeyZ3SrrSz7Xrv0gSVIPOdPZDbJbqwxZbG2IeFsHuGZtBE3jxjxzP7Pm8H56UMSUCKTAn92wtB76Cwc1F/cZ1iKRXUenhPL0BiY9glhQJamJa3aCLwRlU5BvAfBdqwLTAAMlSO0xmTCFLNAX3Kl60Zdvkz44hXHgNynoJfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767624441; c=relaxed/simple;
	bh=BtP3KJSTm/EaNl5zwyenM7VokSI6RXZKCbo/90GvcmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BJ0K5hyWhnnX+cUaR3XJLnhCk3GSSdZXd4HAJM4PJXCgvOi1A4vw83FoTuitFmgT6So7byeXgAph/hwITIkyDKM7YEI+KMeq7jd8/pRsgytI7+dSPS++JeydphvJaMWYVQT0P2lK8tfSUJu8N9p4UVcqPDT6rL/t/44fuTzKjK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=okSFiEG3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q9Imyro4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="okSFiEG3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q9Imyro4"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6059d0KE610666
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2026 14:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=V1SgzhIA0n/
	lH+e8c4NhHPbIxxfyBNFnqJV0Yv3DTIc=; b=okSFiEG30LQSWOGkDuFOKMIJLZH
	ePJnXmAFozQE49DzKtVi+jOS2EJeI/UrK5SaIfP53l9e0iECp3ecMSA6KinX4Wd3
	h6i6oxBftPLI3KVqJHqcVRXDBmEmpGChiDzo5XK2tzYNRqz5ETfAID6uhhcb56iU
	5KTroax9qgQ7xfqsj5HQ2nCozNhkPQOOgtoGXtq/TOoXIDpdylR2n0Fxt+yen9l7
	GJjMeQGAdEPRAg8MKdGcFvRjkmCslovjcHH/H9d+ZUewcTOfCOFvGtkKcYFCAYwa
	lbP8pvbxfQqDJEQfs+XtTbwmuz7l6QuZNSE4cJIlvh+FqEtFlLHQ3CUxyOw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgaus0rq6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 14:47:16 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34aa6655510so25632a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 06:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767624436; x=1768229236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1SgzhIA0n/lH+e8c4NhHPbIxxfyBNFnqJV0Yv3DTIc=;
        b=Q9Imyro4EgLmd+rXpTm6hPXa4V99MKkTaSkb0qTpYq29OYOYYxqL5kPfww4SYoUeRU
         cRrL5NfbCPSTyWCQj/6Kp7IzLhLqrS5gyzEtaCoxnXU6uRStlkUsUJ37TkJ2o3CB+iAv
         CvM41S3ulyHdB4abd64bRdPBCVfsKUtTRV2OS5f1b3O36zt36fW+yS7+XxVRiWwSWtW+
         oq1hYCwMnBIbdiyV5/0QYM0ByBDaTJkNmgtBtzgNeo384+8hzeVieJbPuFw7Jx2J1VbS
         if3XANFq2ZZjj6QtdDwR7Lm/rWuC71gBCRn8xF05AzBYNxLQHxEcov7Dk/vyKvkz4zBf
         HGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767624436; x=1768229236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V1SgzhIA0n/lH+e8c4NhHPbIxxfyBNFnqJV0Yv3DTIc=;
        b=fhtSiU3pJcop11QyyeIVuwMcWEM4incZtfCEU7G7o3yP0H1w0XKT0WX8HAaVLQ0mJU
         gDHexL17919hp+S8NeIHVtWArPaeaMVvutq1RX3i2a5DeZ/pP0IOOJX94MgKDtkuKFtW
         USR0eiMS1q8WZW0z83MYcN1MQtNMfCzpUPyOGBiPHwOyLEyKOWWoEwyt3v2bRl7MCfVo
         BMaDey3IaJePfBjssytRAUz4ISnAdY+3PjJgN0ijMZmF80d3cDNNrfQOjE7Wj06+r+G6
         oqyV3+xs+nmRJBHxxWwyKM6iJKuPfcMdWn58ETMkrQCFzTfXD4W2yrn55k0B0GXBmLZY
         vJUg==
X-Forwarded-Encrypted: i=1; AJvYcCV5bZJs54yxPHzkyb5YNRzBmDPy9gzb+PaiFvfNhqa0s4qjcAaY2mQdwR9rXE47xzJ6GFhOlGs8rhjG@vger.kernel.org
X-Gm-Message-State: AOJu0YxtHmIxm2eWlsq0RWwQSlDsiIWNGnjnceXRC4R51JmqK0BAhabA
	VYhcO2jUAbxEPmukkcvHseNiLK+vdLhQPT4+aOHSvlv68STr2fZ8RuUxts4pL4Ll3RonGmBRutm
	FlUBkQ2vBgyKT1wto1V7l4OgIboSeuZLH3r+U1lh6CVxQi1XHSz4jvyxq4BN/CnYJ
X-Gm-Gg: AY/fxX5q9KvBAoLvc0Q3eSKBF34/T2G/i9Xd3ZKh5uQ8F00M9n2W2fizE2HojLp5Fkm
	I0awbtmJKUCNc0RASDQHeMPoROdHRBWoLvGkHW1mlXlo7sPy/WQTy/DJIP+cvDnIBOPQGlO+IDt
	oYIp9QI8RxtEPxoVvrjoQPk2Vfk3LlXQEPFb2Vd/g482zs4B/UROoamFmks4icLV6YRU4p9lHTR
	SUvf3JUJ8W3ZV4x3YZzNGQR5MH66KFCLnZKlEMaJjGDwhpMRjuaDIdkDbdGe5ZDiCc9RbXG4XEN
	26aEXwYI6qI5FUikLinosO/snTIOVTmMlkhRoOeMqc3gO5C4yH8MUHTOQJs9fs4S0ZshWNvBYl7
	kLHncK5kRrzFpPSBgfDceeIHqwtGNgQdkgE2pelOnWmHBmtAL+opM
X-Received: by 2002:a17:90b:54c3:b0:34c:2f3f:d27e with SMTP id 98e67ed59e1d1-34e92113230mr40042006a91.3.1767624436225;
        Mon, 05 Jan 2026 06:47:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEC0ntpKtEblnNYcl3KPIbge9nxcKn7exCL5e75nVmgyPbQLMaOfTGf4/gEXkYBasPUBxvShA==
X-Received: by 2002:a17:90b:54c3:b0:34c:2f3f:d27e with SMTP id 98e67ed59e1d1-34e92113230mr40041974a91.3.1767624435695;
        Mon, 05 Jan 2026 06:47:15 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f476ec311sm6634868a91.4.2026.01.05.06.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 06:47:15 -0800 (PST)
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
        Abel Vesa <abel.vesa@oss.qualcomm.com>
Subject: [PATCH V3 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for x1e80100 SoC
Date: Mon,  5 Jan 2026 20:16:42 +0530
Message-Id: <20260105144643.669344-4-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: FYP9wh96WV6c54tQyG6IfIhl5zkQJ7jJ
X-Authority-Analysis: v=2.4 cv=DP6CIiNb c=1 sm=1 tr=0 ts=695bcef5 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=-wAyGzpI3j0i2zLxvnIA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: FYP9wh96WV6c54tQyG6IfIhl5zkQJ7jJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEyOSBTYWx0ZWRfX8byQ8/iPpGFD
 xvTznr5OWfMy3D6nvfzoSY4OcvvE0r+crsj6GMui0wP3UDeD4gYRoHD4H2BuUKy2GyOnD9nE5Sv
 +7BkfQajRZfTtn5zpW0EozcXoyjJKGYsLI+x4wWZ2eUvZ4lS+iL4DexJAakkShSrI5r11pcDzsz
 t8hNL4/yv1cOpXJWPBjdz+ga+Zlqp/LNZxLtotIIREA8l1C9/DOqeMbfShI6xPkGwgFXuhKc6GO
 jiUoyPneXiQooNR6OtbKEDi40C0SJ7OP1to4CjXbqx1e49lnrJRJe9yP5kZYIcHT1wl1vOgr6jl
 pH9SosXUhBefm24TI2dGgBHJWvBr8XRsFqITdQu2Eb3BfEZKGi881jFg0mAiv6bB4MSi+Irkxna
 FEsXNuLLFHWozXMQpvei7QRvDzJjpjnoR4227UGenP5WjA+liu4ehWUmMybzMWrMlr0Pghl6zTf
 XpzBWolAbGAGaH+y9Ow==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601050129

Add UFS host controller and PHY nodes for x1e80100 SoC.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 123 +++++++++++++++++++++++++++-
 1 file changed, 120 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index f7d71793bc77..33899fa06aa4 100644
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
@@ -3848,6 +3848,123 @@ pcie4_phy: phy@1c0e000 {
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
+		ufs_mem_hc: ufs@1d84000 {
+			compatible = "qcom,x1e80100-ufshc",
+				     "qcom,sm8550-ufshc",
+				     "qcom,ufshc",
+				     "jedec,ufs-2.0";
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

