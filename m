Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFB2153598
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 14:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770820459; cv=none; b=PSxtD0+mfJI01RsQzqh+bAUgmXWFj3YFJkArY1knIVNtdkFl9wB62bxF4xEhmGqRaq3I8luibXw8A7mtzI9d8jau3F41Epo5/0Nd6EVYq1qb+KR/5wrqWgThKLkAgHAHJu/DqAZfXaCkx2RH1bIrz/IPAqqooKMtIYaHAeeVpRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770820459; c=relaxed/simple;
	bh=4C6y6kEEkJcBGMXN9ItqYeem+UPO961GNzIxDCW4P5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hwAaXGO4Oz9fi+/KTHUPaS4xvIlPszZWfX0FgCWCIBaIbGAdl5y4pJPXSlbq7V+We/RLMlxfgAojpOJsVvBwR/osUXNA/jEbBQp4LYdqPb0jUVORa6nnwup1oNWZMGcAOmxdPT/wMtCllrQE0tjXM/uxAv9qJzOAdjSVzH7GIOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=ddOmkkBS; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="ddOmkkBS"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48068ed1eccso70310505e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 06:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1770820456; x=1771425256; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WVIXXmPY6V4whXaCwITzEzH8RnJSLzmycKi4L/qVHqo=;
        b=ddOmkkBS5AQ3OumFMy9agQb0SFKmYCoVcWkF8M+4SjR9W9s7tsEKIBpdx59vVErpRG
         j+iOBCo6crFZPisQZqfOWggI6g2Fc7qxBWdtcYrxanaGGEUQlhtfe8+gCYMKCv6URlas
         5u4ZdunJuXSy10af32BYddoPcr2+Ri0QC4H/fVi9AbPpFu9AcyaCtI1hMZKXZzADU50M
         Zh4UplTK5+MbdFilaphC7wElU1A4rFv/XL/s6+HLZW5Rl/MwWCcTX2wCyOQf12SmkYc6
         VYxL2sjm6qQjCbK5yOeXxFoWU2oPtnRxuGMfRK/OqEDGcR7qqaBKp/KrNob+02detSWO
         Dzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770820456; x=1771425256;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVIXXmPY6V4whXaCwITzEzH8RnJSLzmycKi4L/qVHqo=;
        b=ckOcCExMN7P5Qb/oJgZKC2lsfIE9+M76DHisbmdiUtd5N7FhPwBFbVeEl3oT4/oLCY
         sG2lfLNgIN0cfSo9xvu7520WcIMJOmvD/v5NQPSjS5N3JWHjFqKfC9kdvDfvyeHlhGDu
         a3rty11JllLIDMH3l86J87ruOA8iiQukDdXNroK2NoZZRDQafDwod+6H553azibAOjPO
         CaM/bghrNJUj3QM5sUqItlQbKj6W3RgRVEKoGdPpv5CtzK26q/WmE5GoZjr+NfGEwnTX
         bgpUOp9csBWGhnDVnBiRouPis4YfoHx4kpmKAuR6XZI3Bpz5uAEHDm0Rn1I0vOD9KSWy
         KzxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOkxHE0Giv3bOuvZCCYAQNCBwG5TZ4vQsqSHrk0sZImvQPrNyhKWG9EZOXHGEVxKP2rb4nIzzEYlkc@vger.kernel.org
X-Gm-Message-State: AOJu0YzTU8Q2nDGqMrcdr03HZesGaKuJ3eFKA+jvhcpzpYexyRdKmtdR
	h62XKES3j2XS+5WieThQcCbGYnBnXF04eMX3Jf5ZUhvCgeb2hxsBijnJbOj82Fj9Bz4=
X-Gm-Gg: AZuq6aKxC97PQ2WlKHOVNpnvj0vcGSx60GxwDNzsEX3f134eF6N8rV1qtRsk2YeG0V+
	qJ00NCdL3f2B1y9iHO8IYQakrJyZkcS6i77chl4ROfRGX2bemxyYGIaeeAJ4jcSP6XzyJteGvo1
	SySVo4NJP3htAUeqRobKTrCI8OTLzkSUIwSa57HCWIt4f7vbJXcvuyoL3xZH9usRQIqragG+KnX
	o7ZudKwtsGg3yk5avDIy6mhbmGFm2gfXOO3IIeIRUS+0ppaDbxMO4X7s/oXL6Js1E/I26FEB6hW
	bTcKTshjBzD5A2sXYjsM8WCRLenwaf+OMZQzAnmfkaDYR5tSZTl2RJ0EYD46QB1qXO0XFCZVSOp
	ju9PyyYNpSHxObMv22XGbh/fGm5nS7Kb6T6uTFga0DToIJ2uC0CfEloJbIEGZq7R/4pfu5RyUUw
	u/m1SbiX27atNI98ggKB3r45nfbtaatsXEmM5kPAQ1GBXCiTW4WEKzV7WdqKXfJgNYoUf6cLHpO
	voht4zGfHBxmpcS37hrmF7tqaFFhgkMlpTHRt/hDdYKx2jlIv7HR7A867MUuw==
