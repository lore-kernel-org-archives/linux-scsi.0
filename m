From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Errors on USB-storage device are ignored.
Date: Mon, 20 Aug 2007 10:37:23 +0200
Message-ID: <20070820083723.GD21438@bitwizard.nl>
References: <20070816145817.GA24105@bitwizard.nl> <20070820060946.GE9867@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:47989 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755460AbXHTIh0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Aug 2007 04:37:26 -0400
Content-Disposition: inline
In-Reply-To: <20070820060946.GE9867@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: usb-storage@lists.one-eyed-alien.net, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Sun, Aug 19, 2007 at 11:09:46PM -0700, Matthew Dharm wrote:
> Off the cuff, this really looks like something for the SCSI layer.  I'll
> bet there are SCSI devices that do something similar...
> 
> And, I'm generally reluctant to modify the data to/from a device unless
> usb-storage *really* has to in order to make it work....

I fully agree, but as the scsi layer has been in existance almost 10
years longer than USB-storage, and that nobody seems to have encountered
a device requesting auto-sense, and then reporting no error, I would
say this is just a classical: "shitty USB implementation". 



The reverse situation is also probelematic. If a device happens to
occasionally request an autosense, but perhaps the problem solves
itself before the sense request comes through, then it might report
"no error". If that is actually true, for some SCSI harddisks, then
changing this at the scsi layer will make those harddrives report an
IO error every now and then, which is spurious. 

That is why I chose to implement it at the lowest possible level, 
as close as possible to the known non-conformant device. 

Yes, I've generalized to: "Maybe there are other USB-IDE converters
that may make this mistake", but won't go as far as: "Maybe there
are other SCSI devices that make this mistake". 

	Roger. 

 
> 
> Matt
> 
> On Thu, Aug 16, 2007 at 04:58:17PM +0200, Rogier Wolff wrote:
> > 
> > Hi,
> > 
> > I have an usb-storage enclosure that houses a normal desktop 
> > harddrive. I have been wondering why disks in that enclosure 
> > seemed to be  having less errors than when connected to a 
> > normal IDE connector. 
> > 
> > The reason is: USB-storage is ignoring a hint that something is
> > wrong. Probably my enclosure is also not completely following specs, 
> > but Linux is ignoring the hint as well.... 
> > 
> > On hitting a bad block, the disk reports error. The USB converter
> > then reports "auto-sense-required", and this is carried out. However
> > at this point, my USB enclosure returns all-zeroes. This is
> > considered non-fatal by the kernel. 
> > 
> > I'm guessing not many people are testing these things with 
> > bad drives. So, I don't know wether or not other USB converters
> > handle this situation more gracefully. 
> > 
> > As a patch, I've decided to set the sense key to "vendor specific"
> > (9), and then no "additional sense" (0:0), if, and only if the device
> > didn't return any valid sense info. 
> > 
> > The rest of the kernel then correctly interprets the situation
> > as an IO error. 
> > 
> > 	Roger Wolff. 
> > 
> > --- linux-2.6.20.3.clean/drivers/usb/storage/transport.c	2007-03-13 19:27:08.000000000 +0100
> > +++ linux-2.6.20.3.kostunrix/drivers/usb/storage/transport.c	2007-08-16 16:47:00.000000000 +0200
> > @@ -629,6 +629,14 @@
> >  
> >  		/* let's clean up right away */
> >  		memcpy(srb->sense_buffer, us->sensebuf, US_SENSE_SIZE);
> > +		if (((srb->sense_buffer[2]&0xf) == 0) &&
> > +		    (srb->sense_buffer[12] == 0) &&
> > +		    (srb->sense_buffer[13] == 0)) {
> > +			/* Hmmmmm. The device requested sense, but then
> > +			   declined to give us more info.... -- REW */ 
> > +			srb->sense_buffer[2] |= 0x09; /* Vendor specific */
> > +		}
> > +
> >  		srb->resid = old_resid;
> >  		srb->request_buffer = old_request_buffer;
> >  		srb->request_bufflen = old_request_bufflen;
> > 
> > 
> > 
> > -- 
> > ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
> > **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
> > *-- BitWizard writes Linux device drivers for any device you may have! --*
> > Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
> > Does it sit on the couch all day? Is it unemployed? Please be specific! 
> > Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
> 
> -- 
> Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.net 
> Maintainer, Linux USB Mass Storage Driver
> 
> G:  Money isn't everything, A.J.
> AJ: Who convinced you of that?
> G:  The Chief, at my last salary review.
> 					-- Mike and Greg
> User Friendly, 11/3/1998



-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
