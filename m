Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9930039C623
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 13:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776432592; cv=none; b=hTZzRYsAQRi/zkz+/eG4pxSAfW2E+6RoONdduV9nXAyfgd5skJ66/4k4n9XNIw6stIF9/xvlwBjRrBekoaJE40gTzYvCJvMLrbOzztlJv2ew2AgHJ6og/ROS8Z29kn4zSprAU5WVOdhUtiibGNBBU6bQfcfuOjd9s+yY2yN/iao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776432592; c=relaxed/simple;
	bh=SDOJrrI3lTBAebziczGzMC8S5O6qT7RZbqRtoZr1W6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L2Bg5LmP0rCCZoq99Z1cBnIGmnDVvimfFCoYY6sJ6dGriOeGM846hsQzbJdhsdz2ac5jUtHYPkJ5+gIGMYXOpxb0PcANuv66Tw/FfmOCN3dJfne9BP6GKa2+gKNSTVQxGzlkYfbMkhpKw+mPJf7iacRoGhoMwsJlVT4MXc04Uhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=iidswQYE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DQYtnBoF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="iidswQYE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DQYtnBoF"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63HABcjl1323334
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 13:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1HeSxgq6qe6Gt1Ak2J5KtEc+UgWpolaht6umu9cGq9I=; b=iidswQYEQzjN85nH
	G2ti/igpUnv19vyXSn0ZYOPAvXEd4sksWg+Y/P5kXJS470Nbi/PdEdfLCFZzIoZS
	JzZM/r2NjRsgDGjo738SNRl1toTXwvK1bAekOC24GvQGfg0ehdWEPcc/hEoupjqB
	fnJroOKZwMclndwTw0vh1DJp+p9Xs6xm7Ym6e6VVfpRxxmqy/U2MmpgV/ZHFHJSA
	Vp67f19HWYjJPdBZzytZGBzCNPAkvBkzDDUSLJeA35TJDjp2te9f9sGBtDi21nge
	uccaAl5FJEs6uw38iiwE2uJpltwjBLCbRoihjOlmjONR+9awUgvdPH2bQzy2Imoh
	eJDcBA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dkdgy1wht-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 13:29:50 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82f74f0e3c6so530013b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 06:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776432590; x=1777037390; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1HeSxgq6qe6Gt1Ak2J5KtEc+UgWpolaht6umu9cGq9I=;
        b=DQYtnBoFUhEVJMbx4PRgvMyaCDUoO8it4C8EbMrdNzxJnsNacomRmRKC9F+wM2EQof
         txQ5jz5hjWMQnS+Cm9X5zYvon+ZxBOiZfQ9AYXJimVQ6enscV47sbIBbPy7GTi0q5vvx
         yA75LjprB82xnQhNNXEYjEklxDMbOaSU0v0B8SdNG0T7KsPOgI2IrPyUkZ+89gnXLwt3
         tKn3yaV76Thfcf4v302Zfr2QtuxgOYYyJp1SYZjY/sf9A4psx7G4UW0+gEs2034Wr51i
         Q6i5Vk8PIYhXRTze1m8Q/xlfKucIgRkndrGRyAg0fvrA6GHOaKtqGLDikojVJKPZQLw1
         I6Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776432590; x=1777037390;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1HeSxgq6qe6Gt1Ak2J5KtEc+UgWpolaht6umu9cGq9I=;
        b=HhHUAPSGy8SIcUk4Tw+N7k1/xmDTNQoUd/gZbXGceCbS+5vkiCi4oxxUr6HOWDn1iK
         76nN6/pb5b4vMy9n+WSIWUPnMVIRKhbu59V0Ew/YTBquEqqNxSgrJBoez9iS45ZQEYBN
         P2bv+qEDt4VZ0EhlLNy1xkfwDYMfK0QrxaS0dClVOIeyExiSmvRFiurLnXqKs70kN7vz
         rUh9M+/LeWPV+sdqairVSXlkh/pm0O/H9PQoQByVc/gRAaUYOxz5vxBZi4hjpukALElV
         0UBwLMvD8eUVwQsqiHHJPYvxJqYuinrYoSH8k+qUaWkW/Ft8zdUahdrplKBAp6wmQbFm
         FaxQ==
X-Forwarded-Encrypted: i=1; AFNElJ9YFSek710wqMWwVHfjhNIhBRImhY6CE534vder8Ptw9mHx6RClt9LuVqraj8LPp/5Q0zXkEnG3ldWc@vger.kernel.org
X-Gm-Message-State: AOJu0YwIDU6oJtP8VxFG33M2DsOU6K2U5Co84ARjAhuTJ2SIXdDaQ8YI
	zcT1XBReHpCzBdxB0JT3fCEdDJSxnfFqXOvJM1h3Gb/YS40HGxL6aL4Dh8mpBcMsT+8KOhrsd5p
	3JZUFSWovphKpCbSI4SsVOMESAsUkJM2q5LWgpfwfPh19v8vWFfPNYQ3WH34OpRBN
