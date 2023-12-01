Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sm4ZZFq9"
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F5DD3
	for <linux-scsi@vger.kernel.org>; Fri,  1 Dec 2023 09:49:36 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-40b4f6006d5so22994435e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Dec 2023 09:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701452975; x=1702057775; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c3XtzzjFOgOD7S4u56J6oC5ewGwOzGezjwSu4l5fq5g=;
        b=sm4ZZFq91CY8lte9F47e4X3zAOAXsm8t0eBH4BO5uNmn8snvKeCbHYnHIAp2JWAAtW
         MG1DDiYdDAIvxQp1y8Ld80lV3YYSKMR+bpPEsVMn9dXe0Q+9XYux5wRuMRhegWh5xNAa
         Ymii+///SgDCozKE9LYdr+r3o2yQYeU72SualleKfb84fsqpEK0U209KwA5StV97OF6W
         2I59evkBsqq3QaEOQE/U755uBLCo9YjoqiZFYbPK1sBGmD1yhSi5lkD+sGMN256xQctB
         l9thj3vJV+iz5nuJZZ1YmWWNpzdJSLQBC5gBoz+sGNvw9xUUSqxawKIhECfZ0C3XKYbL
         c9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701452975; x=1702057775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3XtzzjFOgOD7S4u56J6oC5ewGwOzGezjwSu4l5fq5g=;
        b=VFZkpmYcJoUw7VVvZjkTzUS4EztgvUrPfOvAyI/5W5K8wBLhABm3tyY4OUf6gb9RHR
         UhRzIsy+8x34A9qFjM/Z3RTj7ugQ9xUNV024BQYimAs5OpL+vTh0vUytYnOQGOTlToVh
         brvcraBbdVYOFJg7QSWnomWA4S1VzEvryfQ9R0qPKywEnjqsAdfm3KH1DbQEKBCEfeFv
         LWi6hrj/NlX+5xW30BUj8DAFxfFicmkdnO0PPz3KA2YffbvndVdWs07qKgdRNPPVahQn
         C7LxNhWrSYseOA+6VIX6kB1C6Cch3yOWX29Su3eg5ZRa8ZToDlw5HdX1jQnszlxXdqi5
         zb6A==
X-Gm-Message-State: AOJu0YwL8kRxiHeBnJl9pirqVYxkNyM3uwiRe8WZYxV5aGgB6N2Ibqa0
	wnVSP4qzqYBQKGaP5VejtTMZ2g==
X-Google-Smtp-Source: AGHT+IFHuFmbI9cOvT54OXa90QPoF6aFMDHPdlfYs5Ijr3TiN58L/m9EWHXlGpDb4KgfEboYZKC0EQ==
X-Received: by 2002:a05:600c:4f03:b0:40b:2a15:9b30 with SMTP id l3-20020a05600c4f0300b0040b2a159b30mr447078wmq.1.1701452975070;
        Fri, 01 Dec 2023 09:49:35 -0800 (PST)
Received: from linaro.org ([82.77.85.67])
        by smtp.gmail.com with ESMTPSA id dl17-20020a0560000b9100b003316debbde4sm4777931wrb.48.2023.12.01.09.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 09:49:34 -0800 (PST)
Date: Fri, 1 Dec 2023 19:49:32 +0200
From: Abel Vesa <abel.vesa@linaro.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org,
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	quic_cang@quicinc.com
Subject: Re: [PATCH 02/13] scsi: ufs: qcom: Fix the return value of
 ufs_qcom_ice_program_key()
Message-ID: <ZWocrM0guCvGSRrQ@linaro.org>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
 <20231201151417.65500-3-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201151417.65500-3-manivannan.sadhasivam@linaro.org>

On 23-12-01 20:44:06, Manivannan Sadhasivam wrote:
> Currently, the function returns -EINVAL if algorithm other than AES-256-XTS
> is requested. But the correct error code is -EOPNOTSUPP. Fix it!
> 
> Cc: Abel Vesa <abel.vesa@linaro.org>
> Fixes: 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

LGTM.

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>

> ---
>  drivers/ufs/host/ufs-qcom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index cbb6a696cd97..852179e456f2 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -158,7 +158,7 @@ static int ufs_qcom_ice_program_key(struct ufs_hba *hba,
>  	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
>  	if (cap.algorithm_id != UFS_CRYPTO_ALG_AES_XTS ||
>  	    cap.key_size != UFS_CRYPTO_KEY_SIZE_256)
> -		return -EINVAL;
> +		return -EOPNOTSUPP;
>  
>  	if (config_enable)
>  		return qcom_ice_program_key(host->ice,
> -- 
> 2.25.1
> 
