Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4D4388E47
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 11:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774612741; cv=none; b=LqwolhGdMfaYsvzb2KlKjkYCHleOFa02FcHounWrSYve1k3gok/AT1Z3PueThuQCRVWhkmLigwf+RCfRGiR9YAXDZiDelNacQ6UZT4bNDnHold5cyWsPCWbRQshzrBlUAOhe2pfziug5R/3Mj1sGw+S3MGYYGnebQIeH/ird2B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774612741; c=relaxed/simple;
	bh=w3JedPAx28O2flGzVavIS/jETfiHXpBRVc+ZV/SS7Ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dL2ZNGBuYsJFcfdG7/zSyzGE4pSLZ+zz6JCuU/3TRxBaBcRH4L10FKnpg+zWXVA1o4K7tBR8CCN+B110OraVI6N+no6HPnnu08/YyfR8LZBRQyqr5kfL0vzD3HYvA7VTVZFx5yvgoiqg0QUlikTvHwb61b2uTW22LGL5I3ttmW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KaxR9xt/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VsVSPLFU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KaxR9xt/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VsVSPLFU"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R6wvPq2846339
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 11:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cujlSLknogHUz53/M5ngb1ybc0eI1qWSmC0JNuYAUCE=; b=KaxR9xt/CuTb2jx1
	2DoXe1G7+eP7sJ7dZ/t62yx1xrGDCtVHntRwSZWpV5P+Iggy1sAMSsamBuQVLVix
	RrmvDVZWCKUWm+/40kY5vyDs985rj4wVIKMWwo80tdb2OBOJc5Y/XVlmLWCZgXrb
	YNmP80HR3DqiKLzw0HbcafF9vhxZ1rjNKA6kiiJ+ommlKKSVh1HGpdBgdGQv8ANa
	OnQrzaEbniNUAIYAYJCjXWgvtCMdwwMQj3i7exYey9zWc1eToCWb6Zy9ymNLjJMu
	hrha5yzcSkAeKvLaMcLG696kVoVC9s+cJoBsHnqD9X6HC2el5pMU1h2CQozcBztg
	9xiqrg==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d53eqmw9d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 11:58:59 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c737b6686ddso1424184a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 04:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774612739; x=1775217539; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cujlSLknogHUz53/M5ngb1ybc0eI1qWSmC0JNuYAUCE=;
        b=VsVSPLFUFypUOO9Tye8CQnI5mI2YeSrR5VvrFrDOTbGb0OnzMD3uQmUbQ47skxPrfh
         71yuYawMQPOKa/QzTNflC2JPCgqiXajtVypxQuJPQ4/9dPSxKHw/peuoqPQoIAuSGElA
         nuTrYKBZcox48JBAzrsMMju4xAOGzWnjTAGo04Km47Thz5Bs/eADmI3AB67KcP+QmapM
         oB1OftivOHneFrnsH6Gr92N0HKW9ChJhs3kwD7EvqDFY4MO+fnYV4C0C76bNG4PgcCVw
         mPS7kNBsbskSyjAuJ/qoz3MgdsJD/NeI+KvmIfFiOIJSXyoBctHfBhvxVF43Nw1FlDnB
         VA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774612739; x=1775217539;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cujlSLknogHUz53/M5ngb1ybc0eI1qWSmC0JNuYAUCE=;
        b=k4GbddBvBUynHWCqI7dgD674aT+WC2oMPfbeHLf6Lx0jJgll7bB6WMQICEueAibUl7
         yw/ELKaAPj9ZhI2fEL4Bvwolv7QFp7xCFKAdMYb8ig4XHnUzuT2G2GkGXkaOXTy6/APT
         tY/XqzTbFC7OlPYOT8+pNbC09C9G7ty7G7WmKLVNBMsmDDSAeHuPQWsqqVox7ZR9WAoJ
         k1bGDDyHYQ8Kt63GRACnBqRCv81N37RKHvRAVEc9HlL8FiT65kFBZHG/BSHULnUpwozp
         Meeml8/bHlGCOnFEOX9fi1sQwlkWWLWgt6MnJN8isOxaus4dB/QIkRHBpnwnaf/k0zKQ
         PYdA==
