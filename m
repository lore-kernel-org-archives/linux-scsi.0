Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2B7178CEC
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 13:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720011679; cv=none; b=snpeSgALZfG7hAUmqG47WNf2UrKkpJ8N9goeURMxM4waU5HfZRPpY9BusNU2tcthpGxq+ek+nXg/+EEIy05hDehLbJlWfIMKxCRBiRGiVle2wop8iTRUpQlcaTZi5kLqVZ9uiqthKxIQGjRyX44mbD4oP1NRdFQq/ohXEe5O3n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720011679; c=relaxed/simple;
	bh=zRnFh7zDQBzsf+JHx8cuctXddM/KsYy1KEQAPoOZS24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OqffWe9UtvdTbFosrYeUzqha+BlaUwHWtyEGiIUw8ZT++ATpTKKh5dAThVgVykTYiVtjkOzMhCskC0awBkiYJ5a876O/Ks/5aLYt4YHy3RM0cP5geEaRwRWIzLpHP2c2KG3PQPZza8Eg25J3xrnKRcRG4fhtB5T5UTpotSTvCmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FrWDj5ae; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FrWDj5ae"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70af4868d3dso200151b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jul 2024 06:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720011677; x=1720616477; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OrXjYKNM+d0cFb2ptCNNs7gUOI6OZIvBqEFb/usySrg=;
        b=FrWDj5aesAcWqWqQ71GMGZnqFqBSTv1MERrrGL8kDnTkz6zuWbIaf5dH/1DDaSWbx8
         mdkyt2q3BNaX6fRTMQlPtY5LX6OMyo6bR0ni1ejlExdGp+USAYJxhaJu6Ps2Qki8dRWl
         wmY1Y/1go1ajz/CAoMuQnAVZeBP5nNnI5IOWatymoab3jm+BC4ELlUp3zQQuF6e4vZVF
         z0RV/S0RZMxJQEcZnqcfLY+UB62syPEX1g7PP3CTaS9BN2HeUV/tGKAHFXvZWRpvlfRH
         Ze9oA8S1mlRtgLaiYBcRkI5/MneN4ZpZH36jOhe92EHInBtEDjtBPHyQNKLTjAAY9Spb
         WzsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720011677; x=1720616477;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OrXjYKNM+d0cFb2ptCNNs7gUOI6OZIvBqEFb/usySrg=;
        b=W6CZdCfJtgmQrJNGtgbpp7NE2LxTDKENSgvDEjq6/M9SXvm6PGjYYBjBmdVapnpdhJ
         RDbSMlaEC7qFc/QKAkFDC8VeRiXgDREg7w0qsL8IGp9hRHYDp+UASd+f8qy5uk52RTBd
         RFjjRV1xgUEnBR83s+XFmBz45RRKsnNPGHH/wK/f9lLT6nPpgytoOqFgxl3bjo8Ad196
         KPHNPTJutuI5r2RJUOHNxBJoHvPXa51ihTUsFGYYIcnuxNQov9wCrsqqjDDPUFhzU4vc
         lO6pAo61FZgJc6vl9JJjRhG9aysGx/XuMgvGseUxpLTK8Go+HAegsrIX7NNSWphEIpNh
         q11w==
X-Forwarded-Encrypted: i=1; AJvYcCXRvgb0LlV9zNuGtQGu3gaYj6uhQIdN9A9r+IaNjfdH5a8qBIurFPhoMbpq+A4ICnVGqumAsoAW/t6FxPHFtD7geN4cH3Z1IslxHQ==
X-Gm-Message-State: AOJu0Yw0j60Z2/Ni+JjNb1/D/taOuwphk+4B+hE1PDfGz37iN03Y9+5i
	u7k1iQANt/ySEaO9iYBmMxMQ4K23LYk2FjvIFfK+qdJ60rziu12BMBDWXAa2bQ==
X-Google-Smtp-Source: AGHT+IENRgCcNP9UAaJYZpejbKVDGk3Wd7ip+dc+Rfd1OOLAKPSo9CPiUHYr9wB1KXucG+izcK0aLQ==
X-Received: by 2002:a05:6a20:1595:b0:1bd:8581:2f61 with SMTP id adf61e73a8af0-1bef61ff391mr11581449637.39.1720011675348;
        Wed, 03 Jul 2024 06:01:15 -0700 (PDT)
Received: from thinkpad ([220.158.156.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-708044ad3besm10319612b3a.169.2024.07.03.06.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 06:01:14 -0700 (PDT)
Date: Wed, 3 Jul 2024 18:31:09 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Can Guo <quic_cang@quicinc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v4 5/9] scsi: ufs: Initialize hba->reserved_slot earlier
Message-ID: <20240703130109.GB3498@thinkpad>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-6-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240702204020.2489324-6-bvanassche@acm.org>

On Tue, Jul 02, 2024 at 01:39:13PM -0700, Bart Van Assche wrote:
> Move the hba->reserved_slot and the host->can_queue assignments from
> ufshcd_config_mcq() into ufshcd_alloc_mcq(). The advantages of this
> change are as follows:
> - It becomes easier to verify that these two parameters are updated
>   if hba->nutrs is updated.
> - It prevents unnecessary assignments to these two parameters. While
>   ufshcd_config_mcq() is called during host reset, ufshcd_alloc_mcq()
>   is not.
> 
> Cc: Can Guo <quic_cang@quicinc.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 2cbd0f91953b..178b0abaeb30 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8678,6 +8678,9 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
>  	if (ret)
>  		goto err;
>  
> +	hba->host->can_queue = hba->nutrs - UFSHCD_NUM_RESERVED;
> +	hba->reserved_slot = hba->nutrs - UFSHCD_NUM_RESERVED;
> +
>  	return 0;
>  err:
>  	hba->nutrs = old_nutrs;
> @@ -8699,9 +8702,6 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
>  	ufshcd_mcq_make_queues_operational(hba);
>  	ufshcd_mcq_config_mac(hba, hba->nutrs);
>  
> -	hba->host->can_queue = hba->nutrs - UFSHCD_NUM_RESERVED;
> -	hba->reserved_slot = hba->nutrs - UFSHCD_NUM_RESERVED;
> -
>  	ufshcd_mcq_enable(hba);
>  	hba->mcq_enabled = true;
>  

-- 
மணிவண்ணன் சதாசிவம்
