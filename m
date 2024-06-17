Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D0C190464
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 07:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718611088; cv=none; b=cPOsVIuYAO+XZym2yNkUZMuz/fXTs8iCb1TAH+dYdsR7mVT01hjfttJFxInSi8X1K/b3SEShD2kPAM0+IGk8s55r8ggjJek0W8uGs2GVb2SsAHHsNDe2zAbBb7CMu2hZVSZmGN1k9Xq30Ha1JPk5Y54YtH6UBpM/arh2RJupYIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718611088; c=relaxed/simple;
	bh=xp6ogpjWSbJLZpxG/11o9qWsWuRkYsIuOYj0shAFTvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLztVhLJbSYV+/mCWBo3+eibMkXRv1h/ZplrPrdhfzlLFNLW9IuyAP28OhCurIm3y224E2duqK3QynnG89Klx5KKUZ2/nSQRX7+VZfzra8Ae176iDVsCP/p4BISQAU3EnUTUGUa8I8+/5YIBaqcS8VkvjYR1SJabjYYkvfNIIfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TjEzn50J; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TjEzn50J"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-52bc035a7ccso4363997e87.2
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 00:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718611085; x=1719215885; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ODVZ2a7uqD44xyTm8f9ujOrdUFNw6sun9vxSfj31nAk=;
        b=TjEzn50JiXHrfqc8fv5s9AwZjNhMnD+8z53TEmtH73mVV9c6l91OfY/bOeYEMtGNjr
         CqsD6rwITLGe8LZxahBHjiKjofRBuZY9rCsBFMwVDgfAz9M28FAvldexV1ib3J86LZKC
         og+Xvj3I2MKIsYYKWiJf2nBvTN+9Xho9V/+gWuI9VQmAfg/LK4upszLrp5sRMdazgksU
         FUD5zgbB/eiEiyMC9TVm6XG5ChO79EAvJOmbOBgTeg56/OYanaphsogUrDKGDuMo6myf
         y3s17s+QJskP9V/HP1MzKhZ1WGaUnpbJBqp+6uPVOB7pXkP4SaP4rfFOUoIWLT092Wr6
         TP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718611085; x=1719215885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODVZ2a7uqD44xyTm8f9ujOrdUFNw6sun9vxSfj31nAk=;
        b=Vq6R4C0LVRh3skgzK6l6x7d0q557OpHev8yjXLkqLJ0/O3SJnwCDwTuc6ES3tgUcJR
         q3pNx/eo3QHkG2PiXIpqtgHEMfR81FZF+MCF1w/XBjIRNCCF0iOtI8aPCS3Sn74bAIXe
         9QPR9kIwC/p8Fm9tyzmMUrZ/6LvzBEWSrJP2n1u4lzE10N2+nXpAnrbRdMZ0b5NVR/rg
         7MuIlcJ6lAsNvCX266qjGsaAcL00nmUYQqqsVcF3yEsa/slrYmLK8qYPsqyG8sh6SIKr
         mQ2yCxwP+0ds0ZcbYf88HVAoqXbi5eAzgKREp4qUcz6CHvgao/O7maOxKSOR4V2ji6/h
         DIVg==
X-Forwarded-Encrypted: i=1; AJvYcCV8A+7l8THPX+j695h6fCxfKEVeaLM0MP4oRvuiB8Y/0rV6wooBeTnjn0OsUwdh/lIU/q4VCoPG924uCMBeMKp8hh60dlMiG+qA+w==
X-Gm-Message-State: AOJu0Yy9n5YNpQ2scopMjy5wNUUW7urJMcNoYAW5j3OHwJsANWVHNSLA
	ApZpBORlGk8VoS3znQqbNYdgRRIJhd2wzWi/tpsKJcoLHH/oVqoUWfbdNrTmG8c=
X-Google-Smtp-Source: AGHT+IHcLYn3QHIusC8lvXLKR6f7eP7LQSUjuA3yhHCd5aMLxRnMmKLH7SziPyP0nZbjXCNtjw/UpQ==
X-Received: by 2002:a2e:350e:0:b0:2ec:2b25:3c8e with SMTP id 38308e7fff4ca-2ec2b253d64mr18240001fa.39.1718611084818;
        Mon, 17 Jun 2024 00:58:04 -0700 (PDT)
Received: from eriador.lumag.spb.ru (dzdbxzyyyyyyyyyyybrhy-3.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::b8c])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ec05bf4538sm12984411fa.4.2024.06.17.00.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 00:58:04 -0700 (PDT)
Date: Mon, 17 Jun 2024 10:58:02 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	andersson@kernel.org, ebiggers@google.com, neil.armstrong@linaro.org, 
	srinivas.kandagatla@linaro.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, 
	robh+dt@kernel.org, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	kernel@quicinc.com, linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	quic_omprsing@quicinc.com, quic_nguyenb@quicinc.com, bartosz.golaszewski@linaro.org, 
	konrad.dybcio@linaro.org, ulf.hansson@linaro.org, jejb@linux.ibm.com, 
	martin.petersen@oracle.com, mani@kernel.org, davem@davemloft.net, 
	herbert@gondor.apana.org.au, psodagud@quicinc.com, quic_apurupa@quicinc.com, 
	sonalg@quicinc.com
