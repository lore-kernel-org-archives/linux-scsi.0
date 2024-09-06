Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C551F15A87A
	for <linux-scsi@vger.kernel.org>; Fri,  6 Sep 2024 22:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725660442; cv=none; b=Lo0vx4MjbtRKIUKciYPTiUUHK8O9jEgCSdVlj98zp44uFAEfw27J9Bqe0z8iuITLRtOGDJfVPqSCfJy30pRxS04aN8lymEHaPo7fhpIZcr0tG8VAFcGEmZjULGpCA9trPyoLRVH+OjckgAdNVmD9SIHcdnxgxIXYKHRfzRcY/DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725660442; c=relaxed/simple;
	bh=DMDXUtr2tKydRZROnQMaVv9GRGluLW3xfbvWKrH84YM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oY7EG3efB5F3XzBb6TbE2hjBvwY3J94X7k0z416Ky+iwyy8kjhgaDTw74vWkSqIJrnTUggaLZ+zmdAP+Tm9cuNWbP3puAOi/vGKwXLZ3RRRcrqi6RnMa6Ce4RytnaTgYz4UjkXxnFRbl1kUpIFrbPWyciibmDzEOYli6ROyWhZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kaQN6uA+; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kaQN6uA+"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5356bb55224so3123830e87.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Sep 2024 15:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725660439; x=1726265239; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6HOhtyEYYt7rA6jCBX+L1mlm8hngGJHlfFCxxooVTC4=;
        b=kaQN6uA+5cYL38uaZLKBGyobZmQgr12YaaCLn80DRzBTFtLrZuxB9OfNnowN+YWS0/
         EZ0gQ3vWXINxF5r6dptQxWlxL/HsAJSIa84VDdlUnGPTF5YbPo+W6DfbkDoaMcVR15/x
         wFYLJhsb3PRYorSk0ZQaKryX5jPKwfekTUBAabltz/SA2X/sfyn5OaZMVJMgh/Apcdek
         61nJUyQ2IXVMaSJKQdyr/p+3t8Q8WSzxqpGCL6dBAsHVzmADYQ/vBUUrEnRy0xC9jOc6
         5SFk5FiKfO6nWnqqYh04CF4UcyB1vemf2TMzQb4F5yBJ+klIumSK8vzj0NAZAjlnccDI
         J2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725660439; x=1726265239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6HOhtyEYYt7rA6jCBX+L1mlm8hngGJHlfFCxxooVTC4=;
        b=RJujPf1MTc7qe1SLdDVhgBO4RQIxtPrqiB3yyYae+y2lpXXvtIURhCe2HdaAhuCIyG
         FT0Q1lFKwVqOEu7XGTTcOtcX17AtAYuWFAzBSJr5/dSTK6AjapB1tS2/m6a4tX2uBU/a
         EDD7KHp60Flxb5kspiFHjZq5XUzLm/yFCr5ooS+539r4j/bVFnHxdQifUEIokkj0KiVW
         jxhEYoBj3+0n6IvH3Ki7F6nhsKNpp3KA/cLaRgUzcBddJDB5RWtUJaat/T+EH7SsL2aL
         jWeaWovHcqOkjG7LDvYofz2/UUTJJbW0rgxPm0SGSx4lyejK1O+x/KT5JKlxr1FKr5LK
         1PfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXB9WoPTWdNi4pwpygSidLxzOdpYr0ojkeKAtIB3l6v5pZ0SrxzSTr1MK+Y1uwZdtGIYn3bd+W0YfXU@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1c8j7cZZ2F7P6Mv8B99bvyZSr5EUSlkXc8uzogqHsp3t4Vnwv
	D1AZPhvuzN2qcjfb7vDTUdZl/SOOeck+5Z+BnpRNJjJ2dClrHqBav0uaxgQHs+U=
X-Google-Smtp-Source: AGHT+IGo5Rf50EbBmOUBUAeWLcQnh0sLqD8vtwGBMm3Zld7y3VkY79ttTtwoqkfdSYGppGMy/IXnlA==
X-Received: by 2002:a05:6512:280d:b0:530:ba4b:f65d with SMTP id 2adb3069b0e04-536587b4b74mr2903071e87.28.1725660438133;
        Fri, 06 Sep 2024 15:07:18 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-536536a12f4sm529135e87.230.2024.09.06.15.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:07:17 -0700 (PDT)
