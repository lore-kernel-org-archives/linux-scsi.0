Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A022F28371
	for <linux-scsi@vger.kernel.org>; Sun,  6 Apr 2025 18:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743964528; cv=none; b=gJMVjqtVxON4zxk3HYUD7QRwDfI0pKvU/8gW7d6zkaJD1dNIYqEdAoApu7kRIsSi8B5o0VHVZTx6qzZx1mR3ay7SuhruwcWARAd+/YScpQ3o8PPAImqrUK0tkVGM8GHZcIu/XX5WgQDqiGhG9DiIuZP5JEfhWCUaHbPH8eTp5b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743964528; c=relaxed/simple;
	bh=xVF3x3UkSJDIxlowMV/5yJWg5CVdZ5Rp/WZSsw2+4XY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ephxfiWHc0UeuAfg+RbGcfYceNssCxqnJp7Pu8BQ6Jvuo4EBiJcfyWieBUdVWGjp71KIjLJLu29kLh0r4xOtYRSr3BsmZqOnzZqBkMSvxzbaIyyfe6SUT8soA+vV26sbdu1NRzVmWKrc80h86O9E3khmzgFi0Tv4ZnQCuCyM3eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TOu04ogp; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TOu04ogp"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-227cf12df27so26587195ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 06 Apr 2025 11:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743964525; x=1744569325; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JG00idBbiuZzkIUnOfUDwBMjIfIGhLtfrBRZuXQ2YbM=;
        b=TOu04ogpGZucH3zRsGvcLUQQKn4G3sZlm3cBv1EG4svsZ6PY0UvU0LO5MXWC86erHM
         FqU/3lurbBpSPOtzSGUw/2duANc2J+UCVh+gIcYqcjNFqTy1K8Uk1kHVNYmstVfGic/P
         OoFCM+s3vPXSKbtyH8yBb+Osw1ylR/iFzA8OaxceQTNnNTg5hftYQnHymuxcFRkuohrN
         C4n5lbTrMjcbu1/R71Pk5GSdexzfLT7VzZz0QvsXEoFFz+Dv6v7NGsuCoNwvNIy3lKPf
         XoTdK4BhOAZ6u83mjFCVD05fuemh5jrNHgX15cwvRzLA+W1KvXa/3xQATdGyf3ng5p4V
         MwkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743964525; x=1744569325;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JG00idBbiuZzkIUnOfUDwBMjIfIGhLtfrBRZuXQ2YbM=;
        b=hHL39JJFA26ssF376+gVTuIML7OWoIikSNJuOJdqBzsJBiGwkOQtJ0IjUzPnATtgIN
         jJ0jP5gul2pnvqvcN/8QR5eARDjeymveg9VZIHGfOjlVnmrg+IxCNO2Es4ckVBC3qkxY
         jpbe7yIvHJy16dnI1Ua9IaI5lWM0GLU3xv2YivopBYXE/tP0bdtVwRVaWTVeTuJWP4uu
         2SSX+30Rtr39lGPFxxu6eQtiQa6GHK4AlGsUnYn1zkCGRXIhgO/c3YWv1KNOtEqUnxeB
         HO1BPCxxiDHeygg3HHOwFbapoJJ+fBjHyFQz8W0uLnaS4uyClzy0SSQZq/6hhRV+mw3J
         KTAA==
X-Forwarded-Encrypted: i=1; AJvYcCWyjfGC82VDviIkErfYNRknHZK6JYx+sjbhvqoCXvwCvN+L9IWuiodII/qojkoHVgD6rJ3ffTHEsKIZ@vger.kernel.org
X-Gm-Message-State: AOJu0YybzQ9aUSIMpR72zy7EBFdJrqcwrz6pqJE72KqwWUiIlb3vN3eo
	hxILKRXbDpmitt+bk2Vzw6Si23CQqL1LOwUWDyREnB3f8D1czzGPechFbOObog==
