Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87A4304BBC
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 12:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767787412; cv=none; b=EXedJKe5DIiSPDlOvR5pBvipbnf8lJcERrtRhpuHtKFOOpny4fRk70fPw0PwQ67l9ddkPJBE6+gNy37Uq/tQcqe+ctfdr9ROl6wgZo/3aGHHqf76KOmFSWjCMrEFpl4NZvOVFXYiiiUWXdW6swEhZ6vohfeoGv41yt1DlZRxIjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767787412; c=relaxed/simple;
	bh=oMhk/Xq2aC3Aag3B5Yh6Uo35K9uJs0+HxKtSjP1ZhrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VpBTlN4k/xKXMRBOCEntpewXTkquIXeh+KleKzh1Y5OUvUsAmStFYA88WCyWNHdFzkc4d9oqzANXaBYfc7XKlijewR/GgkYM3pVvQI3Lc80OGjmkXN/Q3Tmt84K+gVBI/o/2RWIbKFfq5Nio78o1RkC75D3VZSBRmg9u9ECGtr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H839W9pn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZT/xmK37; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H839W9pn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZT/xmK37"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60791HOp1981313
	for <linux-scsi@vger.kernel.org>; Wed, 7 Jan 2026 12:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5OYIuWlfNmnER+pgxQN0927vrOsdUT6g48em04i5dIM=; b=H839W9pnQG6eZ8c1
	HTH66kEY0wsIqHxHKei1nAj7N3xuiARn0lGM1HgyVtqsGtfy+GSFpSnFPjy/GH77
	jdbitQjZyhKAVp1OEK3jtcRdJ4wdu74J9zHSZ96EadBezXuqkIQCvCTieRp5HIVD
	n2H5U5QRR1rdD/T84PwDQrP49Q6evMGf+hbREh7S+mY5i1r/2rsWw5O+CC7fP+7n
	faf3i4D569aMHHIg9WRsFLZW4fwQ1wDqo4V702ZeXT+vTGN+RCUxnTISkthLi2aw
	mhK/bpjw4DCo4LZ9/NlJ4kpQhDIEu+jNfDvLBYxklJezx1uM3x8m0tDjfMnI/5sJ
	59+J8A==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bhdavhy7c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 12:03:28 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4ee05927208so6117061cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 04:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767787408; x=1768392208; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5OYIuWlfNmnER+pgxQN0927vrOsdUT6g48em04i5dIM=;
        b=ZT/xmK37O8q2ZM3pH36dmgOQoCmLWt9FiIIVKrEwle0J5ckY8C4m60ev0UMmPj9vNW
         ac8VtufDmvdpBt8j4HbD5iFpXXqYySEet/wkV3iETioEL7j3BbCDLQYnni1dW89BcGAY
         9V9WyhMHMEVifebv88p0l/Gp47ppXZOx8Zcie/1nbenB7C/R2q2btyx8JFokDTfAZ9k0
         rJb8Ea4Sv+NTHZ8gLBNBcKN0PAMmxBW2FSj4Hzuc1r24dI9KEfvGpWzoZyQQ6553k41U
         r3PXqheXvNZJbJQIeoKch1bjQujUg1yn+oj3J+Dzhe/ukQUoRtl7CtPn5NAThjB8VItt
         dwVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767787408; x=1768392208;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5OYIuWlfNmnER+pgxQN0927vrOsdUT6g48em04i5dIM=;
        b=Gw9qB79suDSJVfwIYEG8x32KIB6tWNcoFdUEE6BEEBIuXsq4inpGiDcc82IrnauWIk
         pomSFdkc+Hia4DPn4soOBjImeqcUlNhFr0W+ynqgb8G9ZWPdQXEe9KuBuaRTBNsIwLAN
         Lio2wKzIhFhSumgk956IKSa/cAo3uWI/8k27DnvD5ShyEUytzkY/kMvzrzFWi6krUOXM
         DxwgS4/LSv8p2AcqBB5BpJoQ+0F1DqUCmXJcJd16vK7ZI9Ht5hzoOBpOEk4oOkOQB3lN
         ySXftjaEifk1th2QJjAxpzWtXgCsPA+7NAmf2YM/hVFE5wzQG8y8N3Fq7nIZgw5bDfMu
         wf/g==
X-Forwarded-Encrypted: i=1; AJvYcCWaMQSDcmnSmUkPSy1eivrl0X1Kne+4sGeRDfwT3qqtmi6NxHOsVlxoIUSqlx6Zx7E4vqeP2vHi9Z8x@vger.kernel.org
X-Gm-Message-State: AOJu0YwPPByCyXbv06GwkEfj6MB72R6HvaW+G6z1tWA/FaZR0gOyw28k
	NiDytRkKuPQVRbJvowUMeyZo1Wmn3/ttx+WF/lM+ZE0XzD2reI+0vi7Tgo+mlc/6mEZZ9thu/Td
	PU/iSc7XKWQMT+/Bq3vhrXn5fTENxvkXPfoqjbcNeCZZB/jd3nOcD5z0Gyz+NCmLd
