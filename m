From: Rob Landley <rob@landley.net>
Subject: Re: Some quick scsi documentation questions:
Date: Mon, 6 Aug 2007 12:29:30 -0400
Message-ID: <200708061129.31012.rob@landley.net>
References: <200707252328.28981.rob@landley.net> <46B3C36F.8060405@s5r6.in-berlin.de> <46B5FFD9.403@torque.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:48243
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933942AbXHFPgK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2007 11:36:10 -0400
In-Reply-To: <46B5FFD9.403@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sunday 05 August 2007 11:50:33 am Douglas Gilbert wrote:
> Stefan Richter wrote:
> > Rob Landley wrote:
> >> So an sg device is for something like a scanner that doesn't
> >> present a block device?
> >
> > That's what I heard.
>
> The sg driver is a SCSI pass-through while the bsg driver is
> a pass-through the specializes in SCSI and other (usually)
> storage related protocols. Both work at the level of industry
> recognized standard (and draft) protocols.
>
> That approach makes the Linux block layer either a nuisance,
> irrelevant or a complete anachronism (in the case of OSD).

There are non-scsi block devices in the world, you know.

> IMO the linux block layer should be morphed into a library
> of internal queue handling routines. Storage upper level
> drivers such as sd can continue to present the "block"
> view ** of storage devices such as disks.

Ok, so when do embedded flash volumes (non-USB) start getting routed through 
the scsi layer?  Shortly after ramdisks do?

> ** In OO terminology a storage device may have a "block"
>    interface. A storage device is not derived from "block".

I have no idea what that means.

> In practical terms the block layer SG_IO ioctl is still a
> scaled down version of what the corresponding ioctl in
> the sg driver can do.

Is there anything interesting that you _can't_ do through SG_IO that you could 
do through sg?

> The block layer SG_IO ioctl is saddled 
> with whatever strange policy the upper level driver might
> have for that device class (e.g. wait forever if removal media
> is not present). Also the block layer SG_IO ioctl cannot do
> asynchronous IO (either can the bsg driver at the moment).

This sounds like A) an implementation detail, B) a performance hack for 
seldom-used things like low level formats.

> There was a version of Fedora that came out with sg devices
> only available for SCSI devices not already claimed by
> other upper level drivers. It was a surprise to me (Arjan
> may have mentioned it on this list). I got some complaints
> (as if I could do anything). Anyway it was amusing
> to watch how quickly that misstep was reversed. Obviously
> some folks with a lot me influence than me got to the Fedora
> designers who did that.

Fedora is the new name for Red Hat Enterprise Rawhide.  Red Hat figured out 
how Sun made all its money (large corporate and government purchasing 
contracts that cap the profit at the percentage of the cost of materials, so 
people bidding on those contracts spec the most expensive materials they can.  
If they use a $25 copy of Linux they get $2.50 but if they use a $5000 copy 
of Solaris they get $500.  And so they went "hey, if it makes you happy we 
can charge $5000 too" and came out with Red Hat Enterprise, which was so 
lucrative they left everything else behind.) 

These days Fedora listens to money, not to technology.  If somebody like IBM 
says "do X, here's a big check", are they going to turn it down?

> >> There are such things as external SATA enclosures, but
> >> they're A) few and far between,
> >
> > What?  They are all the rage now.  :-)
>
> ATA8-ACS (still draft I think) has provision for a NAA-5
> based UUID. Not sure if any SATA disks are complying
> yet. [I don't think the Seagate ES series ("enterprise")
> did so it will be interesting if their recently announced
> ES.2 series does.]
>
> Yes SATA external enclosures are everywhere. They make more
> sense than USB 2 and marginalize 1394. The problems start
> for SATA when you want to have more than one disk in that
> enclosure. SAS is much better as an interconnect.

My point is that there are something like ten million of laptops produced 
annually and with enclosures you're talking about a technology where the 
entire production run generally doesn't hit six figures in unit volume.  That 
would be "few and far between" in my book.  (Don't get me started on cell 
phones. :)

> >> In 99.x% of systems with SATA hard drives, said drives are sealed inside
> >> the machine, whether it's a laptop or a server.  USB can move around
> >> between boots (or with the power on) as a matter of course, but SATA
> >> really isn't designed for that or expected to do that.
> >
> > I suppose you could still have a not too complicated topology-based
> > naming scheme even with eSATA.
>
> Recent SAS-2 drafts have some heuristic for ATA disks (that
> don't have real UUIDs) that combines the manufacturer, model
> and serial number into a single number for identification
> purposes. With potentially hundreds of SATA disks hanging
> off SAS infrastructure, someone who changed the slot a SATA
> disk was connected to could cause a lot of fun.

But there aren't potentially hundreds of SATA disks hanging off my laptop, and 
my laptop is actually a common case of hardware.  You are penalizing the 
common case in favor of systems that cost more than the salary of the 
full-time professional system administrator assigned to them.

> >> You can reliably enumerate ATA and SATA.
> >
> > You mean, you can reliably enumerate ATA and SATA based on bus topology.
> > Do SATA port multipliers still fit into the picture?
>
> Hopefully they will be chased out of the picture by SAS
> expanders.

If it meant that sata would stop being routed through the scsi layer and could 
thus be reliably enumerated without sacrificing a chicken, I'd be all for it.  
Alas, this doesn't seem likely.

> When a SATA port multiplier is used
>   - the SATA controller and its driver must detect it and
>     know what to do

In which case you should be able to detect the ABSENCE of a port multiplier, 
and reliably enumerate the devices that aren't behind one.

> > All newer SCSI transports are far too complicated for a kernelspace-only
> > implementation.  So in case of such transports, it's not a workaround.
>
> Ah user space device discovery! If only folks wouldn't
> design things so that protocols used to device discovery
> (yes I am talking about the SAS Management Protocol [SMP])
> did _not_ need discovered (or about to be discovered)
> devices already in the kernel's sysfs or dev space.

I worked with SAS for three months before running far, far away from it.  
You'll notice I'm not the one who brought it up.  As far as I can tell, they 
took sata, gold-plated the connectors, spun the platters faster, added an 
incompatable second mode to the firmware that has no actual benefits, added a 
second set of connectors (because the electronics are so much more likely to 
fail than the moving parts), and went "we can charge WAY more for this!"  And 
did.

> I agree with both angles. The linux SCSI/storage subsystem
> should look a lot more like the networking layers. No-one
> tries to enumerate the whole IP space but it may make sense
> to enumerate a small part of it (e.g. MAC addresses in the
> directly attached ethernet subnet).
>
> If any enumeration is required then it should be done by
> user space tools (e.g. udev) interacting with the transport
> concerned. That also implies that SCSI hosts and ATA
> controllers need to be promoted to "first class" devices
> (cf "interfaces" in networking), not hidden as if they were
> some sort of an embarrassment.

I'm all for it.

I'm happy to do enumeration from userspace if I have the information to do so.  
Right now "this is a SATA drive" isn't exposed in sysfs, that I can find.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
