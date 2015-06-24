From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH] st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO
Date: Thu, 25 Jun 2015 08:27:07 +0900
Message-ID: <20150624232707.GA3365@swordfish>
References: <DDB9C85B850785449757F9914A034FCB3F8E9DA4@G4W3219.americas.hpqcorp.net>
 <20150624062557.GA10808@swordfish>
 <20150624151011.GC7925@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:35904 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbFXX0j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2015 19:26:39 -0400
Content-Disposition: inline
In-Reply-To: <20150624151011.GC7925@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Greg KH <gregkh@linuxfoundation.org> (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Seymour, Shane M" <shane.seymour@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>

On (06/24/15 08:10), Greg KH <gregkh@linuxfoundation.org> (gregkh@linuxfoundation.org) wrote:
> On Wed, Jun 24, 2015 at 03:25:57PM +0900, Sergey Senozhatsky wrote:
> > On (06/24/15 06:10), Seymour, Shane M wrote:
> > [..]
> > >  
> > >  /* The sysfs driver interface. Read-only at the moment */
> > > -static ssize_t st_try_direct_io_show(struct device_driver *ddp, char *buf)
> > > +static ssize_t try_direct_io_show(struct device_driver *ddp, char *buf)
> > >  {
> > > -	return snprintf(buf, PAGE_SIZE, "%d\n", try_direct_io);
> > > +	return sprintf(buf, "%d\n", try_direct_io);
> > >  }
> > 
> > a nitpick,
> > 
> > per Documentation/filesystems/sysfs.txt
> > 
> > :
> > : - show() should always use scnprintf().
> > :
> 
> That should be rewritten to say, "don't use snprintf(), but scnprintf(),
> if you want to.  Otherwise sprintf() should be fine as you obviously are
> only returning a single value to userspace"
> 

Sure, that was just a nitpick. For '%d' it's totally fine, I agree.
It was more of a 'do we strictly obey the rules' thing.

	-ss
