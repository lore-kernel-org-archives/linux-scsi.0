From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] tmscsim: 64-bit cleanup
Date: 22 May 2004 10:43:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085240593.2006.8.camel@mulgrave>
References: <Pine.LNX.4.44.0405192135160.6790-200000@poirot.grange>
	<1085152512.2258.21.camel@mulgrave>
	<20040522080924.GP4623@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:26011 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261232AbUEVPnZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 11:43:25 -0400
In-Reply-To: <20040522080924.GP4623@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Sat, 2004-05-22 at 03:09, Kurt Garloff wrote:
> On Fri, May 21, 2004 at 10:15:11AM -0500, James Bottomley wrote:
> > On Wed, 2004-05-19 at 14:50, Guennadi Liakhovetski wrote:
> > Actually, no.  struct scatterlist is for the OS platform to use to
> > characterise DMA; it's actually a private structure entirely within the
> > gift of the architecture to define.  It usually contains bits of
> > extraneous data that the driver never sees.  The driver should convert
> > struct scatterlist into its own version of the scatterlist that needs
> > feeding to the hardware rather than try and use struct scatterlist.
> 
> The AM53C974 hardware does not have hardware support for scatter-gather.
> (Yes, this is sad, you get an IRQ after every segment ...)

But then you should set sg_tablesize to one.  There's little point the
elevator wasting time to coalesce if you can't process the request in a
single go.  Doing that would also allow for a simpler driver design,
because now you know you can complete individual requests since they
only yield a single sg element.  You no longer have to track multiple
card completions to the request completion.

> > You'll find that lvalue use of sg_dma_len() fails on some platforms that
> > actually compute it from page/offset values in the scatterlist.
> > 
> > Could you (eventually) update tmscsim not to use it?
> 
> We could just define our own format, make a copy and then use that one.

Sure, that would be fine.  Whatever the registers take.

James


