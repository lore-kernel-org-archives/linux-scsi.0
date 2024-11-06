Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173C71DD0C9
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 09:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887078; cv=none; b=OkvJ/qSRB/u10wdLIu4lrM18hWGWVt7e0Zer2wb5Xxfyr3HnM+xJlGW4pA0VKKJPxVeaYXPwXx+9V5vMGmllYUIV1HYju0iHt0JRTjYEsqTC+2FuU698iJIM8n+UUng4dyj1xomJqF9gNxTHW8dn70nLZGUhxUdOqQVQB0LUcz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887078; c=relaxed/simple;
	bh=GrEQs+Mvm8eZUvYF7xkFtXg22qgSfS9+w5/CpzjUSfI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=GJvnKwb8JPTRhD+GZzW98VEbQE+StrMleGLuUh2cnPo0LqHICMTbKJ72QwXAsHFvYfKykxwnzeaeZlcuus4quTHqPHGOaCvdE8Camjr+hPe/Zmm8K/ITTKngj00/jzdQ3ISHt0G1kLUhVLUN4XH3FW9Y9ws7H7qP/TzpDrQYYxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=exISflq8; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="exISflq8"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539f0f9ee49so7394207e87.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Nov 2024 01:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730887074; x=1731491874; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rst+mqVu3MLq874rD+/4acNC43emUZz7QJpezvdmPm8=;
        b=exISflq8iPkBERC9mtGKN3ccGw5/x+PW3XFvv3VRdh5gTN7KAfsLv71C973sGM7qUc
         sr/jwQTCv8FodGaKS+80ECrA0Rg4LEob0fh+HBPeBiveaqAin+L2nyWSl7/3Uud+EAVY
         aQJPJER/PDNyRyAHu+8j1wwkz+pV43XoD6uO9ZCmiQE1MTssi7D1GMXnqOTtlcC0qcbk
         MUOxN5ySZoifkbLpgkJrPXM4IHRFG/i57XEu/p42/4eSUhqLCpdnl5U650csjbn6N1rQ
         xGdWalA4618dzKcPRNGEsuGrJ3RechqQwqTRl5jEhEX6bmSKD+WUkz9dJDXxkkE3rwal
         gnMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730887074; x=1731491874;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Rst+mqVu3MLq874rD+/4acNC43emUZz7QJpezvdmPm8=;
        b=AtbM+0+icKhbZPeUqNipN2bkDVBuXuFIgrZste6FZhBaKAX9qDB4PUEWs/b2TeqG2R
         KUR554TCkMtE/Ii7qP6G0wqFF+g+JQM9bu6UD2Ctlsn2kt1dJ/jknN0jpzWc3uB4AvIx
         muYgfXoSeQOADBlH/6GIaME7FczFWJidSPs7vdHv05QWdKWthCbJ1Pfh5NeJnkUEby96
         SeTxKQKgBRa8sgupEFMGSIE+WA6koeg/Sn8G690hitbIEwJaQOjXF1ayNuUhXJTJt7EF
         vNRzW/tMy1cIhM+nO1GsYY6HLN3Iwb1QExvQ2Wr3m/yUk5JYcmopzMaurLyezLrMpeRM
         YhBg==
X-Gm-Message-State: AOJu0YwPklqGZOIsQ+NuD66K4lbPVQBt/e0DFyL1g3E2iSurDV82/6Md
	kMUiaoeI4w9leT9hYgaPyaFzH8zHi+g7H1Oz6DPk5+mfTbNTvib9VEbDV6ltQ3I=
X-Google-Smtp-Source: AGHT+IGPdIPjgwRPzgi31y8GNrxtk1yyF3JFMFCi1WCEorrAxT504D/jMvyiHN7LjHmAionk9tfQQw==
X-Received: by 2002:a05:6512:3087:b0:539:fb49:c47d with SMTP id 2adb3069b0e04-53b348b7bfcmr18249662e87.12.1730887074102;
        Wed, 06 Nov 2024 01:57:54 -0800 (PST)
Received: from [172.16.23.252] ([89.101.134.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432a26a7508sm43622355e9.0.2024.11.06.01.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 01:57:53 -0800 (PST)
Message-ID: <6b37ac2c-e3bd-48d0-bc50-4fa2e5789d3d@linaro.org>
Date: Wed, 6 Nov 2024 10:57:52 +0100
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
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
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

+ Mani

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
> 
> Thanks,
> 
> Bart.

Thanks, it does fix the issue. But it won't scale since the next platforms will
probably need the same tweak in the future.

Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD

Thanks,
Neil
