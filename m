From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] iommu: parse pci device scope even only intr remap is
 defined
Date: Mon, 25 Jul 2011 09:19:41 +0200
Message-ID: <20110725071941.GA22518@elte.hu>
References: <CAE9FiQV0pnJW2BYdNSH3J-ZJ1JBtQ8qKf8HAfk1A98U3onn92A@mail.gmail.com>
 <20110721085636.GJ9216@elte.hu>
 <CAE9FiQU629jW2n8HTiA7ZZotfsUoXAkCvZ5XDOPeERubYemdzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE9FiQU629jW2n8HTiA7ZZotfsUoXAkCvZ5XDOPeERubYemdzg@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>, Joerg Roedel <joerg.roedel@amd.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux scsi dev <linux-scsi@vger.kernel.org>, linux pci <linux-pci@vger.kernel.org>, "hpa@linux.intel.com" <hpa@linux.intel.com>, Avik Shau <avik.shau@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>
List-Id: linux-scsi@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> > This looks very messy.
> >
> > CONFIG_DMAR has no clear meaning. The DMAR table parsing 
> > functionality is intermixed with the DMAR feature itself. The 
> > kernel code is littered with a couple of dozen CONFIG_DMAR 
> > #ifdefs with no clear structure to the initialization and to the 
> > separation of functionality.
> 
> CONFIG_DMAR is actually DMA_REMAP instead DMAR table.
> 
> or Do you prefer to clean them up further with following depency?
> 
> CONFIG_DMAR_TBL for DMAR table
> CONFIG_DMA_REMAP for DMA remapping
> CONFIG_INTR_REMAP for Interrupt remapping
> and XXX_REMAP will select DMAR_TBL

'DMAR', 'TBL' and 'INTR' are all misnomers!

	CONFIG_DMA_REMAP_TABLE
	CONFIG_DMA_REMAP
	CONFIG_IRQ_REMAP

That way we'd get the 'DMAR tables' via CONFIG_DMA_REMAP_TABLE - on 
top of which enabling CONFIG_DMA_REMAP and CONFIG_IRQ_REMAP would 
enable and handle various hw remapping features.

(Does anyone else have better/other code structure suggestions?)

But yes, we should first do this rename/cleanup to clarify what it 
all means, then fix whatever config-combos don't work perfectly yet.

Thanks,

	Ingo
