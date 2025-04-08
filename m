Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFF7261585
	for <linux-scsi@vger.kernel.org>; Tue,  8 Apr 2025 07:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744097027; cv=none; b=JWl+l7xC2ibVgxKTljZ4aOM31KoGAG91nVqw/+++0ucMjmXNhiDU1P8Nqn2LpodaU9KyTbal+pPtQ+i9SMPTOH3zHap5pQtUU+3CozztiU2+U7OsDGvFbJ5LDnD8nth++hbBBQMMvc7zYNicmZV0J5SCvBgPtxPE586ANHElcqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744097027; c=relaxed/simple;
	bh=rL5dGpnFjOxWd3LsB+ItQyiyXmnHrcABj2M4ZSlcHDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TznbXo8xeigq1d5cnp4CTtmhtk7PcmYk7voPc/TWnceCMJmKUcDHjKlmGM+jIccJozO4WkUuhKkbuuUKz4g6wGRNL3QIKr+DnR6BATCG1uNKY20nUzPnLvRoXW6NwwAdp85htZJkFavzZoANlPmgj4fmXoQxeGfbuV/arMQCI9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uJbsUz5X; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uJbsUz5X"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-227a8cdd241so59845745ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Apr 2025 00:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744097024; x=1744701824; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gVo2aw8e68tzNUEBR5LrT7OG8JEIu/cx6FavvcXXg2o=;
        b=uJbsUz5XeE6hxVIz5jX8ptxHA5XoKb+yTII+mdK+VOU7n1YmxMjAIOqbp7MsJq9tuw
         fE/pRLuWpTe5MEcbttBT+ABUx2FcGa2bF2tRVsjR4IlRavwF4hNN7WtSg3UGWwV39y93
         q++HJR7nkTc3dDktm1oeOggH/r/N/BzIeZIz9iaspPnCWJRkmQqCB7VBKwgXe6B2XTM7
         Nb43SEZ0SdzmDVRkGl0ltxjtUen8jIPMLuu4ZwCgTmxLp9Yw1LQfXutIzg1IRUBLCUax
         y49lXwVhHFZD5JkuBW0QuMlX8DHReYRIz9ZYZTZ+qz4tAZ4KMeFz+VzNHOWncqej62tQ
         9gaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744097024; x=1744701824;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gVo2aw8e68tzNUEBR5LrT7OG8JEIu/cx6FavvcXXg2o=;
        b=q0ESvcQbVAfolhuE5ElIXI8UuX8XJoyHlOsZAgi/3LohGJO7Dz94qe3REYw4UApc19
         SwiWOaw/7u5WWLSpOY9iNxbH8gJsFsag7tIkvOcVwBU6BZXUjKzly6yL3gQxehmPxltD
         5pvKfVsTsBAc9ogbbBYMJyu0H9fbRa9iMA8oesdSqPslZFyCa7D2VKhY1qcOgErNQ0yk
         sXxKXmnN++RMAuk/lTxpyKGqSJUoWKo6ozuZq9Q4woWwepUrVRhmKu52fTAxokRSuB9e
         KSftePzNvbbsAdvm1Qu1VceF0/73sSO9ZUtjsIoW1DmKNb4DubyyCRtqQTgh8tP7mI+P
         7Uqg==
X-Forwarded-Encrypted: i=1; AJvYcCVgCPjsY7wrLz5BychSlWLl6bS5qqc/arQTx410pVLyy1AnLpSEF4OQUuUzlh+k8n9jVV/Z5h9qkMMN@vger.kernel.org
X-Gm-Message-State: AOJu0YzBRdziZiRltolI6gt3D7ECcM8UR6vOJvPQghz/vuQty7IOpsRN
	YwYJuYiQOV6JsEQh3UMLjjXoL3d+bKKYvGxk27S6dK4ius36d6KKgD+47aX+5g==
X-Gm-Gg: ASbGncufAVV5N5JCovgby3hQhqym7SKCotBC2jbEmw1+cC502no21p/TNxT7L31R147
	R/3er+jL/rkF2eccqhcm7OjwLdVyIewwFAu70y1ZEcly9p4FKfOTcrhPNf8uwVnp2JGedsIx9Sm
	orHBOqVPQiT6f0Gza0ibmkh3Mcqer6qeSJZryBItI0SiKCxUInOOKoirFn2aVQdRi3waIDUNofx
	G66MwHw29lw8ZJktSnkqbJ8R2YT1pN8ivqwgw6MZ6Aa1yASSN6DJLtKqrW8vVyN3coNNPsYfIkU
	KJwAr5n6foB09ixS0Y1L22CxirTontzVwO1pBjDF3PlUBsyG44Eqptsh
