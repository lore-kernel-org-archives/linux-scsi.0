From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx strange code
Date: Wed, 31 Dec 2003 11:36:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <960352704.1072895786@aslan.btc.adaptec.com>
References: <1072885576.10877.6.camel@laptop.fenrus.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:2245 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S265221AbTLaSar
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 13:30:47 -0500
In-Reply-To: <1072885576.10877.6.camel@laptop.fenrus.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com, linux-scsi@vger.kernel.org

> Hi,
> 
> 
> the snippet below (from aic7xxx driver) is rather strange and probably
> broken:
> 
>         /*
>          * Although we can dma data above 4GB, our
>          * "consistent" memory is below 4GB for
>          * space efficiency reasons (only need a 4byte
>          * address).  For this reason, we have to reset
>          * our dma mask when doing allocations.
>          */

...

> consistent memory ALWAYS comes from lower 4Gb regardless of the
> pci_set_dma_mask() setting;

This isn't true on some architectures in the 2.4 kernel.  Look at, for
example, arch/ia64/hp/common/sba_iommu.c in the RedHat 2.4.18-e.31 kernel.
This is why this particular hack was added.

> Justin: are you willing to just remove the unneeded dma mask sets? They
> can race etc etc and are 100% unneeded.

The hack is not racy for any mapping calls within the driver since they
are protected by the softc lock.  For any other clients that are
looking at the mask, the worse case is that they end up mapping some
transaction below the 4GB boundary that could have been sent unmapped.

I'm more than happy to change the #ifdefs on the hack to exclude 2.6
so long as all platforms the driver operates under behave as expected.
If 2.4 is any guide, however, there may still be some bogus code lurking
around that uses the "normal" dma mask incorrectly.

--
Justin

