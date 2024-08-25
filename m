Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9521D69E
	for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2024 05:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724562717; cv=none; b=R2TnfZR3qOLwW3a3BUHQPcipLWJwFfMMNAsG2Tgb+RTf4jLZf6MHGbKGF94/VtOnlvzpW6gbP1pCH/XaUSeOeSI6gDk76HP7ns3T/yHCbElQnhNK55JTGcHSIUChA4cMyTf1KFYRsjdhKr2w5EUGNUeP6fBbhF2M1h0peAQFrTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724562717; c=relaxed/simple;
	bh=3ybSxGjj0fmhxIFkzfsL77NoVIMS9+oZKEE7UAwN1hE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t07ME7ShYuJGuQBhQSFVjIP67VyqDR4JtmwbKhXFyCKpDOOZArdtiV8SMpx0YLEyztdmfdZYV1eMEAWOIVHSA6cC9/tf8O5w7cFXHf+I33tiD6GF+mFE4A7WneYMq6XxMUZoFEoeHT6rCKdTwgAlVfwMvWYkvSMtMKYzqkxNdjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vbq1TWih; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vbq1TWih"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7141d7b270dso2510604b3a.2
        for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 22:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724562715; x=1725167515; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pIyrSXW20VcKjAczse6HC9yErr6kjes1IHWUKhPJRWw=;
        b=vbq1TWih7fmXa/1OAzslg+yw2N4gIN9F5e3VDHJoDt63MJpiJAcup95qSJ9lgUsWX0
         T3bKes6pY6iKiJLf6ZC2ogPvgPxidH/f6nEM7f1xvGtbHvUqn5bX7T07+/O7a8V120qD
         xTDGx5ig9G8wMbdvbsUbxI6++fh/NetqgO5VAh6LJZ9vNHpm2hsNHMNurM0QNG4rGvG3
         xkL+NSt3FEmh34DD66bUsKqsaWkMo5iMgFORX/WQMUmhzg/REB8damH+NiI0hzdcSgvn
         UTyMh5WifZZBa9dXeAWOgfX2QSJbme4ThYMakOTrf6mTKdfrYl2BKF7XLAU/s0kNiotr
         2sfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724562715; x=1725167515;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pIyrSXW20VcKjAczse6HC9yErr6kjes1IHWUKhPJRWw=;
        b=PcpuTUZgrhYsFYGQNa2PEGvMq7Nu4K62w1OMzZPVvgsHl3EIywcg/vC4jFLbPJlTvY
         N+UcDoSNbjAWsjw0EFLNEUZ8mPR4yWedenvb5Ej9wGRPT+gc8p4DAQvZ695e/hrf70x9
         kaKBTNCybVa/IdwPA7s24ABhTWrQZhhCcE/Gxs7fg6w5F39U06TRjsThEkkgvzZ7CWp/
         anlnAI0RPhWW1qOVhPJB0Xt08Mju1PvC1c/JHvx5moirhekF/G0sPKEptjq5tTN6RtzV
         XyhKben406b2hncE2YSZKgCAc8nXAglXiV1CB7cZnw8vEVuUD9HXDgvbph9MvXbpdhJI
         UaZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkEV7C/6rjNGTZ40G8tpn+BHGGxYnYOJfZDKIQvxSZoJoOIBMOK8eTJDmQWyQzvVIBMdB6ouPqntmd@vger.kernel.org
X-Gm-Message-State: AOJu0YzgSxosITIR2SShSHUQGKbCLhitYcDM+EXYMFNEG/hUdBOaXzhK
	DyFfQu6Od0aFZuktUFTcBUYdnJT5ApqpzlWDBOvRq2DC5qonjNj8QZrdUmKCbA==
X-Google-Smtp-Source: AGHT+IELXzGKf10jvjSUEeMw3eqsfiT2m8XYkKYiMtvaE52EH77ysGep824ZJcJ74viov2FXZHjPhQ==
X-Received: by 2002:a05:6a20:c998:b0:1ca:da81:a3ef with SMTP id adf61e73a8af0-1cc8b4245a0mr6965160637.3.1724562715455;
        Sat, 24 Aug 2024 22:11:55 -0700 (PDT)
Received: from thinkpad ([2406:7400:75:7df3:6806:4b18:6e64:a184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855677d0sm49327115ad.6.2024.08.24.22.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 22:11:55 -0700 (PDT)
Date: Sun, 25 Aug 2024 10:41:49 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: Re: [PATCH v2 2/9] ufs: core: Introduce ufshcd_activate_link()
Message-ID: <20240825051149.w6vt3ltwfjehrdks@thinkpad>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-3-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240822213645.1125016-3-bvanassche@acm.org>

On Thu, Aug 22, 2024 at 02:36:03PM -0700, Bart Van Assche wrote:
> Prepare for introducing a second caller by moving the code for
> activating the link between UFS controller and device into a new
> function. No functionality has been changed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d29e469c3873..04d94bf5cc2d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8733,10 +8733,9 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
>  		 hba->nutrs);
>  }
>  
> -static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
> +static int ufshcd_activate_link(struct ufs_hba *hba)
>  {
>  	int ret;
> -	struct Scsi_Host *host = hba->host;
>  
>  	hba->ufshcd_state = UFSHCD_STATE_RESET;
>  
> @@ -8753,6 +8752,18 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>  	/* UniPro link is active now */
>  	ufshcd_set_link_active(hba);
>  
> +	return 0;
> +}
> +
> +static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
> +{
> +	struct Scsi_Host *host = hba->host;
> +	int ret;
> +
> +	ret = ufshcd_activate_link(hba);
> +	if (ret)
> +		return ret;
> +
>  	/* Reconfigure MCQ upon reset */
>  	if (hba->mcq_enabled && !init_dev_params) {
>  		ufshcd_config_mcq(hba);

-- 
மணிவண்ணன் சதாசிவம்
