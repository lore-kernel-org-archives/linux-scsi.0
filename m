Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6CD1ACED3
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 09:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737019740; cv=none; b=SCkyonLf2GlIl9sk9n0cQciB0vUfo88Hzvk4TZIzDtT7buC8xQ0zGuCKm37Nn3urj5ypq923ziDZaqufL6rg3hlwXtLJbpd1wWKepceSSmH/QMdK8f85tUp5alqN8iUtD5PIzSwr4lT5WWOXiUrGn7sgWETeBKvJ6qiTz+3lVSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737019740; c=relaxed/simple;
	bh=tRjrbGPxuG+NrM4V4zHYmwA97wvVac7mf6ErxdzeyY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E/KszmbL0K4FmdRXW+nyKb/092bAJdCtatYys7mOpE7RVhFNXugzfUjd0fGxd17/oOo7xBt3ak0j/1qHsWVch/gXiuIs9t8srtl7sbxiHHG4iE893hIcpGsm74+BMZP7MIQJgsx0yeo9LXVdV0JaqoqDRWu+VebRZAqQsWfolw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H1Irv5Oi; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H1Irv5Oi"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-436ce2ab251so3756295e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 01:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737019737; x=1737624537; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :reply-to:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z2ao+rKhy2rrFNzC5Hk6CZpJrkvTuzh6Wda4P8nTqpU=;
        b=H1Irv5OizvAlDcSWxCsjc7vOqSmVC+9G43h9sfp8HdI2dkNr2YeOTyg54AT10j/ciP
         h+UZikGkvnkebJHXE9sSJGCVQ7J1EOXqFiYNzBdo9OdxJgkezv8k5HoxMupSoJEOFNUI
         OMMkCe8AEgXGck4q3ivwGHc5ccH2A9X2osFK9tt8jt3RMZ4Wfl6TVC2ojTqtbrISjGzH
         N5y0LX6871PMzvmyE4E0iHhkvaRx5rBe4yghCZOSIlDjsrcCoy81E0omtyh1j3zN1ho/
         rCn2MrzoG6uB7EUmnJ1wKw5yp/QFQmLFaoWyzZG+L7vxzxOouuA2zCOxc5b96lXXAFSQ
         4tJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737019737; x=1737624537;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :reply-to:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z2ao+rKhy2rrFNzC5Hk6CZpJrkvTuzh6Wda4P8nTqpU=;
        b=tMZg3xGdugxLWMbl+aT5IIhZ1s28hy0tFfAOhL6pRZEe8NkVM/GND6nepVuTHL5iBq
         p6TW7OvhyH98Zt67SWS4f1+HRSZp0CcElZUAPMu67S60jid3z/8vSPzcXSSR0M0HShqy
         Trd7UJzsloIbdPSiyYRL0iL6G3okeECeDXwR0t0rV9Duvuvy02hb7SQ3iVMojDgQ6J73
         Ikj3FOFCF4LjBTp5gvkUEO6pr7OxdeKo+wCOV+SQJD7O9+ZgsiDgPEoIcTDvSfn/z2nT
         9REyPIPPybTZd3dxXVV87w/JzbD0qj3OL+thWJFpJVzn0XRSy0LrGFFCsLfeVVjIHcAN
         ldFA==
X-Gm-Message-State: AOJu0Yyca1sY+yy9ttTSLrCutluUbXnbkECsrmnT7msX9yM1QNVfZApM
	GvDNVaYZXIyrYl+Ij43k95GQ4nlnTevl602VQDGiANuFjzLQs/JI0o2ieSQBmQc=
