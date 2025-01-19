Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D961DF721
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2025 16:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737305859; cv=none; b=A0nWtVl2qXNcLKTSRaIFyB4r8tTslpEH68XrZl20oQRK1uQS1rTgLNehL5x/P8Q/fbYAcOOieAeTTgGA8HuihIV48S/uZZj5wlY5UYZiyFMXbeX2MU8hO8gyMPbXbWGJzfE6cGju+1kC2itEk22IxH4lSQfRhaCD74rzRum0RPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737305859; c=relaxed/simple;
	bh=OXYO0T7rIEvVXR1OPVg2/XaOdqsk7JqB0nHWGkAq3C0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DsHCqJXBl/SiTEmXcsGtBKFwUMSctPfyGy8WjaDFhrnXpgXSJfPLmF7jOiGHZr0eiDrlK4tTwHDsxF3uXngZb7XKj8G2LsXPpZQ3ZsfgNOcQycJSnMUNFXUAZYenOX85QdJAsnpG8WurvcD2ENWt5WXSiueCrxIGSWJ40MyX5rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QytANKqB; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QytANKqB"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4361c705434so25570465e9.3
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2025 08:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737305856; x=1737910656; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qmmb4zqZ9p+siFdSZXdznAkxBlMcr3SpDaxiDo2SWyU=;
        b=QytANKqBNlhgeQUeujFznb2OissSo02RNtBCnzCZxx27YQD1qgVOA54c1ckXBlg52o
         mDxOkRy44Z8/XgLS9EGVHplM+Geljq/TzsFx3nlZm/jwhxNO8Xdatcc6v8Vnol0f37It
         MPpeEcwPk+wQ2XNUbV1XsMC0qZRDCFr88GA9zNEc5nNf18zzI48cBPz0Uk9BvKntt1l3
         pACuYSykRTCEWjvDeHle2pue/ky27x/fpcdp/3B/hoArQ0Wex9Kz3JBtSMtdgvYqsvpV
         rjGquyAnKyHH90txJXEPm0uFMGQR1qP0IKs9/FXAq3Afget/dL5LlhY09WOUtrfB98Ev
         IBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737305856; x=1737910656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmmb4zqZ9p+siFdSZXdznAkxBlMcr3SpDaxiDo2SWyU=;
        b=am+RJna8UUq7bOsfAmng8hYd3IWYH13rTUIYjr4PrRY0j6JKxvQVn9sVJxZ5irRJm7
         E45TVBKeIX7OfcwblMZAuiH80qvIA2esa/ix2dcPx1Ewk6PO5awffTN1Eki9DBMieWZX
         y589I5HCwKj2zWHXmnS2iCfyRw2ymX7A46ymRDLFNATNfPGhIeJ54Og2jXTKBaoaIHm2
         zpZ/jJ1+1OnornVF4YG08gEC6gXouH4Xzq+43I9RxOjy9SjuSwNKEKsD2N2AFbafUVFv
         l/FMjiqYnVNDtG4W2ybtCYupxsN1hmRdCT378vi1nov1dhXmJqyVDDol3oqZssISE7X2
         oZ+g==
X-Forwarded-Encrypted: i=1; AJvYcCXlfBGXCwwAY5k8b0JpBJ5M92/lgJMmV9SUfIAobeZX6T7OVaHfrupWS2dCtGAtNbX3VmBolq8kpE6k@vger.kernel.org
X-Gm-Message-State: AOJu0Yzopc5twVxbcsD2arr3zWosC702YW2Q5cyf53WLlsW9uCpl4crf
	ynwL0UJo7eZBryKjsjc3yDhdGRfd2LiBSA2GU/SWt/UaxDHi6iC9uW/eZ2nReNg=
X-Gm-Gg: ASbGncu0CRFEyYMoWpecdZRdFC3FAr6uXMX+sGXYIw5vAvxXSQmQ+dVRgFnrEXRdiar
	++bziP6TPgxZmvZY66ZtuyRBqHItCTIU0lNF0c8AMcz3T5knzAuCk5l4wc20na5sRL+Fd8GXmnD
	wNObBYJYnqBrUJzxoxRbd7lSTFPDiMtFWeyq2m8rPxKkcR47JREqiZS2cfuj22e/hXplmq2QRh/
	/+Qymg7bhuKfpVSNLAeGISNZGZU3EBVm9SDcfOwNPJKMHq9TEHYeKkwh7vuOt8HJt/S
