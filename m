From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Sat, 12 May 2007 16:29:16 +0100
Message-ID: <20070512152916.GA7992@infradead.org>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40313 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXELP3R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 11:29:17 -0400
Content-Disposition: inline
In-Reply-To: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, May 11, 2007 at 01:33:41PM -0500, James Bottomley wrote:
> Right at the moment, we're planning to clean up the way SCSI drivers
> process commands.  The proposals are essentially:
> 
>      1. Get rid of the now unnecessary map_single path (every command is
>         either zero transfer or scatter/gather)
>      2. use accessors to manipulate the SG lists (mainly so that we can
>         alter the implementation without affecting the drivers)
> 
> It strikes me that in all of this, we could also consider doing the DMA
> mapping inside the mid layer (instead of in every driver).  This is
> essentially what libata is already doing ... leading to confusion in
> SCSI drivers that use libata for SATA.
> 
> So what do people think about this?

I don't like it at all.  It means we tange up dma mapping bits into
a layer were they don't belong at all.  We have hbas doing pio, doing
channel programs, mangling dma list before or after the mapping or just
dealing with the commands in kernelspace.  We also have architectures
without dma mapping support.

I'd rather give the drivers proper helpers as in tomo's proposal and
let them handle what should be in their layer.

Btw, Adam Richter already sent a patch doing the dma mapping in
scsi.c back in 2002 and he got shot down for the same reasons, although
I can't find the arguments in the list archives anymore.
