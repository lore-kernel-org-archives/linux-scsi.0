From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Sat, 12 May 2007 16:52:40 +0100
Message-ID: <20070512155240.GA8460@infradead.org>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com> <20070512152916.GA7992@infradead.org> <1178985016.3723.15.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54228 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbXELPwl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 11:52:41 -0400
Content-Disposition: inline
In-Reply-To: <1178985016.3723.15.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, May 12, 2007 at 10:50:16AM -0500, James Bottomley wrote:
> > I don't like it at all.  It means we tange up dma mapping bits into
> > a layer were they don't belong at all.
> 
> Well ... libata already does this ... I don't remember you complaining
> about it being a layering violation in libata.

I have in fact never reviewed libata fully, and no I don't like this
in libata either.

> >   We have hbas doing pio, doing
> > channel programs, mangling dma list before or after the mapping or just
> > dealing with the commands in kernelspace.  We also have architectures
> > without dma mapping support.
> 
> I agree we have a lot of special cases which need handling ... could we
> not get around all of these with a template flag specifying whether the
> driver wants the mid-layer to dma_map or not?

We probably could.  But if would be hacky as hell, and we'd have to hack
the core code for every new piece of whacky hardware.  I much prefer
the current clean abstraction where the responsibily is clearly divided.

Just look at the mess the infinibad people created because they put
the dma mapping functionality outside of the drivers.
