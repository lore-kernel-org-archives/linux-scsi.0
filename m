Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED723F6C21
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781787724; cv=none; b=r3ryRC4YyViX2fRxtN6jXhW9v+jfbFOMC/bK7OJqZdB0IBzSHQP/5iAwDA9fHwXdV5o7Ayq6Y+U1D1kTHiMwVsaQGxpINVJysvXl2K4kAJubgoe+c24BWxonX8RRG9AZ1inZIYBwH/AFCap/L1Q0zfBdulHMJN8jS+PPSEkWqwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781787724; c=relaxed/simple;
	bh=OiBvJGA3rcBVkwv/W5Exjcj+7CrWvutuFaR7iOPWQ6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YBUVJCLz77PhZZ089fdb0JhzrKIXK7tU4FuZun3YaR5LmJ4CpxCBiWl7qc8WadOmXrHbLXG/x00bAbnAvDBm3BlbxOatvXdFqsjw1NvOxAOMrQWuKdcGGy3hRAyF6MTOUfxN8Y8xF9xKSc16vMikdwTOvfEROwamQqkFMivoNPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NHVLGIPg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iVz2LprO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NHVLGIPg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iVz2LprO"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65ICvHKj1879340
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	drBtdZI1GgQ6oz1Wq7kAcWt1WrFzuxR5m4b03USirw4=; b=NHVLGIPgdZ+BBsyb
	fGjwFfMjLWbk4ynHrjgQJju4rivyvZp2sPxy50Y7WPlE9XIKqnAGhfgtnO8nY062
	++GAlMsL1C1fcy/FR3HdyYSYeR5Vmr8XIdnts4/h7j/GHJG1nr7dRQmTe/jYliC7
	cUJcTvh+XBy4xosXU+35p1rqdLIDJVx1mpBkgrd7mtwPf2RYK2sL9dsXbjyv+R4X
	Icy3Je4RAjq7BaTbdJvy34+5GyeORQY6O61cOZdHpVlDUZqysQ8qbZNtv9koFZz2
	OGSl043JFByRmP1BO+Jo+i52+a+YlVLH2fIO/De46CJ7EQcUOVupin4Ma7x8pkcW
	RrXjWg==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ev0g7kp4w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 13:02:02 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e7062a8951so240590a34.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 06:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781787722; x=1782392522; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=drBtdZI1GgQ6oz1Wq7kAcWt1WrFzuxR5m4b03USirw4=;
        b=iVz2LprOEI+6RmbJQUuC7ng+gjU3AZqst5kxkc7Ki4QLdLdy8TzAD/r/c7Pzk/5I4r
         UO+h5oRDrygvACFfaJpzlBW69bDkJjEjoEjQZQQnOy848HfZJ8Z0HeyVAhV7nwGhQyXs
         Lu5AuBztfb6sqIU+MUCpqGw6h+QMgCxISyaE7Dru89BSLpaH6FvAHsPdGs15p42vrwRi
         k/eVbXxoBWsuKzeqX/oZuGhDzhsV3g7WrU83CGKl1vXUsa+HOGCxq4qP9+6OrGVgVX+I
         2O+H3qz1S4VWPa8i0l6Kid7f9mmRqyZmzoOIluqgl4i66dt+ZeIuCWiWbbRrIri8AvBK
         BvMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781787722; x=1782392522;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=drBtdZI1GgQ6oz1Wq7kAcWt1WrFzuxR5m4b03USirw4=;
        b=GbbKGLhfMusRJ8+n7605p00zPP2Inw884cFU+mzcw68xauUH5IPN9mgXoX6YP7Hifj
         qblSoxDvB9tPkVus9qrOu2+ZjcslJSI0zJQ2cngtcxXTVMBDaEcuvVx4Lp+eqS4/2Yeg
         7WgUsQ+4qC0RRllanzxnseb5hP1nx0q7DIXmPliOwQgHZ607sD6AecKuySiFfW2zBnAz
         f334VaXxiZ/0CPzTl9brLXmkqgb0fHe1HDsi/AOesHYLFIkdHtkN6HujB4Mk1VU1iRje
         exIAlv6vKtopyOf0GiyPfSnRNVc9dQfgpDDWFzvhnWC2+n+Zfy1Hh4eN1ZLhd2sGsh3D
         O+yQ==
X-Forwarded-Encrypted: i=1; AFNElJ8qxCFkh52QenKTC6abr3ikxjYsePZzFV0lFzY1HXhINFrCwDSNCQdFoF4wxvEPqtKRa1fxxiLiG7+D@vger.kernel.org
X-Gm-Message-State: AOJu0YwjUm6VX01YGP6+O33XZKqkdrzLRnQKAo0owZlmJ9bBNvLsb9I+
	BaglUicdVNRtOJFjCNldxtb7izhVns8mkPq9/vwtmkTpt0Dv43YlIpycZRbc5Yhr99Kt66U5IBB
	pkEohFg1sv08g0MYoBkbSJm46j2ga6p6pr3FyfOA8FNQS2FFAXad/cMIWFfJZqlZ9
