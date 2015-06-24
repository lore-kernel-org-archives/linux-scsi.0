From: "Greg KH <gregkh@linuxfoundation.org> (gregkh@linuxfoundation.org)"
	<gregkh@linuxfoundation.org>
Subject: Re: [PATCH] st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO
Date: Wed, 24 Jun 2015 08:10:11 -0700
Message-ID: <20150624151011.GC7925@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3F8E9DA4@G4W3219.americas.hpqcorp.net>
 <20150624062557.GA10808@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54159 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbbFXPKM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2015 11:10:12 -0400
Content-Disposition: inline
In-Reply-To: <20150624062557.GA10808@swordfish>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: "Seymour, Shane M" <shane.seymour@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>

On Wed, Jun 24, 2015 at 03:25:57PM +0900, Sergey Senozhatsky wrote:
> On (06/24/15 06:10), Seymour, Shane M wrote:
> [..]
> >  
> >  /* The sysfs driver interface. Read-only at the moment */
> > -static ssize_t st_try_direct_io_show(struct device_driver *ddp, char *buf)
> > +static ssize_t try_direct_io_show(struct device_driver *ddp, char *buf)
> >  {
> > -	return snprintf(buf, PAGE_SIZE, "%d\n", try_direct_io);
> > +	return sprintf(buf, "%d\n", try_direct_io);
> >  }
> 
> a nitpick,
> 
> per Documentation/filesystems/sysfs.txt
> 
> :
> : - show() should always use scnprintf().
> :

That should be rewritten to say, "don't use snprintf(), but scnprintf(),
if you want to.  Otherwise sprintf() should be fine as you obviously are
only returning a single value to userspace"

Or something like that.

thanks,

greg k-h
