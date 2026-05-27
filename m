Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6363DA7E5
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 09:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779874107; cv=none; b=Ivz0ZBIfV08AY4po57cIZyXtr4ML0AMwxdHTgiyxWfQzBICxMxrO9wTPCgFl/kuebwKVNRQX9AZP985PAjL03juQq4GjNapRoVV+3zZrl/opEvpFBRwWAcPGto3NpXqNfBcrHIPESNzUJ4mLvAYdyK5ty/eFGWfM87aaHzKKy4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779874107; c=relaxed/simple;
	bh=wh2is0NxrSIwdahl0U1M1H1oL1golN9FcMndqj98Tbg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=r2E7ecy42g6Ie5JelTF5/Gst1y+pqy+DGkJH6UdXqY08kDcN/8zPUiemS4VwQmXJxtJUMy/qvLNteVHYEm8fhydleXGmErvJugVAeEQDHdqfFqBdpBv1G7JbDqogRzQzaO6IpATdGgcc7mfm9Sqpl49AvNN0d1bPJQjV0DyOIy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FdhqiZUI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Pq5SRtgy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FdhqiZUI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Pq5SRtgy"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64R8mXBq879397
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 09:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	krZaKSvePXl1QNhWDCRYm1/ahf3NGJUstxm4NUAsrnI=; b=FdhqiZUI4krVvtw1
	yfSr7oImzzmMAbbFJ1zd2+RlZ1FEe+X+bMgu1k7c4VPotQRNNmNJ6sLT0W6P27N9
	ULHOSi8iPYOBYOAFxlUU96meB2xru0Ite2VVhd8NKhT4okOOByK5lm3xa6fmULkO
	18+fuYpiN+dUK4WeEfrimkyuKT/8eY1Ks5bWDsQDLxrHdehytjrgX5XrOgT9RjDy
	Z7of6cUxN/I2DkojhuudTAAQswkpneit6bkK2sC9WkeW4EookQYIs9HaKyaw2zI1
	11CrRYNEqAjIaDi05KWbfREs2maQVozhigreuou+c7guivyNVSjDG1fDRxIoaHlj
	+bsz3g==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4edvvqrapk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 09:28:24 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2bc7f9b2213so83735325ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 02:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779874103; x=1780478903; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=krZaKSvePXl1QNhWDCRYm1/ahf3NGJUstxm4NUAsrnI=;
        b=Pq5SRtgyAZwKVzwhsuHYkTjvuzTuEyXwgVKV0dLpUVY+EEAgSn3+Wzrw6x/taw/xsV
         mneNmLt5jpS0mj1UHrxKmvBR6a+huHJX5JJGSBajk+pEZ3CLM1LWGJbbtPL5KDTsTYic
         kQ9fyVN2E8INTA3oy4ZDEnT88OCAr4pNelwLWNXWQyYJZX4EgdAEfzhEvz5aMFXpVGYv
         sYzJmoe/sbF+JB1HDwAciKSpc4Yf/iQY5yCOY/Posr3NqEm2qwRbEoDAJXorgzSaAJX2
         U+BtWvc7iqAm+9gFfHicy00OY1DCcHLSwUNpyUuArpXQx23IBcx/d8QpaCIZJFQIbI0C
         rJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779874103; x=1780478903;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=krZaKSvePXl1QNhWDCRYm1/ahf3NGJUstxm4NUAsrnI=;
        b=rRHWID3YaBLB8Z5O5uShrBmVJNn+7Ns7Opcuxjm8TdbzmgW8zXGO9iTK7Nrbys0xw9
         0jCCDMrPLgWGjnTsKwCfO6kZ0QY4eiM1i92ueuvqUyUWJQK+KYMAmYL00cNf8VfFS9gt
         oSxFJeYmHbgfxGogcHlZTl39vhNOKdGS00M8X8e8TM9oA3StgC87rky76M73nb7+LeFO
         xUGa2uSzNMnCH0l5ii5wsGmmgVufMzhuGQJihbIlFk54iIFdFpRSSzIDRQuVsAtfhurJ
         iCvUcuhdUHanhXxeUFkip3ytK9jeDk6mWTNpCqK+ZutC76BPE9vS5xsb5ZVaPm+K8IBS
         Uoiw==
