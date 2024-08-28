Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B6A16BE30
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 13:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724850936; cv=none; b=XeES3PuQ1mWpHtmmlz0kIRIiD2RTgIRfVBPNNqsHw1qR7h4s6+RtOd3BqY4F3W/qq8zQ/PmkH0rFKN6YqGR0dymjw+Z7PiAfa1zY089JVqzjo123/y4c4E3Ji34UsiDpGL5mRkPTeYGYYInj54gkF9LOtx3ygXVosnKHiHy7vP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724850936; c=relaxed/simple;
	bh=ah+6jhI5ss5hooA/BlJlnvVa5DwEdtYu8H93JxWNPpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C9Fp2FrsTKvdHun/KlQ6r9sue5OSVMzTUzBcmIAXZqzmSZnjMwNuhPEn72GhXooF10JSNtIqA6cRuIKGeV/F7UpbyiSKFASVrM45TFEFxmOmxI8fRiHAkXmVEOPZgKRzdSsUMUzW9YZ/JZjlGz4ttlZhX0aGcJtdnXxPW0uDL04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LhNAGa8S; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LhNAGa8S"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2025031eb60so58967795ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 06:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724850933; x=1725455733; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dmh04gzmPECoa4NnTe4KxPpKH8/gM2Cb6gM7BgiITIM=;
        b=LhNAGa8Sl81ROok1eMZxRCtCncAxM33XS4TfNxnag/cO7MVzfVIpbzKWGzWYfl14H0
         WRw0JGcfnf+c03+8cYP1rwySTBnismeN7bEA79vOZMCOR10H9hZAWHlK78P1wA2NoKiA
         MOzdPRbTK0PyjGSXPCZkRyT1CuQ59AuWsbcogSdQkS1TH8g554K3qjq6+mcj+Gzy5N7H
         b9gwyoLxVbdweOuMrDIdH4gz/rqBd9WjB/L5ayefv+NWyFvC3p5aIAsoKYagi0CKxIvw
         m3uHqPG8iQ8WrLgAqxG05WouZFt1/u9UGci02W8JOQF8mp5duEgIg07nwhoFrWUTqKIk
         muGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724850933; x=1725455733;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dmh04gzmPECoa4NnTe4KxPpKH8/gM2Cb6gM7BgiITIM=;
        b=Bg9neDcsBnoechlWZuDu5OgmEBtumD9jaeapbMftaWhf/jBR1TSARYIGtiJv6j1zlO
         9pVsGGA6prpL77evbyHbNBF7KOPdef7KmV6ea6tcEVtqqMckZB3adLidTkO/Fo/CMqHD
         n7AdUxmphHPp8IV5ZFUNfrGcj5j0FVLhLEkRBKPoZJxZM4yCwGqzH5F14CMA6KILzxhK
         kxYmsq4JQIDw+P04rp2dOT3Hqs7IlTaAFDpFNLceXuRknkSqVhsYiTDPKhj4lJb5qROV
         nCDe+3+Tl3RW1Hk2Ljh79jLFn/nxb3OXEWGjQdLzLteEZ/mCL9Q/yEZnxiYJRrOxDoVV
         Xa5w==
X-Forwarded-Encrypted: i=1; AJvYcCUtRijlPF3E0uHsKt6TKohCWDBWTOkReqKMXI3HHrx5/YxxCfgRCE0yzfqH1mV9STLIviBy2rZBIssF@vger.kernel.org
X-Gm-Message-State: AOJu0YxlEcB20aXryJWBz/mbXcE4vcIN5A7oTd1ch6XGnR528Ev181Ak
	LHNUOKwvL8ToCtzBqT2vtBDYngBk/v9FKzuUf2La0dSmLkWD7i297EjBcDhsG+FfUsOX+GFKYcg
	=
X-Google-Smtp-Source: AGHT+IGya5XNkj573WaCJk+Ci8cx/XSHPyf2d7LHItxiVozjc104SLB6/Mr3Y3MkCWrX75Br+5jYvw==
X-Received: by 2002:a17:902:ccc9:b0:202:1033:8d25 with SMTP id d9443c01a7336-2039e4b4ae4mr214239825ad.35.1724850933411;
        Wed, 28 Aug 2024 06:15:33 -0700 (PDT)
Received: from thinkpad ([120.56.198.191])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038560a301sm98172485ad.217.2024.08.28.06.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 06:15:33 -0700 (PDT)
Date: Wed, 28 Aug 2024 18:45:27 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Manish Pandey <quic_mapa@quicinc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com,
	quic_bhaskarv@quicinc.com, quic_narepall@quicinc.com,
	quic_rampraka@quicinc.com, quic_cang@quicinc.com,
	quic_nguyenb@quicinc.com
Subject: Re: [PATCH] scsi: ufs: qcom: update MODE_MAX cfg_bw value
Message-ID: <20240828131527.su2bl5iyxdllfbkl@thinkpad>
References: <20240828120502.1439-1-quic_mapa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240828120502.1439-1-quic_mapa@quicinc.com>

On Wed, Aug 28, 2024 at 05:35:02PM +0530, Manish Pandey wrote:
> update cfg_bw value for MODE_MAX for Qualcomm SoC.
> 

As Bart said, please do not send patches with these vague descriptions. They
provide no info whatsoever to the community on why this patch is needed. There
should be a valid justification to convince the community to accept your patch.

If you are sending a series, this same comment applies to all the patches.

- Mani

> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
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