Subject: Re: [PATCH v5 05/15] soc: qcom: ice: support for hardware wrapped
 keys
Message-ID: <nvs6pb3nvrtwljbvc5erwhxr6vj6o2p34emggglr3iuitijihq@uf37shcw57bm>
References: <20240617005825.1443206-1-quic_gaurkash@quicinc.com>
 <20240617005825.1443206-6-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617005825.1443206-6-quic_gaurkash@quicinc.com>

On Sun, Jun 16, 2024 at 05:51:00PM GMT, Gaurav Kashyap wrote:
> Now that HWKM support is added to ICE, extend the ICE
> driver to support hardware wrapped keys programming coming
> in from the storage controllers (ufs and emmc). This is
> similar to standard keys where the call is forwarded to

standard keys = ?

> Trustzone, however certain wrapped key and HWKM specific
> actions has to be performed around the SCM calls.

which actions? Be specific here.


> 
> Derive software secret support is also added by forwarding the
> call to the corresponding scm api.
> 
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/soc/qcom/ice.c | 119 +++++++++++++++++++++++++++++++++++++----
>  include/soc/qcom/ice.h |   4 ++
>  2 files changed, 112 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index d5e74cf2946b..f0e9e0885732 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -27,6 +27,8 @@
>  #define QCOM_ICE_REG_BIST_STATUS		0x0070
>  #define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
>  #define QCOM_ICE_REG_CONTROL			0x0
> +#define QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16		0x4040
> +
>  /* QCOM ICE HWKM registers */
>  #define QCOM_ICE_REG_HWKM_TZ_KM_CTL			0x1000
>  #define QCOM_ICE_REG_HWKM_TZ_KM_STATUS			0x1004
> @@ -68,6 +70,8 @@
>  #define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
>  #define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
>  
> +#define QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET	0x80
> +
>  #define QCOM_ICE_HWKM_REG_OFFSET	0x8000
>  #define HWKM_OFFSET(reg)		((reg) + QCOM_ICE_HWKM_REG_OFFSET)
>  
> @@ -88,6 +92,16 @@ struct qcom_ice {
>  	bool hwkm_init_complete;
>  };
>  
> +union crypto_cfg {
> +	__le32 regval;
> +	struct {
> +		u8 dusize;
> +		u8 capidx;
> +		u8 reserved;
> +		u8 cfge;
> +	};
> +};
> +
>  static bool qcom_ice_check_supported(struct qcom_ice *ice)
>  {
>  	u32 regval = qcom_ice_readl(ice, QCOM_ICE_REG_VERSION);
> @@ -298,6 +312,51 @@ int qcom_ice_suspend(struct qcom_ice *ice)
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_suspend);
>  
> +/*
> + * HW dictates the internal mapping between the ICE and HWKM slots,
> + * which are different for different versions, make the translation
> + * here. For v1 however, the translation is done in trustzone.

THis doesn't really help.

> + */
> +static int translate_hwkm_slot(struct qcom_ice *ice, int slot)
> +{
> +	return (ice->hwkm_version == 1) ? slot : (slot * 2);
> +}
> +
> +static int qcom_ice_program_wrapped_key(struct qcom_ice *ice,
> +					const struct blk_crypto_key *key,
> +					u8 data_unit_size, int slot)
> +{
> +	union crypto_cfg cfg;
> +	int hwkm_slot;
> +	int err;
> +
> +	hwkm_slot = translate_hwkm_slot(ice, slot);
> +
> +	memset(&cfg, 0, sizeof(cfg));
> +	cfg.dusize = data_unit_size;
> +	cfg.capidx = QCOM_SCM_ICE_CIPHER_AES_256_XTS;
> +	cfg.cfge = 0x80;
> +
> +	/* Clear CFGE */
> +	qcom_ice_writel(ice, 0x0, QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16 +
> +				  QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET * slot);

#define register address instead.

> +
> +	/* Call trustzone to program the wrapped key using hwkm */
> +	err = qcom_scm_ice_set_key(hwkm_slot, key->raw, key->size,
> +				   QCOM_SCM_ICE_CIPHER_AES_256_XTS, data_unit_size);
> +	if (err) {
> +		pr_err("%s:SCM call Error: 0x%x slot %d\n", __func__, err,
> +		       slot);
> +		return err;
> +	}
> +
> +	/* Enable CFGE after programming key */
> +	qcom_ice_writel(ice, cfg.regval, QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16 +
> +					 QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET * slot);
> +
> +	return err;
> +}
> +
>  int qcom_ice_program_key(struct qcom_ice *ice,
>  			 u8 algorithm_id, u8 key_size,
>  			 const struct blk_crypto_key *bkey,


-- 
With best wishes
Dmitry
