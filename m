From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 09:10:49 -0400
Message-ID: <1192453849.6368.26.camel@localhost.localdomain>
References: <200710112011.22000.rob@landley.net>
	 <20071013220539.GD29934@parisc-linux.org>
	 <1192400672.3351.56.camel@localhost.localdomain>
	 <200710141845.44750.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764721AbXJONLD@vger.kernel.org>
In-Reply-To: <200710141845.44750.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@oracle.com>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2007-10-14 at 18:45 -0500, Rob Landley wrote:
> On Sunday 14 October 2007 5:24:32 pm James Bottomley wrote:
> > On Sat, 2007-10-13 at 16:05 -0600, Matthew Wilcox wrote:
> > > On Thu, Oct 11, 2007 at 08:11:21PM -0500, Rob Landley wrote:
> > > > My impression from asking questions on the linux-scsi mailing list is
> > > > that the scsi upper/middle/lower layers doesn't use the block layer
> > > > described in Documentation/block/*.
> > >
> > > Entirely incorrect.
> >
> > OK, right ... could we please get a sense of decorum back on this list.
> 
> Did I reply to the insult?
> 
> > Rob, if you didn't ask your alleged questions in such a pejorative
> > manner, we'd get a lot further
> 
> I'm not attempting to be pejorative.

OK, so could we get back to the original discussion?  The question I
think you meant to ask is "does SCSI use the block layer, and if so;
how?"

The answer is yes (just do an ls /sys/block on any scsi machine).  The
how is that it bascially uses the block layer as a service library (i.e.
most SCSI services are built on top of those already provided by block).
The email you cited was basically from our one area of confusion:  SCSI
and block both provide services to decode the SG_IO ioctl.  This is
partly historical; block and SCSI are very much intertwined; so much so
that they both tend to drive each other's development.  The programme
over the last few years has been to identify features in SCSI that
should be more generic (and hence moved to block).  SG_IO is one of
these, so we end up with the situation where Block provides this as a
service (and sr, st and sd make use of it) while the sg driver still
doesn't use what the block layer provides but rolls its own.  I think
the layout of how all this works is illustrated at a reasonably high
level here on slide 15:

http://licensing.steeleye.com/support/papers/ols_2005_slides.pdf


> I admit a certain amount of personal annoyance that once the SCSI layer 
> consumes a category of device (USB, SATA, PATA), they can often _only_ be 
> used by going through the SCSI midlayer.  (This strikes me as analogous to 
> TCP/IP claiming ethernet and PPP devices so thoroughly that you can no longer 
> address them as eth1 or /dev/ttyS0.)

OK.  But that's the bit I need you to separate from your inquiry into
how SCSI actually works.  You can't go on a research trip if you allow
preconceived notions to spill over into it.

For the record, USB and firewire are SCSI at their core, so they can
never really be separated.  SATA (but not SATAPI) is a separate
protocol, so it can theoretically be separated later, and we are
actually working on that.  It's only in SCSI because there's a well
defined and standardised way to place it their (called the SAT
layer---SCSI to ATA Translation) and because it's a lot easier since
SCSI has all the features and quite a few of the necessary ones aren't
yet migrated to block.

> This has the annoying effect of bundling together different types of devices 
> and making device enumeration unnecessarily difficult: my laptop only has one 
> SATA hard drive and can't gain another without a soldering iron, but that 
> drive could move from /dev/sda to /dev/sdb if I reboot the system with a USB 
> key plugged in.  This seems like a regrettable loss of orthogonality to me.  
> I remember back when /dev/usb0 and /dev/hda were separate devices that showed 
> up in /dev, but these days "it's SCSI" seems to trump "it's USB", "it's ATA", 
> or "it's SATA".  (Even though none of those are actually SCSI hardware, they 
> just send a similar packet protocol across the wire.)
> 
> The fact that udev can theoretically unwind this hairball is not an excuse for 
> conflating different categories of devices in the first place.  Avoiding an 
> unnecessary problem seems superior to trying to get udev to solve it.  Note 
> that Ubuntu 7.04 solves it by sticking a UUID on every _partition_, and then 
> spinning up my external USB hard drive trying to find the root partition on a 
> reboot.  Tell me how this can be considered progress:
> 
> > # /etc/fstab: static file system information.
> > #
> > # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> > proc            /proc           proc    defaults        0       0
> > # /dev/sda1
> > UUID=04d1b984-bd65-46f1-9a77-c158cf4bed1b /               ext3 
> defaults,errors=remount-ro,noatime 0       1
> > # /dev/sda5 
> > UUID=cdf0936d-9f19-42c6-b131-9fefcf1321ef none            swap    sw        
> 0       0
> > /dev/scd0       /media/cdrom0   udf,iso9660 user,noauto   0       0 
> > UUID=86bbb512-ab7e-4a12-8618-1190f032c082  /boot ext3 defaults 0 0 
> 
> Conflating categories of hardware that cannot easily be enumerated (USB) with 
> categories that can (the SATA hard drive in my laptop, of which there can be 
> only one) strikes me as a bad thing.  Putting them in a common "scsi device 
> pool" within which they do not enumerate consistently is not something I 
> enjoy dealing with.

However, by design choice, we got the SCSI layer in the kernel out of
the business of trying to provide a stable name space, since Richard
Gooch did a brilliant job of demonstrating the insoluability of that
problem.  There are many ways to identify a device (UUID being just one
of them).  It seems much more desirable to give the users the choice.
You can even have what you seem to want (SATA stably at /dev/sda) simply
by ensuring that you have a modular kernel and that libata always loads
before USB or any other storage device (not that I'd recommend doing
this, because it will fail for a large configuration, but it would work
for you).

> However, the response to my attempts to express this dissatisfaction on the 
> SCSI list a few months ago came too close to a flamewar for me to consider 
> continuing it productive.  I'd still love to update the "2.4 scsi howto" and 
> corresponding sg howto, but lack the expertise.  The SCSI layer really isn't 
> my area, and I was much happier back when I could avoid using it at all.

That was because your initial inquiry came across as "I'm trying to
document this, and by the way it's rubbish".  By all means have an
inquiry and an argument, but saying effectively I don't understand this
but I know it's wrong is a guaranteed way to antagonise everyone who's
worked to try to make all of this as functional as possible.  Find out
the facts first then argue from them.

> The question I was trying to ask _here_ was about the block layer.  I seem not 
> to have asked it very well.  Sorry 'bout that.

OK, so look at the diagram and the other SCSI documents and come back
for further clarification as you need it.

James
