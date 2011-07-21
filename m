From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] iommu: parse pci device scope even only intr remap is
 defined
Date: Thu, 21 Jul 2011 10:56:36 +0200
Message-ID: <20110721085636.GJ9216@elte.hu>
References: <CAE9FiQV0pnJW2BYdNSH3J-ZJ1JBtQ8qKf8HAfk1A98U3onn92A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQV0pnJW2BYdNSH3J-ZJ1JBtQ8qKf8HAfk1A98U3onn92A@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>, Joerg Roedel <joerg.roedel@amd.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux scsi dev <linux-scsi@vger.kernel.org>, linux pci <linux-pci@vger.kernel.org>, "hpa@linux.intel.com" <hpa@linux.intel.com>, Avik Shau <avik.shau@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> [PATCH] iommu: parse pci device scope even only intr remap is defined.
> 
> Andrew found when CONFIG_DMAR=N and CONFIG_INTR_REMAP=Y:
> >        [ 1137.271447] qla2xxx 0000:18:00.0: irq 97 for MSI/MSI-X
> >        [ 1137.271706] qla2xxx 0000:18:00.0: Configuring PCI space...
> >        [ 1137.271725] qla2xxx 0000:18:00.0: setting latency timer to 64
> >        [ 1137.271732] qla2xxx 0000:18:00.0: enabling Mem-Wr-Inval
> >        [ 1137.278705] DRHD: handling fault status reg 2
> >        [ 1137.278715] INTR-REMAP: Request device [[18:00.0] fault index 20
> >        [ 1137.278717] INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear
> >        [ 1159.389099] qla2xxx 0000:0c:07.0: Cable is unplugged...
> >        [ 1167.218478] qla2xxx 0000:18:00.0: Mailbox command timeout occurred. Scheduling ISP abort. eeh_busy: 0x0
> >        [ 1167.218490] qla2xxx 0000:18:00.0: Unable to burst-read optrom segment (100/7ff50400/18389b000).
> >        [ 1167.218496] qla2xxx 0000:18:00.0: Reverting to slow-read.
> >        [ 1197.174623] qla2xxx 0000:18:00.0: Unable to burst-read optrom segment (100/7ff50000/18389b000).
> >        [ 1197.174632] qla2xxx 0000:18:00.0: Reverting to slow-read.
> >        [ 1197.190613] qla2xxx 0000:18:00.0: Configure NVRAM parameters...
> >        [ 1197.198582] qla2xxx 0000:18:00.0: Verifying loaded RISC code...
> >        [ 1227.142951] qla2xxx 0000:18:00.0: Failed mailbox send register test
> >        [ 1227.142959] qla2xxx 0000:18:00.0: Failed to initialize adapter
> 
> It turns out that path, pci devices will not be link to drhd, so later all pci
> devices will point to default drhd when using intr-remap.
> 
> Suresh pointed out:
> | This issue is caused by this commit:
> |
> | commit 9d5ce73a64be2be8112147a3e0b551ad9cd1247b
> | Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> | Date:   Tue Nov 10 19:46:16 2009 +0900
> |
> |   x86: intel-iommu: Convert detect_intel_iommu to use iommu_init hook
> |
> | So this is a regression
> 
> Try to fix the path with calling dmar_dev_scope_init() in intel_iommu_init()
> 
> Reported-and-tested-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/iommu/dmar.c |   10 ++++++++++
>  include/linux/dmar.h |    4 +---
>  2 files changed, 11 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/include/linux/dmar.h
> ===================================================================
> --- linux-2.6.orig/include/linux/dmar.h
> +++ linux-2.6/include/linux/dmar.h
> @@ -232,9 +232,7 @@ struct dmar_atsr_unit {
>  #define for_each_atsr_unit(atsr) \
>  	list_for_each_entry(atsr, &dmar_atsr_units, list)
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
> @@ -722,6 +722,16 @@ int __init detect_intel_iommu(void)
>  	return ret ? 1 : -ENODEV;
>  }
>  
> +#ifndef CONFIG_DMAR
> +/* When intr remapping is used but dmar remapping is not defined */
> +int __init intel_iommu_init(void)
> +{
> +	if (dmar_table_init())
> +		return  -ENODEV;
> +
> +	return dmar_dev_scope_init();
> +}
> +#endif

So INTR_REMAP functionality really depends on dmar_table_init()?

This looks very messy.

CONFIG_DMAR has no clear meaning. The DMAR table parsing 
functionality is intermixed with the DMAR feature itself. The kernel 
code is littered with a couple of dozen CONFIG_DMAR #ifdefs with no 
clear structure to the initialization and to the separation of 
functionality.

Thanks,

	Ingo
