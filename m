From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH 04/10] aacraid: Fix memory leak in aac_fib_map_free
Date: Sat, 5 Dec 2015 00:40:34 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1EF725@BBYEXM01.pmc-sierra.internal>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1448973589-9216-5-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <5661A493.90603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37039 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295AbbLEAkg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2015 19:40:36 -0500
In-Reply-To: <5661A493.90603@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Santosh Akula <Santosh.Akula@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Rich Bono <Rich.Bono@pmcs.com>

Hello Tomas,


> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Friday, December 4, 2015 6:35 AM
> To: Raghava Aditya Renukunta; JBottomley@Parallels.com; linux-
> scsi@vger.kernel.org
> Cc: Mahesh Rajashekhara; Murthy Bhat; Santosh Akula; Gana Sridaran;
> aacraid@pmc-sierra.com; Rich Bono
> Subject: Re: [PATCH 04/10] aacraid: Fix memory leak in aac_fib_map_free
> 
> On 1.12.2015 13:39, Raghava Aditya Renukunta wrote:
> > From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
> >
> > aac_fib_map_free() calls pci_free_consistent() without checking that
> > dev->hw_fib_va is not NULL and dev->max_fib_size is not zero.If they
> > are indeed NULL/0, this will result in a hang as pci_free_consistent()
> > will attempt to invalidate cache for the entire 64-bit address space
> > (which would take a very long time).
> >
> > Fixed by adding a check to make sure that dev->hw_fib_va and
> > dev->max_fib_size are not NULL and 0 respectively.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <raghavaaditya.renukunta@pmcs.com>
> 
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> 
> Is the can_queue constant during the driver's life, or is it possible
> to manipulate it (aac_change_queue_depth)?
> 
> Tomas

can_queue is only changed in aac_init_adapter. Do you want to save 
 (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) in a variable
So that the whole can_queue dereference need not be used?

Regards,
Raghava Aditya

> > ---
> >  drivers/scsi/aacraid/commsup.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/aacraid/commsup.c
> b/drivers/scsi/aacraid/commsup.c
> > index b257d3b..9533f47 100644
> > --- a/drivers/scsi/aacraid/commsup.c
> > +++ b/drivers/scsi/aacraid/commsup.c
> > @@ -83,9 +83,12 @@ static int fib_map_alloc(struct aac_dev *dev)
> >
> >  void aac_fib_map_free(struct aac_dev *dev)
> >  {
> > -	pci_free_consistent(dev->pdev,
> > -	  dev->max_fib_size * (dev->scsi_host_ptr->can_queue +
> AAC_NUM_MGT_FIB),
> > -	  dev->hw_fib_va, dev->hw_fib_pa);
> > +	if (dev->hw_fib_va && dev->max_fib_size) {
> > +		pci_free_consistent(dev->pdev,
> > +		(dev->max_fib_size *
> > +		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB)),
> > +		dev->hw_fib_va, dev->hw_fib_pa);
> > +	}
> >  	dev->hw_fib_va = NULL;
> >  	dev->hw_fib_pa = 0;
> >  }

