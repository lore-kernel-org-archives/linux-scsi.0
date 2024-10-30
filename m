Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1E21E0DFE
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 08:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730276655; cv=none; b=b1EXMRQ8HkKGtZP5Yw0MDucmW7POEe9LCPRrJxCdStRC9/oEDBHGZnpV9PRoUaiqJ05fPjFxkiik6IXlSkknzBcMAoQnjBBN3Rar8r64k+9I/Kj8FlmqeYjDD6vceHhVvhmfJKIgRk64jgw+fjBhC3u0OXn2KD7mHhChviN2DDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730276655; c=relaxed/simple;
	bh=Qhpkm4WTteAyftmrwtnK9R8dd+A2hUuNmx/G1bGXkYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vFwRdVFljQ2+670t1dLnjDaMeBlqdUniuTF2EAz6y221Z4ziLk4jPozCCAFO1vCHZYegn0THOZxGRzGV+NjklBRwxgGoUGo/nHFBUzPlv/hwQeNWIhuR9EyxrqzD+pPYdEnUmYBpdrcX/vQP3xdnYnGpALnfvub6JqozCzjCTIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dgQVSADj; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dgQVSADj"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9a6acac4c3so994035366b.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2024 01:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730276651; x=1730881451; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4IzTjonjvv4fhPKtE1bAMZ0z1TTpZMKWkER0B3kjnaU=;
        b=dgQVSADjzU7mFlrNo7V7ohi1dVUSo9j0YZkEIVkrmbHwsmwCyoQyG+o1jRET2VBPw2
         5icY86ol+yKWQLY57/M9HSKAuj2VrHvD7SAzohfYwM2WM62kH6McCpMsOXx+Ks9CliJs
         hwY6M0hXkO6OiKm5mYmCPcv9KO7rGejkh5Vx5TLwd/FjuDA9DGdNMiWXW9BwQQvYM2YI
         Byf3YzE+qiOn09q/wIAvxq5P/aousxtLIynAOuKAivoEWjA+6KSdn2pCB9KFoCw7dgA7
         xQmU89ldGLqaS20MjX6wgLbaNNnoEx3ZYVkjFybNzyhhb+FKqzzVGHLD5kNfNA+3b98B
         fM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730276651; x=1730881451;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4IzTjonjvv4fhPKtE1bAMZ0z1TTpZMKWkER0B3kjnaU=;
        b=LdA7jhG6B5kLvwhlLLNP7s6FaPVhJWtBes+/ap6YLqZtOToLMLYCTwcEtM/MqnP/2K
         MrmNCKslI2utjEQPBRbqqiQiBxSOCq2IpYpGVE0xLNxl8Qk6lwHR43FF+YhDjiJYzquu
         aIHHT0J7aJHIHaPWJRIQTpPUs2Pww1F9ab9twzwhHAIbuNAEp+O028p0t5H4IHdMksF9
         LdGydh4qjQnjm1rlvmTiMmT3DgZkevpAEgD7TMv6nRSBiF9U2OLLQSlduQ8wTU2nLgIQ
         +/t/QEKWKglJ9WqipBZMnSIDj3ck76Q/2SrgCfG5Rn41BtpgJ9NO/iStd8oyCon+zkkI
         42Zw==
X-Forwarded-Encrypted: i=1; AJvYcCVD96rzu+ZZgidyXyaZBZuNsa2uW37tjC/r/U+A9ocTuzh/FVe36DoEh/anuusGxt8UOlkIOTWvZpkS@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+76dPPwg+Ocf0VRGGZH9wH/MxFXaEg4pI5WEuOmp9BEb+ctaO
	hlsIQlnLnnpr9Vs+TcwBYAWFaUGinAdC0ntlw5TzVAW2M7rwfvkevj/uo4C9i8Q=
X-Google-Smtp-Source: AGHT+IH5x1e9E410/aCJcWrSKGwzP+rL5H/qoPDmLBUylFSzYy/PDgopa4w/bjGtxcjDtfhlYRn7IQ==
X-Received: by 2002:a17:906:794c:b0:a99:e505:2089 with SMTP id a640c23a62f3a-a9de61ce120mr1423660466b.45.1730276651447;
        Wed, 30 Oct 2024 01:24:11 -0700 (PDT)
Received: from [192.168.0.157] ([79.115.63.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b13309sm14733219f8f.3.2024.10.30.01.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 01:24:11 -0700 (PDT)
Message-ID: <039d4e57-30e7-40e8-9501-cc4b18c6bb30@linaro.org>
Date: Wed, 30 Oct 2024 08:24:09 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] scsi: ufs: exynos: gs101: remove
 EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL
To: Peter Griffin <peter.griffin@linaro.org>, alim.akhtar@samsung.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 avri.altman@wdc.com, bvanassche@acm.org, krzk@kernel.org
Cc: andre.draszik@linaro.org, kernel-team@android.com,
 willmcvicker@google.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org
References: <20241025131442.112862-1-peter.griffin@linaro.org>
 <20241025131442.112862-4-peter.griffin@linaro.org>
Content-Language: en-US
From: Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20241025131442.112862-4-peter.griffin@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/25/24 2:14 PM, Peter Griffin wrote:
> This flag is not required for gs101 SoC.
> 

nitpick, use imperative

Auto clk control works fine for gs101, remove
EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL flag.

(or something along these lines)

Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/ufs/host/ufs-exynos.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index 939d08bce545..d685d3e93ea1 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -2142,8 +2142,7 @@ static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
>  				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
>  				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
>  				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
> -	.opts			= EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
> -				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
> +	.opts			= EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
>  				  EXYNOS_UFS_OPT_UFSPR_SECURE |
>  				  EXYNOS_UFS_OPT_TIMER_TICK_SELECT,
>  	.drv_init		= exynosauto_ufs_drv_init,
