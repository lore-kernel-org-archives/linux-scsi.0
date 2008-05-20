From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: dma_alloc_coherent() sets __GFP_NORETRY ? [was: Re: [PATCH 1/2]
	dpt_i2o: 64 bit support (take 4)]
Date: Tue, 20 May 2008 02:24:22 +0200
Message-ID: <1211243062.16898.37.camel@localhost.localdomain>
References: <20080424213355.GA21682@xs4all.net>
	 <1209144552.3087.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2816 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbYETAY2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 20:24:28 -0400
In-Reply-To: <1209144552.3087.43.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 12:29 -0500, James Bottomley wrote:
> On Thu, 2008-04-24 at 23:33 +0200, Miquel van Smoorenburg wrote:
>
> >  
> >  	memset(msg, 0, sizeof(msg));
> > -	buf = kmalloc(80,GFP_KERNEL|ADDR32);
> > +	buf = pci_alloc_consistent(pHba->pDev, 80, &addr);
> 
> You probably want to use dma_alloc_coherent here ... it's identical to
> pci_alloc_consistent in almost every way, except that it allows you to
> pass in the GFP_KERNEL flag (pci_alloc_consistent has to assume
> GFP_ATOMIC and thus you can get unexpected failures if SLUB is having a
> bad day) and you have to call it on &pHba->pDev->dev and use the
> corresponding dma_free_coherent().

I actually did that in the next patch, but I have been looking a bit
deeper into this and it might not be such a good idea. That, or there is
a bug in pci-dma_64.c.

In arch/x86/kernel/pci-dma_64.c , dma_alloc_coherent() adds
__GFP_NORETRY to the gfp flags before it calls __get_free_pages (through
dma_alloc_pages).

That means dma_alloc_coherent() -> __get_free_pages() can fail quite
easily on x86_64 with GFP_KERNEL.

If in __get_free_pages() try_to_free_pages() fails once, and
__GFP_NORETRY is set, there is .. well .. no retry :)

But why does dma_alloc_coherent() on x86_64 set __GFP_NORETRY ? It says
"don't invoke OOM killer" but I think it has more side affects than
that: easier failure.

Now I think I know why the 3ware management utility tw_cli crashes a lot
on my 64-bit boxes with a large diskwrite load ... I've fixed that now
by commenting out  gfp |= __GFP_NORETRY .

Note that pci-dma_32.c in 2.6.25 does not do this, but in 2.6.26-rc3 the
two have been merged and __GFP_NORETRY is set for x86_32 as well now. Is
that a good idea ? Perhaps a __GFP_NO_OOMKILL ?

Mike.

