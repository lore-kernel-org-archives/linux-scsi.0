Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9563F6601
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 06:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791354622; cv=none; b=UtYBVwK/BB2nr1hKsu+RKrZ20Ygp0hzzKGgPi6p1ecX4YWYL/xICBIoBLTQJOvhLkJ3pWaOeGZN9cUJZF7Oz3ppJYvy4lv7hRV9HQh2imtUZMCkrksa+Sx/iG/g3ExvTPWEnrAcu/C6flWOqdxwXXcPilqB+U5VX+2qvpCpCcU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791354622; c=relaxed/simple;
	bh=9kyv/RmQosGyDp9VxTpU4lmroLa4HPs6mFTgIA1kMzM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NvabXFC6Ud1aJe+rk06GUOpdCkIsoKbNJQW9bhge8H9v1NMyNry75vCyyWM/E1Hx2QY9isGKNgVAUnH3eFHVIW+hRvFjgJNJy4k+C5+mj4P6Ka8H4W3Nb9FSrpHD2Sxd3F/32g6I1FnVQd/szH+lPkwF4omY2o2RiBe3OXcTuAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nUQAjtFE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hxyMmo+9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nUQAjtFE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hxyMmo+9"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6974UDWB2916126
	for <linux-scsi@vger.kernel.org>; Wed, 7 Oct 2026 06:30:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AtE/d8mRsSzaG79+2m8aJWMacLBckY8idc15SCnRGq0=; b=nUQAjtFEhukq1u0t
	99/equNAUu62g8UPBCCk9tAY9Eh+YEcpsPswlGIRrA33C9SvjYFab80dHw3KFQe8
	iW+/kwG/34VSa0rm9XFfvcIj5XJv4oBcrTzDYBhlULAwjJdvYF0C8zkKqQJjkG6u
	cWafnYS/VARzftwhKROsdhidHgvu8qB9C2tT2jYBEo0eJ06Q0kD/r/4VLz3Nm9IW
	dsNXiuR4rgIrRo5sEzWwcFUqqzpk6tVJ8wlAzBcDVkDJJht7cvbUs4wmpEn5LVDn
	cyKC7cxR9w6hJE5eZFOD399FmhG3+kJ6s66fkRGY0OPJyXHKkU0xj5k1d3Mzb1Wi
	GM5Zvg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h54622twe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2026 06:30:19 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a7d2f25f65so1223934a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 23:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791354619; x=1791959419; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AtE/d8mRsSzaG79+2m8aJWMacLBckY8idc15SCnRGq0=;
        b=hxyMmo+9vxRUJuLv/ugmtMvhphx8a5Y0B7pzSX8SA4r5tONYUpK4AvDYKTYpvyBUbO
         t0wJau1K3XxF2/LtrfsNcHuYFWpVIp4YzUwIgpAGcY1y9H+ZpEKt1XbSjU93ss7sC1Sm
         iH1uO9ZYgVG1WZANQkYVGC7Dnmg/G/kLwzNwGCG+cMihKh/Pg9iDLO+3BcfaIFufTTai
         M9JZs/YstxXEnfsmpCclKmnPxsLW4VupGGVV9o8phU9M/kI3RR9Z3f9lSyCgf+5Co1al
         YCn3neKtyfXuOC6kRkSjv/uGTeqdn+rS93GWtFpz5/IzxO8TxutwtGj/TftzcA77AcOE
         swFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791354619; x=1791959419;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AtE/d8mRsSzaG79+2m8aJWMacLBckY8idc15SCnRGq0=;
        b=pw8zZ5ky5tpjA29KGvw3HRpuj5f8UT0i5hFY7yue0BYSLHjy4A7tsfGircft8ekaRX
         DuNzNE4NJ4aEn44gNBHcjEEFfMODlWYv3vvlrCepeweg6YyvWjiYmBocF06s0aFmrkHD
         r8n6ANGPNIq8bNVbV1/7DvI+WY/POzk2f7so/kct28o9msE+wrRkNNaz1GRNGElJLiLX
         aQ6ZcyHE0QCoM3bPv9yOc/sW4IH2xLRipeI/MI0I2iGw2nU6jcy4T1KBo8SWEhSP69u8
         jZpaXJFfkvcA1YwCvfly0dI5I4vKNi1+XhkNBoruJFSxmkAlAh6JbgaulRaK5NO7kPGx
         jFIw==
