Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDDF33A71B
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781180423; cv=none; b=eo6UygKU/HQ3lXIBYzWj94Re9EzkYqD+WGsCcd9g8tg1bGgl/9X80sYS3/9iprSJMS5sRnVbTzLhs4WtF2N+k/2RXJ904eI9HwpH/RBBRdZxcB38xxlA4T3cvbimdiNNd+/WgtKosHswVHD4GDNSeIUKVZXfLm4/E26DZl74D3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781180423; c=relaxed/simple;
	bh=LD5koep+nrii/XuykvR3Msykmd/YE6bxJye9b/iheAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cylv9ZPY+FwJCjVlDLgn6aCX6d3IdzXTv0wzlgmu4kM6Jy5NFKyGrmDQH49QSJw61NHnQmGObUT7F3f0FVo5iiWdJZYl/v8ynrL6xwJ/MZfZ2abY34T24ZBJToWU4J/YFTEroHsSwAUIKpgV3V/x/hwYX2Uh3nrDopaAkZtcKVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=A6OBpqGq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hIIiaRXx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="A6OBpqGq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hIIiaRXx"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65B9xMIg2890717
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wvUdbixww6CTGMe6OrNevndOOKL7ZNzp2IY7YAuE0kI=; b=A6OBpqGqmEZMzkZL
	aNeAZ7SbvyzaXDBfI0tUe5+HWCBd68U5xPpN71bLr8J1GQxpNmHQuEzHvdYBcms+
	O0ND70Ndjsba0YqlURI6SmLFLMVvVMNBL/7o1eWkHDqHIdJBJVFBKBAKk3MmPc59
	OEZuANvEsvSK2TRiC1Sd+Gu0CQua2XoGWWavBNe3AnXHFceCu1jDobQDSNPkOpYg
	NYxUJwxmqqngkK5jIelEsIwNcM+HODQveriYrLQ1yedKC464i7wtLwD27RBNKPDN
	c16zsSUeMNttXyZzBCZK05AMvDr35iXKNrPOHrgbMWhDwMw0wYdlL3JA1kRfl1oh
	6xLl6A==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eqe79k9qe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:20:21 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c8584e3fc96so4068008a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 05:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781180420; x=1781785220; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wvUdbixww6CTGMe6OrNevndOOKL7ZNzp2IY7YAuE0kI=;
        b=hIIiaRXxeQwUBPBFjLsHgERcyYnWuQePwnAue6J273LTFBnjMXmZbxDghrVi41jeFZ
         kkbsT9V+/2ziy07HD6192CcahNvkHI2f4EfqPfnF8g080Hx4i9EjICFxRWwuzeWVdd9S
         L3VaU9MLfW0RQvZVRq4ffgDf8rTnmOwRw1k2m/BFPyy7W6ZLOl3NrT1wQ/NyPP3vODC4
         rE+JXvAFVSOQcenR5Te11qiosxsRW3udojX5H0k6YhYHbrqGcdIdHYaCrFIRf58F12mg
         E7uIy8eOggQFLieeDwnv5Hfh645eBoOUP5z3f82PSTfTcVpi7UtRGGQcZh6O/KJwEdqI
         pcnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781180420; x=1781785220;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wvUdbixww6CTGMe6OrNevndOOKL7ZNzp2IY7YAuE0kI=;
        b=n0imPYZ1+jtIGHCX/lMCAlwUJvN32zVALxbGpwXNPNXeRSLAG8uofLAHetMLQNi17f
         17cJtn3dE+qoGzdY2AchCpTVAwh4djvTCIhrxSw3t8xoAX0iWtRhPOHRQxT3AvBEx78v
         3UDk/c4a7ywu2RtUBjDyM2h7v2n09Std1EFPYO1zyiSlpX0VOtFm9gR9hQln/6aeFdlE
         KlhbVcbgdbEILlS/YOzesWIulY6VajbyMPilIVefF1AjxHMC9D7PJ+JEG7wXXe+QcgbE
         vC6osXAlATWsqzSIDaR5LqRduutbslGZWLVgUKPPKoZqDfLlMN3N+xUkZw8/dc+s+vOk
         v6ag==
X-Forwarded-Encrypted: i=1; AFNElJ/zIi/Qne0348FxC/aAM1y4aASOt2At7lA09IdoCUW666xIEL2kny5yBeMP6Ouui3ZIOvJ/MzrA9XrF@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7iCRjIkBDrHvGlvI+vQBkrzZDOoK8bwtmohvnIGWKLB6bPLKV
	lDLwGTog2RMwZzlqwXfogOKcd2LaUFMvEHOYsZepUrJVp9BQ9m1qV6gLYABpg+Oo5x4L++m3ZFj
	Zu+aqK8oqETnxPfzWSVMRhVEhAGoGQYahE/LQAuPJidblvSR5JCyuIpX4eedVMEa2
