Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A501A08A8
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 06:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742279715; cv=none; b=mfOBxFoZFHraHAAJUMZJgG3WvlpKOLNQOzFCbMpY/zKa5WToTWEicWrwF9EDUHwpVXKOFyHyH/yNNuduWd1CgqnW7e0LhlLWVEw9JBYdr6J/6UHgYetZ2/goZB97H5+s5xYk/yokVuuQsSQTnTA74vm74XFzpt2MtDhTVrawErc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742279715; c=relaxed/simple;
	bh=PryEXhcXzXzoSLQ+jG9MOOOhQkkDY7IE0CkRSj18qSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=chk898RpBvdJr8iOyLf6xSc+v1EjNDRFQAeRMElbGWgbjwFXpHnp7/NvHccD/CTdmtHT6WMmkGPW5AQxLllZL2lws3z9IL07O/qLq+G02vTtB3KPnIxzSCx8BWJtBnKDI/0yvixPJ9RK6oxQ0RltmDvuDbhR3eftOBpLH/h7E64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vbFoi6uv; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vbFoi6uv"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2255003f4c6so90608985ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 23:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742279713; x=1742884513; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U6F27MGkl6WcOKIJ4ECnYu/HOFV7Uz3She2p4aXiUWw=;
        b=vbFoi6uvanuqNU+e3irnqgpyWhyo4pngagj0m938yePxHWczYQAcJYYKxVxGFDdaBs
         7ca0mvYX17QhnMLNeWFEGsyp9zxoW8tbHIubjEIlJ5tcm2R53/KRZu8czaZcr0huLDWq
         nUwTe4kmrEk86cU2knNLzHHqW3cDLTv3VwLzmh2DS2To/zky61+/kQoy+wZOAEXk/cFF
         psM9p7ZywQypam7o3lAGIdx6RCzdtlqsGeWT1OiavYUe9pgxBKjHfpf9O6H20zHqYCnJ
         Bde7bTMSPM2WsWNpUw7DEqfT0efduEkOLp44Co6mOzcnjo5FtHI70uunFCWzCuG37KEA
         tljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742279713; x=1742884513;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U6F27MGkl6WcOKIJ4ECnYu/HOFV7Uz3She2p4aXiUWw=;
        b=KkMUoouu+Irt1BhzVtRsQ8xfRYhYbLsphgkMlEqy5rjswDCUSBSZdLbELqThE1UZY6
         /qHwLCrStrUgrTWZV1eEPetmVg9vmZ+sXwpqZfTWBXSZDWD60vlvcYDDRUJB//oZtRIr
         QT0xPz2N2FSomq/aw0GxY7FB7VZHouzI3LlZ9K2aBg4TSYxoMRdmVVkZt8nOH9VmPDaD
         QrJlBqvaej8qKjsDfP5XEWtaLv29EIL8mF2tKAdNq9WMI/Dqe8o2fsxuNTkSam3oUKcB
         +VTcLAyQ6QYzS89NNvEcvAMKdsQuRGjrUmpD8lNNlUQPwGDfYlSryilDO41KnzKuLwze
         E/fA==
X-Forwarded-Encrypted: i=1; AJvYcCXTBtBcJbzqDoZDBR7N7RAc1JndoNOd45rxQMkf1VALbEmmYn1qR+YSWN1YkMK8mZ4UJxXzncEJKGoq@vger.kernel.org
X-Gm-Message-State: AOJu0YzWpAuFFVVrBblLlRjduD7gx2WbLts2iWYRV8P6z+gGZ69M4aUZ
	sb6Zy6apT+o/YY7vBOPemM7gh2t6g0+rb12dQ9kwibjt15ZMfCDoiniaH0iqIQ==
