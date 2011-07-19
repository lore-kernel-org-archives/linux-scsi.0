From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: CONFIG_INTR_REMAP and CONFIG_DMAR dependencies?
Date: Mon, 18 Jul 2011 21:50:33 -0700
Message-ID: <1311051033.13685.5.camel@sbsiddha-mobl2>
References: <20110718211620.GD4770@plapp.qlogic.org>
	 <CAE9FiQUgbvC6TiSXK-5K9bOsxYeCePoRoU-NBvtitweVBegyEA@mail.gmail.com>
	 <CAE9FiQVUA2bWycDNmKDysPV6SQ1tcniJHUvbSDXpufC75cFVjg@mail.gmail.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13382 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1GSEwi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2011 00:52:38 -0400
In-Reply-To: <CAE9FiQVUA2bWycDNmKDysPV6SQ1tcniJHUvbSDXpufC75cFVjg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux scsi dev <linux-scsi@vger.kernel.org>, linux pci <linux-pci@vger.kernel.org>, "hpa@linux.intel.com" <hpa@linux.intel.com>, Avik Shau <avik.shau@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Mon, 2011-07-18 at 16:16 -0700, Yinghai Lu wrote:
> ---
>  drivers/iommu/dmar.c |   11 +++++++++++
>  include/linux/dmar.h |    4 +---
>  2 files changed, 12 insertions(+), 3 deletions(-)

Yinghai, Thanks for looking at this.

This issue is caused by this commit:

commit 9d5ce73a64be2be8112147a3e0b551ad9cd1247b
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Tue Nov 10 19:46:16 2009 +0900

    x86: intel-iommu: Convert detect_intel_iommu to use iommu_init hook

So this is a regression. Also,

> 
> Index: linux-2.6/include/linux/dmar.h
> ===================================================================
> --- linux-2.6.orig/include/linux/dmar.h
> +++ linux-2.6/include/linux/dmar.h
> @@ -232,9 +232,7 @@ struct dmar_atsr_unit {
>  #define for_each_atsr_unit(atsr) \
>         list_for_each_entry(atsr, &dmar_atsr_units, list)
>  
> -extern int intel_iommu_init(void);
> -#else /* !CONFIG_DMAR: */
> -static inline int intel_iommu_init(void) { return -ENODEV; }
>  #endif /* CONFIG_DMAR */
> +extern int intel_iommu_init(void);
>  
>  #endif /* __DMAR_H__ */
> Index: linux-2.6/drivers/iommu/dmar.c
> ===================================================================
> --- linux-2.6.orig/drivers/iommu/dmar.c
> +++ linux-2.6/drivers/iommu/dmar.c
> @@ -722,6 +722,17 @@ int __init detect_intel_iommu(void)
>         return ret ? 1 : -ENODEV;
>  }
>  
> +#ifndef CONFIG_DMAR
> +int __init intel_iommu_init(void)
> +{
> +        if (dmar_table_init()) {
> +                return  -ENODEV;
> +        }
> +
> +        dmar_dev_scope_init();
> +        return  -ENODEV;

I think this should be return dmar_dev_scope_init();

thanks!

> +}
> +#endif
>  
>  int alloc_iommu(struct dmar_drhd_unit *drhd)
>  { 



