Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569882FABFE
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 11:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936763; cv=none; b=jItC21r6Fx0ufMhHWwvy7fqg0yn5D/ItgS9KkHNNNUtvsRJbYLJqVFpHf0gbrvPeRl1P9rlC9GcOy2KGH643srqs0Eee8U9begt4hOkciOzrEKlWFVlrTbEwk636XZgMSw7XxKXkF8xnCiR2G/ADiO7ccDTNT1tSaBZH7x+mRQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936763; c=relaxed/simple;
	bh=BrOH+KcMwf/4Z7+srHs9vRripsew+HPQoXsssvWqnNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HGZ6KfUw17oe37nwHxCxR9Sl2Jpd3MLA2bL6jsoiY0s854WmOJAJN5E3NwIMazfgmhd2VKNhOMBZ34M0CaaAZ8gdmXAWPYot4oXD1A5lYeYNPZM6XLxvkyQ4b/+gB1Vcotk+V4ymeTt1Wy4tsLlHXdIhNH2km0tpJGj+UvU6R2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MYAEBRaF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MYAEBRaF"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F8FfSd014033
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 11:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Yc/EdeTsapZAIKdxQSsdsqo8W7xeyLArRmYWMpRhLgI=; b=MYAEBRaFPe9kOt8a
	dawDB/vuw9Ht4Ok6tk4vv0Fmoz4sY6DA65qFAIHMopmwqD6QW5fntBxLagnC4iv6
	Ri2Mea+gZC2QIeZk7DFi4G1jslZZNPeSDrAp95+RCDPeZ1VEQ6sukDEDNC4Mj3rx
	An63bsNplrbb/P33nSok3tTc2zL6R26pu0Uax0hg9y5zSonJv1D75yRh490plww1
	UWkTv7A/Qt4/Lp7nkgmAd3LmLDhpRVD6dVEu4cr8OOiJNEEtpqU2QX8wNiKDANrS
	F8hKciBykwEuIuo5+tuzp09wdyo90Vnv8J+2Wd2upe4AGa2oNPpvqvi+XC8j7546
	O0f42Q==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 494wyr4ypx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 11:45:59 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b522037281bso2847450a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 04:45:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757936758; x=1758541558;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yc/EdeTsapZAIKdxQSsdsqo8W7xeyLArRmYWMpRhLgI=;
        b=KkT9xmwWOl0FUg4bcWHkUw/CtOxIPC3CAT0ZL4pVswQFdeQxwHDDsWd35n+4QVxxOa
         GHYysb8julcNwZItV8SGi8/SGoGWIVb4kN9X7i7neqrczXHxEZ9qr30RgigWbWirc+pY
         +zV1Myslq1X5Hd/P1zydCdKd7xVXPbddOnXlMUWV/ReQrpp5IPENCoLJCmjoCt1oTOdu
         o2Si60TzlsAoFLrZCFbNAASWKkaE3LkJ9eBoUWee5HHRKVGCEbcXt4xp4hANo/PvdfYM
         FHngFTCm25ellExrKhF6Wn4dzbGyUrOHgxrW2zWxdWacu1Td1Kn0uy14EftZUTJ3VfNR
         HLMw==
X-Forwarded-Encrypted: i=1; AJvYcCV/9/WAMigX+LKn1rv2u07ANehDisiewZSbdUgE32h7/KJAg8uAVDqRPWIO0fQ0P/fFLdBSacLGEdjl@vger.kernel.org
X-Gm-Message-State: AOJu0Yyfvi4rQXo55a6Pz94PgODoOiKTI4sQ6LrGAKNh6sFdhh/7hRdE
	u4HkXfIsBkRHnkLYwH6p6ufka3nS1takjpJoovTC6p8b8cPSVDobgItVndH4I4k6l64mtJ8ZHBq
	hiYSuEAcq1YnB3nPEbamueMFJhOksj563/7wn/NYhjteQ7/HCAtX87W6wl8zkm9qL
