From: Rob Landley <rob@landley.net>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 03:04:00 -0500
Message-ID: <200710150304.00901.rob@landley.net>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015014503.GF9715@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:50793
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbXJOIEG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 04:04:06 -0400
In-Reply-To: <20071015014503.GF9715@thunk.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Sunday 14 October 2007 8:45:03 pm Theodore Tso wrote:
> On Sun, Oct 14, 2007 at 06:45:44PM -0500, Rob Landley wrote:
> > I admit a certain amount of personal annoyance that once the SCSI
> > layer consumes a category of device (USB, SATA, PATA), they can
> > often _only_ be used by going through the SCSI midlayer.  (This
> > strikes me as analogous to TCP/IP claiming ethernet and PPP devices
> > so thoroughly that you can no longer address them as eth1 or
> > /dev/ttyS0.)
>
> That's because modern USB, ATAPI (what was once known as IDE), SATA
> really *all* using the SCSI command protocols at the low level,

Ok, I'll bite.  If it's all "real" scsi, why does ioctl(SG_EMULATED_HOST) 
exist? exist if it's all "real" scsi?

> just 
> as Ethernet and PPP interfaces really are fundamentally the same
> thing.

They're the same thing?

Do you mean that on a system with both, going:
  ifconfig eth1 66.92.53.140
  ifconfig ppp 192.168.0.42

Would be functionally equivalent to:
  ifconfig eth1 192.168.0.42
  ifconfig ppp 66.92.53.140

So if on one boot the addresses are assigned the first way, and upon reboot 
they're assigned in the second way by exact the same set of commands...  well 
that's not IMPORTANT, is it?  (Or is it that everyone everywhere should use 
dhcp for everything, and static addressing is obsolete and no longer 
supported?  Apparently dhcp addresses should be delivered by machines with 
only one network interface of any type...)

This is my objection.  Even when enumerating multiple devices of the same type 
is tricky, enumerating multiple devices of _different_ types should not be.  
There's a great big type indicator that is being _deliberately_ ignored, and 
large classes of devices (millions of laptops) where you know there's only 
going to be _one_ instance of a given type.

By the way, ethernet cards contain a unique MAC address.  Hard drives do not 
seem to, or if they do it's not being consistently exposed in a way I can 
find.  This is sad.  (No, reading data from the device to determine this gets 
us back to the "spinning up the external USB drive to find my root partition" 
gripe mentioned earlier.)

> You can rail against it, but that's the mark of someone who 
> refuses to accept reality.

Let me clarify: I'm talking about device enumeration.

I've never had trouble enumerating a device that was _not_ routed through the 
scsi layer, largely because the systems I work with don't usually have more 
than one device of the same type.  (There are millions of laptop and desktop 
devices out there where this is the common case.  As I said, I may have four 
USB ports and the ability to plug hubs into them, but you can't add another 
SATA hard drive to my laptop without a soldering iron.)

However, as soon as a device _is_ routed through the scsi layer (as PATA was a 
few versions back), it gets conflated with numerous other devices.  This 
creates problems.  SATA isn't hard to enmerate in my laptop, USB potentially 
is.  Dumpting all the SATA devices into the same bucket with the USB devices 
makes both harder to enumerate.

> > This has the annoying effect of bundling together different types of
> > devices and making device enumeration unnecessarily difficult: my
> > laptop only has one SATA hard drive and can't gain another without a
> > soldering iron, but that drive could move from /dev/sda to /dev/sdb
> > if I reboot the system with a USB key plugged in.  This seems like a
> > regrettable loss of orthogonality to me.  I remember back when
> > /dev/usb0 and /dev/hda were separate devices that showed up in /dev,
> > but these days "it's SCSI" seems to trump "it's USB", "it's ATA", or
> > "it's SATA".  (Even though none of those are actually SCSI hardware,
> > they just send a similar packet protocol across the wire.)
>
> You're showing your ignorance here. 

