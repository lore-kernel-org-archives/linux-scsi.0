Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E83014BFB4
	for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2024 07:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725002414; cv=none; b=kj5Dkh73DYxp4PrZrKZYlG6z6x8KeCs9OdbrT+IMoCwu+952DrEwCUuSJRm3VQMZiaqNsigkm8miSW1oKqe1/LCX+8a9BbEy6QHP4aY9BtiGGex65g9cfWWfsHjUSyTOc5YgG71fFMpuRpmCr9m+Msk6GSQviUSWGVimhvGUgTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725002414; c=relaxed/simple;
	bh=HLaqna6UCuIrOsmYb1PawOtU1637YFWvoiEdQ3WVIvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ww+zwOouSssfPiKsfYjjcs18aEUOI242ui3FA6VlDnl1qxsm1gZ6QDnFlxb7AkS2QREsdWCRZlMkst2mAjKqVTwBoVWzZyodvCLLivkTW4vNQDMSL/z/Zj4QsmQS4NKWG3kHDGIJg3k1uIEdk4r8fEp3RY+btJbTe8czdeDJtCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=joBH0amu; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="joBH0amu"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2f3fea6a0a9so14086411fa.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2024 00:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725002411; x=1725607211; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3qiXwyV3htRr/C+q00ThbxxW4I9Cl0S2rzv2BfSX2XE=;
        b=joBH0amuZpBKyGqaJtPqzzegijjS50M4tXjk8LFHCMGa9oGTVNbBs1udaNr602W2WT
         4xdG9K9J+IXAhMn2CX9uWbtRe7I++LOA+blDXWboGMjWLTxqbUypPoJFgeaQBPK/fOr5
         CrludGWJ0ZBMpqblO99/Qyg7ckv1tlCURDn3rUqGoC0YOCpmCbJW2Ab92R+8NFn3N2Pr
         lUa1PLpiPEw9oKoYgaccdpKFo4yL2+GrCU8rXl1TClSVeQOvvloKXh7UCKbVQngLvkJ0
         d51G7tshDXD4+RUyYMwOCUvYi/52COj8nF/0Az5yn+M/UKTra/j06NKvbeTgkOoVAA3c
         IDew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725002411; x=1725607211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3qiXwyV3htRr/C+q00ThbxxW4I9Cl0S2rzv2BfSX2XE=;
        b=jSKWZzx5gCdbeGmKIUQB5xqEU+bnSPYLMl6+/jHPNA30qMWEuSOz3+9UQQrqV6X3q2
         +XPxSKXjTyR49boFF4N36nOl7p18nqGwgTrz7r+p9+1RH0rycgsWpwpDwF7WAhPJyfCD
         WGWFSpihgnGS+R9fbilsBLDZYmxC6npKKJWlT7aVHAB3ihN6OApmogJ60547sOfr8/lA
         1DR99WWtCkUYToorLqLHFaFsTEFQWGIWlcwH2YrT4uVFQ7BiUUo5Kks4AcVq6Q7qZNCe
         HIyTpNPHB/B6RoN44NTCKXgBXsL/MeEKPTNPf8h134FlA41s7Hly4TGA0ZltnXzhdHoS
         2bDQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5qvGWWqKbTMIWXMZEXPUeNTDxPpllfN/Rid5KSe3GiHwwmK1tw/EGFOfY7VN+O7+ZrTVohZ+Uo7Bj@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw0+PxnWNM6h7suykYg3YJCCrkvdr5vi5HN5LvJ8B4f+HB/eZS
	Ni5c5RbdisoF3TZVEnJ5RVS/vt9757y1etrD4r94XmkvHPIhBocMLgZYOTbfG/c=
X-Google-Smtp-Source: AGHT+IHr64ktPPLwO8bWL9kuJHNB6sUG3ObN0WP5rN3nb+epYFlsrNNeuu9wmeVfANO5vZbNzp/aoQ==
X-Received: by 2002:a2e:a99c:0:b0:2ef:2f8a:52d5 with SMTP id 38308e7fff4ca-2f61e05c9cfmr5342641fa.8.1725002410729;
        Fri, 30 Aug 2024 00:20:10 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2f6151828c3sm5066641fa.109.2024.08.30.00.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 00:20:10 -0700 (PDT)
Date: Fri, 30 Aug 2024 10:20:08 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Manish Pandey <quic_mapa@quicinc.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	quic_nitirawa@quicinc.com, quic_bhaskarv@quicinc.com, quic_narepall@quicinc.com, 
	quic_rampraka@quicinc.com, quic_cang@quicinc.com, quic_nguyenb@quicinc.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH V4] scsi: ufs: qcom: update MODE_MAX cfg_bw value
Message-ID: <a7v4sgkh5f67hmbrpf4hukgt652qzkgaykszsbzbed44bnh2m7@xaspg6nxxduf>
References: <20240829123938.31115-1-quic_mapa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829123938.31115-1-quic_mapa@quicinc.com>

On Thu, Aug 29, 2024 at 06:09:38PM GMT, Manish Pandey wrote:
> The cfg_bw value for max mode is incorrect for the Qualcomm SoC.
> Update it to the correct value for cfg_bw max mode.
> 
> Fixes: 03ce80a1bb86 ("scsi: ufs: qcom: Add support for scaling interconnects")
> Cc: stable@vger.kernel.org
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> ---
> Changes from v3:
> - Cced stable@vger.kernel.org.
> 
> Changes from v2:
> - Addressed Mani comment, added fixes tag.

Mani also asked you to provide details, why the value is considered to
be incorrect. You have responded in the email, but instead those details
should have gone to the commit message. Please fix it accordingly.

> 
> Changes from v1:
> - Updated commit message.
> ---
>  drivers/ufs/host/ufs-qcom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index c87fdc849c62..ecdfff2456e3 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -93,7 +93,7 @@ static const struct __ufs_qcom_bw_table {
>  	[MODE_HS_RB][UFS_HS_G3][UFS_LANE_2] = { 1492582,	204800 },
>  	[MODE_HS_RB][UFS_HS_G4][UFS_LANE_2] = { 2915200,	409600 },
>  	[MODE_HS_RB][UFS_HS_G5][UFS_LANE_2] = { 5836800,	819200 },
> -	[MODE_MAX][0][0]		    = { 7643136,	307200 },
> +	[MODE_MAX][0][0]		    = { 7643136,	819200 },
>  };
>  
>  static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
> -- 
> 2.17.1
> 

-- 
With best wishes
Dmitry
