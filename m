From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: 64-bit cleanup
Date: Sun, 6 Jun 2004 17:06:38 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0406061643310.2029-100000@poirot.grange>
References: <1086469564.2281.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:62096 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263725AbUFFPHg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 11:07:36 -0400
In-Reply-To: <1086469564.2281.23.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On 5 Jun 2004, James Bottomley wrote:

> On Sat, 2004-06-05 at 15:37, Guennadi Liakhovetski wrote:
> > Thanks for replies and explanations, James! But could you, please, just
> > explain a bit more - what and how do I break with this patch? I just use a
> > driver-private scatterlist struct (SRB.Segmentx) to set up a
> > single-segment sg-list, and call pci_map_sg() on it. If I do it wrong - it
> > could be fixed. But why it is bad in principle? Advantages - no need to
> > check if sg is used for this particular command throughout the code.
> >
> > But no problem. I'll redo the patch without private sg.
>
> Actually, I haven't looked at the patch yet.  I was just answering the
> question in the mail which I assumed was "can I alter these three
> fields?" to which the answer is "no".  If the question is "can I read
> these fields directly" the answer's yes.

Ah, ok. I don't alter those fields in the sg, set up by the block-layer. I
just set up a separate sg for cases, when the block layer doesn't do it.
That helps to unify the processing. I would prefer to go that way.
Although, I think, there's still a glitch there (modified if's order).
I'll send a new version, if the approach is approved in principle.

I also prepared a patch without extra sg's, but I am much less confident
about it, although it survived some light testing.

Thanks
Guennadi
---
Guennadi Liakhovetski