X-Gm-Gg: ASbGncv98EBMxAwptUPFBpkVO8g2yEgb04MMqnJj9EpdVRvfMltMQJOA7iSdyzPBuw9
	9ef6K2p3CcaQtwqgfC+CfO5qmfLSMtJ94fNSyOpKFMJntFB2THL6rAmXkUZOqh2QvNovdvTyAg6
	IOSXAl8+VwWcBXUZip2H0dqf0Oew/eJkrzHtfDSdXVoxV+lGxCb1IpmUhCBwKGeqDWADhl+DZ4h
	jpR6EYHV1E0Ft6WCGK+cH2vd9L0nGH082bpm4u2FPrwQyYMTVZkH+E7wZLyPw/FXVcrkuA5P2wa
	hd2FBYdGkcEl3OO4Pi3FCO/OyJgQny3MW3TQSIqScNSPs8zLp2LKr3w=
X-Google-Smtp-Source: AGHT+IGOGFfSBcmfodUPLiDGYIY4DGC8r1k7PhYjbfzDdhTnlzgvWrXr4fTTmrOrq1dg8IG68Osutg==
X-Received: by 2002:a17:902:d482:b0:223:4d5e:76a6 with SMTP id d9443c01a7336-22a89a241d6mr131992235ad.1.1743964524915;
        Sun, 06 Apr 2025 11:35:24 -0700 (PDT)
Received: from thinkpad ([120.60.71.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2297866080csm66260455ad.125.2025.04.06.11.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 11:35:24 -0700 (PDT)
Date: Mon, 7 Apr 2025 00:05:19 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Manish Pandey <quic_mapa@quicinc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, quic_nitirawa@quicinc.com, 
	quic_bhaskarv@quicinc.com, quic_rampraka@quicinc.com, quic_cang@quicinc.com, 
	quic_nguyenb@quicinc.com
Subject: Re: [PATCH V2 2/2] scsi: ufs: introduce quirk to extend
 PA_HIBERN8TIME for UFS devices
Message-ID: <hcguawgzuqgi2cyw3nf7uiilahjsvrm37f6zgfqlnfkck3jatv@xgaca3zgts2u>
References: <20250404174539.28707-1-quic_mapa@quicinc.com>
 <20250404174539.28707-3-quic_mapa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250404174539.28707-3-quic_mapa@quicinc.com>

On Fri, Apr 04, 2025 at 11:15:39PM +0530, Manish Pandey wrote:
> Some UFS devices need additional time in hibern8 mode before exiting,
> beyond the negotiated handshaking phase between the host and device.
> Introduce a quirk to increase the PA_HIBERN8TIME parameter by 100 µs
> to ensure proper hibernation process.
> 

This commit message didn't mention the UFS device for which this quirk is being
applied.

> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> ---
>  drivers/ufs/core/ufshcd.c | 31 +++++++++++++++++++++++++++++++
>  include/ufs/ufs_quirks.h  |  6 ++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 464f13da259a..2b8203fe7b8c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -278,6 +278,7 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
>  	  .model = UFS_ANY_MODEL,
>  	  .quirk = UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
>  		   UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE |
> +		   UFS_DEVICE_QUIRK_PA_HIBER8TIME |
>  		   UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS },
>  	{ .wmanufacturerid = UFS_VENDOR_SKHYNIX,
>  	  .model = UFS_ANY_MODEL,
> @@ -8384,6 +8385,33 @@ static int ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
>  	return ret;
>  }
>  
> +/**
> + * ufshcd_quirk_override_pa_h8time - Ensures proper adjustment of PA_HIBERN8TIME.
> + * @hba: per-adapter instance
> + *
> + * Some UFS devices require specific adjustments to the PA_HIBERN8TIME parameter
> + * to ensure proper hibernation timing. This function retrieves the current
> + * PA_HIBERN8TIME value and increments it by 100us.
> + */
> +static void ufshcd_quirk_override_pa_h8time(struct ufs_hba *hba)
> +{
> +	u32 pa_h8time = 0;

Why do you need to initialize it?

> +	int ret;
> +
> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_HIBERN8TIME),
> +			&pa_h8time);
> +	if (ret) {
> +		dev_err(hba->dev, "Failed to get PA_HIBERN8TIME: %d\n", ret);
> +		return;
> +	}
> +
> +	/* Increment by 1 to increase hibernation time by 100 µs */

From where the value of 100us adjustment is coming from?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
