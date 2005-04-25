From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Mon, 25 Apr 2005 21:56:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0504252110230.9503@poirot.grange>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
  <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>  <20050321104419.GH23911@suse.de>
  <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0503302318250.9431@poirot.grange>  <1112220802.9435.1.camel@mulgrave>
  <Pine.LNX.4.56.0503311051290.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0504100035110.4283@poirot.grange>  <Pine.LNX.4.60.0504212341390.6761@poirot.grange>
  <20050422113654.GY9371@suse.de>  <Pine.LNX.4.60.0504222203190.5348@poirot.grange>
  <Pine.LNX.4.60.0504231159260.8537@poirot.grange>  <1114282904.5068.19.camel@mulgrave>
  <Pine.LNX.4.60.0504240212090.13715@poirot.grange> <1114380718.4786.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:19157 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262771AbVDYULe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2005 16:11:34 -0400
In-Reply-To: <1114380718.4786.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Kurt Garloff <garloff@suse.de>

Hi

On Sun, 24 Apr 2005, James Bottomley wrote:

> On Sun, 2005-04-24 at 02:22 +0200, Guennadi Liakhovetski wrote:
> >  But, I hope, 
> > the .page, .length, and .offset elements stayed unchanged, so, one can 
> > still walk elements 0 and 1, calculating a sum of sg[i].length and thus 
> > arrive to the required page, right?
> 
> This, I'm not entirely sure about.  There are some weird iommu mapping
> implementations out there.  The only absolute requirement is that the
> map_sg unmap_sg map_sg actually work.  There was some debate over
> whether unmap_sg was supposed to return the sg list to its original
> form, but x86_64 got beaten up in the argument, so this is true too.
> 
> So ... I think the answer to your question is "yes", at least for all
> the iommu implementations I know about.  However, nothing in the
> published API actually requires this.
> 
> What I think all this means is that you can get away with what you're
> proposing.  However, the proper route would be to unmap the sglist
> before you start feeding the leftovers via pio.

Hmm, does anyone already on "CC" know the exact answer? Shall I forward 
it to LKML? It'd be nice to know the answer exactly. I'm not quite sure if 
unmapping sg would be always feasible / at all doable. E.g., in tmscsim 
(AFAIR, in dc395x too) PIO is done in ISR. Would it be too limiting / 
impossible to actually require that .page, .length and .offset stay 
unchanged over map_sg?

Ok, I actually looked through

alpha
ia64
parisc
ppc64
sparc64
x86_64

- AFAICS, none of them ever modifies those sg members on sg_(un)map. Did I 
miss anybody with an IOMMU?

Thanks
Guennadi
---
Guennadi Liakhovetski

