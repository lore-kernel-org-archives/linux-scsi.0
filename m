Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F36D19DF62
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 16:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737133158; cv=none; b=DKyibOYHd5I43uqh+4KT+5PcFeX8AVxZLBDysumhQUdISXuWniIOD5L8UapiWe7oRK7tvjOBc1sB6Azrd757g4AZP9J/BxaTb2wls9t5UThokGJxz8aPQzXBS4FiqDNse5H9MYXVeSXXKgcfn+zQZ4KSy2lPv4Jc2HHFCXGnb7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737133158; c=relaxed/simple;
	bh=eELjTMxy9R374bYdUfkFwRMkrtaOe7EhJHvKRy25pnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrMa+KZnWGKpxB/ntN/VxhK4VFAkJ5PhYs87/mTU7Hf4tJyvsyltcjfD8Gexq2Rknq7m8GXooGV/AV/q9QI/KlyySSHi93hogI2ju9uHj6Suk0P22Z7TI3M0LWMuqxJu45YhLEOPT2LQWTDBwfe3pCTacqxJxjJ6vHVK1STQzYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FX6T+eAp; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FX6T+eAp"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-216401de828so43809415ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 08:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737133156; x=1737737956; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XkhbZO8tYS+x52lOvx8K04qENXNly95zhsaFcqaUxAQ=;
        b=FX6T+eApkix0ks3jZyk0VSywgekeWYV+VEoow8Q3dDk9yMSfXe6G4SHjguPc/Ig5bc
         L02K6zFvs+ZGZLYOfSUnB6dRdiAvI0nfhKHp7hCF0md1MexzMqVRj8TSO2IkkuINbkaQ
         Gmzdw6syA8hYh7krDlgcLAU2u7KAG8c4jFdOe1mQk1mHqBpIiV7z8YcrhdTVVDijWOyH
         sNS0gmo+F/AQWgRyQLBuDyQLJX5PizYcKUccFjrjucOzjwskSwahnD8k9/98eggfCrAT
         ANVWicHzTN9ofaoD7svlu4r6pW6nE5GkcXAeBYJwnOEbEryPA32J+zW7QVHkjuXdmggg
         lrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737133156; x=1737737956;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XkhbZO8tYS+x52lOvx8K04qENXNly95zhsaFcqaUxAQ=;
        b=ff8xSd5bOWFtkqSZinDzZMIDoJrJSyjTaEqBrOqxMQuZl4CRD0H8LA2b3uEWIEodZ/
         JzN1/rYT1O8d0nWWtGDV1b7v5hX20xWa1VSPE8vjmy8ScYCzgN4fbcz16FPjCNhH+TaW
         BuhoOGZrnoixkxYSeusO/hQX9ylZq1e+KIn3grIYSPaqA36PbkCjBvUfyH61pxcXiV13
         9NpyvKgcMDRDxLmui6GTgX856JtpdOplq6iNtXKBvncAZ2riRK3kWFzqHaqw1JRHw67q
         4ajU2+gRmcsMyruvl7ZYidRJZBXZgfM6waAhCw77+W3wdnbtIvd7Ka/hJpCSs52Ta8h2
         87rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkG+J40SJQJoJgZw9XuJaPaUQMzkXI99/gRM0Fu0KtGijQUG6edYJdzhw/NsfNvUFHOBI1i4KUjAv8@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7BjZivKNhZSUMvqEZpnY45prELuRU2+S8RSILUse+v921JIXa
	QdVCx33Ria7QoNMfSvjbIhO/unGskffJk0xzKZ/qWRXzWhEjB3s6bXtiQoxwpg==
X-Gm-Gg: ASbGnctPzcNFidTaxm7fyuy29Tbg/u4p/shYNfkH6wkT2a3SgbwzmlfQR4uUhGRPgGO
	1BkCsD7BmvVvxFjx9g0p98gw8HM97i59eekc1DaHndFpsWwlHWJh9fwuMJd5z7EHC7FoCT5KmW0
	2DGj046M/4qZRYzs9tRr2oXPBpZTDF3I9e/lp3DPqtW3Xu8QB3MIepPVr8E3E/iPVfpnl8RxNv0
	LaLZuP757eIFvqkM2RGgW9WgtjSHltDkwC83Q//LR84PcpbiAnHQfr6/bvvhcOVFR3I
X-Google-Smtp-Source: AGHT+IEfnnL3mUhpv8k8DjWFKRShJa/iF7JsGrlzqODd5Qcyj+91fLelDJ83KysyOwgQsgiCtdXH0A==
X-Received: by 2002:a05:6a20:9143:b0:1e0:dc06:4f4d with SMTP id adf61e73a8af0-1eb214da876mr5836750637.19.1737133156381;
        Fri, 17 Jan 2025 08:59:16 -0800 (PST)
Received: from thinkpad ([117.193.215.12])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bdf0b43aasm2041206a12.66.2025.01.17.08.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:59:15 -0800 (PST)
Date: Fri, 17 Jan 2025 22:29:07 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: quic_cang@quicinc.com, bvanassche@acm.org, avri.altman@wdc.com,
	peter.wang@mediatek.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, stable@vger.kernel.org,
	Bean Huo <beanhuo@micron.com>,
	Daejun Park <daejun7.park@samsung.com>,
	Guenter Roeck <linux@roeck-us.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] scsi: ufs: core: Fix the HIGH/LOW_TEMP Bit
 Definitions
Message-ID: <20250117165907.rfdaayq4a6ichhmy@thinkpad>
References: <69992b3e3e3434a5c7643be5a64de48be892ca46.1736793068.git.quic_nguyenb@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <69992b3e3e3434a5c7643be5a64de48be892ca46.1736793068.git.quic_nguyenb@quicinc.com>

On Mon, Jan 13, 2025 at 10:32:07AM -0800, Bao D. Nguyen wrote:
> According to the UFS Device Specification, the dExtendedUFSFeaturesSupport
> defines the support for TOO_HIGH_TEMPERATURE as bit[4] and the
> TOO_LOW_TEMPERATURE as bit[5]. Correct the code to match with
> the UFS device specification definition.
> 
> Fixes: e88e2d322 ("scsi: ufs: core: Probe for temperature notification support")

Fixes commit SHA should be 12 characters:

Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature notification support")

- Mani

> Cc: stable@vger.kernel.org
> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Reviewed-by: Avri Altman <Avri.Altman@wdc.com>
> ---
>  include/ufs/ufs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
> index e594abe..f0c6111 100644
> --- a/include/ufs/ufs.h
> +++ b/include/ufs/ufs.h
> @@ -386,8 +386,8 @@ enum {
>  
>  /* Possible values for dExtendedUFSFeaturesSupport */
>  enum {
> -	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
> -	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
> +	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(4),
> +	UFS_DEV_LOW_TEMP_NOTIF		= BIT(5),
>  	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
>  	UFS_DEV_HPB_SUPPORT		= BIT(7),
>  	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
> -- 
> 2.7.4
> 

-- 
மணிவண்ணன் சதாசிவம்
