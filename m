Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFC61922EF
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 08:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730882918; cv=none; b=nJ0Ldd8Lgq/KejQ7+7MS5nXcW9kU1RZtP12CPIp967vv4uk9wvMsW7MdWziJ88WXWo8YiznZHHKOZw4tslc5S8S6T4Zr5KAlJoS3+rK4k+rL8O+/jzL63g3prPVs/zoaGQDMWFUHKTNf7yvA2s75+5PW0/EOJB6NiLoJIYywROc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730882918; c=relaxed/simple;
	bh=oXLeB7HBzhxzJfBeoFpJBTOlyzDf2LRJ/KSN7bUL4wY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=haFpq+hp0OEAaYpuG6ksiTdvC6De5LUQut/DBJsmc+g3P9avAz/dAzRJ1HSV3FEPPgvcDBR6jB6FEpR+jZsDl/ssQ38pxuj+WcZzEMYDvVA7WzoflanL2t0z1qNh7ZLl7xBDUov6YyujfYgLqb/wcg3UEqMu1G14jZqDlnDq04A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c4i+AwVV; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c4i+AwVV"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539ee1acb86so6518080e87.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2024 00:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730882914; x=1731487714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+DHea6qNka5zu5kUvVTVEMpfukRwKxo/tAWy5PjttvM=;
        b=c4i+AwVVmcAyLNrqqa+mAc+gbIYq8TXO36CRvTDDEYcKmTx27n10QGEjFTdq4rWVpj
         1mOCKEzN2y1PG2xAG1F2z5ECB/NkoVpsRpo+Dis60pUCFK5urjc4VbrHPZNMCkD+DEHc
         V8TFi7mEs8oray09+r2fpK2X18hhtRpv+9HN0VEf0/BGL0c73n/D1zg5Gxyb741OsRab
         vkcqPwGsN8strsfG0qZquvtbt4yniCJ7wIGzJOalVG2N/ar0K67KxBU+rOxHcqTEs4ED
         inXBvbdWJlku2yk5p3RH40hALZGO9hWExsfTu5pkOzfL/fDWwvdc0HTevU+kwurlGUlU
         I5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730882914; x=1731487714;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+DHea6qNka5zu5kUvVTVEMpfukRwKxo/tAWy5PjttvM=;
        b=vpTTnsuhCZOfo8QjF+IfbHbiN0BrZpA4pLIP0S/Wb6xFr6wqvmX7jW5YwXBzYras2L
         excpZzf93HKOO603dBBsUpdTxFzhaH2hVTkjAd66Z0nxppVmwpOTAVmGyK/WsCmbKPun
         eEdijGizxY3vvDaOlAe+CmbdN5DSSsGQnlPevsYIIDXNrXqBIyiV7FQ819WWOXCzA5Ij
         fhAQmq33ifjg4zk8KNSDprnfdb27MK8jaJ++FlGqmAo01pkb5/12Z36G7Ls+bi78U86g
         +6RrRraMkFsAIoxL9SE/HHSs3frQcopMzy+6zZawo6OuWDz/Xbs5cFL3NPgbIcKl0uWb
         Uzwg==
X-Gm-Message-State: AOJu0YzI55+G8F1w1UxuzGTfnbAporwRwVMXMkWUk0ZToCfqHIfG2oHy
	s3CPc95NgaE33JhRjM7XJuRXP1WZzbrmmKrVxeei2+gwfNyEvJmqTxNF+Jafm+aJ5DKjPy/27Q2
	KEws=
X-Google-Smtp-Source: AGHT+IEYKijIdYAqMBfmJ2ZA/aojqnqd2g/8XrU9iAq35/fePCQ5icXIlBSY2GfjaEW384vphmJK8w==
X-Received: by 2002:a05:6512:3d2a:b0:536:54c2:fb83 with SMTP id 2adb3069b0e04-53d65df7681mr9357815e87.23.1730882914219;
        Wed, 06 Nov 2024 00:48:34 -0800 (PST)
Received: from [192.168.8.141] ([89.101.134.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432aa737c86sm14561945e9.38.2024.11.06.00.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 00:48:33 -0800 (PST)
Message-ID: <b9263930-4448-4f96-94e3-ee5241490f54@linaro.org>
Date: Wed, 6 Nov 2024 09:48:33 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v6 11/11] scsi: ufs: core: Move code out of an
 if-statement
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20241016201249.2256266-1-bvanassche@acm.org>
 <20241016201249.2256266-12-bvanassche@acm.org>
 <0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org>
 <afaca557-6b7f-4f48-a38a-19eca725282f@acm.org>
 <19b75e1d-bc36-494d-a33a-d36a1646bcc7@linaro.org>
 <6b20595d-c7f6-42aa-922e-3671abd7917c@acm.org>
 <1c9acc01-7b1d-41ac-a0da-4e50dc8f0319@acm.org>
Content-Language: en-US, fr
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro
In-Reply-To: <1c9acc01-7b1d-41ac-a0da-4e50dc8f0319@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 05/11/2024 23:01, Bart Van Assche wrote:
> On 10/31/24 2:15 PM, Bart Van Assche wrote:
>> On 10/31/24 12:55 PM, Neil Armstrong wrote:
>>> Le 31/10/2024 à 18:51, Bart Van Assche a écrit :
>>>> Is the patch below sufficient to fix both issues?
>>>
>>> Yes it does!
>>
>> Thank you for having tested this patch quickly. Would it be possible
>> to test whether the patch below also fixes the reported boot failure?
>> I think the patch below is a better fix.
>>
>> Thanks,
>>
>> Bart.
>>
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index a5a0646bb80a..3b592492e152 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -874,7 +874,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
>>       if (host->hw_ver.major > 0x3)
>>           hba->quirks |= UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
>>
>> -    if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc"))
>> +    if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc") ||
>> +        of_device_is_compatible(hba->dev->of_node, "qcom,sm8650-ufshc"))
>>           hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
>>   }
> 
> (replying to my own email)
> 
> Can anyone who has access to a Qualcomm SM8650 Platform please help with
> testing the above patch on top of linux-next?

Sorry I was traveling and I forgot about it, I'll try to test this today.

Neil

> 
> Thanks,
> 
> Bart.

