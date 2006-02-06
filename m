From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] ipr: don't doublefree pages from scatterlist
Date: Mon, 6 Feb 2006 17:01:53 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0602061646230.3560@goblin.wat.veritas.com>
References: <Pine.LNX.4.61.0602040004020.5406@goblin.wat.veritas.com>
 <43E66FB6.6070303@us.ibm.com>  <Pine.LNX.4.61.0602060909180.6827@goblin.wat.veritas.com>
  <20060206.014608.22328385.davem@davemloft.net> <1139238179.3022.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gold.veritas.com ([143.127.12.110]:60563 "EHLO gold.veritas.com")
	by vger.kernel.org with ESMTP id S932230AbWBFRBK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 12:01:10 -0500
Received: from [172.21.56.196]([172.21.56.196]) (3321 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1F69jg-0001U6C@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Mon, 6 Feb 2006 09:01:08 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <1139238179.3022.2.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "David S. Miller" <davem@davemloft.net>, brking@us.ibm.com, akpm@osdl.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 6 Feb 2006, James Bottomley wrote:
> On Mon, 2006-02-06 at 01:46 -0800, David S. Miller wrote:
> > That's a bug, frankly.  Sparc64 doesn't need to do anything like
> > that.  Spamming the page pointers is really really bogus and I'm
> > surprised this doesn't make more stuff explode.
> > 
> > It was never the intention to allow the DMA mapping support code
> > to modify the page, offset, and length members of the scatterlist.
> > Only the DMA components.
> > 
> > I'd really prefer that those assignments get fixed and an explicit
> > note added to Documentation/DMA-mapping.txt about this.
> > 
> > It's rediculious that these generic subsystem drivers need to
> > know about this. :)
> 
> I complained about this x86_64 behaviour ages ago.

While I agree with you, David and Brian that this would be much nicer
for driver writers to know that the page,offset,length in the sg list
would not be touched by map_sg, I am surprised that you didn't say so
in DMA-API.txt, and said only that map_sg would destroy information
there.  x86_64 seems to conform to that destruction!

> Andi claimed it was
> the only way they could get there merging algorithm to work.  It
> actually triggered a bug in SCSI because in-flight I/O that was rejected
> gets unmapped and then remapped (which was, originally, not working).
> They finally fixed it by making the unmap put back the original
> scatterlist.

I don't quite get that, but whatever, it would be a good idea to cc Andi.

> Perhaps this should go to linux-arch just in case anyone
> else copied x86_64?

Okay, cc'd to linux-arch also.  The one thing I have checked is that the
coalescing architectures (if I actually got them right) do all declare
a dma_length (perhaps differently named) distinct from input length,
so wouldn't need that added.  Although I can see that x86_64 does
modify the page,offset,length fields we'd prefer it not to, I didn't
find any of the architecture's coalescing routines easy to follow,
and would hesitate to declare any of them safe in this regard.

I'd better also forward my original mail on the fix to Ryan's bug
to Andi and linux-arch also.

Hugh