Date: Sat, 7 Sep 2024 01:07:16 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Asutosh Das <quic_asutoshd@quicinc.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Gaurav Kashyap <quic_gaurkash@quicinc.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v6 09/17] soc: qcom: ice: add HWKM support to the ICE
 driver
Message-ID: <7uoq72bpiqmo2olwpnudpv3gtcowpnd6jrifff34ubmfpijgc6@k6rmnalu5z4o>
References: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
 <20240906-wrapped-keys-v6-9-d59e61bc0cb4@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906-wrapped-keys-v6-9-d59e61bc0cb4@linaro.org>

On Fri, Sep 06, 2024 at 08:07:12PM GMT, Bartosz Golaszewski wrote:
> From: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> 
> Qualcomm's ICE (Inline Crypto Engine) contains a proprietary key
> management hardware called Hardware Key Manager (HWKM). Add HWKM support
> to the ICE driver if it is available on the platform. HWKM primarily
> provides hardware wrapped key support where the ICE (storage) keys are
> not available in software and instead protected in hardware.
> 
> When HWKM software support is not fully available (from Trustzone), there
> can be a scenario where the ICE hardware supports HWKM, but it cannot be
> used for wrapped keys. In this case, raw keys have to be used without
> using the HWKM. We query the TZ at run-time to find out whether wrapped
> keys support is available.
> 
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  drivers/soc/qcom/ice.c | 152 +++++++++++++++++++++++++++++++++++++++++++++++--
>  include/soc/qcom/ice.h |   1 +
>  2 files changed, 149 insertions(+), 4 deletions(-)
> 
>  int qcom_ice_enable(struct qcom_ice *ice)
>  {
> +	int err;
> +
>  	qcom_ice_low_power_mode_enable(ice);
>  	qcom_ice_optimization_enable(ice);
>  
> -	return qcom_ice_wait_bist_status(ice);
> +	if (ice->use_hwkm)
> +		qcom_ice_enable_standard_mode(ice);
> +
> +	err = qcom_ice_wait_bist_status(ice);
> +	if (err)
> +		return err;
> +
> +	if (ice->use_hwkm)
> +		qcom_ice_hwkm_init(ice);
> +
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_enable);
>  
> @@ -150,6 +282,10 @@ int qcom_ice_resume(struct qcom_ice *ice)
>  		return err;
>  	}
>  
> +	if (ice->use_hwkm) {
> +		qcom_ice_enable_standard_mode(ice);
> +		qcom_ice_hwkm_init(ice);
> +	}
>  	return qcom_ice_wait_bist_status(ice);
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_resume);
> @@ -157,6 +293,7 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
>  int qcom_ice_suspend(struct qcom_ice *ice)
>  {
>  	clk_disable_unprepare(ice->core_clk);
> +	ice->hwkm_init_complete = false;
>  
>  	return 0;
>  }
> @@ -206,6 +343,12 @@ int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
>  
> +bool qcom_ice_hwkm_supported(struct qcom_ice *ice)
> +{
> +	return ice->use_hwkm;
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
> +
>  static struct qcom_ice *qcom_ice_create(struct device *dev,
>  					void __iomem *base)
>  {
> @@ -240,6 +383,7 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>  		engine->core_clk = devm_clk_get_enabled(dev, NULL);
>  	if (IS_ERR(engine->core_clk))
>  		return ERR_CAST(engine->core_clk);
> +	engine->use_hwkm = qcom_scm_has_wrapped_key_support();

This still makes the decision on whether to use HW-wrapped keys on
behalf of a user. I suppose this is incorrect. The user must be able to
use raw keys even if HW-wrapped keys are available on the platform. One
of the examples for such use-cases is if a user prefers to be able to
recover stored information in case of a device failure (such recovery
will be impossible if SoC is damaged and HW-wrapped keys are used).

>  
>  	if (!qcom_ice_check_supported(engine))
>  		return ERR_PTR(-EOPNOTSUPP);
> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index 9dd835dba2a7..1f52e82e3e1c 100644
> --- a/include/soc/qcom/ice.h
> +++ b/include/soc/qcom/ice.h
> @@ -34,5 +34,6 @@ int qcom_ice_program_key(struct qcom_ice *ice,
>  			 const struct blk_crypto_key *bkey,
>  			 u8 data_unit_size, int slot);
>  int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
> +bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
>  struct qcom_ice *of_qcom_ice_get(struct device *dev);
>  #endif /* __QCOM_ICE_H__ */
> 
> -- 
> 2.43.0
> 

-- 
With best wishes
Dmitry
