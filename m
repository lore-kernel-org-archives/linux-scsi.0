From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH 1/3] iscsi iser: remove DMA restrictions
Date: Wed, 13 Feb 2008 14:59:12 -0500
Message-ID: <20080213195912.GC7372@osc.edu>
References: <20080212205252.GB13643@osc.edu> <20080212205403.GC13643@osc.edu> <1202850645.3137.132.camel@localhost.localdomain> <20080212214632.GA14397@osc.edu> <1202853468.3137.148.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:37878 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbYBMT7O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 14:59:14 -0500
Content-Disposition: inline
In-Reply-To: <1202853468.3137.148.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>

James.Bottomley@HansenPartnership.com wrote on Tue, 12 Feb 2008 15:57 -0600:
> On Tue, 2008-02-12 at 16:46 -0500, Pete Wyckoff wrote:
> > James.Bottomley@HansenPartnership.com wrote on Tue, 12 Feb 2008 15:10 -0600:
> > > On Tue, 2008-02-12 at 15:54 -0500, Pete Wyckoff wrote:
> > > > iscsi_iser does not have any hardware DMA restrictions.  Add a
> > > > slave_configure function to remove any DMA alignment restriction,
> > > > allowing the use of direct IO from arbitrary offsets within a page.
> > > > Also disable page bouncing; iser has no restrictions on which pages it
> > > > can address.
> > > > 
> > > > Signed-off-by: Pete Wyckoff <pw@osc.edu>
> > > > ---
> > > >  drivers/infiniband/ulp/iser/iscsi_iser.c |    8 ++++++++
> > > >  1 files changed, 8 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> > > > index be1b9fb..1b272a6 100644
> > > > --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> > > > +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> > > > @@ -543,6 +543,13 @@ iscsi_iser_ep_disconnect(__u64 ep_handle)
> > > >  	iser_conn_terminate(ib_conn);
> > > >  }
> > > >  
> > > > +static int iscsi_iser_slave_configure(struct scsi_device *sdev)
> > > > +{
> > > > +	blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_ANY);
> > > 
> > > You really don't want to do this.  That signals to the block layer that
> > > we have an iommu, although it's practically the same thing as a 64 bit
> > > DMA mask ... but I'd just leave it to the DMA mask to set this up
> > > correctly.  Anything else is asking for a subtle bug to turn up years
> > > from now when something causes the mask and the limit to be mismatched.
> > 
> > Oh.  I decided to add that line for symmetry with TCP, and was
> > convinced by the arguments here:
> > 
> >     commit b6d44fe9582b9d90a0b16f508ac08a90d899bf56
> >     Author: Mike Christie <michaelc@cs.wisc.edu>
> >     Date:   Thu Jul 26 12:46:47 2007 -0500
> > 
> >     [SCSI] iscsi_tcp: Turn off bounce buffers
> > 
> >     It was found by LSI that on setups with large amounts of memory
> >     we were bouncing buffers when we did not need to. If the iscsi tcp
> >     code touches the data buffer (or a helper does),
> >     it will kmap the buffer. iscsi_tcp also does not interact with hardware,
> >     so it does not have any hw dma restrictions. This patch sets the bounce
> >     buffer settings for our device queue so buffers should not be bounced
> >     because of a driver limit.
> > 
> > I don't see a convenient place to callback into particular iscsi
> > devices to set the DMA mask per-host.  It has to go on the
> > shost_gendev, right?, but only for TCP and iSER, not qla4xxx, which
> > handles its DMA mask during device probe.
> 
> You should be taking your mask from the underlying infiniband device as
> part of the setup, shouldn't you?

I think you're right about this.  All the existing IB HW tries to
set a 64-bit dma mask, but that's no reason to disable the mechanism
entirely in iser.  I'll remove that line that disables bouncing in
my patch.  Perhaps Mike will know if the iscsi_tcp usage is still
appropriate.

		-- Pete
