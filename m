From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH ] drivers/base/bus.c - export reprobe
Date: Tue, 14 Mar 2006 09:19:51 -0800
Message-ID: <20060314171951.GA22678@suse.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F36D829@NAMAIL2.ad.lsil.com> <20060314153455.GA8071@suse.de> <20060314170855.GA18342@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl093-040-174.pdx1.dsl.speakeasy.net ([66.93.40.174]:62378
	"EHLO aria.kroah.org") by vger.kernel.org with ESMTP
	id S1750882AbWCNRUA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 12:20:00 -0500
Content-Disposition: inline
In-Reply-To: <20060314170855.GA18342@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, hch@lst.de

On Tue, Mar 14, 2006 at 05:08:55PM +0000, Christoph Hellwig wrote:
> On Tue, Mar 14, 2006 at 07:34:55AM -0800, Greg KH wrote:
> > Also, it looks like USB needs to call this function, (based on the
> > comment)?  Care to switch that code over to have it use it too?
> 
> what comment do you think indicates that?  It's needed for raid drivers
> that

I saw the:

+       if (dev->driver) {^M
+               if (dev->parent)        /* Needed for USB */^M
+                       down(&dev->parent->sem);^M

portion and thought it came from USB core code somewhere.  Or are you
referring to the need for USB-storage here?

> 
>   a) expose physical volumes but set the no_uld_attach flag to hide them
>      from sd
>   b) allow only raid volume creation/deletion so this flag may be set/cleared
>      at runtime

Ok, fair enough, just was a bit confused.

thanks,

greg k-h
