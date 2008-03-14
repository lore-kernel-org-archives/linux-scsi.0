From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] mpt fusion: Fix for 1078 Data corruption issue for36GB memory region
Date: Fri, 14 Mar 2008 10:43:18 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70D82CBD@NAMAIL4.ad.lsil.com>
References: <1205443700.2893.71.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:47985 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbYCNQna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Mar 2008 12:43:30 -0400
Content-class: urn:content-classes:message
In-reply-to: <1205443700.2893.71.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Thursday, March 13, 2008 3:28 PM, James Bottomley wrote:  
> > The fix is explained below
> > 1) Ensure that the message frames are NOT located in the trouble
> > region. There is no remapping available for message frames, they
> > must be allocated outside the problem region.
> > 2) Ensure that Sense buffers are NOT in the trouble region. There is
> > no remapping available.
> > 3) Walk through the SGE entries and if any are inside the trouble
> > region then they need to be remapped as discussed below.
> > 	1) Set the Local Address bit in the SGE Flags field.
> > 	MPI_SGE_FLAGS_LOCAL_ADDRESS
> > 	2) Ensure we are using 64-bit SGEs
> > 	3) Set MSb (Bit 63) of the 64-bit address, this will 
> indicate buffer
> > 	location is Host Memory.
> 
> Is there any reason these three things can't be done all the time for
> the troubled adapter rather then do the if you have on every scatter
> gather segment?
> 

The reason for the this implementation is less risk.  Due to a hardware
bug, we are providing both firmware and driver fixes.  The hardware bug
effects three memory ranges within 36-37GB range, the bug is is when
your writing into that physical memory, your writting into controller
memory instead of host memory, hence the data corruption.    So the
customer will be requiring a firmware upgrade as well as new drivers.
We call this method of setting the scatter gather "POM2 addressing".
The other method is called "POM3 addressing".    In order to use the
"POM2 addressing", the customer will need a firmware upgrade.    If the
customer has less than 36GB of memory, there is no reason they have to
upgrade since "POM3 adrressing" is used in the existing patch.   Also,
we only tested the "POM2 addressing" in that range, so we are not sure
whether it will work for all memory ranges.  So the bottom line is less
risk and impact when applying the "POM2" change only within that range.

> > +	/*
> > +	 * 1078 errata workaround for the 36GB limitation
> > +	 */
> > +	if ((((u64)dma_addr + MPI_SGE_LENGTH(flagslength)) >> 
> 32)  == 9) {
> 
> This looks really odd.  36GB (in fact 32-64GB) will have (dma_addr >>
> 32) == 3 not 9

I do believe this calculation is correct.  The three effected ranges
are:

(1) 0x900000000 - 0x91000FFFF
(2) 0x918000000 - 0x918000FFF
(3) 0x91C000000 - 0x91C000FFF

 
> > +	/*
> > +	 * Setting up proper handlers for scatter gather handling
> > +	 */
> > +	if (sizeof(dma_addr_t) == sizeof(u64)) {
> 
> use dma_get_required_mask() here ... that will tell you not 
> only if you
> were compiled for 64 bits, but also if the box would actually 
> use them.
> 

ok

> >  	/*  Prime reply FIFO...  */
> >  
> >  	if (ioc->reply_frames == NULL) {
> >  		if ( (num_chain = initChainBuffers(ioc)) < 0)
> >  			return -1;
> > +		/*
> > +		 * 1078 errata workaround for the 36GB limitation
> > +		 */
> > +		if (ioc->pcidev->device == 
> MPI_MANUFACTPAGE_DEVID_SAS1078 &&
> > +		    ioc->dma_mask > MPT_DMA_35BIT_MASK) {
> > +			if (!pci_set_dma_mask(ioc->pcidev, 
> DMA_32BIT_MASK)
> 
> Don't you want to be setting a 35 bit mask here, not a 32 bit one ...
> not that it really matters, most architectures will happily 
> give you 32
> bits anyway (except possibly altix).

I can't off hand remember why I did that, but I agree with your point.



> 
> There's already a definition DMA_35BIT_MASK in
> include/linux/dma-mapping.h ... please use it.
> 

ok, this was really a portability thing, but I agree the mainstream code
should be using DMA_35BIT_MASK

> > +	MPT_ADD_SGE		 add_sge;
> > +	u64			 dma_mask;
> 
> You don't need this ... isn't it going to be the same as
> ioc->pcidev->dma_mask?

The general idea of the flag was to help in PrimeIocFifos, so the
message frames are below the effected memory in the hardware errata,
meanwhile we use full available physical memory for dma the scatter
gather.

Eric

