Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1223C3792
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 22:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439097; cv=none; b=IKAg/ZfjcZ+W8mNEN8L22/dO3ssGjbfJ3JfZeFA4mk0T8M7AdBg00JYZMFB3EAb0XrS8uHATEwggGSCJY0UMW1QXD/hg0F6BzaFMVZ/HwfY7buLyNv29gliR9oAJrYD6/YtpRSwPxbiHNhUq5k+6U35Zlc30htvls63pEe8oGhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439097; c=relaxed/simple;
	bh=DXh2TI45vU1iLpWsE+RYENmxgSc16LkuYVsOKJ6zBAg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QVcFgSJNY+V4Udm2U/q/fB3C68D1iJiRMlg8X4sc542Fw+LuMqDOOxcTxhRJ1nSyqsCsilvbGJKV7gSUZ58SaFhl/iJvatQ/qJBrlCn2ncB94AINHSZH8BPxTt4VruCFGtSzkRCg/mUUlDnLzPCmXpulgTuR3YbNOA8sf/+Kr58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CgIvIyfS; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=G8UKOYi9; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CgIvIyfS";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="G8UKOYi9"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 652JXEcc2767867
	for <linux-scsi@vger.kernel.org>; Tue, 2 Jun 2026 22:24:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iYYqWEc3U8tcC19eQELIhV1rxr7yBmE/dYW94QG/AcA=; b=CgIvIyfSHTb5+Lt4
	G/vpGmyy9FnnoEJ4K8wXe2sGjDvtPJ1oKo49PRf0evNOrHHOFMk0B27yuwAMon9G
	nnMiO7quixhHagozVYNCZ8/xApFry5bChPrHRXq3FsWVrOkPnL58GdMMmDBx3kX0
	7ciQpBxBUpCR6ZObbUj2cwo+ZVHfNBd9TfDP1M4is84uSoijx2mY9e6zIw7omzAG
	MN1D4beevj9til2vPwg0on8m7I4bRHbwOLuOJqxSGblOuJ6KegofKSNeFT0Bffgk
	qItdLRRJwL7vm7Xio1ThXO3X0huJhLXGpCqLr2VV+bzmnVjZ/eIxyXdCltV67MVs
	+SJKgA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ehsus3x00-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2026 22:24:56 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2c0c20f7581so33590125ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2026 15:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780439096; x=1781043896; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iYYqWEc3U8tcC19eQELIhV1rxr7yBmE/dYW94QG/AcA=;
        b=G8UKOYi9twN+tOagaIqtrtYLq98h1wX8HM7FoC64BIKzl6AE1sS8aGjaBOaYnEyoHk
         yBoMt98sg4OXsiinFW7K6EKiCaMTPqwNxQRTAl7XcHCsGWdxN05dmnZ2rgjvlZb/gLSB
         yEQi353e2aIELthLvUP4Y0u4kPlZDfSMIPvHrOogEYdeccBd+qxyRBKzmc6GFG5XJ8gz
         ssOUz73eJxWPRUj3HH9Rki2Le0f6/G5Ddcw2j1jlEg0PFJ4DWiJ/pjhvLu1Z4918YZUj
         6KO5uIR4kuCvEOU5j0YBxVnEz2NGDUmbVpawrN82B7d7o7CdUjrBpF2Dj30QQzkLMlVT
         MW0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780439096; x=1781043896;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iYYqWEc3U8tcC19eQELIhV1rxr7yBmE/dYW94QG/AcA=;
        b=OQTjemZEEvsYmxBTgTIbS/voNhHQ4eaeedBIAb/oo1Tiey1ub6tPePZM/Ue4L9OPho
         0Do9uxca4ZHVPyhEMN84z5OXqv8slF5R12S37oHBo/imaLcrB4NhsXcKMNKM3I/khND8
         9oAIJf87SdOLoxVNSlxXAJJvFKO19V5tcmxG+gvBc0e186d66QvLkggnr6WQ0hoKAo1z
         XkhqHGDzSye3zjoxoutl4y8diYswZeDkVHTfosEjMHlJ/sTBR5mPWEI8LK0BNAZcL6Ug
         t+ZbyKgeX5J07ryD40Bd5h/x0N41txxvLfveIMFLcQDJEIy8rluR3MoMV5cCidERtdeg
         5zEQ==
