From: Rob Landley <rob@landley.net>
Subject: Re: What still uses the block layer?
Date: Sun, 14 Oct 2007 18:45:44 -0500
Message-ID: <200710141845.44750.rob@landley.net>
References: <200710112011.22000.rob@landley.net> <20071013220539.GD29934@parisc-linux.org> <1192400672.3351.56.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:40471
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbXJNXpu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Oct 2007 19:45:50 -0400
In-Reply-To: <1192400672.3351.56.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Sunday 14 October 2007 5:24:32 pm James Bottomley wrote:
> On Sat, 2007-10-13 at 16:05 -0600, Matthew Wilcox wrote:
> > On Thu, Oct 11, 2007 at 08:11:21PM -0500, Rob Landley wrote:
> > > My impression from asking questions on the linux-scsi mailing list is
> > > that the scsi upper/middle/lower layers doesn't use the block layer
> > > described in Documentation/block/*.
> >
> > Entirely incorrect.
>
> OK, right ... could we please get a sense of decorum back on this list.

Did I reply to the insult?

> Rob, if you didn't ask your alleged questions in such a pejorative
> manner, we'd get a lot further

I'm not attempting to be pejorative.

I admit a certain amount of personal annoyance that once the SCSI layer 
consumes a category of device (USB, SATA, PATA), they can often _only_ be 
used by going through the SCSI midlayer.  (This strikes me as analogous to 
TCP/IP claiming ethernet and PPP devices so thoroughly that you can no longer 
address them as eth1 or /dev/ttyS0.)

This has the annoying effect of bundling together different types of devices 
and making device enumeration unnecessarily difficult: my laptop only has one 
SATA hard drive and can't gain another without a soldering iron, but that 
drive could move from /dev/sda to /dev/sdb if I reboot the system with a USB 
key plugged in.  This seems like a regrettable loss of orthogonality to me.  
I remember back when /dev/usb0 and /dev/hda were separate devices that showed 
up in /dev, but these days "it's SCSI" seems to trump "it's USB", "it's ATA", 
or "it's SATA".  (Even though none of those are actually SCSI hardware, they 
just send a similar packet protocol across the wire.)

The fact that udev can theoretically unwind this hairball is not an excuse for 
conflating different categories of devices in the first place.  Avoiding an 
unnecessary problem seems superior to trying to get udev to solve it.  Note 
that Ubuntu 7.04 solves it by sticking a UUID on every _partition_, and then 
spinning up my external USB hard drive trying to find the root partition on a 
reboot.  Tell me how this can be considered progress:

> # /etc/fstab: static file system information.
> #
> # <file system> <mount point>   <type>  <options>       <dump>  <pass>
> proc            /proc           proc    defaults        0       0
> # /dev/sda1
> UUID=04d1b984-bd65-46f1-9a77-c158cf4bed1b /               ext3 
defaults,errors=remount-ro,noatime 0       1
> # /dev/sda5 
> UUID=cdf0936d-9f19-42c6-b131-9fefcf1321ef none            swap    sw        
0       0
> /dev/scd0       /media/cdrom0   udf,iso9660 user,noauto   0       0 
> UUID=86bbb512-ab7e-4a12-8618-1190f032c082  /boot ext3 defaults 0 0 

Conflating categories of hardware that cannot easily be enumerated (USB) with 
categories that can (the SATA hard drive in my laptop, of which there can be 
only one) strikes me as a bad thing.  Putting them in a common "scsi device 
pool" within which they do not enumerate consistently is not something I 
enjoy dealing with.

However, the response to my attempts to express this dissatisfaction on the 
SCSI list a few months ago came too close to a flamewar for me to consider 
continuing it productive.  I'd still love to update the "2.4 scsi howto" and 
corresponding sg howto, but lack the expertise.  The SCSI layer really isn't 
my area, and I was much happier back when I could avoid using it at all.

The question I was trying to ask _here_ was about the block layer.  I seem not 
to have asked it very well.  Sorry 'bout that.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
