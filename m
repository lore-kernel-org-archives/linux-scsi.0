Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A05241665
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 19:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770924728; cv=none; b=dY+5Grw3TTmRVq8Mk2NWgklfRlk8i6e36jTBGSTkRn8zqrT/gbvviNu4FvT3ODG987zA3I8tLWly1TvxHBKFZ+MLXHUc8eBK+5wZYsryZ6PDu2THuTwSlV0j2X6SSYVm0NXqz6LLB04h8WtiehYzoL2RQ7nkkTY+R0hz+fHfYQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770924728; c=relaxed/simple;
	bh=5JO4JaYlz29aRc4eZ1BzjkE5r/Pera7eJaYFnlnjWT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RlECu1EL9On3DLI5Fj4rrRatW0llJXPLjBXQHzaFhGsgKAhDnomNtgLFpFC0WszrF6oMhhh79wULggpCe4gZxo73hhvv3QWI5j8WqNg1ic36YC1QSHzx/4geaUWLOZNAVcDGuhYW43veUQRKaoFwJDalf/kQmRYLy47NVwXzBIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=BgiEVDt9; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="BgiEVDt9"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b886fc047d5so16854866b.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 11:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1770924725; x=1771529525; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xm67HOMJjtVzpz2QwYvEC/Ust0XT5jG8ZzeC1EEmRyE=;
        b=BgiEVDt9nzgbLoNWF5wu7PZJ2xrJ7yOBGHhLsOP39UZnnq0DaL3qwQLdwQDoVl2Elb
         iJjX8VytWo4pmRPovcMpistoqw81w/8+fPf8h1/KmtaZXcro6a4v5jlcE9eNUuqm2gBe
         jfug3CTy39q1zcBHsoJd4fGJTlQ1DothjN95zaemb+PEowO5qfCD8vLUjkApTXpDdvvY
         RLsK8WOXfLA+Teb2kmOv7uiF5WjPUaAr1DfbRDtvksZPt8AM88UE15HJF76htARDvrtc
         Ntvs3KMp5p7KxNqtCAyj28Y1hvozuW0VmJcgxi2mclmKn3N7GId7j8po4+3JDptRGKQz
         mOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770924725; x=1771529525;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xm67HOMJjtVzpz2QwYvEC/Ust0XT5jG8ZzeC1EEmRyE=;
        b=YU2boOneT1V0vPTje5mRsGEqUgninKWKPFyPdtMyInJOhjmzPt5NDZa4LrCRT5MdFC
         D8sbEgC9VTZjBdSJ18y4YKKsCgzyORvWs8nCwAR5IVlPsr1d4QY5IFAvRvOR56xQ0CWo
         P9KvzFvrF2pNtyOC1x7l3Ly5n43WDCuYMvHOP29mec/RGC3yJURXs3fwfY2kgMUjv//F
         gmFMlfO+JMKgILclWMaXwaMG+kjDANu7b+6ej9xiz07DEMC/EuwMSOFE/T/H2b0f366x
         ZGjMhYe6Y0yLe+5ZHTM8Aqg31ZSQxwt5aoV/8JqYKyh13WJHEQ442ys1iRSgYXLOjSd6
         H8ew==
X-Forwarded-Encrypted: i=1; AJvYcCXrKxjnM0NX4yZ8YzJirkpvawKhmkVQObNG3XzcWFLJTH2DBtFxJKbyBrvDqOViyrvSpjqn123IpNAX@vger.kernel.org
X-Gm-Message-State: AOJu0YyQPLdVnK9yqVtzP2N4+xQxmnfItRPp349oxeAzORME5JhZpy2d
	11VCEEpefPe6EV4AYPR3zHUQppaadsM1JwIUO/q2LPfzVBaykmG0xMOQNiHATI2hq50=
X-Gm-Gg: AZuq6aKg/7SfB+u96NhAI3RXpDfPPogj9nHtllTc4dXFrWzwP/4G/Q+GaMA2KPjH1uX
	yiU82v50mQkCkpz4DoNFHLs9hZs+6H26zjOSMTFY+P/frH9YbLLBiytCK13WVX6Figd2zHjo3d+
	AVqd1vpW3vgaqqEeIhXSBV7h5eDkfP/CsTzgDgPgX83v+8Aix+NFjYQhVzrkzQWu/lKiwPvueKk
	EjPlBuC3BmLayilYmEj/gKmMfNowdBBV9IOsRWIy7GS3Z2X83XD421rotSdwSnx2zNUh8N+/kgK
	J19wuW51Leibn0hWy8n1w+sBbHzgmOgtUreHve3oGM2EcCvUsarZYi6Oh+z0oCSjclsx5JPuS1Y
	dfWNL/7RjWlJAfa2dRud41HTgLqDWzI3Ml2XPnOsM0HbSfWAM982UMh8Xp2R05MOc5kxFko/2QV
	9uQJWqhajifHpraT0UoICraYocNoF31PPIeb9nvDS7l00ltNUj/GQCRZFMr5aj5CyQUDYYd/2A6
	xp7jXeTDkakljHqF/OVQPia9byhc2YBAxz6NDLQ4z5EptSZ+UKpHwexDFwArg==
X-Received: by 2002:a17:907:9703:b0:b73:1634:6d71 with SMTP id a640c23a62f3a-b8facd0bbd9mr8733366b.26.1770924724562;
        Thu, 12 Feb 2026 11:32:04 -0800 (PST)
