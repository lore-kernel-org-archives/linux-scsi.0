Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E693AD52E
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 09:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779960686; cv=none; b=e6T5Fsc5SGI6wuk/0HhLNXApc2GMvLPvP8vMVJ1wOV/rMxzmhvUZ87mGzKW6EUdtdMkfd/l/44p3YAiRUS0IjMG/w3Rp1ozMPfPMMyAEuYsr62IW07PfXgceTognoH38PqPlDZoQRDDtMcc8MHm9MPiT7FhWe5HI7VfYaJayTYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779960686; c=relaxed/simple;
	bh=3CJGch7Wqhun11Fje6j1nCkEksjcEX4SJNXkVQhIlbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bn2+CcoZicdXdgKQc9milShCsLP8siW/0ZtLpTcZnacz9+ocConjjLa6/6yq+GBVK9+tFqJIXetFjhQQGh28sEQTfoTR5MAHTve+ENm50fBSy1/p4KT45gksZYwIgQ4dSXfToW+rdpLceDv8EdOr/yPAHWue8xiLby9PgLpKa1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TjWuNWJL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=T1yXtINO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TjWuNWJL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="T1yXtINO"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S8vUik3203254
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 09:31:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7+iN9dl63snSUahQXpnWC4YL4PYn6MUHOT/tvBUrleM=; b=TjWuNWJLZKSXxmvh
	LJYib6C0XYvSXMZX3140rGd8g03/jJ2YJKXvUWR7nG8RPF9bXCHU1jyX8y4eiggT
	qe0FSnqOPr8byp0DV+1WU9ic1YjtBojgUWLlJPjlLYYwCSzbOSu/X9qm62yFc7Yk
	QB4qTPu/3PovrF3I9/lW8zAlKIxAL+8ihhMbiHd8M0mSmAiGGb8ee6TxSbig4ngR
	NCADzvSRVAWmDZ+vUhjo/DUIhJfAKkO1FBlhx9yanZD+kvEAMqICY+q8+fL8FVv8
	25sLq2lSUMFgh8DRX4tMtvy6ZHPRf4DHvGQtWwxYzCYoZEZjI5raITLhyFuAsGom
	WWVW4w==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ee7ynj7j8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 09:31:24 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c82ba4715b6so13663382a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 28 May 2026 02:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779960683; x=1780565483; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7+iN9dl63snSUahQXpnWC4YL4PYn6MUHOT/tvBUrleM=;
        b=T1yXtINO7K0rzvj0F528/byO+eSxyUAhN2VjGhN5MGNgfijm3SA6Ll8zRXPXGy1NKA
         u//7GqR1th6uSuN+R7FBglBp0lwEMcj0bTHjU351v/fcRRyrPZto2FlGO84biMAg51Gf
         6QEmQd52/XI2ODS/kqavq3MUc5dlJ3MHCpI50hHaOO5f3mKrDJxcHVGHI+gaFlkGXl4w
         vlnXbcqRf+0kNSx1FGJpFTHpWGRSV/X35SrrHIsvqHb5Q722szE4SWYOVgPKV2MIBmw7
         S2ugPxE6tNGWejW/v97RDZljar3diQCvP6bDVPm9bKqoqwx5JO8qpKPW98rWWxy68DT/
         qKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779960683; x=1780565483;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7+iN9dl63snSUahQXpnWC4YL4PYn6MUHOT/tvBUrleM=;
        b=QYnP5TmSeSr4xVChK4fzWuh66XWMgmeRbWhlVvGJ6oen3KC/59kv7qbf+u36dvdMQu
         BViu9NHTFTgfi9AabhKAGjCPhLa9lBP4J6H0lqtY9/oDTNP5JrmMeHmvEE/ckbDaeHsy
         q2aA2XsQmHMss97FzjN6bfkU8UeUa/XWETJvmwIiTk5TbmKscXUgT3L/k41NRIfuk3WD
         HUjIwbHv2gPo1vHiKYEdSPkQcpdyUyrLQgGHaIposKbKX89vCZFv/5Xm6DJevby4KCyP
         h1J8henYBHeZzSncANd/ex465RjVRgInLhQ6hmA9K5YHPwAd3L6iZZf7fUnDxLj5Ktuz
         Utlw==
X-Forwarded-Encrypted: i=1; AFNElJ8WKY7dh0F153xWRDg9Zk+1MBjkbSce/SsAKU2k67jqNQ8yxt5jkVv/GDwrvA8GgNkjhhV3OrJZrmZ8@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp5vIj6zIK0zZTtmc30eBtqWIOjhh3PtVWJRoFDJb/UcLJU62+
	jexCONVgrNne2FJ+AI8BEc4/BtbwtTSBt33NFVVIhyzJ7FQ9zEy7vSIIUkBSoM8kRu8WJeZox7w
	E++eC+UQRLDYfjwDEnTnt+HM5zokSSgtL0P+i0Wxk5Q5TQFZlCuxDwhawbnUoYG+0
