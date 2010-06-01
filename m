From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 08/24] hpsa: fix leak of ioremapped memory
Date: Tue, 1 Jun 2010 07:55:39 -0500
Message-ID: <20100601125539.GQ10831@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com> <20100527201322.3116.86053.stgit@beardog.cce.hp.com> <201005282112.24802.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:20646 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab0FAMu5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 08:50:57 -0400
Content-Disposition: inline
In-Reply-To: <201005282112.24802.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

On Fri, May 28, 2010 at 09:12:17PM +0200, Rolf Eike Beer wrote:
> Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > hpsa: fix leak of ioremapped memory
> > in hpsa_pci_init error path.
> 
> If you had used devres to track your resources you got this for free.
> 

Thanks, I was unaware of devres.  I'll look into it.

> > @@ -3474,6 +3477,12 @@ static int __devinit hpsa_pci_init(struct ctlr_info
> > *h) return 0;
> > 
> >  err_out_free_res:
> > +	if (h->transtable)
> > +		iounmap(h->transtable);
> > +	if (h->cfgtable)
> > +		iounmap(h->cfgtable);
> > +	if (h->vaddr)
> > +		iounmap(h->vaddr);
> 
> I wonder if that shouldn't use pci_iomap() instead. Also the page aligning 
> tricks in remap_pci_mem() look a bit dubious to me. If your pci BAR is >= 
> PAGE_SIZE this isn't needed at all anyway since those mappings are aligned to 
> at least their size in physical address space anyway and the logical address 
> shouldn't matter for the driver.

Ok, I'll look into these as well.

> 
> Eike