X-Gm-Gg: AeBDietYRW3orD3c/kU77f7qNA87adIxfLzuehaUamNjOCLEwZcs12MgJzBrOwWU2g0
	ht4SuFD8LoA5xqPKIpq2H0QmKiSuwSJnBNOh8xXJSgxVd+xRfqFBEEMilPafGXCgS4BVn3ETrRH
	qIMKbc9m8sgdiXkZz2iWSzOntjTZkuOR/leNnG2Hq+sH4ZKulphfc2GDvFOKFbV7zjXQ3HDJas5
	zXpL1dpKyLjgnZj53Jsh4sKR9tUgtQ6tUTWnU5Zjz0DYVUPSWmX8Np3A8l2b4xN9it2zBuVmsgF
	wTcJX0tm1kRvuOw29WN4i20YZz9ye+C8ewXRnRWAUT0kOHn2Scl6eVfnrxU+5KqcZJ0cY+i5NuK
	V8wU+B1lbjWbX9eZVpBy/deC5jJ38K3UfwdN8cseK/JI2emvJDOoAuLfJGQdPFg==
X-Received: by 2002:a05:6a00:a241:b0:822:6830:5900 with SMTP id d2e1a72fcca58-82f8c7eee25mr2726444b3a.6.1776432589978;
        Fri, 17 Apr 2026 06:29:49 -0700 (PDT)
X-Received: by 2002:a05:6a00:a241:b0:822:6830:5900 with SMTP id d2e1a72fcca58-82f8c7eee25mr2726388b3a.6.1776432589265;
        Fri, 17 Apr 2026 06:29:49 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ea0a97esm2695706b3a.27.2026.04.17.06.29.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2026 06:29:48 -0700 (PDT)
Message-ID: <a432b2c2-475e-4833-9225-801990cb2d34@oss.qualcomm.com>
Date: Fri, 17 Apr 2026 18:59:42 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/5] mmc: sdhci-msm: Set ICE clk to TURBO at sdhci ICE
 init
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
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Rob Herring
 <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
 <20260409-enable-ice-clock-scaling-v8-3-ca1129798606@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260409-enable-ice-clock-scaling-v8-3-ca1129798606@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: ePXGlc6fZSkPp3UmYzaVcB5FYpQWh7b0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDEzNSBTYWx0ZWRfX5b/FUZVDPHPN
 SuhjHttVzLTKHsw/Sjgod83jFz8MVe5ItBsPshp0tFFSYEoF5Rtf2lIrhSaI7Mx52Vol9xm4V3S
 65liXkVglyhJa2qPsV6esRs9BTTzazMpqhMBCQkvuzDWulD+lZnkf03nNnUBl2urWtA1YjontfL
 RldWNRU9x+c6CeTtGA+rkn8Akk6/VlHNX947msrqaxMArMD8dMideSaVypgqPX2wfavIieXLIH4
 6O1aIlEtxp4w6R2JwKWn1XKIVkMTK2TafBVosP497TSC8u+mpAqepFdbsl+DnSJ+/8VJ6OQZ3Pa
 KPA8BLkKc6flX9ANKuK4osVFIqi0RiEJLJ/ZgeOsKMUKISEoufnvNw/HeGpLSflSiZT42o8BHoR
 R10q4XVgNCXdF4fOYpFH058TDL9A7i3ygWWoVhGy1awXN7c9YioPHA3sK+MmuK3J2FBhOCqYnAh
 58UO5kKUl5VR9gql/Tw==
X-Authority-Analysis: v=2.4 cv=GN041ONK c=1 sm=1 tr=0 ts=69e235ce cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=i-sMpDq2_rzAXM5hadQA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: ePXGlc6fZSkPp3UmYzaVcB5FYpQWh7b0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604170135



On 4/9/2026 5:14 PM, Abhinaba Rakshit wrote:
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
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  drivers/mmc/host/sdhci-msm.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 

[...]

>  
>  static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops; /* forward decl */
> +static int sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host, unsigned long target_freq,
> +				   bool round_ceil); /* forward decl */
>  
>  static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
>  			      struct cqhci_host *cq_host)
> @@ -1964,6 +1966,11 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
>  	}
>  
>  	mmc->caps2 |= MMC_CAP2_CRYPTO;
> +
> +	err = sdhci_msm_ice_scale_clk(msm_host, INT_MAX, false);

The 2nd parameter is an unsigned long, do you really want to pass INT_MAX here? I would go with
UINT_MAX. But still, why go with such a high value? Do we not have an upper bound for the clk
frequency that we know we can't ever exceed for any target across OPP tables? If not, then maybe
UINT_MAX is best we can do here.

Regards,
Harshal

> +	if (err && err != -EOPNOTSUPP)
> +		dev_warn(dev, "Unable to boost ICE clock to TURBO\n");
> +
>  	return 0;
>  }
>  
> @@ -1989,6 +1996,16 @@ static int sdhci_msm_ice_suspend(struct sdhci_msm_host *msm_host)
>  	return 0;
>  }
>  
> +static int sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host,
> +				   unsigned long target_freq,
> +				   bool round_ceil)
> +{
> +	if (msm_host->mmc->caps2 & MMC_CAP2_CRYPTO)
> +		return qcom_ice_scale_clk(msm_host->ice, target_freq, round_ceil);
> +
> +	return 0;
> +}
> +
