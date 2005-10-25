From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] dec_esp: Use physical addresses
Date: Tue, 25 Oct 2005 16:13:42 +0100 (BST)
Message-ID: <Pine.LNX.4.55.0510251559570.8058@blysk.ds.pg.gda.pl>
References: <20051015012630.GA20981@linux-mips.org> <20051017104207.GA22710@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:58639 "EHLO
	pollux.ds.pg.gda.pl") by vger.kernel.org with ESMTP id S932171AbVJYPNh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 11:13:37 -0400
In-Reply-To: <20051017104207.GA22710@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Mon, 17 Oct 2005, Christoph Hellwig wrote:

> > Use physical addresses at the interface level, letting drivers remap
> > them as appropriate.
> 
> > -		esp->eregs = (struct ESP_regs *) (system_base + IOASIC_SCSI);
> > +		esp->eregs = (void *)CKSEG1ADDR(dec_kn_slot_base +
> > +						IOASIC_SCSI);
> 
> Both the old and new code look very odd.  This looks like iomaped-ish
> memory and should be using some iomap variant.  The patch is probably
> okay for now, but I'd prefer if this used the proper APIs.

 It's a step in the transition to modern I/O bus APIs for TURBOchannel
systems.  It's certainly not going to stay there any longer than necessary
as this driver is meant to support Alphas and VAXen eventually.

  Maciej
