From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] qla1820 iomem annotations
Date: Thu, 21 Oct 2004 16:14:06 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021151406.GB24336@parcelfarce.linux.theplanet.co.uk>
References: <20041020235837.GC23987@parcelfarce.linux.theplanet.co.uk> <20041021090032.GA1941@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9101 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270758AbUJUPOH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 11:14:07 -0400
Content-Disposition: inline
In-Reply-To: <20041021090032.GA1941@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-scsi@vger.kernel.org

On Thu, Oct 21, 2004 at 10:00:32AM +0100, Christoph Hellwig wrote:
> This breaks old-style PIO support in this driver which is required for the
> Visual Workstations.

Where?  __iomem is #defined to nothing for gcc.  So that leaves only
the chunk below as theoretically possible source of changes, right?

> > @@ -2773,13 +2773,14 @@
> >  static int
> >  qla1280_mailbox_command(struct scsi_qla_host *ha, uint8_t mr, uint16_t *mb)
> >  {
> > -	struct device_reg *reg = ha->iobase;
> > +	struct device_reg __iomem *reg = ha->iobase;
> >  #if 0
> >  	LIST_HEAD(done_q);
> >  #endif
> >  	int status = 0;
> >  	int cnt;
> >  	uint16_t *optr, *iptr;
> > +	uint16_t __iomem *mptr;
> >  	uint16_t data;
> >  	DECLARE_COMPLETION(wait);
> >  	struct timer_list timer;
> > @@ -2796,15 +2797,15 @@
> >  	 * available before starting sending the command data
> >  	 */
> >  	/* Load mailbox registers. */
> > -	optr = (uint16_t *) &reg->mailbox0;
> > +	mptr = (uint16_t __iomem *) &reg->mailbox0;
> >  	iptr = mb;
> >  	for (cnt = 0; cnt < MAILBOX_REGISTER_COUNT; cnt++) {
> >  		if (mr & BIT_0) {
> > -			WRT_REG_WORD(optr, (*iptr));
> > +			WRT_REG_WORD(mptr, (*iptr));
> >  		}
> >  
> >  		mr >>= 1;
> > -		optr++;
> > +		mptr++;
> >  		iptr++;
> >  	}

Now let's look at the function in question; the next place where optr is
used is
        /* Load return mailbox registers. */
        optr = mb;

so what we had was

	optr = (uint16_t *) &reg->mailbox0;
	iptr = mb;
	<loop using and modifying optr>
	<code never using optr>
	optr = mb;

Since optr is never used between the end of loop and reassignment, the code
above is equivalent to
	{
		uint16_t *foo = optr;
		optr = (uint16_t *) &reg->mailbox0;
		iptr = mb;
		<loop using and modifying optr>
		optr = foo;
		<code never using optr>
	}
	optr = mb;
which is, in turn, equivalent to
	{
		uint16_t *bar;
		bar = (uint16_t *) &reg->mailbox0;
		iptr = mb;
		<loop using and modifying optr> with s/optr/bar/
		<code never using optr>
	}
	optr = mb;

s/bar/mptr/ and lift its declaration to the top of function and that's
what we have now.