X-Google-Smtp-Source: AGHT+IFPM9/HimoR1iqD87ojIqSwcwz9XpIsOOx/gkGl8C+bQirMDZCXalGm8Chz/NcPiOQyGMeqew==
X-Received: by 2002:a17:902:d484:b0:223:6180:1bea with SMTP id d9443c01a7336-22a955734cfmr159838375ad.37.1744097023770;
        Tue, 08 Apr 2025 00:23:43 -0700 (PDT)
Received: from thinkpad ([120.60.134.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-229787776f8sm92798135ad.256.2025.04.08.00.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 00:23:43 -0700 (PDT)
Date: Tue, 8 Apr 2025 12:53:37 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: MANISH PANDEY <quic_mapa@quicinc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, quic_nitirawa@quicinc.com, 
	quic_bhaskarv@quicinc.com, quic_rampraka@quicinc.com, quic_cang@quicinc.com, 
	quic_nguyenb@quicinc.com
Subject: Re: [PATCH V2 2/2] scsi: ufs: introduce quirk to extend
 PA_HIBERN8TIME for UFS devices
Message-ID: <l6xao2ubcvv3ho56dv6qfr3b62ve3olfbhvywg2is2xdhod27r@2nyjfwinrxzm>
References: <20250404174539.28707-1-quic_mapa@quicinc.com>
 <20250404174539.28707-3-quic_mapa@quicinc.com>
 <hcguawgzuqgi2cyw3nf7uiilahjsvrm37f6zgfqlnfkck3jatv@xgaca3zgts2u>
 <d09641c7-c266-4f0a-a0e3-56f63d8c9ce3@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d09641c7-c266-4f0a-a0e3-56f63d8c9ce3@quicinc.com>

On Tue, Apr 08, 2025 at 11:07:58AM +0530, MANISH PANDEY wrote:
> 
> 
> On 4/7/2025 12:05 AM, Manivannan Sadhasivam wrote:
> > On Fri, Apr 04, 2025 at 11:15:39PM +0530, Manish Pandey wrote:
> > > Some UFS devices need additional time in hibern8 mode before exiting,
> > > beyond the negotiated handshaking phase between the host and device.
> > > Introduce a quirk to increase the PA_HIBERN8TIME parameter by 100 µs
> > > to ensure proper hibernation process.
> > > 
> > 
> > This commit message didn't mention the UFS device for which this quirk is being
> > applied.
> > 
> Since it's a quirk and may be applicable to other vendors also in future, so
> i thought to keep it general.
> 

You cannot make commit message generic. It should precisely describe the change.

> Will update in next patch set if required.
>  >> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> > > ---
> > >   drivers/ufs/core/ufshcd.c | 31 +++++++++++++++++++++++++++++++
> > >   include/ufs/ufs_quirks.h  |  6 ++++++
> > >   2 files changed, 37 insertions(+)
> > > 
> > > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > > index 464f13da259a..2b8203fe7b8c 100644
> > > --- a/drivers/ufs/core/ufshcd.c
> > > +++ b/drivers/ufs/core/ufshcd.c
> > > @@ -278,6 +278,7 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
> > >   	  .model = UFS_ANY_MODEL,
> > >   	  .quirk = UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
> > >   		   UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE |
> > > +		   UFS_DEVICE_QUIRK_PA_HIBER8TIME |
> > >   		   UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS },
> > >   	{ .wmanufacturerid = UFS_VENDOR_SKHYNIX,
> > >   	  .model = UFS_ANY_MODEL,
> > > @@ -8384,6 +8385,33 @@ static int ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
> > >   	return ret;
> > >   }
> > > +/**
> > > + * ufshcd_quirk_override_pa_h8time - Ensures proper adjustment of PA_HIBERN8TIME.
> > > + * @hba: per-adapter instance
> > > + *
> > > + * Some UFS devices require specific adjustments to the PA_HIBERN8TIME parameter
> > > + * to ensure proper hibernation timing. This function retrieves the current
> > > + * PA_HIBERN8TIME value and increments it by 100us.
> > > + */
> > > +static void ufshcd_quirk_override_pa_h8time(struct ufs_hba *hba)
> > > +{
> > > +	u32 pa_h8time = 0;
> > 
> > Why do you need to initialize it?
> > 
> Agree.. Not needed, will update.>> +	int ret;
> > > +
> > > +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_HIBERN8TIME),
> > > +			&pa_h8time);
> > > +	if (ret) {
> > > +		dev_err(hba->dev, "Failed to get PA_HIBERN8TIME: %d\n", ret);
> > > +		return;
> > > +	}
> > > +
> > > +	/* Increment by 1 to increase hibernation time by 100 µs */
> > 
> >  From where the value of 100us adjustment is coming from?
> > 
> > - Mani
> > 
> These values are derived from experiments on Qualcomm SoCs.
> However this is also matching with ufs-exynos.c
> 

Okay. In that case, you should mention that the 100us value is derived from
experiments on Qcom and Samsung SoCs. Otherwise, it gives an assumption that
this value is universal.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
