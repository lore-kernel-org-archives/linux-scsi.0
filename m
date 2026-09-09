Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6941A2D24B7
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 05:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788930308; cv=none; b=TiVfyB/SI/MdgjzZvmJOzqHkGKloP6PXOPCn7PcwhfS8ZmJ+FPZylVpysJihterwwaZUOSUyVJfRtCetaDUq8nN9bxvBh7ZtiiY4l3oQ4lyk39r1tr5jj6CB+NU6ext9j1CuZrVBhCfFu3hf/1jr9PrxEW+dyOH+ggs5KDFLhcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788930308; c=relaxed/simple;
	bh=CKdRM5fSMd2cujrUt2fuU6ccWuxsQFIGjUemrc2ZJmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eRsCFoqfPOBA+RIQRjiZj/PwW/ZQ6VfuXPY8VuwfuhwYugc44T1yphh2T1EPi7jBsykZvoPzDDX+lPsY/RiyRGW0QNvPiNlCXJfZAakI9djaV+huaNfNGuHJC7n+JlVrMw1Tc1rI9v1AQ4PcwFdRJ66BirzMY3Jwxo1tf/yBHWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JJHeJM9s; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LeovFJLN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JJHeJM9s";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LeovFJLN"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Mg23B965220
	for <linux-scsi@vger.kernel.org>; Wed, 9 Sep 2026 05:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LZSTs+CvtHAB1mwHgOV7ZbDB5Nlf194yh6i3owJzkNU=; b=JJHeJM9sHMUTb7pk
	RFPVbOQSGGTNLCG3o4Kv5JEXpZ4f8C8yXpBNusZyTtBDRPlgI72h7aFMKu82m35l
	f0eXa55zJvF6wFvOj/qJ5mqoL/+TTiZdcAizujEyiztZhImzfDihW/F7LT5jh39K
	1CNcqTFQMhieT3r8zwt1ZwFVJxM3lb9+P5g0DYqAon+txLeWN/tUOsdsJ88wnniz
	S0riGdr0dUCysYLu/TJPNxeWMGVqEgwEDOwbhYk3wE4F+I9+zjjKi5DEAxF3U5eT
	RPUKXZWatZEFTdrGjlFohxKpQVkGpJOZ0qYW2jePB+Y8Ga30NRfI38hiH9O1k8gy
	jqeBEw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjqha28bh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2026 05:05:06 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1c18c775eso6415972a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Sep 2026 22:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788930306; x=1789535106; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LZSTs+CvtHAB1mwHgOV7ZbDB5Nlf194yh6i3owJzkNU=;
        b=LeovFJLNWBgAN6pWQNT7AElzWZ5YNiznDDlzkgKLpNG1uwr6RmuRXTAAbiXf01UxMS
         DenF5tnE81IwZXxM93rCTg06Co+FkY8t0D2pdjes71saEXjaH6Uh9ysu0sb1YFwMkPAx
         KjuhSgAdPpZOoJ+OCyU9zsEJFBrOaq9G6ESMgaXTHFtpRHnSL8tCzrNn7br804BrWdMv
         +KpyFP2vERzqCPlGOVe//9G2LyqnTdsDp/DTmuPBpxXkXS2VPdK7KPTxcrLPLu4mpj+J
         NT0E4qEd3yNAo5LXw1+D6IXGcUnRSu5cHV/2BBzcKV4Rtu66dXXTZlhwJkvdl37iCz8r
         OwRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788930306; x=1789535106;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LZSTs+CvtHAB1mwHgOV7ZbDB5Nlf194yh6i3owJzkNU=;
        b=FbOVloK2eOn+lYollLyd9AVT3Lfa634YKX+E9s0gDce0M0TOrvQTKRFboxtBtni3QO
         0XQ4kGJYaACRakB/8MSryt4nScFmmF0P4+58yt3os/10TBYErcHsabKC9jAgAdn2gpKs
         yTyT/5KhS9yyOKmiarSX0fjpDGX34J8gGjz/aOdjkAZTV8NHf0UkO85RIsXNR2YSQEEn
         Xz1yR/1b2s0ubOk9pWeSiBvQfYzxUS/LSyL9GSK7aDfikI4GEklaL5AVc63DXsV3qTci
         XEUMLcuQPIFXqdgWtIZvfpR2V/qgrXQWqd94VgTo8ADXIBX9mT71uKLbDN9JRJ97yhWN
         1OqQ==
