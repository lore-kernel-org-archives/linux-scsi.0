Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8E66139
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 07:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718781219; cv=none; b=K/Ar+Y6Oa7k2+YPEckckdYO1IEw+l+8GbwMToz0yQPGKwtgUcAhXllPS5K98xJpah+9CmYDCJ3geJAQlDarEJwWgwURB0cC7IBbs6Ooi3NspDWaCmcAFDL8XfCUcmZ/s4PrRW2/MnUykRvflR031Zy2L7STX1crekA7p/7xu4BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718781219; c=relaxed/simple;
	bh=wCaLzYiDRwC89FpYOaWIdMm1AlTkSdiVxGKuachdLH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M23Cg+zgGOYUYJ6MnAykFmk+KW5iX+iFZ++jR6+1sv4YIhHCuur80C4Kpn/AM0p+DCXnMatlb62Fc95EmVCXqJ6Tuce9quSsumVIDAMFyRpC2Z0PF5QeWKv0wZV9NKIgAMcf985+MZBxxc5OSZRmqvcGFqFffKcLGe5YWVduNXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hztnmBwY; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hztnmBwY"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f6fada63a6so50919715ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 00:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718781217; x=1719386017; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QK7OBYtWo4eVoWKX5VN9To9vV086DlpOPkOB5TfhV0M=;
        b=hztnmBwYhPym8G1g57I3P68rG6qw5lHMbh3NZKGSu4YzeamPU24g86TLjVZtf8JE/H
         2Ftf0No8fTmbNmezAI1j9cQl6Kmat5ytbwmAlWrxEH9Dzr7cIqzdVwaNYN2jWk3a5IPd
         aia74VMdUXesSb/in14aoHrwacOF/lXHzrOsVA9c0egNZB1nNsM1dvHb3xKlgjHaX0Ql
         OhDr8O6b7t8X4CBrJ/lOjHuUI5Nxa6bkTI/aFQ6sPi7+Qbdfvt4SHnMpL+lFQrVZEt+e
         7r6/JFdRApg10pi5POYTU33i4AKT0yDiRFn/pK/eV8oNTyxXFRQh7q+ru23k5R+JBZIk
         nEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718781217; x=1719386017;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QK7OBYtWo4eVoWKX5VN9To9vV086DlpOPkOB5TfhV0M=;
        b=VZH9QEq4NoSO9ekxs9ulnYqWL0IudL/v4/Y7dvFIIb9sHiRpjtTKfx9EDt4NNSxD5x
         HOuGhbA/9Rqg7PwVbya+1TEMX2eweCBDm1TEOUZkc9TFvzFtAH529UuS9n/mQ/tfmZh3
         CnL3mSOrrxL9j47NDzvrMUbuvvKIg1GqfkO9zvmkgzrEiKXac81BJkxeKv7DSuTYe2Sw
         EB0TQ7ADCVNCh5THOdrTwq16h/TYLBhgXBrfCK+Ij+cmdQxML54Aak40cW+P46iRWvdB
         YyOJ4S9lGnTK7U9hrR3S6voe9Ysh3X/KoHYasohN3AI5XWoqUfTxoRaJwcwZB55rpVaY
         GJxA==
X-Forwarded-Encrypted: i=1; AJvYcCVjk6jO73Kilm+S/f4mvuoTp0f2jsV/ZzQqo9wJ2W0WnnImqTuVfIX1igQNVwQvVsv78HD3XpWm+sOQrX6YfgnNlAQyJkRsskSZjQ==
X-Gm-Message-State: AOJu0YyF9fA9Z9EPVg2DPgVaXcAFP6Qttycm3k5YW3rYS9/Jzx4ImFJQ
	lI96ZcW2COTD0LVPnswxXlONGTHQUym5eBzIEdkwc0RVtPqulJH4mo2enBRpJ3WOxEck/N04miE
	=
X-Google-Smtp-Source: AGHT+IE0V+6PzaXjEizkG0oM7zBxBtuUe0khMH3vIi/hWBr6MxKPg1ilIGQ/JzqqVDOD0awb+sAa2w==
X-Received: by 2002:a17:902:da84:b0:1f7:2293:1886 with SMTP id d9443c01a7336-1f9aa3a7f37mr19693735ad.12.1718781217325;
        Wed, 19 Jun 2024 00:13:37 -0700 (PDT)
Received: from thinkpad ([120.60.70.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e7bf76sm108894545ad.105.2024.06.19.00.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 00:13:36 -0700 (PDT)
Date: Wed, 19 Jun 2024 12:43:29 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
Message-ID: <20240619071329.GD6056@thinkpad>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-5-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240617210844.337476-5-bvanassche@acm.org>

On Mon, Jun 17, 2024 at 02:07:43PM -0700, Bart Van Assche wrote:
> UFSHCI controllers that are compliant with the UFSHCI 4.0 standard report
> the maximum number of supported commands in the controller capabilities
> register. Use that value if .get_hba_mac == NULL.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufs-mcq.c | 12 +++++++-----
>  include/ufs/ufshcd.h       |  4 +++-
>  include/ufs/ufshci.h       |  2 +-
>  3 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 0482c7a1e419..d6f966f4abef 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -138,7 +138,6 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
>   *
>   * MAC - Max. Active Command of the Host Controller (HC)
>   * HC wouldn't send more than this commands to the device.
> - * It is mandatory to implement get_hba_mac() to enable MCQ mode.
>   * Calculates and adjusts the queue depth based on the depth
>   * supported by the HC and ufs device.
>   */
> @@ -146,10 +145,13 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
>  {
>  	int mac = -EOPNOTSUPP;
>  
> -	if (!hba->vops || !hba->vops->get_hba_mac)
> -		goto err;
> -
> -	mac = hba->vops->get_hba_mac(hba);
> +	if (!hba->vops || !hba->vops->get_hba_mac) {
> +		hba->capabilities =
> +			ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
> +		mac = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
> +	} else {
> +		mac = hba->vops->get_hba_mac(hba);
> +	}
>  	if (mac < 0)
>  		goto err;
>  
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index d4d63507d090..d32637d267f3 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -325,7 +325,9 @@ struct ufs_pwr_mode_info {
>   * @event_notify: called to notify important events
>   * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
>   * @mcq_config_resource: called to configure MCQ platform resources
> - * @get_hba_mac: called to get vendor specific mac value, mandatory for mcq mode
> + * @get_hba_mac: reports maximum number of outstanding commands supported by
> + *	the controller. Should be implemented for UFSHCI 4.0 or later
> + *	controllers that are not compliant with the UFSHCI 4.0 specification.
>   * @op_runtime_config: called to config Operation and runtime regs Pointers
>   * @get_outstanding_cqs: called to get outstanding completion queues
>   * @config_esi: called to config Event Specific Interrupt
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index c50f92bf2e1d..899077bba2d2 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -67,7 +67,7 @@ enum {
>  
>  /* Controller capability masks */
>  enum {
> -	MASK_TRANSFER_REQUESTS_SLOTS		= 0x0000001F,
> +	MASK_TRANSFER_REQUESTS_SLOTS		= 0x000000FF,

This should be a separate fix that comes before this patch. But I believe this
came up during MCQ review as well and I don't remember what was the reply from
Can. 0x1F is the mask for SDB mode and 0xFF is the mask for MCQ mode.

Can, can you comment more?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
