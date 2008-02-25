From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [12/22] Remove GFP_DMAs/unchecked_isa_dma checks in
	scsi_scan.c
Date: Mon, 25 Feb 2008 07:45:05 -0800
Message-ID: <1203954305.3254.39.camel@localhost.localdomain>
References: <200802251235.889863872@firstfloor.org>
	 <20080224233525.31E991B4183@basil.firstfloor.org>
	 <1203950818.3254.16.camel@localhost.localdomain>
	 <20080225145850.GB16158@one.firstfloor.org>
	 <1203951860.3254.26.camel@localhost.localdomain>
	 <20080225151138.GE16158@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52339 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753433AbYBYPpR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 10:45:17 -0500
In-Reply-To: <20080225151138.GE16158@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-02-25 at 16:11 +0100, Andi Kleen wrote:
> On Mon, Feb 25, 2008 at 07:04:20AM -0800, James Bottomley wrote:
> > On Mon, 2008-02-25 at 15:58 +0100, Andi Kleen wrote:
> > > On Mon, Feb 25, 2008 at 06:46:58AM -0800, James Bottomley wrote:
> > > > 
> > > > On Mon, 2008-02-25 at 00:35 +0100, Andi Kleen wrote:
> > > > > Should not be needed because the block layer bounces that all.
> > > > > 
> > > > > Signed-off-by: Andi Kleen <ak@suse.de>
> > > > > 
> > > > > ---
> > > > >  drivers/scsi/scsi_scan.c |    6 ++----
> > > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > > > 
> > > > > Index: linux/drivers/scsi/scsi_scan.c
> > > > > ===================================================================
> > > > > --- linux.orig/drivers/scsi/scsi_scan.c
> > > > > +++ linux/drivers/scsi/scsi_scan.c
> > > > > @@ -1010,8 +1010,7 @@ static int scsi_probe_and_add_lun(struct
> > > > >  	if (!sdev)
> > > > >  		goto out;
> > > > >  
> > > > > -	result = kmalloc(result_len, GFP_ATOMIC |
> > > > > -			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
> > > > > +	result = kmalloc(result_len, GFP_ATOMIC);
> > > > >  	if (!result)
> > > > >  		goto out_free_sdev;
> > > > >  
> > > > > @@ -1328,8 +1327,7 @@ static int scsi_report_lun_scan(struct s
> > > > >  	 * prevent us from finding any LUNs on this target.
> > > > >  	 */
> > > > >  	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
> > > > > -	lun_data = kmalloc(length, GFP_ATOMIC |
> > > > > -			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
> > > > > +	lun_data = kmalloc(length, GFP_ATOMIC);
> > > > >  	if (!lun_data) {
> > > > >  		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
> > > > >  		goto out;
> > > > 
> > > > Andi, this can't be right.
> > > 
> > > You mean it is incorrect or just not optimal? 
> > 
> > It's not optimal ... but that's sufficient an objection.
> > 
> > > > 
> > > > You're removing something that's actually useful.  I'm happy to
> > > > substitute this kmalloc for kmalloc_mask on the device dma mask which
> > > > will do the same thing and so junk unchecked_isa_dma() that way (and
> > > > actually fix us up for other weird mask devices), but just using
> > > > ZONE_NORMAL is wrong because we'll then bounce all the time for
> > > > something we knew a priori how to avoid.
> > > 
> > > That would require adding a separate mask just for this to the 
> > > template. I figured the SCSI scan was not performance critical
> > > so a few more copies just for this case was an ok trade off
> > > for simpler code.
> > 
> > Why?  We already have the device; can't we just use its mask?
> 
> These ISA drivers I worked with definitely don't know 
> anything about a device in any form.
> 
> Also there is the issue that 50+% of the ISA drivers actually
> don't need it even if they had a ISA device.
> 
> > 
> > > You think it makes sense to optimize scsi scan?
> > 
> > It makes sense to use information we already know to optimise the path,
> 
> In this case we would need to add a special new field for this
> to the SCSI template (assume unchecked_isa_dma is already gone). 
> You think that is worth it? 

You've already added a new special field with your u64
sense_buffer_mask;

It's a special case field for ISA devices because everything else has a
dev->dma_mask you can use.

So, in fact, you're removing my single bit isa_unchecked_dma flag and
using 64 bits in its place that preserves essentially the same
information.  It just doesn't look like a bargain to me.  Particularly
as you're removing a lot of the memory allocation optimisation paths at
the same time.

Don't get me wrong; I'm all for removing the special casing of isa
devices we have to do, of which isa_unchecked_dma is the switch ... I
just want to do it properly, and that would have to be by bringing isa
devices under the device model, so we don't have to special case them.

There is a proposal that's been under consideration for a while because
it might solve other issues ATA has with mdma (they need to use
different DMA masks for different devices on the same host).  The
proposal was to use the struct device in the struct scsi_device as the
device for the dma_ API ... this has all the properties you need ... you
can give it a DMA_24BIT_MASK for isa devices, and use it to key the
allocations off, since it's always present ... then we can junk
isa_unchecked_dma and not add any other strange flags.

James


