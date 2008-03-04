From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/7] mptbase: reset ioc initiator during PCI resume
Date: Tue, 4 Mar 2008 15:49:50 -0800
Message-ID: <20080304154950.09df861a.akpm@linux-foundation.org>
References: <200803042324.m24NOLWG003081@imap1.linux-foundation.org>
	<664A4EBB07F29743873A87CF62C26D70D555F3@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934785AbYCDXzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Mar 2008 18:55:31 -0500
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70D555F3@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, djwong@us.ibm.com, Sathya.Prakash@lsi.com

On Tue, 4 Mar 2008 16:30:24 -0700
"Moore, Eric" <Eric.Moore@lsi.com> wrote:

> On Tuesday, March 04, 2008 4:24 PM, Andrew Morton  wrote: 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > Cc: "Moore, Eric" <Eric.Moore@lsi.com>
> > Cc: <Sathya.Prakash@lsi.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/message/fusion/mptbase.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff -puN 
> > drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator-d
> > uring-pci-resume drivers/message/fusion/mptbase.c
> > --- 
> > a/drivers/message/fusion/mptbase.c~mptbase-reset-ioc-initiator
> > -during-pci-resume
> > +++ a/drivers/message/fusion/mptbase.c
> > @@ -1852,6 +1852,12 @@ mpt_resume(struct pci_dev *pdev)
> >  		(mpt_GetIocState(ioc, 1) >> MPI_IOC_STATE_SHIFT),
> >  		CHIPREG_READ32(&ioc->chip->Doorbell));
> >  
> > +	/* put ioc into READY_STATE */
> > +	if(SendIocReset(ioc, 
> > MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
> > +		printk(MYIOC_s_ERR_FMT
> > +		"pci-resume:  IOC msg unit reset failed!\n", ioc->name);
> > +	}
> > +
> >  	/* bring ioc to operational state */
> >  	if ((recovery_state = mpt_do_ioc_recovery(ioc,
> >  	    MPT_HOSTEVENT_IOC_RECOVER, CAN_SLEEP)) != 0) {
> > _
> >
> 
> Actually we have a different patch for this, which Sathya been working
> on.
> 

Will that be ready in time for 2.6.25?  If not, should we merge Darrick's
patch as an interrim thing?

And I assume that 2.6.24 has the same problem - what should we do there?

Thanks.
