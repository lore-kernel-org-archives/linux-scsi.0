Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADE633F5B2
	for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779650792; cv=none; b=R+OCYUTm2Sfn3EaYO9fkz9UsLa0VWPKkSzj5RE4vMa/iQdJ5EO0y6KoZKBfOu0o8TXS3Dq8qVqefVQSxKOo5ipgpIkRqRgOfPm8d8rCTSdFUNSLRKq7RoXg38KTQYzySfAbR5RYnve4RGkwUY+WluqaWCtKSoh3kr4Az1O4RC6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779650792; c=relaxed/simple;
	bh=xx/OKQkndZ0HVXGIbB1dzJVX/RWFuCljMR+ppwrasBY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PDDK5+sm5URVCoY6kq2mr2DHLJ9Dtp2NqDiYeU7Qt9Lhc1MuGqC8fJZRX90iaOrVmOCXPesAOIicDNvgoPa+pSPGg89CyAZCchAOOUveCQMPfGMXYn/9UQxMuGIZ3AlUiscUeavK0vRMv3Q/vjT8XpVYcgvYl6xHnXBO5kRqTw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bGdKW9Sb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Puijgxui; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bGdKW9Sb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Puijgxui"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64OBtLbV311737
	for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 19:26:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gDV1nPpX3nIdzbxc9n1Wsm9dVpymUyRjJcXvIcY9kbg=; b=bGdKW9SbVOFFo7Jd
	wExZbmC8HnAzH/bYeFHp/25k0XOUuX9jqwV1EBCmHs6U7/z8NSBXlOPR8hHSYaUM
	wSMX30zBdPFxCc96zqnm5Cso0EnCNXrse78jOgxNarxJEQuVwBF3x6/epwQnX98h
	j6rtaA1GZDpNp22l+6Pcavaid3cPfC66YXezOHqRTBxdYWdxOLx6Lz5FnbtFiKqf
	BeCxGLB6m1RlZP5FHNVK29m52n0dO30I7SSSW7eRqzcYc0saEGwdv0wZXN9yor1P
	LM6n+ifRB1Eq8jEebJWufHQH6bcaJ1YMy8Uf7L7kre09iapT53FTiObOeLmvtagf
	tDYnzQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb1kmm8n6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 19:26:29 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2bc763c7256so198345405ad.3
        for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 12:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779650789; x=1780255589; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gDV1nPpX3nIdzbxc9n1Wsm9dVpymUyRjJcXvIcY9kbg=;
        b=PuijgxuixL8qHgXwT+jn/cIFNLlTJx9KBjnMR46lIqXc2ThnCovZbdQO4vqUAlZv5Q
         TcqjQSqqMV6C/Q5RGktr/cu/ecJoUi+7hr/ikWh/mqKve7pi5AkJvzYHtiHg5p2Q6x8A
         YYi61eCLSbOcz/nToJTpvG0Bc6oqHwiDbqaTSd3UGEqDg+ecWSGztn7yHLUQbHydiWcS
         ehh4km2EOHOKbiad9kYQUCsq2D3OL3q6D8ln4gfLkku+WlTT+KPK/hanRrhyP+MmgsYz
         3QcHaPgSZnA1TbB6QIhvkxkn8y5H/1WI5PDKFbEm201hrVgI2h3BsneO4fQhBgpCrcHP
         iEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779650789; x=1780255589;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gDV1nPpX3nIdzbxc9n1Wsm9dVpymUyRjJcXvIcY9kbg=;
        b=h7OZM7tMgmA5LiIlhFjfwTqODhwFr20b9Aw8l5vMoemTueaUjdYUYhfZv8KoZd8bL+
         tSJWQzC5D+GxEqMgGn7GEhYsAiaC2tYXbzcG3F2GsD7VgpN4fuwXpWPdD4DjeOPzbggu
         N9pjdCfIZ8pbbkQRQsHFWpIi3nxTV9055YLyF3E06HqQmVSLNErfavgYavaeN6UrdVwx
         l4ZV6TDMOOW2axwliaDyj1IginFk3Y89JAZooBOjhxaNLxfGqpRrO1t/3r4u6+n5icmi
         HpdzmTEqR3BF0j6rXxAACiS64hIeonsqyfn8fKYNFHpBVQXUWN2QIWhLNV+qBRe8FKuJ
         nYIw==
X-Forwarded-Encrypted: i=1; AFNElJ/hF+OwaJHPJ5p7umu3DYkVj46nBytRHrk+bLiEtxRoOKbCntwv99jFDNe3aGeLljGqRGmZrWM7dtEN@vger.kernel.org
X-Gm-Message-State: AOJu0YxwMgm7QTclHG/UtLu14ChpRi4N0RQtUyiRzSmeDFaE7W/J++Z+
	fiwebzIE5pp+l/kTqmEWO5pEi3t1Gum5478R9XbnMp150wWJE16T4zchN6HcmtG5G3xMiMiol8y
	3L/RCuuPLO3xZRa7fdCbe3vVwIS0wZWwqNV4nVbO5Mor0IM1MJ2ELAKjSrzkPgUdZ