X-Forwarded-Encrypted: i=1; AFNElJ93/VV4vaL90O0W56rmfMb3dQ38O/pfCjuGDY95Eagu+BVflblv0q2kPsfdbPgBGEO8QhDHqlIeF4R/@vger.kernel.org
X-Gm-Message-State: AOJu0YyjuSjxrh8+uH3/SOQSbECR0mAym9eiesIV787oM5mxVyO4J7Yo
	wvQk38wJlaY02Y+OXXEeV3OJZ2hq3R6Dq3O52jvh8TyIC2YC1SgmBUwEl1Eq8ZmpIQ1+WvwAdwR
	jeHQCb/zAXhqWKJRuocfhBqEEMPMD0VzAR625SmPtgEt/0Xcs0+IG/ODqHEgrHUta
X-Gm-Gg: Acq92OG16BJZ48F1rkO3p+F42qnHlHRr8IAMCLNlp2hXzKS2QlkKk1OjcHo/9EWLkSK
	rWuzBs+5MiJLFzG3+ohkybuWra6TOJUYi9kDRk7tcWerodpHch+J/VctU/B+gtyr/uuDQxhU1OM
	DW1yQNc1Fxtg7uIxf0uFuYuxaNSk6rujXcJKtCLu5whTKbVUFo6DUc8G3By3elGnMwnaqirWeyk
	rrMZh0sw/pwVqM5iF9uuL4GCsafsl8BN3V1iPLpjrnpQa6EX3YW3RIgsicy+2rq5Olu07j13JCZ
	Ml584L+sZPEUWwGXH9RidDlxzy2WwulWQqz/P5Gb5zmfejxckP3Zap0wZ49CP9nGjTmEAuyeWJV
	PAr1WVThbUr5iBwd5MxIrK2d+up4fRxSL6ONjEiB5kTILlbPRuGIlAZCBJP9g9YvEx3zWew==
X-Received: by 2002:a17:903:2a8d:b0:2c1:660a:2941 with SMTP id d9443c01a7336-2c1660a2bb7mr5879725ad.19.1780439095635;
        Tue, 02 Jun 2026 15:24:55 -0700 (PDT)
X-Received: by 2002:a17:903:2a8d:b0:2c1:660a:2941 with SMTP id d9443c01a7336-2c1660a2bb7mr5879365ad.19.1780439095116;
        Tue, 02 Jun 2026 15:24:55 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16609e0ecsm2698035ad.45.2026.06.02.15.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 15:24:54 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 03 Jun 2026 03:53:57 +0530
Subject: [PATCH v10 5/5] arm64: dts: qcom: monaco: Add OPP-table for ICE
 UFS and ICE eMMC nodes
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260603-enable-ice-clock-scaling-v10-5-b0b728435356@oss.qualcomm.com>
References: <20260603-enable-ice-clock-scaling-v10-0-b0b728435356@oss.qualcomm.com>
In-Reply-To: <20260603-enable-ice-clock-scaling-v10-0-b0b728435356@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: pclVzj9nBR1b5ycRWCxLGMydEQrnrMYN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDIxNyBTYWx0ZWRfXzMpX1hg5SLPN
 /CSISSX8Xn20JWkrOO+RcE8DXQWlgWXOnCWzH1eK0Wk87qYbedcHq4Xbl1Zx4xHP+JD74GnYTqH
 LKaD16KEzDgHWVtU95XIFCqrdkwKUM1jVyG6ZnpIvRP9Q0nqlUBSoLojW8og1EB2uGInGIk9fgb
 ryyBBw4XKsz9TF/xcqiXLtG0ulVGn99+SWVyISvyuDSsqGgfTfdUo7k37Z4ZA0Ksi9W/TftAF9E
 G3+rkDqW9oElCRQ/dWXIMv/Mu3SvGmRkLsJk+Y5YMU80H0JY5/qe2hXS6Bjq+KWXp5b+F7EUbPE
 jRoZXYgKrcj8+yMLZ6QTi1LPsC1YAkUXQr5JGzDgmNH1NEYRY77GTVYpLCkfVtWQCcK95TwgKEB
 gaRabKDE/aTyToaT58X36tXE/qzUulJy5EGi5juCUXExjE1SUP/x9Tw2dreCBcGNZW0IAJdBwm6
 yW6otYUqGL0t9oii8Tw==
X-Authority-Analysis: v=2.4 cv=ZYAt8MVA c=1 sm=1 tr=0 ts=6a1f5838 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=IFdraIdqUsMg42QbtkkA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: pclVzj9nBR1b5ycRWCxLGMydEQrnrMYN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-02_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606020217

Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
an optional OPP-table.

Add OPP-table for ICE UFS and ICE eMMC device nodes for Monaco
platform.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 37 ++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index a1b6e6211b84d0d5008231c55613a0ccd61b9450..d9298d8b7874b8669b2cded2a28a99dce6eadbda 100644
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

