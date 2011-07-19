From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: CONFIG_INTR_REMAP and CONFIG_DMAR dependencies?
Date: Mon, 18 Jul 2011 20:18:34 -0700
Message-ID: <CAE9FiQUAJkiK-QYgaWy_NYeW81c0dA1_q3mw5mVX_AETNeKWww@mail.gmail.com>
References: <20110718211620.GD4770@plapp.qlogic.org>
	<CAE9FiQUgbvC6TiSXK-5K9bOsxYeCePoRoU-NBvtitweVBegyEA@mail.gmail.com>
	<CAE9FiQVUA2bWycDNmKDysPV6SQ1tcniJHUvbSDXpufC75cFVjg@mail.gmail.com>
	<20110718235030.GD11738@plapp.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45743 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1GSDSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2011 23:18:35 -0400
In-Reply-To: <20110718235030.GD11738@plapp.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, Ingo Molnar <mingo@elte.hu>, "Barnes, Jesse" <jesse.barnes@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux scsi dev <linux-scsi@vger.kernel.org>, linux pci <linux-pci@vger.kernel.org>, "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>, "hpa@linux.intel.com" <hpa@linux.intel.com>, Avik Shau <avik.shau@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>

On Mon, Jul 18, 2011 at 4:50 PM, Andrew Vasquez
<andrew.vasquez@qlogic.com> wrote:
> On Mon, 18 Jul 2011, Yinghai Lu wrote:
>
>> On Mon, Jul 18, 2011 at 2:32 PM, Yinghai Lu <yinghai@kernel.org> wro=
te:
>> > On Mon, Jul 18, 2011 at 2:16 PM, Andrew Vasquez
>> > <andrew.vasquez@qlogic.com> wrote:
>> >> Suresh,
>> >>
>> >> Any thoughts/ideas on this? ?Could you help with the INTR-REMAP
>> >> messages?
>> >>
>> >> Thanks,
>> >> Andrew Vasquez
>> >>
>> >> ----
>> >>
>> >> All,
>> >>
>> >> We've seen a few reports logged with upstream kernels where qla2x=
xx is
>> >> unable to initialize HW due to what appears to be a lack of
>> >> interrupt routing:
>> >>
>> >> ? ? ? ?[ 1137.271156] qla2xxx 0000:18:00.0: Found an ISP2532, irq=
 52, iobase 0xffffc90000028000
>> >> ? ? ? ?[ 1137.271438] qla2xxx 0000:18:00.0: irq 96 for MSI/MSI-X
>> >> ? ? ? ?[ 1137.271447] qla2xxx 0000:18:00.0: irq 97 for MSI/MSI-X
>> >> ? ? ? ?[ 1137.271706] qla2xxx 0000:18:00.0: Configuring PCI space=
=2E..
>> >> ? ? ? ?[ 1137.271725] qla2xxx 0000:18:00.0: setting latency timer=
 to 64
>> >> ? ? ? ?[ 1137.271732] qla2xxx 0000:18:00.0: enabling Mem-Wr-Inval
>> >> ? ? ? ?[ 1137.278705] DRHD: handling fault status reg 2
>> >> ? ? ? ?[ 1137.278715] INTR-REMAP: Request device [[18:00.0] fault=
 index 20
>> >> ? ? ? ?[ 1137.278717] INTR-REMAP:[fault reason 34] Present field =
in the IRTE entry is clear
>> >> ? ? ? ?[ 1159.389099] qla2xxx 0000:0c:07.0: Cable is unplugged...
>> >> ? ? ? ?[ 1167.218478] qla2xxx 0000:18:00.0: Mailbox command timeo=
ut occurred. Scheduling ISP abort. eeh_busy: 0x0
>> >> ? ? ? ?[ 1167.218490] qla2xxx 0000:18:00.0: Unable to burst-read =
optrom segment (100/7ff50400/18389b000).
>> >> ? ? ? ?[ 1167.218496] qla2xxx 0000:18:00.0: Reverting to slow-rea=
d.
>> >> ? ? ? ?[ 1197.174623] qla2xxx 0000:18:00.0: Unable to burst-read =
optrom segment (100/7ff50000/18389b000).
>> >> ? ? ? ?[ 1197.174632] qla2xxx 0000:18:00.0: Reverting to slow-rea=
d.
>> >> ? ? ? ?[ 1197.190613] qla2xxx 0000:18:00.0: Configure NVRAM param=
eters...
>> >> ? ? ? ?[ 1197.198582] qla2xxx 0000:18:00.0: Verifying loaded RISC=
 code...
>> >> ? ? ? ?[ 1227.142951] qla2xxx 0000:18:00.0: Failed mailbox send r=
egister test
>> >> ? ? ? ?[ 1227.142959] qla2xxx 0000:18:00.0: Failed to initialize =
adapter
>>
>> please check attached patch, it should fix that configuration.
>>
>> Thanks
>
> Yinghai,
>
> Yes, this patch seems to help. With CONFIG_INTR_REMAP=3Dy,
> CONFIG_DMAR=3Dn, and this patch, I no longer see the
> 'DRHD...INTR-REMAP...' warnings, and hardware interrupts appear to be
> routing normally.
>
> One small fixup I had to do was change the path for dmar.c in your
> patch file. =A0On upstream kernels dmar.c is in drivers/pci/, not
> drivers/iommu/.

in -tip, those iommu code already get moved to drivers/iommu/

>
> Let me know if there's something else you need from our side. =A0Hope
> this patch makes 3.0.

Not sure. should be for 3.1 instead.

Thanks

>
> Thanks, AV
>
>> ---
>> =A0drivers/iommu/dmar.c | =A0 11 +++++++++++
>> =A0include/linux/dmar.h | =A0 =A04 +---
>> =A02 files changed, 12 insertions(+), 3 deletions(-)
>>
>> Index: linux-2.6/include/linux/dmar.h
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-2.6.orig/include/linux/dmar.h
>> +++ linux-2.6/include/linux/dmar.h
>> @@ -232,9 +232,7 @@ struct dmar_atsr_unit {
>> =A0#define for_each_atsr_unit(atsr) \
>> =A0 =A0 =A0 list_for_each_entry(atsr, &dmar_atsr_units, list)
>>
>> -extern int intel_iommu_init(void);
>> -#else /* !CONFIG_DMAR: */
>> -static inline int intel_iommu_init(void) { return -ENODEV; }
>> =A0#endif /* CONFIG_DMAR */
>> +extern int intel_iommu_init(void);
>>
>> =A0#endif /* __DMAR_H__ */
>> Index: linux-2.6/drivers/iommu/dmar.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-2.6.orig/drivers/iommu/dmar.c
>> +++ linux-2.6/drivers/iommu/dmar.c
>> @@ -722,6 +722,17 @@ int __init detect_intel_iommu(void)
>> =A0 =A0 =A0 return ret ? 1 : -ENODEV;
>> =A0}
>>
>> +#ifndef CONFIG_DMAR
>> +int __init intel_iommu_init(void)
>> +{
>> + =A0 =A0 =A0 =A0if (dmar_table_init()) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return =A0-ENODEV;
>> + =A0 =A0 =A0 =A0}
>> +
>> + =A0 =A0 =A0 =A0dmar_dev_scope_init();
>> + =A0 =A0 =A0 =A0return =A0-ENODEV;
>> +}
>> +#endif
>>
>> =A0int alloc_iommu(struct dmar_drhd_unit *drhd)
>> =A0{
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
