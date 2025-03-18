Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459B91C5F32
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742310321; cv=none; b=GtjnBRtF3HU2RkIr40mY3v7RJAUOl+NEjl3uR8be+jpaFA2/eSXhZ4Zkd/O4O1gOiptbRs39FwdibkkXJVTrAvLkbqvRAwDC6UE9yvaIrESsa82fo71LV9oFXpahCezxEeS4rB2Nwe9BO+pRUZCxlP4SfL2zAY+EtslPulYK9gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742310321; c=relaxed/simple;
	bh=X1fIwXQ6nnTOxW8T62IeQHo4HyPTrgZeN4zniCvGBGE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=elNpfYaBgzLD1+nSia1XtzEwMIiG3JhG+zvOhzeX9HtyJUA5Lzmrn1VbLCpG2FK/YqUuqzqpicnMe0VyyQujlh1p3X9OxSCu3XMvsCc1aBhj9mZStUQ17fpAzWfB2Q7KrI7SlD2p2adoh3k8qJuxdw+vNQeVpgK3uzKLhjQScJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bhB138d/; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bhB138d/"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43cf3192f3bso36740555e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 08:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742310316; x=1742915116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s7z3efMccsfKBdFpHk+eX1kiGNX1+yreBt4Fj6qD5jo=;
        b=bhB138d/cj2BDeutQskCH79Y4tq8Tk0ILsimQ06e0/AswlX5r55xNZ1tYQj8FHEjOY
         dZRowEBgTe6fvzPjChCPkcy7ccE/2DN6AerU80+kVa31BjYsyflbyxKKKZLPP2y4N5ib
         61pQlEJMt12wxiS3v0I20sd8R7Vy5pcaph2xY/srLDsbcQt4bLlYBkh0had4u01B812e
         iQIQyFn4zVWIxKfkXWiHnf+fMLkTdDBFu4GN9hBusUwrLF0f8aa6Q8D86oZmCE070UK/
         /2esqp3fx6zBfvTyOa/cfsR6rcCfILS0a6tCosTSX7TvltqtyUDjZ5obBJL8l6C8QZID
         WzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742310316; x=1742915116;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s7z3efMccsfKBdFpHk+eX1kiGNX1+yreBt4Fj6qD5jo=;
        b=F1GAYTomlyD+hap/2k2wbzlsaZQs7BQav8de8vLiJWDSPMdsBiWf8AnIXU/nW5CXwn
         MiLn3FxrcYLXRTZ+rTpxQH7wKG/9ouDZVNKr/MIMwHI5f5+uu+X/Dr/p4sPT4hxyew2i
         nHVCiAH9LlUi0zpjeUYs5AEJhrhnIDFr8aG+bo1JVlGJ7RGi/uD8Lkh6Fe/1I7HtvtDa
         E7N1BLlAgPXqLu4BdMHvPpOb/UakKG471v/S9ioxst815QRrgf2ZXzjOf7sdNeQawfXy
         n5u0FmJXgKJm5DKuBA10oauwM4txgyItaSLCYdiVO/Ces+dYoRHU0H0OY2SfkBK69UGS
         Z+Kg==
X-Forwarded-Encrypted: i=1; AJvYcCVqy7qIdf6l0LwaoUz96H+iL5CFPvImNVsOS0mPG6yZbhPf9BXk61le08je3f6wU7EkmYDOM89ZbLuv@vger.kernel.org
X-Gm-Message-State: AOJu0YypoCwCXl2Hd2JmUegoXfENU7Hhx0ID2+GMFIjVxCM8OihrLuVA
	ibtAUfWz5gco7OeBbfuT3gf/vBgXUiUyzL4HN8d+vPGykAbrM/avIIUaXxxYf7M=
