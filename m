Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEAA3451C6
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 09:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781601614; cv=none; b=PuMmgnBEbvUq4lfZrs/uUv/cW1KFkZlkBO0EQJfbVWMA+ZgUjE6iwMklPY9BdOliKP5hUficcFQ+yXkBaE96PnJYYi2Orz12BeWTDalhLTfaULmIfXyR2+04U0x4B8TyLU2Mah4HYUEObSIEeyLxxVBZKITE5WWcZXMlKH2UYro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781601614; c=relaxed/simple;
	bh=NAw2aTt156UXj/vzyCFj05vsi0gzzhKJtngHULTfHSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FeNnXSkL583VnjmBrTZ86Ll+MuvWBwQF8BZ/s6+8ItRelRfKjaMvkjBxqmzaqAMNvRqckKyfpE2nkgI3fjxNUlFHwc8pWZwuNxakGSgjbVeHPvU4Ch63OKU9XjgariZ2klqevpR+uWbhT4lyI+XBXe8LErQiFdtq5NtiZUvK/7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dVxIgl5R; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cPKWJSix; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dVxIgl5R";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cPKWJSix"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65G7I3GY2832700
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 09:20:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WKcJ5+YHj6LRiGZdkp7N7ktIBdN1t3qTPXNjJWfufDE=; b=dVxIgl5Ri3BAKhYX
	MHHYslKmY7BlwwAvoAe4rXyGnIoQYXROqE7wrq8eLDvV8U4JUpc/6r9zC1ROD+YQ
	xQ1VCk0MTA9WHQT9Rwo4sJK+ZE3ci3e6GNH/R74Lm9y6yTWQKfIWaXN4dGo1L+ye
	nPJMBHvPwUA3NLd6a5zy4yLCGDk2n8zkhChhvjlUjvap4URIG2W48SUCxkHatyZa
	z+4bBSeLhAI4wzKcCxl7W5+6xjG7A9vcw4bPPVdOi/z05FQBfsR/BEPxy2tsyARe
	4uRFv2t5jxzG8FuFLOmBAgX3bwFPaC8fEl/1cw5nNuW0htZ7BQ0CWOCKAUAoxl7l
	RKhBsw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eu1ysrfrb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 09:20:12 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2bd04e4fe3dso111335855ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 02:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781601611; x=1782206411; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WKcJ5+YHj6LRiGZdkp7N7ktIBdN1t3qTPXNjJWfufDE=;
        b=cPKWJSixF2XSd/P0EBPZQese000iUgHsCSjyPpFYfEzVs1fIt7Z/6u94rz/Zoyieex
         DNSfVaZ1GlJ85R96g76Oz8h6hvHaMRIldKCQpmdkUILCFNesHPe/OxkVGzf7TNvS5LEH
         xQFtzqfWq2VZo20qzQJU7TNfaNnUAD9yxHZBEJqkgp1cSFaKDxOFU1fJoOBv0NvuE1qB
         W81AfXq5aqEzi6G8Qcki5ux/JBcww65TgMxCBkAOdBdAWvjPXmcgHtdmAFVLfeTyUgaU
         EZl1Tk7qKA/jMTMFbXeFfIGPWA53Dc4wTVKnu0+9mMoSj2LzcNLsWJ9aCSsKvsbBRkvq
         mTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781601611; x=1782206411;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WKcJ5+YHj6LRiGZdkp7N7ktIBdN1t3qTPXNjJWfufDE=;
        b=jTqlGQ6eXLEmV2kjmvsedBml9kOilDwVi6RXkpBAb4gwY8CEQ8qie5JqV+GHRbT+Q+
         r6v/qVBOZ4g0RMQKEsu8eUw+j5doQtvxbExVyWl7ZldbWsj7x+0yhGdhS5ANm+FkSwPT
         U0BbSFzVEYqvac8AadckrpeDkxJBYN0kgq0zsmWxxooiocaxPq01vAsJBZf8qbXqpJmg
         xHi+WujKYhPPirWZl3DRpxMnHCOOp+Uv6aW8/ksvA49nMwjx3NlthAb9A5nF5mJfAH5T
         8r/2HOhkVsAJHeFd/eivyFzyTs7zpY+pv85kuKLvWu2LiMEx5ZTtEPauQjqDhmAEb07R
         aRAQ==