Received: from ?IPV6:2003:fa:af22:2200:e0d6:dee7:4f29:a60a? (p200300faaf222200e0d6dee74f29a60a.dip0.t-ipconnect.de. [2003:fa:af22:2200:e0d6:dee7:4f29:a60a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fa374f079sm37274566b.22.2026.02.12.11.32.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 11:32:04 -0800 (PST)
Message-ID: <42c6547f-2cf4-4585-bb59-7fda966ecb02@grsecurity.net>
Date: Thu, 12 Feb 2026 20:32:03 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: lpfc: Properly set WC for DPP mapping
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com, justin.tee@broadcom.com
References: <20260212192327.141104-1-justintee8345@gmail.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20260212192327.141104-1-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12.02.26 20:23, Justin Tee wrote:
> From: Mathias Krause <minipli@grsecurity.net>
> 
> Using set_memory_wc() to enable write-combining for the DPP portion of
> the MMIO mapping is wrong as set_memory_*() is meant to operate on RAM
> only, not MMIO mappings. In fact, as used currently triggers a BUG_ON()
> with enabled CONFIG_DEBUG_VIRTUAL.
> 
> Simply map the DPP region separately and in addition to the already
> existing mappings, avoiding any possible negative side effects for
> these.
> 
> Fixes: 1351e69fc6db ("scsi: lpfc: Add push-to-adapter support to sli4")
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> Signed-off-by: Justin Tee <justintee8345@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c |  2 ++
>  drivers/scsi/lpfc/lpfc_sli.c  | 36 +++++++++++++++++++++++++++++------
>  drivers/scsi/lpfc/lpfc_sli4.h |  3 +++
>  3 files changed, 35 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index a116a16c4a6f..b5e53c7d33e7 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -12039,6 +12039,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
>  		iounmap(phba->sli4_hba.conf_regs_memmap_p);
>  		if (phba->sli4_hba.dpp_regs_memmap_p)
>  			iounmap(phba->sli4_hba.dpp_regs_memmap_p);
> +		if (phba->sli4_hba.dpp_regs_memmap_wc_p)
> +			iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
>  		break;
>  	case LPFC_SLI_INTF_IF_TYPE_1:
>  		break;
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 734af3d039f8..690763e0aa55 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -15981,6 +15981,32 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba *phba, uint16_t pci_barset)
>  	return NULL;
>  }
>  
> +static __maybe_unused void __iomem *
> +lpfc_dpp_wc_map(struct lpfc_hba *phba, uint8_t dpp_barset)
> +{
> +
> +	/* DPP region is supposed to cover 64-bit BAR2 */
> +	if (dpp_barset != WQ_PCI_BAR_4_AND_5) {
> +		lpfc_log_msg(phba, KERN_WARNING, LOG_INIT,
> +			     "3273 dpp_barset x%x != WQ_PCI_BAR_4_AND_5\n",
> +			     dpp_barset);
> +		return NULL;
> +	}
> +
> +	if (!phba->sli4_hba.dpp_regs_memmap_wc_p) {
> +		void __iomem *dpp_map;
> +
> +		dpp_map = ioremap_wc(phba->pci_bar2_map,
> +				     pci_resource_len(phba->pcidev,
> +						      PCI_64BIT_BAR4));
> +
> +		if (dpp_map)
> +			phba->sli4_hba.dpp_regs_memmap_wc_p = dpp_map;
> +	}
> +
> +	return phba->sli4_hba.dpp_regs_memmap_wc_p;
> +}
> +
>  /**
>   * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on EQs
>   * @phba: HBA structure that EQs are on.
> @@ -16944,9 +16970,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
>  	uint8_t dpp_barset;
>  	uint32_t dpp_offset;
>  	uint8_t wq_create_version;
> -#ifdef CONFIG_X86
> -	unsigned long pg_addr;
> -#endif
>  
>  	/* sanity check on queue memory */
>  	if (!wq || !cq)
> @@ -17132,14 +17155,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
>  
>  #ifdef CONFIG_X86
>  			/* Enable combined writes for DPP aperture */
> -			pg_addr = (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
> -			rc = set_memory_wc(pg_addr, 1);
> -			if (rc) {
> +			bar_memmap_p = lpfc_dpp_wc_map(phba, dpp_barset);
> +			if (!bar_memmap_p) {
>  				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>  					"3272 Cannot setup Combined "
>  					"Write on WQ[%d] - disable DPP\n",
>  					wq->queue_id);
>  				phba->cfg_enable_dpp = 0;
> +			} else {
> +				wq->dpp_regaddr = bar_memmap_p + dpp_offset;
>  			}
>  #else
>  			phba->cfg_enable_dpp = 0;
> diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
> index ee58383492b2..b6d90604bb61 100644
> --- a/drivers/scsi/lpfc/lpfc_sli4.h
> +++ b/drivers/scsi/lpfc/lpfc_sli4.h
> @@ -785,6 +785,9 @@ struct lpfc_sli4_hba {
>  	void __iomem *dpp_regs_memmap_p;  /* Kernel memory mapped address for
>  					   * dpp registers
>  					   */
> +	void __iomem *dpp_regs_memmap_wc_p;/* Kernel memory mapped address for
> +					    * dpp registers with write combining
> +					    */
>  	union {
>  		struct {
>  			/* IF Type 0, BAR 0 PCI cfg space reg mem map */

Looks good to me, therefore:

Reviewed-by: Mathias Krause <minipli@grsecurity.net>

Thanks,
Mathias
