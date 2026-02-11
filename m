Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E92F27E054
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770816609; cv=none; b=T0qK1C1yL6x5PNJg8fvQzksqSzawp6AM6pqQn2dgucI+cJt0vXZYR6LAOjJ1WAoFejsSobkWWkpbj9l2YMpzEL1J6l9SC6lWGkC97rQWQmk2bfotNyw/oyzXUfbfyiT/ZpTXMKqA35DovGH8Na2i4wydngsBmH/zlgoxIf36Pjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770816609; c=relaxed/simple;
	bh=fUKuL3WnE7Tx4rKFOb25yQF6wrr5kmZz3j2yMUGlAhQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=imomeglj9GEX+0rCT4Aq1VN7+UUXEIO9fC18bK6I6zj02Wo3YwmdmzrcZeYmfy1L1m/YRAgw0N6kgaClE3sCmNzE/a1jbYIZb14+uANc4+lGydZhiEAmFuNxkvcwRhyMU2LVVxsRJFo0ZZU3ZU6Q7u3oXqIgg4mD6t5c5jrPwV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BV15DCeZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CHI6dxGd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BV15DCeZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CHI6dxGd"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BA7j9K4127432
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:30:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=+mSXJFmfYY0
	VhwXxSE2lAFNVkKKZxxlSmeb8NLwsIws=; b=BV15DCeZlv/N89lMGoS9k4HTBy2
	dHnMz78geIaPRjZ0gKTbPJxWk+iAB/PyoxPee5HT+36zWfU7G7KFVqYJ6zpnro3q
	Idbj5Fwz3y5I/hRUW8DEd5EJS4C3KfHxGy4yqOp0l6F4LuzXOk8rPK3p0fWuaTY3
	YhzlZeU/B1RKL1oj9j2RTp+gVjhctWb1APQ01ViqBuoKb+C9jTnwz+t3cICGMLAL
	UXr/FFFPnj8s7ZyCFfy1N6211ChuHP7jhPR+7wZ4F917CWgidBDhv33C0iv+wAms
	Sjbuf5WysHI4nPbH+A0vPJQ3ScEfES8UDw2/ywMptMl04Rky+ZV4q4HqLPQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c8gvm1w93-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 13:30:07 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-824a1d441e7so207713b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 05:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770816607; x=1771421407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+mSXJFmfYY0VhwXxSE2lAFNVkKKZxxlSmeb8NLwsIws=;
        b=CHI6dxGd3hO8no7RTD50Om31u7q+gCVXutnAHlKoS2PIOKth7bXE/QZP3rJ0tkVTSj
         CP07lBtZQO3EaHX7EvufaQblwCh4xdrTo3Ku4TDufREqkmcBEv97ekooWsoicty5S4ic
         KdU4aUj66YlYCkMsLg5mJbsXXfYCSzwHyfyw5h5QSKlB/yHiC17n1tSjFtN7shhlGO/v
         0HtPd7hds9kHxAQUL23zKenNU3q+N1ey9qKwTwHi5bHaVZhzbSJZ248OUV++l7o+OIyn
         /X0Bd+dbA5U+XaMepXj2rvqjoqqYXyI152Cz3vNqyARu2K24s/WQJuj2uNmbRrY84MYo
         jf6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770816607; x=1771421407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+mSXJFmfYY0VhwXxSE2lAFNVkKKZxxlSmeb8NLwsIws=;
        b=Bgvuf05M5lA2880C6AEY/rH+4q9jasX0Vel48mTOInisoVaxofIFEuvZjRCHkJvdMg
         yIRh2z4A+jXOxvoGo+hhwYOspTBh8NyoxaJ3obXxaOwP+4Du80/6FHQDgPCvHI4Dl9a9
         kcAoy1fMFlyTMeW5uryzzBxAi5QqhUWljfPEU99nFHwnY21pIWSzv45eQfUvdIJVucHI
         Z8wo7Ba2zZpuq49G4VYhNLyDlfqFb/IjtavTHODScG3ZCOZ1gRm5x0wA99xqhK4pi8aM
         p4QEfG+vUe93iWQYfHxBBah+7U/i+G3tREXBPaotayV1aKSp/WGamujNXHX8Z9hFuDaF
         1oEA==