X-Gm-Message-State: AOJu0YwAoSxoOHxu1O54Tf+JRWtP1ljd1NfxL6Bp3uBz7PmMlR+6gaCw
	vUNyvXv8n/b/9/h5vD51MItf1+zNCur4cZ7OcL4ev/wRpIkOs4ERd7c9mGNjDQhgl/jhphFGMxQ
	HIkd6J4Uom6h4KF9vhIhQocZY2D3j+7G04MaLkp1mIEF33QnS+U9UnsUqY15YaYI0efu63qhfzd
	I=
X-Gm-Gg: Acq92OHz7IWZeallpA9H7iYiWRioJHA9DLjm047p7DPdhyHce2lKwsFckoIDItWAAmj
	taR810Gr+zT0yvmwo6CMsM7pjdZ1ja0sbAytcj8+hkH2qkD2bXWQdugW1Mr29dgu32X3GvT79bH
	wF/V9I5kQ58E5g3OYa4LeWAmbiLihGoS7jE1gbjzAj19Ih039RUJYJfH7vgcG1+r1y8gfB8cOIT
	g85jo/t6nRmyziCJJQMe+Epee3lBF4wROb2S25IkQxaKIHtDZKBxYG1YsXlAaHACqQ7mRHcEpw/
	BNOhb4A4UD9zhGy+QvVaOuaoI8eincxVoGUY18aTqQuwD+vF/po87rtpbyNpRzfWTKWy9kfk63D
	bZylsWkzgBhhWy/JUWTVZ6FWRVbAbRoCWicGLD39FwEKNqlAJhVuBSRiexgxUSxC0TVGbq4C+rU
	YhiU1SuLbWkQ==
X-Received: by 2002:a17:902:e550:b0:2bf:2e93:c624 with SMTP id d9443c01a7336-2c69a1adf44mr30074035ad.27.1781601611287;
        Tue, 16 Jun 2026 02:20:11 -0700 (PDT)
X-Received: by 2002:a17:902:e550:b0:2bf:2e93:c624 with SMTP id d9443c01a7336-2c69a1adf44mr30073615ad.27.1781601610852;
        Tue, 16 Jun 2026 02:20:10 -0700 (PDT)
Received: from [10.133.33.52] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c432c8c1f9sm130921925ad.59.2026.06.16.02.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 02:20:10 -0700 (PDT)
Message-ID: <15f7d54e-7cdc-4d88-a1b6-65c4ab99e76c@oss.qualcomm.com>
Date: Tue, 16 Jun 2026 17:20:07 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
 <20260615134515.8D19A1F000E9@smtp.kernel.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <20260615134515.8D19A1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Dpc5Av5MImrB_SuWR4NYWtbX3J3KP17n
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDA5MiBTYWx0ZWRfX6wgbFUjoIvWK
 TL3gxQGWc/gZ2Fybhztx1c6lx9XTtu68QfO7q/qXT/Dp3nwnXqMBx99bFAj2dGfG4P3D6Ectn+b
 dCKMUBS/SzvqNrMTS2f5mO4RtyBf2VI=
