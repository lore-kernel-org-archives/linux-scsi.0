From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] iommu: parse pci device scope even only intr remap is defined
Date: Sat, 23 Jul 2011 12:12:00 -0700
Message-ID: <CAE9FiQU629jW2n8HTiA7ZZotfsUoXAkCvZ5XDOPeERubYemdzg@mail.gmail.com>
References: <CAE9FiQV0pnJW2BYdNSH3J-ZJ1JBtQ8qKf8HAfk1A98U3onn92A@mail.gmail.com>
	<20110721085636.GJ9216@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20110721085636.GJ9216@elte.hu>
Sender: linux-pci-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>, Joerg Roedel <joerg.roedel@amd.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux scsi dev <linux-scsi@vger.kernel.org>, linux pci <linux-pci@vger.kernel.org>, "hpa@linux.intel.com" <hpa@linux.intel.com>, Avik Shau <avik.shau@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 21, 2011 at 1:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>

>>
>> +#ifndef CONFIG_DMAR
>> +/* When intr remapping is used but dmar remapping is not defined */
>> +int __init intel_iommu_init(void)
>> +{
>> + =A0 =A0 if (dmar_table_init())
>> + =A0 =A0 =A0 =A0 =A0 =A0 return =A0-ENODEV;
>> +
>> + =A0 =A0 return dmar_dev_scope_init();
>> +}
>> +#endif
>
> So INTR_REMAP functionality really depends on dmar_table_init()?

it will need DMAR table and need to parse ioapic and pci device scope i=
n them

and dev scope is needed to done later because it will put pci dev
pointer into drhd dev list.

>
> This looks very messy.
>
> CONFIG_DMAR has no clear meaning. The DMAR table parsing
> functionality is intermixed with the DMAR feature itself. The kernel
> code is littered with a couple of dozen CONFIG_DMAR #ifdefs with no
> clear structure to the initialization and to the separation of
> functionality.

CONFIG_DMAR is actually DMA_REMAP instead DMAR table.

or Do you prefer to clean them up further with following depency?

CONFIG_DMAR_TBL for DMAR table
CONFIG_DMA_REMAP for DMA remapping
CONFIG_INTR_REMAP for Interrupt remapping
and XXX_REMAP will select DMAR_TBL

Thanks

Yinghai
