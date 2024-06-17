Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B13018FDAD
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 07:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718611188; cv=none; b=J0v5nbMv1ZxIC/vimgRCXp5hqJ0wmyC+K3bMWQqoiukfb0CpZ+sxiHMLBkpwHOqWRELFAoeypn4fzrAqSaICkEuu7fUz77bXU4F4eI1svJ4LM9gPpMC9P6nCoa5gt+OESCID3I0emxaE8prU0DEIo9/oTLx5PnynqwOlOQ40PVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718611188; c=relaxed/simple;
	bh=oLDzlSODJljzUKjcR6ta6ivMALGSpYL+FSN5LvaAeCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p26kXY/Vyl0hXh2oDsKEgM1efGsiv6Ubr7Vd5+wMOkjXAEuLU2ZBbklpWhC6gIbbaMBWfNCSLgBwY40epFQQQsVoto3Ru6X0gh9v259WkqW5XhLBe9gnVzbi9qiH603rGBjTkmURQo7aV6vITOX54xX66ITHfpbLyHHDoUaqRmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Md/zH0G5; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Md/zH0G5"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52b7e693b8aso4441415e87.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 00:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718611185; x=1719215985; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w7rDWn7Lx3IDkThbHypTiJWDbgdPwp60eh3YBpuQo+k=;
        b=Md/zH0G51BM7gQGnwwvkg/QXvUkCYYrX68mQXZmjT0wO/tHudvwGiNByEgwA7zwVbX
         VVrF9N5DmWncGgSwqhYONB5vGoggFquXqJM+x1vKkqWKD2JP1EUKOJtwlFfcmLyGQuRm
         fv8P6rdSFAPPqiqBBjHgN56zOZXPZMySbGijTzKenVE4GPmTleOKf2HG/LiwP+5YlgqQ
         LZkEkYGmSX+At9kRyRZOdpCegtbsao+MOmaDF4FNQ6oqtw/ev1hbs+FtEcbM7IhmsPb2
         /1Qi86ar3LbnPJaB+MvKo3ly5chRNB6XimRfF+o4+E7X5oazu+/C9rCM4OXxK3vSrtLW
         zR2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718611185; x=1719215985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w7rDWn7Lx3IDkThbHypTiJWDbgdPwp60eh3YBpuQo+k=;
        b=ee75mrv9tWzgg8HjSSKqnrY+3luqCYHhejgpM1yLjhEAIfO40KA8Y5aDWFvQANGsxH
         R5NLCUKSlziYRzF/fnADtvYBXQhhw1WYxEdk76FYB8uvmMxTNniiwjUiPpoc5O3mOAdF
         dBY0yE022bC8pXsCI0aphNadscVyhfZLAiz+pGKGovWgURQ3zVmifDx7JVNFhWyWNBhN
         yOyNfwjH0r/n5QymsWwomR9bf+vPqxJs5c/6a/ZcAeqAk5tk89+A/8DUZ37i2m9rIukl
         S/yhh2beu7/+0YaPZlyosxsi3ZfTpKGfwwxiVdCUFqsYKYoHb/Hp4LFovFIGWotG4tQi
         a5lg==
X-Forwarded-Encrypted: i=1; AJvYcCWV4C6RH4n0Y/lNNWqr9ujt1n0Vpmk7pvaPeje+2iRpi5WanByosEoeYevNsMKpRWGHQgAZsHWxusyzOGAmw8VRJus8VxCnncFV6A==
X-Gm-Message-State: AOJu0YzKDvG/DohT2syfIZK2Gp7w40MQ53tsL9eINSXL4KqAJ8am/sot
	JCrsP4lM4sxVVF48VMrwT2tYhnnZqsF5SJTr+znVAtWAv7NGeYtixutF9GuJowg=
X-Google-Smtp-Source: AGHT+IF+CZ8uto5qKLok/n5CxOYFdsmEC2fcv9V6Dp6NxoXRmQwKWeqIjMRdtYCqhKsJHuVgzAV8Kw==
X-Received: by 2002:a05:6512:ba0:b0:52c:8dea:c56f with SMTP id 2adb3069b0e04-52ca6cc6e6bmr3707383e87.25.1718611185356;
        Mon, 17 Jun 2024 00:59:45 -0700 (PDT)
Received: from eriador.lumag.spb.ru (dzdbxzyyyyyyyyyyybrhy-3.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::b8c])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ca282573esm1177689e87.45.2024.06.17.00.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 00:59:44 -0700 (PDT)
Date: Mon, 17 Jun 2024 10:59:43 +0300
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
Subject: Re: [PATCH v5 06/15] soc: qcom: ice: support for generate, import
 and prepare key
Message-ID: <y3p55nrjrdm3mnz23ljg5odc2oley2k2zqnbjo5g4h7oqk2mue@thqdtm44rouu>
References: <20240617005825.1443206-1-quic_gaurkash@quicinc.com>
 <20240617005825.1443206-7-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617005825.1443206-7-quic_gaurkash@quicinc.com>