X-Gm-Gg: ASbGncsy/pGpvfV4Fi9B1mRlpACRW6KaU8e4reYfPfD3+ST8ACTqlzIxMJMxqf5uBIV
	GnCvZmVLzoe+F0uZeWeDjGeI+VXWvBPBvGTObWPR6CU66viCtPitfPz22xh6gn8MDIcY5VgEmSt
	gT8iGcsDBIzwfNDNexLKk1EosLWtTAtQUaLBgEQvS50n3VD6nJR8ssLyrlQFTCkLmEOm3MxxQjO
	+WZq9CU5lyGUWGErttyrWtLYn3f3yB91QOHjnSrB7d8jHjwo2ZALyUKfSvj4h009FSOekXH90eu
	GWyODhQ5nttqGVTChZBg1GYhnCi9uYwQDPCEHxVosF274s+x/sjaeH+YiAUIlTQq33YKWULGoji
	k5CpinFrEN02lmiTaDXIrHNW6idUJaw==
X-Received: by 2002:a05:6a20:258b:b0:252:fbd4:630c with SMTP id adf61e73a8af0-2602d00eca0mr15922320637.52.1757936757964;
        Mon, 15 Sep 2025 04:45:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1+MjVkOmvS+r+M9ltPuOloFpakiq2fFlYI2EREj0x5+CbeV4GyC8RJBbCrDtnWLdep/CZ7w==
X-Received: by 2002:a05:6a20:258b:b0:252:fbd4:630c with SMTP id adf61e73a8af0-2602d00eca0mr15922270637.52.1757936757469;
        Mon, 15 Sep 2025 04:45:57 -0700 (PDT)
Received: from [10.133.33.70] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7761853866bsm9648737b3a.95.2025.09.15.04.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 04:45:57 -0700 (PDT)
Message-ID: <796b89f2-281d-4602-8351-4ab00b131c39@oss.qualcomm.com>
Date: Mon, 15 Sep 2025 19:45:50 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
To: Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, tanghuan@vivo.com, liu.song13@zte.com.cn,
        quic_nguyenb@quicinc.com, viro@zeniv.linux.org.uk, huobean@gmail.com,
        adrian.hunter@intel.com, can.guo@oss.qualcomm.com, ebiggers@kernel.org,
        neil.armstrong@linaro.org, angelogioacchino.delregno@collabora.com,
        quic_narepall@quicinc.com, quic_mnaresh@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, ziqi.chen@oss.qualcomm.com,
        zhongqiu.han@oss.qualcomm.com
References: <20250902074829.657343-1-zhongqiu.han@oss.qualcomm.com>
 <4b970683-bc36-4dc2-a404-e1440da83ae7@acm.org>
Content-Language: en-US
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
In-Reply-To: <4b970683-bc36-4dc2-a404-e1440da83ae7@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Ee_oW0hRbvB4Fmqstv0c5zGwscs7cu2q
X-Authority-Analysis: v=2.4 cv=SouQ6OO0 c=1 sm=1 tr=0 ts=68c7fc77 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=9Xt4y-262ZfalKxfTLgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMCBTYWx0ZWRfX6Jn5gzspoaeY
 ORsVHAsWWndfUvBHFRJUGy2DKPfOO+z8UBzUVX2bzHzd2nAdBtvrhX4Sunx1ZGGls41FIt8hS8b
 tm5yssLsnFHLxGHCr7z0Bfay0qc/i7ybO17ftBr6rUX3NWH3TJ/8QPR4c1nrH21j6ab0r1kcmHC
 nDlzdC+A9gEjbBSdvJUBy+UWTNADy0DuJ/SOfo8eb3UExGYiMse0AXfnmj6jchwo/VrVgFEGHtL
 fCHScFfmEZisfMQA9CNGurOMxnyWCGXew6TorsTvUvYdye9517FanwyfUZMarxvzEr0iwr9zATt
 F4jR/Hk1ZRNBl2zVRRHT+4TLNASp9rL+HF+fOAAmGLsr7lQOCASMg54EUNZ41jnzYPY8kTrU70s
 gFyhc811
X-Proofpoint-GUID: Ee_oW0hRbvB4Fmqstv0c5zGwscs7cu2q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130000

