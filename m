From: Rob Landley <rob@landley.net>
Subject: Re: Some quick scsi documentation questions:
Date: Fri, 3 Aug 2007 17:11:26 -0400
Message-ID: <200708031611.26768.rob@landley.net>
References: <200707252328.28981.rob@landley.net> <200708022055.45523.rob@landley.net> <46B306CD.3030002@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35090
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756290AbXHCVNL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 17:13:11 -0400
In-Reply-To: <46B306CD.3030002@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Friday 03 August 2007 5:43:25 am Stefan Richter wrote:
> Rob Landley wrote:
> > On Thursday 02 August 2007 5:19:51 pm Stefan Richter wrote:
> >> Alternatively to partition labels, you can also have udev create
> >> persistently named symlinks for you.
> >
> > A) You never need to label the _partition_, you need to consistently
> > identify the _device_ and the partitions fall out from that.
> >
> > landley@dell:/$ cat /sys/block/sr0/device/model
> > CDRWDVD DW224EV
> > landley@dell:/$ cat /sys/block/sda/device/model
> > Hitachi HTS54161
> >
> > Why exactly do I need a uuid to identify either of these when I only have
> > one of each in the system and _know_ I'll never have more than that?
>
> If there is only have one device of a kind, then there is no UUID needed
> for anything in the first place.

Yeah, but optimizing for common cases is still something they're working on, 
it seems.  (The perfect being the enemy of the good and all that: but what if 
someone does whip out a soldering iron and hotplug a second sata drive into 
my laptop!  Gotta be prepared...)

> Besides, then you also don't need to map between the sd or sr device and
> the sg device.  You can and should do the generic IO through the sd and
> sr devices nowadays.

Good to know.  So an sg device is for something like a scanner that doesn't 
present a block device?

> > (Sure go
> > for a uuid when there's more than one hard drive.  But please explain to
> > me how a uuid would help if I had two identical DVD burners with no media
> > in them on bootup...)
>
> In case of FireWire drives and several other types of drives (I believe
> also in case of SATA devices) there is a UUID tied to the *drive* too,
> alongside UUIDs of the media.

I can't find it under /sys/block/sda or device under that.  I can find "model" 
and "vendor", but that's about it.  (I can't even get anything to admit it's 
sata vs firewire.  The vendor for the hard drive is "ATA" but the vendor for 
the dvd is "TEAC", and they're both sata devices on the spec sheet...)

> > B) This particular device can't move without a screwdriver, and you can't
> > add another sata drive to this laptop without a soldering iron.
>
> And how is software supposed to know that?

