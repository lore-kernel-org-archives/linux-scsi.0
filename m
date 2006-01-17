From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] fusion - setting timeouts in eh threads appropiatley for fc/sas/spi
Date: Tue, 17 Jan 2006 16:48:42 +0000
Message-ID: <20060117164842.GA13211@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAD12@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:8429 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932174AbWAQQso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 11:48:44 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAD12@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Tue, Jan 17, 2006 at 09:13:57AM -0700, Moore, Eric wrote:
> On Tuesday, January 17, 2006 6:43 AM,  Christoph Hellwig wrote:
> 
> > The timeout selection should probably be done in a little 
> > helper instead
> > of duplicated in a few places.  Updated patch below:
> > 
> > 
> > Index: linux-2.6/drivers/message/fusion/mptscsih.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/message/fusion/mptscsih.c	
> > 2006-01-17 14:07:57.000000000 +0100
> > +++ linux-2.6/drivers/message/fusion/mptscsih.c	
> > 2006-01-17 14:10:55.000000000 +0100
> > @@ -1719,6 +1719,20 @@
> >  	return retval;
> >  }
> >  
> > +static int
> > +mptscsih_get_tm_timeout(MPT_ADAPTER *ioc)
> > +{
> > +	switch (ioc->bus_type) {
> > +	case FC:
> > +		return 40;
> > +	case SAS:
> > +		return 10;
> > +	case SPI:
> > +	default:
> > +		return 2;
> > +	}
> > +}
> > +
> >  
> 
> Good idea to combine everything into mptscsih_get_tm_timeout.
> However the SPI timeout is 2 seconds for eh_abort_handler,
> and 5 seconds for eh_device_reset_handler and eh_bus_reset_handler. 
> It would be better to go with 5 seconds in the SPI case, as the
> driver timeout needs to be be longer than the firmware timeout.

Ok.  I don't think three seconds additional wait time in the abort
handler should be much of a problem.

