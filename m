Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3B53C345F
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 11:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775735107; cv=none; b=LufpBqx8f2/wOLCZSnsrUtFXvMoWvyK17TU+s2BW7lOPMobgD4c3eOPk7lCFzBjXTAyYUDlHAuoDDQ6h+/3AIToOtEgRhLZF/60nsWZ/jfXzZoARhruGwkBa61w/bS9abxOdoJyv3DRhNKGE13urcp0taQ1UtpQiVcBmbBKZjg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775735107; c=relaxed/simple;
	bh=NzK2BKDDpiMn7S4hNvWZzsLjsJo/12wVptCDRhY76jE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UpKB2GtPwqoQlZNA3g//WtTII7bOYq1FTJ10rR1s2B6sqrBBBs2Yh05E9fmXB7Hw77L6pT+B3TKYcDA3UIBvAQYAoLeym5rfKnSio+JvmJRGNWthyTvV/Vw3qIsNMAdatnecX7y1vLsL09W1fMBk7qyXVkd3uPA/aouY6Qh+3TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H9IkSav/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=i92La4jv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H9IkSav/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="i92La4jv"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6398CQgo4047116
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2026 11:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nMtaeroAIa2z0DlOIF1X2BC+XORLh63KcMmIsYwtcHs=; b=H9IkSav/aucj/RjL
	pU8wkv1cdnPBMpjYwTMEiAWwL9tVVn0iJVnMxDbtjRf14yss00fzE3yIJ68qwSK1
	6ulM3JTvgYqlgF2QRnra3/T1Ldu0Dxmt4glOYVmDb3XBpqR1P46qkgkSvBnX2FeS
	xjRx7mP7v4dmKLsAISe/g+EB7XT8fDnpSszL2mJO/Wlp7JSefA9RJOQ6apvKDaiJ
	rGuoSkpQfcyjSen51I55QFtVeFTVdB3XCn54rqKlk93IZqrh7EtZOl6e1BAguCjv
	xDUPUjptYdWpuvFyzz81QYzBMdGtmDSbmRSXtBTQX9yUz6PhEi4qvhwAJXGrY9Zm
	DZa7Nw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ddtd73tw7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 11:45:05 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b24611696eso8463715ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Apr 2026 04:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775735104; x=1776339904; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nMtaeroAIa2z0DlOIF1X2BC+XORLh63KcMmIsYwtcHs=;
        b=i92La4jvqevI2VYjEPL35UoiEqi5fCQ4K37SAFHS2VdEwoIMNyahRDnUgZ8dhQJ/L1
         expIeR90tri2tB8KHrZmD1mxH+LhBPithvX0Kp727cW62w1X1cE0yEWdpB3E8Hammywy
         uY4zy10Ws2sJxtxKNbYpu/sdI2vrUOaCyA8ehSByPjTejVF8ViZUFcVdCmlMzD6yRb7c
         hyeUuSrG0Er+gnhkFE/wD8QcEoGmX9z/UNe3S0oKveLqAsEM27PvdUxNzrcn63Hm3S6g
         jYtTK/eNwTMoM4yG3UrRef7dfqohNIijcy8DD/zUQw1C8RLRiv2hU4XpJKS4P1wuAnLP
         V7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775735104; x=1776339904;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nMtaeroAIa2z0DlOIF1X2BC+XORLh63KcMmIsYwtcHs=;
        b=MdBNC273TVgmJ9POdfue1GtybHQTCQFvpKS2EIUCTRQBLJcSaNSqWVk06CDPED1XPD
         gTEzBYOLyxWqUrhHt8tRpqM1rD2vjCkfuONED2RJnFd4VHXE+uX7ZeWAQavg+Eu60ieD
         R39KYukgKruy3LTRuCpMbCr00d8cqzNrjhno5lSj65F4LXJcSg/+z89vMy0n8YhUD7R0
         3Tf65za2ULd14UoAGy3RtMWzqprDdkPcOblt2FZ5V1XLF+okkAYhz87fhrevhr8rb5z0
         jw236wxeWIJI8UykUYGu07ifI0hN5vjmfVY+Glap1/7yAQhyzjt6wNPgf3okOZHpY25Y
         PzQg==
X-Forwarded-Encrypted: i=1; AJvYcCWXrmT65qi7Rcqz3pQ756tqCjVwobEm+EKmwBeGlML1snkRCeA9UqNuvLXpC7vD8ihzNBwXuvMHw2hl@vger.kernel.org
X-Gm-Message-State: AOJu0YxYlcgzbwZWOL07AVlf6dBCCkmV6bfjfbYvpYjRSu2GKCZnvA8p
	fdJzixZviOMe08s5wVzRNPhZUMzk1Fn0KJMzFjPfVPpe6AzETBpV5utRuBwfhBTtSCX4prZ/8tE
	EapXBDoc9qz2cXN0+nyI7tBr8SwKKRTWbrVOzjpv23dRogk/J2jIiTRFPC8HOkiQL
