Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139703B2FC7
	for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 19:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787514495; cv=none; b=uRWqSYsqW4QucehdtmL3wytVLzj9Sy4hiccN/odXr7En64klBHXAaVPd/24NTJXU6cBC2Vm1BGRzeHINX1KPLCVL8OnolI7NNOYg8pkEJFnzUn6NySOgISrGR335aUx5RWW9Bke71v/jI77cgFvs9rw3WERxeVdMyYRXPCqmzqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787514495; c=relaxed/simple;
	bh=64Yx/oap9bx7pLvcpGavfWziESJkglcJnhLN1D4LXxg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OGMXFny/2sKXxY6NItjZJyzmPmxwuVgJq6lxWoXnVAyQt13i6CIkwrOas9zFm3yoadHS5GjLH0kDubSR3NCpWF2MJirqGGDFVx967ZeEvRnybmCOfjfqNqnK/Ba8tT6fiB0U1jvZCLYwUpwK+epHgzZbdCLrfQZKjAB/QoA1oDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g3qe2F36; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fPoSqhcS; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g3qe2F36";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fPoSqhcS"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67NG6rBI408817
	for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 19:48:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iupV9vOqfaNe4LW/SncYaFTBIZ2zIXSFduS0Q0Tf91Q=; b=g3qe2F36j6MP6SKF
	uAX+PVAQfW0W1L56WxWjb37/iBu9awLQ5VbJbZKH5/5w4hCVQhNWB4AHYXIhsUpn
	3CHh480JaoeaxrhmmQKtK7YG0kQYA3qKeAEK29w+VPa3Zq1t6UyMrck7rC1NN0Z1
	X3NAHvcZBkUc37N8wzXCshN74fGotD+G02MFE7toSI661Jw5pJq+TcgUJa9Vy/JR
	twBUJNhjpjG7BmwmiT5/IlHJ0fAaZml8W3RLuZtmAT9zd/JcxHxXg9db1YRmP449
	TM4Q21pOw9/48zD4HMLW+65LIirqlxc6fCvL0jZy4Ue35Es/1SwzBCop15J9ZtON
	f/ZWwA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g744a4c64-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 19:48:11 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dbf293831so6628195a91.3
        for <linux-scsi@vger.kernel.org>; Sun, 23 Aug 2026 12:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787514491; x=1788119291; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iupV9vOqfaNe4LW/SncYaFTBIZ2zIXSFduS0Q0Tf91Q=;
        b=fPoSqhcSWSSPW4c6gLnT4qaXW/NJXeXKHNx9UV0SXadfom5OHngMtc/keNxo6zY+dA
         0rjotFT2pAnyx/pmzHZ4I2UO6E/SwAigXe3CsmOjxvq7bOCkxMKhAMrKTdja2yozWN68
         D6okLgwQA2lXpXruKCx1739hT7uNMVo6ZU2uGjhGhBKUt9IzHSl986Hh34eNp26lT2dR
         Y2ynQgM0vs899drNFdyL2pijI/hPnQHYzhEmy6eJbgbtbEsNOGKcAQQUfypxL50PxwHf
         Ua2Vjaa5I6lF55CuFWQvq2K7THQOcrADG8JytsiumNbkl3fE35DoJRed0iEEpG/fTC3I
         eVYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787514491; x=1788119291;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iupV9vOqfaNe4LW/SncYaFTBIZ2zIXSFduS0Q0Tf91Q=;
        b=HAOLH0Dyu646swemHWnFOe6h8+Gxxf99nyrYni+NRe5tDrMM0ucoj9a3KcJMscxrtf
         t4wbuzPukGSKTCk0avhOk5/qGZdD6NPuHShZBw4069ixDLJhAAwogJzjFymly9B7TVsr
         s8+lTc0eizIGiKmciyrHG+EkODZjrpl19tvnuHtw+IGLOSrDnu+ez4zySa6t/DxFTscx
         jpfNtYsjuBFtanSHb1QUh/1/zvjtzEChJTgPJDYYZo389NmEwzjXg21W49ns/0ggsx8f
         zsh1Hdfrv12b2MPPwDhsImPYnhAtqt72LtkReXMt7HAufnfUwsUHFlPXfVfHfAccSMOj
         XhyQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrd8S1Vm3/N5GCFJUi4uXqYMwkl1Ro/u5Z5E5DEMlypeuXEyi8xy3E6sXwkIfU+Ym5rcQ32yqYYd1Tf@vger.kernel.org
X-Gm-Message-State: AFuF++lDv65blkUkZZmtMnjvUgkFVXafiU5ZuBjhVPv1Hv9Nlb3GPn9t
	vwFhQwg/t2zS2ZtP79Y2foThxMzchCa9GAj+6zlO4nXm/IlAR1R1PLFC5y5F8g4mhPmV8s8Oc+2
	XKACiA+R4V7h0bPW9cLzj/r4CU69hUeEMNGRIhfD+J/i/8TcboWBON8yCy8qSSmlT
