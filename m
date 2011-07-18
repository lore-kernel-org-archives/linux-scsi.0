From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: CONFIG_INTR_REMAP and CONFIG_DMAR dependencies?
Date: Mon, 18 Jul 2011 16:50:30 -0700
Message-ID: <20110718235030.GD11738@plapp.qlogic.org>
References: <20110718211620.GD4770@plapp.qlogic.org>
 <CAE9FiQUgbvC6TiSXK-5K9bOsxYeCePoRoU-NBvtitweVBegyEA@mail.gmail.com>
 <CAE9FiQVUA2bWycDNmKDysPV6SQ1tcniJHUvbSDXpufC75cFVjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQVUA2bWycDNmKDysPV6SQ1tcniJHUvbSDXpufC75cFVjg@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux scsi dev <linux-scsi@vger.kernel.org>, linux pci <linux-pci@vger.kernel.org>, "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>, "hpa@linux.intel.com" <hpa@linux.intel.com>, Avik Shau <avik.shau@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 18 Jul 2011, Yinghai Lu wrote:

> On Mon, Jul 18, 2011 at 2:32 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Mon, Jul 18, 2011 at 2:16 PM, Andrew Vasquez
> > <andrew.vasquez@qlogic.com> wrote:
> >> Suresh,
> >>
> >> Any thoughts/ideas on this? ?Could you help with the INTR-REMAP
> >> messages?
> >>
> >> Thanks,
> >> Andrew Vasquez
> >>
> >> ----
> >>
> >> All,
> >>
> >> We've seen a few reports logged with upstream kernels where qla2xxx is
> >> unable to initialize HW due to what appears to be a lack of
> >> interrupt routing:
> >>
> >> ? ? ? ?[ 1137.271156] qla2xxx 0000:18:00.0: Found an ISP2532, irq 52, iobase 0xffffc90000028000
> >> ? ? ? ?[ 1137.271438] qla2xxx 0000:18:00.0: irq 96 for MSI/MSI-X
> >> ? ? ? ?[ 1137.271447] qla2xxx 0000:18:00.0: irq 97 for MSI/MSI-X
> >> ? ? ? ?[ 1137.271706] qla2xxx 0000:18:00.0: Configuring PCI space...
> >> ? ? ? ?[ 1137.271725] qla2xxx 0000:18:00.0: setting latency timer to 64
> >> ? ? ? ?[ 1137.271732] qla2xxx 0000:18:00.0: enabling Mem-Wr-Inval
> >> ? ? ? ?[ 1137.278705] DRHD: handling fault status reg 2
> >> ? ? ? ?[ 1137.278715] INTR-REMAP: Request device [[18:00.0] fault index 20
> >> ? ? ? ?[ 1137.278717] INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear
> >> ? ? ? ?[ 1159.389099] qla2xxx 0000:0c:07.0: Cable is unplugged...
> >> ? ? ? ?[ 1167.218478] qla2xxx 0000:18:00.0: Mailbox command timeout occurred. Scheduling ISP abort. eeh_busy: 0x0
> >> ? ? ? ?[ 1167.218490] qla2xxx 0000:18:00.0: Unable to burst-read optrom segment (100/7ff50400/18389b000).
> >> ? ? ? ?[ 1167.218496] qla2xxx 0000:18:00.0: Reverting to slow-read.
> >> ? ? ? ?[ 1197.174623] qla2xxx 0000:18:00.0: Unable to burst-read optrom segment (100/7ff50000/18389b000).
> >> ? ? ? ?[ 1197.174632] qla2xxx 0000:18:00.0: Reverting to slow-read.
> >> ? ? ? ?[ 1197.190613] qla2xxx 0000:18:00.0: Configure NVRAM parameters...
> >> ? ? ? ?[ 1197.198582] qla2xxx 0000:18:00.0: Verifying loaded RISC code...
> >> ? ? ? ?[ 1227.142951] qla2xxx 0000:18:00.0: Failed mailbox send register test
> >> ? ? ? ?[ 1227.142959] qla2xxx 0000:18:00.0: Failed to initialize adapter
> 
> please check attached patch, it should fix that configuration.
> 
> Thanks

Yinghai,

Yes, this patch seems to help. With CONFIG_INTR_REMAP=y,
CONFIG_DMAR=n, and this patch, I no longer see the
'DRHD...INTR-REMAP...' warnings, and hardware interrupts appear to be
routing normally.

One small fixup I had to do was change the path for dmar.c in your
patch file.  On upstream kernels dmar.c is in drivers/pci/, not
drivers/iommu/.

Let me know if there's something else you need from our side.  Hope
this patch makes 3.0.

Thanks, AV

> ---
>  drivers/iommu/dmar.c |   11 +++++++++++
>  include/linux/dmar.h |    4 +---
>  2 files changed, 12 insertions(+), 3 deletions(-)
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
> @@ -722,6 +722,17 @@ int __init detect_intel_iommu(void)
>  	return ret ? 1 : -ENODEV;
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
> +}
> +#endif
>  
>  int alloc_iommu(struct dmar_drhd_unit *drhd)
>  {