Well, if all else fails I can tell it at install time.  (Well, re-install time 
in this case.  This is one of those Dell machines that comes pre-imaged with 
Linux, but they put a 32 bit version on a machine with a 64 bit processor.  
Haven't gotten around to reinstalling yet.)

However, for some common types of hardware like ATA and SATA, "not moving" is 
the default case.  There are such things as external SATA enclosures, but 
they're A) few and far between, B) technically different hardware often 
throwing in the towel and slapping USB on the external drive, ala:
http://www.cooldrives.com/sata-enclosure.html

In 99.x% of systems with SATA hard drives, said drives are sealed inside the 
machine, whether it's a laptop or a server.  USB can move around between 
boots (or with the power on) as a matter of course, but SATA really isn't 
designed for that or expected to do that.

> > The fact that modern Linux kernels can't consistently identify it during
> > bootup is a design flaw.
>
> Do you mean the Linux OS or the Linux kernel?

As someone who used ATA drives for 10 years before this became a problem, and 
is now using a SATA drive inside a laptop in a configuration Dell (ok, 
Quanta) churns out by the millions, I consider it a design flaw in the scsi 
layer that anything that goes through the scsi layer loses its original 
identity.

There have been numerous proposals to compensate for the scsi layer's 
renumbering with udev rules, but at least two of the most widely used 
distributions are still doing them wrong, so it's apparently not a trivial 
problem to recover from.

> > (Yes, I followed the discussion of all this years
> > ago, but the fact remains that there are certain very common types of
> > hardware that only get confused by things like USB keys because both the
> > USB keys, which may speak a scsi-like protocol but aren't actually scsi
> > hardware, and SATA drives, ditto, get routed into the same scsi layer
> > heap and conflated.  And that's sad.
>
> Harddisks are harddisks, CD-ROMs are CD-ROMs, scanners are scanners, no
> matter how they are attached.  At least as far as the commands are
> concerned that software sends to them.  I say that's a good thing.

You can reliably enumerate ATA and SATA.  You cannot reliably enumerate USB.  
Lumping SATA and USB together means you can't reliably enumerate either of 
them, which is an artificial problem invented by lumping them together.

> Sure, the type of attachment may be interesting to know for device file
> naming, see below.

It is, yes.

> >> The udev rules I have here (Gentoo's) apparently don't do this for
> >> CD/DVD-ROM/R/Ws although that should be possible as well.
> >
> > Many things are possible.  It doesn't make them a good idea.  Telling
> > udev to do something complicated to keep track of a device that I know,
> > at OS install time, _can't_ever_physically_move_, is one of them.
>
> There is a variety of possible naming schemes:
>
>   - Naming by order of discovery.
>   - Naming by vendor/model name strings.
>   - Naming by universally unique identifier.
>   - Naming by topology.
>   - ...

See "I followed the discussion of all this years ago"...

> Only the simplest of these schemes (naming by order of discovery) is
> hardwired into the kernel portion of the Linux OS.

The issue you're ignoring when you talk about "order of discovery" is that the 
first Sata drive and the first USB drive are lumped into the same sequence.  
The sata drives can't move, but I have an external USB drive that may or may 
not be plugged in at boot time.  The fact that the presence or absence of a 
USB drive can change the names assigned to the SATA drives is a loss of 
orthogonality caused by the SCSI layer.  I consider this a design flaw, and 
migrating the ATA drives to do this was a regression.

> The other naming  
> schemes are (or can be) implemented in the userland portion of the Linux
> OS.

Userland can work around the scsi layer, yes.

> There is only the most primitive naming scheme implemented in the kernel
> because naming policy, like most other kinds of policy, is better left
> to userland.  The kernel is a too restricted framework to implement such
> things.  The kernel lacks runtime-configuration files, scripting
> interfaces, et cetera.

/dev/hdc staying put when you removed or inserted a /dev/hdb was nice.  It 
worked well for 15 years.

Not _all_ hardware is hotpluggable, and ignoring this knowledge during device 
enumeration is silly.

> >> On the other
> >> hand, application programs like K3B already nicely show devices with
> >> vendor and model strings.  I don't know how much effort that imposes on
> >> the application programs.
> >
> > See above, but notice that Greg KH says that any program that follows
> > the "device" symlink is buggy,
>
> K3B doesn't use sysfs for that.  It most certainly uses SG IO (SCSI
> generic IO) to figure out these names.

Good to know.  I haven't read far enough through the scsi docs to see how to 
do that yet.  (I just moved, still catching up.)  Can I get back to you when 
I have?

> > because he doesn't want to be tied down to anything as mundane as a
> > stable userspace API.
>
> Sysfs is designed to be unstable;

Unstable, yes.  "Designed" may be too strong a word here...

> see my answer to your other post. 
> Sysfs (most of it) does not belong to the stable userspace ABIs of the
> kernel.

I currently view the scsi layer as a weird sort of networking stack.  Although 
actual SCSI hardware seems essentially extinct, lots of devices speak 
dialects of the SCSI protocol, and they still send data packets in that 
format back and forth through the hardware du jour (sometimes even tunneled 
over TCP/IP).  The SCSI layer lets you talk to these devices using that 
protocol.

SCSI doesn't handle device enumeration any more than TCP/IP does, and 
sometimes to do device enumeration you have to look at or talk to the 
underlying hardware, just like you have to dig down to ethernet broadcast 
packets in order to do DHCP.  Unfortunately, the only way to talk to the 
underlying hardware seems to be through the SCSI layer.  I can find "eth0" 
without having a TCP/IP address assigned to it, but I can only list the sata 
devices in the system by going through the list of devices the SCSI layer has 
detected and working backwards...
 
It's entirely possible my metaphor is wrong here, but I'm trying to 
understand...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
