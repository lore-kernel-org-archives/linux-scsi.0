From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Some quick scsi documentation questions:
Date: Sat, 04 Aug 2007 02:08:15 +0200
Message-ID: <46B3C36F.8060405@s5r6.in-berlin.de>
References: <200707252328.28981.rob@landley.net> <200708022055.45523.rob@landley.net> <46B306CD.3030002@s5r6.in-berlin.de> <200708031611.26768.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52619 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762486AbXHDAIk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 20:08:40 -0400
In-Reply-To: <200708031611.26768.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Rob Landley wrote:
> So an sg device is for something like a scanner that doesn't 
> present a block device?

That's what I heard.

>> In case of FireWire drives and several other types of drives (I believe
>> also in case of SATA devices) there is a UUID tied to the *drive* too,
>> alongside UUIDs of the media.
> 
> I can't find it under /sys/block/sda or device under that.  I can find "model" 
> and "vendor", but that's about it.  (I can't even get anything to admit it's 
> sata vs firewire.  The vendor for the hard drive is "ATA" but the vendor for 
> the dvd is "TEAC", and they're both sata devices on the spec sheet...)

# /lib/udev/ata_id /dev/hda
HTE721010G9AT00_MPC0J1Y0GRKYGD
# /lib/udev/ata_id /dev/sda
ST3750640AS_3QD07L23
# /lib/udev/ata_id /dev/hdb
PLEXTOR_DVD-ROM_PX-130A

Not very unique in case of the IDE DVD-ROM.  I don't know if SATA
DVD_ROMs have an actual UUID.

> There are such things as external SATA enclosures, but 
> they're A) few and far between,

What?  They are all the rage now.  :-)

> In 99.x% of systems with SATA hard drives, said drives are sealed inside the 
> machine, whether it's a laptop or a server.  USB can move around between 
> boots (or with the power on) as a matter of course, but SATA really isn't 
> designed for that or expected to do that.

I suppose you could still have a not too complicated topology-based
naming scheme even with eSATA.

...
> As someone who used ATA drives for 10 years before this became a problem, and 
> is now using a SATA drive inside a laptop in a configuration Dell (ok, 
> Quanta) churns out by the millions, I consider it a design flaw in the scsi 
> layer that anything that goes through the scsi layer loses its original 
> identity.
> 
> There have been numerous proposals to compensate for the scsi layer's 
> renumbering with udev rules, but at least two of the most widely used 
> distributions are still doing them wrong, so it's apparently not a trivial 
> problem to recover from.

At least some PPC Linux distributions have had boot-from-FireWire for
some time, even though there are neither deterministic discovery times
nor a fixed bus topology with FireWire.  SATA should be simpler.

...
> You can reliably enumerate ATA and SATA.

You mean, you can reliably enumerate ATA and SATA based on bus topology.
Do SATA port multipliers still fit into the picture?

...
>>> Telling
>>> udev to do something complicated to keep track of a device that I know,
>>> at OS install time, _can't_ever_physically_move_, is one of them.
>> There is a variety of possible naming schemes:
>>
>>   - Naming by order of discovery.
>>   - Naming by vendor/model name strings.
>>   - Naming by universally unique identifier.
>>   - Naming by topology.
>>   - ...
> 
> See "I followed the discussion of all this years ago"...
> 
>> Only the simplest of these schemes (naming by order of discovery) is
>> hardwired into the kernel portion of the Linux OS.
> 
> The issue you're ignoring when you talk about "order of discovery" is that the 
> first Sata drive and the first USB drive are lumped into the same sequence.

No, I'm not ignoring that.  I never stated that naming by order of
discovery would be a particularly useful naming scheme.  For
administration and applications it is of course the least useful naming
scheme.

> The sata drives can't move, but I have an external USB drive that may or may 
> not be plugged in at boot time.  The fact that the presence or absence of a 
> USB drive can change the names assigned to the SATA drives is a loss of 
> orthogonality caused by the SCSI layer.

Only names based on order of discovery change when SATA and USB are
intermingled.  The other names don't change.  (But these other names
have to be put together by userspace.)

A simple workaround for simple configurations is to only load the
low-level drivers (transport and interconnect drivers) in the early boot
phase which are known to be required for the disk with root filesystem.

