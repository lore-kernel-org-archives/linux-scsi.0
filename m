Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BAF3AFD01
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jun 2026 21:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780955346; cv=none; b=lum7o3Ryy+BINykanQEQPPfasGfqeLEFPWiZ3I/PjGum11AYG8ydd+VCn1eRZpTMw2mW8LqgWjh6tJtJ1BnOBRQQxi2vzQJje0g5Yx4AROd5jOo4VjXXh3a6mZywy8TXm/2G5h7Ja/PsOtQFUmHXgxpzvcpjwJLv7v3SwUHKLJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780955346; c=relaxed/simple;
	bh=HPJrgV/WvcC5J528dV3QG/rkJGKe1vbeM4CVOkeyLQQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J6nnE7Qzt43zF0rgFW0c165EpleXPsxpDqfWS3N6YSdpVKt0sS0FHizOg83ZTLyl2pVWaNK0fr2tK5ndvfpHaTzru98lqxN9ElL+W9/4tjhoZwhVIRhk2k032P+UCTNlebhEumVMDrApHNAuoLbADehmBwU/I9zXI3LQ4yKQwMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=X8jCRgHZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Br35f+n+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="X8jCRgHZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Br35f+n+"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658IxasC277623
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2026 21:49:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5yZGKQDFpwwqtyl5XA4nQYM3xUM5ByH30DMsiQvsyHU=; b=X8jCRgHZIB8BQlHv
	tsgXVsM4F/b2XgA6J+HCyya8k9fMZY58SltTJcpVAu6St/lCCejq5dN8BlV4fAS2
	S/JRSUoRwfWjwbUQYfhnSL/XlP67jB0I6NN470qo4l/ph9x4A7p7CtWoqvLSooLK
	2xx7+JaO8gp0OvRcQMWKj+S2UTdkRUeyUmUaIMp4rT9IGDRjcfJPH4G+tRZilJPA
	wS1MsU8xxoiJG/UEUJfjs1mLn0mbJYfQgB5ih1FHj8nqx6swUz9DBEJtzmHk8mZq
	5YWPiTgm3T3lebChmoq3GgUm7USfY3JpPAgBqzyjcx1eg3qRuoO0/Y10/IZbAcik
	FeuEpQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4enuptk3aq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 21:49:04 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c85a298cd62so3114681a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jun 2026 14:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780955344; x=1781560144; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5yZGKQDFpwwqtyl5XA4nQYM3xUM5ByH30DMsiQvsyHU=;
        b=Br35f+n+2wqMv6HwBFzFndeXCQHesVKuaXZZ6XuyO/8Wmu+CN8K6Izm0LMtO1bhvJZ
         v6dNuHbR2GSM1mABh21axmkZeH0OvVkXaN1jx0v5XkHljIhBKwnwtMQkWHFMVhPkTn4I
         Dsy9RFUZIh/yJCo8OWwgOJ+6lqw2eQpsVjE6Q4gu+LldA9ffl1rWp7JvBx71fERmf8XL
         GvHk7KXTS6bC0tR+pw+8UwYT790TXAmp6JLfERKaZQjwfTHfPJjgP190X/07aoL4lqCX
         5wIVv1nQR1UOJnp9LKpLhtp93W/wbAxbbrhQ8iBCtvOcQxy0DVOjrIapjn1+yRoCuoFU
         +uEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780955344; x=1781560144;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5yZGKQDFpwwqtyl5XA4nQYM3xUM5ByH30DMsiQvsyHU=;
        b=hjmZpq6F0de5CY0ZD7ffv9bfl6BYuE79Qja5Bvai/8NlvJBn+e3KTakzs1PWMfTDlo
         9oJymklGrJVa2fB/3LNoRPHxCZiQodfWNom8R121qnlFPLEl1zGwlrqhuB/r+ut+Gcua
         er2IRIHA+01K7MueuGcam+RIN/SVbctz34IZiexnGd/rPQVS3mykoG0w1yh0OyQBZgEZ
         XZc+ry4Izclxc/ERNAdkjrr3M17wjmKRI/0+YJabo/afxr1BydiIwEu4TUuWzc/hJ0HG
         VUxfTIF0LSdlLMvwGg4NcOiHZifTg6xy6uGqkSGGk1F7WxuvoX4uG5tbhDuLH53bqczs
         bnLQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ikzVrcpdKcNe7ZY1C3Ho9uti/nv33VW5FBhUkZCWJ8Pm6d/TsmJWA5YACTvCaZ2imtAqexHri4BxV@vger.kernel.org
X-Gm-Message-State: AOJu0Yx88Sxmp1/Qqj2sVjON8eeterHdJ224+c5AAQwLjXK4kgSTbNL8
	65hgJdoI5+45js2rKB1Uw/AwNGC5WEo0VQPjIzCs91QzG3shEYcG6in58HXvci3n9iHtG9ThhyU
	gUCRpspvuUqXHRHWjsTRADGjGyaaktU791H7fuPucmxmkTwZ67Oy12z4nQRddeW36Q49/blqf
