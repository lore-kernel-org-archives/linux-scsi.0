From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] fix cdrom mt rainier probe
Date: Fri, 16 Jul 2004 14:28:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040716122845.GE2025@suse.de>
References: <1089848082.3736.21.camel@patibmrh9> <1089938380.3667.19.camel@patibmrh9> <20040716122554.GD2025@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:61664 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266534AbUGPM2t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 08:28:49 -0400
Content-Disposition: inline
In-Reply-To: <20040716122554.GD2025@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 16 2004, Jens Axboe wrote:
> On Thu, Jul 15 2004, Pat LaVarre wrote:
> > 1) The first part changes cdrom_open to check CDC_RAM earlier in an
> > FMODE_WRITE open i.e. before open_for_data.  I'm asking you to choose to
> > check earlier or not.
> > 
> > 2) The second part draws your attention to a set_disk_ro I actually did
> > not delete.  That remaining set_disk_ro dynamically forces ro true in
> > response to particular write errors.  The /* != scsi/sr.c */ text of the
> > comment I used to draw you attention to that source line means to say
> > that this is an asymmetry between ide/ide-cd.c and scsi/sr.c, in that
> > only ide/ide-cd.c works this hard.  I'm asking you to choose to delete
> > that call to set_disk_ro, to comment on its asymmetry, or to leave it
> > unchanged.
> > 
> > 3, 4) The last two parts of the patch merely delete the once-per-plugin
> > calls to set_disk_ro.
> > 
> > Pat LaVarre
> > 
> > diff -urp linux-2.6.8-rc1/drivers/cdrom/cdrom.c linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c
> > --- linux-2.6.8-rc1/drivers/cdrom/cdrom.c	2004-07-13 08:26:02.000000000 -0600
> > +++ linux-2.6.8-rc1-pel/drivers/cdrom/cdrom.c	2004-07-15 18:21:48.564652904 -0600
> > @@ -892,13 +892,16 @@ int cdrom_open(struct cdrom_device_info 
> >  	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS)) {
> >  		ret = cdi->ops->open(cdi, 1);
> >  	} else {
> > +		if (fp->f_mode & FMODE_WRITE) {
> > +			ret = -EROFS;
> > +			if (!CDROM_CAN(CDC_RAM))
> > +				goto err;
> > +		}
> >  		ret = open_for_data(cdi);
> >  		if (ret)
> >  			goto err;
> >  		if (fp->f_mode & FMODE_WRITE) {
> >  			ret = -EROFS;
> > -			if (!CDROM_CAN(CDC_RAM))
> > -				goto err;
> >  			if (cdrom_open_write(cdi))
> >  				goto err;
> >  			ret = 0;
> 
> This looks strange - cdrom_open_write() is the one that checks whether
> the media is suitable for writing or not. In fact, it looks as if just
> transposing the two checks should be fine:
> 
>                 if (fp->f_mode & FMODE_WRITE) {
>                         ret = -EROFS;
>                         if (cdrom_open_write(cdi))
>                                 goto err;
>                         if (!CDROM_CAN(CDC_RAM))
>                                 goto err;
>                         ret = 0;
>                 }

Actually, looking at the above makes it clear that we should probably
just drop CDC_RAM again and just let cdrom_open_write() return whether
we are allowed to open the media for write or not. Now that CDC_RAM is
a per-media capability flag, it doesn't make sense to set/clear it on
every open when you can just return ok or not.

But that cleanup can be applied of this patch, so please just continue.

-- 
Jens Axboe