X-Gm-Gg: Acq92OH4MGe2yqdchiw1DRKgDsU5lIQnamOyldG61Zu6OFBbPBf9mIi5WqLLV5uk+kI
	7AmSGFEvX1zUn42HsJ7XgD/Rnx2b4JzMrAfRQ5wXdUR3loshv58h9Ksk2NmTmm2EQc0XJgIz1a4
	wtGJ38y16Q2vpbFEysrKqwwxZJUI0JPRp0ySEiM2v1gdDs7/6rcmq0ug+k8lPK61XLf1tFvQVG8
	upeM2n6yziS3Rn7w+0X+UxF78TkiXn4upnGPZIGPF+qkEPnfhoJLIgCGD65tmKWallV44+iIJdk
	9ePRDcd9VwqRGAra+7ZeThzmzYvwqyZFm4D9pG0kcQ9V74BpWh2FJr/wkI+4FGMK0SESFqrpYZ8
	sEMl6HO6Y7FGVF9ZFYWui6KfFhhR2nJZIuXBmMQKTPdQvGDwyE4tOYmrRWICE9mdQ9Cl3I4wOg9
	vHHtV40KGbXcmkMSM15a5YlQ==
X-Received: by 2002:a05:6a21:6110:b0:3a1:90ef:7e37 with SMTP id adf61e73a8af0-3b328e5b321mr27022151637.33.1779960683348;
        Thu, 28 May 2026 02:31:23 -0700 (PDT)
X-Received: by 2002:a05:6a21:6110:b0:3a1:90ef:7e37 with SMTP id adf61e73a8af0-3b328e5b321mr27022099637.33.1779960682775;
        Thu, 28 May 2026 02:31:22 -0700 (PDT)
Received: from [10.133.33.247] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c852056dfb1sm13714857a12.28.2026.05.28.02.31.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 02:31:22 -0700 (PDT)
Message-ID: <a123bd30-09b8-41cc-b6d2-e6be038795bf@oss.qualcomm.com>
Date: Thu, 28 May 2026 17:31:17 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
 <20260527144055.2758170-3-can.guo@oss.qualcomm.com>
 <mt2asdx4vnuxo3eodrc7dlfdtv3b5bpjfvxxglmncny36otfav@htri3l5q4ba3>
 <d57a0e9b-74f6-4472-842f-6479c7449cd8@oss.qualcomm.com>
 <35rqdgvdtf2jjjjdfajhhansmzzem2gllbw5olcopdmcdfdd3k@rqwlcht5uzsw>
 <330662df-b2e3-45df-a801-4e84573fa6ec@oss.qualcomm.com>
 <dg5xqzi2xhjr5lete5git25dffeb2cmm5ufp3wbpmzhprcqols@hkee2numt2gd>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <dg5xqzi2xhjr5lete5git25dffeb2cmm5ufp3wbpmzhprcqols@hkee2numt2gd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDA5NSBTYWx0ZWRfX8CYip/VsOAab
 4eBrAlWSXctarEjoZFpfUWmpGs9uEh8XY6lj4k33ecRWIEybFjz5nSNQ44LNnqUmd3ZsrMdPAt8
 ZTDUNkgSRlDOuv8JpDwqbaH8H7IM2/Q+hBgvjP1tPAr6vT9nKHdDqL05YOBu2pj/0XCbeZRTDT2
 wc+SdRyDg7BDQYBCvOlTwa452o9Qspo7BHEMcsllDQYf5W7ZWFst1OJpLHdDHyxLy4RfwYZVoda
 +vdM4uOQm69KOfwC7tmkDIXDvfDDH5ud3IHJdkEMK5d9nJYlqxR+H2c6w3nSme1GXwhKV6+Gd1M
 X9AU9f0IbbWLgluSEs7JTf0/i5mkR2MNgEag4ZPe8QXjOya6co/CUMGQ9fcPOcv+lpJu021pm+8
 2Ei/rvBQvb5pKm6CXPrpvvS261as+j2wDE82FxiTSVu4XUpPg7tma7p5TXHV4FaS2fhCjdqpAkn
 zcessd25md5U3r/O0ZQ==
X-Proofpoint-ORIG-GUID: ocVuwq9fJbK1dXR4u4yCfUAfTOHjAJ7W
X-Proofpoint-GUID: ocVuwq9fJbK1dXR4u4yCfUAfTOHjAJ7W
X-Authority-Analysis: v=2.4 cv=EdL4hvmC c=1 sm=1 tr=0 ts=6a180b6c cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=6xqaE-ZKsAtMbV9ZvyEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605280095



