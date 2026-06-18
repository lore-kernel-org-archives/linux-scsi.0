Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFE33FBB5E
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 12:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787549; cv=none; b=GCltLspLyn6Jo73wGJvxWapSuT08cnyaD/gNsgBuZbiTqp2uVKpzrTIdwZouAnTwqMRRbhnBLHvOTGrfWk9DSJ1cp/jY77sfgWrM5ad3jkncfnox32QD3NGG+m9afVxZ4LA61LqLwupbUVELjy8ijeDctnt8HWswfbpKjbKWJL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787549; c=relaxed/simple;
	bh=PNtWWUZnOoeuRuQvHHH8ESeBdiXIxik44bljZe73FdQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sp9Sd2XxNtx1zSZ485nAtKnoj/5DTTvHHbFeqNo6cLRrGPSEt2NaQHikBAyg78lwhQEU5DzOe4YSz5BcrKRL+P9ResAUh9ObxqATzJ3qUipoAxvBO8269LSPeZ3kPpJcpOuOu8ty3E8Yaa1L0ST1k1lhdJcug9vPznNuYFtvRwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=opW2ZeLZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jAOaLxhf; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="opW2ZeLZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jAOaLxhf"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65ICuXer1638917
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 12:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PMYW4I9dC9wuzE1yOpLwjXPmFQ01enmrDtWrZvFEzpU=; b=opW2ZeLZpjprwV8g
	8F6I8NDeMHvWwODi4f5Rwck5vmlqhPcEzKgamVFo0mmVZHdREVUd+jSf+ii2L+il
	64zFJOOGpKEtnyGCadV3m1HFZjHzUd4R84lkPtdGyO2pZVhEaCtie9lcF4FRx5a8
	+AzP2KNPIm1ATPoOz7LGHV7Fx13m35Fa7rfL+vzhmovAkg0hjBXEX+NcjinmmPLT
	J/+l7pjwHpuAuAyavW5MfNArfBHGXUjRNLPQHgo0eb9uC6ACT/laUbmWe7QzB/TW
	ghXtj3zHKsdmN7J/X3ZX3003CJhU0fVc66iLgg1Wzw8F1RTX7dy7ccFzl9Gr2NS9
	8FspRA==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ev1rtu9n6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 12:59:06 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-91571f0d3e3so12537185a.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 05:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781787546; x=1782392346; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PMYW4I9dC9wuzE1yOpLwjXPmFQ01enmrDtWrZvFEzpU=;
        b=jAOaLxhf5xHaILHMYrndKw3LDZcmjDTc/yiz8Gyc/wm+Wdeq5votWFaP0CFPgBxXSE
         rIh2AceTzI3w/14NVQ420FNaQjqqsEGZClyWmCw3ThrZY5FGIp4HVKEACYBpwguMf7FT
         TBvt4IiZOoIqlEbUGr894AQaxWvHy6iWyLVg6czWB1MZjq55NWRtnbTZXlX0Ay8ivVBi
         DOuhlJm4ftGVNdHCfNPtPHnAmFP8UC51Mf7eOcsIzbsa7x3VR0lQlFxmUP3/RppLu4Zw
         mCHl3DTnM4tGQpE4qhejWe8kSFkhV6UMF206/kA/M6d9hSQpOuaVNh7M24zc+S5k3WcE
         HwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781787546; x=1782392346;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PMYW4I9dC9wuzE1yOpLwjXPmFQ01enmrDtWrZvFEzpU=;
        b=D6RfCMUv0Glia3LcweZiRAcSnAnQvOGz/JHuM5yzFTyP4HiyEuf/v7l8pduaplch+u
         rWxOyEBIFofFMnU7kJRShSQHlirDjMcG5NxBVlJPEUpmpHkr2c/XfhysuhU2B6GMrDrF
         qoQ6NitpAkQqRWBpakT4quOcJ7yWHra4VFqH63owcZC0Bns1O4e7Zu2VtTrgUycpr24K
         9Mvm4QAP95eoGggzC2OnYnc0tOipOWBvcnl1ukrcNRfn3IMutN5VWdyFpi/gnAjFlEI4
         a7f54dralbZ9drByjO8qln6OOwsMAE/qQ/R9yeDIW7n8zEoMOQXwxqoxWqrHEhOku3pV
         sgtw==
X-Forwarded-Encrypted: i=1; AFNElJ+I3Cr74+qVl8LnAaime0r2DCKpchugTC6R9Cq+64bC+A82/9qN7P8QVUMbFiO7fE4V8oV3K+Lebhl7@vger.kernel.org
X-Gm-Message-State: AOJu0YzEfrMhXP0MQhWkTNo7V6/Byktl3D7DpRgWI+AW2hkPZ6eb8AKs
	FbJl8N9s4Fltvc1j6MQ8XUmJQqJHR4A4xWSK2FkDtPtqk2z4OjJ0H/sbgoezV5/uBshzFl46QwJ
	yOZi/uIRlaPlxTZ0ncx59bqCIYO+FZQ872rC0gis7WiHssb/z2bITx78aBxJViKAQ