X-Google-Smtp-Source: AGHT+IFIEiBSMQ4j5lMnpSAdnhTiXrPNymMtDHfM0cHBf/ZM58+IWBa3SM92dBvbDqsFvOWiTieU0Q==
X-Received: by 2002:a05:600c:510c:b0:434:a1e7:27b0 with SMTP id 5b1f17b1804b1-438913ccd4amr117549975e9.11.1737305855586;
        Sun, 19 Jan 2025 08:57:35 -0800 (PST)
Received: from linaro.org ([86.123.96.125])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4389041fe29sm107187745e9.22.2025.01.19.08.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2025 08:57:34 -0800 (PST)
Date: Sun, 19 Jan 2025 18:57:32 +0200
From: Abel Vesa <abel.vesa@linaro.org>
To: Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Eric Biggers <ebiggers@google.com>, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org, andre.draszik@linaro.org,
	peter.griffin@linaro.org, willmcvicker@google.com,
	kernel-team@android.com
Subject: Re: [PATCH v2 1/4] soc: qcom: ice: introduce devm_of_qcom_ice_get
Message-ID: <Z40u/DkEQIK9naI2@linaro.org>
References: <20250117-qcom-ice-fix-dev-leak-v2-0-1ffa5b6884cb@linaro.org>
 <20250117-qcom-ice-fix-dev-leak-v2-1-1ffa5b6884cb@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117-qcom-ice-fix-dev-leak-v2-1-1ffa5b6884cb@linaro.org>

On 25-01-17 14:18:50, Tudor Ambarus wrote:
> Callers of of_qcom_ice_get() leak the device reference taken by
> of_find_device_by_node(). Introduce devm variant for of_qcom_ice_get().
> Existing consumers need the ICE instance for the entire life of their
> device, thus exporting qcom_ice_put() is not required.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>

Good catch. LGTM.

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>

> ---
>  drivers/soc/qcom/ice.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/soc/qcom/ice.h |  2 ++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 393d2d1d275f..79e04bff3e33 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -11,6 +11,7 @@
>  #include <linux/cleanup.h>
>  #include <linux/clk.h>
>  #include <linux/delay.h>
> +#include <linux/device.h>
>  #include <linux/iopoll.h>
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
> @@ -324,6 +325,53 @@ struct qcom_ice *of_qcom_ice_get(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(of_qcom_ice_get);
>  
> +static void qcom_ice_put(const struct qcom_ice *ice)
> +{
> +	struct platform_device *pdev = to_platform_device(ice->dev);
> +
> +	if (!platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice"))
> +		platform_device_put(pdev);
> +}
> +
> +static void devm_of_qcom_ice_put(struct device *dev, void *res)
> +{
> +	qcom_ice_put(*(struct qcom_ice **)res);
> +}
> +
> +/**
> + * devm_of_qcom_ice_get() - Devres managed helper to get an ICE instance from
> + * a DT node.
> + * @dev: device pointer for the consumer device.
> + *
> + * This function will provide an ICE instance either by creating one for the
> + * consumer device if its DT node provides the 'ice' reg range and the 'ice'
> + * clock (for legacy DT style). On the other hand, if consumer provides a
> + * phandle via 'qcom,ice' property to an ICE DT, the ICE instance will already
> + * be created and so this function will return that instead.
> + *
> + * Return: ICE pointer on success, NULL if there is no ICE data provided by the
> + * consumer or ERR_PTR() on error.
> + */
> +struct qcom_ice *devm_of_qcom_ice_get(struct device *dev)
> +{
> +	struct qcom_ice *ice, **dr;
> +
> +	dr = devres_alloc(devm_of_qcom_ice_put, sizeof(*dr), GFP_KERNEL);
> +	if (!dr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ice = of_qcom_ice_get(dev);
> +	if (!IS_ERR_OR_NULL(ice)) {
> +		*dr = ice;
> +		devres_add(dev, dr);
> +	} else {
> +		devres_free(dr);
> +	}
> +
> +	return ice;
> +}
> +EXPORT_SYMBOL_GPL(devm_of_qcom_ice_get);
> +
>  static int qcom_ice_probe(struct platform_device *pdev)
>  {
>  	struct qcom_ice *engine;
> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index 5870a94599a2..d5f6a228df65 100644
> --- a/include/soc/qcom/ice.h
> +++ b/include/soc/qcom/ice.h
> @@ -34,4 +34,6 @@ int qcom_ice_program_key(struct qcom_ice *ice,
>  			 int slot);
>  int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
>  struct qcom_ice *of_qcom_ice_get(struct device *dev);
> +struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
> +
>  #endif /* __QCOM_ICE_H__ */
> 
> -- 
> 2.48.0.rc2.279.g1de40edade-goog
> 