X-Gm-Gg: ASbGnctNzWYuCF8T/5rX7yNgrCBb86injQgKakLiZCLYAtvL6m8nvjtKHqU414jZ+XO
	7dmLn6kHX2gmW+S/y/zXi5w9VDUqT4OKSJVkdlLs3OCcmmR/+rKSZvYWb0acHIqgMz6QFxTkYEa
	lcuOJHd+lF3x9g4W9Ej/fwUH78NSvZVuOC0HwCPHINlBfHYJs9KuZVOiiQZwFhdvHbZAW/fuyGM
	WnGVFRZcEHqBK85ZN0Ot67ZWtiYMu2CguVMgp/a6PHrYSBUjf8p9eGNF1BPn8PsMuR3ROcvWg2j
	9+Fzy9hHYhvq+CuvZrMJOtejA2VkLeh9V6vUfrA1mqO2ToXg7Yt4TasO24wsCeDRWMtdGBWTG2/
	HAfTholvKO7/2sPVzyPYQ7A==
X-Google-Smtp-Source: AGHT+IFvHjliDhhrMFfSHKDFTbiDpIfzsiyAIrlmrzEJuRyFcEuNWlnzrwIPGgDXN2d4wUB2n4VJZA==
X-Received: by 2002:a05:600c:4587:b0:43c:eb63:415d with SMTP id 5b1f17b1804b1-43d3b9a4273mr24879565e9.14.1742310311971;
        Tue, 18 Mar 2025 08:05:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:3d9:2080:eac1:f2d4:84a8:c5ff? ([2a01:e0a:3d9:2080:eac1:f2d4:84a8:c5ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d3ae040f9sm18471835e9.0.2025.03.18.08.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 08:05:11 -0700 (PDT)
Message-ID: <89e743e5-7ff6-43fe-bd52-97f0ca6ab07e@linaro.org>
Date: Tue, 18 Mar 2025 16:05:10 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: neil.armstrong@linaro.org
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH V2 1/6] phy: qcom-qmp-ufs: Rename qmp_ufs_enable and
 qmp_ufs_power_on
To: Nitin Rawat <quic_nitirawa@quicinc.com>, vkoul@kernel.org,
 kishon@kernel.org, manivannan.sadhasivam@linaro.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 konrad.dybcio@oss.qualcomm.com
Cc: quic_rdwivedi@quicinc.com, linux-arm-msm@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <20250318144944.19749-1-quic_nitirawa@quicinc.com>
 <20250318144944.19749-2-quic_nitirawa@quicinc.com>
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
In-Reply-To: <20250318144944.19749-2-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/03/2025 15:49, Nitin Rawat wrote:
> Rename qmp_ufs_enable to qmp_ufs_power_on and qmp_ufs_power_on to
> qmp_ufs_phy_calibrate to better reflect functionality. Also
> update function calls and structure assignments accordingly.
> 
> Co-developed-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---
>   drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> index 45b3b792696e..bb836bc0f736 100644
> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> @@ -1837,7 +1837,7 @@ static int qmp_ufs_init(struct phy *phy)
>   	return 0;
>   }
> 
> -static int qmp_ufs_power_on(struct phy *phy)
> +static int qmp_ufs_phy_calibrate(struct phy *phy)
>   {
>   	struct qmp_ufs *qmp = phy_get_drvdata(phy);
>   	const struct qmp_phy_cfg *cfg = qmp->cfg;
> @@ -1898,7 +1898,7 @@ static int qmp_ufs_exit(struct phy *phy)
>   	return 0;
>   }
> 
> -static int qmp_ufs_enable(struct phy *phy)
> +static int qmp_ufs_power_on(struct phy *phy)
>   {
>   	int ret;
> 
> @@ -1906,7 +1906,7 @@ static int qmp_ufs_enable(struct phy *phy)
>   	if (ret)
>   		return ret;
> 
> -	ret = qmp_ufs_power_on(phy);
> +	ret = qmp_ufs_phy_calibrate(phy);
>   	if (ret)
>   		qmp_ufs_exit(phy);
> 
> @@ -1940,7 +1940,7 @@ static int qmp_ufs_set_mode(struct phy *phy, enum phy_mode mode, int submode)
>   }
> 
>   static const struct phy_ops qcom_qmp_ufs_phy_ops = {
> -	.power_on	= qmp_ufs_enable,
> +	.power_on	= qmp_ufs_power_on,
>   	.power_off	= qmp_ufs_disable,
>   	.set_mode	= qmp_ufs_set_mode,
>   	.owner		= THIS_MODULE,
> --
> 2.48.1
> 
> 

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
