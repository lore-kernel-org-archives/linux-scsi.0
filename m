From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Correct some mistakes in drivers using the scsi hotplug model
Date: Tue, 31 Jul 2007 08:52:28 -0600
Message-ID: <20070731145227.GP21219@parisc-linux.org>
References: <20070731125510.GN21219@parisc-linux.org> <1185892945.3468.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60795 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435AbXGaOw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 10:52:29 -0400
Content-Disposition: inline
In-Reply-To: <1185892945.3468.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jul 31, 2007 at 09:42:25AM -0500, James Bottomley wrote:
> Rather than changing this in every 53c700 based driver, shouldn't it
> just be added to NCR_700_release()?

Then I'd have to change the few drivers that weren't leaking scsi_hosts
;-)  But I can, if that's what you prefer.

> > diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> > index 85f2394..27acef4 100644
> > --- a/drivers/scsi/aha152x.c
> > +++ b/drivers/scsi/aha152x.c
> > @@ -907,6 +907,7 @@ void aha152x_release(struct Scsi_Host *shpnt)
> >  	if(!shpnt)
> >  		return;
> >  
> > +	scsi_remove_host(shpnt);
> >  	if (shpnt->irq)
> >  		free_irq(shpnt->irq, shpnt);
> 
> and this one needs to go via Boaz ... he's currently rewriting this
> driver.

OK.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
