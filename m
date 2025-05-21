Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A4C270546
	for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 13:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747832902; cv=none; b=n60ur/jSwGT0Oy0ie4JIFsAF3a95wMC5DqxS91ZgN7NUG9w/etUBbEdK75e4iZvv+Y/svq4qpqv3hXCB1JcZLVPLwwqA2lI6pdpuFMMns4MKW3vnlMTZ/gtEG/bBQ8XLIwXQUW3FhXWr4cTp+HqblFe2lBRQ5fJk5XQWAnFRzJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747832902; c=relaxed/simple;
	bh=y667xlRjshHTCdOcA4582uYlKjS+bp6OLEVTjHaUkzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4KV8Q6HCUdHkEW3AW/S5K0TSoKTuGS5z+Cjxh+Cae6ImIqyCGqa0MttRbghFsX9oVBFESbgJ9ntZpVczP8T1PbGF2Z4FdF7+c4Ok2/iGe4jkSnqb1yq+6LpSX2h5tDVa1QZ9s2RLMyS1akIGwMz/LN65UsFYKC1axlCEptmd4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ACsfUy/d; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ACsfUy/d"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-73972a54919so6339868b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2025 06:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747832900; x=1748437700; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xt5u1NW+UKPTvEFieJrj+mDAWfwc6t4eZFA83UFoe+Y=;
        b=ACsfUy/dVIhtCIa4i4sgWdTlmemyn4/Gh3xS2F+MJJEcEvsfT45SeINJE1Bvn7uXSK
         iXfDX17syhq6H+KIlwADx2kTL6Tymjb5aZfJI5VRCiNwyurLb9mSJCQg7kCPVN+iJaNO
         AMqXjmtXcwk6HSUBUzQaIIVtP2DQLW0be22TX0j7G9vOyQT6l9XKlKLcIY7U0fDEswB1
         kJVtJLYEZZ4veeWtzF96a4GMU/5Fdy6C15rEkK9xLwq9jhK27jlAMOY/d+gbdAYuvHgQ
         D0NRVViMFNX0x35suKzKtTsS6A+xZ+oC9PFdglTKTAvpTfRIxzZM8VCIj88ClTzyGwbu
         Kn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747832900; x=1748437700;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xt5u1NW+UKPTvEFieJrj+mDAWfwc6t4eZFA83UFoe+Y=;
        b=TFbp4aeTRoXsNkz5EarUXgn4lrqmNx0VuH8LkjRU7Gm7cBQOExo8O/VySNCrc01o9Z
         dlEEBRD/57I6W6ipwjWe7wifV8XCvZcMIA1JtVIklLGgv+sUOotetC3K1LFDxhbtkjes
         44Ss/hDBrY0cfI2enohkGStDHfFrbBiI9JI4be5+UTbiAKpByRQiKI416pk0VhPwHI5m
         KfzBY6ON150+htbRJ9xocDusFJ0ZLmkuzWijsActX4ffNYx8LLmIDVE0MmlFmH16U4Oi
         u7i3nrRGgteABxAM98tQTAAhWEp4sSXSq1dK41ZdxpUBwFAKCP1XufNi0s8ppYpNMoLq
         s+HA==
X-Forwarded-Encrypted: i=1; AJvYcCVzytFmgfQWsMerQiZJfkqI4mWUjdxiHK8Mo7ZLExb7u8bWrg5XVswasHzbmZ5fFmQ8yOYUSCfB3wqz@vger.kernel.org
X-Gm-Message-State: AOJu0YwbhnjnU89T1i740iIU+6X19N6cogh3FMVfGgKakRalI3wiNkiO
	ZHJ3B22jeOKTg1iPh2F36hBUHL0W5j/+ZhClwzxuB5r+CPqB7YEP78xo9WnUieJ/SA==
X-Gm-Gg: ASbGncutmzdM4EajE/n61PEn3ckfpsU9Y+0kwvMMYkFauj8cJ+HAzs9p7qDRCTanVN6
	FZrNqfYWo9yEuOvF9BZMmhIOm6AU93V9P62sm59SAvDPdOLYgvFNmP4uh+3rdZ7I2qZP7/lWB+O
	QOdiFggh65Gjd1o3EhBgUPf+2dokpbhnXuLhLMIfuDl7B0EDBQanW3TsC2W74VY6nLvLo5yacWm
	B2zga4EvzxE46QAtup09VwwXpmCi8XAz79nJ6fqTVEDP3aatsNd/bJcomoQMoP3q6eJHQJ5qDCX
	mL2CKSEvvk/m0PUqyLle6jI0/tcTTfD4xkRZWRw5IlZZcE82077+hxSwY9PL
X-Google-Smtp-Source: AGHT+IHascvxCoFVkA31LZBdvW7jzau3iUVkHksoNUV8TEsEK7Xh8qeVnLYOu02jnBVSWphaqJ0viA==
X-Received: by 2002:aa7:888e:0:b0:742:a02e:dd8d with SMTP id d2e1a72fcca58-742a98b4a84mr28669364b3a.20.1747832899901;
        Wed, 21 May 2025 06:08:19 -0700 (PDT)
Received: from thinkpad ([120.60.52.42])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a970d5c4sm9842432b3a.65.2025.05.21.06.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 06:08:19 -0700 (PDT)
Date: Wed, 21 May 2025 14:08:06 +0100
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, bvanassche@acm.org, 
	andersson@kernel.org, neil.armstrong@linaro.org, dmitry.baryshkov@oss.qualcomm.com, 
	konrad.dybcio@oss.qualcomm.com, quic_rdwivedi@quicinc.com, quic_cang@quicinc.com, 
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH V5 01/11] scsi: ufs: qcom: add a new phy calibrate API
 call
Message-ID: <jnftkie5c5hi6nqhliktxqbj7gykj53lvm5gibt3fjdcq7dber@bh4fxrp3fezu>
References: <20250515162722.6933-1-quic_nitirawa@quicinc.com>
 <20250515162722.6933-2-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250515162722.6933-2-quic_nitirawa@quicinc.com>

On Thu, May 15, 2025 at 09:57:12PM +0530, Nitin Rawat wrote:
> Introduce a new phy calibrate API call in the UFS Qualcomm driver to
> separate phy calibration from phy power-on. This change is a precursor
> to the next patchset in this series, which requires these two operations

'next patchset in the series' wouldn't make sense once this patch gets merged.
They all become commits. So you should mention 'successive commits'.

> to be distinct.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/host/ufs-qcom.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 37887ec68412..23b4fc84dc8c 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -531,6 +531,12 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>  		goto out_disable_phy;
>  	}
>  
> +	ret = phy_calibrate(phy);
> +	if (ret) {
> +		dev_err(hba->dev, "Failed to calibrate PHY: %d\n", ret);
> +		goto out_disable_phy;
> +	}
> +
>  	ufs_qcom_select_unipro_mode(host);
>  
>  	return 0;
> -- 
> 2.48.1
> 

-- 
மணிவண்ணன் சதாசிவம்
