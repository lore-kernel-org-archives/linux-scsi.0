From: "Moore, Eric Dean" <emoore@lsil.com>
Subject: Re: [BK PATCH] essential SCSI fixes for 2.6.5-rc2
Date: Sat, 20 Mar 2004 22:26:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000801c40f05$0daa3c50$231015ac@ericmoore>
References: <1079793048.1778.6.camel@mulgrave> <m3u10jr93e.fsf@averell.firstfloor.org> <1079796067.1755.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:13301 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263608AbUCUF06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Mar 2004 00:26:58 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Andi Kleen <ak@muc.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

I will be consolidating the three allocations. I have started this work last
Friday,
and should be done early next week.

Eric Moore

On Saturday, March 20, 2004 8:21 AM, James Bottomley wrote:
> On Sat, 2004-03-20 at 07:33, Andi Kleen wrote:
> > Any chance you could include the fusion consistent mask patch with this?
> >
> > Without this fusion is completely unusable with >4GB on 64bit.
>
> But if I include this patch, it will break Altix.
>
> Eric, could you make fixing this your top priority?  Even if you can't
> consolidate the allocations, what about using dma_pool instead?
>
> James
>
> > diff -burpN -X ../KDIFX -x '*-SLAB'
linux-vanilla-2.6.5rc2/drivers/message/fusion/mptbase.c
linux-2.6.5rc2-amd64/drivers/message/fusion/mptbase.c
> > --- linux-vanilla-2.6.5rc2/drivers/message/fusion/mptbase.c 2004-03-20
03:55:31.000000000 +0100
> > +++ linux-2.6.5rc2-amd64/drivers/message/fusion/mptbase.c 2004-03-20
04:11:24.000000000 +0100
> > @@ -1280,12 +1280,17 @@ mptbase_probe(struct pci_dev *pdev, cons
> >  return r;
> >  }
> >
> > +#if 0
> > + /* broken because some code assumes that multiple calls
> > +    to pci_alloc_consistent return data in the same 4GB segment.
> > +    This cannot work on machines with enough memory. */
> >  if (!pci_set_consistent_dma_mask(pdev, mask))
> >  dprintk((KERN_INFO MYNAM
> >  ": Using 64 bit consistent mask\n"));
> >  else
> >  dprintk((KERN_INFO MYNAM
> >  ": Not using 64 bit consistent mask\n"));
> > +#endif
> >
> >  ioc = kmalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
> >  if (ioc == NULL) {
>
>