X-Forwarded-Encrypted: i=1; AKwUvBzJP+R2CjC/qKE6Zp+VRBUlDBtlLH/Dlr9ygBmfYMBzqzXkvnfdBUf90U8v4sUWAREkOMrAwE76eJeh@vger.kernel.org
X-Gm-Message-State: AFq9FYK1WJfYcf1TX5ejDNFEc901pEcwzALFc7d5VpeAkbBlakTf+8GN
	iPaWUovqgdCkDbEkoIt8lCIMXZqOzE6A56Mq1tEPGnBaGLk2kyoXsRyh8/TkRFxkUU9g9nDbtPJ
	gD8XCZjxUnxOWnyeR8kRZAXj4vWN6XIzJwR7h8n06mdjDqf4kxlo1MAWNoVYzxBhD
X-Gm-Gg: AYBFou25K6LiRvWXf+cp+c00Jv8kj+bgszclgvKeNeD3X0jqkADOdSXTzNNHkp3nfox
	bDCJo44MXIw7fOFhVT4cLxhJQWOjDnLHxcakXAunXsZlWBkIdFbUIQA/IjgkPyHUUOftHBQL3QH
	Ygn87xusDrm7GFOJZEmQ/5rHCA2kfgAqKGPvwEOJAWH3U+tKtqLk6NsWYKxNJYkoWj7qzP8Bgcg
	ARrhwWUd5HzMRyw0zRl98qi9TxOb4i4NA2YBz4FNppw3SJQs+MHdpLwOh4x8bbzK+uTKAolYEXQ
	8WUa0xr3amIZoypQhviuegYMpfoHyE7eYES1/2osRkSKLHGQJok/iTIRlBibHE583VjJtnbrlzs
	gKgiIpvxuEHyrHILIiQnNoL9kVg==
X-Received: by 2002:a17:90b:2ec3:b0:3a4:cf85:aef with SMTP id 98e67ed59e1d1-3a8545cea12mr2865696a91.25.1791354618719;
        Tue, 06 Oct 2026 23:30:18 -0700 (PDT)
X-Received: by 2002:a17:90b:2ec3:b0:3a4:cf85:aef with SMTP id 98e67ed59e1d1-3a8545cea12mr2865664a91.25.1791354618091;
        Tue, 06 Oct 2026 23:30:18 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89ab81bb0sm2972690a91.5.2026.10.06.23.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 23:30:17 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Wed, 07 Oct 2026 11:59:36 +0530
Subject: [PATCH v3 3/5] arm64: dts: qcom: glymur: Add UFS nodes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-glymur_ufs_qcb_enablement-v3-3-84cf4f861415@oss.qualcomm.com>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
In-Reply-To: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791354585; l=4407;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=9kyv/RmQosGyDp9VxTpU4lmroLa4HPs6mFTgIA1kMzM=;
 b=IXIzx1cg2vfC+nAk1sKZYrJYkD15D+Vb5+X45/bjUiTNNO3jLCxAgOI1jrQmPewwKk3BOsYSZ
 a7wp5Nu9JOLDkQYSHkBqrUhvEZ0fegU/a/WAMZWD5z25NEqSE/c3tdt
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Proofpoint-GUID: rlzB_xJm-MAD1UopWPVTQCQgPL07WdGC
X-Authority-Analysis: v=2.4 cv=ZZiIpcVA c=1 sm=1 tr=0 ts=6ac5e6fc cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=7sHo3vQ6stv6frjssEUA:9 a=JqOrBNmfTE-P4NNt:21
 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDAyNSBTYWx0ZWRfX4b8819AnUj+1
 qSwcLXZphgmaT6sQUJJ1syClV1OYRNjU4vo6tEUzFSVXzwWVmmUjYuxnXFvWkoppY5CwSf35mUr
 Sy5ghNaFehvc2fYdASoRrGSUAft5kWY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDAyNSBTYWx0ZWRfXwWUwiU4oX6Am
 euVtvRyenApraTlYaeBEph7+dTjiLVPxntPUZ3oXSnsbr21LNJ4nvpqmM+7NCpakasWnb9FoZj2
 iyrRPjS0BcChdJ++QBaKx1pVXjthchL40Jmohz+GstN0MW77hk1nwGTOsVTpmjCc+fHYZbRyVuR
 Ybwjlm4iRxyarBvevuzf729ms66SuExKqbWwB4kDQBMigNoyek3ITy/4HCTaN3Qh//Dl+95W5Y5
 jK9RDQMSoW2Ad8eBv88Wi27KroqNRvPwCDqZ/GvVfMY5empw/H9Qogs8OsHeB8oZ+9C2i4ZF/fG
 0cnrDBM4mE7w+4GoZL70HWj03x4358F/4vFuK3nIgABdjB8F+xBnAgjDw46rk71oBBMaK23U+f7
 XkzDuX4pCpV1Vrvyb+zZ21E2m/kiNsBF+UWPIahm0C9OfG0cCQN+YtYdjxTNcrqKl46eg9yHzGk
 zCVsK1w3A9tFHSsJDlg==
