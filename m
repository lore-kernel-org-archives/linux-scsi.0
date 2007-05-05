From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/3] tmscsim: remove bogus endianness conversions
Date: Sat, 5 May 2007 23:18:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0705052308460.9593@poirot.grange>
References: <Pine.LNX.4.60.0705042257410.21060@poirot.grange>
 <20070505093751.GB9422@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36301 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933613AbXEEVSc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 May 2007 17:18:32 -0400
In-Reply-To: <20070505093751.GB9422@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Sat, 5 May 2007, Christoph Hellwig wrote:

> On Fri, May 04, 2007 at 10:59:40PM +0200, Guennadi Liakhovetski wrote:
> > cpu_to_le32 endianness conversions in tmscsim.c, followed by
> > arithmetic operations don't look correct. Besides, {in,out}[wl]
> > already perform the necessary conversions. Further, bus addresses
> > of request buffers are guaranteed to be (mapped) under 4G by
> > current scsi- and block-layer defaults. This could be explicitly
> > enforced by using blk_queue_bounce_limit(), which, however,
> > doesn't seem to be the common practice among SCSI drivers.
> 
> Looks good to me.  If there are structures in dma memory in the driver
> it would help to give the __le annotation to get the whole endianess
> handling completely right.

Yeah, but these variables are not like that. Actually, I don't think 
there are any variables in tmscsim that get passed to the controller over 
DMA.

Thanks
Guennadi
---
Guennadi Liakhovetski