X-Gm-Gg: Acq92OHm1q5+ls5KV51stA7XTZnbdqTm//utnCHjMjQ32xtpvwCa+OtaByxs+DIQUI2
	L9z+WS/rw0JjBshcX7XMRAgktqaDqiVHGoVuB0MRNtZCWgFWzD3qtmEqnVdPeAdalKk71loVhFj
	OebtGfhKBT4gYR1GH2M3fhuWDfBtqygiivmQEdnklnJ8BMWxQtvx6xgjkiET0FJ8yXntay/4xw0
	aN5mWA7i3NQdQqVHCwpHmK45LtxPSmFLCvXNPbghp2C8nSnepCJcBGjuTE9ieyON00xh/tDbTSN
	wVYayLGJRVUg3roJVmo4JjsL8Z1NIrmW7YAN1MlZLNyPn/ze8gYHlyxWQVr8Y29tjmdrbNyie5p
	TihXQFlu8PJx2YqLAzEPa20dpONS1rs7FVv8=
X-Received: by 2002:a05:6830:8383:b0:7d7:ea6e:322b with SMTP id 46e09a7af769-7e91be85760mr1719046a34.0.1781787721263;
        Thu, 18 Jun 2026 06:02:01 -0700 (PDT)
X-Received: by 2002:a05:6830:8383:b0:7d7:ea6e:322b with SMTP id 46e09a7af769-7e91be85760mr1718455a34.0.1781787717537;
        Thu, 18 Jun 2026 06:01:57 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb4420570sm954142466b.11.2026.06.18.06.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 06:01:56 -0700 (PDT)
Message-ID: <d1232243-2f23-423b-84ac-4463eac79f9a@oss.qualcomm.com>
Date: Thu, 18 Jun 2026 15:01:54 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
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
 <20260609-enable-ice-clock-scaling-v11-1-1cebc8b3275b@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-1-1cebc8b3275b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEyMSBTYWx0ZWRfX4dzq3JWQs7rK
 OzRXz9eSkjVqM4wtKXUNCAkf0XmwD+7BxmeS+UYmioY6vuhuE/2kif1l2karDx7tyMFrk1g4MQH
 c1sWpVV6bog7sSGS3L2tmL5o2117uUi9DAEd+xghZ4s5W+vb07qnlVncU//M1U4n+ofx0EUM9Qo
 FC4CZ5L1llTLoyoLUhRO2DB2pAOQRWGK40QS13Eh7Jxz2Nfn7VqMEvyknU6/Nv7LMJxWmJmEsof
 4ZVzlp7+wkBLEIlapx6dRD8nYOTXJOMN8C6PnZAAYSRCoehLC2Q7ZvdC2xkSIN6dgyg1Z5X1VpN
 HJwB9Za25UGgO2vwHz4uJOqjcaiFhtfuG53HIRS4iOdvtWW5kSfJy53gIE5IjOkvnW1yCjvPYRg
 eY7BIXKoxguJJmtzZwt78qEittZwo/WBGzrG/PIiEVrjtIlL0FzIeVW+LwKfiN6WhfE4fUtzqTC
 jraTP8OKeDKAJEFRbsQ==
X-Proofpoint-GUID: iK9JrRIjs5vEnbEVaJw99RSN_0vDT5dS
X-Proofpoint-ORIG-GUID: iK9JrRIjs5vEnbEVaJw99RSN_0vDT5dS
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEyMSBTYWx0ZWRfX7OH4U2jLfCUM
 eS2ynpVBfx/bd1777bTt5rMijjBwSJYtuFLFf7bV0kgisHAJzzVAYYboMg1ba+ujSQ/SP8Cmk+f
 GFBa9llWVi6smM1E1P/MyjDAzORt3IA=
X-Authority-Analysis: v=2.4 cv=YrI/gYYX c=1 sm=1 tr=0 ts=6a33ec4a cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=nM57NVUx0yqqE4FGInsA:9 a=QEXdDO2ut3YA:10
 a=Z1Yy7GAxqfX1iEi80vsk:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_01,2026-06-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606180121

On 6/8/26 11:47 PM, Abhinaba Rakshit wrote:
> Register optional operation-points-v2 table for ICE device
> during device probe. Attach the OPP-table with only the ICE
> core clock. Since, dtbinding is on a transition phase to include
> iface clock and clock-names, attaching the opp-table to core clock
> remains optional such that it does not cause probe failures.
> 
> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> core clock based on the target frequency provided and if a valid
> OPP-table is registered. Use round_ceil passed to decide on the
> rounding of the clock freq against OPP-table. Clock scaling is
> disabled when a valid OPP-table is not registered.
> 
> This ensures when an ICE-device specific OPP table is available,
> use the PM OPP framework to manage frequency scaling and maintain
> proper power-domain constraints.
> 
> Also, ensure to drop the votes in suspend to prevent power/thermal
> retention. Subsequently restore the frequency in resume from
> core_clk_freq which stores the last ICE core clock operating frequency.
> 
> Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

[...]

> @@ -335,6 +342,11 @@ int qcom_ice_suspend(struct qcom_ice *ice)
>  {
>  	clk_disable_unprepare(ice->iface_clk);
>  	clk_disable_unprepare(ice->core_clk);
> +
> +	/* Drop the clock votes while suspend */
> +	if (ice->has_opp)
> +		dev_pm_opp_set_rate(ice->dev, 0);

The PM core will quiesce the vote as the device suspends, this is
unnecessary. Similarly, the rate restore logic will become unnecessary.
Especially since dev_pm_opp_set_rate(0) does not actually do any rate
setting.

Konrad
