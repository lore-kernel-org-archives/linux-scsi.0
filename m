From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] tmscsim: 64-bit cleanup
Date: 21 May 2004 10:15:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085152512.2258.21.camel@mulgrave>
References: <Pine.LNX.4.44.0405192135160.6790-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:52672 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265881AbUEUPPS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 May 2004 11:15:18 -0400
In-Reply-To: <Pine.LNX.4.44.0405192135160.6790-200000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, 2004-05-19 at 14:50, Guennadi Liakhovetski wrote:
> Ok, here comes the first one. I chose this one because it fixes an actual
> bug in the driver. This bug was (partially) introduced by myself when
> porting to 2.6. Partly the reason was that I disliked using
> function-like macros as lvalues:
> 
> sg_dma_address(x) = ...
> sg_dma_len(x) = ...
> 
> [OT] wouldn't it be better to introduce some macros like
> set_sg_dma_{address|len}(x, y)?

Actually, no.  struct scatterlist is for the OS platform to use to
characterise DMA; it's actually a private structure entirely within the
gift of the architecture to define.  It usually contains bits of
extraneous data that the driver never sees.  The driver should convert
struct scatterlist into its own version of the scatterlist that needs
feeding to the hardware rather than try and use struct scatterlist.

You'll find that lvalue use of sg_dma_len() fails on some platforms that
actually compute it from page/offset values in the scatterlist.

Could you (eventually) update tmscsim not to use it?

Thanks,

James