X-Proofpoint-ORIG-GUID: rlzB_xJm-MAD1UopWPVTQCQgPL07WdGC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_02,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070025

Add UFS PHY and UFS host controller nodes for Glymur SoC.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 125 ++++++++++++++++++++++++++++++++++-
 1 file changed, 122 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 65a398c0a992..49ef89b41aad 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -811,9 +811,9 @@ gcc: clock-controller@100000 {
 				 <0>,				/* QUSB4 1 PHY RX 1 */
 				 <0>,				/* QUSB4 2 PHY RX 0 */
 				 <0>,				/* QUSB4 2 PHY RX 1 */
-				 <0>,				/* UFS PHY RX Symbol 0 */
-				 <0>,				/* UFS PHY RX Symbol 1 */
-				 <0>,				/* UFS PHY TX Symbol 0 */
+				 <&ufs_mem_phy 0>,
+				 <&ufs_mem_phy 1>,
+				 <&ufs_mem_phy 2>,
 				 <&usb_0_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
 				 <&usb_1_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
 				 <&usb_2_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
@@ -4102,6 +4102,125 @@ rng: rng@10c3000 {
 			reg = <0x0 0x010c3000 0x0 0x1000>;
 		};
 
+		ufs_mem_phy: phy@1d80000 {
+			compatible = "qcom,glymur-qmp-ufs-phy";
+			reg = <0x0 0x01d80000 0x0 0x2000>;
+
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
+				 /* UFS and PCIE4 share the same clkref */
+				 <&tcsr TCSR_PCIE_4_CLKREF_EN>;
+
+			clock-names = "ref",
+				      "ref_aux",
+				      "qref";
+
+			resets = <&ufs_mem_hc 0>;
+			reset-names = "ufsphy";
+
+			#clock-cells = <1>;
+			#phy-cells = <0>;
+
+			status = "disabled";
+		};
+
+		ufs_mem_hc: ufshc@1d84000 {
+			compatible = "qcom,glymur-ufshc",
+				     "qcom,ufshc",
+				     "jedec,ufs-2.0";
+			reg = <0x0 0x01d84000 0x0 0x3000>,
+			      <0x0 0x01da0000 0x0 0x15000>;
+			reg-names = "std",
+				    "mcq";
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
+			interconnects = <&aggre2_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&hsc_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "ufs-ddr",
+					     "cpu-ufs";
+
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
+
+			iommus = <&apps_smmu 0x460 0>;
+			dma-coherent;
+
+			msi-parent = <&gic_its 0x460>;
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
+				opp-100000000 {
+					opp-hz = /bits/ 64 <100000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <100000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-201500000 {
+					opp-hz = /bits/ 64 <201500000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <201500000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-403000000 {
+					opp-hz = /bits/ 64 <403000000>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <0>,
+						 /bits/ 64 <403000000>,
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