X-Received: by 2002:a05:600c:8108:b0:475:da1a:5418 with SMTP id 5b1f17b1804b1-483507cffd2mr76136255e9.1.1770820455627;
        Wed, 11 Feb 2026 06:34:15 -0800 (PST)
Received: from ?IPV6:2003:fa:af22:2200:e0d6:dee7:4f29:a60a? (p200300faaf222200e0d6dee74f29a60a.dip0.t-ipconnect.de. [2003:fa:af22:2200:e0d6:dee7:4f29:a60a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d5d77b3sm147348895e9.2.2026.02.11.06.34.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Feb 2026 06:34:15 -0800 (PST)
Message-ID: <82f38f49-2f50-4c8b-9482-e446e61d5006@grsecurity.net>
Date: Wed, 11 Feb 2026 15:34:14 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: lpfc: Properly set WC for DPP mapping
To: Justin Tee <justintee8345@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
 linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
References: <20260113222716.2454544-1-minipli@grsecurity.net>
 <CABPRKS89zwXdUT1Bhj37cQDyOHNupOJ-Ez6kS7Dp_pu06X9Myw@mail.gmail.com>
 <CABPRKS-ongXPqWVpNYiKvy_afVKn999bxtSEfsBVQ7z5JVCgeQ@mail.gmail.com>
 <59933d92-eefe-49f6-ad70-79fe7aef0f3c@grsecurity.net>
 <CABPRKS8C4WmEYX+jtAOTS_jeFYt_GeTp9uBoWzCMF8cUZxxzUA@mail.gmail.com>
 <CABPRKS_cT5f21A-Jkx_uhA+SF4THpPSaqKtk8mWk9nN4Gh9LFQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <CABPRKS_cT5f21A-Jkx_uhA+SF4THpPSaqKtk8mWk9nN4Gh9LFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 09.02.26 19:47, Justin Tee wrote:
> Hi Mathias,
> 
>> Thanks, I think I’m able to reproduce the call trace of concern.  I’ll
>> have a closer look at this patch and will report back.
> 
> I have some slight changes to the original patch, which I've tested on
> real hardware.  Please see below.

Thanks for testing! ...and fixing my goof with using pci_barset instead
of dpp_barset. Dunno what I was thinking!

> Is it possible to check if this works for the customer as well?

If your tests on real hardware ran fine, it should be good for our
customer as well. It still gets rid of the problematic set_memory_wc()
call so it's fine from our point of view.

Though, some comments below...

> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index a116a16c4a6f..b5e53c7d33e7 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -12039,6 +12039,8 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
>          iounmap(phba->sli4_hba.conf_regs_memmap_p);
>          if (phba->sli4_hba.dpp_regs_memmap_p)
>              iounmap(phba->sli4_hba.dpp_regs_memmap_p);
> +        if (phba->sli4_hba.dpp_regs_memmap_wc_p)
> +            iounmap(phba->sli4_hba.dpp_regs_memmap_wc_p);
>          break;
>      case LPFC_SLI_INTF_IF_TYPE_1:
>          break;
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 734af3d039f8..a0b55bd8566e 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -15981,6 +15981,47 @@ lpfc_dual_chute_pci_bar_map(struct lpfc_hba
> *phba, uint16_t pci_barset)
>      return NULL;
>  }
> 
> +static phys_addr_t
> +lpfc_dual_chute_pci_bar_addr(struct lpfc_hba *phba, uint16_t pci_barset)
> +{
> +    if (!phba->pcidev)
> +        return PHYS_ADDR_MAX;
> +
> +    switch (pci_barset) {
> +    case WQ_PCI_BAR_0_AND_1:
> +        return phba->pci_bar0_map;
> +    case WQ_PCI_BAR_2_AND_3:
> +        return phba->pci_bar1_map;
> +    case WQ_PCI_BAR_4_AND_5:
> +        return phba->pci_bar2_map;
> +    default:
> +        break;
> +    }
> +    return PHYS_ADDR_MAX;
> +}
> +
> +static __maybe_unused void __iomem *
> +lpfc_dpp_wc_map(struct lpfc_hba *phba, uint16_t dpp_barset)
> +{
> +    if (!phba->sli4_hba.dpp_regs_memmap_wc_p) {
> +        void __iomem *dpp_map;
> +        phys_addr_t dpp_addr;
> +
> +        dpp_addr = lpfc_dual_chute_pci_bar_addr(phba, dpp_barset);
> +        if (dpp_addr == PHYS_ADDR_MAX)
> +            return NULL;
> +

> +        dpp_map = ioremap_wc(dpp_addr,
> +                     pci_resource_len(phba->pcidev,
> +                              PCI_64BIT_BAR4));

You're hard-coding PCI_64BIT_BAR4 here which *feels* inappropriate if we
went all the way with wrappers like lpfc_dual_chute_pci_bar_addr() and
making sure to be using the BAR the device told us. In fact, that was
the reason, I did it like this, assuming it might be something else than
WQ_PCI_BAR_4_AND_5, e.g. a BAR shared with the doorbell registers. If
that cannot happen, what's the reason to have 'dpp_offset'?

Also, what's the reason to do the offset calculation in the caller?
ioremap_wc() can handle non-page-aligned / offset addresses just fine.
That's why my version passed dpp_offset to lpfc_dpp_wc_map() and made it
adjust the to-be-mapped address before calling ioremap_wc(); to only
remap what's needed.
Same for the size: I just capped it to what's needed by its only user in
lpfc_sli4_wq_put(). Again, ioremap_wc() will do "The Right Thing(TM)"
and map all required pages.

> +
> +        if (dpp_map)
> +            phba->sli4_hba.dpp_regs_memmap_wc_p = dpp_map;
> +    }
> +
> +    return phba->sli4_hba.dpp_regs_memmap_wc_p;
> +}
> +
>  /**
>   * lpfc_modify_hba_eq_delay - Modify Delay Multiplier on EQs
>   * @phba: HBA structure that EQs are on.
> @@ -16944,9 +16985,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct
> lpfc_queue *wq,
>      uint8_t dpp_barset;
>      uint32_t dpp_offset;
>      uint8_t wq_create_version;
> -#ifdef CONFIG_X86
> -    unsigned long pg_addr;
> -#endif
> 
>      /* sanity check on queue memory */
>      if (!wq || !cq)
> @@ -17132,14 +17170,15 @@ lpfc_wq_create(struct lpfc_hba *phba, struct
> lpfc_queue *wq,
> 
>  #ifdef CONFIG_X86
>              /* Enable combined writes for DPP aperture */
> -            pg_addr = (unsigned long)(wq->dpp_regaddr) & PAGE_MASK;
> -            rc = set_memory_wc(pg_addr, 1);
> -            if (rc) {
> +            bar_memmap_p = lpfc_dpp_wc_map(phba, dpp_barset);
> +            if (!bar_memmap_p) {
>                  lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
>                      "3272 Cannot setup Combined "
>                      "Write on WQ[%d] - disable DPP\n",
>                      wq->queue_id);
>                  phba->cfg_enable_dpp = 0;
> +            } else {
> +                wq->dpp_regaddr = bar_memmap_p + dpp_offset;
>              }
>  #else
>              phba->cfg_enable_dpp = 0;
> diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
> index ee58383492b2..b6d90604bb61 100644
> --- a/drivers/scsi/lpfc/lpfc_sli4.h
> +++ b/drivers/scsi/lpfc/lpfc_sli4.h
> @@ -785,6 +785,9 @@ struct lpfc_sli4_hba {
>      void __iomem *dpp_regs_memmap_p;  /* Kernel memory mapped address for
>                         * dpp registers
>                         */
> +    void __iomem *dpp_regs_memmap_wc_p;/* Kernel memory mapped address for
> +                        * dpp registers with write combining
> +                        */
>      union {
>          struct {
>              /* IF Type 0, BAR 0 PCI cfg space reg mem map */
> 
> 
> Regards,
> Justin

Out of curiosity, the I/O stalls are no longer happening with this version?

Thanks,
Mathias