X-Gm-Gg: ASbGncsAHmL96jecQsW1MIAN4yyJDqiAeII6MfNVcw6ALUrOqsZqmJ/JCGFtrj1Wwso
	KkwYciaHzlHFeAYxRDWErACtYDNtuCWXzuSivRItcEPRWRS5KnxuUBJ9jichGd+nukOqJQhQX9I
	RHUIN+dcQiux/6o6NMPIBezPKb2CSXbDLZSV+s2GqwpKfcbf/SusbTIvtGWh7/5DrmUMCVMhB/I
	fbOCHwKxjxT1xKk3NcsUkAolbJAv7Q/0bPOTW2i+doYTJ2o38ksuiIUpispq2kgusYwlgjUjOGJ
	Og+Y7/cbVfmI5Vsy30g/hO8hklGg81yGXGidfzDgH06/4l83adNAbCW7
X-Google-Smtp-Source: AGHT+IHCqFm9csE2qkE4bmWGh9NkZBAUBiZ2j02yr8s8ij2xHhs7et8fWqAp4EPwKF4QP8r/SzWwdQ==
X-Received: by 2002:a05:6a21:918c:b0:1f5:6a1a:329b with SMTP id adf61e73a8af0-1f5c12cd543mr23504218637.32.1742279712736;
        Mon, 17 Mar 2025 23:35:12 -0700 (PDT)
Received: from thinkpad ([120.56.195.170])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-737113d71fbsm8711029b3a.0.2025.03.17.23.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 23:35:12 -0700 (PDT)
Date: Tue, 18 Mar 2025 12:05:08 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Manish Pandey <quic_mapa@quicinc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com,
	quic_cang@quicinc.com, quic_nguyenb@quicinc.com
Subject: Re: [PATCH V3 1/3] scsi: ufs-qcom: Add support for dumping HW and SW
 hibern8 count
Message-ID: <20250318063508.4iz4olthqq2rhjce@thinkpad>
References: <20250313051635.22073-1-quic_mapa@quicinc.com>
 <20250313051635.22073-2-quic_mapa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250313051635.22073-2-quic_mapa@quicinc.com>

On Thu, Mar 13, 2025 at 10:46:33AM +0530, Manish Pandey wrote:
> This patch adds functionality to dump both hardware and software

No 'patch' in description. Once the patch is merged, it will become as 'commit'.

Also, please use imperative mood to describe the change. I don't know why this
is not followed since I believe, I've given this comment before also (if you
didn't read the process documentation).

> hibern8 enter counts. This enhancement will aid in monitoring and
> debugging hibern8 state transitions by providing detailed count
> information.
> 
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 9 +++++++++
>  drivers/ufs/host/ufs-qcom.h | 9 +++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 1b37449fbffc..f5181773c0e5 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1573,6 +1573,15 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
>  
>  	host = ufshcd_get_variant(hba);
>  
> +	dev_err(hba->dev, "HW_H8_ENTER_CNT=%d\n", ufshcd_readl(hba, REG_UFS_HW_H8_ENTER_CNT));
> +	dev_err(hba->dev, "HW_H8_EXIT_CNT=%d\n", ufshcd_readl(hba, REG_UFS_HW_H8_EXIT_CNT));
> +
> +	dev_err(hba->dev, "SW_H8_ENTER_CNT=%d\n", ufshcd_readl(hba, REG_UFS_SW_H8_ENTER_CNT));
> +	dev_err(hba->dev, "SW_H8_EXIT_CNT=%d\n", ufshcd_readl(hba, REG_UFS_SW_H8_EXIT_CNT));
> +
> +	dev_err(hba->dev, "SW_AFTER_HW_H8_ENTER_CNT=%d\n",
> +			ufshcd_readl(hba, REG_UFS_SW_AFTER_HW_H8_ENTER_CNT));
> +
>  	ufshcd_dump_regs(hba, REG_UFS_SYS1CLK_1US, 16 * 4,
>  			 "HCI Vendor Specific Registers ");
>  
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index d0e6ec9128e7..a41db017009f 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -75,6 +75,15 @@ enum {
>  	UFS_UFS_DBG_RD_EDTL_RAM			= 0x1900,
>  };
>  
> +/* Vendor-specific Hibern8 count registers for the QCOM UFS host controller. */

Get rid of 'for the QCOM UFS host controller'.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
