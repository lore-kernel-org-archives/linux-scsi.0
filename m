From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [V2 PATCH 3/4] scsi:stex.c Add reboot support
Date: Fri, 14 Nov 2014 17:03:42 -0800
Message-ID: <20141115010342.GA5933@kroah.com>
References: <5462D62C.50602@gmail.com>
 <20141112172750.GB18862@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141112172750.GB18862@infradead.org>
Sender: linux-pm-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Charles Chiou <ch1102chiou@gmail.com>, JBottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 12, 2014 at 09:27:50AM -0800, Christoph Hellwig wrote:
> > +static int stex_reboot_callback(struct notifier_block *self,
> > +							  unsigned long val,
> > +							  void *data)
> > +{
> > +	if (val == SYS_RESTART)
> > +		isRestart = 1;
> > +	return NOTIFY_OK;
> > +}
> > 
> > @@ -1832,7 +1859,14 @@ static void stex_shutdown(struct pci_dev *pdev)
> >  {
> >  	struct st_hba *hba = pci_get_drvdata(pdev);
> > 
> > -	stex_hba_stop(hba);
> > +	if (hba->yellowstone == 1)
> > +		stex_hba_stop(hba, ST_IGNORED);
> > +	else {
> > +		if (isRestart)
> > +			stex_hba_stop(hba, ST_S6);
> > +		else
> > +			stex_hba_stop(hba, ST_S5);
> > +	}
> 
> This sort of check for reboot vs restart isn't really something
> we want in drivers.  I don't really know how we could find this
> out assuming we even want drivers to behave differently.
> 
> Maybe Greg or someone on lkml has an idea how to best handle this case.

What is "this case"?

And yes, I agree, we shouldn't care, in drivers, about reboot vs.
restart, as they should both be the same thing, along with "disconnect",
right?

thanks,

greg k-h