X-Forwarded-Encrypted: i=1; AJvYcCWk10pagF4eyhnKSvLwjPn/TWzBIVGPfXXXyFvFpIQL1jF5jn+f2TlDg22AEFhYokaKzCVlzStQ3Bs6@vger.kernel.org
X-Gm-Message-State: AOJu0YxdbNyj/18stYxSxO+EmJfpUKENlEsSITEfEMOa1oBUHpStEMyB
	UwxshZHdIPnloT+Nmq0PUR3BImSqLu8XPihmmIsTyIu3jLuMtmTNLTLy91skm6Q1BgUzRg4G0kz
	aWRTGy09MD+/iX0uYzdHcEyie1RK/tBuywLkJSWVP2AEaW/SzVRMO8D7VZngT2ECk
X-Gm-Gg: ATEYQzzp8sFtH1IBkXZ/+z5MGU+X7WoK2uZOhImnbSSGIyBTv/gfGpUn9yBqJW09Pou
	YJSzAEEgS//TfxhQ5d1WxsXa+1xzA3sBRyrx14vhAqKIGi56sPaubIXAiE2sGEIElqUs/l8euWw
	bjWeWM2+GmPiVC9r/lxguSOOzFnNGBs/a/qKFFqkbRyP+MbA78JT2dlmZUt0Rv+qpQxqCxaaPWt
	O2FzxX1OqjIau0pRBLOZFl5Il8pQwyjWLF08r8S6IAJHHgEBDje4vnUDENWqgLnokvOMwZs92WD
	DBJjyEUO2zpyLm4NybqocCbidG9GLJG58OgeLQj6z6uPFiI/lrXUEbX7D9LYH3RzTLPbkG1GaW2
	thvXfkNSV3nVkHNDy5xqyKKzqsj1H7or9zUMUJCQYvyfxRLEc4mE=
X-Received: by 2002:a05:6a21:3086:b0:366:14ac:e201 with SMTP id adf61e73a8af0-39c87c4ae56mr2521326637.63.1774612739087;
        Fri, 27 Mar 2026 04:58:59 -0700 (PDT)
X-Received: by 2002:a05:6a21:3086:b0:366:14ac:e201 with SMTP id adf61e73a8af0-39c87c4ae56mr2521303637.63.1774612738614;
        Fri, 27 Mar 2026 04:58:58 -0700 (PDT)
Received: from [10.92.178.97] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76739b5ec9sm4480178a12.32.2026.03.27.04.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2026 04:58:58 -0700 (PDT)
Message-ID: <39e72094-5f9c-462e-a0ee-f9b51662b9a8@oss.qualcomm.com>
Date: Fri, 27 Mar 2026 17:28:54 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/2] ufs: core: Configure only active lanes during link
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        nitin.rawat@oss.qualcomm.com, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
References: <20260327090346.656324-1-palash.kambar@oss.qualcomm.com>
 <20260327090346.656324-2-palash.kambar@oss.qualcomm.com>
 <f0685a6c-25f2-293a-cd94-754326abcedd@rock-chips.com>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <f0685a6c-25f2-293a-cd94-754326abcedd@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA4MSBTYWx0ZWRfX6J161hideeYq
 FGCHy5UfmsUx/DwpEoYKjn2vbD/fChpRyfNU4B4beJ8R6vALkTV0uIGmM9UcuoR3qOYCDgF8GcN
 OERMNdKRQlm43k1G8hppcYqWBoEITrGfLd58GX060KUoWjihXp6PmkwcqR4m5lxzcZSuPSX5g3Q
 4N0b8B+aXbmRNdjuin1lr22UBRXeDC3F78YSGKel3n02dNQL5TAfIANAjWGHwO/vVmLCl09ABFJ
 jlaGbjEl6Ju8SPsBlYFqObGPNkLd1eWBgI35Ar0iRuUcD0x0xOUCbQ8rzX8CTO6pddcSGh76ulx
 NmZ0mMR9Xw0n1UuOodTUkCVsZU4naerb47T4ump7BEfYxvT4Tn9zRqnq/+6pE9u7hmwGoG5cb8v
 4wtYv2gKRjjUzXgDecOxfhl40TVhlQ/lEXgnk7T5hHg4qI4ODt0+vEeKMVvJUKfZkb6nzrg0JEa
 jijkyqu/N6bXmaHn0Kw==
