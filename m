Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0071D1E1A36
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 09:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730279319; cv=none; b=XgZTzY+5P8fjZO0/J6tNvR0ojyM1pGqrmUb5xOUKFrYNcE0ZF/2PJBZ/oqBTu89322ahiahllc6yl1Rbc0tVgcUl2FH4ArWBFgxJlbIJOfPps7vNzXn/0puzPFRto4bzX8tzcogVykr/iLq3XkQxSJHZFOxWdJTMcxsKZkrTcS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730279319; c=relaxed/simple;
	bh=Jk0UXxShi8z2/f18nwm1muRUeNcR5njK4N+6odlBPYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z242FX+2lbOaVYYQs2LFvxbCwl0DoL4opZPFBBqnVISFRem0gTPwlbscmgsAj+XlpyXia3JWSLV3+glDMcehOz6Zd4xxRppV9O1OTyNDF0YVuyzZXEPtFmhLKCQlCtVMZoZQxqt+Bv5g2/n4Jb3MX8jD6ih0s4t20w39NzBVbqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wOmAsvyC; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wOmAsvyC"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4315baec69eso62017635e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 02:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730279315; x=1730884115; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jfSruwmm+EhXu2+6CoTrjQzFc7XhuI6YW/TgDUPgZq0=;
        b=wOmAsvyCUCdYJmAXE1B0LBiBJb/u4e4DKCLxZ5jYd5xzWQ5EBWXpcCBLVadIbxd6cU
         hgcrHqP+kJ7b6LxfzXEgdt7o/2xywpWabEnxNvjei3QYnK4lBac6CdOGh5JeKzE0x8XG
         6lr42H83wZZ+qBM5zlNdZMPtJWML6ooDfQPVs7tPkvekxQGdjP3OIyL5U57+OZaqJlW/
         RZjg3FJOUNmtJaCekDX66e/+B2aLIqMCbhx+eql7xJQt4CWQlybT0/K47NUKthBDdwb3
         AIRtFWlnraMW6ijmL48fPu+XK+o+GOXG3Gcby3H2eIfxod+uNwfwyWabD7t3HORoTsb7
         a9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730279315; x=1730884115;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jfSruwmm+EhXu2+6CoTrjQzFc7XhuI6YW/TgDUPgZq0=;
        b=CiGP6k5jxSlQrZhQ8wx8O2nXeX+s/hHqInp4LiL864jzitIO5hbd1a01UZ9qTx0HIb
         1hKRPNIdbJofDgdf85SQcOtG+w7AAMbcxb3Nq34ScGU3wOs6UEh1a+IDl8W3zKqx1lce
         o8TdlaiI7sf3+uwh2OqCbGsfTHlQ76aF2REWYHYhhegFRDb/n3OT44+vG4lxNvwTC3pn
         sCOVwKdasWZC2ekZrDD7cbzrU6hSJ+eumuov3J1cwfhcQFCP2HmdUi6joM5bUsxHIVAA
         P/DLISFieX5hdtF2+9QXFmEYA8lI1eKy9Rl1qugHGMpYxqWIMXHjk8XCertETr0SKURt
         kzgw==
X-Forwarded-Encrypted: i=1; AJvYcCWpxmhcjgys1J3RQF1nredOIRA4VeL6sNjLGX19yCkMVhWpHWY/XbXJQnUMz2UqiOPlVfFD6bPW6BYL@vger.kernel.org
X-Gm-Message-State: AOJu0YzYQ5fNf/r386kqgJcVuFagqDZH/6Ch82rNH1tnIRp5/bPU5m7p
	PRTf/fDhmFUd1gzM3scjDSkf7nn93UJRdvswut6vR/XjK9cbBv723dH6iXuCwCE=
X-Google-Smtp-Source: AGHT+IGD4iPjU+Pkh0lZx916PTWhGIipRT1xfez/Mrkm0VvypRRrWcsZWadAIqR4bRvqK/U4Zm60wA==
X-Received: by 2002:a05:600c:458f:b0:42b:a7c7:5667 with SMTP id 5b1f17b1804b1-4319ad02659mr126496625e9.25.1730279315276;
        Wed, 30 Oct 2024 02:08:35 -0700 (PDT)
