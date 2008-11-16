From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [5/21] Remove unchecked_isa in BusLogic
Date: Sun, 16 Nov 2008 23:31:05 +0100
Message-ID: <20081116223105.GE6703@one.firstfloor.org>
References: <200811161211.212948789@firstfloor.org> <20081115231105.63B2F3E6619@basil.firstfloor.org> <1226850376.3556.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:47451 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYKPWV3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Nov 2008 17:21:29 -0500
Content-Disposition: inline
In-Reply-To: <1226850376.3556.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Sun, Nov 16, 2008 at 10:46:16AM -0500, James Bottomley wrote:
> On Sun, 2008-11-16 at 00:11 +0100, Andi Kleen wrote:
> > +static struct Scsi_Host *buslogic_host_alloc(gfp_t gfp)
> > +{
> > +       struct BusLogic_HostAdapter *board;
> > +       struct Scsi_Host *shost;
> > +
> > +
> > +       shost = scsi_host_alloc(&Bus_Logic_template, sizeof(struct host_ptr));
> > +       if (!shost)
> > +               return NULL;
> > +
> > +       board = dma_alloc_coherent(NULL, sizeof(struct BusLogic_HostAdapter),
> > +                                       &bl_shost_dma(shost), GFP_KERNEL);
> > +       if (!board) {
> > +               scsi_host_put(shost);
> > +               return NULL;
> > +       }
> 
> What makes you think that BusLogic_HostAdapter has to be in coherent
> memory?  You can tell from your own patch that nothing ever uses its DMA
> address, so the card never actually DMAs data to or from this area.

Hmm I think it was mostly about having an equivalent transformation.
The structure was in GFP_DMA before, so I wanted to keep that

Also the driver does some funny things with transforming some
bus addresses on its own, which made me double conservative.
On looking more closely it doesn't do virt_to_bus, but at least
one bus_to_virt (but it seems to data outside BusAdapter)

I don't have that hardware so I wanted to be very conservative
in any

But I'll fix it in the next version.

-Andi

