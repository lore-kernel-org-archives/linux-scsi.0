Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0332018B46E
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 08:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730275470; cv=none; b=euRfSWDA8uzoz0vA/2vbbymVxpKYRWrp3b6xOY5nRJ8njkK2ys4n88XcvTGZ6M3gNa6l48mn3dpz3mwNyIXioSbiSi2FZIYPygUbWl2aPiA3pk8OhuLY7ztlC6yICAoDn7ip8/jErLUnm5reDEyEtMkLx0Yt3rYLEDhm5ZQWi7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730275470; c=relaxed/simple;
	bh=B+cw9PA/7VZt/fohppn2aNdkGFc4L/28zmOip6XYSe0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pug4SzumiSerqBhoHSSstqyHuH+lQLlMBN6jwMxTaDYOUc454JY+XnDRTEIUnb4Vr8qe1RN9ZPkv9u6j7tP/MFqvBG5Tge4X5Tet8Wx0bUJ+vC5zuMhtcCFGf3CIlVCq2Gy0ZgurggnMbWo/3r7u69nkrlonu8029wSk8i839AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l3IIUoYc; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l3IIUoYc"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-539983beb19so7477313e87.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 01:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730275465; x=1730880265; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H93KKVpJbQ9UgwbZgl1kdPifbCt7HKUU//i7YU4EaJY=;
        b=l3IIUoYc7aPorQTgtEhf4hz3dyiHjXE9Y+obwFQGgd3pXDYinfWdFFjnpphWHee05v
         d+4Ke9Ly7VDhqo3LRk0UFpZTnM/1DoHjsCVI0wtmGa24BhXtmtXT9AfOSciavrgL2vWU
         XsNsdALDkx/626X5fFhtI8JpTAnb9EXccUjngMo+KGGu8kkU7gAZz1E3D7wfiRHDZD5O
         paEXXN5Q1e+CE+rRbXYMv3xf+3WimTO+30iGLArrN771aEsM1l6JKz5lOzuFDk5G9nHd
         HTYmOFjXpqrKFh+uju3uYRdxTwIdEC7lBIIuua277DjjYnpjROVYVJN/5ZaFFoX05LCB
         63Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730275465; x=1730880265;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H93KKVpJbQ9UgwbZgl1kdPifbCt7HKUU//i7YU4EaJY=;
        b=I8DX0q0qfoYAoHmZAF4ao3ExAkSpb+gywCuyRdrj71tqqdwhDXqyzpnzN6rlBboKhh
         fz62mjOQA3WUEA4TiwDdUOsdiHs3K0RdPeZ4Ml8pgo1ORwBpncdeKKOvXgeVryCrvfL9
         0XOqaDvrr4p9lUA+seXGv6L8pZ3FheZjLIp714CtNIm7VNl018Jcdq2wg649TMoWdErN
         IEHJedy7KuUwh4AWEmlaUeyTyXk/K3jUkXKJT6pZoIh1q/EH2+zDiQ2pYv+0aPG6Ateh
         0+NThFlngxFyp1k/xIEGICySqOxYTiZJ68zJ3pBBu7kzx87X097Hj/kooKZ7EV0LH3C1
         WheA==
X-Forwarded-Encrypted: i=1; AJvYcCXjOJsHzmxdfOLfiNc9VKGDkHXRAu4/rCnKyJasgAHj89UWh6q8DmV9VyGqt0+ajHT44C8lTXa0H+8M@vger.kernel.org
X-Gm-Message-State: AOJu0YwQsSjOmL1tChly/KgSYMyCfIQovKlJTZ2uiEf1k3u/E+wZYH15
	aKv5CtSSIJ63YAWhl4h5UGGMGWk/uYJABdQ+1uSxE28mqEVLV2sjjEDK+yILQi0=
X-Google-Smtp-Source: AGHT+IEZj9cR0ATu/JOPSB5irJVr/RnXyRQtlMK8w5XGhoTtI+E9S/Awq23Np24Aq1OO/+nXkl58yg==
X-Received: by 2002:ac2:4c41:0:b0:539:f65b:3f9 with SMTP id 2adb3069b0e04-53b347c0b08mr8580322e87.10.1730275464885;
        Wed, 30 Oct 2024 01:04:24 -0700 (PDT)
Received: from [192.168.0.157] ([79.115.63.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b3bf85sm14792889f8f.42.2024.10.30.01.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 01:04:24 -0700 (PDT)
Message-ID: <74458ba4-af0f-4c41-92f5-c6c0cb79e930@linaro.org>
Date: Wed, 30 Oct 2024 08:04:22 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] scsi: ufs: exynos: Allow UFS Gear 4
To: Peter Griffin <peter.griffin@linaro.org>, alim.akhtar@samsung.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 avri.altman@wdc.com, bvanassche@acm.org, krzk@kernel.org
Cc: andre.draszik@linaro.org, kernel-team@android.com,
 willmcvicker@google.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-2-peter.griffin@linaro.org>
Content-Language: en-US
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20241025131442.112862-2-peter.griffin@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/24 2:14 PM, Peter Griffin wrote:
> UFS Gear 4 offers faster speeds, and better power usage so lets
> enable it.
> 
> Currently ufshcd_init_host_params() sets UFS_HS_G3 as a default,
> so even if the device supports G4 we end up negotiating down to
> G3.
> 
> For SoCs like gs101 which have a UFS major controller version
> of 3 or above advertise Gear 4. This then allows a Gear 4 link
> on Pixel 6.
> 
> For earlier controller versions keep the current default behaviour
> of reporting G3.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

some nits/personal preferences below, no need to address them

> ---
>  drivers/ufs/host/ufs-exynos.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index 9ec318ef52bf..e25de4b86ac0 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -771,6 +771,21 @@ static void exynos_ufs_config_sync_pattern_mask(struct exynos_ufs *ufs,
>  	exynos_ufs_disable_ov_tm(hba);
>  }
>  
> +#define UFS_HW_VER_MAJOR_MASK   GENMASK(15, 8)
> +
> +static u32 exynos_ufs_get_hs_gear(struct ufs_hba *hba)
> +{
> +	u8 major;
> +
> +	major = FIELD_GET(UFS_HW_VER_MAJOR_MASK, hba->ufs_version);
> +
> +	if (major >= 3)
> +		return UFS_HS_G4;
> +
> +	/* Default is HS-G3 */
> +	return UFS_HS_G3;
> +}
> +
>  static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
>  				struct ufs_pa_layer_attr *dev_max_params,
>  				struct ufs_pa_layer_attr *dev_req_params)
> @@ -787,6 +802,8 @@ static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
>  	}
>  
>  	ufshcd_init_host_params(&host_params);

blank line

> +	/* This driver only support symmetric gear setting e.g. hs_tx_gear == hs_rx_gear */
> +	host_params.hs_tx_gear = host_params.hs_rx_gear = exynos_ufs_get_hs_gear(hba);

I find it easier to read if you split inits on their own line:
	host_params.hs_tx_gear = exynos_ufs_get_hs_gear(hba);
	host_params.hs_rx_gear = exynos_ufs_get_hs_gear(hba);

>  
>  	ret = ufshcd_negotiate_pwr_params(&host_params, dev_max_params, dev_req_params);
>  	if (ret) {
