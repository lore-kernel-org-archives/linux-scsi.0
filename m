Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369BB3F8229
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787907; cv=none; b=GdlClZTm2YkF42XbWzCxZH4lhqL9A3jfLQJatY8cJt9HrdCRR4LjJ9YkelUDcA8Tm5eeKft6v/tAORrsmNOO7O3Jq1WUHgBJ/yXXAePRVQqjqtXy1nC6FkxB72w4yYSKYvFUZ8P2yAB4iwn1NUJBWBB9qIGxfhExT/Qefi9pOVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787907; c=relaxed/simple;
	bh=iJFpoj0Y+KkhOxJkO9jtgeUe8Nz64iXqGZjDvXZnyJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DBSYnIs2D2ld/s1bB6pzZXC6bj5qazCUaourV5onY037mJp2tgZYsUj/aLwIi5rQFmGtA9osDUXzVNqFuLoIzc5/4i8RGvMdRACP934vaSjTPUg4I5i+DgjN7XxecdW4+M40kf/XswrRuICN9NcvjcRyVozQ3uHjWEN7xyt2PoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=L45ruMnf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Os5cPV6P; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="L45ruMnf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Os5cPV6P"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65ICs1NO1320090
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:05:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AdpWPnfspT0O4IPRrN2sCrHLTuOAQdpa0+3S2ykbaYU=; b=L45ruMnfSUOYwG3/
	WLCojx3MdHdc9oEGKewXflXk0OQM/XLe+iQRLiQDvF80xn7b6eSUx6chpBMCuqar
	wlR2bPrVrEZT0EQFBgLiL21bN7Rx7Buuy8V2QKp74zc2U84PETEwY6CbFyCaVDJq
	x5T4HMk2HInVVSp+/9O4966VIup78INEziGHIQPpAMwrl3RlFB/VQWeptpzViFSi
	fN1m2bsript97o8HTU1hEaeej1ebxDwPZGMMpWGKMeg8iYSO5S24ytx8oTt8TJSZ
	lX/JxKF3+MxPHPgeIkFZGPI+MUb0XiEq9V4AMqumJliRieyWMzlsD2CBX7PfPR8T
	G8gcWQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eux2cckju-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:05:04 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8ddecbc403eso258456d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 06:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781787904; x=1782392704; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AdpWPnfspT0O4IPRrN2sCrHLTuOAQdpa0+3S2ykbaYU=;
        b=Os5cPV6P9KKADMWgih/gwCU/2yspj4T11Ksxhrn87DDJzapp4CrdYSPo65DzAjaOg4
         7mOImf+qD9O6rmIhmzXm5zrlD39EN+s0DVkJT5392J3GuEy/1vsX2U0m5fpEU68pf8VB
         2lMHSvJLfECelZJRkmTGUg2Z9XEYDDsIDmQZa0hMqK8fYtDX16VdmqZyrbjBFE76hYX5
         VmLMKoeU/xvCKfOr5o3vQVWCLS3t4MltI09sHet7dAsJvn9v2n/JLCr5mduAQ9NTvs+w
         jVw+Pe6N+K86LhXIE++hPVI7iGh/V37mX0PpndU61+pKu7o60Q06dXEGwNgiD+6MELnc
         xuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781787904; x=1782392704;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AdpWPnfspT0O4IPRrN2sCrHLTuOAQdpa0+3S2ykbaYU=;
        b=PN/r8GDBvGtQtOJWYaDlRWk4fRr9u0GZNmzhEC/zH9WJGT2BXwTgaiy9ACPz/kzkAK
         RIhbyaW2OApllNfm2uW0lxm+VSkhD/OMayk2llfXDUm8JIM4ecuuHcbntgqdV2LCaRHA
         ++lvPYUNVtapeUsg6HKvo2xGyDfZYu+uVqxKVngT2stO3Qht/icuGgZ1uw6nX/zbP0XH
         WFeUBV0pRfVhHFJB4sXgU5BXtS77Y+cZiE0e+F6B3WQ5cbokYrmcMybjeOAUxfjEJbCv
         nECdTXUQpRx6M5Yy3Umq1NPn0J8VJwqSooT2T3BQ3GP5h5C3wvEAI37UAUKtqdiqMP2E
         CpRg==
