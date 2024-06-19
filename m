Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1FC47F59
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 07:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718782344; cv=none; b=OGCiJZzgjN7Y3lKpX6AsJYO+/93nd6e/8I8SHsEKh63yDrshws9Ux8AyFwHn9XjMGuwrHSH4/Fo7fOIhdEt+RpfNI+bmuwt7/MVeapa+18/a0/5zFDevPBH1dbAmTESFuzdyKoqFMI8AD6w0jUVB7P0BKd5S55elDC/PXyS+3Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718782344; c=relaxed/simple;
	bh=Rs70ghS2C9Hvy0XHYfOosL1VMB3AUdxQpT8DKHTlmZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J63pskHZg/ryhj5GUYMsGgQI1/ABXvfTePlPRJnZ7x+mKH3r8Cwx8Nbj661Qcc6tmxuVrnm3PJO3CqWlcpK9b792vshA/3KwEIpJYj9nokxdhisoGD2JFpTfy+OJ7t6NhQp3Sl1CUnSuuuUZXQeyhXAiK5n566HH9v70jpQXuhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TX7qLups; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TX7qLups"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-705fff50de2so404385b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 00:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718782342; x=1719387142; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pH2NG21dFDWfGGfln0QgCspIGMb9TxbgKn8eYT9KFus=;
        b=TX7qLupsqQScxWvD+9x9tzpDH7h7CeCEr/S/V+vvmwLlP0vbtnZzzpocF7p4Z+Bg+T
         uUvCNh5EasdsIf+4R7QLah1itjAfW46zEGm1tox1IMf961sr0N1gRwPXDBZoZwMhT48b
         c0mIHpXLDESMj/U7s/ut9ZIPiUbEXrmTdr5MgQ5i/plFuXy03fyjQiE+fDtqti9163YF
         jadauUAMcZhCjDVWSNSEhxrykm1rP/KSjZFF+FnlmLjXI5Xij99WPvafKYScv+9gBi83
         86JkEqC0BDmgGMM+rYFCNPpdDeOryku9bkuyWl3YhPRfVJha+coJO6zp13O5TBXG1wN4
         SbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718782342; x=1719387142;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pH2NG21dFDWfGGfln0QgCspIGMb9TxbgKn8eYT9KFus=;
        b=HrKElCrc9KFK2grGqjCl/XD7+S5+pVjRdutu//PtsPkYQA6YfspWPuJq3oxjOeRxLg
         Ti3/9cJqh0vMA96WgVbaaeTWq/2CqHV1InsYV/kP9405/N8cqAmty5maOyUo8LCTQokX
         oB/j4VHt2njEzBMChXGxpcOrUk/bugweYOY17WIrR50QcMqRK6HcVkDllz4Xk75itk7s
         TLL6n2ojUkD4y7D4pBSg/un8qnlsW/hl5JkeR1qjI8L2lRJ4Fkpf727A0e2nL6hZuG8g
         KTYy32vZoh9Ef469otL6EiklUQ79z2OOHTYCj29WBdpLhRviSo1VXq6pi0cFJN+mszv2
         kKew==
X-Forwarded-Encrypted: i=1; AJvYcCUbcmbil1JUdLTeVvFHekG/Fhq92rjZjKrkx28N+FlhN+bpY91JPU40KhANSoTCZBsXlyJ43osU5VJIkJWzyyaFXT2/amAdY+jLfQ==
X-Gm-Message-State: AOJu0YwUk/6gQKz/3OIIJIAqRx82So6slTdiXbOh9qFbJzxsSCCyIn19
	mGzGvkkXnZ3KkYr3HUo05HvpGvqAUwZVa08DTbWEElNT0Yh+DYfG5PrwAMA9k3Xbkri8V+a+1nU
	=
X-Google-Smtp-Source: AGHT+IFFbAnCCfTy98aZPIRlxPvRC7/toc1qCCfVVwcQvjeGVqyJNLY5YiuJPfkL59+lXpX6XIismw==
X-Received: by 2002:a05:6a00:2d9b:b0:704:2516:8d17 with SMTP id d2e1a72fcca58-7061ab78382mr7893000b3a.8.1718782341728;
        Wed, 19 Jun 2024 00:32:21 -0700 (PDT)
Received: from thinkpad ([120.60.70.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb6adcbsm10062269b3a.161.2024.06.19.00.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 00:32:21 -0700 (PDT)
Date: Wed, 19 Jun 2024 13:02:10 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: Re: [PATCH 6/8] scsi: ufs: Make ufshcd_poll() complain about
 unsupported arguments
Message-ID: <20240619073210.GE6056@thinkpad>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-7-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240617210844.337476-7-bvanassche@acm.org>

On Mon, Jun 17, 2024 at 02:07:45PM -0700, Bart Van Assche wrote:
> The ufshcd_poll() implementation does not support queue_num ==
> UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode. Hence complain
> if queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 7761ccca2115..db374a788140 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5562,6 +5562,7 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
>  	struct ufs_hw_queue *hwq;
>  
>  	if (is_mcq_enabled(hba)) {
> +		WARN_ON_ONCE(queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);

So what does the user has to do if this WARN_ON gets triggered? Can't we use
dev_err()/dev_warn() and return instead if the intention is to just report the
error or warning.

I know that UFS code has WARN_ON sprinkled all over, but those should be audited
at some point and also the new additions.

Also, this is a bug fix as it essentially fixes array out of the bounds issue.
So should have a fixes tag and CC stable list for backporting.

- Mani

>  		hwq = &hba->uhq[queue_num];
>  
>  		return ufshcd_mcq_poll_cqe_lock(hba, hwq);

-- 
மணிவண்ணன் சதாசிவம்
