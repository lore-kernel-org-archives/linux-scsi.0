From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 10/11] drivers/scsi/: Use the DMA_{64,32}BIT_MASK constants
Date: Mon, 7 Mar 2005 14:36:16 +0000
Message-ID: <20050307143616.GD28741@parcelfarce.linux.theplanet.co.uk>
References: <20050306222721.1E3391F208@trashy.coderock.org> <yq0ekerepaf.fsf@jaguar.mkp.net> <20050307123739.GC28741@parcelfarce.linux.theplanet.co.uk> <yq04qfnedkq.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:1498 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261187AbVCGOgh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 09:36:37 -0500
Content-Disposition: inline
In-Reply-To: <yq04qfnedkq.fsf@jaguar.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: Matthew Wilcox <matthew@wil.cx>, domen@coderock.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, tklauser@nuerscht.ch

On Mon, Mar 07, 2005 at 09:27:17AM -0500, Jes Sorensen wrote:
> Matthew> We've had drivers with typos.  Missing one f suddenly causes
> Matthew> all your memory to come from ZONE_DMA.  Having an extra f
> Matthew> causes your driver to work ... most of the time on machines
> Matthew> with >4GB ram.  Sure, your driver doesn't, but when looking
> Matthew> over a lot of drivers, it's easier if everyone's using the
> Matthew> same macros.
> 
> If these were the only two masks ever used I'd agree with you. However
> there's several other in use and more will probably be added, so we're
> going to end up with drivers sometimes using constants and other times
> hex values causing an even bigger mess ;-(

No, that's a *good thing*.  It let's you know the driver's doing something
non-standard.  Here's what sym2 looks like these days:

#if SYM_CONF_DMA_ADDRESSING_MODE > 0
#if   SYM_CONF_DMA_ADDRESSING_MODE == 1
#define DMA_DAC_MASK    0x000000ffffffffffULL /* 40-bit */
#elif SYM_CONF_DMA_ADDRESSING_MODE == 2
#define DMA_DAC_MASK    DMA_64BIT_MASK
#endif
        if ((np->features & FE_DAC) &&
                        !pci_set_dma_mask(np->s.device, DMA_DAC_MASK)) {
                np->use_dac = 1;
                return 0;
        }
#endif

        if (!pci_set_dma_mask(np->s.device, DMA_32BIT_MASK))
                return 0;

        printf_warning("%s: No suitable DMA available\n", sym_name(np));
        return -1;

I suspect that should be a dev_err rather than a printf_warning, but
my point stands; this is a *much* easier way of doing things.  You can
see exactly where we're doing standard things and where we're doing
weird things.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
