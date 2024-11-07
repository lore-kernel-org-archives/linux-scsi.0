Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC101DFE24
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 10:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730976655; cv=none; b=HLIqeLqkeSGomx/RJ+PbzXYJAFgPjkAlui9WJ5qa3RERY9UTF5JY2X6z19dCtSvbAqRb/wOqcAvv2x6nRfMfaVwU4IcmbsN5AA7uohq/+4fXZNCGclQ3dgz6H3PsztHuf38P4le/YQNtUIfeUfxip9hPd2ONURYDIKNMSwieIP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730976655; c=relaxed/simple;
	bh=TI4mI62i2lA9Q462kSLPExNSp84dUMEi6nA8hDiwGeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUGFwEuYjwfrlqc2ptZob0A5ClfFXsmgP26eAJz383lucMuUPdUiTweFP+TeYncHaTuXwAXHYuN9mL5wAQNWuuY1YFFTY1VyUj8kus1F5sp8hYtjrLH9LRoEbvvVN1Z7cOFX88dP1McFOZjslpihHbVAuwXioIo9dFujhwcrSjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DJtwoKRp; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DJtwoKRp"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-37d4ac91d97so702739f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2024 02:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730976652; x=1731581452; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=twGiQ6Kq4rb0JWoEsS+a3dxTYdcCCgV2GSNZ972e0+0=;
        b=DJtwoKRpIAR0pEMXN0ASxlWDipNhUhOFyWK/4jlNhZs/YTU03CQwkutPXlcM4kyj6X
         qXJdOUOyQRnTo39MP6Hu5pnv3lPlNj54Oto8OX2Fi8qhudnGvKATKRu/2ypMetBIc/oD
         xm4lPLulgjp2vzLD0lGpzol+fc+kAg01qiJZPpeyuNGzE7XmEMTDGJ2IlV+74sH0EtMS
         p+TejGAKc4kYqZAj9crGrVpnA020Pdx5li0AXd+dYLYkZIszdwxLONN0Qqbjd1zPWRUe
         lWcG8vf8XoR8UnsqsVElF19ABdXgxihMKsz77kfTLmFlOGLrV8CQlsKpD7HYgjTurPkL
         q1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730976652; x=1731581452;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=twGiQ6Kq4rb0JWoEsS+a3dxTYdcCCgV2GSNZ972e0+0=;
        b=ChZg9mE/DkZhR98EZUXUEj5uIz0Llb6dcKK7S8WStd2ExyxYiL95qD092Kx8eEo1NQ
         0aq42RC00lSrpRfpuNGXxic4tHJYFMdL+LTUX44VBxQzI4dCtTjdoExdvoJ8w6kdJGv6
         A05HPaExxJlbApD68zomU1bOuVp8bcXTR0YHFbdW6uvobHtyo0JPn8hlJ8sgZUoz5sSN
         08UPTkvhf32vSjmFfLHFve64+C9vBwm1mUNIU3HHkXwGMGFbE5GBS2mbFhNvaCYQ8lPD
         ATa4JyXZGpRrkhTnnmDYfUQkhwvCdpLLgH41C/XkVQW2ip+6hUfjPYph255XPee2+tgH
         pYZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEtaaSHZjry5znSMlWvJJ8SAA1c76Fazf9SpzT7xg3WdSdFNQ8R8rKpdeOIYfLfd1OytnoRfKO/rTv@vger.kernel.org
X-Gm-Message-State: AOJu0YzT0uHWlr1b1fiufZvUsbT9QOYTRAKJI2Rxh+qr3lOBLIF+7pPE
	5JQPpKWe465mwATqWRX9Z2iYU9HwPgJ3u1nqFL6ixix+aP9iGCzVe3E7tov0ztL1Yzc12XI4v3U
	=
X-Google-Smtp-Source: AGHT+IEdFaPBpx5fBWbeDjnAss2LtHeDjjTXMEGNcgmKMGUFzvGDi7/Ku+YXD3HdEccahRgGNqD6BA==
X-Received: by 2002:a5d:47ac:0:b0:37d:48f2:e749 with SMTP id ffacd0b85a97d-381c7a4636cmr23257327f8f.10.1730976652506;
        Thu, 07 Nov 2024 02:50:52 -0800 (PST)
Received: from thinkpad ([89.101.134.25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed9978c6sm1380591f8f.50.2024.11.07.02.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 02:50:51 -0800 (PST)
Date: Thu, 7 Nov 2024 10:50:51 +0000
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: Re: [PATCH] scsi: ufs: core: Restore SM8650 support
Message-ID: <20241107105051.45gpesluiljibkco@thinkpad>
References: <20241106181011.4132974-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241106181011.4132974-1-bvanassche@acm.org>

On Wed, Nov 06, 2024 at 10:10:11AM -0800, Bart Van Assche wrote:
> Some early UFSHCI 4.0 controllers support the UFSHCI 3.0 register set.
> The UFSHCD_QUIRK_BROKEN_LSDBS_CAP quirk must be set for these controllers.
> Commit b92e5937e352 ("scsi: ufs: core: Move code out of an if-statement")
> changed the behavior for these controllers from working fine into
> "ufshcd_add_scsi_host: failed to initialize (legacy doorbell mode not
> supported)". Fix this by setting the "broken LSDBS" quirk for the
> SM8650 development board.
> 
> Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
> Closes: https://lore.kernel.org/linux-scsi/0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org/
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
> Fixes: b92e5937e352 ("scsi: ufs: core: Move code out of an if-statement")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/host/ufs-qcom.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index a5a0646bb80a..3b592492e152 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -874,7 +874,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
>  	if (host->hw_ver.major > 0x3)
>  		hba->quirks |= UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
>  
> -	if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc"))
> +	if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc") ||
> +	    of_device_is_compatible(hba->dev->of_node, "qcom,sm8650-ufshc"))
>  		hba->quirks |= UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
>  }
>  

-- 
மணிவண்ணன் சதாசிவம்