X-Forwarded-Encrypted: i=1; AKwUvBxgoIdcfnqqtdRwr21DBVwPP45ZhHE/P57XtRazewtFkrl84FPw4iI5sq5KPwa4P+TCkgnUmirhvUMm@vger.kernel.org
X-Gm-Message-State: AFuF++meIsZJO8sBiHc0khWwgkS/VxrOrWeO7cZp+g9zjdyUZzmeAx46
	GHtb+MA/NVFW2h7SQ/K9B1XrjACog9rKo0qQDoPWPvXBIbKuPVNcu6fUZA+uxWDk7BsJkvlnNA2
	/E8pxu3Ul/+7QGydbQP3J6g6fBJJYeM/SrqOjdH/VR/eoZZEskBa/N+HFThyalmyoct8aDaAN
X-Gm-Gg: AYBFou23oUNXt74OFay4T4oF/Q0ghiiR48id5KW7civ0M18L9yARUnClgFARjkOJVJU
	VKPeKXsFvvPQwbgGTt2UG2fXr2WnhKnCZCD/QBNdKEq/smu4COnt2vpyhqSvZOTkNuvV7/jg1XM
	3pymfft7M3vzEoVDjFAzL+Jt6oPvmfM5wSsTdQkjt/ZsaSjcORzw2W8O58anEEh0Oku/iEgE/xi
	Yub5lSFYXa/YdRrrfVNoTnjRW6dThlObXXek4YVmgsqOJKKUY9znsg3S09yPUoWHNwWbkg2Y5NX
	5w9/28y9JAvvUK0zlX5IarBFRd7J7qsNXA2Ixh6GHObKlpSg1CLNJKyoYAF1ZH/NYg7ZF87JT1S
	7E2eN4/uOuFWxSPewD6k4hkDkyzW9
X-Received: by 2002:a17:90b:538c:b0:398:9beb:a2b4 with SMTP id 98e67ed59e1d1-39b087992ddmr39690335a91.22.1788930305805;
        Tue, 08 Sep 2026 22:05:05 -0700 (PDT)
X-Received: by 2002:a17:90b:538c:b0:398:9beb:a2b4 with SMTP id 98e67ed59e1d1-39b087992ddmr39690273a91.22.1788930305342;
        Tue, 08 Sep 2026 22:05:05 -0700 (PDT)
Received: from [192.168.29.58] ([49.37.154.50])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-336c2571039sm20745950eec.25.2026.09.08.22.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 22:05:04 -0700 (PDT)
Message-ID: <50e348ef-2d9a-4197-84ca-99d3902cbc37@oss.qualcomm.com>
Date: Wed, 9 Sep 2026 10:34:58 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 1/2] scsi: ufs: ufs-qcom: Add specified gear support
 for multi gear scaling
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: krzk+dt@kernel.org, robh@kernel.org, conor+dt@kernel.org,
        andersson@kernel.org, konradybcio@kernel.org,
        James.Bottomley@hansenpartnership.com, mkp@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        Ziqi Chen <ziqi.chen@oss.qualcomm.com>
References: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
 <20260829074355.946543-2-nitin.rawat@oss.qualcomm.com>
 <stik7u2o6ydje6ws7cyrltmdw4wz6iyximnxeyegw2f562b2bv@4m2sueuuzisb>
Content-Language: en-US
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
In-Reply-To: <stik7u2o6ydje6ws7cyrltmdw4wz6iyximnxeyegw2f562b2bv@4m2sueuuzisb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDA1NSBTYWx0ZWRfXy8f1hK3E4JKf
 VfYdDezdK/1Bk0yxgWTiBH3tkZllm1G8n/1VCe7ctsuz1M08MGu8ViDyIHSlnoXh1tN6zMgMIFi
 scYKp7gcccwHZf5401nRu3bnlRamNEL+YXvk0I7JbgiAYKlkw4Z6PAjZGrqkvjoKvmkBdTeL/i2
 y/FMBs2nardyThf23F1toBI8VsZZQ5nZfFG+V5VkasyRMb7vvCbxYtwEaRnTYSyFW2T2DuTUg2M
 CZKnEhRwjJ1wWPrmvQkwh8GXDUF3sKDgIcb40JdBdzbGdivAb0ceW4cLiv3W4cNrxelp6GAl1dc
 1V0MrmVr3Ab5F8mmbBMNmDnPX6TUIaVNyMMpI+74nk3M8PXTcJk0tKEyyQ03iOa+y/8mXsXrpgf
 TBeJjB1mLWb/40o5PF8pqfIVV3UySIfpc6c6R2YYL2Sb/UsdVUJj30BTaW7aKO0J0yE0OF2VCK0
 wE1flDL3uiH+1RpWSzw==