> I consider this a design flaw, and 
> migrating the ATA drives to do this was a regression.
> 
>> The other naming  
>> schemes are (or can be) implemented in the userland portion of the Linux
>> OS.
> 
> Userland can work around the scsi layer, yes.

All newer SCSI transports are far too complicated for a kernelspace-only
implementation.  So in case of such transports, it's not a workaround.

It may be a workaround in case of ATA and PATA.

>> There is only the most primitive naming scheme implemented in the kernel
>> because naming policy, like most other kinds of policy, is better left
>> to userland.  The kernel is a too restricted framework to implement such
>> things.  The kernel lacks runtime-configuration files, scripting
>> interfaces, et cetera.
> 
> /dev/hdc staying put when you removed or inserted a /dev/hdb was nice.  It 
> worked well for 15 years.
> 
> Not _all_ hardware is hotpluggable, and ignoring this knowledge during device 
> enumeration is silly.

If I understand you correctly, what you desire is to have at least two
naming schemes implemented in the kernel:  Topology-based for those
transports (and interconnects) which have simple topologies (notably ATA
and SATA), and the primitive order-of-discovery-based scheme as fallback
for the rest.  Right?

...
>> K3B doesn't use sysfs for that.  It most certainly uses SG IO (SCSI
>> generic IO) to figure out these names.
> 
> Good to know.  I haven't read far enough through the scsi docs to see how to 
> do that yet.

A pro pos SCSI docs.  I haven't read the full thread.  Did people point
you already to http://www.t10.org/scsi-3.htm?

...
> I currently view the scsi layer as a weird sort of networking stack.  Although 
> actual SCSI hardware seems essentially extinct, lots of devices speak 
> dialects of the SCSI protocol, and they still send data packets in that 
> format back and forth through the hardware du jour (sometimes even tunneled 
> over TCP/IP).  The SCSI layer lets you talk to these devices using that 
> protocol.

See above page.  Also have a look at the SAM-4 spec, figure 2.  The
Linux SCSI stack is not a 1:1 reflection of that architecture, but it
gives an approximate idea of the roles of high-level drivers (sd, sr,
st, sg), the mid-layer (scsi-mod), and low-level drivers (transport
layers and transport libraries, and the numerous interconnect drivers).

(Also scroll a bit further through SAM-4 --- you will see mostly quite
abstract stuff which is this way in order to cover all the various
flavors of SCSI that came into existence.  It's really quite far from
the SCSI of the 1980s.  SCSI actually started to become more diverse
already during the 1990s.)

> SCSI doesn't handle device enumeration any more than TCP/IP does, and 
> sometimes to do device enumeration you have to look at or talk to the 
> underlying hardware, just like you have to dig down to ethernet broadcast 
> packets in order to do DHCP.

These matters are defined in the transport layer of the SCSI
Architecture Model, and implemented in Linux' SCSI low-level drivers.
There are considerable differences in discovery and addressing between
the various transport protocols.  The SCSI core doesn't really play a
role in these matters.

(There are remnants of SPI-specific addressing sprinkled throughout the
SCSI mid-layer's APIs though; something that is seemingly very hard to
get rid of.  SPI = SCSI Parallel Interconnect.)

> Unfortunately, the only way to talk to the 
> underlying hardware seems to be through the SCSI layer.  I can find "eth0" 
> without having a TCP/IP address assigned to it,

But what is "eth0"?  Is it one of the onboard ethernet ports?  Is it an
add-on PCI or CardBus card?  Or is it even an IP-over-FireWire
interface?  (Those too have been named eth* for historical reasons but
now haven't anything to do with Ethernet anymore.)

It's almost the same story with networking interfaces:  The kernel
implements only one of several possible naming policies --- a very
primitive and not very useful one:  There is a prefix like "eth" (there
are a few other prefixes for other types of interfaces but I don't know
which in particular), and then there is a number which is handed out by
the networking core in order of discovery.

> but I can only list the sata 
> devices in the system by going through the list of devices the SCSI layer has 
> detected and working backwards...
>  
> It's entirely possible my metaphor is wrong here, but I'm trying to 
> understand...
> 
> Rob

-- 
Stefan Richter
-=====-=-=== =--- --=--
http://arcgraph.de/sr/