X-Gm-Gg: AfdE7ckh1NR6Zvyu2rcCO6BYKo20ukgKFBfjpRhEqI2+dqJ6iqncPnfhb44cQV79PSS
	fYYR2iykbzRlJE8bT4q3w4Eg7888U0yIHMV9a4bIM4oud3KLzMG/NZMFKyoLGwga5/K8A56osHa
	z9bkGHo0n3WGpeba+no4ewcgSkV6iMSq7qRfApcJ4Xiw6ujmppMojUB1IUaVY+uwQ7j5SzEj/6y
	S+ZQgJVswI5HM4cdFD3p8afUfBRIVAPC2GE1zjcvmvdbzoRWK2/QdMqpDojTULbqwqMpNuPFc1+
	dG+93RM0g/CqxrNH51lurIzfhzEX2WAowL21tYmmcVV7AdW6z2b07MrmZloOK700ye9YJLbq1MU
	Aoi33R/GgRZ76pl29huNAccZHweGeBwNZur0=
X-Received: by 2002:a05:620a:d8b:b0:90f:7ce2:3019 with SMTP id af79cd13be357-91dbd008667mr777218185a.7.1781787546043;
        Thu, 18 Jun 2026 05:59:06 -0700 (PDT)
X-Received: by 2002:a05:620a:d8b:b0:90f:7ce2:3019 with SMTP id af79cd13be357-91dbd008667mr777214485a.7.1781787545637;
        Thu, 18 Jun 2026 05:59:05 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c01d667f63asm676768266b.19.2026.06.18.05.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 05:59:04 -0700 (PDT)
Message-ID: <06999033-1c2f-4203-bdcc-d8e94ed281b7@oss.qualcomm.com>
Date: Thu, 18 Jun 2026 14:59:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 3/6] mmc: sdhci-msm: Set ICE clk to TURBO at sdhci ICE
 init
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
 <20260609-enable-ice-clock-scaling-v11-3-1cebc8b3275b@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-3-1cebc8b3275b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=MNpQXsZl c=1 sm=1 tr=0 ts=6a33eb9a cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=QyXUC8HyAAAA:8 a=kiQjUq8FSzjVjtPiR3oA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEyMSBTYWx0ZWRfX01xiPnxQEdZP
 FipBmeOlVmZ6ASWmIxApX8XgdQ9KGPLBbl+0azPBzU9xKbUJo79coRyyJLKzQ2O5RhXXoVFSKA9
 xEifzXp26qR4ux3fSEZ0h3kQ5bbJeGAZU1hpDk7vC8df1daBjMWUT0HseTwoLooltPEUhymnmv4
 X8/fHMGRgT4rygFkEPUtNaj4tird/I6/7pOJmwPESUSfvwhHe5bXdUXnTdGRHJTQeD2X7GwOcM1
 0g3nmmWG6g61Olyz+NzdNG5g8asLgwV3Gp0ybWJdxQpPQwhNo6CKoSgyHP4NJ3l/X4h0+IwGDBA
 zy6f1UfnfsgWh76OdsksXemQ0PWigcVn7i7i5w0YJx4ygnDmtOiadvhKCbhEZNyoaHl0Rdf5VVe
 g/8rzW+ThV40OEjePukIcfh60o9yAYc5t6s0HLc0kOR7Ztm+e96xmNiKT3s/s8NVVuax0PjTGUj
 8KJ3WEd47v0rIpMeMxA==
X-Proofpoint-ORIG-GUID: 2kI8q9_qRUKXm4eIjq6H9FwwFVrN0nuf
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEyMSBTYWx0ZWRfX8+s5HUamJmY3
 J44d/nUwU1I5hDrW9MWGXiO6l3LYO7p/9b+kYaDJAoehf2jjR/waIJg7LNIKI2Gts/IVAP7vXbh
 eIm+gMCo41Ac8uVzU4pUpKLZEFgBpEA=
X-Proofpoint-GUID: 2kI8q9_qRUKXm4eIjq6H9FwwFVrN0nuf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606180121

On 6/8/26 11:47 PM, Abhinaba Rakshit wrote:
> MMC controller lacks a clock scaling mechanism, unlike the UFS
> controller. By default, the MMC controller is set to TURBO mode
> during probe, but the ICE clock remains at XO frequency,
> leading to read/write performance degradation on eMMC.
> 
> To address this, set the ICE clock to TURBO during sdhci_msm_ice_init
> to align it with the controller clock. This ensures consistent
> performance and avoids mismatches between the controller
> and ICE clock frequencies.
> 
> For platforms where ICE is represented as a separate device,
> use the OPP framework to vote for TURBO mode, maintaining
> proper voltage and power domain constraints.
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  drivers/mmc/host/sdhci-msm.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index 0882ce74e0c9bdddd98341a67b97bcef74078e0c..b655bcb5b90c0677bbe3dc6140de488038fe5ee8 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -1901,6 +1901,8 @@ static void sdhci_msm_set_clock(struct sdhci_host *host, unsigned int clock)
>  #ifdef CONFIG_MMC_CRYPTO
>  
>  static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops; /* forward decl */
> +static int sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host, unsigned long target_freq,
> +				   bool round_ceil); /* forward decl */

Can the definition simply be moved upwards?

Konrad
