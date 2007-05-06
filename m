From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] tmscsim: Remove the last bus_to_virt()
Date: Sun, 6 May 2007 12:23:39 +0100
Message-ID: <20070506112339.GB1597@infradead.org>
References: <Pine.LNX.4.60.0705042259430.21060@poirot.grange> <20070505093859.GC9422@infradead.org> <Pine.LNX.4.60.0705060052100.9593@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56430 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbXEFLXk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 May 2007 07:23:40 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0705060052100.9593@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Sun, May 06, 2007 at 01:06:51AM +0200, Guennadi Liakhovetski wrote:
> On Sat, 5 May 2007, Christoph Hellwig wrote:
> 
> > On Fri, May 04, 2007 at 11:00:49PM +0200, Guennadi Liakhovetski wrote:
> > > Dynamically map the buffer for PIO for the residue byte.
> > 
> > This look okay.  Btw, is there a chance you could run tmscsim.c
> > through scripts/Lindent before your next round of bigger changes?
> 
> Well, I just did that - ran tmscsim.[ch] through Lindent... A couple of 
> things I wouldn't do there. Like:

Lindent is not perfect unfortunately and usually needs some
hand tuning.  It does very strange placement of goto labels, breaks
lines unfortunate when they are too long, etc.

> -static int tmscsim[] = {-2, -2, -2, -2, -2, -2};
> +static int tmscsim[] = { -2, -2, -2, -2, -2, -2 };
> 
> (why extra spaces?)

Normal style is to have braces around literal numbers.  I don't care
about whether we have it for a case like this or not.

> 
> -               ptr[EE_ADAPT_SCSI_ID] = (u8)tmscsim[0]; /* Adapter ID */
> +               ptr[EE_ADAPT_SCSI_ID] = (u8) tmscsim[0];        /* Adapter ID */
> 
> (ditto)

I preer to not having the space here, but lots of other kernel developers
like it.

> -MODULE_DESCRIPTION("SCSI host adapter driver for Tekram DC390 and other AMD53C974A based PCI SCSI adapters");
> +MODULE_DESCRIPTION
> +    ("SCSI host adapter driver for Tekram DC390 and other AMD53C974A based PCI SCSI adapters");
> 
> (doesn't look nice. Would be better to split into two strings?)

The script doesn't know enough C to be able to split a string.  Splitting
it manyally would be nicer.

> +static void dc390_Command_0(struct dc390_acb *pACB, struct dc390_srb *pSRB,
> +			    u8 * psstatus);

Does it really leave the space after the '*'? Odd.