On 9/13/2025 12:22 AM, Bart Van Assche wrote:
> On 9/2/25 12:48 AM, Zhongqiu Han wrote:
>> -    return sysfs_emit(buf, "%d\n", hba->pm_qos_enabled);
>> +    return sysfs_emit(buf, "%d\n", READ_ONCE(hba->pm_qos_enabled));
> 
> Using READ_ONCE() here is inconsistent since none of the modifications
> of hba->pm_qos_enabled use WRITE_ONCE(). Protecting hba->pm_qos_enabled
> modifications with a mutex is not sufficient since the above read of
> hba->pm_qos_enabled is not protected by the same mutex.
> 
> Has it been considered to leave out the READ_ONCE() from the above code
> and instead to add the following above the sysfs_emit() call?
> 
> guard(mutex)(&hba->pm_qos_mutex);
> 

Hi Bart,
Thanks for your review~

Yes, in this case pm_qos_enabled is a status bit indicating whether PM
QoS is enabled, rather than a constantly changing statistical value
(such as IRQ count) that users can tolerate. Users may rely on it to
determine whether PM QoS is enabled, and thereby assess whether current
performance meets expectations or decide to enable/disable PM QoS.
Protection is indeed necessary here.

I will use guard(mutex)(&hba->pm_qos_mutex);
in the V3 to make the modification.

>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 926650412eaa..98b9ce583386 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -1047,14 +1047,19 @@ EXPORT_SYMBOL_GPL(ufshcd_is_hba_active);
>>    */
>>   void ufshcd_pm_qos_init(struct ufs_hba *hba)
>>   {
>> +    mutex_lock(&hba->pm_qos_mutex);
>> -    if (hba->pm_qos_enabled)
>> +    if (hba->pm_qos_enabled) {
>> +        mutex_unlock(&hba->pm_qos_mutex);
>>           return;
>> +    }
>>       cpu_latency_qos_add_request(&hba->pm_qos_req, 
>> PM_QOS_DEFAULT_VALUE);
>>       if (cpu_latency_qos_request_active(&hba->pm_qos_req))
>>           hba->pm_qos_enabled = true;
>> +
>> +    mutex_unlock(&hba->pm_qos_mutex);
>>   }
> 
> Please make the above code easier to review by using
> guard(mutex)(&hba->pm_qos_mutex) instead of explicit mutex_lock() and
> mutex_unlock() calls.

Sure, I’ll make the change.

> 
>> @@ -1063,11 +1068,16 @@ void ufshcd_pm_qos_init(struct ufs_hba *hba)
>>    */
>>   void ufshcd_pm_qos_exit(struct ufs_hba *hba)
>>   {
>> -    if (!hba->pm_qos_enabled)
>> +    mutex_lock(&hba->pm_qos_mutex);
>> +
>> +    if (!hba->pm_qos_enabled) {
>> +        mutex_unlock(&hba->pm_qos_mutex);
>>           return;
>> +    }
>>       cpu_latency_qos_remove_request(&hba->pm_qos_req);
>>       hba->pm_qos_enabled = false;
>> +    mutex_unlock(&hba->pm_qos_mutex);
>>   }
> 
> Same comment here: please make the above code easier to review by using
> guard(mutex)(&hba->pm_qos_mutex) instead of explicit mutex_lock() and
> mutex_unlock() calls.

Acked, I’ll make the change.


> 
>> @@ -1077,10 +1087,15 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
>>    */
>>   static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
>>   {
>> -    if (!hba->pm_qos_enabled)
>> +    mutex_lock(&hba->pm_qos_mutex);
>> +
>> +    if (!hba->pm_qos_enabled) {
>> +        mutex_unlock(&hba->pm_qos_mutex);
>>           return;
>> +    }
>>       cpu_latency_qos_update_request(&hba->pm_qos_req, on ? 0 : 
>> PM_QOS_DEFAULT_VALUE);
>> +    mutex_unlock(&hba->pm_qos_mutex);
>>   }
> 
> Also in the above code, please use the guard()() macro instead of
> explicit mutex_lock() and mutex_unlock() calls.

Acked, will make the change as well.

> 
> Thanks,
> 
> Bart.


-- 
Thx and BRs,
Zhongqiu Han