X-Gm-Gg: AeBDieu6ZJ7o9YbVnSYNIxFoPjN1ZBvkv2RvoDhGUCTazlyNg2aUow7MXzmniLffYwN
	/olY7DMiFukIOCMQDzVJfJxDNUk0d+07ZPpu39gdjqJct7aUbJJI/x6Mxj8W5ojAIsCduPDwlsM
	ClQELW+czYjvtlayuPqfYQN2Sa+nK/O0oOTRY4lNBFbYalRA8oI6Cyz+DLWG2QnQxNrZbrJedQS
	9xkVArZjP2pRmILwwCKT9wR6m4oqG4KX4ErJJmYszs9juWUoEqhLkKKqtkms3zfXKwPPs69AGv6
	ayw2QDG12c4LQBrZ2K8OvEJgcLPy/Ryau6SS/nfOPQ0zjH2jCmWZqTPVYe1F/36ptcv04PxOjHU
	XAsIYEDNICQV2sGUbcksDnUOPpzUHTAEYDI39BPy1+ogL03pXQghcY9AxfHc=
X-Received: by 2002:a17:903:2cd:b0:2b2:4e70:6339 with SMTP id d9443c01a7336-2b2c73ca428mr36152905ad.25.1775735104266;
        Thu, 09 Apr 2026 04:45:04 -0700 (PDT)
X-Received: by 2002:a17:903:2cd:b0:2b2:4e70:6339 with SMTP id d9443c01a7336-2b2c73ca428mr36152615ad.25.1775735103795;
        Thu, 09 Apr 2026 04:45:03 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749cbd9fsm230957355ad.75.2026.04.09.04.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 04:45:03 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Thu, 09 Apr 2026 17:14:11 +0530
Subject: [PATCH v8 4/5] arm64: dts: qcom: kodiak: Add OPP-table for ICE UFS
 and ICE eMMC nodes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260409-enable-ice-clock-scaling-v8-4-ca1129798606@oss.qualcomm.com>
References: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
In-Reply-To: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=QoRuG1yd c=1 sm=1 tr=0 ts=69d79141 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=IFdraIdqUsMg42QbtkkA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: 3f4SN2V4PJvqogTA4d2fqrHLl0ileLgl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDEwNSBTYWx0ZWRfX9KOSA8PxFlzM
 gU2puhiqlQcxBVMzq5W8/cgt9K18dtgj/LyBMzh9FrbdOHmnJ1z8Yn5g/JqNUoUpZwrm2u1C9wT
 kfNHf1IUt5G2+Ea1WpJCHFuOe3LscKoZ+VZ9yNs/Wus5XRG3LJ6q8upnWO4j1vHGrXoTFTC+wwU
 yQk3HGMxMV8uRqTzuJxsiuwhPSizv87j+Dna7XKtrbzsii3JHKIppE1Gr+CYosDRQ6YNLDgFWoV
 uFS3LCPWqx/8NfQ0BtOu9Z/zxonM62ZP3nmIc0vXIaXAOli79GB3Z5ua1BaxXXN+Vz5dlFZVbbl
 qXdd03K3Ko9qFPExlFh89h6v0ytjRsruxnW2hw12oH/HDVu/QvwmDsILREkL3O5S1ziQP8QBYUh
 0NxLbA3QNiqfJKaulcUw311a4+3iUUzw65HUeZ3UdP23EoD3TBKBBlKVu8/nLDz9oqPnx8r7N49
 pieHqRoqkOCaDT9i2Vg==
X-Proofpoint-GUID: 3f4SN2V4PJvqogTA4d2fqrHLl0ileLgl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090105

Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
an optional OPP-table.

Add OPP-table for ICE UFS and ICE eMMC device nodes for Kodiak
platform.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index c899a17026fd2a10ebc528a816629c88ee3bde5d..b0aa1970d42a3bb0b9d371e0e6cd09b8cd164dbe 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -1087,6 +1087,27 @@ sdhc_ice: crypto@7c8000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&rpmhpd SC7280_CX>;
+
+			operating-points-v2 = <&ice_mmc_opp_table>;
+
+			ice_mmc_opp_table: opp-table {
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
+					required-opps = <&rpmhpd_opp_nom>;
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