X-Forwarded-Encrypted: i=1; AJvYcCWbuTj18MlNfENYYdRM+xC2uR4NYYQyG3RYmgjfxqtHHzEobiB27LLppIGF0oWAnu6IR93EjzbbOoZy@vger.kernel.org
X-Gm-Message-State: AOJu0YxY7HNjgFEwExbkdJNBCnu+sGT1uPtbHuwTxhoC+EuOmwAfnG6s
	ErwHJdZDJbfIJ0CsrKi70ZE75Bkog7LyiLOJ8T7D7BkrgDIIHkG62+hzGT77Os9G5xLs7q+JeVr
	+up8NyGWkoWr1r22/Z7/0KQMwq/X3IVIULWvUfnGiR28i9dzQXncupXLBFPHx5iv1
X-Gm-Gg: AZuq6aKcQ/sjARKMz0d3uYIXpo9qjPv+/G6yRzvORHUG8iXEV4P5EAYsLU5/+NLctV5
	JGoUXRFEs5XoMEGdBz9KoWHltLs+datSnu4SsFDcD9Wzi4A5dLhR78ILoSAYzl8rIWT12sqpWOK
	9YY5cZqz7B3hPRM1n742E/iIzg7RW4bWIP8l6nLgofdS+m7Pe4bLLihWMR/zF9WZhEWWpXJBveg
	HEDlTR1d88kRBYtWd3vUh9oTtZjn5aPbiaRjzw0w6HnjIOXz/xKJ8fCnIcl3PAuP4FILf1l31Sn
	+fi0QzYZeB8MAtsZQvptLt+NCA0wpLE+I4kzVmM1xQYZ9RphmW3rwq2wi9BPjoM+hCrqmDAvP27
	4IlxsDfb1PvURbRoGpm4DMoAI0WQWnCuh+pE7sojsRNecVEhzQ6yUVXBRpZLvBGzx
X-Received: by 2002:a05:6a00:390c:b0:7e8:4398:b36c with SMTP id d2e1a72fcca58-82487b039e5mr4959159b3a.63.1770816606493;
        Wed, 11 Feb 2026 05:30:06 -0800 (PST)
X-Received: by 2002:a05:6a00:390c:b0:7e8:4398:b36c with SMTP id d2e1a72fcca58-82487b039e5mr4959128b3a.63.1770816605832;
        Wed, 11 Feb 2026 05:30:05 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e84bc1asm2143655b3a.58.2026.02.11.05.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 05:30:04 -0800 (PST)
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
Subject: [PATCH V5 2/3] arm64: dts: qcom: hamoa: Add UFS nodes for x1e80100 SoC
Date: Wed, 11 Feb 2026 18:59:25 +0530
Message-Id: <20260211132926.3716716-3-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260211132926.3716716-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20260211132926.3716716-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=ctiWUl4i c=1 sm=1 tr=0 ts=698c845f cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=-wAyGzpI3j0i2zLxvnIA:9 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNCBTYWx0ZWRfX1YNqW6w6La6k
 6qlcaiQJriagR8r7xWDeyp5zuGASBkdVHPGulPlnzh7/Kg7gyBBh4fsuJUIXbGVz1Usr6hDFNEs
 7KIYWVvnY8XiGfA35RllaUr0wouzGfc/XOOkxhxhQH8DBYzFn2sZrCvRtTOze1kSC/y/ShL2yYj
 4/AhB5rsjRcccslZy9UWZEk5at68VkRa+LfOpfblwcggfu6XV/8Rt63hzGip9KfGV9yzkwMxjc+
 IeRJ+7D7Bhz/K+B3aOtAMx01jaBH8YdQqnccoaSmLaqZgIPB+yP4+c0JMI9fMKkkrjRR5yEeFw1
 f2X6WJypWfxD+P2YpEqf9PbgNd3HiT5Dy2WOZreiE/b7bt4k9JFk8k7H8siOr0sCEy1zLShzES0
 rU8narQQOkxkMy1VZtUURfq3kSnHTcNBgPk+IOzYPWUQX1CwOQNx4rw4UnUmbKmIikt3awXuO9n
 48HLgsYcXa4bcDkdpTA==
X-Proofpoint-GUID: -MPGAVAB6W0HSPcNCFOq8XTPWfz9PkpA
X-Proofpoint-ORIG-GUID: -MPGAVAB6W0HSPcNCFOq8XTPWfz9PkpA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110104

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
index db65c392e618..5bffff1046e2 100644
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
@@ -3869,6 +3869,122 @@ pcie4_phy: phy@1c0e000 {
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

