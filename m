Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7593427700D
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766988452; cv=none; b=PP30MT3kErzQhX3+sZHK+DP8GfZblLYPZfyQ85HoeW4uCPZWACoRkyRgGMjCqjQgMzn0fQJSsJw6uces71CCu/8NQiwncJNmWsX1H0Ieij8Yg+s3d0GZbRKUPBm8BP55aBb63Rk7mcQuNsqXEZBgZ/hLBPUJOIsaG6GXvn4gUYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766988452; c=relaxed/simple;
	bh=ugZi69chfDlwVLwh0wQVguZ5zZnlOv0W8dElkUfS7SY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XRxXuLFR6f1CirHoW574I5dkqhGYmVKCNoB6dgvUUt8uRbRh+/zrmRgbdt0nBgE7l66IonQ3flJX7kw4dRQDDeBT6BZ/rJ6AmeY8QoTD5g3hM6OWSLzqualfLv5/fnK5GplXGNkOBOZObIhyjyk3vfX6aLRQ6WiP8DZ+jqICW/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ovDjmbWw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Qg+tDZhU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ovDjmbWw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Qg+tDZhU"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BSNLQqC3333269
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=l5AlLFE34Fm
	eV+ruRlv4pOkD3IhGXuAXKbbBjlDFXPg=; b=ovDjmbWwjIBeOBbeGY+AhBNv42T
	Me/Jwbl5FspCQm+L+/7DLSXbgUD2cn27mQ0B/BmqufzCUG95xL/8JWH13GMjX0CI
	xej4WcRHQBw+8qJQW93shgxQgr+EtDQ1kh0rGlobwSuNQvJCftgvJMGQADR/11N3
	4+N+iJUi3bXbM3TcRbmjUspOQxjNzVKpuVexpcFQ91bUlnQ3khH5gVW6b2/q2a9k
	dOuTjkMWS7tkwG+dg0GVNhlkO42+pYIkXbnmSOjWaB6V82m9TAn4SqUk7BJn6z18
	82dw6anb2cs2rCMrDeTM5ZUr2kJPRtPwwYcZ7ilWucqCW6ENsJps5n5CRVw==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ba4tnuq52-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:29 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7d5564057d0so20882017b3a.0
        for <linux-scsi@vger.kernel.org>; Sun, 28 Dec 2025 22:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766988448; x=1767593248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5AlLFE34FmeV+ruRlv4pOkD3IhGXuAXKbbBjlDFXPg=;
        b=Qg+tDZhUwJgdKo3YRQYkJaT4+GNHJzwKgz6deKaEPyC8OyfP2jG568XUS10OMDws1T
         KpMzRKZWV27yh5gRM4SFY4logcCFbd9y6P2Wm5V4Oy1nV2po5B1UXIvbt60zzC4M1VHg
         ZGrlpWTlGB2kiB3cqIiV7FqPOjyKl1mW+gSLixUZXdMPXMWeU8akPEn7u83n5RM4/cTU
         GZKOVL9qqxQ36lTee2bnuHnfu0hV7P1Kt8FC4uCO4U5J/oQp4ujt68z1JZ01SC8pTWOn
         ILNmUYZTs9m9dsm1nHxJzpZueEt7DXiPrE7S0tvc2i3dT8pOZgi+jizmM1gcrF6J5QOb
         zGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766988448; x=1767593248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l5AlLFE34FmeV+ruRlv4pOkD3IhGXuAXKbbBjlDFXPg=;
        b=qT2X6pnK2I9sZJrcCakj2bGNOiH5BFuDYEfBECyGlSwkxAA4ALsjZcX28RinSNE43N
         vIv9boOzk9E2di+gxJVucAXP3tEF9HwP6AD8p3W4CDlvAZcCE+0cKglTwxwXBPr3iqjZ
         X/uc3q65Xcrz/7mcfVCrLG9NNXd0EyOKB+b9yyazHVaBGU4HfHDfd9ZyRTizDzzUB9V0
         FamX3z4dcCciSzPtZL4jWyU/ImYYERunUQ5xUs7jV/UGvMWCX6Cn8z11ZTAx5ulnFnmv
         gA3/MAlSlX2qcHSLxSLUaHhYMCI8P48HMO2VuYOMMMT7LckMPEeRJqWa6s39plqgCz6z
         ZDTA==
X-Forwarded-Encrypted: i=1; AJvYcCXHW3eBf3FZXwcF3f6pP1ok4LmD3+SXFJo7DjVQpGBeBWW2abuPHL46MERILBE5A1fAyc2KAVPRjXs1@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6VEJTLtKS/bO6n9YiYAwz+jqHC9cTWFHTYMu3qBNxlWknrD1b
	rg/iCVJNU+6m3Q6Im0+T9YNNEwJemndNC7JBYzE7Vt6pZl9C81rrbXBLKrMiNuvCdIar9d/f94p
	oephYe+tIA4QKH1/fPZtnK+Hbvhq0egaSR7497+QzWOBtSLlObWnH+gJMahQmDcge
