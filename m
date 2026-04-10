Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3568C37E2FC
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 10:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775818448; cv=none; b=kVP7d7ThbvctIhHVz9oHD8Tqk/LOyu1Mp0ZP9QzTw5XQnk6Sw3dY399gKp1D3uwPVWRU+Dr30DthSHE8XqRWMrc371Y9x1ZWARXcfuWrZLNafAO75wyu1bUQ9poKmwM4T4JBsZxpmS1JgMrc9+5ywnvuAoi5fB0fvLIOYCX+BmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775818448; c=relaxed/simple;
	bh=g4vDsx7AAeCpkibFY7xmrW+P9uLh9E8MtiKJ9h0jWFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G704U0QTdT9mjTMVixcgRVgpAxUqkrX7uNVgoOi5Pd04p3Le1PhVCPmRJ3rZG0gakBWRztyW8e0VPxtBDxbff1DOScA/BZopV5ffcwlRkcljzNISstth0kcbItuxeLtWwEWS6uppRyBXj5Ns7gwauay5XzhPBuH8zWJt7mv4vtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PI2wsrZm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T0Q8CKmV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PI2wsrZm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T0Q8CKmV"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63AAZeU62698298
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 10:54:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	T+T0pbPrCFK4jJi0PBGJd5tN4NDcA3zu0rne4iUcOJ0=; b=PI2wsrZmhb06nJHk
	ixSERcwKR7VoHMq5XbS22tdm5yrkvWrvRSPtYIMxPsG98HNSKGig5N5SneTqiD4V
	O0tFxjI5cs5otUqvx+3fQNoPKfQMVjW5lgtMdKOnOAMjbeeUq/6CTuMOEAgA7/tx
	juB2fczNkQmTtmp5/1CHgCofb0wPHHDx79kBtAvxiuG+7fHuSgw7G0QQvN7QOZ1N
	Dgq11cyBaL4AH7nwJYluA7o37LmeN0/TtuDFWSSO6GHbmGjAR+2EV9VgsXREdsDT
	erE9nrZloYPURlGNGm/epf29KKRifpnWq7FwZcO2ibA3WGO6ufIL21IwFOxtWa5r
	z0++/Q==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4degt9tu6w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 10:54:00 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b242b9359aso18662475ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 03:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775818439; x=1776423239; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T+T0pbPrCFK4jJi0PBGJd5tN4NDcA3zu0rne4iUcOJ0=;
        b=T0Q8CKmVv/SpNxwj2Z3Edv/WlsXgGhELz1+WyVDJRtCMBlvbSvmMtG0B6WXnX0hzja
         fQHz1x1SVB1MHqFJsEgFsG8FR6WmPgDeYClMptyQgB1AVrcFgfnvrRV1wtksOhSsWiTM
         0Lww59K7Xss7k6qlXUa2DKgVF0Iib9Fgk3+VEC8l3w8eL1k/dK+RMsURHWSGCz7bi/L8
         okuxYwI64l1BJOaSX49vC51ihxf0kb3qVEErqTNhAWHAJZhQCuNp3e4p9kQmdtpIsg9M
         9BeZAYfuru5q901YqHOaKZrbaxkzpN1h8SGKV1tzHBNnZtmisPlhD2KS1bqIQES7KD+m
         xuEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775818439; x=1776423239;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T+T0pbPrCFK4jJi0PBGJd5tN4NDcA3zu0rne4iUcOJ0=;
        b=U+nUJeAb9hhqcVhqpxpyIUMCPtsqiAlumFzyY9iPMN3YsYtkvyeO1y4dE52/G7CL/9
         UdGHNR1sX+8fALFuDN13vV2DsAyY2k7OLNw5H21i7vz84XvigqnlTIkZtWB/Xa0yqGmc
         jjMxw82YLgk/Pt7SoWPCb8rfFc6CJLp6Ky2SZqeV2q5wnoBYzTs/MVaDuNC2jbtCkm2i
         5yiTNS1OxgPvy779YO4C24alAlVsy8SLqt7ZviWwmA4a0hIu0r5NEqklgJ0B6RCz+CHY
         chGD/Kv7S9XRrQyHoOe+53F+6XMACtHkb4OuqrYAD7wffRs8EcXvXfOQQJ0A80mQqdyN
         lpzw==
X-Forwarded-Encrypted: i=1; AJvYcCX/d5mC8QYl0X33iwzPuPV9DBuk6ogFRbGTY4kBFF/0bL8M4ra0p1AoaDbU2reYcq5kSrHYOzUD9WBS@vger.kernel.org
X-Gm-Message-State: AOJu0YzmXVGFOHLnjCT1imV9su9LcIrGLD8S7d/ycZfvqCMXZYGQMU7F
	CtocXcsP00fsPtWElYkSFn7wof0m/rCAwrEs+b8TKGR/DC53bHQxN7KALIjRaNSi7J7eRiFbkEG
	samWKTPrcg6DgDH9cF5RRaRWmhSyDqRKSGJ7B7eKEqZyaUghnHJ5F6OzL66EiKgar