X-Forwarded-Encrypted: i=1; AFNElJ/NDtHbmuCOJT1CuuudixS29WPtf5mspmKVoPTxdpIG8rp205fLi6oyyACpGSNDBNNpCJJEITZZHF1t@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq8Vk0KWQ2Jv4E7yF1GN9JrnPkfufpydm6MJAzXZ5WJy00JQ42
	Nfkq6LhYWnWJr0U9Mo0WdYQWzYYuZv8DYGzZWbqsUv+In109aRdFhouDpZmg3WpfstCpX6zyx/x
	KHjFzeP12WoHqdIGclIlD6i++Fd+QrSoPkyj+QXQY94YZR3DmrEXFN/bpk4Jq1Gom
X-Gm-Gg: Acq92OH/iiKFCAtpBl7eAQBCaUFwrcl3DBl88BqUfr4KI0CMLown61HS1XEkO1ilUOM
	+IOromBm7tcwtRouTbDyTWERq9miDmwBGg3LAaAwmGWFGaRl7vAvhj07dqt26XpuZ/N7xpENx92
	MCBp5SO/P1fA/VEvxBkdsCXUuqagKUbv7OuutiLfyia/pFDKckfRycEtWnwQ0iGtTPYsoihfe4f
	+XFhZKjK0TerKjY3VMcy+jhVhB7OJXQ+2rhJSlFMA5cOsKNYVTxtaa2aj1tPBJkToVW4KxWioVW
	3QBpqfYn+6Zw+6ysX4F0BruhCwoaiiTkmxD39sc5CTY4SJBhBa967LQxRJkKtUIN4ftmYwUla5p
	XITqZ2QNDdZ5trf2wFnKdKsl28hrC7ukPC5s7wgdoKL524Sbno9BekEt3suQz4Q7P5d+14EiZmY
	g6TJHiKr6l/Zxt3918gJWYSw==
X-Received: by 2002:a17:902:d50c:b0:2bc:78ec:54cf with SMTP id d9443c01a7336-2beb035a83bmr260703915ad.9.1779874103529;
        Wed, 27 May 2026 02:28:23 -0700 (PDT)
X-Received: by 2002:a17:902:d50c:b0:2bc:78ec:54cf with SMTP id d9443c01a7336-2beb035a83bmr260703725ad.9.1779874103017;
        Wed, 27 May 2026 02:28:23 -0700 (PDT)
Received: from [10.133.33.247] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58dba7bsm143296905ad.66.2026.05.27.02.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 02:28:22 -0700 (PDT)
Message-ID: <8398e275-8d57-48c6-bbf7-f82f423b0a39@oss.qualcomm.com>
Date: Wed, 27 May 2026 17:28:18 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
From: Can Guo <can.guo@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Zhaoming Luo
 <zhml@posteo.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260523134711.323425-1-can.guo@oss.qualcomm.com>
 <20260523134711.323425-2-can.guo@oss.qualcomm.com>
 <m6qq3kxgfs73jve2pjmmszymgxb7aizdfo2rwg72o66n2rvov2@xkcvifciwu3z>
 <96962564-ff25-4d81-a605-3d9c05fa000a@oss.qualcomm.com>
 <qrqggwpuigevauuzjcvggcmbzkphutemlpsvuymy7qn5yblnsd@djbgzgyeekre>
 <1cd587f0-d571-4bd8-a8c0-97248e732cec@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <1cd587f0-d571-4bd8-a8c0-97248e732cec@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDA5MCBTYWx0ZWRfX5a6QcD6MLtqC
 RGvUBvQAkIGk/Wfi3jfKo401B9tSVzYF9UTZjIOokhRTNdF/Dm6dWP5DGWgcGjbkNpn1WqZjsg/
 A5dDnpJrXxdfXSU3c2QaTe8XvHT7Lhg61LbEC2lFt80iX8ZyeU3DGZs79xNKlCrEgbff8A0MWKK
 im4/mKB/BGCJPlNwx662gzDXz+wWX0CXWwfIi5ymapOmcIUYgEX/4WuNbflh3+z2WjpgEwat4gE
 LFyJopuv6emz+PvPOO2Dj106ZUdDSUhjyVH7wynljXv3q1Yt1UA+pWV4zEKS+yTfJIqlnIbmIr4
 AscJm9sAZyPUquXd9aTSTp0LrGcGh9hGz9AyDR4ySmChe6GoE4OVg21OXzZIQF8DyMhqTbgTNww
 EKRHbEZdvOzjpCDiO20D3jBj9d5oL4VcyziZnEt5xlq6VozL/Qcwy+dJeRlgHVxcfNKV3b8jnN4
 kUyIM29D8e7sfp2IgLA==
