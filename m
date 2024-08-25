Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAF91D69E
	for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2024 05:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724563386; cv=none; b=mPcptvbBj3X9zR9xWViJTPVHLM17i53AeRsdJDf6vOSuCvDKvoejM/8RRdyZB8vL/qq0PmOCct9lvlGRrhmNAgg9tYHt8XMLtsoju/mpjO5X+TcWlY2c5nfb568n83e9xGrF7V4uRKv4tRpRDFJN/IJpwW69niIh8w4VmLmH81U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724563386; c=relaxed/simple;
	bh=Kb6kCD1rxH3uGzZJApplehoi59NT6fAlMu7Frha8I3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5Hq46XUxOsNb2lRN5KcnURWAe9moEp+9JAp2bd7yPSPg0tY0fJayq/9FdnXHQu7+wwY9j0BLh59LpbSiUsEfjpUKr02OsH47d1UqsW1je/WbeYMmue0onWIsKYp77Bf82ld/+FpkFIUsIwXLPy8VusG9Y887mMhWWhBct6SEQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G4DHyLTh; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G4DHyLTh"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-714226888dfso2889294b3a.1
        for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 22:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724563384; x=1725168184; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KOBNZm8il1KgcoYsAtojyu3Pt+jJnkEPLCqBoao4Lu0=;
        b=G4DHyLThhrOm83OF7jVV/EOs1VJaroy8thJQjBEB+X+mxMljIKJROZx6cuy0pK1sWo
         r6reI+dLhpuwFKNxzo1NkCVVPSlAQPORyEuEGst7kT+UivXGVsVb44gPiTvjd7TC8a1A
         wyEOmIsFi1yMlwa7nInP4DQDSUs+qACCrND5WnJ2w7BA/P71NfaGZ3GWdIvZPVjlqJDY
         pVCOwSOQaEb3o+NPCNfcoUTf9ebP768vdrHX3FDU18z7ZrutVDsHF4u6jb1/ySHfIZTO
         qGwDHAt9r07IvmhLw6nrNHryFynG8UcDN4PGT+N7tRH1k1DRoDiOERSNBffe/WhQLzXg
         ncfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724563384; x=1725168184;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KOBNZm8il1KgcoYsAtojyu3Pt+jJnkEPLCqBoao4Lu0=;
        b=AV9YcDfx6Th8aquMWCwoEwYtVHxZPzKDGjF1tTUB6LjAPmO0iBZFIksu0pmZyGI/fo
         a5OZeuFOojUifEdnzDeY0EMivwlz/JM0uwvXz86sKf3hTq07ActNBbmhtNE6QcQnwd8d
         jbg3NGcbYY0PoMaM/MikJPlCsbgQ/e+btBvp2M8TQrwVQ1v9CQ3jP2qd46en2POXBvqr
         QAVWA7vTjQ2ts64wHrjemfAD7g7gOZP04PPfVrZFdvf0EyM9dRSWcB+VmghyJ61YZAQI
         SUz1BuTlZiWavyfBa80DZ/CHt78QjAqv5iK8g/KSqR6Na8a9kKqieE747dvAhOc5fvAZ
         pr0g==
X-Forwarded-Encrypted: i=1; AJvYcCWSaDNR6taOd9XMLzCHNcPl2+Pmowjx3CBmlfioEAUQlyfg0IYSiIy3/yH4JCq9bQDeGdhPE3m+JLcL@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg35Z97l5ZZ0aJCw6rPdh/oW787aAeXr5CO+23LxloFTsQMKPU
	7U/T0q/W+MHkTjlbXXsERgW2chFEnsbJZtwADX3P9LZxvj+JgbJnE+6d2gOGdg==
X-Google-Smtp-Source: AGHT+IFV3uMeDf2Q2Q7KmgmBa9bMVa0DVPNr+gwQZCiu/6KDKJS/JZOU7cDqS07A5KfWQywdWHAOgg==
X-Received: by 2002:a05:6a00:2d04:b0:714:291d:7e47 with SMTP id d2e1a72fcca58-7144579d844mr8169571b3a.10.1724563384309;
        Sat, 24 Aug 2024 22:23:04 -0700 (PDT)
Received: from thinkpad ([2406:7400:75:7df3:6806:4b18:6e64:a184])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71434af1856sm5119827b3a.68.2024.08.24.22.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 22:23:03 -0700 (PDT)
Date: Sun, 25 Aug 2024 10:52:59 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: Re: [PATCH v2 5/9] ufs: core: Move the ufshcd_device_init() call
Message-ID: <20240825052259.2lofai4vv6wk24mq@thinkpad>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-6-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240822213645.1125016-6-bvanassche@acm.org>

On Thu, Aug 22, 2024 at 02:36:06PM -0700, Bart Van Assche wrote:
> Move the ufshcd_device_init() call to the ufshcd_probe_hba() callers and
> remove the 'init_dev_params' argument of ufshcd_probe_hba(). This change
> refactors the code without modifying the behavior of the UFSHCI driver.
> 

I don't see an explanation on why this refactoring is necessary though.
Especially when you move it to callers.

- Mani

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b513ef46d848..5c8751672bc7 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -298,7 +298,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
>  static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
>  static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
>  static void ufshcd_hba_exit(struct ufs_hba *hba);
> -static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
> +static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params);
> +static int ufshcd_probe_hba(struct ufs_hba *hba);
>  static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
>  static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
>  static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
> @@ -7717,8 +7718,11 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>  	err = ufshcd_hba_enable(hba);
>  
>  	/* Establish the link again and restore the device */
> -	if (!err)
> -		err = ufshcd_probe_hba(hba, false);
> +	if (!err) {
> +		err = ufshcd_device_init(hba, /*init_dev_params=*/false);
> +		if (!err)
> +			err = ufshcd_probe_hba(hba);
> +	}
>  
>  	if (err)
>  		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
> @@ -8855,21 +8859,16 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  /**
>   * ufshcd_probe_hba - probe hba to detect device and initialize it
>   * @hba: per-adapter instance
> - * @init_dev_params: whether or not to call ufshcd_device_params_init().
>   *
>   * Execute link-startup and verify device initialization
>   *
>   * Return: 0 upon success; < 0 upon failure.
>   */
> -static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
> +static int ufshcd_probe_hba(struct ufs_hba *hba)
>  {
>  	ktime_t start = ktime_get();
>  	unsigned long flags;
> -	int ret;
> -
> -	ret = ufshcd_device_init(hba, init_dev_params);
> -	if (ret)
> -		goto out;
> +	int ret = 0;
>  
>  	if (!hba->pm_op_in_progress &&
>  	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
> @@ -8887,7 +8886,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>  		}
>  
>  		/* Reinit the device */
> -		ret = ufshcd_device_init(hba, init_dev_params);
> +		ret = ufshcd_device_init(hba, /*init_dev_params=*/false);
>  		if (ret)
>  			goto out;
>  	}
> @@ -8935,7 +8934,9 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  
>  	down(&hba->host_sem);
>  	/* Initialize hba, detect and initialize UFS device */
> -	ret = ufshcd_probe_hba(hba, true);
> +	ret = ufshcd_device_init(hba, /*init_dev_params=*/true);
> +	if (ret == 0)
> +		ret = ufshcd_probe_hba(hba);
>  	up(&hba->host_sem);
>  	if (ret)
>  		goto out;

-- 
மணிவண்ணன் சதாசிவம்
