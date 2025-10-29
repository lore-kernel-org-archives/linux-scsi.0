Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99412D5920
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 09:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761730995; cv=none; b=d4v+RQcGaMykHtFUYG9Uq98dl/GPi3bZ/ePUp9VY1DAdWRztltLahLWC+C3ZTPASw3q+JhvLoHE099xhPHRn97m86g5RO8/OeKzP6NZ9kqvtC4U3IxHTREWwk1wyzIXo9YCdIu3SaQKkWQpmUiEOQFkZtkoiooBF52c+FpCfo9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761730995; c=relaxed/simple;
	bh=Q/K+9hGuz91qt1w6NMss9Nats6dibYj0kroY0Wt0OT0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=N+rhfiijYzuqhxmZO42ZiXgnoiQoHWDk6wtnKA2ArAUtviEC5b3Ns/bT4gnj2jhu/VEMDQGsOjul+7v0/DHvqMNYsRzLtxzUupAEq/4KAOFmpPiFHXpwjjwov6GoEKS2bPnFJU53QmE+BEuiYIVI7yoO5MHI9Fqf0IR8waGSqZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zA7fulAl; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zA7fulAl"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso7014468f8f.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 02:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761730989; x=1762335789; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vt0D38+G1zn0BIeZFHVZCFulGxgoS4bXQgM2rqMoPfo=;
        b=zA7fulAlmtl4+7Seso0Jk/AbFlhiW0pmuR0ad/wdsK6eJ6ate8VP9qMrwPvB345TtE
         b5TGbnTokAZf64L75VNJQpH0m3yvdtcCJaPebdmPBYEQxtWyglSAGHHr30f7DpccTLQd
         tuuECg2OvbSS5wcEOcKWep0f1N1nAhIdFY4J9V9QydpSAvKQWajkZ+Y+Hkn8j1wjZneP
         2j4d2iC1bP+ijzplx3c0gP+Rac+TZMPVfc5Vu9Y8FhITbslS2nkCLulnIGDrA3P7230T
         +tcmN4nIc/GiR36uVLETyWFnDKw7fGe9oh3iiaOQ5wdc4xVPyXTvxuGCy9sGOUYOZ15h
         0VMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761730989; x=1762335789;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vt0D38+G1zn0BIeZFHVZCFulGxgoS4bXQgM2rqMoPfo=;
        b=aFDOEWTmgQ1+m4nqWya2YJqfJ1FyKW8D7rB4aFChTeB6kNDqo1LJG/Pp7GepF5cZwk
         WYquvUsQFH0UmZtQu/zsMCxoz+QgGw6fuONBNz81IvdD/UZKNU0r3ZIWjgcG7rUjs16I
         oca8Ccr+hEH193MXTguqiyZW0K3cOFi5wQZoh1mQHLn5aDTzBQxyIXbGNL7lY32yK7Fd
         MWpvqpft08CUDjaR9kq+I3MLtGvBAVwuvZDgWKUVZRlQANqUo8j9PpazS0DTN/EHlx1f
         DTe49gC8nOrx2B29CZVrxFMdGtTzvbqw2tliP6Qjwwy7VRPErYs1YoBgJWy3SqsNP5on
         v+sA==
X-Gm-Message-State: AOJu0YxmoaJzbC2KY1HlnaSN0DA/bkQblfapwKoIbsQojTpUlPbYl1Ji
	Vnx5Aswj62bz1gUEbk/NzsLSc+Fdf5N7spROach3A8BBIIKgyDvMr7+5E0lIsG4JwSk=
X-Gm-Gg: ASbGncs0IsePp5oXHOBMccU98ZpvF9b2B9zwANswePLrLWdfQo7FyniYn1GKDUMWQX0
	XPoonfAm5Ci9kuJoiJGAJGONkufOipHsEfJxzHWDD+VudvWlbV8Pm0tc6TV6fr8nKmTNIn8O7a/
	olDQY7gjFkp58gQtGW+fcszuZWz8Dspc0v/SYro/4hZy5K2fX4l2oNeMl58pkoSaKhZpXUiRrJd
	jtBAsYg/hmrtC2UswBjG2VxzN7K3+cJswVIV/ArqsGRKuhK9pu4VSMg5TTMkYFdMNnWSQGPx2VW
	wEcDHpw43E1a3umP0VmAVn2SQSvMomEIQ1qUrIRPSG4C5VSs77bVMC6TUYUeap//dF4CfUFu+80
	UMq06GA6XVUMgfTFkZ+f+en2zU89wWXJiQfJHDoXpaXMAqXKfM3yslg2Liq9U3tvTy06FvNFEoZ
	5zzeJMO2bKSeMqeXYizSjP0tAbwkm8j8FHcDPMOEwtEbtQTPBh1z7DOsb0ZT2p
