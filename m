Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEF6226531
	for <linux-scsi@vger.kernel.org>; Thu,  6 Feb 2025 09:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738835613; cv=none; b=RuPkFJCNFjzDdyFIbU0JYr3x6HDWX6T6uCrJe1NFBl6SGAENOwMh3BauFLWOBPFOgDaQfm1oU/RnJ/8LSkuZIRFJPLhw9Iv0vkKfsJAaItRM1OxLwZ8vJ/eAkVkzhv39vvFXzO5qnaq6NkNelS5+2YEV2hFgj+ZotGfmRXwkTfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738835613; c=relaxed/simple;
	bh=WUBT/dBT3hdEKftrm9ytaz0AxYAgi67qXEPM3/1/Jfg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Jb1co4myU0DW8BR5V5CW+6U29j8zjyWto2XiL3rhOCGrbTtfuHL4slVehrxd0TPjvlUZKz2tCCMs95O1zVzl2bhB4MHVxYkD5VbHBiiZWgkS5rIBAFsjLU9krkllA/aW41PrDMjVbP8lqZXidf/5fKN7IhJ/kJm/FZtm5Ou92DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XSvB18QO; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XSvB18QO"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-38dc32a1318so90261f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Feb 2025 01:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738835609; x=1739440409; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y/Bse1dCSk7wlBTxWxrw+fvF90V1hOkdi4rEK3c8vEo=;
        b=XSvB18QOuJFkJq9EC+rSNnHmv65O1/n5hZxQA+oOr6lzH1eCr7b2J9j7Y5CrPipyYk
         7NqH4eJerTmIL1KqgFrlbGuwKaUOcs2L3gD8yBRgp/A29aGSX0Xj4obcInAA3PUcI8rg
         xXxQB25VpkRtUP6QfV7K2h5THK/dF/bcefndRAlZWk3twtt2Siwo5PM6Tg01R/tj77m4
         dXb10QhYSwtWdPhoZMSt0FYJa1FQl7eL0lXIR/NheMlZu4mBX/iubtGZdJ1OGJjnm4dw
         /eSaEOIt8cQKCTEQHcPNBjyb3BSirYM9UPm8+sPpc7xt2fUfCpIZpB8c0qFtdtM3aD08
         gm7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738835609; x=1739440409;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y/Bse1dCSk7wlBTxWxrw+fvF90V1hOkdi4rEK3c8vEo=;
        b=Lvq/dBWXQc1H7dxl3wzFR6PpZYl3Y4j52kjGSBFC3fzWvaswN3JDiXkDpjCVNn/m+p
         uWfqvb7HNBkU6qvSO/kQjymfyzLCKsEFG+mmupQDD8dCpDhqTfQmjz+NfG3np24f6H1d
         /vLTrQeVGU7q1bTp9Pbhjh6luItJ2QL5pqNSqxQFyHvp/7DkzvhywjLLZbOIF4irNoMt
         /WVlYz1+MFBpWuejxHPtM/4tALg+Holbeh309XJP39nvpbNeSFgg7DnAMnOvnWqLOwJt
         znMbKDeedBlk4RmpYwJtnkGKZEnQjIRoyr7ZDkT0BpmDpyBQuE9aislSrRSTbdIr28vk
         bc9g==
X-Forwarded-Encrypted: i=1; AJvYcCVslLJozrgp8cpG9sunRypuyIRTp8ztCNw3JhLACqy0q1K1ehYfgpI0E3wpLfLzv+edAqUC2RDWmJAg@vger.kernel.org
X-Gm-Message-State: AOJu0YwkjsqcSXS4/Q/v6EuzP8n9SDoAdamVCsv0ZyOuo4hHKTvaqCjA
	7UZOpelApK11Ab8pWLmVAVL/Q8lkZGB8b+qQa8lVT0mFZk3rlXYjd0ztnGrCh0w=
X-Gm-Gg: ASbGncsB1ybwsU3cvtMBuwlo1RlbTZPDltDZNb3ut0R2ROGnbMnPPgB3PrXiStcdqi3
	ylJJdCMOSQJmt7B4uJA9PM0XKsbRzOXfks99vSZrA37FOzDFtI1LMZ/JKvkIOnvPOcY08TUCP7k
	z36eLjhDCw3ElrAstBM/ILpS3K4so3sZbJhP86l4SJhlO19sDTvD6oiXLmzvzQmZVonS7R9J2dT
	gnxVHp/OK1Ii3dXn4bGCwYuYiC4ssLJIBEKWAGRuod37PK/180myEWSlwO1bz2KWjNmqrw2S4Cr
	Ejul0FdpKLE8mszKJhQiDaLp+88tJu6cqy/3RllhGAdMTMtYwGFJymPWwFfKqLqv9oos
