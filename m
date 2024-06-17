Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B80918C355
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 07:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718609995; cv=none; b=DvzrqqttQzXRP/gsKYzwiwjHWHUbGbuS4ivWOI6YKN9mo9WUySIy3ANCALTKlPNV0eZgiM1PnxF59qtGi5oM5SeligkZbyHipAjKWQku4bgCN3+/90PJs9tp0mrUdgjkVumGI/JQAcO4ql99jDLVutQvtEsZfv4EOIS9u+pxIqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718609995; c=relaxed/simple;
	bh=yol7duF39AHBHDJ3bW7xswb+YtahHMR2QynNNAB7d4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0R4rJP8MLvvyRFoMSPuzU3xYxRIip/u7NDN/CaO96E4BbkkwPWr/o8tQh10lyQe6BwzUWc3Z9SUC1+A4Hx2aUFq4Ugcvj/xAk+OTOp7cq9J9XLmgacv3NL+OeIUgPOMwPjYkjmGIlZkkJr1qts6f2y0LHA0C2vwUR4di6lolRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x+D1VxoP; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x+D1VxoP"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52c8342af5eso4330958e87.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2024 00:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718609991; x=1719214791; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i8lLylZj7oqp2Yh/vHMscucSPMa8WUZ6gNNFNC8Te4Q=;
        b=x+D1VxoPWJBZd73DAlfqcFGPw1i1bWyvKohDVsqKOFFYyEbGBOKO81TiuymTu7Z8L7
         Aq8X1f+X08cCLzYBYNShD2yKUYjz+aKF7tVA+oHxUAnVyGGDXY4tiE3uDngkUfxPzo7M
         /qXdzFzJSgvCnY3Ou4dbTEFc//Cc5dPOlSPX4rFa+t1k6HS/QtkOKtJc82oZaiRX11rx
         a6TG38Kv+0fGPS6yU+/fmppLRGk3bFJTivqb24HInBGOVJwmsC45tWUrFNOvqqPAWp37
         IzpDsPIwkGqXEGlpcqmH5Hy4hF9YFqar1KxlYv1mdR9FsqSEnJjmEFrGFYeGnFT8bDEQ
         asiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718609991; x=1719214791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8lLylZj7oqp2Yh/vHMscucSPMa8WUZ6gNNFNC8Te4Q=;
        b=pGYnFOzcaq4ruBXERb0Uz/JoxOlaeEIJR+wQrPlYStrH8JvHTdVuOErJU7haiRzLGF
         UPGI/IWOCsaAGZD5+GC6DWvusvhF3RvVil6ceYQPiEbl//qAHwgl8F/QnYDIkcKy2bHW
         EL3w219huXRXXgYr6vipr6FAgvYEm5pJ8TB0UPsrDGm2YYTy/Tt9Yn/S6dViCrDxQU5r
         n+/39uqza3aU/iZDJ00TcUf/1lrOUesgV50JjWggsBZVI2FuzqbVxNX3o5rKfv5JufBp
         OD/8j9cCShBw1seydLavvgsCalwfoWfipwJjhPGRcyvrdY8ZDfnM1YCb6ak1GdK7cD+V
         kSsg==
X-Forwarded-Encrypted: i=1; AJvYcCU5BINvbUwbnf6xLFjjTd6dyK72ox4Y1x7/bxcVtJ4zBh8fvAn2TWtOv+NPCvgDRlo6BXQk5NF5qtDiNbTSWdS08wVoicbaenFy/A==
X-Gm-Message-State: AOJu0YxANITTJKgTZRIlXhAKzGkqWAmQ3+zG8AweRyVeJF+LRMQp7RpU
	B0aFImSJ+0rqznq2fAx8eFME6NycieMwT3+G89uCprh2+PpeifKoeOSEgjnYYcWnry73w/a723J
	omWs=
X-Google-Smtp-Source: AGHT+IFB7nme6S/NOooTttRkHVLJuEXyYIyqCbfXGGUwcCzbspqei2vyV5eXVyi60i9oqlhQo95d8g==
X-Received: by 2002:a05:6512:130e:b0:52c:8f4a:9200 with SMTP id 2adb3069b0e04-52ca6e9897emr7642250e87.65.1718609991561;
        Mon, 17 Jun 2024 00:39:51 -0700 (PDT)
Received: from eriador.lumag.spb.ru (dzdbxzyyyyyyyyyyybrhy-3.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::b8c])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ca2825711sm1175490e87.21.2024.06.17.00.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 00:39:51 -0700 (PDT)
Date: Mon, 17 Jun 2024 10:39:49 +0300
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
Subject: Re: [PATCH v5 03/15] qcom_scm: scm call for create, prepare and
 import keys
Message-ID: <jqfo7hrkdefrxhycahwelmbluvesum4pmrlefxfn2bszv3iqjc@nhx633d2xbw6>
References: <20240617005825.1443206-1-quic_gaurkash@quicinc.com>
 <20240617005825.1443206-4-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617005825.1443206-4-quic_gaurkash@quicinc.com>

On Sun, Jun 16, 2024 at 05:50:58PM GMT, Gaurav Kashyap wrote:
> Storage encryption has two IOCTLs for creating, importing
> and preparing keys for encryption. For wrapped keys, these
> IOCTLs need to interface with Qualcomm's Trustzone, which
> require these SCM calls.
> 
> generate_key: This is used to generate and return a longterm
>               wrapped key. Trustzone achieves this by generating
> 	      a key and then wrapping it using hwkm, returning
> 	      a wrapped keyblob.
> import_key:   The functionality is similar to generate, but here,
>               a raw key is imported into hwkm and a longterm wrapped
> 	      keyblob is returned.
> prepare_key:  The longterm wrapped key from import or generate
>               is made further secure by rewrapping it with a per-boot
> 	      ephemeral wrapped key before installing it to the linux
> 	      kernel for programming to ICE.
> 
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/firmware/qcom/qcom_scm.c       | 175 +++++++++++++++++++++++++
>  drivers/firmware/qcom/qcom_scm.h       |   3 +
>  include/linux/firmware/qcom/qcom_scm.h |   5 +
>  3 files changed, 183 insertions(+)
> 
> diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
> index 8f23b459c525..61a1ace3c683 100644
> --- a/drivers/firmware/qcom/qcom_scm.c
> +++ b/drivers/firmware/qcom/qcom_scm.c
> @@ -1309,6 +1309,181 @@ int qcom_scm_derive_sw_secret(const u8 *wkey, size_t wkey_size,
>  }
>  EXPORT_SYMBOL_GPL(qcom_scm_derive_sw_secret);
>  
> +/**
> + * qcom_scm_generate_ice_key() - Generate a wrapped key for encryption.
> + * @lt_key: the wrapped key returned after key generation
> + * @lt_key_size: size of the wrapped key to be returned.
> + *
> + * Qualcomm wrapped keys need to be generated in a trusted environment.
> + * A generate key IOCTL call is used to achieve this. These are longterm
> + * in nature as they need to be generated and wrapped only once per
> + * requirement.
> + *
> + * Adds support for the create key IOCTL to interface
> + * with the secure environment to generate and return a wrapped key..

This is documentation to a function, not a changelog. Also the function
helps implementing the IOCTL. Please describe the call itself and its
behaviour. Something like:

Generate a key using built-in entropy source (or using this-and-that
PRNG) inside TZ. Wrap the key using the platform-specific
(board-specific?) Key Encryption Key and return to the caller.

The same comment applies to other SCM calls added in this patch.

-- 
With best wishes
Dmitry
