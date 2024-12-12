Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B08A211A0E
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734012789; cv=none; b=cYmpimvl49KSGfIemPwlQnGWMBZxiASdHsYKmYPxB5lMuc33MtDGRjSuIGxH41frlfFsa0rNiaZNkamgmtKBacU3zgYjKfBV07cek7fWm4PVCyARW1WzmdYFDdzg5H/TzubLYAaF5Y3swdO5s2lCLPu2gD2gCkKBjAZp4yW1vpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734012789; c=relaxed/simple;
	bh=eYfNQdH+Yb3pRxEGGvcQhmT4dHeOB6ybMgg4S3Jm3wA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=WnqNeqOTV8yMiss1d8k1t17H+EHhgYbOuGtHJrY+K0PWdNYUVhoQYJPuMm3BbP1nE1BvmmxdouZEL5VabvheWxosXcTiaYINAjnch6jI3KYSaygQPYJRvTwQl19wgoKkXLx3h7YI7LyCFAuwZmTGCcOf/c/jezoyFjGMDRJtWbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H9V+ue8+; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H9V+ue8+"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4361f65ca01so6166035e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 06:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734012785; x=1734617585; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7qRsWZzS9ykzXPHauoxFElRIiyOYyTyVH1ndFyLa8s=;
        b=H9V+ue8+oAgjT1tqeX0CtQ1ptl5MXfdzX7u7dT3EHE2/FEwODpSCkIbOvcEM9o+o5Q
         UFIrnfMJQzF/cXtTlw4Sh+nFg4Ix8bKi2BeDuILV3Hvc7R6TvnzvtHEZjf6kX5KPnMuA
         hFNQltGAAtEIhljLILuW5jTsEtdYhkxbjsd05NuONWix2dhrnR67QGuasCMJtwN7tDZz
         CzdK22RoEQG+nwL6fKv2pBXNmcre7cCGRGv2f4JTU0MJAklfMkECx2Z6irtHc5s+BhO8
         +N0Az7hI51xailuzGbV2qNH5v+iD+owThVo4mXUcfCqxIw2MBF8g2n801kqONpkaxgdt
         PwdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734012785; x=1734617585;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q7qRsWZzS9ykzXPHauoxFElRIiyOYyTyVH1ndFyLa8s=;
        b=gjGXfADpxbdGdVns/j+eT9sGrGArYJ6zYgX+4qIuzy+Li9y86bWhbHtj1bj4cFhL8p
         c5COH/RmuGr296umUd+mP11BJ9YnkcBQk1HJzjA3m286ewcoHESMGOpkawjLXtMT0cjD
         epANe31NiWVmsw2XdmT/gGdTzDIZiZiZOnW+yrcPFKaQLMDfVZ+aM5hBzF6JFpo+VaLZ
         mPB7LTCj4Y53h6vXOqviiIxAhyhwVyYoR+c2Cpwx24OEunrLQpyaAppON0fcu652Br9O
         ZboJkaWW/WNIyIRkKv/QnMB7bO36SK2uzo8T00y99aHGWk7OLyZ10O/d3IjsjAlgGFsp
         KAdQ==
X-Gm-Message-State: AOJu0Yy0QBW1+rs0OsoDvJK2BZ2sTN42jhA1Y3gfmSmxhmMn7qjwk15j
	jXoDCYz34r0hVC7QA0ro2C+uVyV4EG/UbLy0aqxWnJCpIjUtcz5X0hEPBdePSEE=
X-Gm-Gg: ASbGnctRWkLKbrQxia80FwiVwksBNl4J9Nvwkthmi3QfZ7Dw5xzvU4/eXgBE0M3yX4s
	n/wIXS+b3lNEoTO5+nsfqF2cslJedvL1ZZL1xgIi8L61zzbMQnGheTAdytR/h38ytbHcW0cb3zU
	oHMPJ0EHhlbGv2Wb9+P364+ZRpc8H86XEz9LNokD0DoxWvi4Z1ziQWDQoHdb1VmFmaJCBOds3Yx
	Z+1cO3zyVr2aWy1S+OSHzWydgcNNLOBoxTd5lTynpRIL/Skjg7ZKJUy5wNIzlBn91695RQ+Qzow
	1bezttaTP5hKLt8XWwh6z6XHeI3ab+Z/Tg==
