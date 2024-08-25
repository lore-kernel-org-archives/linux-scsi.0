Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB23B48CCC
	for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2024 05:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724564008; cv=none; b=TqtgUlCe5DfIrk/9W3QDRzQV3VP9d1Lb382mk8Qnj1BA5FC32onLaR6Lr+JJErpIjxjlTRUX4gwucbYiMDRHu0j5F6gt4CgDlsQ2MsGVNeRdjXnUui/FKXT518aiYMthJJnWi43MVYYVigUJ1k/Z4D4lNAVT2tTC0hY3IQZTRwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724564008; c=relaxed/simple;
	bh=E+Zbajv8PGva5Ws1yz4N2YUZNUOqNhay54r+RUXFG6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cxvor3wA97dMZwnpD72bXwUIly2k0j5Av6DiVYqMJi5Eg+91qkgrbp09qRHpS/JP2XRbsn65vB04NwCPd+8QoOUBq0G2J/yzj29N/IJOkr2WURQ5EdZSOwEMHOBh56I/imnkf8vk6HQUpzbYT4Gd2xY0YY3QRAgFE4t4n35NP2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uHaPRXdZ; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uHaPRXdZ"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7093efbade6so2767069a34.2
        for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 22:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724564006; x=1725168806; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eIGId8ryC9qFoBEtiXhBJr23cLWYAN6xKjgzKa9sLcs=;
        b=uHaPRXdZ/SOz1QkKXxGyKl2VXWII9ky8k3BxTAMH7pDJWPj4wc+Qizl41HxL0N2Xol
         2x3Hk7xV1J7VH5ccEIgE8hPLc4L0fdP6+Tt+no2EqdNOwElokwKMPoMzSsKSRlpvPLCH
         F1Qz2v/3qmGGscE5idw0Dtv6NDhgYYJaJ9rRsmptLA2k9PcjXy9zFYltH1FkAiBtVqZD
         4PNs+7UvpqUJuIUp7XWbHsgiZeQZNTcTfyeorRMfR+i/L69vZ3yqqVK9ktoU8hmgPx5d
         R/ORSWPA0pmx6k4rpJ4aRwdUA7YA9IUeli64snq4ax9D6y65PyVOJIA4dnWMtEFz/x6z
         KwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724564006; x=1725168806;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eIGId8ryC9qFoBEtiXhBJr23cLWYAN6xKjgzKa9sLcs=;
        b=smyVHCX/Y9VxMkAd1O55pmoy+yEbjYFdVj33fN0MXSRaTN5ElZ8CckxNC+alm5ch6q
         81KSPO2rfeq834jkWOSJH4AYt1wJbc3/WTWyqQAqOWahjeTzXjM8loifcKI4VGmzaN59
         2gE4JyukkoV6SZVGYB6NbYQaz4l9LsutuEc6oFbimiyr30pKDx20hDzZJ8Rff9+QqSXL
         EDx7Fr9aJF0tC1ga0lZgfWZZ8cuFRGrymH6NdJKpF3q/y9tZANck+T8hKZoBRjRQdhJN
         LHi2GON8fPiOFNIAWvxYofI1IWBP8+WzOnnzEeLVM5v7tj/QsXXYP02je7VIXeUFwx+p
         d1Cw==
X-Forwarded-Encrypted: i=1; AJvYcCWf1vfwxSXZtJ/JtPoFhGdn5ZIYRrEeXXMOSDe6iWDR/2NUhwnMY/QkUnUhXVbazxEvUztdn8FcljRB@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+V67aUJvE0413AupLeSJhFy13BkaeLV/eLjUzYOQeS8sqBkaI
	GVkCZPx3wJeziQFg7ZtMm9UlpAXcG4C7gxD121yt+hS+ggWLLcTDESHfzE8gFA==
X-Google-Smtp-Source: AGHT+IHs5fo+l8CPlK5wV/f8GPL3WXAeDxmVCsUQiXAOl7ogx28ojk1mZb0BTkFFrn3NaheCxodMGg==
X-Received: by 2002:a05:6830:2c0d:b0:70f:3700:7a55 with SMTP id 46e09a7af769-70f37007c87mr2208881a34.18.1724564005718;
        Sat, 24 Aug 2024 22:33:25 -0700 (PDT)
Received: from thinkpad ([2406:7400:75:7df3:6806:4b18:6e64:a184])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71434230bb2sm5169025b3a.42.2024.08.24.22.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 22:33:25 -0700 (PDT)
Date: Sun, 25 Aug 2024 11:03:20 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v2 6/9] ufs: core: Move the ufshcd_device_init(hba, true)
 call
Message-ID: <20240825053320.mewedbbpxkljamds@thinkpad>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-7-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240822213645.1125016-7-bvanassche@acm.org>

On Thu, Aug 22, 2024 at 02:36:07PM -0700, Bart Van Assche wrote:
> Move the ufshcd_device_init(hba, true) call from ufshcd_async_scan()
> into ufshcd_init(). This patch prepares for moving both scsi_add_host()
> calls into ufshcd_add_scsi_host(). Calling ufshcd_device_init() from
> ufshcd_init() without holding hba->host_sem is safe because
> hba->host_sem serializes core code with sysfs callback code and because
> the ufshcd_device_init() is moved before the scsi_add_host() call.

I think this last sentence is not complete.

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

One nitpick below.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

> ---
>  drivers/ufs/core/ufshcd.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5c8751672bc7..0fdf19889191 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8933,10 +8933,7 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  	int ret;
>  
>  	down(&hba->host_sem);
> -	/* Initialize hba, detect and initialize UFS device */
> -	ret = ufshcd_device_init(hba, /*init_dev_params=*/true);
> -	if (ret == 0)
> -		ret = ufshcd_probe_hba(hba);
> +	ret = ufshcd_probe_hba(hba);
>  	up(&hba->host_sem);
>  	if (ret)
>  		goto out;
> @@ -10632,6 +10629,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	 */
>  	ufshcd_set_ufs_dev_active(hba);
>  
> +	/* Initialize hba, detect and initialize UFS device */
> +	err = ufshcd_device_init(hba, /*init_dev_params=*/true);

I think this inline comment is not really needed. It is rather decreasing code
readability.

- Mani

> +	if (err)
> +		goto out_disable;
> +
>  	err = ufshcd_add_scsi_host(hba);
>  	if (err)
>  		goto out_disable;

-- 
மணிவண்ணன் சதாசிவம்