X-Gm-Gg: ASbGncvwzSm64psdSMubJHKfvZtrCqDD7GmWaXJ7JGSeLTv5uHi44y3VRrEccbr/08H
	S5VSAZCxw9jVlbAky2WtSv6KotLdGVHb4l+t/vupHSfO+c4MnjQKZoklS6OmEGFm4y7951hoo+S
	vFU1QLrzVeINfxGpMogo4p+OEgmg5vFrbCb1pnSeT475uBmTM8WXjVocKKWNCNc98+vDI5ZdaO5
	lc40M1c53JxfyQZ307Zs09tII0xTFhtetr9RMr0WK3iEAbwuMXs+lRq4NS26k1Uy5G/+VxBkA+c
	QtvjnFPCFJP2VQQUvFfY4c9OnBo84Jo=
X-Google-Smtp-Source: AGHT+IHdmWN7Oeq0S+zEiZuKe5KeBcQ85jvcioqfybqbDRFTq5jmeJjyGwdZonKpDmR4f3lwPMFpRg==
X-Received: by 2002:a05:600c:a08b:b0:431:5863:4240 with SMTP id 5b1f17b1804b1-436e26dda73mr251928715e9.24.1737019737060;
        Thu, 16 Jan 2025 01:28:57 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:69b:c51f:3072:d4f5? ([2a01:e0a:982:cbb0:69b:c51f:3072:d4f5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74e5e69sm51988535e9.37.2025.01.16.01.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 01:28:56 -0800 (PST)
Message-ID: <92b2f271-34dc-4560-a96c-bdd372d5e3d6@linaro.org>
Date: Thu, 16 Jan 2025 10:28:55 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Support Multi-frequency scale for UFS
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_cang@quicinc.com,
 bvanassche@acm.org, mani@kernel.org, beanhuo@micron.com,
 avri.altman@wdc.com, junwoo80.lee@samsung.com, martin.petersen@oracle.com,
 quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
 quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "open list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-kernel@vger.kernel.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
Content-Language: en-US, fr
Reply-To: neil.armstrong@linaro.org
From: Neil Armstrong <neil.armstrong@linaro.org>
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
In-Reply-To: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

[+linux-arm-msm@vger.kernel.org]

On 16/01/2025 10:11, Ziqi Chen wrote:
> With OPP V2 enabled, devfreq can scale clocks amongst multiple frequency
> plans. However, the gear speed is only toggled between min and max during
> clock scaling. Enable multi-level gear scaling by mapping clock frequencies
> to gear speeds, so that when devfreq scales clock frequencies we can put
> the UFS link at the appropraite gear speeds accordingly.
> 
> This series has been tested on below platforms -
> SM8650 + UFS3.1

Which board did you use ? the MTP ?

> SM8750 + UFS4.0

Did you alse test it on SM8550 ? this platform is also concerned.
And perhaps SM8450 should be also converted to the OPP table & tested.

Please Cc linux-arm-msm on all patches since we're directly concerned by
the whole changeset.

Thanks,
Neil

> 
> 
> Can Guo (6):
>    scsi: ufs: core: Pass target_freq to clk_scale_notify() vops
>    scsi: ufs: qcom: Pass target_freq to clk scale pre and post change
>    scsi: ufs: core: Add a vops to map clock frequency to gear speed
>    scsi: ufs: qcom: Implement the freq_to_gear_speed() vops
>    scsi: ufs: core: Enable multi-level gear scaling
>    scsi: ufs: core: Toggle Write Booster during clock scaling base on
>      gear speed
> 
> Ziqi Chen (2):
>    scsi: ufs: core: Check if scaling up is required when disable clkscale
>    ARM: dts: msm: Use Operation Points V2 for UFS on SM8650
> 
>   arch/arm64/boot/dts/qcom/sm8650.dtsi | 51 ++++++++++++++++----
>   drivers/ufs/core/ufshcd-priv.h       | 17 +++++--
>   drivers/ufs/core/ufshcd.c            | 71 +++++++++++++++++++++-------
>   drivers/ufs/host/ufs-mediatek.c      |  1 +
>   drivers/ufs/host/ufs-qcom.c          | 60 ++++++++++++++++++-----
>   include/ufs/ufshcd.h                 |  8 +++-
>   6 files changed, 166 insertions(+), 42 deletions(-)
> 

