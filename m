Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7130A2144C5
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 12:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743079672; cv=none; b=C2IFsMKohU6lH7cSJpSZgXhICkrGfoziYvw15fh4gGIYb7IaXVlPg4i8ATLWrMwyx/UTn6Qq6RgDaUtht8Kmoj8SX6T4bwbKEdJ3oRrxUvU8kQO6Er1oeHT5zSVNA7hiHvz3sKGvy8BEFjb8h9Ddb2oNRRp35c15AosmLRvf4oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743079672; c=relaxed/simple;
	bh=tycgOQWwWJbi7HTyc6T2xiJuVmwbFijiHW6hOcGcs3c=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Bp9QptajJRaDtv0QCHr2v3JCdz9kzPKCSml6feGjbrABaqt/lUAR/eF4ZVTgY9eaeWuCcLIyKsVBtOn0auiLife7mag8trvuwqNdRdBPw89FWQ2c17fAZpjSkgHDmoZG2CqwH0UKotz4QU5UK4q4BftUKABXaYVKV8qRbBxzpQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZsitrB2t; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZsitrB2t"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3996af42857so1327141f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 05:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743079669; x=1743684469; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nrhZhK2vDq2GLpC5AXkPOJNIZAgprokk9oQOGjga9nQ=;
        b=ZsitrB2tocBSgyIgY9s/XNEs3xztFn5hc40l6x8pkyOsGnJ/lJAZy/g1iQqgHiruQ2
         kVCWUSTCiggSLgmhC+iRvMNZPlp+1xzF4bi9S+a2unAMo/Ls2jWdDOuRpNJ0MCWrVMpP
         +d4OUhCONbVuMKina4HIIp8CqTexa3RRJHv2JA/DuWFCrp88fIIzPs8w+OGRxJXZlvbT
         xAt1yOCd1lmQNQG8vLgP9jfDZtNMNkJbsBKAgaixhxo6iUFSz6266kU2TPnuM8EqRPfr
         GLoyLX75M649yqhe1lnvkSLs+8SK7IETs/mr6g2cx/Hjb6vcgRQP/Ku/mkZGR77lIUel
         4w6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743079669; x=1743684469;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nrhZhK2vDq2GLpC5AXkPOJNIZAgprokk9oQOGjga9nQ=;
        b=IOX4wSojMSS/4MVJQQiTJaZ/+6cDTyMhYWHfFP4y2R3dF4C3YrsstP7vOw9gVgy0tN
         TcdblI1PVN46TRY/7bqDX8LR2zRM2RHoxfeM69k382EbI9b56cCt5pVDYM3iYThrWcGI
         QRMWTm0UWiwtddjaa6CH97yxsrKzSE4/BBhm0lEd3+N6QcnqAprNwSqbgLZVBHbIB31z
         wRvuae9Qry/GoQ/+9ck8T/hWCPTEAaVVG1EHlYyZorkfm5lr4QVXE5J9hGSrKoqFgUVI
         HYyc0GceCw25ylT5G7Im5ES0cMrwViJJ7fIqcNvprohVAEm9rFL/oFDrMpN/vMe/2YcO
         s7Zg==
X-Forwarded-Encrypted: i=1; AJvYcCWL9Fcro6SLcF7J0KwInfBAiAlNhHULwCeYHzXt25zikBh6UHktUytQPfwI3nzOGvgsCRREsmkqWNgZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo2ii81POe2i0qQ6OGefxlrIE9k1m2Wm+M0/wEWPEyjyfAAMqf
	vqJqNIoPKdK4CZ7YMjmPDCOALrZzXXa92h1gZ6DZbMhJVnTPIF40ndVJqf4CSYw=
X-Gm-Gg: ASbGncvHy06zmxe8U4+oQQgxnhLmo8ouZrmIEiI6AJ4QgNmBq11hYse3GrWOiwU5X4A
	HhT1FiY3XTtwwJDNft72Kz3PViRhKUclBg+xlcpOF8BypY3ZLWSQ//DtreRfF6QF2rYR0eGyas3
	Wj/BW2Sc7g+qrz0PqkqQU0q7N716FfqTujhbJ4yL4Y4P0MMXZEaaGBliskcdqI0eWLC9NOISRsj
	XfYoyZ10LFQBEV2CSR1+V7ebt29MlFo2si45FXTJ075Phvsy8PKP4R2L0BaHgZdWsalbd2Qxrp0
	KxzBNWiF+wXtbkhseQOQUBhZAcedJhyOIiM7CrdtXZHhS4FnHEE8iaylpvNt0LfpNspTgZJL7iD
	l5jSvQajuOTYjD/ANf4V09Q==