X-Gm-Gg: AR+sD11qFVV/Hoi53FBsBJj+z4G7VqHVIJj2tKEjdQoKu/4HZyWDdizMu/5D33aDBoC
	71n9cWiPw7+19y/N9f2kYoFOko65+fWBjsxfnZcU2ZRcQVm+IC1rjk+7OKYHUdlD6nme+S30GxY
	gS8zCoWSKLi55z6G9NBst7EETYWFzKKkXsei3d+2kWig2eJ0uzbZ0KbNFpVsc40f90FTcKxj01x
	LduvgqmFuF5NTBpoA0SbCQmRlr8/f6Su8KB9pmUNcn2f8VeW41nHlzxxtTWfO3671/let5cNd30
	Utw1uI9VBJ9AxCV9AGYU1Oq4B/jn6JZMEivPPrNwQZNLA0MV5u5RGSv033CaTDlERKFE7Mg6VCy
	wnP058FTaDOrSKCUg4H1roJ7XSvIqRMPD7Y8t6A==
X-Received: by 2002:a17:90b:2712:b0:395:543a:cf3b with SMTP id 98e67ed59e1d1-395c3518185mr40793810a91.2.1787514490609;
        Sun, 23 Aug 2026 12:48:10 -0700 (PDT)
X-Received: by 2002:a17:90b:2712:b0:395:543a:cf3b with SMTP id 98e67ed59e1d1-395c3518185mr40793752a91.2.1787514490142;
        Sun, 23 Aug 2026 12:48:10 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f925190fsm32321623eec.31.2026.08.23.12.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 12:48:09 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Mon, 24 Aug 2026 01:17:41 +0530
Subject: [PATCH v12 4/6] arm64: dts: qcom: kodiak: Add OPP-table for ICE
 UFS and ICE SDHC nodes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-enable-ice-clock-scaling-v12-4-09271f583dc6@oss.qualcomm.com>
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIzMDE4MSBTYWx0ZWRfX/qWlg7oQy6p1
 hmLMpOvMSkuHnz3kRc3G7yNwace81MNLP39X6nstDf3rAd0Dssyzhre/aTEwfeI4Icj2utnz3nm
 b/2hZI0rpNvkvQ8HqHk3/cDUmz1od+U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIzMDE4MSBTYWx0ZWRfXz/gxEJBPNTC/
 BXJRUzds0+wOr4R33+O+qv2e1KLox/Cgott6H1pDp66QtGLOVC5GC9Mqz8W8O3bu5I/B7WxmCWl
 GD644HkyPZwAHqyhJ3ZLkpTPOR4wNVY1iXI7xU2ZV9ocKj+9wXp76s4LoDDj7CABG6eg7dfgcjG
 klyttS3NiuTKDSsOdW5FRqe4SiK3m+VdvhwzCHvW8nYoC8uJlt9qJPURINeUmayzqolSHsMSviH
 fEQr1r1/sL9otWoIs/z1XGtA/glavGPR2Fhq1T+AxAOYcqpNxiGh5wiwojpehi1G6AmG8Lh78Ve
 K9DOFlLnO3j1pLTPriDwgIrw9L9v25MGnVKHfkyIkvNG9Qg+h3YL3jE8AJ5b4h6+VSpnjfNb2pv
 k6pzWrVQEW2Iq4Wo1vzV61+y+L0IE6HOocUNqtf3+TydWbvRKubvkQiCW0ZPvBGGWc82yheZgRr
 dNzqloXLkLRhTfzJ2Sg==
X-Authority-Analysis: v=2.4 cv=JPILdcKb c=1 sm=1 tr=0 ts=6a8b4e7b cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=Gfx0KCctoiflwLzBlNcA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: HTobjGfivkv6Te5ihM8dChDGNkHRFSva
X-Proofpoint-ORIG-GUID: HTobjGfivkv6Te5ihM8dChDGNkHRFSva
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-23_06,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608230181

Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
an optional OPP-table.

Add OPP-table for ICE UFS and ICE SDHC device nodes for Kodiak
platform.

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index 3692be65cc21b2b13a024d26c05b98032488ecc8..ac3e458ef70fd2e68650505b402d1ba924fbfe96 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -1087,6 +1087,27 @@ sdhc_ice: crypto@7c8000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&rpmhpd SC7280_CX>;
+
+			operating-points-v2 = <&sdhc_ice_opp_table>;
+
+			sdhc_ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-100000000 {
+					opp-hz = /bits/ 64 <100000000>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+			};
 		};
 
 		gpi_dma0: dma-controller@900000 {
@@ -2597,6 +2618,27 @@ ice: crypto@1d88000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+
+			operating-points-v2 = <&ice_opp_table>;
+
+			ice_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-75000000 {
+					opp-hz = /bits/ 64 <75000000>;
+					required-opps = <&rpmhpd_opp_low_svs>;
+				};
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>;
+					required-opps = <&rpmhpd_opp_svs>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