X-Gm-Gg: Acq92OE/EPk6CDVxs9PZ04fwBx5MhU7iLBf8x7ZaFFp4TEQQQRQwngncMqqoohoAViT
	oqhmUPtRgVEVUzUK/E8ZvMYEMbPagkjV1xxMSkUv2ro7GkJsvjdXPRtnCtWlE64hefD4ybRKnle
	Aj7bYRWRvo4vb80BW4RZBVC/L0ZzF5oE0HXUj2F2WU8DFHtnH/pLPoopilQ4pZe0zCdVFOG/7uP
	q74ybwfkmV919DGZIWnpeH2sS4hEkiJiFRuFPaa8qYakwaiFoYehiqcRSdmgqYoTVUBW1VMK7Aq
	DbPqYlLx8EUNjynfg8PlrVhu8M6GycaGJX3ZemkCtqjKGVtzTi0H1kLkky6nTmlSF5Dg1QeCOKz
	Z97k55zR6/LU/PWXOmmMzTBBSIE1OR6QgUFXIOwpts0kzUo9SKe8c/2IFPb3RzWM=
X-Received: by 2002:a05:6a20:7fa1:b0:3b3:fce3:a7f8 with SMTP id adf61e73a8af0-3b5e31f33efmr3104318637.15.1781180420562;
        Thu, 11 Jun 2026 05:20:20 -0700 (PDT)
X-Received: by 2002:a05:6a20:7fa1:b0:3b3:fce3:a7f8 with SMTP id adf61e73a8af0-3b5e31f33efmr3104280637.15.1781180420116;
        Thu, 11 Jun 2026 05:20:20 -0700 (PDT)
Received: from [10.92.167.195] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c865880cc87sm1827061a12.23.2026.06.11.05.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 05:20:19 -0700 (PDT)
Message-ID: <7c94758c-1100-43d9-a0a4-2cb7df947cc9@oss.qualcomm.com>
Date: Thu, 11 Jun 2026 17:50:12 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 5/6] arm64: dts: qcom: monaco: Add OPP-table for ICE
 UFS and ICE eMMC nodes
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-5-1cebc8b3275b@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-5-1cebc8b3275b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: LH87pzRqhS18PXe7ifGw_1NKsUdqlKst
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDEyNCBTYWx0ZWRfXxMDMPGODnNSe
 tivM0Z7NapsfnKMbyVLy+2e7YMI7K4GAgFFJXhzGtuTqTrfsILZ28S2cs12ag98kFQdwmMBXMCz
 DgYrDfY6NRJsftlz5MS072n7XnDAR4yd+rSW8g1FertNugz8+EQqk0hIAnRzMgSEXdLVfVtqF2A
 A3SqyIVmkLpSbCQ3+tvTbF7ZycCH/sqIsEzufhfjtfAzGD41GOMtX3bws9vRBS6YXwWoA1NgFsr
 z4LxFAg7EBDguWZOPEVTjKq+2um13KyPAbfhWvLjJq47M3PC+8QN/iLQDPpHws3uT54G9iHzp3K
 SCqLHZMk2f7Ev2YCkIsMQgvoeGI6TcWWurNr6XcWTc0+Fdg1Qi2xspNHlK82yRxObKVs2Q5HLnD
 xTIovileYZNExtnd0R8CsaBkHM6hMkhWcgFePw1CdjOCwv/ALqiWDtWbte1mec6XaQScm0CR5Ju
 jT1qoEV1LcKmwEcs1tw==
X-Proofpoint-GUID: LH87pzRqhS18PXe7ifGw_1NKsUdqlKst
X-Authority-Analysis: v=2.4 cv=fbydDUQF c=1 sm=1 tr=0 ts=6a2aa805 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=QRdWpJMrku1fmPn5X40A:9 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDEyNCBTYWx0ZWRfXxCsnNy5AGEnm
 JzKpipQzOTO+h2FYh5jAA+OxKTeHxlAmOBVoYPk3lMOHt/f6+P+YNXdCbu33KQCJGZKyMWnK9E1
 YKQdTP/ADB+p/Tf7IPKsSygJpY8qvW8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_02,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606110124

On 09-06-2026 03:17, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS and ICE eMMC device nodes for Monaco
> platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/monaco.dtsi | 37 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
> index a1b6e6211b84d0d5008231c55613a0ccd61b9450..d9298d8b7874b8669b2cded2a28a99dce6eadbda 100644
> --- a/arch/arm64/boot/dts/qcom/monaco.dtsi
> +++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
> @@ -2742,6 +2742,27 @@ ice: crypto@1d88000 {
>  			clock-names = "core",
>  				      "iface";
>  			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
> +
> +			operating-points-v2 = <&ice_opp_table>;
> +
> +			ice_opp_table: opp-table {
> +				compatible = "operating-points-v2";
> +
> +				opp-75000000 {
> +					opp-hz = /bits/ 64 <75000000>;
> +					required-opps = <&rpmhpd_opp_svs_l1>;
> +				};
> +
> +				opp-201600000 {
> +					opp-hz = /bits/ 64 <201600000>;
> +					required-opps = <&rpmhpd_opp_svs_l1>;
> +				};
> +
> +				opp-403200000 {
> +					opp-hz = /bits/ 64 <403200000>;
> +					required-opps = <&rpmhpd_opp_nom>;
> +				};
> +			};
>  		};
>  
>  		crypto: crypto@1dfa000 {
> @@ -4878,6 +4899,22 @@ sdhc_ice: crypto@87c8000 {
>  			clock-names = "core",
>  				      "iface";
>  			power-domains = <&rpmhpd RPMHPD_CX>;
> +
> +			operating-points-v2 = <&ice_mmc_opp_table>;

s/ice_mmc_opp_table/sdhc_ice_opp_table?

-- 
Regards
Kuldeep