X-Authority-Analysis: v=2.4 cv=Z5Xc2nRA c=1 sm=1 tr=0 ts=6aa0e902 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=FrNG0DaaYUTAIW4lgu81OA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=hgvoHBFRqoCwco_ImLEA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: mclpANt3o86SsNQwHnsbs5OxeIGz4Cml
X-Proofpoint-ORIG-GUID: mclpANt3o86SsNQwHnsbs5OxeIGz4Cml
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDA1NSBTYWx0ZWRfX3+A3oh9y92Sw
 FSAxTuGC9RdyN1HpxfncvbUTlprCpxKXUM0dI6HeBxzs55oFuPLs32WYg5m992BRLZXtvvF47oF
 Dq70IUqFvMxmOG6QUbQqz75NPrstv2M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090055



On 9/2/2026 9:32 PM, Manivannan Sadhasivam wrote:
> On Sat, Aug 29, 2026 at 01:13:54PM +0530, Nitin Rawat wrote:
>> From: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
>>
>> The UFS clock frequency and gear speed do not necessarily have a strict
>> one-to-one correspondence on all platforms. Introduce a device tree
>> based configuration interface that allows specifying the HS gear
>> speed for each supported operating frequency via the "opp-level"
>> property in the OPP table. When this property is not configured, the
>> driver falls back to the default frequency-to-gear mapping table.
>>
>> Signed-off-by: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
>> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
>> ---
>>   drivers/ufs/host/ufs-qcom.c | 30 ++++++++++++++++++++++++++----
>>   1 file changed, 26 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index 0f2e083b04fd..aa2ac2cd2b69 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -2460,8 +2460,9 @@ static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
>>   	bool found = false;
>>
>>   	opp = dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
>> -	if (IS_ERR(opp)) {
>> -		dev_err(hba->dev, "Failed to find OPP for exact frequency %lu\n", freq);
>> +	if (IS_ERR_OR_NULL(opp)) {
>> +		dev_err(hba->dev, "%s: Failed to find OPP for exact frequency %lu\n",
>> +			__func__, freq);
> 
> Don't bring back the '__func__' marking please...
Sure, will take in next patchset


> 
>>   		return 0;
>>   	}
>>
>> @@ -2489,12 +2490,32 @@ static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
>>
>>   static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long freq)
>>   {
>> -	u32 gear = UFS_HS_DONT_CHANGE;
>> +	struct dev_pm_opp *opp;
>>   	unsigned long unipro_freq;
>> +	u32 gear = UFS_HS_DONT_CHANGE;
> 
> Nit: Preserve reverse Xmas order.
Sure, will take in next patchset

> 
>>
>>   	if (!hba->use_pm_opp)
>>   		return gear;
>>
>> +	opp = dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
>> +	if (IS_ERR_OR_NULL(opp)) {
>> +		dev_err(hba->dev, "%s: Failed to find OPP for exact frequency %lu\n",
>> +			__func__, freq);
> 
> Drop '__func__' here and below.
Sure, will take in next patchset

> 
>> +		return gear;
>> +	}
>> +
>> +	/* Get HS gear speed from 'opp-level' */
>> +	gear = dev_pm_opp_get_level(opp);
>> +	dev_pm_opp_put(opp);
>> +
>> +	/*
>> +	 * Greater than max gear means that there is no specified gear configured in DT
>> +	 * or the specified gear is invalid.
>> +	 */
>> +	if (gear <= hba->max_pwr_info.info.gear_rx)
>> +		return gear;
> 
> Sashiko pointed out a valid concern with this check, please take a look.

I reviewed the bot's comment. The concern raised applies to the case 
where the gear value provided through the device tree is higher (for 
example, 5) than what a UFS 3.x device can support. After link startup 
and negotiation, hba->max_pwr_info.info.gear_rx would be 4. In this 
scenario, the condition below evaluates to false:


 > +	if (gear <= hba->max_pwr_info.info.gear_rx)
 > +		return gear;

Execution then falls back to the switch-case logic. If the current 
frequency does not match any of the predefined entries, the function 
returns UFS_HS_DONT_CHANGE, which effectively maps to the minimum gear. 
Shahiko's suggestion is to instead return the device's maximum 
negotiated gear using:

A couple of points to note:

1. If the current frequency does not match any of the expected frequency 
entries, that is already an existing issue. In such a case, simply 
returning the maximum negotiated gear may not be correct because we do 
not know the actual gear corresponding to the currently programmed 
frequency.

2. The patch under review does not change this existing behavior. It 
only addresses the handling of gear values that are within the 
negotiated device capabilities and does not alter the fallback path when 
the frequency lookup fails.


Considering the above points, I believe no changes are required for this 
patch at this time.
We can revisit this behavior separately and evaluate potential 
optimizations in a future patch if needed.

Please let me know your opinion.

Thanks,
Nitin






> 
> - Mani
> 

