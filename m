From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [12/22] Remove GFP_DMAs/unchecked_isa_dma checks in
	scsi_scan.c
Date: Mon, 25 Feb 2008 07:04:20 -0800
Message-ID: <1203951860.3254.26.camel@localhost.localdomain>
References: <200802251235.889863872@firstfloor.org>
	 <20080224233525.31E991B4183@basil.firstfloor.org>
	 <1203950818.3254.16.camel@localhost.localdomain>
	 <20080225145850.GB16158@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45216 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153AbYBYPEd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 10:04:33 -0500
In-Reply-To: <20080225145850.GB16158@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-02-25 at 15:58 +0100, Andi Kleen wrote:
> On Mon, Feb 25, 2008 at 06:46:58AM -0800, James Bottomley wrote:
> > 
> > On Mon, 2008-02-25 at 00:35 +0100, Andi Kleen wrote:
> > > Should not be needed because the block layer bounces that all.
> > > 
> > > Signed-off-by: Andi Kleen <ak@suse.de>
> > > 
> > > ---
> > >  drivers/scsi/scsi_scan.c |    6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > 
> > > Index: linux/drivers/scsi/scsi_scan.c
> > > ===================================================================
> > > --- linux.orig/drivers/scsi/scsi_scan.c
> > > +++ linux/drivers/scsi/scsi_scan.c
> > > @@ -1010,8 +1010,7 @@ static int scsi_probe_and_add_lun(struct
> > >  	if (!sdev)
> > >  		goto out;
> > >  
> > > -	result = kmalloc(result_len, GFP_ATOMIC |
> > > -			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
> > > +	result = kmalloc(result_len, GFP_ATOMIC);
> > >  	if (!result)
> > >  		goto out_free_sdev;
> > >  
> > > @@ -1328,8 +1327,7 @@ static int scsi_report_lun_scan(struct s
> > >  	 * prevent us from finding any LUNs on this target.
> > >  	 */
> > >  	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
> > > -	lun_data = kmalloc(length, GFP_ATOMIC |
> > > -			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
> > > +	lun_data = kmalloc(length, GFP_ATOMIC);
> > >  	if (!lun_data) {
> > >  		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
> > >  		goto out;
> > 
> > Andi, this can't be right.
> 
> You mean it is incorrect or just not optimal? 

It's not optimal ... but that's sufficient an objection.

> > 
> > You're removing something that's actually useful.  I'm happy to
> > substitute this kmalloc for kmalloc_mask on the device dma mask which
> > will do the same thing and so junk unchecked_isa_dma() that way (and
> > actually fix us up for other weird mask devices), but just using
> > ZONE_NORMAL is wrong because we'll then bounce all the time for
> > something we knew a priori how to avoid.
> 
> That would require adding a separate mask just for this to the 
> template. I figured the SCSI scan was not performance critical
> so a few more copies just for this case was an ok trade off
> for simpler code.

Why?  We already have the device; can't we just use its mask?

> You think it makes sense to optimize scsi scan?

It makes sense to use information we already know to optimise the path,
yes, when it's something as simple as keeping the dma buffer within the
mask bounds of the device.

James