I have buckets of ignorance.  It's why I ask questions.

> In fact in the past few years, 
> ATA and SCSI has been converging significantly,

And down far enough all these devices are powered by electricity.  Are we 
going to wind up with /dev/electric[1-999]?

SATA != PATA != USB.  But /dev/sda can be PATA, /dev/sdb SATA, and /dev/sdc 
USB.  And they can move relative to each other.  This didn't used to be the 
case.  Why is it considered an improvement?

> with the ATAPI 
> specification has essentially incorporating the SCSI protocol by
> reference and by value --- with the point that SAS was developed by
> the SCSI Trade Association, and SAS is effectively a superset of SATA,
> to the point where with care, you can actually mix SAS and SATA drives
> on the same in enclosure (SAS and SATA are physically compatible on
> the connector level).

I'm aware of this, and under the impression they're both modified gigabit 
ethernet at the PHY level.  Should the hard drive become eth2?

> More to the point, with SATA, hot plugging has been designed in, so
> probing order is not going to be well defined,

The spec may define the capability to hotplug, but your average laptop doesn't 
not offer the capability to hotplug anything into its SATA controllers.  The 
hard drive is screwed in (due to the portability part of laptopness), all the 
controllers wired onto the motherboard are accounted for, none are exposed 
externally.  What _is_ exposed externally is USB, and if you want to add an 
extra hard drive you can buy a cheap USB one at Fry's.

In such a case, which is common, the first SATA hard drive is reliably the 
disk containing the root partition, and there's no need to stick a UUID 
in /etc/fstab.

The problem is, "the first SATA hard drive" is not a stable identifier in a 
system where SATA and USB devices are dumped in the same bucket and given a 
big stir.  Dumping SATA and USB devices into the same bucket (because they 
smell a bit like SCSI) is what I am objecting to.

> just as with USB 
> devices.  And there are already relatively common situations where the
> same disk can show up via multiple different interfaces.

It was also possible to buy a hotplug PATA ide enclosure.  So what?  The vast 
majority of traditional IDE users happily ignored this, and went on with 
their lives.

> For example, if you have a modern Thinkpad with an secondary SATA hard
> drive in an Ultrabay, and you plug it into the Ultrabay in your T60,
> it will show up as a SATA drive.

I remember the config option about enumerating onboard IDE controllers first.  
It didn't really matter what order they were enumerated in as long as it was 
controllable.

Presumably if the primary SATA hard drive was /dev/sata and the slot 
with "secondary" in its name got /dev/satb, life would be good.  And the 
presence or absence of /dev/satb wouldn't affect USB devices and such if they 
weren't in the same namespace.

> However, if you plug it into the 
> Advanced dock, it shows up as a USB device.

You plug it in somewhere else, it shows up somewhere else.  This sounds 
familiar to old IDE users. :)

How is it harder for udev to make a stable symlink for this drive that 
sometimes points to /dev/satb and sometimes to /dev/usb1?  (Harder than a 
symlink that sometimes points to /dev/sdb and sometimes to /dev/sdd?  You 
don't have persistent naming _now_, so the objection seems to be that 
maintaining the distinction between device types would not be a perfect 
solution in all cases.  I agree.  So?)

> And with iSCSI not only 
> can you encapsulate a SCSI command stream over USB, you can do so over
> IP as well.

Yup.  And you've been able to make a network block device for years.  They 
showed up as /dev/nd0, a distinct type of block device which you (and your 
scripts) could find.  Now yet another way of doing the same thing is mixed 
into the same scsi bucket and given a stir...

> In any case, regardless of how the physical SATA drive is 
> attached to the system, you want it to show up as the same device and
> be mounted in the same location.

If my laptop's hard drive reliably showed up as /dev/sda every time, and I 
could count on that, I wouldn't be complaining about it.  The entire problem 
is that it isn't guaranteed to do that, and thus /etc/fstab is a nightmare I 
can't edit.

