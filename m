Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ei+Kw6Rd"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B6A135
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 10:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701888892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2T2oM8n7ES3F56mk7P89karRriuSouYwO1C14uj3RQs=;
	b=Ei+Kw6Rdi6/Ly9WMK1Nk1jK82EfWCRtS6uCuKQp0Ak9k4MN2/h4OzttNROMzh9NOVrdsu5
	xBtFrjT5LPKMWAhnvzZd20FYDIYcxES9r8PBW3OmkQLar27PvbW8fl5EuzYdKhQYxhWWQQ
	BJYEeh5t+MVPhs9z6I9PHmqKfqStQW4=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-z5w73h2gNVamrwP4HuCN6A-1; Wed, 06 Dec 2023 13:52:43 -0500
X-MC-Unique: z5w73h2gNVamrwP4HuCN6A-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-58e157f489dso216916eaf.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 10:52:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701888758; x=1702493558;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2T2oM8n7ES3F56mk7P89karRriuSouYwO1C14uj3RQs=;
        b=k+hBhFuD6LXcMKvxilWL8rCGTDkDOCiFFBBtVH2toSbRVCiASN6c4+XHcUheTKs9hB
         ksPZRS4KAWmC6wkJ+BXNQ72CkiOASXGmE3BjtCznk4GhHwmvxRRpqs1A3xYn8bMWWvrU
         Xu4C/GrUOqbIuwBVZhCMtkv8lDMNapNW+hIEQTb23LPS4Z87eQznVst9scp4ryADT+XB
         8Itx4kzUJsp8EUG+ZvzCplMvClhcI/Xhsbb8MmAbcC6JAjkugvyIZwZYeIFNAZPuTZdI
         DwlQBKlpaANzNTOA3uEYY2Xxwm18esVpu9AK8ulWAjzzUt+LhOUFy44OhYsGEYM85DgN
         MA3Q==
X-Gm-Message-State: AOJu0Yx/rna4m1QfFIbRziFkae+RVLpygBI5KB98OrzWoUicaNm8iLB3
	tObA7uJ50y1turwf+02zA2z6IZa/WBOv4C3SFZJ6wloM75fS1TAM9CGYULHUCqA4eU23nloTOAl
	n+AztfHD442gPkH6NDtd0Yw==
X-Received: by 2002:a05:6358:9049:b0:170:982:5611 with SMTP id f9-20020a056358904900b0017009825611mr1734950rwf.32.1701888758719;
        Wed, 06 Dec 2023 10:52:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFGWWO9/aICv0W0WM3P+DYCIxzbBCoWdkWyVRrfijwhjBdH3/PviMW3Ncuu5AZPyvNFq7pIKg==
X-Received: by 2002:a05:6358:9049:b0:170:982:5611 with SMTP id f9-20020a056358904900b0017009825611mr1734939rwf.32.1701888758442;
        Wed, 06 Dec 2023 10:52:38 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id s6-20020ad45006000000b0067a3ad49979sm185483qvo.96.2023.12.06.10.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:52:38 -0800 (PST)
Date: Wed, 6 Dec 2023 12:52:36 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com
Subject: Re: [PATCH 10/13] scsi: ufs: qcom: Use dev_err_probe() to simplify
 error handling of devm_gpiod_get_optional()
Message-ID: <swt7fadd6cpi3tfyphpuhv5omlr3jzc6uipc246f7flritnufs@4hjdjfjnydgr>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
 <20231201151417.65500-11-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201151417.65500-11-manivannan.sadhasivam@linaro.org>

On Fri, Dec 01, 2023 at 08:44:14PM +0530, Manivannan Sadhasivam wrote:
> As done in other places, let's use dev_err_probe() to simplify the error
> handling while acquiring the device reset gpio using
> devm_gpiod_get_optional().
> 
> While at it, let's reword the error message to make it clear that the
> failure is due to acquiring "device reset gpio".
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/ufs/host/ufs-qcom.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 218d22e1efce..a86f6620abc8 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1146,9 +1146,8 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	host->device_reset = devm_gpiod_get_optional(dev, "reset",
>  						     GPIOD_OUT_HIGH);
>  	if (IS_ERR(host->device_reset)) {
> -		err = PTR_ERR(host->device_reset);
> -		if (err != -EPROBE_DEFER)
> -			dev_err(dev, "failed to acquire reset gpio: %d\n", err);
> +		err = dev_err_probe(dev, PTR_ERR(host->device_reset),
> +				    "Failed to acquire device reset gpio\n");
>  		goto out_variant_clear;
>  	}
>  
> -- 
> 2.25.1
> 
> 