X-Proofpoint-GUID: syZyS1dIbRQ_cpqfNH9PMJfWhqQsNMhi
X-Proofpoint-ORIG-GUID: syZyS1dIbRQ_cpqfNH9PMJfWhqQsNMhi
X-Authority-Analysis: v=2.4 cv=fLMJG5ae c=1 sm=1 tr=0 ts=6a16b938 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=YG64nluAAAAA:20 a=L2ds4eLAk9dUaZRLGA8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22 a=bA3UWDv6hWIuX7UZL3qL:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_01,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605270090



On 5/27/2026 5:24 PM, Can Guo wrote:
>
>
> On 5/27/2026 5:15 PM, Manivannan Sadhasivam wrote:
>> On Wed, May 27, 2026 at 04:51:04PM +0800, Can Guo wrote:
>>> Hi Mani,
>>>
>>> On 5/23/2026 10:14 PM, Manivannan Sadhasivam wrote:
>>>> On Sat, May 23, 2026 at 06:47:10AM -0700, Can Guo wrote:
>>>>> UFS v5.0/UFSHCI v5.0 add HS-G6 support (46.6 Gbps/lane) via UniPro 
>>>>> v3.0
>>>>> and M-PHY v6.0. In these specs, TX Equalization is defined for all 
>>>>> High
>>>>> Speed Gears (not only HS-G6) to compensate channel loss and 
>>>>> improve signal
>>>>> integrity at high speed operation.
>>>>>
>>>>> For HS-G6, M-PHY uses PAM4 1b1b line coding, Pre-Coding may also be
>>>>> required depending on channel characteristics.
>>>>>
>>>>> Add vendor-neutral DT patternProperties:
>>>>> txeq-settings-g[1-6]
>>>>>
>>>>> Each property is a uint32 array of per-lane tuples:
>>>>> (PreShoot, DeEmphasis, PrecodeEn)
>>>>>
>>>> I don't think combining all EQ settings (PreShoot, DeEmphasis, 
>>>> PrecodeEn) in a
>>>> single property as opaque tuples is the right approach. These are 
>>>> three
>>>> semantically distinct parameters with independent value ranges. So 
>>>> packing
>>>> them into a uint32 array makes validation impossible in the schema.
>>>>
>>>> AFACIS, PrecodeEn is applicable only to HS-G6 (PAM4), but the proposed
>>>> patternProperties forces it into G1-G5 tuples as well, which is 
>>>> semantically
>>>> wrong.
>>> Point taken for the PrecodeEn.
>>>> PCIe binding defines one property per data rate for EQ presets:
>>>> https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/pci/pci-bus-common.yaml#L193 
>>>>
>>>>
>>>> Similarly, UFS should define one property per gear per (like, 
>>>> txeq-preshoot-g6,
>>>> txeq-deemphasis-g6, txeq-precode-enable-g6,...) rather than 
>>>> clubbing everything
>>>> into opaque tuples.
>>> Thanks for the suggestion. I will go with below approach:
>>>
>>> txeq-preshoot-g6 = <Host Lane 0 PreShoot, Device Lane 0 PreShoot, 
>>> Host Lane
>>> 1 PreShoot, Device Lane 1 PreShoot>;
>>> txeq-deemphasis-g6 = <Host Lane 0 DeEmphasis, Device Lane 0 
>>> DeEmphasis, Host
>>> Lane 1 DeEmphasis, Device Lane 1 DeEmphasis>;
>>> txeq-precode-en-g6 = <Host Lane 0 PrecodeEn, Device Lane 0 
>>> PrecodeEn, Host
>>> Lane 1 PrecodeEn, Device Lane 1 PrecodeEn>;
>>>
>> How about encoding Host and Device values in a single tuple. Like,
>>
>>     txeq-preshoot-g6 = <Lane_0 Host_PreShoot Device_PreShoot>, <Lane 
>> 1...>,
> Man, I don't like that way to be honest, it took me a few minutes to 
> understand it on the PCIe side...
>
> Let's go with my approach please...
I misunderstood your point. I thought you meant the 0x5555 vs 0x55 
stuffs in PCIe side.
I am OK to go with single tuple approach as you suggested, which is more 
readable.

Thanks,
Can Guo.
> Thanks,
> Can Guo.
>>
>> - Mani
>>
>