X-Google-Smtp-Source: AGHT+IGhQrOjvvXzkn0WE/eSGEISLy0pVMmCQQP/NDmPFcdSy+Meb+0+oWca7K3MusqrZ2wHNWNndQ==
X-Received: by 2002:a05:600c:35cb:b0:434:f9ad:7238 with SMTP id 5b1f17b1804b1-4362286391fmr26925065e9.22.1734012785437;
        Thu, 12 Dec 2024 06:13:05 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:b98a:c6fe:3a5d:f20a? ([2a01:e0a:982:cbb0:b98a:c6fe:3a5d:f20a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436256b7c62sm17840475e9.34.2024.12.12.06.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 06:13:04 -0800 (PST)
Message-ID: <00847cb8-2ead-4d2c-8b30-a9f8d8ceeb76@linaro.org>
Date: Thu, 12 Dec 2024 15:13:03 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH 2/3] scsi: ufs: qcom: Allow passing platform specific OF
 data
To: manivannan.sadhasivam@linaro.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Abel Vesa <abel.vesa@linaro.org>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, Amit Pundir <amit.pundir@linaro.org>,
 Nitin Rawat <quic_nitirawa@quicinc.com>
References: <20241211-ufs-qcom-suspend-fix-v1-0-83ebbde76b1c@linaro.org>
 <20241211-ufs-qcom-suspend-fix-v1-2-83ebbde76b1c@linaro.org>
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
In-Reply-To: <20241211-ufs-qcom-suspend-fix-v1-2-83ebbde76b1c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/2024 18:40, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 
> In order to allow platform specific flags and configurations, introduce
> the platform specific OF data and move the existing quirk
> UFSHCD_QUIRK_BROKEN_LSDBS_CAP for SM8550 and SM8650 SoCs.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   drivers/ufs/host/ufs-qcom.c | 13 +++++++++----
>   drivers/ufs/host/ufs-qcom.h |  4 ++++
>   2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 32b0c74437de..35ae8c8fc301 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -871,6 +871,7 @@ static u32 ufs_qcom_get_ufs_hci_version(struct ufs_hba *hba)
>    */
>   static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
>   {
> +	const struct ufs_qcom_drvdata *drvdata = of_device_get_match_data(hba->dev);
>   	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>   
>   	if (host->hw_ver.major == 0x2)
> @@ -879,9 +880,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
>   	if (host->hw_ver.major > 0x3)
>   		hba->quirks |= UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
>   
> -	if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc") ||
> -	    of_device_is_compatible(hba->dev->of_node, "qcom,sm8650-ufshc"))
> -		hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
> +	if (drvdata && drvdata->quirks)
> +		hba->quirks |= drvdata->quirks;
>   }
>   
>   static void ufs_qcom_set_phy_gear(struct ufs_qcom_host *host)
> @@ -1864,9 +1864,14 @@ static void ufs_qcom_remove(struct platform_device *pdev)
>   	platform_device_msi_free_irqs_all(hba->dev);
>   }
>   
> +static const struct ufs_qcom_drvdata ufs_qcom_sm8550_drvdata = {
> +	.quirks = UFSHCD_QUIRK_BROKEN_LSDBS_CAP,
> +};
> +
>   static const struct of_device_id ufs_qcom_of_match[] __maybe_unused = {
>   	{ .compatible = "qcom,ufshc" },
> -	{ .compatible = "qcom,sm8550-ufshc" },
> +	{ .compatible = "qcom,sm8550-ufshc", .data = &ufs_qcom_sm8550_drvdata },
> +	{ .compatible = "qcom,sm8650-ufshc", .data = &ufs_qcom_sm8550_drvdata },
>   	{},
>   };
>   MODULE_DEVICE_TABLE(of, ufs_qcom_of_match);
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index b9de170983c9..e85cc6fc072e 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -217,6 +217,10 @@ struct ufs_qcom_host {
>   	bool esi_enabled;
>   };
>   
> +struct ufs_qcom_drvdata {
> +	unsigned int quirks;
> +};
> +
>   static inline u32
>   ufs_qcom_get_debug_reg_offset(struct ufs_qcom_host *host, u32 reg)
>   {
> 

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
