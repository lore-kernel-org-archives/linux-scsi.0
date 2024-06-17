Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C091E185E74
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 17:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718645876; cv=none; b=McIxfhZyzzdSsg3i0u/2bCYP5sGxogkSiVx6ANwLwKstMnSPIlJr8AhkfCrLaIscze8fvb1jjYQ86Nu83Vh6FpKDzc0+h5omn0r2QgP1tVNR0J20pSY3AjdSs7u5JD1mlLWrZeQWbtWeTw+ojsSuM1I1T6ZGTRYDH3ws15Kfw50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718645876; c=relaxed/simple;
	bh=aolkxKvRvPIVJ5LETI4Hrnp8zx+LOBl01iPVxlavPkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MHaqg4QiMZAuLMbncHwsec27COJMIZt7D1uLw/bgOJedRgUzEwvMd+GjnNaiPHH+Q1Cc2BrJSC3ENUhHjEUtf0OV5eCUjxJYzA9Ft8DryUwm25fSSRtQcd1s44gJjsm3w8WJiP45aa+EKmJVm6+LTzLygArJtu/sT0XNQ3oUXDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Mm8f18AC; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Mm8f18AC"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52bc27cfb14so5771351e87.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 10:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718645873; x=1719250673; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZR/Rb5xAaQGOJ5DS10l+hrvLr7O7vUYtHmk4lXMtiMo=;
        b=Mm8f18ACJ+fDlXRc3DkfZIEWdg3ZYZ9SKjtokGYHotWlI5RAoKKA71ZfL5zFxpv5vi
         jEBrZR+LvWygkHD9igWHVlg50EVaHqPRNJdA97hMb+AY5lTqzZTB1Oa9Am2rmR8XbZbc
         ZMjnvTBXvAm8VDGYEkDD9BfSvOnFQ5+K+/0qkkisOIW3lWClJkozihAcGuexzMPab/R0
         B9AgfjYSCaOzECR5JgOeHMNVRGcWDhuuRg8uQmnhYsZevzGFCYsXqgwtgxGrsJ7R9Dps
         wzUwDyLUJhj/fFqUpf4zgyJMOc5VD7rUXZ0d4zS8j288u52tVetdTEFb9PcbHvTnK1r0
         3vTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718645873; x=1719250673;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZR/Rb5xAaQGOJ5DS10l+hrvLr7O7vUYtHmk4lXMtiMo=;
        b=Qk/fhjHx+cRGIgOvsOZcyP1r5/Bwz7dqTlIL8yowo0dsqENyVPkE8kDEPH09bA4vbU
         /Nhcn/ZoAG7hQNHl1ecabBfaDOjSkrOijnrY2c7pkm7+WF0v+CPy7mD7EdXL5hohDgBj
         G0ZUVuD5cspA/z1S8tW0E5H8S5EDAX0XaQv4EKWvMbalF3nrO5+Wb0bsuswxdt637yLx
         Ji4R4v7G8hPOpWBJfDa6+0kTw4ZKTTXv+t6L7y6nICnTzFSjZUuCQp6WqBzeBlbDWm2t
         LO6Uv16djUep0svaUcefIFRQbHSiWDvfEAhJWPAalttXzDWIFdvzSKQKlBk3JaOBd3+A
         7wFg==
X-Forwarded-Encrypted: i=1; AJvYcCUJ+hBwCKtEfAlLSnSlypTkeKcBJKapXS8UVy6uQ82rPmZYUSs0Os2/bFp1Hrj2hT4UXuN+3ahttOsW+xyCO4YjYie/fFd66kid7A==
X-Gm-Message-State: AOJu0YyniLxms+HwnufRg56nezXW0HefUMw0YVeOMOVmNH2eXLl95UMu
	yxXqgoZq71Z6qZK3xNMv/2JY2DKOalezDMibw30l3a0Vdja2fRUuMTBjlq0UYoM=
X-Google-Smtp-Source: AGHT+IGar7uh7/qvCi73QxBJXZ6s6MZ9h6S2JVkmR8/klBJePWGXzGItSfkyV9Oe+VUxofwGJiqlyg==
X-Received: by 2002:a05:6512:616:b0:52c:c97:b591 with SMTP id 2adb3069b0e04-52ca6e6e321mr6501823e87.32.1718645872896;
        Mon, 17 Jun 2024 10:37:52 -0700 (PDT)
Received: from ?IPV6:2a00:f41:cb2:a9df:20fa:cfbe:9ea6:1fe8? ([2a00:f41:cb2:a9df:20fa:cfbe:9ea6:1fe8])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52cc1fb481asm60273e87.82.2024.06.17.10.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 10:37:52 -0700 (PDT)
Message-ID: <fab4cf38-d3b8-421d-a610-b16aad7670db@linaro.org>
Date: Mon, 17 Jun 2024 19:37:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/15] ufs: core: add support to derive software secret
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>,
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 andersson@kernel.org, ebiggers@google.com, neil.armstrong@linaro.org,
 srinivas.kandagatla@linaro.org, krzysztof.kozlowski+dt@linaro.org,
 conor+dt@kernel.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
 kernel@quicinc.com, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, quic_omprsing@quicinc.com,
 quic_nguyenb@quicinc.com, bartosz.golaszewski@linaro.org,
 ulf.hansson@linaro.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
 mani@kernel.org, davem@davemloft.net, herbert@gondor.apana.org.au,
 psodagud@quicinc.com, quic_apurupa@quicinc.com, sonalg@quicinc.com
References: <20240617005825.1443206-1-quic_gaurkash@quicinc.com>
 <20240617005825.1443206-9-quic_gaurkash@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20240617005825.1443206-9-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/17/24 02:51, Gaurav Kashyap wrote:
> Block crypto allows storage controllers like UFS to
> register an op derive a software secret from wrapped
> keys added to the kernel.
> 
> Wrapped keys in most cases will have vendor specific
> implementations, which means this op would need to have
> a corresponding UFS variant op.
> This change adds hooks in UFS core to support this variant
> ops and tie them to the blk crypto op.
> 
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>   drivers/ufs/core/ufshcd-crypto.c | 15 +++++++++++++++
>   include/ufs/ufshcd.h             |  4 ++++
>   2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
> index 399b55d67b3b..c14800eac1ff 100644
> --- a/drivers/ufs/core/ufshcd-crypto.c
> +++ b/drivers/ufs/core/ufshcd-crypto.c
> @@ -119,6 +119,20 @@ static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
>   	return ufshcd_clear_keyslot(hba, slot);
>   }
>   
> +static int ufshcd_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
> +					  const u8 wkey[], size_t wkey_size,
> +					  u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
> +{
> +	struct ufs_hba *hba =
> +		container_of(profile, struct ufs_hba, crypto_profile);
> +
> +	if (hba->vops && hba->vops->derive_sw_secret)
> +		return  hba->vops->derive_sw_secret(hba, wkey, wkey_size,

Double space

Konrad
