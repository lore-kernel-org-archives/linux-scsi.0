From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH 05/10] aacraid: Set correct msix count for EEH recovery
Date: Sat, 5 Dec 2015 00:15:47 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1EF704@BBYEXM01.pmc-sierra.internal>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1448973589-9216-6-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <56619ED3.40409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:35145 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932150AbbLEAPu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2015 19:15:50 -0500
In-Reply-To: <56619ED3.40409@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Santosh Akula <Santosh.Akula@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Rich Bono <Rich.Bono@pmcs.com>

Hello Tomas,

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Friday, December 4, 2015 6:10 AM
> To: Raghava Aditya Renukunta; JBottomley@Parallels.com; linux-
> scsi@vger.kernel.org
> Cc: Mahesh Rajashekhara; Murthy Bhat; Santosh Akula; Gana Sridaran;
> aacraid@pmc-sierra.com; Rich Bono
> Subject: Re: [PATCH 05/10] aacraid: Set correct msix count for EEH recovery
> 
> On 1.12.2015 13:39, Raghava Aditya Renukunta wrote:
> > From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
> >
> > During EEH recovery number of online CPU's might change thereby
> changing
> > the number of MSIx vectors. Since each fib is allocated to a vector,
> > changes in the number of vectors causes fib to be sent thru invalid
> > vectors.In addition the correct number of MSIx vectors is not
> > updated in the INIT struct sent to the controller, when it is
> > reinitialized.
> >
> > Fixed by reassigning vectors to fibs based on the updated number of MSIx
> > vectors and updating the INIT structure before sending to controller.
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <raghavaaditya.renukunta@pmcs.com>
> > ---
> >  drivers/scsi/aacraid/linit.c | 25 ++++++++++++++++++++++++-
> >  1 file changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> > index 0147210..f88f1132 100644
> > --- a/drivers/scsi/aacraid/linit.c
> > +++ b/drivers/scsi/aacraid/linit.c
> > @@ -1355,6 +1355,7 @@ static int aac_acquire_resources(struct aac_dev
> *dev)
> >  	int i, j;
> >  	int instance = dev->id;
> >  	const char *name = dev->name;
> > +	int vector = 0;
> >  	unsigned long status;
> >  	/*
> >  	 *	First clear out all interrupts.  Then enable the one's that we
> > @@ -1409,9 +1410,31 @@ static int aac_acquire_resources(struct aac_dev
> *dev)
> >  	}
> >
> >  	aac_adapter_enable_int(dev);
> > +	/*max msix may change  after EEH
> > +	 * Re-assign vectors to fibs
> > +	 */
> > +	 for (i = 0;
> > +		i < (dev->scsi_host_ptr->can_queue +
> AAC_NUM_MGT_FIB);
> > +		i++) {
> > +		if ((dev->max_msix == 1) ||
> > +		   (i > ((dev->scsi_host_ptr->can_queue +
> AAC_NUM_MGT_FIB - 1)
> > +			- dev->vector_cap))) {
> > +			dev->fibs[i].vector_no = 0;
> > +		} else {
> > +			dev->fibs[i].vector_no = vector;
> > +			vector++;
> > +			if (vector == dev->max_msix)
> > +				vector = 1;
> > +		}
> > +	}
> 
> The above hunk added code looks identical to the part you have just added
> in 02/10 "aacraid: Fix RRQ overload" could you make this to function ?
> Thanks, tomash

Yes, I will make the necessary changes.
> >
> > -	if (!dev->sync_mode)
> > +	if (!dev->sync_mode) {
> > +		/* After EEH recovery or suspend resume, max_msix count
> > +		 * may change, therfore updating in init as well.
> > +		 */
> >  		aac_adapter_start(dev);
> > +		dev->init->Sa_MSIXVectors = cpu_to_le32(dev->max_msix);
> > +	}
> >  	return 0;
> >
> >  error_iounmap:

Regards,
Raghava Aditya
