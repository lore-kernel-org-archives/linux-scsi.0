Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B326519C55D
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 12:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725281251; cv=none; b=CerxYHP+dOGSaeI1Jho+brlXd9PHjkFRoe8mVq/AlFIDolCtH0pkrKnFafgAe3ndOZBbpcMEa+x6Bc4gjPEZoXAEyewmLIr9o7G9Bs+5As7vOilrqzmPoHsHQsq88cUGwwuHHQ9iJw0Jvo7anJugMHAp+cJz/s5GEmZlRNbXgYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725281251; c=relaxed/simple;
	bh=wF+TDzVSJ2YjjfA3NeGCW28IVmyODfLzxaDM+fl+FHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lCYhylKuLrnqxH9bhPWhp64bODwsIFfWoxcbUHuhfoptoOhOKL1DZ0NBV+o50E4MgaOgaKOJ4pEKDiHW+q4u3BD8XLRz6TObGDeDot2OHIXtydP4TYvxyTGQFRKxeYcNG0gjWr+4nOJhNvaIO1JMEqGVl884kCC/WkTJH9tU6ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D7y3iaBU; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D7y3iaBU"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7140ff4b1e9so3228729b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Sep 2024 05:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725281248; x=1725886048; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sw56HONjylV3zP4q+WSmMqj4D4zJNduIGjeb5jWNs/E=;
        b=D7y3iaBUDV4W8AREiDBPtobdyHc0MbJbkyFnawRRq2UgD+LGkaBnWAPzZdWF6OSJgT
         baX/8s2Tf3wMlXsBcC2lI1IUybFOBVmRLRXKf51vSVPW+RxYpBEjQl1SBG+Ilb6y8LHd
         RcqOYVD2YRk9KCXogddYguzsJN+vjYhgcsoMbCCddFZfKLSIWu1cOckqSYhQJrYnRWYx
         J5xFkybBuLo51BnqFjveVmWvJEG2hDEQhpLecYRG5LgVgaFgOn1wUs4SLusmkBFgdKU2
         imKrnRTzCAwi7Zj6rVutx6ekbNsbdyWBf/yQUgyg2OwZk8h0A3GkibF//Vp+O/k2ZQfL
         T0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725281248; x=1725886048;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sw56HONjylV3zP4q+WSmMqj4D4zJNduIGjeb5jWNs/E=;
        b=gyQLwYRquFe20FzXJ3HRQoCCjUrto9ni3KoY54LZYCrYCgaAgTqvBfuAWK/eQGRkfP
         8KVQPcY5PFE6+XAW3ERG1duLPVghoohM2QA7TAxK5Jq9yU1vmKim4fTOwHEQgMZWrbdq
         CmybHv6yzMAAuDdmAes0j4NUAU5Ydzi7+SDhgOEI8jvmuu0TB8R0XMQ9ljy1ZtQSfqrM
         UdIFuC6hiStpyLUnHrg9tFqJmkiahMh4LukjC3lBlj3BMhSI/lggtfhpE1ePvOof+RAS
         EtxTCse+lv04vsDWWjMnJNah77YJfKq2dNt35QRc7SZBxYMpbIvGqz2r+dAzGhcQ0bWq
         kSCA==
X-Forwarded-Encrypted: i=1; AJvYcCXPDaPPg2ptT+CNTrn6dUZ5X4f41gEJL5ldQCTCVL7OXquVfq1+HEDZr/8N9oy3zQNhllwrZoWUPsXb@vger.kernel.org
X-Gm-Message-State: AOJu0YyHMLH5vl3yOUpru45zzBuMPIZdQ9odxQNXvMW1A+YeyNa/2h7h
	aMmbQjkdBAjYv2UXbpolt64cpj4Tc/ff8OMmXyNMkncaBPyDTIoFb68tGE5+VA==
X-Google-Smtp-Source: AGHT+IFm74MUePoqdJK4/q3NgMhKFYLf6zUq00FAgFNFSomryCyuaX6pCUOEG8+oPT7dru6YDuaHVg==
X-Received: by 2002:a05:6a20:b58b:b0:1c0:f2d9:a44a with SMTP id adf61e73a8af0-1ced0469115mr6570664637.22.1725281247917;
        Mon, 02 Sep 2024 05:47:27 -0700 (PDT)
Received: from thinkpad ([120.60.129.190])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d22e9d77f2sm7438317a12.89.2024.09.02.05.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 05:47:27 -0700 (PDT)
Date: Mon, 2 Sep 2024 18:17:20 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Manish Pandey <quic_mapa@quicinc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com,
	quic_bhaskarv@quicinc.com, quic_narepall@quicinc.com,
	quic_rampraka@quicinc.com, quic_cang@quicinc.com,
	quic_nguyenb@quicinc.com, stable@vger.kernel.org
Subject: Re: [PATCH V5] scsi: ufs: qcom: update MODE_MAX cfg_bw value
Message-ID: <20240902124720.coeidzis2xcmglzl@thinkpad>
References: <20240902114737.3740-1-quic_mapa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240902114737.3740-1-quic_mapa@quicinc.com>

On Mon, Sep 02, 2024 at 05:17:37PM +0530, Manish Pandey wrote:
> Commit 8db8f6ce556a ("scsi: ufs: qcom: Add missing interconnect
> bandwidth values for Gear 5") updates the ufs_qcom_bw_table for

s/updates/updated

> Gear 5. However, it misses updating the cfg_bw value for the max

s/misses/missed

> mode.
> 
> Hence update the cfg_bw value for the max mode for UFS 4.x devices.
> 
> Fixes: 8db8f6ce556a ("scsi: ufs: qcom: Add missing interconnect
> bandwidth values for Gear 5")
> Cc: stable@vger.kernel.org
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
> Changes from v4:
> - Updated commit message.
> 
> Changes from v3:
> - Cced stable@vger.kernel.org.
> 
> Changes from v2:
> - Addressed Mani comment, added fixes tag.
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
மணிவண்ணன் சதாசிவம்