X-Proofpoint-ORIG-GUID: Dpc5Av5MImrB_SuWR4NYWtbX3J3KP17n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDA5MiBTYWx0ZWRfX6JIEtWJhjYOL
 ZZ9pztRR+Zu55IAEUlaVsmU3APcLNGn06ERS4voMdfP4GTm16wXpMp96xQkp4o/hphKGANXuFHy
 t4i943PnEfoPMUnedRSoQsUrWBNfE0O9KkJ0+pb/gfXfGfSKkFBaPIGejcaBO+7A5+u3ACPx+sQ
 Ky7kQOd19aOnJH+JWn0wjLMJJgpP39jPlCe/okTKXfx0PyvL4yhAxu6zrgd7GmaRVaQtvEGC1dp
 PnhBuGGLv5GDrDCmr1X8y0gEkFBoyjkiu45FY2H0Gl7fdd4FuPeMlWVE3C7M/12LNrHlQn2YSjw
 iCxlDN1BxsCfJ8Ux2Xsl68ll1kH/3TIWmZ5OXSeSQKIDiJV0eQAMkaVhteOCoeVQzhBPnaYqK5z
 NgcF1q4OywSlSWuU9QOya8eWOO/KEHXUZBPdfgdCuVyUoRI+MLEmKflVXMR3WMOs+UV7ExNvl0T
 AA/lJuG3VzeoYUweDuw==
X-Authority-Analysis: v=2.4 cv=JJcLdcKb c=1 sm=1 tr=0 ts=6a31154c cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=aJQhKzKjLi4jenc1hegA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_02,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606160092



On 6/15/2026 9:45 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>
> Pre-existing issues:
> - [High] Calling `devm_kzalloc` with `GFP_KERNEL` while the UFS block device queue is quiesced can cause a direct reclaim deadlock.
> --
>
> commit ad55228fec48bc54dfc7ac781e567e213cf4a86e
> Author: Can Guo <can.guo@oss.qualcomm.com>
>
> scsi: ufs: core: Add support for static TX Equalization settings
>
> This patch parses board-specific static TX Equalization settings from
> Device Tree for each HS gear. It introduces a from_dt flag to track
> whether the settings came from the Device Tree and forces the TX EQTR
> procedure to run when those static settings need to be overridden.
>
>> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
>> index aa64f2bf4f1ef..f06dc3c3492d1 100644
>> --- a/drivers/ufs/core/ufs-txeq.c
>> +++ b/drivers/ufs/core/ufs-txeq.c
>> @@ -1301,7 +1301,13 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>>   	}
>>   
>>   	params = &hba->tx_eq_params[gear - 1];
>> -	if (!params->is_valid || force_tx_eqtr) {
>> +	/*
>> +	 * TX EQTR must run for the following cases:
>> +	 * 1. TX EQ settings are invalid.
>> +	 * 2. TX EQ settings are from Device Tree.
>> +	 * 3. TX EQTR procedure is forced.
>> +	 */
>> +	if (!params->is_valid || params->from_dt || force_tx_eqtr) {
>>   		int ret;
>>   
>>   		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
> [Severity: High]
> This is a pre-existing issue, but this patch further exposes it since the
> new from_dt flag condition can trigger ufshcd_tx_eqtr() during devfreq
> gear changes.
>
> Can calling devm_kzalloc() with GFP_KERNEL in ufshcd_tx_eqtr() cause a
> direct reclaim deadlock?
>
> During devfreq gear scaling, the UFS block device queue is first quiesced:
>
> ufshcd_clock_scaling_prepare() {
>      ...
>      blk_mq_quiesce_tagset(&hba->host->tag_set);
>      ...
> }
>
> Later in the scaling process, this condition is evaluated and can trigger
> the memory allocation:
>
> ufshcd_config_pwr_mode()
>    -> ufshcd_config_tx_eq_settings()
>      -> ufshcd_tx_eqtr()
>         params->eqtr_record = devm_kzalloc(hba->dev,
>                                            sizeof(*params->eqtr_record),
>                                            GFP_KERNEL);
>
> If memory reclaim is triggered by this GFP_KERNEL allocation, the system
> might attempt to flush dirty pages to the same UFS device. Since the queue
> is already quiesced, the flush would block indefinitely.
Good catch, a fix has been proposed as a separate patch:

https://lore.kernel.org/all/20260616090654.421850-1-can.guo@oss.qualcomm.com/

Thanks,
Can Guo.