X-Forwarded-Encrypted: i=1; AFNElJ8es3f0uo0jcMjO/EzxvrhQAzJiEXrI0+Mokcgste7/1piJJg2El7nkOiBopsAiNGZrmi2WDFCgpjx3@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp33jcZEgwXTsIJa9UMPRwNgU72lYzNVFaeuuQwA0rTgE/m7b2
	LKYpRJUI84UKrTNBm0vT/FVkMKXkVT8h3tZN9CoMGjJupgW+2Mt3xxRR1icWM/t0qLL3B2WX40c
	/nln/O96V/qwoLouXZi0shmACflMtUPt/VcuYHRnh0YSqxPqkbNlwgn9HOXnAM3c0
X-Gm-Gg: AfdE7cmOZCy/0YSZ6iD5TJSJSn1FaF+0z/qig9iXhFFGEJ3Ec7VOTHHX9jImszAIMv/
	FculSR4mOj1Q0S8yZ68qfXN0UymlbEzsVimpJNFMycI7mX8y8iTDxRCUuQy5+H75CBu+84Ter5D
	EJUYyjaneXToM+uY7YZtaCwDx98qsyGFdwas3clb3Aqfx5bTD/k0fXbODCONrXzwfQT2q6t9zYR
	ZtT43uSFZx0ah6iUkqO/xYS7AG5YM1YXC9h2rYgDLJuOBTA0mNXW1b/f6aVgDQsfWKK67dU88AP
	N8HEhVX9bjBhKScSu5jhGMABQaY5Bb3VS+xZVi2k3aloGwbOnS0s3BW+N4+bnzJYa6d1//EAOae
	veAsmNDQCNzMlbbebu+XB3oIeTVlWWQksJh8=
X-Received: by 2002:a05:620a:d95:b0:915:769d:56e with SMTP id af79cd13be357-91f27bdf21amr330333585a.1.1781787903792;
        Thu, 18 Jun 2026 06:05:03 -0700 (PDT)
X-Received: by 2002:a05:620a:d95:b0:915:769d:56e with SMTP id af79cd13be357-91f27bdf21amr330324285a.1.1781787902760;
        Thu, 18 Jun 2026 06:05:02 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6954c2a4450sm2231829a12.16.2026.06.18.06.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 06:05:01 -0700 (PDT)
Message-ID: <d8fd7888-cf7d-47e2-8e77-3ba705c88502@oss.qualcomm.com>
Date: Thu, 18 Jun 2026 15:04:57 +0200
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
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-5-1cebc8b3275b@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-5-1cebc8b3275b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEyMSBTYWx0ZWRfX6DbfETA9JWQX
 G3fmDgykxggp6RciQRN1tGefRaG2KZd9a6Vn9hn5QMuvB9E8rah5AYjmo7282mhXNMKUq4KO+lE
 3LlRrmHEqIKQFaQqp5VxDUQAGdJ/E5uYchrS4genUO8EpmMqBT/QEQUVK8p5kHDDlnkur73/uTt
 WNzWvUcKfYbPptnow6jYKUNieFA50YfQ3GAnpD9zWhZby8eYtG5kUWxBOdqMqjY5vy3MIU0wyh0
 VT0qCMPBa7dbutQekmJt1xK0Ak+IHeOaQf2Ye+fnWz0gXs0eLWCbdowoRDPdabZSncZY62VdVDu
 b18eJMSrRifmey1hmHAsBIcGDb9llNiR/S+Aj3WIpVQFZcXrvt5zjbVNUVE2EU5Uo2BS+rMgPbd
 87Cy5OVYHngsiMlC67VubWQ11VSVoqhD+5yDZtTBqUvtSYhyHyWXa3pFy4C7muNMlokgNv73mbg
 54/JcX70a7AvrlyJuhQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEyMSBTYWx0ZWRfXyRGCE3Qy582P
 94qMc8vv8RN8XApfebZgGBCo6ZYpqhXya5001bjIrgG1v8tL6lHELIlCwAPhSaDwPpLkBFjkE/B
 t+Ac1C76bwcR8Cc6N1v6Bv9h7V0EC5k=
X-Proofpoint-GUID: yGxEpjpZyrCa4rSZP5A6O-h4x8J9f9TQ
X-Proofpoint-ORIG-GUID: yGxEpjpZyrCa4rSZP5A6O-h4x8J9f9TQ
X-Authority-Analysis: v=2.4 cv=WN1PmHsR c=1 sm=1 tr=0 ts=6a33ed00 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=QRdWpJMrku1fmPn5X40A:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 priorityscore=1501 adultscore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606180121

On 6/8/26 11:47 PM, Abhinaba Rakshit wrote:
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

Since 75 MHz and 201.6 Mhz require the same power level, is the former
OPP any useful?

Konrad
