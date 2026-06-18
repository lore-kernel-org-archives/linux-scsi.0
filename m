Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF953F823D
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787934; cv=none; b=gZdfzIRyQJzJ7iY7eNhru+QAli1HDg4qiGznWdmLII2BFzIOUsER0EhYANM5jMPGc7/RnIQJHYaMpdyeniooORYzAQwMJbhR1DiaLEpgv0LkB67J2/rHGRN3L1cKA70LIri71kJpWSdds0bMRxKZ13YFixnBqzYLNkfRNHfjOdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787934; c=relaxed/simple;
	bh=vzILV4+h0+G1LsFLbM2We1npcaJ7hdgJ1uT/BQ+/yGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ORsKC5fWCs9eNkigknhS6ANE1yeELMjSK1Uu2V7vzsN4UxTeoOmjeTIWXiU0S0FSC03pEqHV0h9wwMzksBrZM5GZ60jmotgNiDSNDDA9KvRGAwqWP36XgL1+lJn1o1OIdvITrM5nkTu0aY5805GZWapVqYC0+ddKq8Qh5yY9ArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AHo7QnnR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hA3XPCjx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AHo7QnnR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hA3XPCjx"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65ICuYcS1804223
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:05:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hExW5q53C06OI5kfHEsByW9qflDmMT+s04jRbOB0jEw=; b=AHo7QnnR9QOcBty4
	FuD6avT34992eZifOfKBbRensUEWSFnNabdOqVHqPsJJH3Xa1d28ezcm/8I+OIJp
	dyYxbNVqdMgcwm6SjE0dBWlJOfhYo6RH33VFLRFL5p0lp0mjjQlABBepV2JWx8A+
	8QnAT0mJ6mAX3CBxEVv22oQr6lWLCJE/i+zkrHxeKiuUPkj12bCa9DkTn59Ui5dc
	eYoYOOCWMfOE5IRzN7f3Cj/rAGLmJxwAWeerRq2Af74QdyvNaxvQhQeuDpECvaQt
	EAOlR0bAyr2GUdaxqeRUSErAmzq+gsuaKBoxXum/RCdZYyYzw+IUl7wm/L6VABig
	z2GBpQ==
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ev12kkgn6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:05:32 +0000 (GMT)
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e5fb37ac4bso145507a34.3
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 06:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781787932; x=1782392732; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hExW5q53C06OI5kfHEsByW9qflDmMT+s04jRbOB0jEw=;
        b=hA3XPCjxDtK5dniVwqSpUhXqwTKqW3COlKQqAIzNYOXaDVJJtq5KS5cYWerz/82wXE
         aUstQ7YTzdhq0as7M+h5TV0eX0jm9/uElS6L+HJ18bNokjICkR4OKRb+xxto0xBqW8da
         vrnw+f0/570B0++uHPPEHaNJfgiQWxfMJNIVGF2T6eOqejeiJiEtXeAMhBn8dfidso5f
         2ulTtFyiEh9zRIwtZn+uD6ozZcw3qcTR4xR8mZGBB/M6pfy9JwPcrPYewdcWub/rfC99
         DYCSoD/wU7nAIW8NqmutuziG4QYkjTFOFFjK9Vxrj7nlXcWqAyR8JvSs2F7UI9z3/D60
         uLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781787932; x=1782392732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hExW5q53C06OI5kfHEsByW9qflDmMT+s04jRbOB0jEw=;
        b=Ih/taHY81P8jIi4phl75RnKb/Rq8xtT9DTz3CBM8MC7e7Q3XcvOxVtzmmW5CoQ9w/k
         J6b6G6+ckHos0ZvV5JI6T/eftWdNNm2aNMmF6l1EHEnZYoZFTVmSoxHlbCS1eKAfgTYb
         8YgJ4EF/ItGhHGeEvnYlW0flagThejC5pncIlLJ9NHkAma8Jzc83qOa82wAOK9Uf2EIz
         O6fApnTlMhT+DW+HyEfT5f401n+mQ5+r9wxUlMSWpYst70o+O0hAMVYrWHgVVMYFvYtp
         noYApMjOCech5QPh8IxAQEXp/J0lmYQSdWwas+3iFe5Esga78d6hhrLVMeirxikSxQyV
         hFrg==
X-Forwarded-Encrypted: i=1; AFNElJ8yDSqintNZmhu/qWUfKlklTOj2MJWMEgsu1aq07C0j+LJJjEOLHlUgiRMCqrO1QigkoBOtKpXIdJcT@vger.kernel.org
X-Gm-Message-State: AOJu0YziKp8cIkfOjr/slOA9ifg1jlTEBWmxrRe9li91KiOcoQRt1xVC
	+AO2eebbBgJaosvUXbDoVe9LD6FcaORuAX+AcrMXse704EjhiEdU17koXIbYmOIMJ+MIJUgG3oZ
	Ay8jSL2BPkGktq0SHvBeNAJrfy9ak+BOJdw3iZkxPp8WHcfoimUcpMzaUj1d7/ndZ