X-Gm-Gg: AY/fxX7Z4Yxzws1b8EVb9//zJexvB39k4aWqpX3CHAbwwayA2W6nG/PyyYZyZGAYi1a
	TyvlFK4u0r1soI1xtuyEe0vXlrONVzD8tzjgMpgJ2ECKlOz1lP3ipdShOCeCTAXefVkqL5IaORU
	6+shrGteWToQIS5uc75VumdfFIb17TjhR4xAiNIslh2FVdJYEEaHjckqCPf6HbJjOhr7dmwMTCB
	dsIp8RJTKcVD3H3nVcm2pRYL74RQuTuCNaTkzfNeG5M2AArVbi7MLdtdLLI4loteld2FnLjHExY
	HMcLsb1TxQI5eoNwoMIQF5OQ+3eYyThQ7VttBy4M5iiu0uGluEf2cfgJhlHrMqgG9K0/aZo/mzy
	9GZL7NUjzHHEZ6V5AkuU3Ls2uc3rMV0TnSBT/mjdjss/CWnFmGMZ9
X-Received: by 2002:a05:6a00:414e:b0:7e8:450c:61a0 with SMTP id d2e1a72fcca58-7ff66a6ded0mr23813226b3a.55.1766988448084;
        Sun, 28 Dec 2025 22:07:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFbToU29sSeln6IBU3gpubsp2YRrK0fCKY+pEKgI319gR8j0RPiSLM10K92Wv5lHcLvo38cXA==
X-Received: by 2002:a05:6a00:414e:b0:7e8:450c:61a0 with SMTP id d2e1a72fcca58-7ff66a6ded0mr23813207b3a.55.1766988447570;
        Sun, 28 Dec 2025 22:07:27 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e8947a1sm27917763b3a.67.2025.12.28.22.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 22:07:26 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH V1 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for hamoa SoC
Date: Mon, 29 Dec 2025 11:36:41 +0530
Message-Id: <20251229060642.2807165-4-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=G+YR0tk5 c=1 sm=1 tr=0 ts=69521aa1 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=t4k6GlNMiQNeD8J6t2QA:9 a=HbcSV5I89lm56-yt:21
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-GUID: KsHVw35rdDRvK1HhzhfzseFZBmoNEhOR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDA1NCBTYWx0ZWRfXxJGDu+Zbw+7n
 oXs6I6T9AbjpYDNrKSO7fvG5/kNVxZKrxOQZpslsMEsEpysga4liLaYusgAsNrizeIyZe8IxxnF
 8OXU2NLS+y4tFKQ/hNUL2eDeS0xtjmEDffAzutK6TeXRAZs3HsEIot4nE2QrbuIp8r65PmoYXpm
 wlDBhtBfZ31GDi3GPm4wNLMVcEqrw6sYSCrcUi+MHETc1sna1WfHao5qFKsQleIlnoX2fQNNJFm
 LRp8ZtuPskk64rPIcZCNclo8Yu+pQCPNgIx7rxEvvrttYaLOXNJSC91YLmW6FJP9meSWWeDUQqq
 DxSAYVUTf18CTWVj/8cSWhZBQgNwpgwm1HEohTqir99hMl2N7CL3mGQ5ThLneGvKZNF3jsbiRBX
 F4kNJgEnUI6nT4GsbzxRaD2XzjKJetbN899UFdqkShp//b9ukfkgJFGz7+SrRn7VPCroiAXmf53
 HyQyaNY+gP16BsuyLpg==
X-Proofpoint-ORIG-GUID: KsHVw35rdDRvK1HhzhfzseFZBmoNEhOR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_01,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2512290054

Add UFS host controller and PHY nodes for hamoa SoC.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa.dtsi | 119 +++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
index bb7c14d473c9..340b907657be 100644
--- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
+++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
@@ -834,7 +834,10 @@ gcc: clock-controller@100000 {
 				 <0>,
 				 <0>,
 				 <0>,
-				 <0>;
+				 <0>,
+				 <&ufs_mem_phy 0>,
+				 <&ufs_mem_phy 1>,
+				 <&ufs_mem_phy 2>;
 
 			power-domains = <&rpmhpd RPMHPD_CX>;
 			#clock-cells = <1>;
@@ -3845,6 +3848,120 @@ pcie4_phy: phy@1c0e000 {
 			status = "disabled";
 		};
 
+		ufs_mem_phy: phy@1d80000 {
+			compatible = "qcom,hamoa-qmp-ufs-phy", "qcom,sm8550-qmp-ufs-phy";
+			reg = <0x0 0x1d80000 0x0 0x2000>;
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
+			compatible = "qcom,hamoa-ufshc", "qcom,sm8550-ufshc", "qcom,ufshc",
+				     "jedec,ufs-2.0";
+			reg = <0x0 0x1d84000 0x0 0x3000>;
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
+					&mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					&config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
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