X-Gm-Gg: AY/fxX6fbiaM2v+eRXawNihpxYOXOpzdAScBCPKmIkqa8z/lUe9ZecBCQrA1gS4P9Hv
	r0Jgld2sKek6JWyhJK9oBb3tPATBAjAgjV0BxZw0a7d/bn5E0fbg72atKaBFs1Bn2lOzsqNq08y
	h61S3OmEMTBPMNZTHCy4n0EdIOHBOgixkBvMbNTOnOCIpr5irb04WA8h2v6xJXzRKP3cVKL/Btn
	bxBikMzo6xmPp791kP54rwBZR1S9sYqi9iYD7JzhGtlNeJAGUJR8gfRPAJ3b+0S4s9fEGb2RXKb
	FR3N22aly2YYXu8u0zS7iEyzOKT42EpFpSKPhqSdrEmfiShxjrHcpsBMDH9tGVv5oIIx3ba0LUe
	lM+2RziaKBWxRaOedXLZIKUxsaZSOsFlRxRkWXRyK5+qKxCdCS/z4iaVKJusSvJ5AExA=
X-Received: by 2002:a05:622a:8a:b0:4f1:840a:c90f with SMTP id d75a77b69052e-4ffb47e3b0dmr22957311cf.2.1767787407869;
        Wed, 07 Jan 2026 04:03:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIUGxjnQgE4PgHsYyrjWsDHfJ6IeypN42Z/YRU+rG2QsfHWIVu19VW4NAlWcg80kdk86FAHg==
X-Received: by 2002:a05:622a:8a:b0:4f1:840a:c90f with SMTP id d75a77b69052e-4ffb47e3b0dmr22956801cf.2.1767787407325;
        Wed, 07 Jan 2026 04:03:27 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a23432dsm482678666b.11.2026.01.07.04.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 04:03:26 -0800 (PST)
Message-ID: <84799abd-3b30-4772-b716-37f97a28a8f7@oss.qualcomm.com>
Date: Wed, 7 Jan 2026 13:03:23 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] arm64: dts: qcom: milos-fairphone-fp6: Enable UFS
To: Luca Weiss <luca.weiss@fairphone.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-6-6982ab20d0ac@fairphone.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260107-milos-ufs-v1-6-6982ab20d0ac@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA5NCBTYWx0ZWRfXy3JKpfHTsT0z
 Ij5dKIokO/yQW9xOTxFEnkRpeBCpjrBfYuCWZFnVsp+3iuNLg+8AZdnomDD8DRBTgbRbd/WrP7b
 iiZYzUym2Iedg8iNlKED/zOTrzdqC+W/canK0xNGieYglOkwaUErrupFmbUiIa/WuEy0SSiNikx
 uOpjQzJCtsS7K7H6fFhEsHV+rOsaiCZncIUNcCN8dYiP5EX7dgcg+QSEv4mFrXtGTrqGxCeV0Vu
 s0ptXDwOcVAYYaNJt58X9RiTnka5dpOgpKr1ArV8BoK7pL1DxCgFUGUJMZhWsekqPx9nNKxBlAi
 gaccCspqc27/Zps25rVwVDZ62YFdxE9q39xLXbykdyamRaG1ssUXnEbcRWx04p2RX1MlAJxGEDr
 wgq3LM9c7QpiY8mE0v3b4Jb42NGTwjTsYjVC9eYiuGPsEjBdeWEPiRlUENfuYJdWZ2TacyDvdkk
 u+Cds0Z6OnDU4VPU1Fg==
X-Proofpoint-ORIG-GUID: yprQ7rYihbc4X6ncT1mX0iMMK-sU30Ki
X-Authority-Analysis: v=2.4 cv=comWUl4i c=1 sm=1 tr=0 ts=695e4b90 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8
 a=STFXn1ACf7ZPQ-DneOQA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=dawVfQjAaf238kedN5IG:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: yprQ7rYihbc4X6ncT1mX0iMMK-sU30Ki
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601070094

On 1/7/26 9:05 AM, Luca Weiss wrote:
> Configure and enable the nodes for UFS, so that we can access the
> internal storage.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts b/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
> index 3a7f2f2b3a59..7629ceddde2a 100644
> --- a/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
> +++ b/arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts
> @@ -819,6 +819,24 @@ &uart5 {
>  	status = "okay";
>  };
>  
> +&ufs_mem_hc {
> +	reset-gpios = <&tlmm 167 GPIO_ACTIVE_LOW>;
> +
> +	vcc-supply = <&vreg_l12b>;
> +	vcc-max-microamp = <800000>;
> +	vccq-supply = <&vreg_l5f>;
> +	vccq-max-microamp = <750000>;

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad

