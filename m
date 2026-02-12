Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B61E2EBBAF
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 11:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770895808; cv=none; b=mkzAWHDHclDfM9kpuZHnQ9viGF9jSc6YVZrmY3WsmLCq2mI5pS0rjCzlwoC2hWHDTLkqwrFf1ryT1KEV/kCwLNEg9XLPQ2kCm2p3WKTu7/jLuya+WoZZk8usHHYErsDu73tYFkLDLcu+R6OGUpagDD+lbwTnXkmS/Y21EqDPDI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770895808; c=relaxed/simple;
	bh=s/xg6C6WN2NIXO1VE7H68jznG8Lz8f8idcAGIpFhkXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hqc2o4OqX91kWDqTSsXP7wiO7UGSHThDkde4tS66mWLV8TQN6j91npmImMDaOtZEkwonrRmlaLrQ9s492qQreLzrbJWvWGFKQiR6VNrB7SmLwQ3Y06LCnM2izKtzdBIhkwM/TmetUnvrbXQ0zuZRVeoOUHgSZQLiW2v+KyleyDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cp5oxCmm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cwK2gFx+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cp5oxCmm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cwK2gFx+"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61CAIHKB657755
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 11:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	CcafTaVjifqFrLoCQd4r4m/zCs1n46XiePZ4WiT65Tg=; b=cp5oxCmmi5uiP91R
	omlhAZvPlihcPIEMr6YJPdw0iPUivmDq5wu6B57wr4cIWi4vy0l4gSNtuvYAHHqk
	xAX5ZrV0dm2qV17PeYiVzPwmQxlWvOTueaqPJpGt4ko5Yxnvt4xYX2sdjxaASZE0
	msurNksYX+8eOhTtVLkYUipLDwKzvbu0SQDaYfew3EqxaliXJaImO0WDKYvArodf
	GrXQULaq+GwSqKsSjCsGfDhaYaPtK7cfvcXaCTItZlrBAr/4IovFAeOTBsXTc3ck
	elsHEh/eElFLiZSN2r5R8xoC5BEhDls71jpW/B1tBpVFq2H93vUPMRmEENcZzU7G
	9BlgGQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c9d09g6q0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 11:30:06 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8c710279d57so265970685a.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 03:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770895805; x=1771500605; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CcafTaVjifqFrLoCQd4r4m/zCs1n46XiePZ4WiT65Tg=;
        b=cwK2gFx+005GnA2gRJEBkCg4Y+rXXGjABsdpTTufPculx5Imzsr68LztdsvDf4ozTe
         gEOC3qeDxwSwGNmA9jDQ1MiPIlJYMq5jN+7JW379ZjNHRGvE9fA/noezMXaRDV6j3O0q
         oLy//xmVrTtwPQv4yixpFLMHMdt65vtms8V61CEaBngL/qFWAkfmo6xj+4tGuK3g89Bf
         v6I1DczdAtjhrBN/LEwsurTP8YfoiSlYQPExud1gKJZ/vQvR34j2PYtkdCygT+/p3/5x
         NmktCbIUtEaas+emSCVEB3dO9qYYDBFxq7EEphCWS+Gaj1R3MXxYh4dFKqamiu6dFPBk
         ayJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770895805; x=1771500605;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CcafTaVjifqFrLoCQd4r4m/zCs1n46XiePZ4WiT65Tg=;
        b=U8oTORvuvpAqOjpmdAvhwmlpOuORr6TYDm7EdfNpBD5iQeVK3I+aMfsrg3dkBOpJe/
         FaNOIsnGPDWgKCThpEuKG6eyuA93ONd3PEpjmpMwdSxEduW+QgbuaKqr0jPvX4mVMDfi
         +Ue1jrmLSZn1zsaqLl4W80xJ5TCK5gb/5oXNGn8NA+6bU4ArnYrxg18XXoYzX/QbOv+x
         M2msHLKH9D98W6uQdker/QUSH2wMu6A9E+7aXqrzcT6LklVbPNlOWgBJOUYPmDmzGLbW
         4xPUGSbsPV9+tKrinRFbAFKkHFXpljm0YhXDPZ3vcucJnXxXVUHVxWQtQZ9PO+2iDt35
         n56A==
X-Forwarded-Encrypted: i=1; AJvYcCWZcbC/L/xGWBYjlqU7cUO5++2F04adNWGxMDM9gYPhv3E+1l63hMilaGulRzPhHSxwnqD+8X+zX0od@vger.kernel.org
X-Gm-Message-State: AOJu0YwIp/dZswvDFLsLqICPhUH3DC4j5jYWP7TrI/T9Ym1DNrwn9rke
	MWsoiDBznpUvrnWJRX257MGjGQWzkmwlsLX2hR788cpnFP5gD74CX7g6uduT5tQ9bS6pNMrFa+6
	UJslIDedw4HyJHFLHcvfg9EbGKzcqlgvWKSF9Eio27T+SZQQ5o+Z8IBYe9g7iGTfz
X-Gm-Gg: AZuq6aItvycxmz7AxBxJ1XRgb+jznUgHAS5uVw6seHKxAlVevye2/rCQ6QeELgcgxrs
	7upPWl797u4j6uskZ7RlSP+M7GYfLjEPc9R25boV6uMC7sWrvk5BvNYlX4ITJCI8NBtRFhj1nz6
	6jHyhNzRBpEFvaQEIxcU9i0OwzItAPXdGqftkuMEMF7Hj9xwb7CA5rXz9tzpDYOJm67QTzWBbDP
	HA1TWFjbkY0Uk7Fu/cTxsIs+AfkYpZXxiDfSHkr4QcuiFq6PgvxZ9F+e+YlBGOEpynzpNYT25Cl
	oVQQkNoBCXLo0U/o6QQbj+lEjrA4+gjCzVXNQBNA6piHxy8Gg2UDPUPsky8MlaQV2QfGG0gH1EX
	IfL8M90o+cpuqcMJs/QRM5s2lIZGe0/XDr94YONgdFVGDa75dhE+kMCa5YVcQoF7jP1bEI9UArP
	aCDKs=
X-Received: by 2002:a05:620a:448b:b0:8c9:eae0:d1df with SMTP id af79cd13be357-8cb33115b5amr226370985a.6.1770895805146;
        Thu, 12 Feb 2026 03:30:05 -0800 (PST)
X-Received: by 2002:a05:620a:448b:b0:8c9:eae0:d1df with SMTP id af79cd13be357-8cb33115b5amr226368085a.6.1770895804702;
        Thu, 12 Feb 2026 03:30:04 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8f6ecadb27sm147972666b.63.2026.02.12.03.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 03:30:03 -0800 (PST)
Message-ID: <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
Date: Thu, 12 Feb 2026 12:30:00 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDA4NSBTYWx0ZWRfX/qzMtIM8E1aB
 0obMYY/kWaytPjC6+jn8zE8m8h5gOT7knEsWhR5xLRZMEUMEdBtNEVlsufLoifAfJIluL45DSrc
 u6MhxLwqH1kA6CpCSNW8ROMh7RBPygao05Xl/h8Xluikl/fmsDIyqNih8vHoMHj/mOJPIj0Xl7W
 m2oUOWfZrKfvf1A2tNA6oiplXlHDFw2w6GhEes9y73YcrxuXAEaVlxuJFUazYzeWmXUbAadvTk5
 q74mBBUov80QxsmIyzN6Bv4CncfbXr5OLyaFczn0n/7JCj0uiQ1a36FSdTjWh9ijwf1cInWDLXc
 LVo890Rdfmh+ajXu+evcBH5d59sVZRoVaSdiq6dyuH9q3Yn5ui78pRMuK5Dxag9jkLb1hceplul
 RD/1LYoQzfzVhTMJwLJbTid24tC+XxQMJ4WoIdETvJyvf9+xRh36tTIJ/UAQ5xWNcTH/VwAutPX
 89C4XWbFYnvydIuFSeQ==
X-Proofpoint-GUID: KIYriHj3uWp_sqb3OT6jyKjLpNgp8iuP
X-Authority-Analysis: v=2.4 cv=Y6j1cxeN c=1 sm=1 tr=0 ts=698db9be cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=cMzz2QcylWOBvAN0VsUA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: KIYriHj3uWp_sqb3OT6jyKjLpNgp8iuP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_03,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602120085

On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
> Register optional operation-points-v2 table for ICE device
> and aquire its minimum and maximum frequency during ICE
> device probe.
> 
> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> core clock based on the target frequency provided and if a valid
> OPP-table is registered. Use flags (if provided) to decide on
> the rounding of the clock freq against OPP-table. Incase no flags
> are provided use default behaviour (CEIL incase of scale_up and FLOOR
> incase of ~scale_up). Disable clock scaling if OPP-table is not
> registered.
> 
> When an ICE-device specific OPP table is available, use the PM OPP
> framework to manage frequency scaling and maintain proper power-domain
> constraints.
> 
> Also, ensure to drop the votes in suspend to prevent power/thermal
> retention. Subsequently restore the frequency in resume from
> core_clk_freq which stores the last ICE core clock operating frequency.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

[...]

> +/**
> + * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
> + * @ice: ICE driver data
> + * @target_freq: requested frequency in Hz
> + * @scale_up: If @flags is 0, choose ceil (true) or floor (false)
> + * @flags: Rounding policy (ICE_CLOCK_ROUND_*); overrides @scale_up
> + *
> + * Clamps @target_freq to the OPP range (min/max), selects an OPP per rounding
> + * policy, then applies it via dev_pm_opp_set_rate() (including voltage/PD
> + * changes).
> + *
> + * Return: 0 on success; -EOPNOTSUPP if no OPP table; or error from
> + *         dev_pm_opp_set_rate()/OPP lookup.
> + */
> +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> +		       bool scale_up, unsigned int flags)
> +{
> +	int ret;
> +	unsigned long ice_freq = target_freq;
> +	struct dev_pm_opp *opp;

Reverse-Christmas-tree ordering would be neat

> +
> +	if (!ice->has_opp)
> +		return -EOPNOTSUPP;
> +
> +	/* Clamp the freq to max if target_freq is beyond supported frequencies */
> +	if (ice->max_freq && target_freq >= ice->max_freq) {
> +		ice_freq = ice->max_freq;
> +		goto scale_clock;
> +	}
> +
> +	/* Clamp the freq to min if target_freq is below supported frequencies */
> +	if (ice->min_freq && target_freq <= ice->min_freq) {
> +		ice_freq = ice->min_freq;
> +		goto scale_clock;
> +	}

The OPP framework won't let you overclock the ICE if this is what these checks
are about. Plus the clk framework will perform rounding for you too

> +
> +	switch (flags) {

Are you going to use these flags? Currently they're dead code

> +	case ICE_CLOCK_ROUND_CEIL:
> +		opp = dev_pm_opp_find_freq_ceil_indexed(ice->dev, &ice_freq, 0);

You never use the index (hardcoded to 0)

> +		break;
> +	case ICE_CLOCK_ROUND_FLOOR:
> +		opp = dev_pm_opp_find_freq_floor_indexed(ice->dev, &ice_freq, 0);
> +		break;
> +	default:
> +		if (scale_up)
> +			opp = dev_pm_opp_find_freq_ceil_indexed(ice->dev, &ice_freq, 0);
> +		else
> +			opp = dev_pm_opp_find_freq_floor_indexed(ice->dev, &ice_freq, 0);

Is this distinction necessary?

Konrad
