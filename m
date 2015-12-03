From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH 01/10] aacraid: SCSI blk tag support
Date: Thu, 3 Dec 2015 21:25:23 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1EF153@BBYEXM01.pmc-sierra.internal>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1448973589-9216-2-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <5660652D.8080501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53014 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019AbbLCVZZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 16:25:25 -0500
In-Reply-To: <5660652D.8080501@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Santosh Akula <Santosh.Akula@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Rich Bono <Rich.Bono@pmcs.com>

Hello Tomas,

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Thursday, December 3, 2015 7:52 AM
> To: Raghava Aditya Renukunta; JBottomley@Parallels.com; linux-
> scsi@vger.kernel.org
> Cc: Mahesh Rajashekhara; Murthy Bhat; Santosh Akula; Gana Sridaran;
> aacraid@pmc-sierra.com; Rich Bono
> Subject: Re: [PATCH 01/10] aacraid: SCSI blk tag support
> 
> On 1.12.2015 13:39, Raghava Aditya Renukunta wrote:
> > From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
> >
> > The method to allocate and free FIB's in the present code utilizes
> > spinlocks.Multiple IO's have to wait on the spinlock to acquire or
> > free fibs creating a performance bottleneck.
> >
> > An alternative solution would be to use block layer tags to keep track
> > of the fibs allocated and freed. To this end 2 functions
> > aac_fib_alloc_tag and aac_fib_free_tag were created which utilize the
> > blk layer tags to plug into the Fib pool.These functions are used
> > exclusively in the IO path. 8 fibs are reserved for the use of AIF
> > management software and utilize the previous spinlock based
> > implementations.
> >


[....]

> >
> > @@ -166,6 +166,49 @@ int aac_fib_setup(struct aac_dev * dev)
> >   *	aac_fib_alloc	-	allocate a fib
> >   *	@dev: Adapter to allocate the fib for
> >   *
> > + *	Allocate a fib from the adapter fib pool using tags
> > + *	from the blk layer.
> > + */
> > +
> > +struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd
> *scmd)
> > +{
> > +	struct fib *fibptr;
> > +
> > +	fibptr = &dev->fibs[scmd->request->tag];
> > +	/*
> > +	 *	Set the proper node type code and node byte size
> > +	 */
> 
> Can't you just make most of the initialisation below just once when the driver
> starts?
> 
> > +	fibptr->type = FSAFS_NTC_FIB_CONTEXT;
> > +	fibptr->size = sizeof(struct fib);
> > +	/*
> > +	 *	Null out fields that depend on being zero at the start of
> > +	 *	each I/O
> > +	 */
> > +	fibptr->hw_fib_va->header.XferState = 0;
> > +	fibptr->flags = 0;
> 
> For example the flags field is initialised  here to '0', then
> in aac_fib_send again to zero and later is 'fibptr->flags =
> FIB_CONTEXT_FLAG;'
> Removing part of it would help I think.
> The code here is not new so, if I am right, please plan it for a next series.

I will look into it and see where the code is being duplicated and will remove it,
If it does not do anything new.

> 
> > +	fibptr->callback = NULL;
> > +	fibptr->callback_data = NULL;
> > +
> > +	return fibptr;
> > +}
> > +
> > +/**
> > + *	aac_fib_free_tag	free a fib
> > + *	@fibptr: fib to free up
> > + *
> > + *	Placeholder to free tag allocated fibs
> > + *	Does not do anything
> > + */
> > +
> > +void aac_fib_free_tag(struct fib *fibptr)
> > +{
> > +	(void)fibptr;
> > +}
> 
> I agree with Johannes, I also don't like the aac_fib_free_tag as it is.
> With the aac_fib_free_tag you may add -

The reason it is still there is that , future versions can use it to add 
something meaningful(set flags etc).I could remove it now since 
it serves no purpose

> Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Regards,
Raghava Aditya