X-Google-Smtp-Source: AGHT+IH7vTkD1EpvQ1pnTdIXyT11ZQroNe1bXfZ6Z2W1J3NovHK5NVozVnLU1L6ojpmVJC3grA6ZVw==
X-Received: by 2002:a05:6000:23c9:b0:390:f9e0:f0d0 with SMTP id ffacd0b85a97d-39c099b5d7dmr97829f8f.6.1743079668789;
        Thu, 27 Mar 2025 05:47:48 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:3d9:2080:f1b8:272a:1fa5:f554? ([2a01:e0a:3d9:2080:f1b8:272a:1fa5:f554])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9a6326sm19380815f8f.29.2025.03.27.05.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Mar 2025 05:47:48 -0700 (PDT)
Message-ID: <5be7a006-054d-4275-9c83-2687461028ef@linaro.org>
Date: Thu, 27 Mar 2025 13:47:47 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH RFC v2 2/2] ufs: core: delegate the interrupt service
 routine to a threaded irq handler
To: Bart Van Assche <bvanassche@acm.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250326-topic-ufs-use-threaded-irq-v2-0-7b3e8a5037e6@linaro.org>
 <20250326-topic-ufs-use-threaded-irq-v2-2-7b3e8a5037e6@linaro.org>
 <4a5efc8e-ec61-40c8-9b36-59e185b0fdd5@acm.org>
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
In-Reply-To: <4a5efc8e-ec61-40c8-9b36-59e185b0fdd5@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 27/03/2025 12:56, Bart Van Assche wrote:
> On 3/26/25 4:36 AM, Neil Armstrong wrote:
>  > When MCQ & Interrupt Aggregation are supported, the interrupt
>  > are directly handled in the "hard" interrupt routine to
>  > keep IOPs high since queues handling is done in separate
>  > per-queue interrupt routines.
> 
> The above explanation suggests that I/O completions are handled by the
> modified interrupt handler. This is not necessarily the case. With MCQ,
> I/O completions are either handled by dedicated interrupts or by the
> legacy interrupt handler.

Will update the sentence with that

> 
>> Reported bandwidth is not affected on various tests.
> 
> This kind of patch can only affect command completion latency but not
> the bandwidth, isn't it?

Yes, but on a fully loaded system, it will enhance bandwidth
but with a greater latency, but without eating irq handling time
for other routines.

> 
>> +/**
>> + * ufshcd_intr - Main interrupt service routine
>> + * @irq: irq number
>> + * @__hba: pointer to adapter instance
>> + *
>> + * Return:
>> + *  IRQ_HANDLED     - If interrupt is valid
>> + *  IRQ_WAKE_THREAD - If handling is moved to threaded handled
>> + *  IRQ_NONE        - If invalid interrupt
>> + */
>> +static irqreturn_t ufshcd_intr(int irq, void *__hba)
>> +{
>> +    struct ufs_hba *hba = __hba;
>> +
>> +    /*
>> +     * Move interrupt handling to thread when MCQ is not supported
>> +     * or when Interrupt Aggregation is not supported, leading to
>> +     * potentially longer interrupt handling.
>> +     */
>> +    if (!is_mcq_supported(hba) || !ufshcd_is_intr_aggr_allowed(hba))
>> +        return IRQ_WAKE_THREAD;
>> +
>> +    /* Directly handle interrupts since MCQ handlers does the hard job */
>> +    return ufshcd_sl_intr(hba, ufshcd_readl(hba, REG_INTERRUPT_STATUS) &
>> +                   ufshcd_readl(hba, REG_INTERRUPT_ENABLE));
>> +}
> 
> Where has ufshcd_is_intr_aggr_allowed() been defined? I can't find this
> function.

It's in include/ufs/ufshcd.h

> 
> For the MCQ case, this patch removes the loop from around
> ufshcd_sl_intr() without explaining in the patch description why this change has been made. Please explain all changes in the patch
> description.

Ack will update explaining this change.

Thanks,
Neil

> 
> Thanks,
> 
> Bart.