On Sun, Jun 16, 2024 at 05:51:01PM GMT, Gaurav Kashyap wrote:
> Wrapped key creation and management using HWKM is currently
> supported only through Qualcomm's Trustzone.
> Three new SCM calls have already been added in the scm layer
> for this purpose.
> 
> This patch adds support for generate, prepare and import key
> apis in ICE module and hooks it up the scm calls defined for them.
> This will eventually plug into the new IOCTLS added for this
> usecase in the block layer.

Documentation/process/submitting-patches.rst. "This patch..."

> 
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/soc/qcom/ice.c | 75 ++++++++++++++++++++++++++++++++++++++++++
>  include/soc/qcom/ice.h |  8 +++++
>  2 files changed, 83 insertions(+)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index f0e9e0885732..68062b27f40c 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -21,6 +21,13 @@
>  
>  #define AES_256_XTS_KEY_SIZE			64
>  
> +/*
> + * Wrapped key sizes that HWKM expects and manages is different for different
> + * versions of the hardware.
> + */
> +#define QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(v)	\
> +	((v) == 1 ? 68 : 100)
> +
>  /* QCOM ICE registers */
>  #define QCOM_ICE_REG_VERSION			0x0008
>  #define QCOM_ICE_REG_FUSE_SETTING		0x0010
> @@ -445,6 +452,74 @@ int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wkey[],
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_derive_sw_secret);
>  
> +/**
> + * qcom_ice_generate_key() - Generate a wrapped key for inline encryption
> + * @lt_key: longterm wrapped key that is generated, which is
> + *          BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
> + *
> + * Make a scm call into trustzone to generate a wrapped key for storage
> + * encryption using hwkm.
> + *
> + * Return: lt wrapped key size on success; err on failure.

This is incorrect.

> + */
> +int qcom_ice_generate_key(struct qcom_ice *ice,
> +			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
> +{
> +	size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
> +
> +	if (!qcom_scm_generate_ice_key(lt_key, wk_size))
> +		return wk_size;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_generate_key);
> +
> +/**
> + * qcom_ice_prepare_key() - Prepare a longterm wrapped key for inline encryption
> + * @lt_key: longterm wrapped key that is generated or imported.
> + * @lt_key_size: size of the longterm wrapped_key
> + * @eph_key: wrapped key returned which has been wrapped with a per-boot ephemeral key,
> + *           size of which is BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
> + *
> + * Make a scm call into trustzone to prepare a wrapped key for storage
> + * encryption by rewrapping the longterm wrapped key with a per boot ephemeral
> + * key using hwkm.
> + *
> + * Return: eph wrapped key size on success; err on failure.

And this too.

> + */
> +int qcom_ice_prepare_key(struct qcom_ice *ice, const u8 *lt_key, size_t lt_key_size,
> +			 u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
> +{
> +	size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
> +
> +	if (!qcom_scm_prepare_ice_key(lt_key, lt_key_size, eph_key, wk_size))
> +		return wk_size;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_prepare_key);
> +
> +/**
> + * qcom_ice_import_key() - Import a raw key for inline encryption
> + * @imp_key: raw key that has to be imported
> + * @imp_key_size: size of the imported key
> + * @lt_key: longterm wrapped key that is imported, which is
> + *          BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
> + *
> + * Make a scm call into trustzone to import a raw key for storage encryption
> + * and generate a longterm wrapped key using hwkm.
> + *
> + * Return: lt wrapped key size on success; err on failure.

Guess, this is incorrect too.

> + */
> +int qcom_ice_import_key(struct qcom_ice *ice, const u8 *imp_key, size_t imp_key_size,
> +			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
> +{
> +	size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
> +
> +	if (!qcom_scm_import_ice_key(imp_key, imp_key_size, lt_key, wk_size))
> +		return wk_size;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_import_key);
> +
>  static struct qcom_ice *qcom_ice_create(struct device *dev,
>  					void __iomem *base)
>  {
> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index dabe0d3a1fd0..dcf277d196ff 100644
> --- a/include/soc/qcom/ice.h
> +++ b/include/soc/qcom/ice.h
> @@ -39,5 +39,13 @@ bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
>  int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wkey[],
>  			      unsigned int wkey_size,
>  			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
> +int qcom_ice_generate_key(struct qcom_ice *ice,
> +			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
> +int qcom_ice_prepare_key(struct qcom_ice *ice,
> +			 const u8 *lt_key, size_t lt_key_size,
> +			 u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
> +int qcom_ice_import_key(struct qcom_ice *ice,
> +			const u8 *imp_key, size_t imp_key_size,
> +			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
>  struct qcom_ice *of_qcom_ice_get(struct device *dev);
>  #endif /* __QCOM_ICE_H__ */
> -- 
> 2.43.0
> 

-- 
With best wishes
Dmitry