X-Google-Smtp-Source: AGHT+IFu3JPa7CH8WhVFc8gTq+czxDEmrDGp2rNmH4aJgIuJqdatXcbYmfh34E+/dp2wAoVIehGXMw==
X-Received: by 2002:a05:6000:4011:b0:425:86f0:6817 with SMTP id ffacd0b85a97d-429af00231cmr1663420f8f.57.1761730988760;
        Wed, 29 Oct 2025 02:43:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:cad:2140:3447:eb7a:cb9f:5e0? ([2a01:e0a:cad:2140:3447:eb7a:cb9f:5e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e3a88fdsm43394835e9.10.2025.10.29.02.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 02:43:08 -0700 (PDT)
Message-ID: <f596d776-173d-4a04-b005-0d1bb09f7903@linaro.org>
Date: Wed, 29 Oct 2025 10:43:07 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: Neil Armstrong <neil.armstrong@linaro.org>
Subject: Re: [PATCH] ufs: core: Revert "Make HID attributes visible"
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>,
 Peter Wang <peter.wang@mediatek.com>, Bjorn Andersson
 <andersson@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Huan Tang <tanghuan@vivo.com>, Avri Altman <avri.altman@wdc.com>,
 Liu Song <liu.song13@zte.com.cn>,
 Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Bean Huo <huobean@gmail.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 Gwendal Grignou <gwendal@chromium.org>
References: <20251028222433.1108299-1-bvanassche@acm.org>
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
In-Reply-To: <20251028222433.1108299-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 10/28/25 23:24, Bart Van Assche wrote:
> Patch "Make HID attributes visible" is needed for older kernel versions
> (e.g. 6.12) where ufs_get_device_desc() is called from ufshcd_probe_hba().
> In these older kernel versions ufshcd_get_device_desc() may be called
> after the sysfs attributes have been added. In the upstream kernel however
> ufshcd_get_device_desc() is called before ufs_sysfs_add_nodes(). See also
> the ufshcd_device_params_init() call from ufshcd_init(). Hence, calling
> sysfs_update_group() is not necessary.
> 
> See also commit 69f5eb78d4b0 ("scsi: ufs: core: Move the
> ufshcd_device_init(hba, true) call") in kernel v6.13.
> 
> This patch fixes the following kernel warning:
> 
> sysfs: cannot create duplicate filename '/devices/platform/3c2d0000.ufs/hid'
> Workqueue: async async_run_entry_fn
> Call trace:
>   dump_backtrace+0xfc/0x17c
>   show_stack+0x18/0x28
>   dump_stack_lvl+0x40/0x104
>   dump_stack+0x18/0x3c
>   sysfs_warn_dup+0x6c/0xc8
>   internal_create_group+0x1c8/0x504
>   sysfs_create_groups+0x38/0x9c
>   ufs_sysfs_add_nodes+0x20/0x58
>   ufshcd_init+0x1114/0x134c
>   ufshcd_pltfrm_init+0x728/0x7d8
>   ufs_google_probe+0x30/0x84
>   platform_probe+0xa0/0xe0
>   really_probe+0x114/0x454
>   __driver_probe_device+0xa4/0x160
>   driver_probe_device+0x44/0x23c
>   __device_attach_driver+0x15c/0x1f4
>   bus_for_each_drv+0x10c/0x168
>   __device_attach_async_helper+0x80/0xf8
>   async_run_entry_fn+0x4c/0x17c
>   process_one_work+0x26c/0x65c
>   worker_thread+0x33c/0x498
>   kthread+0x110/0x134
>   ret_from_fork+0x10/0x20
> ufshcd 3c2d0000.ufs: ufs_sysfs_add_nodes: sysfs groups creation failed (err = -17)
> 
> Cc: Daniel Lee <chullee@google.com>
> Cc: Peter Wang <peter.wang@mediatek.com>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Fixes: bb7663dec67b ("scsi: ufs: sysfs: Make HID attributes visible")

Duplicate fixes, but perhaps you could specify this revert is only for v6.18 and the original commit should be backported ?

Anyway:
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>

Thanks,
Neil

> ---
>   drivers/ufs/core/ufs-sysfs.c | 2 +-
>   drivers/ufs/core/ufs-sysfs.h | 1 -
>   drivers/ufs/core/ufshcd.c    | 2 --
>   3 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index c040afc6668e..0086816b27cd 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -1949,7 +1949,7 @@ static umode_t ufs_sysfs_hid_is_visible(struct kobject *kobj,
>   	return	hba->dev_info.hid_sup ? attr->mode : 0;
>   }
>   
> -const struct attribute_group ufs_sysfs_hid_group = {
> +static const struct attribute_group ufs_sysfs_hid_group = {
>   	.name = "hid",
>   	.attrs = ufs_sysfs_hid,
>   	.is_visible = ufs_sysfs_hid_is_visible,
> diff --git a/drivers/ufs/core/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
> index 6efb82a082fd..8d94af3b8077 100644
> --- a/drivers/ufs/core/ufs-sysfs.h
> +++ b/drivers/ufs/core/ufs-sysfs.h
> @@ -14,6 +14,5 @@ void ufs_sysfs_remove_nodes(struct device *dev);
>   
>   extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
>   extern const struct attribute_group ufs_sysfs_lun_attributes_group;
> -extern const struct attribute_group ufs_sysfs_hid_group;
>   
>   #endif
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5d6297aa5c28..2b76f543d072 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8499,8 +8499,6 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>   				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
>   				UFS_DEV_HID_SUPPORT;
>   
> -	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
> -
>   	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
>   
>   	err = ufshcd_read_string_desc(hba, model_index,

