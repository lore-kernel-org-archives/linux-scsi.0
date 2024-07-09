Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9027C1E898
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 05:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720501782; cv=none; b=mySUHKSaoaRB6KDRo69DTRe9vydcVH5/rqRrzJhd8GZgF8sZUdCNMjkGDViLaR4bcTcA8Ou814G4DYMe49cnUMYBMwK5XV7mnpCqlJc7qoO3D+LwilgDElNo2SNYrNk8sa2olTN9PVkzdl/ZJ1GcMdWwEjrsQ2t5JMlqUxIPArw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720501782; c=relaxed/simple;
	bh=7EfrdI1r2MezIpSe/eJZBiPubm3b2brNMzu3H/jcwqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxJPLy3qQNVbmnZpPSsZ1BYf37qsG3FBoVkECxO1kX6vsEHRDLs1odbweWEDK7SBwvrrPbENN3k+Zce7pomm2cfgjRzb789VjIkU5fhOuz3VC5+dpJBvPavs6uEWQ5nwiACuDhs//JxMdvryTb/KR6wVJrJ8BHvBJN/tTg/GTBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wwDmVSNY; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wwDmVSNY"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-707040e3018so3071965a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 22:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720501780; x=1721106580; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XlHO+nWzImZ1oMZxh1mrsAv7gK+5Aq5UcPqRYzLIRDk=;
        b=wwDmVSNYpEJbflJt2EJQAbqbvZTCQKOcF9SHECBE/wdiY6Pg3lJAhODJVGd33xN3Xc
         1dpRwhDhloKCY6iePSn8fJ/d/+AaMNKKoVavP/3p41EVw+sjKtusJ20xL6T1doHB+CXy
         RTcLhQjwm23sYYRIY7AIonjD694cIrDCJmX1p5yS9RTiq/88XOm0GZgjc8Amg8iKXEQa
         EwM0fhqhJaBToyiF59ZTbNyHPtq9SRI0WyoENm6Eu3N0jxJgt8KQvaB+/w5oMFKoPUXn
         KrOELUdOoz7BoNboPWZaCEzvS+Z2/85AJAfV6megtAk/cl9T6KieJqxv8kwEC50387Ib
         9D1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720501780; x=1721106580;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XlHO+nWzImZ1oMZxh1mrsAv7gK+5Aq5UcPqRYzLIRDk=;
        b=BzTVjZpUhTjvO3eEB0hH28K5equE1JyNDbFYWVlQUB1xSuU3/rzBqewLptqupdHAXk
         a8K84LXSO9+mnC2fVOBlvgzssYr0mvswzzBWETUC/Z+6y3lA41b9aFtZuxfIV3lv0l8c
         ntCYFmNzoTPLNtoOr8CHudCHfH2JrjGKlgxEpur4+f5VCYNMsZrr4Rc2pwk0ld4QvB3t
         3jH7WkMI7wupe354CFgtlk4HepuUQe1Idjes1oAXph38Qzq4eT07MMoWP/IXgt0/RpEY
         0oRoAIDle+GCQTyPZNZglqTfGtt3E69tmbkpMbiSUExsiVXVF0f9RW5aIeWXlBwrPwZH
         DJCg==
X-Forwarded-Encrypted: i=1; AJvYcCUR3Yi7HLRJDHRhSW+LaoJiBzh6lJ6Aara8RpgG/EMox7Bk7wu8RwyzhrGflRu6Z7LsgYPdEpfmKT4GoL27r4rD0mDqtpJw3K8aOQ==
X-Gm-Message-State: AOJu0Yz+zKvb9xdwSmGDZckuxeTtIlE/B9M1RcFaCSGbsaifAvnHnu+w
	Jn+1mslBQAKnYgFl3ZR278TFFYOv9WHATh3P5XzPmMYgzLIg59s0SMN9bv8i80PGjh+9xuoAfeg
	=
X-Google-Smtp-Source: AGHT+IGJ9h6FPq8D25ipdXS7NGqh6LhAojot1mzHppSEJ53Ix6dZ32Ck2g+6QB2535Uk0tmuUkDQTQ==
X-Received: by 2002:a05:6a20:7350:b0:1be:c6a5:5e74 with SMTP id adf61e73a8af0-1c29821ce28mr2081274637.21.1720501779710;
        Mon, 08 Jul 2024 22:09:39 -0700 (PDT)
Received: from thinkpad ([117.193.209.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6ab7debsm7084725ad.166.2024.07.08.22.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 22:09:39 -0700 (PDT)
Date: Tue, 9 Jul 2024 10:39:24 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, peter.wang@mediatek.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Naomi Chu <naomi.chu@mediatek.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Yang Li <yang.lee@linux.alibaba.com>
Subject: Re: [PATCH v5 09/10] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
Message-ID: <20240709050924.GE3820@thinkpad>
References: <20240708211716.2827751-1-bvanassche@acm.org>
 <20240708211716.2827751-10-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240708211716.2827751-10-bvanassche@acm.org>

On Mon, Jul 08, 2024 at 02:16:04PM -0700, Bart Van Assche wrote:
> Make ufshcd_mcq_decide_queue_depth() easier to read by inlining
> ufshcd_mcq_vops_get_hba_mac().
> 
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufs-mcq.c     | 18 +++++++++++-------
>  drivers/ufs/core/ufshcd-priv.h |  8 --------
>  2 files changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 0a9597a6d059..ef98c9797d07 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -144,14 +144,14 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
>   */
>  int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
>  {
> -	int mac;
> +	int mac = -EOPNOTSUPP;
>  
> -	/* Mandatory to implement get_hba_mac() */
> -	mac = ufshcd_mcq_vops_get_hba_mac(hba);
> -	if (mac < 0) {
> -		dev_err(hba->dev, "Failed to get mac, err=%d\n", mac);
> -		return mac;
> -	}
> +	if (!hba->vops || !hba->vops->get_hba_mac)
> +		goto err;
> +
> +	mac = hba->vops->get_hba_mac(hba);
> +	if (mac < 0)
> +		goto err;
>  
>  	WARN_ON_ONCE(!hba->dev_info.bqueuedepth);
>  	/*
> @@ -160,6 +160,10 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
>  	 * shared queuing architecture is enabled.
>  	 */
>  	return min_t(int, mac, hba->dev_info.bqueuedepth);
> +
> +err:
> +	dev_err(hba->dev, "Failed to get mac, err=%d\n", mac);
> +	return mac;
>  }
>  
>  static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index 668748477e6e..88ce93748305 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -249,14 +249,6 @@ static inline int ufshcd_vops_mcq_config_resource(struct ufs_hba *hba)
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline int ufshcd_mcq_vops_get_hba_mac(struct ufs_hba *hba)
> -{
> -	if (hba->vops && hba->vops->get_hba_mac)
> -		return hba->vops->get_hba_mac(hba);
> -
> -	return -EOPNOTSUPP;
> -}
> -
>  static inline int ufshcd_mcq_vops_op_runtime_config(struct ufs_hba *hba)
>  {
>  	if (hba->vops && hba->vops->op_runtime_config)

-- 
மணிவண்ணன் சதாசிவம்