X-Google-Smtp-Source: AGHT+IFZ/YD1C+lwl5UFVIadECKSzvAxjxJXg73+g+VHFrSip3JyQPnIew9WOECpn6y9hKaGtkaC7Q==
X-Received: by 2002:a5d:5f4c:0:b0:385:fae2:f443 with SMTP id ffacd0b85a97d-38db48d5d49mr3733434f8f.34.1738835608907;
        Thu, 06 Feb 2025 01:53:28 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:4972:46a2:e0cb:c0a6? ([2a01:e0a:982:cbb0:4972:46a2:e0cb:c0a6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dc31b9394sm337288f8f.11.2025.02.06.01.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 01:53:28 -0800 (PST)
Message-ID: <63578f71-e5f5-482a-98a7-779053b1caf7@linaro.org>
Date: Thu, 6 Feb 2025 10:53:27 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v3 0/8] Support Multi-frequency scale for UFS
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_cang@quicinc.com,
 bvanassche@acm.org, mani@kernel.org, beanhuo@micron.com,
 avri.altman@wdc.com, junwoo80.lee@samsung.com, martin.petersen@oracle.com,
 quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
 quic_rampraka@quicinc.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "open list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-kernel@vger.kernel.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
 "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <20250203081109.1614395-1-quic_ziqichen@quicinc.com>
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
In-Reply-To: <20250203081109.1614395-1-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 03/02/2025 09:11, Ziqi Chen wrote:
> With OPP V2 enabled, devfreq can scale clocks amongst multiple frequency
> plans. However, the gear speed is only toggled between min and max during
> clock scaling. Enable multi-level gear scaling by mapping clock frequencies
> to gear speeds, so that when devfreq scales clock frequencies we can put
> the UFS link at the appropraite gear speeds accordingly.
> 
> This series has been tested on below platforms -
> sm8550 mtp + UFS3.1
> SM8650 MTP + UFS3.1
> SM8750 MTP + UFS4.0
> 
> v1 -> v2:
> 1. Withdraw old patch 8/8 "ARM: dts: msm: Use Operation Points V2 for UFS on SM8650"
> 2. Add new patch 8/8 "ABI: sysfs-driver-ufs: Add missing UFS sysfs addributes"
> 3. Modify commit message for  "scsi: ufs: core: Pass target_freq to clk_scale_notify() vops" and "scsi: ufs: qcom: Pass target_freq to clk scale pre and post change"
> 4. In "scsi: ufs: qcom: Pass target_freq to clk scale pre and post change", use common Macro HZ_PER_MHZ in function ufs_qcom_set_core_clk_ctrl()
> 5. In "scsi: ufs: qcom: Implement the freq_to_gear_speed() vops", print out freq and gear info as debugging message
> 6. In "scsi: ufs: core: Enable multi-level gear scaling", rename the lable "do_pmc" to "config_pwr_mode"
> 7. In "scsi: ufs: core: Toggle Write Booster during clock", initialize the local variables "wb_en" as "false"
> 
> v2 -> v3:
> 1. Change 'vops' to 'vop' in all commit message
> 2. keep the indentation consistent for clk_scale_notify() definition.
> 3. In "scsi: ufs: core: Add a vop to map clock frequency to gear speed", "scsi: ufs: qcom: Implement the freq_to_gear_speed() vop"
>     and "scsi: ufs: core: Enable multi-level gear scaling", remove the parameter 'gear' and use it as return result in function freq_to_gear_speed()
> 4. In "scsi: ufs: qcom: Implement the freq_to_gear_speed(), removed the variable 'ret' in function ufs_qcom_freq_to_gear_speed()
> 5. In "scsi: ufs: core: Enable multi-level gear scaling", use assignment instead memcpy() in function ufshcd_scale_gear()
> 6. Improve the grammar of attributes' descriptions in “ABI: sysfs-driver-ufs: Add missing UFS sysfs attributes”
> 7. Typo fixed for some commit messages.
> 
> Can Guo (6):
>    scsi: ufs: core: Pass target_freq to clk_scale_notify() vop
>    scsi: ufs: qcom: Pass target_freq to clk scale pre and post change
>    scsi: ufs: core: Add a vop to map clock frequency to gear speed
>    scsi: ufs: qcom: Implement the freq_to_gear_speed() vop
>    scsi: ufs: core: Enable multi-level gear scaling
>    scsi: ufs: core: Toggle Write Booster during clock scaling base on
>      gear speed
> 
> Ziqi Chen (2):
>    scsi: ufs: core: Check if scaling up is required when disable clkscale
>    ABI: sysfs-driver-ufs: Add missing UFS sysfs attributes
> 
>   Documentation/ABI/testing/sysfs-driver-ufs | 33 ++++++++++
>   drivers/ufs/core/ufshcd-priv.h             | 15 ++++-
>   drivers/ufs/core/ufshcd.c                  | 76 +++++++++++++++++-----
>   drivers/ufs/host/ufs-mediatek.c            |  1 +
>   drivers/ufs/host/ufs-qcom.c                | 62 ++++++++++++++----
>   include/ufs/ufshcd.h                       |  9 ++-
>   6 files changed, 160 insertions(+), 36 deletions(-)
> 

Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK

I added some traces and played with devfreq max_freq while copying data
from the UFS disk, no issues observed.

Neil		