X-Gm-Gg: Acq92OFGbenX5lpu/QrGox4epYD8Oj61RT7dfleK1LI7SSmRgWYmgv0tPDn4lEAXaCP
	1DvPozN7y7x3BGmdkSfbKuVhafBVD4n8BYppnK9N7HK2iMVjG7hDrNpSEipXjkD4g4Lz6oq8qPM
	RxNEITjFQvuUhRMdAcMb6l9zPy0RDQ0cZFEceKhMXob6P4Asg31FlQ9Vhv/2sz/z/GNumHX51zC
	I9IwzSSJyOmRef3LuA9V4u+MV/ePvLzJs2MB+NJbdM5WPJ6Svi5uzDFUzxr+Ov+98+Nurkk0b/d
	wxQSB/VrfzR14zkenbi7fwoP2A5SBWn6qOmtubjQ9Hd1qYZUcg4W0H1v3Z9Jqreh3qqfkKdNftM
	/JXODgOTuQMVabZCu/loHEWNjgUO2oxnGewKA4ipX9WG+bcofuEopXbtzRtejcZ7fIrPOvg==
X-Received: by 2002:a05:6a00:10c5:b0:842:3aee:12c2 with SMTP id d2e1a72fcca58-842b0e661e5mr16882660b3a.18.1780955343663;
        Mon, 08 Jun 2026 14:49:03 -0700 (PDT)
X-Received: by 2002:a05:6a00:10c5:b0:842:3aee:12c2 with SMTP id d2e1a72fcca58-842b0e661e5mr16882639b3a.18.1780955343219;
        Mon, 08 Jun 2026 14:49:03 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828cf783sm19607485b3a.40.2026.06.08.14.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:49:02 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Tue, 09 Jun 2026 03:17:28 +0530
Subject: [PATCH v11 6/6] arm64: dts: qcom: lemans: Add OPP-table for ICE
 UFS device node
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-enable-ice-clock-scaling-v11-6-1cebc8b3275b@oss.qualcomm.com>
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: cX3NF8XW6lsWbkus8M4AWvw6_NkmUD2m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE5OSBTYWx0ZWRfXxtI8L6NwTvRl
 iXfpEO7R38wioIPQzltsTfqh6Z+byUayIzJfb2D4xaVRaYzRqhY1SgGJx5LFVeiev1UmtTFfizs
 mUmsGVr/vCG5aKivnrwizbfYAIVutRdN5w3ATVT/kz+CTAIh+H4k+KblAJGd/9acr8cXD2b9EpO
 5/aqfPMAf4uLI0VpNDI1Y8veWerVbBwwPdp9XNp6Oaw498hB6f45uWZesvv5iRlg9ag90GYXiWW
 Ru3qEhMuBqhhyS+Whnl8djlImY5+PDYND2IK0Z1CgYPzHDnJkyPuaOJaUjDu9yWLmQ4qS+v+lkx
 HrXMvQACs37+KDmCX1IBV4fzt5ALhVMw7F9ixBCMygYnmmrHiFZWuQgI4jInkmVlFU8HhZk05cP
 zf/N0kKVy8HT9BBmHTeg0fN/lyatxreVe0yTlirFRBs1z0fFX1uW/vilGeboTGmVcOMbH/1Tmgj
 Ypa1ZBSADXNvSmmRwlQ==
X-Authority-Analysis: v=2.4 cv=XKAAjwhE c=1 sm=1 tr=0 ts=6a2738d0 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=ASeq7m8wwX9lxpDCPrQA:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: cX3NF8XW6lsWbkus8M4AWvw6_NkmUD2m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080199

Qualcomm Inline Crypto Engine (ICE) platform driver now supports
an optional OPP-table.

Add OPP-table for ICE UFS device nodes for LeMans platform.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index 353a6e6fd3acb22ef228bee340212b8b2c300957..f100d706edde465730873702f0b0a00b44050c23 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -3109,6 +3109,32 @@ ice: crypto@1d88000 {
 			clock-names = "core",
 				      "iface";
 			power-domains = <&gcc UFS_PHY_GDSC>;
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
+				opp-150000000 {
+					opp-hz = /bits/ 64 <150000000>;
+					required-opps = <&rpmhpd_opp_svs_l1>;
+				};
+
+				opp-300000000 {
+					opp-hz = /bits/ 64 <300000000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+
+				opp-600000000 {
+					opp-hz = /bits/ 64 <600000000>;
+					required-opps = <&rpmhpd_opp_nom>;
+				};
+			};
 		};
 
 		cryptobam: dma-controller@1dc4000 {

-- 
2.34.1