On 5/28/2026 5:29 PM, Manivannan Sadhasivam wrote:
> On Thu, May 28, 2026 at 04:40:59PM +0800, Can Guo wrote:
>>
>> On 5/28/2026 4:16 PM, Manivannan Sadhasivam wrote:
>>> On Thu, May 28, 2026 at 03:24:37PM +0800, Can Guo wrote:
>>>> On 5/28/2026 2:13 PM, Manivannan Sadhasivam wrote:
>>>>> On Wed, May 27, 2026 at 07:40:55AM -0700, Can Guo wrote:
>>>>>> Static TX Equalization settings and TX Precode enable indication from DT
>>>>>> properties txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6], and
>>>>>> tx-precode-enable-g6 are board-specific baseline values. Values are
>>>>>> provided as per-lane tuples:
>>>>>>
>>>>>> <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]
>>>>>>
>>>>>> Parse DT u32 properties with explicit range checks by using
>>>>>> of_property_count_u32_elems()/of_property_read_u32_array().
>>>>>>
>>>>>> When adaptive TX Equalization is used, these static settings are not final:
>>>>>>
>>>>>> - If valid settings are retrieved from qTxEQGnSettings/wTxEQGnSettingsExt,
>>>>>>      those retrieved settings override static DT settings.
>>>>>> - If retrieval is not available/valid, TX EQTR runs and trained settings
>>>>>>      override static DT settings.
>>>>>>
>>>>>> So static DT settings are a fallback and are intended for cases where
>>>>>> adaptive TX Equalization is not enabled/used. Adaptive TX Equalization
>>>>>> remains the primary path when enabled.
>>>>>>
>>>>>> No behavior changes for platforms that do not provide these properties.
>>>>>>
>>>>>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>>>>>> ---
>>>>>>     drivers/ufs/core/ufs-txeq.c      |   4 +-
>>>>>>     drivers/ufs/host/ufshcd-pltfrm.c | 128 +++++++++++++++++++++++++++++++
>>>>>>     include/ufs/ufshcd.h             |   2 +
>>>>>>     3 files changed, 133 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
>>>>>> index 4b264adfdf49..634ec039e129 100644
>>>>>> --- a/drivers/ufs/core/ufs-txeq.c
>>>>>> +++ b/drivers/ufs/core/ufs-txeq.c
>>>>>> @@ -1297,7 +1297,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>>>>>>     	}
>>>>>>     	params = &hba->tx_eq_params[gear - 1];
>>>>>> -	if (!params->is_valid || force_tx_eqtr) {
>>>>>> +	if (!params->is_valid || params->is_static || force_tx_eqtr) {
>>>>>>     		int ret;
>>>>>>     		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
>>>>>> @@ -1310,6 +1310,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
>>>>>>     		/* Mark TX Equalization settings as valid */
>>>>>>     		params->is_valid = true;
>>>>>>     		params->is_trained = true;
>>>>>> +		params->is_static = false;
>>>>>>     		params->is_applied = false;
>>>>>>     	}
>>>>>> @@ -1495,6 +1496,7 @@ static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
>>>>>>     	}
>>>>>>     	params->is_valid = true;
>>>>>> +	params->is_static = false;
>>>>> Maybe it's me, but I'm not able to understand how you want to apply these static
>>>>> EQ settings. In commit message you said, the static values should be used as a
>>>>> fallback, but you just check for 'params->is_static' while triggering
>>>>> ufshcd_tx_eqtr() which is supposed to perform adaptive TX EQ training. IMO, you
>>>>> don't need any check at all for applying static setting. If '(!params->is_valid
>>>>> || force_tx_eqtr)' condition is not satisfied, then the static setting should be
>>>>> used.
>>>> Thanks for the review.
>>>>
>>>> The distinction is between two different sources that can pre-populate
>>>> txeq_params with
>>>> is_valid set to true before ufshcd_config_tx_eq_settings() is called:
>>>>
>>>> 1. DT properties — parsed by ufshcd_pltfrm_parse_tx_eq_settings(),
>>>>       sets is_valid = true, is_static = true.
>>>> 2. UFS Attributes (qTxEQGnSettings/wTxEQGnSettingsExt) — retrieved by
>>>>       ufshcd_retrieve_tx_eq_settings() (introduced in the 2nd series),
>>>>       sets is_valid = true, is_static = false.
>>>>
>>>> Since both sources set is_valid = true, the is_valid flag alone cannot tell
>>>> them apart.
>>>> The is_static flag is the discriminator:
>>>>
>>>> - is_valid && is_static -> settings came from DT; they are a board-level
>>>> baseline.
>>>>     TX EQTR should still run to find optimal settings, which will then
>>>> overwrite the static ones.
>>>> - is_valid && !is_static -> settings came from UFS Attributes; they are
>>>> previously trained
>>> You use '&&' here, but '||' in the code. When you use '||', then I see no point
>>> for 'is_static' check.
>> The code is correct. My reply was explaining why the check is there, but not
>> explaining the check itself.
>>
>> Original check in the code is (!params->is_valid || force_tx_eqtr).
>>
>> Static TX EQ settings are valid, so '!params->is_valid' is false, TX EQTR
>> would be skipped.
>>
>> Update the check as (!params->is_valid || params->is_static ||
>> force_tx_eqtr) so TX EQTR
>> must run when static settings are provided.
>>
> Ok. I still see having 'is_static' is a bit of overkill, but I don't see a
> sensible way to check whether the static EQ settings are available or not.
>
> But please add a comment above the check to make it clear.
OK sir.

Thanks,
Can Guo.
>
> - Mani
>