X-Gm-Gg: AeBDieuep2P4lhUlOuFR9VugfFOr04SR/L8lzGtQ0V/Bsz51OV1SPgK1lCL8MTRgVOh
	h+km3ht7lDMsKlS5HkqncpywlAn7zEU53MOd9ANjsdEDraVEdja0lkE5aPVmO0D7Z/eXmJu+m+W
	EzjvMVHhQqprNFaLiBGa7felYtqoXsOSnmQW5Xch81TXncRG9DLsdF68TDJYBdRrSJUZvTBAmQ+
	GKiHfTG1asr2rlENH5C0JttOann+jyPtsEoQ35UtaaWzOMmj6/vNIVy/bqluyTqyfGJ3K0xzyJT
	G3yyVKWsJhAHHTSWG4DDzoAby0Lv0Ri7qLpJms7GDUzAH3nO/l9PlMd5zitgmrMFgRJW7X7yApt
	xjNn0Rrq3l0omxavGVyr0fVz9avBTWgrUyA2qqNtA5UZWEgP6EifT
X-Received: by 2002:a05:6a20:432b:b0:398:6ea8:21f7 with SMTP id adf61e73a8af0-39fe3ce5e7fmr3214217637.15.1775818439093;
        Fri, 10 Apr 2026 03:53:59 -0700 (PDT)
X-Received: by 2002:a05:6a20:432b:b0:398:6ea8:21f7 with SMTP id adf61e73a8af0-39fe3ce5e7fmr3214178637.15.1775818438564;
        Fri, 10 Apr 2026 03:53:58 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c79218fc8d9sm2160706a12.12.2026.04.10.03.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2026 03:53:58 -0700 (PDT)
Message-ID: <cb6b19ff-811b-427e-a588-cb85c6854da8@oss.qualcomm.com>
Date: Fri, 10 Apr 2026 16:23:51 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/5] arm64: dts: qcom: kodiak: Add OPP-table for ICE
 UFS and ICE eMMC nodes
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson
 <ulf.hansson@linaro.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
 <20260409-enable-ice-clock-scaling-v8-4-ca1129798606@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260409-enable-ice-clock-scaling-v8-4-ca1129798606@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDEwMSBTYWx0ZWRfXyPWHvJpyDZIk
 Fh/ANgY7AkzeCCHCiTrH2gIjr66AFF6vsJ7CK5hg96D7BKSy75Oe5ArREqSnMu6puPpBpXyj/Bn
 ri7dZPiDKlDSVbmJqxaP2S1VTAJP4hBOlDtpwRqK+6mKsEAgYT5fAkQfGIS0jr8SJ7+yInxXRWP
 BW8ST2qqkt34Y8KJhIbXFsn6te5ohTK9JAu+qhF6J1suGTwtwTchlRKUPo1PwtNeO+rTXLhVJrN
 lM5zZTpPXSlP9q/aSgB52J45Zvpc2fn5lNpvXKQ2S8voAd0oPgsQQ+IUKt9kTqhS42TLKs1G2gy
 Xei1nY4zAhBNSsgNQ0IxstHhG4ja7YaTk9AwH410hM/C7+aKDoNn5pTOXbAGrIpcae4SGVmtsKl
 1VIxgecBefSmz/jafj78Pzh8TOM0f4Fuy62Fm0AO/p+2SGwlvCfCHrcsOLk9e6K5kBHDCcHIbWm
 OOXwsYzR8HprRkEx6rA==
X-Proofpoint-ORIG-GUID: rQskLTR5lpG5a2fp5NXyjz3G69petjjG
X-Proofpoint-GUID: rQskLTR5lpG5a2fp5NXyjz3G69petjjG
X-Authority-Analysis: v=2.4 cv=BJyDalQG c=1 sm=1 tr=0 ts=69d8d6c8 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=QRdWpJMrku1fmPn5X40A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 clxscore=1011 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100101

On 4/9/2026 5:14 PM, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS and ICE eMMC device nodes for Kodiak
> platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/kodiak.dtsi | 42 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
> index c899a17026fd2a10ebc528a816629c88ee3bde5d..b0aa1970d42a3bb0b9d371e0e6cd09b8cd164dbe 100644
> --- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
> +++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
> @@ -1087,6 +1087,27 @@ sdhc_ice: crypto@7c8000 {
>  			clock-names = "core",
>  				      "iface";
>  			power-domains = <&rpmhpd SC7280_CX>;
> +
> +			operating-points-v2 = <&ice_mmc_opp_table>;
> +
> +			ice_mmc_opp_table: opp-table {
> +				compatible = "operating-points-v2";
> +
> +				opp-100000000 {
> +					opp-hz = /bits/ 64 <100000000>;
> +					required-opps = <&rpmhpd_opp_low_svs>;
> +				};
> +
> +				opp-150000000 {
> +					opp-hz = /bits/ 64 <150000000>;
> +					required-opps = <&rpmhpd_opp_svs>;
> +				};
> +
> +				opp-300000000 {
> +					opp-hz = /bits/ 64 <300000000>;
> +					required-opps = <&rpmhpd_opp_nom>;

As per hardware spec, 300MHz is supported by SVS_L1.

-- 
Regards
Kuldeep

