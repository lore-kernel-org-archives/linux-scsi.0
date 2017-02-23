From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: Advanced Format SAT devices show incorrect physical block size
Date: Thu, 23 Feb 2017 10:03:36 +0100
Message-ID: <20170223090336.GA24201@pali>
References: <Pine.LNX.4.44L0.1701301055100.2025-100000@iolanthe.rowland.org>
 <201701301843.12242@pali>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:33225 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbdBWJEh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 04:04:37 -0500
Content-Disposition: inline
In-Reply-To: <201701301843.12242@pali>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Dainius =?utf-8?Q?Masili=C5=ABnas?= <pastas4@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Tom Yan <tom.ty89@gmail.com>

On Monday 30 January 2017 18:43:12 Pali Rohár wrote:
> On Monday 30 January 2017 17:17:03 Alan Stern wrote:
> > On Sun, 29 Jan 2017, Pali Rohár wrote:
> > > On Wednesday 11 January 2017 16:23:29 Alan Stern wrote:
> > > > On Tue, 10 Jan 2017, James Bottomley wrote:
> > > > > On Tue, 2017-01-10 at 16:00 -0500, Alan Stern wrote:
> > > > > > In theory, I suppose we could change the kernel so that it
> > > > > > would default to READ CAPACITY(16) for devices that report a
> > > > > > SCSI level
> > > > > > 
> > > > > > >= 3, or something along those lines.  In general we hesitate
> > > > > > >to
> > > > > > 
> > > > > > make changes of this sort, because they almost always end up
> > > > > > breaking _some_ devices -- and if that happens then the
> > > > > > change is reverted, with no exceptions.  Linus has a very
> > > > > > strict rule about not breaking working systems.
> > > > > 
> > > > > You shouldn't have to change anything: it already does
> > > > > (otherwise how else would we detect physical exponent for
> > > > > proper SCSI devices) see sd.c:sd_try_rc16_first().  It always
> > > > > returns false for USB because you set sdev->try_rc_10_first
> > > > 
> > > > In fact, this approach probably won't work.  See Bugzilla entries
> > > > #43265 and #43391.  The devices in those reports claimed to be
> > > > ANSI level 4, but they failed anyway.
> > > 
> > > Seems those devices return capacity 0x7F000000000001 or
> > > 0xFF000000000001 Maybe there is some error pattern?
> > 
> > As far as I can tell, they both reported 0xFF000000000001.  That's a
> > pattern -- unless somebody really does have a storage device that
> > large (18 exabytes).  For the time being, perhaps we can ignore this
> > possibility.
> > 
> > > > If you guys want to try the quirk flag, you can apply the patch
> > > > below. Then set the usb-storage module parameter
> > > > quirks=vvvv:pppp:k where vvvv and pppp are the Vendor and
> > > > Product ID codes for your device (as 4 hex digits).
> > > > 
> > > > In the long run, however, this is not a viable approach.  We'd be
> > > > better off with an explicit blacklist.
> > > 
> > > Ok, so what are next steps? I think that explicit blacklist would
> > > be needed if "bad" devices is less.
> > > 
> > > How many bug reports were there?
> > 
> > I don't know.
> > 
> > Anyway, please try out the patch below.  I don't know if it will be
> > acceptable to the SCSI maintainers, but we should at least make sure
> > it fixes your problem before submitting it.
> 
> I'm not original reporter of this problem.
> 
> Dainius, can you test it?

Just want to remind this patch so it will not be forgotten...

> > Alan Stern
> > 
> > 
> > 
> > 
> > Index: usb-4.x/drivers/scsi/sd.c
> > ===================================================================
> > --- usb-4.x.orig/drivers/scsi/sd.c
> > +++ usb-4.x/drivers/scsi/sd.c
> > @@ -2157,6 +2157,13 @@ static int read_capacity_16(struct scsi_
> >  		return -ENODEV;
> >  	}
> > 
> > +	/* Some buggy devices report an impossibly large size */
> > +	if (lba >= (1ULL << 54)) {
> > +		sd_printk(KERN_WARNING, sdkp, "Read Capacity(16) returned excessively large value: %llu", lba);
> > +		sdkp->capacity = 0;
> > +		return -EINVAL;
> > +	}
> > +
> >  	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
> >  		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
> >  			"kernel compiled with support for large block "
> > Index: usb-4.x/drivers/usb/storage/scsiglue.c
> > ===================================================================
> > --- usb-4.x.orig/drivers/usb/storage/scsiglue.c
> > +++ usb-4.x/drivers/usb/storage/scsiglue.c
> > @@ -247,8 +247,11 @@ static int slave_configure(struct scsi_d
> >  		 * Tell the SCSI layer to try READ_CAPACITY_10 first.
> >  		 * However some USB 3.0 drive enclosures return capacity
> >  		 * modulo 2TB. Those must use READ_CAPACITY_16
> > +		 *
> > +		 * Assume SPC3 or later devices can handle READ_CAPACITY_16.
> >  		 */
> > -		if (!(us->fflags & US_FL_NEEDS_CAP16))
> > +		if (sdev->scsi_level <= SCSI_SPC_2 &&
> > +				!(us->fflags & US_FL_NEEDS_CAP16))
> >  			sdev->try_rc_10_first = 1;
> > 
> >  		/* assume SPC3 or latter devices support sense size > 18 */
> 

-- 
Pali Rohár
pali.rohar@gmail.com