X-Gm-Gg: AfdE7cluXMFMdWPJX9e98GZ3/aX3rPk+aurEwmgIDYKZ2TZrlNBYbdnAf+Agi989yCl
	BQVCmMYJAqHF+NQUcI4ZsKix474jN63B/wLPjXHh3RncL0Ymh2+94PmB9yhd5posLNMgBmByIli
	9c4mkcs0GqfNX+L5L6OmCmQSPUbCAwAL3+vPDlprCDKxb+IvfNttMndGsGLf1saguRppLDrKbs0
	toldW6OqTg2+krWKsZpU/kVXK1+giMbFc/Ziyul4aCqRR777HyCTMui2N87ZG2kN0/fHwBLsezI
	+7oOZkB/5G+Mu7i6MO9M5Q2LceRvk2yEzYDx0QgUgxhhifFeQqP1qKiV3V9LUJeyly3Bz5vlRkn
	2m0WGkkFm0+MgucoyFuXg6pthrr9CtVmiyGI=
X-Received: by 2002:a05:6830:43a7:b0:7e6:6f9f:7445 with SMTP id 46e09a7af769-7e90c7497d2mr4390136a34.3.1781787931545;
        Thu, 18 Jun 2026 06:05:31 -0700 (PDT)
X-Received: by 2002:a05:6830:43a7:b0:7e6:6f9f:7445 with SMTP id 46e09a7af769-7e90c7497d2mr4390108a34.3.1781787931149;
        Thu, 18 Jun 2026 06:05:31 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb4b22544sm929983566b.14.2026.06.18.06.05.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 06:05:29 -0700 (PDT)
Message-ID: <71f41225-226e-42b2-87e4-2c8b082aeae7@oss.qualcomm.com>
Date: Thu, 18 Jun 2026 15:05:27 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 6/6] arm64: dts: qcom: lemans: Add OPP-table for ICE
 UFS device node
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
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-6-1cebc8b3275b@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-6-1cebc8b3275b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEyMSBTYWx0ZWRfX16oOmGut0PV+
 5kd6bn8UINQJHugjJTr5+ZySv4dNpVdHd2gISUiPTVm8N1U9drk3TVPrCcGZPA/7wyeekKExOlp
 oTewMKWFIyCztpLSRk2nA22gCVPEdLNmWNgB4H5q/8raWeyY9r4HCu9ytyxaAipdJbBdZXavlEe
 Tydj9teZ2opPUEjghclffiXb/e+qhbQLT7+QoCQZFxiGOnrvw/Y7cinCnfyx2MnsaaslSbXLwt8
 lmAbB3XLPCU+tE4MsXN4HiO/qGS8CBX77AyfmsjXhlNfrhsuZye6G482wYDUuFgmjXgL6mltmdZ
 eroocIDAKjk+B8xxd/Uof8FMyLwrAW3qhTuSVDt8Ts4ylRLIfbn/u+HGAcU42wPh4S9z0fEezsS
 Q84Ws5OODz5cZt1S74aet2JjXtS13A2qd2k05C6zbsIhfx95w2PQNsU30KerM4psnYcimm4wUR0
 gzLT/0XvOwqudc+ADtQ==
X-Proofpoint-GUID: g7Ut2wE5j9Fkd25tHbpDqBkBLo6TWQM3
X-Authority-Analysis: v=2.4 cv=HpVG3UTS c=1 sm=1 tr=0 ts=6a33ed1c cx=c_pps
 a=7uPEO8VhqeOX8vTJ3z8K6Q==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=OfDFtJRAjKKuzGRYHJAA:9 a=QEXdDO2ut3YA:10
 a=EXS-LbY8YePsIyqnH6vw:22
X-Proofpoint-ORIG-GUID: g7Ut2wE5j9Fkd25tHbpDqBkBLo6TWQM3
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEyMSBTYWx0ZWRfX0MViGK41y/uL
 j/4ywSjADM/bXd8bMrTpnku2hbSTVwVO9kZQiPpu6I6JLzRM66xdiskOgLWU8zihKY/oWoD+R4r
 HvTD6TW5/95n9jg41VG+FUhOKnEdcnI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606180121

On 6/8/26 11:47 PM, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS device nodes for LeMans platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/lemans.dtsi | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
> index 353a6e6fd3acb22ef228bee340212b8b2c300957..f100d706edde465730873702f0b0a00b44050c23 100644
> --- a/arch/arm64/boot/dts/qcom/lemans.dtsi
> +++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
> @@ -3109,6 +3109,32 @@ ice: crypto@1d88000 {
>  			clock-names = "core",
>  				      "iface";
>  			power-domains = <&gcc UFS_PHY_GDSC>;
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
> +				opp-150000000 {
> +					opp-hz = /bits/ 64 <150000000>;
> +					required-opps = <&rpmhpd_opp_svs_l1>;
> +				};
> +
> +				opp-300000000 {
> +					opp-hz = /bits/ 64 <300000000>;
> +					required-opps = <&rpmhpd_opp_nom>;
> +				};
> +
> +				opp-600000000 {
> +					opp-hz = /bits/ 64 <600000000>;
> +					required-opps = <&rpmhpd_opp_nom>;
> +				};

Analogous question for both pairs of frequencies

Konrad