X-Proofpoint-GUID: oyv0uxka1W49yHh7qm-lsQiOVAVzM05K
X-Authority-Analysis: v=2.4 cv=S4bUAYsP c=1 sm=1 tr=0 ts=69c67103 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=hbg6syq5vlUVZb5qw7sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: oyv0uxka1W49yHh7qm-lsQiOVAVzM05K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270081



On 3/27/2026 3:01 PM, Shawn Lin wrote:
> Hi Palash
> 
> 在 2026/03/27 星期五 17:03, palash.kambar@oss.qualcomm.com 写道:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> The number of connected lanes detected during UFS link startup can be
>> fewer than the lanes specified in the device tree. The current driver
>> logic attempts to configure all lanes defined in the device tree,
>> regardless of their actual availability. This mismatch may cause
>> failures during power mode changes.
>>
>> Hence, add check to identify only the lanes that were successfully
>> discovered during link startup, to warn on power mode change errors
>> caused by mismatched lane counts.
> 
> The logic of your patch is clear, but I believe there is a slight
> inconsistency between the commit message and the current code
> implementation. The patch currently returns -ENOLINK immediately when a
> lane mismatch is detected. This causes the Link Startup process to
> terminate instantly, preventing the UFS device from completing
> initialization. Consequently, ufshcd_change_power_mode() will never be
> executed, there is nothing about warning on power mode change errors.
> 
> How about "to prevents potential failures in subsequent power mode
> changes by failing the initialization early"  or something similart?
> 

Sure Shawn, will update the commit text.

>>
>> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 39 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 39 insertions(+)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 31950fc51a4c..cc291cae79f0 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -5035,6 +5035,40 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
>>   }
>>   EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
>>   +static int ufshcd_validate_link_params(struct ufs_hba *hba)
>> +{
>> +    int ret = 0;
>> +    int val = 0;
>> +
>> +    ret = ufshcd_dme_get(hba,
>> +                 UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), &val);
>> +    if (ret)
>> +        goto out;
>> +
>> +    if (val != hba->lanes_per_direction) {
>> +        dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
>> +            hba->lanes_per_direction, val);
>> +        ret = -ENOLINK;
>> +        goto out;
>> +    }
>> +
>> +    val = 0;
>> +
> 
> ufshcd_dme_get() returns 0 on success, non-zero value on failure.
> Perhaps you could remove this "val = 0".
>

Hi Shawn, the "val" used here holds the value of attribute returned
I have used "ret" to hold the return from ufshcd_dme_get()

 
>> +    ret = ufshcd_dme_get(hba,
>> +                 UIC_ARG_MIB(PA_CONNECTEDRXDATALANES), &val);
>> +    if (ret)
>> +        goto out;
>> +
>> +    if (val != hba->lanes_per_direction) {
>> +        dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
>> +            hba->lanes_per_direction, val);
>> +        ret = -ENOLINK;
>> +    }
>> +
>> +out:
>> +    return ret;
>> +}
>> +
>>   /**
>>    * ufshcd_link_startup - Initialize unipro link startup
>>    * @hba: per adapter instance
>> @@ -5108,6 +5142,11 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
>>               goto out;
>>       }
>>   +    /* Check successfully detected lanes */
>> +    ret = ufshcd_validate_link_params(hba);
>> +    if (ret)
>> +        goto out;
>> +
>>       /* Include any host controller configuration via UIC commands */
>>       ret = ufshcd_vops_link_startup_notify(hba, POST_CHANGE);
>>       if (ret)