X-Gm-Gg: Acq92OEv9BS1uumQpMtpU9BN7rhEe8EPMfIYGvHfE3rC15ZuN1wjvFNkuLq6yQR3A3k
	O53ZsZe08OrYteavYceQ5Daj3srFmB2MXpPHjQVpl7wm/hn7deyvkK+GQQ7hnKesdrkOzjU43xQ
	XQ+l1PNP6cei+EX0eL5J2eaqj+iFhSNDz/sWE/b5TqmVugmHmxErdoab0YY8uo4j05cfRTj2w3B
	+XzlY7pmZ3XLHtiBFuKg5PVL9ZYKuPqzhCUVN8DPsYcJWEtWJebUKKuW9r7j+9/znyidCM/h9Mt
	M9bljmIkFB7mMJqYugyoxdb2Vl4wR28XlSGvTpMe/korE1JpcONEfkZKpqAw89p46iRtZ8UmIvr
	2WjmuKF26nYLM+wi02cL5V2WgSSqv8twUrObhgtr0CL7iFP+B+J3VvvKURco=
X-Received: by 2002:a17:902:ebd2:b0:2bc:b141:8551 with SMTP id d9443c01a7336-2beb06f81f3mr131886795ad.19.1779650788842;
        Sun, 24 May 2026 12:26:28 -0700 (PDT)
X-Received: by 2002:a17:902:ebd2:b0:2bc:b141:8551 with SMTP id d9443c01a7336-2beb06f81f3mr131886575ad.19.1779650788351;
        Sun, 24 May 2026 12:26:28 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56ce2cdsm75329945ad.29.2026.05.24.12.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 12:26:27 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Mon, 25 May 2026 00:55:52 +0530
Subject: [PATCH v9 5/5] arm64: dts: qcom: monaco: Add OPP-table for ICE UFS
 and ICE eMMC nodes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260525-enable-ice-clock-scaling-v9-5-c84613e9ce47@oss.qualcomm.com>
References: <20260525-enable-ice-clock-scaling-v9-0-c84613e9ce47@oss.qualcomm.com>
In-Reply-To: <20260525-enable-ice-clock-scaling-v9-0-c84613e9ce47@oss.qualcomm.com>
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
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI0MDE5NCBTYWx0ZWRfX25ImqDhBmYtr
 HrpuBG6ZKCwgnNA/OAgOKGjtFzT8tVCO6Lo7EC3rE7OTJegfgVBdtpuazclpiNkeSw79yS7yv4U
 LZElzMywrVGThOLB6DqOlLmvl3U/2UWi7v6BGBtNJqKObsijuDdXT5nBj7opYldB42IWBKqfUA4
 oD7Sx4RZ5dk6MVAdxTtbJyHrfDb1H9WDiq2erS52WCjZMx4mju0TtjhEF3d/BFP/OoAlPlU0V2g
 kIBamn8yZAWwko5CbhbJLRh2Iemw4FmGwkKAu67dHx45KfPM3uOs3rM7MtGl5ax5/qG7cCsfhx/
 Cp4xrg+AGVw0om6/Kzf5eazLf6BmASaL5vYw8/vJmnPJ11BGBBnnxI84/qHHxusy0Vjzsk3TRLx
 2Exdu9g00CsI1FRcX8WfAaFL3Gkm8Rw2Ht8IE7n8Xj3t7No4wl1K0z13jX3qPnzXVaXeMCc8MFp
 6MBGAG4GLN7m7yxXb8A==
X-Proofpoint-ORIG-GUID: I8HoXQ06IeW7f_nu3U0E5fBYM7vxQW6J
X-Authority-Analysis: v=2.4 cv=cN3QdFeN c=1 sm=1 tr=0 ts=6a1350e5 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=IFdraIdqUsMg42QbtkkA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: I8HoXQ06IeW7f_nu3U0E5fBYM7vxQW6J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-24_06,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 phishscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605240194

Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
an optional OPP-table.

Add OPP-table for ICE UFS and ICE eMMC device nodes for Monaco
platform.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 37 ++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index 805feb481943e0684162048b5e665b056588095f..89586a6fda70dde16007fb9d3d6a1fc4459c58ed 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -2742,6 +2742,27 @@ ice: crypto@1d88000 {
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
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-201600000 {
+					opp-hz = /bits/ 64 <201600000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-403200000 {
+					opp-hz = /bits/ 64 <403200000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		crypto: crypto@1dfa000 {
@@ -4878,6 +4899,22 @@ sdhc_ice: crypto@87c8000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&rpmhpd RPMHPD_CX>;
+
+			operating-points-v2 = <&ice_mmc_opp_table>;
+
+			ice_mmc_opp_table: opp-table {
+				compatible = "operating-points-v2";
+
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		usb_1_hsphy: phy@8904000 {

-- 
2.34.1