Received: from [192.168.0.157] ([79.115.63.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b3b956sm14734821f8f.36.2024.10.30.02.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 02:08:34 -0700 (PDT)
Message-ID: <3f758642-b319-4c00-bde2-2ac62936cf8f@linaro.org>
Date: Wed, 30 Oct 2024 09:08:33 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/11] scsi: ufs: exynos: gs101: remove unused phy
 attribute fields
To: Peter Griffin <peter.griffin@linaro.org>, alim.akhtar@samsung.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 avri.altman@wdc.com, bvanassche@acm.org, krzk@kernel.org
Cc: andre.draszik@linaro.org, kernel-team@android.com,
 willmcvicker@google.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-6-peter.griffin@linaro.org>
Content-Language: en-US
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20241025131442.112862-6-peter.griffin@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/24 2:14 PM, Peter Griffin wrote:
> Now that exynos_ufs_specify_phy_time_attr() checks the appropriate
> EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR flag. Remove the unused fields
> in gs101_uic_attr.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

> ---
>  drivers/ufs/host/ufs-exynos.c | 20 --------------------
>  1 file changed, 20 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index a1a2fdcb8a40..9d668d13fe94 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -2068,26 +2068,6 @@ static const struct exynos_ufs_drv_data exynos_ufs_drvs = {
>  
>  static struct exynos_ufs_uic_attr gs101_uic_attr = {
>  	.tx_trailingclks		= 0xff,
> -	.tx_dif_p_nsec			= 3000000,	/* unit: ns */
> -	.tx_dif_n_nsec			= 1000000,	/* unit: ns */
> -	.tx_high_z_cnt_nsec		= 20000,	/* unit: ns */
> -	.tx_base_unit_nsec		= 100000,	/* unit: ns */
> -	.tx_gran_unit_nsec		= 4000,		/* unit: ns */
> -	.tx_sleep_cnt			= 1000,		/* unit: ns */

Okay with the removal of the above. All are set in
exynos_ufs_specify_phy_time_attr(), which returns early if
EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR is set.

> -	.tx_min_activatetime		= 0xa,
> -	.rx_filler_enable		= 0x2,

Okay with these. They are used just in exynos_ufs_config_phy_time_attr
which is guarded by EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR.

> -	.rx_dif_p_nsec			= 1000000,	/* unit: ns */
> -	.rx_hibern8_wait_nsec		= 4000000,	/* unit: ns */
> -	.rx_base_unit_nsec		= 100000,	/* unit: ns */
> -	.rx_gran_unit_nsec		= 4000,		/* unit: ns */
> -	.rx_sleep_cnt			= 1280,		/* unit: ns */
> -	.rx_stall_cnt			= 320,		/* unit: ns */

Okay with the removal of the above. All are set in
exynos_ufs_specify_phy_time_attr(), which returns early if
EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR is set.

> -	.rx_hs_g1_sync_len_cap		= SYNC_LEN_COARSE(0xf),
> -	.rx_hs_g2_sync_len_cap		= SYNC_LEN_COARSE(0xf),
> -	.rx_hs_g3_sync_len_cap		= SYNC_LEN_COARSE(0xf),
> -	.rx_hs_g1_prep_sync_len_cap	= PREP_LEN(0xf),
> -	.rx_hs_g2_prep_sync_len_cap	= PREP_LEN(0xf),
> -	.rx_hs_g3_prep_sync_len_cap	= PREP_LEN(0xf),

Okay for these as well, all are set in exynos_ufs_config_phy_cap_attr()
which is guarded by EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR.


>  	.pa_dbg_opt_suite1_val		= 0x90913C1C,
>  	.pa_dbg_opt_suite1_off		= PA_GS101_DBG_OPTION_SUITE1,
>  	.pa_dbg_opt_suite2_val		= 0xE01C115F,