You could meet this definition of "the same" by having every block device in 
the system show up as /dev/block[a-z] no matter what type it was, and all the 
char devices show up as /dev/char[aa-zz], shuffle them all each reboot, and 
then have all the programs iterate through all of them any time they wanted 
something specific.

I'm rather glad that /dev/ttyS0 and /dev/zero aren't easy to mix up.

> That's why identifying filesystem by UUID's or Labels is so critical.
> This is not a new concept; we've had the capability to do this for
> over a decade, and I always knew it would be necessary for us to do
> this sooner or later --- which is why I added the UUID support to ext2
> back in 1996.

It's necessary for IBM big iron to do this.  It's generally not necessary for 
laptops or embedded systems to do this if they distinguish between _types_ of 
devices, which is something they until recently did for the types of devices 
I was interested in, and something they _stopped_ doing when everything got 
merged into the scsi layer, and I consider this a regression.

No, distinguishing between types of devices is not a perfect solution to 
device enumeration, but it was sufficient for all my use cases for many 
years, and would still be if the kernel still did it, and I'm not alone here.

> > The fact that udev can theoretically unwind this hairball is not an
> > excuse for conflating different categories of devices in the first
> > place.
>
> See the thinkpad Ultrabay drive example above.

Last week I drove my laptop so deep into swap (with a "make -j" on qemu) that 
after half an hour trying to repaint my kmail window, it locked solid.  
Again.  You'd think the oom killer would come to the rescue, but it didn't.  
Maybe Ubuntu disabled it.  I have _2_gigs_ of ram in this sucker, on a stock 
Ubuntu 7.04 install (with the "upgrade all" tab pressed a few times), and yet 
I managed to make it swap itself to death one more time.

Virtual memory isn't perfect.  I've _always_ been able to come up with 
examples where it just doesn't work for me.  This doesn't mean VM overcommit 
should be abolished, because it's useful more often than not.

So you have a counterexample.  Ok.  I can't actually see how your 
counterexample would be worse off than it is now; just differently worse off.

> You address hosts by 
> IP address; it doesn't matter whether you access them via a PPP
> interface, or a wireless interface, or a ethernet interface.

It does when I'm configuring the interfaces.

> Similarly, a disk could in theory be accessible over USB, SATA, or
> iSCSI, and the Thinkpad example is only one such where the same
> filesystem might be accessible over multiple interfaces.  And with
> multipath fiber channel SAN's (and I hate to break it to you, but FC
> also uses SCSI protocols) storage is very much looking more and more
> like networking.

And in the networking world I'm able to say that this local machine has a 
static IP that is not world-routable.  It is separate, manually configured, I 
put it _right_here_, and I personally know that it's not going to move 
because I'm the one who put it there and I'm the only one who would move it.

Over on the networking side of things I can "ifconfig lo 127.0.0.1" without 
first probing all the interfaces to figure out which one's loopback and which 
one's the wireless card.

I note that the eth0 and eth1 names are dynamically assigned on a first come 
first serve basis (like scsi).  This never causes me a problem because the 
driver loading order is constant, and once you figure out that eth0 is 
gigabit and eth1 is the 80211g it _stays_ that way across reboots, reliably.  
Yeah, it's a heuristic.  Hands up everybody relying on such a heuristic in 
the real world.

Possibly one solution here is to document that the SATA drivers load before 
any other scsi device, and the driver subsystem _waits_ for that to finish 
enumerating before trying any other kind of scsi device, with a barrier of 
some kind), and then any SATA devices present at boot time will reliably get 
those names in that order (no races, no variation) and anything after that is 
a separate problem.  (Of course this would involve making it true if it 
currently isn't.  It's still a mess to dump all sorts of different devices in 
the same namespace, but at least for the common case of a laptop with a SATA 
root partition this would let us get the UUID out of /etc/fstab).

> 						- Ted

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
