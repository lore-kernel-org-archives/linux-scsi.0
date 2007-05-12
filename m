From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Sat, 12 May 2007 10:50:16 -0500
Message-ID: <1178985016.3723.15.camel@mulgrave.il.steeleye.com>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
	 <20070512152916.GA7992@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57090 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754970AbXELPuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 11:50:20 -0400
In-Reply-To: <20070512152916.GA7992@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2007-05-12 at 16:29 +0100, Christoph Hellwig wrote:
> On Fri, May 11, 2007 at 01:33:41PM -0500, James Bottomley wrote:
> > Right at the moment, we're planning to clean up the way SCSI drivers
> > process commands.  The proposals are essentially:
> > 
> >      1. Get rid of the now unnecessary map_single path (every command is
> >         either zero transfer or scatter/gather)
> >      2. use accessors to manipulate the SG lists (mainly so that we can
> >         alter the implementation without affecting the drivers)
> > 
> > It strikes me that in all of this, we could also consider doing the DMA
> > mapping inside the mid layer (instead of in every driver).  This is
> > essentially what libata is already doing ... leading to confusion in
> > SCSI drivers that use libata for SATA.
> > 
> > So what do people think about this?
> 
> I don't like it at all.  It means we tange up dma mapping bits into
> a layer were they don't belong at all.

Well ... libata already does this ... I don't remember you complaining
about it being a layering violation in libata.

>   We have hbas doing pio, doing
> channel programs, mangling dma list before or after the mapping or just
> dealing with the commands in kernelspace.  We also have architectures
> without dma mapping support.

I agree we have a lot of special cases which need handling ... could we
not get around all of these with a template flag specifying whether the
driver wants the mid-layer to dma_map or not?

> I'd rather give the drivers proper helpers as in tomo's proposal and
> let them handle what should be in their layer.
> 
> Btw, Adam Richter already sent a patch doing the dma mapping in
> scsi.c back in 2002 and he got shot down for the same reasons, although
> I can't find the arguments in the list archives anymore.

In 2002 it really wansn't possible because each bus type had its own dma
mapping functions (or it was possible, but would be extremely ugly).
The generic dma mapping functions take care of that problem.

James


